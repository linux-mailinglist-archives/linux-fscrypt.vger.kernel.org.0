Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D467AF234
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbjIZSDs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235495AbjIZSDr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:47 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D22124
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:39 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-41820eecff2so19633471cf.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751418; x=1696356218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=77x/Hy1aSzyf/SlLhZmkO/V30ynvClbK7xoDUcF2W5s=;
        b=0VBAH2Tm8BVRv6DUR8CEzhhGr8VferJtF47VeS11Kk6OmC98gUlMdWl1ovIHWPMoj5
         7vo3Cr7FreJKm5Rw9Vv/IOSDYOnWqJooOD4z3jgYL2P1LiQ2hfRxIldVrFowmmWrzvpT
         Sdol5NjXfiAHIrL30D4gL6/gmwLhnn8creuPoYzJ3C4GLTKkxO8zrSJvwDl4pmIXAoAW
         6PH6l4NUORFz0+b/6x2p7Jyl9k6PSKp4wW3Lg1AQSFqaTsnYJ6I4pPlXvfRPOkXYxe5M
         HgHlc6KKDbb6/wEkSQlprBs1dHgv7NHrn+pi6kM9IRpyz/vWXi8GiXoESQEiXWWOB6Jf
         2qHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751418; x=1696356218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=77x/Hy1aSzyf/SlLhZmkO/V30ynvClbK7xoDUcF2W5s=;
        b=OMavPPMuUcVgmJ41x0Fr6ZM66pi4yetmJQeA94GqzQpQE8PkZGB7Dgx6nRJdyZlk0f
         GG0ztiDbLZQDpo4Wu6e+wJFWQkyK2W26NlIm+W7IFwTA9zkyl4n48/zVrFzG4mL2KT9X
         Yk5ivx1xAeGTvOB9kGP9dJ6se9s5K2ghbcIHk+Njo79UEgrO6wUxtg3HALLm08lR2Pb/
         OpBJ+rAVi5NV+q7RyqICYcNVA1rOJAk2mrTHmattuH+j6AcwybTbxB9EtJCDzhELxraf
         gsBc8vPDnjtrd3AYCef/zF3i5/uxkxTDb+NSC7oqLkEqyLFef2BMPi3On+MoymSNXGq6
         DTWA==
X-Gm-Message-State: AOJu0Yz8Ak9QR1m0/kHk/xvjdwu1kVWhfx19s5WbO/A5gnD6gDBL9sMY
        1/epo52h4u7GcNT4rueQifKuglrMpomlgQ6YR1WFEQ==
X-Google-Smtp-Source: AGHT+IHXxVEDQL63ZZ4XYwuRIYCyejbJDJImvvzOr0EYvSkZb+OQhvwjEXuep6HaxRpuGCYFc2Kl2w==
X-Received: by 2002:ac8:1381:0:b0:418:1d4f:995c with SMTP id h1-20020ac81381000000b004181d4f995cmr4101881qtj.55.1695751418334;
        Tue, 26 Sep 2023 11:03:38 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id ex14-20020a05622a518e00b0041815bcea29sm2048234qtb.19.2023.09.26.11.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:38 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 22/35] btrfs: plumb through setting the fscrypt_info for ordered extents
Date:   Tue, 26 Sep 2023 14:01:48 -0400
Message-ID: <2364da0114abd49fe4aa6c1722174bad7d61a2e0.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
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

We're going to be getting fscrypt_info from the extent maps, update the
helpers to take an fscrypt_info argument and use that to set the
encryption type on the ordered extent.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c        | 20 +++++++++++---------
 fs/btrfs/ordered-data.c | 32 ++++++++++++++++++++------------
 fs/btrfs/ordered-data.h |  9 +++++----
 3 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d26062b67211..903ec2d460f5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1162,7 +1162,8 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 	}
 	free_extent_map(em);
 
-	ordered = btrfs_alloc_ordered_extent(inode, start,	/* file_offset */
+	ordered = btrfs_alloc_ordered_extent(inode, NULL,
+				       start,			/* file_offset */
 				       async_extent->ram_size,	/* num_bytes */
 				       async_extent->ram_size,	/* ram_bytes */
 				       ins.objectid,		/* disk_bytenr */
@@ -1425,9 +1426,10 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 		}
 		free_extent_map(em);
 
-		ordered = btrfs_alloc_ordered_extent(inode, start, ram_size,
-					ram_size, ins.objectid, cur_alloc_size,
-					0, 1 << BTRFS_ORDERED_REGULAR,
+		ordered = btrfs_alloc_ordered_extent(inode, NULL,
+					start, ram_size, ram_size, ins.objectid,
+					cur_alloc_size, 0,
+					1 << BTRFS_ORDERED_REGULAR,
 					BTRFS_COMPRESS_NONE);
 		if (IS_ERR(ordered)) {
 			ret = PTR_ERR(ordered);
@@ -2158,7 +2160,7 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 			free_extent_map(em);
 		}
 
-		ordered = btrfs_alloc_ordered_extent(inode, cur_offset,
+		ordered = btrfs_alloc_ordered_extent(inode, NULL, cur_offset,
 				nocow_args.num_bytes, nocow_args.num_bytes,
 				nocow_args.disk_bytenr, nocow_args.num_bytes, 0,
 				is_prealloc
@@ -7041,7 +7043,7 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 		if (IS_ERR(em))
 			goto out;
 	}
-	ordered = btrfs_alloc_ordered_extent(inode, start, len, len,
+	ordered = btrfs_alloc_ordered_extent(inode, NULL, start, len, len,
 					     block_start, block_len, 0,
 					     (1 << type) |
 					     (1 << BTRFS_ORDERED_DIRECT),
@@ -10512,9 +10514,9 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	}
 	free_extent_map(em);
 
-	ordered = btrfs_alloc_ordered_extent(inode, start, num_bytes, ram_bytes,
-				       ins.objectid, ins.offset,
-				       encoded->unencoded_offset,
+	ordered = btrfs_alloc_ordered_extent(inode, NULL, start,
+				       num_bytes, ram_bytes, ins.objectid,
+				       ins.offset, encoded->unencoded_offset,
 				       (1 << BTRFS_ORDERED_ENCODED) |
 				       (1 << BTRFS_ORDERED_COMPRESSED),
 				       compression);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index d33a780d9893..81b0fe575011 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -147,9 +147,11 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
 }
 
 static struct btrfs_ordered_extent *alloc_ordered_extent(
-			struct btrfs_inode *inode, u64 file_offset, u64 num_bytes,
-			u64 ram_bytes, u64 disk_bytenr, u64 disk_num_bytes,
-			u64 offset, unsigned long flags, int compress_type)
+			struct btrfs_inode *inode,
+			struct fscrypt_extent_info *fscrypt_info,
+			u64 file_offset, u64 num_bytes, u64 ram_bytes,
+			u64 disk_bytenr, u64 disk_num_bytes, u64 offset,
+			unsigned long flags, int compress_type)
 {
 	struct btrfs_ordered_extent *entry;
 	int ret;
@@ -182,10 +184,12 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	entry->bytes_left = num_bytes;
 	entry->inode = igrab(&inode->vfs_inode);
 	entry->compress_type = compress_type;
-	entry->encryption_type = BTRFS_ENCRYPTION_NONE;
 	entry->truncated_len = (u64)-1;
 	entry->qgroup_rsv = ret;
 	entry->flags = flags;
+	entry->fscrypt_info = fscrypt_get_extent_info(fscrypt_info);
+	entry->encryption_type = entry->fscrypt_info ?
+		BTRFS_ENCRYPTION_FSCRYPT : BTRFS_ENCRYPTION_NONE;
 	refcount_set(&entry->refs, 1);
 	init_waitqueue_head(&entry->wait);
 	INIT_LIST_HEAD(&entry->list);
@@ -248,6 +252,7 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
  * Add an ordered extent to the per-inode tree.
  *
  * @inode:           Inode that this extent is for.
+ * @fscrypt_info:    The fscrypt_extent_info for this extent, if necessary.
  * @file_offset:     Logical offset in file where the extent starts.
  * @num_bytes:       Logical length of extent in file.
  * @ram_bytes:       Full length of unencoded data.
@@ -264,17 +269,19 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
  * Return: the new ordered extent or error pointer.
  */
 struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
-			struct btrfs_inode *inode, u64 file_offset,
-			u64 num_bytes, u64 ram_bytes, u64 disk_bytenr,
-			u64 disk_num_bytes, u64 offset, unsigned long flags,
-			int compress_type)
+			struct btrfs_inode *inode,
+			struct fscrypt_extent_info *fscrypt_info,
+			u64 file_offset, u64 num_bytes, u64 ram_bytes,
+			u64 disk_bytenr, u64 disk_num_bytes, u64 offset,
+			unsigned long flags, int compress_type)
 {
 	struct btrfs_ordered_extent *entry;
 
 	ASSERT((flags & ~BTRFS_ORDERED_TYPE_FLAGS) == 0);
 
-	entry = alloc_ordered_extent(inode, file_offset, num_bytes, ram_bytes,
-				     disk_bytenr, disk_num_bytes, offset, flags,
+	entry = alloc_ordered_extent(inode, fscrypt_info, file_offset,
+				     num_bytes, ram_bytes, disk_bytenr,
+				     disk_num_bytes, offset, flags,
 				     compress_type);
 	if (!IS_ERR(entry))
 		insert_ordered_extent(entry);
@@ -1181,8 +1188,9 @@ struct btrfs_ordered_extent *btrfs_split_ordered_extent(
 	if (WARN_ON_ONCE(ordered->disk_num_bytes != ordered->num_bytes))
 		return ERR_PTR(-EINVAL);
 
-	new = alloc_ordered_extent(inode, file_offset, len, len, disk_bytenr,
-				   len, 0, flags, ordered->compress_type);
+	new = alloc_ordered_extent(inode, ordered->fscrypt_info, file_offset,
+				   len, len, disk_bytenr, len, 0, flags,
+				   ordered->compress_type);
 	if (IS_ERR(new))
 		return new;
 
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 607814876f1f..e19e62d5171a 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -185,10 +185,11 @@ bool btrfs_dec_test_ordered_pending(struct btrfs_inode *inode,
 				    struct btrfs_ordered_extent **cached,
 				    u64 file_offset, u64 io_size);
 struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
-			struct btrfs_inode *inode, u64 file_offset,
-			u64 num_bytes, u64 ram_bytes, u64 disk_bytenr,
-			u64 disk_num_bytes, u64 offset, unsigned long flags,
-			int compress_type);
+			struct btrfs_inode *inode,
+			struct fscrypt_extent_info *fscrypt_info,
+			u64 file_offset, u64 num_bytes, u64 ram_bytes,
+			u64 disk_bytenr, u64 disk_num_bytes, u64 offset,
+			unsigned long flags, int compress_type);
 void btrfs_add_ordered_sum(struct btrfs_ordered_extent *entry,
 			   struct btrfs_ordered_sum *sum);
 struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct btrfs_inode *inode,
-- 
2.41.0

