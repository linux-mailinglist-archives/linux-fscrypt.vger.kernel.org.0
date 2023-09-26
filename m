Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8BD7AF241
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbjIZSDs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbjIZSDr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:47 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82998FC
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:40 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id 6a1803df08f44-65b0383f618so30993276d6.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751419; x=1696356219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rBWLpxPh19X73dPFX8Yn4lHS0AwxjYc36S4EI8tWcB4=;
        b=Z11TucYEmFYrAcLd+ZvbfTrC33gK40vfWXC/FazykUVYGrQBrIwmrEKGaU+NqOVADy
         YcRcFhJw8U9VZx6Z5X92zJIM6p8Hy2s6gxNYjWrelNjGm7CavvX7s+6Pxqh9tQezWOqY
         ZBkoPs2AbgV35SdbVU70jVVkfyfQxsJPPKJYqpHKlOOU22FxR4BXyHRvxfPR4mmEF2wM
         bmne9qyxRpOF7xPcTIkpWonfggTznjwqsIJcDAmmFDpVAzcMa2p9lAkJee4mk8LgWqFN
         ZPGjDxgZ0KyULQZuI2KzSFr8PNtC3Gao8qi8wvDAPK7tK7qnO5KyK8uLbV2hM4MCUSLl
         Vbvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751419; x=1696356219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rBWLpxPh19X73dPFX8Yn4lHS0AwxjYc36S4EI8tWcB4=;
        b=F0eTnSNkMi5D9nJNI3qspgt1DgSaGSXP+GfkITVroc1y9MiPNGNV+r7XeENnxEw0CQ
         rXl6GLsfjivx7IQRZERpgf3Fg1VCsQsecCRfF+lvjJSC3JrhOZPVa26u3ey3Hs0jZk8g
         DewV6aTHueWZv3h3ngDSvGO11ZxldFLzj7v7WrWsMBJh6uyZZhx2Y8ad1z1OlcnMQjXm
         3CPQ96Dzdn7W0cwAjBBhTWBEr02u94Yi/zOSzkIuXx7CqrhGjm5hQc8JMKJi4+rnwdep
         /yBnBrRb6GyP86ZbYSi5Eb42Vj9v7PQKF9NCFDWzVxTbqNBud7mMyjd2m/16DlhQ0YIV
         a8mA==
X-Gm-Message-State: AOJu0YxjUItYmlCCaTH+y6OJp/yVx8u9AUnzetj6WM7l4XAwCgRl9cFC
        Lry3iel5y6tPbHEsOB+L4e4lMQ==
X-Google-Smtp-Source: AGHT+IG7IzD1KAhaf6wk7yK22JmzPdW2RnO3UPwRzAYWcFaxLgMqt4hbuOT0nHwoYJ4K5KjnodLxCw==
X-Received: by 2002:a0c:e183:0:b0:64f:67ae:a132 with SMTP id p3-20020a0ce183000000b0064f67aea132mr8431970qvl.23.1695751419456;
        Tue, 26 Sep 2023 11:03:39 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id o8-20020a0ce408000000b0065b1c26c89asm1365734qvl.145.2023.09.26.11.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:39 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 23/35] btrfs: populate the ordered_extent with the fscrypt context
Date:   Tue, 26 Sep 2023 14:01:49 -0400
Message-ID: <6efdb68cb164a54bb2b05a096cc8a3c793bfb1af.1695750478.git.josef@toxicpanda.com>
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

The fscrypt_extent_info will be tied to the extent_map lifetime, so it
will be created when we create the IO em, or it'll already exist in the
NOCOW case.  Use this fscrypt_info when creating the ordered extent to
make sure everything is passed through properly.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 62 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 903ec2d460f5..19831291fb54 100644
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
@@ -7023,6 +7040,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 
 static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 						  struct btrfs_dio_data *dio_data,
+						  struct extent_map *orig_em,
 						  const u64 start,
 						  const u64 len,
 						  const u64 orig_start,
@@ -7034,6 +7052,7 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 {
 	struct extent_map *em = NULL;
 	struct btrfs_ordered_extent *ordered;
+	struct fscrypt_extent_info *fscrypt_info = NULL;
 
 	if (type != BTRFS_ORDERED_NOCOW) {
 		em = create_io_em(inode, start, len, orig_start, block_start,
@@ -7042,9 +7061,13 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
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
@@ -7081,9 +7104,10 @@ static struct extent_map *btrfs_new_extent_direct(struct btrfs_inode *inode,
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
@@ -7428,9 +7452,9 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
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

