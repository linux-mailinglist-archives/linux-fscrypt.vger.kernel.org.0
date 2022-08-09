Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D1D58DFB7
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Aug 2022 21:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344466AbiHITFL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 9 Aug 2022 15:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245431AbiHITEI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 9 Aug 2022 15:04:08 -0400
Received: from mail-vs1-xe49.google.com (mail-vs1-xe49.google.com [IPv6:2607:f8b0:4864:20::e49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18313B1CF
        for <linux-fscrypt@vger.kernel.org>; Tue,  9 Aug 2022 11:40:43 -0700 (PDT)
Received: by mail-vs1-xe49.google.com with SMTP id v67-20020a676146000000b0038899813921so1943986vsb.4
        for <linux-fscrypt@vger.kernel.org>; Tue, 09 Aug 2022 11:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=JJreHpxkGplGgWlVxY/T21izlepvyKv45Ur44tYGtrs=;
        b=deTKfK/pG+UhD6xCk6Q0WSysgssZSf7LPqPAh0xkZzaMmHI33B1KKOZo1RoX7nHWtX
         8eGPETqrC6m8f7e8yGaSAcagaOF6jPmJlJtiLVWX9XWL17QQFJUu/+4fW5p7tOGhcEKE
         /h+n2ZGT7+Eyap2Yd/pz5c9p/IK16zTKV/CHz6W8QYtm4c280D6qnr5F7+nhU2EFw78Y
         TbS9sOnEeA/ptLE8bPC+vnQah/sn2eQE0mKc+bpsO/ZfQK1dOaPOteS4ESVMcY7fZslB
         tf2b0dfohHuGaJWxWXezJKdbdCaQEofxoDWvzQoT/0luDoicCigF25s3tAsZxvIr7DwS
         jXzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=JJreHpxkGplGgWlVxY/T21izlepvyKv45Ur44tYGtrs=;
        b=7532QAI8HJ+4wglcLbO+diRvr0pyS42XaaMMMs/LetSsLwP2+ff/g0HaB6d7qE8MmI
         BFE/H6QIAJKWVw6SvfwJDBYgXiErSwNJ04JJH6huJg9ZkoGMPHk8P4lzdkVdUZKxq8r1
         Hy8UycAkhz3crfL7vQOaEeJVi2b1AY2z2Q7+JnkGU0Ev/JGjVVFJ94599Rf9kSFahmrP
         THg2eH8UMzmlE8cKCV38yfr51kx2raIBEA+cWmtgghpB7mHsSMOPD4SgJR5ImVE4RyJ5
         G8JGzHKm/vpfgL8AzfSVmmeKS75hGfZH5gqCiSGGLieAPTihRmBdqtIWocLpKQO7323z
         f2kA==
X-Gm-Message-State: ACgBeo3f5IKs7FqC3lWiXTQasl1p1B2GHsnqTBN26KoSb1FjpK/UdOJH
        meXdcnU+A843RxCZBYt/lX5TcF4u5Q==
X-Google-Smtp-Source: AA6agR6Oibc7GRMszTt0UQR8qNLP0FGfc3V7TFKalFwE0j186rPBEv8ZRbqRuFDTZtxZzqn5lUfF2QAfQQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a67:e3c7:0:b0:388:b85e:4e8b with SMTP id
 k7-20020a67e3c7000000b00388b85e4e8bmr4225522vsm.43.1660070442205; Tue, 09 Aug
 2022 11:40:42 -0700 (PDT)
Date:   Tue,  9 Aug 2022 11:40:36 -0700
In-Reply-To: <20220809184037.636578-1-nhuck@google.com>
Message-Id: <20220809184037.636578-2-nhuck@google.com>
Mime-Version: 1.0
References: <20220809184037.636578-1-nhuck@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v6 1/2] fscrypt-crypt-util: add HCTR2 implementation
From:   Nathan Huckleberry <nhuck@google.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
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

This patch adds an implementation of HCTR2 to the fscrypt testing
utility.

More information on HCTR2 can be found here: "Length-preserving
encryption with HCTR2": https://ia.cr/2021/1441

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Tested-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt           |   2 +
 src/fscrypt-crypt-util.c | 357 ++++++++++++++++++++++++++++++++-------
 2 files changed, 302 insertions(+), 57 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index f90c4ef0..937bb914 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -767,6 +767,7 @@ FSCRYPT_MODE_AES_256_CTS=4
 FSCRYPT_MODE_AES_128_CBC=5
 FSCRYPT_MODE_AES_128_CTS=6
 FSCRYPT_MODE_ADIANTUM=9
+FSCRYPT_MODE_AES_256_HCTR2=10
 
 FSCRYPT_POLICY_FLAG_DIRECT_KEY=0x04
 FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64=0x08
@@ -785,6 +786,7 @@ _fscrypt_mode_name_to_num()
 	AES-128-CBC-ESSIV)	echo $FSCRYPT_MODE_AES_128_CBC ;;
 	AES-128-CTS-CBC)	echo $FSCRYPT_MODE_AES_128_CTS ;;
 	Adiantum)		echo $FSCRYPT_MODE_ADIANTUM ;;
+	AES-256-HCTR2)		echo $FSCRYPT_MODE_AES_256_HCTR2 ;;
 	*)			_fail "Unknown fscrypt mode: $name" ;;
 	esac
 }
diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 03cc3c4a..aa75a4d6 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -37,7 +37,8 @@
 /*
  * Define to enable the tests of the crypto code in this file.  If enabled, you
  * must link this program with OpenSSL (-lcrypto) v1.1.0 or later, and your
- * kernel needs CONFIG_CRYPTO_USER_API_SKCIPHER=y and CONFIG_CRYPTO_ADIANTUM=y.
+ * kernel needs CONFIG_CRYPTO_USER_API_SKCIPHER=y, CONFIG_CRYPTO_ADIANTUM=y, and
+ * CONFIG_CRYPTO_HCTR2=y.
  */
 #undef ENABLE_ALG_TESTS
 
@@ -54,7 +55,8 @@ static void usage(FILE *fp)
 "resulting ciphertext (or plaintext) to stdout.\n"
 "\n"
 "CIPHER can be AES-256-XTS, AES-256-CTS-CBC, AES-128-CBC-ESSIV, AES-128-CTS-CBC,\n"
-"or Adiantum.  MASTER_KEY must be a hex string long enough for the cipher.\n"
+"Adiantum, or AES-256-HCTR2.  MASTER_KEY must be a hex string long enough for\n"
+"the cipher.\n"
 "\n"
 "WARNING: this program is only meant for testing, not for \"real\" use!\n"
 "\n"
@@ -268,7 +270,59 @@ static void rand_bytes(u8 *buf, size_t count)
 	while (count--)
 		*buf++ = rand();
 }
-#endif
+
+#include <linux/if_alg.h>
+#include <sys/socket.h>
+#define SOL_ALG 279
+static void af_alg_crypt(int algfd, int op, const u8 *key, size_t keylen,
+			 const u8 *iv, size_t ivlen,
+			 const u8 *src, u8 *dst, size_t datalen)
+{
+	size_t controllen = CMSG_SPACE(sizeof(int)) +
+			    CMSG_SPACE(sizeof(struct af_alg_iv) + ivlen);
+	u8 *control = xmalloc(controllen);
+	struct iovec iov = { .iov_base = (u8 *)src, .iov_len = datalen };
+	struct msghdr msg = {
+		.msg_iov = &iov,
+		.msg_iovlen = 1,
+		.msg_control = control,
+		.msg_controllen = controllen,
+	};
+	struct cmsghdr *cmsg;
+	struct af_alg_iv *algiv;
+	int reqfd;
+
+	memset(control, 0, controllen);
+
+	cmsg = CMSG_FIRSTHDR(&msg);
+	cmsg->cmsg_len = CMSG_LEN(sizeof(int));
+	cmsg->cmsg_level = SOL_ALG;
+	cmsg->cmsg_type = ALG_SET_OP;
+	*(int *)CMSG_DATA(cmsg) = op;
+
+	cmsg = CMSG_NXTHDR(&msg, cmsg);
+	cmsg->cmsg_len = CMSG_LEN(sizeof(struct af_alg_iv) + ivlen);
+	cmsg->cmsg_level = SOL_ALG;
+	cmsg->cmsg_type = ALG_SET_IV;
+	algiv = (struct af_alg_iv *)CMSG_DATA(cmsg);
+	algiv->ivlen = ivlen;
+	memcpy(algiv->iv, iv, ivlen);
+
+	if (setsockopt(algfd, SOL_ALG, ALG_SET_KEY, key, keylen) != 0)
+		die_errno("can't set key on AF_ALG socket");
+
+	reqfd = accept(algfd, NULL, NULL);
+	if (reqfd < 0)
+		die_errno("can't accept() AF_ALG socket");
+	if (sendmsg(reqfd, &msg, 0) != datalen)
+		die_errno("can't sendmsg() AF_ALG request socket");
+	if (xread(reqfd, dst, datalen) != datalen)
+		die("short read from AF_ALG request socket");
+	close(reqfd);
+
+	free(control);
+}
+#endif /* ENABLE_ALG_TESTS */
 
 /*----------------------------------------------------------------------------*
  *                          Finite field arithmetic                           *
@@ -293,7 +347,7 @@ typedef struct {
 } ble128;
 
 /* Multiply a GF(2^128) element by the polynomial 'x' */
-static inline void gf2_128_mul_x(ble128 *t)
+static inline void gf2_128_mul_x_xts(ble128 *t)
 {
 	u64 lo = le64_to_cpu(t->lo);
 	u64 hi = le64_to_cpu(t->hi);
@@ -302,6 +356,38 @@ static inline void gf2_128_mul_x(ble128 *t)
 	t->lo = cpu_to_le64((lo << 1) ^ ((hi & (1ULL << 63)) ? 0x87 : 0));
 }
 
+static inline void gf2_128_mul_x_polyval(ble128 *t)
+{
+	u64 lo = le64_to_cpu(t->lo);
+	u64 hi = le64_to_cpu(t->hi);
+	u64 lo_reducer = (hi & (1ULL << 63)) ? 1 : 0;
+	u64 hi_reducer = (hi & (1ULL << 63)) ? 0xc2ULL << 56 : 0;
+
+	t->hi = cpu_to_le64(((hi << 1) | (lo >> 63)) ^ hi_reducer);
+	t->lo = cpu_to_le64((lo << 1) ^ lo_reducer);
+}
+
+static void gf2_128_mul_polyval(ble128 *r, const ble128 *b)
+{
+	int i;
+	ble128 p;
+	u64 lo = le64_to_cpu(b->lo);
+	u64 hi = le64_to_cpu(b->hi);
+
+	memset(&p, 0, sizeof(p));
+	for (i = 0; i < 64; i++) {
+		if (lo & (1ULL << i))
+			xor((u8 *)&p, (u8 *)&p, (u8 *)r, sizeof(p));
+		gf2_128_mul_x_polyval(r);
+	}
+	for (i = 0; i < 64; i++) {
+		if (hi & (1ULL << i))
+			xor((u8 *)&p, (u8 *)&p, (u8 *)r, sizeof(p));
+		gf2_128_mul_x_polyval(r);
+	}
+	*r = p;
+}
+
 /*----------------------------------------------------------------------------*
  *                             Group arithmetic                               *
  *----------------------------------------------------------------------------*/
@@ -901,6 +987,47 @@ static void test_hkdf_sha512(void)
 }
 #endif /* ENABLE_ALG_TESTS */
 
+/*----------------------------------------------------------------------------*
+ *                                 POLYVAL                                     *
+ *----------------------------------------------------------------------------*/
+
+/*
+ * Reference: "AES-GCM-SIV: Nonce Misuse-Resistant Authenticated Encryption"
+ *	https://datatracker.ietf.org/doc/html/rfc8452
+ */
+
+#define POLYVAL_KEY_SIZE	16
+#define POLYVAL_BLOCK_SIZE	16
+
+static void polyval_update(const u8 key[POLYVAL_KEY_SIZE],
+			   const u8 *msg, size_t msglen,
+			   u8 accumulator[POLYVAL_BLOCK_SIZE])
+{
+	ble128 h;
+	ble128 aligned_accumulator;
+	// x^{-128} = x^127 + x^124 + x^121 + x^114 + 1
+	static const ble128 inv128 = {
+		cpu_to_le64(1),
+		cpu_to_le64(0x9204ULL << 48)
+	};
+
+	/* Partial block support is not necessary for HCTR2 */
+	ASSERT(msglen % POLYVAL_BLOCK_SIZE == 0);
+
+	memcpy(&h, key, POLYVAL_BLOCK_SIZE);
+	memcpy(&aligned_accumulator, accumulator, POLYVAL_BLOCK_SIZE);
+	gf2_128_mul_polyval(&h, &inv128);
+
+	while (msglen > 0) {
+		xor((u8 *)&aligned_accumulator, (u8 *)&aligned_accumulator, msg,
+		    POLYVAL_BLOCK_SIZE);
+		gf2_128_mul_polyval(&aligned_accumulator, &h);
+		msg += POLYVAL_BLOCK_SIZE;
+		msglen -= POLYVAL_BLOCK_SIZE;
+	}
+	memcpy(accumulator, &aligned_accumulator, POLYVAL_BLOCK_SIZE);
+}
+
 /*----------------------------------------------------------------------------*
  *                            AES encryption modes                            *
  *----------------------------------------------------------------------------*/
@@ -924,7 +1051,7 @@ static void aes_256_xts_crypt(const u8 key[2 * AES_256_KEY_SIZE],
 		else
 			aes_encrypt(&cipher_key, &dst[i], &dst[i]);
 		xor(&dst[i], &dst[i], (const u8 *)&t, AES_BLOCK_SIZE);
-		gf2_128_mul_x(&t);
+		gf2_128_mul_x_xts(&t);
 	}
 }
 
@@ -1173,6 +1300,167 @@ static void aes_128_cts_cbc_decrypt(const u8 key[AES_128_KEY_SIZE],
 	aes_cts_cbc_decrypt(key, AES_128_KEY_SIZE, iv, src, dst, nbytes);
 }
 
+/*
+ * Reference: "Length-preserving encryption with HCTR2"
+ *	https://ia.cr/2021/1441
+ */
+
+static void aes_256_xctr_crypt(const u8 key[AES_256_KEY_SIZE],
+			      const u8 iv[AES_BLOCK_SIZE], const u8 *src,
+			      u8 *dst, size_t nbytes)
+{
+	struct aes_key k;
+	union {
+		u8 bytes[AES_BLOCK_SIZE];
+		__le64 ctr;
+	} blk;
+	size_t i;
+
+	aes_setkey(&k, key, AES_256_KEY_SIZE);
+
+	for (i = 0; i < nbytes; i += AES_BLOCK_SIZE) {
+		memcpy(blk.bytes, iv, AES_BLOCK_SIZE);
+		blk.ctr ^= cpu_to_le64((i / AES_BLOCK_SIZE) + 1);
+		aes_encrypt(&k, blk.bytes, blk.bytes);
+		xor(&dst[i], blk.bytes, &src[i], MIN(AES_BLOCK_SIZE, nbytes - i));
+	}
+}
+
+/*
+ * Reference: "Length-preserving encryption with HCTR2"
+ *	https://ia.cr/2021/1441
+ */
+
+#define HCTR2_IV_SIZE 32
+static void hctr2_hash_iv(const u8 hbar[POLYVAL_KEY_SIZE],
+			  const u8 iv[HCTR2_IV_SIZE], size_t msglen,
+			  u8 digest[POLYVAL_BLOCK_SIZE])
+{
+	le128 tweaklen_blk = {
+		.lo = cpu_to_le64(HCTR2_IV_SIZE * 8 * 2 + 2 +
+				  (msglen % AES_BLOCK_SIZE != 0))
+	};
+
+	memset(digest, 0, POLYVAL_BLOCK_SIZE);
+	polyval_update(hbar, (u8 *)&tweaklen_blk, POLYVAL_BLOCK_SIZE, digest);
+	polyval_update(hbar, iv, HCTR2_IV_SIZE, digest);
+}
+
+static void hctr2_hash_message(const u8 hbar[POLYVAL_KEY_SIZE],
+			       const u8 *msg, size_t msglen,
+			       u8 digest[POLYVAL_BLOCK_SIZE])
+{
+	size_t remainder = msglen % AES_BLOCK_SIZE;
+	u8 padded_block[POLYVAL_BLOCK_SIZE] = {0};
+
+	polyval_update(hbar, msg, msglen - remainder, digest);
+	if (remainder) {
+		memcpy(padded_block, &msg[msglen - remainder], remainder);
+		padded_block[remainder] = 1;
+		polyval_update(hbar, padded_block, POLYVAL_BLOCK_SIZE, digest);
+	}
+}
+
+static void aes_256_hctr2_crypt(const u8 key[AES_256_KEY_SIZE],
+				const u8 iv[HCTR2_IV_SIZE], const u8 *src,
+				u8 *dst, size_t nbytes, bool decrypting)
+{
+	struct aes_key k;
+	u8 hbar[AES_BLOCK_SIZE] = {0};
+	u8 L[AES_BLOCK_SIZE] = {1};
+	size_t bulk_bytes = nbytes - AES_BLOCK_SIZE;
+	u8 digest[POLYVAL_BLOCK_SIZE];
+	const u8 *M = src;
+	const u8 *N = src + AES_BLOCK_SIZE;
+	u8 MM[AES_BLOCK_SIZE];
+	u8 UU[AES_BLOCK_SIZE];
+	u8 S[AES_BLOCK_SIZE];
+	u8 *U = dst;
+	u8 *V = dst + AES_BLOCK_SIZE;
+
+	ASSERT(nbytes >= AES_BLOCK_SIZE);
+	aes_setkey(&k, key, AES_256_KEY_SIZE);
+
+	aes_encrypt(&k, hbar, hbar);
+	aes_encrypt(&k, L, L);
+
+	hctr2_hash_iv(hbar, iv, bulk_bytes, digest);
+	hctr2_hash_message(hbar, N, bulk_bytes, digest);
+
+	xor(MM, M, digest, AES_BLOCK_SIZE);
+
+	if (decrypting)
+		aes_decrypt(&k, MM, UU);
+	else
+		aes_encrypt(&k, MM, UU);
+
+	xor(S, MM, UU, AES_BLOCK_SIZE);
+	xor(S, L, S, AES_BLOCK_SIZE);
+
+	aes_256_xctr_crypt(key, S, N, V, bulk_bytes);
+
+	hctr2_hash_iv(hbar, iv, bulk_bytes, digest);
+	hctr2_hash_message(hbar, V, bulk_bytes, digest);
+
+	xor(U, UU, digest, AES_BLOCK_SIZE);
+}
+
+static void aes_256_hctr2_encrypt(const u8 key[AES_256_KEY_SIZE],
+				  const u8 iv[HCTR2_IV_SIZE], const u8 *src,
+				  u8 *dst, size_t nbytes)
+{
+	aes_256_hctr2_crypt(key, iv, src, dst, nbytes, false);
+}
+
+static void aes_256_hctr2_decrypt(const u8 key[AES_256_KEY_SIZE],
+				  const u8 iv[HCTR2_IV_SIZE], const u8 *src,
+				  u8 *dst, size_t nbytes)
+{
+	aes_256_hctr2_crypt(key, iv, src, dst, nbytes, true);
+}
+
+#ifdef ENABLE_ALG_TESTS
+#include <linux/if_alg.h>
+#include <sys/socket.h>
+static void test_aes_256_hctr2(void)
+{
+	int algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
+	struct sockaddr_alg addr = {
+		.salg_type = "skcipher",
+		.salg_name = "hctr2(aes)",
+	};
+	unsigned long num_tests = NUM_ALG_TEST_ITERATIONS;
+
+	if (algfd < 0)
+		die_errno("can't create AF_ALG socket");
+	if (bind(algfd, (struct sockaddr *)&addr, sizeof(addr)) != 0)
+		die_errno("can't bind AF_ALG socket to HCTR2 algorithm");
+
+	while (num_tests--) {
+		u8 key[AES_256_KEY_SIZE];
+		u8 iv[HCTR2_IV_SIZE];
+		u8 ptext[4096];
+		u8 ctext[sizeof(ptext)];
+		u8 ref_ctext[sizeof(ptext)];
+		u8 decrypted[sizeof(ptext)];
+		const size_t datalen = 16 + (rand() % (sizeof(ptext) - 15));
+
+		rand_bytes(key, sizeof(key));
+		rand_bytes(iv, sizeof(iv));
+		rand_bytes(ptext, datalen);
+
+		aes_256_hctr2_encrypt(key, iv, ptext, ctext, datalen);
+		af_alg_crypt(algfd, ALG_OP_ENCRYPT, key, sizeof(key),
+			     iv, sizeof(iv), ptext, ref_ctext, datalen);
+		ASSERT(memcmp(ctext, ref_ctext, datalen) == 0);
+
+		aes_256_hctr2_decrypt(key, iv, ctext, decrypted, datalen);
+		ASSERT(memcmp(ptext, decrypted, datalen) == 0);
+	}
+	close(algfd);
+}
+#endif /* ENABLE_ALG_TESTS */
+
 /*----------------------------------------------------------------------------*
  *                           XChaCha12 stream cipher                          *
  *----------------------------------------------------------------------------*/
@@ -1500,58 +1788,6 @@ static void adiantum_decrypt(const u8 key[ADIANTUM_KEY_SIZE],
 }
 
 #ifdef ENABLE_ALG_TESTS
-#include <linux/if_alg.h>
-#include <sys/socket.h>
-#define SOL_ALG 279
-static void af_alg_crypt(int algfd, int op, const u8 *key, size_t keylen,
-			 const u8 *iv, size_t ivlen,
-			 const u8 *src, u8 *dst, size_t datalen)
-{
-	size_t controllen = CMSG_SPACE(sizeof(int)) +
-			    CMSG_SPACE(sizeof(struct af_alg_iv) + ivlen);
-	u8 *control = xmalloc(controllen);
-	struct iovec iov = { .iov_base = (u8 *)src, .iov_len = datalen };
-	struct msghdr msg = {
-		.msg_iov = &iov,
-		.msg_iovlen = 1,
-		.msg_control = control,
-		.msg_controllen = controllen,
-	};
-	struct cmsghdr *cmsg;
-	struct af_alg_iv *algiv;
-	int reqfd;
-
-	memset(control, 0, controllen);
-
-	cmsg = CMSG_FIRSTHDR(&msg);
-	cmsg->cmsg_len = CMSG_LEN(sizeof(int));
-	cmsg->cmsg_level = SOL_ALG;
-	cmsg->cmsg_type = ALG_SET_OP;
-	*(int *)CMSG_DATA(cmsg) = op;
-
-	cmsg = CMSG_NXTHDR(&msg, cmsg);
-	cmsg->cmsg_len = CMSG_LEN(sizeof(struct af_alg_iv) + ivlen);
-	cmsg->cmsg_level = SOL_ALG;
-	cmsg->cmsg_type = ALG_SET_IV;
-	algiv = (struct af_alg_iv *)CMSG_DATA(cmsg);
-	algiv->ivlen = ivlen;
-	memcpy(algiv->iv, iv, ivlen);
-
-	if (setsockopt(algfd, SOL_ALG, ALG_SET_KEY, key, keylen) != 0)
-		die_errno("can't set key on AF_ALG socket");
-
-	reqfd = accept(algfd, NULL, NULL);
-	if (reqfd < 0)
-		die_errno("can't accept() AF_ALG socket");
-	if (sendmsg(reqfd, &msg, 0) != datalen)
-		die_errno("can't sendmsg() AF_ALG request socket");
-	if (xread(reqfd, dst, datalen) != datalen)
-		die("short read from AF_ALG request socket");
-	close(reqfd);
-
-	free(control);
-}
-
 static void test_adiantum(void)
 {
 	int algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
@@ -1675,6 +1911,12 @@ static const struct fscrypt_cipher {
 		.decrypt = aes_128_cts_cbc_decrypt,
 		.keysize = AES_128_KEY_SIZE,
 		.min_input_size = AES_BLOCK_SIZE,
+	}, {
+		.name = "AES-256-HCTR2",
+		.encrypt = aes_256_hctr2_encrypt,
+		.decrypt = aes_256_hctr2_decrypt,
+		.keysize = AES_256_KEY_SIZE,
+		.min_input_size = AES_BLOCK_SIZE,
 	}, {
 		.name = "Adiantum",
 		.encrypt = adiantum_encrypt,
@@ -1980,6 +2222,7 @@ int main(int argc, char *argv[])
 	test_aes_256_xts();
 	test_aes_256_cts_cbc();
 	test_adiantum();
+	test_aes_256_hctr2();
 #endif
 
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
-- 
2.37.1.559.g78731f0fdb-goog

