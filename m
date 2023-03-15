Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F476BBCAB
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Mar 2023 19:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbjCOSt3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Mar 2023 14:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbjCOSt2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Mar 2023 14:49:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02A911E96;
        Wed, 15 Mar 2023 11:49:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21B10B81F0F;
        Wed, 15 Mar 2023 18:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D0FC433A0;
        Wed, 15 Mar 2023 18:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678905633;
        bh=nxXzrV07OaXxqVH25OB7zwsJ+hxE6DhfHAt+jgSYsdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vp8062PukWtWA7LIfozadkUw6LhUAjVFW0Vy1SoX+FDhz652uRPmd3kpiPeG/w1mQ
         fSx03d5Q65gxi/4brtX9CFJNMvH8Q4N0Fp7hgj+Qvy0b+F8IJkrNRx2TN5ZDZx3Y0y
         PCun7TYVL7SE+pmkNUcPobnnX5ntqyFD5CBYa64tTaUKTCFEs74QSf3iUzXF0dtdLv
         ciiaOsYRCxCZZNH59hZrO7vidRgA/wyH8lVO5S+KJXC6YlAPppYk0AW1sWRUMqHeDm
         zZ+rJASuw0QAuppSmPwuqAmvzR05AynwHkVBN+tCdu1KSi+KPdjeBmYmc7tN23vFGO
         HjzmMfWPbR83w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 6/6] blk-crypto: drop the NULL check from blk_crypto_put_keyslot()
Date:   Wed, 15 Mar 2023 11:39:07 -0700
Message-Id: <20230315183907.53675-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315183907.53675-1-ebiggers@kernel.org>
References: <20230315183907.53675-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that all callers of blk_crypto_put_keyslot() check for NULL before
calling it, there is no need for blk_crypto_put_keyslot() to do the NULL
check itself.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto-profile.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 3290c03c9918d..2a67d3fb63e5c 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -227,14 +227,13 @@ EXPORT_SYMBOL_GPL(blk_crypto_keyslot_index);
  * @profile: the crypto profile of the device the key will be used on
  * @key: the key that will be used
  * @slot_ptr: If a keyslot is allocated, an opaque pointer to the keyslot struct
- *	      will be stored here; otherwise NULL will be stored here.
+ *	      will be stored here.  blk_crypto_put_keyslot() must be called
+ *	      later to release it.  Otherwise, NULL will be stored here.
  *
  * If the device has keyslots, this gets a keyslot that's been programmed with
  * the specified key.  If the key is already in a slot, this reuses it;
  * otherwise this waits for a slot to become idle and programs the key into it.
  *
- * This must be paired with a call to blk_crypto_put_keyslot().
- *
  * Context: Process context. Takes and releases profile->lock.
  * Return: BLK_STS_OK on success, meaning that either a keyslot was allocated or
  *	   one wasn't needed; or a blk_status_t error on failure.
@@ -312,20 +311,15 @@ blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
 
 /**
  * blk_crypto_put_keyslot() - Release a reference to a keyslot
- * @slot: The keyslot to release the reference of (may be NULL).
+ * @slot: The keyslot to release the reference of
  *
  * Context: Any context.
  */
 void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot)
 {
-	struct blk_crypto_profile *profile;
+	struct blk_crypto_profile *profile = slot->profile;
 	unsigned long flags;
 
-	if (!slot)
-		return;
-
-	profile = slot->profile;
-
 	if (atomic_dec_and_lock_irqsave(&slot->slot_refs,
 					&profile->idle_slots_lock, flags)) {
 		list_add_tail(&slot->idle_slot_node, &profile->idle_slots);
-- 
2.39.2

