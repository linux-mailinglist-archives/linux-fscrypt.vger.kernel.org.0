Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D456B122D
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Mar 2023 20:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjCHTjm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Mar 2023 14:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjCHTjk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Mar 2023 14:39:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C8C838A9;
        Wed,  8 Mar 2023 11:39:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69FE6B81269;
        Wed,  8 Mar 2023 19:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEF5C4339C;
        Wed,  8 Mar 2023 19:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678304377;
        bh=vEKYcc/LTBd9qDV4oAD0WbQzxrfB47Q4z7AN/AsRbpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIDAcnzmSNMdM77xUUJI93gQ+oCUgHyITXqF1NGtAayyh0/1I6FQwiXIEYDjA1Ob6
         B8KIq7GS4CMFxLhsIYkeao9xHWM5vZ4of9CbhICNIj5P+rQQVWW9GwPHpMyNji5TO7
         MyWbLw/QdzwsxT72NNx/WFJZkyVMb3IPo+DWToYpvMTPno9TvbWrmU+6xFbQUAZgnZ
         iwMZse34Nlaez7z1vBXHbm/rJidsX7h6XqncKDUYf8MsicCVy6DZXySTs8Dh5SpY/s
         f94/Bg2zvjE8YJYmITG6wGTyNwwyHdeaIUOdyh7yfRDraCngbZ3wbvQ5pEIXATaWGc
         MyeExzdwtiGZw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Subject: [PATCH v2 3/4] blk-crypto: remove blk_crypto_insert_cloned_request()
Date:   Wed,  8 Mar 2023 11:36:44 -0800
Message-Id: <20230308193645.114069-4-ebiggers@kernel.org>
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

blk_crypto_insert_cloned_request() is the same as
blk_crypto_rq_get_keyslot(), so just use that directly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/block/inline-encryption.rst |  3 +--
 block/blk-crypto-internal.h               | 15 ---------------
 block/blk-mq.c                            |  2 +-
 3 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/Documentation/block/inline-encryption.rst b/Documentation/block/inline-encryption.rst
index f9bf18ea6509..90b733422ed4 100644
--- a/Documentation/block/inline-encryption.rst
+++ b/Documentation/block/inline-encryption.rst
@@ -270,8 +270,7 @@ Request queue based layered devices like dm-rq that wish to support inline
 encryption need to create their own blk_crypto_profile for their request_queue,
 and expose whatever functionality they choose. When a layered device wants to
 pass a clone of that request to another request_queue, blk-crypto will
-initialize and prepare the clone as necessary; see
-``blk_crypto_insert_cloned_request()``.
+initialize and prepare the clone as necessary.
 
 Interaction between inline encryption and blk integrity
 =======================================================
diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index 4f1de2495f0c..93a141979694 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -205,21 +205,6 @@ static inline int blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
 	return 0;
 }
 
-/**
- * blk_crypto_insert_cloned_request - Prepare a cloned request to be inserted
- *				      into a request queue.
- * @rq: the request being queued
- *
- * Return: BLK_STS_OK on success, nonzero on error.
- */
-static inline blk_status_t blk_crypto_insert_cloned_request(struct request *rq)
-{
-
-	if (blk_crypto_rq_is_encrypted(rq))
-		return blk_crypto_rq_get_keyslot(rq);
-	return BLK_STS_OK;
-}
-
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK
 
 int blk_crypto_fallback_start_using_mode(enum blk_crypto_mode_num mode_num);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 49825538d932..5e819de2f5e7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3049,7 +3049,7 @@ blk_status_t blk_insert_cloned_request(struct request *rq)
 	if (q->disk && should_fail_request(q->disk->part0, blk_rq_bytes(rq)))
 		return BLK_STS_IOERR;
 
-	if (blk_crypto_insert_cloned_request(rq))
+	if (blk_crypto_rq_get_keyslot(rq))
 		return BLK_STS_IOERR;
 
 	blk_account_io_start(rq);
-- 
2.39.2

