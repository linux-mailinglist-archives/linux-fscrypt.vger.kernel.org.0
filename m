Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572E752F25C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 May 2022 20:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352518AbiETSPs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 20 May 2022 14:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352527AbiETSPW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 20 May 2022 14:15:22 -0400
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEDE190D0E
        for <linux-fscrypt@vger.kernel.org>; Fri, 20 May 2022 11:15:15 -0700 (PDT)
Received: by mail-ua1-x94a.google.com with SMTP id j15-20020ab0644f000000b00368bac468ceso4100035uap.17
        for <linux-fscrypt@vger.kernel.org>; Fri, 20 May 2022 11:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lSp4E6wNizuP+qhsN3gJGJXtWLs1Fn2HQCi8c0WytJM=;
        b=pqm2X6olN1eOORh6xJPBRObdxkPGCTcOhoz7wXIkESTL45woJq4zrBc1mi+PR0mKlf
         KWLDCimjEmS25R1YH3bl9168SUdsy7zKuIkiMS5kRkfKGjDpl3c4zz1HdFW2b0aMLsdm
         C5Jx7N5+xARwFP7nPA3SRSmDVYJ9tlUDZ8KEKfYEMSi3VO24BGrngHPkLsHQ8g/muNdT
         pShUv1YM5X5rjhrl9Iq4lwvIIQv37jgoGXvC/Ru0ZsTYlhOy8GTfjFDG28fUyLCAHo/y
         o3g/GdY4iO3/TAU1PIEt5bRveQRAePMGrryXBsU3sgk49fYWMP20h1w0n9DxwO0Ifb6n
         yMDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lSp4E6wNizuP+qhsN3gJGJXtWLs1Fn2HQCi8c0WytJM=;
        b=MUE30R28iE298nXPfI0cBAYwokKvWyghh2jcCuKpvVTpUYWpMLk/+nvCNrxf9IHr51
         JjyCIG1ZjaVhpMSBQJ0zAeODQ7JqknnIIWOZWhnOvjBIM13zfyEW5O1EKQ5xuIyzwBni
         7ShZZ3PujahsIPKVRY0+PUq801+2FVLBzhCah3UCSupqWftVz0cTN/esalwWxUvqQuDN
         PBA/JzGkOcnVnc9CM3u6BAUyutyMxGQbyi3rAf80+HJp1VYkcfmXd1vEDPrpZyyfqJSI
         i7+C825KI50egpvqnmmdIeZjIPNzJP027Le2Tne7qvhH90L4Cdbxib/xJs5eoaXPzrsl
         TzEw==
X-Gm-Message-State: AOAM531zM+vhyyPaavvw0s1WmcGKq0tXJduSXNFnp1bYCW1WQ/fxFbdn
        rdB1Si9mTSYvBRRNS4eRaX/6g9eEtw==
X-Google-Smtp-Source: ABdhPJyjGopy0QAheMP0mf9T18yjh5ZI2f6B8+Gerd/vFoFc+r5dfYcJcP2kkBRl4mn65gPP0+mcwfFpLw==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a1f:2693:0:b0:349:8f4a:c0b8 with SMTP id
 m141-20020a1f2693000000b003498f4ac0b8mr5147765vkm.4.1653070514662; Fri, 20
 May 2022 11:15:14 -0700 (PDT)
Date:   Fri, 20 May 2022 18:14:57 +0000
In-Reply-To: <20220520181501.2159644-1-nhuck@google.com>
Message-Id: <20220520181501.2159644-6-nhuck@google.com>
Mime-Version: 1.0
References: <20220520181501.2159644-1-nhuck@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v9 5/9] crypto: arm64/aes-xctr: Add accelerated implementation
 of XCTR
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Huckleberry <nhuck@google.com>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add hardware accelerated version of XCTR for ARM64 CPUs with ARMv8
Crypto Extension support.  This XCTR implementation is based on the CTR
implementation in aes-modes.S.

More information on XCTR can be found in
the HCTR2 paper: "Length-preserving encryption with HCTR2":
https://eprint.iacr.org/2021/1441.pdf

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/Kconfig     |   4 +-
 arch/arm64/crypto/aes-glue.c  |  64 ++++++++++++-
 arch/arm64/crypto/aes-modes.S | 168 +++++++++++++++++++++-------------
 3 files changed, 169 insertions(+), 67 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 2a965aa0188d..897f9a4b5b67 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -84,13 +84,13 @@ config CRYPTO_AES_ARM64_CE_CCM
 	select CRYPTO_LIB_AES
 
 config CRYPTO_AES_ARM64_CE_BLK
-	tristate "AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions"
+	tristate "AES in ECB/CBC/CTR/XTS/XCTR modes using ARMv8 Crypto Extensions"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_AES_ARM64_CE
 
 config CRYPTO_AES_ARM64_NEON_BLK
-	tristate "AES in ECB/CBC/CTR/XTS modes using NEON instructions"
+	tristate "AES in ECB/CBC/CTR/XTS/XCTR modes using NEON instructions"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 561dd2332571..b6883288234c 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -34,10 +34,11 @@
 #define aes_essiv_cbc_encrypt	ce_aes_essiv_cbc_encrypt
 #define aes_essiv_cbc_decrypt	ce_aes_essiv_cbc_decrypt
 #define aes_ctr_encrypt		ce_aes_ctr_encrypt
+#define aes_xctr_encrypt	ce_aes_xctr_encrypt
 #define aes_xts_encrypt		ce_aes_xts_encrypt
 #define aes_xts_decrypt		ce_aes_xts_decrypt
 #define aes_mac_update		ce_aes_mac_update
-MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
+MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS/XCTR using ARMv8 Crypto Extensions");
 #else
 #define MODE			"neon"
 #define PRIO			200
@@ -50,16 +51,18 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #define aes_essiv_cbc_encrypt	neon_aes_essiv_cbc_encrypt
 #define aes_essiv_cbc_decrypt	neon_aes_essiv_cbc_decrypt
 #define aes_ctr_encrypt		neon_aes_ctr_encrypt
+#define aes_xctr_encrypt	neon_aes_xctr_encrypt
 #define aes_xts_encrypt		neon_aes_xts_encrypt
 #define aes_xts_decrypt		neon_aes_xts_decrypt
 #define aes_mac_update		neon_aes_mac_update
-MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 NEON");
+MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS/XCTR using ARMv8 NEON");
 #endif
 #if defined(USE_V8_CRYPTO_EXTENSIONS) || !IS_ENABLED(CONFIG_CRYPTO_AES_ARM64_BS)
 MODULE_ALIAS_CRYPTO("ecb(aes)");
 MODULE_ALIAS_CRYPTO("cbc(aes)");
 MODULE_ALIAS_CRYPTO("ctr(aes)");
 MODULE_ALIAS_CRYPTO("xts(aes)");
+MODULE_ALIAS_CRYPTO("xctr(aes)");
 #endif
 MODULE_ALIAS_CRYPTO("cts(cbc(aes))");
 MODULE_ALIAS_CRYPTO("essiv(cbc(aes),sha256)");
@@ -89,6 +92,9 @@ asmlinkage void aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
 asmlinkage void aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int bytes, u8 ctr[]);
 
+asmlinkage void aes_xctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
+				 int rounds, int bytes, u8 ctr[], int byte_ctr);
+
 asmlinkage void aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[],
 				int rounds, int bytes, u32 const rk2[], u8 iv[],
 				int first);
@@ -442,6 +448,44 @@ static int __maybe_unused essiv_cbc_decrypt(struct skcipher_request *req)
 	return err ?: cbc_decrypt_walk(req, &walk);
 }
 
+static int __maybe_unused xctr_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err, rounds = 6 + ctx->key_length / 4;
+	struct skcipher_walk walk;
+	unsigned int byte_ctr = 0;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	while (walk.nbytes > 0) {
+		const u8 *src = walk.src.virt.addr;
+		unsigned int nbytes = walk.nbytes;
+		u8 *dst = walk.dst.virt.addr;
+		u8 buf[AES_BLOCK_SIZE];
+
+		if (unlikely(nbytes < AES_BLOCK_SIZE))
+			src = dst = memcpy(buf + sizeof(buf) - nbytes,
+					   src, nbytes);
+		else if (nbytes < walk.total)
+			nbytes &= ~(AES_BLOCK_SIZE - 1);
+
+		kernel_neon_begin();
+		aes_xctr_encrypt(dst, src, ctx->key_enc, rounds, nbytes,
+						 walk.iv, byte_ctr);
+		kernel_neon_end();
+
+		if (unlikely(nbytes < AES_BLOCK_SIZE))
+			memcpy(walk.dst.virt.addr,
+			       buf + sizeof(buf) - nbytes, nbytes);
+		byte_ctr += nbytes;
+
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+	}
+
+	return err;
+}
+
 static int __maybe_unused ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -669,6 +713,22 @@ static struct skcipher_alg aes_algs[] = { {
 	.setkey		= skcipher_aes_setkey,
 	.encrypt	= ctr_encrypt,
 	.decrypt	= ctr_encrypt,
+}, {
+	.base = {
+		.cra_name		= "xctr(aes)",
+		.cra_driver_name	= "xctr-aes-" MODE,
+		.cra_priority		= PRIO,
+		.cra_blocksize		= 1,
+		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+		.cra_module		= THIS_MODULE,
+	},
+	.min_keysize	= AES_MIN_KEY_SIZE,
+	.max_keysize	= AES_MAX_KEY_SIZE,
+	.ivsize		= AES_BLOCK_SIZE,
+	.chunksize	= AES_BLOCK_SIZE,
+	.setkey		= skcipher_aes_setkey,
+	.encrypt	= xctr_encrypt,
+	.decrypt	= xctr_encrypt,
 }, {
 	.base = {
 		.cra_name		= "xts(aes)",
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index dc35eb0245c5..9a027200bdba 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -318,80 +318,103 @@ AES_FUNC_END(aes_cbc_cts_decrypt)
 	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
 	.previous
 
-
 	/*
-	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
-	 *		   int bytes, u8 ctr[])
+	 * This macro generates the code for CTR and XCTR mode.
 	 */
-
-AES_FUNC_START(aes_ctr_encrypt)
+.macro ctr_encrypt xctr
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
 	enc_prepare	w3, x2, x12
 	ld1		{vctr.16b}, [x5]
 
-	umov		x12, vctr.d[1]		/* keep swabbed ctr in reg */
-	rev		x12, x12
+	.if \xctr
+		umov		x12, vctr.d[0]
+		lsr		w11, w6, #4
+	.else
+		umov		x12, vctr.d[1] /* keep swabbed ctr in reg */
+		rev		x12, x12
+	.endif
 
-.LctrloopNx:
+.LctrloopNx\xctr:
 	add		w7, w4, #15
 	sub		w4, w4, #MAX_STRIDE << 4
 	lsr		w7, w7, #4
 	mov		w8, #MAX_STRIDE
 	cmp		w7, w8
 	csel		w7, w7, w8, lt
-	adds		x12, x12, x7
 
+	.if \xctr
+		add		x11, x11, x7
+	.else
+		adds		x12, x12, x7
+	.endif
 	mov		v0.16b, vctr.16b
 	mov		v1.16b, vctr.16b
 	mov		v2.16b, vctr.16b
 	mov		v3.16b, vctr.16b
 ST5(	mov		v4.16b, vctr.16b		)
-	bcs		0f
-
-	.subsection	1
-	/* apply carry to outgoing counter */
-0:	umov		x8, vctr.d[0]
-	rev		x8, x8
-	add		x8, x8, #1
-	rev		x8, x8
-	ins		vctr.d[0], x8
-
-	/* apply carry to N counter blocks for N := x12 */
-	cbz		x12, 2f
-	adr		x16, 1f
-	sub		x16, x16, x12, lsl #3
-	br		x16
-	bti		c
-	mov		v0.d[0], vctr.d[0]
-	bti		c
-	mov		v1.d[0], vctr.d[0]
-	bti		c
-	mov		v2.d[0], vctr.d[0]
-	bti		c
-	mov		v3.d[0], vctr.d[0]
-ST5(	bti		c				)
-ST5(	mov		v4.d[0], vctr.d[0]		)
-1:	b		2f
-	.previous
-
-2:	rev		x7, x12
-	ins		vctr.d[1], x7
-	sub		x7, x12, #MAX_STRIDE - 1
-	sub		x8, x12, #MAX_STRIDE - 2
-	sub		x9, x12, #MAX_STRIDE - 3
-	rev		x7, x7
-	rev		x8, x8
-	mov		v1.d[1], x7
-	rev		x9, x9
-ST5(	sub		x10, x12, #MAX_STRIDE - 4	)
-	mov		v2.d[1], x8
-ST5(	rev		x10, x10			)
-	mov		v3.d[1], x9
-ST5(	mov		v4.d[1], x10			)
-	tbnz		w4, #31, .Lctrtail
-	ld1		{v5.16b-v7.16b}, [x1], #48
+	.if \xctr
+		sub		x6, x11, #MAX_STRIDE - 1
+		sub		x7, x11, #MAX_STRIDE - 2
+		sub		x8, x11, #MAX_STRIDE - 3
+		sub		x9, x11, #MAX_STRIDE - 4
+ST5(		sub		x10, x11, #MAX_STRIDE - 5	)
+		eor		x6, x6, x12
+		eor		x7, x7, x12
+		eor		x8, x8, x12
+		eor		x9, x9, x12
+ST5(		eor		x10, x10, x12			)
+		mov		v0.d[0], x6
+		mov		v1.d[0], x7
+		mov		v2.d[0], x8
+		mov		v3.d[0], x9
+ST5(		mov		v4.d[0], x10			)
+	.else
+		bcs		0f
+		.subsection	1
+		/* apply carry to outgoing counter */
+0:		umov		x8, vctr.d[0]
+		rev		x8, x8
+		add		x8, x8, #1
+		rev		x8, x8
+		ins		vctr.d[0], x8
+
+		/* apply carry to N counter blocks for N := x12 */
+		cbz		x12, 2f
+		adr		x16, 1f
+		sub		x16, x16, x12, lsl #3
+		br		x16
+		bti		c
+		mov		v0.d[0], vctr.d[0]
+		bti		c
+		mov		v1.d[0], vctr.d[0]
+		bti		c
+		mov		v2.d[0], vctr.d[0]
+		bti		c
+		mov		v3.d[0], vctr.d[0]
+ST5(		bti		c				)
+ST5(		mov		v4.d[0], vctr.d[0]		)
+1:		b		2f
+		.previous
+
+2:		rev		x7, x12
+		ins		vctr.d[1], x7
+		sub		x7, x12, #MAX_STRIDE - 1
+		sub		x8, x12, #MAX_STRIDE - 2
+		sub		x9, x12, #MAX_STRIDE - 3
+		rev		x7, x7
+		rev		x8, x8
+		mov		v1.d[1], x7
+		rev		x9, x9
+ST5(		sub		x10, x12, #MAX_STRIDE - 4	)
+		mov		v2.d[1], x8
+ST5(		rev		x10, x10			)
+		mov		v3.d[1], x9
+ST5(		mov		v4.d[1], x10			)
+	.endif
+	tbnz		w4, #31, .Lctrtail\xctr
+    	ld1		{v5.16b-v7.16b}, [x1], #48
 ST4(	bl		aes_encrypt_block4x		)
 ST5(	bl		aes_encrypt_block5x		)
 	eor		v0.16b, v5.16b, v0.16b
@@ -403,16 +426,17 @@ ST5(	ld1		{v5.16b-v6.16b}, [x1], #32	)
 ST5(	eor		v4.16b, v6.16b, v4.16b		)
 	st1		{v0.16b-v3.16b}, [x0], #64
 ST5(	st1		{v4.16b}, [x0], #16		)
-	cbz		w4, .Lctrout
-	b		.LctrloopNx
+	cbz		w4, .Lctrout\xctr
+	b		.LctrloopNx\xctr
 
-.Lctrout:
-	st1		{vctr.16b}, [x5]	/* return next CTR value */
+.Lctrout\xctr:
+	.if !\xctr
+		st1		{vctr.16b}, [x5] /* return next CTR value */
+	.endif
 	ldp		x29, x30, [sp], #16
 	ret
 
-.Lctrtail:
-	/* XOR up to MAX_STRIDE * 16 - 1 bytes of in/output with v0 ... v3/v4 */
+.Lctrtail\xctr:
 	mov		x16, #16
 	ands		x6, x4, #0xf
 	csel		x13, x6, x16, ne
@@ -427,7 +451,7 @@ ST5(	csel		x14, x16, xzr, gt		)
 
 	adr_l		x12, .Lcts_permute_table
 	add		x12, x12, x13
-	ble		.Lctrtail1x
+	ble		.Lctrtail1x\xctr
 
 ST5(	ld1		{v5.16b}, [x1], x14		)
 	ld1		{v6.16b}, [x1], x15
@@ -459,9 +483,9 @@ ST5(	st1		{v5.16b}, [x0], x14		)
 	add		x13, x13, x0
 	st1		{v9.16b}, [x13]		// overlapping stores
 	st1		{v8.16b}, [x0]
-	b		.Lctrout
+	b		.Lctrout\xctr
 
-.Lctrtail1x:
+.Lctrtail1x\xctr:
 	sub		x7, x6, #16
 	csel		x6, x6, x7, eq
 	add		x1, x1, x6
@@ -476,9 +500,27 @@ ST5(	mov		v3.16b, v4.16b			)
 	eor		v5.16b, v5.16b, v3.16b
 	bif		v5.16b, v6.16b, v11.16b
 	st1		{v5.16b}, [x0]
-	b		.Lctrout
+	b		.Lctrout\xctr
+.endm
+
+	/*
+	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	 *		   int bytes, u8 ctr[])
+	 */
+
+AES_FUNC_START(aes_ctr_encrypt)
+	ctr_encrypt 0
 AES_FUNC_END(aes_ctr_encrypt)
 
+	/*
+	 * aes_xctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	 *		   int bytes, u8 const iv[], int byte_ctr)
+	 */
+
+AES_FUNC_START(aes_xctr_encrypt)
+	ctr_encrypt 1
+AES_FUNC_END(aes_xctr_encrypt)
+
 
 	/*
 	 * aes_xts_encrypt(u8 out[], u8 const in[], u8 const rk1[], int rounds,
-- 
2.36.1.124.g0e6072fb45-goog

