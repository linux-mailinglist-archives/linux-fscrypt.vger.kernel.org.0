Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F597C41A3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343745AbjJJUl4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343991AbjJJUlq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:46 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37A7BA
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:44 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-579de633419so74998087b3.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970503; x=1697575303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L4BaCdes/ph+FBDRPrYEBu7SdLjcMrWxDC5DvBg0S2c=;
        b=egYpJ/oT8YjKfmr1j3QA1LQIq+yYs5wdhHKnWoPE+rTmlI/be/v5bBspEttg3DetmU
         B46z7P64K9Elh0MktZafDJSMBNglIXtTAN6wJM7BsRhyTpVWdiKkqCWe2GJqrMgTa+8A
         vkTmTUvBDlnPEN8VZz0wqR82SRDO0wNCW4hjSGs9F3WcE88LWLOD903GzENUy13P/QAP
         aAFJL9ML6NyHMvjLLuNF31TOEmGTUTQU87OV+NM7Hv7pVzTC2/Gcgua7/PiSPU2nn8TE
         c4hCUsnvHNwNN997XjFjkwTR/0QzYMnZDoOprrcaUEuLmjci71X8Dgzj7sDdHrino9dK
         9KWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970503; x=1697575303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L4BaCdes/ph+FBDRPrYEBu7SdLjcMrWxDC5DvBg0S2c=;
        b=DnGE6VlvWNa0vFuxgsyAfUbDFmWM4cYiztHtFUI6wX86OPvLZvFv8uxUvza0dPB0Uy
         n4oT6iGQI2Xlj+MWuTFTWw7Hn8THolMuyw27Lz9/9GLyAyyU5gQjV0r0W3vKb6J5e5Sa
         A884p1QKgI1FFoXNrds60mY3hQMsvvXtPuG4aM+yCcGVrh1VS/v+CbDS8CP80JxfWE1O
         MI36GjEpnHHkXjQm1FvNIZla4/l5D3PRe39fG2eaABGJHiTK4GUX5kUKpVDPMeTkwZk6
         SZKrGbfKxQ/E2o3PJ6ntym6DpzmkrdSpekNBkDz9x+ZnmwCkXlMc3t19JorqA2nPwBUS
         US5Q==
X-Gm-Message-State: AOJu0YyhxErmvUHnCvam8jsW7mhSrv9+OzoceZn6LxkxS4Z5/3Fq+JMl
        OpP+aDG+FfDh2sdTs6x91BS1iZ4/mFRtwQs0j1i/Rw==
X-Google-Smtp-Source: AGHT+IGFFFqdGS+bEMrI8IIbPKrLa10j5ewUtMWPqPRYQCytN6foBRilPYIxmD8Hxi9PGHUSYl3Yww==
X-Received: by 2002:a0d:c8c3:0:b0:59b:fb69:1639 with SMTP id k186-20020a0dc8c3000000b0059bfb691639mr18781097ywd.32.1696970503228;
        Tue, 10 Oct 2023 13:41:43 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id r70-20020a0de849000000b00570253fc3e5sm115304ywe.105.2023.10.10.13.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:42 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 34/36] btrfs: add a bio argument to btrfs_csum_one_bio
Date:   Tue, 10 Oct 2023 16:40:49 -0400
Message-ID: <837a5b3c1449c0d4f83fee09be721114398fa47d.1696970227.git.josef@toxicpanda.com>
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

