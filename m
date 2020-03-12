Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23667183BAD
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 22:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgCLVsY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 17:48:24 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34227 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgCLVsY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 17:48:24 -0400
Received: by mail-qk1-f196.google.com with SMTP id f3so9031507qkh.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 12 Mar 2020 14:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ok6ER6RFfhHaEaOxgnPvuc6QdJ04aInl1ZOVdWBdHxY=;
        b=so06BDgplMMSBWBKmIAQsaVyZnJiYqdUUp28UQoCuACcpHbffur7TEUGhlBgUJHqPf
         cTzLZMadCsOC0xJt6GVVB/ONikarpD0pHxkhho/yy5W/8ksYGWV5/052QHV3crvhc0/I
         hLlHI3Xzf23tV3/40U7Bp5MgejBWH3Pe5gn2WP3ep1njv1ogkJxSDrjaclCP8JIbRdvq
         PvQGsIhIUe6u9oLCKuhM0OcLpxLI4bFKgP3mGmT+l6UtpADE18pkrjPens/f7hx16Fbe
         Ng18dsGau4YLZUSwPgFiezr0M3diRYk1MXFzIPvGUEujNIaNea+HYBH+IPKHsM37/bzi
         NR1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ok6ER6RFfhHaEaOxgnPvuc6QdJ04aInl1ZOVdWBdHxY=;
        b=jAzxAlpKhQJS8UzQdZeMYSkUTx8dDL1NJcrOJaNbf2bDlZhcw6sACfkO0sUVL9r+KU
         SRVVQtDLlr84pz9Z9ErjmIixC6bjJz4e6hflZMybz9fW8zWAtEJftKO1KG1aDWOA3yWX
         Iapm1dU/Ifym74q1HtlEu3G6eUM4v/Wq7brIlUQEhQ8MkCVonNDUBSgSXlkKUSWjsWMv
         Ko/p81AwOnGDCmJr9248DsCSuQr0rFKZVXEzEt6e26Pta7q0mgtHoh+U7gQ+asN1wN4R
         hW/bMy1zcFBp0oFgjC3vclqa8UXvARbT9HgwSLXEHMzoMKEYX9HxRvs8maDra1U9y2aX
         WYFg==
X-Gm-Message-State: ANhLgQ2QYdmFLOr9EEoOnP5MZSDaxKB9SFNC7lTj/aDCt44Rgng7TbkY
        F6Uavonxr/0ttPFwnzU/l+FSgV7E
X-Google-Smtp-Source: ADFU+vtKDvPyw9Ol2h6B7jc8OeL3Y4A++/9OV/xee0tFlSoU4EyjBQ0Enz3gxV9CkzfCd47JxfJUog==
X-Received: by 2002:a37:6e06:: with SMTP id j6mr9964690qkc.171.1584049702444;
        Thu, 12 Mar 2020 14:48:22 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::fa82])
        by smtp.gmail.com with ESMTPSA id n6sm7961420qkh.70.2020.03.12.14.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 14:48:21 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 5/9] Create libfsverity_compute_digest() and adapt cmd_sign to use it
Date:   Thu, 12 Mar 2020 17:47:54 -0400
Message-Id: <20200312214758.343212-6-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

This reorganizes the digest signing code and moves it to the shared library.
In addition libfsverity_private.h is created for library internal data
structures, in particular struct fsverity_decriptor.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_sign.c            | 194 ++-------------------------------------
 libfsverity.h         |  17 ----
 libfsverity_private.h |  33 +++++++
 libverity.c           | 207 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 250 insertions(+), 201 deletions(-)
 create mode 100644 libfsverity_private.h

diff --git a/cmd_sign.c b/cmd_sign.c
index 5ad4eda..6a5d185 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -16,12 +16,9 @@
 #include <openssl/pkcs7.h>
 #include <stdlib.h>
 #include <string.h>
-#include <sys/stat.h>
-#include <unistd.h>
 
 #include "commands.h"
 #include "libfsverity.h"
-#include "hash_algs.h"
 
 /*
  * Format in which verity file measurements are signed.  This is the same as
@@ -337,179 +334,6 @@ static bool write_signature(const char *filename, const u8 *sig, u32 sig_size)
 	return ok;
 }
 
-#define FS_VERITY_MAX_LEVELS	64
-
-struct block_buffer {
-	u32 filled;
-	u8 *data;
-};
-
-/*
- * Hash a block, writing the result to the next level's pending block buffer.
- * Returns true if the next level's block became full, else false.
- */
-static bool hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
-			   u32 block_size, const u8 *salt, u32 salt_size)
-{
-	struct block_buffer *next = cur + 1;
-
-	/* Zero-pad the block if it's shorter than block_size. */
-	memset(&cur->data[cur->filled], 0, block_size - cur->filled);
-
-	hash_init(hash);
-	hash_update(hash, salt, salt_size);
-	hash_update(hash, cur->data, block_size);
-	hash_final(hash, &next->data[next->filled]);
-
-	next->filled += hash->alg->digest_size;
-	cur->filled = 0;
-
-	return next->filled + hash->alg->digest_size > block_size;
-}
-
-static int full_read_fd(int fd, void *buf, size_t count)
-{
-	while (count) {
-		int n = read(fd, buf, min(count, INT_MAX));
-
-		if (n < 0) {
-			error_msg_errno("reading from file");
-			return n;
-		}
-		if (n == 0) {
-			error_msg("unexpected end-of-file");
-			return -ENODATA;
-		}
-		buf += n;
-		count -= n;
-	}
-	return 0;
-}
-
-/*
- * Compute the file's Merkle tree root hash using the given hash algorithm,
- * block size, and salt.
- */
-static bool compute_root_hash(int fd, u64 file_size,
-			      struct hash_ctx *hash, u32 block_size,
-			      const u8 *salt, u32 salt_size, u8 *root_hash)
-{
-	const u32 hashes_per_block = block_size / hash->alg->digest_size;
-	const u32 padded_salt_size = roundup(salt_size, hash->alg->block_size);
-	u8 *padded_salt = xzalloc(padded_salt_size);
-	u64 blocks;
-	int num_levels = 0;
-	int level;
-	struct block_buffer _buffers[1 + FS_VERITY_MAX_LEVELS + 1] = {};
-	struct block_buffer *buffers = &_buffers[1];
-	u64 offset;
-	bool ok = false;
-
-	if (salt_size != 0)
-		memcpy(padded_salt, salt, salt_size);
-
-	/* Compute number of levels */
-	for (blocks = DIV_ROUND_UP(file_size, block_size); blocks > 1;
-	     blocks = DIV_ROUND_UP(blocks, hashes_per_block)) {
-		ASSERT(num_levels < FS_VERITY_MAX_LEVELS);
-		num_levels++;
-	}
-
-	/*
-	 * Allocate the block buffers.  Buffer "-1" is for data blocks.
-	 * Buffers 0 <= level < num_levels are for the actual tree levels.
-	 * Buffer 'num_levels' is for the root hash.
-	 */
-	for (level = -1; level < num_levels; level++)
-		buffers[level].data = xmalloc(block_size);
-	buffers[num_levels].data = root_hash;
-
-	/* Hash each data block, also hashing the tree blocks as they fill up */
-	for (offset = 0; offset < file_size; offset += block_size) {
-		buffers[-1].filled = min(block_size, file_size - offset);
-
-		if (full_read_fd(fd, buffers[-1].data, buffers[-1].filled))
-			goto out;
-
-		level = -1;
-		while (hash_one_block(hash, &buffers[level], block_size,
-				      padded_salt, padded_salt_size)) {
-			level++;
-			ASSERT(level < num_levels);
-		}
-	}
-	/* Finish all nonempty pending tree blocks */
-	for (level = 0; level < num_levels; level++) {
-		if (buffers[level].filled != 0)
-			hash_one_block(hash, &buffers[level], block_size,
-				       padded_salt, padded_salt_size);
-	}
-
-	/* Root hash was filled by the last call to hash_one_block() */
-	ASSERT(buffers[num_levels].filled == hash->alg->digest_size);
-	ok = true;
-out:
-	for (level = -1; level < num_levels; level++)
-		free(buffers[level].data);
-	free(padded_salt);
-	return ok;
-}
-
-/*
- * Compute the fs-verity measurement of the given file.
- *
- * The fs-verity measurement is the hash of the fsverity_descriptor, which
- * contains the Merkle tree properties including the root hash.
- */
-static bool compute_file_measurement(int fd,
-				     const struct fsverity_hash_alg *hash_alg,
-				     u32 block_size, const u8 *salt,
-				     u32 salt_size, u8 *measurement)
-{
-	struct hash_ctx *hash = hash_alg->create_ctx(hash_alg);
-	u64 file_size;
-	struct fsverity_descriptor desc;
-	struct stat stbuf;
-	bool ok = false;
-
-	if (fstat(fd, &stbuf) != 0) {
-		error_msg_errno("can't stat input file");
-		goto out;
-	}
-	file_size = stbuf.st_size;
-
-	memset(&desc, 0, sizeof(desc));
-	desc.version = 1;
-	desc.hash_algorithm = hash_alg->hash_num;
-
-	ASSERT(is_power_of_2(block_size));
-	desc.log_blocksize = ilog2(block_size);
-
-	if (salt_size != 0) {
-		if (salt_size > sizeof(desc.salt)) {
-			error_msg("Salt too long (got %u bytes; max is %zu bytes)",
-				  salt_size, sizeof(desc.salt));
-			goto out;
-		}
-		memcpy(desc.salt, salt, salt_size);
-		desc.salt_size = salt_size;
-	}
-
-	desc.data_size = cpu_to_le64(file_size);
-
-	/* Root hash of empty file is all 0's */
-	if (file_size != 0 &&
-	    !compute_root_hash(fd, file_size, hash, block_size, salt,
-			       salt_size, desc.root_hash))
-		goto out;
-
-	hash_full(hash, &desc, sizeof(desc), measurement);
-	ok = true;
-out:
-	hash_free(hash);
-	return ok;
-}
-
 enum {
 	OPT_HASH_ALG,
 	OPT_BLOCK_SIZE,
@@ -538,7 +362,8 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	u32 salt_size = 0;
 	const char *keyfile = NULL;
 	const char *certfile = NULL;
-	struct fsverity_signed_digest *digest = NULL;
+	struct libfsverity_digest *digest = NULL;
+	struct libfsverity_merkle_tree_params params;
 	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + 1];
 	u8 *sig = NULL;
 	u32 sig_size;
@@ -608,16 +433,17 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	if (certfile == NULL)
 		certfile = keyfile;
 
-	digest = xzalloc(sizeof(*digest) + hash_alg->digest_size);
-	memcpy(digest->magic, "FSVerity", 8);
-	digest->digest_algorithm = cpu_to_le16(hash_alg->hash_num);
-	digest->digest_size = cpu_to_le16(hash_alg->digest_size);
-
 	if (!open_file(&file, argv[0], O_RDONLY, 0))
 		goto out_err;
 
-	if (!compute_file_measurement(file.fd, hash_alg, block_size,
-				      salt, salt_size, digest->digest))
+	memset(&params, 0, sizeof(struct libfsverity_merkle_tree_params));
+	params.version = 1;
+	params.hash_algorithm = hash_alg->hash_num;
+	params.block_size = block_size;
+	params.salt_size = salt_size;
+	params.salt = salt;
+
+	if (libfsverity_compute_digest(file.fd, &params, &digest))
 		goto out_err;
 
 	filedes_close(&file);
diff --git a/libfsverity.h b/libfsverity.h
index 318dcd7..cb5f5b6 100644
--- a/libfsverity.h
+++ b/libfsverity.h
@@ -49,23 +49,6 @@ struct libfsverity_signature_params {
 	uint64_t reserved[11];
 };
 
-/*
- * Merkle tree properties.  The file measurement is the hash of this structure
- * excluding the signature and with the sig_size field set to 0.
- */
-struct fsverity_descriptor {
-	uint8_t version;	/* must be 1 */
-	uint8_t hash_algorithm;	/* Merkle tree hash algorithm */
-	uint8_t log_blocksize;	/* log2 of size of data and tree blocks */
-	uint8_t salt_size;	/* size of salt in bytes; 0 if none */
-	__le32 sig_size;	/* size of signature in bytes; 0 if none */
-	__le64 data_size;	/* size of file the Merkle tree is built over */
-	uint8_t root_hash[64];	/* Merkle tree root hash */
-	uint8_t salt[32];	/* salt prepended to each hashed block */
-	uint8_t __reserved[144];/* must be 0's */
-	uint8_t signature[];	/* optional PKCS#7 signature */
-};
-
 struct fsverity_hash_alg {
 	const char *name;
 	unsigned int digest_size;
diff --git a/libfsverity_private.h b/libfsverity_private.h
new file mode 100644
index 0000000..5f3e1b4
--- /dev/null
+++ b/libfsverity_private.h
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * libfsverity private interfaces
+ *
+ * Copyright (C) 2018 Google LLC
+ * Copyright (C) 2020 Facebook
+ *
+ * Written by Eric Biggers and modified by Jes Sorensen.
+ */
+#ifndef _LIBFSVERITY_PRIVATE_H
+#define _LIBFSVERITY_PRIVATE_H
+
+#include <stdint.h>
+#include <linux/types.h>
+
+/*
+ * Merkle tree properties.  The file measurement is the hash of this structure
+ * excluding the signature and with the sig_size field set to 0.
+ */
+struct fsverity_descriptor {
+	uint8_t version;	/* must be 1 */
+	uint8_t hash_algorithm;	/* Merkle tree hash algorithm */
+	uint8_t log_blocksize;	/* log2 of size of data and tree blocks */
+	uint8_t salt_size;	/* size of salt in bytes; 0 if none */
+	__le32 sig_size;	/* size of signature in bytes; 0 if none */
+	__le64 data_size;	/* size of file the Merkle tree is built over */
+	uint8_t root_hash[64];	/* Merkle tree root hash */
+	uint8_t salt[32];	/* salt prepended to each hashed block */
+	uint8_t __reserved[144];/* must be 0's */
+	uint8_t signature[];	/* optional PKCS#7 signature */
+};
+
+#endif
diff --git a/libverity.c b/libverity.c
index 6821aa2..19272f7 100644
--- a/libverity.c
+++ b/libverity.c
@@ -8,3 +8,210 @@
  * Written by Eric Biggers and Jes Sorensen.
  */
 
+#include <openssl/bio.h>
+#include <openssl/err.h>
+#include <openssl/pem.h>
+#include <openssl/pkcs7.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "libfsverity.h"
+#include "libfsverity_private.h"
+#include "hash_algs.h"
+
+#define FS_VERITY_MAX_LEVELS	64
+
+struct block_buffer {
+	u32 filled;
+	u8 *data;
+};
+
+/*
+ * Hash a block, writing the result to the next level's pending block buffer.
+ * Returns true if the next level's block became full, else false.
+ */
+static bool hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
+			   u32 block_size, const u8 *salt, u32 salt_size)
+{
+	struct block_buffer *next = cur + 1;
+
+	/* Zero-pad the block if it's shorter than block_size. */
+	memset(&cur->data[cur->filled], 0, block_size - cur->filled);
+
+	hash_init(hash);
+	hash_update(hash, salt, salt_size);
+	hash_update(hash, cur->data, block_size);
+	hash_final(hash, &next->data[next->filled]);
+
+	next->filled += hash->alg->digest_size;
+	cur->filled = 0;
+
+	return next->filled + hash->alg->digest_size > block_size;
+}
+
+static int full_read_fd(int fd, void *buf, size_t count)
+{
+	while (count) {
+		int n = read(fd, buf, min(count, INT_MAX));
+
+		if (n < 0) {
+			error_msg_errno("reading from file");
+			return n;
+		}
+		if (n == 0) {
+			error_msg("unexpected end-of-file");
+			return -ENODATA;
+		}
+		buf += n;
+		count -= n;
+	}
+	return 0;
+}
+
+/*
+ * Compute the file's Merkle tree root hash using the given hash algorithm,
+ * block size, and salt.
+ */
+static bool compute_root_hash(int fd, u64 file_size,
+			      struct hash_ctx *hash, u32 block_size,
+			      const u8 *salt, u32 salt_size, u8 *root_hash)
+{
+	const u32 hashes_per_block = block_size / hash->alg->digest_size;
+	const u32 padded_salt_size = roundup(salt_size, hash->alg->block_size);
+	u8 *padded_salt = xzalloc(padded_salt_size);
+	u64 blocks;
+	int num_levels = 0;
+	int level;
+	struct block_buffer _buffers[1 + FS_VERITY_MAX_LEVELS + 1] = {};
+	struct block_buffer *buffers = &_buffers[1];
+	u64 offset;
+	bool ok = false;
+
+	if (salt_size != 0)
+		memcpy(padded_salt, salt, salt_size);
+
+	/* Compute number of levels */
+	for (blocks = DIV_ROUND_UP(file_size, block_size); blocks > 1;
+	     blocks = DIV_ROUND_UP(blocks, hashes_per_block)) {
+		ASSERT(num_levels < FS_VERITY_MAX_LEVELS);
+		num_levels++;
+	}
+
+	/*
+	 * Allocate the block buffers.  Buffer "-1" is for data blocks.
+	 * Buffers 0 <= level < num_levels are for the actual tree levels.
+	 * Buffer 'num_levels' is for the root hash.
+	 */
+	for (level = -1; level < num_levels; level++)
+		buffers[level].data = xmalloc(block_size);
+	buffers[num_levels].data = root_hash;
+
+	/* Hash each data block, also hashing the tree blocks as they fill up */
+	for (offset = 0; offset < file_size; offset += block_size) {
+		buffers[-1].filled = min(block_size, file_size - offset);
+
+		if (full_read_fd(fd, buffers[-1].data, buffers[-1].filled))
+			goto out;
+
+		level = -1;
+		while (hash_one_block(hash, &buffers[level], block_size,
+				      padded_salt, padded_salt_size)) {
+			level++;
+			ASSERT(level < num_levels);
+		}
+	}
+	/* Finish all nonempty pending tree blocks */
+	for (level = 0; level < num_levels; level++) {
+		if (buffers[level].filled != 0)
+			hash_one_block(hash, &buffers[level], block_size,
+				       padded_salt, padded_salt_size);
+	}
+
+	/* Root hash was filled by the last call to hash_one_block() */
+	ASSERT(buffers[num_levels].filled == hash->alg->digest_size);
+	ok = true;
+out:
+	for (level = -1; level < num_levels; level++)
+		free(buffers[level].data);
+	free(padded_salt);
+	return ok;
+}
+
+/*
+ * Compute the fs-verity measurement of the given file.
+ *
+ * The fs-verity measurement is the hash of the fsverity_descriptor, which
+ * contains the Merkle tree properties including the root hash.
+ */
+int
+libfsverity_compute_digest(int fd,
+			   const struct libfsverity_merkle_tree_params *params,
+			   struct libfsverity_digest **digest_ret)
+{
+	const struct fsverity_hash_alg *hash_alg;
+	struct libfsverity_digest *digest;
+	struct hash_ctx *hash;
+	struct fsverity_descriptor desc;
+	struct stat stbuf;
+	u64 file_size;
+	int retval = -EINVAL;
+
+	hash_alg = libfsverity_find_hash_alg_by_num(params->hash_algorithm);
+	hash = hash_alg->create_ctx(hash_alg);
+
+	digest = malloc(sizeof(struct libfsverity_digest) +
+			hash_alg->digest_size);
+	if (!digest_ret)
+		return -ENOMEM;
+	memcpy(digest->magic, "FSVerity", 8);
+	digest->digest_algorithm = cpu_to_le16(hash_alg->hash_num);
+	digest->digest_size = cpu_to_le16(hash_alg->digest_size);
+	memset(digest->digest, 0, hash_alg->digest_size);
+
+	if (fstat(fd, &stbuf) != 0) {
+		error_msg_errno("can't stat input file");
+		retval = -EBADF;
+		goto error_out;
+	}
+	file_size = stbuf.st_size;
+
+	memset(&desc, 0, sizeof(desc));
+	desc.version = 1;
+	desc.hash_algorithm = params->hash_algorithm;
+
+	ASSERT(is_power_of_2(params->block_size));
+	desc.log_blocksize = ilog2(params->block_size);
+
+	if (params->salt_size != 0) {
+		if (params->salt_size > sizeof(desc.salt)) {
+			error_msg("Salt too long (got %u bytes; max is %zu bytes)",
+				  params->salt_size, sizeof(desc.salt));
+			retval = EINVAL;
+			goto error_out;
+		}
+		memcpy(desc.salt, params->salt, params->salt_size);
+		desc.salt_size = params->salt_size;
+	}
+
+	desc.data_size = cpu_to_le64(file_size);
+
+	/* Root hash of empty file is all 0's */
+	if (file_size != 0 &&
+	    !compute_root_hash(fd, file_size, hash, params->block_size,
+			       params->salt, params->salt_size,
+			       desc.root_hash)) {
+		retval = -EAGAIN;
+		goto error_out;
+	}
+
+	hash_full(hash, &desc, sizeof(desc), digest->digest);
+	hash_free(hash);
+	*digest_ret = digest;
+
+	return 0;
+
+ error_out:
+	free(digest);
+	return retval;
+}
-- 
2.24.1

