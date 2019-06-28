Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0452359EB5
	for <lists+linux-fscrypt@lfdr.de>; Fri, 28 Jun 2019 17:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfF1PVd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 28 Jun 2019 11:21:33 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54672 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfF1PVb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 28 Jun 2019 11:21:31 -0400
Received: by mail-wm1-f67.google.com with SMTP id g135so9490951wme.4
        for <linux-fscrypt@vger.kernel.org>; Fri, 28 Jun 2019 08:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=20kar+4njHVQnk3Y1QM9bnnvyr2Y5wWcvH/MhU3+4M0=;
        b=hPvxtK50qH2DSJ4PmUnfo9L33cGMVuH8GiL90PdaAVvf0hTKVnsgrO4JtozOqmFr6S
         FkyaF7kl8TkSdEdflec16clg+W6faORc9k1Q7EUlj4compTlYyxKO996+0AUscqlJ2La
         0u++EbJ12cQJUx2ZrkpwtUua1cd4uiMxytttZc5DpIUvhu6fAS/aTNNTUwQRucxWZYKF
         5ajKb8v3hqJBdIkq6Ey5RLx6F0r2AS3EZzYjdPp2ob0E4ye8k+l9Ziozx7p/v+PYsqnJ
         GqNrM1wiq1EV6pNJElYJsBMlXfdtuu4UFJIhBz2StQC5PTNi1IgfgL6KySIqw+G9SjeN
         RQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=20kar+4njHVQnk3Y1QM9bnnvyr2Y5wWcvH/MhU3+4M0=;
        b=DyZT/g26sxjsqmegLSPjdA06LeOO2pL004P4DgCek03E/StIOYi+sU0xOhsekxxwrD
         sj2tAWIuPRhBk8E3tm2CWx76kT/FyNivHZwVPcaGKtRiIM4NXvYCzpDSIrx0hcEp3jqo
         gtWFmF65zGCTm9KNBiUs9IZEnQTxw6yV5TahFIBuZLFserkTkS+6dzfne4QLwaWs6j9k
         NPGsHtYAyNGhNxQeTzvE6GvUr1fqN31PiVLCuq43WZUoekQT07zIbgkwYPuSRo4V0Ya9
         hGizbg3banyLYP6vV04ZYZa72GYSR9mUeBJNXtBQGaha+OLCTFNYLw/nupY5E4wHeIfj
         6Zlw==
X-Gm-Message-State: APjAAAXbkRnGjaPkXmxJogq99UQVQCtH8kOx5S7+j8XzvyyDHO7ZjEpT
        i2p/584HW8qF3DZDu7q+tq+G1w==
X-Google-Smtp-Source: APXvYqwltc9GpugFTW62G5hWAIiDrwhxe/GNIufdABs2RzRap9shASPS0icMwH2UQE+fDxYv0F+2Kg==
X-Received: by 2002:a1c:c549:: with SMTP id v70mr7466352wmf.135.1561735288700;
        Fri, 28 Jun 2019 08:21:28 -0700 (PDT)
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net. [91.167.84.221])
        by smtp.gmail.com with ESMTPSA id u13sm2734319wrq.62.2019.06.28.08.21.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 08:21:28 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v6 6/7] crypto: arm64/aes-cts-cbc - factor out CBC en/decryption of a walk
Date:   Fri, 28 Jun 2019 17:21:11 +0200
Message-Id: <20190628152112.914-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628152112.914-1-ard.biesheuvel@linaro.org>
References: <20190628152112.914-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.20.1

