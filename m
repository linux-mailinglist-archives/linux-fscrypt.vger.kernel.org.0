Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538F961901E
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Nov 2022 06:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiKDFqe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Nov 2022 01:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiKDFqd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Nov 2022 01:46:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F876275E2;
        Thu,  3 Nov 2022 22:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-ID:Content-Description;
        bh=QC6lvkK2JD8wN2tPHohvLGvp/4phH8zXP+23YeaGEcY=; b=fSGfrQQ8Vdzzk4AgO3PxpjqlfG
        zc9adaECO2oy455z/syPo0C4Tyj0M8lEWagUIIfLA9NjtgUWjxrYQc0cAV76QC56G60I+6tAKT5uH
        AscaRmCY8KsLYN39XiKpa4ZHdUpemwUZp2+yHQO6cTZX/aQWHyK8rdWNARU5dGGYzCuaA4CpGV2I4
        xr+6eFoF5rGZrnnIi3jcGSlDPlYZAgm/RxRNuw83JU9Q6OwDiWTHk5GKrr4Bt7HhuZysn0QjWWGSq
        299ewUOGJ9WeZM/wQONoSgnn5jZ5AsMbiTmW9HkYtLItQ08OJM+59LewNG+wuosOM9sT3K/ILCuC1
        advB5PtQ==;
Received: from [2001:4bb8:182:29ca:9be5:7ea:ab68:47c9] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqpX8-002S1Z-Ba; Fri, 04 Nov 2022 05:46:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH 1/2] blk-crypto: don't use struct request_queue for public interfaces
Date:   Fri,  4 Nov 2022 06:46:20 +0100
Message-Id: <20221104054621.628369-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221104054621.628369-1-hch@lst.de>
References: <20221104054621.628369-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 Documentation/block/inline-encryption.rst | 24 +++++++++++------------
 block/blk-crypto.c                        | 20 +++++++++++--------
 drivers/md/dm-table.c                     |  2 +-
 fs/crypto/inline_crypt.c                  |  8 +++-----
 include/linux/blk-crypto.h                |  8 ++++----
 5 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/Documentation/block/inline-encryption.rst b/Documentation/block/inline-encryption.rst
index 4d151fbe20583..168d465f65263 100644
--- a/Documentation/block/inline-encryption.rst
+++ b/Documentation/block/inline-encryption.rst
@@ -97,7 +97,7 @@ blk_crypto_profile serves as the way that drivers for inline encryption hardware
 advertise their crypto capabilities and provide certain functions (e.g.,
 functions to program and evict keys) to upper layers.  Each device driver that
 wants to support inline encryption will construct a blk_crypto_profile, then
-associate it with the disk's request_queue.
+associate it with the block device.
 
 The blk_crypto_profile also manages the hardware's keyslots, when applicable.
 This happens in the block layer, so that users of the block layer can just
@@ -124,7 +124,7 @@ numbers.  Only the encryption context for the first bio in a request is
 retained, since the remaining bios have been verified to be merge-compatible
 with the first bio.
 
-To make it possible for inline encryption to work with request_queue based
+To make it possible for inline encryption to work with struct request based
 layered devices, when a request is cloned, its encryption context is cloned as
 well.  When the cloned request is submitted, it is then processed as usual; this
 includes getting a keyslot from the clone's target device if needed.
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
+block_devіce -- either via hardware or via blk-crypto-fallback.  This function
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
@@ -242,7 +242,7 @@ hardware, e.g. how to program and evict keyslots.  Most drivers will need to
 implement ``keyslot_program`` and ``keyslot_evict``.  For details, see the
 comments for ``struct blk_crypto_ll_ops``.
 
-Once the driver registers a blk_crypto_profile with a request_queue, I/O
+Once the driver registers a blk_crypto_profile with a block_device, I/O
 requests the driver receives via that queue may have an encryption context.  All
 encryption contexts will be compatible with the crypto capabilities declared in
 the blk_crypto_profile, so drivers don't need to worry about handling
@@ -266,10 +266,10 @@ Finally, if the driver used ``blk_crypto_profile_init()`` instead of
 Layered Devices
 ===============
 
-Request queue based layered devices like dm-rq that wish to support inline
-encryption need to create their own blk_crypto_profile for their request_queue,
+Request based layered devices like dm-rq that wish to support inline
+encryption need to create their own blk_crypto_profile for their block_device,
 and expose whatever functionality they choose. When a layered device wants to
-pass a clone of that request to another request_queue, blk-crypto will
+pass a clone of that request to another block_device, blk-crypto will
 initialize and prepare the clone as necessary; see
 ``blk_crypto_insert_cloned_request()``.
 
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

