Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7376F7C41A5
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343877AbjJJUl5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbjJJUlp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:45 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA27EC4
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:42 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-5a1ec43870cso76020747b3.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970502; x=1697575302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S7o7qRJqT7WXIHnR39I2blCqbRVV+PPhUWMOckSNH4U=;
        b=vM+pPHIXQtZuKbji5vowhecXexz6KycDpHdi2gvrUae+3st2fjCu1EhUC51j4n2pQf
         BVcyXUeMQ7MEVcPF/3uho68LpMppfpfuE6MxJdtaM4towevnGJNIdYxwbqZC4iKQ+ley
         hpZTKmfTdnSXEdzq1u97O4tNdqB1sbpaiTVbR/ic5rH7+r2CqGH7SBw+42DgubmJ5N1f
         1rjZxJFiOyn1PecufmqEyf1uwxoooCe7ly635VBsX9Lx994xee3jtP0ug7XlSVOBFVwb
         zhr4+M4A+zpYEhFXLtJo9MzUbrMhWOeCb89vG601w/Xe1QVwModgRnAps01lef/CNy3d
         6WmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970502; x=1697575302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7o7qRJqT7WXIHnR39I2blCqbRVV+PPhUWMOckSNH4U=;
        b=cxegDR97zmz2VKACJZdKMgca6xQSsD0Rj0TozqDETf2Qp5RmmAvLRx5HyKxZKtRPkU
         jFMy9xbO1md9UqM6noR3JYvhS6FfFqlldO6X+Kqx6RJWdeqR5akTO99BQHgCPn9epP1f
         3lnVnuzydwfK7v/eczW0InBBdfpUOR5pozXAJozYowFZcXvhoZC070fmXJ/OYM414S2w
         agRYMNeyW6cCMWt3E436AiQJGos8Joa182vu7Tiv9ONM50qtj2ZO7dm/O81nru7BvxhE
         K3whD57bQzGwb2TrRJjh7aTeKHi3VLUYfVErDcTShMAY7L8+/JsyCQROa/EdFvVgkHi6
         gpOQ==
X-Gm-Message-State: AOJu0YyEGTXbMSeCPq7mfKR64WHHNLKhRgXk6WLk6gN0mF9lBk4gBjLN
        vNsZnH+wqMmXE4PFCP2I9id5cLr58XaLzThqzeVa1Q==
X-Google-Smtp-Source: AGHT+IF56fOXVijiTvVq7mGk6XMP5ct7mplE+soyERrKF85z3nWuaShbfnhDav7lNYWAoe69p25SRQ==
X-Received: by 2002:a81:5bd5:0:b0:589:f9f0:2e8c with SMTP id p204-20020a815bd5000000b00589f9f02e8cmr19088355ywb.48.1696970501984;
        Tue, 10 Oct 2023 13:41:41 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id o140-20020a0dcc92000000b005a7c829dda2sm484413ywd.84.2023.10.10.13.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:41 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 33/36] btrfs: set the bio fscrypt context when applicable
Date:   Tue, 10 Oct 2023 16:40:48 -0400
Message-ID: <64e97e21c9aa1a1c48252142c6e02297324d2558.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Now that we have the fscrypt_info plumbed through everywhere, add the
code to setup the bio encryption context from the extent context.

We use the per-extent fscrypt_extent_info for encryption/decryption.
We use the offset into the extent as the lblk for fscrypt.  So the start
of the extent has the lblk of 0, 4k into the extent has the lblk of 4k,
etc.  This is done to allow things like relocation to continue to work
properly.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/compression.c |  6 ++++
 fs/btrfs/extent_io.c   | 63 +++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/fscrypt.c     | 36 ++++++++++++++++++++++++
 fs/btrfs/fscrypt.h     | 22 +++++++++++++++
 fs/btrfs/inode.c       | 10 +++++++
 5 files changed, 136 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 19b22b4653c8..3f586ee40b94 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -36,6 +36,7 @@
 #include "zoned.h"
 #include "file-item.h"
 #include "super.h"
+#include "fscrypt.h"
 
 static struct bio_set btrfs_compressed_bioset;
 
@@ -301,6 +302,9 @@ void btrfs_submit_compressed_write(struct btrfs_ordered_extent *ordered,
 	cb->bbio.ordered = ordered;
 	btrfs_add_compressed_bio_pages(cb);
 
+	btrfs_set_bio_crypt_ctx_from_extent(&cb->bbio.bio, inode,
+					    ordered->fscrypt_info, 0);
+
 	btrfs_submit_bio(&cb->bbio, 0);
 }
 
@@ -504,6 +508,8 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	cb->compress_type = em->compress_type;
 	cb->orig_bbio = bbio;
 
+	btrfs_set_bio_crypt_ctx_from_extent(&cb->bbio.bio, inode,
+					    em->fscrypt_info, 0);
 	free_extent_map(em);
 
 	cb->nr_pages = DIV_ROUND_UP(compressed_len, PAGE_SIZE);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c4265826278d..2251417106ea 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -37,6 +37,7 @@
 #include "dev-replace.h"
 #include "super.h"
 #include "transaction.h"
+#include "fscrypt.h"
 
 static struct kmem_cache *extent_buffer_cache;
 
@@ -103,6 +104,10 @@ struct btrfs_bio_ctrl {
 	blk_opf_t opf;
 	btrfs_bio_end_io_t end_io_func;
 	struct writeback_control *wbc;
+
+	/* This is set for reads and we have encryption. */
+	struct fscrypt_extent_info *fscrypt_info;
+	u64 orig_start;
 };
 
 static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
@@ -707,10 +712,31 @@ static bool btrfs_bio_is_contig(struct btrfs_bio_ctrl *bio_ctrl,
 				struct page *page, u64 disk_bytenr,
 				unsigned int pg_offset)
 {
-	struct bio *bio = &bio_ctrl->bbio->bio;
+	struct inode *inode = page->mapping->host;
+	struct btrfs_bio *bbio = bio_ctrl->bbio;
+	struct bio *bio = &bbio->bio;
 	struct bio_vec *bvec = bio_last_bvec_all(bio);
 	const sector_t sector = disk_bytenr >> SECTOR_SHIFT;
 
+	if (IS_ENCRYPTED(inode)) {
+		u64 file_offset = page_offset(page) + pg_offset;
+		u64 offset = 0;
+		struct fscrypt_extent_info *fscrypt_info = NULL;
+
+		/* bio_ctrl->fscrypt_info is only set in the READ case. */
+		if (bio_ctrl->fscrypt_info) {
+			offset = file_offset - bio_ctrl->orig_start;
+			fscrypt_info = bio_ctrl->fscrypt_info;
+		} else if (bbio->ordered) {
+			fscrypt_info = bbio->ordered->fscrypt_info;
+			offset = file_offset - bbio->ordered->orig_offset;
+		}
+
+		if (!btrfs_mergeable_encrypted_bio(bio, inode, fscrypt_info,
+						   offset))
+			return false;
+	}
+
 	if (bio_ctrl->compress_type != BTRFS_COMPRESS_NONE) {
 		/*
 		 * For compression, all IO should have its logical bytenr set
@@ -741,6 +767,8 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_bio *bbio;
+	struct fscrypt_extent_info *fscrypt_info = NULL;
+	u64 offset = 0;
 
 	bbio = btrfs_bio_alloc(BIO_MAX_VECS, bio_ctrl->opf, fs_info,
 			       bio_ctrl->end_io_func, NULL);
@@ -760,6 +788,8 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 					ordered->file_offset +
 					ordered->disk_num_bytes - file_offset);
 			bbio->ordered = ordered;
+			fscrypt_info = ordered->fscrypt_info;
+			offset = file_offset - ordered->orig_offset;
 		}
 
 		/*
@@ -770,7 +800,13 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 		 */
 		bio_set_dev(&bbio->bio, fs_info->fs_devices->latest_dev->bdev);
 		wbc_init_bio(bio_ctrl->wbc, &bbio->bio);
+	} else {
+		fscrypt_info = bio_ctrl->fscrypt_info;
+		offset = file_offset - bio_ctrl->orig_start;
 	}
+
+	btrfs_set_bio_crypt_ctx_from_extent(&bbio->bio, inode, fscrypt_info,
+					    offset);
 }
 
 /*
@@ -1004,6 +1040,8 @@ static int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 		bool force_bio_submit = false;
 		u64 disk_bytenr;
 
+		bio_ctrl->fscrypt_info = NULL;
+
 		ASSERT(IS_ALIGNED(cur, fs_info->sectorsize));
 		if (cur >= last_byte) {
 			iosize = PAGE_SIZE - pg_offset;
@@ -1078,6 +1116,22 @@ static int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 		if (prev_em_start)
 			*prev_em_start = em->start;
 
+		/*
+		 * We use the extent offset for the IV when decrypting the page,
+		 * so we have to set the extent_offset based on the orig_start
+		 * for this extent.  Also save the fscrypt_info so the bio ctx
+		 * can be set properly.  If this inode isn't encrypted this
+		 * won't do anything.
+		 *
+		 * If we're compressed we'll handle all of this in
+		 * btrfs_submit_compressed_read.
+		 */
+		if (compress_type == BTRFS_COMPRESS_NONE) {
+			bio_ctrl->orig_start = em->orig_start;
+			bio_ctrl->fscrypt_info =
+				fscrypt_get_extent_info(em->fscrypt_info);
+		}
+
 		free_extent_map(em);
 		em = NULL;
 
@@ -1089,6 +1143,9 @@ static int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 			end_page_read(page, true, cur, iosize);
 			cur = cur + iosize;
 			pg_offset += iosize;
+
+			/* This shouldn't be set, but clear it just in case. */
+			fscrypt_put_extent_info(bio_ctrl->fscrypt_info);
 			continue;
 		}
 		/* the get_extent function already copied into the page */
@@ -1097,6 +1154,9 @@ static int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 			end_page_read(page, true, cur, iosize);
 			cur = cur + iosize;
 			pg_offset += iosize;
+
+			/* This shouldn't be set, but clear it just in case. */
+			fscrypt_put_extent_info(bio_ctrl->fscrypt_info);
 			continue;
 		}
 
@@ -1109,6 +1169,7 @@ static int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 			submit_one_bio(bio_ctrl);
 		submit_extent_page(bio_ctrl, disk_bytenr, page, iosize,
 				   pg_offset);
+		fscrypt_put_extent_info(bio_ctrl->fscrypt_info);
 		cur = cur + iosize;
 		pg_offset += iosize;
 	}
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 7a7272cb83ec..726cb6121934 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -262,6 +262,42 @@ size_t btrfs_fscrypt_extent_context_size(struct btrfs_inode *inode)
 		fscrypt_extent_context_size(&inode->vfs_inode);
 }
 
+void btrfs_set_bio_crypt_ctx_from_extent(struct bio *bio,
+					 struct btrfs_inode *inode,
+					 struct fscrypt_extent_info *fi,
+					 u64 logical_offset)
+{
+	if (!fi)
+		return;
+
+	/*
+	 * fscrypt uses bytes >> s_blocksize_bits for the block numbers, so we
+	 * have to adjust everything based on our sectorsize so that the DUN
+	 * calculations are correct.
+	 */
+	logical_offset = div64_u64(logical_offset,
+				   inode->root->fs_info->sectorsize);
+	fscrypt_set_bio_crypt_ctx_from_extent(bio, &inode->vfs_inode, fi,
+					      logical_offset, GFP_NOFS);
+}
+
+bool btrfs_mergeable_encrypted_bio(struct bio *bio, struct inode *inode,
+				   struct fscrypt_extent_info *fi,
+				   u64 logical_offset)
+{
+	if (!fi)
+		return true;
+
+	/*
+	 * fscrypt uses bytes >> s_blocksize_bits for the block numbers, so we
+	 * have to adjust everything based on our sectorsize so that the DUN
+	 * calculations are correct.
+	 */
+	logical_offset = div64_u64(logical_offset,
+				   BTRFS_I(inode)->root->fs_info->sectorsize);
+	return fscrypt_mergeable_extent_bio(bio, inode, fi, logical_offset);
+}
+
 const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.has_per_extent_encryption = 1,
 	.get_context = btrfs_fscrypt_get_context,
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 2882a4a9d978..756375ade0b6 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -28,6 +28,13 @@ int btrfs_fscrypt_save_extent_info(struct btrfs_inode *inode,
 				   struct btrfs_path *path,
 				   struct fscrypt_extent_info *fi);
 size_t btrfs_fscrypt_extent_context_size(struct btrfs_inode *inode);
+void btrfs_set_bio_crypt_ctx_from_extent(struct bio *bio,
+					 struct btrfs_inode *inode,
+					 struct fscrypt_extent_info *fi,
+					 u64 logical_offset);
+bool btrfs_mergeable_encrypted_bio(struct bio *bio, struct inode *inode,
+				   struct fscrypt_extent_info *fi,
+				   u64 logical_offset);
 
 #else
 static inline int btrfs_fscrypt_save_extent_info(struct btrfs_inode *inode,
@@ -66,6 +73,21 @@ static inline size_t btrfs_fscrypt_extent_context_size(struct btrfs_inode *inode
 {
 	return 0;
 }
+
+static inline void btrfs_set_bio_crypt_ctx_from_extent(struct bio *bio,
+						       struct btrfs_inode *inode,
+						       struct fscrypt_extent_info *fi,
+						       u64 logical_offset)
+{
+}
+
+static inline bool btrfs_mergeable_encrypted_bio(struct bio *bio,
+						 struct inode *inode,
+						 struct fscrypt_extent_info *fi,
+						 u64 logical_offset)
+{
+	return true;
+}
 #endif /* CONFIG_FS_ENCRYPTION */
 
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1b844a27a0d1..4f5bcfb5c0c1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7895,6 +7895,8 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 	struct btrfs_dio_private *dip =
 		container_of(bbio, struct btrfs_dio_private, bbio);
 	struct btrfs_dio_data *dio_data = iter->private;
+	struct fscrypt_extent_info *fscrypt_info = NULL;
+	u64 offset = 0;
 
 	btrfs_bio_init(bbio, BTRFS_I(iter->inode)->root->fs_info,
 		       btrfs_dio_end_io, bio->bi_private);
@@ -7916,6 +7918,9 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 	if (iter->flags & IOMAP_WRITE) {
 		int ret;
 
+		offset = file_offset - dio_data->ordered->orig_offset;
+		fscrypt_info = dio_data->ordered->fscrypt_info;
+
 		ret = btrfs_extract_ordered_extent(bbio, dio_data->ordered);
 		if (ret) {
 			btrfs_finish_ordered_extent(dio_data->ordered, NULL,
@@ -7925,8 +7930,13 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 			iomap_dio_bio_end_io(bio);
 			return;
 		}
+	} else {
+		fscrypt_info = dio_data->fscrypt_info;
+		offset = file_offset - dio_data->orig_start;
 	}
 
+	btrfs_set_bio_crypt_ctx_from_extent(&bbio->bio, bbio->inode,
+					    fscrypt_info, offset);
 	btrfs_submit_bio(bbio, 0);
 }
 
-- 
2.41.0

