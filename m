Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25ABF6335A7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Nov 2022 08:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiKVHGn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 22 Nov 2022 02:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbiKVHGn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 22 Nov 2022 02:06:43 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C3A2CE3F;
        Mon, 21 Nov 2022 23:06:38 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VVR5qpT_1669100795;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VVR5qpT_1669100795)
          by smtp.aliyun-inc.com;
          Tue, 22 Nov 2022 15:06:36 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v2 1/2] blk-crypto: Add support for SM4-XTS blk crypto mode
Date:   Tue, 22 Nov 2022 15:06:31 +0800
Message-Id: <20221122070632.21910-2-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20221122070632.21910-1-tianjia.zhang@linux.alibaba.com>
References: <20221122070632.21910-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

SM4 is a symmetric algorithm widely used in China, and SM4-XTS is also
used to encrypt length-preserving data, this patch enables the use of
SM4-XTS algorithm in block inline encryption, and provides support for
fscrypt.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 block/blk-crypto.c         | 6 ++++++
 include/linux/blk-crypto.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index a496aaef85ba..e44709fc6a08 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -36,6 +36,12 @@ const struct blk_crypto_mode blk_crypto_modes[] = {
 		.keysize = 32,
 		.ivsize = 32,
 	},
+	[BLK_ENCRYPTION_MODE_SM4_XTS] = {
+		.name = "SM4-XTS",
+		.cipher_str = "xts(sm4)",
+		.keysize = 32,
+		.ivsize = 16,
+	},
 };
 
 /*
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 69b24fe92cbf..26b1b71c3091 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -13,6 +13,7 @@ enum blk_crypto_mode_num {
 	BLK_ENCRYPTION_MODE_AES_256_XTS,
 	BLK_ENCRYPTION_MODE_AES_128_CBC_ESSIV,
 	BLK_ENCRYPTION_MODE_ADIANTUM,
+	BLK_ENCRYPTION_MODE_SM4_XTS,
 	BLK_ENCRYPTION_MODE_MAX,
 };
 
-- 
2.24.3 (Apple Git-128)

