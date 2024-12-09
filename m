Return-Path: <linux-fscrypt+bounces-539-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BFA59E8AB5
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 05:57:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F51C1642CE
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 04:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34233199E9D;
	Mon,  9 Dec 2024 04:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dG62w0hF"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98A6199938;
	Mon,  9 Dec 2024 04:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733720224; cv=none; b=IHpCu1FqIKXwhyTrnPvp5pNonxbmE5/HODzvpMGZNKM8dorgqjFcCfOWSuJD5kJjO9JH6C7y+K2po4bp8DFeiSdd+l1XNxVkWo12+eqoZashoTICXUCBpJu37kv49YiycDp5h7uBjqnGpXTTZZYoaYgh6Bm49ht9fgaTJaLvuYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733720224; c=relaxed/simple;
	bh=P+IYcSv+3ZPjU0tFb0vZaSHTd6TYe+nZefGBRRX9nu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJcKrjx1xiWkfe1c9y6VJAgfKrgf1rusBd0eBoZ4tzeeHirE2QvhDU6YfyaZBOqYmaMxDgk+MM9tb2AYnPLfUQJZxRMxKoYohYcVOzImEfQvhmMpVopS6Z8bnpxymAZlQh3+zrrn2P8harFfWx77OONaesgxOZTUluH/aDcILyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dG62w0hF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399DAC4CED1;
	Mon,  9 Dec 2024 04:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733720223;
	bh=P+IYcSv+3ZPjU0tFb0vZaSHTd6TYe+nZefGBRRX9nu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dG62w0hFnPIssARss1U5qKCySvQndVlbrTdDj2Vh5VmvYYOUti5uoldgMekZdGRZc
	 ubRUQhzopTyDdkh0/lKOwFvWSyzuD0N3DeBW5qW4ZHTz81PKwn2EBFFMIdoWRUyDDg
	 PMsP9FYPabryHC5OHoWZ+Oe6Lhu7X4jPCWS1VPLtqJP97buJ+uqZjlip/rzijLUJgj
	 ZZVMGIqpgIiEZOq35VZEgmUYjJBxqfkgnWW8v0YdrluvqZe3PCwvsCSpFMnL9rz3To
	 UtVpaYyjL555GCEKugM12MBADdOVR/6jWqnWjeoYXZ/boTs8lYiViGqjW7UHWaTFTz
	 9zszgJWtp4K0w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v9 07/12] blk-crypto: add basic hardware-wrapped key support
Date: Sun,  8 Dec 2024 20:55:25 -0800
Message-ID: <20241209045530.507833-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241209045530.507833-1-ebiggers@kernel.org>
References: <20241209045530.507833-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

To prevent keys from being compromised if an attacker acquires read
access to kernel memory, some inline encryption hardware can accept keys
which are wrapped by a per-boot hardware-internal key.  This avoids
needing to keep the raw keys in kernel memory, without limiting the
number of keys that can be used.  Such hardware also supports deriving a
"software secret" for cryptographic tasks that can't be handled by
inline encryption; this is needed for fscrypt to work properly.

To support this hardware, allow struct blk_crypto_key to represent a
hardware-wrapped key as an alternative to a raw key, and make drivers
set flags in struct blk_crypto_profile to indicate which types of keys
they support.  Also add the ->derive_sw_secret() low-level operation,
which drivers supporting wrapped keys must implement.

For more information, see the detailed documentation which this patch
adds to Documentation/block/inline-encryption.rst.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/block/inline-encryption.rst | 219 +++++++++++++++++++++-
 block/blk-crypto-fallback.c               |   7 +-
 block/blk-crypto-internal.h               |   1 +
 block/blk-crypto-profile.c                |  46 +++++
 block/blk-crypto.c                        |  53 ++++--
 drivers/md/dm-table.c                     |   1 +
 drivers/mmc/host/cqhci-crypto.c           |   8 +-
 drivers/mmc/host/sdhci-msm.c              |   1 +
 drivers/soc/qcom/ice.c                    |   2 +-
 drivers/ufs/core/ufshcd-crypto.c          |   7 +-
 drivers/ufs/host/ufs-exynos.c             |   3 +-
 drivers/ufs/host/ufs-qcom.c               |   1 +
 fs/crypto/inline_crypt.c                  |   4 +-
 include/linux/blk-crypto-profile.h        |  20 ++
 include/linux/blk-crypto.h                |  72 ++++++-
 15 files changed, 411 insertions(+), 34 deletions(-)

diff --git a/Documentation/block/inline-encryption.rst b/Documentation/block/inline-encryption.rst
index 90b733422ed46..f03bd5b090d89 100644
--- a/Documentation/block/inline-encryption.rst
+++ b/Documentation/block/inline-encryption.rst
@@ -75,14 +75,14 @@ Constraints and notes
 
 Basic design
 ============
 
 We introduce ``struct blk_crypto_key`` to represent an inline encryption key and
-how it will be used.  This includes the actual bytes of the key; the size of the
-key; the algorithm and data unit size the key will be used with; and the number
-of bytes needed to represent the maximum data unit number the key will be used
-with.
+how it will be used.  This includes the type of the key (raw or
+hardware-wrapped); the actual bytes of the key; the size of the key; the
+algorithm and data unit size the key will be used with; and the number of bytes
+needed to represent the maximum data unit number the key will be used with.
 
 We introduce ``struct bio_crypt_ctx`` to represent an encryption context.  It
 contains a data unit number and a pointer to a blk_crypto_key.  We add pointers
 to a bio_crypt_ctx to ``struct bio`` and ``struct request``; this allows users
 of the block layer (e.g. filesystems) to provide an encryption context when
@@ -299,5 +299,216 @@ and disallow the combination for now. Whenever a device supports integrity, the
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
+However, that naive approach runs into a couple problems:
+
+- It limits the number of unlocked keys to the number of keyslots, which
+  typically is a small number.  In cases where there is only one encryption key
+  system-wide (e.g., a full-disk encryption key), that can be tolerable.
+  However, in general there can be many logged-in users with many different
+  keys, and/or many running applications with application-specific encrypted
+  storage areas.  This is especially true if file-based encryption (e.g.
+  fscrypt) is being used.
+
+- Inline crypto engines typically lose the contents of their keyslots if the
+  storage controller (usually UFS or eMMC) is reset.  Resetting the storage
+  controller is a standard error recovery procedure that is executed if certain
+  types of storage errors occur, and such errors can occur at any time.
+  Therefore, when inline crypto is being used, the operating system must always
+  be ready to reprogram the keyslots without user intervention.
+
+Thus, it is important for the kernel to still have a way to "remind" the
+hardware about a key, without actually having the raw key itself.
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
+been extended to support hardware-wrapped keys as an alternative to raw keys,
+when hardware support is available.  This works in the following way:
+
+- A ``key_types_supported`` field is added to the crypto capabilities in
+  ``struct blk_crypto_profile``.  This allows device drivers to declare that
+  they support raw keys, hardware-wrapped keys, or both.
+
+- ``struct blk_crypto_key`` can now contain a hardware-wrapped key as an
+  alternative to a raw key; a ``key_type`` field is added to
+  ``struct blk_crypto_config`` to distinguish between the different key types.
+  This allows users of blk-crypto to en/decrypt data using a hardware-wrapped
+  key in a way very similar to using a raw key.
+
+- A new method ``blk_crypto_ll_ops::derive_sw_secret`` is added.  Device drivers
+  that support hardware-wrapped keys must implement this method.  Users of
+  blk-crypto can call ``blk_crypto_derive_sw_secret()`` to access this method.
+
+- The programming and eviction of hardware-wrapped keys happens via
+  ``blk_crypto_ll_ops::keyslot_program`` and
+  ``blk_crypto_ll_ops::keyslot_evict``, just like it does for raw keys.  If a
+  driver supports hardware-wrapped keys, then it must handle hardware-wrapped
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
+<https://android.googlesource.com/platform/test/vts-testcase/kernel/+/refs/heads/main/encryption/>`_.
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 29a205482617c..f154be0b575ad 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -85,11 +85,11 @@ static struct bio_set crypto_bio_split;
 
 /*
  * This is the key we set when evicting a keyslot. This *should* be the all 0's
  * key, but AES-XTS rejects that key, so we use some random bytes instead.
  */
-static u8 blank_key[BLK_CRYPTO_MAX_KEY_SIZE];
+static u8 blank_key[BLK_CRYPTO_MAX_RAW_KEY_SIZE];
 
 static void blk_crypto_fallback_evict_keyslot(unsigned int slot)
 {
 	struct blk_crypto_fallback_keyslot *slotp = &blk_crypto_keyslots[slot];
 	enum blk_crypto_mode_num crypto_mode = slotp->crypto_mode;
@@ -117,11 +117,11 @@ blk_crypto_fallback_keyslot_program(struct blk_crypto_profile *profile,
 	if (crypto_mode != slotp->crypto_mode &&
 	    slotp->crypto_mode != BLK_ENCRYPTION_MODE_INVALID)
 		blk_crypto_fallback_evict_keyslot(slot);
 
 	slotp->crypto_mode = crypto_mode;
-	err = crypto_skcipher_setkey(slotp->tfms[crypto_mode], key->raw,
+	err = crypto_skcipher_setkey(slotp->tfms[crypto_mode], key->bytes,
 				     key->size);
 	if (err) {
 		blk_crypto_fallback_evict_keyslot(slot);
 		return err;
 	}
@@ -537,11 +537,11 @@ static int blk_crypto_fallback_init(void)
 	int err;
 
 	if (blk_crypto_fallback_inited)
 		return 0;
 
-	get_random_bytes(blank_key, BLK_CRYPTO_MAX_KEY_SIZE);
+	get_random_bytes(blank_key, sizeof(blank_key));
 
 	err = bioset_init(&crypto_bio_split, 64, 0, 0);
 	if (err)
 		goto out;
 
@@ -559,10 +559,11 @@ static int blk_crypto_fallback_init(void)
 		goto fail_free_profile;
 	err = -ENOMEM;
 
 	blk_crypto_fallback_profile->ll_ops = blk_crypto_fallback_ll_ops;
 	blk_crypto_fallback_profile->max_dun_bytes_supported = BLK_CRYPTO_MAX_IV_SIZE;
+	blk_crypto_fallback_profile->key_types_supported = BLK_CRYPTO_KEY_TYPE_RAW;
 
 	/* All blk-crypto modes have a crypto API fallback. */
 	for (i = 0; i < BLK_ENCRYPTION_MODE_MAX; i++)
 		blk_crypto_fallback_profile->modes_supported[i] = 0xFFFFFFFF;
 	blk_crypto_fallback_profile->modes_supported[BLK_ENCRYPTION_MODE_INVALID] = 0;
diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index 93a141979694b..1893df9a8f06c 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -12,10 +12,11 @@
 /* Represents a crypto mode supported by blk-crypto  */
 struct blk_crypto_mode {
 	const char *name; /* name of this mode, shown in sysfs */
 	const char *cipher_str; /* crypto API name (for fallback case) */
 	unsigned int keysize; /* key size in bytes */
+	unsigned int security_strength; /* security strength in bytes */
 	unsigned int ivsize; /* iv size in bytes */
 };
 
 extern const struct blk_crypto_mode blk_crypto_modes[];
 
diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 7fabc883e39f1..1b92276ed2fcc 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -350,10 +350,12 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
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
@@ -460,10 +462,48 @@ bool blk_crypto_register(struct blk_crypto_profile *profile,
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
@@ -483,14 +523,16 @@ void blk_crypto_intersect_capabilities(struct blk_crypto_profile *parent,
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
@@ -519,10 +561,13 @@ bool blk_crypto_has_capabilities(const struct blk_crypto_profile *target,
 
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
@@ -553,7 +598,8 @@ void blk_crypto_update_capabilities(struct blk_crypto_profile *dst,
 {
 	memcpy(dst->modes_supported, src->modes_supported,
 	       sizeof(dst->modes_supported));
 
 	dst->max_dun_bytes_supported = src->max_dun_bytes_supported;
+	dst->key_types_supported = src->key_types_supported;
 }
 EXPORT_SYMBOL_GPL(blk_crypto_update_capabilities);
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 4d760b092deb9..b55b3d8bffa00 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -21,28 +21,32 @@
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
@@ -74,13 +78,19 @@ static int __init bio_crypt_ctx_init(void)
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
+		       BLK_CRYPTO_MAX_RAW_KEY_SIZE);
+		BUG_ON(blk_crypto_modes[i].security_strength >
+		       blk_crypto_modes[i].keysize);
 		BUG_ON(blk_crypto_modes[i].ivsize > BLK_CRYPTO_MAX_IV_SIZE);
 	}
 
 	return 0;
 out_no_mem:
@@ -313,21 +323,24 @@ int __blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
 }
 
 /**
  * blk_crypto_init_key() - Prepare a key for use with blk-crypto
  * @blk_key: Pointer to the blk_crypto_key to initialize.
- * @raw_key: Pointer to the raw key. Must be the correct length for the chosen
- *	     @crypto_mode; see blk_crypto_modes[].
+ * @key_bytes: the bytes of the key
+ * @key_size: size of the key in bytes
+ * @key_type: type of the key -- either raw or hardware-wrapped
  * @crypto_mode: identifier for the encryption algorithm to use
  * @dun_bytes: number of bytes that will be used to specify the DUN when this
  *	       key is used
  * @data_unit_size: the data unit size to use for en/decryption
  *
  * Return: 0 on success, -errno on failure.  The caller is responsible for
- *	   zeroizing both blk_key and raw_key when done with them.
+ *	   zeroizing both blk_key and key_bytes when done with them.
  */
-int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
+int blk_crypto_init_key(struct blk_crypto_key *blk_key,
+			const u8 *key_bytes, size_t key_size,
+			enum blk_crypto_key_type key_type,
 			enum blk_crypto_mode_num crypto_mode,
 			unsigned int dun_bytes,
 			unsigned int data_unit_size)
 {
 	const struct blk_crypto_mode *mode;
@@ -336,25 +349,37 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 
 	if (crypto_mode >= ARRAY_SIZE(blk_crypto_modes))
 		return -EINVAL;
 
 	mode = &blk_crypto_modes[crypto_mode];
-	if (mode->keysize == 0)
+	switch (key_type) {
+	case BLK_CRYPTO_KEY_TYPE_RAW:
+		if (key_size != mode->keysize)
+			return -EINVAL;
+		break;
+	case BLK_CRYPTO_KEY_TYPE_HW_WRAPPED:
+		if (key_size < mode->security_strength ||
+		    key_size > BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE)
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
+	blk_key->size = key_size;
+	memcpy(blk_key->bytes, key_bytes, key_size);
 
 	return 0;
 }
 
 bool blk_crypto_config_supported_natively(struct block_device *bdev,
@@ -370,12 +395,14 @@ bool blk_crypto_config_supported_natively(struct block_device *bdev,
  * blk-crypto-fallback is enabled and supports the cfg).
  */
 bool blk_crypto_config_supported(struct block_device *bdev,
 				 const struct blk_crypto_config *cfg)
 {
-	return IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-	       blk_crypto_config_supported_natively(bdev, cfg);
+	if (IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) &&
+	    cfg->key_type == BLK_CRYPTO_KEY_TYPE_RAW)
+		return true;
+	return blk_crypto_config_supported_natively(bdev, cfg);
 }
 
 /**
  * blk_crypto_start_using_key() - Start using a blk_crypto_key on a device
  * @bdev: block device to operate on
@@ -394,10 +421,14 @@ bool blk_crypto_config_supported(struct block_device *bdev,
 int blk_crypto_start_using_key(struct block_device *bdev,
 			       const struct blk_crypto_key *key)
 {
 	if (blk_crypto_config_supported_natively(bdev, &key->crypto_cfg))
 		return 0;
+	if (key->crypto_cfg.key_type != BLK_CRYPTO_KEY_TYPE_RAW) {
+		pr_warn_once("tried to use wrapped key, but hardware doesn't support it\n");
+		return -EOPNOTSUPP;
+	}
 	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
 }
 
 /**
  * blk_crypto_evict_key() - Evict a blk_crypto_key from a block_device
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index bd8b796ae683b..3e2ab66a46aef 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1248,10 +1248,11 @@ static int dm_table_construct_crypto_profile(struct dm_table *t)
 	blk_crypto_profile_init(profile, 0);
 	profile->ll_ops.keyslot_evict = dm_keyslot_evict;
 	profile->max_dun_bytes_supported = UINT_MAX;
 	memset(profile->modes_supported, 0xFF,
 	       sizeof(profile->modes_supported));
+	profile->key_types_supported = ~0;
 
 	for (i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(t, i);
 
 		if (!dm_target_passes_crypto(ti->type)) {
diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
index 4736564286859..99456585d63bd 100644
--- a/drivers/mmc/host/cqhci-crypto.c
+++ b/drivers/mmc/host/cqhci-crypto.c
@@ -82,15 +82,15 @@ static int cqhci_crypto_keyslot_program(struct blk_crypto_profile *profile,
 	cfg.crypto_cap_idx = cap_idx;
 	cfg.config_enable = CQHCI_CRYPTO_CONFIGURATION_ENABLE;
 
 	if (ccap_array[cap_idx].algorithm_id == CQHCI_CRYPTO_ALG_AES_XTS) {
 		/* In XTS mode, the blk_crypto_key's size is already doubled */
-		memcpy(cfg.crypto_key, key->raw, key->size/2);
+		memcpy(cfg.crypto_key, key->bytes, key->size/2);
 		memcpy(cfg.crypto_key + CQHCI_CRYPTO_KEY_MAX_SIZE/2,
-		       key->raw + key->size/2, key->size/2);
+		       key->bytes + key->size/2, key->size/2);
 	} else {
-		memcpy(cfg.crypto_key, key->raw, key->size);
+		memcpy(cfg.crypto_key, key->bytes, key->size);
 	}
 
 	cqhci_crypto_program_key(cq_host, &cfg, slot);
 
 	memzero_explicit(&cfg, sizeof(cfg));
@@ -204,10 +204,12 @@ int cqhci_crypto_init(struct cqhci_host *cq_host)
 	profile->dev = dev;
 
 	/* Unfortunately, CQHCI crypto only supports 32 DUN bits. */
 	profile->max_dun_bytes_supported = 4;
 
+	profile->key_types_supported = BLK_CRYPTO_KEY_TYPE_RAW;
+
 	/*
 	 * Cache all the crypto capabilities and advertise the supported crypto
 	 * modes and data unit sizes to the block layer.
 	 */
 	for (cap_idx = 0; cap_idx < cq_host->crypto_capabilities.num_crypto_cap;
diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 8684a5f3357ba..27b24fb8e8809 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1845,10 +1845,11 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 	if (err)
 		return err;
 
 	profile->ll_ops = sdhci_msm_crypto_ops;
 	profile->max_dun_bytes_supported = 4;
+	profile->key_types_supported = BLK_CRYPTO_KEY_TYPE_RAW;
 	profile->dev = dev;
 
 	/*
 	 * Currently this driver only supports AES-256-XTS.  All known versions
 	 * of ICE support it, but to be safe make sure it is really declared in
diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 04d5884574c54..78780fd508f0b 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -182,11 +182,11 @@ int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
 
 	if (blk_key->size != AES_256_XTS_KEY_SIZE) {
 		dev_err_ratelimited(dev, "Incorrect key size\n");
 		return -EINVAL;
 	}
-	memcpy(key.bytes, blk_key->raw, AES_256_XTS_KEY_SIZE);
+	memcpy(key.bytes, blk_key->bytes, AES_256_XTS_KEY_SIZE);
 
 	/* The SCM call requires that the key words are encoded in big endian */
 	for (i = 0; i < ARRAY_SIZE(key.words); i++)
 		__cpu_to_be32s(&key.words[i]);
 
diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index 694ff7578fc19..9e63a9d3cb7e2 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -70,15 +70,15 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 	cfg.crypto_cap_idx = cap_idx;
 	cfg.config_enable = UFS_CRYPTO_CONFIGURATION_ENABLE;
 
 	if (ccap_array[cap_idx].algorithm_id == UFS_CRYPTO_ALG_AES_XTS) {
 		/* In XTS mode, the blk_crypto_key's size is already doubled */
-		memcpy(cfg.crypto_key, key->raw, key->size/2);
+		memcpy(cfg.crypto_key, key->bytes, key->size/2);
 		memcpy(cfg.crypto_key + UFS_CRYPTO_KEY_MAX_SIZE/2,
-		       key->raw + key->size/2, key->size/2);
+		       key->bytes + key->size/2, key->size/2);
 	} else {
-		memcpy(cfg.crypto_key, key->raw, key->size);
+		memcpy(cfg.crypto_key, key->bytes, key->size);
 	}
 
 	ufshcd_program_key(hba, &cfg, slot);
 
 	memzero_explicit(&cfg, sizeof(cfg));
@@ -183,10 +183,11 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 		goto out;
 
 	hba->crypto_profile.ll_ops = ufshcd_crypto_ops;
 	/* UFS only supports 8 bytes for any DUN */
 	hba->crypto_profile.max_dun_bytes_supported = 8;
+	hba->crypto_profile.key_types_supported = BLK_CRYPTO_KEY_TYPE_RAW;
 	hba->crypto_profile.dev = hba->dev;
 
 	/*
 	 * Cache all the UFS crypto capabilities and advertise the supported
 	 * crypto modes and data unit sizes to the block layer.
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 13dd5dfc03eb3..6a415d9bdc85a 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1318,10 +1318,11 @@ static void exynos_ufs_fmp_init(struct ufs_hba *hba, struct exynos_ufs *ufs)
 		dev_err(hba->dev, "Failed to initialize crypto profile: %d\n",
 			err);
 		return;
 	}
 	profile->max_dun_bytes_supported = AES_BLOCK_SIZE;
+	profile->key_types_supported = BLK_CRYPTO_KEY_TYPE_RAW;
 	profile->dev = hba->dev;
 	profile->modes_supported[BLK_ENCRYPTION_MODE_AES_256_XTS] =
 		DATA_UNIT_SIZE;
 
 	/* Advertise crypto support to ufshcd-core. */
@@ -1364,11 +1365,11 @@ static inline __be64 fmp_key_word(const u8 *key, int j)
 static int exynos_ufs_fmp_fill_prdt(struct ufs_hba *hba,
 				    const struct bio_crypt_ctx *crypt_ctx,
 				    void *prdt, unsigned int num_segments)
 {
 	struct fmp_sg_entry *fmp_prdt = prdt;
-	const u8 *enckey = crypt_ctx->bc_key->raw;
+	const u8 *enckey = crypt_ctx->bc_key->bytes;
 	const u8 *twkey = enckey + AES_KEYSIZE_256;
 	u64 dun_lo = crypt_ctx->bc_dun[0];
 	u64 dun_hi = crypt_ctx->bc_dun[1];
 	unsigned int i;
 
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index c0e72d2de378a..865193d9bc474 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -146,10 +146,11 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	if (err)
 		return err;
 
 	profile->ll_ops = ufs_qcom_crypto_ops;
 	profile->max_dun_bytes_supported = 8;
+	profile->key_types_supported = BLK_CRYPTO_KEY_TYPE_RAW;
 	profile->dev = dev;
 
 	/*
 	 * Currently this driver only supports AES-256-XTS.  All known versions
 	 * of ICE support it, but to be safe make sure it is really declared in
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 40de69860dcf9..7fa53d30aec30 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -128,10 +128,11 @@ int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci)
 	 * crypto configuration that the file would use.
 	 */
 	crypto_cfg.crypto_mode = ci->ci_mode->blk_crypto_mode;
 	crypto_cfg.data_unit_size = 1U << ci->ci_data_unit_bits;
 	crypto_cfg.dun_bytes = fscrypt_get_dun_bytes(ci);
+	crypto_cfg.key_type = BLK_CRYPTO_KEY_TYPE_RAW;
 
 	devs = fscrypt_get_devices(sb, &num_devs);
 	if (IS_ERR(devs))
 		return PTR_ERR(devs);
 
@@ -164,11 +165,12 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 
 	blk_key = kmalloc(sizeof(*blk_key), GFP_KERNEL);
 	if (!blk_key)
 		return -ENOMEM;
 
-	err = blk_crypto_init_key(blk_key, raw_key, crypto_mode,
+	err = blk_crypto_init_key(blk_key, raw_key, ci->ci_mode->keysize,
+				  BLK_CRYPTO_KEY_TYPE_RAW, crypto_mode,
 				  fscrypt_get_dun_bytes(ci),
 				  1U << ci->ci_data_unit_bits);
 	if (err) {
 		fscrypt_err(inode, "error %d initializing blk-crypto key", err);
 		goto fail;
diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
index 90ab33cb5d0ef..7764b4f7b45b9 100644
--- a/include/linux/blk-crypto-profile.h
+++ b/include/linux/blk-crypto-profile.h
@@ -55,10 +55,24 @@ struct blk_crypto_ll_ops {
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
@@ -82,10 +96,16 @@ struct blk_crypto_profile {
 	 * specifying the data unit number (DUN).  Specifically, the range of
 	 * supported DUNs is 0 through (1 << (8 * max_dun_bytes_supported)) - 1.
 	 */
 	unsigned int max_dun_bytes_supported;
 
+	/**
+	 * @key_types_supported: A bitmask of the supported key types:
+	 * BLK_CRYPTO_KEY_TYPE_RAW and/or BLK_CRYPTO_KEY_TYPE_HW_WRAPPED.
+	 */
+	unsigned int key_types_supported;
+
 	/**
 	 * @modes_supported: Array of bitmasks that specifies whether each
 	 * combination of crypto mode and data unit size is supported.
 	 * Specifically, the i'th bit of modes_supported[crypto_mode] is set if
 	 * crypto_mode can be used with a data unit size of (1 << i).  Note that
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 5e5822c18ee41..0e63287e2175f 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -4,10 +4,11 @@
  */
 
 #ifndef __LINUX_BLK_CRYPTO_H
 #define __LINUX_BLK_CRYPTO_H
 
+#include <linux/minmax.h>
 #include <linux/types.h>
 
 enum blk_crypto_mode_num {
 	BLK_ENCRYPTION_MODE_INVALID,
 	BLK_ENCRYPTION_MODE_AES_256_XTS,
@@ -15,43 +16,94 @@ enum blk_crypto_mode_num {
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
+	 * Raw keys (i.e. "software keys").  These keys are simply kept in raw,
+	 * plaintext form in kernel memory.
+	 */
+	BLK_CRYPTO_KEY_TYPE_RAW = 1 << 0,
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
+ * Currently the maximum raw key size is 64 bytes, as that is the key size of
+ * BLK_ENCRYPTION_MODE_AES_256_XTS which takes the longest key.
+ *
+ * The maximum hardware-wrapped key size depends on the hardware's key wrapping
+ * algorithm, which is a hardware implementation detail, so it isn't precisely
+ * specified.  But currently 128 bytes is plenty in practice.  Implementations
+ * are recommended to wrap a 32-byte key for the hardware KDF with AES-256-GCM,
+ * which should result in a size closer to 64 bytes than 128.
+ *
+ * Both of these values can trivially be increased if ever needed.
+ */
+#define BLK_CRYPTO_MAX_RAW_KEY_SIZE		64
+#define BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE	128
+
+#define BLK_CRYPTO_MAX_ANY_KEY_SIZE \
+	MAX(BLK_CRYPTO_MAX_RAW_KEY_SIZE, BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE)
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
+ * @key_type: the type of this key -- either raw or hardware-wrapped
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
+ * @size: size of this key in bytes.  The size of a raw key is fixed for a given
+ *	  crypto mode, but the size of a hardware-wrapped key can vary.
+ * @bytes: the bytes of this key.  Only the first @size bytes are significant.
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
+	u8 bytes[BLK_CRYPTO_MAX_ANY_KEY_SIZE];
 };
 
 #define BLK_CRYPTO_MAX_IV_SIZE		32
 #define BLK_CRYPTO_DUN_ARRAY_SIZE	(BLK_CRYPTO_MAX_IV_SIZE / sizeof(u64))
 
@@ -85,11 +137,13 @@ void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
 
 bool bio_crypt_dun_is_contiguous(const struct bio_crypt_ctx *bc,
 				 unsigned int bytes,
 				 const u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE]);
 
-int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
+int blk_crypto_init_key(struct blk_crypto_key *blk_key,
+			const u8 *key_bytes, size_t key_size,
+			enum blk_crypto_key_type key_type,
 			enum blk_crypto_mode_num crypto_mode,
 			unsigned int dun_bytes,
 			unsigned int data_unit_size);
 
 int blk_crypto_start_using_key(struct block_device *bdev,
@@ -101,10 +155,14 @@ void blk_crypto_evict_key(struct block_device *bdev,
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
-- 
2.47.1


