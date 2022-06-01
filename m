Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D2F539E00
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Jun 2022 09:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350219AbiFAHSj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Jun 2022 03:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350242AbiFAHSi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Jun 2022 03:18:38 -0400
Received: from mail-vk1-xa49.google.com (mail-vk1-xa49.google.com [IPv6:2607:f8b0:4864:20::a49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67253A1A1
        for <linux-fscrypt@vger.kernel.org>; Wed,  1 Jun 2022 00:18:36 -0700 (PDT)
Received: by mail-vk1-xa49.google.com with SMTP id m71-20020a1fa34a000000b003572cab1489so147032vke.4
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Jun 2022 00:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xCCB5zDb/K/3E5aM9WYFTX2Uc7twxEaR4jU1CSA3ieg=;
        b=a5978nP5GoeS1S+hck7z9bqYCHpvjOpGtmnrSYIbIhGM/2YCF0Zx5N7M0d2YY/U3+O
         +5WUYVswCKEVkxNbgPR0SbqPiFOGkzKp0AStLiINUNIzOnsRuJ+whtKNjGqZzYRB67rl
         atxY0d/5PaaETx0rWatMCSHcTvCL7OJVPm+FT0svsnLhjjXuyN/MqgCVXfCL7KVUrgob
         lLzv4lOpJEkGSq4fhYhvamwseG2eOLS+0USdH9HWatHQSPWcny8LrFIElNNmBNdkJMbx
         i5QE/uFblj1Glfsi/CjIfpEeJW5dfAaogp90OXD5b5n/hPzGJhOtDMV+Lxfs5pGZUxa/
         ZXBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xCCB5zDb/K/3E5aM9WYFTX2Uc7twxEaR4jU1CSA3ieg=;
        b=7xht1qIEC0RfQAmkrUATI9RPIkOIl7PJoksZ5i2tm0dGTMxnNijflZ8KUflaNbQ4L3
         LMil3cXIgfYU3aJV15fotJ3ZCTpG4mYn3a4sl5F1ay6fetWB2F/ijWzlSS0GQMfOOb8Y
         9uG2xMBUW482RmNTaUADYEWb5HrsHYA9RvckAIy3gjhqfAbBiQjtTh85n1FNrqytKbjl
         61wyJhosgd/vZchsiZFJB/jmwvysbh9i5TePTGhuCiB7gDNsKWlm2LCkuO4N2rTFWSy7
         b7L3QACFnYpGlH7jHmoesJ9QiTWwt3fRmiZ6KyUbUYMDbVV5s+0Uipb8YsYBTzlNxkNe
         kINA==
X-Gm-Message-State: AOAM532YL8NHpIFpaSb4eSUddxeShahUNGJv8d35Q7K+9YvFAnfYTnub
        E4M3bwHICa+7q1HFXnnTuepUHYPgLA==
X-Google-Smtp-Source: ABdhPJwZBRqh+tN7Kq0a47YttBg6oS3iPgYOWUZQCz4SDgtTqFsIzfOdxFaa3xj1rmtaTSXvlCePkwbHEw==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:ab0:3492:0:b0:368:b577:bfd with SMTP id
 c18-20020ab03492000000b00368b5770bfdmr22391896uar.110.1654067915741; Wed, 01
 Jun 2022 00:18:35 -0700 (PDT)
Date:   Wed,  1 Jun 2022 00:18:10 -0700
In-Reply-To: <20220601071811.1353635-1-nhuck@google.com>
Message-Id: <20220601071811.1353635-2-nhuck@google.com>
Mime-Version: 1.0
References: <20220601071811.1353635-1-nhuck@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [RFC PATCH v4 1/2] fscrypt-crypt-util: add HCTR2 implementation
From:   Nathan Huckleberry <nhuck@google.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
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

This patch adds an implementation of HCTR2 to the fscrypt testing
utility.

More information on HCTR2 can be found here: "Length-preserving
encryption with HCTR2": https://ia.cr/2021/1441

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 common/encrypt           |   2 +
 src/fscrypt-crypt-util.c | 341 ++++++++++++++++++++++++++++++++-------
 2 files changed, 286 insertions(+), 57 deletions(-)

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
index 03cc3c4a..6e91577e 100644
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
+void gf2_128_mul_polyval(ble128 *r, const ble128 *b)
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
@@ -901,6 +987,41 @@ static void test_hkdf_sha512(void)
 }
 #endif /* ENABLE_ALG_TESTS */
 
+/*----------------------------------------------------------------------------*
+ *                                 POLYVAL                                     *
+ *----------------------------------------------------------------------------*/
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
+	size_t chunk_size;
+	// x^{-128} = x^127 + x^124 + x^121 + x^114 + 1
+	static const ble128 inv128 = {
+		cpu_to_le64(1),
+		cpu_to_le64(0x9204ULL << 48)
+	};
+
+	memcpy(&h, key, POLYVAL_BLOCK_SIZE);
+	memcpy(&aligned_accumulator, accumulator, POLYVAL_BLOCK_SIZE);
+	gf2_128_mul_polyval(&h, &inv128);
+
+	while (msglen > 0) {
+		chunk_size = MIN(POLYVAL_BLOCK_SIZE, msglen);
+		xor((u8 *)&aligned_accumulator, (u8 *)&aligned_accumulator, msg,
+		    chunk_size);
+		gf2_128_mul_polyval(&aligned_accumulator, &h);
+		msg += chunk_size;
+		msglen -= chunk_size;
+	}
+	memcpy(accumulator, &aligned_accumulator, POLYVAL_BLOCK_SIZE);
+}
+
 /*----------------------------------------------------------------------------*
  *                            AES encryption modes                            *
  *----------------------------------------------------------------------------*/
@@ -924,7 +1045,7 @@ static void aes_256_xts_crypt(const u8 key[2 * AES_256_KEY_SIZE],
 		else
 			aes_encrypt(&cipher_key, &dst[i], &dst[i]);
 		xor(&dst[i], &dst[i], (const u8 *)&t, AES_BLOCK_SIZE);
-		gf2_128_mul_x(&t);
+		gf2_128_mul_x_xts(&t);
 	}
 }
 
@@ -1173,6 +1294,157 @@ static void aes_128_cts_cbc_decrypt(const u8 key[AES_128_KEY_SIZE],
 	aes_cts_cbc_decrypt(key, AES_128_KEY_SIZE, iv, src, dst, nbytes);
 }
 
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
@@ -1500,58 +1772,6 @@ static void adiantum_decrypt(const u8 key[ADIANTUM_KEY_SIZE],
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
@@ -1675,6 +1895,12 @@ static const struct fscrypt_cipher {
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
@@ -1980,6 +2206,7 @@ int main(int argc, char *argv[])
 	test_aes_256_xts();
 	test_aes_256_cts_cbc();
 	test_adiantum();
+	test_aes_256_hctr2();
 #endif
 
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
-- 
2.36.1.255.ge46751e96f-goog

