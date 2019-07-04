Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F395FCEF
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Jul 2019 20:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfGDSaw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Jul 2019 14:30:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43609 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfGDSaw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Jul 2019 14:30:52 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so7490761wru.10
        for <linux-fscrypt@vger.kernel.org>; Thu, 04 Jul 2019 11:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q2LNtGCmE5IlgP+bQlpDKN5FkREmAvC3oHX/3jKNrRY=;
        b=AWw0X0ldg6U0xP9z9EIXN7pc0fp+5EvjK30XzbXoxs0EeTO0y5XABAeisWIdXREF2U
         s/Ja7Bt67iGxB1hb3QkS5sDE8FdLB83mKoVxX3839omjjETHgxjlgqQHezmEFbSCbDin
         vBzof1dEhE0DdRdjf4IkgPswj6SG4Z+pFPMa/RnDjx7JwXuuDnvuduqZ+gCgws210EGx
         ASjM+J6SRXvlmaxVMn/DHjB++J6cU1VSvgbwUazKIWlPaGFpjPkWOawsr8XAATsxSSpy
         SsEwXGg1jTlmCv3YHoPXXkKHlzMw3yM2gP2BSf3kY73pijSgQDyCIDVrwOBV4+BAiCPj
         GQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q2LNtGCmE5IlgP+bQlpDKN5FkREmAvC3oHX/3jKNrRY=;
        b=UWbfPOrkqibta1WCQhingZdDfFl79w+PLCLXvFGG2ovHp/lnOzMcnyZMRNdAkL8CzW
         NlP0SlQv9twDIjP8K3mOwEhWP9hLvm6+7KqBIkED6LhfA7mEzKFOwwMzFGUNJw/L/vfT
         O1r99VYXGYfXkG3lSgPdbw2zzYvl1JLf+NBXFm5TTwY35iLCKFuKmDBmkk+moouYJ7QV
         SIzuv9MxNW3B8rvebdxiKz+s/PnOAWduoghTjY5SVnWVY3QqlGDtgPvHooLwvwtiIdp0
         cvou0Ni5A42055Ac4nKNtxeEwujGYje+miCLJ5E8CNxNb6FKPqYA/1Eb+iv4VZ+mXrcW
         he9Q==
X-Gm-Message-State: APjAAAUQh2A8FtVruJyknXfM2nOUzGEPQ5SNzZqPtuFn4oR6hx+t5jse
        Nt4Ugy+uO7HEZcGLRrUNO6s74g==
X-Google-Smtp-Source: APXvYqytPc5jdSNLJ9V0tw1rQghVl5C+oRle/fcBMLN0f/E6Tk3hHy9XRVLksXKPd8W7SpVTOQr26A==
X-Received: by 2002:a5d:5752:: with SMTP id q18mr29699813wrw.337.1562265050057;
        Thu, 04 Jul 2019 11:30:50 -0700 (PDT)
Received: from e111045-lin.arm.com (93-143-123-179.adsl.net.t-com.hr. [93.143.123.179])
        by smtp.gmail.com with ESMTPSA id o6sm11114695wra.27.2019.07.04.11.30.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 11:30:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v8 6/7] crypto: arm64/aes-cts-cbc - factor out CBC en/decryption of a walk
Date:   Thu,  4 Jul 2019 20:30:16 +0200
Message-Id: <20190704183017.31570-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190704183017.31570-1-ard.biesheuvel@linaro.org>
References: <20190704183017.31570-1-ard.biesheuvel@linaro.org>
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
index f0ceb545bd1e..11b85ce02d7a 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -185,46 +185,64 @@ static int ecb_decrypt(struct skcipher_request *req)
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
@@ -250,22 +268,12 @@ static int cts_cbc_encrypt(struct skcipher_request *req)
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
 
@@ -315,22 +323,12 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
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

