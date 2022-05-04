Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8445192B4
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 May 2022 02:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244599AbiEDAWj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 3 May 2022 20:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244566AbiEDAWY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 3 May 2022 20:22:24 -0400
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB8B42A0F
        for <linux-fscrypt@vger.kernel.org>; Tue,  3 May 2022 17:18:50 -0700 (PDT)
Received: by mail-ua1-x94a.google.com with SMTP id z12-20020ab0770c000000b0035fb10cfc86so8171768uaq.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 03 May 2022 17:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=D5/qcOFQF650mn+smLjdUHC6Pnb+rzvEJSwVX/Zz7DU=;
        b=RS7+oEJ+wFkntBS6W9lHEOyk7ISM7K5nkZzwrCERcmF3JO1a0ruaktsaWMDRQ0Jm7K
         e3vjMK9hD+OMUkAj+RkYfM0NcesJIIfQ1G/RR6RDDQJ7ZbklJUSgDgavLtX43/O8qRRE
         LcTINm3pfJZSxHF5420OvDyqtdLj3GmeZF1YmqAhPPKSmMrd/y2B9r5PILe7aMzRuD9Z
         ZmB0r+a5irMHd/I++PuAujaAgVcRqePsOFgZhwIhoDTr3a93vtdN+DO2eIbo9n0+72Ig
         rDyD+n/rMKk1Q/gonETaDqWVc0kxOYlcajIRMYZmjrlbrzkZ9WgZBl1Q9Lp9yXsapmef
         kSEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=D5/qcOFQF650mn+smLjdUHC6Pnb+rzvEJSwVX/Zz7DU=;
        b=EaqvJCCaj43loBvnk0qvtdCYO5KFpzMC2CRpDyrLy945+GBBVHhgdQeiVdykWyovHy
         OhjWc34bJG11Q4ToSWm09BTO5DHiiQsrU9wvHYwj1EtFuNBsGaQJEZq13d+aDLk/63af
         PGSi1q9NcxA1BlNcK2oozQzWDyeTPD1uIeB9TU1G/eIHBOYcQlKvmcfdE/avefjGcWzc
         9S2zvcmZvxapt+/t9BwrIQYcMTWFKuP8UBsvEOIePUPL3rOg6qa3BBLo+rKr7lAlZo3u
         7SkbeNvJGc/ELdkFjEW2gdvY04VmVu5N9qGP7B18xZuEFSXRSAmEWamvEAR7Drfh6Awl
         evaw==
X-Gm-Message-State: AOAM5327kN2Irh0eO3Jmbe9PqhYOLvsxOit2Mb41F0kpRi2oWD1fdxc1
        KWKjR8mdbHg82cfH5MfKSfv6ogXy9Q==
X-Google-Smtp-Source: ABdhPJzecWcSYpBE4N73UmJNsgevBK/9R/Kcrrqsoui5lZBXDaL61yLtHHavxdvjq/Iybva3jHnQqgevDA==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a67:2dc3:0:b0:32c:de69:ce0d with SMTP id
 t186-20020a672dc3000000b0032cde69ce0dmr6102593vst.38.1651623530082; Tue, 03
 May 2022 17:18:50 -0700 (PDT)
Date:   Wed,  4 May 2022 00:18:20 +0000
In-Reply-To: <20220504001823.2483834-1-nhuck@google.com>
Message-Id: <20220504001823.2483834-7-nhuck@google.com>
Mime-Version: 1.0
References: <20220504001823.2483834-1-nhuck@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 6/9] crypto: arm64/aes-xctr: Improve readability of XCTR
 and CTR modes
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
        Nathan Huckleberry <nhuck@google.com>
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

Added some clarifying comments, changed the register allocations to make
the code clearer, and added register aliases.

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 arch/arm64/crypto/aes-modes.S | 193 ++++++++++++++++++++++------------
 1 file changed, 128 insertions(+), 65 deletions(-)

diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 55df157fce3a..da7c9f3380f8 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -322,32 +322,60 @@ AES_FUNC_END(aes_cbc_cts_decrypt)
 	 * This macro generates the code for CTR and XCTR mode.
 	 */
 .macro ctr_encrypt xctr
+	// Arguments
+	OUT		.req x0
+	IN		.req x1
+	KEY		.req x2
+	ROUNDS_W	.req w3
+	BYTES_W		.req w4
+	IV		.req x5
+	BYTE_CTR_W 	.req w6		// XCTR only
+	// Intermediate values
+	CTR_W		.req w11	// XCTR only
+	CTR		.req x11	// XCTR only
+	IV_PART		.req x12
+	BLOCKS		.req x13
+	BLOCKS_W	.req w13
+
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
-	enc_prepare	w3, x2, x12
-	ld1		{vctr.16b}, [x5]
+	enc_prepare	ROUNDS_W, KEY, IV_PART
+	ld1		{vctr.16b}, [IV]
 
+	/*
+	 * Keep 64 bits of the IV in a register.  For CTR mode this lets us
+	 * easily increment the IV.  For XCTR mode this lets us efficiently XOR
+	 * the 64-bit counter with the IV.
+	 */
 	.if \xctr
-		umov		x12, vctr.d[0]
-		lsr		w11, w6, #4
+		umov		IV_PART, vctr.d[0]
+		lsr		CTR_W, BYTE_CTR_W, #4
 	.else
-		umov		x12, vctr.d[1] /* keep swabbed ctr in reg */
-		rev		x12, x12
+		umov		IV_PART, vctr.d[1]
+		rev		IV_PART, IV_PART
 	.endif
 
 .LctrloopNx\xctr:
-	add		w7, w4, #15
-	sub		w4, w4, #MAX_STRIDE << 4
-	lsr		w7, w7, #4
+	add		BLOCKS_W, BYTES_W, #15
+	sub		BYTES_W, BYTES_W, #MAX_STRIDE << 4
+	lsr		BLOCKS_W, BLOCKS_W, #4
 	mov		w8, #MAX_STRIDE
-	cmp		w7, w8
-	csel		w7, w7, w8, lt
+	cmp		BLOCKS_W, w8
+	csel		BLOCKS_W, BLOCKS_W, w8, lt
 
+	/*
+	 * Set up the counter values in v0-v4.
+	 *
+	 * If we are encrypting less than MAX_STRIDE blocks, the tail block
+	 * handling code expects the last keystream block to be in v4.  For
+	 * example: if encrypting two blocks with MAX_STRIDE=5, then v3 and v4
+	 * should have the next two counter blocks.
+	 */
 	.if \xctr
-		add		x11, x11, x7
+		add		CTR, CTR, BLOCKS
 	.else
-		adds		x12, x12, x7
+		adds		IV_PART, IV_PART, BLOCKS
 	.endif
 	mov		v0.16b, vctr.16b
 	mov		v1.16b, vctr.16b
@@ -355,16 +383,16 @@ AES_FUNC_END(aes_cbc_cts_decrypt)
 	mov		v3.16b, vctr.16b
 ST5(	mov		v4.16b, vctr.16b		)
 	.if \xctr
-		sub		x6, x11, #MAX_STRIDE - 1
-		sub		x7, x11, #MAX_STRIDE - 2
-		sub		x8, x11, #MAX_STRIDE - 3
-		sub		x9, x11, #MAX_STRIDE - 4
-ST5(		sub		x10, x11, #MAX_STRIDE - 5	)
-		eor		x6, x6, x12
-		eor		x7, x7, x12
-		eor		x8, x8, x12
-		eor		x9, x9, x12
-		eor		x10, x10, x12
+		sub		x6, CTR, #MAX_STRIDE - 1
+		sub		x7, CTR, #MAX_STRIDE - 2
+		sub		x8, CTR, #MAX_STRIDE - 3
+		sub		x9, CTR, #MAX_STRIDE - 4
+ST5(		sub		x10, CTR, #MAX_STRIDE - 5	)
+		eor		x6, x6, IV_PART
+		eor		x7, x7, IV_PART
+		eor		x8, x8, IV_PART
+		eor		x9, x9, IV_PART
+		eor		x10, x10, IV_PART
 		mov		v0.d[0], x6
 		mov		v1.d[0], x7
 		mov		v2.d[0], x8
@@ -381,9 +409,9 @@ ST5(		mov		v4.d[0], x10			)
 		ins		vctr.d[0], x8
 
 		/* apply carry to N counter blocks for N := x12 */
-		cbz		x12, 2f
+		cbz		IV_PART, 2f
 		adr		x16, 1f
-		sub		x16, x16, x12, lsl #3
+		sub		x16, x16, IV_PART, lsl #3
 		br		x16
 		bti		c
 		mov		v0.d[0], vctr.d[0]
@@ -398,71 +426,88 @@ ST5(		mov		v4.d[0], vctr.d[0]		)
 1:		b		2f
 		.previous
 
-2:		rev		x7, x12
+2:		rev		x7, IV_PART
 		ins		vctr.d[1], x7
-		sub		x7, x12, #MAX_STRIDE - 1
-		sub		x8, x12, #MAX_STRIDE - 2
-		sub		x9, x12, #MAX_STRIDE - 3
+		sub		x7, IV_PART, #MAX_STRIDE - 1
+		sub		x8, IV_PART, #MAX_STRIDE - 2
+		sub		x9, IV_PART, #MAX_STRIDE - 3
 		rev		x7, x7
 		rev		x8, x8
 		mov		v1.d[1], x7
 		rev		x9, x9
-ST5(		sub		x10, x12, #MAX_STRIDE - 4	)
+ST5(		sub		x10, IV_PART, #MAX_STRIDE - 4	)
 		mov		v2.d[1], x8
 ST5(		rev		x10, x10			)
 		mov		v3.d[1], x9
 ST5(		mov		v4.d[1], x10			)
 	.endif
-	tbnz		w4, #31, .Lctrtail\xctr
-    	ld1		{v5.16b-v7.16b}, [x1], #48
+
+	/*
+	 * If there are at least MAX_STRIDE blocks left, XOR the plaintext with
+	 * keystream and store.  Otherwise jump to tail handling.
+	 */
+	tbnz		BYTES_W, #31, .Lctrtail\xctr
+    	ld1		{v5.16b-v7.16b}, [IN], #48
 ST4(	bl		aes_encrypt_block4x		)
 ST5(	bl		aes_encrypt_block5x		)
 	eor		v0.16b, v5.16b, v0.16b
-ST4(	ld1		{v5.16b}, [x1], #16		)
+ST4(	ld1		{v5.16b}, [IN], #16		)
 	eor		v1.16b, v6.16b, v1.16b
-ST5(	ld1		{v5.16b-v6.16b}, [x1], #32	)
+ST5(	ld1		{v5.16b-v6.16b}, [IN], #32	)
 	eor		v2.16b, v7.16b, v2.16b
 	eor		v3.16b, v5.16b, v3.16b
 ST5(	eor		v4.16b, v6.16b, v4.16b		)
-	st1		{v0.16b-v3.16b}, [x0], #64
-ST5(	st1		{v4.16b}, [x0], #16		)
-	cbz		w4, .Lctrout\xctr
+	st1		{v0.16b-v3.16b}, [OUT], #64
+ST5(	st1		{v4.16b}, [OUT], #16		)
+	cbz		BYTES_W, .Lctrout\xctr
 	b		.LctrloopNx\xctr
 
 .Lctrout\xctr:
 	.if !\xctr
-		st1		{vctr.16b}, [x5] /* return next CTR value */
+		st1		{vctr.16b}, [IV] /* return next CTR value */
 	.endif
 	ldp		x29, x30, [sp], #16
 	ret
 
 .Lctrtail\xctr:
+	/*
+	 * Handle up to MAX_STRIDE * 16 - 1 bytes of plaintext
+	 *
+	 * This code expects the last keystream block to be in v4.  For example:
+	 * if encrypting two blocks with MAX_STRIDE=5, then v3 and v4 should
+	 * have the next two counter blocks.
+	 *
+	 * This allows us to store the ciphertext by writing to overlapping
+	 * regions of memory.  Any invalid ciphertext blocks get overwritten by
+	 * correctly computed blocks.  This approach avoids extra conditional
+	 * branches.
+	 */
 	mov		x16, #16
-	ands		x6, x4, #0xf
-	csel		x13, x6, x16, ne
+	ands		w7, BYTES_W, #0xf
+	csel		x13, x7, x16, ne
 
-ST5(	cmp		w4, #64 - (MAX_STRIDE << 4)	)
+ST5(	cmp		BYTES_W, #64 - (MAX_STRIDE << 4))
 ST5(	csel		x14, x16, xzr, gt		)
-	cmp		w4, #48 - (MAX_STRIDE << 4)
+	cmp		BYTES_W, #48 - (MAX_STRIDE << 4)
 	csel		x15, x16, xzr, gt
-	cmp		w4, #32 - (MAX_STRIDE << 4)
+	cmp		BYTES_W, #32 - (MAX_STRIDE << 4)
 	csel		x16, x16, xzr, gt
-	cmp		w4, #16 - (MAX_STRIDE << 4)
+	cmp		BYTES_W, #16 - (MAX_STRIDE << 4)
 
-	adr_l		x12, .Lcts_permute_table
-	add		x12, x12, x13
+	adr_l		x9, .Lcts_permute_table
+	add		x9, x9, x13
 	ble		.Lctrtail1x\xctr
 
-ST5(	ld1		{v5.16b}, [x1], x14		)
-	ld1		{v6.16b}, [x1], x15
-	ld1		{v7.16b}, [x1], x16
+ST5(	ld1		{v5.16b}, [IN], x14		)
+	ld1		{v6.16b}, [IN], x15
+	ld1		{v7.16b}, [IN], x16
 
 ST4(	bl		aes_encrypt_block4x		)
 ST5(	bl		aes_encrypt_block5x		)
 
-	ld1		{v8.16b}, [x1], x13
-	ld1		{v9.16b}, [x1]
-	ld1		{v10.16b}, [x12]
+	ld1		{v8.16b}, [IN], x13
+	ld1		{v9.16b}, [IN]
+	ld1		{v10.16b}, [x9]
 
 ST4(	eor		v6.16b, v6.16b, v0.16b		)
 ST4(	eor		v7.16b, v7.16b, v1.16b		)
@@ -477,30 +522,48 @@ ST5(	eor		v7.16b, v7.16b, v2.16b		)
 ST5(	eor		v8.16b, v8.16b, v3.16b		)
 ST5(	eor		v9.16b, v9.16b, v4.16b		)
 
-ST5(	st1		{v5.16b}, [x0], x14		)
-	st1		{v6.16b}, [x0], x15
-	st1		{v7.16b}, [x0], x16
-	add		x13, x13, x0
+ST5(	st1		{v5.16b}, [OUT], x14		)
+	st1		{v6.16b}, [OUT], x15
+	st1		{v7.16b}, [OUT], x16
+	add		x13, x13, OUT
 	st1		{v9.16b}, [x13]		// overlapping stores
-	st1		{v8.16b}, [x0]
+	st1		{v8.16b}, [OUT]
 	b		.Lctrout\xctr
 
 .Lctrtail1x\xctr:
-	sub		x7, x6, #16
-	csel		x6, x6, x7, eq
-	add		x1, x1, x6
-	add		x0, x0, x6
-	ld1		{v5.16b}, [x1]
-	ld1		{v6.16b}, [x0]
+	/*
+	 * Handle <= 16 bytes of plaintext
+	 */
+	sub		x8, x7, #16
+	csel		x7, x7, x8, eq
+	add		IN, IN, x7
+	add		OUT, OUT, x7
+	ld1		{v5.16b}, [IN]
+	ld1		{v6.16b}, [OUT]
 ST5(	mov		v3.16b, v4.16b			)
 	encrypt_block	v3, w3, x2, x8, w7
-	ld1		{v10.16b-v11.16b}, [x12]
+	ld1		{v10.16b-v11.16b}, [x9]
 	tbl		v3.16b, {v3.16b}, v10.16b
 	sshr		v11.16b, v11.16b, #7
 	eor		v5.16b, v5.16b, v3.16b
 	bif		v5.16b, v6.16b, v11.16b
-	st1		{v5.16b}, [x0]
+	st1		{v5.16b}, [OUT]
 	b		.Lctrout\xctr
+
+	// Arguments
+	.unreq OUT
+	.unreq IN
+	.unreq KEY
+	.unreq ROUNDS_W
+	.unreq BYTES_W
+	.unreq IV
+	.unreq BYTE_CTR_W	// XCTR only
+	// Intermediate values
+	.unreq CTR_W		// XCTR only
+	.unreq CTR		// XCTR only
+	.unreq IV_PART
+	.unreq BLOCKS
+	.unreq BLOCKS_W
 .endm
 
 	/*
-- 
2.36.0.464.gb9c8b46e94-goog

