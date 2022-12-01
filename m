Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F368163F0F7
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Dec 2022 13:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiLAM6a (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 1 Dec 2022 07:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiLAM63 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 1 Dec 2022 07:58:29 -0500
Received: from out30-6.freemail.mail.aliyun.com (out30-6.freemail.mail.aliyun.com [115.124.30.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5A755C8B;
        Thu,  1 Dec 2022 04:58:27 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=tianjia.zhang@linux.alibaba.com;NM=0;PH=DS;RN=12;SR=0;TI=SMTPD_---0VW8v8o9_1669899502;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VW8v8o9_1669899502)
          by smtp.aliyun-inc.com;
          Thu, 01 Dec 2022 20:58:23 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v4 1/2] blk-crypto: Add support for SM4-XTS blk crypto mode
Date:   Thu,  1 Dec 2022 20:58:18 +0800
Message-Id: <20221201125819.36932-2-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20221201125819.36932-1-tianjia.zhang@linux.alibaba.com>
References: <20221201125819.36932-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

SM4 is a symmetric cipher algorithm widely used in China. The SM4-XTS
variant is used to encrypt length-preserving data. This is the
mandatory algorithm in some special scenarios.

Enable the algorithm in block inline encryption, this is needed for the
inlinecrypt mount option to be supported via blk-crypto-fallback, as it
is for the other fscrypt modes.

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

