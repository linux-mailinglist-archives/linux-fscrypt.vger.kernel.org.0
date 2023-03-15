Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AE56BBC7D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Mar 2023 19:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjCOSmQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Mar 2023 14:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjCOSmP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Mar 2023 14:42:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1F313DDA;
        Wed, 15 Mar 2023 11:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A02861E50;
        Wed, 15 Mar 2023 18:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFCAC433D2;
        Wed, 15 Mar 2023 18:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678905633;
        bh=JxQjRBgYS6KrYKBuMUapr6XvhJ+sb1I8bM5e+bk8euE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppeym9PMY1rGkTvyOtpcNq7n09HVCZWOSk/S1LQuOY9TSPs3KU5TJXxoiPGsDhdYx
         gB+llmbKXowE09KA+dfykisJMMLxeTuDiZuxdB76QKzIuNw1zN1uB0XEM2wyxuDrKw
         gYcyM1Gj1QdnkOS+4+j9Wm7zrsQe5DHBrm0gej1NUL3jSB/hfGpjuuBk4oXMIFCiyX
         +2EScC8Cu3EvHZ4L6MeRY9JpoRBRz7YeR/BnKzqJ/VFaZEg7U0VGLbpDVsQ1j91AbJ
         Wbk/Y27x/DpeZDsFI8ToBT8F7g9fznwTNfkxfdKZnVKgbWjZtxxwzceANXG7KJAq7I
         u8Eo4z0sf5zjQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Subject: [PATCH v3 5/6] blk-mq: return actual keyslot error in blk_insert_cloned_request()
Date:   Wed, 15 Mar 2023 11:39:06 -0700
Message-Id: <20230315183907.53675-6-ebiggers@kernel.org>
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

To avoid hiding information, pass on the error code from
blk_crypto_rq_get_keyslot() instead of always using BLK_STS_IOERR.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-mq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5e819de2f5e70..a875b1cdff9b5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3049,8 +3049,9 @@ blk_status_t blk_insert_cloned_request(struct request *rq)
 	if (q->disk && should_fail_request(q->disk->part0, blk_rq_bytes(rq)))
 		return BLK_STS_IOERR;
 
-	if (blk_crypto_rq_get_keyslot(rq))
-		return BLK_STS_IOERR;
+	ret = blk_crypto_rq_get_keyslot(rq);
+	if (ret != BLK_STS_OK)
+		return ret;
 
 	blk_account_io_start(rq);
 
-- 
2.39.2

