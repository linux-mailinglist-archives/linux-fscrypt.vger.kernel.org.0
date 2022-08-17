Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625BE5971D6
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 16:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbiHQOv0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Aug 2022 10:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiHQOvZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Aug 2022 10:51:25 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D49A2A42B;
        Wed, 17 Aug 2022 07:51:24 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 65DEC8042B;
        Wed, 17 Aug 2022 10:50:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1660747884; bh=OlozKYfOnwxc30qMXzB0M/kFw+zUFBtMZOWMgXEidbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLy+la3yUHZ3OhlGYugI+Lm0kydP1S1Fh15eBHzEmHdLNBywk3SdbSfQRrBgAOYK3
         B2jyHM1Qpjf+nAZAUHXNE/d9OFcuI8cRAMu1Yy8R+wDrqlfoBAASLE056yb+W/3AUB
         5nS7iDxrJooEVAGggXIWkIaZBzXvsg4geDjpncVO1GtWRhQE+v4MYi2DhqXzcwfa3H
         i99tJf0wT277gImin7O8yKfAUAEsW8uVAHqi75axNcbz9IK/mPeUOXqwRQWtanJDYA
         eePGRQgymy3ug8joyL+W/IB9vZq96sQY0pt0KAvJLllTySUHIDZKsav3ApUqpYSAcs
         7u1YFN8vX9ThQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 20/21] btrfs: encrypt normal file extent data if appropriate
Date:   Wed, 17 Aug 2022 10:50:04 -0400
Message-Id: <c34db0a234ab3b681909710b1d7865695375756f.1660744500.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1660744500.git.sweettea-kernel@dorminy.me>
References: <cover.1660744500.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

Add in the necessary calls to encrypt and decrypt data to achieve
encryption of normal data.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/extent_io.c    | 56 ++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/file-item.c    |  9 +++++--
 fs/btrfs/fscrypt.c      | 27 ++++++++++++++++----
 fs/btrfs/inode.c        | 19 +++++++-------
 fs/btrfs/tree-checker.c | 11 +++++---
 5 files changed, 97 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ff2b995ded6e..440f8b41469b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -184,6 +184,7 @@ static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
 {
 	struct bio *bio;
 	struct bio_vec *bv;
+	struct page *first_page;
 	struct inode *inode;
 	int mirror_num;
 
@@ -192,13 +193,17 @@ static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
 
 	bio = bio_ctrl->bio;
 	bv = bio_first_bvec_all(bio);
-	inode = bv->bv_page->mapping->host;
+	first_page = bio_first_page_all(bio);
+	if (fscrypt_is_bounce_page(first_page))
+		inode = fscrypt_pagecache_page(first_page)->mapping->host;
+	else
+		inode = first_page->mapping->host;
 	mirror_num = bio_ctrl->mirror_num;
 
 	/* Caller should ensure the bio has at least some range added */
 	ASSERT(bio->bi_iter.bi_size);
 
-	btrfs_bio(bio)->file_offset = page_offset(bv->bv_page) + bv->bv_offset;
+	btrfs_bio(bio)->file_offset = page_offset(first_page) + bv->bv_offset;
 
 	if (!is_data_inode(inode))
 		btrfs_submit_metadata_bio(inode, bio, mirror_num);
@@ -2836,9 +2841,19 @@ static void end_bio_extent_writepage(struct bio *bio)
 	ASSERT(!bio_flagged(bio, BIO_CLONED));
 	bio_for_each_segment_all(bvec, bio, iter_all) {
 		struct page *page = bvec->bv_page;
-		struct inode *inode = page->mapping->host;
-		struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-		const u32 sectorsize = fs_info->sectorsize;
+		struct inode *inode;
+		struct btrfs_fs_info *fs_info;
+		u32 sectorsize;
+		struct page *bounce_page = NULL;
+
+		if (fscrypt_is_bounce_page(page)) {
+			bounce_page = page;
+			page = fscrypt_pagecache_page(bounce_page);
+		}
+
+		inode = page->mapping->host;
+		fs_info = btrfs_sb(inode->i_sb);
+		sectorsize = fs_info->sectorsize;
 
 		/* Our read/write should always be sector aligned. */
 		if (!IS_ALIGNED(bvec->bv_offset, sectorsize))
@@ -2859,7 +2874,7 @@ static void end_bio_extent_writepage(struct bio *bio)
 		}
 
 		end_extent_writepage(page, error, start, end);
-
+		fscrypt_free_bounce_page(bounce_page);
 		btrfs_page_clear_writeback(fs_info, page, start, bvec->bv_len);
 	}
 
@@ -3058,6 +3073,17 @@ static void end_bio_extent_readpage(struct bio *bio)
 			}
 		}
 
+		if (likely(uptodate)) {
+			if (fscrypt_inode_uses_fs_layer_crypto(inode)) {
+				int ret = fscrypt_decrypt_pagecache_blocks(page,
+									   bvec->bv_len,
+									   bvec->bv_offset);
+				if (ret) {
+					error_bitmap = (unsigned int) -1;
+					uptodate = false;
+					}
+			}
+		}
 		if (likely(uptodate)) {
 			loff_t i_size = i_size_read(inode);
 			pgoff_t end_index = i_size >> PAGE_SHIFT;
@@ -3415,11 +3441,29 @@ static int submit_extent_page(unsigned int opf,
 			      bool force_bio_submit)
 {
 	int ret = 0;
+	struct page *bounce_page = NULL;
 	struct btrfs_inode *inode = BTRFS_I(page->mapping->host);
 	unsigned int cur = pg_offset;
 
 	ASSERT(bio_ctrl);
 
+	if ((opf & REQ_OP_MASK) == REQ_OP_WRITE &&
+	    fscrypt_inode_uses_fs_layer_crypto(&inode->vfs_inode)) {
+		gfp_t gfp_flags = GFP_NOFS;
+
+		if (bio_ctrl->bio)
+			gfp_flags = GFP_NOWAIT | __GFP_NOWARN;
+		else
+			gfp_flags = GFP_NOFS;
+		bounce_page = fscrypt_encrypt_pagecache_blocks(page, size,
+							       pg_offset,
+							       gfp_flags);
+		if (IS_ERR(bounce_page))
+			return PTR_ERR(bounce_page);
+		page = bounce_page;
+		pg_offset = 0;
+	}
+
 	ASSERT(pg_offset < PAGE_SIZE && size <= PAGE_SIZE &&
 	       pg_offset + size <= PAGE_SIZE);
 	if (force_bio_submit)
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 066d59707408..c3780eacdd35 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -663,8 +663,13 @@ blk_status_t btrfs_csum_one_bio(struct btrfs_inode *inode, struct bio *bio,
 	shash->tfm = fs_info->csum_shash;
 
 	bio_for_each_segment(bvec, bio, iter) {
-		if (use_page_offsets)
-			offset = page_offset(bvec.bv_page) + bvec.bv_offset;
+		if (use_page_offsets) {
+			struct page *page = bvec.bv_page;
+
+			if (fscrypt_is_bounce_page(page))
+				page = fscrypt_pagecache_page(page);
+			offset = page_offset(page) + bvec.bv_offset;
+		}
 
 		if (!ordered) {
 			ordered = btrfs_lookup_ordered_extent(inode, offset);
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 95a84d426d06..df19c7690b12 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -190,11 +190,28 @@ static bool btrfs_fscrypt_empty_dir(struct inode *inode)
 static void btrfs_fscrypt_get_iv(u8 *iv, int ivsize, struct inode *inode,
 				 u64 lblk_num)
 {
-	/*
-	 * For encryption that doesn't involve extent data, juse use the
-	 * nonce already loaded into the iv buffer.
-	 */
-	return;
+	u64 offset = lblk_num << inode->i_blkbits;
+	struct extent_map *em;
+
+	if (lblk_num == 0) {
+		/* Must be a filename or a symlink. Just use the nonce. */
+		return;
+	}
+
+	/* Since IO must be in progress on this extent, this must succeed */
+	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, PAGE_SIZE);
+	ASSERT(!IS_ERR(em) && em);
+	if (em) {
+		__le64 *iv_64 = (__le64 *)iv;
+		memcpy(iv, em->iv, ivsize);
+		/*
+		 * Add the lblk_num to the low bits of the IV to ensure
+		 * the IV changes for every page
+		 */
+		*iv_64 = cpu_to_le64(le64_to_cpu(*iv_64) + lblk_num);
+		free_extent_map(em);
+		return;
+	}
 }
 
 const struct fscrypt_operations btrfs_fscrypt_ops = {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d0fe956c0927..8e07d4f2a1b7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1016,7 +1016,6 @@ static int submit_one_async_extent(struct btrfs_inode *inode,
 		ret = PTR_ERR(em);
 		goto out_free_reserve;
 	}
-	free_extent_map(em);
 
 	ret = btrfs_add_ordered_extent(inode, start,		/* file_offset */
 				       async_extent->ram_size,	/* num_bytes */
@@ -1025,7 +1024,8 @@ static int submit_one_async_extent(struct btrfs_inode *inode,
 				       ins.offset,		/* disk_num_bytes */
 				       0,			/* offset */
 				       1 << BTRFS_ORDERED_COMPRESSED,
-				       async_extent->compress_type, NULL);
+				       async_extent->compress_type, em->iv);
+	free_extent_map(em);
 	if (ret) {
 		btrfs_drop_extent_cache(inode, start, end, 0);
 		goto out_free_reserve;
@@ -1298,12 +1298,12 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 			ret = PTR_ERR(em);
 			goto out_reserve;
 		}
-		free_extent_map(em);
 
 		ret = btrfs_add_ordered_extent(inode, start, ram_size, ram_size,
 					       ins.objectid, cur_alloc_size, 0,
 					       1 << BTRFS_ORDERED_REGULAR,
-					       BTRFS_COMPRESS_NONE, NULL);
+					       BTRFS_COMPRESS_NONE, em->iv);
+		free_extent_map(em);
 		if (ret)
 			goto out_drop_extent_cache;
 
@@ -2094,14 +2094,14 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 				ret = PTR_ERR(em);
 				goto error;
 			}
-			free_extent_map(em);
 			ret = btrfs_add_ordered_extent(inode,
 					cur_offset, nocow_args.num_bytes,
 					nocow_args.num_bytes,
 					nocow_args.disk_bytenr,
 					nocow_args.num_bytes, 0,
 					1 << BTRFS_ORDERED_PREALLOC,
-					BTRFS_COMPRESS_NONE, NULL);
+					BTRFS_COMPRESS_NONE, em->iv);
+			free_extent_map(em);
 			if (ret) {
 				btrfs_drop_extent_cache(inode, cur_offset,
 							nocow_end, 0);
@@ -7435,7 +7435,7 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 				       block_len, 0,
 				       (1 << type) |
 				       (1 << BTRFS_ORDERED_DIRECT),
-				       BTRFS_COMPRESS_NONE, NULL);
+				       BTRFS_COMPRESS_NONE, em->iv);
 	if (ret) {
 		if (em) {
 			free_extent_map(em);
@@ -7709,6 +7709,7 @@ static struct extent_map *create_io_em(struct btrfs_inode *inode, u64 start,
 	struct extent_map_tree *em_tree;
 	struct extent_map *em;
 	int ret;
+	const u8 ivsize = fscrypt_mode_ivsize(&inode->vfs_inode);
 
 	ASSERT(type == BTRFS_ORDERED_PREALLOC ||
 	       type == BTRFS_ORDERED_COMPRESSED ||
@@ -11195,14 +11196,14 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 		ret = PTR_ERR(em);
 		goto out_free_reserved;
 	}
-	free_extent_map(em);
 
 	ret = btrfs_add_ordered_extent(inode, start, num_bytes, ram_bytes,
 				       ins.objectid, ins.offset,
 				       encoded->unencoded_offset,
 				       (1 << BTRFS_ORDERED_ENCODED) |
 				       (1 << BTRFS_ORDERED_COMPRESSED),
-				       compression, NULL);
+				       compression, em->iv);
+	free_extent_map(em);
 	if (ret) {
 		btrfs_drop_extent_cache(inode, start, end, 0);
 		goto out_free_reserved;
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index e6b3f92ab56f..1ccfaa138f55 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -273,9 +273,14 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 			return -EUCLEAN;
 		}
 
-		/* Compressed inline extent has no on-disk size, skip it */
-		if (btrfs_file_extent_compression(leaf, fi) !=
-		    BTRFS_COMPRESS_NONE)
+		/*
+		 * Compressed inline extent has no on-disk size; encrypted has
+		 * variable size; skip them
+		 */
+		if ((btrfs_file_extent_compression(leaf, fi) !=
+		     BTRFS_COMPRESS_NONE) ||
+		    (btrfs_file_extent_encryption(leaf, fi) !=
+		     BTRFS_ENCRYPTION_NONE))
 			return 0;
 
 		/* Uncompressed inline extent size must match item size */
-- 
2.35.1

