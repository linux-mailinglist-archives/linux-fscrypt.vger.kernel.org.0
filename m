Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A5C61F665
	for <lists+linux-fscrypt@lfdr.de>; Mon,  7 Nov 2022 15:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiKGOmq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Nov 2022 09:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiKGOmo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Nov 2022 09:42:44 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF46A1A206;
        Mon,  7 Nov 2022 06:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4cOhfImWA5E57yLmv+kuoHUhhtpTgGnwnPUezDCJTlQ=; b=0RQLhjgnP48YMOWs+b1HBJsjSQ
        utfX5TYICJxhzKdwQLHV5iWGhq/6RYiRrA1nwkiJUgdKk2X1SOiEedPqWAreHN6qD3LuWGykqzmdW
        o9JfgDOOTpmtSTvmAu1ea/odiy9jmLyZPSXJUndL9PceAvhwgoin9jUjDEpjrtQzyXnCrhO2+GgAM
        D6j0MrkDVgEMxRCFf39nljqLzAjHdV+W4ryEVxVdkmNDfyFNehz0ptEBsG97PF4OWEQsOm26JgOnv
        dbNsgMLkX0HYclKS9K+WvacsgDAGbKZxm6MQamZH6tOJSd7paVqSqwPh2D92T8tII1a2AsiVVoxGf
        o/8J0DUg==;
Received: from [2001:4bb8:191:2450:bd6a:c86c:b287:8b99] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1os3Ki-00FJc7-5v; Mon, 07 Nov 2022 14:42:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH 3/3] blk-crypto: move __blk_crypto_cfg_supported to blk-crypto-internal.h
Date:   Mon,  7 Nov 2022 15:42:29 +0100
Message-Id: <20221107144229.1547370-4-hch@lst.de>
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

__blk_crypto_cfg_supported is only used internally by the blk-crypto
code now, so move it out of the public header.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-crypto-internal.h        | 3 +++
 include/linux/blk-crypto-profile.h | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index e6818ffaddbf8..c587b3e1886c9 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -19,6 +19,9 @@ struct blk_crypto_mode {
 
 extern const struct blk_crypto_mode blk_crypto_modes[];
 
+bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
+				const struct blk_crypto_config *cfg);
+
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 
 int blk_crypto_sysfs_register(struct request_queue *q);
diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
index bbab65bd54288..e990ec9b32aa4 100644
--- a/include/linux/blk-crypto-profile.h
+++ b/include/linux/blk-crypto-profile.h
@@ -144,9 +144,6 @@ blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
 
 void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot);
 
-bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
-				const struct blk_crypto_config *cfg);
-
 int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
 			   const struct blk_crypto_key *key);
 
-- 
2.30.2

