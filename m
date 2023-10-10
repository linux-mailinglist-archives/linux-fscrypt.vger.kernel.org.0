Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C980D7C41A9
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343822AbjJJUl6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344034AbjJJUlt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:49 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32F2D6
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:46 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-59f4f80d084so73974117b3.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970506; x=1697575306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NRH4SLgwNgVi2hMAGAQpqfi8yk6Nkn1gVR1vo3W10g8=;
        b=jS9L0u0rpIn59onc2icUtpcZBz0U7iVFRDauvfKh/absB3yHypDAfjTZx+88fWhpZX
         /h/MS+3ThwXVEyAzZ8bMfwVFB6eQvbsOtM2ZHdFF9bx34lB9XrZVQ3jHxBsU3WT9msv8
         TnQ044+m76o+KaFgL943Mx5HAcL8wnzHETwWY5/8NWgmaCk9GxH3cGay0UFxq0DSNCln
         5fScWPtdxeyu4Spqt7sD+ajW79exS0yebNIor1rRc2bYUPSAP5BV3zeZORBdAbka3Sf+
         xIfPEiUvNz3G6X+Ovd+QMoaafKBHoGek1qMBRNylrV74lhU8cWpe1qmdp3Y6VDcRDQpA
         vv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970506; x=1697575306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NRH4SLgwNgVi2hMAGAQpqfi8yk6Nkn1gVR1vo3W10g8=;
        b=ajgoM18rg58VvkTzdxiZavBgYAs21R5ZeiLrDcZIiAJfGhq42IxSA5UFdFecLjLSRz
         3ae9yQIGlv3E6EdSEI1vDavaS2Tk/3+tD3pBc+MghFDbPsWJwklzTU4zRqMGmmEh2yMS
         EN82bstLmX3TlqEzwIiOVriHeaMHqBuznn59X/tSrqQFIFdlvXNBwRiERvFd6rCjjWcI
         w7vvEX1t4M7xyp5SF1e3CUR040FSLFN3Fg+6UgTzbx1ckjVxue1dRYNrCP37LFhKB7tv
         0GzwndpcSTJKoOmnwWM2tZDKdsx5jootODsuogWN42GRzL1Mep4zT5WbE6jC31Jdbkn+
         VsNQ==
X-Gm-Message-State: AOJu0Yy8ayRTaAn9mfSHlPmHCdEsqe2BX79Xce+gv/VN1Ot06SOoZRbF
        m/TzvON5n7KUsv7tTEPu3KMo++A0PL0TtFjVFAytKw==
X-Google-Smtp-Source: AGHT+IHK2WU+sKiD+8oGs+u1Es2T9ACnf24UkZOfv55x1/n8ucve05NVQ4+qQcY+OlOk7onBfZfCog==
X-Received: by 2002:a81:8d52:0:b0:5a5:575:b222 with SMTP id w18-20020a818d52000000b005a50575b222mr17801693ywj.23.1696970505933;
        Tue, 10 Oct 2023 13:41:45 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id t184-20020a8183c1000000b005a247c18403sm4737130ywf.37.2023.10.10.13.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:45 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 36/36] btrfs: implement process_bio cb for fscrypt
Date:   Tue, 10 Oct 2023 16:40:51 -0400
Message-ID: <8fe21ee6831aef28a58672f4cb273f5689471151.1696970227.git.josef@toxicpanda.com>
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
index 726cb6121934..b7e92ee5e60b 100644
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
@@ -304,4 +322,5 @@ const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.set_context = btrfs_fscrypt_set_context,
 	.empty_dir = btrfs_fscrypt_empty_dir,
 	.get_devices = btrfs_fscrypt_get_devices,
+	.process_bio = btrfs_process_encrypted_bio,
 };
-- 
2.41.0

