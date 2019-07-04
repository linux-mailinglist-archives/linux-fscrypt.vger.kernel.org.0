Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B74A15FCF4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Jul 2019 20:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfGDSay (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Jul 2019 14:30:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35607 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfGDSay (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Jul 2019 14:30:54 -0400
Received: by mail-wm1-f65.google.com with SMTP id c6so7044900wml.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 04 Jul 2019 11:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iKucLOLDdGOOuekL4vlJXDesrsnQZhL0jiwM8r6CtNY=;
        b=W0AYIE1D6hU+rKKJU6Q37A/1RkGYUx4J+DtfpanBvXZP3OcwiAnVdPj7aA8QkM2Zff
         0YoOEoU33FfSM5SbQBXQw+hrynfqkfjtNS2QKQO/t74KjQZLygEbB2sfeGRhfOVMeRyT
         cb8yEQoboSlkZiyu3hmEPbTu+lpbkaHr/xLIoXgzXZBUlozBBpB9H4EA6tdAYzrXrOyZ
         CE3eWCswW40k0i1KD/fy+tUEybL4mp0/a7RLux1LvhZfRxpEv5+IeGWRUqHRPef4+Ou1
         pUAAhbsP3cXKwH+cUPVD5QMExm3GPWmuTI8nEaLYFTHUc71IEOJKBS2ULp0abnpwimDR
         IEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iKucLOLDdGOOuekL4vlJXDesrsnQZhL0jiwM8r6CtNY=;
        b=PkFVPD+4miLSoYayiPqXaQf1Hk2XK9e8EwBw8PLgZAZt+FNpdIvBpfjt8bBbMeeQ8X
         T3lZh0hZT7dg1P+pIq+VEfMi3BAbZScnGyiKerx5I90eVjUYx4H2XGXNZ0jPwUTCeOyj
         U7qtU/nRMAWSxvvG9IPOnz0eukEnsP8sHbwz2dHYxdiU/BBNDRZ439J9LForxqG8WdLY
         N5x7tX+8g+XDrQAp2F0SnN/hwCkLRlbVPM9XS8Uj5lwTXnH7lfQ5EvdyBu7QWcC4rwRX
         d6JVw8LYeBYBvBdl4dbRkxKTVOJ014/x2IGvMOlCQw+TpyC7huxW+Uq3y7is9kom26rt
         KOgw==
X-Gm-Message-State: APjAAAWQLW1sIXgDVfBi5uHmmHx6wcbVLnS1HVI2qef+WcGgfPwIOOwk
        qkA2cK7g9cmR99tJ65SL21LPqg==
X-Google-Smtp-Source: APXvYqzQIz1uobghFjaaaY94B3UdV8/efTpsX6rCdPNfcwsQzSDO+IkkDk8ppuFrNviyb43t/7nuEA==
X-Received: by 2002:a1c:cb0c:: with SMTP id b12mr548190wmg.93.1562265051701;
        Thu, 04 Jul 2019 11:30:51 -0700 (PDT)
Received: from e111045-lin.arm.com (93-143-123-179.adsl.net.t-com.hr. [93.143.123.179])
        by smtp.gmail.com with ESMTPSA id o6sm11114695wra.27.2019.07.04.11.30.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 11:30:50 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v8 7/7] crypto: arm64/aes - implement accelerated ESSIV/CBC mode
Date:   Thu,  4 Jul 2019 20:30:17 +0200
Message-Id: <20190704183017.31570-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190704183017.31570-1-ard.biesheuvel@linaro.org>
References: <20190704183017.31570-1-ard.biesheuvel@linaro.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add an accelerated version of the 'essiv(cbc(aes),aes,sha256'
skcipher, which is used by fscrypt or dm-crypt on systems where
CBC mode is signficantly more performant than XTS mode (e.g., when
using a h/w accelerator which supports the former but not the latter)
This avoids a separate call into the AES cipher for every invocation.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c  | 123 ++++++++++++++++++++
 arch/arm64/crypto/aes-modes.S |  29 ++++-
 2 files changed, 151 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 11b85ce02d7a..7097739e7cd9 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -12,6 +12,7 @@
 #include <asm/hwcap.h>
 #include <asm/simd.h>
 #include <crypto/aes.h>
+#include <crypto/sha.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
@@ -34,6 +35,8 @@
 #define aes_cbc_decrypt		ce_aes_cbc_decrypt
 #define aes_cbc_cts_encrypt	ce_aes_cbc_cts_encrypt
 #define aes_cbc_cts_decrypt	ce_aes_cbc_cts_decrypt
+#define aes_essiv_cbc_encrypt	ce_aes_essiv_cbc_encrypt
+#define aes_essiv_cbc_decrypt	ce_aes_essiv_cbc_decrypt
 #define aes_ctr_encrypt		ce_aes_ctr_encrypt
 #define aes_xts_encrypt		ce_aes_xts_encrypt
 #define aes_xts_decrypt		ce_aes_xts_decrypt
@@ -50,6 +53,8 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #define aes_cbc_decrypt		neon_aes_cbc_decrypt
 #define aes_cbc_cts_encrypt	neon_aes_cbc_cts_encrypt
 #define aes_cbc_cts_decrypt	neon_aes_cbc_cts_decrypt
+#define aes_essiv_cbc_encrypt	neon_aes_essiv_cbc_encrypt
+#define aes_essiv_cbc_decrypt	neon_aes_essiv_cbc_decrypt
 #define aes_ctr_encrypt		neon_aes_ctr_encrypt
 #define aes_xts_encrypt		neon_aes_xts_encrypt
 #define aes_xts_decrypt		neon_aes_xts_decrypt
@@ -93,6 +98,13 @@ asmlinkage void aes_xts_decrypt(u8 out[], u8 const in[], u32 const rk1[],
 				int rounds, int blocks, u32 const rk2[], u8 iv[],
 				int first);
 
+asmlinkage void aes_essiv_cbc_encrypt(u8 out[], u8 const in[], u32 const rk1[],
+				      int rounds, int blocks, u8 iv[],
+				      u32 const rk2[]);
+asmlinkage void aes_essiv_cbc_decrypt(u8 out[], u8 const in[], u32 const rk1[],
+				      int rounds, int blocks, u8 iv[],
+				      u32 const rk2[]);
+
 asmlinkage void aes_mac_update(u8 const in[], u32 const rk[], int rounds,
 			       int blocks, u8 dg[], int enc_before,
 			       int enc_after);
@@ -108,6 +120,12 @@ struct crypto_aes_xts_ctx {
 	struct crypto_aes_ctx __aligned(8) key2;
 };
 
+struct crypto_aes_essiv_cbc_ctx {
+	struct crypto_aes_ctx key1;
+	struct crypto_aes_ctx __aligned(8) key2;
+	struct crypto_shash *hash;
+};
+
 struct mac_tfm_ctx {
 	struct crypto_aes_ctx key;
 	u8 __aligned(8) consts[];
@@ -145,6 +163,31 @@ static int xts_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 	return -EINVAL;
 }
 
+static int essiv_cbc_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
+			     unsigned int key_len)
+{
+	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	SHASH_DESC_ON_STACK(desc, ctx->hash);
+	u8 digest[SHA256_DIGEST_SIZE];
+	int ret;
+
+	ret = aes_expandkey(&ctx->key1, in_key, key_len);
+	if (ret)
+		goto out;
+
+	desc->tfm = ctx->hash;
+	crypto_shash_digest(desc, in_key, key_len, digest);
+
+	ret = aes_expandkey(&ctx->key2, digest, sizeof(digest));
+	if (ret)
+		goto out;
+
+	return 0;
+out:
+	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	return -EINVAL;
+}
+
 static int ecb_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -359,6 +402,68 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	return skcipher_walk_done(&walk, 0);
 }
 
+static int essiv_cbc_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	ctx->hash = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(ctx->hash))
+		return PTR_ERR(ctx->hash);
+
+	return 0;
+}
+
+static void essiv_cbc_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_shash(ctx->hash);
+}
+
+static int essiv_cbc_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err, rounds = 6 + ctx->key1.key_length / 4;
+	struct skcipher_walk walk;
+	unsigned int blocks;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	blocks = walk.nbytes / AES_BLOCK_SIZE;
+	if (blocks) {
+		kernel_neon_begin();
+		aes_essiv_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				      ctx->key1.key_enc, rounds, blocks,
+				      req->iv, ctx->key2.key_enc);
+		kernel_neon_end();
+		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+	}
+	return err ?: cbc_encrypt_walk(req, &walk);
+}
+
+static int essiv_cbc_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err, rounds = 6 + ctx->key1.key_length / 4;
+	struct skcipher_walk walk;
+	unsigned int blocks;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	blocks = walk.nbytes / AES_BLOCK_SIZE;
+	if (blocks) {
+		kernel_neon_begin();
+		aes_essiv_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				      ctx->key1.key_dec, rounds, blocks,
+				      req->iv, ctx->key2.key_enc);
+		kernel_neon_end();
+		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+	}
+	return err ?: cbc_decrypt_walk(req, &walk);
+}
+
 static int ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -502,6 +607,24 @@ static struct skcipher_alg aes_algs[] = { {
 	.encrypt	= cts_cbc_encrypt,
 	.decrypt	= cts_cbc_decrypt,
 	.init		= cts_cbc_init_tfm,
+}, {
+	.base = {
+		.cra_name		= "__essiv(cbc(aes),aes,sha256)",
+		.cra_driver_name	= "__essiv-cbc-aes-sha256-" MODE,
+		.cra_priority		= PRIO + 1,
+		.cra_flags		= CRYPTO_ALG_INTERNAL,
+		.cra_blocksize		= AES_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct crypto_aes_essiv_cbc_ctx),
+		.cra_module		= THIS_MODULE,
+	},
+	.min_keysize	= AES_MIN_KEY_SIZE,
+	.max_keysize	= AES_MAX_KEY_SIZE,
+	.ivsize		= AES_BLOCK_SIZE,
+	.setkey		= essiv_cbc_set_key,
+	.encrypt	= essiv_cbc_encrypt,
+	.decrypt	= essiv_cbc_decrypt,
+	.init		= essiv_cbc_init_tfm,
+	.exit		= essiv_cbc_exit_tfm,
 }, {
 	.base = {
 		.cra_name		= "__ctr(aes)",
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 3f60f7b152bf..c33a050c694c 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -121,10 +121,25 @@ AES_ENDPROC(aes_ecb_decrypt)
 	 *		   int blocks, u8 iv[])
 	 * aes_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		   int blocks, u8 iv[])
+	 * aes_essiv_cbc_encrypt(u8 out[], u8 const in[], u32 const rk1[],
+	 *			 int rounds, int blocks, u8 iv[],
+	 *			 u32 const rk2[]);
+	 * aes_essiv_cbc_decrypt(u8 out[], u8 const in[], u32 const rk1[],
+	 *			 int rounds, int blocks, u8 iv[],
+	 *			 u32 const rk2[]);
 	 */
 
+AES_ENTRY(aes_essiv_cbc_encrypt)
+	ld1		{v4.16b}, [x5]			/* get iv */
+
+	mov		w8, #14				/* AES-256: 14 rounds */
+	enc_prepare	w8, x6, x7
+	encrypt_block	v4, w8, x6, x7, w9
+	b		.Lessivcbcencstart
+
 AES_ENTRY(aes_cbc_encrypt)
 	ld1		{v4.16b}, [x5]			/* get iv */
+.Lessivcbcencstart:
 	enc_prepare	w3, x2, x6
 
 .Lcbcencloop4x:
@@ -156,13 +171,25 @@ AES_ENTRY(aes_cbc_encrypt)
 	st1		{v4.16b}, [x5]			/* return iv */
 	ret
 AES_ENDPROC(aes_cbc_encrypt)
+AES_ENDPROC(aes_essiv_cbc_encrypt)
 
+AES_ENTRY(aes_essiv_cbc_decrypt)
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
+
+	ld1		{cbciv.16b}, [x5]		/* get iv */
+
+	mov		w8, #14				/* AES-256: 14 rounds */
+	enc_prepare	w8, x6, x7
+	encrypt_block	v7, w8, x6, x7, w9
+	b		.Lessivcbcdecstart
 
 AES_ENTRY(aes_cbc_decrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
 	ld1		{cbciv.16b}, [x5]		/* get iv */
+.Lessivcbcdecstart:
 	dec_prepare	w3, x2, x6
 
 .LcbcdecloopNx:
@@ -215,6 +242,7 @@ ST5(	st1		{v4.16b}, [x0], #16		)
 	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_cbc_decrypt)
+AES_ENDPROC(aes_essiv_cbc_decrypt)
 
 
 	/*
@@ -294,7 +322,6 @@ AES_ENDPROC(aes_cbc_cts_decrypt)
 	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
 	.previous
 
-
 	/*
 	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		   int blocks, u8 ctr[])
-- 
2.17.1

