Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575EF2B5351
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 21:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732795AbgKPU44 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 15:56:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732798AbgKPU4z (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 15:56:55 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B54592224B;
        Mon, 16 Nov 2020 20:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605560213;
        bh=OOuIczPF6IJCCjIE5+wlaIaVp/KM8ngsZaR4hlVgs9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBe+uGFs431P+J4XgwmGug6gQ/RqRlfdPv/JE4DH1MpReD1j4lSrIbxu/ZTFFty7H
         FjVsUH/24kC1X9IsvFze5o96GzEJHKYf0MpEPcP+mPMyZIB+i7ztmAzM5I3cYG3vv8
         OMVgc+QyNx3tRX2DrILQ1MI6mwWImdRI7acIbe+k=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Luca Boccassi <luca.boccassi@gmail.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: [fsverity-utils PATCH v2 2/4] lib/compute_digest: add default hash_algorithm and block_size
Date:   Mon, 16 Nov 2020 12:56:26 -0800
Message-Id: <20201116205628.262173-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116205628.262173-1-ebiggers@kernel.org>
References: <20201116205628.262173-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

If hash_algorithm is left 0, default it to FS_VERITY_HASH_ALG_SHA256;
and if block_size is left 0, default it to 4096 bytes.

While it's nice to be explicit, having defaults makes things easier for
library users.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/libfsverity.h          | 47 ++++++++++++++++++++++++++--------
 lib/compute_digest.c           | 27 +++++++++++--------
 lib/lib_private.h              |  6 +++++
 programs/cmd_digest.c          |  8 +-----
 programs/cmd_sign.c            |  9 +------
 programs/test_compute_digest.c | 18 ++++++++-----
 6 files changed, 71 insertions(+), 44 deletions(-)

diff --git a/include/libfsverity.h b/include/libfsverity.h
index 8f78a13..985b364 100644
--- a/include/libfsverity.h
+++ b/include/libfsverity.h
@@ -27,15 +27,42 @@ extern "C" {
 #define FS_VERITY_HASH_ALG_SHA256       1
 #define FS_VERITY_HASH_ALG_SHA512       2
 
+/**
+ * struct libfsverity_merkle_tree_params - properties of a file's Merkle tree
+ *
+ * Zero this, then fill in at least @version and @file_size.
+ */
 struct libfsverity_merkle_tree_params {
-	uint32_t version;		/* must be 1			*/
-	uint32_t hash_algorithm;	/* one of FS_VERITY_HASH_ALG_*	*/
-	uint64_t file_size;		/* file size in bytes		*/
-	uint32_t block_size;		/* Merkle tree block size in bytes */
-	uint32_t salt_size;		/* salt size in bytes (0 if unsalted) */
-	const uint8_t *salt;		/* pointer to salt (optional)	*/
-	uint64_t reserved1[8];		/* must be 0 */
-	uintptr_t reserved2[8];		/* must be 0 */
+
+	/** @version: must be 1 */
+	uint32_t version;
+
+	/**
+	 * @hash_algorithm: one of FS_VERITY_HASH_ALG_*, or 0 to use the default
+	 * of FS_VERITY_HASH_ALG_SHA256
+	 */
+	uint32_t hash_algorithm;
+
+	/** @file_size: the file size in bytes */
+	uint64_t file_size;
+
+	/**
+	 * @block_size: the Merkle tree block size in bytes, or 0 to use the
+	 * default of 4096 bytes
+	 */
+	uint32_t block_size;
+
+	/** @salt_size: the salt size in bytes, or 0 if unsalted */
+	uint32_t salt_size;
+
+	/** @salt: pointer to the salt, or NULL if unsalted */
+	const uint8_t *salt;
+
+	/** @reserved1: must be 0 */
+	uint64_t reserved1[8];
+
+	/** @reserved2: must be 0 */
+	uintptr_t reserved2[8];
 };
 
 struct libfsverity_digest {
@@ -69,9 +96,7 @@ typedef int (*libfsverity_read_fn_t)(void *fd, void *buf, size_t count);
  *          digest computed over the entire file.
  * @fd: context that will be passed to @read_fn
  * @read_fn: a function that will read the data of the file
- * @params: struct libfsverity_merkle_tree_params specifying the fs-verity
- *	    version, the hash algorithm, the file size, the block size, and
- *	    optionally a salt.  Reserved fields must be zero.
+ * @params: Pointer to the Merkle tree parameters
  * @digest_ret: Pointer to pointer for computed digest.
  *
  * Returns:
diff --git a/lib/compute_digest.c b/lib/compute_digest.c
index e0b213b..a36795d 100644
--- a/lib/compute_digest.c
+++ b/lib/compute_digest.c
@@ -164,6 +164,8 @@ libfsverity_compute_digest(void *fd, libfsverity_read_fn_t read_fn,
 			   const struct libfsverity_merkle_tree_params *params,
 			   struct libfsverity_digest **digest_ret)
 {
+	u32 alg_num;
+	u32 block_size;
 	const struct fsverity_hash_alg *hash_alg;
 	struct hash_ctx *hash = NULL;
 	struct libfsverity_digest *digest;
@@ -179,9 +181,13 @@ libfsverity_compute_digest(void *fd, libfsverity_read_fn_t read_fn,
 				      params->version);
 		return -EINVAL;
 	}
-	if (!is_power_of_2(params->block_size)) {
+
+	alg_num = params->hash_algorithm ?: FS_VERITY_HASH_ALG_DEFAULT;
+	block_size = params->block_size ?: FS_VERITY_BLOCK_SIZE_DEFAULT;
+
+	if (!is_power_of_2(block_size)) {
 		libfsverity_error_msg("unsupported block size (%u)",
-				      params->block_size);
+				      block_size);
 		return -EINVAL;
 	}
 	if (params->salt_size > sizeof(desc.salt)) {
@@ -201,16 +207,15 @@ libfsverity_compute_digest(void *fd, libfsverity_read_fn_t read_fn,
 		return -EINVAL;
 	}
 
-	hash_alg = libfsverity_find_hash_alg_by_num(params->hash_algorithm);
+	hash_alg = libfsverity_find_hash_alg_by_num(alg_num);
 	if (!hash_alg) {
-		libfsverity_error_msg("unknown hash algorithm: %u",
-				      params->hash_algorithm);
+		libfsverity_error_msg("unknown hash algorithm: %u", alg_num);
 		return -EINVAL;
 	}
 
-	if (params->block_size < 2 * hash_alg->digest_size) {
+	if (block_size < 2 * hash_alg->digest_size) {
 		libfsverity_error_msg("block size (%u) too small for hash algorithm %s",
-				      params->block_size, hash_alg->name);
+				      block_size, hash_alg->name);
 		return -EINVAL;
 	}
 
@@ -220,8 +225,8 @@ libfsverity_compute_digest(void *fd, libfsverity_read_fn_t read_fn,
 
 	memset(&desc, 0, sizeof(desc));
 	desc.version = 1;
-	desc.hash_algorithm = params->hash_algorithm;
-	desc.log_blocksize = ilog2(params->block_size);
+	desc.hash_algorithm = alg_num;
+	desc.log_blocksize = ilog2(block_size);
 	desc.data_size = cpu_to_le64(params->file_size);
 	if (params->salt_size != 0) {
 		memcpy(desc.salt, params->salt, params->salt_size);
@@ -229,7 +234,7 @@ libfsverity_compute_digest(void *fd, libfsverity_read_fn_t read_fn,
 	}
 
 	err = compute_root_hash(fd, read_fn, params->file_size, hash,
-				params->block_size, params->salt,
+				block_size, params->salt,
 				params->salt_size, desc.root_hash);
 	if (err)
 		goto out;
@@ -239,7 +244,7 @@ libfsverity_compute_digest(void *fd, libfsverity_read_fn_t read_fn,
 		err = -ENOMEM;
 		goto out;
 	}
-	digest->digest_algorithm = params->hash_algorithm;
+	digest->digest_algorithm = alg_num;
 	digest->digest_size = hash_alg->digest_size;
 	libfsverity_hash_full(hash, &desc, sizeof(desc), digest->digest);
 	*digest_ret = digest;
diff --git a/lib/lib_private.h b/lib/lib_private.h
index ff00490..7768eea 100644
--- a/lib/lib_private.h
+++ b/lib/lib_private.h
@@ -19,6 +19,12 @@
 
 #define LIBEXPORT	__attribute__((visibility("default")))
 
+/* The hash algorithm that libfsverity assumes when none is specified */
+#define FS_VERITY_HASH_ALG_DEFAULT	FS_VERITY_HASH_ALG_SHA256
+
+/* The block size that libfsverity assumes when none is specified */
+#define FS_VERITY_BLOCK_SIZE_DEFAULT	4096
+
 /* hash_algs.c */
 
 struct fsverity_hash_alg {
diff --git a/programs/cmd_digest.c b/programs/cmd_digest.c
index 7899b04..4f7818e 100644
--- a/programs/cmd_digest.c
+++ b/programs/cmd_digest.c
@@ -86,12 +86,6 @@ int fsverity_cmd_digest(const struct fsverity_command *cmd,
 	if (argc < 1)
 		goto out_usage;
 
-	if (tree_params.hash_algorithm == 0)
-		tree_params.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
-
-	if (tree_params.block_size == 0)
-		tree_params.block_size = 4096;
-
 	for (int i = 0; i < argc; i++) {
 		struct fsverity_signed_digest *d = NULL;
 		struct libfsverity_digest *digest = NULL;
@@ -137,7 +131,7 @@ int fsverity_cmd_digest(const struct fsverity_command *cmd,
 			printf("%s %s\n", digest_hex, argv[i]);
 		else
 			printf("%s:%s %s\n",
-			       libfsverity_get_hash_name(tree_params.hash_algorithm),
+			       libfsverity_get_hash_name(digest->digest_algorithm),
 			       digest_hex, argv[i]);
 
 		filedes_close(&file);
diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
index 9cb7507..4b90944 100644
--- a/programs/cmd_sign.c
+++ b/programs/cmd_sign.c
@@ -101,12 +101,6 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	if (argc != 2)
 		goto out_usage;
 
-	if (tree_params.hash_algorithm == 0)
-		tree_params.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
-
-	if (tree_params.block_size == 0)
-		tree_params.block_size = 4096;
-
 	if (sig_params.keyfile == NULL) {
 		error_msg("Missing --key argument");
 		goto out_usage;
@@ -138,8 +132,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	ASSERT(digest->digest_size <= FS_VERITY_MAX_DIGEST_SIZE);
 	bin2hex(digest->digest, digest->digest_size, digest_hex);
 	printf("Signed file '%s' (%s:%s)\n", argv[0],
-	       libfsverity_get_hash_name(tree_params.hash_algorithm),
-	       digest_hex);
+	       libfsverity_get_hash_name(digest->digest_algorithm), digest_hex);
 	status = 0;
 out:
 	filedes_close(&file);
diff --git a/programs/test_compute_digest.c b/programs/test_compute_digest.c
index eee10f7..e7f2645 100644
--- a/programs/test_compute_digest.c
+++ b/programs/test_compute_digest.c
@@ -139,7 +139,13 @@ static const struct test_case {
 			  "\x56\xce\x29\xa9\x60\xbf\x4b\xb0"
 			  "\xe5\x95\xec\x38\x6c\xa5\x8c\x06"
 			  "\x51\x9d\x54\x6d\xc5\xb1\x97\xbb",
-	}
+	}, { /* default hash algorithm (SHA-256) and block size (4096) */
+		.file_size = 100000,
+		.digest = "\xf2\x09\x6a\x36\xc5\xcd\xca\x4f"
+			  "\xa3\x3e\xe8\x85\x28\x33\x15\x0b"
+			  "\xb3\x24\x99\x2e\x54\x17\xa9\xd5"
+			  "\x71\xf1\xbf\xff\xf7\x3b\x9e\xfc",
+	},
 };
 
 static void fix_digest_and_print(const struct test_case *t,
@@ -206,15 +212,11 @@ static void test_invalid_params(void)
 
 	/* bad hash_algorithm */
 	params = good_params;
-	params.hash_algorithm = 0;
-	ASSERT(libfsverity_compute_digest(&f, read_fn, &params, &d) == -EINVAL);
 	params.hash_algorithm = 1000;
 	ASSERT(libfsverity_compute_digest(&f, read_fn, &params, &d) == -EINVAL);
 
 	/* bad block_size */
 	params = good_params;
-	params.block_size = 0;
-	ASSERT(libfsverity_compute_digest(&f, read_fn, &params, &d) == -EINVAL);
 	params.block_size = 1;
 	ASSERT(libfsverity_compute_digest(&f, read_fn, &params, &d) == -EINVAL);
 	params.block_size = 4097;
@@ -266,6 +268,8 @@ int main(int argc, char *argv[])
 		f.data[i] = (i % 11) + (i % 439) + (i % 1103);
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		u32 expected_alg = test_cases[i].hash_algorithm ?:
+				   FS_VERITY_HASH_ALG_SHA256;
 
 		memset(&params, 0, sizeof(params));
 		params.version = 1;
@@ -283,9 +287,9 @@ int main(int argc, char *argv[])
 		err = libfsverity_compute_digest(&f, read_fn, &params, &d);
 		ASSERT(err == 0);
 
-		ASSERT(d->digest_algorithm == test_cases[i].hash_algorithm);
+		ASSERT(d->digest_algorithm == expected_alg);
 		ASSERT(d->digest_size ==
-		       libfsverity_get_digest_size(test_cases[i].hash_algorithm));
+		       libfsverity_get_digest_size(expected_alg));
 		if (update)
 			fix_digest_and_print(&test_cases[i], d);
 		else
-- 
2.29.2

