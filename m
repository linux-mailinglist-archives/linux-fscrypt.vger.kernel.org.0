Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 005CD8F48F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 21:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732065AbfHOT3W (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Aug 2019 15:29:22 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40418 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732131AbfHOT3W (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Aug 2019 15:29:22 -0400
Received: by mail-wr1-f65.google.com with SMTP id c3so3186440wrd.7
        for <linux-fscrypt@vger.kernel.org>; Thu, 15 Aug 2019 12:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=huVoFUpMc5dzWwrmJm9Qwvn6MCUViGlDp2QJ3557fZk=;
        b=noy61VfHR7U2BgfdW30pqSNYezEMOuuESP7Kxt2spwIyqZclbrVt9uq/fnWCA/55Tt
         0lYC7xcVVxwpwPaDm3iZlXreSOgQH4g2HroXrWABayTOOld+C/YNV2RxNATK3TbjO4BH
         DK7hrEqLdVOHt5kRdB8ae9zmJFbgttdLBJX/oilIiW9DmEyFyETFNZcjAnbztc7kEwcc
         JCnD2EP01sCpQJ0udZjkIapv/e+QkwO4u8xFnOAORqVMvnzofA36yHoD/c8wo8csmHDL
         rbH+FGMMgW9QwBwl6uURBhwHPectNJTWNSdGO5MdjX48I3gLO6q0gL9FbGwdmiVujIGU
         OIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=huVoFUpMc5dzWwrmJm9Qwvn6MCUViGlDp2QJ3557fZk=;
        b=ZG1fW3m3VAl00YxiycY0BF9tZMbladLugTQx7TGt/j8SRgFTp95Dcsqqa6smKELiTg
         OZtvnlEutCFP71CmrvY4cTZ4VyScNxtRSwkL1o3xad84icI26J3ePexnr3WEX2dwb4YN
         mdW7VgdLP49/mK9IQPOlna0vCEd21p9DeVo2IVGotw+Y7w8pn+azjLdIOTodaZGaQ+Zg
         gYs4o1zuSLAXKW+k4Y90y5KD5d7+2ZV2tZ8TNVhwoBrVQFjU6PKAMpdgNcw+Q965wjX/
         vlCD5CblgdDHaPPADlRvcAZztpKVTx1aVkSJVLS5I9avBVKGXEIZLquyD9lb9ih/ibfg
         d2tg==
X-Gm-Message-State: APjAAAV/+g7YmYsnX2eP03wFSMhPTmW3HMk/dLR0TzXnlwNrmF9UdvzY
        2SFLzhlbJ5mgdINm6WknUu1fMA==
X-Google-Smtp-Source: APXvYqyxxP92ZNffa1tenVrrYKVzTdqCcngjq2SfLrGaHgkvzoJ8IGTCxq1wAiw2sJzRBVnTO3NjwQ==
X-Received: by 2002:adf:eb0f:: with SMTP id s15mr6966623wrn.324.1565897359259;
        Thu, 15 Aug 2019 12:29:19 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id h9sm2949063wrt.53.2019.08.15.12.29.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 12:29:18 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v12 3/4] crypto: arm64/aes-cts-cbc - factor out CBC en/decryption of a walk
Date:   Thu, 15 Aug 2019 22:28:57 +0300
Message-Id: <20190815192858.28125-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
References: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The plain CBC driver and the CTS one share some code that iterates over
a scatterwalk and invokes the CBC asm code to do the processing. The
upcoming ESSIV/CBC mode will clone that pattern for the third time, so
let's factor it out first.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c | 82 ++++++++++----------
 1 file changed, 40 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 55d6d4838708..23abf335f1ee 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -186,46 +186,64 @@ static int ecb_decrypt(struct skcipher_request *req)
 	return err;
 }
 
-static int cbc_encrypt(struct skcipher_request *req)
+static int cbc_encrypt_walk(struct skcipher_request *req,
+			    struct skcipher_walk *walk)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err, rounds = 6 + ctx->key_length / 4;
-	struct skcipher_walk walk;
+	int err = 0, rounds = 6 + ctx->key_length / 4;
 	unsigned int blocks;
 
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+	while ((blocks = (walk->nbytes / AES_BLOCK_SIZE))) {
 		kernel_neon_begin();
-		aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				ctx->key_enc, rounds, blocks, walk.iv);
+		aes_cbc_encrypt(walk->dst.virt.addr, walk->src.virt.addr,
+				ctx->key_enc, rounds, blocks, walk->iv);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(walk, walk->nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
 
-static int cbc_decrypt(struct skcipher_request *req)
+static int cbc_encrypt(struct skcipher_request *req)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int err, rounds = 6 + ctx->key_length / 4;
 	struct skcipher_walk walk;
-	unsigned int blocks;
+	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
+	return cbc_encrypt_walk(req, &walk);
+}
 
-	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+static int cbc_decrypt_walk(struct skcipher_request *req,
+			    struct skcipher_walk *walk)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err = 0, rounds = 6 + ctx->key_length / 4;
+	unsigned int blocks;
+
+	while ((blocks = (walk->nbytes / AES_BLOCK_SIZE))) {
 		kernel_neon_begin();
-		aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				ctx->key_dec, rounds, blocks, walk.iv);
+		aes_cbc_decrypt(walk->dst.virt.addr, walk->src.virt.addr,
+				ctx->key_dec, rounds, blocks, walk->iv);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(walk, walk->nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
 
+static int cbc_decrypt(struct skcipher_request *req)
+{
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
+	return cbc_decrypt_walk(req, &walk);
+}
+
 static int cts_cbc_init_tfm(struct crypto_skcipher *tfm)
 {
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct cts_cbc_req_ctx));
@@ -251,22 +269,12 @@ static int cts_cbc_encrypt(struct skcipher_request *req)
 	}
 
 	if (cbc_blocks > 0) {
-		unsigned int blocks;
-
 		skcipher_request_set_crypt(&rctx->subreq, req->src, req->dst,
 					   cbc_blocks * AES_BLOCK_SIZE,
 					   req->iv);
 
-		err = skcipher_walk_virt(&walk, &rctx->subreq, false);
-
-		while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
-			kernel_neon_begin();
-			aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-					ctx->key_enc, rounds, blocks, walk.iv);
-			kernel_neon_end();
-			err = skcipher_walk_done(&walk,
-						 walk.nbytes % AES_BLOCK_SIZE);
-		}
+		err = skcipher_walk_virt(&walk, &rctx->subreq, false) ?:
+		      cbc_encrypt_walk(&rctx->subreq, &walk);
 		if (err)
 			return err;
 
@@ -316,22 +324,12 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	}
 
 	if (cbc_blocks > 0) {
-		unsigned int blocks;
-
 		skcipher_request_set_crypt(&rctx->subreq, req->src, req->dst,
 					   cbc_blocks * AES_BLOCK_SIZE,
 					   req->iv);
 
-		err = skcipher_walk_virt(&walk, &rctx->subreq, false);
-
-		while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
-			kernel_neon_begin();
-			aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-					ctx->key_dec, rounds, blocks, walk.iv);
-			kernel_neon_end();
-			err = skcipher_walk_done(&walk,
-						 walk.nbytes % AES_BLOCK_SIZE);
-		}
+		err = skcipher_walk_virt(&walk, &rctx->subreq, false) ?:
+		      cbc_decrypt_walk(&rctx->subreq, &walk);
 		if (err)
 			return err;
 
-- 
2.17.1

