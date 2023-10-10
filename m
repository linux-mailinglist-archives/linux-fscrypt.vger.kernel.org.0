Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A3D7C419D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344078AbjJJUlw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234658AbjJJUle (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:34 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A43599
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:32 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-5a7be61fe74so15051037b3.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970491; x=1697575291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sdhOZSbLFAWHbBthhX//NAxRHhPvITLPW+kiDV9DiQg=;
        b=sp6CPy/26n8gHxHHSCotJawUvMkZy6hWKQR+AhonHZYtDuUxYg7mdUfqCAfzhQl9LN
         GmhKsU2TY65KrxsR2rtnWrrlQBCcZwOWTI829yt11u6t3cnmCEOAvOAto8iJLEfzKtuj
         D9GMQPjBomF9CCwhtWdvgESqJRQHgWdVUV774isGY+ir9hI+tRWc5EPLb0/JYG+w6aMp
         8nu4NgQHCL4wAfZVuIyjXIMYpA3tTBnPeURoeQ+LSmF38OZ6+F5wZJjDiZ7da7x54pbf
         e7SOPe/CtvqgvkX17M7EhNXEvKoxZFfQMIZVJF7v5d8pxv9C14BbvG05dFZWf94W1uyt
         Frrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970491; x=1697575291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sdhOZSbLFAWHbBthhX//NAxRHhPvITLPW+kiDV9DiQg=;
        b=K3HvqDU0PHlil4Xe9pXVRHgf3rEa1JxtB2AJml9NDTYYQe4l+fxEhXt7U7wBwk9u0x
         Gs49CF2cFGVMyKn3MzZtMCQNCtA+CItkA3e87uX32E/ex/S6hpbKzvyN8i0oSZjxMVFi
         Nzi1OtsHRUgGNSynPOQbnppBoNX2G+5ieaSj3TVBYVFuDsIdOUxt8cT83N/VUL7KCJVM
         v0z4lHOlJgKJvWuh1UVoE0Z0Y3MKSdrZlVMt+8wHldPhwwGp6bKeK+81QEgOy0yVJUrc
         1Wqp1UCwObRtUZlbMY5jcyci3HC48h/YVyiZ/2dnOMDALoj8KcFQu+cLefG6+ANBp2b1
         rdKg==
X-Gm-Message-State: AOJu0YxLxnygl9y5A5cchoyCHSUZ4AZEAagWpa3jXNxGkSi633ECkAy1
        V5FDb37XsQAw4/n3u/fRaMh7v68OVAvUnottphLd2w==
X-Google-Smtp-Source: AGHT+IHnTLGLwEyh2iAbLqOo80QF5NP0kF4Lmdo9qoe7odEnvcx6u3ZFvtjfAR8OxuNM5M7rwGKwug==
X-Received: by 2002:a05:690c:250e:b0:5a7:a959:338 with SMTP id dt14-20020a05690c250e00b005a7a9590338mr4624617ywb.13.1696970491555;
        Tue, 10 Oct 2023 13:41:31 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id z17-20020a0dd711000000b0057087e7691bsm472534ywd.56.2023.10.10.13.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:31 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 24/36] btrfs: populate the ordered_extent with the fscrypt context
Date:   Tue, 10 Oct 2023 16:40:39 -0400
Message-ID: <e11a84b835d00b71cb56e316588b31c93f695f46.1696970227.git.josef@toxicpanda.com>
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

The fscrypt_extent_info will be tied to the extent_map lifetime, so it
will be created when we create the IO em, or it'll already exist in the
NOCOW case.  Use this fscrypt_info when creating the ordered extent to
make sure everything is passed through properly.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 62 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a1fa5b6f3790..7d859e327485 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1160,9 +1160,8 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 		ret = PTR_ERR(em);
 		goto out_free_reserve;
 	}
-	free_extent_map(em);
 
-	ordered = btrfs_alloc_ordered_extent(inode, NULL,
+	ordered = btrfs_alloc_ordered_extent(inode, em->fscrypt_info,
 				       start,			/* file_offset */
 				       async_extent->ram_size,	/* num_bytes */
 				       async_extent->ram_size,	/* ram_bytes */
@@ -1171,6 +1170,7 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 				       0,			/* offset */
 				       1 << BTRFS_ORDERED_COMPRESSED,
 				       async_extent->compress_type);
+	free_extent_map(em);
 	if (IS_ERR(ordered)) {
 		btrfs_drop_extent_map_range(inode, start, end, false);
 		ret = PTR_ERR(ordered);
@@ -1424,13 +1424,13 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 			ret = PTR_ERR(em);
 			goto out_reserve;
 		}
-		free_extent_map(em);
 
-		ordered = btrfs_alloc_ordered_extent(inode, NULL,
+		ordered = btrfs_alloc_ordered_extent(inode, em->fscrypt_info,
 					start, ram_size, ram_size, ins.objectid,
 					cur_alloc_size, 0,
 					1 << BTRFS_ORDERED_REGULAR,
 					BTRFS_COMPRESS_NONE);
+		free_extent_map(em);
 		if (IS_ERR(ordered)) {
 			ret = PTR_ERR(ordered);
 			goto out_drop_extent_cache;
@@ -2003,6 +2003,8 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 		struct btrfs_key found_key;
 		struct btrfs_file_extent_item *fi;
 		struct extent_buffer *leaf;
+		struct extent_map *em = NULL;
+		struct fscrypt_extent_info *fscrypt_info = NULL;
 		u64 extent_end;
 		u64 ram_bytes;
 		u64 nocow_end;
@@ -2143,7 +2145,6 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 		is_prealloc = extent_type == BTRFS_FILE_EXTENT_PREALLOC;
 		if (is_prealloc) {
 			u64 orig_start = found_key.offset - nocow_args.extent_offset;
-			struct extent_map *em;
 
 			em = create_io_em(inode, cur_offset, nocow_args.num_bytes,
 					  orig_start,
@@ -2157,16 +2158,32 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 				ret = PTR_ERR(em);
 				goto error;
 			}
-			free_extent_map(em);
+			fscrypt_info = em->fscrypt_info;
+		} else if (IS_ENCRYPTED(&inode->vfs_inode)) {
+			/*
+			 * We only want to do this lookup if we're encrypted,
+			 * otherwise fsrypt_info will be null and we can avoid
+			 * this lookup.
+			 */
+			em = btrfs_get_extent(inode, NULL, 0, cur_offset,
+					      nocow_args.num_bytes);
+			if (IS_ERR(em)) {
+				btrfs_dec_nocow_writers(nocow_bg);
+				ret = PTR_ERR(em);
+				goto error;
+			}
+			fscrypt_info = em->fscrypt_info;
 		}
 
-		ordered = btrfs_alloc_ordered_extent(inode, NULL, cur_offset,
-				nocow_args.num_bytes, nocow_args.num_bytes,
-				nocow_args.disk_bytenr, nocow_args.num_bytes, 0,
+		ordered = btrfs_alloc_ordered_extent(inode, fscrypt_info,
+				cur_offset, nocow_args.num_bytes,
+				nocow_args.num_bytes, nocow_args.disk_bytenr,
+				nocow_args.num_bytes, 0,
 				is_prealloc
 				? (1 << BTRFS_ORDERED_PREALLOC)
 				: (1 << BTRFS_ORDERED_NOCOW),
 				BTRFS_COMPRESS_NONE);
+		free_extent_map(em);
 		btrfs_dec_nocow_writers(nocow_bg);
 		if (IS_ERR(ordered)) {
 			if (is_prealloc) {
@@ -7022,6 +7039,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 
 static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 						  struct btrfs_dio_data *dio_data,
+						  struct extent_map *orig_em,
 						  const u64 start,
 						  const u64 len,
 						  const u64 orig_start,
@@ -7033,6 +7051,7 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 {
 	struct extent_map *em = NULL;
 	struct btrfs_ordered_extent *ordered;
+	struct fscrypt_extent_info *fscrypt_info = NULL;
 
 	if (type != BTRFS_ORDERED_NOCOW) {
 		em = create_io_em(inode, start, len, orig_start, block_start,
@@ -7041,9 +7060,13 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 				  type);
 		if (IS_ERR(em))
 			goto out;
+		fscrypt_info = em->fscrypt_info;
+	} else {
+		fscrypt_info = orig_em->fscrypt_info;
 	}
-	ordered = btrfs_alloc_ordered_extent(inode, NULL, start, len, len,
-					     block_start, block_len, 0,
+
+	ordered = btrfs_alloc_ordered_extent(inode, fscrypt_info, start, len,
+					     len, block_start, block_len, 0,
 					     (1 << type) |
 					     (1 << BTRFS_ORDERED_DIRECT),
 					     BTRFS_COMPRESS_NONE);
@@ -7080,9 +7103,10 @@ static struct extent_map *btrfs_new_extent_direct(struct btrfs_inode *inode,
 	if (ret)
 		return ERR_PTR(ret);
 
-	em = btrfs_create_dio_extent(inode, dio_data, start, ins.offset, start,
-				     ins.objectid, ins.offset, ins.offset,
-				     ins.offset, BTRFS_ORDERED_REGULAR);
+	em = btrfs_create_dio_extent(inode, dio_data, NULL, start, ins.offset,
+				     start, ins.objectid, ins.offset,
+				     ins.offset, ins.offset,
+				     BTRFS_ORDERED_REGULAR);
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 	if (IS_ERR(em))
 		btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset,
@@ -7426,9 +7450,9 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 		}
 		space_reserved = true;
 
-		em2 = btrfs_create_dio_extent(BTRFS_I(inode), dio_data, start, len,
-					      orig_start, block_start,
-					      len, orig_block_len,
+		em2 = btrfs_create_dio_extent(BTRFS_I(inode), dio_data, em,
+					      start, len, orig_start,
+					      block_start, len, orig_block_len,
 					      ram_bytes, type);
 		btrfs_dec_nocow_writers(bg);
 		if (type == BTRFS_ORDERED_PREALLOC) {
@@ -10512,14 +10536,14 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 		ret = PTR_ERR(em);
 		goto out_free_reserved;
 	}
-	free_extent_map(em);
 
-	ordered = btrfs_alloc_ordered_extent(inode, NULL, start,
+	ordered = btrfs_alloc_ordered_extent(inode, em->fscrypt_info, start,
 				       num_bytes, ram_bytes, ins.objectid,
 				       ins.offset, encoded->unencoded_offset,
 				       (1 << BTRFS_ORDERED_ENCODED) |
 				       (1 << BTRFS_ORDERED_COMPRESSED),
 				       compression);
+	free_extent_map(em);
 	if (IS_ERR(ordered)) {
 		btrfs_drop_extent_map_range(inode, start, end, false);
 		ret = PTR_ERR(ordered);
-- 
2.41.0

