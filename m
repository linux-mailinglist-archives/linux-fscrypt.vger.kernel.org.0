Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C8E88A5A
	for <lists+linux-fscrypt@lfdr.de>; Sat, 10 Aug 2019 11:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfHJJl3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 10 Aug 2019 05:41:29 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43944 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfHJJl3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 10 Aug 2019 05:41:29 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so25765171wru.10
        for <linux-fscrypt@vger.kernel.org>; Sat, 10 Aug 2019 02:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WtUW4kMtV0FuBm9YSr9KHz4FtfpiQZk/mVyKFBxk8RY=;
        b=AyrhBJu8fUqszw4iANyFyJs5HpQXjT6EuzCIzSVB2L1Gre2tx7stmuD7ikbk2qu7SW
         ltmtG3vhfOLoy3uFXk/0mfy+6LVvDiLBjLfGpahjzR5GGLJ8/Qo40+1kvGt7AfTgxNOo
         fqSQQZJWzxGHbR5DKwhUwwsixb+ZssNDn0rCt5wcfiYxknh3haQZSUJS9qY9rWJtTLr5
         oA2ArOkoRhtjPOfCyGn/IyKEO2JCzGXEgbcaHVh8A7dgamjF+ciYBsKEUlgF8FlDqu0p
         Z8AzQhf/syvUCrWz19ronAkuUVawVkw/32cmUf2oKmD+veQ8/DwocEAsNUHBbMCNYctz
         eh5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WtUW4kMtV0FuBm9YSr9KHz4FtfpiQZk/mVyKFBxk8RY=;
        b=AVQ5HZSCC7+BtV5hXfaeo8QgpPSYmtkv/KvZAWz5kMV5+SOBTuhwf62jq8vlXYyvbL
         eakFjkI4FYOBOpzNVJwKdM9BxkC1pHoDTw/4MqYOT7jbEqoMNCg9s5wPDdpCdp0rzGMN
         BuZNh5l8iwvVczk4SNOGkPI5OTkKxB36A2Hx00T2di+s4/GeVhx949/nyAhGZWEsy1ea
         cYD5ETsJIWsYABNIpKlOxDnFUygOVNgVsXnPmPDFTaWerheQfaGnKNrISDXV7Fp7bbC1
         E3MJF8Lqfzhk4uvsswV9Nb+sxafxRAa/uyCBL6eiC3WpfpqZ76nwODCD8mkG5huRIQBw
         pJ/w==
X-Gm-Message-State: APjAAAWFxPZxbebHwWgLY33csebAZX6Qgy2JBYjxOlnAEVtSI+Js/IM0
        AjhYo6wStKm/7UMeWol1/EDiBA==
X-Google-Smtp-Source: APXvYqz2FGFf5/FCuIqUU0p5uJ5Knt7ua0BM3U6YgGbzhC0eXuid+KaPNiKJmpfLAqB5ktpsT9VbSA==
X-Received: by 2002:a5d:670d:: with SMTP id o13mr19421829wru.289.1565430086316;
        Sat, 10 Aug 2019 02:41:26 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id n16sm519883wmk.12.2019.08.10.02.41.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Aug 2019 02:41:25 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v9 6/7] crypto: arm64/aes - implement accelerated ESSIV/CBC mode
Date:   Sat, 10 Aug 2019 12:40:52 +0300
Message-Id: <20190810094053.7423-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190810094053.7423-1-ard.biesheuvel@linaro.org>
References: <20190810094053.7423-1-ard.biesheuvel@linaro.org>
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
 arch/arm64/crypto/aes-modes.S |  28 +++++
 2 files changed, 151 insertions(+)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 23abf335f1ee..45fca7f8cd75 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -10,6 +10,7 @@
 #include <asm/simd.h>
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
+#include <crypto/sha.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
@@ -30,6 +31,8 @@
 #define aes_cbc_decrypt		ce_aes_cbc_decrypt
 #define aes_cbc_cts_encrypt	ce_aes_cbc_cts_encrypt
 #define aes_cbc_cts_decrypt	ce_aes_cbc_cts_decrypt
+#define aes_essiv_cbc_encrypt	ce_aes_essiv_cbc_encrypt
+#define aes_essiv_cbc_decrypt	ce_aes_essiv_cbc_decrypt
 #define aes_ctr_encrypt		ce_aes_ctr_encrypt
 #define aes_xts_encrypt		ce_aes_xts_encrypt
 #define aes_xts_decrypt		ce_aes_xts_decrypt
@@ -44,6 +47,8 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #define aes_cbc_decrypt		neon_aes_cbc_decrypt
 #define aes_cbc_cts_encrypt	neon_aes_cbc_cts_encrypt
 #define aes_cbc_cts_decrypt	neon_aes_cbc_cts_decrypt
+#define aes_essiv_cbc_encrypt	neon_aes_essiv_cbc_encrypt
+#define aes_essiv_cbc_decrypt	neon_aes_essiv_cbc_decrypt
 #define aes_ctr_encrypt		neon_aes_ctr_encrypt
 #define aes_xts_encrypt		neon_aes_xts_encrypt
 #define aes_xts_decrypt		neon_aes_xts_decrypt
@@ -87,6 +92,13 @@ asmlinkage void aes_xts_decrypt(u8 out[], u8 const in[], u32 const rk1[],
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
@@ -102,6 +114,12 @@ struct crypto_aes_xts_ctx {
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
@@ -146,6 +164,31 @@ static int xts_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
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
@@ -360,6 +403,68 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
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
@@ -515,6 +620,24 @@ static struct skcipher_alg aes_algs[] = { {
 	.encrypt	= cts_cbc_encrypt,
 	.decrypt	= cts_cbc_decrypt,
 	.init		= cts_cbc_init_tfm,
+}, {
+	.base = {
+		.cra_name		= "__essiv(cbc(aes),sha256)",
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
index 324039b72094..2879f030a749 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -118,8 +118,23 @@ AES_ENDPROC(aes_ecb_decrypt)
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
+	enc_switch_key	w3, x2, x6
+	b		.Lcbcencloop4x
+
 AES_ENTRY(aes_cbc_encrypt)
 	ld1		{v4.16b}, [x5]			/* get iv */
 	enc_prepare	w3, x2, x6
@@ -153,13 +168,25 @@ AES_ENTRY(aes_cbc_encrypt)
 	st1		{v4.16b}, [x5]			/* return iv */
 	ret
 AES_ENDPROC(aes_cbc_encrypt)
+AES_ENDPROC(aes_essiv_cbc_encrypt)
+
+AES_ENTRY(aes_essiv_cbc_decrypt)
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
+
+	ld1		{cbciv.16b}, [x5]		/* get iv */
 
+	mov		w8, #14				/* AES-256: 14 rounds */
+	enc_prepare	w8, x6, x7
+	encrypt_block	cbciv, w8, x6, x7, w9
+	b		.Lessivcbcdecstart
 
 AES_ENTRY(aes_cbc_decrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
 	ld1		{cbciv.16b}, [x5]		/* get iv */
+.Lessivcbcdecstart:
 	dec_prepare	w3, x2, x6
 
 .LcbcdecloopNx:
@@ -212,6 +239,7 @@ ST5(	st1		{v4.16b}, [x0], #16		)
 	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_cbc_decrypt)
+AES_ENDPROC(aes_essiv_cbc_decrypt)
 
 
 	/*
-- 
2.17.1

