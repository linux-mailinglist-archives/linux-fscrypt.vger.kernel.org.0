Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169AE7AF25B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbjIZSEC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbjIZSD7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:59 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA21BF
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:51 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-64cca551ae2so55219536d6.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751430; x=1696356230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L4BaCdes/ph+FBDRPrYEBu7SdLjcMrWxDC5DvBg0S2c=;
        b=0kZoUKyT26+RFVBhvO6XNArPmlBF4XrA3IREAALxZBUGpoDsBzZYMo1mv5YCxdugAt
         gKC3RCHBLj+ZVTmMxeg2/HS/WkWY11Oezit/PfhQumNDCtQh+GSd1/J8mzqTBhTs6IBv
         M6+qfVpAwuBARwkJBj8z4ffKxoBSBlF7JEVCGL5YPnmVA5IlsOqbms3GxGEKaJ8vzC3K
         YQVh/tnPtzDE2UTLoLA3iEVX/oVQOTQ2bBL/I8EnbV0VJ6AJpuE0lmIda+W/CHRNSArw
         spU/1SNvGpeXfp3gzAge5vzI9p/XxTBFn6NDjR+AoNWUJ9ZoHE4loDRV6SAnXTEZGkkW
         tYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751430; x=1696356230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L4BaCdes/ph+FBDRPrYEBu7SdLjcMrWxDC5DvBg0S2c=;
        b=rHhl3S2ADnRuVo8DU+3I3U1rfTWe6Th7OJMI3KzO7gW42yzhmAYg9SxhijzDlBeMwv
         U0JSfvYYhnCOouAYGNm72g2uRbBTS2IkZjU2z+x6icaLBaYL40d9aFZA3SbA9ketvUgm
         WDiqoGs4ssrGk1i5G83d6ZkxnuJPwwhYxxzK6cVXoZADO2pIWKSvDGYCLgCkYYZ2Q9jP
         6JDRUwuJ9d4DTSuiDoko9ZVqaA8HFEvR4L2zWh9F/jN54CYqWiMPZ6NY/QaEKV6TBII+
         ycCL0XGXcL1QxjsmNBBqLqINmwCx/QzKIetKd6Yi+5M8mq3SK5ipyjUMWALuQpOYen3C
         4h5A==
X-Gm-Message-State: AOJu0Yxo/ceL6rGCZR/h/YvhSQcLz3CDP+wYhooRRmu874wiRfQQqK7C
        6aSts3DZ4GUelSJbWfJovl5Uvw==
X-Google-Smtp-Source: AGHT+IHh/9A5aVRflC7yv5D8ZGje9VJPvMlKVGnnlxuMjX80+rsaMTgsqP1l95FD9hZ9j3Of+oni4A==
X-Received: by 2002:a05:6214:4c1b:b0:656:51ed:b9e8 with SMTP id qh27-20020a0562144c1b00b0065651edb9e8mr9821932qvb.34.1695751430642;
        Tue, 26 Sep 2023 11:03:50 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id br30-20020a05620a461e00b0077411a459a8sm4494766qkb.4.2023.09.26.11.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:50 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 33/35] btrfs: add a bio argument to btrfs_csum_one_bio
Date:   Tue, 26 Sep 2023 14:01:59 -0400
Message-ID: <079f9a864fd440c7b286a154cd10e1381070b6d5.1695750478.git.josef@toxicpanda.com>
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

We only ever needed the bbio in btrfs_csum_one_bio, since that has the
bio embedded in it.  However with encryption we'll have a different bio
with the encrypted data in it, and the original bbio.  Update
btrfs_csum_one_bio to take the bio we're going to csum as an argument,
which will allow us to csum the encrypted bio and stuff the csums into
the corresponding bbio to be used later when the IO completes.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/bio.c       | 2 +-
 fs/btrfs/file-item.c | 3 +--
 fs/btrfs/file-item.h | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 4f3b693a16b1..90e4d4709fa3 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -533,7 +533,7 @@ static blk_status_t btrfs_bio_csum(struct btrfs_bio *bbio)
 {
 	if (bbio->bio.bi_opf & REQ_META)
 		return btree_csum_one_bio(bbio);
-	return btrfs_csum_one_bio(bbio);
+	return btrfs_csum_one_bio(bbio, &bbio->bio);
 }
 
 /*
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 35036fab58c4..d925d6d98bf4 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -730,13 +730,12 @@ int btrfs_lookup_csums_bitmap(struct btrfs_root *root, struct btrfs_path *path,
 /*
  * Calculate checksums of the data contained inside a bio.
  */
-blk_status_t btrfs_csum_one_bio(struct btrfs_bio *bbio)
+blk_status_t btrfs_csum_one_bio(struct btrfs_bio *bbio, struct bio *bio)
 {
 	struct btrfs_ordered_extent *ordered = bbio->ordered;
 	struct btrfs_inode *inode = bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	SHASH_DESC_ON_STACK(shash, fs_info->csum_shash);
-	struct bio *bio = &bbio->bio;
 	struct btrfs_ordered_sum *sums;
 	char *data;
 	struct bvec_iter iter;
diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
index bb79014024bd..e52d5d71d533 100644
--- a/fs/btrfs/file-item.h
+++ b/fs/btrfs/file-item.h
@@ -51,7 +51,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct btrfs_ordered_sum *sums);
-blk_status_t btrfs_csum_one_bio(struct btrfs_bio *bbio);
+blk_status_t btrfs_csum_one_bio(struct btrfs_bio *bbio, struct bio *bio);
 blk_status_t btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit,
-- 
2.41.0

