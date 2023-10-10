Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C997C41A0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbjJJUly (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343877AbjJJUln (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:43 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2161CA
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:41 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-5a7b91faf40so19284437b3.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970501; x=1697575301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OVSFcN3hgU5Wv+MUFYElNWnOc10PkPLhn8pZyce9ayk=;
        b=MQkaJjHVyeC3YpmxIk6vzp10P0zI1eKIcPFXu8gTCu4xIs4Xm7p1MjPvKUnnPtRyDJ
         Pbg0iVWBzYUaEdMKWII/sRQPbjwjzt0YJ1LUMcoAk8HUphGh4f9JXgisw67RhfqbiOka
         JrynA/xJc5yVXSZSD3vF1LdDzHlhQAj/RCN6WWtXnIbFTcNw0HFapmr9+h85G8mOAe/8
         u7VtIAnXCIvMGvwksbPR9iMtwHf8CTuW3zsfFLnzkYdBr4YEDhtJsrGCC2Q7VIOzO/sW
         0Qx4+qG+LZpzUyeq87wyfcig+MU7mCsW83HtUW/Awj0JLgHXPY1zbtEvdyqIcO6Ekhzz
         91vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970501; x=1697575301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OVSFcN3hgU5Wv+MUFYElNWnOc10PkPLhn8pZyce9ayk=;
        b=QTIcRsG0vA98TFNaYw7zTvEP1THvejexfxvApW7EqmNrOqf8Pfs5z0mcCVj++f0BP+
         Q8FHSTVyZKPNIFZxoHc2+pvmki/7/4VRNwH8ZgE+6TmQ+5A8srYodwbzI1oRANIpvAJM
         JTbt00MFh4UXVnmLvMaQ2AgCk4VJxoN1uhtlgLityle4v9/0NigU8rLHzT3/S9+6+GnO
         Bg9ci624/yPFytZvtMRJH3a2nQS3OHKtUn3/Ygb3LK0DIBnhxhj8JotYsuwohCqwFUn1
         3bBS3iENJZCLn37wvY/0VhGiZ6uKLF+BoOuhLtxPNcSFMSuxKGvNzTBSNjA72NFOt56J
         kG5w==
X-Gm-Message-State: AOJu0Yxr6EttAJRe03yafHd2P6rQH3Xz1w/ItcFQw1f84ydHOCRWAG+E
        MYTUJz/vApTJh3YlUCRnt5IiG2DJHNlVhPE7T6XOpA==
X-Google-Smtp-Source: AGHT+IFxqFG1nuO6v6ew4CA8tSwiCEkkYfTfNpr0c4G8Olk77UVSxpRA3usPMHl69BNp/UO+Uaz7sA==
X-Received: by 2002:a81:7242:0:b0:589:e4aa:7b67 with SMTP id n63-20020a817242000000b00589e4aa7b67mr20852904ywc.41.1696970501001;
        Tue, 10 Oct 2023 13:41:41 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id s67-20020a815e46000000b0059b50f126fbsm4677065ywb.114.2023.10.10.13.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:40 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 32/36] btrfs: populate ordered_extent with the orig offset
Date:   Tue, 10 Oct 2023 16:40:47 -0400
Message-ID: <4aa3a98fb50a0f124b50235b5edc1c58908ebd0a.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

For extent encryption we have to use a logical block nr as input for the
IV.  For btrfs we're using the offset into the extent we're operating
on.  For most ordered extents this is the same as the file_offset,
however for prealloc and NOCOW we have to use the original offset.

Add this as an argument and plumb it through everywhere, this will be
used when setting up the bio.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c        | 15 ++++++++++-----
 fs/btrfs/ordered-data.c | 22 ++++++++++++----------
 fs/btrfs/ordered-data.h | 12 +++++++++---
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b0109b313217..1b844a27a0d1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1165,6 +1165,7 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 
 	ordered = btrfs_alloc_ordered_extent(inode, em->fscrypt_info,
 				       start,			/* file_offset */
+				       start,			/* orig_start */
 				       async_extent->ram_size,	/* num_bytes */
 				       async_extent->ram_size,	/* ram_bytes */
 				       ins.objectid,		/* disk_bytenr */
@@ -1428,8 +1429,8 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 		}
 
 		ordered = btrfs_alloc_ordered_extent(inode, em->fscrypt_info,
-					start, ram_size, ram_size, ins.objectid,
-					cur_alloc_size, 0,
+					start, start, ram_size, ram_size,
+					ins.objectid, cur_alloc_size, 0,
 					1 << BTRFS_ORDERED_REGULAR,
 					BTRFS_COMPRESS_NONE);
 		free_extent_map(em);
@@ -2178,7 +2179,9 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 		}
 
 		ordered = btrfs_alloc_ordered_extent(inode, fscrypt_info,
-				cur_offset, nocow_args.num_bytes,
+				cur_offset,
+				found_key.offset - nocow_args.extent_offset,
+				nocow_args.num_bytes,
 				nocow_args.num_bytes, nocow_args.disk_bytenr,
 				nocow_args.num_bytes, 0,
 				is_prealloc
@@ -7087,8 +7090,9 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 		fscrypt_info = orig_em->fscrypt_info;
 	}
 
-	ordered = btrfs_alloc_ordered_extent(inode, fscrypt_info, start, len,
-					     len, block_start, block_len, 0,
+	ordered = btrfs_alloc_ordered_extent(inode, fscrypt_info, start,
+					     orig_start, len, len, block_start,
+					     block_len, 0,
 					     (1 << type) |
 					     (1 << BTRFS_ORDERED_DIRECT),
 					     BTRFS_COMPRESS_NONE);
@@ -10612,6 +10616,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	}
 
 	ordered = btrfs_alloc_ordered_extent(inode, em->fscrypt_info, start,
+				       start - encoded->unencoded_offset,
 				       num_bytes, ram_bytes, ins.objectid,
 				       ins.offset, encoded->unencoded_offset,
 				       (1 << BTRFS_ORDERED_ENCODED) |
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index ee3138a6d11e..75eb42b5c95b 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -148,9 +148,9 @@ static inline struct rb_node *ordered_tree_search(struct btrfs_inode *inode,
 static struct btrfs_ordered_extent *alloc_ordered_extent(
 			struct btrfs_inode *inode,
 			struct fscrypt_extent_info *fscrypt_info,
-			u64 file_offset, u64 num_bytes, u64 ram_bytes,
-			u64 disk_bytenr, u64 disk_num_bytes, u64 offset,
-			unsigned long flags, int compress_type)
+			u64 file_offset, u64 orig_offset, u64 num_bytes,
+			u64 ram_bytes, u64 disk_bytenr, u64 disk_num_bytes,
+			u64 offset, unsigned long flags, int compress_type)
 {
 	struct btrfs_ordered_extent *entry;
 	int ret;
@@ -175,6 +175,7 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 		return ERR_PTR(-ENOMEM);
 
 	entry->file_offset = file_offset;
+	entry->orig_offset = orig_offset;
 	entry->num_bytes = num_bytes;
 	entry->ram_bytes = ram_bytes;
 	entry->disk_bytenr = disk_bytenr;
@@ -253,6 +254,7 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
  * @inode:           Inode that this extent is for.
  * @fscrypt_info:    The fscrypt_extent_info for this extent, if necessary.
  * @file_offset:     Logical offset in file where the extent starts.
+ * @orig_offset:     Logical offset of the original extent (PREALLOC or NOCOW)
  * @num_bytes:       Logical length of extent in file.
  * @ram_bytes:       Full length of unencoded data.
  * @disk_bytenr:     Offset of extent on disk.
@@ -270,17 +272,17 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
 struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 			struct btrfs_inode *inode,
 			struct fscrypt_extent_info *fscrypt_info,
-			u64 file_offset, u64 num_bytes, u64 ram_bytes,
-			u64 disk_bytenr, u64 disk_num_bytes, u64 offset,
-			unsigned long flags, int compress_type)
+			u64 file_offset, u64 orig_offset, u64 num_bytes,
+			u64 ram_bytes, u64 disk_bytenr, u64 disk_num_bytes,
+			u64 offset, unsigned long flags, int compress_type)
 {
 	struct btrfs_ordered_extent *entry;
 
 	ASSERT((flags & ~BTRFS_ORDERED_TYPE_FLAGS) == 0);
 
 	entry = alloc_ordered_extent(inode, fscrypt_info, file_offset,
-				     num_bytes, ram_bytes, disk_bytenr,
-				     disk_num_bytes, offset, flags,
+				     orig_offset, num_bytes, ram_bytes,
+				     disk_bytenr, disk_num_bytes, offset, flags,
 				     compress_type);
 	if (!IS_ERR(entry))
 		insert_ordered_extent(entry);
@@ -1174,8 +1176,8 @@ struct btrfs_ordered_extent *btrfs_split_ordered_extent(
 		return ERR_PTR(-EINVAL);
 
 	new = alloc_ordered_extent(inode, ordered->fscrypt_info, file_offset,
-				   len, len, disk_bytenr, len, 0, flags,
-				   ordered->compress_type);
+				   ordered->orig_offset, len, len, disk_bytenr,
+				   len, 0, flags, ordered->compress_type);
 	if (IS_ERR(new))
 		return new;
 
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 767efcd74bee..af8b51c255ee 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -83,6 +83,12 @@ struct btrfs_ordered_extent {
 	/* logical offset in the file */
 	u64 file_offset;
 
+	/*
+	 * The original logical offset of the extent, this is for NOCOW and
+	 * PREALLOC extents, otherwise it'll be the same as file_offset.
+	 */
+	u64 orig_offset;
+
 	/*
 	 * These fields directly correspond to the same fields in
 	 * btrfs_file_extent_item.
@@ -172,9 +178,9 @@ bool btrfs_dec_test_ordered_pending(struct btrfs_inode *inode,
 struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 			struct btrfs_inode *inode,
 			struct fscrypt_extent_info *fscrypt_info,
-			u64 file_offset, u64 num_bytes, u64 ram_bytes,
-			u64 disk_bytenr, u64 disk_num_bytes, u64 offset,
-			unsigned long flags, int compress_type);
+			u64 file_offset, u64 orig_offset, u64 num_bytes,
+			u64 ram_bytes, u64 disk_bytenr, u64 disk_num_bytes,
+			u64 offset, unsigned long flags, int compress_type);
 void btrfs_add_ordered_sum(struct btrfs_ordered_extent *entry,
 			   struct btrfs_ordered_sum *sum);
 struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct btrfs_inode *inode,
-- 
2.41.0

