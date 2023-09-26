Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FCD7AF25D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbjIZSEC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235532AbjIZSEB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:04:01 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDD0192
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:53 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-658967a5334so54866346d6.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751433; x=1696356233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Edbq5tgXOIRcyTqEQ3s+ivFN/ofXmWB8jAzJZRGyEco=;
        b=S3A6RtZWCH9RAqJBsQ94bM9Ezz6+UlK4DSWCv2DQ4H4scIo+RFRevU4hlENp8Y5L9/
         mW9uF2g/5/9F5noxb0cGNPjoL0kMRLXHvFDESoV1nAzNHttt2ThWlzCqh/x8BOPEV2PM
         GVpiynledX8WxoYu+YLXrVJ76bZMm3YUFL6TSWE//5U2fFtzSVd70BakUaf1b2L+cDrX
         /G9K1GdcSM9QF+SyS8XdEx3tTtITWBC8p/AnU+tzNQKHKSIG+nYViTaS5r5crYpPda3l
         tTd0fGBC5skfe8GWHQWd9D/gglimrp8l1oE+VgO9v1XBOhkUZRI1eoTQKyPwJDhzafWo
         SnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751433; x=1696356233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Edbq5tgXOIRcyTqEQ3s+ivFN/ofXmWB8jAzJZRGyEco=;
        b=jSjErp+lDhQaGdWUGThd8yVCgoonu/TrdvdHCCHKn18omqjVE3JhDU1ChvruojtA+O
         LMDL2fnBhiTgE502lzEKXQPDn5kp1kp7fdRv++sKTArUnX8evfEdLqnV3YM1IxqEVOXA
         BeT7m6WoGDjZLFLx1zusqyeU0YGxojdcx4qYytrE1UorIs2/1iUc4AVp4zQZSp3gV1Zb
         swz1lGoHIT1C00pe6ohGFa68v+kkOdihX0vub7WPkENytoAdhz0fp0Ked0z2O2uLIPZF
         468hMg/dg3PvFaISZvhWXlBG7HhVu2ZKIbIrnMhh9VaU1MOnmmPZBAEW5lsxw+UB4HZn
         5H9A==
X-Gm-Message-State: AOJu0YzTvgq1yoznWbLoK7mzWKQntOKftuX/BozgamoX5OMHDKujmgLH
        iZUfssXaL5TunzH8E1jQA9oWbQ==
X-Google-Smtp-Source: AGHT+IHDrHahEEBgahtYUOMFgx+xXjeJpicmNK5aAUPE19vkE8UYrdymV6HCUUQUXhctdptuIwZAcw==
X-Received: by 2002:a0c:ec89:0:b0:656:3352:831e with SMTP id u9-20020a0cec89000000b006563352831emr11007859qvo.31.1695751432745;
        Tue, 26 Sep 2023 11:03:52 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id q7-20020a0cf5c7000000b00656506a1881sm5305554qvm.74.2023.09.26.11.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:52 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 35/35] btrfs: implement process_bio cb for fscrypt
Date:   Tue, 26 Sep 2023 14:02:01 -0400
Message-ID: <a26514814b4d2a54ff2317369365dc2bf1c280dc.1695750478.git.josef@toxicpanda.com>
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

We are going to be checksumming the encrypted data, so we have to
implement the ->process_bio fscrypt callback.  This will provide us with
the original bio and the encrypted bio to do work on.  For WRITE's this
will happen after the encrypted bio has been encrypted.  For READ's this
will happen after the read has completed and before the decryption step
is done.

For write's this is straightforward, we can just pass in the encrypted
bio to btrfs_csum_one_bio and then the csums will be added to the bbio
as normal.

For read's this is relatively straightforward, but requires some care.
We assume (because that's how it works currently) that the encrypted bio
match the original bio, this is important because we save the iter of
the bio before we submit.  If this changes in the future we'll need a
hook to give us the bi_iter of the decryption bio before it's submitted.
We check the csums before decryption.  If it doesn't match we simply
error out and we let the normal path handle the repair work.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/bio.c     | 34 +++++++++++++++++++++++++++++++++-
 fs/btrfs/bio.h     |  3 +++
 fs/btrfs/fscrypt.c | 19 +++++++++++++++++++
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 7d6931e53beb..27ebf6373c8f 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -280,6 +280,34 @@ static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
 	return fbio;
 }
 
+blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio,
+					    struct bio *enc_bio)
+{
+	struct btrfs_inode *inode = bbio->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	u32 sectorsize = fs_info->sectorsize;
+	struct bvec_iter iter = bbio->saved_iter;
+	struct btrfs_device *dev = bbio->bio.bi_private;
+	u32 offset = 0;
+
+	/*
+	 * We have to use a copy of iter in case there's an error,
+	 * btrfs_check_read_bio will handle submitting the repair bios.
+	 */
+	while (iter.bi_size) {
+		struct bio_vec bv = bio_iter_iovec(enc_bio, iter);
+
+		bv.bv_len = min(bv.bv_len, sectorsize);
+		if (!btrfs_data_csum_ok(bbio, dev, offset, &bv))
+			return BLK_STS_IOERR;
+		bio_advance_iter_single(enc_bio, &iter, sectorsize);
+		offset += sectorsize;
+	}
+
+	bbio->csum_done = true;
+	return BLK_STS_OK;
+}
+
 static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *dev)
 {
 	struct btrfs_inode *inode = bbio->inode;
@@ -305,6 +333,10 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
 	/* Clear the I/O error. A failed repair will reset it. */
 	bbio->bio.bi_status = BLK_STS_OK;
 
+	/* This was an encrypted bio and we've already done the csum check. */
+	if (status == BLK_STS_OK && bbio->csum_done)
+		goto out;
+
 	while (iter->bi_size) {
 		struct bio_vec bv = bio_iter_iovec(&bbio->bio, *iter);
 
@@ -315,7 +347,7 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
 		bio_advance_iter_single(&bbio->bio, iter, sectorsize);
 		offset += sectorsize;
 	}
-
+out:
 	if (bbio->csum != bbio->csum_inline)
 		kfree(bbio->csum);
 
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index 5d3f53dcd6d5..393ef32f5321 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -45,6 +45,7 @@ struct btrfs_bio {
 		struct {
 			u8 *csum;
 			u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
+			bool csum_done;
 			struct bvec_iter saved_iter;
 		};
 
@@ -110,5 +111,7 @@ void btrfs_submit_repair_write(struct btrfs_bio *bbio, int mirror_num, bool dev_
 int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 			    u64 length, u64 logical, struct page *page,
 			    unsigned int pg_offset, int mirror_num);
+blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio,
+					    struct bio *enc_bio);
 
 #endif
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 1c690fcd0693..b2dfc26221e7 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -15,6 +15,7 @@
 #include "transaction.h"
 #include "volumes.h"
 #include "xattr.h"
+#include "file-item.h"
 
 /*
  * From a given location in a leaf, read a name into a qstr (usually a
@@ -214,6 +215,23 @@ static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
 	return devs;
 }
 
+static blk_status_t btrfs_process_encrypted_bio(struct bio *orig_bio,
+						struct bio *enc_bio)
+{
+	struct btrfs_bio *bbio = btrfs_bio(orig_bio);
+
+	if (bio_op(orig_bio) == REQ_OP_READ) {
+		/*
+		 * We have ->saved_iter based on the orig_bio, so if the block
+		 * layer changes we need to notice this asap so we can update
+		 * our code to handle the new world order.
+		 */
+		ASSERT(orig_bio == enc_bio);
+		return btrfs_check_encrypted_read_bio(bbio, enc_bio);
+	}
+	return btrfs_csum_one_bio(bbio, enc_bio);
+}
+
 int btrfs_fscrypt_load_extent_info(struct btrfs_inode *inode,
 				   struct extent_map *em,
 				   struct btrfs_fscrypt_ctx *ctx)
@@ -303,5 +321,6 @@ const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.set_context = btrfs_fscrypt_set_context,
 	.empty_dir = btrfs_fscrypt_empty_dir,
 	.get_devices = btrfs_fscrypt_get_devices,
+	.process_bio = btrfs_process_encrypted_bio,
 	.key_prefix = "btrfs:"
 };
-- 
2.41.0

