Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0261073DAA8
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Jun 2023 11:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjFZJAt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Jun 2023 05:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjFZI7z (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Jun 2023 04:59:55 -0400
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4C04C39
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Jun 2023 01:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; s=LIY0OQ3MUMW6182UNI14; d=nsr.re.kr; t=1687769580; c=relaxed/relaxed; h=content-type:date:from:message-id:mime-version:subject:to; bh=UFq1BcIt/OE3YQsplFDcgYVgSbCEVyqC7jbFFFvUJsM=; b=DCWHA4bm6rEggxbLlOXzL1sifCgVfMEKQXaMxYpThrMpLe7uKJz/usrLiGBjfQC/L2pazBv0YrGigt91Q/PpD5BDaAtv2Kd87m1XiiOHM67TXDJg5BmQ+TNr4vekZXdT4ALcRAF0iaqOu3v29yYZct4pZxgn2cjlUExoaKEPvBV15220SWDQEWW3x+nj7Yw5Dou8NoIElMVKz5QjqQdvLmCQfL9e86yddM77FI8wt69ZKHLcltr0UBtkXy9bUrewYmVzh5/++j1oT9cWTmYqnYCufg+sw0dFmeenifnI2oPwLcMXtm2tUH/43ejZ0YsislUZRnkHCpCIRY0NZEaMNg==
Received: from 210.104.33.70 (nsr.re.kr)
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
        by mail.nsr.re.kr with SMTP; Mon, 26 Jun 2023 17:45:39 +0900
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 334;
          Mon, 26 Jun 2023 17:47:46 +0900 (KST)
From:   Dongsoo Lee <letrhee@nsr.re.kr>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dongsoo Lee <letrhee@nsr.re.kr>
Subject: [PATCH v3 1/4] crypto: LEA block cipher implementation
Date:   Mon, 26 Jun 2023 17:47:00 +0900
Message-Id: <20230626084703.907331-2-letrhee@nsr.re.kr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230626084703.907331-1-letrhee@nsr.re.kr>
References: <20230626084703.907331-1-letrhee@nsr.re.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

LEA is a 128-bit block cipher developed by South Korea.

LEA is a Korean national standard (KS X 3246) and included in the
ISO/IEC 29192-2:2019 standard (Information security - Lightweight
cryptography - Part 2: Block ciphers).

The LEA algorithm is a symmetric key cipher that processes data blocks
of 128-bits and has three different key lengths, each with a different
number of rounds:

- LEA-128: 128-bit key, 24 rounds,
- LEA-192: 192-bit key, 28 rounds, and
- LEA-256: 256-bit key, 32 rounds.

The round function of LEA consists of 32-bit ARX(modular Addition,
bitwise Rotation, and bitwise XOR) operations.

- https://seed.kisa.or.kr/kisa/algorithm/EgovLeaInfo.do

Signed-off-by: Dongsoo Lee <letrhee@nsr.re.kr>
---
 crypto/Kconfig       |  18 ++
 crypto/Makefile      |   1 +
 crypto/lea_generic.c | 410 +++++++++++++++++++++++++++++++++++++++++++
 include/crypto/lea.h |  44 +++++
 4 files changed, 473 insertions(+)
 create mode 100644 crypto/lea_generic.c
 create mode 100644 include/crypto/lea.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a0e080d5f6ae..9d7b60cd4cd5 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -485,6 +485,24 @@ config CRYPTO_KHAZAD
 	  See https://web.archive.org/web/20171011071731/http://www.larc.usp.br/~pbarreto/KhazadPage.html
 	  for further information.
 
+config CRYPTO_LEA
+	tristate "LEA"
+	select CRYPTO_ALGAPI
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
 config CRYPTO_SEED
 	tristate "SEED"
 	depends on CRYPTO_USER_API_ENABLE_OBSOLETE
diff --git a/crypto/Makefile b/crypto/Makefile
index d0126c915834..bf52af4dfdf2 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -149,6 +149,7 @@ obj-$(CONFIG_CRYPTO_KHAZAD) += khazad.o
 obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
 obj-$(CONFIG_CRYPTO_SEED) += seed.o
 obj-$(CONFIG_CRYPTO_ARIA) += aria_generic.o
+obj-$(CONFIG_CRYPTO_LEA) += lea_generic.o
 obj-$(CONFIG_CRYPTO_CHACHA20) += chacha_generic.o
 obj-$(CONFIG_CRYPTO_POLY1305) += poly1305_generic.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
diff --git a/crypto/lea_generic.c b/crypto/lea_generic.c
new file mode 100644
index 000000000000..792db01a39e0
--- /dev/null
+++ b/crypto/lea_generic.c
@@ -0,0 +1,410 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Cryptographic API.
+ *
+ * The LEA Cipher Algorithm
+ *
+ * LEA is a 128-bit block cipher developed by South Korea.
+ *
+ * LEA is a Korean national standard (KS X 3246) and included in the ISO/IEC
+ * 29192-2:2019 standard (Information security - Lightweight cryptography -
+ * Part 2: Block ciphers).
+ *
+ * Copyright (c) 2023 National Security Research.
+ * Author: Dongsoo Lee <letrhee@nsr.re.kr>
+ */
+
+#include <asm/unaligned.h>
+#include <linux/module.h>
+#include <crypto/algapi.h>
+#include <crypto/lea.h>
+
+/*
+ * The eight 32-bit constant values δ[8] are used in the key schedule algorithm.
+ * They are the first 256-bits of the fractional part of
+ * sqrt(766965) = sqrt("LEA")
+ * The actual constant is additionally left-rotated from δ, which is to make the
+ * key schedule more compact.
+ * This constant can be calculated in Python as follows:
+ *
+ * from decimal import *
+ * rotl32 = lambda v, i: ((v << i) ^ (v >> (32 - i))) & 0xffffffff
+ * getcontext().prec = 87 # >= 32 * (8 + 1) / math.log(10, 2)
+ *
+ * LEA_ord = int(''.join([str(ord(ch)) for ch in "LEA"])) #766965
+ * sqrt_seq = Decimal(LEA_ord).sqrt()
+ *
+ * for i in range(8):
+ *   sqrt_seq = (sqrt_seq % 1) * (2 ** 32)
+ *   delta = int(sqrt_seq) #δ[i]
+ *   lea_const = rotl32(delta, i) #actual constant
+ *   print(hex(lea_const))
+ */
+static const u32 lea_constants[8] = {
+	0xc3efe9db, 0x88c4d604, 0xe789f229, 0xc6f98763,
+	0x15ea49e7, 0xf0bb4158, 0x13bc8ab8, 0xe204abf2,
+};
+
+#define LEA_SET_RK1(V, CV, ROT1, ROT2) (V = rol32(V + rol32(CV, ROT1), ROT2))
+
+#define LEA_SET_RK6(V0, V1, V2, V3, V4, V5, CV_ARR, ROT0, CV_IDX) \
+	do {                                                      \
+		const u32 CV_I = CV_ARR[CV_IDX];                  \
+		CV_ARR[CV_IDX] = rol32(CV_I, ROT0);               \
+		LEA_SET_RK1(V0, CV_I, 0, 1);                      \
+		LEA_SET_RK1(V1, CV_I, 1, 3);                      \
+		LEA_SET_RK1(V2, CV_I, 2, 6);                      \
+		LEA_SET_RK1(V3, CV_I, 3, 11);                     \
+		LEA_SET_RK1(V4, CV_I, 4, 13);                     \
+		LEA_SET_RK1(V5, CV_I, 5, 17);                     \
+	} while (0)
+
+#define STORE_RND_KEY6(RK, V0, V1, V2, V3, V4, V5, WAY) \
+	do {                                            \
+		RK[0] = V0;                             \
+		RK[1] = V1;                             \
+		RK[2] = V2;                             \
+		RK[3] = V3;                             \
+		RK[4] = V4;                             \
+		RK[5] = V5;                             \
+		RK += WAY * LEA_ROUND_KEY_WIDTH;        \
+	} while (0)
+
+/**
+ * LEA-128 can encrypt with four 32-bit integers as a round key. But in order to
+ * incorporate it with the encryption function for LEA-192 and LEA-256, one
+ * round key consists of six 32-bit integers.
+ */
+static void lea128_set_key(struct crypto_lea_ctx *key, const u8 *in_key)
+{
+	u32 x0 = get_unaligned_le32(&in_key[4 * 0]);
+	u32 x1 = get_unaligned_le32(&in_key[4 * 1]);
+	u32 x2 = get_unaligned_le32(&in_key[4 * 2]);
+	u32 x4 = get_unaligned_le32(&in_key[4 * 3]);
+
+	u32 *rk_enc = key->rk_enc;
+	u32 *rk_dec =
+		key->rk_dec + (LEA128_ROUND_CNT - 1) * LEA_ROUND_KEY_WIDTH;
+	u32 cv[4];
+	u32 rnd;
+
+	memcpy(cv, lea_constants, sizeof(cv));
+	key->round = LEA128_ROUND_CNT;
+
+	for (rnd = 0; rnd < LEA128_ROUND_CNT; ++rnd) {
+		const u32 offset = rnd % 4;
+		const u32 cv_i = cv[offset];
+
+		cv[offset] = rol32(cv_i, 4);
+		LEA_SET_RK1(x0, cv_i, 0, 1);
+		LEA_SET_RK1(x1, cv_i, 1, 3);
+		LEA_SET_RK1(x2, cv_i, 2, 6);
+		LEA_SET_RK1(x4, cv_i, 3, 11);
+
+		STORE_RND_KEY6(rk_enc, x0, x1, x2, x1, x4, x1, 1);
+		STORE_RND_KEY6(rk_dec, x0, x1, x2 ^ x1, x1, x4 ^ x1, x1, -1);
+	}
+}
+
+/**
+ * The key schedule for LEA-192 can be represented as follows,
+ * regarding the round key as an array of 32-bit integers.
+ *
+ * T[0:6] = K[0:6]
+ * for i in range(28):
+ *   T[0] = rotl32(T[0] + rotl32(delta[i % 6], i + 0), 1)
+ *   T[1] = rotl32(T[1] + rotl32(delta[i % 6], i + 1), 3)
+ *   T[2] = rotl32(T[2] + rotl32(delta[i % 6], i + 2), 6)
+ *   T[3] = rotl32(T[3] + rotl32(delta[i % 6], i + 3), 11)
+ *   T[4] = rotl32(T[4] + rotl32(delta[i % 6], i + 4), 13)
+ *   T[5] = rotl32(T[5] + rotl32(delta[i % 6], i + 5), 17)
+ *   RK[i*6:(i+1)*6] = T
+ *
+ * The key schedules of the LEA-128 and LEA-256 can be understood as variations
+ * of this calculation.
+ * The constants have already been left-rotated, so rotl32 of delta is
+ * simplified in each iteration.
+ */
+static void lea192_set_key(struct crypto_lea_ctx *key, const u8 *in_key)
+{
+	u32 x0 = get_unaligned_le32(&in_key[4 * 0]);
+	u32 x1 = get_unaligned_le32(&in_key[4 * 1]);
+	u32 x2 = get_unaligned_le32(&in_key[4 * 2]);
+	u32 x3 = get_unaligned_le32(&in_key[4 * 3]);
+	u32 x4 = get_unaligned_le32(&in_key[4 * 4]);
+	u32 x5 = get_unaligned_le32(&in_key[4 * 5]);
+
+	u32 *rk_enc = key->rk_enc;
+	u32 *rk_dec =
+		key->rk_dec + (LEA192_ROUND_CNT - 1) * LEA_ROUND_KEY_WIDTH;
+	u32 cv[6];
+	u32 rnd;
+
+	memcpy(cv, lea_constants, sizeof(cv));
+	key->round = LEA192_ROUND_CNT;
+
+	for (rnd = 0; rnd < LEA192_ROUND_CNT; ++rnd) {
+		const u32 offset = rnd % 6;
+
+		LEA_SET_RK6(x0, x1, x2, x3, x4, x5, cv, 6, offset);
+		STORE_RND_KEY6(rk_enc, x0, x1, x2, x3, x4, x5, 1);
+		STORE_RND_KEY6(rk_dec, x0, x1, x2 ^ x1, x3, x4 ^ x3, x5, -1);
+	}
+}
+
+/**
+ * In the LEA-256, the encryption key is eight 32-bit integers, which does not
+ * match LEA's round key width of 6. Therefore, partial loop unrolling is used
+ * to compute 4 round keys per loop.
+ */
+static void lea256_set_key(struct crypto_lea_ctx *key, const u8 *in_key)
+{
+	u32 x0 = get_unaligned_le32(&in_key[4 * 0]);
+	u32 x1 = get_unaligned_le32(&in_key[4 * 1]);
+	u32 x2 = get_unaligned_le32(&in_key[4 * 2]);
+	u32 x3 = get_unaligned_le32(&in_key[4 * 3]);
+	u32 x4 = get_unaligned_le32(&in_key[4 * 4]);
+	u32 x5 = get_unaligned_le32(&in_key[4 * 5]);
+	u32 x6 = get_unaligned_le32(&in_key[4 * 6]);
+	u32 x7 = get_unaligned_le32(&in_key[4 * 7]);
+
+	u32 *rk_enc = key->rk_enc;
+	u32 *rk_dec =
+		key->rk_dec + (LEA256_ROUND_CNT - 1) * LEA_ROUND_KEY_WIDTH;
+	u32 cv[8];
+	u32 rnd;
+
+	memcpy(cv, lea_constants, sizeof(cv));
+	key->round = LEA256_ROUND_CNT;
+
+	for (rnd = 0; rnd < LEA256_ROUND_CNT; rnd += 4) {
+		u32 offset = rnd % 8;
+
+		LEA_SET_RK6(x0, x1, x2, x3, x4, x5, cv, 8, offset);
+		STORE_RND_KEY6(rk_enc, x0, x1, x2, x3, x4, x5, 1);
+		STORE_RND_KEY6(rk_dec, x0, x1, x2 ^ x1, x3, x4 ^ x3, x5, -1);
+
+		++offset;
+		LEA_SET_RK6(x6, x7, x0, x1, x2, x3, cv, 8, offset);
+		STORE_RND_KEY6(rk_enc, x6, x7, x0, x1, x2, x3, 1);
+		STORE_RND_KEY6(rk_dec, x6, x7, x0 ^ x7, x1, x2 ^ x1, x3, -1);
+
+		++offset;
+		LEA_SET_RK6(x4, x5, x6, x7, x0, x1, cv, 8, offset);
+		STORE_RND_KEY6(rk_enc, x4, x5, x6, x7, x0, x1, 1);
+		STORE_RND_KEY6(rk_dec, x4, x5, x6 ^ x5, x7, x0 ^ x7, x1, -1);
+
+		++offset;
+		LEA_SET_RK6(x2, x3, x4, x5, x6, x7, cv, 8, offset);
+		STORE_RND_KEY6(rk_enc, x2, x3, x4, x5, x6, x7, 1);
+		STORE_RND_KEY6(rk_dec, x2, x3, x4 ^ x3, x5, x6 ^ x5, x7, -1);
+	}
+}
+
+int lea_set_key(struct crypto_lea_ctx *key, const u8 *in_key, u32 key_len)
+{
+	switch (key_len) {
+	case 16:
+		lea128_set_key(key, in_key);
+		return 0;
+	case 24:
+		lea192_set_key(key, in_key);
+		return 0;
+	case 32:
+		lea256_set_key(key, in_key);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(lea_set_key);
+
+/**
+ * The encryption round function can be represented as follows
+ *
+ * next_v3 = v0
+ * next_v2 = rotr32((v2 ^ RK[4]) + (v3 ^ RK[5]), 3);
+ * next_v1 = rotr32((v1 ^ RK[2]) + (v2 ^ RK[3]), 5);
+ * next_v0 = rotl32((v0 ^ RK[0]) + (v1 ^ RK[1]), 9);
+ *
+ * It is possible to avoid shuffling by partial unrolling, which unrolls 4
+ * rounds in a loop.
+ */
+#define LEA_ENC_RND(V0, V1, V2, V3, RK)                     \
+	do {                                                \
+		V3 = ror32((V2 ^ RK[4]) + (V3 ^ RK[5]), 3); \
+		V2 = ror32((V1 ^ RK[2]) + (V2 ^ RK[3]), 5); \
+		V1 = rol32((V0 ^ RK[0]) + (V1 ^ RK[1]), 9); \
+		RK += LEA_ROUND_KEY_WIDTH;                  \
+	} while (0)
+
+void lea_encrypt(const struct crypto_lea_ctx *key, u8 *out, const u8 *in)
+{
+	u32 x0 = get_unaligned_le32(&in[4 * 0]);
+	u32 x1 = get_unaligned_le32(&in[4 * 1]);
+	u32 x2 = get_unaligned_le32(&in[4 * 2]);
+	u32 x3 = get_unaligned_le32(&in[4 * 3]);
+
+	const u32 *rk = key->rk_enc;
+	const u32 *rk_tail = rk + LEA_ROUND_KEY_WIDTH * key->round;
+
+	while (rk < rk_tail) {
+		LEA_ENC_RND(x0, x1, x2, x3, rk);
+		LEA_ENC_RND(x1, x2, x3, x0, rk);
+		LEA_ENC_RND(x2, x3, x0, x1, rk);
+		LEA_ENC_RND(x3, x0, x1, x2, rk);
+	}
+
+	put_unaligned_le32(x0, &out[4 * 0]);
+	put_unaligned_le32(x1, &out[4 * 1]);
+	put_unaligned_le32(x2, &out[4 * 2]);
+	put_unaligned_le32(x3, &out[4 * 3]);
+}
+EXPORT_SYMBOL_GPL(lea_encrypt);
+
+/**
+ * The decryption round function for LEA is the inverse of encryption,
+ * so it can be represented as follows
+ *
+ * next_v0 = v3
+ * next_v1 = (rotr32(v0, 9) - (next_v0 ^ RK[0])) ^ RK[1];
+ * next_v2 = (rotl32(v1, 5) - (next_v1 ^ RK[2])) ^ RK[3];
+ * next_v3 = (rotl32(v2, 3) - (next_v2 ^ RK[4])) ^ RK[5];
+ *
+ * However, in the above expression, all previous steps must be computed to
+ * calculate next_v3.
+ * If the process is unpacked, the computation would look like this
+ *
+ * next_v0 = v3
+ * next_v1 = (rotr32(v0, 9) - (v3 ^ RK[0])) ^ RK[1];
+ * next_v2 = (rotl32(v1, 5) - ((rotr32(v0, 9) - (v3 ^ RK[0])) ^ RK[1] ^ RK[2]))
+ *           ^ RK[3];
+ * next_v3 = (rotl32(v2, 3) - ((rotl32(v1, 5)
+ *           - ((rotr32(v0, 9) - (v3 ^ RK[0])) ^ RK[1] ^ RK[2]))
+ *           ^ RK[3] ^ RK[4])) ^ RK[5];
+ *
+ * Letting (rotr32(v0, 9) - (v3 ^ RK[0])) be the intermediate value,
+ * it would look like
+ *
+ * next_v0 = v3
+ * tmp_v1  = (rotr32(v0, 9) - (v3 ^ RK[0]))
+ * next_v1 = tmp_v1 ^ RK[1];
+ * next_v2 = (rotl32(v1, 5) - (tmp_v1 ^ RK[1] ^ RK[2])) ^ RK[3];
+ * next_v3 = (rotl32(v2, 3) - ((rotl32(V1, 5) - (tmp_v1 ^ RK[1] ^ RK[2]))
+ *           ^ RK[3] ^ RK[4])) ^ RK[5];
+ *
+ * Similarly, letting (rotl32(v1, 5) - (tmp_v1 ^ RK[1] ^ RK[2])) be the
+ * intermediate value, it would look like this
+ *
+ * next_v0 = v3
+ * tmp_v1  = (rotr32(v0, 9) - (v3 ^ RK[0]))
+ * next_v1 = tmp_v1 ^ RK[1];
+ * tmp_v2  = (rotl32(v1, 5) - (tmp_v1 ^ RK[1] ^ RK[2]))
+ * next_v2 = tmp_v2 ^ RK[3];
+ * next_v3 = (rotl32(v2, 3) - (tmp_v2 ^ RK[3] ^ RK[4])) ^ RK[5];
+ *
+ * To reduce the operation of XORing RK twice to once, try using
+ * RKdec[0] = RK[0], RKdec[1] = RK[1], RKdec[2] = RK[1] ^ RK[2]
+ * RKdec[3] = RK[3], RKdec[4] = RK[3] ^ RK[4], RKdec[5] = RK[5]
+ *
+ * then the code can be rewritten as follows
+ *
+ * next_v0 = v3
+ * tmp_v1  = (rotr32(v0, 9) - (v3 ^ RKdec[0]));
+ * next_v1 = tmp_v1 ^ RKdec[1];
+ * tmp_v2  = (rotl32(v1, 5) - (tmp_v1 ^ RKdec[2]);
+ * next_v2 = tmp_v2 ^ RKdec[3];
+ * next_v3 = (rotl32(v2, 3) - (tmp_v2 ^ RKdec[4]) ^ RKdec[5];
+ *
+ * There is no difference in the number of operations, but there is two less
+ * data-dependent step, some operations can be performed simultaneously in the
+ * out-of-order processor.
+ */
+#define LEA_DEC_RND(V0, V1, V2, V3, TMP, RK)                 \
+	do {                                                 \
+		TMP = (ror32(V0, 9) - (V3 ^ RK[0]));         \
+		V0 = TMP ^ RK[1];                            \
+		TMP = (rol32(V1, 5) - (TMP ^ RK[2]));        \
+		V1 = TMP ^ RK[3];                            \
+		V2 = (rol32(V2, 3) - (TMP ^ RK[4])) ^ RK[5]; \
+		RK += LEA_ROUND_KEY_WIDTH;                   \
+	} while (0)
+
+void lea_decrypt(const struct crypto_lea_ctx *key, u8 *out, const u8 *in)
+{
+	const u32 *rk = key->rk_dec;
+	const u32 *rk_tail = rk + LEA_ROUND_KEY_WIDTH * key->round;
+
+	u32 x0 = get_unaligned_le32(&in[4 * 0]);
+	u32 x1 = get_unaligned_le32(&in[4 * 1]);
+	u32 x2 = get_unaligned_le32(&in[4 * 2]);
+	u32 x3 = get_unaligned_le32(&in[4 * 3]);
+	u32 tmp;
+
+	while (rk < rk_tail) {
+		LEA_DEC_RND(x0, x1, x2, x3, tmp, rk);
+		LEA_DEC_RND(x3, x0, x1, x2, tmp, rk);
+		LEA_DEC_RND(x2, x3, x0, x1, tmp, rk);
+		LEA_DEC_RND(x1, x2, x3, x0, tmp, rk);
+	};
+
+	put_unaligned_le32(x0, &out[4 * 0]);
+	put_unaligned_le32(x1, &out[4 * 1]);
+	put_unaligned_le32(x2, &out[4 * 2]);
+	put_unaligned_le32(x3, &out[4 * 3]);
+}
+EXPORT_SYMBOL_GPL(lea_decrypt);
+
+static int crypto_lea_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+			      u32 key_len)
+{
+	return lea_set_key(crypto_tfm_ctx(tfm), in_key, key_len);
+}
+
+static void crypto_lea_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	const struct crypto_lea_ctx *key = crypto_tfm_ctx(tfm);
+
+	lea_encrypt(key, out, in);
+}
+
+static void crypto_lea_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	const struct crypto_lea_ctx *key = crypto_tfm_ctx(tfm);
+
+	lea_decrypt(key, out, in);
+}
+
+static struct crypto_alg lea_alg = {
+	.cra_name = "lea",
+	.cra_driver_name = "lea-generic",
+	.cra_priority = 100,
+	.cra_flags = CRYPTO_ALG_TYPE_CIPHER,
+	.cra_blocksize = LEA_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct crypto_lea_ctx),
+	.cra_module = THIS_MODULE,
+	.cra_u = { .cipher = { .cia_min_keysize = LEA_MIN_KEY_SIZE,
+			       .cia_max_keysize = LEA_MAX_KEY_SIZE,
+			       .cia_setkey = crypto_lea_set_key,
+			       .cia_encrypt = crypto_lea_encrypt,
+			       .cia_decrypt = crypto_lea_decrypt } }
+};
+
+static int crypto_lea_init(void)
+{
+	return crypto_register_alg(&lea_alg);
+}
+
+static void crypto_lea_exit(void)
+{
+	crypto_unregister_alg(&lea_alg);
+}
+
+module_init(crypto_lea_init);
+module_exit(crypto_lea_exit);
+
+MODULE_DESCRIPTION("LEA Cipher Algorithm");
+MODULE_AUTHOR("Dongsoo Lee <letrhee@nsr.re.kr>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("lea");
+MODULE_ALIAS_CRYPTO("lea-generic");
diff --git a/include/crypto/lea.h b/include/crypto/lea.h
new file mode 100644
index 000000000000..0a438cf8f0d6
--- /dev/null
+++ b/include/crypto/lea.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Cryptographic API.
+ *
+ * The LEA Cipher Algorithm
+ *
+ * LEA is a 128-bit block cipher developed by South Korea.
+ *
+ * LEA is a Korean national standard (KS X 3246) and included in the ISO/IEC
+ * 29192-2:2019 standard (Information security - Lightweight cryptography -
+ * Part 2: Block ciphers).
+ *
+ * Copyright (c) 2023 National Security Research.
+ * Author: Dongsoo Lee <letrhee@nsr.re.kr>
+ */
+
+#ifndef _CRYPTO_LEA_H
+#define _CRYPTO_LEA_H
+
+#include <linux/types.h>
+
+#define LEA_MIN_KEY_SIZE 16
+#define LEA_MAX_KEY_SIZE 32
+#define LEA_BLOCK_SIZE 16
+#define LEA_ROUND_KEY_WIDTH 6
+
+#define LEA128_ROUND_CNT 24
+#define LEA192_ROUND_CNT 28
+#define LEA256_ROUND_CNT 32
+
+#define LEA_MAX_KEYLENGTH_U32 (LEA256_ROUND_CNT * LEA_ROUND_KEY_WIDTH)
+#define LEA_MAX_KEYLENGTH (LEA_MAX_KEYLENGTH_U32 * sizeof(u32))
+
+struct crypto_lea_ctx {
+	u32 round;
+	u32 rk_enc[LEA_MAX_KEYLENGTH_U32];
+	u32 rk_dec[LEA_MAX_KEYLENGTH_U32];
+};
+
+int lea_set_key(struct crypto_lea_ctx *key, const u8 *in_key, u32 key_len);
+void lea_encrypt(const struct crypto_lea_ctx *key, u8 *out, const u8 *in);
+void lea_decrypt(const struct crypto_lea_ctx *key, u8 *out, const u8 *in);
+
+#endif
-- 
2.34.1
