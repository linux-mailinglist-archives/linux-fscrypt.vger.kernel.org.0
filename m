Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83C573DAAF
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Jun 2023 11:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjFZJBh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Jun 2023 05:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjFZJBJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Jun 2023 05:01:09 -0400
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C61446A1
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Jun 2023 01:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; s=LIY0OQ3MUMW6182UNI14; d=nsr.re.kr; t=1687769644; c=relaxed/relaxed; h=date:from:message-id:mime-version:subject:to; bh=EApqQ6uoe2J8t6KKqJtI9FKl5fra2p1B54wZxyPswJ0=; b=XX5ekCN9Ui7oKu5VoMqCffSg7ZuNEumHJwabJ/pkMzjSBtVupbnwNK4ZwANdl5Qkioj0kxosg4M/4ETROubW/nKyvmB0znV4NQpu+VHmo2ht6rT20/aOYc0NYQH2dw2kZHmlqcvXMV5JhH2c5huJNDadCkKm/pDTNo9XBsFmoiPEduK4YkWFzEfj3M/1Bh4GwPalKjBkfT0nWD2eLrE0x3RTGLPurT0cqxVhS7t+x8ZIYZlgxZ/zBTr53mB4wbPIncdXjQArTvH+IkZDFOCiSx1JG/5vx8OSmMux74f3/8/Gz4UFof8V6KCR2fHdkWluxnsJNamPzVihhx2RUCsThw==
Received: from 210.104.33.70 (nsr.re.kr)
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
        by mail.nsr.re.kr with SMTP; Mon, 26 Jun 2023 17:45:39 +0900
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 334;
          Mon, 26 Jun 2023 17:47:46 +0900 (KST)
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
Subject: [PATCH v3 3/4] blk-crypto: Add LEA-256-XTS blk-crypto support
Date:   Mon, 26 Jun 2023 17:47:02 +0900
Message-Id: <20230626084703.907331-4-letrhee@nsr.re.kr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230626084703.907331-1-letrhee@nsr.re.kr>
References: <20230626084703.907331-1-letrhee@nsr.re.kr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
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
