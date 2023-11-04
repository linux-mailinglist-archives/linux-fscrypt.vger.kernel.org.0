Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52447E1139
	for <lists+linux-fscrypt@lfdr.de>; Sat,  4 Nov 2023 22:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjKDVRS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 4 Nov 2023 17:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjKDVRR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 4 Nov 2023 17:17:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F09B0;
        Sat,  4 Nov 2023 14:17:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C57EC433C8;
        Sat,  4 Nov 2023 21:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699132629;
        bh=amnqdzaRr5HWv3IVXjNJNbr2D/Ga92eQZ3W65cAVlr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHx9yV7Nvs+rmH01ST+2Re6qpvX5pDDFDrRbjZS3Fu07+mCz7HQLPzj6JMhNOYn2U
         G6b7lk1n/DknKz3Hc6MAGL7PmtTnBrplhoc6iz/FTK8EYAJZeFZlLN5hooYhZdfxzt
         jatDnCwxzU1DMWFq8xxNBvlLioBThI6Wl1yESlWFvb1rQ97nWsZbkXkswbVLemrRnm
         BsfEZ5p2GhJ9j2+MHF6WjSCHaDzzt6VIwUAIXKtFCrz3Mak11Wn/vefhh27IpY7kaU
         JFi75uJINZMNQmGkZt9TIw6ayGDZjns6lM5mwbWj948c2xWQ97hikkmSyiVl4/EAW1
         dDAHQ/+EYfQFQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     kernel-team@android.com, Israel Rukshin <israelr@nvidia.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Peter Griffin <peter.griffin@linaro.org>,
        Daniil Lunev <dlunev@chromium.org>
Subject: [RFC PATCH v8 4/4] fscrypt: add support for hardware-wrapped keys
Date:   Sat,  4 Nov 2023 14:12:59 -0700
Message-ID: <20231104211259.17448-5-ebiggers@kernel.org>
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

Add support for hardware-wrapped keys to fscrypt.  Such keys are
protected from certain attacks, such as cold boot attacks.  For more
information, see the "Hardware-wrapped keys" section of
Documentation/block/inline-encryption.rst.

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
it is only applicable to ext4 and f2fs.

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
 fs/crypto/fscrypt_private.h           |  71 ++++++++++--
 fs/crypto/hkdf.c                      |   4 +-
 fs/crypto/inline_crypt.c              |  46 ++++++--
 fs/crypto/keyring.c                   | 122 ++++++++++++++------
 fs/crypto/keysetup.c                  |  54 ++++++++-
 fs/crypto/keysetup_v1.c               |   5 +-
 fs/crypto/policy.c                    |  11 +-
 include/uapi/linux/fscrypt.h          |   7 +-
 9 files changed, 401 insertions(+), 73 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 1b84f818e574..08b499dd8e80 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -63,21 +63,21 @@ of holes (unallocated blocks which logically contain all zeroes) in
 files is not protected.
 
 fscrypt is not guaranteed to protect confidentiality or authenticity
 if an attacker is able to manipulate the filesystem offline prior to
 an authorized user later accessing the filesystem.
 
 Online attacks
 --------------
 
 fscrypt (and storage encryption in general) can only provide limited
-protection, if any at all, against online attacks.  In detail:
+protection against online attacks.  In detail:
 
 Side-channel attacks
 ~~~~~~~~~~~~~~~~~~~~
 
 fscrypt is only resistant to side-channel attacks, such as timing or
 electromagnetic attacks, to the extent that the underlying Linux
 Cryptographic API algorithms or inline encryption hardware are.  If a
 vulnerable algorithm is used, such as a table-based implementation of
 AES, it may be possible for an attacker to mount a side channel attack
 against the online system.  Side channel attacks may also be mounted
@@ -92,30 +92,37 @@ system.  Instead, existing access control mechanisms such as file mode
 bits, POSIX ACLs, LSMs, or namespaces should be used for this purpose.
 
 (For the reasoning behind this, understand that while the key is
 added, the confidentiality of the data, from the perspective of the
 system itself, is *not* protected by the mathematical properties of
 encryption but rather only by the correctness of the kernel.
 Therefore, any encryption-specific access control checks would merely
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
 encryption key from kernel memory.  If it does so, it will also try to
 evict all cached inodes which had been "unlocked" using the key,
 thereby wiping their per-file keys and making them once again appear
 "locked", i.e. in ciphertext or encrypted form.
 
 However, these ioctls have some limitations:
 
@@ -138,20 +145,38 @@ However, these ioctls have some limitations:
   caches are freed but not wiped.  Therefore, portions thereof may be
   recoverable from freed memory, even after the corresponding key(s)
   were wiped.  To partially solve this, you can set
   CONFIG_PAGE_POISONING=y in your kernel config and add page_poison=1
   to your kernel command line.  However, this has a performance cost.
 
 - Secret keys might still exist in CPU registers, in crypto
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
 
 v1 encryption policies have some weaknesses with respect to online
 attacks:
 
 - There is no verification that the provided master key is correct.
   Therefore, a malicious user can temporarily associate the wrong key
   with another user's encrypted files to which they have read-only
   access.  Because of filesystem caching, the wrong key will then be
@@ -164,20 +189,25 @@ attacks:
 
 - Non-root users cannot securely remove encryption keys.
 
 All the above problems are fixed with v2 encryption policies.  For
 this reason among others, it is recommended to use v2 encryption
 policies on all new encrypted directories.
 
 Key hierarchy
 =============
 
+Note: this section assumes the use of standard keys (i.e. "software
+keys") rather than hardware-wrapped keys.  The use of hardware-wrapped
+keys modifies the key hierarchy slightly.  For details, see the
+`Hardware-wrapped keys`_ section.
+
 Master Keys
 -----------
 
 Each encrypted directory tree is protected by a *master key*.  Master
 keys can be up to 64 bytes long, and must be at least as long as the
 greater of the security strength of the contents and filenames
 encryption modes being used.  For example, if any AES-256 mode is
 used, the master key must be at least 256 bits, i.e. 32 bytes.  A
 stricter requirement applies if the key is used by a v1 encryption
 policy and AES-256-XTS is used; such keys must be 64 bytes.
@@ -604,20 +634,22 @@ This structure must be initialized as follows:
 - ``flags`` contains optional flags from ``<linux/fscrypt.h>``:
 
   - FSCRYPT_POLICY_FLAGS_PAD_*: The amount of NUL padding to use when
     encrypting filenames.  If unsure, use FSCRYPT_POLICY_FLAGS_PAD_32
     (0x3).
   - FSCRYPT_POLICY_FLAG_DIRECT_KEY: See `DIRECT_KEY policies`_.
   - FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64: See `IV_INO_LBLK_64
     policies`_.
   - FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32: See `IV_INO_LBLK_32
     policies`_.
+  - FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY: This flag denotes that this
+    policy uses a hardware-wrapped key.  See `Hardware-wrapped keys`_.
 
   v1 encryption policies only support the PAD_* and DIRECT_KEY flags.
   The other flags are only supported by v2 encryption policies.
 
   The DIRECT_KEY, IV_INO_LBLK_64, and IV_INO_LBLK_32 flags are
   mutually exclusive.
 
 - ``log2_data_unit_size`` is the log2 of the data unit size in bytes,
   or 0 to select the default data unit size.  The data unit size is
   the granularity of file contents encryption.  For example, setting
@@ -826,40 +858,41 @@ The FS_IOC_ADD_ENCRYPTION_KEY ioctl adds a master encryption key to
 the filesystem, making all files on the filesystem which were
 encrypted using that key appear "unlocked", i.e. in plaintext form.
 It can be executed on any file or directory on the target filesystem,
 but using the filesystem's root directory is recommended.  It takes in
 a pointer to struct fscrypt_add_key_arg, defined as follows::
 
     struct fscrypt_add_key_arg {
             struct fscrypt_key_specifier key_spec;
             __u32 raw_size;
             __u32 key_id;
-            __u32 __reserved[8];
+            __u32 flags;
+            __u32 __reserved[7];
             __u8 raw[];
     };
 
     #define FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR        1
     #define FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER        2
 
     struct fscrypt_key_specifier {
             __u32 type;     /* one of FSCRYPT_KEY_SPEC_TYPE_* */
             __u32 __reserved;
             union {
                     __u8 __reserved[32]; /* reserve some extra space */
                     __u8 descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
                     __u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
             } u;
     };
 
     struct fscrypt_provisioning_key_payload {
             __u32 type;
-            __u32 __reserved;
+            __u32 flags;
             __u8 raw[];
     };
 
 struct fscrypt_add_key_arg must be zeroed, then initialized
 as follows:
 
 - If the key is being added for use by v1 encryption policies, then
   ``key_spec.type`` must contain FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR, and
   ``key_spec.u.descriptor`` must contain the descriptor of the key
   being added, corresponding to the value in the
@@ -873,20 +906,26 @@ as follows:
   an *output* field which the kernel fills in with a cryptographic
   hash of the key.  To add this type of key, the calling process does
   not need any privileges.  However, the number of keys that can be
   added is limited by the user's quota for the keyrings service (see
   ``Documentation/security/keys/core.rst``).
 
 - ``raw_size`` must be the size of the ``raw`` key provided, in bytes.
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
   struct fscrypt_provisioning_key_payload whose ``raw`` field contains
   the raw key and whose ``type`` field matches ``key_spec.type``.
   Since ``raw`` is variable-length, the total size of this key's
   payload must be ``sizeof(struct fscrypt_provisioning_key_payload)``
   plus the raw key size.  The process must have Search permission on
   this key.
 
@@ -914,32 +953,36 @@ must still be provided, as a proof of knowledge).
 
 FS_IOC_ADD_ENCRYPTION_KEY returns 0 if either the key or a claim to
 the key was either added or already exists.
 
 FS_IOC_ADD_ENCRYPTION_KEY can fail with the following errors:
 
 - ``EACCES``: FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR was specified, but the
   caller does not have the CAP_SYS_ADMIN capability in the initial
   user namespace; or the raw key was specified by Linux key ID but the
   process lacks Search permission on the key.
+- ``EBADMSG``: FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED was specified, but the
+  key isn't a valid hardware-wrapped key
 - ``EDQUOT``: the key quota for this user would be exceeded by adding
   the key
 - ``EINVAL``: invalid key size or key specifier type, or reserved bits
   were set
 - ``EKEYREJECTED``: the raw key was specified by Linux key ID, but the
   key has the wrong type
 - ``ENOKEY``: the raw key was specified by Linux key ID, but no key
   exists with that ID
 - ``ENOTTY``: this type of filesystem does not implement encryption
 - ``EOPNOTSUPP``: the kernel was not configured with encryption
   support for this filesystem, or the filesystem superblock has not
-  had encryption enabled on it
+  had encryption enabled on it, or FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED was
+  specified but the filesystem and/or the hardware doesn't support
+  hardware-wrapped keys
 
 Legacy method
 ~~~~~~~~~~~~~
 
 For v1 encryption policies, a master encryption key can also be
 provided by adding it to a process-subscribed keyring, e.g. to a
 session keyring, or to a user keyring if the user keyring is linked
 into the session keyring.
 
 This method is deprecated (and not supported for v2 encryption
@@ -988,23 +1031,22 @@ Two ioctls are available for removing a key that was added by
 
 - `FS_IOC_REMOVE_ENCRYPTION_KEY`_
 - `FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS`_
 
 These two ioctls differ only in cases where v2 policy keys are added
 or removed by non-root users.
 
 These ioctls don't work on keys that were added via the legacy
 process-subscribed keyrings mechanism.
 
-Before using these ioctls, read the `Kernel memory compromise`_
-section for a discussion of the security goals and limitations of
-these ioctls.
+Before using these ioctls, read the `Online attacks`_ section for a
+discussion of the security goals and limitations of these ioctls.
 
 FS_IOC_REMOVE_ENCRYPTION_KEY
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 The FS_IOC_REMOVE_ENCRYPTION_KEY ioctl removes a claim to a master
 encryption key from the filesystem, and possibly removes the key
 itself.  It can be executed on any file or directory on the target
 filesystem, but using the filesystem's root directory is recommended.
 It takes in a pointer to struct fscrypt_remove_key_arg, defined
 as follows::
@@ -1310,29 +1352,107 @@ contents.  To enable this, set CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y in
 the kernel configuration, and specify the "inlinecrypt" mount option
 when mounting the filesystem.
 
 Note that the "inlinecrypt" mount option just specifies to use inline
 encryption when possible; it doesn't force its use.  fscrypt will
 still fall back to using the kernel crypto API on files where the
 inline encryption hardware doesn't have the needed crypto capabilities
 (e.g. support for the needed encryption algorithm and data unit size)
 and where blk-crypto-fallback is unusable.  (For blk-crypto-fallback
 to be usable, it must be enabled in the kernel configuration with
-CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y.)
+CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y, and the file must be
+protected by a standard key rather than a hardware-wrapped key.)
 
 Currently fscrypt always uses the filesystem block size (which is
 usually 4096 bytes) as the data unit size.  Therefore, it can only use
 inline encryption hardware that supports that data unit size.
 
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
+Note that hardware-wrapped keys aren't specific to fscrypt; they are a
+block layer feature (part of *blk-crypto*).  For more details about
+hardware-wrapped keys, see the block layer documentation at
+:ref:`Documentation/block/inline-encryption.rst
+<hardware_wrapped_keys>`.  Below, we just focus on the details of how
+fscrypt can use hardware-wrapped keys.
+
+fscrypt supports hardware-wrapped keys by allowing the fscrypt master
+keys to be hardware-wrapped keys as an alternative to standard keys.
+To add a hardware-wrapped key with `FS_IOC_ADD_ENCRYPTION_KEY`_,
+userspace must specify FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED in the
+``flags`` field of struct fscrypt_add_key_arg and also in the
+``flags`` field of struct fscrypt_provisioning_key_payload when
+applicable.  The key must be in ephemerally-wrapped form, not
+long-term wrapped form.
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
 
 Direct I/O support
 ==================
 
 For direct I/O on an encrypted file to work, the following conditions
 must be met (in addition to the conditions for direct I/O on an
 unencrypted file):
 
 * The file must be using inline encryption.  Usually this means that
   the filesystem must be mounted with ``-o inlinecrypt`` and inline
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 1892356cf924..57c5f3a7f48a 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -20,20 +20,41 @@
 
 #define FSCRYPT_FILE_NONCE_SIZE	16
 
 /*
  * Minimum size of an fscrypt master key.  Note: a longer key will be required
  * if ciphers with a 256-bit security strength are used.  This is just the
  * absolute minimum, which applies when only 128-bit encryption is used.
  */
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
 
 /* Keep this in sync with include/uapi/linux/fscrypt.h */
 #define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
 
 struct fscrypt_context_v1 {
 	u8 version; /* FSCRYPT_CONTEXT_V1 */
 	u8 contents_encryption_mode;
 	u8 filenames_encryption_mode;
@@ -351,51 +372,59 @@ struct fscrypt_hkdf {
 int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 		      unsigned int master_key_size);
 
 /*
  * The list of contexts in which fscrypt uses HKDF.  These values are used as
  * the first byte of the HKDF application-specific info string to guarantee that
  * info strings are never repeated between contexts.  This ensures that all HKDF
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
 			u8 *okm, unsigned int okmlen);
 
 void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf);
 
 /* inline_crypt.c */
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci);
 
 static inline bool
 fscrypt_using_inline_encryption(const struct fscrypt_inode_info *ci)
 {
 	return ci->ci_inlinecrypt;
 }
 
 int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
-				     const u8 *raw_key,
+				     const u8 *raw_key, size_t raw_key_size,
+				     bool is_hw_wrapped,
 				     const struct fscrypt_inode_info *ci);
 
 void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
 				      struct fscrypt_prepared_key *prep_key);
 
+int fscrypt_derive_sw_secret(struct super_block *sb,
+			     const u8 *wrapped_key, size_t wrapped_key_size,
+			     u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+
 /*
  * Check whether the crypto transform or blk-crypto key has been allocated in
  * @prep_key, depending on which encryption implementation the file will use.
  */
 static inline bool
 fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
 			const struct fscrypt_inode_info *ci)
 {
 	/*
 	 * The two smp_load_acquire()'s here pair with the smp_store_release()'s
@@ -418,63 +447,91 @@ static inline int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci)
 }
 
 static inline bool
 fscrypt_using_inline_encryption(const struct fscrypt_inode_info *ci)
 {
 	return false;
 }
 
 static inline int
 fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
-				 const u8 *raw_key,
+				 const u8 *raw_key, size_t raw_key_size,
+				 bool is_hw_wrapped,
 				 const struct fscrypt_inode_info *ci)
 {
 	WARN_ON_ONCE(1);
 	return -EOPNOTSUPP;
 }
 
 static inline void
 fscrypt_destroy_inline_crypt_key(struct super_block *sb,
 				 struct fscrypt_prepared_key *prep_key)
 {
 }
 
+static inline int
+fscrypt_derive_sw_secret(struct super_block *sb,
+			 const u8 *wrapped_key, size_t wrapped_key_size,
+			 u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	fscrypt_warn(NULL, "kernel doesn't support hardware-wrapped keys");
+	return -EOPNOTSUPP;
+}
+
 static inline bool
 fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
 			const struct fscrypt_inode_info *ci)
 {
 	return smp_load_acquire(&prep_key->tfm) != NULL;
 }
 #endif /* !CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
 /* keyring.c */
 
 /*
  * fscrypt_master_key_secret - secret key material of an in-use master key
  */
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
 
+	/*
+	 * True if this key is a hardware-wrapped key; false if this key is a
+	 * standard key (i.e. a "software key").  For v1 policy keys this will
+	 * always be false, as v1 policy support is a legacy feature which
+	 * doesn't support newer functionality such as hardware-wrapped keys.
+	 */
+	bool			is_hw_wrapped;
+
 	/*
 	 * Size of the raw key in bytes.  This remains set even if ->raw was
 	 * zeroized due to no longer being needed.  I.e. we still remember the
 	 * size of the key even if we don't need to remember the key itself.
 	 */
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
 
 /*
  * fscrypt_master_key - an in-use master key
  *
  * This represents a master encryption key which has been added to the
  * filesystem.  There are three high-level states that a key can be in:
  *
  * FSCRYPT_KEY_STATUS_PRESENT
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index 5a384dad2c72..7e007810e434 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -1,17 +1,19 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Implementation of HKDF ("HMAC-based Extract-and-Expand Key Derivation
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
 
 #include <crypto/hash.h>
 #include <crypto/sha2.h>
 
 #include "fscrypt_private.h"
 
 /*
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 821a800c9a89..79b338f824b1 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -86,20 +86,21 @@ static void fscrypt_log_blk_crypto_impl(struct fscrypt_mode *mode,
 				mode->friendly_name);
 		}
 	}
 }
 
 /* Enable inline encryption for this file if supported. */
 int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci)
 {
 	const struct inode *inode = ci->ci_inode;
 	struct super_block *sb = inode->i_sb;
+	unsigned int policy_flags = fscrypt_policy_flags(&ci->ci_policy);
 	struct blk_crypto_config crypto_cfg;
 	struct block_device **devs;
 	unsigned int num_devs;
 	unsigned int i;
 
 	/* The file must need contents encryption, not filenames encryption */
 	if (!S_ISREG(inode->i_mode))
 		return 0;
 
 	/* The crypto mode must have a blk-crypto counterpart */
@@ -111,72 +112,75 @@ int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci)
 		return 0;
 
 	/*
 	 * When a page contains multiple logically contiguous filesystem blocks,
 	 * some filesystem code only calls fscrypt_mergeable_bio() for the first
 	 * block in the page. This is fine for most of fscrypt's IV generation
 	 * strategies, where contiguous blocks imply contiguous IVs. But it
 	 * doesn't work with IV_INO_LBLK_32. For now, simply exclude
 	 * IV_INO_LBLK_32 with blocksize != PAGE_SIZE from inline encryption.
 	 */
-	if ((fscrypt_policy_flags(&ci->ci_policy) &
-	     FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) &&
+	if ((policy_flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) &&
 	    sb->s_blocksize != PAGE_SIZE)
 		return 0;
 
 	/*
 	 * On all the filesystem's block devices, blk-crypto must support the
 	 * crypto configuration that the file would use.
 	 */
 	crypto_cfg.crypto_mode = ci->ci_mode->blk_crypto_mode;
 	crypto_cfg.data_unit_size = 1U << ci->ci_data_unit_bits;
 	crypto_cfg.dun_bytes = fscrypt_get_dun_bytes(ci);
-	crypto_cfg.key_type = BLK_CRYPTO_KEY_TYPE_STANDARD;
+	crypto_cfg.key_type =
+		(policy_flags & FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY) ?
+		BLK_CRYPTO_KEY_TYPE_HW_WRAPPED : BLK_CRYPTO_KEY_TYPE_STANDARD;
 
 	devs = fscrypt_get_devices(sb, &num_devs);
 	if (IS_ERR(devs))
 		return PTR_ERR(devs);
 
 	for (i = 0; i < num_devs; i++) {
 		if (!blk_crypto_config_supported(devs[i], &crypto_cfg))
 			goto out_free_devs;
 	}
 
 	fscrypt_log_blk_crypto_impl(ci->ci_mode, devs, num_devs, &crypto_cfg);
 
 	ci->ci_inlinecrypt = true;
 out_free_devs:
 	kfree(devs);
 
 	return 0;
 }
 
 int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
-				     const u8 *raw_key,
+				     const u8 *raw_key, size_t raw_key_size,
+				     bool is_hw_wrapped,
 				     const struct fscrypt_inode_info *ci)
 {
 	const struct inode *inode = ci->ci_inode;
 	struct super_block *sb = inode->i_sb;
 	enum blk_crypto_mode_num crypto_mode = ci->ci_mode->blk_crypto_mode;
+	enum blk_crypto_key_type key_type = is_hw_wrapped ?
+		BLK_CRYPTO_KEY_TYPE_HW_WRAPPED : BLK_CRYPTO_KEY_TYPE_STANDARD;
 	struct blk_crypto_key *blk_key;
 	struct block_device **devs;
 	unsigned int num_devs;
 	unsigned int i;
 	int err;
 
 	blk_key = kmalloc(sizeof(*blk_key), GFP_KERNEL);
 	if (!blk_key)
 		return -ENOMEM;
 
-	err = blk_crypto_init_key(blk_key, raw_key, ci->ci_mode->keysize,
-				  BLK_CRYPTO_KEY_TYPE_STANDARD, crypto_mode,
-				  fscrypt_get_dun_bytes(ci),
+	err = blk_crypto_init_key(blk_key, raw_key, raw_key_size, key_type,
+				  crypto_mode, fscrypt_get_dun_bytes(ci),
 				  1U << ci->ci_data_unit_bits);
 	if (err) {
 		fscrypt_err(inode, "error %d initializing blk-crypto key", err);
 		goto fail;
 	}
 
 	/* Start using blk-crypto on all the filesystem's block devices. */
 	devs = fscrypt_get_devices(sb, &num_devs);
 	if (IS_ERR(devs)) {
 		err = PTR_ERR(devs);
@@ -221,20 +225,48 @@ void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
 	/* Evict the key from all the filesystem's block devices. */
 	devs = fscrypt_get_devices(sb, &num_devs);
 	if (!IS_ERR(devs)) {
 		for (i = 0; i < num_devs; i++)
 			blk_crypto_evict_key(devs[i], blk_key);
 		kfree(devs);
 	}
 	kfree_sensitive(blk_key);
 }
 
+/*
+ * Ask the inline encryption hardware to derive the software secret from a
+ * hardware-wrapped key.  Returns -EOPNOTSUPP if hardware-wrapped keys aren't
+ * supported on this filesystem or hardware.
+ */
+int fscrypt_derive_sw_secret(struct super_block *sb,
+			     const u8 *wrapped_key, size_t wrapped_key_size,
+			     u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	int err;
+
+	/* The filesystem must be mounted with -o inlinecrypt. */
+	if (!(sb->s_flags & SB_INLINECRYPT)) {
+		fscrypt_warn(NULL,
+			     "%s: filesystem not mounted with inlinecrypt\n",
+			     sb->s_id);
+		return -EOPNOTSUPP;
+	}
+
+	err = blk_crypto_derive_sw_secret(sb->s_bdev, wrapped_key,
+					  wrapped_key_size, sw_secret);
+	if (err == -EOPNOTSUPP)
+		fscrypt_warn(NULL,
+			     "%s: block device doesn't support hardware-wrapped keys\n",
+			     sb->s_id);
+	return err;
+}
+
 bool __fscrypt_inode_uses_inline_crypto(const struct inode *inode)
 {
 	return inode->i_crypt_info->ci_inlinecrypt;
 }
 EXPORT_SYMBOL_GPL(__fscrypt_inode_uses_inline_crypto);
 
 static void fscrypt_generate_dun(const struct fscrypt_inode_info *ci,
 				 u64 lblk_num,
 				 u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE])
 {
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index f34a9b0b9e92..cd371eaa8a01 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -137,25 +137,25 @@ static inline bool valid_key_spec(const struct fscrypt_key_specifier *spec)
 {
 	if (spec->__reserved)
 		return false;
 	return master_key_spec_len(spec) != 0;
 }
 
 static int fscrypt_user_key_instantiate(struct key *key,
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
 {
 	seq_puts(m, key->description);
 }
 
 /*
  * Type of key in ->mk_users.  Each key of this type represents a particular
  * user who has added a particular master key.
@@ -546,55 +546,97 @@ static int do_add_master_key(struct super_block *sb,
 	return err;
 }
 
 static int add_master_key(struct super_block *sb,
 			  struct fscrypt_master_key_secret *secret,
 			  struct fscrypt_key_specifier *key_spec)
 {
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
 			return err;
 	}
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
 	if (!prep->payload.data[0])
 		return -ENOMEM;
 
 	prep->quotalen = prep->datalen;
 	return 0;
 }
 
@@ -627,50 +669,54 @@ static struct key_type key_type_fscrypt_provisioning = {
 	.free_preparse		= fscrypt_provisioning_key_free_preparse,
 	.instantiate		= generic_key_instantiate,
 	.describe		= fscrypt_provisioning_key_describe,
 	.destroy		= fscrypt_provisioning_key_destroy,
 };
 
 /*
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
 	struct key *key;
 	const struct fscrypt_provisioning_key_payload *payload;
 	int err;
 
 	ref = lookup_user_key(key_id, 0, KEY_NEED_SEARCH);
 	if (IS_ERR(ref))
 		return PTR_ERR(ref);
 	key = key_ref_to_ptr(ref);
 
 	if (key->type != &key_type_fscrypt_provisioning)
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
 	memcpy(secret->raw, payload->raw, secret->size);
 	err = 0;
 	goto out_put;
 
 bad_key:
 	err = -EKEYREJECTED;
 out_put:
@@ -722,29 +768,38 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 	/*
 	 * Only root can add keys that are identified by an arbitrary descriptor
 	 * rather than by a cryptographic hash --- since otherwise a malicious
 	 * user could add the wrong key.
 	 */
 	if (arg.key_spec.type == FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR &&
 	    !capable(CAP_SYS_ADMIN))
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
 		if (copy_from_user(secret.raw, uarg->raw, secret.size))
 			goto out_wipe_secret;
 	}
 
 	err = add_master_key(sb, &secret, &arg.key_spec);
 	if (err)
 		goto out_wipe_secret;
@@ -758,41 +813,42 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 	err = 0;
 out_wipe_secret:
 	wipe_master_key_secret(&secret);
 	return err;
 }
 EXPORT_SYMBOL_GPL(fscrypt_ioctl_add_key);
 
 static void
 fscrypt_get_test_dummy_secret(struct fscrypt_master_key_secret *secret)
 {
-	static u8 test_key[FSCRYPT_MAX_KEY_SIZE];
+	static u8 test_key[FSCRYPT_MAX_STANDARD_KEY_SIZE];
 
-	get_random_once(test_key, FSCRYPT_MAX_KEY_SIZE);
+	get_random_once(test_key, sizeof(test_key));
 
 	memset(secret, 0, sizeof(*secret));
-	secret->size = FSCRYPT_MAX_KEY_SIZE;
-	memcpy(secret->raw, test_key, FSCRYPT_MAX_KEY_SIZE);
+	secret->size = sizeof(test_key);
+	memcpy(secret->raw, test_key, sizeof(test_key));
 }
 
 int fscrypt_get_test_dummy_key_identifier(
 				u8 key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE])
 {
 	struct fscrypt_master_key_secret secret;
 	int err;
 
 	fscrypt_get_test_dummy_secret(&secret);
 
 	err = fscrypt_init_hkdf(&secret.hkdf, secret.raw, secret.size);
 	if (err)
 		goto out;
-	err = fscrypt_hkdf_expand(&secret.hkdf, HKDF_CONTEXT_KEY_IDENTIFIER,
+	err = fscrypt_hkdf_expand(&secret.hkdf,
+				  HKDF_CONTEXT_KEY_IDENTIFIER_FOR_STANDARD_KEY,
 				  NULL, 0, key_identifier,
 				  FSCRYPT_KEY_IDENTIFIER_SIZE);
 out:
 	wipe_master_key_secret(&secret);
 	return err;
 }
 
 /**
  * fscrypt_add_test_dummy_key() - add the test dummy encryption key
  * @sb: the filesystem instance to add the key to
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index d71f7c799e79..2cff1f840d2d 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -146,21 +146,23 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
  * raw key, encryption mode (@ci->ci_mode), flag indicating which encryption
  * implementation (fs-layer or blk-crypto) will be used (@ci->ci_inlinecrypt),
  * and IV generation method (@ci->ci_policy.flags).
  */
 int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 			const u8 *raw_key, const struct fscrypt_inode_info *ci)
 {
 	struct crypto_skcipher *tfm;
 
 	if (fscrypt_using_inline_encryption(ci))
-		return fscrypt_prepare_inline_crypt_key(prep_key, raw_key, ci);
+		return fscrypt_prepare_inline_crypt_key(prep_key, raw_key,
+							ci->ci_mode->keysize,
+							false, ci);
 
 	tfm = fscrypt_allocate_skcipher(ci->ci_mode, raw_key, ci->ci_inode);
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 	/*
 	 * Pairs with the smp_load_acquire() in fscrypt_is_key_prepared().
 	 * I.e., here we publish ->tfm with a RELEASE barrier so that
 	 * concurrent tasks can ACQUIRE it.  Note that this concurrency is only
 	 * possible for per-mode keys, not for per-file keys.
 	 */
@@ -188,39 +190,64 @@ int fscrypt_set_per_file_enc_key(struct fscrypt_inode_info *ci,
 static int setup_per_mode_enc_key(struct fscrypt_inode_info *ci,
 				  struct fscrypt_master_key *mk,
 				  struct fscrypt_prepared_key *keys,
 				  u8 hkdf_context, bool include_fs_uuid)
 {
 	const struct inode *inode = ci->ci_inode;
 	const struct super_block *sb = inode->i_sb;
 	struct fscrypt_mode *mode = ci->ci_mode;
 	const u8 mode_num = mode - fscrypt_modes;
 	struct fscrypt_prepared_key *prep_key;
-	u8 mode_key[FSCRYPT_MAX_KEY_SIZE];
+	u8 mode_key[FSCRYPT_MAX_STANDARD_KEY_SIZE];
 	u8 hkdf_info[sizeof(mode_num) + sizeof(sb->s_uuid)];
 	unsigned int hkdf_infolen = 0;
+	bool use_hw_wrapped_key = false;
 	int err;
 
 	if (WARN_ON_ONCE(mode_num > FSCRYPT_MODE_MAX))
 		return -EINVAL;
 
+	if (mk->mk_secret.is_hw_wrapped && S_ISREG(inode->i_mode)) {
+		/* Using a hardware-wrapped key for file contents encryption */
+		if (!fscrypt_using_inline_encryption(ci)) {
+			if (sb->s_flags & SB_INLINECRYPT)
+				fscrypt_warn(ci->ci_inode,
+					     "Hardware-wrapped key required, but no suitable inline encryption capabilities are available");
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
 		return 0;
 	}
 
 	mutex_lock(&fscrypt_mode_key_setup_mutex);
 
 	if (fscrypt_is_key_prepared(prep_key, ci))
 		goto done_unlock;
 
+	if (use_hw_wrapped_key) {
+		err = fscrypt_prepare_inline_crypt_key(prep_key,
+						       mk->mk_secret.raw,
+						       mk->mk_secret.size, true,
+						       ci);
+		if (err)
+			goto out_unlock;
+		goto done_unlock;
+	}
+
 	BUILD_BUG_ON(sizeof(mode_num) != 1);
 	BUILD_BUG_ON(sizeof(sb->s_uuid) != 16);
 	BUILD_BUG_ON(sizeof(hkdf_info) != 17);
 	hkdf_info[hkdf_infolen++] = mode_num;
 	if (include_fs_uuid) {
 		memcpy(&hkdf_info[hkdf_infolen], &sb->s_uuid,
 		       sizeof(sb->s_uuid));
 		hkdf_infolen += sizeof(sb->s_uuid);
 	}
 	err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
@@ -329,20 +356,33 @@ static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_inode_info *ci,
 		fscrypt_hash_inode_number(ci, mk);
 	return 0;
 }
 
 static int fscrypt_setup_v2_file_key(struct fscrypt_inode_info *ci,
 				     struct fscrypt_master_key *mk,
 				     bool need_dirhash_key)
 {
 	int err;
 
+	if (mk->mk_secret.is_hw_wrapped &&
+	    !(ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY)) {
+		fscrypt_warn(ci->ci_inode,
+			     "Given key is hardware-wrapped, but file isn't protected by a hardware-wrapped key");
+		return -EINVAL;
+	}
+	if ((ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY) &&
+	    !mk->mk_secret.is_hw_wrapped) {
+		fscrypt_warn(ci->ci_inode,
+			     "File is protected by a hardware-wrapped key, but given key isn't hardware-wrapped");
+		return -EINVAL;
+	}
+
 	if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) {
 		/*
 		 * DIRECT_KEY: instead of deriving per-file encryption keys, the
 		 * per-file nonce will be included in all the IVs.  But unlike
 		 * v1 policies, for v2 policies in this case we don't encrypt
 		 * with the master key directly but rather derive a per-mode
 		 * encryption key.  This ensures that the master key is
 		 * consistently used only for HKDF, avoiding key reuse issues.
 		 */
 		err = setup_per_mode_enc_key(ci, mk, mk->mk_direct_keys,
@@ -355,21 +395,21 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_inode_info *ci,
 		 * the IVs.  This format is optimized for use with inline
 		 * encryption hardware compliant with the UFS standard.
 		 */
 		err = setup_per_mode_enc_key(ci, mk, mk->mk_iv_ino_lblk_64_keys,
 					     HKDF_CONTEXT_IV_INO_LBLK_64_KEY,
 					     true);
 	} else if (ci->ci_policy.v2.flags &
 		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
 		err = fscrypt_setup_iv_ino_lblk_32_key(ci, mk);
 	} else {
-		u8 derived_key[FSCRYPT_MAX_KEY_SIZE];
+		u8 derived_key[FSCRYPT_MAX_STANDARD_KEY_SIZE];
 
 		err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
 					  HKDF_CONTEXT_PER_FILE_ENC_KEY,
 					  ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
 					  derived_key, ci->ci_mode->keysize);
 		if (err)
 			return err;
 
 		err = fscrypt_set_per_file_enc_key(ci, derived_key);
 		memzero_explicit(derived_key, ci->ci_mode->keysize);
@@ -492,20 +532,28 @@ static int setup_file_encryption_key(struct fscrypt_inode_info *ci,
 		goto out_release_key;
 	}
 
 	if (!fscrypt_valid_master_key_size(mk, ci)) {
 		err = -ENOKEY;
 		goto out_release_key;
 	}
 
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
 		err = fscrypt_setup_v2_file_key(ci, mk, need_dirhash_key);
 		break;
 	default:
 		WARN_ON_ONCE(1);
 		err = -EINVAL;
 		break;
 	}
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index cf3b58ec32cc..8f2d44e6726a 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -111,21 +111,22 @@ find_and_lock_process_key(const char *prefix,
 
 	down_read(&key->sem);
 	ukp = user_key_payload_locked(key);
 
 	if (!ukp) /* was the key revoked before we acquired its semaphore? */
 		goto invalid;
 
 	payload = (const struct fscrypt_key *)ukp->data;
 
 	if (ukp->datalen != sizeof(struct fscrypt_key) ||
-	    payload->size < 1 || payload->size > FSCRYPT_MAX_KEY_SIZE) {
+	    payload->size < 1 ||
+	    payload->size > FSCRYPT_MAX_STANDARD_KEY_SIZE) {
 		fscrypt_warn(NULL,
 			     "key with description '%s' has invalid payload",
 			     key->description);
 		goto invalid;
 	}
 
 	if (payload->size < min_keysize) {
 		fscrypt_warn(NULL,
 			     "key with description '%s' is too short (got %u bytes, need %u+ bytes)",
 			     key->description, payload->size, min_keysize);
@@ -142,21 +143,21 @@ find_and_lock_process_key(const char *prefix,
 }
 
 /* Master key referenced by DIRECT_KEY policy */
 struct fscrypt_direct_key {
 	struct super_block		*dk_sb;
 	struct hlist_node		dk_node;
 	refcount_t			dk_refcount;
 	const struct fscrypt_mode	*dk_mode;
 	struct fscrypt_prepared_key	dk_key;
 	u8				dk_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
-	u8				dk_raw[FSCRYPT_MAX_KEY_SIZE];
+	u8				dk_raw[FSCRYPT_MAX_STANDARD_KEY_SIZE];
 };
 
 static void free_direct_key(struct fscrypt_direct_key *dk)
 {
 	if (dk) {
 		fscrypt_destroy_prepared_key(dk->dk_sb, &dk->dk_key);
 		kfree_sensitive(dk);
 	}
 }
 
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 701259991277..91102635e98a 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -222,21 +222,22 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 		fscrypt_warn(inode,
 			     "Unsupported encryption modes (contents %d, filenames %d)",
 			     policy->contents_encryption_mode,
 			     policy->filenames_encryption_mode);
 		return false;
 	}
 
 	if (policy->flags & ~(FSCRYPT_POLICY_FLAGS_PAD_MASK |
 			      FSCRYPT_POLICY_FLAG_DIRECT_KEY |
 			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 |
-			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)) {
+			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32 |
+			      FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY)) {
 		fscrypt_warn(inode, "Unsupported encryption flags (0x%02x)",
 			     policy->flags);
 		return false;
 	}
 
 	count += !!(policy->flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY);
 	count += !!(policy->flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64);
 	count += !!(policy->flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32);
 	if (count > 1) {
 		fscrypt_warn(inode, "Mutually exclusive encryption flags (0x%02x)",
@@ -262,20 +263,28 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 			/*
 			 * Not safe to enable yet, as we need to ensure that DUN
 			 * wraparound can only occur on a FS block boundary.
 			 */
 			fscrypt_warn(inode,
 				     "Sub-block data units not yet supported with IV_INO_LBLK_32");
 			return false;
 		}
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
 		return false;
 
 	if ((policy->flags & (FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 |
 			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)) &&
 	    !supported_iv_ino_lblk_policy(policy, inode))
 		return false;
 
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 7a8f4c290187..2724febca08f 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -13,20 +13,21 @@
 
 /* Encryption policy flags */
 #define FSCRYPT_POLICY_FLAGS_PAD_4		0x00
 #define FSCRYPT_POLICY_FLAGS_PAD_8		0x01
 #define FSCRYPT_POLICY_FLAGS_PAD_16		0x02
 #define FSCRYPT_POLICY_FLAGS_PAD_32		0x03
 #define FSCRYPT_POLICY_FLAGS_PAD_MASK		0x03
 #define FSCRYPT_POLICY_FLAG_DIRECT_KEY		0x04
 #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64	0x08
 #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32	0x10
+#define FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY	0x20
 
 /* Encryption algorithms */
 #define FSCRYPT_MODE_AES_256_XTS		1
 #define FSCRYPT_MODE_AES_256_CTS		4
 #define FSCRYPT_MODE_AES_128_CBC		5
 #define FSCRYPT_MODE_AES_128_CTS		6
 #define FSCRYPT_MODE_SM4_XTS			7
 #define FSCRYPT_MODE_SM4_CTS			8
 #define FSCRYPT_MODE_ADIANTUM			9
 #define FSCRYPT_MODE_AES_256_HCTR2		10
@@ -112,30 +113,32 @@ struct fscrypt_key_specifier {
 		__u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
 	} u;
 };
 
 /*
  * Payload of Linux keyring key of type "fscrypt-provisioning", referenced by
  * fscrypt_add_key_arg::key_id as an alternative to fscrypt_add_key_arg::raw.
  */
 struct fscrypt_provisioning_key_payload {
 	__u32 type;
-	__u32 __reserved;
+	__u32 flags;
 	__u8 raw[];
 };
 
 /* Struct passed to FS_IOC_ADD_ENCRYPTION_KEY */
 struct fscrypt_add_key_arg {
 	struct fscrypt_key_specifier key_spec;
 	__u32 raw_size;
 	__u32 key_id;
-	__u32 __reserved[8];
+#define FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED			0x00000001
+	__u32 flags;
+	__u32 __reserved[7];
 	__u8 raw[];
 };
 
 /* Struct passed to FS_IOC_REMOVE_ENCRYPTION_KEY */
 struct fscrypt_remove_key_arg {
 	struct fscrypt_key_specifier key_spec;
 #define FSCRYPT_KEY_REMOVAL_STATUS_FLAG_FILES_BUSY	0x00000001
 #define FSCRYPT_KEY_REMOVAL_STATUS_FLAG_OTHER_USERS	0x00000002
 	__u32 removal_status_flags;	/* output */
 	__u32 __reserved[5];
-- 
2.42.0

