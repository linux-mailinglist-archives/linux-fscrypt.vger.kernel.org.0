Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A376A91A8
	for <lists+linux-fscrypt@lfdr.de>; Fri,  3 Mar 2023 08:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjCCHXg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 3 Mar 2023 02:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjCCHXd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 3 Mar 2023 02:23:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0945015C86;
        Thu,  2 Mar 2023 23:23:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE12EB816A1;
        Fri,  3 Mar 2023 07:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3756FC4339C;
        Fri,  3 Mar 2023 07:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677828209;
        bh=S96iUPLNp4rT3Ve3r72wqD24rjqGWLopbjKW6pRn4zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McQVsF3pfbbSMz/bG0gkWr+ikJD06/SPczhUfwC9RM/sYz8cVjp9caqrRE8/yKsPA
         bYJqU4aJ/oLzEkLkHiDz6q9dpuI9PQvH2aI0DUa7HyzGmTlddjwBwk1T8Yu3mWt8qd
         8xmVreTDatA4LOzATgUK23G7DKYb05sC2+rQ5q+9ja5PXzN8W2NC/MGoFLIK+7PqRf
         ET3BdGc9JeYbJHKi9GoH1Wdwhi1hPyVpfxhogsQhVwMkLXvDGv7u/DeSq8Q13iF53M
         Kju8By7EaS9mJ6b7N9YVKo9348bMOGqiX1hRzhhk+j9eAFavRzKSxKHyfEwrxZvBmS
         NdI276eODSPTA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Subject: [PATCH 3/3] blk-crypto: remove blk_crypto_insert_cloned_request()
Date:   Thu,  2 Mar 2023 23:19:59 -0800
Message-Id: <20230303071959.144604-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303071959.144604-1-ebiggers@kernel.org>
References: <20230303071959.144604-1-ebiggers@kernel.org>
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
index f9bf18ea65093..90b733422ed46 100644
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
index 73609902349b6..0f55e5b4bbbf2 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -195,21 +195,6 @@ static inline int blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
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
index 738e81f518227..61ed699e89d53 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3048,7 +3048,7 @@ blk_status_t blk_insert_cloned_request(struct request *rq)
 	if (q->disk && should_fail_request(q->disk->part0, blk_rq_bytes(rq)))
 		return BLK_STS_IOERR;
 
-	if (blk_crypto_insert_cloned_request(rq))
+	if (blk_crypto_rq_get_keyslot(rq))
 		return BLK_STS_IOERR;
 
 	blk_account_io_start(rq);
-- 
2.39.2

