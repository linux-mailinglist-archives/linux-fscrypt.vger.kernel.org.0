Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47367433DD
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Jun 2023 07:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjF3FD6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 30 Jun 2023 01:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjF3FD5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 30 Jun 2023 01:03:57 -0400
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E508B10E7;
        Thu, 29 Jun 2023 22:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; s=LIY0OQ3MUMW6182UNI14; d=nsr.re.kr; t=1688101300; c=relaxed/relaxed; h=date:from:message-id:mime-version:subject:to; bh=EApqQ6uoe2J8t6KKqJtI9FKl5fra2p1B54wZxyPswJ0=; b=xSH5j5ahwido9aaVN96GZPfzCPT+hCF4/CCUNEs88C5VFB74pwedHWed5E8NR98Nx5fhGJwiVVX+CHibFkNF2HT+S0VYviqJg8hXYgr3PYFLbB4uu/J2wCHFujX2axbH5gSQXYnwOr6hVhR087v+gUrbrH9lXfutcxAqyoDfEBHAomhYcDipcd253n+eK+ROXFD9bksBmqLydTdDkeHQOG+PgblJlMfeWrdT12G1pQD8zasKTFjQMAqcpIfM8Xg+2OwRUHcg5L5Xt4FDXkyW9DeQathASS2NY8S1maYERRrp3Fv2gksLp+QdpWHbIzpYlS+e7kVAopmLoSLqhBmjag==
Received: from 210.104.33.70 (nsr.re.kr)
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
        by mail.nsr.re.kr with SMTP; Fri, 30 Jun 2023 14:01:25 +0900
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 128;
          Fri, 30 Jun 2023 14:03:31 +0900 (KST)
From:   Dongsoo Lee <letrhee@nsr.re.kr>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dongsoo Lee <letrhee@nsr.re.kr>
Subject: [PATCH v4 3/4] blk-crypto: Add LEA-256-XTS blk-crypto support
Date:   Fri, 30 Jun 2023 14:03:22 +0900
Message-Id: <20230630050323.984216-4-letrhee@nsr.re.kr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230630050323.984216-1-letrhee@nsr.re.kr>
References: <20230630050323.984216-1-letrhee@nsr.re.kr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add LEA-256-XTS blk-crypto support

LEA is a 128-bit block cipher developed by South Korea.

LEA is a Korean national standard (KS X 3246) and included in the
ISO/IEC 29192-2:2019 standard (Information security - Lightweight
cryptography - Part 2: Block ciphers).

Enable the LEA to be used in block inline encryption. This can be
used via blk-crypto-fallback, when using the "inlinecrypt" mount
option in fscrypt.

Signed-off-by: Dongsoo Lee <letrhee@nsr.re.kr>
---
 block/blk-crypto.c         | 6 ++++++
 include/linux/blk-crypto.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 4d760b092deb..b847706bbc59 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -43,6 +43,12 @@ const struct blk_crypto_mode blk_crypto_modes[] = {
 		.keysize = 32,
 		.ivsize = 16,
 	},
+	[BLK_ENCRYPTION_MODE_LEA_256_XTS] = {
+		.name = "LEA-256-XTS",
+		.cipher_str = "xts(lea)",
+		.keysize = 64,
+		.ivsize = 16,
+	},
 };
 
 /*
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 5e5822c18ee4..b6bf2a5c58ed 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -14,6 +14,7 @@ enum blk_crypto_mode_num {
 	BLK_ENCRYPTION_MODE_AES_128_CBC_ESSIV,
 	BLK_ENCRYPTION_MODE_ADIANTUM,
 	BLK_ENCRYPTION_MODE_SM4_XTS,
+	BLK_ENCRYPTION_MODE_LEA_256_XTS,
 	BLK_ENCRYPTION_MODE_MAX,
 };
 
-- 
2.34.1
