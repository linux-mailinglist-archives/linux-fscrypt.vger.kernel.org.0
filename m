Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA97A52F265
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 May 2022 20:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352605AbiETSQO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 20 May 2022 14:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349754AbiETSPo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 20 May 2022 14:15:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125A6190D21
        for <linux-fscrypt@vger.kernel.org>; Fri, 20 May 2022 11:15:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 68-20020a250447000000b0064f83b0db7bso155247ybe.7
        for <linux-fscrypt@vger.kernel.org>; Fri, 20 May 2022 11:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wjq8mq0U/SoQnMxBMH9r4U2ga1h0e0FJA1pDEWv12f8=;
        b=rfZSRZ/mJ6ePvbBK2Kc3OXaW+79wiLEiCuTeRVm+n1VRcHkj9riZVukrK5FGxmagnu
         NpjXHgUtcRNsHZnJg1mdq5I0F8WKuhSkkyvfudWSd6gkipxpxYWiVGo55sWSeGro9f0H
         vradtaa0y+qVeXxJQVgaaHiO2b1jKALc/vJBZelCWJFaqIG9fHciN4RWsMdM3AfS+BHI
         LTJ9Nv1Z0qIHsOUcQDjFjvnOrcJMYksAPaYVWcFeAuO1YmCin7nrd67msumLFHRm+qEt
         QECdKsl5HhWfaHcOIOAXlkDUWJ/dEl2hkfcZ9p8uqTIbocl4bTN5MBSXOBsDcVMkvuLx
         0LSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wjq8mq0U/SoQnMxBMH9r4U2ga1h0e0FJA1pDEWv12f8=;
        b=JfIwroQvjh7bbWoY8hJBNsFzT3psJzYadphofuYTMTQKkl/HZxeHKRqM0s7HOeLwZC
         m4fUG/KBeQlM6N4oi7a78VMJEatTcazLwJbL4KenB9CrbGxlOGRqfop6JAekkk8bhTQo
         3TGzbh2QkIou9UzMGbCrbv4V2JpTa2VoEVUss3xHXO+eHLiUO1zStBJp9OXx0CmvuY8Q
         9XWJDPk4zn0Qb7a1ydA87QidFfFlNEusR1+LkiDV0jTHK2bzuystT7jNfSHVeXQNiH0O
         /uE0aAK0/1wEmlE3QffYWKEJsK8BBpOdEbstS4iJiJLXcOpTuyXIMW24atV59D8I7y4A
         g+fA==
X-Gm-Message-State: AOAM531GQDhjt9fjLzCbzlbI/5sA2PWarsQfEeJ4HFS3BGNA1jAXFAsO
        wpb0QNZgLC1NaqMuOq/MElJb7QMMoQ==
X-Google-Smtp-Source: ABdhPJz0Q/5e5iQHmXbI0+W9J1yV5tLjlLLNDNJPOEybWBGc+JFM6qwaGRLUj51jHGJZOMpn2mOAeH5eUw==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a81:2643:0:b0:2f4:c975:b7ca with SMTP id
 m64-20020a812643000000b002f4c975b7camr11016132ywm.494.1653070517717; Fri, 20
 May 2022 11:15:17 -0700 (PDT)
Date:   Fri, 20 May 2022 18:14:59 +0000
In-Reply-To: <20220520181501.2159644-1-nhuck@google.com>
Message-Id: <20220520181501.2159644-8-nhuck@google.com>
Mime-Version: 1.0
References: <20220520181501.2159644-1-nhuck@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v9 7/9] crypto: x86/polyval: Add PCLMULQDQ accelerated
 implementation of POLYVAL
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

Add hardware accelerated version of POLYVAL for x86-64 CPUs with
PCLMULQDQ support.

This implementation is accelerated using PCLMULQDQ instructions to
perform the finite field computations.  For added efficiency, 8 blocks
of the message are processed simultaneously by precomputing the first
8 powers of the key.

Schoolbook multiplication is used instead of Karatsuba multiplication
because it was found to be slightly faster on x86-64 machines.
Montgomery reduction must be used instead of Barrett reduction due to
the difference in modulus between POLYVAL's field and other finite
fields.

More information on POLYVAL can be found in the HCTR2 paper:
"Length-preserving encryption with HCTR2":
https://eprint.iacr.org/2021/1441.pdf

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/Makefile               |   3 +
 arch/x86/crypto/polyval-clmulni_asm.S  | 321 +++++++++++++++++++++++++
 arch/x86/crypto/polyval-clmulni_glue.c | 203 ++++++++++++++++
 crypto/Kconfig                         |   9 +
 crypto/polyval-generic.c               |  40 +++
 include/crypto/polyval.h               |   5 +
 6 files changed, 581 insertions(+)
 create mode 100644 arch/x86/crypto/polyval-clmulni_asm.S
 create mode 100644 arch/x86/crypto/polyval-clmulni_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 2831685adf6f..b9847152acd8 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -69,6 +69,9 @@ libblake2s-x86_64-y := blake2s-core.o blake2s-glue.o
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 
+obj-$(CONFIG_CRYPTO_POLYVAL_CLMUL_NI) += polyval-clmulni.o
+polyval-clmulni-y := polyval-clmulni_asm.o polyval-clmulni_glue.o
+
 obj-$(CONFIG_CRYPTO_CRC32C_INTEL) += crc32c-intel.o
 crc32c-intel-y := crc32c-intel_glue.o
 crc32c-intel-$(CONFIG_64BIT) += crc32c-pcl-intel-asm_64.o
diff --git a/arch/x86/crypto/polyval-clmulni_asm.S b/arch/x86/crypto/polyval-clmulni_asm.S
new file mode 100644
index 000000000000..a6ebe4e7dd2b
--- /dev/null
+++ b/arch/x86/crypto/polyval-clmulni_asm.S
@@ -0,0 +1,321 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright 2021 Google LLC
+ */
+/*
+ * This is an efficient implementation of POLYVAL using intel PCLMULQDQ-NI
+ * instructions. It works on 8 blocks at a time, by precomputing the first 8
+ * keys powers h^8, ..., h^1 in the POLYVAL finite field. This precomputation
+ * allows us to split finite field multiplication into two steps.
+ *
+ * In the first step, we consider h^i, m_i as normal polynomials of degree less
+ * than 128. We then compute p(x) = h^8m_0 + ... + h^1m_7 where multiplication
+ * is simply polynomial multiplication.
+ *
+ * In the second step, we compute the reduction of p(x) modulo the finite field
+ * modulus g(x) = x^128 + x^127 + x^126 + x^121 + 1.
+ *
+ * This two step process is equivalent to computing h^8m_0 + ... + h^1m_7 where
+ * multiplication is finite field multiplication. The advantage is that the
+ * two-step process  only requires 1 finite field reduction for every 8
+ * polynomial multiplications. Further parallelism is gained by interleaving the
+ * multiplications and polynomial reductions.
+ */
+
+#include <linux/linkage.h>
+#include <asm/frame.h>
+
+#define STRIDE_BLOCKS 8
+
+#define GSTAR %xmm7
+#define PL %xmm8
+#define PH %xmm9
+#define TMP_XMM %xmm11
+#define LO %xmm12
+#define HI %xmm13
+#define MI %xmm14
+#define SUM %xmm15
+
+#define KEY_POWERS %rdi
+#define MSG %rsi
+#define BLOCKS_LEFT %rdx
+#define ACCUMULATOR %rcx
+#define TMP %rax
+
+.section    .rodata.cst16.gstar, "aM", @progbits, 16
+.align 16
+
+.Lgstar:
+	.quad 0xc200000000000000, 0xc200000000000000
+
+.text
+
+/*
+ * Performs schoolbook1_iteration on two lists of 128-bit polynomials of length
+ * count pointed to by MSG and KEY_POWERS.
+ */
+.macro schoolbook1 count
+	.set i, 0
+	.rept (\count)
+		schoolbook1_iteration i 0
+		.set i, (i +1)
+	.endr
+.endm
+
+/*
+ * Computes the product of two 128-bit polynomials at the memory locations
+ * specified by (MSG + 16*i) and (KEY_POWERS + 16*i) and XORs the components of
+ * the 256-bit product into LO, MI, HI.
+ *
+ * Given:
+ *   X = [X_1 : X_0]
+ *   Y = [Y_1 : Y_0]
+ *
+ * We compute:
+ *   LO += X_0 * Y_0
+ *   MI += X_0 * Y_1 + X_1 * Y_0
+ *   HI += X_1 * Y_1
+ *
+ * Later, the 256-bit result can be extracted as:
+ *   [HI_1 : HI_0 + MI_1 : LO_1 + MI_0 : LO_0]
+ * This step is done when computing the polynomial reduction for efficiency
+ * reasons.
+ *
+ * If xor_sum == 1, then also XOR the value of SUM into m_0.  This avoids an
+ * extra multiplication of SUM and h^8.
+ */
+.macro schoolbook1_iteration i xor_sum
+	movups (16*\i)(MSG), %xmm0
+	.if (\i == 0 && \xor_sum == 1)
+		pxor SUM, %xmm0
+	.endif
+	vpclmulqdq $0x01, (16*\i)(KEY_POWERS), %xmm0, %xmm2
+	vpclmulqdq $0x00, (16*\i)(KEY_POWERS), %xmm0, %xmm1
+	vpclmulqdq $0x10, (16*\i)(KEY_POWERS), %xmm0, %xmm3
+	vpclmulqdq $0x11, (16*\i)(KEY_POWERS), %xmm0, %xmm4
+	vpxor %xmm2, MI, MI
+	vpxor %xmm1, LO, LO
+	vpxor %xmm4, HI, HI
+	vpxor %xmm3, MI, MI
+.endm
+
+/*
+ * Performs the same computation as schoolbook1_iteration, except we expect the
+ * arguments to already be loaded into xmm0 and xmm1 and we set the result
+ * registers LO, MI, and HI directly rather than XOR'ing into them.
+ */
+.macro schoolbook1_noload
+	vpclmulqdq $0x01, %xmm0, %xmm1, MI
+	vpclmulqdq $0x10, %xmm0, %xmm1, %xmm2
+	vpclmulqdq $0x00, %xmm0, %xmm1, LO
+	vpclmulqdq $0x11, %xmm0, %xmm1, HI
+	vpxor %xmm2, MI, MI
+.endm
+
+/*
+ * Computes the 256-bit polynomial represented by LO, HI, MI. Stores
+ * the result in PL, PH.
+ *   [PH : PL] = [HI_1 : HI_0 + MI_1 : LO_1 + MI_0 : LO_0]
+ */
+.macro schoolbook2
+	vpslldq $8, MI, PL
+	vpsrldq $8, MI, PH
+	pxor LO, PL
+	pxor HI, PH
+.endm
+
+/*
+ * Computes the 128-bit reduction of PH : PL. Stores the result in dest.
+ *
+ * This macro computes p(x) mod g(x) where p(x) is in montgomery form and g(x) =
+ * x^128 + x^127 + x^126 + x^121 + 1.
+ *
+ * We have a 256-bit polynomial PH : PL = P_3 : P_2 : P_1 : P_0 that is the
+ * product of two 128-bit polynomials in Montgomery form.  We need to reduce it
+ * mod g(x).  Also, since polynomials in Montgomery form have an "extra" factor
+ * of x^128, this product has two extra factors of x^128.  To get it back into
+ * Montgomery form, we need to remove one of these factors by dividing by x^128.
+ *
+ * To accomplish both of these goals, we add multiples of g(x) that cancel out
+ * the low 128 bits P_1 : P_0, leaving just the high 128 bits. Since the low
+ * bits are zero, the polynomial division by x^128 can be done by right shifting.
+ *
+ * Since the only nonzero term in the low 64 bits of g(x) is the constant term,
+ * the multiple of g(x) needed to cancel out P_0 is P_0 * g(x).  The CPU can
+ * only do 64x64 bit multiplications, so split P_0 * g(x) into x^128 * P_0 +
+ * x^64 * g*(x) * P_0 + P_0, where g*(x) is bits 64-127 of g(x).  Adding this to
+ * the original polynomial gives P_3 : P_2 + P_0 + T_1 : P_1 + T_0 : 0, where T
+ * = T_1 : T_0 = g*(x) * P_0.  Thus, bits 0-63 got "folded" into bits 64-191.
+ *
+ * Repeating this same process on the next 64 bits "folds" bits 64-127 into bits
+ * 128-255, giving the answer in bits 128-255. This time, we need to cancel P_1
+ * + T_0 in bits 64-127. The multiple of g(x) required is (P_1 + T_0) * g(x) *
+ * x^64. Adding this to our previous computation gives P_3 + P_1 + T_0 + V_1 :
+ * P_2 + P_0 + T_1 + V_0 : 0 : 0, where V = V_1 : V_0 = g*(x) * (P_1 + T_0).
+ *
+ * So our final computation is:
+ *   T = T_1 : T_0 = g*(x) * P_0
+ *   V = V_1 : V_0 = g*(x) * (P_1 + T_0)
+ *   p(x) / x^{128} mod g(x) = P_3 + P_1 + T_0 + V_1 : P_2 + P_0 + T_1 + V_0
+ *
+ * The implementation below saves a XOR instruction by computing P_1 + T_0 : P_0
+ * + T_1 and XORing into dest, rather than separately XORing P_1 : P_0 and T_0 :
+ * T_1 into dest.  This allows us to reuse P_1 + T_0 when computing V.
+ */
+.macro montgomery_reduction dest
+	vpclmulqdq $0x00, PL, GSTAR, TMP_XMM	# TMP_XMM = T_1 : T_0 = P_0 * g*(x)
+	pshufd $0b01001110, TMP_XMM, TMP_XMM	# TMP_XMM = T_0 : T_1
+	pxor PL, TMP_XMM			# TMP_XMM = P_1 + T_0 : P_0 + T_1
+	pxor TMP_XMM, PH			# PH = P_3 + P_1 + T_0 : P_2 + P_0 + T_1
+	pclmulqdq $0x11, GSTAR, TMP_XMM		# TMP_XMM = V_1 : V_0 = V = [(P_1 + T_0) * g*(x)]
+	vpxor TMP_XMM, PH, \dest
+.endm
+
+/*
+ * Compute schoolbook multiplication for 8 blocks
+ * m_0h^8 + ... + m_7h^1
+ *
+ * If reduce is set, also computes the montgomery reduction of the
+ * previous full_stride call and XORs with the first message block.
+ * (m_0 + REDUCE(PL, PH))h^8 + ... + m_7h^1.
+ * I.e., the first multiplication uses m_0 + REDUCE(PL, PH) instead of m_0.
+ */
+.macro full_stride reduce
+	pxor LO, LO
+	pxor HI, HI
+	pxor MI, MI
+
+	schoolbook1_iteration 7 0
+	.if \reduce
+		vpclmulqdq $0x00, PL, GSTAR, TMP_XMM
+	.endif
+
+	schoolbook1_iteration 6 0
+	.if \reduce
+		pshufd $0b01001110, TMP_XMM, TMP_XMM
+	.endif
+
+	schoolbook1_iteration 5 0
+	.if \reduce
+		pxor PL, TMP_XMM
+	.endif
+
+	schoolbook1_iteration 4 0
+	.if \reduce
+		pxor TMP_XMM, PH
+	.endif
+
+	schoolbook1_iteration 3 0
+	.if \reduce
+		pclmulqdq $0x11, GSTAR, TMP_XMM
+	.endif
+
+	schoolbook1_iteration 2 0
+	.if \reduce
+		vpxor TMP_XMM, PH, SUM
+	.endif
+
+	schoolbook1_iteration 1 0
+
+	schoolbook1_iteration 0 1
+
+	addq $(8*16), MSG
+	schoolbook2
+.endm
+
+/*
+ * Process BLOCKS_LEFT blocks, where 0 < BLOCKS_LEFT < STRIDE_BLOCKS
+ */
+.macro partial_stride
+	mov BLOCKS_LEFT, TMP
+	shlq $4, TMP
+	addq $(16*STRIDE_BLOCKS), KEY_POWERS
+	subq TMP, KEY_POWERS
+
+	movups (MSG), %xmm0
+	pxor SUM, %xmm0
+	movaps (KEY_POWERS), %xmm1
+	schoolbook1_noload
+	dec BLOCKS_LEFT
+	addq $16, MSG
+	addq $16, KEY_POWERS
+
+	test $4, BLOCKS_LEFT
+	jz .Lpartial4BlocksDone
+	schoolbook1 4
+	addq $(4*16), MSG
+	addq $(4*16), KEY_POWERS
+.Lpartial4BlocksDone:
+	test $2, BLOCKS_LEFT
+	jz .Lpartial2BlocksDone
+	schoolbook1 2
+	addq $(2*16), MSG
+	addq $(2*16), KEY_POWERS
+.Lpartial2BlocksDone:
+	test $1, BLOCKS_LEFT
+	jz .LpartialDone
+	schoolbook1 1
+.LpartialDone:
+	schoolbook2
+	montgomery_reduction SUM
+.endm
+
+/*
+ * Perform montgomery multiplication in GF(2^128) and store result in op1.
+ *
+ * Computes op1*op2*x^{-128} mod x^128 + x^127 + x^126 + x^121 + 1
+ * If op1, op2 are in montgomery form, this computes the montgomery
+ * form of op1*op2.
+ *
+ * void clmul_polyval_mul(u8 *op1, const u8 *op2);
+ */
+SYM_FUNC_START(clmul_polyval_mul)
+	FRAME_BEGIN
+	vmovdqa .Lgstar(%rip), GSTAR
+	movups (%rdi), %xmm0
+	movups (%rsi), %xmm1
+	schoolbook1_noload
+	schoolbook2
+	montgomery_reduction SUM
+	movups SUM, (%rdi)
+	FRAME_END
+	RET
+SYM_FUNC_END(clmul_polyval_mul)
+
+/*
+ * Perform polynomial evaluation as specified by POLYVAL.  This computes:
+ *	h^n * accumulator + h^n * m_0 + ... + h^1 * m_{n-1}
+ * where n=nblocks, h is the hash key, and m_i are the message blocks.
+ *
+ * rdi - pointer to precomputed key powers h^8 ... h^1
+ * rsi - pointer to message blocks
+ * rdx - number of blocks to hash
+ * rcx - pointer to the accumulator
+ *
+ * void clmul_polyval_update(const struct polyval_tfm_ctx *keys,
+ *	const u8 *in, size_t nblocks, u8 *accumulator);
+ */
+SYM_FUNC_START(clmul_polyval_update)
+	FRAME_BEGIN
+	vmovdqa .Lgstar(%rip), GSTAR
+	movups (ACCUMULATOR), SUM
+	subq $STRIDE_BLOCKS, BLOCKS_LEFT
+	js .LstrideLoopExit
+	full_stride 0
+	subq $STRIDE_BLOCKS, BLOCKS_LEFT
+	js .LstrideLoopExitReduce
+.LstrideLoop:
+	full_stride 1
+	subq $STRIDE_BLOCKS, BLOCKS_LEFT
+	jns .LstrideLoop
+.LstrideLoopExitReduce:
+	montgomery_reduction SUM
+.LstrideLoopExit:
+	add $STRIDE_BLOCKS, BLOCKS_LEFT
+	jz .LskipPartial
+	partial_stride
+.LskipPartial:
+	movups SUM, (ACCUMULATOR)
+	FRAME_END
+	RET
+SYM_FUNC_END(clmul_polyval_update)
diff --git a/arch/x86/crypto/polyval-clmulni_glue.c b/arch/x86/crypto/polyval-clmulni_glue.c
new file mode 100644
index 000000000000..b7664d018851
--- /dev/null
+++ b/arch/x86/crypto/polyval-clmulni_glue.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Glue code for POLYVAL using PCMULQDQ-NI
+ *
+ * Copyright (c) 2007 Nokia Siemens Networks - Mikko Herranen <mh1@iki.fi>
+ * Copyright (c) 2009 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ * Copyright 2021 Google LLC
+ */
+
+/*
+ * Glue code based on ghash-clmulni-intel_glue.c.
+ *
+ * This implementation of POLYVAL uses montgomery multiplication
+ * accelerated by PCLMULQDQ-NI to implement the finite field
+ * operations.
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
+#include <crypto/polyval.h>
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/cpu_device_id.h>
+#include <asm/simd.h>
+
+#define NUM_KEY_POWERS	8
+
+struct polyval_tfm_ctx {
+	/*
+	 * These powers must be in the order h^8, ..., h^1.
+	 */
+	u8 key_powers[NUM_KEY_POWERS][POLYVAL_BLOCK_SIZE];
+};
+
+struct polyval_desc_ctx {
+	u8 buffer[POLYVAL_BLOCK_SIZE];
+	u32 bytes;
+};
+
+asmlinkage void clmul_polyval_update(const struct polyval_tfm_ctx *keys,
+	const u8 *in, size_t nblocks, u8 *accumulator);
+asmlinkage void clmul_polyval_mul(u8 *op1, const u8 *op2);
+
+static void internal_polyval_update(const struct polyval_tfm_ctx *keys,
+	const u8 *in, size_t nblocks, u8 *accumulator)
+{
+	if (likely(crypto_simd_usable())) {
+		kernel_fpu_begin();
+		clmul_polyval_update(keys, in, nblocks, accumulator);
+		kernel_fpu_end();
+	} else {
+		polyval_update_non4k(keys->key_powers[NUM_KEY_POWERS-1], in,
+			nblocks, accumulator);
+	}
+}
+
+static void internal_polyval_mul(u8 *op1, const u8 *op2)
+{
+	if (likely(crypto_simd_usable())) {
+		kernel_fpu_begin();
+		clmul_polyval_mul(op1, op2);
+		kernel_fpu_end();
+	} else {
+		polyval_mul_non4k(op1, op2);
+	}
+}
+
+static int polyval_x86_setkey(struct crypto_shash *tfm,
+			const u8 *key, unsigned int keylen)
+{
+	struct polyval_tfm_ctx *tctx = crypto_shash_ctx(tfm);
+	int i;
+
+	if (keylen != POLYVAL_BLOCK_SIZE)
+		return -EINVAL;
+
+	memcpy(tctx->key_powers[NUM_KEY_POWERS-1], key, POLYVAL_BLOCK_SIZE);
+
+	for (i = NUM_KEY_POWERS-2; i >= 0; i--) {
+		memcpy(tctx->key_powers[i], key, POLYVAL_BLOCK_SIZE);
+		internal_polyval_mul(tctx->key_powers[i],
+				     tctx->key_powers[i+1]);
+	}
+
+	return 0;
+}
+
+static int polyval_x86_init(struct shash_desc *desc)
+{
+	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	memset(dctx, 0, sizeof(*dctx));
+
+	return 0;
+}
+
+static int polyval_x86_update(struct shash_desc *desc,
+			 const u8 *src, unsigned int srclen)
+{
+	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
+	const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	u8 *pos;
+	unsigned int nblocks;
+	unsigned int n;
+
+	if (dctx->bytes) {
+		n = min(srclen, dctx->bytes);
+		pos = dctx->buffer + POLYVAL_BLOCK_SIZE - dctx->bytes;
+
+		dctx->bytes -= n;
+		srclen -= n;
+
+		while (n--)
+			*pos++ ^= *src++;
+
+		if (!dctx->bytes)
+			internal_polyval_mul(dctx->buffer,
+					    tctx->key_powers[NUM_KEY_POWERS-1]);
+	}
+
+	while (srclen >= POLYVAL_BLOCK_SIZE) {
+		/* Allow rescheduling every 4K bytes. */
+		nblocks = min(srclen, 4096U) / POLYVAL_BLOCK_SIZE;
+		internal_polyval_update(tctx, src, nblocks, dctx->buffer);
+		srclen -= nblocks * POLYVAL_BLOCK_SIZE;
+		src += nblocks * POLYVAL_BLOCK_SIZE;
+	}
+
+	if (srclen) {
+		dctx->bytes = POLYVAL_BLOCK_SIZE - srclen;
+		pos = dctx->buffer;
+		while (srclen--)
+			*pos++ ^= *src++;
+	}
+
+	return 0;
+}
+
+static int polyval_x86_final(struct shash_desc *desc, u8 *dst)
+{
+	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
+	const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+
+	if (dctx->bytes) {
+		internal_polyval_mul(dctx->buffer,
+				     tctx->key_powers[NUM_KEY_POWERS-1]);
+	}
+
+	memcpy(dst, dctx->buffer, POLYVAL_BLOCK_SIZE);
+
+	return 0;
+}
+
+static struct shash_alg polyval_alg = {
+	.digestsize	= POLYVAL_DIGEST_SIZE,
+	.init		= polyval_x86_init,
+	.update		= polyval_x86_update,
+	.final		= polyval_x86_final,
+	.setkey		= polyval_x86_setkey,
+	.descsize	= sizeof(struct polyval_desc_ctx),
+	.base		= {
+		.cra_name		= "polyval",
+		.cra_driver_name	= "polyval-clmulni",
+		.cra_priority		= 200,
+		.cra_blocksize		= POLYVAL_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct polyval_tfm_ctx),
+		.cra_module		= THIS_MODULE,
+	},
+};
+
+__maybe_unused static const struct x86_cpu_id pcmul_cpu_id[] = {
+	X86_MATCH_FEATURE(X86_FEATURE_PCLMULQDQ, NULL),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, pcmul_cpu_id);
+
+static int __init polyval_clmulni_mod_init(void)
+{
+	if (!x86_match_cpu(pcmul_cpu_id))
+		return -ENODEV;
+
+	if (!boot_cpu_has(X86_FEATURE_AVX))
+		return -ENODEV;
+
+	return crypto_register_shash(&polyval_alg);
+}
+
+static void __exit polyval_clmulni_mod_exit(void)
+{
+	crypto_unregister_shash(&polyval_alg);
+}
+
+module_init(polyval_clmulni_mod_init);
+module_exit(polyval_clmulni_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("POLYVAL hash function accelerated by PCLMULQDQ-NI");
+MODULE_ALIAS_CRYPTO("polyval");
+MODULE_ALIAS_CRYPTO("polyval-clmulni");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index aa06af0e0ebe..e5ccc43b6775 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -787,6 +787,15 @@ config CRYPTO_POLYVAL
 	  POLYVAL is the hash function used in HCTR2.  It is not a general-purpose
 	  cryptographic hash function.
 
+config CRYPTO_POLYVAL_CLMUL_NI
+	tristate "POLYVAL hash function (CLMUL-NI accelerated)"
+	depends on X86 && 64BIT
+	select CRYPTO_POLYVAL
+	help
+	  This is the x86_64 CLMUL-NI accelerated implementation of POLYVAL. It is
+	  used to efficiently implement HCTR2 on x86-64 processors that support
+	  carry-less multiplication instructions.
+
 config CRYPTO_POLY1305
 	tristate "Poly1305 authenticator algorithm"
 	select CRYPTO_HASH
diff --git a/crypto/polyval-generic.c b/crypto/polyval-generic.c
index bf2b03b7bfc0..16bfa6925b31 100644
--- a/crypto/polyval-generic.c
+++ b/crypto/polyval-generic.c
@@ -76,6 +76,46 @@ static void copy_and_reverse(u8 dst[POLYVAL_BLOCK_SIZE],
 	put_unaligned(swab64(b), (u64 *)&dst[0]);
 }
 
+/*
+ * Performs multiplication in the POLYVAL field using the GHASH field as a
+ * subroutine.  This function is used as a fallback for hardware accelerated
+ * implementations when simd registers are unavailable.
+ *
+ * Note: This function is not used for polyval-generic, instead we use the 4k
+ * lookup table implementation for finite field multiplication.
+ */
+void polyval_mul_non4k(u8 *op1, const u8 *op2)
+{
+	be128 a, b;
+
+	// Assume one argument is in Montgomery form and one is not.
+	copy_and_reverse((u8 *)&a, op1);
+	copy_and_reverse((u8 *)&b, op2);
+	gf128mul_x_lle(&a, &a);
+	gf128mul_lle(&a, &b);
+	copy_and_reverse(op1, (u8 *)&a);
+}
+EXPORT_SYMBOL_GPL(polyval_mul_non4k);
+
+/*
+ * Perform a POLYVAL update using non4k multiplication.  This function is used
+ * as a fallback for hardware accelerated implementations when simd registers
+ * are unavailable.
+ *
+ * Note: This function is not used for polyval-generic, instead we use the 4k
+ * lookup table implementation of finite field multiplication.
+ */
+void polyval_update_non4k(const u8 *key, const u8 *in,
+			  size_t nblocks, u8 *accumulator)
+{
+	while (nblocks--) {
+		crypto_xor(accumulator, in, POLYVAL_BLOCK_SIZE);
+		polyval_mul_non4k(accumulator, key);
+		in += POLYVAL_BLOCK_SIZE;
+	}
+}
+EXPORT_SYMBOL_GPL(polyval_update_non4k);
+
 static int polyval_setkey(struct crypto_shash *tfm,
 			  const u8 *key, unsigned int keylen)
 {
diff --git a/include/crypto/polyval.h b/include/crypto/polyval.h
index b14c38aa9166..1d630f371f77 100644
--- a/include/crypto/polyval.h
+++ b/include/crypto/polyval.h
@@ -14,4 +14,9 @@
 #define POLYVAL_BLOCK_SIZE	16
 #define POLYVAL_DIGEST_SIZE	16
 
+void polyval_mul_non4k(u8 *op1, const u8 *op2);
+
+void polyval_update_non4k(const u8 *key, const u8 *in,
+			  size_t nblocks, u8 *accumulator);
+
 #endif
-- 
2.36.1.124.g0e6072fb45-goog

