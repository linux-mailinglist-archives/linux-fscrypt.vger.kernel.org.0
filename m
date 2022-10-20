Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9FD606680
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 18:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJTQ7g (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 12:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiJTQ7f (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 12:59:35 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C4C32C;
        Thu, 20 Oct 2022 09:59:30 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 7F8C4811D3;
        Thu, 20 Oct 2022 12:59:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666285169; bh=S6wlQC8tqo0GJvjmmEtuNyVGNPAmIbcT6aZU5tJ3wE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F53olXR/olfZtAC7HKcjDjjvGFiSVU/BC6OlpSxlx8pxnNZZTSigc7PYdt3dDwg/W
         KP9tSeHdIHeQedBnV5WbZhoomuCDRN5sLF60+NruhYylhVKm4/3EyTyJ8QnIpb6nZy
         CmjHIlpVzcCNHCT8eQIDT/E4BfhD7cp348OBPtCbbTnnetH6mx0eK9BgDRXCSvRpGR
         N1fRHhKU16e/mftFBkk6qPDk2m5rkota9aPkmzbrNCYpvI08HjCHKYTcfUseGai9RV
         /Jl1UkizoqD9TAe1xE06964mvi1NXuSizxAnru/KqAo/JFgJD+RCI7So3QB1SoSlAA
         UiniMYInMG1tg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 15/22] btrfs: encrypt normal file extent data if appropriate
Date:   Thu, 20 Oct 2022 12:58:34 -0400
Message-Id: <cfb16a33dd7f56c9f2d13a5645e670de8df93d96.1666281277.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1666281276.git.sweettea-kernel@dorminy.me>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

Add in the necessary calls to encrypt and decrypt data to achieve
encryption of normal data.

Since these are all page cache pages being encrypted, we can't encrypt
them in place and must encrypt/decrypt into a new page. fscrypt provides a pool
of pages for this purpose, which it calls bounce pages. For IO of
encrypted data, we use a bounce page for the actual IO, and
encrypt/decrypt from/to the actual page cache page on either side of the
IO.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/extent_io.c    | 56 ++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/file-item.c    |  9 +++++--
 fs/btrfs/fscrypt.c      | 32 ++++++++++++++++++++++-
 fs/btrfs/tree-checker.c | 11 +++++---
 4 files changed, 96 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4e4f28387ace..94d0636aafd0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -113,6 +113,7 @@ static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
 {
 	struct bio *bio;
 	struct bio_vec *bv;
+	struct page *first_page;
 	struct inode *inode;
 	int mirror_num;
 
@@ -121,13 +122,17 @@ static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
 
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
@@ -1014,9 +1019,19 @@ static void end_bio_extent_writepage(struct btrfs_bio *bbio)
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
@@ -1037,7 +1052,7 @@ static void end_bio_extent_writepage(struct btrfs_bio *bbio)
 		}
 
 		end_extent_writepage(page, error, start, end);
-
+		fscrypt_free_bounce_page(bounce_page);
 		btrfs_page_clear_writeback(fs_info, page, start, bvec->bv_len);
 	}
 
@@ -1229,6 +1244,17 @@ static void end_bio_extent_readpage(struct btrfs_bio *bbio)
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
@@ -1563,11 +1589,29 @@ static int submit_extent_page(blk_opf_t opf,
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
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 598dff14078f..e4ec6a97a85c 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -676,8 +676,13 @@ blk_status_t btrfs_csum_one_bio(struct btrfs_inode *inode, struct bio *bio,
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
index 717a9c244306..324436cba989 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -175,7 +175,37 @@ static int btrfs_fscrypt_get_extent_context(const struct inode *inode,
 					    size_t *extent_offset,
 					    size_t *extent_length)
 {
-	return len;
+	u64 offset = lblk_num << inode->i_blkbits;
+	struct extent_map *em;
+
+	/* Since IO must be in progress on this extent, this must succeed */
+	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, PAGE_SIZE);
+	if (em) {
+		int ret = ctx ? em->fscrypt_context.len : 0;
+
+		if (em->block_start == EXTENT_MAP_HOLE) {
+			btrfs_info(BTRFS_I(inode)->root->fs_info,
+				   "extent context requested for block %llu of inode %llu without an extent",
+				   lblk_num, inode->i_ino);
+			free_extent_map(em);
+			return -ENOENT;
+		}
+
+		if (ctx)
+			memcpy(ctx, em->fscrypt_context.buffer,
+			       em->fscrypt_context.len);
+
+		if (extent_offset)
+			*extent_offset
+				 = (offset - em->start) >> inode->i_blkbits;
+
+		if (extent_length)
+			*extent_length = em->len >> inode->i_blkbits;
+
+		free_extent_map(em);
+		return ret;
+	}
+	return -EINVAL;
 }
 
 static int btrfs_fscrypt_set_extent_context(void *extent, void *ctx,
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 868ac7f2aeed..d17e34aea386 100644
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

