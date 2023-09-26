Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9391A7AF257
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbjIZSD7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235517AbjIZSD6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:58 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2241A6
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:50 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id 6a1803df08f44-65afac36b2cso30518836d6.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751429; x=1696356229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wN/XVw9o4Zo7vsDD0QhSsMXlcdq0/KPnE8JijB7sQ2s=;
        b=Qmccs+bsXIIa6BT7uMZh5w1ceJUYoURCIBHTPoETUKsSzp7tcFnectcSbz5BuWQRWQ
         3bqHVzc9oTMd52Y7DZmIySTVB8B9wcoIZtrK4mu++ZWn7Dkh4GGevbNQuodeNQXZvPMA
         wfUB4E63w5Rww+JP5URPv8BoDuEXaVkOI1SvvSn5korcm9u/G94chHV6aoBAYXrrLPuV
         fI6QETyALkghkTJK3c6RES2TQJCADUIL5W3BaTjXZlAMPUZDJVqtgNzE8rpkYL65AH6R
         WKMmxxlwrfc0iuJEV3km91QRHs/4y9wrxtl7SutaVyo9a9oKrICP46SdnvXU2bMVFwPH
         yzuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751429; x=1696356229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wN/XVw9o4Zo7vsDD0QhSsMXlcdq0/KPnE8JijB7sQ2s=;
        b=w4Kpev9Iw5Gg5Pgc9e2w6XMdpAb9x+QI9iWdAy6sC5oggXiLs9TR8X0NdG5FG1zWf9
         IXzStBon0snW65lJ1/r/PlDBkEHI/0JIG9xWqQZLvoheplsMr2OET68Gto9sOEd5dD+D
         IvZtIn4UA1XIyF+Qa42uq0aCRhyXwjDBoaUk6m5YRwdI5ozLeeZLDjwmhrWhQO2QNdl4
         vtHBWBx9vKXlKxKsaZbU55/egHSWP4E5ORZvoIv/SrVPlbuWO0+g4JohVwUH7asnRSLv
         dZLv62Uwi+IcN2/Vc0vcLKiJl0sJXfgATmApA8MkWDGRgdzT3x8c5HwdnphITabOx2QP
         7uOw==
X-Gm-Message-State: AOJu0YwiuGCsVcyr8XKgpf2Wjt4REeZjc3yROPHDNTyce+ZEc9NNWCod
        4qCsKrOr+sWK1fQrsdbsCKBJsklyCANagJ8wRDW9Mw==
X-Google-Smtp-Source: AGHT+IFBsrjztBuowqWrYLdHz9sbNV/3ClTZLqmOtXuVYsTxfL/bnH18f6ot/UVCKk/iLcrM9pw/0w==
X-Received: by 2002:a05:6214:daf:b0:656:52a3:44f5 with SMTP id h15-20020a0562140daf00b0065652a344f5mr10984302qvh.57.1695751429548;
        Tue, 26 Sep 2023 11:03:49 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d7-20020a0ce447000000b0065b0fa22667sm2062531qvm.81.2023.09.26.11.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:49 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 32/35] btrfs: set the bio fscrypt context when applicable
Date:   Tue, 26 Sep 2023 14:01:58 -0400
Message-ID: <09bfd8c789f9e6aceb1a0a86fa8b29110ad12dc4.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 121746b7ce95..49f6bbe3b75b 100644
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
index 7f53bfa621e1..1c690fcd0693 100644
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
 	.get_context = btrfs_fscrypt_get_context,
 	.set_context = btrfs_fscrypt_set_context,
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
index 14420683651a..fbcabc9a79fe 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7897,6 +7897,8 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 	struct btrfs_dio_private *dip =
 		container_of(bbio, struct btrfs_dio_private, bbio);
 	struct btrfs_dio_data *dio_data = iter->private;
+	struct fscrypt_extent_info *fscrypt_info = NULL;
+	u64 offset = 0;
 
 	btrfs_bio_init(bbio, BTRFS_I(iter->inode)->root->fs_info,
 		       btrfs_dio_end_io, bio->bi_private);
@@ -7918,6 +7920,9 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 	if (iter->flags & IOMAP_WRITE) {
 		int ret;
 
+		offset = file_offset - dio_data->ordered->orig_offset;
+		fscrypt_info = dio_data->ordered->fscrypt_info;
+
 		ret = btrfs_extract_ordered_extent(bbio, dio_data->ordered);
 		if (ret) {
 			btrfs_finish_ordered_extent(dio_data->ordered, NULL,
@@ -7927,8 +7932,13 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
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

