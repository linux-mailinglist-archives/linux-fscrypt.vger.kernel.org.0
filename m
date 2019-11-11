Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F94F81DC
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Nov 2019 22:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKKVFn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 11 Nov 2019 16:05:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726927AbfKKVFn (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 11 Nov 2019 16:05:43 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EA252084F;
        Mon, 11 Nov 2019 21:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573506341;
        bh=mQ23u/zdJd3leI9q2lQdwIUg1EDV0QRUTyeImF/Bo1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNYxR9QFXOIZzu7Ki88n6kL57x2hb+s4YuVDLAscGljkOKpC8ZvnbJ/cXfYI2AD/y
         D7YwRRlxVxxDiJDpEO5FIquNquMxRSgtp8EJj9VAapAH17L873/Yn9vUCeIUCIVM2K
         PSAUB7KkFEsBVSevszMkmKJpEJDpQ328TmW94edw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: [RFC PATCH 1/5] fscrypt-crypt-util: create key_and_iv_params structure
Date:   Mon, 11 Nov 2019 13:04:23 -0800
Message-Id: <20191111210427.137256-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
In-Reply-To: <20191111210427.137256-1-ebiggers@kernel.org>
References: <20191111210427.137256-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In preparation for adding 3 more input parameters to get_key_and_iv(),
create a structure to hold the input parameters so that the code doesn't
get too unwieldy.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 82 +++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 38 deletions(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index f5fd8386..bafc15e0 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -1694,66 +1694,75 @@ static u8 parse_mode_number(const char *arg)
 	return num;
 }
 
+struct key_and_iv_params {
+	u8 master_key[MAX_KEY_SIZE];
+	int master_key_size;
+	enum kdf_algorithm kdf;
+	u8 mode_num;
+	u8 file_nonce[FILE_NONCE_SIZE];
+	bool file_nonce_specified;
+};
+
 /*
  * Get the key and starting IV with which the encryption will actually be done.
  * If a KDF was specified, a subkey is derived from the master key and the mode
  * number or file nonce.  Otherwise, the master key is used directly.
  */
-static void get_key_and_iv(const u8 *master_key, size_t master_key_size,
-			   enum kdf_algorithm kdf,
-			   u8 mode_num, const u8 nonce[FILE_NONCE_SIZE],
+static void get_key_and_iv(const struct key_and_iv_params *params,
 			   u8 *real_key, size_t real_key_size,
 			   struct fscrypt_iv *iv)
 {
-	bool nonce_in_iv = false;
+	bool file_nonce_in_iv = false;
 	struct aes_key aes_key;
 	u8 info[8 + 1 + FILE_NONCE_SIZE] = "fscrypt";
 	size_t infolen = 8;
 	size_t i;
 
-	ASSERT(real_key_size <= master_key_size);
+	ASSERT(real_key_size <= params->master_key_size);
 
 	memset(iv, 0, sizeof(*iv));
 
-	switch (kdf) {
+	switch (params->kdf) {
 	case KDF_NONE:
-		if (mode_num != 0)
+		if (params->mode_num != 0)
 			die("--mode-num isn't supported with --kdf=none");
-		memcpy(real_key, master_key, real_key_size);
-		nonce_in_iv = true;
+		memcpy(real_key, params->master_key, real_key_size);
+		file_nonce_in_iv = true;
 		break;
 	case KDF_AES_128_ECB:
-		if (nonce == NULL)
+		if (!params->file_nonce_specified)
 			die("--file-nonce is required with --kdf=AES-128-ECB");
-		if (mode_num != 0)
+		if (params->mode_num != 0)
 			die("--mode-num isn't supported with --kdf=AES-128-ECB");
 		STATIC_ASSERT(FILE_NONCE_SIZE == AES_128_KEY_SIZE);
 		ASSERT(real_key_size % AES_BLOCK_SIZE == 0);
-		aes_setkey(&aes_key, nonce, AES_128_KEY_SIZE);
+		aes_setkey(&aes_key, params->file_nonce, AES_128_KEY_SIZE);
 		for (i = 0; i < real_key_size; i += AES_BLOCK_SIZE)
-			aes_encrypt(&aes_key, &master_key[i], &real_key[i]);
+			aes_encrypt(&aes_key, &params->master_key[i],
+				    &real_key[i]);
 		break;
 	case KDF_HKDF_SHA512:
-		if (mode_num != 0) {
+		if (params->mode_num != 0) {
 			info[infolen++] = 3; /* HKDF_CONTEXT_PER_MODE_KEY */
-			info[infolen++] = mode_num;
-			nonce_in_iv = true;
-		} else if (nonce != NULL) {
+			info[infolen++] = params->mode_num;
+			file_nonce_in_iv = true;
+		} else if (params->file_nonce_specified) {
 			info[infolen++] = 2; /* HKDF_CONTEXT_PER_FILE_KEY */
-			memcpy(&info[infolen], nonce, FILE_NONCE_SIZE);
+			memcpy(&info[infolen], params->file_nonce,
+			       FILE_NONCE_SIZE);
 			infolen += FILE_NONCE_SIZE;
 		} else {
 			die("With --kdf=HKDF-SHA512, at least one of --file-nonce and --mode-num must be specified");
 		}
-		hkdf_sha512(master_key, master_key_size, NULL, 0,
-			    info, infolen, real_key, real_key_size);
+		hkdf_sha512(params->master_key, params->master_key_size,
+			    NULL, 0, info, infolen, real_key, real_key_size);
 		break;
 	default:
 		ASSERT(0);
 	}
 
-	if (nonce_in_iv && nonce != NULL)
-		memcpy(&iv->bytes[8], nonce, FILE_NONCE_SIZE);
+	if (file_nonce_in_iv && params->file_nonce_specified)
+		memcpy(&iv->bytes[8], params->file_nonce, FILE_NONCE_SIZE);
 }
 
 enum {
@@ -1781,19 +1790,16 @@ int main(int argc, char *argv[])
 {
 	size_t block_size = 4096;
 	bool decrypting = false;
-	u8 _file_nonce[FILE_NONCE_SIZE];
-	u8 *file_nonce = NULL;
-	enum kdf_algorithm kdf = KDF_NONE;
-	u8 mode_num = 0;
+	struct key_and_iv_params params;
 	size_t padding = 0;
 	const struct fscrypt_cipher *cipher;
-	u8 master_key[MAX_KEY_SIZE];
-	int master_key_size;
 	u8 real_key[MAX_KEY_SIZE];
 	struct fscrypt_iv iv;
 	char *tmp;
 	int c;
 
+	memset(&params, 0, sizeof(params));
+
 	aes_init();
 
 #ifdef ENABLE_ALG_TESTS
@@ -1816,19 +1822,19 @@ int main(int argc, char *argv[])
 			decrypting = true;
 			break;
 		case OPT_FILE_NONCE:
-			if (hex2bin(optarg, _file_nonce, FILE_NONCE_SIZE) !=
-			    FILE_NONCE_SIZE)
+			if (hex2bin(optarg, params.file_nonce, FILE_NONCE_SIZE)
+			    != FILE_NONCE_SIZE)
 				die("Invalid file nonce: %s", optarg);
-			file_nonce = _file_nonce;
+			params.file_nonce_specified = true;
 			break;
 		case OPT_HELP:
 			usage(stdout);
 			return 0;
 		case OPT_KDF:
-			kdf = parse_kdf_algorithm(optarg);
+			params.kdf = parse_kdf_algorithm(optarg);
 			break;
 		case OPT_MODE_NUM:
-			mode_num = parse_mode_number(optarg);
+			params.mode_num = parse_mode_number(optarg);
 			break;
 		case OPT_PADDING:
 			padding = strtoul(optarg, &tmp, 10);
@@ -1857,14 +1863,14 @@ int main(int argc, char *argv[])
 		die("Block size of %zu bytes is too small for cipher %s",
 		    block_size, cipher->name);
 
-	master_key_size = hex2bin(argv[1], master_key, MAX_KEY_SIZE);
-	if (master_key_size < 0)
+	params.master_key_size = hex2bin(argv[1], params.master_key,
+					 MAX_KEY_SIZE);
+	if (params.master_key_size < 0)
 		die("Invalid master_key: %s", argv[1]);
-	if (master_key_size < cipher->keysize)
+	if (params.master_key_size < cipher->keysize)
 		die("Master key is too short for cipher %s", cipher->name);
 
-	get_key_and_iv(master_key, master_key_size, kdf, mode_num, file_nonce,
-		       real_key, cipher->keysize, &iv);
+	get_key_and_iv(&params, real_key, cipher->keysize, &iv);
 
 	crypt_loop(cipher, real_key, &iv, decrypting, block_size, padding);
 	return 0;
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

