Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD9A6B1229
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Mar 2023 20:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCHTjk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Mar 2023 14:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjCHTjj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Mar 2023 14:39:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093AB7D091;
        Wed,  8 Mar 2023 11:39:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A5C361939;
        Wed,  8 Mar 2023 19:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC25C433A0;
        Wed,  8 Mar 2023 19:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678304377;
        bh=jUFFwIrjwlkdx2u75JjBew7+G5pN2IhZ8ExoTUl0X5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gk17Dxws07+M1VsKyVxeKzfhatrISPPml9Ha1FomdjF03NnY60rQ4WDwbmBE8j0az
         IRr/CEb8wexZ+rRaF9josTKFvBPh4hbbU+Lp4mDzCtdSKJM0PaXmwGGVkFO2EUTOZe
         O6G3Qk/WMfEnJcXLyBR4f01d3x7a8tCiuMLYgPlZrVbHfan5yOQTdPpZkZQD64elA9
         utcFMDkNcz40H46FVoft9WWtuGs+GBkgijIMk5I8oWsD0VZuY79IQHujWPV5xvihJP
         gQSEsQDJVPLHfJpp2D5l/jsy1/HMMxdsHMaSR9wt1JNURrAlm8DsNBPbKLlr+jVvYi
         +jYpK7uRSac4g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Subject: [PATCH v2 4/4] blk-crypto: drop the NULL check from blk_crypto_put_keyslot()
Date:   Wed,  8 Mar 2023 11:36:45 -0800
Message-Id: <20230308193645.114069-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308193645.114069-1-ebiggers@kernel.org>
References: <20230308193645.114069-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto-profile.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 1b20ead59f39..6c16edfa0dee 100644
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

