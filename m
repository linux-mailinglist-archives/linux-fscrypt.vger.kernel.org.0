Return-Path: <linux-fscrypt+bounces-565-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C0CC9F03B9
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:21:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F6121611B8
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 04:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671A8191493;
	Fri, 13 Dec 2024 04:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZTNhp5z"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BF918452C;
	Fri, 13 Dec 2024 04:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063631; cv=none; b=RECHMi811dELYbnlbFuvCyfGjDpzSEoefkHQ0vewZkkFL0alyUKco89QzgnAvh7YBe8eXVS1S8r7rlxAo8cSz8UcRuMnmXURItWs5eWQrO5DwLyobLL38AY/Sp77fbo0QC6y//SaIGS3+L9Rm/TfBPl0mTf0KZNGRoaSIhyC9Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063631; c=relaxed/simple;
	bh=hj0oFKmhtejPGNLpKunnM1fSmohjGhvvLjQjr6WN4YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/RLOvn2r/MnLTIZTycdNwIHZmEnaPeOR9AVp8trAvUH8M+0uA+t0Bv0iJ2PQtQ1HCp4uBloXDl0XeYrBYcbnBkXxNaUQjtk9Q1cUMiglEtctzwfytSOVz1O1n1mkfYUKf30O4q0SIhnoIYZ87ufZgbPhIQBaZZ9JlP/83kEelI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZTNhp5z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B12DC4CEE0;
	Fri, 13 Dec 2024 04:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734063631;
	bh=hj0oFKmhtejPGNLpKunnM1fSmohjGhvvLjQjr6WN4YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZTNhp5zErVCnkScmuJicj2zkYlhAQFkmf5HhlaFPHDCwg84s+2XHZiAgyt3taTYN
	 GJHt2/Tb/xYyvo+CDH82IyxjvfXYTHF7CiKrrHym62cjU46dW8XfVJze6FSZvVDtBz
	 lPKEMNg/t4SkH3koLGfRxYM3PbgKnH+jd8BESqD2c5JxsZC2VlU6ZoInKDhigXDi04
	 o2Zfdf9ImUPBd7Rc1q9uIunJEh1nXgIqvVVNGSM4VFJaPMmthfe0Ybrycb/Yjqnhh3
	 MLqncWoziCfl5QeBDsuIFcQyJ0v4jQkIRClH7rGQOHJe5OysZMBtTMWMiPWFL8LZC5
	 EP/TA/D9dZKcA==
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
	Ulf Hansson <ulf.hansson@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH v10 13/15] fscrypt: add support for hardware-wrapped keys
Date: Thu, 12 Dec 2024 20:19:56 -0800
Message-ID: <20241213041958.202565-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241213041958.202565-1-ebiggers@kernel.org>
References: <20241213041958.202565-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add support for hardware-wrapped keys to fscrypt.  Such keys are
protected from certain attacks, such as cold boot attacks.  For more
information, see the "Hardware-wrapped keys" section of
Documentation/block/inline-encryption.rst.

To support hardware-wrapped keys in fscrypt, we allow the fscrypt master
keys to be hardware-wrapped.  File contents encryption is done by
passing the wrapped key to the inline encryption hardware via
blk-crypto.  Other fscrypt operations such as filenames encryption
continue to be done by the kernel, using the "software secret" which the
hardware derives.  For more information, see the documentation which
this patch adds to Documentation/filesystems/fscrypt.rst.

Note that this feature doesn't require any filesystem-specific changes.
However it does depend on inline encryption support, and thus currently
it is only applicable to ext4 and f2fs.

The version of this feature introduced by this patch is mostly
equivalent to the version that has existed downstream in the Android
kernels since 2020.  However, a couple fixes are included.  First, the
flags field in struct fscrypt_add_key_arg is now placed in the proper
location.  Second, an option is now provided to derive key identifiers
for HW-wrapped keys using a distinct HKDF context byte; this fixes a bug
where a raw key could have the same identifier as a HW-wrapped key.

This patch has been heavily rewritten from the original version by
Gaurav Kashyap <quic_gaurkash@quicinc.com> and
Barani Muthukumaran <bmuthuku@codeaurora.org>.

Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org> # sm8650
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 201 ++++++++++++++++++++------
 fs/crypto/fscrypt_private.h           |  75 ++++++++--
 fs/crypto/hkdf.c                      |   4 +-
 fs/crypto/inline_crypt.c              |  44 +++++-
 fs/crypto/keyring.c                   | 157 ++++++++++++++------
 fs/crypto/keysetup.c                  |  63 +++++++-
 fs/crypto/keysetup_v1.c               |   4 +-
 include/uapi/linux/fscrypt.h          |   7 +-
 8 files changed, 444 insertions(+), 111 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 04eaab01314b..eb44830173fc 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -68,11 +68,11 @@ an authorized user later accessing the filesystem.
 
 Online attacks
 --------------
 
 fscrypt (and storage encryption in general) can only provide limited
-protection, if any at all, against online attacks.  In detail:
+protection against online attacks.  In detail:
 
 Side-channel attacks
 ~~~~~~~~~~~~~~~~~~~~
 
 fscrypt is only resistant to side-channel attacks, such as timing or
@@ -97,20 +97,27 @@ system itself, is *not* protected by the mathematical properties of
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
@@ -143,10 +150,28 @@ However, these ioctls have some limitations:
 
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
@@ -169,10 +194,14 @@ this reason among others, it is recommended to use v2 encryption
 policies on all new encrypted directories.
 
 Key hierarchy
 =============
 
+Note: this section assumes the use of raw keys rather than
+hardware-wrapped keys.  The use of hardware-wrapped keys modifies the
+key hierarchy slightly.  For details, see `Hardware-wrapped keys`_.
+
 Master Keys
 -----------
 
 Each encrypted directory tree is protected by a *master key*.  Master
 keys can be up to 64 bytes long, and must be at least as long as the
@@ -834,11 +863,14 @@ a pointer to struct fscrypt_add_key_arg, defined as follows::
 
     struct fscrypt_add_key_arg {
             struct fscrypt_key_specifier key_spec;
             __u32 raw_size;
             __u32 key_id;
-            __u32 __reserved[8];
+    #define FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V0      0x00000001
+    #define FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V1      0x00000002
+            __u32 flags;
+            __u32 __reserved[7];
             __u8 raw[];
     };
 
     #define FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR        1
     #define FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER        2
@@ -853,11 +885,11 @@ a pointer to struct fscrypt_add_key_arg, defined as follows::
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
@@ -881,28 +913,41 @@ as follows:
 
 - ``raw_size`` must be the size of the ``raw`` key provided, in bytes.
   Alternatively, if ``key_id`` is nonzero, this field must be 0, since
   in that case the size is implied by the specified Linux keyring key.
 
-- ``key_id`` is 0 if the raw key is given directly in the ``raw``
-  field.  Otherwise ``key_id`` is the ID of a Linux keyring key of
-  type "fscrypt-provisioning" whose payload is
-  struct fscrypt_provisioning_key_payload whose ``raw`` field contains
-  the raw key and whose ``type`` field matches ``key_spec.type``.
-  Since ``raw`` is variable-length, the total size of this key's
-  payload must be ``sizeof(struct fscrypt_provisioning_key_payload)``
-  plus the raw key size.  The process must have Search permission on
-  this key.
-
-  Most users should leave this 0 and specify the raw key directly.
-  The support for specifying a Linux keyring key is intended mainly to
+- ``key_id`` is 0 if the key is given directly in the ``raw`` field.
+  Otherwise ``key_id`` is the ID of a Linux keyring key of type
+  "fscrypt-provisioning" whose payload is struct
+  fscrypt_provisioning_key_payload whose ``raw`` field contains the
+  key, whose ``type`` field matches ``key_spec.type``, and whose
+  ``flags`` field matches ``flags``.  Since ``raw`` is
+  variable-length, the total size of this key's payload must be
+  ``sizeof(struct fscrypt_provisioning_key_payload)`` plus the number
+  of key bytes.  The process must have Search permission on this key.
+
+  Most users should leave this 0 and specify the key directly.  The
+  support for specifying a Linux keyring key is intended mainly to
   allow re-adding keys after a filesystem is unmounted and re-mounted,
-  without having to store the raw keys in userspace memory.
+  without having to store the keys in userspace memory.
+
+- ``flags`` contains optional flags from ``<linux/fscrypt.h>``:
+
+  - FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V0: Similar to
+    FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V1 but selects an old on-disk
+    format.  Do not use when encrypting new directories.  This flag
+    can only be used by privileged users.
+
+  - FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V1: This denotes that the key is a
+    hardware-wrapped key.  See `Hardware-wrapped keys`_.  This flag
+    can't be used if FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR is used.
 
 - ``raw`` is a variable-length field which must contain the actual
   key, ``raw_size`` bytes long.  Alternatively, if ``key_id`` is
-  nonzero, then this field is unused.
+  nonzero, then this field is unused.  Note that despite being named
+  ``raw``, if one of the FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_* flags is
+  specified then it will contain a wrapped key, not a raw key.
 
 For v2 policy keys, the kernel keeps track of which user (identified
 by effective user ID) added the key, and only allows the key to be
 removed by that user --- or by "root", if they use
 `FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS`_.
@@ -910,34 +955,39 @@ removed by that user --- or by "root", if they use
 However, if another user has added the key, it may be desirable to
 prevent that other user from unexpectedly removing it.  Therefore,
 FS_IOC_ADD_ENCRYPTION_KEY may also be used to add a v2 policy key
 *again*, even if it's already added by other user(s).  In this case,
 FS_IOC_ADD_ENCRYPTION_KEY will just install a claim to the key for the
-current user, rather than actually add the key again (but the raw key
-must still be provided, as a proof of knowledge).
+current user, rather than actually add the key again (but the key must
+still be provided, as a proof of knowledge).
 
 FS_IOC_ADD_ENCRYPTION_KEY returns 0 if either the key or a claim to
 the key was either added or already exists.
 
 FS_IOC_ADD_ENCRYPTION_KEY can fail with the following errors:
 
-- ``EACCES``: FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR was specified, but the
-  caller does not have the CAP_SYS_ADMIN capability in the initial
-  user namespace; or the raw key was specified by Linux key ID but the
-  process lacks Search permission on the key.
+- ``EACCES``: FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR or
+  FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V0 was specified, but the caller
+  does not have the CAP_SYS_ADMIN capability in the initial user
+  namespace; or the key was specified by Linux key ID but the process
+  lacks Search permission on the key.
+- ``EBADMSG``: One of the FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_* flags was
+  specified, but the key isn't a valid hardware-wrapped key
 - ``EDQUOT``: the key quota for this user would be exceeded by adding
   the key
 - ``EINVAL``: invalid key size or key specifier type, or reserved bits
   were set
-- ``EKEYREJECTED``: the raw key was specified by Linux key ID, but the
-  key has the wrong type
-- ``ENOKEY``: the raw key was specified by Linux key ID, but no key
-  exists with that ID
+- ``EKEYREJECTED``: the key was specified by Linux key ID, but the key
+  has the wrong type
+- ``ENOKEY``: the key was specified by Linux key ID, but no key exists
+  with that ID
 - ``ENOTTY``: this type of filesystem does not implement encryption
 - ``EOPNOTSUPP``: the kernel was not configured with encryption
   support for this filesystem, or the filesystem superblock has not
-  had encryption enabled on it
+  had encryption enabled on it, or one of the
+  FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_* flags was specified but the
+  filesystem and/or the hardware doesn't support hardware-wrapped keys
 
 Legacy method
 ~~~~~~~~~~~~~
 
 For v1 encryption policies, a master encryption key can also be
@@ -996,13 +1046,12 @@ These two ioctls differ only in cases where v2 policy keys are added
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
@@ -1318,19 +1367,89 @@ encryption when possible; it doesn't force its use.  fscrypt will
 still fall back to using the kernel crypto API on files where the
 inline encryption hardware doesn't have the needed crypto capabilities
 (e.g. support for the needed encryption algorithm and data unit size)
 and where blk-crypto-fallback is unusable.  (For blk-crypto-fallback
 to be usable, it must be enabled in the kernel configuration with
-CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y.)
+CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y, and the file must be
+protected by a raw key rather than a hardware-wrapped key.)
 
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
+keys to be hardware-wrapped keys as an alternative to raw keys.  To
+add a hardware-wrapped key with `FS_IOC_ADD_ENCRYPTION_KEY`_,
+userspace must specify one of the FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_*
+flags in the ``flags`` field of struct fscrypt_add_key_arg and also in
+the ``flags`` field of struct fscrypt_provisioning_key_payload when
+applicable.  The key must be in ephemerally-wrapped form, not
+long-term wrapped form.
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
+the case with raw keys, the block layer will program the key into a
+keyslot when it isn't already in one.  However, when programming a
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
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 8371e4e1f596..c1d92074b65c 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -10,10 +10,11 @@
 
 #ifndef _FSCRYPT_PRIVATE_H
 #define _FSCRYPT_PRIVATE_H
 
 #include <linux/fscrypt.h>
+#include <linux/minmax.h>
 #include <linux/siphash.h>
 #include <crypto/hash.h>
 #include <linux/blk-crypto.h>
 
 #define CONST_STRLEN(str)	(sizeof(str) - 1)
@@ -25,10 +26,27 @@
  * if ciphers with a 256-bit security strength are used.  This is just the
  * absolute minimum, which applies when only 128-bit encryption is used.
  */
 #define FSCRYPT_MIN_KEY_SIZE	16
 
+/* Maximum size of a raw fscrypt master key */
+#define FSCRYPT_MAX_RAW_KEY_SIZE	64
+
+/* Maximum size of a hardware-wrapped fscrypt master key */
+#define FSCRYPT_MAX_HW_WRAPPED_KEY_SIZE	BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE
+
+/* Maximum size of an fscrypt master key across both key types */
+#define FSCRYPT_MAX_ANY_KEY_SIZE \
+	MAX(FSCRYPT_MAX_RAW_KEY_SIZE, FSCRYPT_MAX_HW_WRAPPED_KEY_SIZE)
+
+/*
+ * FSCRYPT_MAX_KEY_SIZE is defined in the UAPI header, but the addition of
+ * hardware-wrapped keys has made it misleading as it's only for raw keys.
+ * Don't use it in kernel code; use one of the above constants instead.
+ */
+#undef FSCRYPT_MAX_KEY_SIZE
+
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
 
 /* Keep this in sync with include/uapi/linux/fscrypt.h */
 #define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
@@ -358,41 +376,49 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
  * the first byte of the HKDF application-specific info string to guarantee that
  * info strings are never repeated between contexts.  This ensures that all HKDF
  * outputs are unique and cryptographically isolated, i.e. knowledge of one
  * output doesn't reveal another.
  */
-#define HKDF_CONTEXT_KEY_IDENTIFIER	1 /* info=<empty>		*/
+#define HKDF_CONTEXT_KEY_IDENTIFIER_FOR_RAW_KEY	1 /* info=<empty>	*/
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
-int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci);
+int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci,
+				   bool is_hw_wrapped_key);
 
 static inline bool
 fscrypt_using_inline_encryption(const struct fscrypt_inode_info *ci)
 {
 	return ci->ci_inlinecrypt;
 }
 
 int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
-				     const u8 *raw_key,
+				     const u8 *key_bytes, size_t key_size,
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
@@ -412,11 +438,12 @@ fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
 	return smp_load_acquire(&prep_key->tfm) != NULL;
 }
 
 #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
-static inline int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci)
+static inline int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci,
+						 bool is_hw_wrapped_key)
 {
 	return 0;
 }
 
 static inline bool
@@ -425,11 +452,12 @@ fscrypt_using_inline_encryption(const struct fscrypt_inode_info *ci)
 	return false;
 }
 
 static inline int
 fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
-				 const u8 *raw_key,
+				 const u8 *key_bytes, size_t key_size,
+				 bool is_hw_wrapped,
 				 const struct fscrypt_inode_info *ci)
 {
 	WARN_ON_ONCE(1);
 	return -EOPNOTSUPP;
 }
@@ -438,10 +466,19 @@ static inline void
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
@@ -454,24 +491,42 @@ fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
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
 
 	/*
-	 * Size of the raw key in bytes.  This remains set even if ->raw was
+	 * True if this key is a hardware-wrapped key; false if this key is a
+	 * raw key (i.e. a "software key").  For v1 policy keys this will always
+	 * be false, as v1 policy support is a legacy feature which doesn't
+	 * support newer functionality such as hardware-wrapped keys.
+	 */
+	bool			is_hw_wrapped;
+
+	/*
+	 * Size of the key in bytes.  This remains set even if ->bytes was
 	 * zeroized due to no longer being needed.  I.e. we still remember the
 	 * size of the key even if we don't need to remember the key itself.
 	 */
 	u32			size;
 
-	/* For v1 policy keys: the raw key.  Wiped for v2 policy keys. */
-	u8			raw[FSCRYPT_MAX_KEY_SIZE];
+	/*
+	 * The bytes of the key, when still needed.  This can be either a raw
+	 * key or a hardware-wrapped key, as indicated by ->is_hw_wrapped.  In
+	 * the case of a raw, v2 policy key, there is no need to remember the
+	 * actual key separately from ->hkdf so this field will be zeroized as
+	 * soon as ->hkdf is initialized.
+	 */
+	u8			bytes[FSCRYPT_MAX_ANY_KEY_SIZE];
 
 } __randomize_layout;
 
 /*
  * fscrypt_master_key - an in-use master key
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index 5a384dad2c72..7e007810e434 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -2,11 +2,13 @@
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
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 7fa53d30aec3..1d008c440cb6 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -87,11 +87,12 @@ static void fscrypt_log_blk_crypto_impl(struct fscrypt_mode *mode,
 		}
 	}
 }
 
 /* Enable inline encryption for this file if supported. */
-int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci)
+int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci,
+				   bool is_hw_wrapped_key)
 {
 	const struct inode *inode = ci->ci_inode;
 	struct super_block *sb = inode->i_sb;
 	struct blk_crypto_config crypto_cfg;
 	struct block_device **devs;
@@ -128,11 +129,12 @@ int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci)
 	 * crypto configuration that the file would use.
 	 */
 	crypto_cfg.crypto_mode = ci->ci_mode->blk_crypto_mode;
 	crypto_cfg.data_unit_size = 1U << ci->ci_data_unit_bits;
 	crypto_cfg.dun_bytes = fscrypt_get_dun_bytes(ci);
-	crypto_cfg.key_type = BLK_CRYPTO_KEY_TYPE_RAW;
+	crypto_cfg.key_type = is_hw_wrapped_key ?
+		BLK_CRYPTO_KEY_TYPE_HW_WRAPPED : BLK_CRYPTO_KEY_TYPE_RAW;
 
 	devs = fscrypt_get_devices(sb, &num_devs);
 	if (IS_ERR(devs))
 		return PTR_ERR(devs);
 
@@ -149,29 +151,31 @@ int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci)
 
 	return 0;
 }
 
 int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
-				     const u8 *raw_key,
+				     const u8 *key_bytes, size_t key_size,
+				     bool is_hw_wrapped,
 				     const struct fscrypt_inode_info *ci)
 {
 	const struct inode *inode = ci->ci_inode;
 	struct super_block *sb = inode->i_sb;
 	enum blk_crypto_mode_num crypto_mode = ci->ci_mode->blk_crypto_mode;
+	enum blk_crypto_key_type key_type = is_hw_wrapped ?
+		BLK_CRYPTO_KEY_TYPE_HW_WRAPPED : BLK_CRYPTO_KEY_TYPE_RAW;
 	struct blk_crypto_key *blk_key;
 	struct block_device **devs;
 	unsigned int num_devs;
 	unsigned int i;
 	int err;
 
 	blk_key = kmalloc(sizeof(*blk_key), GFP_KERNEL);
 	if (!blk_key)
 		return -ENOMEM;
 
-	err = blk_crypto_init_key(blk_key, raw_key, ci->ci_mode->keysize,
-				  BLK_CRYPTO_KEY_TYPE_RAW, crypto_mode,
-				  fscrypt_get_dun_bytes(ci),
+	err = blk_crypto_init_key(blk_key, key_bytes, key_size, key_type,
+				  crypto_mode, fscrypt_get_dun_bytes(ci),
 				  1U << ci->ci_data_unit_bits);
 	if (err) {
 		fscrypt_err(inode, "error %d initializing blk-crypto key", err);
 		goto fail;
 	}
@@ -226,10 +230,38 @@ void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
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
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 787e9c8938ba..9c2f51b62ff2 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -147,15 +147,15 @@ static inline bool valid_key_spec(const struct fscrypt_key_specifier *spec)
 
 static int fscrypt_user_key_instantiate(struct key *key,
 					struct key_preparsed_payload *prep)
 {
 	/*
-	 * We just charge FSCRYPT_MAX_KEY_SIZE bytes to the user's key quota for
-	 * each key, regardless of the exact key size.  The amount of memory
+	 * We just charge FSCRYPT_MAX_RAW_KEY_SIZE bytes to the user's key quota
+	 * for each key, regardless of the exact key size.  The amount of memory
 	 * actually used is greater than the size of the raw key anyway.
 	 */
-	return key_payload_reserve(key, FSCRYPT_MAX_KEY_SIZE);
+	return key_payload_reserve(key, FSCRYPT_MAX_RAW_KEY_SIZE);
 }
 
 static void fscrypt_user_key_describe(const struct key *key, struct seq_file *m)
 {
 	seq_puts(m, key->description);
@@ -551,50 +551,95 @@ static int do_add_master_key(struct super_block *sb,
 	return err;
 }
 
 static int add_master_key(struct super_block *sb,
 			  struct fscrypt_master_key_secret *secret,
-			  struct fscrypt_key_specifier *key_spec)
+			  struct fscrypt_key_specifier *key_spec, u32 flags)
 {
 	int err;
 
 	if (key_spec->type == FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER) {
-		err = fscrypt_init_hkdf(&secret->hkdf, secret->raw,
-					secret->size);
-		if (err)
-			return err;
+		u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE];
+		u8 *kdf_key = secret->bytes;
+		unsigned int kdf_key_size = secret->size;
+		u8 keyid_kdf_ctx = HKDF_CONTEXT_KEY_IDENTIFIER_FOR_RAW_KEY;
 
 		/*
-		 * Now that the HKDF context is initialized, the raw key is no
-		 * longer needed.
+		 * For raw keys, the fscrypt master key is used directly as the
+		 * fscrypt KDF key.  For hardware-wrapped keys, we have to pass
+		 * the master key to the hardware to derive the KDF key, which
+		 * is then only used to derive non-file-contents subkeys.
+		 */
+		if (secret->is_hw_wrapped) {
+			err = fscrypt_derive_sw_secret(sb, secret->bytes,
+						       secret->size, sw_secret);
+			if (err)
+				return err;
+			kdf_key = sw_secret;
+			kdf_key_size = sizeof(sw_secret);
+			/*
+			 * To avoid weird behavior if someone manages to
+			 * determine sw_secret and add it as a raw key, ensure
+			 * that hardware-wrapped keys and raw keys will have
+			 * different key identifiers by deriving their key
+			 * identifiers using different KDF contexts.
+			 */
+			if (!(flags & FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V0))
+				keyid_kdf_ctx =
+					HKDF_CONTEXT_KEY_IDENTIFIER_FOR_HW_WRAPPED_KEY;
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
+	u32 max_size = (add_key_flags & (FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V0 |
+					 FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V1)) ?
+		       FSCRYPT_MAX_HW_WRAPPED_KEY_SIZE :
+		       FSCRYPT_MAX_RAW_KEY_SIZE;
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
+	if (payload->flags & ~(FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V0 |
+			       FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V1))
 		return -EINVAL;
 
 	prep->payload.data[0] = kmemdup(payload, prep->datalen, GFP_KERNEL);
 	if (!prep->payload.data[0])
 		return -ENOMEM;
@@ -634,25 +679,25 @@ static struct key_type key_type_fscrypt_provisioning = {
 	.describe		= fscrypt_provisioning_key_describe,
 	.destroy		= fscrypt_provisioning_key_destroy,
 };
 
 /*
- * Retrieve the raw key from the Linux keyring key specified by 'key_id', and
- * store it into 'secret'.
+ * Retrieve the key from the Linux keyring key specified by 'key_id', and store
+ * it into 'secret'.
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
- * re-mounted.  Most users should just provide the raw key directly instead.
+ * re-mounted.  Most users should just provide the key directly instead.
  */
-static int get_keyring_key(u32 key_id, u32 type,
+static int get_keyring_key(u32 key_id, u32 type, u32 flags,
 			   struct fscrypt_master_key_secret *secret)
 {
 	key_ref_t ref;
 	struct key *key;
 	const struct fscrypt_provisioning_key_payload *payload;
@@ -665,16 +710,20 @@ static int get_keyring_key(u32 key_id, u32 type,
 
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
-	memcpy(secret->raw, payload->raw, secret->size);
+	memcpy(secret->bytes, payload->raw, secret->size);
 	err = 0;
 	goto out_put;
 
 bad_key:
 	err = -EKEYREJECTED;
@@ -732,27 +781,52 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 	if (arg.key_spec.type == FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
 	memset(&secret, 0, sizeof(secret));
+
+	if (arg.flags) {
+		if (arg.flags & ~(FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V0 |
+				  FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V1))
+			return -EINVAL;
+		if (arg.flags & FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V0) {
+			if (arg.flags & FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V1)
+				return -EINVAL; /* Ambiguous flags */
+			/*
+			 * HW_WRAPPED_V0 keys reuse the same HKDF context byte
+			 * as raw keys when deriving the key identifier.  This
+			 * creates an ambiguity where a file encrypted by a
+			 * HW-wrapped key can be unlocked with the wrong key by
+			 * using a raw key.  Strictly speaking this breaks the
+			 * security model of the fscrypt keyring where different
+			 * keys should have different identifiers.  Thus
+			 * technically HW_WRAPPED_V0 is only safe when keys are
+			 * system-managed, so we require CAP_SYS_ADMIN for it.
+			 */
+			if (!capable(CAP_SYS_ADMIN))
+				return -EACCES;
+		}
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
-		if (copy_from_user(secret.raw, uarg->raw, secret.size))
+		if (copy_from_user(secret.bytes, uarg->raw, secret.size))
 			goto out_wipe_secret;
 	}
 
-	err = add_master_key(sb, &secret, &arg.key_spec);
+	err = add_master_key(sb, &secret, &arg.key_spec, arg.flags);
 	if (err)
 		goto out_wipe_secret;
 
 	/* Return the key identifier to userspace, if applicable */
 	err = -EFAULT;
@@ -768,31 +842,32 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 EXPORT_SYMBOL_GPL(fscrypt_ioctl_add_key);
 
 static void
 fscrypt_get_test_dummy_secret(struct fscrypt_master_key_secret *secret)
 {
-	static u8 test_key[FSCRYPT_MAX_KEY_SIZE];
+	static u8 test_key[FSCRYPT_MAX_RAW_KEY_SIZE];
 
-	get_random_once(test_key, FSCRYPT_MAX_KEY_SIZE);
+	get_random_once(test_key, sizeof(test_key));
 
 	memset(secret, 0, sizeof(*secret));
-	secret->size = FSCRYPT_MAX_KEY_SIZE;
-	memcpy(secret->raw, test_key, FSCRYPT_MAX_KEY_SIZE);
+	secret->size = sizeof(test_key);
+	memcpy(secret->bytes, test_key, sizeof(test_key));
 }
 
 int fscrypt_get_test_dummy_key_identifier(
 				u8 key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE])
 {
 	struct fscrypt_master_key_secret secret;
 	int err;
 
 	fscrypt_get_test_dummy_secret(&secret);
 
-	err = fscrypt_init_hkdf(&secret.hkdf, secret.raw, secret.size);
+	err = fscrypt_init_hkdf(&secret.hkdf, secret.bytes, secret.size);
 	if (err)
 		goto out;
-	err = fscrypt_hkdf_expand(&secret.hkdf, HKDF_CONTEXT_KEY_IDENTIFIER,
+	err = fscrypt_hkdf_expand(&secret.hkdf,
+				  HKDF_CONTEXT_KEY_IDENTIFIER_FOR_RAW_KEY,
 				  NULL, 0, key_identifier,
 				  FSCRYPT_KEY_IDENTIFIER_SIZE);
 out:
 	wipe_master_key_secret(&secret);
 	return err;
@@ -815,11 +890,11 @@ int fscrypt_add_test_dummy_key(struct super_block *sb,
 {
 	struct fscrypt_master_key_secret secret;
 	int err;
 
 	fscrypt_get_test_dummy_secret(&secret);
-	err = add_master_key(sb, &secret, key_spec);
+	err = add_master_key(sb, &secret, key_spec, 0);
 	wipe_master_key_secret(&secret);
 	return err;
 }
 
 /*
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index b4fe01ea4bd4..5bbbfdb6a1a3 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -151,11 +151,13 @@ int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
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
@@ -193,18 +195,33 @@ static int setup_per_mode_enc_key(struct fscrypt_inode_info *ci,
 	const struct inode *inode = ci->ci_inode;
 	const struct super_block *sb = inode->i_sb;
 	struct fscrypt_mode *mode = ci->ci_mode;
 	const u8 mode_num = mode - fscrypt_modes;
 	struct fscrypt_prepared_key *prep_key;
-	u8 mode_key[FSCRYPT_MAX_KEY_SIZE];
+	u8 mode_key[FSCRYPT_MAX_RAW_KEY_SIZE];
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
@@ -212,10 +229,20 @@ static int setup_per_mode_enc_key(struct fscrypt_inode_info *ci,
 	mutex_lock(&fscrypt_mode_key_setup_mutex);
 
 	if (fscrypt_is_key_prepared(prep_key, ci))
 		goto done_unlock;
 
+	if (use_hw_wrapped_key) {
+		err = fscrypt_prepare_inline_crypt_key(prep_key,
+						       mk->mk_secret.bytes,
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
@@ -334,10 +361,18 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_inode_info *ci,
 				     struct fscrypt_master_key *mk,
 				     bool need_dirhash_key)
 {
 	int err;
 
+	if (mk->mk_secret.is_hw_wrapped &&
+	    !(ci->ci_policy.v2.flags & (FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 |
+					FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))) {
+		fscrypt_warn(ci->ci_inode,
+			     "Hardware-wrapped keys are only supported with IV_INO_LBLK policies");
+		return -EINVAL;
+	}
+
 	if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) {
 		/*
 		 * DIRECT_KEY: instead of deriving per-file encryption keys, the
 		 * per-file nonce will be included in all the IVs.  But unlike
 		 * v1 policies, for v2 policies in this case we don't encrypt
@@ -360,11 +395,11 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_inode_info *ci,
 					     true);
 	} else if (ci->ci_policy.v2.flags &
 		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
 		err = fscrypt_setup_iv_ino_lblk_32_key(ci, mk);
 	} else {
-		u8 derived_key[FSCRYPT_MAX_KEY_SIZE];
+		u8 derived_key[FSCRYPT_MAX_RAW_KEY_SIZE];
 
 		err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
 					  HKDF_CONTEXT_PER_FILE_ENC_KEY,
 					  ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
 					  derived_key, ci->ci_mode->keysize);
@@ -443,14 +478,10 @@ static int setup_file_encryption_key(struct fscrypt_inode_info *ci,
 	struct super_block *sb = ci->ci_inode->i_sb;
 	struct fscrypt_key_specifier mk_spec;
 	struct fscrypt_master_key *mk;
 	int err;
 
-	err = fscrypt_select_encryption_impl(ci);
-	if (err)
-		return err;
-
 	err = fscrypt_policy_to_key_spec(&ci->ci_policy, &mk_spec);
 	if (err)
 		return err;
 
 	mk = fscrypt_find_master_key(sb, &mk_spec);
@@ -474,10 +505,14 @@ static int setup_file_encryption_key(struct fscrypt_inode_info *ci,
 	}
 	if (unlikely(!mk)) {
 		if (ci->ci_policy.version != FSCRYPT_POLICY_V1)
 			return -ENOKEY;
 
+		err = fscrypt_select_encryption_impl(ci, false);
+		if (err)
+			return err;
+
 		/*
 		 * As a legacy fallback for v1 policies, search for the key in
 		 * the current task's subscribed keyrings too.  Don't move this
 		 * to before the search of ->s_master_keys, since users
 		 * shouldn't be able to override filesystem-level keys.
@@ -495,13 +530,25 @@ static int setup_file_encryption_key(struct fscrypt_inode_info *ci,
 	if (!fscrypt_valid_master_key_size(mk, ci)) {
 		err = -ENOKEY;
 		goto out_release_key;
 	}
 
+	err = fscrypt_select_encryption_impl(ci, mk->mk_secret.is_hw_wrapped);
+	if (err)
+		goto out_release_key;
+
 	switch (ci->ci_policy.version) {
 	case FSCRYPT_POLICY_V1:
-		err = fscrypt_setup_v1_file_key(ci, mk->mk_secret.raw);
+		if (WARN_ON(mk->mk_secret.is_hw_wrapped)) {
+			/*
+			 * This should never happen, as adding a v1 policy key
+			 * that is hardware-wrapped isn't allowed.
+			 */
+			err = -EINVAL;
+			goto out_release_key;
+		}
+		err = fscrypt_setup_v1_file_key(ci, mk->mk_secret.bytes);
 		break;
 	case FSCRYPT_POLICY_V2:
 		err = fscrypt_setup_v2_file_key(ci, mk, need_dirhash_key);
 		break;
 	default:
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index cf3b58ec32cc..b70521c55132 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -116,11 +116,11 @@ find_and_lock_process_key(const char *prefix,
 		goto invalid;
 
 	payload = (const struct fscrypt_key *)ukp->data;
 
 	if (ukp->datalen != sizeof(struct fscrypt_key) ||
-	    payload->size < 1 || payload->size > FSCRYPT_MAX_KEY_SIZE) {
+	    payload->size < 1 || payload->size > sizeof(payload->raw)) {
 		fscrypt_warn(NULL,
 			     "key with description '%s' has invalid payload",
 			     key->description);
 		goto invalid;
 	}
@@ -147,11 +147,11 @@ struct fscrypt_direct_key {
 	struct hlist_node		dk_node;
 	refcount_t			dk_refcount;
 	const struct fscrypt_mode	*dk_mode;
 	struct fscrypt_prepared_key	dk_key;
 	u8				dk_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
-	u8				dk_raw[FSCRYPT_MAX_KEY_SIZE];
+	u8				dk_raw[FSCRYPT_MAX_RAW_KEY_SIZE];
 };
 
 static void free_direct_key(struct fscrypt_direct_key *dk)
 {
 	if (dk) {
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 7a8f4c290187..6246a190934a 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -117,20 +117,23 @@ struct fscrypt_key_specifier {
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
+#define FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V0	0x00000001
+#define FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V1	0x00000002
+	__u32 flags;
+	__u32 __reserved[7];
 	__u8 raw[];
 };
 
 /* Struct passed to FS_IOC_REMOVE_ENCRYPTION_KEY */
 struct fscrypt_remove_key_arg {
-- 
2.47.1


