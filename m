Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E36540E982
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Sep 2021 20:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345900AbhIPRzc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Sep 2021 13:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244330AbhIPRxs (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Sep 2021 13:53:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15C7D61139;
        Thu, 16 Sep 2021 17:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631814707;
        bh=HkcGXVCQPE6AYpAlRsn1Ox5dBuJtUVR0+j00VpWeiUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cY0qQKwGRbkPyWuM8R3MD9+TfLtzotHXHug8Vh1YpG6ZVwr1Y9GgccwLpCMkKSnRU
         j7fOXP68lEM0X7PG+LPQXmfimdXWI+pkFMaS8Uswa0cLBfK5By0Kuy+l2CSwfQ+AMs
         H26jaBbI53HpHl/sP0lAIyY2fnfHUYFacerQ2DR+Ghl5w4Eu2v/eW4U6MpLKjEsoHw
         lB78IwDm00GdPHtlxgBhKX1IGseaIh3/hq6mIxiBptbRmW/1BSeukoWDGPD/rh/O03
         uGl0ZBFqTD6afRKpacF85QRht5O0XARHP80rI9y/aUZfNas71eUDrNXqs+WrI/KIlV
         rq0e1oNMsO0wg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, kernel-team@android.com,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Gaurav Kashyap <gaurkash@codeaurora.org>,
        Satya Tangirala <satyaprateek2357@gmail.com>
Subject: [RFC PATCH v2 5/5] fscrypt: add support for hardware-wrapped keys
Date:   Thu, 16 Sep 2021 10:49:28 -0700
Message-Id: <20210916174928.65529-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916174928.65529-1-ebiggers@kernel.org>
References: <20210916174928.65529-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add support for hardware-wrapped keys to fscrypt.  Hardware-wrapped keys
are inline encryption keys which are only present in kernel memory in
ephemerally-wrapped form, and which can only be unwrapped by dedicated
hardware.  Such keys are protected from certain attacks, such as cold
boot attacks.  For more information, see the "Hardware-wrapped keys"
section of Documentation/block/inline-encryption.rst.

To support hardware-wrapped keys in fscrypt, we allow the fscrypt master
keys to be hardware-wrapped, and we allow encryption policies to be
flagged as needing a hardware-wrapped key.  File contents encryption is
done by passing the wrapped key to the inline encryption hardware via
blk-crypto.  Other fscrypt operations such as filenames encryption
continue to be done by the kernel, using the "software secret" which the
hardware derives.  For more information, see the documentation which
this patch adds to Documentation/filesystems/fscrypt.rst.

Note that this feature doesn't require any filesystem-specific changes.
However it does depend on inline encryption support, and thus currently
it is only applicable to ext4 and f2fs, not to ubifs or CephFS.

This feature is intentionally not UAPI or on-disk format compatible with
the version of this feature in the Android Common Kernels, as that
version was meant as a temporary solution and it took some shortcuts.
Once upstreamed, this new version should be used going forwards.

This patch has been heavily rewritten from the original version by
Gaurav Kashyap <gaurkash@codeaurora.org> and
Barani Muthukumaran <bmuthuku@codeaurora.org>.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 154 +++++++++++++++++++++++---
 fs/crypto/fscrypt_private.h           |  83 ++++++++++++--
 fs/crypto/hkdf.c                      |   4 +-
 fs/crypto/inline_crypt.c              |  66 ++++++++++-
 fs/crypto/keyring.c                   | 119 ++++++++++++++------
 fs/crypto/keysetup.c                  |  74 +++++++++++--
 fs/crypto/keysetup_v1.c               |   5 +-
 fs/crypto/policy.c                    |  11 +-
 include/uapi/linux/fscrypt.h          |   7 +-
 9 files changed, 448 insertions(+), 75 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index d6f6495b56c0c..c339a4c3d25c3 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -70,7 +70,7 @@ Online attacks
 --------------
 
 fscrypt (and storage encryption in general) can only provide limited
-protection, if any at all, against online attacks.  In detail:
+protection against online attacks.  In detail:
 
 Side-channel attacks
 ~~~~~~~~~~~~~~~~~~~~
@@ -99,16 +99,23 @@ Therefore, any encryption-specific access control checks would merely
 be enforced by kernel *code* and therefore would be largely redundant
 with the wide variety of access control mechanisms already available.)
 
-Kernel memory compromise
-~~~~~~~~~~~~~~~~~~~~~~~~
+Read-only kernel memory compromise
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Unless `hardware-wrapped keys`_ are used, an attacker who gains the
+ability to read from arbitrary kernel memory, e.g. by mounting a
+physical attack or by exploiting a kernel security vulnerability, can
+compromise all fscrypt keys that are currently in-use.  This also
+extends to cold boot attacks; if the system is suddenly powered off,
+keys the system was using may remain in memory for a short time.
 
-An attacker who compromises the system enough to read from arbitrary
-memory, e.g. by mounting a physical attack or by exploiting a kernel
-security vulnerability, can compromise all encryption keys that are
-currently in use.
+However, if hardware-wrapped keys are used, then the fscrypt master
+keys and file contents encryption keys (but not other types of fscrypt
+subkeys such as filenames encryption keys) are protected from
+compromises of arbitrary kernel memory.
 
-However, fscrypt allows encryption keys to be removed from the kernel,
-which may protect them from later compromise.
+In addition, fscrypt allows encryption keys to be removed from the
+kernel, which may protect them from later compromise.
 
 In more detail, the FS_IOC_REMOVE_ENCRYPTION_KEY ioctl (or the
 FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS ioctl) can wipe a master
@@ -145,6 +152,24 @@ However, these ioctls have some limitations:
   accelerator hardware (if used by the crypto API to implement any of
   the algorithms), or in other places not explicitly considered here.
 
+Full system compromise
+~~~~~~~~~~~~~~~~~~~~~~
+
+An attacker who gains "root" access and/or the ability to execute
+arbitrary kernel code can freely exfiltrate data that is protected by
+any in-use fscrypt keys.  Thus, usually fscrypt provides no meaningful
+protection in this scenario.  (Data that is protected by a key that is
+absent throughout the entire attack remains protected, modulo the
+limitations of key removal mentioned above in the case where the key
+was removed prior to the attack.)
+
+However, if `hardware-wrapped keys`_ are used, such attackers will be
+unable to exfiltrate the master keys or file contents keys in a form
+that will be usable after the system is powered off.  This may be
+useful if the attacker is significantly time-limited and/or
+bandwidth-limited, so they can only exfiltrate some data and need to
+rely on a later offline attack to exfiltrate the rest of it.
+
 Limitations of v1 policies
 ~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -171,6 +196,11 @@ policies on all new encrypted directories.
 Key hierarchy
 =============
 
+Note: this section assumes the use of standard keys (i.e. "software
+keys") rather than hardware-wrapped keys.  The use of hardware-wrapped
+keys modifies the key hierarchy slightly.  For details, see the
+`Hardware-wrapped keys`_ section.
+
 Master Keys
 -----------
 
@@ -486,6 +516,8 @@ This structure must be initialized as follows:
     policies`_.
   - FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32: See `IV_INO_LBLK_32
     policies`_.
+  - FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY: This flag denotes that this
+    policy uses a hardware-wrapped key.  See `Hardware-wrapped keys`_.
 
   v1 encryption policies only support the PAD_* and DIRECT_KEY flags.
   The other flags are only supported by v2 encryption policies.
@@ -685,7 +717,8 @@ a pointer to struct fscrypt_add_key_arg, defined as follows::
             struct fscrypt_key_specifier key_spec;
             __u32 raw_size;
             __u32 key_id;
-            __u32 __reserved[8];
+            __u32 flags;
+            __u32 __reserved[7];
             __u8 raw[];
     };
 
@@ -704,7 +737,7 @@ a pointer to struct fscrypt_add_key_arg, defined as follows::
 
     struct fscrypt_provisioning_key_payload {
             __u32 type;
-            __u32 __reserved;
+            __u32 flags;
             __u8 raw[];
     };
 
@@ -732,6 +765,12 @@ as follows:
   Alternatively, if ``key_id`` is nonzero, this field must be 0, since
   in that case the size is implied by the specified Linux keyring key.
 
+- ``flags`` contains optional flags from ``<linux/fscrypt.h>``:
+
+  - FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED: This denotes that the key is a
+    hardware-wrapped key.  See `Hardware-wrapped keys`_.  This flag
+    can't be used if FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR is used.
+
 - ``key_id`` is 0 if the raw key is given directly in the ``raw``
   field.  Otherwise ``key_id`` is the ID of a Linux keyring key of
   type "fscrypt-provisioning" whose payload is
@@ -773,6 +812,8 @@ FS_IOC_ADD_ENCRYPTION_KEY can fail with the following errors:
   caller does not have the CAP_SYS_ADMIN capability in the initial
   user namespace; or the raw key was specified by Linux key ID but the
   process lacks Search permission on the key.
+- ``EBADMSG``: FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED was specified, but the
+  key isn't a valid hardware-wrapped key
 - ``EDQUOT``: the key quota for this user would be exceeded by adding
   the key
 - ``EINVAL``: invalid key size or key specifier type, or reserved bits
@@ -784,7 +825,9 @@ FS_IOC_ADD_ENCRYPTION_KEY can fail with the following errors:
 - ``ENOTTY``: this type of filesystem does not implement encryption
 - ``EOPNOTSUPP``: the kernel was not configured with encryption
   support for this filesystem, or the filesystem superblock has not
-  had encryption enabled on it
+  had encryption enabled on it, or FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED was
+  specified but the filesystem and/or the hardware doesn't support
+  hardware-wrapped keys
 
 Legacy method
 ~~~~~~~~~~~~~
@@ -847,9 +890,8 @@ or removed by non-root users.
 These ioctls don't work on keys that were added via the legacy
 process-subscribed keyrings mechanism.
 
-Before using these ioctls, read the `Kernel memory compromise`_
-section for a discussion of the security goals and limitations of
-these ioctls.
+Before using these ioctls, read the `Online attacks`_ section for a
+discussion of the security goals and limitations of these ioctls.
 
 FS_IOC_REMOVE_ENCRYPTION_KEY
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -1169,7 +1211,8 @@ inline encryption hardware doesn't have the needed crypto capabilities
 (e.g. support for the needed encryption algorithm and data unit size)
 and where blk-crypto-fallback is unusable.  (For blk-crypto-fallback
 to be usable, it must be enabled in the kernel configuration with
-CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y.)
+CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y, and the file must be
+protected by a standard key rather than a hardware-wrapped key.)
 
 Currently fscrypt always uses the filesystem block size (which is
 usually 4096 bytes) as the data unit size.  Therefore, it can only use
@@ -1177,7 +1220,84 @@ inline encryption hardware that supports that data unit size.
 
 Inline encryption doesn't affect the ciphertext or other aspects of
 the on-disk format, so users may freely switch back and forth between
-using "inlinecrypt" and not using "inlinecrypt".
+using "inlinecrypt" and not using "inlinecrypt".  An exception is that
+files that are protected by a hardware-wrapped key can only be
+encrypted/decrypted by the inline encryption hardware and therefore
+can only be accessed when the "inlinecrypt" mount option is used.  For
+more information about hardware-wrapped keys, see below.
+
+Hardware-wrapped keys
+---------------------
+
+fscrypt supports using *hardware-wrapped keys* when the inline
+encryption hardware supports it.  Such keys are only present in kernel
+memory in wrapped (encrypted) form; they can only be unwrapped
+(decrypted) by the inline encryption hardware and are temporally bound
+to the current boot.  This prevents the keys from being compromised if
+kernel memory is leaked.  This is done without limiting the number of
+keys that can be used and while still allowing the execution of
+cryptographic tasks that are tied to the same key but can't use inline
+encryption hardware, e.g. filenames encryption.
+
+Note that hardware-wrapped keys aren't specific to fscrypt per se;
+they are a block layer feature (part of *blk-crypto*), which in
+principle could be used by other storage encryption systems such as
+dm-crypt.  For more details about hardware-wrapped keys, see the block
+layer documentation at :ref:`Documentation/block/inline-encryption.rst
+<hardware_wrapped_keys>`.  Below, we just focus on the details of how
+fscrypt can use hardware-wrapped keys.
+
+fscrypt supports hardware-wrapped keys by allowing the fscrypt master
+keys to be hardware-wrapped keys as an alternative to standard keys.
+To add a hardware-wrapped key with `FS_IOC_ADD_ENCRYPTION_KEY`_,
+userspace must specify FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED in the
+``flags`` field of struct fscrypt_add_key_arg and also in the
+``flags`` field of struct fscrypt_provisioning_key_payload when
+applicable.
+
+To specify that files will be protected by a hardware-wrapped key,
+userspace must specify FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY in the
+encryption policy.  (Note that this flag is somewhat redundant, as the
+encryption policy also contains the key identifier, and
+hardware-wrapped keys and standard keys will have different key
+identifiers.  However, it is sometimes helpful to make it explicit
+that an encryption policy is supposed to use a hardware-wrapped key.)
+
+Some limitations apply.  First, files protected by a hardware-wrapped
+key are tied to the system's inline encryption hardware.  Therefore
+they can only be accessed when the "inlinecrypt" mount option is used,
+and they can't be included in portable filesystem images.  Second,
+currently the hardware-wrapped key support is only compatible with
+`IV_INO_LBLK_64 policies`_ and `IV_INO_LBLK_32 policies`_, as it
+assumes that there is just one file contents encryption key per
+fscrypt master key rather than one per file.  Future work may address
+this limitation by passing per-file nonces down the storage stack to
+allow the hardware to derive per-file keys.
+
+Implementation-wise, to encrypt/decrypt the contents of files that are
+protected by a hardware-wrapped key, fscrypt uses blk-crypto,
+attaching the hardware-wrapped key to the bio crypt contexts.  As is
+the case with standard keys, the block layer will program the key into
+a keyslot when it isn't already in one.  However, when programming a
+hardware-wrapped key, the hardware doesn't program the given key
+directly into a keyslot but rather unwraps it (using the hardware's
+ephemeral wrapping key) and derives the inline encryption key from it.
+The inline encryption key is the key that actually gets programmed
+into a keyslot, and it is never exposed to software.
+
+However, fscrypt doesn't just do file contents encryption; it also
+uses its master keys to derive filenames encryption keys, key
+identifiers, and sometimes some more obscure types of subkeys such as
+dirhash keys.  So even with file contents encryption out of the
+picture, fscrypt still needs a raw key to work with.  To get such a
+key from a hardware-wrapped key, fscrypt asks the inline encryption
+hardware to derive a cryptographically isolated "software secret" from
+the hardware-wrapped key.  fscrypt uses this "software secret" to key
+its KDF to derive all subkeys other than file contents keys.
+
+Note that this implies that the hardware-wrapped key feature only
+protects the file contents encryption keys.  It doesn't protect other
+fscrypt subkeys such as filenames encryption keys.
 
 Implementation details
 ======================
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index cb25ef0cdf1f3..01e0a7d8177e9 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -20,8 +20,34 @@
 
 #define FSCRYPT_FILE_NONCE_SIZE	16
 
+/*
+ * Minimum size of an fscrypt master key.  Note: a longer key will be required
+ * if ciphers with a 256-bit security strength are used.  This is just the
+ * absolute minimum, which applies when only 128-bit encryption is used.
+ */
 #define FSCRYPT_MIN_KEY_SIZE	16
 
+/* Maximum size of a standard fscrypt master key */
+#define FSCRYPT_MAX_STANDARD_KEY_SIZE	64
+
+/* Maximum size of a hardware-wrapped fscrypt master key */
+#define FSCRYPT_MAX_HW_WRAPPED_KEY_SIZE	BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE
+
+/*
+ * Maximum size of an fscrypt master key across both key types.
+ * This should just use max(), but max() doesn't work in a struct definition.
+ */
+#define FSCRYPT_MAX_ANY_KEY_SIZE \
+	(FSCRYPT_MAX_HW_WRAPPED_KEY_SIZE > FSCRYPT_MAX_STANDARD_KEY_SIZE ? \
+	 FSCRYPT_MAX_HW_WRAPPED_KEY_SIZE : FSCRYPT_MAX_STANDARD_KEY_SIZE)
+
+/*
+ * FSCRYPT_MAX_KEY_SIZE is defined in the UAPI header, but the addition of
+ * hardware-wrapped keys has made it misleading as it's only for standard keys.
+ * Don't use it in kernel code; use one of the above constants instead.
+ */
+#undef FSCRYPT_MAX_KEY_SIZE
+
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
 
@@ -314,13 +340,16 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
  * outputs are unique and cryptographically isolated, i.e. knowledge of one
  * output doesn't reveal another.
  */
-#define HKDF_CONTEXT_KEY_IDENTIFIER	1 /* info=<empty>		*/
+#define HKDF_CONTEXT_KEY_IDENTIFIER_FOR_STANDARD_KEY \
+					1 /* info=<empty>		*/
 #define HKDF_CONTEXT_PER_FILE_ENC_KEY	2 /* info=file_nonce		*/
 #define HKDF_CONTEXT_DIRECT_KEY		3 /* info=mode_num		*/
 #define HKDF_CONTEXT_IV_INO_LBLK_64_KEY	4 /* info=mode_num||fs_uuid	*/
 #define HKDF_CONTEXT_DIRHASH_KEY	5 /* info=file_nonce		*/
 #define HKDF_CONTEXT_IV_INO_LBLK_32_KEY	6 /* info=mode_num||fs_uuid	*/
 #define HKDF_CONTEXT_INODE_HASH_KEY	7 /* info=<empty>		*/
+#define HKDF_CONTEXT_KEY_IDENTIFIER_FOR_HW_WRAPPED_KEY \
+					8 /* info=<empty>		*/
 
 int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
 			const u8 *info, unsigned int infolen,
@@ -340,10 +369,16 @@ fscrypt_using_inline_encryption(const struct fscrypt_info *ci)
 
 int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 				     const u8 *raw_key,
+				     unsigned int raw_key_size,
+				     bool is_hw_wrapped,
 				     const struct fscrypt_info *ci);
 
 void fscrypt_destroy_inline_crypt_key(struct fscrypt_prepared_key *prep_key);
 
+int fscrypt_derive_sw_secret(struct super_block *sb, const u8 *wrapped_key,
+			     unsigned int wrapped_key_size,
+			     u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+
 /*
  * Check whether the crypto transform or blk-crypto key has been allocated in
  * @prep_key, depending on which encryption implementation the file will use.
@@ -354,7 +389,7 @@ fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
 {
 	/*
 	 * The two smp_load_acquire()'s here pair with the smp_store_release()'s
-	 * in fscrypt_prepare_inline_crypt_key() and fscrypt_prepare_key().
+	 * in fscrypt_prepare_inline_crypt_key() and __fscrypt_prepare_key().
 	 * I.e., in some cases (namely, if this prep_key is a per-mode
 	 * encryption key) another task can publish blk_key or tfm concurrently,
 	 * executing a RELEASE barrier.  We need to use smp_load_acquire() here
@@ -380,7 +415,8 @@ fscrypt_using_inline_encryption(const struct fscrypt_info *ci)
 
 static inline int
 fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
-				 const u8 *raw_key,
+				 const u8 *raw_key, unsigned int raw_key_size,
+				 bool is_hw_wrapped,
 				 const struct fscrypt_info *ci)
 {
 	WARN_ON(1);
@@ -392,6 +428,15 @@ fscrypt_destroy_inline_crypt_key(struct fscrypt_prepared_key *prep_key)
 {
 }
 
+static inline int
+fscrypt_derive_sw_secret(struct super_block *sb, const u8 *wrapped_key,
+			 unsigned int wrapped_key_size,
+			 u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	fscrypt_warn(NULL, "kernel doesn't support hardware-wrapped keys");
+	return -EOPNOTSUPP;
+}
+
 static inline bool
 fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
 			const struct fscrypt_info *ci)
@@ -408,16 +453,38 @@ fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
 struct fscrypt_master_key_secret {
 
 	/*
-	 * For v2 policy keys: HKDF context keyed by this master key.
-	 * For v1 policy keys: not set (hkdf.hmac_tfm == NULL).
+	 * The KDF with which subkeys of this key can be derived.
+	 *
+	 * For v1 policy keys, this isn't applicable and won't be set.
+	 * Otherwise, this KDF will be keyed by this master key if
+	 * ->is_hw_wrapped=false, or by the "software secret" that hardware
+	 * derived from this master key if ->is_hw_wrapped=true.
 	 */
 	struct fscrypt_hkdf	hkdf;
 
-	/* Size of the raw key in bytes.  Set even if ->raw isn't set. */
+	/*
+	 * True if this key is a hardware-wrapped key; false if this key is a
+	 * standard key (i.e. a "software key").  For v1 policy keys this will
+	 * always be false, as v1 policy support is a legacy feature which
+	 * doesn't support newer functionality such as hardware-wrapped keys.
+	 */
+	bool			is_hw_wrapped;
+
+	/*
+	 * Size of the raw key in bytes.  This remains set even if ->raw was
+	 * zeroized due to no longer being needed.  I.e. we still remember the
+	 * size of the key even if we don't need to remember the key itself.
+	 */
 	u32			size;
 
-	/* For v1 policy keys: the raw key.  Wiped for v2 policy keys. */
-	u8			raw[FSCRYPT_MAX_KEY_SIZE];
+	/*
+	 * The raw key which userspace provided, when still needed.  This can be
+	 * either a standard key or a hardware-wrapped key, as indicated by
+	 * ->is_hw_wrapped.  In the case of a standard, v2 policy key, there is
+	 * no need to remember the raw key separately from ->hkdf so this field
+	 * will be zeroized as soon as ->hkdf is initialized.
+	 */
+	u8			raw[FSCRYPT_MAX_ANY_KEY_SIZE];
 
 } __randomize_layout;
 
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index 7607d18b35fc0..41e7c9b05c2aa 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -4,7 +4,9 @@
  * Function"), aka RFC 5869.  See also the original paper (Krawczyk 2010):
  * "Cryptographic Extraction and Key Derivation: The HKDF Scheme".
  *
- * This is used to derive keys from the fscrypt master keys.
+ * This is used to derive keys from the fscrypt master keys (or from the
+ * "software secrets" which hardware derives from the fscrypt master keys, in
+ * the case that the fscrypt master keys are hardware-wrapped keys).
  *
  * Copyright 2019 Google LLC
  */
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index ecb0cda469880..2268b35e1dd70 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/blk-crypto.h>
+#include <linux/blk-crypto-profile.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <linux/sched/mm.h>
@@ -68,6 +69,7 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 {
 	const struct inode *inode = ci->ci_inode;
 	struct super_block *sb = inode->i_sb;
+	unsigned int policy_flags = fscrypt_policy_flags(&ci->ci_policy);
 	struct blk_crypto_config crypto_cfg;
 	int num_devs;
 	struct request_queue **devs;
@@ -93,8 +95,7 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 	 * doesn't work with IV_INO_LBLK_32. For now, simply exclude
 	 * IV_INO_LBLK_32 with blocksize != PAGE_SIZE from inline encryption.
 	 */
-	if ((fscrypt_policy_flags(&ci->ci_policy) &
-	     FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) &&
+	if ((policy_flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) &&
 	    sb->s_blocksize != PAGE_SIZE)
 		return 0;
 
@@ -105,7 +106,9 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 	crypto_cfg.crypto_mode = ci->ci_mode->blk_crypto_mode;
 	crypto_cfg.data_unit_size = sb->s_blocksize;
 	crypto_cfg.dun_bytes = fscrypt_get_dun_bytes(ci);
-	crypto_cfg.key_type = BLK_CRYPTO_KEY_TYPE_STANDARD;
+	crypto_cfg.key_type =
+		(policy_flags & FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY) ?
+		BLK_CRYPTO_KEY_TYPE_HW_WRAPPED : BLK_CRYPTO_KEY_TYPE_STANDARD;
 	num_devs = fscrypt_get_num_devices(sb);
 	devs = kmalloc_array(num_devs, sizeof(*devs), GFP_KERNEL);
 	if (!devs)
@@ -126,11 +129,15 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 
 int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 				     const u8 *raw_key,
+				     unsigned int raw_key_size,
+				     bool is_hw_wrapped,
 				     const struct fscrypt_info *ci)
 {
 	const struct inode *inode = ci->ci_inode;
 	struct super_block *sb = inode->i_sb;
 	enum blk_crypto_mode_num crypto_mode = ci->ci_mode->blk_crypto_mode;
+	enum blk_crypto_key_type key_type = is_hw_wrapped ?
+		BLK_CRYPTO_KEY_TYPE_HW_WRAPPED : BLK_CRYPTO_KEY_TYPE_STANDARD;
 	int num_devs = fscrypt_get_num_devices(sb);
 	int queue_refs = 0;
 	struct fscrypt_blk_crypto_key *blk_key;
@@ -144,8 +151,8 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 	blk_key->num_devs = num_devs;
 	fscrypt_get_devices(sb, num_devs, blk_key->devs);
 
-	err = blk_crypto_init_key(&blk_key->base, raw_key, ci->ci_mode->keysize,
-				  BLK_CRYPTO_KEY_TYPE_STANDARD, crypto_mode,
+	err = blk_crypto_init_key(&blk_key->base, raw_key, raw_key_size,
+				  key_type, crypto_mode,
 				  fscrypt_get_dun_bytes(ci), sb->s_blocksize);
 	if (err) {
 		fscrypt_err(inode, "error %d initializing blk-crypto key", err);
@@ -205,6 +212,55 @@ void fscrypt_destroy_inline_crypt_key(struct fscrypt_prepared_key *prep_key)
 	}
 }
 
+/*
+ * Ask the inline encryption hardware to derive the software secret from a
+ * hardware-wrapped key.  Returns -EOPNOTSUPP if hardware-wrapped keys aren't
+ * supported on this filesystem or hardware.
+ */
+int fscrypt_derive_sw_secret(struct super_block *sb, const u8 *wrapped_key,
+			     unsigned int wrapped_key_size,
+			     u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	struct blk_crypto_profile *profile;
+	int num_devs;
+
+	/* The filesystem must be mounted with -o inlinecrypt */
+	if (!(sb->s_flags & SB_INLINECRYPT))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Hardware-wrapped keys might be specific to a particular storage
+	 * device, so for now we don't allow them to be used if the filesystem
+	 * uses block devices with different crypto profiles.  This way, there
+	 * is no ambiguity about which ->derive_sw_secret method to call.
+	 */
+	profile = bdev_get_queue(sb->s_bdev)->crypto_profile;
+	num_devs = fscrypt_get_num_devices(sb);
+	if (num_devs > 1) {
+		struct request_queue **devs =
+			kmalloc_array(num_devs, sizeof(*devs), GFP_KERNEL);
+		int i;
+
+		if (!devs)
+			return -ENOMEM;
+
+		fscrypt_get_devices(sb, num_devs, devs);
+
+		for (i = 0; i < num_devs; i++) {
+			if (devs[i]->crypto_profile != profile) {
+				fscrypt_warn(NULL,
+					     "unsupported multi-device configuration for hardware-wrapped keys");
+				kfree(devs);
+				return -EOPNOTSUPP;
+			}
+		}
+		kfree(devs);
+	}
+
+	return blk_crypto_derive_sw_secret(profile, wrapped_key,
+					   wrapped_key_size, sw_secret);
+}
+
 bool __fscrypt_inode_uses_inline_crypto(const struct inode *inode)
 {
 	return inode->i_crypt_info->ci_inlinecrypt;
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 0b3ffbb4faf4a..4d6223d348d48 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -103,11 +103,11 @@ static int fscrypt_user_key_instantiate(struct key *key,
 					struct key_preparsed_payload *prep)
 {
 	/*
-	 * We just charge FSCRYPT_MAX_KEY_SIZE bytes to the user's key quota for
-	 * each key, regardless of the exact key size.  The amount of memory
-	 * actually used is greater than the size of the raw key anyway.
+	 * We just charge FSCRYPT_MAX_STANDARD_KEY_SIZE bytes to the user's key
+	 * quota for each key, regardless of the exact key size.  The amount of
+	 * memory actually used is greater than the size of the raw key anyway.
 	 */
-	return key_payload_reserve(key, FSCRYPT_MAX_KEY_SIZE);
+	return key_payload_reserve(key, FSCRYPT_MAX_STANDARD_KEY_SIZE);
 }
 
 static void fscrypt_user_key_describe(const struct key *key, struct seq_file *m)
@@ -479,20 +479,45 @@ static int add_master_key(struct super_block *sb,
 	int err;
 
 	if (key_spec->type == FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER) {
-		err = fscrypt_init_hkdf(&secret->hkdf, secret->raw,
-					secret->size);
-		if (err)
-			return err;
+		u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE];
+		u8 *kdf_key = secret->raw;
+		unsigned int kdf_key_size = secret->size;
+		u8 keyid_kdf_ctx = HKDF_CONTEXT_KEY_IDENTIFIER_FOR_STANDARD_KEY;
 
 		/*
-		 * Now that the HKDF context is initialized, the raw key is no
-		 * longer needed.
+		 * For standard keys, the fscrypt master key is used directly as
+		 * the fscrypt KDF key.  For hardware-wrapped keys, we have to
+		 * pass the master key to the hardware to derive the KDF key,
+		 * which is then only used to derive non-file-contents subkeys.
+		 */
+		if (secret->is_hw_wrapped) {
+			err = fscrypt_derive_sw_secret(sb, secret->raw,
+						       secret->size, sw_secret);
+			if (err)
+				return err;
+			kdf_key = sw_secret;
+			kdf_key_size = sizeof(sw_secret);
+			/*
+			 * To avoid weird behavior if someone manages to
+			 * determine sw_secret and add it as a standard key,
+			 * ensure that hardware-wrapped keys and standard keys
+			 * will have different key identifiers by deriving their
+			 * key identifiers using different KDF contexts.
+			 */
+			keyid_kdf_ctx =
+				HKDF_CONTEXT_KEY_IDENTIFIER_FOR_HW_WRAPPED_KEY;
+		}
+		err = fscrypt_init_hkdf(&secret->hkdf, kdf_key, kdf_key_size);
+		/*
+		 * Now that the KDF context is initialized, the raw KDF key is
+		 * no longer needed.
 		 */
-		memzero_explicit(secret->raw, secret->size);
+		memzero_explicit(kdf_key, kdf_key_size);
+		if (err)
+			return err;
 
 		/* Calculate the key identifier */
-		err = fscrypt_hkdf_expand(&secret->hkdf,
-					  HKDF_CONTEXT_KEY_IDENTIFIER, NULL, 0,
+		err = fscrypt_hkdf_expand(&secret->hkdf, keyid_kdf_ctx, NULL, 0,
 					  key_spec->u.identifier,
 					  FSCRYPT_KEY_IDENTIFIER_SIZE);
 		if (err)
@@ -501,19 +526,36 @@ static int add_master_key(struct super_block *sb,
 	return do_add_master_key(sb, secret, key_spec);
 }
 
+/*
+ * Validate the size of an fscrypt master key being added.  Note that this is
+ * just an initial check, as we don't know which ciphers will be used yet.
+ * There is a stricter size check later when the key is actually used by a file.
+ */
+static inline bool fscrypt_valid_key_size(size_t size, u32 add_key_flags)
+{
+	u32 max_size = (add_key_flags & FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED) ?
+		       FSCRYPT_MAX_HW_WRAPPED_KEY_SIZE :
+		       FSCRYPT_MAX_STANDARD_KEY_SIZE;
+
+	return size >= FSCRYPT_MIN_KEY_SIZE && size <= max_size;
+}
+
 static int fscrypt_provisioning_key_preparse(struct key_preparsed_payload *prep)
 {
 	const struct fscrypt_provisioning_key_payload *payload = prep->data;
 
-	if (prep->datalen < sizeof(*payload) + FSCRYPT_MIN_KEY_SIZE ||
-	    prep->datalen > sizeof(*payload) + FSCRYPT_MAX_KEY_SIZE)
+	if (prep->datalen < sizeof(*payload))
+		return -EINVAL;
+
+	if (!fscrypt_valid_key_size(prep->datalen - sizeof(*payload),
+				    payload->flags))
 		return -EINVAL;
 
 	if (payload->type != FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR &&
 	    payload->type != FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER)
 		return -EINVAL;
 
-	if (payload->__reserved)
+	if (payload->flags & ~FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED)
 		return -EINVAL;
 
 	prep->payload.data[0] = kmemdup(payload, prep->datalen, GFP_KERNEL);
@@ -560,18 +602,18 @@ static struct key_type key_type_fscrypt_provisioning = {
  * Retrieve the raw key from the Linux keyring key specified by 'key_id', and
  * store it into 'secret'.
  *
- * The key must be of type "fscrypt-provisioning" and must have the field
- * fscrypt_provisioning_key_payload::type set to 'type', indicating that it's
- * only usable with fscrypt with the particular KDF version identified by
- * 'type'.  We don't use the "logon" key type because there's no way to
- * completely restrict the use of such keys; they can be used by any kernel API
- * that accepts "logon" keys and doesn't require a specific service prefix.
+ * The key must be of type "fscrypt-provisioning" and must have the 'type' and
+ * 'flags' field of the payload set to the given values, indicating that the key
+ * is intended for use for the specified purpose.  We don't use the "logon" key
+ * type because there's no way to completely restrict the use of such keys; they
+ * can be used by any kernel API that accepts "logon" keys and doesn't require a
+ * specific service prefix.
  *
  * The ability to specify the key via Linux keyring key is intended for cases
  * where userspace needs to re-add keys after the filesystem is unmounted and
  * re-mounted.  Most users should just provide the raw key directly instead.
  */
-static int get_keyring_key(u32 key_id, u32 type,
+static int get_keyring_key(u32 key_id, u32 type, u32 flags,
 			   struct fscrypt_master_key_secret *secret)
 {
 	key_ref_t ref;
@@ -588,8 +630,12 @@ static int get_keyring_key(u32 key_id, u32 type,
 		goto bad_key;
 	payload = key->payload.data[0];
 
-	/* Don't allow fscrypt v1 keys to be used as v2 keys and vice versa. */
-	if (payload->type != type)
+	/*
+	 * Don't allow fscrypt v1 keys to be used as v2 keys and vice versa.
+	 * Similarly, don't allow hardware-wrapped keys to be used as
+	 * non-hardware-wrapped keys and vice versa.
+	 */
+	if (payload->type != type || payload->flags != flags)
 		goto bad_key;
 
 	secret->size = key->datalen - sizeof(*payload);
@@ -655,15 +701,24 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 		return -EACCES;
 
 	memset(&secret, 0, sizeof(secret));
+
+	if (arg.flags) {
+		if (arg.flags & ~FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED)
+			return -EINVAL;
+		if (arg.key_spec.type != FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER)
+			return -EINVAL;
+		secret.is_hw_wrapped = true;
+	}
+
 	if (arg.key_id) {
 		if (arg.raw_size != 0)
 			return -EINVAL;
-		err = get_keyring_key(arg.key_id, arg.key_spec.type, &secret);
+		err = get_keyring_key(arg.key_id, arg.key_spec.type, arg.flags,
+				      &secret);
 		if (err)
 			goto out_wipe_secret;
 	} else {
-		if (arg.raw_size < FSCRYPT_MIN_KEY_SIZE ||
-		    arg.raw_size > FSCRYPT_MAX_KEY_SIZE)
+		if (!fscrypt_valid_key_size(arg.raw_size, arg.flags))
 			return -EINVAL;
 		secret.size = arg.raw_size;
 		err = -EFAULT;
@@ -696,15 +751,15 @@ EXPORT_SYMBOL_GPL(fscrypt_ioctl_add_key);
 int fscrypt_add_test_dummy_key(struct super_block *sb,
 			       struct fscrypt_key_specifier *key_spec)
 {
-	static u8 test_key[FSCRYPT_MAX_KEY_SIZE];
+	static u8 test_key[FSCRYPT_MAX_STANDARD_KEY_SIZE];
 	struct fscrypt_master_key_secret secret;
 	int err;
 
-	get_random_once(test_key, FSCRYPT_MAX_KEY_SIZE);
+	get_random_once(test_key, FSCRYPT_MAX_STANDARD_KEY_SIZE);
 
 	memset(&secret, 0, sizeof(secret));
-	secret.size = FSCRYPT_MAX_KEY_SIZE;
-	memcpy(secret.raw, test_key, FSCRYPT_MAX_KEY_SIZE);
+	secret.size = FSCRYPT_MAX_STANDARD_KEY_SIZE;
+	memcpy(secret.raw, test_key, FSCRYPT_MAX_STANDARD_KEY_SIZE);
 
 	err = add_master_key(sb, &secret, key_spec);
 	wipe_master_key_secret(&secret);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 89cd533a88bff..97ae31a054c24 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -122,16 +122,25 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 
 /*
  * Prepare the crypto transform object or blk-crypto key in @prep_key, given the
- * raw key, encryption mode, and flag indicating which encryption implementation
- * (fs-layer or blk-crypto) will be used.
+ * raw key, encryption mode (@ci->ci_mode), flag indicating which encryption
+ * implementation (fs-layer or blk-crypto) will be used (@ci->ci_inlinecrypt),
+ * and IV generation method (@ci->ci_policy.flags).  The raw key can be either a
+ * standard key or a hardware-wrapped key, as indicated by @is_hw_wrapped; it
+ * can only be a hardware-wrapped key if blk-crypto will be used.
  */
-int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
-			const u8 *raw_key, const struct fscrypt_info *ci)
+static int __fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
+				 const u8 *raw_key, unsigned int raw_key_size,
+				 bool is_hw_wrapped,
+				 const struct fscrypt_info *ci)
 {
 	struct crypto_skcipher *tfm;
 
 	if (fscrypt_using_inline_encryption(ci))
-		return fscrypt_prepare_inline_crypt_key(prep_key, raw_key, ci);
+		return fscrypt_prepare_inline_crypt_key(prep_key,
+				raw_key, raw_key_size, is_hw_wrapped, ci);
+
+	if (WARN_ON(is_hw_wrapped || raw_key_size != ci->ci_mode->keysize))
+		return -EINVAL;
 
 	tfm = fscrypt_allocate_skcipher(ci->ci_mode, raw_key, ci->ci_inode);
 	if (IS_ERR(tfm))
@@ -146,6 +155,13 @@ int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 	return 0;
 }
 
+int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
+			const u8 *raw_key, const struct fscrypt_info *ci)
+{
+	return __fscrypt_prepare_key(prep_key, raw_key, ci->ci_mode->keysize,
+				     false, ci);
+}
+
 /* Destroy a crypto transform object and/or blk-crypto key. */
 void fscrypt_destroy_prepared_key(struct fscrypt_prepared_key *prep_key)
 {
@@ -170,14 +186,29 @@ static int setup_per_mode_enc_key(struct fscrypt_info *ci,
 	struct fscrypt_mode *mode = ci->ci_mode;
 	const u8 mode_num = mode - fscrypt_modes;
 	struct fscrypt_prepared_key *prep_key;
-	u8 mode_key[FSCRYPT_MAX_KEY_SIZE];
+	u8 mode_key[FSCRYPT_MAX_STANDARD_KEY_SIZE];
 	u8 hkdf_info[sizeof(mode_num) + sizeof(sb->s_uuid)];
 	unsigned int hkdf_infolen = 0;
+	bool use_hw_wrapped_key = false;
 	int err;
 
 	if (WARN_ON(mode_num > FSCRYPT_MODE_MAX))
 		return -EINVAL;
 
+	if (mk->mk_secret.is_hw_wrapped && S_ISREG(inode->i_mode)) {
+		/* Using a hardware-wrapped key for file contents encryption */
+		if (!fscrypt_using_inline_encryption(ci)) {
+			if (sb->s_flags & SB_INLINECRYPT)
+				fscrypt_warn(ci->ci_inode,
+					     "Hardware-wrapped key required, but no suitable inline encryption hardware is available");
+			else
+				fscrypt_warn(ci->ci_inode,
+					     "Hardware-wrapped keys require inline encryption (-o inlinecrypt)");
+			return -EINVAL;
+		}
+		use_hw_wrapped_key = true;
+	}
+
 	prep_key = &keys[mode_num];
 	if (fscrypt_is_key_prepared(prep_key, ci)) {
 		ci->ci_enc_key = *prep_key;
@@ -189,6 +220,14 @@ static int setup_per_mode_enc_key(struct fscrypt_info *ci,
 	if (fscrypt_is_key_prepared(prep_key, ci))
 		goto done_unlock;
 
+	if (use_hw_wrapped_key) {
+		err = __fscrypt_prepare_key(prep_key, mk->mk_secret.raw,
+					    mk->mk_secret.size, true, ci);
+		if (err)
+			goto out_unlock;
+		goto done_unlock;
+	}
+
 	BUILD_BUG_ON(sizeof(mode_num) != 1);
 	BUILD_BUG_ON(sizeof(sb->s_uuid) != 16);
 	BUILD_BUG_ON(sizeof(hkdf_info) != 17);
@@ -311,6 +350,19 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 {
 	int err;
 
+	if (mk->mk_secret.is_hw_wrapped &&
+	    !(ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY)) {
+		fscrypt_warn(ci->ci_inode,
+			     "Key is hardware-wrapped but file isn't protected by a hardware-wrapped key");
+		return -EINVAL;
+	}
+	if ((ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY) &&
+	    !mk->mk_secret.is_hw_wrapped) {
+		fscrypt_warn(ci->ci_inode,
+			     "File is protected by a hardware-wrapped key, but key isn't hardware-wrapped");
+		return -EINVAL;
+	}
+
 	if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) {
 		/*
 		 * DIRECT_KEY: instead of deriving per-file encryption keys, the
@@ -337,7 +389,7 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
 		err = fscrypt_setup_iv_ino_lblk_32_key(ci, mk);
 	} else {
-		u8 derived_key[FSCRYPT_MAX_KEY_SIZE];
+		u8 derived_key[FSCRYPT_MAX_STANDARD_KEY_SIZE];
 
 		err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
 					  HKDF_CONTEXT_PER_FILE_ENC_KEY,
@@ -473,6 +525,14 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 
 	switch (ci->ci_policy.version) {
 	case FSCRYPT_POLICY_V1:
+		if (WARN_ON(mk->mk_secret.is_hw_wrapped)) {
+			/*
+			 * This should never happen, as adding a v1 policy key
+			 * that is hardware-wrapped isn't allowed.
+			 */
+			err = -EINVAL;
+			goto out_release_key;
+		}
 		err = fscrypt_setup_v1_file_key(ci, mk->mk_secret.raw);
 		break;
 	case FSCRYPT_POLICY_V2:
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 2762c53504323..b2f9031de2c0e 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -118,7 +118,8 @@ find_and_lock_process_key(const char *prefix,
 	payload = (const struct fscrypt_key *)ukp->data;
 
 	if (ukp->datalen != sizeof(struct fscrypt_key) ||
-	    payload->size < 1 || payload->size > FSCRYPT_MAX_KEY_SIZE) {
+	    payload->size < 1 ||
+	    payload->size > FSCRYPT_MAX_STANDARD_KEY_SIZE) {
 		fscrypt_warn(NULL,
 			     "key with description '%s' has invalid payload",
 			     key->description);
@@ -148,7 +149,7 @@ struct fscrypt_direct_key {
 	const struct fscrypt_mode	*dk_mode;
 	struct fscrypt_prepared_key	dk_key;
 	u8				dk_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
-	u8				dk_raw[FSCRYPT_MAX_KEY_SIZE];
+	u8				dk_raw[FSCRYPT_MAX_STANDARD_KEY_SIZE];
 };
 
 static void free_direct_key(struct fscrypt_direct_key *dk)
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index ed3d623724cdd..9e28b6ea6bff5 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -178,7 +178,8 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 	if (policy->flags & ~(FSCRYPT_POLICY_FLAGS_PAD_MASK |
 			      FSCRYPT_POLICY_FLAG_DIRECT_KEY |
 			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 |
-			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)) {
+			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32 |
+			      FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY)) {
 		fscrypt_warn(inode, "Unsupported encryption flags (0x%02x)",
 			     policy->flags);
 		return false;
@@ -193,6 +194,14 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 		return false;
 	}
 
+	if ((policy->flags & FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY) &&
+	    !(policy->flags & (FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 |
+			       FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))) {
+		fscrypt_warn(inode,
+			     "HW_WRAPPED_KEY flag can only be used with IV_INO_LBLK_64 or IV_INO_LBLK_32");
+		return false;
+	}
+
 	if ((policy->flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) &&
 	    !supported_direct_key_modes(inode, policy->contents_encryption_mode,
 					policy->filenames_encryption_mode))
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 9f4428be3e362..884c5bf526a05 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -20,6 +20,7 @@
 #define FSCRYPT_POLICY_FLAG_DIRECT_KEY		0x04
 #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64	0x08
 #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32	0x10
+#define FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY	0x20
 
 /* Encryption algorithms */
 #define FSCRYPT_MODE_AES_256_XTS		1
@@ -115,7 +116,7 @@ struct fscrypt_key_specifier {
  */
 struct fscrypt_provisioning_key_payload {
 	__u32 type;
-	__u32 __reserved;
+	__u32 flags;
 	__u8 raw[];
 };
 
@@ -124,7 +125,9 @@ struct fscrypt_add_key_arg {
 	struct fscrypt_key_specifier key_spec;
 	__u32 raw_size;
 	__u32 key_id;
-	__u32 __reserved[8];
+#define FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED			0x00000001
+	__u32 flags;
+	__u32 __reserved[7];
 	__u8 raw[];
 };
 
-- 
2.33.0

