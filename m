Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1640A7E1137
	for <lists+linux-fscrypt@lfdr.de>; Sat,  4 Nov 2023 22:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjKDVRQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 4 Nov 2023 17:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjKDVRP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 4 Nov 2023 17:17:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EBEBE;
        Sat,  4 Nov 2023 14:17:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187EEC433CA;
        Sat,  4 Nov 2023 21:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699132628;
        bh=O5n+UVp0NsBwPC03GGgaGEnKrMqDeBDGpqdt7V3dNS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CuGDJjOsQyHs3jkGhXzAwjSqnjwFZWJNRPL9bK6qxxQxzT/q5SVh+BivwfFLjJnuA
         QdhZmggww6E3sgclBuoYOrkQiV+Nd/c7ex7fREZHcYzlxIJDNiAV6dl/C+5LDjMyy7
         9QyyddiCWBdwjwTzl9BRxxupcbedUozNOjnMHT0TNCKeri4jNpCHaXNKlpLnGXroTK
         wu00X+K+XzzwoQm7iHE/x9T3ri0dObY8txRVPVyh8hOt+7wBFI2zpaXpFdMhda4vr+
         Wk+eIFvLcqaZOmSg1OFgz0ac3IvlCQS0NlfeDKsBM0XOLSmdzE5cQpRQ7D0kxxQF8A
         X1vVZci0E0Q+g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     kernel-team@android.com, Israel Rukshin <israelr@nvidia.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Peter Griffin <peter.griffin@linaro.org>,
        Daniil Lunev <dlunev@chromium.org>
Subject: [RFC PATCH v8 1/4] blk-crypto: add basic hardware-wrapped key support
Date:   Sat,  4 Nov 2023 14:12:56 -0700
Message-ID: <20231104211259.17448-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231104211259.17448-1-ebiggers@kernel.org>
References: <20231104211259.17448-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

To prevent keys from being compromised if an attacker acquires read
access to kernel memory, some inline encryption hardware can accept keys
which are wrapped by a per-boot hardware-internal key.  This avoids
needing to keep the raw keys in kernel memory, without limiting the
number of keys that can be used.  Such hardware also supports deriving a
"software secret" for cryptographic tasks that can't be handled by
inline encryption; this is needed for fscrypt to work properly.

To support this hardware, allow struct blk_crypto_key to represent a
hardware-wrapped key as an alternative to a standard key, and make
drivers set flags in struct blk_crypto_profile to indicate which types
of keys they support.  Also add the ->derive_sw_secret() low-level
operation, which drivers supporting wrapped keys must implement.

For more information, see the detailed documentation which this patch
adds to Documentation/block/inline-encryption.rst.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/block/inline-encryption.rst | 213 +++++++++++++++++++++-
 block/blk-crypto-fallback.c               |   5 +-
 block/blk-crypto-internal.h               |   1 +
 block/blk-crypto-profile.c                |  46 +++++
 block/blk-crypto.c                        |  51 +++++-
 drivers/md/dm-table.c                     |   1 +
 drivers/mmc/host/cqhci-crypto.c           |   2 +
 drivers/ufs/core/ufshcd-crypto.c          |   1 +
 fs/crypto/inline_crypt.c                  |   4 +-
 include/linux/blk-crypto-profile.h        |  20 ++
 include/linux/blk-crypto.h                |  74 +++++++-
 11 files changed, 394 insertions(+), 24 deletions(-)

diff --git a/Documentation/block/inline-encryption.rst b/Documentation/block/inline-encryption.rst
index 90b733422ed4..07218455a2bc 100644
--- a/Documentation/block/inline-encryption.rst
+++ b/Documentation/block/inline-encryption.rst
@@ -70,24 +70,24 @@ Constraints and notes
   layers to also evict keys from any keyslots they are present in.
 
 - When possible, device-mapper devices must be able to pass through the inline
   encryption support of their underlying devices.  However, it doesn't make
   sense for device-mapper devices to have keyslots themselves.
 
 Basic design
 ============
 
 We introduce ``struct blk_crypto_key`` to represent an inline encryption key and
-how it will be used.  This includes the actual bytes of the key; the size of the
-key; the algorithm and data unit size the key will be used with; and the number
-of bytes needed to represent the maximum data unit number the key will be used
-with.
+how it will be used.  This includes the type of the key (standard or
+hardware-wrapped); the actual bytes of the key; the size of the key; the
+algorithm and data unit size the key will be used with; and the number of bytes
+needed to represent the maximum data unit number the key will be used with.
 
 We introduce ``struct bio_crypt_ctx`` to represent an encryption context.  It
 contains a data unit number and a pointer to a blk_crypto_key.  We add pointers
 to a bio_crypt_ctx to ``struct bio`` and ``struct request``; this allows users
 of the block layer (e.g. filesystems) to provide an encryption context when
 creating a bio and have it be passed down the stack for processing by the block
 layer and device drivers.  Note that the encryption context doesn't explicitly
 say whether to encrypt or decrypt, as that is implicit from the direction of the
 bio; WRITE means encrypt, and READ means decrypt.
 
@@ -294,10 +294,215 @@ if the fallback is used, the device will receive the integrity info of the
 ciphertext, not that of the plaintext).
 
 Because there isn't any real hardware yet, it seems prudent to assume that
 hardware implementations might not implement both features together correctly,
 and disallow the combination for now. Whenever a device supports integrity, the
 kernel will pretend that the device does not support hardware inline encryption
 (by setting the blk_crypto_profile in the request_queue of the device to NULL).
 When the crypto API fallback is enabled, this means that all bios with and
 encryption context will use the fallback, and IO will complete as usual.  When
 the fallback is disabled, a bio with an encryption context will be failed.
+
+.. _hardware_wrapped_keys:
+
+Hardware-wrapped keys
+=====================
+
+Motivation and threat model
+---------------------------
+
+Linux storage encryption (dm-crypt, fscrypt, eCryptfs, etc.) traditionally
+relies on the raw encryption key(s) being present in kernel memory so that the
+encryption can be performed.  This traditionally isn't seen as a problem because
+the key(s) won't be present during an offline attack, which is the main type of
+attack that storage encryption is intended to protect from.
+
+However, there is an increasing desire to also protect users' data from other
+types of attacks (to the extent possible), including:
+
+- Cold boot attacks, where an attacker with physical access to a system suddenly
+  powers it off, then immediately dumps the system memory to extract recently
+  in-use encryption keys, then uses these keys to decrypt user data on-disk.
+
+- Online attacks where the attacker is able to read kernel memory without fully
+  compromising the system, followed by an offline attack where any extracted
+  keys can be used to decrypt user data on-disk.  An example of such an online
+  attack would be if the attacker is able to run some code on the system that
+  exploits a Meltdown-like vulnerability but is unable to escalate privileges.
+
+- Online attacks where the attacker fully compromises the system, but their data
+  exfiltration is significantly time-limited and/or bandwidth-limited, so in
+  order to completely exfiltrate the data they need to extract the encryption
+  keys to use in a later offline attack.
+
+Hardware-wrapped keys are a feature of inline encryption hardware that is
+designed to protect users' data from the above attacks (to the extent possible),
+without introducing limitations such as a maximum number of keys.
+
+Note that it is impossible to **fully** protect users' data from these attacks.
+Even in the attacks where the attacker "just" gets read access to kernel memory,
+they can still extract any user data that is present in memory, including
+plaintext pagecache pages of encrypted files.  The focus here is just on
+protecting the encryption keys, as those instantly give access to **all** user
+data in any following offline attack, rather than just some of it (where which
+data is included in that "some" might not be controlled by the attacker).
+
+Solution overview
+-----------------
+
+Inline encryption hardware typically has "keyslots" into which software can
+program keys for the hardware to use; the contents of keyslots typically can't
+be read back by software.  As such, the above security goals could be achieved
+if the kernel simply erased its copy of the key(s) after programming them into
+keyslot(s) and thereafter only referred to them via keyslot number.
+
+However, that naive approach runs into the problem that it limits the number of
+unlocked keys to the number of keyslots, which typically is a small number.  In
+cases where there is only one encryption key system-wide (e.g., a full-disk
+encryption key), that can be tolerable.  However, in general there can be many
+logged-in users with many different keys, and/or many running applications with
+application-specific encrypted storage areas.  This is especially true if
+file-based encryption (e.g. fscrypt) is being used.
+
+Thus, it is important for the kernel to still have a way to "remind" the
+hardware about a key, without actually having the raw key itself.  This would
+ensure that the number of hardware keyslots only limits the number of active I/O
+requests, not other things such as the number of logged-in users, the number of
+running apps, or the number of encrypted storage areas that apps can create.
+
+Somewhat less importantly, it is also desirable that the raw keys are never
+visible to software at all, even while being initially unlocked.  This would
+ensure that a read-only compromise of system memory will never allow a key to be
+extracted to be used off-system, even if it occurs when a key is being unlocked.
+
+To solve all these problems, some vendors of inline encryption hardware have
+made their hardware support *hardware-wrapped keys*.  Hardware-wrapped keys
+are encrypted keys that can only be unwrapped (decrypted) and used by hardware
+-- either by the inline encryption hardware itself, or by a dedicated hardware
+block that can directly provision keys to the inline encryption hardware.
+
+(We refer to them as "hardware-wrapped keys" rather than simply "wrapped keys"
+to add some clarity in cases where there could be other types of wrapped keys,
+such as in file-based encryption.  Key wrapping is a commonly used technique.)
+
+The key which wraps (encrypts) hardware-wrapped keys is a hardware-internal key
+that is never exposed to software; it is either a persistent key (a "long-term
+wrapping key") or a per-boot key (an "ephemeral wrapping key").  The long-term
+wrapped form of the key is what is initially unlocked, but it is erased from
+memory as soon as it is converted into an ephemerally-wrapped key.  In-use
+hardware-wrapped keys are always ephemerally-wrapped, not long-term wrapped.
+
+As inline encryption hardware can only be used to encrypt/decrypt data on-disk,
+the hardware also includes a level of indirection; it doesn't use the unwrapped
+key directly for inline encryption, but rather derives both an inline encryption
+key and a "software secret" from it.  Software can use the "software secret" for
+tasks that can't use the inline encryption hardware, such as filenames
+encryption.  The software secret is not protected from memory compromise.
+
+Key hierarchy
+-------------
+
+Here is the key hierarchy for a hardware-wrapped key::
+
+                       Hardware-wrapped key
+                                |
+                                |
+                          <Hardware KDF>
+                                |
+                  -----------------------------
+                  |                           |
+        Inline encryption key           Software secret
+
+The components are:
+
+- *Hardware-wrapped key*: a key for the hardware's KDF (Key Derivation
+  Function), in ephemerally-wrapped form.  The key wrapping algorithm is a
+  hardware implementation detail that doesn't impact kernel operation, but a
+  strong authenticated encryption algorithm such as AES-256-GCM is recommended.
+
+- *Hardware KDF*: a KDF (Key Derivation Function) which the hardware uses to
+  derive subkeys after unwrapping the wrapped key.  The hardware's choice of KDF
+  doesn't impact kernel operation, but it does need to be known for testing
+  purposes, and it's also assumed to have at least a 256-bit security strength.
+  All known hardware uses the SP800-108 KDF in Counter Mode with AES-256-CMAC,
+  with a particular choice of labels and contexts; new hardware should use this
+  already-vetted KDF.
+
+- *Inline encryption key*: a derived key which the hardware directly provisions
+  to a keyslot of the inline encryption hardware, without exposing it to
+  software.  In all known hardware, this will always be an AES-256-XTS key.
+  However, in principle other encryption algorithms could be supported too.
+  Hardware must derive distinct subkeys for each supported encryption algorithm.
+
+- *Software secret*: a derived key which the hardware returns to software so
+  that software can use it for cryptographic tasks that can't use inline
+  encryption.  This value is cryptographically isolated from the inline
+  encryption key, i.e. knowing one doesn't reveal the other.  (The KDF ensures
+  this.)  Currently, the software secret is always 32 bytes and thus is suitable
+  for cryptographic applications that require up to a 256-bit security strength.
+  Some use cases (e.g. full-disk encryption) won't require the software secret.
+
+Example: in the case of fscrypt, the fscrypt master key (the key that protects a
+particular set of encrypted directories) is made hardware-wrapped.  The inline
+encryption key is used as the file contents encryption key, while the software
+secret (rather than the master key directly) is used to key fscrypt's KDF
+(HKDF-SHA512) to derive other subkeys such as filenames encryption keys.
+
+Note that currently this design assumes a single inline encryption key per
+hardware-wrapped key, without any further key derivation.  Thus, in the case of
+fscrypt, currently hardware-wrapped keys are only compatible with the "inline
+encryption optimized" settings, which use one file contents encryption key per
+encryption policy rather than one per file.  This design could be extended to
+make the hardware derive per-file keys using per-file nonces passed down the
+storage stack, and in fact some hardware already supports this; future work is
+planned to remove this limitation by adding the corresponding kernel support.
+
+Kernel support
+--------------
+
+The inline encryption support of the kernel's block layer ("blk-crypto") has
+been extended to support hardware-wrapped keys as an alternative to standard
+keys, when hardware support is available.  This works in the following way:
+
+- A ``key_types_supported`` field is added to the crypto capabilities in
+  ``struct blk_crypto_profile``.  This allows device drivers to declare that
+  they support standard keys, hardware-wrapped keys, or both.
+
+- ``struct blk_crypto_key`` can now contain a hardware-wrapped key as an
+  alternative to a standard key; a ``key_type`` field is added to
+  ``struct blk_crypto_config`` to distinguish between the different key types.
+  This allows users of blk-crypto to en/decrypt data using a hardware-wrapped
+  key in a way very similar to using a standard key.
+
+- A new method ``blk_crypto_ll_ops::derive_sw_secret`` is added.  Device drivers
+  that support hardware-wrapped keys must implement this method.  Users of
+  blk-crypto can call ``blk_crypto_derive_sw_secret()`` to access this method.
+
+- The programming and eviction of hardware-wrapped keys happens via
+  ``blk_crypto_ll_ops::keyslot_program`` and
+  ``blk_crypto_ll_ops::keyslot_evict``, just like it does for standard keys.  If
+  a driver supports hardware-wrapped keys, then it must handle hardware-wrapped
+  keys being passed to these methods.
+
+blk-crypto-fallback doesn't support hardware-wrapped keys.  Therefore,
+hardware-wrapped keys can only be used with actual inline encryption hardware.
+
+Testability
+-----------
+
+Both the hardware KDF and the inline encryption itself are well-defined
+algorithms that don't depend on any secrets other than the unwrapped key.
+Therefore, if the unwrapped key is known to software, these algorithms can be
+reproduced in software in order to verify the ciphertext that is written to disk
+by the inline encryption hardware.
+
+However, the unwrapped key will only be known to software for testing if the
+"import" functionality is used.  Proper testing is not possible in the
+"generate" case where the hardware generates the key itself.  The correct
+operation of the "generate" mode thus relies on the security and correctness of
+the hardware RNG and its use to generate the key, as well as the testing of the
+"import" mode as that should cover all parts other than the key generation.
+
+For an example of a test that verifies the ciphertext written to disk in the
+"import" mode, see the fscrypt hardware-wrapped key tests in xfstests, or
+`Android's vts_kernel_encryption_test
+<https://android.googlesource.com/platform/test/vts-testcase/kernel/+/refs/heads/master/encryption/>`_.
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index e6468eab2681..6bce8b5d138c 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -80,21 +80,21 @@ static struct blk_crypto_fallback_keyslot {
 
 static struct blk_crypto_profile *blk_crypto_fallback_profile;
 static struct workqueue_struct *blk_crypto_wq;
 static mempool_t *blk_crypto_bounce_page_pool;
 static struct bio_set crypto_bio_split;
 
 /*
  * This is the key we set when evicting a keyslot. This *should* be the all 0's
  * key, but AES-XTS rejects that key, so we use some random bytes instead.
  */
-static u8 blank_key[BLK_CRYPTO_MAX_KEY_SIZE];
+static u8 blank_key[BLK_CRYPTO_MAX_STANDARD_KEY_SIZE];
 
 static void blk_crypto_fallback_evict_keyslot(unsigned int slot)
 {
 	struct blk_crypto_fallback_keyslot *slotp = &blk_crypto_keyslots[slot];
 	enum blk_crypto_mode_num crypto_mode = slotp->crypto_mode;
 	int err;
 
 	WARN_ON(slotp->crypto_mode == BLK_ENCRYPTION_MODE_INVALID);
 
 	/* Clear the key in the skcipher */
@@ -531,21 +531,21 @@ int blk_crypto_fallback_evict_key(const struct blk_crypto_key *key)
 
 static bool blk_crypto_fallback_inited;
 static int blk_crypto_fallback_init(void)
 {
 	int i;
 	int err;
 
 	if (blk_crypto_fallback_inited)
 		return 0;
 
-	get_random_bytes(blank_key, BLK_CRYPTO_MAX_KEY_SIZE);
+	get_random_bytes(blank_key, sizeof(blank_key));
 
 	err = bioset_init(&crypto_bio_split, 64, 0, 0);
 	if (err)
 		goto out;
 
 	/* Dynamic allocation is needed because of lockdep_register_key(). */
 	blk_crypto_fallback_profile =
 		kzalloc(sizeof(*blk_crypto_fallback_profile), GFP_KERNEL);
 	if (!blk_crypto_fallback_profile) {
 		err = -ENOMEM;
@@ -553,20 +553,21 @@ static int blk_crypto_fallback_init(void)
 	}
 
 	err = blk_crypto_profile_init(blk_crypto_fallback_profile,
 				      blk_crypto_num_keyslots);
 	if (err)
 		goto fail_free_profile;
 	err = -ENOMEM;
 
 	blk_crypto_fallback_profile->ll_ops = blk_crypto_fallback_ll_ops;
 	blk_crypto_fallback_profile->max_dun_bytes_supported = BLK_CRYPTO_MAX_IV_SIZE;
+	blk_crypto_fallback_profile->key_types_supported = BLK_CRYPTO_KEY_TYPE_STANDARD;
 
 	/* All blk-crypto modes have a crypto API fallback. */
 	for (i = 0; i < BLK_ENCRYPTION_MODE_MAX; i++)
 		blk_crypto_fallback_profile->modes_supported[i] = 0xFFFFFFFF;
 	blk_crypto_fallback_profile->modes_supported[BLK_ENCRYPTION_MODE_INVALID] = 0;
 
 	blk_crypto_wq = alloc_workqueue("blk_crypto_wq",
 					WQ_UNBOUND | WQ_HIGHPRI |
 					WQ_MEM_RECLAIM, num_online_cpus());
 	if (!blk_crypto_wq)
diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index 93a141979694..1893df9a8f06 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -7,20 +7,21 @@
 #define __LINUX_BLK_CRYPTO_INTERNAL_H
 
 #include <linux/bio.h>
 #include <linux/blk-mq.h>
 
 /* Represents a crypto mode supported by blk-crypto  */
 struct blk_crypto_mode {
 	const char *name; /* name of this mode, shown in sysfs */
 	const char *cipher_str; /* crypto API name (for fallback case) */
 	unsigned int keysize; /* key size in bytes */
+	unsigned int security_strength; /* security strength in bytes */
 	unsigned int ivsize; /* iv size in bytes */
 };
 
 extern const struct blk_crypto_mode blk_crypto_modes[];
 
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 
 int blk_crypto_sysfs_register(struct gendisk *disk);
 
 void blk_crypto_sysfs_unregister(struct gendisk *disk);
diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 7fabc883e39f..1b92276ed2fc 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -345,20 +345,22 @@ void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot)
  */
 bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
 				const struct blk_crypto_config *cfg)
 {
 	if (!profile)
 		return false;
 	if (!(profile->modes_supported[cfg->crypto_mode] & cfg->data_unit_size))
 		return false;
 	if (profile->max_dun_bytes_supported < cfg->dun_bytes)
 		return false;
+	if (!(profile->key_types_supported & cfg->key_type))
+		return false;
 	return true;
 }
 
 /*
  * This is an internal function that evicts a key from an inline encryption
  * device that can be either a real device or the blk-crypto-fallback "device".
  * It is used only by blk_crypto_evict_key(); see that function for details.
  */
 int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
 			   const struct blk_crypto_key *key)
@@ -455,20 +457,58 @@ bool blk_crypto_register(struct blk_crypto_profile *profile,
 {
 	if (blk_integrity_queue_supports_integrity(q)) {
 		pr_warn("Integrity and hardware inline encryption are not supported together. Disabling hardware inline encryption.\n");
 		return false;
 	}
 	q->crypto_profile = profile;
 	return true;
 }
 EXPORT_SYMBOL_GPL(blk_crypto_register);
 
+/**
+ * blk_crypto_derive_sw_secret() - Derive software secret from wrapped key
+ * @bdev: a block device that supports hardware-wrapped keys
+ * @eph_key: the hardware-wrapped key in ephemerally-wrapped form
+ * @eph_key_size: size of @eph_key in bytes
+ * @sw_secret: (output) the software secret
+ *
+ * Given a hardware-wrapped key in ephemerally-wrapped form (the same form that
+ * it is used for I/O), ask the hardware to derive the secret which software can
+ * use for cryptographic tasks other than inline encryption.  This secret is
+ * guaranteed to be cryptographically isolated from the inline encryption key,
+ * i.e. derived with a different KDF context.
+ *
+ * Return: 0 on success, -EOPNOTSUPP if the block device doesn't support
+ *	   hardware-wrapped keys, -EBADMSG if the key isn't a valid
+ *	   hardware-wrapped key, or another -errno code.
+ */
+int blk_crypto_derive_sw_secret(struct block_device *bdev,
+				const u8 *eph_key, size_t eph_key_size,
+				u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	struct blk_crypto_profile *profile =
+		bdev_get_queue(bdev)->crypto_profile;
+	int err;
+
+	if (!profile)
+		return -EOPNOTSUPP;
+	if (!(profile->key_types_supported & BLK_CRYPTO_KEY_TYPE_HW_WRAPPED))
+		return -EOPNOTSUPP;
+	if (!profile->ll_ops.derive_sw_secret)
+		return -EOPNOTSUPP;
+	blk_crypto_hw_enter(profile);
+	err = profile->ll_ops.derive_sw_secret(profile, eph_key, eph_key_size,
+					       sw_secret);
+	blk_crypto_hw_exit(profile);
+	return err;
+}
+
 /**
  * blk_crypto_intersect_capabilities() - restrict supported crypto capabilities
  *					 by child device
  * @parent: the crypto profile for the parent device
  * @child: the crypto profile for the child device, or NULL
  *
  * This clears all crypto capabilities in @parent that aren't set in @child.  If
  * @child is NULL, then this clears all parent capabilities.
  *
  * Only use this when setting up the crypto profile for a layered device, before
@@ -478,24 +518,26 @@ void blk_crypto_intersect_capabilities(struct blk_crypto_profile *parent,
 				       const struct blk_crypto_profile *child)
 {
 	if (child) {
 		unsigned int i;
 
 		parent->max_dun_bytes_supported =
 			min(parent->max_dun_bytes_supported,
 			    child->max_dun_bytes_supported);
 		for (i = 0; i < ARRAY_SIZE(child->modes_supported); i++)
 			parent->modes_supported[i] &= child->modes_supported[i];
+		parent->key_types_supported &= child->key_types_supported;
 	} else {
 		parent->max_dun_bytes_supported = 0;
 		memset(parent->modes_supported, 0,
 		       sizeof(parent->modes_supported));
+		parent->key_types_supported = 0;
 	}
 }
 EXPORT_SYMBOL_GPL(blk_crypto_intersect_capabilities);
 
 /**
  * blk_crypto_has_capabilities() - Check whether @target supports at least all
  *				   the crypto capabilities that @reference does.
  * @target: the target profile
  * @reference: the reference profile
  *
@@ -514,20 +556,23 @@ bool blk_crypto_has_capabilities(const struct blk_crypto_profile *target,
 
 	for (i = 0; i < ARRAY_SIZE(target->modes_supported); i++) {
 		if (reference->modes_supported[i] & ~target->modes_supported[i])
 			return false;
 	}
 
 	if (reference->max_dun_bytes_supported >
 	    target->max_dun_bytes_supported)
 		return false;
 
+	if (reference->key_types_supported & ~target->key_types_supported)
+		return false;
+
 	return true;
 }
 EXPORT_SYMBOL_GPL(blk_crypto_has_capabilities);
 
 /**
  * blk_crypto_update_capabilities() - Update the capabilities of a crypto
  *				      profile to match those of another crypto
  *				      profile.
  * @dst: The crypto profile whose capabilities to update.
  * @src: The crypto profile whose capabilities this function will update @dst's
@@ -548,12 +593,13 @@ EXPORT_SYMBOL_GPL(blk_crypto_has_capabilities);
  * might result in blk-crypto-fallback being used if available, or the bio being
  * failed).
  */
 void blk_crypto_update_capabilities(struct blk_crypto_profile *dst,
 				    const struct blk_crypto_profile *src)
 {
 	memcpy(dst->modes_supported, src->modes_supported,
 	       sizeof(dst->modes_supported));
 
 	dst->max_dun_bytes_supported = src->max_dun_bytes_supported;
+	dst->key_types_supported = src->key_types_supported;
 }
 EXPORT_SYMBOL_GPL(blk_crypto_update_capabilities);
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 4d760b092deb..5a09d0ef1a01 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -16,38 +16,42 @@
 #include <linux/ratelimit.h>
 #include <linux/slab.h>
 
 #include "blk-crypto-internal.h"
 
 const struct blk_crypto_mode blk_crypto_modes[] = {
 	[BLK_ENCRYPTION_MODE_AES_256_XTS] = {
 		.name = "AES-256-XTS",
 		.cipher_str = "xts(aes)",
 		.keysize = 64,
+		.security_strength = 32,
 		.ivsize = 16,
 	},
 	[BLK_ENCRYPTION_MODE_AES_128_CBC_ESSIV] = {
 		.name = "AES-128-CBC-ESSIV",
 		.cipher_str = "essiv(cbc(aes),sha256)",
 		.keysize = 16,
+		.security_strength = 16,
 		.ivsize = 16,
 	},
 	[BLK_ENCRYPTION_MODE_ADIANTUM] = {
 		.name = "Adiantum",
 		.cipher_str = "adiantum(xchacha12,aes)",
 		.keysize = 32,
+		.security_strength = 32,
 		.ivsize = 32,
 	},
 	[BLK_ENCRYPTION_MODE_SM4_XTS] = {
 		.name = "SM4-XTS",
 		.cipher_str = "xts(sm4)",
 		.keysize = 32,
+		.security_strength = 16,
 		.ivsize = 16,
 	},
 };
 
 /*
  * This number needs to be at least (the number of threads doing IO
  * concurrently) * (maximum recursive depth of a bio), so that we don't
  * deadlock on crypt_ctx allocations. The default is chosen to be the same
  * as the default number of post read contexts in both EXT4 and F2FS.
  */
@@ -69,23 +73,29 @@ static int __init bio_crypt_ctx_init(void)
 		goto out_no_mem;
 
 	bio_crypt_ctx_pool = mempool_create_slab_pool(num_prealloc_crypt_ctxs,
 						      bio_crypt_ctx_cache);
 	if (!bio_crypt_ctx_pool)
 		goto out_no_mem;
 
 	/* This is assumed in various places. */
 	BUILD_BUG_ON(BLK_ENCRYPTION_MODE_INVALID != 0);
 
-	/* Sanity check that no algorithm exceeds the defined limits. */
+	/*
+	 * Validate the crypto mode properties.  This ideally would be done with
+	 * static assertions, but boot-time checks are the next best thing.
+	 */
 	for (i = 0; i < BLK_ENCRYPTION_MODE_MAX; i++) {
-		BUG_ON(blk_crypto_modes[i].keysize > BLK_CRYPTO_MAX_KEY_SIZE);
+		BUG_ON(blk_crypto_modes[i].keysize >
+		       BLK_CRYPTO_MAX_STANDARD_KEY_SIZE);
+		BUG_ON(blk_crypto_modes[i].security_strength >
+		       blk_crypto_modes[i].keysize);
 		BUG_ON(blk_crypto_modes[i].ivsize > BLK_CRYPTO_MAX_IV_SIZE);
 	}
 
 	return 0;
 out_no_mem:
 	panic("Failed to allocate mem for bio crypt ctxs\n");
 }
 subsys_initcall(bio_crypt_ctx_init);
 
 void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
@@ -308,79 +318,96 @@ int __blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
 		if (!rq->crypt_ctx)
 			return -ENOMEM;
 	}
 	*rq->crypt_ctx = *bio->bi_crypt_context;
 	return 0;
 }
 
 /**
  * blk_crypto_init_key() - Prepare a key for use with blk-crypto
  * @blk_key: Pointer to the blk_crypto_key to initialize.
- * @raw_key: Pointer to the raw key. Must be the correct length for the chosen
- *	     @crypto_mode; see blk_crypto_modes[].
+ * @raw_key: the raw bytes of the key
+ * @raw_key_size: size of the raw key in bytes
+ * @key_type: type of the key -- either standard or hardware-wrapped
  * @crypto_mode: identifier for the encryption algorithm to use
  * @dun_bytes: number of bytes that will be used to specify the DUN when this
  *	       key is used
  * @data_unit_size: the data unit size to use for en/decryption
  *
  * Return: 0 on success, -errno on failure.  The caller is responsible for
  *	   zeroizing both blk_key and raw_key when done with them.
  */
-int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
+int blk_crypto_init_key(struct blk_crypto_key *blk_key,
+			const u8 *raw_key, size_t raw_key_size,
+			enum blk_crypto_key_type key_type,
 			enum blk_crypto_mode_num crypto_mode,
 			unsigned int dun_bytes,
 			unsigned int data_unit_size)
 {
 	const struct blk_crypto_mode *mode;
 
 	memset(blk_key, 0, sizeof(*blk_key));
 
 	if (crypto_mode >= ARRAY_SIZE(blk_crypto_modes))
 		return -EINVAL;
 
 	mode = &blk_crypto_modes[crypto_mode];
-	if (mode->keysize == 0)
+	switch (key_type) {
+	case BLK_CRYPTO_KEY_TYPE_STANDARD:
+		if (raw_key_size != mode->keysize)
+			return -EINVAL;
+		break;
+	case BLK_CRYPTO_KEY_TYPE_HW_WRAPPED:
+		if (raw_key_size < mode->security_strength ||
+		    raw_key_size > BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE)
+			return -EINVAL;
+		break;
+	default:
 		return -EINVAL;
+	}
 
 	if (dun_bytes == 0 || dun_bytes > mode->ivsize)
 		return -EINVAL;
 
 	if (!is_power_of_2(data_unit_size))
 		return -EINVAL;
 
 	blk_key->crypto_cfg.crypto_mode = crypto_mode;
 	blk_key->crypto_cfg.dun_bytes = dun_bytes;
 	blk_key->crypto_cfg.data_unit_size = data_unit_size;
+	blk_key->crypto_cfg.key_type = key_type;
 	blk_key->data_unit_size_bits = ilog2(data_unit_size);
-	blk_key->size = mode->keysize;
-	memcpy(blk_key->raw, raw_key, mode->keysize);
+	blk_key->size = raw_key_size;
+	memcpy(blk_key->raw, raw_key, raw_key_size);
 
 	return 0;
 }
 
 bool blk_crypto_config_supported_natively(struct block_device *bdev,
 					  const struct blk_crypto_config *cfg)
 {
 	return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
 					  cfg);
 }
 
 /*
  * Check if bios with @cfg can be en/decrypted by blk-crypto (i.e. either the
  * block_device it's submitted to supports inline crypto, or the
  * blk-crypto-fallback is enabled and supports the cfg).
  */
 bool blk_crypto_config_supported(struct block_device *bdev,
 				 const struct blk_crypto_config *cfg)
 {
-	return IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-	       blk_crypto_config_supported_natively(bdev, cfg);
+	if (IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) &&
+	    cfg->key_type == BLK_CRYPTO_KEY_TYPE_STANDARD)
+		return true;
+	return blk_crypto_config_supported_natively(bdev, cfg);
 }
 
 /**
  * blk_crypto_start_using_key() - Start using a blk_crypto_key on a device
  * @bdev: block device to operate on
  * @key: A key to use on the device
  *
  * Upper layers must call this function to ensure that either the hardware
  * supports the key's crypto settings, or the crypto API fallback has transforms
  * for the needed mode allocated and ready to go. This function may allocate
@@ -389,20 +416,24 @@ bool blk_crypto_config_supported(struct block_device *bdev,
  *
  * Return: 0 on success; -ENOPKG if the hardware doesn't support the key and
  *	   blk-crypto-fallback is either disabled or the needed algorithm
  *	   is disabled in the crypto API; or another -errno code.
  */
 int blk_crypto_start_using_key(struct block_device *bdev,
 			       const struct blk_crypto_key *key)
 {
 	if (blk_crypto_config_supported_natively(bdev, &key->crypto_cfg))
 		return 0;
+	if (key->crypto_cfg.key_type != BLK_CRYPTO_KEY_TYPE_STANDARD) {
+		pr_warn_once("tried to use wrapped key, but hardware doesn't support it\n");
+		return -EOPNOTSUPP;
+	}
 	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
 }
 
 /**
  * blk_crypto_evict_key() - Evict a blk_crypto_key from a block_device
  * @bdev: a block_device on which I/O using the key may have been done
  * @key: the key to evict
  *
  * For a given block_device, this function removes the given blk_crypto_key from
  * the keyslot management structures and evicts it from any underlying hardware
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 198d38b53322..2137e4e284f3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1303,20 +1303,21 @@ static int dm_table_construct_crypto_profile(struct dm_table *t)
 	if (!dmcp)
 		return -ENOMEM;
 	dmcp->md = t->md;
 
 	profile = &dmcp->profile;
 	blk_crypto_profile_init(profile, 0);
 	profile->ll_ops.keyslot_evict = dm_keyslot_evict;
 	profile->max_dun_bytes_supported = UINT_MAX;
 	memset(profile->modes_supported, 0xFF,
 	       sizeof(profile->modes_supported));
+	profile->key_types_supported = ~0;
 
 	for (i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(t, i);
 
 		if (!dm_target_passes_crypto(ti->type)) {
 			blk_crypto_intersect_capabilities(profile, NULL);
 			break;
 		}
 		if (!ti->type->iterate_devices)
 			continue;
diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
index d5f4b6972f63..6652982410ec 100644
--- a/drivers/mmc/host/cqhci-crypto.c
+++ b/drivers/mmc/host/cqhci-crypto.c
@@ -203,20 +203,22 @@ int cqhci_crypto_init(struct cqhci_host *cq_host)
 	err = devm_blk_crypto_profile_init(dev, profile, num_keyslots);
 	if (err)
 		goto out;
 
 	profile->ll_ops = cqhci_crypto_ops;
 	profile->dev = dev;
 
 	/* Unfortunately, CQHCI crypto only supports 32 DUN bits. */
 	profile->max_dun_bytes_supported = 4;
 
+	profile->key_types_supported = BLK_CRYPTO_KEY_TYPE_STANDARD;
+
 	/*
 	 * Cache all the crypto capabilities and advertise the supported crypto
 	 * modes and data unit sizes to the block layer.
 	 */
 	for (cap_idx = 0; cap_idx < cq_host->crypto_capabilities.num_crypto_cap;
 	     cap_idx++) {
 		cq_host->crypto_cap_array[cap_idx].reg_val =
 			cpu_to_le32(cqhci_readl(cq_host,
 						CQHCI_CRYPTOCAP +
 						cap_idx * sizeof(__le32)));
diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index f2c4422cab86..f4cc54d82281 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -183,20 +183,21 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 	/* The actual number of configurations supported is (CFGC+1) */
 	err = devm_blk_crypto_profile_init(
 			hba->dev, &hba->crypto_profile,
 			hba->crypto_capabilities.config_count + 1);
 	if (err)
 		goto out;
 
 	hba->crypto_profile.ll_ops = ufshcd_crypto_ops;
 	/* UFS only supports 8 bytes for any DUN */
 	hba->crypto_profile.max_dun_bytes_supported = 8;
+	hba->crypto_profile.key_types_supported = BLK_CRYPTO_KEY_TYPE_STANDARD;
 	hba->crypto_profile.dev = hba->dev;
 
 	/*
 	 * Cache all the UFS crypto capabilities and advertise the supported
 	 * crypto modes and data unit sizes to the block layer.
 	 */
 	for (cap_idx = 0; cap_idx < hba->crypto_capabilities.num_crypto_cap;
 	     cap_idx++) {
 		hba->crypto_cap_array[cap_idx].reg_val =
 			cpu_to_le32(ufshcd_readl(hba,
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index b4002aea7cdb..821a800c9a89 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -123,20 +123,21 @@ int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci)
 	    sb->s_blocksize != PAGE_SIZE)
 		return 0;
 
 	/*
 	 * On all the filesystem's block devices, blk-crypto must support the
 	 * crypto configuration that the file would use.
 	 */
 	crypto_cfg.crypto_mode = ci->ci_mode->blk_crypto_mode;
 	crypto_cfg.data_unit_size = 1U << ci->ci_data_unit_bits;
 	crypto_cfg.dun_bytes = fscrypt_get_dun_bytes(ci);
+	crypto_cfg.key_type = BLK_CRYPTO_KEY_TYPE_STANDARD;
 
 	devs = fscrypt_get_devices(sb, &num_devs);
 	if (IS_ERR(devs))
 		return PTR_ERR(devs);
 
 	for (i = 0; i < num_devs; i++) {
 		if (!blk_crypto_config_supported(devs[i], &crypto_cfg))
 			goto out_free_devs;
 	}
 
@@ -159,21 +160,22 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 	struct blk_crypto_key *blk_key;
 	struct block_device **devs;
 	unsigned int num_devs;
 	unsigned int i;
 	int err;
 
 	blk_key = kmalloc(sizeof(*blk_key), GFP_KERNEL);
 	if (!blk_key)
 		return -ENOMEM;
 
-	err = blk_crypto_init_key(blk_key, raw_key, crypto_mode,
+	err = blk_crypto_init_key(blk_key, raw_key, ci->ci_mode->keysize,
+				  BLK_CRYPTO_KEY_TYPE_STANDARD, crypto_mode,
 				  fscrypt_get_dun_bytes(ci),
 				  1U << ci->ci_data_unit_bits);
 	if (err) {
 		fscrypt_err(inode, "error %d initializing blk-crypto key", err);
 		goto fail;
 	}
 
 	/* Start using blk-crypto on all the filesystem's block devices. */
 	devs = fscrypt_get_devices(sb, &num_devs);
 	if (IS_ERR(devs)) {
diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
index 90ab33cb5d0e..229287a7f451 100644
--- a/include/linux/blk-crypto-profile.h
+++ b/include/linux/blk-crypto-profile.h
@@ -50,20 +50,34 @@ struct blk_crypto_ll_ops {
 	 * @key from any underlying devices.  @slot won't be valid in this case.
 	 *
 	 * If there are no keyslots and no underlying devices, this function
 	 * isn't required.
 	 *
 	 * Must return 0 on success, or -errno on failure.
 	 */
 	int (*keyslot_evict)(struct blk_crypto_profile *profile,
 			     const struct blk_crypto_key *key,
 			     unsigned int slot);
+
+	/**
+	 * @derive_sw_secret: Derive the software secret from a hardware-wrapped
+	 *		      key in ephemerally-wrapped form.
+	 *
+	 * This only needs to be implemented if BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
+	 * is supported.
+	 *
+	 * Must return 0 on success, -EBADMSG if the key is invalid, or another
+	 * -errno code on other errors.
+	 */
+	int (*derive_sw_secret)(struct blk_crypto_profile *profile,
+				const u8 *eph_key, size_t eph_key_size,
+				u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
 };
 
 /**
  * struct blk_crypto_profile - inline encryption profile for a device
  *
  * This struct contains a storage device's inline encryption capabilities (e.g.
  * the supported crypto algorithms), driver-provided functions to control the
  * inline encryption hardware (e.g. programming and evicting keys), and optional
  * device-independent keyslot management data.
  */
@@ -77,20 +91,26 @@ struct blk_crypto_profile {
 	 */
 	struct blk_crypto_ll_ops ll_ops;
 
 	/**
 	 * @max_dun_bytes_supported: The maximum number of bytes supported for
 	 * specifying the data unit number (DUN).  Specifically, the range of
 	 * supported DUNs is 0 through (1 << (8 * max_dun_bytes_supported)) - 1.
 	 */
 	unsigned int max_dun_bytes_supported;
 
+	/**
+	 * @key_types_supported: A bitmask of the supported key types:
+	 * BLK_CRYPTO_KEY_TYPE_STANDARD and/or BLK_CRYPTO_KEY_TYPE_HW_WRAPPED.
+	 */
+	unsigned int key_types_supported;
+
 	/**
 	 * @modes_supported: Array of bitmasks that specifies whether each
 	 * combination of crypto mode and data unit size is supported.
 	 * Specifically, the i'th bit of modes_supported[crypto_mode] is set if
 	 * crypto_mode can be used with a data unit size of (1 << i).  Note that
 	 * only data unit sizes that are powers of 2 can be supported.
 	 */
 	unsigned int modes_supported[BLK_ENCRYPTION_MODE_MAX];
 
 	/**
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 5e5822c18ee4..19066d86ecbf 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -10,53 +10,107 @@
 
 enum blk_crypto_mode_num {
 	BLK_ENCRYPTION_MODE_INVALID,
 	BLK_ENCRYPTION_MODE_AES_256_XTS,
 	BLK_ENCRYPTION_MODE_AES_128_CBC_ESSIV,
 	BLK_ENCRYPTION_MODE_ADIANTUM,
 	BLK_ENCRYPTION_MODE_SM4_XTS,
 	BLK_ENCRYPTION_MODE_MAX,
 };
 
-#define BLK_CRYPTO_MAX_KEY_SIZE		64
+/*
+ * Supported types of keys.  Must be bitflags due to their use in
+ * blk_crypto_profile::key_types_supported.
+ */
+enum blk_crypto_key_type {
+	/*
+	 * Standard keys (i.e. "software keys").  These keys are simply kept in
+	 * raw, plaintext form in kernel memory.
+	 */
+	BLK_CRYPTO_KEY_TYPE_STANDARD = 1 << 0,
+
+	/*
+	 * Hardware-wrapped keys.  These keys are only present in kernel memory
+	 * in ephemerally-wrapped form, and they can only be unwrapped by
+	 * dedicated hardware.  For details, see the "Hardware-wrapped keys"
+	 * section of Documentation/block/inline-encryption.rst.
+	 */
+	BLK_CRYPTO_KEY_TYPE_HW_WRAPPED = 1 << 1,
+};
+
+/*
+ * Currently the maximum standard key size is 64 bytes, as that is the key size
+ * of BLK_ENCRYPTION_MODE_AES_256_XTS which takes the longest key.
+ *
+ * The maximum hardware-wrapped key size depends on the hardware's key wrapping
+ * algorithm, which is a hardware implementation detail, so it isn't precisely
+ * specified.  But currently 128 bytes is plenty in practice.  Implementations
+ * are recommended to wrap a 32-byte key for the hardware KDF with AES-256-GCM,
+ * which should result in a size closer to 64 bytes than 128.
+ *
+ * Both of these values can trivially be increased if ever needed.
+ */
+#define BLK_CRYPTO_MAX_STANDARD_KEY_SIZE	64
+#define BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE	128
+
+/* This should use max(), but max() doesn't work in a struct definition. */
+#define BLK_CRYPTO_MAX_ANY_KEY_SIZE \
+	(BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE > \
+	 BLK_CRYPTO_MAX_STANDARD_KEY_SIZE ? \
+	 BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE : BLK_CRYPTO_MAX_STANDARD_KEY_SIZE)
+
+/*
+ * Size of the "software secret" which can be derived from a hardware-wrapped
+ * key.  This is currently always 32 bytes.  Note, the choice of 32 bytes
+ * assumes that the software secret is only used directly for algorithms that
+ * don't require more than a 256-bit key to get the desired security strength.
+ * If it were to be used e.g. directly as an AES-256-XTS key, then this would
+ * need to be increased (which is possible if hardware supports it, but care
+ * would need to be taken to avoid breaking users who need exactly 32 bytes).
+ */
+#define BLK_CRYPTO_SW_SECRET_SIZE	32
+
 /**
  * struct blk_crypto_config - an inline encryption key's crypto configuration
  * @crypto_mode: encryption algorithm this key is for
  * @data_unit_size: the data unit size for all encryption/decryptions with this
  *	key.  This is the size in bytes of each individual plaintext and
  *	ciphertext.  This is always a power of 2.  It might be e.g. the
  *	filesystem block size or the disk sector size.
  * @dun_bytes: the maximum number of bytes of DUN used when using this key
+ * @key_type: the type of this key -- either standard or hardware-wrapped
  */
 struct blk_crypto_config {
 	enum blk_crypto_mode_num crypto_mode;
 	unsigned int data_unit_size;
 	unsigned int dun_bytes;
+	enum blk_crypto_key_type key_type;
 };
 
 /**
  * struct blk_crypto_key - an inline encryption key
- * @crypto_cfg: the crypto configuration (like crypto_mode, key size) for this
- *		key
+ * @crypto_cfg: the crypto mode, data unit size, key type, and other
+ *		characteristics of this key and how it will be used
  * @data_unit_size_bits: log2 of data_unit_size
- * @size: size of this key in bytes (determined by @crypto_cfg.crypto_mode)
- * @raw: the raw bytes of this key.  Only the first @size bytes are used.
+ * @size: size of this key in bytes.  The size of a standard key is fixed for a
+ *	  given crypto mode, but the size of a hardware-wrapped key can vary.
+ * @raw: the bytes of this key.  Only the first @size bytes are significant.
  *
  * A blk_crypto_key is immutable once created, and many bios can reference it at
  * the same time.  It must not be freed until all bios using it have completed
  * and it has been evicted from all devices on which it may have been used.
  */
 struct blk_crypto_key {
 	struct blk_crypto_config crypto_cfg;
 	unsigned int data_unit_size_bits;
 	unsigned int size;
-	u8 raw[BLK_CRYPTO_MAX_KEY_SIZE];
+	u8 raw[BLK_CRYPTO_MAX_ANY_KEY_SIZE];
 };
 
 #define BLK_CRYPTO_MAX_IV_SIZE		32
 #define BLK_CRYPTO_DUN_ARRAY_SIZE	(BLK_CRYPTO_MAX_IV_SIZE / sizeof(u64))
 
 /**
  * struct bio_crypt_ctx - an inline encryption context
  * @bc_key: the key, algorithm, and data unit size to use
  * @bc_dun: the data unit number (starting IV) to use
  *
@@ -80,36 +134,42 @@ static inline bool bio_has_crypt_ctx(struct bio *bio)
 }
 
 void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
 		       const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
 		       gfp_t gfp_mask);
 
 bool bio_crypt_dun_is_contiguous(const struct bio_crypt_ctx *bc,
 				 unsigned int bytes,
 				 const u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE]);
 
-int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
+int blk_crypto_init_key(struct blk_crypto_key *blk_key,
+			const u8 *raw_key, size_t raw_key_size,
+			enum blk_crypto_key_type key_type,
 			enum blk_crypto_mode_num crypto_mode,
 			unsigned int dun_bytes,
 			unsigned int data_unit_size);
 
 int blk_crypto_start_using_key(struct block_device *bdev,
 			       const struct blk_crypto_key *key);
 
 void blk_crypto_evict_key(struct block_device *bdev,
 			  const struct blk_crypto_key *key);
 
 bool blk_crypto_config_supported_natively(struct block_device *bdev,
 					  const struct blk_crypto_config *cfg);
 bool blk_crypto_config_supported(struct block_device *bdev,
 				 const struct blk_crypto_config *cfg);
 
+int blk_crypto_derive_sw_secret(struct block_device *bdev,
+				const u8 *eph_key, size_t eph_key_size,
+				u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+
 #else /* CONFIG_BLK_INLINE_ENCRYPTION */
 
 static inline bool bio_has_crypt_ctx(struct bio *bio)
 {
 	return false;
 }
 
 #endif /* CONFIG_BLK_INLINE_ENCRYPTION */
 
 int __bio_crypt_clone(struct bio *dst, struct bio *src, gfp_t gfp_mask);
-- 
2.42.0

