Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B04239AB30
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Jun 2021 22:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhFCUBv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Jun 2021 16:01:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhFCUBu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Jun 2021 16:01:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA4936139A;
        Thu,  3 Jun 2021 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622750405;
        bh=2YrqxSaDbqrkFqauDM9hRRvR/T2mY7ydopo8x9/nUM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJ8gwo14bYXKXby51c+KvUMBeqeFJt3hLxvz+1q5z3M1CAx+RCg2UwHZt+kZcByb2
         HTSp858jEmDc/fBBUwlPJ1I1SoL1nzccDRQ3Q0ER66Q2Ra6Fr6zau+Sv/AoBuoU7pq
         obBofjl9nmZ8vlYa009IPrlIT020wWt034cY36BrB3yRtBBhuq8b1Hc4DX7CDK0OrO
         /zRN0KW27U0P3sE9VN1k5mXhT/lZqUVSgvVzZdvpX+5PHaq+ua3TBC3q8jxPJP9doF
         a2tnbnpEmnzjU/FrIb+Y+jwj0wnnxmSeRvDQk3Y3HSW/qm4J3OPTqVmsqf+DN0oY3U
         TmDmKLdpWJ89Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>
Subject: [fsverity-utils PATCH 1/4] lib/compute_digest: add callbacks for getting the verity metadata
Date:   Thu,  3 Jun 2021 12:58:09 -0700
Message-Id: <20210603195812.50838-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603195812.50838-1-ebiggers@kernel.org>
References: <20210603195812.50838-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Allow callers of libfsverity_compute_digest() to provide callback
functions which get passed the Merkle tree and fs-verity descriptor
after they are calculated.

This will allow adding options to 'fsverity digest' and 'fsverity sign'
which cause this metadata to be dumped to files.  Normally this isn't
useful, but this can be needed in cases where the fs-verity metadata
needs to be consumed by something other than one of the native Linux
kernel implementations of fs-verity.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/libfsverity.h |  46 ++++++++++++++-
 lib/compute_digest.c  | 130 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 156 insertions(+), 20 deletions(-)

diff --git a/include/libfsverity.h b/include/libfsverity.h
index 6c42e5e..c2c6c18 100644
--- a/include/libfsverity.h
+++ b/include/libfsverity.h
@@ -61,8 +61,18 @@ struct libfsverity_merkle_tree_params {
 	/** @reserved1: must be 0 */
 	uint64_t reserved1[8];
 
+	/**
+	 * @metadata_callbacks: if non-NULL, this gives a set of callback
+	 * functions to which libfsverity_compute_digest() will pass the Merkle
+	 * tree blocks and fs-verity descriptor after they are computed.
+	 * Normally this isn't useful, but this can be needed in rare cases
+	 * where the metadata needs to be consumed by something other than one
+	 * of the native Linux kernel implementations of fs-verity.
+	 */
+	const struct libfsverity_metadata_callbacks *metadata_callbacks;
+
 	/** @reserved2: must be 0 */
-	uintptr_t reserved2[8];
+	uintptr_t reserved2[7];
 };
 
 struct libfsverity_digest {
@@ -78,6 +88,37 @@ struct libfsverity_signature_params {
 	uintptr_t reserved2[8];		/* must be 0 */
 };
 
+struct libfsverity_metadata_callbacks {
+
+	/** @ctx: context passed to the below callbacks (opaque to library) */
+	void *ctx;
+
+	/**
+	 * @merkle_tree_size: if non-NULL, called with the total size of the
+	 * Merkle tree in bytes, prior to any call to @merkle_tree_block.  Must
+	 * return 0 on success, or a negative errno value on failure.
+	 */
+	int (*merkle_tree_size)(void *ctx, uint64_t size);
+
+	/**
+	 * @merkle_tree_block: if non-NULL, called with each block of the
+	 * Merkle tree after it is computed.  The offset is the offset in bytes
+	 * to the block within the Merkle tree, using the Merkle tree layout
+	 * used by FS_IOC_READ_VERITY_METADATA.  The offsets won't necessarily
+	 * be in increasing order.  Must return 0 on success, or a negative
+	 * errno value on failure.
+	 */
+	int (*merkle_tree_block)(void *ctx, const void *block, size_t size,
+				 uint64_t offset);
+
+	/**
+	 * @descriptor: if non-NULL, called with the fs-verity descriptor after
+	 * it is computed.  Must return 0 on success, or a negative errno value
+	 * on failure.
+	 */
+	int (*descriptor)(void *ctx, const void *descriptor, size_t size);
+};
+
 /*
  * libfsverity_read_fn_t - callback that incrementally provides a file's data
  * @fd: the user-provided "file descriptor" (opaque to library)
@@ -101,7 +142,8 @@ typedef int (*libfsverity_read_fn_t)(void *fd, void *buf, size_t count);
  *
  * Returns:
  * * 0 for success, -EINVAL for invalid input arguments, -ENOMEM if libfsverity
- *   failed to allocate memory, or an error returned by @read_fn.
+ *   failed to allocate memory, or an error returned by @read_fn or by one of
+ *   the @params->metadata_callbacks.
  * * digest_ret returns a pointer to the digest on success. The digest object
  *   is allocated by libfsverity and must be freed by the caller using free().
  */
diff --git a/lib/compute_digest.c b/lib/compute_digest.c
index a4f649c..c5b0100 100644
--- a/lib/compute_digest.c
+++ b/lib/compute_digest.c
@@ -24,9 +24,8 @@ struct block_buffer {
 
 /*
  * Hash a block, writing the result to the next level's pending block buffer.
- * Returns true if the next level's block became full, else false.
  */
-static bool hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
+static void hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
 			   u32 block_size, const u8 *salt, u32 salt_size)
 {
 	struct block_buffer *next = cur + 1;
@@ -41,8 +40,60 @@ static bool hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
 
 	next->filled += hash->alg->digest_size;
 	cur->filled = 0;
+}
+
+static bool block_is_full(const struct block_buffer *block, u32 block_size,
+			  struct hash_ctx *hash)
+{
+	/* Would the next hash put us over the limit? */
+	return block->filled + hash->alg->digest_size > block_size;
+}
+
+static int report_merkle_tree_size(const struct libfsverity_metadata_callbacks *cbs,
+				   u64 size)
+{
+	if (cbs && cbs->merkle_tree_size) {
+		int err = cbs->merkle_tree_size(cbs->ctx, size);
 
-	return next->filled + hash->alg->digest_size > block_size;
+		if (err) {
+			libfsverity_error_msg("error processing Merkle tree size");
+			return err;
+		}
+	}
+	return 0;
+}
+
+static int report_merkle_tree_block(const struct libfsverity_metadata_callbacks *cbs,
+				    const struct block_buffer *block,
+				    u32 block_size, u64 *level_offset)
+{
+
+	if (cbs && cbs->merkle_tree_block) {
+		int err = cbs->merkle_tree_block(cbs->ctx, block->data,
+						 block_size,
+						 *level_offset * block_size);
+
+		if (err) {
+			libfsverity_error_msg("error processing Merkle tree block");
+			return err;
+		}
+		(*level_offset)++;
+	}
+	return 0;
+}
+
+static int report_descriptor(const struct libfsverity_metadata_callbacks *cbs,
+			     const void *descriptor, size_t size)
+{
+	if (cbs && cbs->descriptor) {
+		int err = cbs->descriptor(cbs->ctx, descriptor, size);
+
+		if (err) {
+			libfsverity_error_msg("error processing fs-verity descriptor");
+			return err;
+		}
+	}
+	return 0;
 }
 
 /*
@@ -52,6 +103,7 @@ static bool hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
 static int compute_root_hash(void *fd, libfsverity_read_fn_t read_fn,
 			     u64 file_size, struct hash_ctx *hash,
 			     u32 block_size, const u8 *salt, u32 salt_size,
+			     const struct libfsverity_metadata_callbacks *metadata_cbs,
 			     u8 *root_hash)
 {
 	const u32 hashes_per_block = block_size / hash->alg->digest_size;
@@ -60,6 +112,7 @@ static int compute_root_hash(void *fd, libfsverity_read_fn_t read_fn,
 	u64 blocks;
 	int num_levels = 0;
 	int level;
+	u64 level_offset[FS_VERITY_MAX_LEVELS];
 	struct block_buffer _buffers[1 + FS_VERITY_MAX_LEVELS + 1] = {};
 	struct block_buffer *buffers = &_buffers[1];
 	u64 offset;
@@ -68,7 +121,7 @@ static int compute_root_hash(void *fd, libfsverity_read_fn_t read_fn,
 	/* Root hash of empty file is all 0's */
 	if (file_size == 0) {
 		memset(root_hash, 0, hash->alg->digest_size);
-		return 0;
+		return report_merkle_tree_size(metadata_cbs, 0);
 	}
 
 	if (salt_size != 0) {
@@ -78,15 +131,39 @@ static int compute_root_hash(void *fd, libfsverity_read_fn_t read_fn,
 		memcpy(padded_salt, salt, salt_size);
 	}
 
-	/* Compute number of levels */
-	for (blocks = DIV_ROUND_UP(file_size, block_size); blocks > 1;
-	     blocks = DIV_ROUND_UP(blocks, hashes_per_block)) {
+	/* Compute number of levels and the number of blocks in each level. */
+	blocks = DIV_ROUND_UP(file_size, block_size);
+	while (blocks > 1)  {
 		if (WARN_ON(num_levels >= FS_VERITY_MAX_LEVELS)) {
 			err = -EINVAL;
 			goto out;
 		}
-		num_levels++;
+		blocks = DIV_ROUND_UP(blocks, hashes_per_block);
+		/*
+		 * Temporarily use level_offset[] to store the number of blocks
+		 * in each level.  It will be overwritten later.
+		 */
+		level_offset[num_levels++] = blocks;
+	}
+
+	/*
+	 * Compute the starting block of each level, using the convention where
+	 * the root level is first, i.e. the convention used by
+	 * FS_IOC_READ_VERITY_METADATA.  At the same time, compute the total
+	 * size of the Merkle tree.  These values are only needed for the
+	 * metadata callbacks (if they were given), as the hash computation
+	 * itself doesn't prescribe an ordering of the levels and doesn't
+	 * prescribe any special meaning to the total size of the Merkle tree.
+	 */
+	offset = 0;
+	for (level = num_levels - 1; level >= 0; level--) {
+		blocks = level_offset[level];
+		level_offset[level] = offset;
+		offset += blocks;
 	}
+	err = report_merkle_tree_size(metadata_cbs, offset * block_size);
+	if (err)
+		goto out;
 
 	/*
 	 * Allocate the block buffers.  Buffer "-1" is for data blocks.
@@ -112,21 +189,33 @@ static int compute_root_hash(void *fd, libfsverity_read_fn_t read_fn,
 			goto out;
 		}
 
-		level = -1;
-		while (hash_one_block(hash, &buffers[level], block_size,
-				      padded_salt, padded_salt_size)) {
-			level++;
-			if (WARN_ON(level >= num_levels)) {
-				err = -EINVAL;
+		hash_one_block(hash, &buffers[-1], block_size,
+			       padded_salt, padded_salt_size);
+		for (level = 0; level < num_levels; level++) {
+			if (!block_is_full(&buffers[level], block_size, hash))
+				break;
+			hash_one_block(hash, &buffers[level], block_size,
+				       padded_salt, padded_salt_size);
+			err = report_merkle_tree_block(metadata_cbs,
+						       &buffers[level],
+						       block_size,
+						       &level_offset[level]);
+			if (err)
 				goto out;
-			}
 		}
 	}
 	/* Finish all nonempty pending tree blocks */
 	for (level = 0; level < num_levels; level++) {
-		if (buffers[level].filled != 0)
+		if (buffers[level].filled != 0) {
 			hash_one_block(hash, &buffers[level], block_size,
 				       padded_salt, padded_salt_size);
+			err = report_merkle_tree_block(metadata_cbs,
+						       &buffers[level],
+						       block_size,
+						       &level_offset[level]);
+			if (err)
+				goto out;
+		}
 	}
 
 	/* Root hash was filled by the last call to hash_one_block() */
@@ -217,8 +306,13 @@ libfsverity_compute_digest(void *fd, libfsverity_read_fn_t read_fn,
 	}
 
 	err = compute_root_hash(fd, read_fn, params->file_size, hash,
-				block_size, params->salt,
-				params->salt_size, desc.root_hash);
+				block_size, params->salt, params->salt_size,
+				params->metadata_callbacks, desc.root_hash);
+	if (err)
+		goto out;
+
+	err = report_descriptor(params->metadata_callbacks,
+				&desc, sizeof(desc));
 	if (err)
 		goto out;
 
-- 
2.31.1

