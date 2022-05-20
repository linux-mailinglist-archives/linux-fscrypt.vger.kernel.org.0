Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6FB52F26A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 May 2022 20:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352610AbiETSQP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 20 May 2022 14:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352532AbiETSPX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 20 May 2022 14:15:23 -0400
Received: from mail-ua1-x949.google.com (mail-ua1-x949.google.com [IPv6:2607:f8b0:4864:20::949])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131C71900FF
        for <linux-fscrypt@vger.kernel.org>; Fri, 20 May 2022 11:15:17 -0700 (PDT)
Received: by mail-ua1-x949.google.com with SMTP id s14-20020ab02bce000000b0035d45862725so4088902uar.22
        for <linux-fscrypt@vger.kernel.org>; Fri, 20 May 2022 11:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DzwbDyo0Hifrmpg9+ONeHKqzLtXyM8pE1lBDo5DVPMc=;
        b=iND/7UKdYEs1UuuEafoHKYttBfMVG+TWfwTTkb8wZndwE3OaUbGk7y4aRUHYINJj8m
         uyZKRrdGYib9Ik8WkUOHi+IYHFF8OoprZ7h7aYKQqY3fJx8EwKbLMN4lzIQsTjhxi+d9
         /eaVNVb8KC0bmK2aOPO9J5OcrAhdo2TGBBZ4tnh8KA4vkoSSYJBrg1+1vvoqZd+0eiVM
         OlpV2LhBYPDSoBbaD2QG10JxNvewEEZPmZdDh6D0sf/tnMUzBEIPPcH36BiUnazvNaBu
         dGD+y6qu3QHr2Z1ROOJqMSd0D2UDk6pJFDWangp2t65TM0x63QSYKuBt34DLJ8bc5qTp
         ukkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DzwbDyo0Hifrmpg9+ONeHKqzLtXyM8pE1lBDo5DVPMc=;
        b=PUKo/iMy244FvQZCRVZE0vJAJLXiEUfnRMfTer1OTkL7sVUtqCUB5POZ8m0lHXKthC
         qP5TFF4GNqWlqgaUMjlmJR1r6BIi5Jt5XuPIzLGa13Hgt8nUIephVvE5bpZ4H3SHALKB
         ZNwy2ydvmugoQDtryLw0LJjCWAkVA9A9Fkfae7JOv9YvynxNBG4GZCFDDzgaYDmNe3dN
         rg1QRvel2WGwrZzuPGuUOsZlyU4yDutqm7ZgbtMm2GPGrvO2U0q/NZvYD/Ma7gE7EYJ2
         /sbCVS33NfB9+3X/SREtk4w56k+EedRXYpXRSv/0L9Ep7w1L98h5jD2ZMr8cBSd9pSmj
         O5BQ==
X-Gm-Message-State: AOAM530zbHyvFckJhsg9XmIs+sbnZKzzM8YdR3Zfd2CVhlfr4yiRXINw
        ulgftR5hvOuCsR/OYRjuPNbIE1mDtA==
X-Google-Smtp-Source: ABdhPJxWFnZevsrYERoSwR9lH+inlkqD12DIgqsRbXtECYa80tbEZbdVzosbj4+k9pdtoCDXP9U3YKF1EQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a05:6102:316e:b0:337:8a71:8ebf with SMTP id
 l14-20020a056102316e00b003378a718ebfmr2058089vsm.84.1653070516240; Fri, 20
 May 2022 11:15:16 -0700 (PDT)
Date:   Fri, 20 May 2022 18:14:58 +0000
In-Reply-To: <20220520181501.2159644-1-nhuck@google.com>
Message-Id: <20220520181501.2159644-7-nhuck@google.com>
Mime-Version: 1.0
References: <20220520181501.2159644-1-nhuck@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v9 6/9] crypto: arm64/aes-xctr: Improve readability of XCTR
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

Added some clarifying comments, changed the register allocations to make
the code clearer, and added register aliases.

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/aes-glue.c  |  16 +++
 arch/arm64/crypto/aes-modes.S | 237 ++++++++++++++++++++++++----------
 2 files changed, 185 insertions(+), 68 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index b6883288234c..162787c7aa86 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -464,6 +464,14 @@ static int __maybe_unused xctr_encrypt(struct skcipher_request *req)
 		u8 *dst = walk.dst.virt.addr;
 		u8 buf[AES_BLOCK_SIZE];
 
+		/*
+		 * If given less than 16 bytes, we must copy the partial block
+		 * into a temporary buffer of 16 bytes to avoid out of bounds
+		 * reads and writes.  Furthermore, this code is somewhat unusual
+		 * in that it expects the end of the data to be at the end of
+		 * the temporary buffer, rather than the start of the data at
+		 * the start of the temporary buffer.
+		 */
 		if (unlikely(nbytes < AES_BLOCK_SIZE))
 			src = dst = memcpy(buf + sizeof(buf) - nbytes,
 					   src, nbytes);
@@ -501,6 +509,14 @@ static int __maybe_unused ctr_encrypt(struct skcipher_request *req)
 		u8 *dst = walk.dst.virt.addr;
 		u8 buf[AES_BLOCK_SIZE];
 
+		/*
+		 * If given less than 16 bytes, we must copy the partial block
+		 * into a temporary buffer of 16 bytes to avoid out of bounds
+		 * reads and writes.  Furthermore, this code is somewhat unusual
+		 * in that it expects the end of the data to be at the end of
+		 * the temporary buffer, rather than the start of the data at
+		 * the start of the temporary buffer.
+		 */
 		if (unlikely(nbytes < AES_BLOCK_SIZE))
 			src = dst = memcpy(buf + sizeof(buf) - nbytes,
 					   src, nbytes);
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 9a027200bdba..5e0f0e51557c 100644
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
+	 * Set up the counter values in v0-v{MAX_STRIDE-1}.
+	 *
+	 * If we are encrypting less than MAX_STRIDE blocks, the tail block
+	 * handling code expects the last keystream block to be in
+	 * v{MAX_STRIDE-1}.  For example: if encrypting two blocks with
+	 * MAX_STRIDE=5, then v3 and v4 should have the next two counter blocks.
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
-ST5(		eor		x10, x10, x12			)
+		sub		x6, CTR, #MAX_STRIDE - 1
+		sub		x7, CTR, #MAX_STRIDE - 2
+		sub		x8, CTR, #MAX_STRIDE - 3
+		sub		x9, CTR, #MAX_STRIDE - 4
+ST5(		sub		x10, CTR, #MAX_STRIDE - 5	)
+		eor		x6, x6, IV_PART
+		eor		x7, x7, IV_PART
+		eor		x8, x8, IV_PART
+		eor		x9, x9, IV_PART
+ST5(		eor		x10, x10, IV_PART		)
 		mov		v0.d[0], x6
 		mov		v1.d[0], x7
 		mov		v2.d[0], x8
@@ -373,17 +401,32 @@ ST5(		mov		v4.d[0], x10			)
 	.else
 		bcs		0f
 		.subsection	1
-		/* apply carry to outgoing counter */
+		/*
+		 * This subsection handles carries.
+		 *
+		 * Conditional branching here is allowed with respect to time
+		 * invariance since the branches are dependent on the IV instead
+		 * of the plaintext or key.  This code is rarely executed in
+		 * practice anyway.
+		 */
+
+		/* Apply carry to outgoing counter. */
 0:		umov		x8, vctr.d[0]
 		rev		x8, x8
 		add		x8, x8, #1
 		rev		x8, x8
 		ins		vctr.d[0], x8
 
-		/* apply carry to N counter blocks for N := x12 */
-		cbz		x12, 2f
+		/*
+		 * Apply carry to counter blocks if needed.
+		 *
+		 * Since the carry flag was set, we know 0 <= IV_PART <
+		 * MAX_STRIDE.  Using the value of IV_PART we can determine how
+		 * many counter blocks need to be updated.
+		 */
+		cbz		IV_PART, 2f
 		adr		x16, 1f
-		sub		x16, x16, x12, lsl #3
+		sub		x16, x16, IV_PART, lsl #3
 		br		x16
 		bti		c
 		mov		v0.d[0], vctr.d[0]
@@ -398,71 +441,88 @@ ST5(		mov		v4.d[0], vctr.d[0]		)
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
+	 * If there are at least MAX_STRIDE blocks left, XOR the data with
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
+	 * This code expects the last keystream block to be in v{MAX_STRIDE-1}.
+	 * For example: if encrypting two blocks with MAX_STRIDE=5, then v3 and
+	 * v4 should have the next two counter blocks.
+	 *
+	 * This allows us to store the ciphertext by writing to overlapping
+	 * regions of memory.  Any invalid ciphertext blocks get overwritten by
+	 * correctly computed blocks.  This approach greatly simplifies the
+	 * logic for storing the ciphertext.
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
@@ -477,35 +537,70 @@ ST5(	eor		v7.16b, v7.16b, v2.16b		)
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
+	 *
+	 * This code always reads and writes 16 bytes.  To avoid out of bounds
+	 * accesses, XCTR and CTR modes must use a temporary buffer when
+	 * encrypting/decrypting less than 16 bytes.
+	 *
+	 * This code is unusual in that it loads the input and stores the output
+	 * relative to the end of the buffers rather than relative to the start.
+	 * This causes unusual behaviour when encrypting/decrypting less than 16
+	 * bytes; the end of the data is expected to be at the end of the
+	 * temporary buffer rather than the start of the data being at the start
+	 * of the temporary buffer.
+	 */
+	sub		x8, x7, #16
+	csel		x7, x7, x8, eq
+	add		IN, IN, x7
+	add		OUT, OUT, x7
+	ld1		{v5.16b}, [IN]
+	ld1		{v6.16b}, [OUT]
 ST5(	mov		v3.16b, v4.16b			)
-	encrypt_block	v3, w3, x2, x8, w7
-	ld1		{v10.16b-v11.16b}, [x12]
+	encrypt_block	v3, ROUNDS_W, KEY, x8, w7
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
 	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		   int bytes, u8 ctr[])
+	 *
+	 * The input and output buffers must always be at least 16 bytes even if
+	 * encrypting/decrypting less than 16 bytes.  Otherwise out of bounds
+	 * accesses will occur.  The data to be encrypted/decrypted is expected
+	 * to be at the end of this 16-byte temporary buffer rather than the
+	 * start.
 	 */
 
 AES_FUNC_START(aes_ctr_encrypt)
@@ -515,6 +610,12 @@ AES_FUNC_END(aes_ctr_encrypt)
 	/*
 	 * aes_xctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		   int bytes, u8 const iv[], int byte_ctr)
+	 *
+	 * The input and output buffers must always be at least 16 bytes even if
+	 * encrypting/decrypting less than 16 bytes.  Otherwise out of bounds
+	 * accesses will occur.  The data to be encrypted/decrypted is expected
+	 * to be at the end of this 16-byte temporary buffer rather than the
+	 * start.
 	 */
 
 AES_FUNC_START(aes_xctr_encrypt)
-- 
2.36.1.124.g0e6072fb45-goog

