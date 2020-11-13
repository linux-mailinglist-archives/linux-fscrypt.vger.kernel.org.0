Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E91C2B267A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Nov 2020 22:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgKMVUv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 16:20:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:40730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726355AbgKMVUu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 16:20:50 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CEEF22258;
        Fri, 13 Nov 2020 21:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605302449;
        bh=QjiQvf7g9yKcGU5m9aqGw/qrrLu6PiIemjru5rN3w4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=108beoJREVHxUgHoAtZEL/NOxOzAcLAMUUBsn6UpyFKMRNKc0XRIkEMuCuaSWaXGU
         xlSrI1lShWwZca4wx9rocE2exuguVnpgoKYmYbwi7RmmHf4wjykNhwc3TsEIurbeBB
         a+P+H1wSGEjdfunncywOSdcfDI9WBnUGJxhqSfhE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Victor Hsieh <victorhsieh@google.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Luca Boccassi <luca.boccassi@gmail.com>,
        Martijn Coenen <maco@android.com>,
        Paul Lawrence <paullawrence@google.com>
Subject: [PATCH 4/4] fs-verity: move structs needed for file signing to UAPI header
Date:   Fri, 13 Nov 2020 13:19:18 -0800
Message-Id: <20201113211918.71883-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201113211918.71883-1-ebiggers@kernel.org>
References: <20201113211918.71883-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Although it isn't used directly by the ioctls,
"struct fsverity_descriptor" is required by userspace programs that need
to compute fs-verity file digests in a standalone way.  Therefore
it's also needed to sign files in a standalone way.

Similarly, "struct fsverity_formatted_digest" (previously called
"struct fsverity_signed_digest" which was misleading) is also needed to
sign files if the built-in signature verification is being used.

Therefore, move these structs to the UAPI header.

While doing this, try to make it clear that the signature-related fields
in fsverity_descriptor aren't used in the file digest computation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fsverity.rst |  6 +---
 fs/verity/fsverity_private.h           | 37 -------------------
 include/uapi/linux/fsverity.h          | 49 ++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 42 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 2eee558b7f5ff..e0204a23e997e 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -334,17 +334,13 @@ root hash as well as other fields such as the file size::
             __u8 hash_algorithm;    /* Merkle tree hash algorithm */
             __u8 log_blocksize;     /* log2 of size of data and tree blocks */
             __u8 salt_size;         /* size of salt in bytes; 0 if none */
-            __le32 sig_size;        /* must be 0 */
+            __le32 __reserved_0x04; /* must be 0 */
             __le64 data_size;       /* size of file the Merkle tree is built over */
             __u8 root_hash[64];     /* Merkle tree root hash */
             __u8 salt[32];          /* salt prepended to each hashed block */
             __u8 __reserved[144];   /* must be 0's */
     };
 
-Note that the ``sig_size`` field must be set to 0 for the purpose of
-computing the file measurement, even if a signature was provided (or
-will be provided) to `FS_IOC_ENABLE_VERITY`_.
-
 Built-in signature verification
 ===============================
 
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index 21e9930d65fbd..96f7b332f54f5 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -77,49 +77,12 @@ struct fsverity_info {
 	const struct inode *inode;
 };
 
-/*
- * Merkle tree properties.  The fs-verity file digest is the hash of this
- * structure excluding the signature and with the sig_size field set to 0.
- */
-struct fsverity_descriptor {
-	__u8 version;		/* must be 1 */
-	__u8 hash_algorithm;	/* Merkle tree hash algorithm */
-	__u8 log_blocksize;	/* log2 of size of data and tree blocks */
-	__u8 salt_size;		/* size of salt in bytes; 0 if none */
-	__le32 sig_size;	/* size of signature in bytes; 0 if none */
-	__le64 data_size;	/* size of file the Merkle tree is built over */
-	__u8 root_hash[64];	/* Merkle tree root hash */
-	__u8 salt[32];		/* salt prepended to each hashed block */
-	__u8 __reserved[144];	/* must be 0's */
-	__u8 signature[];	/* optional PKCS#7 signature */
-};
-
 /* Arbitrary limit to bound the kmalloc() size.  Can be changed. */
 #define FS_VERITY_MAX_DESCRIPTOR_SIZE	16384
 
 #define FS_VERITY_MAX_SIGNATURE_SIZE	(FS_VERITY_MAX_DESCRIPTOR_SIZE - \
 					 sizeof(struct fsverity_descriptor))
 
-/*
- * Format in which fs-verity file digests are signed in built-in signatures.
- * This is the same as 'struct fsverity_digest', except here some magic bytes
- * are prepended to provide some context about what is being signed in case the
- * same key is used for non-fsverity purposes, and here the fields have fixed
- * endianness.
- *
- * This struct is specific to the built-in signature verification support, which
- * is optional.  fs-verity users may also verify signatures in userspace, in
- * which case userspace is responsible for deciding on what bytes are signed.
- * This struct may still be used, but it doesn't have to be.  For example,
- * userspace could instead use a string like "sha256:$digest_as_hex_string".
- */
-struct fsverity_formatted_digest {
-	char magic[8];			/* must be "FSVerity" */
-	__le16 digest_algorithm;
-	__le16 digest_size;
-	__u8 digest[];
-};
-
 /* hash_algs.c */
 
 extern struct fsverity_hash_alg fsverity_hash_algs[];
diff --git a/include/uapi/linux/fsverity.h b/include/uapi/linux/fsverity.h
index da0daf6c193b4..260017a4b44b3 100644
--- a/include/uapi/linux/fsverity.h
+++ b/include/uapi/linux/fsverity.h
@@ -34,6 +34,55 @@ struct fsverity_digest {
 	__u8 digest[];
 };
 
+/*
+ * Struct containing a file's Merkle tree properties.  The fs-verity file digest
+ * is the hash of this struct.  A userspace program needs this struct only if it
+ * needs to compute fs-verity file digests itself, e.g. in order to sign files.
+ * It isn't needed just to enable fs-verity on a file.
+ *
+ * Note: when computing the file digest, 'sig_size' and 'signature' must be left
+ * zero and empty, respectively.  These fields are present only because some
+ * filesystems reuse this struct as part of their on-disk format.
+ */
+struct fsverity_descriptor {
+	__u8 version;		/* must be 1 */
+	__u8 hash_algorithm;	/* Merkle tree hash algorithm */
+	__u8 log_blocksize;	/* log2 of size of data and tree blocks */
+	__u8 salt_size;		/* size of salt in bytes; 0 if none */
+#ifdef __KERNEL__
+	__le32 sig_size;
+#else
+	__le32 __reserved_0x04;
+#endif
+	__le64 data_size;	/* size of file the Merkle tree is built over */
+	__u8 root_hash[64];	/* Merkle tree root hash */
+	__u8 salt[32];		/* salt prepended to each hashed block */
+	__u8 __reserved[144];	/* must be 0's */
+#ifdef __KERNEL__
+	__u8 signature[];
+#endif
+};
+
+/*
+ * Format in which fs-verity file digests are signed in built-in signatures.
+ * This is the same as 'struct fsverity_digest', except here some magic bytes
+ * are prepended to provide some context about what is being signed in case the
+ * same key is used for non-fsverity purposes, and here the fields have fixed
+ * endianness.
+ *
+ * This struct is specific to the built-in signature verification support, which
+ * is optional.  fs-verity users may also verify signatures in userspace, in
+ * which case userspace is responsible for deciding on what bytes are signed.
+ * This struct may still be used, but it doesn't have to be.  For example,
+ * userspace could instead use a string like "sha256:$digest_as_hex_string".
+ */
+struct fsverity_formatted_digest {
+	char magic[8];			/* must be "FSVerity" */
+	__le16 digest_algorithm;
+	__le16 digest_size;
+	__u8 digest[];
+};
+
 #define FS_IOC_ENABLE_VERITY	_IOW('f', 133, struct fsverity_enable_arg)
 #define FS_IOC_MEASURE_VERITY	_IOWR('f', 134, struct fsverity_digest)
 
-- 
2.29.2

