Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9406F6467E8
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Dec 2022 04:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiLHDgn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Dec 2022 22:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiLHDgm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Dec 2022 22:36:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B46B207;
        Wed,  7 Dec 2022 19:36:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FC1361D56;
        Thu,  8 Dec 2022 03:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8255C433C1;
        Thu,  8 Dec 2022 03:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670470599;
        bh=S7beDX8FcgruropJYnQVglR+kUywD3OlsZPm3Rmougw=;
        h=From:To:Cc:Subject:Date:From;
        b=q+/SgbiZy1/VQ4jlrVGyPOZRBDI76UJLkyb9mGndUmxKklyqWAQ3IUrCdZerfkPpV
         YAwvyIT9NbhK39uw3RPTzS9OIvT+IpkyQe/p2pNHiDQ2Tg4/jf7HeMmOaCldG0a47h
         d8XZg0aX+VF2f8D/ANbG2hZGQze4sK1+Uyaw8LQGnWEKUdDI9D2WgmRC7J+Wk4lRTc
         StptIkJGVxvDrWAgse2mlKTpRNP0Yz0KQ1wRLK425+rOnq7TP2WX7McolQ2cPGbR/y
         +7S6Sb+3XHcYg63d2HFRmQsgQJzF4+Vm9ESzEQd0ydGRE4DKDUuo9zUKpVtT/NmR/I
         dOtKHqyrfbu0A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-integrity@vger.kernel.org,
        Luca Boccassi <bluca@debian.org>,
        Jes Sorensen <jsorensen@meta.com>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [PATCH] fsverity: mark builtin signatures as deprecated
Date:   Wed,  7 Dec 2022 19:35:48 -0800
Message-Id: <20221208033548.122704-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fsverity builtin signatures, at least as currently implemented, are a
mistake and should not be used.  They mix the authentication policy
between the kernel and userspace, which is not a clean design and causes
confusion.  For builtin signatures to actually provide any security
benefit, userspace still has to enforce that specific files have
fsverity enabled.  Since userspace needs to do this, a better design is
to have that same userspace code do the signature check too.

That allows better signature formats and algorithms to be used, avoiding
in-kernel parsing of the notoriously bad PKCS#7 format.  It is also
needed anyway when different keys need to be trusted for different
files, or when it's desired to use fsverity for integrity-only or
auditing on some files and for authenticity on other files.  Basically,
the builtin signatures don't work for any nontrivial use case.

(IMA appraisal is another alternative.  It goes in the opposite
direction -- the full policy is moved into the kernel.)

For these reasons, the master branch of AOSP no longer uses builtin
signatures.  It still uses fsverity for some files, but signatures are
verified in userspace when needed.

None of the public uses of builtin signatures outside Android seem to
have gotten going, either.  Support for builtin signatures was added to
RPM.  However, https://fedoraproject.org/wiki/Changes/FsVerityRPM was
subsequently rejected from Fedora and seems to have been abandoned.
There is also https://github.com/ostreedev/ostree/pull/2269, which was
never merged.  Neither proposal mentioned a plan to set
fs.verity.require_signatures=1 and enforce that files have fs-verity
enabled -- so, they would have had no security benefit on their own.

I'd be glad to hear about any other users of builtin signatures that may
exist, and help with the details of what should be used instead.

Anyway, the feature can't simply be removed, due to the need to maintain
backwards compatibility.  But let's at least make it clear that it's
deprecated.  Update the documentation accordingly, and rename the
kconfig option to CONFIG_FS_VERITY_DEPRECATED_BUILTINSIG.  Also remove
the kconfig option from the s390 defconfigs, as it's unneeded there.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fsverity.rst | 135 +++++++++++++------------
 arch/s390/configs/debug_defconfig      |   1 -
 arch/s390/configs/defconfig            |   1 -
 fs/verity/Kconfig                      |  27 +++--
 fs/verity/Makefile                     |   2 +-
 fs/verity/fsverity_private.h           |   6 +-
 fs/verity/signature.c                  |  12 ++-
 7 files changed, 97 insertions(+), 87 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index cb8e7573882a1..f3dba9c53affe 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -69,24 +69,17 @@ still be used on read-only filesystems.  fs-verity is for files that
 must live on a read-write filesystem because they are independently
 updated and potentially user-installed, so dm-verity cannot be used.
 
-The base fs-verity feature is a hashing mechanism only; actually
-authenticating the files may be done by:
-
-* Userspace-only
-
-* Builtin signature verification + userspace policy
-
-  fs-verity optionally supports a simple signature verification
-  mechanism where users can configure the kernel to require that
-  all fs-verity files be signed by a key loaded into a keyring;
-  see `Built-in signature verification`_.
-
-* Integrity Measurement Architecture (IMA)
-
-  IMA supports including fs-verity file digests and signatures in the
-  IMA measurement list and verifying fs-verity based file signatures
-  stored as security.ima xattrs, based on policy.
-
+The base fs-verity feature is a hashing mechanism only.  Actually
+authenticating files' fs-verity digests can be done by userspace, as
+described above.  Alternatively, the Integrity Measurement
+Architecture (IMA) can be used.  IMA supports including fs-verity file
+digests and signatures in the IMA measurement list and verifying
+fs-verity based file signatures stored as security.ima xattrs, based
+on policy.
+
+Another alternative is `Builtin signature verification (deprecated)`_.
+However, that approach has been shown to not be a good way of doing
+signatures with fs-verity, so its use is discouraged.
 
 User API
 ========
@@ -111,8 +104,7 @@ follows::
     };
 
 This structure contains the parameters of the Merkle tree to build for
-the file, and optionally contains a signature.  It must be initialized
-as follows:
+the file.  It must be initialized as follows:
 
 - ``version`` must be 1.
 - ``hash_algorithm`` must be the identifier for the hash algorithm to
@@ -128,12 +120,12 @@ as follows:
   file or device.  Currently the maximum salt size is 32 bytes.
 - ``salt_ptr`` is the pointer to the salt, or NULL if no salt is
   provided.
-- ``sig_size`` is the size of the signature in bytes, or 0 if no
-  signature is provided.  Currently the signature is (somewhat
-  arbitrarily) limited to 16128 bytes.  See `Built-in signature
-  verification`_ for more information.
-- ``sig_ptr``  is the pointer to the signature, or NULL if no
-  signature is provided.
+- ``sig_size`` is the size of the builtin signature in bytes, or 0 if
+  no builtin signature is provided.  Currently the builtin signature
+  is (somewhat arbitrarily) limited to 16128 bytes.  See
+  `Builtin signature verification (deprecated)`_ for more information.
+- ``sig_ptr``  is the pointer to the builtin signature, or NULL if no
+  builtin signature is provided.
 - All reserved fields must be zeroed.
 
 FS_IOC_ENABLE_VERITY causes the filesystem to build a Merkle tree for
@@ -157,7 +149,7 @@ fatal signal), no changes are made to the file.
 FS_IOC_ENABLE_VERITY can fail with the following errors:
 
 - ``EACCES``: the process does not have write access to the file
-- ``EBADMSG``: the signature is malformed
+- ``EBADMSG``: the builtin signature is malformed
 - ``EBUSY``: this ioctl is already running on the file
 - ``EEXIST``: the file already has verity enabled
 - ``EFAULT``: the caller provided inaccessible memory
@@ -166,10 +158,10 @@ FS_IOC_ENABLE_VERITY can fail with the following errors:
   reserved bits are set; or the file descriptor refers to neither a
   regular file nor a directory.
 - ``EISDIR``: the file descriptor refers to a directory
-- ``EKEYREJECTED``: the signature doesn't match the file
-- ``EMSGSIZE``: the salt or signature is too long
+- ``EKEYREJECTED``: the builtin signature doesn't match the file
+- ``EMSGSIZE``: the salt or builtin signature is too long
 - ``ENOKEY``: the fs-verity keyring doesn't contain the certificate
-  needed to verify the signature
+  needed to verify the builtin signature
 - ``ENOPKG``: fs-verity recognizes the hash algorithm, but it's not
   available in the kernel's crypto API as currently configured (e.g.
   for SHA-512, missing CONFIG_CRYPTO_SHA512).
@@ -178,8 +170,8 @@ FS_IOC_ENABLE_VERITY can fail with the following errors:
   support; or the filesystem superblock has not had the 'verity'
   feature enabled on it; or the filesystem does not support fs-verity
   on this file.  (See `Filesystem support`_.)
-- ``EPERM``: the file is append-only; or, a signature is required and
-  one was not provided.
+- ``EPERM``: the file is append-only; or, a builtin signature is
+  required and one was not provided.
 - ``EROFS``: the filesystem is read-only
 - ``ETXTBSY``: someone has the file open for writing.  This can be the
   caller's file descriptor, another open file descriptor, or the file
@@ -268,9 +260,9 @@ This ioctl takes in a pointer to the following structure::
 - ``FS_VERITY_METADATA_TYPE_DESCRIPTOR`` reads the fs-verity
   descriptor.  See `fs-verity descriptor`_.
 
-- ``FS_VERITY_METADATA_TYPE_SIGNATURE`` reads the signature which was
-  passed to FS_IOC_ENABLE_VERITY, if any.  See `Built-in signature
-  verification`_.
+- ``FS_VERITY_METADATA_TYPE_SIGNATURE`` reads the builtin signature
+  which was passed to FS_IOC_ENABLE_VERITY, if any.
+  See `Builtin signature verification (deprecated)`_.
 
 The semantics are similar to those of ``pread()``.  ``offset``
 specifies the offset in bytes into the metadata item to read from, and
@@ -297,7 +289,7 @@ FS_IOC_READ_VERITY_METADATA can fail with the following errors:
   overflowed
 - ``ENODATA``: the file is not a verity file, or
   FS_VERITY_METADATA_TYPE_SIGNATURE was requested but the file doesn't
-  have a built-in signature
+  have a builtin signature
 - ``ENOTTY``: this type of filesystem does not implement fs-verity, or
   this ioctl is not yet implemented on it
 - ``EOPNOTSUPP``: the kernel was not configured with fs-verity
@@ -345,8 +337,9 @@ non-verity one, with the following exceptions:
   with EIO (for read()) or SIGBUS (for mmap() reads).
 
 - If the sysctl "fs.verity.require_signatures" is set to 1 and the
-  file is not signed by a key in the fs-verity keyring, then opening
-  the file will fail.  See `Built-in signature verification`_.
+  file does not have a builtin signature that verifies against the
+  fs-verity keyring, then opening the file will fail.
+  See `Builtin signature verification (deprecated)`_.
 
 Direct access to the Merkle tree is not supported.  Therefore, if a
 verity file is copied, or is backed up and restored, then it will lose
@@ -428,32 +421,42 @@ root hash as well as other fields such as the file size::
             __u8 __reserved[144];   /* must be 0's */
     };
 
-Built-in signature verification
-===============================
+Builtin signature verification (deprecated)
+===========================================
+
+Authenticating the contents of a file via fs-verity requires (a)
+checking that the file has fs-verity enabled, and (b) verifying that
+the file's fs-verity digest is signed by a trusted key.
 
-With CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y, fs-verity supports putting
-a portion of an authentication policy (see `Use cases`_) in the
-kernel.  Specifically, it adds support for:
+Userspace can do both (a) and (b).  Alternatively, the kernel can do
+both (a) and (b); that is possible with IMA appraisal.
 
-1. At fs-verity module initialization time, a keyring ".fs-verity" is
-   created.  The root user can add trusted X.509 certificates to this
-   keyring using the add_key() system call, then (when done)
-   optionally use keyctl_restrict_keyring() to prevent additional
-   certificates from being added.
+fs-verity builtin signatures are a hybrid solution where userspace
+handles (a), but the kernel handles (b).  Due to this odd division of
+responsibilities, the inflexibility of doing signature verification in
+the kernel, and the use of PKCS#7, this solution has been shown to not
+be a good way of doing signatures with fs-verity.  Therefore, it is
+**now considered deprecated**.  Users of it should migrate to a better
+solution -- usually userspace signature verification.
 
-2. `FS_IOC_ENABLE_VERITY`_ accepts a pointer to a PKCS#7 formatted
-   detached signature in DER format of the file's fs-verity digest.
-   On success, this signature is persisted alongside the Merkle tree.
-   Then, any time the file is opened, the kernel will verify the
-   file's actual digest against this signature, using the certificates
-   in the ".fs-verity" keyring.
+That being said, it optionally remains available in the kernel for
+backwards compatibility, and is documented below.
 
-3. A new sysctl "fs.verity.require_signatures" is made available.
-   When set to 1, the kernel requires that all verity files have a
-   correctly signed digest as described in (2).
+CONFIG_FS_VERITY_DEPRECATED_BUILTINSIG=y enables support for the
+deprecated builtin signatures feature.  It makes available the kernel
+keyring ".fs-verity" and the sysctl "fs.verity.require_signatures".
 
-fs-verity file digests must be signed in the following format, which
-is similar to the structure used by `FS_IOC_MEASURE_VERITY`_::
+The ".fs-verity" keyring contains the X.509 certificates that are
+trusted for builtin signatures.  The root user can add certificates to
+this keyring using the add_key() system call, and then (when done)
+optionally use keyctl_restrict_keyring() to prevent additional
+certificates from being added.
+
+When fs-verity is enabled on a file using `FS_IOC_ENABLE_VERITY`_, a
+pointer to a builtin signature can be provided.  On success, the
+builtin signature is stored internally within the file's fs-verity
+metadata.  The builtin signature must be a PKCS#7 detached signature
+in DER format of the file's fs-verity digest in the following format::
 
     struct fsverity_formatted_digest {
             char magic[8];                  /* must be "FSVerity" */
@@ -462,13 +465,13 @@ is similar to the structure used by `FS_IOC_MEASURE_VERITY`_::
             __u8 digest[];
     };
 
-fs-verity's built-in signature verification support is meant as a
-relatively simple mechanism that can be used to provide some level of
-authenticity protection for verity files, as an alternative to doing
-the signature verification in userspace or using IMA-appraisal.
-However, with this mechanism, userspace programs still need to check
-that the verity bit is set, and there is no protection against verity
-files being swapped around.
+Finally, while the sysctl "fs.verity.require_signatures" is set to 1,
+the kernel requires that all verity files have a builtin signature
+that verifies against the ".fs-verity" keyring.
+
+Note that there is no point in using builtin signatures when
+"fs.verity.require_signatures" is 0 or when userspace doesn't check
+which files have fs-verity enabled.
 
 Filesystem support
 ==================
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index 63807bd0b5364..a5e503f8ca647 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -629,7 +629,6 @@ CONFIG_FS_DAX=y
 CONFIG_EXPORTFS_BLOCK_OPS=y
 CONFIG_FS_ENCRYPTION=y
 CONFIG_FS_VERITY=y
-CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y
 CONFIG_FANOTIFY=y
 CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 4f9a982474423..a754fa5bf2e87 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -615,7 +615,6 @@ CONFIG_FS_DAX=y
 CONFIG_EXPORTFS_BLOCK_OPS=y
 CONFIG_FS_ENCRYPTION=y
 CONFIG_FS_VERITY=y
-CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y
 CONFIG_FANOTIFY=y
 CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
diff --git a/fs/verity/Kconfig b/fs/verity/Kconfig
index aad1f1d998b9d..089e2194650ba 100644
--- a/fs/verity/Kconfig
+++ b/fs/verity/Kconfig
@@ -42,19 +42,24 @@ config FS_VERITY_DEBUG
 
 	  Say N unless you are an fs-verity developer.
 
-config FS_VERITY_BUILTIN_SIGNATURES
-	bool "FS Verity builtin signature support"
+config FS_VERITY_DEPRECATED_BUILTINSIG
+	bool "FS Verity builtin signature support (deprecated)"
 	depends on FS_VERITY
 	select SYSTEM_DATA_VERIFICATION
 	help
-	  Support verifying signatures of verity files against the X.509
-	  certificates that have been loaded into the ".fs-verity"
-	  kernel keyring.
+	  Support verifying builtin signatures of verity files against
+	  the X.509 certificates that have been loaded into the
+	  ".fs-verity" kernel keyring.
 
-	  This is meant as a relatively simple mechanism that can be
-	  used to provide an authenticity guarantee for verity files, as
-	  an alternative to IMA appraisal.  Userspace programs still
-	  need to check that the verity bit is set in order to get an
-	  authenticity guarantee.
+	  This is *not* the recommended way to do signatures with
+	  fs-verity.  This was meant as a proof-of-concept of using
+	  fs-verity to ensure the authenticity of files.  It has been
+	  shown that this is not a good way to do signatures with
+	  fs-verity.  Instead, users should manage and verify
+	  signatures in userspace, or use IMA's fs-verity support.
 
-	  If unsure, say N.
+	  Note: this feature is useless unless userspace sets the
+	  fs.verity.require_signatures sysctl to 1 and verifies that
+	  specific files have fs-verity enabled.
+
+	  Say N unless you need this for backwards compatibility.
diff --git a/fs/verity/Makefile b/fs/verity/Makefile
index 435559a4fa9ea..ec8899d58cbf0 100644
--- a/fs/verity/Makefile
+++ b/fs/verity/Makefile
@@ -8,4 +8,4 @@ obj-$(CONFIG_FS_VERITY) += enable.o \
 			   read_metadata.o \
 			   verify.o
 
-obj-$(CONFIG_FS_VERITY_BUILTIN_SIGNATURES) += signature.o
+obj-$(CONFIG_FS_VERITY_DEPRECATED_BUILTINSIG) += signature.o
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index dbe1ce5b450a8..a4d708a8ea57e 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -127,12 +127,12 @@ void __init fsverity_exit_info_cache(void);
 
 /* signature.c */
 
-#ifdef CONFIG_FS_VERITY_BUILTIN_SIGNATURES
+#ifdef CONFIG_FS_VERITY_DEPRECATED_BUILTINSIG
 int fsverity_verify_signature(const struct fsverity_info *vi,
 			      const u8 *signature, size_t sig_size);
 
 int __init fsverity_init_signature(void);
-#else /* !CONFIG_FS_VERITY_BUILTIN_SIGNATURES */
+#else /* !CONFIG_FS_VERITY_DEPRECATED_BUILTINSIG */
 static inline int
 fsverity_verify_signature(const struct fsverity_info *vi,
 			  const u8 *signature, size_t sig_size)
@@ -144,7 +144,7 @@ static inline int fsverity_init_signature(void)
 {
 	return 0;
 }
-#endif /* !CONFIG_FS_VERITY_BUILTIN_SIGNATURES */
+#endif /* !CONFIG_FS_VERITY_DEPRECATED_BUILTINSIG */
 
 /* verify.c */
 
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index dc6935701abda..24c50072e9cc2 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Verification of builtin signatures
+ * Verification of builtin signatures (deprecated)
  *
  * Copyright 2019 Google LLC
  */
@@ -27,14 +27,18 @@ static int fsverity_require_signatures;
 static struct key *fsverity_keyring;
 
 /**
- * fsverity_verify_signature() - check a verity file's signature
+ * fsverity_verify_signature() - check a verity file's builtin signature
  * @vi: the file's fsverity_info
- * @signature: the file's built-in signature
+ * @signature: the file's builtin signature
  * @sig_size: size of signature in bytes, or 0 if no signature
  *
  * If the file includes a signature of its fs-verity file digest, verify it
  * against the certificates in the fs-verity keyring.
  *
+ * Please don't introduce new uses of fs-verity builtin signatures.  They are a
+ * proof-of-concept that turned out to not be a good way to do signatures with
+ * fs-verity.  Use userspace signature verification or IMA appraisal instead.
+ *
  * Return: 0 on success (signature valid or not required); -errno on failure
  */
 int fsverity_verify_signature(const struct fsverity_info *vi,
@@ -96,7 +100,7 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 		return err;
 	}
 
-	pr_debug("Valid signature for file digest %s:%*phN\n",
+	pr_debug("Valid builtin signature for file digest %s:%*phN\n",
 		 hash_alg->name, hash_alg->digest_size, vi->file_digest);
 	return 0;
 }

base-commit: 479174d402bcf60789106eedc4def3957c060bad
-- 
2.38.1

