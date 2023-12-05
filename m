Return-Path: <linux-fscrypt+bounces-46-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 089898043BC
	for <lists+linux-fscrypt@lfdr.de>; Tue,  5 Dec 2023 02:05:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E27FF1C20BCB
	for <lists+linux-fscrypt@lfdr.de>; Tue,  5 Dec 2023 01:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C99D10E8;
	Tue,  5 Dec 2023 01:05:44 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C76116
	for <linux-fscrypt@vger.kernel.org>; Mon,  4 Dec 2023 17:05:26 -0800 (PST)
Received: from 210.104.33.70 (nsr.re.kr)
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
	by mail.nsr.re.kr with SMTP; Tue, 05 Dec 2023 10:03:54 +0900
X-Sender: letrehee@nsr.re.kr
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 438;
          Tue, 5 Dec 2023 10:03:49 +0900 (KST)
From: Dongsoo Lee <letrehee@nsr.re.kr>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, 
	Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Cc: linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongsoo Lee <letrhee@nsr.re.kr>
Subject: [PATCH v6 5/5] crypto: LEA block cipher x86_64 optimization
Date: Tue,  5 Dec 2023 01:03:29 +0000
Message-Id: <20231205010329.21996-6-letrehee@nsr.re.kr>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231205010329.21996-1-letrehee@nsr.re.kr>
References: <20231205010329.21996-1-letrehee@nsr.re.kr>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dongsoo Lee <letrhee@nsr.re.kr>

For the x86_64 environment, we use AVX-512F/AVX2/SSE2 instructions.
Since LEA uses 128-bit blocks of four 32-bit integers, for optimization,
SSE2 encrypts 4 blocks, AVX2 encrypts 4/8 blocks, and AVX-512F encrypts
4/8/16 blocks at a time.

Our submission provides a optimized implementation of ECB, CBC
decryption, CTR, and XTS cipher operation modes on x86_64 CPUs
supporting.

Signed-off-by: Dongsoo Lee <letrhee@nsr.re.kr>
---
 arch/x86/crypto/Kconfig           |   29 +
 arch/x86/crypto/Makefile          |    3 +
 arch/x86/crypto/lea-x86_64-asm.S  | 2272 +++++++++++++++++++++++++++++
 arch/x86/crypto/lea-x86_64-glue.c |  820 +++++++++++
 4 files changed, 3124 insertions(+)
 create mode 100644 arch/x86/crypto/lea-x86_64-asm.S
 create mode 100644 arch/x86/crypto/lea-x86_64-glue.c

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 9bbfd01cfa2f..5acd8794cab4 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -342,6 +342,35 @@ config CRYPTO_ARIA_GFNI_AVX512_X86_64
 
 	  Processes 64 blocks in parallel.
 
+config CRYPTO_LEA_X86_64
+	tristate "Ciphers: LEA with modes: ECB, CBC, CTR, XTS (SSE2/AVX2/AVX-512F)"
+	depends on X86 && 64BIT
+	select CRYPTO_LEA
+	imply CRYPTO_XTS
+	imply CRYPTO_CTR
+	help
+	  LEA is a 128-bit lightweight block cipher developed by South Korea.
+
+	  LEA is the a Korean standard (KS X 3246) and is included in the
+	  ISO/IEC 29192-2:2019 standard (Information security - Lightweight
+	  cryptography - Part 2: Block ciphers).
+
+	  It consists of 32-bit integer addition, rotation, and XOR, which can
+	  be performed effectively on CPUs that support 32-bit operations.
+
+	  It supports 128-bit, 192-bit, and 256-bit keys.
+
+	  See:
+	  https://seed.kisa.or.kr/kisa/algorithm/EgovLeaInfo.do
+
+	  Architecture: x86_64 using:
+	  - SSE2 (Streaming SIMD Extensions 2)
+	  - AVX2 (Advanced Vector Extensions)
+	  - AVX-512F (Advanced Vector Extensions-512F)
+
+	  Processes 4(SSE2, AVX2, AVX-512F), 8(AVX2, AVX-512F), 16(AVX-512F)
+	  blocks in parallel.
+
 config CRYPTO_CHACHA20_X86_64
 	tristate "Ciphers: ChaCha20, XChaCha20, XChaCha12 (SSSE3/AVX2/AVX-512VL)"
 	depends on X86 && 64BIT
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 9aa46093c91b..3c44d43d155d 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -109,6 +109,9 @@ aria-aesni-avx2-x86_64-y := aria-aesni-avx2-asm_64.o aria_aesni_avx2_glue.o
 obj-$(CONFIG_CRYPTO_ARIA_GFNI_AVX512_X86_64) += aria-gfni-avx512-x86_64.o
 aria-gfni-avx512-x86_64-y := aria-gfni-avx512-asm_64.o aria_gfni_avx512_glue.o
 
+obj-$(CONFIG_CRYPTO_LEA_X86_64) += lea-x86_64.o
+lea-x86_64-y := lea-x86_64-asm.o lea-x86_64-glue.o
+
 quiet_cmd_perlasm = PERLASM $@
       cmd_perlasm = $(PERL) $< > $@
 $(obj)/%.S: $(src)/%.pl FORCE
diff --git a/arch/x86/crypto/lea-x86_64-asm.S b/arch/x86/crypto/lea-x86_64-asm.S
new file mode 100644
index 000000000000..97e29e1158b8
--- /dev/null
+++ b/arch/x86/crypto/lea-x86_64-asm.S
@@ -0,0 +1,2272 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * LEA Cipher SSE2/AVX2/AVX-512F parallel algorithm.
+ *
+ * - SSE2: 4 parallel blocks
+ * - AVX2: 8/4 parallel blocks
+ * - AVX-512F: 16/8/4 parallel blocks
+ *
+ * Copyright (c) 2023 National Security Research.
+ * Author: Dongsoo Lee <letrhee@nsr.re.kr>
+ */
+
+#include <linux/linkage.h>
+#include <asm/frame.h>
+
+.file "lea_x86_64-asm.S"
+
+
+.section .text
+
+#define PASTE1(a,b) a##b
+
+#define LEA_MAX_KEYLENGTH (32 * 6 * 4)
+
+#define LEA_CTX_RK_ENC	(0)
+#define LEA_CTX_RK_DEC	(LEA_MAX_KEYLENGTH)
+#define LEA_CTX_ROUND	(LEA_MAX_KEYLENGTH * 2)
+
+#define LOAD_CTR(addr, high, low)	\
+	mov (addr), high;		\
+	mov 8(addr), low;		\
+	bswap high;			\
+	bswap low
+
+#define ADD_CTR_AND_STORE(high, low, addr, val)	\
+	add	val, low;			\
+	adc	$0, high;			\
+	bswap	high;				\
+	bswap	low;				\
+	mov	high, (addr);			\
+	mov	low, 8(addr)
+
+#define XTS_TW_X0	%xmm12
+#define XTS_TW_X1	%xmm13
+#define XTS_TW_I2	%xmm0
+#define XTS_TW_O2	%xmm14
+#define XTS_TW_X3	%xmm15
+#define XTS_TW_X4	%xmm8
+#define XTS_TW_X5	%xmm9
+#define XTS_TW_I6	%xmm1
+#define XTS_TW_O6	%xmm10
+#define XTS_TW_X7	%xmm11
+#define XTS_TW_X8	%xmm2
+#define XTS_MASK	%xmm7
+
+#define XTS_TW_Y0	%ymm12
+#define XTS_TW_Y1	%ymm13
+#define XTS_TW_Y2	%ymm14
+#define XTS_TW_Y3	%ymm15
+
+
+#define BSWAPMASK_XMM	%xmm7
+#define CTRCONST_XMM	%xmm8
+
+#define BSWAPMASK_YMM	%ymm7
+#define CTRCONST_YMM	%ymm8
+
+#define CTR_64_low_src	%rax
+#define CTR_64_high_src	%r9
+#define CTR_64_low	%r10
+#define CTR_64_high	%r11
+
+#define XMM(n)		PASTE1(%xmm, n)
+#define YMM(n)		PASTE1(%ymm, n)
+
+#ifdef CONFIG_AS_AVX512
+
+#define ZMM(n)		PASTE1(%zmm, n)
+
+#define XTS_TW_Z0	%zmm12
+#define XTS_TW_Z1	%zmm13
+#define XTS_TW_Z2	%zmm14
+#define XTS_TW_Z3	%zmm15
+
+#define BSWAPMASK_ZMM	%zmm7
+#define CTRCONST_ZMM	%zmm8
+
+#endif
+
+/* XOR, ADD, ROTR */
+#define XAR_SSE2(v0, v1, cur, pre, tmp1, tmp2, rk1, rk2)\
+	movd	rk1, tmp1;				\
+	movd	rk2, tmp2;				\
+	pshufd	$0, tmp1, tmp1;				\
+	pshufd	$0, tmp2, tmp2;				\
+	pxor	pre, tmp1;				\
+	pxor	tmp2, cur;				\
+	paddd	cur, tmp1;				\
+	movdqa	tmp1, cur;				\
+	psrld	v0, tmp1;				\
+	pslld	v1, cur;				\
+	pxor	tmp1, cur;
+
+#define XAR_AVX2(v0, v1, cur, pre, tmp1, tmp2, rk1, rk2)\
+	vpbroadcastd	rk1, tmp1;			\
+	vpbroadcastd	rk2, tmp2;			\
+	vpxor		pre, tmp1, tmp1;		\
+	vpxor		tmp2, cur, cur;			\
+	vpaddd		cur, tmp1, tmp1;		\
+	vpsrld		v0, tmp1, cur;			\
+	vpslld		v1, tmp1, tmp1;			\
+	vpxor		tmp1, cur, cur;
+
+#ifdef CONFIG_AS_AVX512
+#define XAR_AVX512(v0, _v1, cur, pre, tmp1, tmp2, rk1, rk2)	\
+	vpbroadcastd	rk1, tmp1;				\
+	vpbroadcastd	rk2, tmp2;				\
+	vpxord		pre, tmp1, tmp1;			\
+	vpxord		tmp2, cur, cur;				\
+	vpaddd		cur, tmp1, tmp1;			\
+	vprord		v0, tmp1, cur;
+#endif
+
+/* XOR, SUB, ROTR */
+#define XSR9_SSE2(v0, v3, tnext, tmp1, tmp2, rk1, rk2)	\
+	movd	rk1, tmp1;				\
+	movdqa	v0, tnext;				\
+	psrld	$9, v0;					\
+	pslld	$23, tnext;				\
+	pshufd	$0, tmp1, tmp1;				\
+	pxor	v0, tnext;				\
+	movd	rk2, v0;				\
+	pxor	v3, tmp1;				\
+	pshufd	$0, v0, v0;				\
+	psubd	tmp1, tnext;				\
+	pxor	tnext, v0;
+
+#define XSR5_SSE2(v1, tnext, tmp1, tmp2, rk1, rk2)	\
+	movd	rk1, tmp1;				\
+	pshufd	$0, tmp1, tmp1;				\
+	pxor	tnext, tmp1;				\
+	movdqa	v1, tnext;				\
+	psrld	$27, v1;				\
+	pslld	$5, tnext;				\
+	pxor	v1, tnext;				\
+	movd	rk2, v1;				\
+	pshufd	$0, v1, v1;				\
+	psubd	tmp1, tnext;				\
+	pxor	tnext, v1;
+
+#define XSR3_SSE2(v2, tnext, tmp1, tmp2, rk1, rk2)	\
+	movd	rk1, tmp1;				\
+	movdqa	v2, tmp2;				\
+	psrld	$29, v2;				\
+	pslld	$3, tmp2;				\
+	pshufd	$0, tmp1, tmp1;				\
+	pxor	tmp2, v2;				\
+	movd	rk2, tmp2;				\
+	pxor	tnext, tmp1;				\
+	pshufd	$0, tmp2, tmp2;				\
+	psubd	tmp1, v2;				\
+	pxor	tmp2, v2;
+
+#define XSR9_AVX2(v0, v3, tnext, tmp1, tmp2, rk1, rk2)	\
+	vpbroadcastd	rk1, tmp1;			\
+	vpsrld		$9, v0, tmp2;			\
+	vpslld		$23, v0, v0;			\
+	vpxor		v3, tmp1, tmp1;			\
+	vpxor		tmp2, v0, v0;			\
+	vpbroadcastd	rk2, tmp2;			\
+	vpsubd		tmp1, v0, tnext;		\
+	vpxor		tmp2, tnext, v0;
+
+#define XSR5_AVX2(v1, tnext, tmp1, tmp2, rk1, rk2)	\
+	vpbroadcastd	rk1, tmp1;			\
+	vpsrld		$27, v1, tmp2;			\
+	vpslld		$5, v1, v1;			\
+	vpxor		tnext, tmp1, tmp1;		\
+	vpxor		tmp2, v1, v1;			\
+	vpbroadcastd	rk2, tmp2;			\
+	vpsubd		tmp1, v1, tnext;		\
+	vpxor		tmp2, tnext, v1;
+
+#define XSR3_AVX2(v2, tnext, tmp1, tmp2, rk1, rk2)	\
+	vpbroadcastd	rk1, tmp1;			\
+	vpsrld		$29, v2, tmp2;			\
+	vpslld		$3, v2, v2;			\
+	vpxor		tnext, tmp1, tmp1;		\
+	vpxor		tmp2, v2, v2;			\
+	vpbroadcastd	rk2, tmp2;			\
+	vpsubd		tmp1, v2, v2;			\
+	vpxor		tmp2, v2, v2;
+
+#ifdef CONFIG_AS_AVX512
+#define XSR9_AVX512(v0, v3, tnext, tmp1, tmp2, rk1, rk2)\
+	vpbroadcastd	rk1, tmp1;			\
+	vpbroadcastd	rk2, tmp2;			\
+	vprord		$9, v0, v0;			\
+	vpxord		v3, tmp1, tmp1;			\
+	vpsubd		tmp1, v0, tnext;		\
+	vpxord		tmp2, tnext, v0
+
+#define XSR5_AVX512(v1, tnext, tmp1, tmp2, rk1, rk2)	\
+	vpbroadcastd	rk1, tmp1;			\
+	vpbroadcastd	rk2, tmp2;			\
+	vprold		$5, v1, v1;			\
+	vpxord		tnext, tmp1, tmp1;		\
+	vpsubd		tmp1, v1, tnext;		\
+	vpxord		tmp2, tnext, v1
+
+#define XSR3_AVX512(v2, tnext, tmp1, tmp2, rk1, rk2)	\
+	vpbroadcastd	rk1, tmp1;			\
+	vpbroadcastd	rk2, tmp2;			\
+	vprold		$3, v2, v2;			\
+	vpxord		tnext, tmp1, tmp1;		\
+	vpsubd		tmp1, v2, tnext;		\
+	vpxord		tmp2, tnext, v2
+#endif
+
+#define XAR3(SIMD, cur, pre, tmp1, tmp2, rk1, rk2)			\
+	PASTE1(XAR_,SIMD)($3, $29, cur, pre, tmp1, tmp2, rk1, rk2)
+
+#define XAR5(SIMD, cur, pre, tmp1, tmp2, rk1, rk2)			\
+	PASTE1(XAR_,SIMD)($5, $27, cur, pre, tmp1, tmp2, rk1, rk2)
+
+#define XAR9(SIMD, cur, pre, tmp1, tmp2, rk1, rk2)			\
+	PASTE1(XAR_,SIMD)($23, $9, cur, pre, tmp1, tmp2, rk1, rk2)
+
+#define XSR9(SIMD, v0, v3, tnext, tmp1, tmp2, rk1, rk2)			\
+	PASTE1(XSR9_,SIMD)(v0, v3, tnext, tmp1, tmp2, rk1, rk2)
+
+#define XSR5(SIMD, v1, tnext, tmp1, tmp2, rk1, rk2)			\
+	PASTE1(XSR5_,SIMD)(v1, tnext, tmp1, tmp2, rk1, rk2)
+
+#define XSR3(SIMD, v2, tnext, tmp1, tmp2, rk1, rk2)			\
+	PASTE1(XSR3_,SIMD)(v2, tnext, tmp1, tmp2, rk1, rk2)
+
+/* Could be replaced by the VPGATHERDD command,
+ * but was not used because it is known to have a non-optimized architecture.
+*/
+#define GATHER4_AVX2(i, j, mem)				\
+	vmovd	(j + 0 * 16)(mem), XMM(i);		\
+	vpinsrd $0x1, (j + 1 * 16)(mem), XMM(i), XMM(i);\
+	vpinsrd $0x2, (j + 2 * 16)(mem), XMM(i), XMM(i);\
+	vpinsrd $0x3, (j + 3 * 16)(mem), XMM(i), XMM(i);
+
+#define GATHER8_AVX2(i, ti, j, mem)					\
+	vmovd		(j + 0 * 16)(mem), XMM(i);			\
+	vpinsrd		$0x1, (j + 1 * 16)(mem), XMM(i), XMM(i);	\
+	vpinsrd		$0x2, (j + 2 * 16)(mem), XMM(i), XMM(i);	\
+	vpinsrd		$0x3, (j + 3 * 16)(mem), XMM(i), XMM(i);	\
+	vmovd		(j + 4 * 16)(mem), XMM(ti);			\
+	vpinsrd		$0x1, (j + 5 * 16)(mem), XMM(ti), XMM(ti);	\
+	vpinsrd		$0x2, (j + 6 * 16)(mem), XMM(ti), XMM(ti);	\
+	vpinsrd		$0x3, (j + 7 * 16)(mem), XMM(ti), XMM(ti);	\
+	vinserti128	$0x1, XMM(ti), YMM(i), YMM(i);
+
+#ifdef CONFIG_AS_AVX512
+#define GATHER16_AVX512(i, ti, j, mem)					\
+	vmovd		(j + 0 * 16)(mem), XMM(i);			\
+	vpinsrd		$0x1, (j + 1 * 16)(mem), XMM(i), XMM(i);	\
+	vpinsrd		$0x2, (j + 2 * 16)(mem), XMM(i), XMM(i);	\
+	vpinsrd		$0x3, (j + 3 * 16)(mem), XMM(i), XMM(i);	\
+	vmovd		(j + 4 * 16)(mem), XMM(ti);			\
+	vpinsrd		$0x1, (j + 5 * 16)(mem), XMM(ti), XMM(ti);	\
+	vpinsrd		$0x2, (j + 6 * 16)(mem), XMM(ti), XMM(ti);	\
+	vpinsrd		$0x3, (j + 7 * 16)(mem), XMM(ti), XMM(ti);	\
+	vinserti32x4	$0x1, XMM(ti), ZMM(i), ZMM(i);			\
+	vmovd		(j + 8 * 16)(mem), XMM(ti);			\
+	vpinsrd		$0x1, (j + 9 * 16)(mem), XMM(ti), XMM(ti);	\
+	vpinsrd		$0x2, (j + 10 * 16)(mem), XMM(ti), XMM(ti);	\
+	vpinsrd		$0x3, (j + 11 * 16)(mem), XMM(ti), XMM(ti);	\
+	vinserti32x4	$0x2, XMM(ti), ZMM(i), ZMM(i);			\
+	vmovd		(j + 12 * 16)(mem), XMM(ti);			\
+	vpinsrd		$0x1, (j + 13 * 16)(mem), XMM(ti), XMM(ti);	\
+	vpinsrd		$0x2, (j + 14 * 16)(mem), XMM(ti), XMM(ti);	\
+	vpinsrd		$0x3, (j + 15 * 16)(mem), XMM(ti), XMM(ti);	\
+	vinserti32x4	$0x3, XMM(ti), ZMM(i), ZMM(i);
+#endif
+
+#define GATHER_BLOCK4_AVX2(i0, i1, i2, i3, mem)	\
+	GATHER4_AVX2(i0, 0, mem);		\
+	GATHER4_AVX2(i1, 4, mem);		\
+	GATHER4_AVX2(i2, 8, mem);		\
+	GATHER4_AVX2(i3, 12, mem);
+
+#define GATHER_BLOCK8_AVX2(i0, i1, i2, i3, ti0, mem)	\
+	GATHER8_AVX2(i0, ti0, 0, mem);			\
+	GATHER8_AVX2(i1, ti0, 4, mem);			\
+	GATHER8_AVX2(i2, ti0, 8, mem);			\
+	GATHER8_AVX2(i3, ti0, 12, mem);
+
+#ifdef CONFIG_AS_AVX512
+#define GATHER_BLOCK8_AVX512(i0, i1, i2, i3, mask, mem) \
+	GATHER8_AVX512(i0, mask, 0, mem);		\
+	GATHER8_AVX512(i1, mask, 4, mem);		\
+	GATHER8_AVX512(i2, mask, 8, mem);		\
+	GATHER8_AVX512(i3, mask, 12, mem);
+
+#define GATHER_BLOCK16_AVX512(i0, i1, i2, i3, ti1, mem) \
+	GATHER16_AVX512(i0, ti1, 0, mem);		\
+	GATHER16_AVX512(i1, ti1, 4, mem);		\
+	GATHER16_AVX512(i2, ti1, 8, mem);		\
+	GATHER16_AVX512(i3, ti1, 12, mem);
+#endif
+
+#define SCATTER4_AVX2(i, j, mem) \
+	vpextrd $0x0, XMM(i), (j + 0 * 16)(mem);\
+	vpextrd $0x1, XMM(i), (j + 1 * 16)(mem);\
+	vpextrd $0x2, XMM(i), (j + 2 * 16)(mem);\
+	vpextrd $0x3, XMM(i), (j + 3 * 16)(mem);
+
+#define SCATTER8_AVX2(i, j, mem)		\
+	vpextrd $0x0, XMM(i), (j + 0 * 16)(mem);\
+	vpextrd $0x1, XMM(i), (j + 1 * 16)(mem);\
+	vpextrd $0x2, XMM(i), (j + 2 * 16)(mem);\
+	vpextrd $0x3, XMM(i), (j + 3 * 16)(mem);\
+	vextracti128 $0x1, YMM(i), XMM(i);	\
+	vpextrd $0x0, XMM(i), (j + 4 * 16)(mem);\
+	vpextrd $0x1, XMM(i), (j + 5 * 16)(mem);\
+	vpextrd $0x2, XMM(i), (j + 6 * 16)(mem);\
+	vpextrd $0x3, XMM(i), (j + 7 * 16)(mem);
+
+#ifdef CONFIG_AS_AVX512
+/* Could be replaced by the VPSCATTERDD command */
+#define SCATTER16_AVX512(i, ti, j, mem)			\
+	vpextrd $0x0, XMM(i), (j + 0 * 16)(mem);	\
+	vpextrd $0x1, XMM(i), (j + 1 * 16)(mem);	\
+	vpextrd $0x2, XMM(i), (j + 2 * 16)(mem);	\
+	vpextrd $0x3, XMM(i), (j + 3 * 16)(mem);	\
+	vextracti32x4 $0x1, ZMM(i), XMM(ti);		\
+	vpextrd $0x0, XMM(ti), (j + 4 * 16)(mem);	\
+	vpextrd $0x1, XMM(ti), (j + 5 * 16)(mem);	\
+	vpextrd $0x2, XMM(ti), (j + 6 * 16)(mem);	\
+	vpextrd $0x3, XMM(ti), (j + 7 * 16)(mem);	\
+	vextracti32x4 $0x2, ZMM(i), XMM(ti);		\
+	vpextrd $0x0, XMM(ti), (j + 8 * 16)(mem);	\
+	vpextrd $0x1, XMM(ti), (j + 9 * 16)(mem);	\
+	vpextrd $0x2, XMM(ti), (j + 10 * 16)(mem);	\
+	vpextrd $0x3, XMM(ti), (j + 11 * 16)(mem);	\
+	vextracti32x4 $0x3, ZMM(i), XMM(ti);		\
+	vpextrd $0x0, XMM(ti), (j + 12 * 16)(mem);	\
+	vpextrd $0x1, XMM(ti), (j + 13 * 16)(mem);	\
+	vpextrd $0x2, XMM(ti), (j + 14 * 16)(mem);	\
+	vpextrd $0x3, XMM(ti), (j + 15 * 16)(mem);
+#endif
+
+#define SCATTER_BLOCK4_AVX2(i0, i1, i2, i3, mem)\
+	SCATTER4_AVX2(i0, 0, mem);		\
+	SCATTER4_AVX2(i1, 4, mem);		\
+	SCATTER4_AVX2(i2, 8, mem);		\
+	SCATTER4_AVX2(i3, 12, mem);
+
+#define SCATTER_BLOCK8_AVX2(i0, i1, i2, i3, mem)\
+	SCATTER8_AVX2(i0, 0, mem);		\
+	SCATTER8_AVX2(i1, 4, mem);		\
+	SCATTER8_AVX2(i2, 8, mem);		\
+	SCATTER8_AVX2(i3, 12, mem);
+
+#ifdef CONFIG_AS_AVX512
+#define SCATTER_BLOCK16_AVX512(i0, i1, i2, i3, ti, mem) \
+	SCATTER16_AVX512(i0, ti, 0, mem);\
+	SCATTER16_AVX512(i1, ti, 4, mem);\
+	SCATTER16_AVX512(i2, ti, 8, mem);\
+	SCATTER16_AVX512(i3, ti, 12, mem);
+#endif
+
+#define LOAD_BLOCK4_SSE2(x0, x1, x2, x3, mem)	\
+	movdqu 0 * 16(mem), x0;			\
+	movdqu 1 * 16(mem), x1;			\
+	movdqu 2 * 16(mem), x2;			\
+	movdqu 3 * 16(mem), x3;
+
+#define LOAD_BLOCK4_AVX2(x0, x1, x2, x3, mem)	\
+	vmovdqu 0 * 16(mem), x0;		\
+	vmovdqu 1 * 16(mem), x1;		\
+	vmovdqu 2 * 16(mem), x2;		\
+	vmovdqu 3 * 16(mem), x3;
+
+#define STORE_BLOCK4_SSE2(x0, x1, x2, x3, mem)	\
+	movdqu x0, 0 * 16(mem);			\
+	movdqu x1, 1 * 16(mem);			\
+	movdqu x2, 2 * 16(mem);			\
+	movdqu x3, 3 * 16(mem);
+
+#define STORE_BLOCK4_AVX2(x0, x1, x2, x3, mem)	\
+	vmovdqu x0, 0 * 16(mem);		\
+	vmovdqu x1, 1 * 16(mem);		\
+	vmovdqu x2, 2 * 16(mem);		\
+	vmovdqu x3, 3 * 16(mem);
+
+#define TRANSPOSE_BLOCK4_SSE2(x0, x1, out_x2, x3, tmp, in_x2)	\
+	movdqa x0, out_x2;					\
+	movdqa in_x2, tmp;					\
+	punpckldq x1, x0;					\
+	punpckhdq x1, out_x2;					\
+	punpckldq x3, tmp;					\
+	punpckhdq x3, in_x2;					\
+								\
+	movdqa x0, x1;						\
+	movdqa out_x2, x3;					\
+	punpcklqdq tmp, x0;					\
+	punpckhqdq tmp, x1;					\
+	punpcklqdq in_x2, out_x2;				\
+	punpckhqdq in_x2, x3;
+
+#define TRANSPOSE_BLOCK4_AVX2(x0, x1, out_x2, x3, tmp, in_x2)	\
+	vpunpckhdq x1, x0, out_x2;				\
+	vpunpckldq x1, x0, x0;					\
+	vpunpckldq x3, in_x2, tmp;				\
+	vpunpckhdq x3, in_x2, in_x2;				\
+								\
+	vpunpckhqdq tmp, x0, x1;				\
+	vpunpcklqdq tmp, x0, x0;				\
+	vpunpckhqdq in_x2, out_x2, x3;				\
+	vpunpcklqdq in_x2, out_x2, out_x2;
+
+#define XOR_BLOCK3_SSE2(x0, x1, x2, mem)\
+	pxor 0 * 16(mem), x0;		\
+	pxor 1 * 16(mem), x1;		\
+	pxor 2 * 16(mem), x2;
+
+#define XOR_BLOCK3_AVX2(x0, x1, x2, mem)\
+	vpxor 0 * 16(mem), x0, x0;	\
+	vpxor 1 * 16(mem), x1, x1;	\
+	vpxor 2 * 16(mem), x2, x2;
+
+#define GEN_CTR_BLOCK_AVX2(x0, x1, x2, x3, xtmp, xcarry, bswapmask, ctrconst, ctr) \
+	vpbroadcastd (3 * 4)(ctr), x3;	\
+	vpbroadcastd (2 * 4)(ctr), x2;	\
+	vpbroadcastd (1 * 4)(ctr), x1;	\
+	vpbroadcastd (0 * 4)(ctr), x0;	\
+	vpshufb	bswapmask, x3, x3;	\
+	vpshufb	bswapmask, x2, x2;	\
+	vpshufb	bswapmask, x1, x1;	\
+	vpshufb	bswapmask, x0, x0;	\
+					\
+	vpaddd	ctrconst, x3, xtmp;	\
+	vpandn	x3, xtmp, xcarry;	\
+	vpsrld	$31, xcarry, xcarry;	\
+	vpshufb	bswapmask, xtmp, x3;	\
+					\
+	vpaddd	xcarry, x2, xtmp;	\
+	vpandn	x2, xtmp, xcarry;	\
+	vpsrld	$31, xcarry, xcarry;	\
+	vpshufb	bswapmask, xtmp, x2;	\
+					\
+	vpaddd	xcarry, x1, xtmp;	\
+	vpandn	x1, xtmp, xcarry;	\
+	vpsrld	$31, xcarry, xcarry;	\
+	vpshufb	bswapmask, xtmp, x1;	\
+					\
+	vpaddd	xcarry, x0, x0;		\
+	vpshufb	bswapmask, x0, x0;
+
+#ifdef CONFIG_AS_AVX512
+#define GEN_CTR_BLOCK_AVX512(x0, x1, x2, x3, xtmp, xcarry, bswapmask, ctrconst, ctr) \
+	vpbroadcastd	(3 * 4)(ctr), x3;	\
+	vpbroadcastd	(2 * 4)(ctr), x2;	\
+	vpbroadcastd	(1 * 4)(ctr), x1;	\
+	vpbroadcastd	(0 * 4)(ctr), x0;	\
+	vpshufb		bswapmask, x3, x3;	\
+	vpshufb		bswapmask, x2, x2;	\
+	vpshufb		bswapmask, x1, x1;	\
+	vpshufb		bswapmask, x0, x0;	\
+						\
+	vpaddd		ctrconst, x3, xtmp;	\
+	vpandnd		x3, xtmp, xcarry;	\
+	vpsrld		$0x1f, xcarry, xcarry;	\
+	vpshufb		bswapmask, xtmp, x3;	\
+						\
+	vpaddd		xcarry, x2, xtmp;	\
+	vpandnd		x2, xtmp, xcarry;	\
+	vpsrld		$0x1f, xcarry, xcarry;	\
+	vpshufb		bswapmask, xtmp, x2;	\
+						\
+	vpaddd		xcarry, x1, xtmp;	\
+	vpandnd		x1, xtmp, xcarry;	\
+	vpsrld		$0x1f, xcarry, xcarry;	\
+	vpshufb		bswapmask, xtmp, x1;	\
+						\
+	vpaddd		xcarry, x0, x0;		\
+	vpshufb		bswapmask, x0, x0;
+#endif
+
+#define LEA_1ROUND_ENC(SIMD, i0, i1, i2, i3, tmp1, tmp2, rk, rnd_num)	\
+	XAR3(SIMD, i3, i2, tmp1, tmp2,					\
+		(LEA_CTX_RK_ENC + ((rnd_num) * 6 + 4) * 4)(rk),		\
+		(LEA_CTX_RK_ENC + ((rnd_num) * 6 + 5) * 4)(rk));	\
+	XAR5(SIMD, i2, i1, tmp1, tmp2,					\
+		(LEA_CTX_RK_ENC + ((rnd_num) * 6 + 2) * 4)(rk),		\
+		(LEA_CTX_RK_ENC + ((rnd_num) * 6 + 3) * 4)(rk));	\
+	XAR9(SIMD, i1, i0, tmp1, tmp2,					\
+		(LEA_CTX_RK_ENC + ((rnd_num) * 6 + 0) * 4)(rk),		\
+		(LEA_CTX_RK_ENC + ((rnd_num) * 6 + 1) * 4)(rk))
+
+#define LEA_4ROUND_ENC(SIMD, i0, i1, i2, i3, tmp1, tmp2, rk, rnd_num)		\
+	LEA_1ROUND_ENC(SIMD, i0, i1, i2, i3, tmp1, tmp2, rk, rnd_num + 0);	\
+	LEA_1ROUND_ENC(SIMD, i1, i2, i3, i0, tmp1, tmp2, rk, rnd_num + 1);	\
+	LEA_1ROUND_ENC(SIMD, i2, i3, i0, i1, tmp1, tmp2, rk, rnd_num + 2);	\
+	LEA_1ROUND_ENC(SIMD, i3, i0, i1, i2, tmp1, tmp2, rk, rnd_num + 3)
+
+#define LEA_1ROUND_DEC(SIMD, i0, i1, i2, i3, tnext, tmp1, tmp2, rk, rnd_num)	\
+	XSR9(SIMD, i0, i3, tnext, tmp1, tmp2,					\
+		(LEA_CTX_RK_DEC + ((rnd_num) * 6 + 0) * 4)(rk),			\
+		(LEA_CTX_RK_DEC + ((rnd_num) * 6 + 1) * 4)(rk));		\
+	XSR5(SIMD, i1, tnext, tmp1, tmp2,					\
+		(LEA_CTX_RK_DEC + ((rnd_num) * 6 + 2) * 4)(rk), 		\
+		(LEA_CTX_RK_DEC + ((rnd_num) * 6 + 3) * 4)(rk));		\
+	XSR3(SIMD, i2, tnext, tmp1, tmp2,					\
+		(LEA_CTX_RK_DEC + ((rnd_num) * 6 + 4) * 4)(rk), 		\
+		(LEA_CTX_RK_DEC + ((rnd_num) * 6 + 5) * 4)(rk));
+
+#define LEA_4ROUND_DEC(SIMD, i0, i1, i2, i3, tnext, tmp1, tmp2, rk, rnd_num)	\
+	LEA_1ROUND_DEC(SIMD, i0, i1, i2, i3, tnext, tmp1, tmp2, rk, rnd_num + 0);\
+	LEA_1ROUND_DEC(SIMD, i3, i0, i1, i2, tnext, tmp1, tmp2, rk, rnd_num + 1);\
+	LEA_1ROUND_DEC(SIMD, i2, i3, i0, i1, tnext, tmp1, tmp2, rk, rnd_num + 2);\
+	LEA_1ROUND_DEC(SIMD, i1, i2, i3, i0, tnext, tmp1, tmp2, rk, rnd_num + 3);
+
+
+#define XTS_LOAD_TWEAK_MASK_SSE2(mask)			\
+	movdqa .Lxts_tweak_mask(%rip), mask
+
+#define XTS_LOAD_TWEAK_MASK_AVX2(mask)			\
+	vmovdqa .Lxts_tweak_mask(%rip), mask
+
+#define CBC_LOAD_SHUFFLE_MASK_AVX2(mask)		\
+	vmovdqa .Lcbc_shuffle_mask(%rip), mask
+
+#define LOAD_BSWAP_MASK_AVX2(mask)			\
+	vmovdqa .Lbswap_mask(%rip), mask
+
+#define LOAD_CTR_CONST_AVX2(val)			\
+	vmovdqa .Lctr_add_const(%rip), val
+
+#ifdef CONFIG_AS_AVX512
+
+#define CBC_LOAD_SHUFFLE_MASK_AVX512(mask)		\
+	vmovdqa64 .Lcbc_shuffle_mask16(%rip), mask
+
+#define LOAD_BSWAP_MASK_AVX512(mask)			\
+	vmovdqa64 .Lbswap_mask(%rip), mask
+
+#define LOAD_CTR_CONST_AVX512(val)			\
+	vmovdqa64 .Lctr_add_const(%rip), val
+
+#endif
+
+#define XTS_NEXT_TWEAK_1BLOCK_SSE2(out0, in0, tmp0, mask)	\
+	pshufd	$0x13, in0, tmp0;				\
+	movdqa	in0, out0;					\
+	psrad	$31, tmp0;					\
+	pand	mask, tmp0;					\
+	psllq	$1, out0; 					\
+	pxor	tmp0, out0;
+
+#define XTS_NEXT_TWEAK_1BLOCK_AVX2(out0, in0, tmp0, mask)	\
+	vpshufd	$0x13, in0, tmp0;				\
+	vpsrad	$31, tmp0, tmp0;				\
+	vpand	mask, tmp0, tmp0;				\
+	vpsllq	$1, in0, out0;					\
+	vpxor	tmp0, out0, out0;
+
+.align 8
+SYM_FUNC_START_LOCAL(__lea_x86_64_enc_4way_sse2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%xmm0..%xmm3: 4 plaintext blocks
+	 * output:
+	 *	%xmm0..%xmm3: 4 encrypted blocks
+	 * temporary:
+	 *	$xmm4..%xmm5
+	 */
+	LEA_4ROUND_ENC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 0);
+	LEA_4ROUND_ENC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 4);
+	LEA_4ROUND_ENC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 8);
+	LEA_4ROUND_ENC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 12);
+	LEA_4ROUND_ENC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 16);
+	LEA_4ROUND_ENC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 20);
+
+	cmpl $24, LEA_CTX_ROUND(%rdi);
+	je .Lenc4_sse2_done;
+	LEA_4ROUND_ENC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 24);
+
+	cmpl $28, LEA_CTX_ROUND(%rdi);
+	je .Lenc4_sse2_done;
+	LEA_4ROUND_ENC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 28);
+
+.Lenc4_sse2_done:
+	RET;
+SYM_FUNC_END(__lea_x86_64_enc_4way_sse2)
+
+.align 8
+SYM_FUNC_START_LOCAL(__lea_x86_64_dec_4way_sse2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%xmm0..%xmm3: 4 encrypted blocks
+	 * output:
+	 *	%xmm0..%xmm3: 4 plaintext blocks
+	 * temporary:
+	 *	$xmm4..%xmm6
+	 */
+	LEA_4ROUND_DEC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 0);
+	LEA_4ROUND_DEC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 4);
+	LEA_4ROUND_DEC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 8);
+	LEA_4ROUND_DEC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 12);
+	LEA_4ROUND_DEC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 16);
+	LEA_4ROUND_DEC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 20);
+
+	cmpl $24, LEA_CTX_ROUND(%rdi);
+	je .Ldec4_sse2_done;
+	LEA_4ROUND_DEC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 24);
+
+	cmpl $28, LEA_CTX_ROUND(%rdi);
+	je .Ldec4_sse2_done;
+	LEA_4ROUND_DEC(SSE2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 28);
+
+.Ldec4_sse2_done:
+	RET;
+SYM_FUNC_END(__lea_x86_64_dec_4way_sse2)
+
+.align 16
+SYM_FUNC_START_LOCAL(__lea_x86_64_enc_4way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%xmm0..%xmm3: 4 plaintext blocks
+	 * output:
+	 *	%xmm0..%xmm3: 4 encrypted blocks
+	 * temporary:
+	 *	$xmm4..%xmm5
+	 */
+	LEA_4ROUND_ENC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 0);
+	LEA_4ROUND_ENC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 4);
+	LEA_4ROUND_ENC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 8);
+	LEA_4ROUND_ENC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 12);
+	LEA_4ROUND_ENC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 16);
+	LEA_4ROUND_ENC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 20);
+
+	cmpl $24, LEA_CTX_ROUND(%rdi);
+	je .Lenc4_avx2_done;
+	LEA_4ROUND_ENC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 24);
+
+	cmpl $28, LEA_CTX_ROUND(%rdi);
+	je .Lenc4_avx2_done;
+	LEA_4ROUND_ENC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 28);
+
+.Lenc4_avx2_done:
+	RET;
+SYM_FUNC_END(__lea_x86_64_enc_4way_avx2)
+
+.align 16
+SYM_FUNC_START_LOCAL(__lea_x86_64_dec_4way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%xmm0..%xmm3: 4 encrypted blocks
+	 * output:
+	 *	%xmm0..%xmm3: 4 plaintext blocks
+	 * temporary:
+	 *	$xmm4..%xmm6
+	 */
+	LEA_4ROUND_DEC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 0);
+	LEA_4ROUND_DEC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 4);
+	LEA_4ROUND_DEC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 8);
+	LEA_4ROUND_DEC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 12);
+	LEA_4ROUND_DEC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 16);
+	LEA_4ROUND_DEC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 20);
+
+	cmpl $24, LEA_CTX_ROUND(%rdi);
+	je .Ldec4_avx2_done;
+	LEA_4ROUND_DEC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 24);
+
+	cmpl $28, LEA_CTX_ROUND(%rdi);
+	je .Ldec4_avx2_done;
+	LEA_4ROUND_DEC(AVX2, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 28);
+.Ldec4_avx2_done:
+	RET;
+SYM_FUNC_END(__lea_x86_64_dec_4way_avx2)
+
+.align 16
+SYM_FUNC_START_LOCAL(__lea_x86_64_enc_8way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%ymm0..%ymm3: 8 plaintext blocks
+	 * output:
+	 *	%ymm0..%ymm3: 8 encrypted blocks
+	 * temporary:
+	 *	$ymm4..%ymm5
+	 */
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 0);
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 4);
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 8);
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 12);
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 16);
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 20);
+
+	cmpl $24, LEA_CTX_ROUND(%rdi);
+	je .Lenc8_avx2_done;
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 24);
+
+	cmpl $28, LEA_CTX_ROUND(%rdi);
+	je .Lenc8_avx2_done;
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 28);
+
+.Lenc8_avx2_done:
+	RET;
+SYM_FUNC_END(__lea_x86_64_enc_8way_avx2)
+
+.align 16
+SYM_FUNC_START_LOCAL(__lea_x86_64_dec_8way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%ymm0..%ymm3: 8 encrypted blocks
+	 * output:
+	 *	%ymm0..%ymm3: 8 plaintext blocks
+	 * temporary:
+	 *	$ymm4..%ymm6
+	 */
+	LEA_4ROUND_DEC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 0);
+	LEA_4ROUND_DEC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 4);
+	LEA_4ROUND_DEC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 8);
+	LEA_4ROUND_DEC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 12);
+	LEA_4ROUND_DEC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 16);
+	LEA_4ROUND_DEC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 20);
+
+	cmpl $24, LEA_CTX_ROUND(%rdi);
+	je .Ldec8_avx2_done;
+	LEA_4ROUND_DEC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 24);
+
+	cmpl $28, LEA_CTX_ROUND(%rdi);
+	je .Ldec8_avx2_done;
+	LEA_4ROUND_DEC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 28);
+.Ldec8_avx2_done:
+	RET;
+SYM_FUNC_END(__lea_x86_64_dec_8way_avx2)
+
+#ifdef CONFIG_AS_AVX512
+.align 16
+SYM_FUNC_START_LOCAL(__lea_x86_64_enc_4way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%xmm0..%xmm3: 4 plaintext blocks
+	 * output:
+	 *	%xmm0..%xmm3: 4 encrypted blocks
+	 * temporary:
+	 *	$xmm4..%xmm5
+	 */
+	LEA_4ROUND_ENC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 0);
+	LEA_4ROUND_ENC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 4);
+	LEA_4ROUND_ENC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 8);
+	LEA_4ROUND_ENC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 12);
+	LEA_4ROUND_ENC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 16);
+	LEA_4ROUND_ENC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 20);
+
+	cmpl $24, LEA_CTX_ROUND(%rdi);
+	je .Lenc4_avx512_done;
+	LEA_4ROUND_ENC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 24);
+
+	cmpl $28, LEA_CTX_ROUND(%rdi);
+	je .Lenc4_avx512_done;
+	LEA_4ROUND_ENC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %rdi, 28);
+
+.Lenc4_avx512_done:
+	RET;
+SYM_FUNC_END(__lea_x86_64_enc_4way_avx512)
+
+.align 16
+SYM_FUNC_START_LOCAL(__lea_x86_64_dec_4way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%xmm0..%xmm3: 4 encrypted blocks
+	 * output:
+	 *	%xmm0..%xmm3: 4 plaintext blocks
+	 * temporary:
+	 *	$xmm4..%xmm6
+	 */
+	LEA_4ROUND_DEC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 0);
+	LEA_4ROUND_DEC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 4);
+	LEA_4ROUND_DEC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 8);
+	LEA_4ROUND_DEC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 12);
+	LEA_4ROUND_DEC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 16);
+	LEA_4ROUND_DEC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 20);
+
+	cmpl $24, LEA_CTX_ROUND(%rdi);
+	je .Ldec4_avx512_done;
+	LEA_4ROUND_DEC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 24);
+
+	cmpl $28, LEA_CTX_ROUND(%rdi);
+	je .Ldec4_avx512_done;
+	LEA_4ROUND_DEC(AVX512, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %rdi, 28);
+
+.Ldec4_avx512_done:
+	RET;
+SYM_FUNC_END(__lea_x86_64_dec_4way_avx512)
+
+.align 16
+SYM_FUNC_START_LOCAL(__lea_x86_64_enc_8way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%ymm0..%ymm3: 8 plaintext blocks
+	 * output:
+	 *	%ymm0..%ymm3: 8 encrypted blocks
+	 * temporary:
+	 *	$ymm4..%ymm5
+	 */
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 0);
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 4);
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 8);
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 12);
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 16);
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 20);
+
+	cmpl $24, LEA_CTX_ROUND(%rdi);
+	je .Lenc8_avx512_done;
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 24);
+
+	cmpl $28, LEA_CTX_ROUND(%rdi);
+	je .Lenc8_avx512_done;
+	LEA_4ROUND_ENC(AVX2, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %rdi, 28);
+
+.Lenc8_avx512_done:
+	RET;
+SYM_FUNC_END(__lea_x86_64_enc_8way_avx512)
+
+.align 16
+SYM_FUNC_START_LOCAL(__lea_x86_64_dec_8way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%ymm0..%ymm3: 8 encrypted blocks
+	 * output:
+	 *	%ymm0..%ymm3: 8 plaintext blocks
+	 * temporary:
+	 *	$ymm4..%ymm6
+	 */
+	LEA_4ROUND_DEC(AVX512, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 0);
+	LEA_4ROUND_DEC(AVX512, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 4);
+	LEA_4ROUND_DEC(AVX512, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 8);
+	LEA_4ROUND_DEC(AVX512, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 12);
+	LEA_4ROUND_DEC(AVX512, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 16);
+	LEA_4ROUND_DEC(AVX512, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 20);
+
+	cmpl $24, LEA_CTX_ROUND(%rdi);
+	je .Ldec8_avx512_done;
+	LEA_4ROUND_DEC(AVX512, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 24);
+
+	cmpl $28, LEA_CTX_ROUND(%rdi);
+	je .Ldec8_avx512_done;
+	LEA_4ROUND_DEC(AVX512, %ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %rdi, 28);
+.Ldec8_avx512_done:
+	RET;
+SYM_FUNC_END(__lea_x86_64_dec_8way_avx512)
+
+.align 16
+SYM_FUNC_START_LOCAL(__lea_x86_64_enc_16way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%zmm0..%zmm3: 16 plaintext blocks
+	 * output:
+	 *	%zmm0..%zmm3: 16 encrypted blocks
+	 * temporary:
+	 *	$zmm4..%zmm5
+	 */
+	LEA_4ROUND_ENC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %rdi, 0);
+	LEA_4ROUND_ENC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %rdi, 4);
+	LEA_4ROUND_ENC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %rdi, 8);
+	LEA_4ROUND_ENC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %rdi, 12);
+	LEA_4ROUND_ENC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %rdi, 16);
+	LEA_4ROUND_ENC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %rdi, 20);
+
+	cmpl $24, LEA_CTX_ROUND(%rdi);
+	je .Lenc16_avx512_done;
+	LEA_4ROUND_ENC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %rdi, 24);
+
+	cmpl $28, LEA_CTX_ROUND(%rdi);
+	je .Lenc16_avx512_done;
+	LEA_4ROUND_ENC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %rdi, 28);
+
+.Lenc16_avx512_done:
+	RET;
+SYM_FUNC_END(__lea_x86_64_enc_16way_avx512)
+
+.align 16
+SYM_FUNC_START_LOCAL(__lea_x86_64_dec_16way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%zmm0..%zmm3: 16 encrypted blocks
+	 * output:
+	 *	%zmm0..%zmm3: 16 plaintext blocks
+	 * temporary:
+	 *	$zmm4..%zmm6
+	 */
+	LEA_4ROUND_DEC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %zmm6, %rdi, 0);
+	LEA_4ROUND_DEC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %zmm6, %rdi, 4);
+	LEA_4ROUND_DEC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %zmm6, %rdi, 8);
+	LEA_4ROUND_DEC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %zmm6, %rdi, 12);
+	LEA_4ROUND_DEC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %zmm6, %rdi, 16);
+	LEA_4ROUND_DEC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %zmm6, %rdi, 20);
+
+	cmpl $24, LEA_CTX_ROUND(%rdi);
+	je .Ldec16_avx512_done;
+	LEA_4ROUND_DEC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %zmm6, %rdi, 24);
+
+	cmpl $28, LEA_CTX_ROUND(%rdi);
+	je .Ldec16_avx512_done;
+	LEA_4ROUND_DEC(AVX512, %zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5, %zmm6, %rdi, 28);
+.Ldec16_avx512_done:
+	RET;
+SYM_FUNC_END(__lea_x86_64_dec_16way_avx512)
+#endif
+
+SYM_FUNC_START(lea_x86_64_ecb_enc_4way_sse2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 */
+	FRAME_BEGIN
+
+	LOAD_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %rdx);
+	TRANSPOSE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5);
+
+	call __lea_x86_64_enc_4way_sse2
+
+	TRANSPOSE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %xmm4, %xmm2);
+	STORE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ecb_enc_4way_sse2)
+
+SYM_FUNC_START(lea_x86_64_ecb_enc_4way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 */
+	FRAME_BEGIN
+
+	GATHER_BLOCK4_AVX2(0, 1, 2, 3, %rdx);
+
+	call __lea_x86_64_enc_4way_avx2
+
+	SCATTER_BLOCK4_AVX2(0, 1, 2, 3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ecb_enc_4way_avx2)
+
+SYM_FUNC_START(lea_x86_64_ecb_enc_8way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (8 blocks)
+	 *	%rdx: src (8 blocks)
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	GATHER_BLOCK8_AVX2(0, 1, 2, 3, 4, %rdx);
+
+	call __lea_x86_64_enc_8way_avx2;
+
+	SCATTER_BLOCK8_AVX2(0, 1, 2, 3, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ecb_enc_8way_avx2)
+
+#ifdef CONFIG_AS_AVX512
+SYM_FUNC_START(lea_x86_64_ecb_enc_4way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 */
+	FRAME_BEGIN
+
+	GATHER_BLOCK4_AVX2(0, 1, 2, 3, %rdx);
+
+	call __lea_x86_64_enc_4way_avx512
+
+	SCATTER_BLOCK4_AVX2(0, 1, 2, 3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ecb_enc_4way_avx512)
+
+SYM_FUNC_START(lea_x86_64_ecb_enc_8way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (8 blocks)
+	 *	%rdx: src (8 blocks)
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	GATHER_BLOCK8_AVX2(0, 1, 2, 3, 4, %rdx);
+
+	call __lea_x86_64_enc_8way_avx512;
+
+	SCATTER_BLOCK8_AVX2(0, 1, 2, 3, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ecb_enc_8way_avx512)
+
+SYM_FUNC_START(lea_x86_64_ecb_enc_16way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	GATHER_BLOCK16_AVX512(0, 1, 2, 3, 4, %rdx);
+
+	call __lea_x86_64_enc_16way_avx512;
+
+	SCATTER_BLOCK16_AVX512(0, 1, 2, 3, 4, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ecb_enc_16way_avx512)
+#endif
+
+SYM_FUNC_START(lea_x86_64_ecb_dec_4way_sse2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 */
+	FRAME_BEGIN
+
+	LOAD_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %rdx);
+	TRANSPOSE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5);
+
+	call __lea_x86_64_dec_4way_sse2
+
+	TRANSPOSE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %xmm4, %xmm2);
+	STORE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ecb_dec_4way_sse2)
+
+SYM_FUNC_START(lea_x86_64_ecb_dec_4way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 */
+	FRAME_BEGIN
+
+	GATHER_BLOCK4_AVX2(0, 1, 2, 3, %rdx);
+
+	call __lea_x86_64_dec_4way_avx2
+
+	SCATTER_BLOCK4_AVX2(0, 1, 2, 3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ecb_dec_4way_avx2)
+
+SYM_FUNC_START(lea_x86_64_ecb_dec_8way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (8 blocks)
+	 *	%rdx: src (8 blocks)
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	GATHER_BLOCK8_AVX2(0, 1, 2, 3, 4, %rdx);
+
+	call __lea_x86_64_dec_8way_avx2
+
+	SCATTER_BLOCK8_AVX2(0, 1, 2, 3, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ecb_dec_8way_avx2)
+
+#ifdef CONFIG_AS_AVX512
+SYM_FUNC_START(lea_x86_64_ecb_dec_4way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 */
+	FRAME_BEGIN
+
+	GATHER_BLOCK4_AVX2(0, 1, 2, 3, %rdx);
+
+	call __lea_x86_64_dec_4way_avx512
+
+	SCATTER_BLOCK4_AVX2(0, 1, 2, 3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ecb_dec_4way_avx512)
+
+SYM_FUNC_START(lea_x86_64_ecb_dec_8way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (8 blocks)
+	 *	%rdx: src (8 blocks)
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	GATHER_BLOCK8_AVX2(0, 1, 2, 3, 4, %rdx);
+
+	call __lea_x86_64_dec_8way_avx512
+
+	SCATTER_BLOCK8_AVX2(0, 1, 2, 3, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ecb_dec_8way_avx512)
+
+SYM_FUNC_START(lea_x86_64_ecb_dec_16way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	GATHER_BLOCK16_AVX512(0, 1, 2, 3, 4, %rdx);
+
+	call __lea_x86_64_dec_16way_avx512
+
+	SCATTER_BLOCK16_AVX512(0, 1, 2, 3, 4, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ecb_dec_16way_avx512)
+#endif
+
+SYM_FUNC_START(lea_x86_64_cbc_dec_4way_sse2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 */
+	FRAME_BEGIN
+
+	LOAD_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %rdx);
+	TRANSPOSE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5);
+
+	call __lea_x86_64_dec_4way_sse2
+
+	TRANSPOSE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %xmm4, %xmm2);
+	XOR_BLOCK3_SSE2(%xmm1, %xmm5, %xmm3, %rdx);
+	STORE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_cbc_dec_4way_sse2)
+
+SYM_FUNC_START(lea_x86_64_cbc_dec_4way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 */
+	FRAME_BEGIN
+
+	GATHER_BLOCK4_AVX2(0, 1, 2, 3, %rdx);
+
+	call __lea_x86_64_dec_4way_avx2
+
+	TRANSPOSE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %xmm4, %xmm2);
+	XOR_BLOCK3_AVX2(%xmm1, %xmm5, %xmm3, %rdx);
+	STORE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_cbc_dec_4way_avx2)
+
+SYM_FUNC_START(lea_x86_64_cbc_dec_8way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (8 blocks)
+	 *	%rdx: src (8 blocks)
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	GATHER_BLOCK8_AVX2(0, 1, 2, 3, 4, %rdx);
+
+	CBC_LOAD_SHUFFLE_MASK_AVX2(%ymm7);
+	vpxor %ymm4, %ymm4, %ymm4;
+
+	vpermd %ymm0, %ymm7, %ymm8;
+	vpermd %ymm1, %ymm7, %ymm9;
+	vpermd %ymm2, %ymm7, %ymm10;
+	vpermd %ymm3, %ymm7, %ymm11;
+
+	vpblendd $0x1, %ymm4, %ymm8, %ymm8;
+	vpblendd $0x1, %ymm4, %ymm9, %ymm9;
+	vpblendd $0x1, %ymm4, %ymm10, %ymm10;
+	vpblendd $0x1, %ymm4, %ymm11, %ymm11;
+
+	call __lea_x86_64_dec_8way_avx2
+
+	vpxor %ymm8, %ymm0, %ymm0;
+	vpxor %ymm9, %ymm1, %ymm1;
+	vpxor %ymm10, %ymm2, %ymm2;
+	vpxor %ymm11, %ymm3, %ymm3;
+
+	SCATTER_BLOCK8_AVX2(0, 1, 2, 3, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_cbc_dec_8way_avx2)
+
+#ifdef CONFIG_AS_AVX512
+SYM_FUNC_START(lea_x86_64_cbc_dec_4way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 */
+	FRAME_BEGIN
+
+	GATHER_BLOCK4_AVX2(0, 1, 2, 3, %rdx);
+
+	call __lea_x86_64_dec_4way_avx512
+
+	TRANSPOSE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %xmm4, %xmm2);
+	XOR_BLOCK3_AVX2(%xmm1, %xmm5, %xmm3, %rdx);
+	STORE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_cbc_dec_4way_avx512)
+
+SYM_FUNC_START(lea_x86_64_cbc_dec_8way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (8 blocks)
+	 *	%rdx: src (8 blocks)
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	GATHER_BLOCK8_AVX2(0, 1, 2, 3, 4, %rdx);
+
+	CBC_LOAD_SHUFFLE_MASK_AVX2(%ymm7);
+	vpxor %ymm4, %ymm4, %ymm4;
+
+	vpermd %ymm0, %ymm7, %ymm8;
+	vpermd %ymm1, %ymm7, %ymm9;
+	vpermd %ymm2, %ymm7, %ymm10;
+	vpermd %ymm3, %ymm7, %ymm11;
+
+	vpblendd $0x1, %ymm4, %ymm8, %ymm8;
+	vpblendd $0x1, %ymm4, %ymm9, %ymm9;
+	vpblendd $0x1, %ymm4, %ymm10, %ymm10;
+	vpblendd $0x1, %ymm4, %ymm11, %ymm11;
+
+	call __lea_x86_64_dec_8way_avx512
+
+	vpxor %ymm8, %ymm0, %ymm0;
+	vpxor %ymm9, %ymm1, %ymm1;
+	vpxor %ymm10, %ymm2, %ymm2;
+	vpxor %ymm11, %ymm3, %ymm3;
+
+	SCATTER_BLOCK8_AVX2(0, 1, 2, 3, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_cbc_dec_8way_avx512)
+
+SYM_FUNC_START(lea_x86_64_cbc_dec_16way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	GATHER_BLOCK16_AVX512(0, 1, 2, 3, 4, %rdx);
+
+	CBC_LOAD_SHUFFLE_MASK_AVX512(%zmm7);
+	vpxord %zmm4, %zmm4, %zmm4;
+
+	mov $0x1, %eax;
+	kmovw %eax, %k1;
+
+	vpermd %zmm0, %zmm7, %zmm8;
+	vpermd %zmm1, %zmm7, %zmm9;
+	vpermd %zmm2, %zmm7, %zmm10;
+	vpermd %zmm3, %zmm7, %zmm11;
+
+	vpblendmd %zmm4, %zmm8, %zmm8{%k1};
+	vpblendmd %zmm4, %zmm9, %zmm9{%k1};
+	vpblendmd %zmm4, %zmm10, %zmm10{%k1};
+	vpblendmd %zmm4, %zmm11, %zmm11{%k1};
+
+	call __lea_x86_64_dec_16way_avx512
+
+	vpxord %zmm8, %zmm0, %zmm0;
+	vpxord %zmm9, %zmm1, %zmm1;
+	vpxord %zmm10, %zmm2, %zmm2;
+	vpxord %zmm11, %zmm3, %zmm3;
+
+	SCATTER_BLOCK16_AVX512(0, 1, 2, 3, 4, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_cbc_dec_16way_avx512)
+#endif
+
+SYM_FUNC_START(lea_x86_64_ctr_enc_4way_sse2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 *	%rcx: ctr
+	 * temporary:
+	 *	CTR_64_high_src(%r9)
+	 *	CTR_64_low_src(%rax)
+	 *	CTR_64_high(%r11)
+	 *	CTR_64_low(%r10)
+	 */
+	FRAME_BEGIN
+
+	mov (%rcx), CTR_64_high_src;
+	mov 8(%rcx), CTR_64_low_src;
+	bswap CTR_64_high_src;
+	bswap CTR_64_low_src;
+
+	movdqu (%rcx), %xmm0;
+	mov CTR_64_low_src, CTR_64_low;
+	mov CTR_64_high_src, CTR_64_high;
+	ADD_CTR_AND_STORE(CTR_64_high, CTR_64_low, %rcx, $1);
+	movdqu (%rcx), %xmm1;
+	mov CTR_64_low_src, CTR_64_low;
+	mov CTR_64_high_src, CTR_64_high;
+	ADD_CTR_AND_STORE(CTR_64_high, CTR_64_low, %rcx, $2);
+	movdqu (%rcx), %xmm5;
+	mov CTR_64_low_src, CTR_64_low;
+	mov CTR_64_high_src, CTR_64_high;
+	ADD_CTR_AND_STORE(CTR_64_high, CTR_64_low, %rcx, $3);
+	movdqu (%rcx), %xmm3;
+	mov CTR_64_low_src, CTR_64_low;
+	mov CTR_64_high_src, CTR_64_high;
+	ADD_CTR_AND_STORE(CTR_64_high, CTR_64_low, %rcx, $4);
+
+	TRANSPOSE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5);
+	LOAD_BLOCK4_SSE2(%xmm7, %xmm8, %xmm9, %xmm10, %rdx);
+
+	call __lea_x86_64_enc_4way_sse2;
+
+	TRANSPOSE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %xmm4, %xmm2);
+
+	pxor %xmm7, %xmm0;
+	pxor %xmm8, %xmm1;
+	pxor %xmm9, %xmm5;
+	pxor %xmm10, %xmm3;
+
+	STORE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ctr_enc_4way_sse2)
+
+SYM_FUNC_START(lea_x86_64_ctr_enc_4way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 *	%rcx: ctr
+	 * temporary:
+	 *	%r9
+	 *	%rax
+	 */
+	FRAME_BEGIN
+
+	LOAD_BSWAP_MASK_AVX2(BSWAPMASK_XMM);
+	LOAD_CTR_CONST_AVX2(CTRCONST_XMM);
+
+	GEN_CTR_BLOCK_AVX2(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5,
+				BSWAPMASK_XMM, CTRCONST_XMM, %rcx);
+
+	LOAD_CTR(%rcx, %r9, %rax);
+	ADD_CTR_AND_STORE(%r9, %rax, %rcx, $4);
+
+	GATHER_BLOCK4_AVX2(7, 8, 9, 10, %rdx);
+
+	call __lea_x86_64_enc_4way_avx2;
+
+	vpxor %ymm7, %ymm0, %ymm0;
+	vpxor %ymm8, %ymm1, %ymm1;
+	vpxor %ymm9, %ymm2, %ymm2;
+	vpxor %ymm10, %ymm3, %ymm3;
+
+	SCATTER_BLOCK4_AVX2(0, 1, 2, 3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ctr_enc_4way_avx2)
+
+SYM_FUNC_START(lea_x86_64_ctr_enc_8way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (8 blocks)
+	 *	%rdx: src (8 blocks)
+	 *	%rcx: ctr
+	 * temporary:
+	 *	%r9
+	 *	%rax
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+
+	LOAD_BSWAP_MASK_AVX2(BSWAPMASK_YMM);
+	LOAD_CTR_CONST_AVX2(CTRCONST_YMM);
+
+	GEN_CTR_BLOCK_AVX2(%ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5,
+				BSWAPMASK_YMM, CTRCONST_YMM, %rcx);
+	LOAD_CTR(%rcx, %r9, %rax);
+	ADD_CTR_AND_STORE(%r9, %rax, %rcx, $8);
+
+	GATHER_BLOCK8_AVX2(7, 8, 9, 10, 4, %rdx);
+
+	call __lea_x86_64_enc_8way_avx2;
+
+	vpxor %ymm7, %ymm0, %ymm0;
+	vpxor %ymm8, %ymm1, %ymm1;
+	vpxor %ymm9, %ymm2, %ymm2;
+	vpxor %ymm10, %ymm3, %ymm3;
+
+	SCATTER_BLOCK8_AVX2(0, 1, 2, 3, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ctr_enc_8way_avx2)
+
+#ifdef CONFIG_AS_AVX512
+SYM_FUNC_START(lea_x86_64_ctr_enc_4way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 *	%rcx: ctr
+	 * temporary:
+	 *	%r9
+	 *	%rax
+	 */
+	FRAME_BEGIN
+
+	LOAD_BSWAP_MASK_AVX2(BSWAPMASK_XMM);
+	LOAD_CTR_CONST_AVX2(CTRCONST_XMM);
+
+	GEN_CTR_BLOCK_AVX2(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5,
+				BSWAPMASK_XMM, CTRCONST_XMM, %rcx);
+
+	LOAD_CTR(%rcx, %r9, %rax);
+	ADD_CTR_AND_STORE(%r9, %rax, %rcx, $4);
+
+	GATHER_BLOCK4_AVX2(7, 8, 9, 10, %rdx);
+
+	call __lea_x86_64_enc_4way_avx512;
+
+	vpxor %ymm7, %ymm0, %ymm0;
+	vpxor %ymm8, %ymm1, %ymm1;
+	vpxor %ymm9, %ymm2, %ymm2;
+	vpxor %ymm10, %ymm3, %ymm3;
+
+	SCATTER_BLOCK4_AVX2(0, 1, 2, 3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ctr_enc_4way_avx512)
+
+SYM_FUNC_START(lea_x86_64_ctr_enc_8way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (8 blocks)
+	 *	%rdx: src (8 blocks)
+	 *	%rcx: ctr
+	 * temporary:
+	 *	%r9
+	 *	%rax
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+
+	LOAD_BSWAP_MASK_AVX2(BSWAPMASK_YMM);
+	LOAD_CTR_CONST_AVX2(CTRCONST_YMM);
+
+	GEN_CTR_BLOCK_AVX2(%ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5,
+				BSWAPMASK_YMM, CTRCONST_YMM, %rcx);
+	LOAD_CTR(%rcx, %r9, %rax);
+	ADD_CTR_AND_STORE(%r9, %rax, %rcx, $8);
+
+	GATHER_BLOCK8_AVX2(7, 8, 9, 10, 4, %rdx);
+
+	call __lea_x86_64_enc_8way_avx512;
+
+	vpxor %ymm7, %ymm0, %ymm0;
+	vpxor %ymm8, %ymm1, %ymm1;
+	vpxor %ymm9, %ymm2, %ymm2;
+	vpxor %ymm10, %ymm3, %ymm3;
+
+	SCATTER_BLOCK8_AVX2(0, 1, 2, 3, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ctr_enc_8way_avx512)
+
+SYM_FUNC_START(lea_x86_64_ctr_enc_16way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 *	%rcx: ctr
+	 * temporary:
+	 *	%r9
+	 *	%rax
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+
+	LOAD_BSWAP_MASK_AVX512(BSWAPMASK_ZMM);
+	LOAD_CTR_CONST_AVX512(CTRCONST_ZMM);
+
+	GEN_CTR_BLOCK_AVX512(%zmm0, %zmm1, %zmm2, %zmm3, %zmm4, %zmm5,
+				BSWAPMASK_ZMM, CTRCONST_ZMM, %rcx);
+	LOAD_CTR(%rcx, %r9, %rax);
+	ADD_CTR_AND_STORE(%r9, %rax, %rcx, $16);
+
+	GATHER_BLOCK16_AVX512(8, 9, 10, 11, 4, %rdx);
+
+	call __lea_x86_64_enc_16way_avx512;
+
+	vpxord %zmm8, %zmm0, %zmm0;
+	vpxord %zmm9, %zmm1, %zmm1;
+	vpxord %zmm10, %zmm2, %zmm2;
+	vpxord %zmm11, %zmm3, %zmm3;
+
+	SCATTER_BLOCK16_AVX512(0, 1, 2, 3, 4, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_ctr_enc_16way_avx512)
+#endif
+
+SYM_FUNC_START(lea_x86_64_xts_enc_4way_sse2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 *	%rcx: tweak
+	 */
+	FRAME_BEGIN
+
+	LOAD_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %rdx);
+	movdqu (%rcx), XTS_TW_X0;
+	XTS_LOAD_TWEAK_MASK_SSE2(XTS_MASK);
+	pxor XTS_TW_X0, %xmm0;
+	XTS_NEXT_TWEAK_1BLOCK_SSE2(XTS_TW_X1, XTS_TW_X0, %xmm4, XTS_MASK);
+	pxor XTS_TW_X1, %xmm1;
+	XTS_NEXT_TWEAK_1BLOCK_SSE2(XTS_TW_O2, XTS_TW_X1, %xmm4, XTS_MASK);
+	pxor XTS_TW_O2, %xmm5;
+	XTS_NEXT_TWEAK_1BLOCK_SSE2(XTS_TW_X3, XTS_TW_O2, %xmm4, XTS_MASK);
+	pxor XTS_TW_X3, %xmm3;
+
+	TRANSPOSE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5);
+
+	call __lea_x86_64_enc_4way_sse2;
+
+	TRANSPOSE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %xmm4, %xmm2);
+
+	pxor XTS_TW_X0, %xmm0;
+	pxor XTS_TW_X1, %xmm1;
+	pxor XTS_TW_O2, %xmm5;
+	pxor XTS_TW_X3, %xmm3;
+
+	XTS_NEXT_TWEAK_1BLOCK_SSE2(XTS_TW_X0, XTS_TW_X3, %xmm4, XTS_MASK);
+	movdqu XTS_TW_X0, (%rcx);
+	STORE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_xts_enc_4way_sse2)
+
+SYM_FUNC_START(lea_x86_64_xts_enc_4way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 *	%rcx: tweak
+	 */
+	FRAME_BEGIN
+
+	LOAD_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %rdx);
+	vmovdqu (%rcx), XTS_TW_X0;
+	XTS_LOAD_TWEAK_MASK_AVX2(XTS_MASK);
+	vpxor XTS_TW_X0, %xmm0, %xmm0;
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X1, XTS_TW_X0, %xmm4, XTS_MASK);
+	vpxor XTS_TW_X1, %xmm1, %xmm1;
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_O2, XTS_TW_X1, %xmm4, XTS_MASK);
+	vpxor XTS_TW_O2, %xmm5, %xmm5;
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X3, XTS_TW_O2, %xmm4, XTS_MASK);
+	vpxor XTS_TW_X3, %xmm3, %xmm3;
+
+
+	TRANSPOSE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5);
+
+	call __lea_x86_64_enc_4way_avx2
+
+	TRANSPOSE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %xmm4, %xmm2);
+
+	vpxor XTS_TW_X0, %xmm0, %xmm0;
+	vpxor XTS_TW_X1, %xmm1, %xmm1;
+	vpxor XTS_TW_O2, %xmm5, %xmm5;
+	vpxor XTS_TW_X3, %xmm3, %xmm3;
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X0, XTS_TW_X3, %xmm4, XTS_MASK);
+	vmovdqu XTS_TW_X0, (%rcx);
+	STORE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_xts_enc_4way_avx2)
+
+SYM_FUNC_START(lea_x86_64_xts_enc_8way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (8 blocks)
+	 *	%rdx: src (8 blocks)
+	 *	%rcx: tweak
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	vmovdqu (%rcx), XTS_TW_X0;
+	XTS_LOAD_TWEAK_MASK_AVX2(XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X1, XTS_TW_X0, %xmm6, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I2, XTS_TW_X1, %xmm6, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X3, XTS_TW_I2, %xmm6, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X4, XTS_TW_X3, %xmm6, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X5, XTS_TW_X4, %xmm6, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I6, XTS_TW_X5, %xmm6, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X7, XTS_TW_I6, %xmm6, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X8, XTS_TW_X7, %xmm6, XTS_MASK);
+	vmovdqu XTS_TW_X8, (%rcx);
+
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X0, XTS_TW_X1, XTS_TW_O2, XTS_TW_X3, %xmm5, XTS_TW_I2);
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X4, XTS_TW_X5, XTS_TW_O6, XTS_TW_X7, %xmm5, XTS_TW_I6);
+
+	vinserti128 $0x1, XTS_TW_X4, XTS_TW_Y0, XTS_TW_Y0;
+	vinserti128 $0x1, XTS_TW_X5, XTS_TW_Y1, XTS_TW_Y1;
+	vinserti128 $0x1, XTS_TW_O6, XTS_TW_Y2, XTS_TW_Y2;
+	vinserti128 $0x1, XTS_TW_X7, XTS_TW_Y3, XTS_TW_Y3;
+
+	GATHER_BLOCK8_AVX2(0, 1, 2, 3, 4, %rdx);
+
+	vpxor XTS_TW_Y0, %ymm0, %ymm0;
+	vpxor XTS_TW_Y1, %ymm1, %ymm1;
+	vpxor XTS_TW_Y2, %ymm2, %ymm2;
+	vpxor XTS_TW_Y3, %ymm3, %ymm3;
+
+	call __lea_x86_64_enc_8way_avx2
+
+	vpxor XTS_TW_Y0, %ymm0, %ymm0;
+	vpxor XTS_TW_Y1, %ymm1, %ymm1;
+	vpxor XTS_TW_Y2, %ymm2, %ymm2;
+	vpxor XTS_TW_Y3, %ymm3, %ymm3;
+
+	SCATTER_BLOCK8_AVX2(0, 1, 2, 3, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_xts_enc_8way_avx2)
+
+#ifdef CONFIG_AS_AVX512
+SYM_FUNC_START(lea_x86_64_xts_enc_4way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 *	%rcx: tweak
+	 */
+	FRAME_BEGIN
+
+	LOAD_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %rdx);
+	vmovdqu (%rcx), XTS_TW_X0;
+	XTS_LOAD_TWEAK_MASK_AVX2(XTS_MASK);
+	vpxor XTS_TW_X0, %xmm0, %xmm0;
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X1, XTS_TW_X0, %xmm4, XTS_MASK);
+	vpxor XTS_TW_X1, %xmm1, %xmm1;
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_O2, XTS_TW_X1, %xmm4, XTS_MASK);
+	vpxor XTS_TW_O2, %xmm5, %xmm5;
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X3, XTS_TW_O2, %xmm4, XTS_MASK);
+	vpxor XTS_TW_X3, %xmm3, %xmm3;
+
+
+	TRANSPOSE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5);
+
+	call __lea_x86_64_enc_4way_avx512
+
+	TRANSPOSE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %xmm4, %xmm2);
+
+	vpxor XTS_TW_X0, %xmm0, %xmm0;
+	vpxor XTS_TW_X1, %xmm1, %xmm1;
+	vpxor XTS_TW_O2, %xmm5, %xmm5;
+	vpxor XTS_TW_X3, %xmm3, %xmm3;
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X0, XTS_TW_X3, %xmm4, XTS_MASK);
+	vmovdqu XTS_TW_X0, (%rcx);
+	STORE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_xts_enc_4way_avx512)
+
+SYM_FUNC_START(lea_x86_64_xts_enc_8way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (8 blocks)
+	 *	%rdx: src (8 blocks)
+	 *	%rcx: tweak
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	vmovdqu (%rcx), XTS_TW_X0;
+	XTS_LOAD_TWEAK_MASK_AVX2(XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X1, XTS_TW_X0, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I2, XTS_TW_X1, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X3, XTS_TW_I2, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X4, XTS_TW_X3, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X5, XTS_TW_X4, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I6, XTS_TW_X5, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X7, XTS_TW_I6, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X8, XTS_TW_X7, %xmm5, XTS_MASK);
+	vmovdqu XTS_TW_X8, (%rcx);
+
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X0, XTS_TW_X1, XTS_TW_O2, XTS_TW_X3, %xmm5, XTS_TW_I2);
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X4, XTS_TW_X5, XTS_TW_O6, XTS_TW_X7, %xmm5, XTS_TW_I6);
+
+	vinserti128 $0x1, XTS_TW_X4, XTS_TW_Y0, XTS_TW_Y0;
+	vinserti128 $0x1, XTS_TW_X5, XTS_TW_Y1, XTS_TW_Y1;
+	vinserti128 $0x1, XTS_TW_O6, XTS_TW_Y2, XTS_TW_Y2;
+	vinserti128 $0x1, XTS_TW_X7, XTS_TW_Y3, XTS_TW_Y3;
+
+	GATHER_BLOCK8_AVX2(0, 1, 2, 3, 4, %rdx);
+
+	vpxor XTS_TW_Y0, %ymm0, %ymm0;
+	vpxor XTS_TW_Y1, %ymm1, %ymm1;
+	vpxor XTS_TW_Y2, %ymm2, %ymm2;
+	vpxor XTS_TW_Y3, %ymm3, %ymm3;
+
+	call __lea_x86_64_enc_8way_avx512
+
+	vpxor XTS_TW_Y0, %ymm0, %ymm0;
+	vpxor XTS_TW_Y1, %ymm1, %ymm1;
+	vpxor XTS_TW_Y2, %ymm2, %ymm2;
+	vpxor XTS_TW_Y3, %ymm3, %ymm3;
+
+	SCATTER_BLOCK8_AVX2(0, 1, 2, 3, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_xts_enc_8way_avx512)
+
+SYM_FUNC_START(lea_x86_64_xts_enc_16way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 *	%rcx: tweak
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	vmovdqu (%rcx), XTS_TW_X0;
+	XTS_LOAD_TWEAK_MASK_AVX2(XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X1, XTS_TW_X0, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I2, XTS_TW_X1, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X3, XTS_TW_I2, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X4, XTS_TW_X3, %xmm5, XTS_MASK);
+
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X0, XTS_TW_X1, XTS_TW_O2, XTS_TW_X3, %xmm5, XTS_TW_I2);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X5, XTS_TW_X4, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I6, XTS_TW_X5, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X7, XTS_TW_I6, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X8, XTS_TW_X7, %xmm5, XTS_MASK);
+
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X4, XTS_TW_X5, XTS_TW_O6, XTS_TW_X7, %xmm5, XTS_TW_I6);
+
+	vinserti32x4 $0x1, XTS_TW_X4, XTS_TW_Z0, XTS_TW_Z0;
+	vinserti32x4 $0x1, XTS_TW_X5, XTS_TW_Z1, XTS_TW_Z1;
+	vinserti32x4 $0x1, XTS_TW_O6, XTS_TW_Z2, XTS_TW_Z2;
+	vinserti32x4 $0x1, XTS_TW_X7, XTS_TW_Z3, XTS_TW_Z3;
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X5, XTS_TW_X8, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I6, XTS_TW_X5, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X7, XTS_TW_I6, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X4, XTS_TW_X7, %xmm5, XTS_MASK);
+
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X8, XTS_TW_X5, XTS_TW_O6, XTS_TW_X7, %xmm5, XTS_TW_I6);
+
+	vinserti32x4 $0x2, XTS_TW_X8, XTS_TW_Z0, XTS_TW_Z0;
+	vinserti32x4 $0x2, XTS_TW_X5, XTS_TW_Z1, XTS_TW_Z1;
+	vinserti32x4 $0x2, XTS_TW_O6, XTS_TW_Z2, XTS_TW_Z2;
+	vinserti32x4 $0x2, XTS_TW_X7, XTS_TW_Z3, XTS_TW_Z3;
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X5, XTS_TW_X4, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I6, XTS_TW_X5, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X7, XTS_TW_I6, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X8, XTS_TW_X7, %xmm5, XTS_MASK);
+
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X4, XTS_TW_X5, XTS_TW_O6, XTS_TW_X7, %xmm5, XTS_TW_I6);
+
+	vinserti32x4 $0x3, XTS_TW_X4, XTS_TW_Z0, XTS_TW_Z0;
+	vinserti32x4 $0x3, XTS_TW_X5, XTS_TW_Z1, XTS_TW_Z1;
+	vinserti32x4 $0x3, XTS_TW_O6, XTS_TW_Z2, XTS_TW_Z2;
+	vinserti32x4 $0x3, XTS_TW_X7, XTS_TW_Z3, XTS_TW_Z3;
+
+	vmovdqu XTS_TW_X8, (%rcx);
+
+	GATHER_BLOCK16_AVX512(0, 1, 2, 3, 4, %rdx);
+
+	vpxord XTS_TW_Z0, %zmm0, %zmm0;
+	vpxord XTS_TW_Z1, %zmm1, %zmm1;
+	vpxord XTS_TW_Z2, %zmm2, %zmm2;
+	vpxord XTS_TW_Z3, %zmm3, %zmm3;
+
+	call __lea_x86_64_enc_16way_avx512
+
+	vpxord XTS_TW_Z0, %zmm0, %zmm0;
+	vpxord XTS_TW_Z1, %zmm1, %zmm1;
+	vpxord XTS_TW_Z2, %zmm2, %zmm2;
+	vpxord XTS_TW_Z3, %zmm3, %zmm3;
+
+	SCATTER_BLOCK16_AVX512(0, 1, 2, 3, 4, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_xts_enc_16way_avx512)
+#endif
+
+SYM_FUNC_START(lea_x86_64_xts_dec_4way_sse2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 *	%rcx: tweak
+	 */
+	FRAME_BEGIN
+
+	LOAD_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %rdx);
+	movdqu (%rcx), XTS_TW_X0;
+	XTS_LOAD_TWEAK_MASK_SSE2(XTS_MASK);
+	pxor XTS_TW_X0, %xmm0;
+	XTS_NEXT_TWEAK_1BLOCK_SSE2(XTS_TW_X1, XTS_TW_X0, %xmm4, XTS_MASK);
+	pxor XTS_TW_X1, %xmm1;
+	XTS_NEXT_TWEAK_1BLOCK_SSE2(XTS_TW_O2, XTS_TW_X1, %xmm4, XTS_MASK);
+	pxor XTS_TW_O2, %xmm5;
+	XTS_NEXT_TWEAK_1BLOCK_SSE2(XTS_TW_X3, XTS_TW_O2, %xmm4, XTS_MASK);
+	pxor XTS_TW_X3, %xmm3;
+
+	TRANSPOSE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5);
+
+	call __lea_x86_64_dec_4way_sse2
+
+	TRANSPOSE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %xmm4, %xmm2);
+
+	pxor XTS_TW_X0, %xmm0;
+	pxor XTS_TW_X1, %xmm1;
+	pxor XTS_TW_O2, %xmm5;
+	pxor XTS_TW_X3, %xmm3;
+
+	XTS_NEXT_TWEAK_1BLOCK_SSE2(XTS_TW_X0, XTS_TW_X3, %xmm4, XTS_MASK);
+	movdqu XTS_TW_X0, (%rcx);
+	STORE_BLOCK4_SSE2(%xmm0, %xmm1, %xmm5, %xmm3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_xts_dec_4way_sse2)
+
+SYM_FUNC_START(lea_x86_64_xts_dec_4way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 *	%rcx: tweak
+	 */
+	FRAME_BEGIN
+
+	LOAD_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %rdx);
+	vmovdqu (%rcx), XTS_TW_X0;
+	XTS_LOAD_TWEAK_MASK_AVX2(XTS_MASK);
+	vpxor XTS_TW_X0, %xmm0, %xmm0;
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X1, XTS_TW_X0, %xmm4, XTS_MASK);
+	vpxor XTS_TW_X1, %xmm1, %xmm1;
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_O2, XTS_TW_X1, %xmm4, XTS_MASK);
+	vpxor XTS_TW_O2, %xmm5, %xmm5;
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X3, XTS_TW_O2, %xmm4, XTS_MASK);
+	vpxor XTS_TW_X3, %xmm3, %xmm3;
+
+	TRANSPOSE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5);
+
+	call __lea_x86_64_dec_4way_avx2
+
+	TRANSPOSE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %xmm4, %xmm2);
+
+	vpxor XTS_TW_X0, %xmm0, %xmm0;
+	vpxor XTS_TW_X1, %xmm1, %xmm1;
+	vpxor XTS_TW_O2, %xmm5, %xmm5;
+	vpxor XTS_TW_X3, %xmm3, %xmm3;
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X0, XTS_TW_X3, %xmm4, XTS_MASK);
+	vmovdqu XTS_TW_X0, (%rcx);
+	STORE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_xts_dec_4way_avx2)
+
+SYM_FUNC_START(lea_x86_64_xts_dec_8way_avx2)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (8 blocks)
+	 *	%rdx: src (8 blocks)
+	 *	%rcx: tweak
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	vmovdqu (%rcx), XTS_TW_X0;
+	XTS_LOAD_TWEAK_MASK_AVX2(XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X1, XTS_TW_X0, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I2, XTS_TW_X1, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X3, XTS_TW_I2, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X4, XTS_TW_X3, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X5, XTS_TW_X4, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I6, XTS_TW_X5, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X7, XTS_TW_I6, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X8, XTS_TW_X7, %xmm5, XTS_MASK);
+	vmovdqu XTS_TW_X8, (%rcx);
+
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X0, XTS_TW_X1, XTS_TW_O2, XTS_TW_X3, %xmm5, XTS_TW_I2);
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X4, XTS_TW_X5, XTS_TW_O6, XTS_TW_X7, %xmm5, XTS_TW_I6);
+
+	vinserti128 $0x1, XTS_TW_X4, XTS_TW_Y0, XTS_TW_Y0;
+	vinserti128 $0x1, XTS_TW_X5, XTS_TW_Y1, XTS_TW_Y1;
+	vinserti128 $0x1, XTS_TW_O6, XTS_TW_Y2, XTS_TW_Y2;
+	vinserti128 $0x1, XTS_TW_X7, XTS_TW_Y3, XTS_TW_Y3;
+
+	GATHER_BLOCK8_AVX2(0, 1, 2, 3, 4, %rdx);
+
+	vpxor XTS_TW_Y0, %ymm0, %ymm0;
+	vpxor XTS_TW_Y1, %ymm1, %ymm1;
+	vpxor XTS_TW_Y2, %ymm2, %ymm2;
+	vpxor XTS_TW_Y3, %ymm3, %ymm3;
+
+	call __lea_x86_64_dec_8way_avx2
+
+	vpxor XTS_TW_Y0, %ymm0, %ymm0;
+	vpxor XTS_TW_Y1, %ymm1, %ymm1;
+	vpxor XTS_TW_Y2, %ymm2, %ymm2;
+	vpxor XTS_TW_Y3, %ymm3, %ymm3;
+
+	SCATTER_BLOCK8_AVX2(0, 1, 2, 3, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_xts_dec_8way_avx2)
+
+#ifdef CONFIG_AS_AVX512
+SYM_FUNC_START(lea_x86_64_xts_dec_4way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (4 blocks)
+	 *	%rdx: src (4 blocks)
+	 *	%rcx: tweak
+	 */
+	FRAME_BEGIN
+
+	LOAD_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %rdx);
+	vmovdqu (%rcx), XTS_TW_X0;
+	XTS_LOAD_TWEAK_MASK_AVX2(XTS_MASK);
+	vpxor XTS_TW_X0, %xmm0, %xmm0;
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X1, XTS_TW_X0, %xmm4, XTS_MASK);
+	vpxor XTS_TW_X1, %xmm1, %xmm1;
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_O2, XTS_TW_X1, %xmm4, XTS_MASK);
+	vpxor XTS_TW_O2, %xmm5, %xmm5;
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X3, XTS_TW_O2, %xmm4, XTS_MASK);
+	vpxor XTS_TW_X3, %xmm3, %xmm3;
+
+	TRANSPOSE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5);
+
+	call __lea_x86_64_dec_4way_avx512
+
+	TRANSPOSE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %xmm4, %xmm2);
+
+	vpxor XTS_TW_X0, %xmm0, %xmm0;
+	vpxor XTS_TW_X1, %xmm1, %xmm1;
+	vpxor XTS_TW_O2, %xmm5, %xmm5;
+	vpxor XTS_TW_X3, %xmm3, %xmm3;
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X0, XTS_TW_X3, %xmm4, XTS_MASK);
+	vmovdqu XTS_TW_X0, (%rcx);
+	STORE_BLOCK4_AVX2(%xmm0, %xmm1, %xmm5, %xmm3, %rsi);
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_xts_dec_4way_avx512)
+
+SYM_FUNC_START(lea_x86_64_xts_dec_8way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (8 blocks)
+	 *	%rdx: src (8 blocks)
+	 *	%rcx: tweak
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	vmovdqu (%rcx), XTS_TW_X0;
+	XTS_LOAD_TWEAK_MASK_AVX2(XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X1, XTS_TW_X0, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I2, XTS_TW_X1, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X3, XTS_TW_I2, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X4, XTS_TW_X3, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X5, XTS_TW_X4, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I6, XTS_TW_X5, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X7, XTS_TW_I6, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X8, XTS_TW_X7, %xmm5, XTS_MASK);
+	vmovdqu XTS_TW_X8, (%rcx);
+
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X0, XTS_TW_X1, XTS_TW_O2, XTS_TW_X3, %xmm5, XTS_TW_I2);
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X4, XTS_TW_X5, XTS_TW_O6, XTS_TW_X7, %xmm5, XTS_TW_I6);
+
+	vinserti128 $0x1, XTS_TW_X4, XTS_TW_Y0, XTS_TW_Y0;
+	vinserti128 $0x1, XTS_TW_X5, XTS_TW_Y1, XTS_TW_Y1;
+	vinserti128 $0x1, XTS_TW_O6, XTS_TW_Y2, XTS_TW_Y2;
+	vinserti128 $0x1, XTS_TW_X7, XTS_TW_Y3, XTS_TW_Y3;
+
+	GATHER_BLOCK8_AVX2(0, 1, 2, 3, 4, %rdx);
+
+	vpxor XTS_TW_Y0, %ymm0, %ymm0;
+	vpxor XTS_TW_Y1, %ymm1, %ymm1;
+	vpxor XTS_TW_Y2, %ymm2, %ymm2;
+	vpxor XTS_TW_Y3, %ymm3, %ymm3;
+
+	call __lea_x86_64_dec_8way_avx512
+
+	vpxor XTS_TW_Y0, %ymm0, %ymm0;
+	vpxor XTS_TW_Y1, %ymm1, %ymm1;
+	vpxor XTS_TW_Y2, %ymm2, %ymm2;
+	vpxor XTS_TW_Y3, %ymm3, %ymm3;
+
+	SCATTER_BLOCK8_AVX2(0, 1, 2, 3, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_xts_dec_8way_avx512)
+
+SYM_FUNC_START(lea_x86_64_xts_dec_16way_avx512)
+	/* input:
+	 *	%rdi: ctx, CTX
+	 *	%rsi: dst (16 blocks)
+	 *	%rdx: src (16 blocks)
+	 *	%rcx: tweak
+	 */
+	FRAME_BEGIN
+
+	vzeroupper;
+
+	vmovdqu (%rcx), XTS_TW_X0;
+	XTS_LOAD_TWEAK_MASK_AVX2(XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X1, XTS_TW_X0, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I2, XTS_TW_X1, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X3, XTS_TW_I2, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X4, XTS_TW_X3, %xmm5, XTS_MASK);
+
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X0, XTS_TW_X1, XTS_TW_O2, XTS_TW_X3, %xmm5, XTS_TW_I2);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X5, XTS_TW_X4, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I6, XTS_TW_X5, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X7, XTS_TW_I6, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X8, XTS_TW_X7, %xmm5, XTS_MASK);
+
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X4, XTS_TW_X5, XTS_TW_O6, XTS_TW_X7, %xmm5, XTS_TW_I6);
+
+	vinserti32x4 $0x1, XTS_TW_X4, XTS_TW_Z0, XTS_TW_Z0;
+	vinserti32x4 $0x1, XTS_TW_X5, XTS_TW_Z1, XTS_TW_Z1;
+	vinserti32x4 $0x1, XTS_TW_O6, XTS_TW_Z2, XTS_TW_Z2;
+	vinserti32x4 $0x1, XTS_TW_X7, XTS_TW_Z3, XTS_TW_Z3;
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X5, XTS_TW_X8, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I6, XTS_TW_X5, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X7, XTS_TW_I6, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X4, XTS_TW_X7, %xmm5, XTS_MASK);
+
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X8, XTS_TW_X5, XTS_TW_O6, XTS_TW_X7, %xmm5, XTS_TW_I6);
+
+	vinserti32x4 $0x2, XTS_TW_X8, XTS_TW_Z0, XTS_TW_Z0;
+	vinserti32x4 $0x2, XTS_TW_X5, XTS_TW_Z1, XTS_TW_Z1;
+	vinserti32x4 $0x2, XTS_TW_O6, XTS_TW_Z2, XTS_TW_Z2;
+	vinserti32x4 $0x2, XTS_TW_X7, XTS_TW_Z3, XTS_TW_Z3;
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X5, XTS_TW_X4, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_I6, XTS_TW_X5, %xmm5, XTS_MASK);
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X7, XTS_TW_I6, %xmm5, XTS_MASK);
+
+	XTS_NEXT_TWEAK_1BLOCK_AVX2(XTS_TW_X8, XTS_TW_X7, %xmm5, XTS_MASK);
+
+	TRANSPOSE_BLOCK4_AVX2(XTS_TW_X4, XTS_TW_X5, XTS_TW_O6, XTS_TW_X7, %xmm5, XTS_TW_I6);
+
+	vinserti32x4 $0x3, XTS_TW_X4, XTS_TW_Z0, XTS_TW_Z0;
+	vinserti32x4 $0x3, XTS_TW_X5, XTS_TW_Z1, XTS_TW_Z1;
+	vinserti32x4 $0x3, XTS_TW_O6, XTS_TW_Z2, XTS_TW_Z2;
+	vinserti32x4 $0x3, XTS_TW_X7, XTS_TW_Z3, XTS_TW_Z3;
+
+	vmovdqu XTS_TW_X8, (%rcx);
+
+	GATHER_BLOCK16_AVX512(0, 1, 2, 3, 4, %rdx);
+
+	vpxord XTS_TW_Z0, %zmm0, %zmm0;
+	vpxord XTS_TW_Z1, %zmm1, %zmm1;
+	vpxord XTS_TW_Z2, %zmm2, %zmm2;
+	vpxord XTS_TW_Z3, %zmm3, %zmm3;
+
+	call __lea_x86_64_dec_16way_avx512
+
+	vpxord XTS_TW_Z0, %zmm0, %zmm0;
+	vpxord XTS_TW_Z1, %zmm1, %zmm1;
+	vpxord XTS_TW_Z2, %zmm2, %zmm2;
+	vpxord XTS_TW_Z3, %zmm3, %zmm3;
+
+	SCATTER_BLOCK16_AVX512(0, 1, 2, 3, 4, %rsi);
+
+	vzeroupper;
+
+	FRAME_END
+	RET;
+SYM_FUNC_END(lea_x86_64_xts_dec_16way_avx512)
+#endif
+
+#ifdef CONFIG_AS_AVX512
+
+.section	.rodata.cst64.bswap_shuffle_mask, "aM", @progbits, 64
+.align 64
+.Lbswap_mask:
+	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+
+
+.section	.rodata.cst64.ctr_add_const, "aM", @progbits, 64
+.align 64
+.Lctr_add_const:
+	.octa 0x00000003000000020000000100000000
+	.octa 0x00000007000000060000000500000004
+	.octa 0x0000000b0000000a0000000900000008
+	.octa 0x0000000f0000000e0000000d0000000c
+
+.section	.rodata.cst64.cbc_shuffle_mask16, "aM", @progbits, 64
+.align 64
+.Lcbc_shuffle_mask16:
+	.octa 0x0000000200000001000000000000000f
+	.octa 0x00000006000000050000000400000003
+	.octa 0x0000000a000000090000000800000007
+	.octa 0x0000000e0000000d0000000c0000000b
+
+#else
+
+.section	.rodata.cst32.bswap_shuffle_mask, "aM", @progbits, 32
+.align 32
+.Lbswap_mask:
+	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+	.byte 3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12
+
+.section	.rodata.cst32.ctr_add_const, "aM", @progbits, 32
+.align 32
+.Lctr_add_const:
+	.octa 0x00000003000000020000000100000000
+	.octa 0x00000007000000060000000500000004
+
+#endif
+
+.section	.rodata.cst32.cbc_shuffle_mask, "aM", @progbits, 32
+.align 32
+.Lcbc_shuffle_mask:
+	.octa 0x00000002000000010000000000000007
+	.octa 0x00000006000000050000000400000003
+
+.section	.rodata.cst16.xts_tweak_mask, "aM", @progbits, 16
+.align 16
+.Lxts_tweak_mask:
+	.octa 0x00000000000000010000000000000087
diff --git a/arch/x86/crypto/lea-x86_64-glue.c b/arch/x86/crypto/lea-x86_64-glue.c
new file mode 100644
index 000000000000..a28d89960090
--- /dev/null
+++ b/arch/x86/crypto/lea-x86_64-glue.c
@@ -0,0 +1,820 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Glue Code for the SSE2/AVX2/AVX-512F assembler instructions
+ * for the LEA Cipher
+ *
+ * - SSE2: 4 parallel blocks
+ * - AVX2: 8/4 parallel blocks
+ * - AVX-512F: 16/8/4 parallel blocks
+ *
+ * Copyright (c) 2023 National Security Research.
+ * Author: Dongsoo Lee <letrhee@nsr.re.kr>
+ */
+
+#include <asm/simd.h>
+#include <asm/unaligned.h>
+#include <crypto/algapi.h>
+#include <crypto/ctr.h>
+#include <crypto/internal/simd.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/skcipher.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/types.h>
+
+#include <crypto/lea.h>
+#include <crypto/xts.h>
+#include "ecb_cbc_helpers.h"
+
+struct crypto_lea_xts_ctx {
+	struct crypto_lea_ctx crypt_ctx;
+	struct crypto_lea_ctx __aligned(LEA_BLOCK_SIZE) tweak_ctx;
+};
+
+#define LEA_AVX512_MAX_PARALLEL_BLOCKS 16
+#define LEA_AVX2_MAX_PARALLEL_BLOCKS 8
+#define LEA_SSE2_MAX_PARALLEL_BLOCKS 4
+#define LEA_MIN_PARALLEL_BLOCKS LEA_SSE2_MAX_PARALLEL_BLOCKS
+
+typedef void (*lea_ecb_enc_nway)(const void *ctx, u8 *dst, const u8 *src);
+typedef void (*lea_ecb_dec_nway)(const void *ctx, u8 *dst, const u8 *src);
+
+typedef void (*lea_cbc_dec_nway)(const void *ctx, u8 *dst, const u8 *src);
+
+typedef void (*lea_ctr_enc_nway)(const void *ctx, u8 *dst, const u8 *src,
+				 u8 *ctr);
+
+typedef void (*lea_xts_enc_nway)(const void *ctx, u8 *dst, const u8 *src,
+				 u8 *tweak);
+typedef void (*lea_xts_dec_nway)(const void *ctx, u8 *dst, const u8 *src,
+				 u8 *tweak);
+
+struct lea_func_map_t {
+	lea_ecb_enc_nway ecb_enc_4way;
+	lea_ecb_dec_nway ecb_dec_4way;
+	lea_cbc_dec_nway cbc_dec_4way;
+	lea_ctr_enc_nway ctr_enc_4way;
+	lea_xts_enc_nway xts_enc_4way;
+	lea_xts_dec_nway xts_dec_4way;
+
+	lea_ecb_enc_nway ecb_enc_8way;
+	lea_ecb_dec_nway ecb_dec_8way;
+	lea_cbc_dec_nway cbc_dec_8way;
+	lea_ctr_enc_nway ctr_enc_8way;
+	lea_xts_enc_nway xts_enc_8way;
+	lea_xts_dec_nway xts_dec_8way;
+
+#ifdef CONFIG_AS_AVX512
+	lea_ecb_enc_nway ecb_enc_16way;
+	lea_ecb_dec_nway ecb_dec_16way;
+	lea_cbc_dec_nway cbc_dec_16way;
+	lea_ctr_enc_nway ctr_enc_16way;
+	lea_xts_enc_nway xts_enc_16way;
+	lea_xts_dec_nway xts_dec_16way;
+#endif
+	int proc_blocks;
+};
+
+#ifdef CONFIG_AS_AVX512
+asmlinkage void lea_x86_64_ecb_enc_16way_avx512(const void *ctx, u8 *dst,
+						const u8 *src);
+asmlinkage void lea_x86_64_ecb_dec_16way_avx512(const void *ctx, u8 *dst,
+						const u8 *src);
+asmlinkage void lea_x86_64_ecb_enc_8way_avx512(const void *ctx, u8 *dst,
+					       const u8 *src);
+asmlinkage void lea_x86_64_ecb_dec_8way_avx512(const void *ctx, u8 *dst,
+					       const u8 *src);
+asmlinkage void lea_x86_64_ecb_enc_4way_avx512(const void *ctx, u8 *dst,
+					       const u8 *src);
+asmlinkage void lea_x86_64_ecb_dec_4way_avx512(const void *ctx, u8 *dst,
+					       const u8 *src);
+#endif
+
+asmlinkage void lea_x86_64_ecb_enc_8way_avx2(const void *ctx, u8 *dst,
+					     const u8 *src);
+asmlinkage void lea_x86_64_ecb_dec_8way_avx2(const void *ctx, u8 *dst,
+					     const u8 *src);
+asmlinkage void lea_x86_64_ecb_enc_4way_avx2(const void *ctx, u8 *dst,
+					     const u8 *src);
+asmlinkage void lea_x86_64_ecb_dec_4way_avx2(const void *ctx, u8 *dst,
+					     const u8 *src);
+
+asmlinkage void lea_x86_64_ecb_enc_4way_sse2(const void *ctx, u8 *dst,
+					     const u8 *src);
+asmlinkage void lea_x86_64_ecb_dec_4way_sse2(const void *ctx, u8 *dst,
+					     const u8 *src);
+
+#ifdef CONFIG_AS_AVX512
+asmlinkage void lea_x86_64_cbc_dec_16way_avx512(const void *ctx, u8 *dst,
+						const u8 *src);
+asmlinkage void lea_x86_64_cbc_dec_8way_avx512(const void *ctx, u8 *dst,
+					       const u8 *src);
+asmlinkage void lea_x86_64_cbc_dec_4way_avx512(const void *ctx, u8 *dst,
+					       const u8 *src);
+#endif
+
+asmlinkage void lea_x86_64_cbc_dec_8way_avx2(const void *ctx, u8 *dst,
+					     const u8 *src);
+asmlinkage void lea_x86_64_cbc_dec_4way_avx2(const void *ctx, u8 *dst,
+					     const u8 *src);
+
+asmlinkage void lea_x86_64_cbc_dec_4way_sse2(const void *ctx, u8 *dst,
+					     const u8 *src);
+
+#ifdef CONFIG_AS_AVX512
+asmlinkage void lea_x86_64_ctr_enc_16way_avx512(const void *ctx, u8 *dst,
+						const u8 *src, u8 *ctr);
+asmlinkage void lea_x86_64_ctr_enc_8way_avx512(const void *ctx, u8 *dst,
+					       const u8 *src, u8 *ctr);
+asmlinkage void lea_x86_64_ctr_enc_4way_avx512(const void *ctx, u8 *dst,
+					       const u8 *src, u8 *ctr);
+#endif
+
+asmlinkage void lea_x86_64_ctr_enc_8way_avx2(const void *ctx, u8 *dst,
+					     const u8 *src, u8 *ctr);
+asmlinkage void lea_x86_64_ctr_enc_4way_avx2(const void *ctx, u8 *dst,
+					     const u8 *src, u8 *ctr);
+
+asmlinkage void lea_x86_64_ctr_enc_4way_sse2(const void *ctx, u8 *dst,
+					     const u8 *src, u8 *ctr);
+
+#ifdef CONFIG_AS_AVX512
+asmlinkage void lea_x86_64_xts_enc_16way_avx512(const void *ctx, u8 *dst,
+						const u8 *src, u8 *tweak);
+asmlinkage void lea_x86_64_xts_dec_16way_avx512(const void *ctx, u8 *dst,
+						const u8 *src, u8 *tweak);
+asmlinkage void lea_x86_64_xts_enc_8way_avx512(const void *ctx, u8 *dst,
+					       const u8 *src, u8 *tweak);
+asmlinkage void lea_x86_64_xts_dec_8way_avx512(const void *ctx, u8 *dst,
+					       const u8 *src, u8 *tweak);
+asmlinkage void lea_x86_64_xts_enc_4way_avx512(const void *ctx, u8 *dst,
+					       const u8 *src, u8 *tweak);
+asmlinkage void lea_x86_64_xts_dec_4way_avx512(const void *ctx, u8 *dst,
+					       const u8 *src, u8 *tweak);
+#endif
+
+asmlinkage void lea_x86_64_xts_enc_8way_avx2(const void *ctx, u8 *dst,
+					     const u8 *src, u8 *tweak);
+asmlinkage void lea_x86_64_xts_dec_8way_avx2(const void *ctx, u8 *dst,
+					     const u8 *src, u8 *tweak);
+asmlinkage void lea_x86_64_xts_enc_4way_avx2(const void *ctx, u8 *dst,
+					     const u8 *src, u8 *tweak);
+asmlinkage void lea_x86_64_xts_dec_4way_avx2(const void *ctx, u8 *dst,
+					     const u8 *src, u8 *tweak);
+
+asmlinkage void lea_x86_64_xts_enc_4way_sse2(const void *ctx, u8 *dst,
+					     const u8 *src, u8 *tweak);
+asmlinkage void lea_x86_64_xts_dec_4way_sse2(const void *ctx, u8 *dst,
+					     const u8 *src, u8 *tweak);
+
+#ifdef CONFIG_AS_AVX512
+static const struct lea_func_map_t lea_avx512_func_map = {
+	.ecb_enc_4way = lea_x86_64_ecb_enc_4way_avx512,
+	.ecb_dec_4way = lea_x86_64_ecb_dec_4way_avx512,
+	.cbc_dec_4way = lea_x86_64_cbc_dec_4way_avx512,
+	.ctr_enc_4way = lea_x86_64_ctr_enc_4way_avx512,
+	.xts_enc_4way = lea_x86_64_xts_enc_4way_avx512,
+	.xts_dec_4way = lea_x86_64_xts_dec_4way_avx512,
+
+	.ecb_enc_8way = lea_x86_64_ecb_enc_8way_avx512,
+	.ecb_dec_8way = lea_x86_64_ecb_dec_8way_avx512,
+	.cbc_dec_8way = lea_x86_64_cbc_dec_8way_avx512,
+	.ctr_enc_8way = lea_x86_64_ctr_enc_8way_avx512,
+	.xts_enc_8way = lea_x86_64_xts_enc_8way_avx512,
+	.xts_dec_8way = lea_x86_64_xts_dec_8way_avx512,
+
+	.ecb_enc_16way = lea_x86_64_ecb_enc_16way_avx512,
+	.ecb_dec_16way = lea_x86_64_ecb_dec_16way_avx512,
+	.cbc_dec_16way = lea_x86_64_cbc_dec_16way_avx512,
+	.ctr_enc_16way = lea_x86_64_ctr_enc_16way_avx512,
+	.xts_enc_16way = lea_x86_64_xts_enc_16way_avx512,
+	.xts_dec_16way = lea_x86_64_xts_dec_16way_avx512,
+
+	.proc_blocks = LEA_AVX512_MAX_PARALLEL_BLOCKS,
+};
+#endif
+
+static const struct lea_func_map_t lea_avx2_func_map = {
+	.ecb_enc_4way = lea_x86_64_ecb_enc_4way_avx2,
+	.ecb_dec_4way = lea_x86_64_ecb_dec_4way_avx2,
+	.cbc_dec_4way = lea_x86_64_cbc_dec_4way_avx2,
+	.ctr_enc_4way = lea_x86_64_ctr_enc_4way_avx2,
+	.xts_enc_4way = lea_x86_64_xts_enc_4way_avx2,
+	.xts_dec_4way = lea_x86_64_xts_dec_4way_avx2,
+
+	.ecb_enc_8way = lea_x86_64_ecb_enc_8way_avx2,
+	.ecb_dec_8way = lea_x86_64_ecb_dec_8way_avx2,
+	.cbc_dec_8way = lea_x86_64_cbc_dec_8way_avx2,
+	.ctr_enc_8way = lea_x86_64_ctr_enc_8way_avx2,
+	.xts_enc_8way = lea_x86_64_xts_enc_8way_avx2,
+	.xts_dec_8way = lea_x86_64_xts_dec_8way_avx2,
+
+	.proc_blocks = LEA_AVX2_MAX_PARALLEL_BLOCKS,
+};
+
+/* default SSE2 */
+static struct lea_func_map_t lea_func_map = {
+	.ecb_enc_4way = lea_x86_64_ecb_enc_4way_sse2,
+	.ecb_dec_4way = lea_x86_64_ecb_dec_4way_sse2,
+	.cbc_dec_4way = lea_x86_64_cbc_dec_4way_sse2,
+	.ctr_enc_4way = lea_x86_64_ctr_enc_4way_sse2,
+	.xts_enc_4way = lea_x86_64_xts_enc_4way_sse2,
+	.xts_dec_4way = lea_x86_64_xts_dec_4way_sse2,
+
+	.proc_blocks = LEA_SSE2_MAX_PARALLEL_BLOCKS,
+};
+
+static int ecb_encrypt_nway(struct skcipher_request *req)
+{
+	ECB_WALK_START(req, LEA_BLOCK_SIZE, LEA_MIN_PARALLEL_BLOCKS);
+	if (lea_func_map.ecb_enc_16way)
+		ECB_BLOCK(16, lea_func_map.ecb_enc_16way);
+	if (lea_func_map.ecb_enc_8way)
+		ECB_BLOCK(8, lea_func_map.ecb_enc_8way);
+	ECB_BLOCK(4, lea_func_map.ecb_enc_4way);
+	ECB_BLOCK(1, lea_encrypt);
+	ECB_WALK_END();
+}
+
+static int ecb_decrypt_nway(struct skcipher_request *req)
+{
+	ECB_WALK_START(req, LEA_BLOCK_SIZE, LEA_MIN_PARALLEL_BLOCKS);
+	if (lea_func_map.ecb_dec_16way)
+		ECB_BLOCK(16, lea_func_map.ecb_dec_16way);
+	if (lea_func_map.ecb_dec_8way)
+		ECB_BLOCK(8, lea_func_map.ecb_dec_8way);
+	ECB_BLOCK(4, lea_x86_64_ecb_dec_4way_avx2);
+	ECB_BLOCK(1, lea_decrypt);
+	ECB_WALK_END();
+}
+
+static int cbc_encrypt(struct skcipher_request *req)
+{
+	CBC_WALK_START(req, LEA_BLOCK_SIZE, -1);
+	CBC_ENC_BLOCK(lea_encrypt);
+	CBC_WALK_END();
+}
+
+static int cbc_decrypt_nway(struct skcipher_request *req)
+{
+	CBC_WALK_START(req, LEA_BLOCK_SIZE, LEA_MIN_PARALLEL_BLOCKS);
+	if (lea_func_map.cbc_dec_16way)
+		CBC_DEC_BLOCK(16, lea_func_map.cbc_dec_16way);
+	if (lea_func_map.cbc_dec_8way)
+		CBC_DEC_BLOCK(8, lea_func_map.cbc_dec_8way);
+	CBC_DEC_BLOCK(4, lea_func_map.cbc_dec_4way);
+	CBC_DEC_BLOCK(1, lea_decrypt);
+	CBC_WALK_END();
+}
+
+static inline void xor_1blk(u8 *out, const u8 *in1, const u8 *in2)
+{
+	const u64 *_in1 = (const u64 *)in1;
+	const u64 *_in2 = (const u64 *)in2;
+	u64 *_out = (u64 *)out;
+
+	_out[0] = _in1[0] ^ _in2[0];
+	_out[1] = _in1[1] ^ _in2[1];
+}
+
+static inline void xts_next_tweak(u8 *out, const u8 *in)
+{
+	const u64 *_in = (const u64 *)in;
+	u64 *_out = (u64 *)out;
+	u64 v0 = _in[0];
+	u64 v1 = _in[1];
+	u64 carry = (u64)(((s64)v1) >> 63);
+
+	v1 = (v1 << 1) ^ (v0 >> 63);
+	v0 = (v0 << 1) ^ ((u64)carry & 0x87);
+
+	_out[0] = v0;
+	_out[1] = v1;
+}
+
+#define CTR_NWAY(NWAY, FUNC)                      \
+	while (nbytes >= NWAY * LEA_BLOCK_SIZE) { \
+		FUNC(ctx, dst, src, walk.iv);     \
+		src += NWAY * LEA_BLOCK_SIZE;     \
+		dst += NWAY * LEA_BLOCK_SIZE;     \
+		nbytes -= NWAY * LEA_BLOCK_SIZE;  \
+	}
+
+#define XTS_NWAY(NWAY, FUNC)                              \
+	for (; nblocks >= NWAY; nblocks -= NWAY) {        \
+		FUNC(&ctx->crypt_ctx, dst, src, walk.iv); \
+		src += NWAY * LEA_BLOCK_SIZE;             \
+		dst += NWAY * LEA_BLOCK_SIZE;             \
+		nbytes -= NWAY * LEA_BLOCK_SIZE;          \
+	}
+
+#define XTS_SINGLE(FUNC)                                 \
+	for (; nblocks > 0; nblocks -= 1) {              \
+		u8 __aligned(16) buffer[LEA_BLOCK_SIZE]; \
+		xor_1blk(buffer, walk.iv, src);          \
+		FUNC(&ctx->crypt_ctx, buffer, buffer);   \
+		xor_1blk(dst, walk.iv, buffer);          \
+		xts_next_tweak(walk.iv, walk.iv);        \
+		src += LEA_BLOCK_SIZE;                   \
+		dst += LEA_BLOCK_SIZE;                   \
+		nbytes -= LEA_BLOCK_SIZE;                \
+	}
+
+#define XTS_TAIL_ENCRYPT(FUNC)                              \
+	do {                                                \
+		u8 __aligned(16) buffer[LEA_BLOCK_SIZE];    \
+		xor_1blk(buffer, walk.iv, src);             \
+		FUNC(&ctx->crypt_ctx, buffer, buffer);      \
+		xor_1blk(buffer, walk.iv, buffer);          \
+		memcpy(dst, buffer, LEA_BLOCK_SIZE);        \
+		memcpy(buffer, src + LEA_BLOCK_SIZE, tail); \
+		memcpy(dst + LEA_BLOCK_SIZE, dst, tail);    \
+		xts_next_tweak(walk.iv, walk.iv);           \
+		xor_1blk(buffer, walk.iv, buffer);          \
+		FUNC(&ctx->crypt_ctx, buffer, buffer);      \
+		xor_1blk(dst, walk.iv, buffer);             \
+		nbytes -= LEA_BLOCK_SIZE + tail;            \
+	} while (0)
+
+#define XTS_TAIL_DECRYPT(FUNC)                           \
+	do {                                             \
+		u8 __aligned(16) ntweak[LEA_BLOCK_SIZE]; \
+		u8 __aligned(16) buffer[LEA_BLOCK_SIZE]; \
+		memcpy(ntweak, walk.iv, LEA_BLOCK_SIZE); \
+		xts_next_tweak(walk.iv, ntweak);         \
+		xor_1blk(buffer, walk.iv, src);          \
+		FUNC(&ctx->crypt_ctx, buffer, buffer);   \
+		xor_1blk(buffer, walk.iv, buffer);       \
+		memcpy(dst, buffer, LEA_BLOCK_SIZE);     \
+		memcpy(buffer, src + 16, tail);          \
+		memcpy(dst + 16, dst, tail);             \
+		xor_1blk(buffer, ntweak, buffer);        \
+		FUNC(&ctx->crypt_ctx, buffer, buffer);   \
+		xor_1blk(dst, ntweak, buffer);           \
+		nbytes -= LEA_BLOCK_SIZE + tail;         \
+	} while (0)
+
+static inline int xts_edge_tail_encrypt(struct crypto_lea_xts_ctx *ctx,
+					struct skcipher_request *req,
+					struct skcipher_walk *walk,
+					int edge_tail)
+{
+	u8 __aligned(16) buffer[LEA_BLOCK_SIZE];
+	struct scatterlist sg_src[2];
+	struct scatterlist sg_dst[2];
+	struct scatterlist *scatter_src;
+	struct scatterlist *scatter_dst;
+	const u8 *src;
+	u8 *dst;
+
+	scatter_src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
+	if (req->src == req->dst)
+		scatter_dst = scatter_src;
+	else
+		scatter_dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
+
+	skcipher_request_set_crypt(req, scatter_src, scatter_dst,
+				   LEA_BLOCK_SIZE + edge_tail, req->iv);
+
+	skcipher_walk_virt(walk, req, false);
+
+	src = walk->src.virt.addr;
+	dst = walk->dst.virt.addr;
+
+	kernel_fpu_begin();
+
+	xor_1blk(buffer, walk->iv, src);
+	lea_encrypt(&ctx->crypt_ctx, buffer, buffer);
+	xor_1blk(buffer, walk->iv, buffer);
+
+	memcpy(dst, buffer, LEA_BLOCK_SIZE);
+	memcpy(buffer, src + LEA_BLOCK_SIZE, edge_tail);
+	memcpy(dst + LEA_BLOCK_SIZE, dst, edge_tail);
+
+	xts_next_tweak(walk->iv, walk->iv);
+
+	xor_1blk(buffer, walk->iv, buffer);
+	lea_encrypt(&ctx->crypt_ctx, buffer, buffer);
+	xor_1blk(dst, walk->iv, buffer);
+
+	kernel_fpu_end();
+	return skcipher_walk_done(walk, 0);
+}
+
+static inline int xts_edge_tail_decrypt(struct crypto_lea_xts_ctx *ctx,
+					struct skcipher_request *req,
+					struct skcipher_walk *walk,
+					int edge_tail)
+{
+	u8 __aligned(16) buffer[LEA_BLOCK_SIZE];
+	u8 __aligned(16) ntweak[LEA_BLOCK_SIZE];
+	struct scatterlist sg_src[2];
+	struct scatterlist sg_dst[2];
+	struct scatterlist *scatter_src;
+	struct scatterlist *scatter_dst;
+
+	const u8 *src;
+	u8 *dst;
+	int ret;
+
+	scatter_src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
+	if (req->src == req->dst)
+		scatter_dst = scatter_src;
+	else
+		scatter_dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
+
+	skcipher_request_set_crypt(req, scatter_src, scatter_dst,
+				   LEA_BLOCK_SIZE + edge_tail, req->iv);
+
+	ret = skcipher_walk_virt(walk, req, false);
+
+	src = walk->src.virt.addr;
+	dst = walk->dst.virt.addr;
+
+	kernel_fpu_begin();
+
+	memcpy(ntweak, walk->iv, LEA_BLOCK_SIZE);
+	xts_next_tweak(walk->iv, ntweak);
+
+	xor_1blk(buffer, walk->iv, src);
+	lea_decrypt(&ctx->crypt_ctx, buffer, buffer);
+	xor_1blk(buffer, walk->iv, buffer);
+
+	memcpy(dst, buffer, LEA_BLOCK_SIZE);
+
+	memcpy(buffer, src + 16, edge_tail);
+	memcpy(dst + 16, dst, edge_tail);
+
+	xor_1blk(buffer, ntweak, buffer);
+	lea_decrypt(&ctx->crypt_ctx, buffer, buffer);
+	xor_1blk(dst, ntweak, buffer);
+
+	kernel_fpu_end();
+
+	return skcipher_walk_done(walk, 0);
+}
+
+static int xts_encrypt_nway(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_lea_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_request subreq;
+	struct skcipher_walk walk;
+
+	int ret;
+	u32 nblocks;
+	u32 tail = req->cryptlen % LEA_BLOCK_SIZE;
+	u32 edge_tail = 0;
+
+	if (req->cryptlen < LEA_BLOCK_SIZE)
+		return -EINVAL;
+
+	ret = skcipher_walk_virt(&walk, req, false);
+	if (ret)
+		return ret;
+
+	if (unlikely(tail != 0 && walk.nbytes < walk.total)) {
+		u32 req_len = req->cryptlen - LEA_BLOCK_SIZE - tail;
+
+		skcipher_walk_abort(&walk);
+
+		skcipher_request_set_tfm(&subreq, tfm);
+		skcipher_request_set_callback(
+			&subreq, skcipher_request_flags(req), NULL, NULL);
+		skcipher_request_set_crypt(&subreq, req->src, req->dst, req_len,
+					   req->iv);
+		req = &subreq;
+		ret = skcipher_walk_virt(&walk, req, false);
+		if (ret)
+			return ret;
+		edge_tail = tail;
+		tail = 0;
+	}
+
+	lea_encrypt(&ctx->tweak_ctx, walk.iv, walk.iv);
+
+	while ((nblocks = walk.nbytes / LEA_BLOCK_SIZE) > 0) {
+		u32 nbytes = walk.nbytes;
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		bool is_tail = tail != 0 &&
+			       (nblocks + 1) * LEA_BLOCK_SIZE > walk.total;
+
+		if (unlikely(is_tail))
+			nblocks -= 1;
+
+		kernel_fpu_begin();
+
+		if (lea_func_map.xts_enc_16way)
+			XTS_NWAY(16, lea_func_map.xts_enc_16way);
+		if (lea_func_map.xts_enc_8way)
+			XTS_NWAY(8, lea_func_map.xts_enc_8way);
+		XTS_NWAY(4, lea_func_map.xts_enc_4way);
+		XTS_SINGLE(lea_encrypt);
+
+		if (unlikely(is_tail)) {
+			XTS_TAIL_ENCRYPT(lea_encrypt);
+			kernel_fpu_end();
+			return skcipher_walk_done(&walk, nbytes);
+		}
+
+		kernel_fpu_end();
+		ret = skcipher_walk_done(&walk, nbytes);
+		if (ret)
+			return ret;
+	}
+
+	if (unlikely(edge_tail != 0))
+		ret = xts_edge_tail_encrypt(ctx, req, &walk, edge_tail);
+
+	return ret;
+}
+
+static int xts_decrypt_nway(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_lea_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_request subreq;
+	struct skcipher_walk walk;
+
+	int ret;
+	u32 nblocks;
+	u32 tail = req->cryptlen % LEA_BLOCK_SIZE;
+	u32 edge_tail = 0;
+
+	if (req->cryptlen < LEA_BLOCK_SIZE)
+		return -EINVAL;
+
+	ret = skcipher_walk_virt(&walk, req, false);
+
+	if (ret)
+		return ret;
+
+	if (unlikely(tail != 0 && walk.nbytes < walk.total)) {
+		u32 req_len = req->cryptlen - LEA_BLOCK_SIZE - tail;
+
+		skcipher_walk_abort(&walk);
+
+		skcipher_request_set_tfm(&subreq, tfm);
+		skcipher_request_set_callback(
+			&subreq, skcipher_request_flags(req), NULL, NULL);
+		skcipher_request_set_crypt(&subreq, req->src, req->dst, req_len,
+					   req->iv);
+		req = &subreq;
+		ret = skcipher_walk_virt(&walk, req, false);
+		if (ret)
+			return ret;
+
+		edge_tail = tail;
+		tail = 0;
+	}
+
+	lea_encrypt(&ctx->tweak_ctx, walk.iv, walk.iv);
+
+	while ((nblocks = walk.nbytes / LEA_BLOCK_SIZE) > 0) {
+		u32 nbytes = walk.nbytes;
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		bool is_tail = tail != 0 &&
+			       (nblocks + 1) * LEA_BLOCK_SIZE > walk.total;
+
+		if (unlikely(is_tail))
+			nblocks -= 1;
+
+		kernel_fpu_begin();
+
+		if (lea_func_map.xts_dec_16way)
+			XTS_NWAY(16, lea_func_map.xts_dec_16way);
+		if (lea_func_map.xts_dec_8way)
+			XTS_NWAY(8, lea_func_map.xts_dec_8way);
+		XTS_NWAY(4, lea_func_map.xts_dec_4way);
+		XTS_SINGLE(lea_decrypt);
+
+		if (unlikely(is_tail)) {
+			XTS_TAIL_DECRYPT(lea_decrypt);
+			kernel_fpu_end();
+			return skcipher_walk_done(&walk, nbytes);
+		}
+
+		kernel_fpu_end();
+
+		ret = skcipher_walk_done(&walk, nbytes);
+		if (ret)
+			return ret;
+	}
+
+	if (unlikely(edge_tail != 0))
+		xts_edge_tail_decrypt(ctx, req, &walk, edge_tail);
+
+	return ret;
+}
+
+static int ctr_encrypt_nway(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_lea_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+
+	u8 __aligned(16) buffer[LEA_BLOCK_SIZE];
+
+	int ret;
+
+	ret = skcipher_walk_virt(&walk, req, false);
+	if (ret)
+		return ret;
+
+	while (walk.nbytes > 0) {
+		u32 nbytes = walk.nbytes;
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+
+		kernel_fpu_begin();
+
+		if (lea_func_map.ctr_enc_16way)
+			CTR_NWAY(16, lea_func_map.ctr_enc_16way);
+		if (lea_func_map.ctr_enc_8way)
+			CTR_NWAY(8, lea_func_map.ctr_enc_8way);
+		CTR_NWAY(4, lea_func_map.ctr_enc_4way);
+
+		while (nbytes >= LEA_BLOCK_SIZE) {
+			lea_encrypt(ctx, buffer, walk.iv);
+			xor_1blk(dst, buffer, src);
+			crypto_inc(walk.iv, LEA_BLOCK_SIZE);
+
+			src += LEA_BLOCK_SIZE;
+			dst += LEA_BLOCK_SIZE;
+			nbytes -= LEA_BLOCK_SIZE;
+		}
+
+		if (unlikely(walk.nbytes == walk.total && nbytes != 0)) {
+			lea_encrypt(ctx, buffer, walk.iv);
+			crypto_xor_cpy(dst, src, buffer, nbytes);
+			crypto_inc(walk.iv, LEA_BLOCK_SIZE);
+
+			nbytes = 0;
+		}
+
+		kernel_fpu_end();
+		ret = skcipher_walk_done(&walk, nbytes);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+static int xts_lea_set_key(struct crypto_skcipher *tfm, const u8 *key,
+			   u32 keylen)
+{
+	struct crypto_lea_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	struct crypto_lea_ctx *crypt_key = &ctx->crypt_ctx;
+	struct crypto_lea_ctx *tweak_key = &ctx->tweak_ctx;
+
+	int result;
+
+	result = xts_verify_key(tfm, key, keylen);
+	if (result)
+		return result;
+
+	result = lea_set_key(crypt_key, key, keylen / 2);
+
+	if (result)
+		return result;
+
+	return lea_set_key(tweak_key, key + (keylen / 2), keylen / 2);
+}
+
+static int _lea_set_key(struct crypto_skcipher *tfm, const u8 *key, u32 keylen)
+{
+	return lea_set_key(crypto_skcipher_ctx(tfm), key, keylen);
+}
+
+static struct skcipher_alg lea_x86_64_algs[] = {
+	{
+		.base.cra_name = "__ecb(lea)",
+		.base.cra_driver_name = "__ecb-lea-x86_64",
+		.base.cra_priority = 300,
+		.base.cra_flags = CRYPTO_ALG_INTERNAL,
+		.base.cra_blocksize = LEA_BLOCK_SIZE,
+		.base.cra_ctxsize = sizeof(struct crypto_lea_ctx),
+		.base.cra_module = THIS_MODULE,
+		.min_keysize = LEA_MIN_KEY_SIZE,
+		.max_keysize = LEA_MAX_KEY_SIZE,
+		.walksize = LEA_SSE2_MAX_PARALLEL_BLOCKS * LEA_BLOCK_SIZE,
+		.setkey = _lea_set_key,
+		.encrypt = ecb_encrypt_nway,
+		.decrypt = ecb_decrypt_nway,
+	},
+	{
+		.base.cra_name = "__ctr(lea)",
+		.base.cra_driver_name = "__ctr-lea-x86_64",
+		.base.cra_priority = 300,
+		.base.cra_flags = CRYPTO_ALG_INTERNAL,
+		.base.cra_blocksize = 1,
+		.base.cra_ctxsize = sizeof(struct crypto_lea_ctx),
+		.base.cra_module = THIS_MODULE,
+		.min_keysize = LEA_MIN_KEY_SIZE,
+		.max_keysize = LEA_MAX_KEY_SIZE,
+		.chunksize = LEA_BLOCK_SIZE,
+		.walksize = LEA_SSE2_MAX_PARALLEL_BLOCKS * LEA_BLOCK_SIZE,
+		.ivsize = LEA_BLOCK_SIZE,
+		.setkey = _lea_set_key,
+		.encrypt = ctr_encrypt_nway,
+		.decrypt = ctr_encrypt_nway,
+	},
+	{
+		.base.cra_name = "__cbc(lea)",
+		.base.cra_driver_name = "__cbc-lea-x86_64",
+		.base.cra_priority = 300,
+		.base.cra_flags = CRYPTO_ALG_INTERNAL,
+		.base.cra_blocksize = LEA_BLOCK_SIZE,
+		.base.cra_ctxsize = sizeof(struct crypto_lea_ctx),
+		.base.cra_module = THIS_MODULE,
+		.min_keysize = LEA_MIN_KEY_SIZE,
+		.max_keysize = LEA_MAX_KEY_SIZE,
+		.walksize = LEA_SSE2_MAX_PARALLEL_BLOCKS * LEA_BLOCK_SIZE,
+		.ivsize = LEA_BLOCK_SIZE,
+		.setkey = _lea_set_key,
+		.encrypt = cbc_encrypt,
+		.decrypt = cbc_decrypt_nway,
+	},
+	{
+		.base.cra_name = "__xts(lea)",
+		.base.cra_driver_name = "__xts-lea-x86_64",
+		.base.cra_priority = 300,
+		.base.cra_flags = CRYPTO_ALG_INTERNAL,
+		.base.cra_blocksize = LEA_BLOCK_SIZE,
+		.base.cra_ctxsize = sizeof(struct crypto_lea_xts_ctx),
+		.base.cra_module = THIS_MODULE,
+		.min_keysize = LEA_MIN_KEY_SIZE * 2,
+		.max_keysize = LEA_MAX_KEY_SIZE * 2,
+		.walksize = LEA_SSE2_MAX_PARALLEL_BLOCKS * LEA_BLOCK_SIZE,
+		.ivsize = LEA_BLOCK_SIZE,
+		.setkey = xts_lea_set_key,
+		.encrypt = xts_encrypt_nway,
+		.decrypt = xts_decrypt_nway,
+	},
+};
+
+static struct simd_skcipher_alg *lea_x86_64_sk_algs[ARRAY_SIZE(lea_x86_64_algs)];
+
+static int __init crypto_lea_x86_64_init(void)
+{
+	const char *feature_name;
+	int i;
+	const struct lea_func_map_t *target_call_map;
+
+	target_call_map = &lea_avx512_func_map;
+
+	if (!boot_cpu_has(X86_FEATURE_AVX512F))
+		target_call_map = &lea_avx2_func_map;
+	else if (!cpu_has_xfeatures(XFEATURE_MASK_ZMM_Hi256 |
+					    XFEATURE_MASK_OPMASK,
+				    &feature_name))
+		target_call_map = &lea_avx2_func_map;
+
+	if (!boot_cpu_has(X86_FEATURE_AVX2) || !boot_cpu_has(X86_FEATURE_AVX))
+		target_call_map = NULL;
+	else if (!cpu_has_xfeatures(XFEATURE_MASK_YMM, &feature_name))
+		target_call_map = NULL;
+
+	if (!boot_cpu_has(X86_FEATURE_XMM2)) {
+		pr_info("SSE2 instructions are not detected.\n");
+		return -ENODEV;
+	}
+
+	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE, &feature_name)) {
+		pr_info("CPU feature '%s' is not supported.\n", feature_name);
+		return -ENODEV;
+	}
+
+	if (target_call_map != NULL) {
+		lea_func_map = *target_call_map;
+		for (i = 0; i < ARRAY_SIZE(lea_x86_64_algs); i++) {
+			lea_x86_64_algs[i].walksize =
+				lea_func_map.proc_blocks * LEA_BLOCK_SIZE;
+		}
+	}
+
+	return simd_register_skciphers_compat(lea_x86_64_algs,
+					      ARRAY_SIZE(lea_x86_64_sk_algs),
+					      lea_x86_64_sk_algs);
+}
+
+static void __exit crypto_lea_x86_64_exit(void)
+{
+	simd_unregister_skciphers(lea_x86_64_algs,
+				  ARRAY_SIZE(lea_x86_64_sk_algs),
+				  lea_x86_64_sk_algs);
+}
+
+module_init(crypto_lea_x86_64_init);
+module_exit(crypto_lea_x86_64_exit);
+
+MODULE_DESCRIPTION("LEA Cipher Algorithm, AVX-512F, AVX2, SSE2 SIMD");
+MODULE_AUTHOR("Dongsoo Lee <letrhee@nsr.re.kr>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("lea");
+MODULE_ALIAS_CRYPTO("lea-x86_64");
-- 
2.40.1

