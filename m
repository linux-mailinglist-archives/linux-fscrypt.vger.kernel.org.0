Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0C961F661
	for <lists+linux-fscrypt@lfdr.de>; Mon,  7 Nov 2022 15:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbiKGOmo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Nov 2022 09:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiKGOmn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Nov 2022 09:42:43 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1241A05D;
        Mon,  7 Nov 2022 06:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=RDGGNn+evwHccW0om11iUjQ2+qGbFF8rWY/47rLmNDY=; b=l2Lu42A+1frIPy64hAOM8fc1/A
        mbciv/JZnGAeyqm/jZo0NPxWYSUQ1z5Aa3StZ16+1M40HVbRX815LRMZG82h8D1GgOFfYQuk0PhUj
        yZmJG+9CuBPa5NuJ4g9XbcCVdWSTGI+70WXgx4JtPUQ9BBSvsV1tM4h4buNCDa4iOYnE3OnRj/3Ph
        DgRNSA6Kpe4N6HjHNN74AbsTr5Tw+BiA8z0upzH15lS8gVfdT3N7wbtXdkqy0a5gYYmh7Rydq6uhe
        HQIzeJWpBjYgJEfAVYcnETbPb6tQdySOtMxjIrLTOr69NoVHxEna3QN4uy8kmUUtm5ldntTeNyySK
        J+3FmGvQ==;
Received: from [2001:4bb8:191:2450:bd6a:c86c:b287:8b99] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1os3Kf-00FJaj-Dg; Mon, 07 Nov 2022 14:42:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH 2/3] blk-crypto: add a blk_crypto_config_supported_natively helper
Date:   Mon,  7 Nov 2022 15:42:28 +0100
Message-Id: <20221107144229.1547370-3-hch@lst.de>
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

Add a blk_crypto_cfg_supported helper that wraps
__blk_crypto_cfg_supported to retreive the crypto_profile from the
request queue.  With this fscrypt can stop including
blk-crypto-profile.h and rely on the public consumer interface in
blk-crypto.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-crypto.c         | 21 ++++++++++++---------
 fs/crypto/inline_crypt.c   |  6 ++----
 include/linux/blk-crypto.h |  2 ++
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 0e0c2fc56c428..ceb5a4c8f0306 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -267,7 +267,6 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 {
 	struct bio *bio = *bio_ptr;
 	const struct blk_crypto_key *bc_key = bio->bi_crypt_context->bc_key;
-	struct blk_crypto_profile *profile;
 
 	/* Error if bio has no data. */
 	if (WARN_ON_ONCE(!bio_has_data(bio))) {
@@ -284,10 +283,9 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 	 * Success if device supports the encryption context, or if we succeeded
 	 * in falling back to the crypto API.
 	 */
-	profile = bdev_get_queue(bio->bi_bdev)->crypto_profile;
-	if (__blk_crypto_cfg_supported(profile, &bc_key->crypto_cfg))
+	if (blk_crypto_config_supported_natively(bio->bi_bdev,
+						 &bc_key->crypto_cfg))
 		return true;
-
 	if (blk_crypto_fallback_bio_prep(bio_ptr))
 		return true;
 fail:
@@ -352,6 +350,13 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 	return 0;
 }
 
+bool blk_crypto_config_supported_natively(struct block_device *bdev,
+					  const struct blk_crypto_config *cfg)
+{
+	return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
+					  cfg);
+}
+
 /*
  * Check if bios with @cfg can be en/decrypted by blk-crypto (i.e. either the
  * request queue it's submitted to supports inline crypto, or the
@@ -361,8 +366,7 @@ bool blk_crypto_config_supported(struct block_device *bdev,
 				 const struct blk_crypto_config *cfg)
 {
 	return IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-	       __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
-	       				  cfg);
+	       blk_crypto_config_supported_natively(bdev, cfg);
 }
 
 /**
@@ -383,8 +387,7 @@ bool blk_crypto_config_supported(struct block_device *bdev,
 int blk_crypto_start_using_key(struct block_device *bdev,
 			       const struct blk_crypto_key *key)
 {
-	if (__blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
-			&key->crypto_cfg))
+	if (blk_crypto_config_supported_natively(bdev, &key->crypto_cfg))
 		return 0;
 	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
 }
@@ -407,7 +410,7 @@ int blk_crypto_evict_key(struct block_device *bdev,
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (__blk_crypto_cfg_supported(q->crypto_profile, &key->crypto_cfg))
+	if (blk_crypto_config_supported_natively(bdev, &key->crypto_cfg))
 		return __blk_crypto_evict_key(q->crypto_profile, key);
 
 	/*
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 55c4d8c23d30d..8bfb3ce864766 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -12,7 +12,7 @@
  * provides the key and IV to use.
  */
 
-#include <linux/blk-crypto-profile.h>
+#include <linux/blk-crypto.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <linux/sched/mm.h>
@@ -77,10 +77,8 @@ static void fscrypt_log_blk_crypto_impl(struct fscrypt_mode *mode,
 	unsigned int i;
 
 	for (i = 0; i < num_devs; i++) {
-		struct request_queue *q = bdev_get_queue(devs[i]);
-
 		if (!IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-		    __blk_crypto_cfg_supported(q->crypto_profile, cfg)) {
+		    blk_crypto_config_supported_natively(devs[i], cfg)) {
 			if (!xchg(&mode->logged_blk_crypto_native, 1))
 				pr_info("fscrypt: %s using blk-crypto (native)\n",
 					mode->friendly_name);
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index b314e2febcaf5..1271ff39ab162 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -100,6 +100,8 @@ int blk_crypto_start_using_key(struct block_device *bdev,
 int blk_crypto_evict_key(struct block_device *bdev,
 			 const struct blk_crypto_key *key);
 
+bool blk_crypto_config_supported_natively(struct block_device *bdev,
+					  const struct blk_crypto_config *cfg);
 bool blk_crypto_config_supported(struct block_device *bdev,
 				 const struct blk_crypto_config *cfg);
 
-- 
2.30.2

