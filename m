Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4925C5192B1
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 May 2022 02:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244569AbiEDAW0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 3 May 2022 20:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244568AbiEDAWW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 3 May 2022 20:22:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82639433A2
        for <linux-fscrypt@vger.kernel.org>; Tue,  3 May 2022 17:18:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h14-20020a25e20e000000b006484e4a1da2so16969576ybe.9
        for <linux-fscrypt@vger.kernel.org>; Tue, 03 May 2022 17:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kjQ9WRMvEuB+1hhhrADapNRIaOfe7R4HZIANbRC+kcc=;
        b=NOs+rW0RaYZV28s2vk4hkWq7CXcStd0UNbS8f9D6eL9ptMJpYhTmLbWJHvPHjc4tT+
         st0NjmX1NYyl9P5eKSliGW8XlgaVgRbBvCX8bS3rpOoBzMDB3gvVt9NPgd8mAQoaG41G
         k2F5w4/CRUC3xHYgpEsJeqiZY8XPp3AH0RokqIGXPNWhry2Q1sG1WuHsy2Bgt3/DWbFI
         +wQJ4MmaXk5/1s9BbDWebzwlRF8Y+4dW1haNPS7yJV5xdydUg5P//K2fp7A91yr97DEI
         +0RRV9n0SEu1/gqSRmHQvINolI0iEuzDrMSkI35shQZnYtfMwT17snjoKnvjEpFitl01
         b1hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kjQ9WRMvEuB+1hhhrADapNRIaOfe7R4HZIANbRC+kcc=;
        b=KYj9SQlGTzikkevQriW5FTIkXs5BxUZJTD1KOjM3WEUakxgpIiYT1bOywZAI9r9m4A
         rO02QVU5fDPFbcYdr2814KbsnADFc73XlyG5SVeTWaFhv9ZqpnlQ8wIyfO49PSeA03E0
         KxYXF/4Gtbmhr8orm9FXCRhMFJqkowu8qkPK6+qfxct6Ihci/J8Dx0sRLaFjaJ8Z/3Si
         kSs1tVlaMWnKKo8WDWF1HXojucTOVd8TDWQXennI8twP1oZ99wXvZ9Yh2+1fShQKK421
         NL4r/T3+K91Kj9eQS8+Ftynk2cn6BQ7GruPFtjzjCOfl1kJRXu+ZBEgsOvRcqUJrCYFL
         AX2A==
X-Gm-Message-State: AOAM531Cw5C9RYUBVTLRcUr31IN5X18HRDYFf5vArCfCr+2SeOTb6BXu
        AkzRoDACTurhfL78tvvzapjqgr52XA==
X-Google-Smtp-Source: ABdhPJyPvRqZbC8Wzm+/8NbIMc1vF6Zbbw1+apCQ2AClEqvOnpj3uUIxE7ffBS6Z3ZnGhyuhcrEHq+5SJQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a25:2e4c:0:b0:648:5380:dbbd with SMTP id
 b12-20020a252e4c000000b006485380dbbdmr16075829ybn.165.1651623526725; Tue, 03
 May 2022 17:18:46 -0700 (PDT)
Date:   Wed,  4 May 2022 00:18:18 +0000
In-Reply-To: <20220504001823.2483834-1-nhuck@google.com>
Message-Id: <20220504001823.2483834-5-nhuck@google.com>
Mime-Version: 1.0
References: <20220504001823.2483834-1-nhuck@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 4/9] crypto: x86/aesni-xctr: Add accelerated implementation
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

Add hardware accelerated versions of XCTR for x86-64 CPUs with AESNI
support.  These implementations are modified versions of the CTR
implementations found in aesni-intel_asm.S and aes_ctrby8_avx-x86_64.S.

More information on XCTR can be found in the HCTR2 paper:
"Length-preserving encryption with HCTR2":
https://eprint.iacr.org/2021/1441.pdf

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 232 ++++++++++++++++--------
 arch/x86/crypto/aesni-intel_glue.c      | 114 +++++++++++-
 crypto/Kconfig                          |   2 +-
 3 files changed, 266 insertions(+), 82 deletions(-)

diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
index 43852ba6e19c..2402b9418cd7 100644
--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -23,6 +23,11 @@
 
 #define VMOVDQ		vmovdqu
 
+/*
+ * Note: the "x" prefix in these aliases means "this is an xmm register".  The
+ * alias prefixes have no relation to XCTR where the "X" prefix means "XOR
+ * counter".
+ */
 #define xdata0		%xmm0
 #define xdata1		%xmm1
 #define xdata2		%xmm2
@@ -31,8 +36,10 @@
 #define xdata5		%xmm5
 #define xdata6		%xmm6
 #define xdata7		%xmm7
-#define xcounter	%xmm8
-#define xbyteswap	%xmm9
+#define xcounter	%xmm8	// CTR mode only
+#define xiv		%xmm8	// XCTR mode only
+#define xbyteswap	%xmm9	// CTR mode only
+#define xtmp		%xmm9	// XCTR mode only
 #define xkey0		%xmm10
 #define xkey4		%xmm11
 #define xkey8		%xmm12
@@ -45,7 +52,7 @@
 #define p_keys		%rdx
 #define p_out		%rcx
 #define num_bytes	%r8
-
+#define counter		%r9	// XCTR mode only
 #define tmp		%r10
 #define	DDQ_DATA	0
 #define	XDATA		1
@@ -102,7 +109,7 @@ ddq_add_8:
  * do_aes num_in_par load_keys key_len
  * This increments p_in, but not p_out
  */
-.macro do_aes b, k, key_len
+.macro do_aes b, k, key_len, xctr
 	.set by, \b
 	.set load_keys, \k
 	.set klen, \key_len
@@ -111,29 +118,48 @@ ddq_add_8:
 		vmovdqa	0*16(p_keys), xkey0
 	.endif
 
-	vpshufb	xbyteswap, xcounter, xdata0
-
-	.set i, 1
-	.rept (by - 1)
-		club XDATA, i
-		vpaddq	(ddq_add_1 + 16 * (i - 1))(%rip), xcounter, var_xdata
-		vptest	ddq_low_msk(%rip), var_xdata
-		jnz 1f
-		vpaddq	ddq_high_add_1(%rip), var_xdata, var_xdata
-		vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
-		1:
-		vpshufb	xbyteswap, var_xdata, var_xdata
-		.set i, (i +1)
-	.endr
+	.if \xctr
+		movq counter, xtmp
+		.set i, 0
+		.rept (by)
+			club XDATA, i
+			vpaddq	(ddq_add_1 + 16 * i)(%rip), xtmp, var_xdata
+			.set i, (i +1)
+		.endr
+		.set i, 0
+		.rept (by)
+			club	XDATA, i
+			vpxor	xiv, var_xdata, var_xdata
+			.set i, (i +1)
+		.endr
+	.else
+		vpshufb	xbyteswap, xcounter, xdata0
+		.set i, 1
+		.rept (by - 1)
+			club XDATA, i
+			vpaddq	(ddq_add_1 + 16 * (i - 1))(%rip), xcounter, var_xdata
+			vptest	ddq_low_msk(%rip), var_xdata
+			jnz 1f
+			vpaddq	ddq_high_add_1(%rip), var_xdata, var_xdata
+			vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
+			1:
+			vpshufb	xbyteswap, var_xdata, var_xdata
+			.set i, (i +1)
+		.endr
+	.endif
 
 	vmovdqa	1*16(p_keys), xkeyA
 
 	vpxor	xkey0, xdata0, xdata0
-	vpaddq	(ddq_add_1 + 16 * (by - 1))(%rip), xcounter, xcounter
-	vptest	ddq_low_msk(%rip), xcounter
-	jnz	1f
-	vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
-	1:
+	.if \xctr
+		add $by, counter
+	.else
+		vpaddq	(ddq_add_1 + 16 * (by - 1))(%rip), xcounter, xcounter
+		vptest	ddq_low_msk(%rip), xcounter
+		jnz	1f
+		vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
+		1:
+	.endif
 
 	.set i, 1
 	.rept (by - 1)
@@ -371,94 +397,99 @@ ddq_add_8:
 	.endr
 .endm
 
-.macro do_aes_load val, key_len
-	do_aes \val, 1, \key_len
+.macro do_aes_load val, key_len, xctr
+	do_aes \val, 1, \key_len, \xctr
 .endm
 
-.macro do_aes_noload val, key_len
-	do_aes \val, 0, \key_len
+.macro do_aes_noload val, key_len, xctr
+	do_aes \val, 0, \key_len, \xctr
 .endm
 
 /* main body of aes ctr load */
 
-.macro do_aes_ctrmain key_len
+.macro do_aes_ctrmain key_len, xctr
 	cmp	$16, num_bytes
-	jb	.Ldo_return2\key_len
+	jb	.Ldo_return2\xctr\key_len
 
-	vmovdqa	byteswap_const(%rip), xbyteswap
-	vmovdqu	(p_iv), xcounter
-	vpshufb	xbyteswap, xcounter, xcounter
+	.if \xctr
+		shr	$4, counter
+		vmovdqu	(p_iv), xiv
+	.else
+		vmovdqa	byteswap_const(%rip), xbyteswap
+		vmovdqu	(p_iv), xcounter
+		vpshufb	xbyteswap, xcounter, xcounter
+	.endif
 
 	mov	num_bytes, tmp
 	and	$(7*16), tmp
-	jz	.Lmult_of_8_blks\key_len
+	jz	.Lmult_of_8_blks\xctr\key_len
 
 	/* 1 <= tmp <= 7 */
 	cmp	$(4*16), tmp
-	jg	.Lgt4\key_len
-	je	.Leq4\key_len
+	jg	.Lgt4\xctr\key_len
+	je	.Leq4\xctr\key_len
 
-.Llt4\key_len:
+.Llt4\xctr\key_len:
 	cmp	$(2*16), tmp
-	jg	.Leq3\key_len
-	je	.Leq2\key_len
+	jg	.Leq3\xctr\key_len
+	je	.Leq2\xctr\key_len
 
-.Leq1\key_len:
-	do_aes_load	1, \key_len
+.Leq1\xctr\key_len:
+	do_aes_load	1, \key_len, \xctr
 	add	$(1*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
-.Leq2\key_len:
-	do_aes_load	2, \key_len
+.Leq2\xctr\key_len:
+	do_aes_load	2, \key_len, \xctr
 	add	$(2*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
 
-.Leq3\key_len:
-	do_aes_load	3, \key_len
+.Leq3\xctr\key_len:
+	do_aes_load	3, \key_len, \xctr
 	add	$(3*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
-.Leq4\key_len:
-	do_aes_load	4, \key_len
+.Leq4\xctr\key_len:
+	do_aes_load	4, \key_len, \xctr
 	add	$(4*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
-.Lgt4\key_len:
+.Lgt4\xctr\key_len:
 	cmp	$(6*16), tmp
-	jg	.Leq7\key_len
-	je	.Leq6\key_len
+	jg	.Leq7\xctr\key_len
+	je	.Leq6\xctr\key_len
 
-.Leq5\key_len:
-	do_aes_load	5, \key_len
+.Leq5\xctr\key_len:
+	do_aes_load	5, \key_len, \xctr
 	add	$(5*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
-.Leq6\key_len:
-	do_aes_load	6, \key_len
+.Leq6\xctr\key_len:
+	do_aes_load	6, \key_len, \xctr
 	add	$(6*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
-.Leq7\key_len:
-	do_aes_load	7, \key_len
+.Leq7\xctr\key_len:
+	do_aes_load	7, \key_len, \xctr
 	add	$(7*16), p_out
 	and	$(~7*16), num_bytes
-	jz	.Ldo_return2\key_len
-	jmp	.Lmain_loop2\key_len
+	jz	.Ldo_return2\xctr\key_len
+	jmp	.Lmain_loop2\xctr\key_len
 
-.Lmult_of_8_blks\key_len:
+.Lmult_of_8_blks\xctr\key_len:
 	.if (\key_len != KEY_128)
 		vmovdqa	0*16(p_keys), xkey0
 		vmovdqa	4*16(p_keys), xkey4
@@ -471,17 +502,19 @@ ddq_add_8:
 		vmovdqa	9*16(p_keys), xkey12
 	.endif
 .align 16
-.Lmain_loop2\key_len:
+.Lmain_loop2\xctr\key_len:
 	/* num_bytes is a multiple of 8 and >0 */
-	do_aes_noload	8, \key_len
+	do_aes_noload	8, \key_len, \xctr
 	add	$(8*16), p_out
 	sub	$(8*16), num_bytes
-	jne	.Lmain_loop2\key_len
+	jne	.Lmain_loop2\xctr\key_len
 
-.Ldo_return2\key_len:
-	/* return updated IV */
-	vpshufb	xbyteswap, xcounter, xcounter
-	vmovdqu	xcounter, (p_iv)
+.Ldo_return2\xctr\key_len:
+	.if !\xctr
+		/* return updated IV */
+		vpshufb	xbyteswap, xcounter, xcounter
+		vmovdqu	xcounter, (p_iv)
+	.endif
 	RET
 .endm
 
@@ -494,7 +527,7 @@ ddq_add_8:
  */
 SYM_FUNC_START(aes_ctr_enc_128_avx_by8)
 	/* call the aes main loop */
-	do_aes_ctrmain KEY_128
+	do_aes_ctrmain KEY_128 0
 
 SYM_FUNC_END(aes_ctr_enc_128_avx_by8)
 
@@ -507,7 +540,7 @@ SYM_FUNC_END(aes_ctr_enc_128_avx_by8)
  */
 SYM_FUNC_START(aes_ctr_enc_192_avx_by8)
 	/* call the aes main loop */
-	do_aes_ctrmain KEY_192
+	do_aes_ctrmain KEY_192 0
 
 SYM_FUNC_END(aes_ctr_enc_192_avx_by8)
 
@@ -520,6 +553,45 @@ SYM_FUNC_END(aes_ctr_enc_192_avx_by8)
  */
 SYM_FUNC_START(aes_ctr_enc_256_avx_by8)
 	/* call the aes main loop */
-	do_aes_ctrmain KEY_256
+	do_aes_ctrmain KEY_256 0
 
 SYM_FUNC_END(aes_ctr_enc_256_avx_by8)
+
+/*
+ * routine to do AES128 XCTR enc/decrypt "by8"
+ * XMM registers are clobbered.
+ * Saving/restoring must be done at a higher level
+ * aes_xctr_enc_128_avx_by8(const u8 *in, const u8 *iv, const void *keys,
+ * 	u8* out, unsigned int num_bytes, unsigned int byte_ctr)
+ */
+SYM_FUNC_START(aes_xctr_enc_128_avx_by8)
+	/* call the aes main loop */
+	do_aes_ctrmain KEY_128 1
+
+SYM_FUNC_END(aes_xctr_enc_128_avx_by8)
+
+/*
+ * routine to do AES192 XCTR enc/decrypt "by8"
+ * XMM registers are clobbered.
+ * Saving/restoring must be done at a higher level
+ * aes_xctr_enc_192_avx_by8(const u8 *in, const u8 *iv, const void *keys,
+ * 	u8* out, unsigned int num_bytes, unsigned int byte_ctr)
+ */
+SYM_FUNC_START(aes_xctr_enc_192_avx_by8)
+	/* call the aes main loop */
+	do_aes_ctrmain KEY_192 1
+
+SYM_FUNC_END(aes_xctr_enc_192_avx_by8)
+
+/*
+ * routine to do AES256 XCTR enc/decrypt "by8"
+ * XMM registers are clobbered.
+ * Saving/restoring must be done at a higher level
+ * aes_xctr_enc_256_avx_by8(const u8 *in, const u8 *iv, const void *keys,
+ * 	u8* out, unsigned int num_bytes, unsigned int byte_ctr)
+ */
+SYM_FUNC_START(aes_xctr_enc_256_avx_by8)
+	/* call the aes main loop */
+	do_aes_ctrmain KEY_256 1
+
+SYM_FUNC_END(aes_xctr_enc_256_avx_by8)
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 41901ba9d3a2..a5b0cb3efeba 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -135,6 +135,20 @@ asmlinkage void aes_ctr_enc_192_avx_by8(const u8 *in, u8 *iv,
 		void *keys, u8 *out, unsigned int num_bytes);
 asmlinkage void aes_ctr_enc_256_avx_by8(const u8 *in, u8 *iv,
 		void *keys, u8 *out, unsigned int num_bytes);
+
+
+asmlinkage void aes_xctr_enc_128_avx_by8(const u8 *in, const u8 *iv,
+	const void *keys, u8 *out, unsigned int num_bytes,
+	unsigned int byte_ctr);
+
+asmlinkage void aes_xctr_enc_192_avx_by8(const u8 *in, const u8 *iv,
+	const void *keys, u8 *out, unsigned int num_bytes,
+	unsigned int byte_ctr);
+
+asmlinkage void aes_xctr_enc_256_avx_by8(const u8 *in, const u8 *iv,
+	const void *keys, u8 *out, unsigned int num_bytes,
+	unsigned int byte_ctr);
+
 /*
  * asmlinkage void aesni_gcm_init_avx_gen2()
  * gcm_data *my_ctx_data, context data
@@ -527,6 +541,59 @@ static int ctr_crypt(struct skcipher_request *req)
 	return err;
 }
 
+static void aesni_xctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out,
+				   const u8 *in, unsigned int len, u8 *iv,
+				   unsigned int byte_ctr)
+{
+	if (ctx->key_length == AES_KEYSIZE_128)
+		aes_xctr_enc_128_avx_by8(in, iv, (void *)ctx, out, len,
+					 byte_ctr);
+	else if (ctx->key_length == AES_KEYSIZE_192)
+		aes_xctr_enc_192_avx_by8(in, iv, (void *)ctx, out, len,
+					 byte_ctr);
+	else
+		aes_xctr_enc_256_avx_by8(in, iv, (void *)ctx, out, len,
+					 byte_ctr);
+}
+
+static int xctr_crypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	u8 keystream[AES_BLOCK_SIZE];
+	struct skcipher_walk walk;
+	unsigned int nbytes;
+	unsigned int byte_ctr = 0;
+	int err;
+	__le32 block[AES_BLOCK_SIZE / sizeof(__le32)];
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	while ((nbytes = walk.nbytes) > 0) {
+		kernel_fpu_begin();
+		if (nbytes & AES_BLOCK_MASK)
+			aesni_xctr_enc_avx_tfm(ctx, walk.dst.virt.addr,
+				walk.src.virt.addr, nbytes & AES_BLOCK_MASK,
+				walk.iv, byte_ctr);
+		nbytes &= ~AES_BLOCK_MASK;
+		byte_ctr += walk.nbytes - nbytes;
+
+		if (walk.nbytes == walk.total && nbytes > 0) {
+			memcpy(block, walk.iv, AES_BLOCK_SIZE);
+			block[0] ^= cpu_to_le32(1 + byte_ctr / AES_BLOCK_SIZE);
+			aesni_enc(ctx, keystream, (u8 *)block);
+			crypto_xor_cpy(walk.dst.virt.addr + walk.nbytes -
+				       nbytes, walk.src.virt.addr + walk.nbytes
+				       - nbytes, keystream, nbytes);
+			byte_ctr += nbytes;
+			nbytes = 0;
+		}
+		kernel_fpu_end();
+		err = skcipher_walk_done(&walk, nbytes);
+	}
+	return err;
+}
+
 static int
 rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 {
@@ -1050,6 +1117,33 @@ static struct skcipher_alg aesni_skciphers[] = {
 static
 struct simd_skcipher_alg *aesni_simd_skciphers[ARRAY_SIZE(aesni_skciphers)];
 
+#ifdef CONFIG_X86_64
+/*
+ * XCTR does not have a non-AVX implementation, so it must be enabled
+ * conditionally.
+ */
+static struct skcipher_alg aesni_xctr = {
+	.base = {
+		.cra_name		= "__xctr(aes)",
+		.cra_driver_name	= "__xctr-aes-aesni",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_INTERNAL,
+		.cra_blocksize		= 1,
+		.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
+		.cra_module		= THIS_MODULE,
+	},
+	.min_keysize	= AES_MIN_KEY_SIZE,
+	.max_keysize	= AES_MAX_KEY_SIZE,
+	.ivsize		= AES_BLOCK_SIZE,
+	.chunksize	= AES_BLOCK_SIZE,
+	.setkey		= aesni_skcipher_setkey,
+	.encrypt	= xctr_crypt,
+	.decrypt	= xctr_crypt,
+};
+
+static struct simd_skcipher_alg *aesni_simd_xctr;
+#endif /* CONFIG_X86_64 */
+
 #ifdef CONFIG_X86_64
 static int generic_gcmaes_set_key(struct crypto_aead *aead, const u8 *key,
 				  unsigned int key_len)
@@ -1163,7 +1257,7 @@ static int __init aesni_init(void)
 		static_call_update(aesni_ctr_enc_tfm, aesni_ctr_enc_avx_tfm);
 		pr_info("AES CTR mode by8 optimization enabled\n");
 	}
-#endif
+#endif /* CONFIG_X86_64 */
 
 	err = crypto_register_alg(&aesni_cipher_alg);
 	if (err)
@@ -1180,8 +1274,22 @@ static int __init aesni_init(void)
 	if (err)
 		goto unregister_skciphers;
 
+#ifdef CONFIG_X86_64
+	if (boot_cpu_has(X86_FEATURE_AVX))
+		err = simd_register_skciphers_compat(&aesni_xctr, 1,
+						     &aesni_simd_xctr);
+	if (err)
+		goto unregister_aeads;
+#endif /* CONFIG_X86_64 */
+
 	return 0;
 
+#ifdef CONFIG_X86_64
+unregister_aeads:
+	simd_unregister_aeads(aesni_aeads, ARRAY_SIZE(aesni_aeads),
+				aesni_simd_aeads);
+#endif /* CONFIG_X86_64 */
+
 unregister_skciphers:
 	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
 				  aesni_simd_skciphers);
@@ -1197,6 +1305,10 @@ static void __exit aesni_exit(void)
 	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
 				  aesni_simd_skciphers);
 	crypto_unregister_alg(&aesni_cipher_alg);
+#ifdef CONFIG_X86_64
+	if (boot_cpu_has(X86_FEATURE_AVX))
+		simd_unregister_skciphers(&aesni_xctr, 1, &aesni_simd_xctr);
+#endif /* CONFIG_X86_64 */
 }
 
 late_initcall(aesni_init);
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0dedba74db4a..aa06af0e0ebe 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1161,7 +1161,7 @@ config CRYPTO_AES_NI_INTEL
 	  In addition to AES cipher algorithm support, the acceleration
 	  for some popular block cipher mode is supported too, including
 	  ECB, CBC, LRW, XTS. The 64 bit version has additional
-	  acceleration for CTR.
+	  acceleration for CTR and XCTR.
 
 config CRYPTO_AES_SPARC64
 	tristate "AES cipher algorithms (SPARC64)"
-- 
2.36.0.464.gb9c8b46e94-goog

