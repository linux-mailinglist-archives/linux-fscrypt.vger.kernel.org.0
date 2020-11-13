Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0736F2B26FB
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Nov 2020 22:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgKMVeY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 16:34:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgKMVeG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 16:34:06 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B750022255;
        Fri, 13 Nov 2020 21:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605303245;
        bh=Mkx7D5wb3Z3sP0Sjns8IQg+PVKBTLPNKLffUKJD+s3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWgteyvLLeurqFSrk1UnwjZIw31UGGqHCCyPsUCKQp6oYSUtMc3uQQvwY/3l9YZbd
         Geu0bmCvWzjSAOPrdIa/jLvzPChgiDefAca3iPwjuY8iBBfithJl4A4w/NSxfbkDmr
         gHhh8E4BZJtDNMzsSTne9ExrOeB/E8KbkPMPV3oE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Luca Boccassi <luca.boccassi@gmail.com>,
        Martijn Coenen <maco@android.com>,
        Paul Lawrence <paullawrence@google.com>
Subject: [fsverity-utils PATCH 1/2] Upgrade to latest fsverity_uapi.h
Date:   Fri, 13 Nov 2020 13:33:13 -0800
Message-Id: <20201113213314.73616-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201113213314.73616-1-ebiggers@kernel.org>
References: <20201113213314.73616-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The latest UAPI header includes the declarations of fsverity_descriptor
and fsverity_formatted_digest (previously fsverity_signed_digest).
Therefore they no longer need to be declared in other files.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/fsverity_uapi.h | 49 ++++++++++++++++++++++++++++++++++++++++++
 lib/compute_digest.c   | 17 ---------------
 lib/sign_digest.c      | 15 +------------
 programs/cmd_digest.c  | 11 ++--------
 4 files changed, 52 insertions(+), 40 deletions(-)

diff --git a/common/fsverity_uapi.h b/common/fsverity_uapi.h
index da0daf6..260017a 100644
--- a/common/fsverity_uapi.h
+++ b/common/fsverity_uapi.h
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
 
diff --git a/lib/compute_digest.c b/lib/compute_digest.c
index e0b213b..25bba1f 100644
--- a/lib/compute_digest.c
+++ b/lib/compute_digest.c
@@ -17,23 +17,6 @@
 
 #define FS_VERITY_MAX_LEVELS	64
 
-/*
- * Merkle tree properties.  The file measurement is the hash of this structure
- * excluding the signature and with the sig_size field set to 0.
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
 struct block_buffer {
 	u32 filled;
 	u8 *data;
diff --git a/lib/sign_digest.c b/lib/sign_digest.c
index 1f73007..9a35256 100644
--- a/lib/sign_digest.c
+++ b/lib/sign_digest.c
@@ -19,19 +19,6 @@
 #include <openssl/pkcs7.h>
 #include <string.h>
 
-/*
- * Format in which verity file measurements are signed.  This is the same as
- * 'struct fsverity_digest', except here some magic bytes are prepended to
- * provide some context about what is being signed in case the same key is used
- * for non-fsverity purposes, and here the fields have fixed endianness.
- */
-struct fsverity_signed_digest {
-	char magic[8];			/* must be "FSVerity" */
-	__le16 digest_algorithm;
-	__le16 digest_size;
-	__u8 digest[];
-};
-
 static int print_openssl_err_cb(const char *str,
 				size_t len __attribute__((unused)),
 				void *u __attribute__((unused)))
@@ -339,7 +326,7 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
 	EVP_PKEY *pkey = NULL;
 	X509 *cert = NULL;
 	const EVP_MD *md;
-	struct fsverity_signed_digest *d = NULL;
+	struct fsverity_formatted_digest *d = NULL;
 	int err;
 
 	if (!digest || !sig_params || !sig_ret || !sig_size_ret)  {
diff --git a/programs/cmd_digest.c b/programs/cmd_digest.c
index 180f438..420ba82 100644
--- a/programs/cmd_digest.c
+++ b/programs/cmd_digest.c
@@ -31,13 +31,6 @@ static const struct option longopts[] = {
 	{NULL, 0, NULL, 0}
 };
 
-struct fsverity_signed_digest {
-	char magic[8];			/* must be "FSVerity" */
-	__le16 digest_algorithm;
-	__le16 digest_size;
-	__u8 digest[];
-};
-
 /*
  * Compute the fs-verity measurement of the given file(s), for offline signing.
  */
@@ -93,10 +86,10 @@ int fsverity_cmd_digest(const struct fsverity_command *cmd,
 		tree_params.block_size = get_default_block_size();
 
 	for (int i = 0; i < argc; i++) {
-		struct fsverity_signed_digest *d = NULL;
+		struct fsverity_formatted_digest *d = NULL;
 		struct libfsverity_digest *digest = NULL;
 		char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 +
-				sizeof(struct fsverity_signed_digest) * 2 + 1];
+				sizeof(*d) * 2 + 1];
 
 		if (!open_file(&file, argv[i], O_RDONLY, 0))
 			goto out_err;
-- 
2.29.2

