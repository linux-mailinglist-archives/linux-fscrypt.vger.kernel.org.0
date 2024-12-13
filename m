Return-Path: <linux-fscrypt+bounces-569-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E9A59F0438
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 06:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 496902835D4
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A589C188724;
	Fri, 13 Dec 2024 05:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+X9Lt3T"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5B4188704;
	Fri, 13 Dec 2024 05:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734067736; cv=none; b=M9A+EaykNe9/8wmvvYxOqlV4GTsjnw78bt1u5RvdFTv81sxX/ZzgH8xnXxb8al935ItabKlXD/NQMfwM96HrsuNT68EwslO1/HTfuekTlmn6foIxTu2TtXzhSF+vuhKvxV0/aNTNqbnZgxMb7B4C2o/qGQAdebetuZD+4qYxiho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734067736; c=relaxed/simple;
	bh=4lVwDJfz8o6ckrb9c9DVbwZVt61mRQPBQylprA81kXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbbkikRT0bPthimYT3QbisfJn8Tg6xXKA/s7wh1qrwixmqrEpBIee8d6QnuQWMkT/MljEwSOZs/7E/AdsNmJraefH7J6VJddo1ZhMv0VuNZuXTYzUbH7N++cISfizHZqmUa3Mruwq6BeuucLkjrePj3GKBPPQUOz1kROM0RBXUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+X9Lt3T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E069EC4CED6;
	Fri, 13 Dec 2024 05:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734067736;
	bh=4lVwDJfz8o6ckrb9c9DVbwZVt61mRQPBQylprA81kXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+X9Lt3TPrCnSqCrTDyk7iGyB0vcZPcnz8ypHQwwem70T34aKYTyOrC35m/VTRqC+
	 qY2AQ4eIVeNZL8eXDxWEWRqsn0VciCCPCWCIZD4dISZoJppOxDfu0E7MhFXyDAb6rT
	 ZU/EavFxnJNDqeBlEmmKTBWzmwKBftg+cAec2v1duK7ZcHBt+nj7VuK8NZdhfXVjM/
	 AKO+l0CbFZR12MxuAslqQfW2lfJAo18JuomuhblEMALsuvAQF0+38W9/wHDzbMJbDn
	 czw71DA9Sk2dj5LelvGGQh2qlHHeVLj6sC4ZXEgLkYDIQkWEYHb+k6YTVL/8Ei9aQI
	 GBQW80wZ0PbYQ==
From: Eric Biggers <ebiggers@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH v2 1/3] fscrypt-crypt-util: add hardware KDF support
Date: Thu, 12 Dec 2024 21:28:37 -0800
Message-ID: <20241213052840.314921-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241213052840.314921-1-ebiggers@kernel.org>
References: <20241213052840.314921-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add support to fscrypt-crypt-util for replicating the extra KDF (Key
Derivation Function) step that is required when a hardware-wrapped
inline encryption key is used.  This step normally occurs in hardware,
but we need to replicate it for testing purposes.

Note, some care was needed to handle the fact that both inlinecrypt_key
and sw_secret can be needed in a single run of fscrypt-crypt-util.
Namely, with --iv-ino-lblk-32, inlinecrypt_key is needed for the
en/decryption while sw_secret is needed for hash_inode_number().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 251 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 240 insertions(+), 11 deletions(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index a1b5005d..4dde1d4a 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -68,10 +68,14 @@ static void usage(FILE *fp)
 "  --decrypt                   Decrypt instead of encrypt\n"
 "  --direct-key                Use the format where the IVs include the file\n"
 "                                nonce and the same key is shared across files.\n"
 "  --dump-key-identifier       Instead of encrypting/decrypting data, just\n"
 "                                compute and dump the key identifier.\n"
+"  --enable-hw-kdf             Apply the hardware KDF (replicated in software)\n"
+"                                to the key before using it.  Use this to\n"
+"                                replicate the en/decryption that is done when\n"
+"                                the filesystem is given a hardware-wrapped key.\n"
 "  --file-nonce=NONCE          File's nonce as a 32-character hex string\n"
 "  --fs-uuid=UUID              The filesystem UUID as a 32-character hex string.\n"
 "                                Required for --iv-ino-lblk-32 and\n"
 "                                --iv-ino-lblk-64; otherwise is unused.\n"
 "  --help                      Show this help\n"
@@ -86,10 +90,14 @@ static void usage(FILE *fp)
 "                                HKDF-SHA512, or none.  Default: none\n"
 "  --mode-num=NUM              The encryption mode number.  This may be required\n"
 "                                for key derivation, depending on other options.\n"
 "  --padding=PADDING           If last data unit is partial, zero-pad it to next\n"
 "                                PADDING-byte boundary.  Default: DUSIZE\n"
+"  --use-inlinecrypt-key       In combination with --enable-hw-kdf, this causes\n"
+"                                the en/decryption to be done with the \"inline\n"
+"                                encryption key\" rather than with a key derived\n"
+"                                from the \"software secret\".\n"
 	, fp);
 }
 
 /*----------------------------------------------------------------------------*
  *                                 Utilities                                  *
@@ -347,10 +355,15 @@ static inline u32 gf2_8_mul_x_4way(u32 w)
 typedef struct {
 	__le64 lo;
 	__le64 hi;
 } ble128;
 
+typedef struct {
+	__be64 hi;
+	__be64 lo;
+} bbe128;
+
 /* Multiply a GF(2^128) element by the polynomial 'x' */
 static inline void gf2_128_mul_x_xts(ble128 *t)
 {
 	u64 lo = le64_to_cpu(t->lo);
 	u64 hi = le64_to_cpu(t->hi);
@@ -368,10 +381,19 @@ static inline void gf2_128_mul_x_polyval(ble128 *t)
 
 	t->hi = cpu_to_le64(((hi << 1) | (lo >> 63)) ^ hi_reducer);
 	t->lo = cpu_to_le64((lo << 1) ^ lo_reducer);
 }
 
+static inline void gf2_128_mul_x_cmac(bbe128 *t)
+{
+	u64 lo = be64_to_cpu(t->lo);
+	u64 hi = be64_to_cpu(t->hi);
+
+	t->hi = cpu_to_be64((hi << 1) | (lo >> 63));
+	t->lo = cpu_to_be64((lo << 1) ^ ((hi & (1ULL << 63)) ? 0x87 : 0));
+}
+
 static void gf2_128_mul_polyval(ble128 *r, const ble128 *b)
 {
 	int i;
 	ble128 p;
 	u64 lo = le64_to_cpu(b->lo);
@@ -1494,10 +1516,71 @@ static void test_aes_256_hctr2(void)
 	}
 	close(algfd);
 }
 #endif /* ENABLE_ALG_TESTS */
 
+static void aes_256_cmac(const u8 key[AES_256_KEY_SIZE],
+			 const u8 *msg, size_t msglen, u8 mac[AES_BLOCK_SIZE])
+{
+	const size_t partial = msglen % AES_BLOCK_SIZE;
+	const size_t full_blocks = msglen ? (msglen - 1) / AES_BLOCK_SIZE : 0;
+	struct aes_key k;
+	bbe128 subkey;
+	size_t i;
+
+	aes_setkey(&k, key, AES_256_KEY_SIZE);
+	memset(&subkey, 0, sizeof(subkey));
+	aes_encrypt(&k, (u8 *)&subkey, (u8 *)&subkey);
+	gf2_128_mul_x_cmac(&subkey);
+
+	memset(mac, 0, AES_BLOCK_SIZE);
+	for (i = 0; i < full_blocks * AES_BLOCK_SIZE; i += AES_BLOCK_SIZE) {
+		xor(mac, mac, &msg[i], AES_BLOCK_SIZE);
+		aes_encrypt(&k, mac, mac);
+	}
+	xor(mac, mac, &msg[i], msglen - i);
+	if (partial != 0 || msglen == 0) {
+		mac[msglen - i] ^= 0x80;
+		gf2_128_mul_x_cmac(&subkey);
+	}
+	xor(mac, mac, (u8 *)&subkey, AES_BLOCK_SIZE);
+	aes_encrypt(&k, mac, mac);
+}
+
+#ifdef ENABLE_ALG_TESTS
+#include <openssl/cmac.h>
+static void test_aes_256_cmac(void)
+{
+	unsigned long num_tests = NUM_ALG_TEST_ITERATIONS;
+	CMAC_CTX *ctx = CMAC_CTX_new();
+
+	ASSERT(ctx != NULL);
+	while (num_tests--) {
+		u8 key[AES_256_KEY_SIZE];
+		u8 msg[128];
+		u8 mac[AES_BLOCK_SIZE];
+		u8 ref_mac[sizeof(mac)];
+		const size_t msglen = 1 + (rand() % sizeof(msg));
+		size_t out_len = 0;
+
+		rand_bytes(key, sizeof(key));
+		rand_bytes(msg, msglen);
+
+		aes_256_cmac(key, msg, msglen, mac);
+
+		ASSERT(ctx != NULL);
+		ASSERT(CMAC_Init(ctx, key, sizeof(key), EVP_aes_256_cbc(),
+				 NULL) == 1);
+		ASSERT(CMAC_Update(ctx, msg, msglen) == 1);
+		ASSERT(CMAC_Final(ctx, ref_mac, &out_len));
+		ASSERT(out_len == sizeof(mac));
+		ASSERT(memcmp(mac, ref_mac, sizeof(mac)) == 0);
+	}
+	CMAC_CTX_free(ctx);
+}
+#endif /* ENABLE_ALG_TESTS */
+
 /*----------------------------------------------------------------------------*
  *                           XChaCha12 stream cipher                          *
  *----------------------------------------------------------------------------*/
 
 /*
@@ -2060,13 +2143,21 @@ static u8 parse_mode_number(const char *arg)
 		die("Invalid mode number: %s", arg);
 	return num;
 }
 
 struct key_and_iv_params {
+	/*
+	 * If enable_hw_kdf=true, then master_key and sw_secret will differ.
+	 * Otherwise they will be the same.
+	 */
 	u8 master_key[MAX_KEY_SIZE];
 	int master_key_size;
+	u8 sw_secret[MAX_KEY_SIZE];
+	int sw_secret_size;
 	enum kdf_algorithm kdf;
+	bool enable_hw_kdf;
+	bool use_inlinecrypt_key;
 	u8 mode_num;
 	u8 file_nonce[FILE_NONCE_SIZE];
 	bool file_nonce_specified;
 	bool direct_key;
 	bool iv_ino_lblk_64;
@@ -2075,17 +2166,18 @@ struct key_and_iv_params {
 	u64 inode_number;
 	u8 fs_uuid[UUID_SIZE];
 	bool fs_uuid_specified;
 };
 
-#define HKDF_CONTEXT_KEY_IDENTIFIER	1
+#define HKDF_CONTEXT_KEY_IDENTIFIER_FOR_RAW_KEY 1
 #define HKDF_CONTEXT_PER_FILE_ENC_KEY	2
 #define HKDF_CONTEXT_DIRECT_KEY		3
 #define HKDF_CONTEXT_IV_INO_LBLK_64_KEY	4
 #define HKDF_CONTEXT_DIRHASH_KEY	5
 #define HKDF_CONTEXT_IV_INO_LBLK_32_KEY	6
 #define HKDF_CONTEXT_INODE_HASH_KEY	7
+#define HKDF_CONTEXT_KEY_IDENTIFIER_FOR_HW_WRAPPED_KEY 8
 
 /* Hash the file's inode number using SipHash keyed by a derived key */
 static u32 hash_inode_number(const struct key_and_iv_params *params)
 {
 	u8 info[9] = "fscrypt";
@@ -2096,42 +2188,157 @@ static u32 hash_inode_number(const struct key_and_iv_params *params)
 
 	info[8] = HKDF_CONTEXT_INODE_HASH_KEY;
 
 	if (params->kdf != KDF_HKDF_SHA512)
 		die("--iv-ino-lblk-32 requires --kdf=HKDF-SHA512");
-	hkdf_sha512(params->master_key, params->master_key_size,
+	hkdf_sha512(params->sw_secret, params->sw_secret_size,
 		    NULL, 0, info, sizeof(info),
 		    hash_key.bytes, sizeof(hash_key));
 
 	hash_key.words[0] = get_unaligned_le64(&hash_key.bytes[0]);
 	hash_key.words[1] = get_unaligned_le64(&hash_key.bytes[8]);
 
 	return (u32)siphash_1u64(hash_key.words, params->inode_number);
 }
 
+/*
+ * Replicate the hardware KDF, given the raw master key and the context
+ * indicating which type of key to derive.
+ *
+ * Detailed explanation:
+ *
+ * With hardware-wrapped keys, an extra level is inserted into fscrypt's key
+ * hierarchy, above what was previously the root:
+ *
+ *                           master_key
+ *                               |
+ *                         -------------
+ *                         |            |
+ *                         |            |
+ *                inlinecrypt_key    sw_secret
+ *                                      |
+ *                                      |
+ *                                (everything else)
+ *
+ * From the master key, the "inline encryption key" (inlinecrypt_key) and
+ * "software secret" (sw_secret) are derived.  The inlinecrypt_key is used to
+ * encrypt file contents.  The sw_secret is used just like the old master key,
+ * except that it isn't used to derive the file contents key.  (I.e., it's used
+ * to derive filenames encryption keys, key identifiers, inode hash keys, etc.)
+ *
+ * Normally, software only sees master_key in "wrapped" form, and can never see
+ * inlinecrypt_key at all.  Only specialized hardware can access the raw
+ * master_key to derive the subkeys, in a step we call the "HW KDF".
+ *
+ * However, the HW KDF is a well-specified algorithm, and when a
+ * hardware-wrapped key is initially created, software can choose to import a
+ * raw key.  This allows software to test the feature by replicating the HW KDF.
+ *
+ * This is what this function does; it will derive either the inlinecrypt_key
+ * key or the sw_secret, depending on the KDF context passed.
+ */
+static void hw_kdf(const u8 *master_key, size_t master_key_size,
+		   const u8 *ctx, size_t ctx_size,
+		   u8 *derived_key, size_t derived_key_size)
+{
+	static const u8 label[11] = "\0\0\x40\0\0\0\0\0\0\0\x20";
+	u8 info[128];
+	size_t i;
+
+	if (master_key_size != AES_256_KEY_SIZE)
+		die("--hw-kdf requires a 32-byte master key");
+	ASSERT(derived_key_size % AES_BLOCK_SIZE == 0);
+
+	/*
+	 * This is NIST SP 800-108 "KDF in Counter Mode" with AES-256-CMAC as
+	 * the PRF and a particular choice of labels and contexts.
+	 */
+	for (i = 0; i < derived_key_size; i += AES_BLOCK_SIZE) {
+		u8 *p = info;
+
+		ASSERT(sizeof(__be32) + sizeof(label) + 1 + ctx_size +
+		       sizeof(__be32) <= sizeof(info));
+
+		put_unaligned_be32(1 + (i / AES_BLOCK_SIZE), p);
+		p += sizeof(__be32);
+		memcpy(p, label, sizeof(label));
+		p += sizeof(label);
+		*p++ = 0;
+		memcpy(p, ctx, ctx_size);
+		p += ctx_size;
+		put_unaligned_be32(derived_key_size * 8, p);
+		p += sizeof(__be32);
+
+		aes_256_cmac(master_key, info, p - info, &derived_key[i]);
+	}
+}
+
+#define INLINECRYPT_KEY_SIZE 64
+#define SW_SECRET_SIZE 32
+
+static void derive_inline_encryption_key(const u8 *master_key,
+					 size_t master_key_size,
+					 u8 inlinecrypt_key[INLINECRYPT_KEY_SIZE])
+{
+	static const u8 ctx[36] =
+		"inline encryption key\0\0\0\0\0\0\x03\x43\0\x82\x50\0\0\0\0";
+
+	hw_kdf(master_key, master_key_size, ctx, sizeof(ctx),
+	       inlinecrypt_key, INLINECRYPT_KEY_SIZE);
+}
+
+static void derive_sw_secret(const u8 *master_key, size_t master_key_size,
+			     u8 sw_secret[SW_SECRET_SIZE])
+{
+	static const u8 ctx[28] =
+		"raw secret\0\0\0\0\0\0\0\0\0\x03\x17\0\x80\x50\0\0\0\0";
+
+	hw_kdf(master_key, master_key_size, ctx, sizeof(ctx),
+	       sw_secret, SW_SECRET_SIZE);
+}
+
 static void derive_real_key(const struct key_and_iv_params *params,
 			    u8 *real_key, size_t real_key_size)
 {
 	struct aes_key aes_key;
 	u8 info[8 + 1 + 1 + UUID_SIZE] = "fscrypt";
 	size_t infolen = 8;
 	size_t i;
 
-	ASSERT(real_key_size <= params->master_key_size);
+	if (params->use_inlinecrypt_key) {
+		/*
+		 * With --use-inlinecrypt-key, we need to use the "hardware KDF"
+		 * rather than the normal fscrypt KDF.  Note that the fscrypt
+		 * KDF might still be used elsewhere, e.g. hash_inode_number()
+		 * -- it just won't be used for the actual encryption key.
+		 */
+		if (!params->enable_hw_kdf)
+			die("--use-inlinecrypt-key requires --enable-hw-kdf");
+		if (!params->iv_ino_lblk_64 && !params->iv_ino_lblk_32)
+			die("--use-inlinecrypt-key requires one of --iv-ino-lblk-{64,32}");
+		if (real_key_size != INLINECRYPT_KEY_SIZE)
+			die("cipher not compatible with --use-inlinecrypt-key");
+		derive_inline_encryption_key(params->master_key,
+					     params->master_key_size, real_key);
+		return;
+	}
+
+	if (params->sw_secret_size < real_key_size)
+		die("Master key is too short for cipher");
 
 	switch (params->kdf) {
 	case KDF_NONE:
-		memcpy(real_key, params->master_key, real_key_size);
+		memcpy(real_key, params->sw_secret, real_key_size);
 		break;
 	case KDF_AES_128_ECB:
 		if (!params->file_nonce_specified)
 			die("--kdf=AES-128-ECB requires --file-nonce");
 		STATIC_ASSERT(FILE_NONCE_SIZE == AES_128_KEY_SIZE);
 		ASSERT(real_key_size % AES_BLOCK_SIZE == 0);
 		aes_setkey(&aes_key, params->file_nonce, AES_128_KEY_SIZE);
 		for (i = 0; i < real_key_size; i += AES_BLOCK_SIZE)
-			aes_encrypt(&aes_key, &params->master_key[i],
+			aes_encrypt(&aes_key, &params->sw_secret[i],
 				    &real_key[i]);
 		break;
 	case KDF_HKDF_SHA512:
 		if (params->direct_key) {
 			if (params->mode_num == 0)
@@ -2162,11 +2369,11 @@ static void derive_real_key(const struct key_and_iv_params *params,
 			info[infolen++] = HKDF_CONTEXT_PER_FILE_ENC_KEY;
 			memcpy(&info[infolen], params->file_nonce,
 			       FILE_NONCE_SIZE);
 			infolen += FILE_NONCE_SIZE;
 		}
-		hkdf_sha512(params->master_key, params->master_key_size,
+		hkdf_sha512(params->sw_secret, params->sw_secret_size,
 			    NULL, 0, info, infolen, real_key, real_key_size);
 		break;
 	default:
 		ASSERT(0);
 	}
@@ -2230,15 +2437,18 @@ static void do_dump_key_identifier(const struct key_and_iv_params *params)
 {
 	u8 info[9] = "fscrypt";
 	u8 key_identifier[16];
 	int i;
 
-	info[8] = HKDF_CONTEXT_KEY_IDENTIFIER;
+	if (params->enable_hw_kdf)
+		info[8] = HKDF_CONTEXT_KEY_IDENTIFIER_FOR_HW_WRAPPED_KEY;
+	else
+		info[8] = HKDF_CONTEXT_KEY_IDENTIFIER_FOR_RAW_KEY;
 
 	if (params->kdf != KDF_HKDF_SHA512)
 		die("--dump-key-identifier requires --kdf=HKDF-SHA512");
-	hkdf_sha512(params->master_key, params->master_key_size,
+	hkdf_sha512(params->sw_secret, params->sw_secret_size,
 		    NULL, 0, info, sizeof(info),
 		    key_identifier, sizeof(key_identifier));
 
 	for (i = 0; i < sizeof(key_identifier); i++)
 		printf("%02x", key_identifier[i]);
@@ -2248,44 +2458,59 @@ static void parse_master_key(const char *arg, struct key_and_iv_params *params)
 {
 	params->master_key_size = hex2bin(arg, params->master_key,
 					  MAX_KEY_SIZE);
 	if (params->master_key_size < 0)
 		die("Invalid master_key: %s", arg);
+
+	/* Derive sw_secret from master_key, if needed. */
+	if (params->enable_hw_kdf) {
+		derive_sw_secret(params->master_key, params->master_key_size,
+				 params->sw_secret);
+		params->sw_secret_size = SW_SECRET_SIZE;
+	} else {
+		memcpy(params->sw_secret, params->master_key,
+		       params->master_key_size);
+		params->sw_secret_size = params->master_key_size;
+	}
 }
 
 enum {
 	OPT_DATA_UNIT_INDEX,
 	OPT_DATA_UNIT_SIZE,
 	OPT_DECRYPT,
 	OPT_DIRECT_KEY,
 	OPT_DUMP_KEY_IDENTIFIER,
+	OPT_ENABLE_HW_KDF,
 	OPT_FILE_NONCE,
 	OPT_FS_UUID,
 	OPT_HELP,
 	OPT_INODE_NUMBER,
 	OPT_IV_INO_LBLK_32,
 	OPT_IV_INO_LBLK_64,
 	OPT_KDF,
 	OPT_MODE_NUM,
 	OPT_PADDING,
+	OPT_USE_INLINECRYPT_KEY,
 };
 
 static const struct option longopts[] = {
 	{ "data-unit-index", required_argument, NULL, OPT_DATA_UNIT_INDEX },
 	{ "data-unit-size",  required_argument, NULL, OPT_DATA_UNIT_SIZE },
 	{ "decrypt",         no_argument,       NULL, OPT_DECRYPT },
 	{ "direct-key",      no_argument,       NULL, OPT_DIRECT_KEY },
 	{ "dump-key-identifier", no_argument,   NULL, OPT_DUMP_KEY_IDENTIFIER },
+	{ "enable-hw-kdf",   no_argument,       NULL, OPT_ENABLE_HW_KDF },
 	{ "file-nonce",      required_argument, NULL, OPT_FILE_NONCE },
 	{ "fs-uuid",         required_argument, NULL, OPT_FS_UUID },
 	{ "help",            no_argument,       NULL, OPT_HELP },
 	{ "inode-number",    required_argument, NULL, OPT_INODE_NUMBER },
 	{ "iv-ino-lblk-32",  no_argument,       NULL, OPT_IV_INO_LBLK_32 },
 	{ "iv-ino-lblk-64",  no_argument,       NULL, OPT_IV_INO_LBLK_64 },
 	{ "kdf",             required_argument, NULL, OPT_KDF },
 	{ "mode-num",        required_argument, NULL, OPT_MODE_NUM },
 	{ "padding",         required_argument, NULL, OPT_PADDING },
+	{ "use-inlinecrypt-key", no_argument,   NULL, OPT_USE_INLINECRYPT_KEY },
 	{ NULL, 0, NULL, 0 },
 };
 
 int main(int argc, char *argv[])
 {
@@ -2308,10 +2533,11 @@ int main(int argc, char *argv[])
 	test_aes();
 	test_sha2();
 	test_hkdf_sha512();
 	test_aes_256_xts();
 	test_aes_256_cts_cbc();
+	test_aes_256_cmac();
 	test_adiantum();
 	test_aes_256_hctr2();
 #endif
 
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
@@ -2335,10 +2561,13 @@ int main(int argc, char *argv[])
 			params.direct_key = true;
 			break;
 		case OPT_DUMP_KEY_IDENTIFIER:
 			dump_key_identifier = true;
 			break;
+		case OPT_ENABLE_HW_KDF:
+			params.enable_hw_kdf = true;
+			break;
 		case OPT_FILE_NONCE:
 			if (hex2bin(optarg, params.file_nonce, FILE_NONCE_SIZE)
 			    != FILE_NONCE_SIZE)
 				die("Invalid file nonce: %s", optarg);
 			params.file_nonce_specified = true;
@@ -2374,10 +2603,13 @@ int main(int argc, char *argv[])
 			padding = strtoul(optarg, &tmp, 10);
 			if (padding <= 0 || *tmp || !is_power_of_2(padding) ||
 			    padding > INT_MAX)
 				die("Invalid padding amount: %s", optarg);
 			break;
+		case OPT_USE_INLINECRYPT_KEY:
+			params.use_inlinecrypt_key = true;
+			break;
 		default:
 			usage(stderr);
 			return 2;
 		}
 	}
@@ -2406,13 +2638,10 @@ int main(int argc, char *argv[])
 		die("Data unit size of %zu bytes is too small for cipher %s",
 		    data_unit_size, cipher->name);
 
 	parse_master_key(argv[1], &params);
 
-	if (params.master_key_size < cipher->keysize)
-		die("Master key is too short for cipher %s", cipher->name);
-
 	get_key_and_iv(&params, real_key, cipher->keysize, &iv);
 
 	crypt_loop(cipher, real_key, &iv, decrypting, data_unit_size, padding,
 		   params.iv_ino_lblk_64 || params.iv_ino_lblk_32);
 	return 0;
-- 
2.47.1


