Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1A8619020
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Nov 2022 06:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiKDFqf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Nov 2022 01:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiKDFqd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Nov 2022 01:46:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4322408B;
        Thu,  3 Nov 2022 22:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=uGzEDnS0opI0N3+YrSCvPtwJ0zk2gIeVGyGY7+bskrc=; b=iJ8ymjklHT3dqhcZjDpvXh2TDh
        iQ+kbCmNlcvxvscYAowI2Kzv8CsHHb/UzPGNDVewQAAS8YteesBumOpl5nM523EcAZlej+2eQioaH
        wrGu+matqvECSsAF4RCXQ20SU5GNeY+TYFItOpuIr8J4wS/CG7MDDjAPzILvcEENP0CTmH0MhDN6t
        K891/ib6xkHAON6s0C9swfIweomnPGJnzw3NWNJGwGOuTqBC9rdawsxUFDbg+6BiZEYkasHoRDXdc
        HL/FBkAWGPtl5E1qtOBLXJ/kQwRuPcCnHBti7yz8sGWd9qKWD3IOj1TuWojCkOu0LO79v13bKOteo
        7ezOgvNg==;
Received: from [2001:4bb8:182:29ca:9be5:7ea:ab68:47c9] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqpXB-002S1h-1r; Fri, 04 Nov 2022 05:46:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH 2/2] blk-crypto: add a blk_crypto_cfg_supported helper
Date:   Fri,  4 Nov 2022 06:46:21 +0100
Message-Id: <20221104054621.628369-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221104054621.628369-1-hch@lst.de>
References: <20221104054621.628369-1-hch@lst.de>
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
request queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-crypto-profile.c         |  7 +++++++
 block/blk-crypto.c                 | 13 ++++---------
 fs/crypto/inline_crypt.c           |  4 +---
 include/linux/blk-crypto-profile.h |  2 ++
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 96c511967386d..e8a0a3457fa29 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -353,6 +353,13 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
 	return true;
 }
 
+bool blk_crypto_cfg_supported(struct block_device *bdev,
+			      const struct blk_crypto_config *cfg)
+{
+	return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
+					  cfg);
+}
+
 /**
  * __blk_crypto_evict_key() - Evict a key from a device.
  * @profile: the crypto profile of the device
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 0e0c2fc56c428..b4597d0e87546 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -267,7 +267,6 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 {
 	struct bio *bio = *bio_ptr;
 	const struct blk_crypto_key *bc_key = bio->bi_crypt_context->bc_key;
-	struct blk_crypto_profile *profile;
 
 	/* Error if bio has no data. */
 	if (WARN_ON_ONCE(!bio_has_data(bio))) {
@@ -284,10 +283,8 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 	 * Success if device supports the encryption context, or if we succeeded
 	 * in falling back to the crypto API.
 	 */
-	profile = bdev_get_queue(bio->bi_bdev)->crypto_profile;
-	if (__blk_crypto_cfg_supported(profile, &bc_key->crypto_cfg))
+	if (blk_crypto_cfg_supported(bio->bi_bdev, &bc_key->crypto_cfg))
 		return true;
-
 	if (blk_crypto_fallback_bio_prep(bio_ptr))
 		return true;
 fail:
@@ -361,8 +358,7 @@ bool blk_crypto_config_supported(struct block_device *bdev,
 				 const struct blk_crypto_config *cfg)
 {
 	return IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-	       __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
-	       				  cfg);
+	       blk_crypto_cfg_supported(bdev, cfg);
 }
 
 /**
@@ -383,8 +379,7 @@ bool blk_crypto_config_supported(struct block_device *bdev,
 int blk_crypto_start_using_key(struct block_device *bdev,
 			       const struct blk_crypto_key *key)
 {
-	if (__blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
-			&key->crypto_cfg))
+	if (blk_crypto_cfg_supported(bdev, &key->crypto_cfg))
 		return 0;
 	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
 }
@@ -407,7 +402,7 @@ int blk_crypto_evict_key(struct block_device *bdev,
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (__blk_crypto_cfg_supported(q->crypto_profile, &key->crypto_cfg))
+	if (blk_crypto_cfg_supported(bdev, &key->crypto_cfg))
 		return __blk_crypto_evict_key(q->crypto_profile, key);
 
 	/*
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 55c4d8c23d30d..4034908743453 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -77,10 +77,8 @@ static void fscrypt_log_blk_crypto_impl(struct fscrypt_mode *mode,
 	unsigned int i;
 
 	for (i = 0; i < num_devs; i++) {
-		struct request_queue *q = bdev_get_queue(devs[i]);
-
 		if (!IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-		    __blk_crypto_cfg_supported(q->crypto_profile, cfg)) {
+		    blk_crypto_cfg_supported(devs[i], cfg)) {
 			if (!xchg(&mode->logged_blk_crypto_native, 1))
 				pr_info("fscrypt: %s using blk-crypto (native)\n",
 					mode->friendly_name);
diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
index bbab65bd54288..a9ddf543c8a97 100644
--- a/include/linux/blk-crypto-profile.h
+++ b/include/linux/blk-crypto-profile.h
@@ -144,6 +144,8 @@ blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
 
 void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot);
 
+bool blk_crypto_cfg_supported(struct block_device *bdev,
+			      const struct blk_crypto_config *cfg);
 bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
 				const struct blk_crypto_config *cfg);
 
-- 
2.30.2

