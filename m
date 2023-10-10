Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB157C4193
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343964AbjJJUlp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbjJJUld (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:33 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6144FD8
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:31 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-5a7c7262d5eso11151337b3.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970490; x=1697575290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ERZNY9yAu05NkeMS9bd2xgIAJNON/dSqVc7gEbsmsV8=;
        b=cPUh2c1HVZOVUdL8SOt6cfyx2mY2M3UXb1ecxW3dmIWdRG152mvXN4AeFWDyqGYpgh
         KcU2ILgCODxQ4D5rbx+2AHHCs4O/VfsS/USzUhFuSBSMoFhY795llZ9YH6jQpwqcejft
         RzYGoY5KwZ1lE7EIqaTzprD5T4DYs/igzImvWoHPdJg0PdPcPk6QaVtoxlI172r4miun
         70Hi/XneHNjcLVFlIRaAW3dubTv3GzWutmq4GeU+8AvvmGAQk+SefdtzYRIHQp8vguqI
         B/Q8fuRXbkmui8mLjy3Te/Vjw0nRWB8XdDQOxEMPvj4KldF5+Z7TzOU9k45HNJNzhLGb
         uYeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970490; x=1697575290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ERZNY9yAu05NkeMS9bd2xgIAJNON/dSqVc7gEbsmsV8=;
        b=MXCq5gsMbGCECCzCSbYFJq4xnIDCdHkU5e4gquuhpRf+6c+zksrXQg3ef2ZKCEA+ZZ
         Ou/MQOs/pqA1dUQFgq1cKAWrrkzXqRhPK6/Qlh+x7kLXkk+WPBgqSIZXNAIoIa9qCPDY
         cOKb6V6CiffGaYO6cY8M/104lIKG4TK0WKaycl7aqJ3tJZRimifm8sETvBC/Y2k0VFh0
         ehRNmVR154RS3ET85A4UWYs5fhE36CqceiNQcNDykSbqDa7z0LiU6ARwOGfMsUN/M1HR
         mN70nXMYWG4WrECHqT+ZVfGQbBIeGUaNRNIY9nwcg7EKprEwq5aWrGLlTMh4ODMyFb1E
         Szew==
X-Gm-Message-State: AOJu0Yw/EPSFsrAKB2Lh429vDI9rAkE8Asf1dEbrgUQsT+nw36hUT60e
        g+y5f7GvygjsIgYZyL7ZeDXSwjM2wafg8v5jhIjovg==
X-Google-Smtp-Source: AGHT+IF7/z/S168KAzn9DO55LFcQQlzXi4bySDC4Vlz/fRLEbLWZbWGDIwM/gnSuSecVPQ7Fzk/OHA==
X-Received: by 2002:a81:8482:0:b0:5a7:bc79:9618 with SMTP id u124-20020a818482000000b005a7bc799618mr3229187ywf.12.1696970490302;
        Tue, 10 Oct 2023 13:41:30 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id u66-20020a818445000000b00577269ba9e9sm4629194ywf.86.2023.10.10.13.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:30 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 23/36] btrfs: plumb through setting the fscrypt_info for ordered extents
Date:   Tue, 10 Oct 2023 16:40:38 -0400
Message-ID: <a4f6ac8c97cdab97937d4614fcba21aee9bc7621.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
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
index 19087fd68cfe..a1fa5b6f3790 100644
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
@@ -7040,7 +7042,7 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
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
index 27350dd50828..ee3138a6d11e 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -146,9 +146,11 @@ static inline struct rb_node *ordered_tree_search(struct btrfs_inode *inode,
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
@@ -181,10 +183,12 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
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
@@ -247,6 +251,7 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
  * Add an ordered extent to the per-inode tree.
  *
  * @inode:           Inode that this extent is for.
+ * @fscrypt_info:    The fscrypt_extent_info for this extent, if necessary.
  * @file_offset:     Logical offset in file where the extent starts.
  * @num_bytes:       Logical length of extent in file.
  * @ram_bytes:       Full length of unencoded data.
@@ -263,17 +268,19 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
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
@@ -1166,8 +1173,9 @@ struct btrfs_ordered_extent *btrfs_split_ordered_extent(
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
index cc422bdb5363..767efcd74bee 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -170,10 +170,11 @@ bool btrfs_dec_test_ordered_pending(struct btrfs_inode *inode,
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

