Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD5D24BE2E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jun 2019 18:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbfFSQ3q (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jun 2019 12:29:46 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51323 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729987AbfFSQ3p (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jun 2019 12:29:45 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so159290wma.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 19 Jun 2019 09:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZHw0WyiBVZLMUvSwYLBxNsNpOpeasUqgDs3neESLdpw=;
        b=O0yqmovbETKSuVn1xK2WZNd9kUEb6CGxD1qlO3xW+2VdiPR+J1Om8n624PbgzUNKyY
         Hl/YIihxALlJlhgRM4pO+SIsI4q1hzG63D1wUCZkThftJAeBQ4Dtz8EwFvCKMoY1J1cn
         9azu1Zx8g39jNc0287E5dc3Pehbl5Lijqm3sx3V3307zEXuJSKJR2qH9PFW7kM4vvF/L
         Zi1BfvkmlBjeFtMjDdqYJKdys6WCiCeODNP4AYLEFneDavsZ+BrPoO5xqsv1tZGd6LoD
         bwPyUQTJu8tRj23l2BXdRStRuLakjxzyZPmNlnvGyJqQDPd7EgNjmk6iCBtgrGfd9ZTF
         CCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZHw0WyiBVZLMUvSwYLBxNsNpOpeasUqgDs3neESLdpw=;
        b=L0oqmRHGLTLrWJcg17/SkeeMhmXzTwVEhcgmQPhlStBNu1sQvPXijmwkN9HAXfCxhH
         pkTSblMCAzyYyMKhoaxEtS8Y0EfgbxJjM6NYdDUkXFeYa8KkbCtFC1wjpo7Nl6uuwTam
         GPyFBsup8hkqInsLDje9PhBCx/MhTo2EmZBKG7TaPPW8C6WTLQjeC3z92QE1eVvN8diY
         JaYidMkkWxdA3x5HB5k94BpboOnlRfcYv5ExAscnf3UyeIIBcDfNKndnveSo26qd65qE
         M+ydN+9r9aXXAjSCS5S1VGNyhHPWL8nE6Y6RMiwacWEktC/7I34jLjblRSgwafEw8h3C
         PyCw==
X-Gm-Message-State: APjAAAXI0wtSx/0Lcp23GXG9+12A/fbHy9pJhRRqefZLm/eHB/gCGlLw
        QgVkAvtaUaT+cGnyb98POU7w2A==
X-Google-Smtp-Source: APXvYqyqbdnpvJ6FVdKYURwiJo85IGN3UXdX8pN4SRzjJSAU4hILtJQSdY9pCSryUmOi650pJmintg==
X-Received: by 2002:a1c:6a0e:: with SMTP id f14mr9818450wmc.154.1560961784231;
        Wed, 19 Jun 2019 09:29:44 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id 32sm37815960wra.35.2019.06.19.09.29.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 09:29:43 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v3 6/6] crypto: arm64/aes - implement accelerated ESSIV/CBC mode
Date:   Wed, 19 Jun 2019 18:29:21 +0200
Message-Id: <20190619162921.12509-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add an accelerated version of the 'essiv(cbc(aes),aes,sha256)'
skcipher, which is used by fscrypt, and in some cases, by dm-crypt.
This avoids a separate call into the AES cipher for every invocation.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c  | 129 ++++++++++++++++++++
 arch/arm64/crypto/aes-modes.S |  99 +++++++++++++++
 2 files changed, 228 insertions(+)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index f0ceb545bd1e..6dab2f062cea 100644
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
+				      int rounds, int blocks, u32 const rk2[],
+				      u8 iv[], int first);
+asmlinkage void aes_essiv_cbc_decrypt(u8 out[], u8 const in[], u32 const rk1[],
+				      int rounds, int blocks, u32 const rk2[],
+				      u8 iv[], int first);
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
@@ -361,6 +404,74 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
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
+	int err, first, rounds = 6 + ctx->key1.key_length / 4;
+	struct skcipher_walk walk;
+	u8 iv[AES_BLOCK_SIZE];
+	unsigned int blocks;
+
+	memcpy(iv, req->iv, crypto_skcipher_ivsize(tfm));
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+		kernel_neon_begin();
+		aes_essiv_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				      ctx->key1.key_enc, rounds, blocks,
+				      ctx->key2.key_enc, iv, first);
+		kernel_neon_end();
+		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+	}
+
+	return err;
+}
+
+static int essiv_cbc_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err, first, rounds = 6 + ctx->key1.key_length / 4;
+	struct skcipher_walk walk;
+	u8 iv[AES_BLOCK_SIZE];
+	unsigned int blocks;
+
+	memcpy(iv, req->iv, crypto_skcipher_ivsize(tfm));
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+		kernel_neon_begin();
+		aes_essiv_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				      ctx->key1.key_dec, rounds, blocks,
+				      ctx->key2.key_enc, iv, first);
+		kernel_neon_end();
+		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+	}
+
+	return err;
+}
+
 static int ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -504,6 +615,24 @@ static struct skcipher_alg aes_algs[] = { {
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
+	.ivsize		= sizeof(u64),
+	.setkey		= essiv_cbc_set_key,
+	.encrypt	= essiv_cbc_encrypt,
+	.decrypt	= essiv_cbc_decrypt,
+	.init		= essiv_cbc_init_tfm,
+	.exit		= essiv_cbc_exit_tfm,
 }, {
 	.base = {
 		.cra_name		= "__ctr(aes)",
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 4c7ce231963c..4ebc61375aa6 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -247,6 +247,105 @@ AES_ENDPROC(aes_cbc_cts_decrypt)
 	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
 	.previous
 
+	/*
+	 * aes_essiv_cbc_encrypt(u8 out[], u8 const in[], u32 const rk1[],
+	 *			 int rounds, int blocks, u32 const rk2[],
+	 *			 u8 iv[], int first);
+	 * aes_essiv_cbc_decrypt(u8 out[], u8 const in[], u32 const rk1[],
+	 *			 int rounds, int blocks, u32 const rk2[],
+	 *			 u8 iv[], int first);
+	 */
+
+AES_ENTRY(aes_essiv_cbc_encrypt)
+	ld1		{v4.16b}, [x6]			/* get iv */
+	cbz		x7, .Lessivcbcencnotfirst
+
+	mov		w8, #14				/* AES-256: 14 rounds */
+	enc_prepare	w8, x5, x7
+	mov		v4.8b, v4.8b
+	encrypt_block	v4, w8, x5, x7, w9
+
+.Lessivcbcencnotfirst:
+	enc_prepare	w3, x2, x7
+.Lessivcbcencloop4x:
+	subs		w4, w4, #4
+	bmi		.Lessivcbcenc1x
+	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 pt blocks */
+	eor		v0.16b, v0.16b, v4.16b		/* ..and xor with iv */
+	encrypt_block	v0, w3, x2, x7, w8
+	eor		v1.16b, v1.16b, v0.16b
+	encrypt_block	v1, w3, x2, x7, w8
+	eor		v2.16b, v2.16b, v1.16b
+	encrypt_block	v2, w3, x2, x7, w8
+	eor		v3.16b, v3.16b, v2.16b
+	encrypt_block	v3, w3, x2, x7, w8
+	st1		{v0.16b-v3.16b}, [x0], #64
+	mov		v4.16b, v3.16b
+	b		.Lessivcbcencloop4x
+.Lessivcbcenc1x:
+	adds		w4, w4, #4
+	beq		.Lessivcbcencout
+.Lessivcbcencloop:
+	ld1		{v0.16b}, [x1], #16		/* get next pt block */
+	eor		v4.16b, v4.16b, v0.16b		/* ..and xor with iv */
+	encrypt_block	v4, w3, x2, x6, w7
+	st1		{v4.16b}, [x0], #16
+	subs		w4, w4, #1
+	bne		.Lessivcbcencloop
+.Lessivcbcencout:
+	st1		{v4.16b}, [x6]			/* return iv */
+	ret
+AES_ENDPROC(aes_essiv_cbc_encrypt)
+
+
+AES_ENTRY(aes_essiv_cbc_decrypt)
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
+
+	ld1		{v7.16b}, [x6]			/* get iv */
+	cbz		x7, .Lessivcbcdecnotfirst
+
+	mov		w8, #14				/* AES-256: 14 rounds */
+	enc_prepare	w8, x5, x7
+	mov		v7.8b, v7.8b
+	encrypt_block	v7, w8, x5, x7, w9
+
+.Lessivcbcdecnotfirst:
+	dec_prepare	w3, x2, x7
+.LessivcbcdecloopNx:
+	subs		w4, w4, #4
+	bmi		.Lessivcbcdec1x
+	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
+	mov		v4.16b, v0.16b
+	mov		v5.16b, v1.16b
+	mov		v6.16b, v2.16b
+	bl		aes_decrypt_block4x
+	sub		x1, x1, #16
+	eor		v0.16b, v0.16b, v7.16b
+	eor		v1.16b, v1.16b, v4.16b
+	ld1		{v7.16b}, [x1], #16		/* reload 1 ct block */
+	eor		v2.16b, v2.16b, v5.16b
+	eor		v3.16b, v3.16b, v6.16b
+	st1		{v0.16b-v3.16b}, [x0], #64
+	b		.LessivcbcdecloopNx
+.Lessivcbcdec1x:
+	adds		w4, w4, #4
+	beq		.Lessivcbcdecout
+.Lessivcbcdecloop:
+	ld1		{v1.16b}, [x1], #16		/* get next ct block */
+	mov		v0.16b, v1.16b			/* ...and copy to v0 */
+	decrypt_block	v0, w3, x2, x7, w8
+	eor		v0.16b, v0.16b, v7.16b		/* xor with iv => pt */
+	mov		v7.16b, v1.16b			/* ct is next iv */
+	st1		{v0.16b}, [x0], #16
+	subs		w4, w4, #1
+	bne		.Lessivcbcdecloop
+.Lessivcbcdecout:
+	st1		{v7.16b}, [x6]			/* return iv */
+	ldp		x29, x30, [sp], #16
+	ret
+AES_ENDPROC(aes_essiv_cbc_decrypt)
+
 
 	/*
 	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
-- 
2.20.1

