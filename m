Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BF261F663
	for <lists+linux-fscrypt@lfdr.de>; Mon,  7 Nov 2022 15:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbiKGOmp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Nov 2022 09:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiKGOmo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Nov 2022 09:42:44 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3235DBC37;
        Mon,  7 Nov 2022 06:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=n4pPHyOwaRdxHxGG9btccTsZ/aylnz4d4U/iIiA+4qU=; b=RhV5vkDxRo62MJF/b5xNUptTyM
        POeLn3P4J3PimNw+PwcS4Tuk82vMxrH4/0+gwLXbYBWYMNughMVunEh/ZLmpHZcI+6YjhRcWTYuFf
        dHboJTSai2ZpqTfSlG1p59U0HgIMXuQxpp7u4PqfQ+msgCKar2xQ7IG8psbziDq4kxf2ew3fjNoTD
        fKMABpy0Qqrc0R4oP8dcS8X45JzGAJUTENq3KVI9xSVDH1LQPGVG087W4k5IP3dN8izb+2OusV9vk
        exWXr2JIxZ/+/IdYE+wdjpqKHtnfjTtD6F0CXDS1+hzi2JcNITGD6p1B6osTdfMoznq0Ce+6jGTh9
        fCmCMWXg==;
Received: from [2001:4bb8:191:2450:bd6a:c86c:b287:8b99] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1os3Kc-00FJYi-K7; Mon, 07 Nov 2022 14:42:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH 1/3] blk-crypto: don't use struct request_queue for public interfaces
Date:   Mon,  7 Nov 2022 15:42:27 +0100
Message-Id: <20221107144229.1547370-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221107144229.1547370-1-hch@lst.de>
References: <20221107144229.1547370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Switch all public blk-crypto interfaces to use struct block_device
arguments to specify the device they operate on instead of th
request_queue, which is a block layer implementation detail.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/block/inline-encryption.rst | 12 ++++++------
 block/blk-crypto.c                        | 20 ++++++++++++--------
 drivers/md/dm-table.c                     |  2 +-
 fs/crypto/inline_crypt.c                  |  8 +++-----
 include/linux/blk-crypto.h                |  8 ++++----
 5 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/Documentation/block/inline-encryption.rst b/Documentation/block/inline-encryption.rst
index 4d151fbe20583..f9bf18ea65093 100644
--- a/Documentation/block/inline-encryption.rst
+++ b/Documentation/block/inline-encryption.rst
@@ -142,7 +142,7 @@ Therefore, we also introduce *blk-crypto-fallback*, which is an implementation
 of inline encryption using the kernel crypto API.  blk-crypto-fallback is built
 into the block layer, so it works on any block device without any special setup.
 Essentially, when a bio with an encryption context is submitted to a
-request_queue that doesn't support that encryption context, the block layer will
+block_device that doesn't support that encryption context, the block layer will
 handle en/decryption of the bio using blk-crypto-fallback.
 
 For encryption, the data cannot be encrypted in-place, as callers usually rely
@@ -187,7 +187,7 @@ API presented to users of the block layer
 
 ``blk_crypto_config_supported()`` allows users to check ahead of time whether
 inline encryption with particular crypto settings will work on a particular
-request_queue -- either via hardware or via blk-crypto-fallback.  This function
+block_device -- either via hardware or via blk-crypto-fallback.  This function
 takes in a ``struct blk_crypto_config`` which is like blk_crypto_key, but omits
 the actual bytes of the key and instead just contains the algorithm, data unit
 size, etc.  This function can be useful if blk-crypto-fallback is disabled.
@@ -195,7 +195,7 @@ size, etc.  This function can be useful if blk-crypto-fallback is disabled.
 ``blk_crypto_init_key()`` allows users to initialize a blk_crypto_key.
 
 Users must call ``blk_crypto_start_using_key()`` before actually starting to use
-a blk_crypto_key on a request_queue (even if ``blk_crypto_config_supported()``
+a blk_crypto_key on a block_device (even if ``blk_crypto_config_supported()``
 was called earlier).  This is needed to initialize blk-crypto-fallback if it
 will be needed.  This must not be called from the data path, as this may have to
 allocate resources, which may deadlock in that case.
@@ -207,7 +207,7 @@ for en/decryption.  Users don't need to worry about freeing the bio_crypt_ctx
 later, as that happens automatically when the bio is freed or reset.
 
 Finally, when done using inline encryption with a blk_crypto_key on a
-request_queue, users must call ``blk_crypto_evict_key()``.  This ensures that
+block_device, users must call ``blk_crypto_evict_key()``.  This ensures that
 the key is evicted from all keyslots it may be programmed into and unlinked from
 any kernel data structures it may be linked into.
 
@@ -221,9 +221,9 @@ as follows:
 5. ``blk_crypto_evict_key()`` (after all I/O has completed)
 6. Zeroize the blk_crypto_key (this has no dedicated function)
 
-If a blk_crypto_key is being used on multiple request_queues, then
+If a blk_crypto_key is being used on multiple block_devices, then
 ``blk_crypto_config_supported()`` (if used), ``blk_crypto_start_using_key()``,
-and ``blk_crypto_evict_key()`` must be called on each request_queue.
+and ``blk_crypto_evict_key()`` must be called on each block_device.
 
 API presented to device drivers
 ===============================
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index a496aaef85ba4..0e0c2fc56c428 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -357,17 +357,18 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
  * request queue it's submitted to supports inline crypto, or the
  * blk-crypto-fallback is enabled and supports the cfg).
  */
-bool blk_crypto_config_supported(struct request_queue *q,
+bool blk_crypto_config_supported(struct block_device *bdev,
 				 const struct blk_crypto_config *cfg)
 {
 	return IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-	       __blk_crypto_cfg_supported(q->crypto_profile, cfg);
+	       __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
+	       				  cfg);
 }
 
 /**
  * blk_crypto_start_using_key() - Start using a blk_crypto_key on a device
+ * @bdev: block device to operate on
  * @key: A key to use on the device
- * @q: the request queue for the device
  *
  * Upper layers must call this function to ensure that either the hardware
  * supports the key's crypto settings, or the crypto API fallback has transforms
@@ -379,10 +380,11 @@ bool blk_crypto_config_supported(struct request_queue *q,
  *	   blk-crypto-fallback is either disabled or the needed algorithm
  *	   is disabled in the crypto API; or another -errno code.
  */
-int blk_crypto_start_using_key(const struct blk_crypto_key *key,
-			       struct request_queue *q)
+int blk_crypto_start_using_key(struct block_device *bdev,
+			       const struct blk_crypto_key *key)
 {
-	if (__blk_crypto_cfg_supported(q->crypto_profile, &key->crypto_cfg))
+	if (__blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
+			&key->crypto_cfg))
 		return 0;
 	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
 }
@@ -390,7 +392,7 @@ int blk_crypto_start_using_key(const struct blk_crypto_key *key,
 /**
  * blk_crypto_evict_key() - Evict a key from any inline encryption hardware
  *			    it may have been programmed into
- * @q: The request queue who's associated inline encryption hardware this key
+ * @bdev: The block_device who's associated inline encryption hardware this key
  *     might have been programmed into
  * @key: The key to evict
  *
@@ -400,9 +402,11 @@ int blk_crypto_start_using_key(const struct blk_crypto_key *key,
  *
  * Return: 0 on success or if the key wasn't in any keyslot; -errno on error.
  */
-int blk_crypto_evict_key(struct request_queue *q,
+int blk_crypto_evict_key(struct block_device *bdev,
 			 const struct blk_crypto_key *key)
 {
+	struct request_queue *q = bdev_get_queue(bdev);
+
 	if (__blk_crypto_cfg_supported(q->crypto_profile, &key->crypto_cfg))
 		return __blk_crypto_evict_key(q->crypto_profile, key);
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 078da18bb86d8..8541d5688f3a6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1215,7 +1215,7 @@ static int dm_keyslot_evict_callback(struct dm_target *ti, struct dm_dev *dev,
 	struct dm_keyslot_evict_args *args = data;
 	int err;
 
-	err = blk_crypto_evict_key(bdev_get_queue(dev->bdev), args->key);
+	err = blk_crypto_evict_key(dev->bdev, args->key);
 	if (!args->err)
 		args->err = err;
 	/* Always try to evict the key from all devices. */
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index cea8b14007e6a..55c4d8c23d30d 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -139,8 +139,7 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 		return PTR_ERR(devs);
 
 	for (i = 0; i < num_devs; i++) {
-		if (!blk_crypto_config_supported(bdev_get_queue(devs[i]),
-						 &crypto_cfg))
+		if (!blk_crypto_config_supported(devs[i], &crypto_cfg))
 			goto out_free_devs;
 	}
 
@@ -184,8 +183,7 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 		goto fail;
 	}
 	for (i = 0; i < num_devs; i++) {
-		err = blk_crypto_start_using_key(blk_key,
-						 bdev_get_queue(devs[i]));
+		err = blk_crypto_start_using_key(devs[i], blk_key);
 		if (err)
 			break;
 	}
@@ -224,7 +222,7 @@ void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
 	devs = fscrypt_get_devices(sb, &num_devs);
 	if (!IS_ERR(devs)) {
 		for (i = 0; i < num_devs; i++)
-			blk_crypto_evict_key(bdev_get_queue(devs[i]), blk_key);
+			blk_crypto_evict_key(devs[i], blk_key);
 		kfree(devs);
 	}
 	kfree_sensitive(blk_key);
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 69b24fe92cbf1..b314e2febcaf5 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -94,13 +94,13 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 			unsigned int dun_bytes,
 			unsigned int data_unit_size);
 
-int blk_crypto_start_using_key(const struct blk_crypto_key *key,
-			       struct request_queue *q);
+int blk_crypto_start_using_key(struct block_device *bdev,
+			       const struct blk_crypto_key *key);
 
-int blk_crypto_evict_key(struct request_queue *q,
+int blk_crypto_evict_key(struct block_device *bdev,
 			 const struct blk_crypto_key *key);
 
-bool blk_crypto_config_supported(struct request_queue *q,
+bool blk_crypto_config_supported(struct block_device *bdev,
 				 const struct blk_crypto_config *cfg);
 
 #else /* CONFIG_BLK_INLINE_ENCRYPTION */
-- 
2.30.2

