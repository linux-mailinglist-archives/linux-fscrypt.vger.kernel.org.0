Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B0D7AF252
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbjIZSD7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbjIZSD4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:56 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF1D1AC
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:49 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-77410032cedso573527785a.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751428; x=1696356228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YYIX+c2fQ98et4rIeSj9uRudNCLedogSC1IKEMT/vkU=;
        b=AXaM9Zoo5iVmGF5Hztgf4mUyXLOnhgVfePVL3dQoebDotmowCHDG3/u5PQ4liqybXe
         ahaYc8yQEMWiSJgyaZK78jMvFdfa0Ki3Mqk5kvW2Bv6nzpnq/Q1fBVZ8hswGNTwyWcEV
         QUdod8Xg0BsZsCcdCSBdywpKnYrkh7HzkjVj131weYm4B2yKXJ1+q8LBwTFz80ikLs5V
         N4nQWAUYtb8s2kB1ontUK0Rl+HehMazDJDe7M7dRzD0owUZQbNheU28gTnwTaAAw+Dbk
         AsrczO+MhyQqYRh0Tavr8qjYBEbL+kp7S16mDEVZUChf5CvqUeZD5TFhsnmMk8cd9sbM
         7Gfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751428; x=1696356228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YYIX+c2fQ98et4rIeSj9uRudNCLedogSC1IKEMT/vkU=;
        b=d2M4ebGAPLQklf9ANCKhvo6pAUjWwvYqqet+tWrx9MUwqLpkA7rIjeIt6uV7HIdhif
         S+xOMJrBz9ztJJ3EbPJWQ9endUjX7N8WuRxEEC2Wj9EfUwSOdFhLYcVk1GHZOeiQhD74
         6DfTPwzvyjOcz2Y77vbuAv6Lv6PFKmso7Zt1ObwP7USdxZBZRAQdki27Ffzglxx9wEk4
         qGrTOsfFSZXRg0OPG+0z32jHcE3nL3gFihLz0pP8n/gudORRVk/U4Hu7xvtVvteqU8lx
         dopGmYCaar5reAV1KGGwElUZzq8ezUnvqI9jEs48sjaJxiV0hgrI5Xft6vWgdJxCB5OY
         XwFA==
X-Gm-Message-State: AOJu0YxdBntDK9lZzHdRtq/wfuY9r/i0572In57eNoY+GwGYYoQLx+jR
        sBLX4cfj2yuwXDIncS62lvv/6LFCuQ7f/QH7g/DKVA==
X-Google-Smtp-Source: AGHT+IFbBQKizNLvutZheH7/xaSd402GHHQvyARQNgJDnK3y/f9dJI5eNZZ6+Z1cyini9bwV08bf+Q==
X-Received: by 2002:a05:620a:4445:b0:76f:2899:3a96 with SMTP id w5-20020a05620a444500b0076f28993a96mr13057192qkp.0.1695751428513;
        Tue, 26 Sep 2023 11:03:48 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id br30-20020a05620a461e00b0076f124abe4dsm4532196qkb.77.2023.09.26.11.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:48 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 31/35] btrfs: populate ordered_extent with the orig offset
Date:   Tue, 26 Sep 2023 14:01:57 -0400
Message-ID: <f64ba01acc651f7dd44c1f2875e6bbb78d6f7a83.1695750478.git.josef@toxicpanda.com>
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
index aa536b838ce3..14420683651a 100644
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
@@ -7088,8 +7091,9 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
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
index 81b0fe575011..172a6ca38987 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -149,9 +149,9 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
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
@@ -176,6 +176,7 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 		return ERR_PTR(-ENOMEM);
 
 	entry->file_offset = file_offset;
+	entry->orig_offset = orig_offset;
 	entry->num_bytes = num_bytes;
 	entry->ram_bytes = ram_bytes;
 	entry->disk_bytenr = disk_bytenr;
@@ -254,6 +255,7 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
  * @inode:           Inode that this extent is for.
  * @fscrypt_info:    The fscrypt_extent_info for this extent, if necessary.
  * @file_offset:     Logical offset in file where the extent starts.
+ * @orig_offset:     Logical offset of the original extent (PREALLOC or NOCOW)
  * @num_bytes:       Logical length of extent in file.
  * @ram_bytes:       Full length of unencoded data.
  * @disk_bytenr:     Offset of extent on disk.
@@ -271,17 +273,17 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
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
@@ -1189,8 +1191,8 @@ struct btrfs_ordered_extent *btrfs_split_ordered_extent(
 		return ERR_PTR(-EINVAL);
 
 	new = alloc_ordered_extent(inode, ordered->fscrypt_info, file_offset,
-				   len, len, disk_bytenr, len, 0, flags,
-				   ordered->compress_type);
+				   ordered->orig_offset, len, len, disk_bytenr,
+				   len, 0, flags, ordered->compress_type);
 	if (IS_ERR(new))
 		return new;
 
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index e19e62d5171a..b5b969716d13 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -90,6 +90,12 @@ struct btrfs_ordered_extent {
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
@@ -187,9 +193,9 @@ bool btrfs_dec_test_ordered_pending(struct btrfs_inode *inode,
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

