Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670CE62754B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 14 Nov 2022 05:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235835AbiKNEaD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 13 Nov 2022 23:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbiKNE36 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 13 Nov 2022 23:29:58 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D967064C0;
        Sun, 13 Nov 2022 20:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6JM5AtUvtab6jr3UlF0Ij3MT9h6lxlDNx6apodTig34=; b=Uz7aB03R6l9GBb6FTppz3BKEvM
        a4azUgN/3iunQcwmbkX4w9USdROqhmKwTj/+Ps9/4Tk+Ol4J2/izJSGh3FvjHw+9DqnRD+O8JcWjm
        Ff5Z2y5pNd+PyCrh3R3FMDYDkmz8ep9+thLlKULSq8FzLqo8x9WId9S6dJBE5eo5/o3olCoIg0Dex
        0QqWp0eo4V4fPoGGqDEEeasForjGrV7licGOCcq1C8i/9EshLaAjwDEvvOakO5jfEMXM3pxO7M0NF
        W48FvWdW5GjYcbXQmTSlx2fIK81ilzNDq6CeUN/KcUe7Qu5jmoUfFmshZv8oszy9XRvLX1sRomvFq
        lNGku6rg==;
Received: from [2001:4bb8:191:2606:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ouR6Y-00FvUd-2s; Mon, 14 Nov 2022 04:29:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH 3/3] blk-crypto: move internal only declarations to blk-crypto-internal.h
Date:   Mon, 14 Nov 2022 05:29:44 +0100
Message-Id: <20221114042944.1009870-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221114042944.1009870-1-hch@lst.de>
References: <20221114042944.1009870-1-hch@lst.de>
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

 blk_crypto_get_keyslot, blk_crypto_put_keyslot, __blk_crypto_evict_key
and __blk_crypto_cfg_supported are only used internally by the
blk-crypto code, so move the out of blk-crypto-profile.h, which is
included by drivers that supply blk-crypto functionality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-crypto-internal.h        | 12 ++++++++++++
 include/linux/blk-crypto-profile.h | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index e6818ffaddbf8..d31fa80454e49 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -65,6 +65,18 @@ static inline bool blk_crypto_rq_is_encrypted(struct request *rq)
 	return rq->crypt_ctx;
 }
 
+blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
+				    const struct blk_crypto_key *key,
+				    struct blk_crypto_keyslot **slot_ptr);
+
+void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot);
+
+int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
+			   const struct blk_crypto_key *key);
+
+bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
+				const struct blk_crypto_config *cfg);
+
 #else /* CONFIG_BLK_INLINE_ENCRYPTION */
 
 static inline int blk_crypto_sysfs_register(struct request_queue *q)
diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
index bbab65bd54288..e6802b69cdd64 100644
--- a/include/linux/blk-crypto-profile.h
+++ b/include/linux/blk-crypto-profile.h
@@ -138,18 +138,6 @@ int devm_blk_crypto_profile_init(struct device *dev,
 
 unsigned int blk_crypto_keyslot_index(struct blk_crypto_keyslot *slot);
 
-blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
-				    const struct blk_crypto_key *key,
-				    struct blk_crypto_keyslot **slot_ptr);
-
-void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot);
-
-bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
-				const struct blk_crypto_config *cfg);
-
-int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
-			   const struct blk_crypto_key *key);
-
 void blk_crypto_reprogram_all_keys(struct blk_crypto_profile *profile);
 
 void blk_crypto_profile_destroy(struct blk_crypto_profile *profile);
-- 
2.30.2

