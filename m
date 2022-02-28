Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4654C640C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Feb 2022 08:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbiB1Hti (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Feb 2022 02:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbiB1Htg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Feb 2022 02:49:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997053D1D2;
        Sun, 27 Feb 2022 23:48:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 132BFB80E5C;
        Mon, 28 Feb 2022 07:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9604FC340F4;
        Mon, 28 Feb 2022 07:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646034534;
        bh=MsaVrw266YzU16CjaXzIUoUY0yLlOc2autQhKBnUZPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MerbDE00Ntfj86QYmgD3T4DRWAJWGeFWSK7YKVp7h2omJChYuNyu7oXY5QX2bGc5K
         fTFWtI0Bjj8RPJfN7pjp36t9cUQBXir8NG3qHS3Zs06tXnPi1NZtj4fjzpa0lFp4W1
         fcEtwQIyTek+FefTWh2gWuDYffwGFNNGfwpiRfYaRDCOMC5DIoNXQ4zuqOvD7Ez+ZD
         I/lIOfIJ0vS983oc9ugU7TYBZyFkYBSasvwm6WrJ12NN2osRCAgTcyBSqbyvaWgwuI
         8FXm/Li8Zxbx0ya5oiwoz/VzqtfdRh8r1hHrr9dHtx7uicGffD/W4SilHIaE63XnwT
         F7INLtZ1rbRHg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [RFC PATCH 6/8] fscrypt-crypt-util: add hardware KDF support
Date:   Sun, 27 Feb 2022 23:47:20 -0800
Message-Id: <20220228074722.77008-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228074722.77008-1-ebiggers@kernel.org>
References: <20220228074722.77008-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add support to fscrypt-crypt-util for replicating the extra KDF (Key
Derivation Function) step that is required when a hardware-wrapped key
is used.  This step normally occurs in hardware, but we need to
replicate it for testing purposes.

Note, some care was needed to handle the fact that both inlinecrypt_key
and sw_secret can be needed in a single run of fscrypt-crypt-util.
Namely, with --iv-ino-lblk-32, inlinecrypt_key is needed for the
en/decryption while sw_secret is needed for hash_inode_number().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 253 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 242 insertions(+), 11 deletions(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 876d9f5c..7c19bb90 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -68,6 +68,10 @@ static void usage(FILE *fp)
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
@@ -86,6 +90,10 @@ static void usage(FILE *fp)
 "                                for key derivation, depending on other options.\n"
 "  --padding=PADDING           If last block is partial, zero-pad it to next\n"
 "                                PADDING-byte boundary.  Default: BLOCK_SIZE\n"
+"  --use-inlinecrypt-key       In combination with --enable-hw-kdf, this causes\n"
+"                                the en/decryption to be done with the \"inline\n"
+"                                encryption key\" rather than with a key derived\n"
+"                                from the \"software secret\".\n"
 	, fp);
 }
 
@@ -295,6 +303,12 @@ typedef struct {
 	__le64 hi;
 } ble128;
 
+/* Same as ble128 but with big-endian byte order */
+typedef struct {
+	__be64 hi;
+	__be64 lo;
+} bbe128;
+
 /* Multiply a GF(2^128) element by the polynomial 'x' */
 static inline void gf2_128_mul_x(ble128 *t)
 {
@@ -305,6 +319,16 @@ static inline void gf2_128_mul_x(ble128 *t)
 	t->lo = cpu_to_le64((lo << 1) ^ ((hi & (1ULL << 63)) ? 0x87 : 0));
 }
 
+/* Same as gf2_128_mul_x() but with big-endian byte order */
+static inline void gf2_128_mul_x_be(bbe128 *t)
+{
+	u64 lo = be64_to_cpu(t->lo);
+	u64 hi = be64_to_cpu(t->hi);
+
+	t->hi = cpu_to_be64((hi << 1) | (lo >> 63));
+	t->lo = cpu_to_be64((lo << 1) ^ ((hi & (1ULL << 63)) ? 0x87 : 0));
+}
+
 /*----------------------------------------------------------------------------*
  *                             Group arithmetic                               *
  *----------------------------------------------------------------------------*/
@@ -1176,6 +1200,67 @@ static void aes_128_cts_cbc_decrypt(const u8 key[AES_128_KEY_SIZE],
 	aes_cts_cbc_decrypt(key, AES_128_KEY_SIZE, iv, src, dst, nbytes);
 }
 
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
+	gf2_128_mul_x_be(&subkey);
+
+	memset(mac, 0, AES_BLOCK_SIZE);
+	for (i = 0; i < full_blocks * AES_BLOCK_SIZE; i += AES_BLOCK_SIZE) {
+		xor(mac, mac, &msg[i], AES_BLOCK_SIZE);
+		aes_encrypt(&k, mac, mac);
+	}
+	xor(mac, mac, &msg[i], msglen - i);
+	if (partial != 0 || msglen == 0) {
+		mac[msglen - i] ^= 0x80;
+		gf2_128_mul_x_be(&subkey);
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
@@ -1787,9 +1872,17 @@ static u8 parse_mode_number(const char *arg)
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
@@ -1802,13 +1895,14 @@ struct key_and_iv_params {
 	bool fs_uuid_specified;
 };
 
-#define HKDF_CONTEXT_KEY_IDENTIFIER	1
+#define HKDF_CONTEXT_KEY_IDENTIFIER_FOR_STANDARD_KEY 1
 #define HKDF_CONTEXT_PER_FILE_ENC_KEY	2
 #define HKDF_CONTEXT_DIRECT_KEY		3
 #define HKDF_CONTEXT_IV_INO_LBLK_64_KEY	4
 #define HKDF_CONTEXT_DIRHASH_KEY	5
 #define HKDF_CONTEXT_IV_INO_LBLK_32_KEY	6
 #define HKDF_CONTEXT_INODE_HASH_KEY	7
+#define HKDF_CONTEXT_KEY_IDENTIFIER_FOR_HW_WRAPPED_KEY 8
 
 /* Hash the file's inode number using SipHash keyed by a derived key */
 static u32 hash_inode_number(const struct key_and_iv_params *params)
@@ -1820,7 +1914,7 @@ static u32 hash_inode_number(const struct key_and_iv_params *params)
 	} hash_key;
 
 	info[8] = HKDF_CONTEXT_INODE_HASH_KEY;
-	hkdf_sha512(params->master_key, params->master_key_size,
+	hkdf_sha512(params->sw_secret, params->sw_secret_size,
 		    NULL, 0, info, sizeof(info),
 		    hash_key.bytes, sizeof(hash_key));
 
@@ -1830,6 +1924,102 @@ static u32 hash_inode_number(const struct key_and_iv_params *params)
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
@@ -1838,11 +2028,30 @@ static void derive_real_key(const struct key_and_iv_params *params,
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
+			die("--use-inlinecrypt-key requires one of --iv-ino-lblk-*");
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
@@ -1851,7 +2060,7 @@ static void derive_real_key(const struct key_and_iv_params *params,
 		ASSERT(real_key_size % AES_BLOCK_SIZE == 0);
 		aes_setkey(&aes_key, params->file_nonce, AES_128_KEY_SIZE);
 		for (i = 0; i < real_key_size; i += AES_BLOCK_SIZE)
-			aes_encrypt(&aes_key, &params->master_key[i],
+			aes_encrypt(&aes_key, &params->sw_secret[i],
 				    &real_key[i]);
 		break;
 	case KDF_HKDF_SHA512:
@@ -1886,7 +2095,7 @@ static void derive_real_key(const struct key_and_iv_params *params,
 		} else {
 			die("--kdf=HKDF-SHA512 requires --file-nonce or --iv-ino-lblk-*");
 		}
-		hkdf_sha512(params->master_key, params->master_key_size,
+		hkdf_sha512(params->sw_secret, params->sw_secret_size,
 			    NULL, 0, info, infolen, real_key, real_key_size);
 		break;
 	default:
@@ -1957,9 +2166,12 @@ static void do_dump_key_identifier(const struct key_and_iv_params *params)
 	if (params->kdf != KDF_HKDF_SHA512)
 		die("--dump-key-identifier requires --kdf=HKDF-SHA512");
 
-	info[8] = HKDF_CONTEXT_KEY_IDENTIFIER;
+	if (params->enable_hw_kdf)
+		info[8] = HKDF_CONTEXT_KEY_IDENTIFIER_FOR_HW_WRAPPED_KEY;
+	else
+		info[8] = HKDF_CONTEXT_KEY_IDENTIFIER_FOR_STANDARD_KEY;
 
-	hkdf_sha512(params->master_key, params->master_key_size,
+	hkdf_sha512(params->sw_secret, params->sw_secret_size,
 		    NULL, 0, info, sizeof(info), key_identifier,
 		    sizeof(key_identifier));
 
@@ -1973,6 +2185,7 @@ enum {
 	OPT_DECRYPT,
 	OPT_DIRECT_KEY,
 	OPT_DUMP_KEY_IDENTIFIER,
+	OPT_ENABLE_HW_KDF,
 	OPT_FILE_NONCE,
 	OPT_FS_UUID,
 	OPT_HELP,
@@ -1982,6 +2195,7 @@ enum {
 	OPT_KDF,
 	OPT_MODE_NUM,
 	OPT_PADDING,
+	OPT_USE_INLINECRYPT_KEY,
 };
 
 static const struct option longopts[] = {
@@ -1990,6 +2204,7 @@ static const struct option longopts[] = {
 	{ "decrypt",         no_argument,       NULL, OPT_DECRYPT },
 	{ "direct-key",      no_argument,       NULL, OPT_DIRECT_KEY },
 	{ "dump-key-identifier", no_argument,   NULL, OPT_DUMP_KEY_IDENTIFIER },
+	{ "enable-hw-kdf",   no_argument,       NULL, OPT_ENABLE_HW_KDF },
 	{ "file-nonce",      required_argument, NULL, OPT_FILE_NONCE },
 	{ "fs-uuid",         required_argument, NULL, OPT_FS_UUID },
 	{ "help",            no_argument,       NULL, OPT_HELP },
@@ -1999,6 +2214,7 @@ static const struct option longopts[] = {
 	{ "kdf",             required_argument, NULL, OPT_KDF },
 	{ "mode-num",        required_argument, NULL, OPT_MODE_NUM },
 	{ "padding",         required_argument, NULL, OPT_PADDING },
+	{ "use-inlinecrypt-key", no_argument,   NULL, OPT_USE_INLINECRYPT_KEY },
 	{ NULL, 0, NULL, 0 },
 };
 
@@ -2025,6 +2241,7 @@ int main(int argc, char *argv[])
 	test_hkdf_sha512();
 	test_aes_256_xts();
 	test_aes_256_cts_cbc();
+	test_aes_256_cmac();
 	test_adiantum();
 #endif
 
@@ -2051,6 +2268,9 @@ int main(int argc, char *argv[])
 		case OPT_DUMP_KEY_IDENTIFIER:
 			dump_key_identifier = true;
 			break;
+		case OPT_ENABLE_HW_KDF:
+			params.enable_hw_kdf = true;
+			break;
 		case OPT_FILE_NONCE:
 			if (hex2bin(optarg, params.file_nonce, FILE_NONCE_SIZE)
 			    != FILE_NONCE_SIZE)
@@ -2090,6 +2310,9 @@ int main(int argc, char *argv[])
 			    padding > INT_MAX)
 				die("Invalid padding amount: %s", optarg);
 			break;
+		case OPT_USE_INLINECRYPT_KEY:
+			params.use_inlinecrypt_key = true;
+			break;
 		default:
 			usage(stderr);
 			return 2;
@@ -2122,12 +2345,20 @@ int main(int argc, char *argv[])
 	if (params.master_key_size < 0)
 		die("Invalid master_key: %s", *argv);
 
+	/* Derive sw_secret from master_key, if needed. */
+	if (params.enable_hw_kdf) {
+		derive_sw_secret(params.master_key, params.master_key_size,
+				 params.sw_secret);
+		params.sw_secret_size = SW_SECRET_SIZE;
+	} else {
+		memcpy(params.sw_secret, params.master_key,
+		       params.master_key_size);
+		params.sw_secret_size = params.master_key_size;
+	}
+
 	if (dump_key_identifier) {
 		do_dump_key_identifier(&params);
 	} else {
-		if (params.master_key_size < cipher->keysize)
-			die("Master key is too short for cipher %s",
-			    cipher->name);
 		get_key_and_iv(&params, real_key, cipher->keysize, &iv);
 		crypt_loop(cipher, real_key, &iv, decrypting, block_size,
 			   padding,
-- 
2.35.1

