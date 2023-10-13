Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A64B7C7D97
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Oct 2023 08:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjJMGRe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Oct 2023 02:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjJMGRe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Oct 2023 02:17:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8514B7;
        Thu, 12 Oct 2023 23:17:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6D2C433C7;
        Fri, 13 Oct 2023 06:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697177851;
        bh=5We58dLSi4jky+S5LpsGP6r7VcNWP/DskZt9/frlYys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKdQZILN9oTo+3GqQJUTlw+cvrNuK0VbvFoMpdXXh89B4jGxEfwyDBlLU0HZDQ6yV
         HumZP44KtmsVbNhAASe/rqZ+9l9wBa6ambN7jTTNq3oqxii95OTp+a/W95NT26RtzD
         hnI79YF6TUw0Tw1ffzdH27wFcXWzkv6s/2qPz38RtVlTyWHmECpROTobZJ7zQ1EBiA
         KSQR3VhCWwp44YKp7e+ecQLpWlcf3JAV2ooSl2hFuST2dMgdQocRs3xgYK9wsDJvdX
         MTQjMTXpEckjHM5b5tMhQwrr1cqk1tsGAwpzP0cTUmCuZ61DLmnW34ttDLC2uiqga6
         hQ9XIQEmCQtfA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 1/4] fscrypt-crypt-util: rename block to data unit
Date:   Thu, 12 Oct 2023 23:14:00 -0700
Message-ID: <20231013061403.138425-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231013061403.138425-1-ebiggers@kernel.org>
References: <20231013061403.138425-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Rename the --block-size option to --data-unit-size, and rename the
--block-number option to --data-unit-index.

This does not change any functionality, but this avoids confusion now
that the kernel supports the case where the crypto data unit size is not
the same as the filesystem block size.  fscrypt-crypt-util cares about
the crypto data unit size, not the filesystem block size.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt           | 10 ++---
 src/fscrypt-crypt-util.c | 93 ++++++++++++++++++++--------------------
 tests/f2fs/002           |  6 +--
 3 files changed, 55 insertions(+), 54 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index 1a77e23b..5688745c 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -756,51 +756,51 @@ _do_verify_ciphertext_for_encryption_policy()
 
 	# Now unmount the filesystem and verify the ciphertext we just wrote.
 	_scratch_unmount
 
 	echo "Verifying encrypted file contents" >> $seqres.full
 	for f in "${test_contents_files[@]}"; do
 		read -r src inode blocklist <<< "$f"
 		nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
 		_dump_ciphertext_blocks $SCRATCH_DEV $blocklist > $tmp.actual_contents
 		$crypt_contents_cmd $contents_encryption_mode $raw_key_hex \
-			--file-nonce=$nonce --block-size=$blocksize \
+			--file-nonce=$nonce --data-unit-size=$blocksize \
 			--inode-number=$inode < $src > $tmp.expected_contents
 		if ! cmp $tmp.expected_contents $tmp.actual_contents; then
 			_fail "Expected encrypted contents != actual encrypted contents.  File: $f"
 		fi
 		$crypt_contents_cmd $contents_encryption_mode $raw_key_hex \
-			--decrypt --file-nonce=$nonce --block-size=$blocksize \
-			--inode-number=$inode \
+			--decrypt --file-nonce=$nonce \
+                        --data-unit-size=$blocksize --inode-number=$inode \
 			< $tmp.actual_contents > $tmp.decrypted_contents
 		if ! cmp $src $tmp.decrypted_contents; then
 			_fail "Contents decryption sanity check failed.  File: $f"
 		fi
 	done
 
 	echo "Verifying encrypted file names" >> $seqres.full
 	for f in "${test_filenames_files[@]}"; do
 		read -r name inode dir_inode padding <<< "$f"
 		nonce=$(_get_encryption_nonce $SCRATCH_DEV $dir_inode)
 		_get_ciphertext_filename $SCRATCH_DEV $inode $dir_inode \
 			> $tmp.actual_name
 		echo -n "$name" | \
 			$crypt_filename_cmd $filenames_encryption_mode \
 			$raw_key_hex --file-nonce=$nonce --padding=$padding \
-			--block-size=255 --inode-number=$dir_inode \
+			--data-unit-size=255 --inode-number=$dir_inode \
 			> $tmp.expected_name
 		if ! cmp $tmp.expected_name $tmp.actual_name; then
 			_fail "Expected encrypted filename != actual encrypted filename.  File: $f"
 		fi
 		$crypt_filename_cmd $filenames_encryption_mode $raw_key_hex \
 			--decrypt --file-nonce=$nonce --padding=$padding \
-			--block-size=255 --inode-number=$dir_inode \
+			--data-unit-size=255 --inode-number=$dir_inode \
 			< $tmp.actual_name > $tmp.decrypted_name
 		decrypted_name=$(tr -d '\0' < $tmp.decrypted_name)
 		if [ "$name" != "$decrypted_name" ]; then
 			_fail "Filename decryption sanity check failed ($name != $decrypted_name).  File: $f"
 		fi
 	done
 }
 
 # fscrypt UAPI constants (see <linux/fscrypt.h>)
 
diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 96f04799..a1b5005d 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -54,23 +54,23 @@ static void usage(FILE *fp)
 "MASTER_KEY (or a key derived from it, if a KDF is specified), and writes the\n"
 "resulting ciphertext (or plaintext) to stdout.\n"
 "\n"
 "CIPHER can be AES-256-XTS, AES-256-CTS-CBC, AES-128-CBC-ESSIV, AES-128-CTS-CBC,\n"
 "Adiantum, or AES-256-HCTR2.  MASTER_KEY must be a hex string long enough for\n"
 "the cipher.\n"
 "\n"
 "WARNING: this program is only meant for testing, not for \"real\" use!\n"
 "\n"
 "Options:\n"
-"  --block-number=BNUM         Starting block number for IV generation.\n"
+"  --data-unit-index=DUIDX     Starting data unit index for IV generation.\n"
 "                                Default: 0\n"
-"  --block-size=BLOCK_SIZE     Encrypt each BLOCK_SIZE bytes independently.\n"
+"  --data-unit-size=DUSIZE     Encrypt each DUSIZE bytes independently.\n"
 "                                Default: 4096 bytes\n"
 "  --decrypt                   Decrypt instead of encrypt\n"
 "  --direct-key                Use the format where the IVs include the file\n"
 "                                nonce and the same key is shared across files.\n"
 "  --dump-key-identifier       Instead of encrypting/decrypting data, just\n"
 "                                compute and dump the key identifier.\n"
 "  --file-nonce=NONCE          File's nonce as a 32-character hex string\n"
 "  --fs-uuid=UUID              The filesystem UUID as a 32-character hex string.\n"
 "                                Required for --iv-ino-lblk-32 and\n"
 "                                --iv-ino-lblk-64; otherwise is unused.\n"
@@ -79,22 +79,22 @@ static void usage(FILE *fp)
 "                                --iv-ino-lblk-32 and --iv-ino-lblk-64;\n"
 "                                otherwise is unused.\n"
 "  --iv-ino-lblk-32            Similar to --iv-ino-lblk-64, but selects the\n"
 "                                32-bit variant.\n"
 "  --iv-ino-lblk-64            Use the format where the IVs include the inode\n"
 "                                number and the same key is shared across files.\n"
 "  --kdf=KDF                   Key derivation function to use: AES-128-ECB,\n"
 "                                HKDF-SHA512, or none.  Default: none\n"
 "  --mode-num=NUM              The encryption mode number.  This may be required\n"
 "                                for key derivation, depending on other options.\n"
-"  --padding=PADDING           If last block is partial, zero-pad it to next\n"
-"                                PADDING-byte boundary.  Default: BLOCK_SIZE\n"
+"  --padding=PADDING           If last data unit is partial, zero-pad it to next\n"
+"                                PADDING-byte boundary.  Default: DUSIZE\n"
 	, fp);
 }
 
 /*----------------------------------------------------------------------------*
  *                                 Utilities                                  *
  *----------------------------------------------------------------------------*/
 
 #define ARRAY_SIZE(A)		(sizeof(A) / sizeof((A)[0]))
 #define MIN(x, y)		((x) < (y) ? (x) : (y))
 #define MAX(x, y)		((x) > (y) ? (x) : (y))
@@ -1968,73 +1968,74 @@ static const struct fscrypt_cipher *find_fscrypt_cipher(const char *name)
 	for (i = 0; i < ARRAY_SIZE(fscrypt_ciphers); i++) {
 		if (strcmp(fscrypt_ciphers[i].name, name) == 0)
 			return &fscrypt_ciphers[i];
 	}
 	return NULL;
 }
 
 union fscrypt_iv {
 	/* usual IV format */
 	struct {
-		/* logical block number within the file */
-		__le64 block_number;
+		/* data unit index within the file */
+		__le64 data_unit_index;
 
 		/* per-file nonce; only set in DIRECT_KEY mode */
 		u8 nonce[FILE_NONCE_SIZE];
 	};
 	/* IV format for IV_INO_LBLK_* modes */
 	struct {
 		/*
-		 * IV_INO_LBLK_64: logical block number within the file
-		 * IV_INO_LBLK_32: hashed inode number + logical block number
-		 *		   within the file, mod 2^32
+		 * IV_INO_LBLK_64: data unit index within the file
+		 * IV_INO_LBLK_32: hashed inode number + data unit index within
+		 *		   the file, mod 2^32
 		 */
-		__le32 block_number32;
+		__le32 data_unit_index32;
 
 		/* IV_INO_LBLK_64: inode number */
 		__le32 inode_number;
 	};
 	/* Any extra bytes up to the algorithm's IV size must be zeroed */
 	u8 bytes[MAX_IV_SIZE];
 };
 
 static void crypt_loop(const struct fscrypt_cipher *cipher, const u8 *key,
 		       union fscrypt_iv *iv, bool decrypting,
-		       size_t block_size, size_t padding, bool is_bnum_32bit)
+		       size_t data_unit_size, size_t padding,
+		       bool is_data_unit_index_32bit)
 {
-	u8 *buf = xmalloc(block_size);
+	u8 *buf = xmalloc(data_unit_size);
 	size_t res;
 
-	while ((res = xread(STDIN_FILENO, buf, block_size)) > 0) {
-		size_t crypt_len = block_size;
+	while ((res = xread(STDIN_FILENO, buf, data_unit_size)) > 0) {
+		size_t crypt_len = data_unit_size;
 
 		if (padding > 0) {
 			crypt_len = MAX(res, cipher->min_input_size);
 			crypt_len = ROUND_UP(crypt_len, padding);
-			crypt_len = MIN(crypt_len, block_size);
+			crypt_len = MIN(crypt_len, data_unit_size);
 		}
 		ASSERT(crypt_len >= res);
 		memset(&buf[res], 0, crypt_len - res);
 
 		if (decrypting)
 			cipher->decrypt(key, iv->bytes, buf, buf, crypt_len);
 		else
 			cipher->encrypt(key, iv->bytes, buf, buf, crypt_len);
 
 		full_write(STDOUT_FILENO, buf, crypt_len);
 
-		if (is_bnum_32bit)
-			iv->block_number32 = cpu_to_le32(
-					le32_to_cpu(iv->block_number32) + 1);
+		if (is_data_unit_index_32bit)
+			iv->data_unit_index32 = cpu_to_le32(
+				le32_to_cpu(iv->data_unit_index32) + 1);
 		else
-			iv->block_number = cpu_to_le64(
-					le64_to_cpu(iv->block_number) + 1);
+			iv->data_unit_index = cpu_to_le64(
+				le64_to_cpu(iv->data_unit_index) + 1);
 	}
 	free(buf);
 }
 
 /* The supported key derivation functions */
 enum kdf_algorithm {
 	KDF_NONE,
 	KDF_AES_128_ECB,
 	KDF_HKDF_SHA512,
 };
@@ -2063,21 +2064,21 @@ static u8 parse_mode_number(const char *arg)
 struct key_and_iv_params {
 	u8 master_key[MAX_KEY_SIZE];
 	int master_key_size;
 	enum kdf_algorithm kdf;
 	u8 mode_num;
 	u8 file_nonce[FILE_NONCE_SIZE];
 	bool file_nonce_specified;
 	bool direct_key;
 	bool iv_ino_lblk_64;
 	bool iv_ino_lblk_32;
-	u64 block_number;
+	u64 data_unit_index;
 	u64 inode_number;
 	u8 fs_uuid[UUID_SIZE];
 	bool fs_uuid_specified;
 };
 
 #define HKDF_CONTEXT_KEY_IDENTIFIER	1
 #define HKDF_CONTEXT_PER_FILE_ENC_KEY	2
 #define HKDF_CONTEXT_DIRECT_KEY		3
 #define HKDF_CONTEXT_IV_INO_LBLK_64_KEY	4
 #define HKDF_CONTEXT_DIRHASH_KEY	5
@@ -2171,40 +2172,40 @@ static void derive_real_key(const struct key_and_iv_params *params,
 	}
 }
 
 static void generate_iv(const struct key_and_iv_params *params,
 			union fscrypt_iv *iv)
 {
 	memset(iv, 0, sizeof(*iv));
 	if (params->direct_key) {
 		if (!params->file_nonce_specified)
 			die("--direct-key requires --file-nonce");
-		iv->block_number = cpu_to_le64(params->block_number);
+		iv->data_unit_index = cpu_to_le64(params->data_unit_index);
 		memcpy(iv->nonce, params->file_nonce, FILE_NONCE_SIZE);
 	} else if (params->iv_ino_lblk_64) {
-		if (params->block_number > UINT32_MAX)
-			die("iv-ino-lblk-64 can't use --block-number > UINT32_MAX");
+		if (params->data_unit_index > UINT32_MAX)
+			die("iv-ino-lblk-64 can't use --data-unit-index > UINT32_MAX");
 		if (params->inode_number == 0)
 			die("iv-ino-lblk-64 requires --inode-number");
 		if (params->inode_number > UINT32_MAX)
 			die("iv-ino-lblk-64 can't use --inode-number > UINT32_MAX");
-		iv->block_number32 = cpu_to_le32(params->block_number);
+		iv->data_unit_index32 = cpu_to_le32(params->data_unit_index);
 		iv->inode_number = cpu_to_le32(params->inode_number);
 	} else if (params->iv_ino_lblk_32) {
-		if (params->block_number > UINT32_MAX)
-			die("iv-ino-lblk-32 can't use --block-number > UINT32_MAX");
+		if (params->data_unit_index > UINT32_MAX)
+			die("iv-ino-lblk-32 can't use --data-unit-index > UINT32_MAX");
 		if (params->inode_number == 0)
 			die("iv-ino-lblk-32 requires --inode-number");
-		iv->block_number32 = cpu_to_le32(hash_inode_number(params) +
-						 params->block_number);
+		iv->data_unit_index32 = cpu_to_le32(hash_inode_number(params) +
+						    params->data_unit_index);
 	} else {
-		iv->block_number = cpu_to_le64(params->block_number);
+		iv->data_unit_index = cpu_to_le64(params->data_unit_index);
 	}
 }
 
 /*
  * Get the key and starting IV with which the encryption will actually be done.
  * If a KDF was specified, then a subkey is derived from the master key.
  * Otherwise, the master key is used directly.
  */
 static void get_key_and_iv(const struct key_and_iv_params *params,
 			   u8 *real_key, size_t real_key_size,
@@ -2245,57 +2246,57 @@ static void do_dump_key_identifier(const struct key_and_iv_params *params)
 
 static void parse_master_key(const char *arg, struct key_and_iv_params *params)
 {
 	params->master_key_size = hex2bin(arg, params->master_key,
 					  MAX_KEY_SIZE);
 	if (params->master_key_size < 0)
 		die("Invalid master_key: %s", arg);
 }
 
 enum {
-	OPT_BLOCK_NUMBER,
-	OPT_BLOCK_SIZE,
+	OPT_DATA_UNIT_INDEX,
+	OPT_DATA_UNIT_SIZE,
 	OPT_DECRYPT,
 	OPT_DIRECT_KEY,
 	OPT_DUMP_KEY_IDENTIFIER,
 	OPT_FILE_NONCE,
 	OPT_FS_UUID,
 	OPT_HELP,
 	OPT_INODE_NUMBER,
 	OPT_IV_INO_LBLK_32,
 	OPT_IV_INO_LBLK_64,
 	OPT_KDF,
 	OPT_MODE_NUM,
 	OPT_PADDING,
 };
 
 static const struct option longopts[] = {
-	{ "block-number",    required_argument, NULL, OPT_BLOCK_NUMBER },
-	{ "block-size",      required_argument, NULL, OPT_BLOCK_SIZE },
+	{ "data-unit-index", required_argument, NULL, OPT_DATA_UNIT_INDEX },
+	{ "data-unit-size",  required_argument, NULL, OPT_DATA_UNIT_SIZE },
 	{ "decrypt",         no_argument,       NULL, OPT_DECRYPT },
 	{ "direct-key",      no_argument,       NULL, OPT_DIRECT_KEY },
 	{ "dump-key-identifier", no_argument,   NULL, OPT_DUMP_KEY_IDENTIFIER },
 	{ "file-nonce",      required_argument, NULL, OPT_FILE_NONCE },
 	{ "fs-uuid",         required_argument, NULL, OPT_FS_UUID },
 	{ "help",            no_argument,       NULL, OPT_HELP },
 	{ "inode-number",    required_argument, NULL, OPT_INODE_NUMBER },
 	{ "iv-ino-lblk-32",  no_argument,       NULL, OPT_IV_INO_LBLK_32 },
 	{ "iv-ino-lblk-64",  no_argument,       NULL, OPT_IV_INO_LBLK_64 },
 	{ "kdf",             required_argument, NULL, OPT_KDF },
 	{ "mode-num",        required_argument, NULL, OPT_MODE_NUM },
 	{ "padding",         required_argument, NULL, OPT_PADDING },
 	{ NULL, 0, NULL, 0 },
 };
 
 int main(int argc, char *argv[])
 {
-	size_t block_size = 4096;
+	size_t data_unit_size = 4096;
 	bool decrypting = false;
 	bool dump_key_identifier = false;
 	struct key_and_iv_params params;
 	size_t padding = 0;
 	const struct fscrypt_cipher *cipher;
 	u8 real_key[MAX_KEY_SIZE];
 	union fscrypt_iv iv;
 	char *tmp;
 	int c;
 
@@ -2308,31 +2309,31 @@ int main(int argc, char *argv[])
 	test_sha2();
 	test_hkdf_sha512();
 	test_aes_256_xts();
 	test_aes_256_cts_cbc();
 	test_adiantum();
 	test_aes_256_hctr2();
 #endif
 
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
 		switch (c) {
-		case OPT_BLOCK_NUMBER:
+		case OPT_DATA_UNIT_INDEX:
 			errno = 0;
-			params.block_number = strtoull(optarg, &tmp, 10);
+			params.data_unit_index = strtoull(optarg, &tmp, 10);
 			if (*tmp || errno)
-				die("Invalid block number: %s", optarg);
+				die("Invalid data unit index: %s", optarg);
 			break;
-		case OPT_BLOCK_SIZE:
+		case OPT_DATA_UNIT_SIZE:
 			errno = 0;
-			block_size = strtoul(optarg, &tmp, 10);
-			if (block_size <= 0 || *tmp || errno)
-				die("Invalid block size: %s", optarg);
+			data_unit_size = strtoul(optarg, &tmp, 10);
+			if (data_unit_size <= 0 || *tmp || errno)
+				die("Invalid data unit size: %s", optarg);
 			break;
 		case OPT_DECRYPT:
 			decrypting = true;
 			break;
 		case OPT_DIRECT_KEY:
 			params.direct_key = true;
 			break;
 		case OPT_DUMP_KEY_IDENTIFIER:
 			dump_key_identifier = true;
 			break;
@@ -2394,25 +2395,25 @@ int main(int argc, char *argv[])
 	}
 	if (argc != 2) {
 		usage(stderr);
 		return 2;
 	}
 
 	cipher = find_fscrypt_cipher(argv[0]);
 	if (cipher == NULL)
 		die("Unknown cipher: %s", argv[0]);
 
-	if (block_size < cipher->min_input_size)
-		die("Block size of %zu bytes is too small for cipher %s",
-		    block_size, cipher->name);
+	if (data_unit_size < cipher->min_input_size)
+		die("Data unit size of %zu bytes is too small for cipher %s",
+		    data_unit_size, cipher->name);
 
 	parse_master_key(argv[1], &params);
 
 	if (params.master_key_size < cipher->keysize)
 		die("Master key is too short for cipher %s", cipher->name);
 
 	get_key_and_iv(&params, real_key, cipher->keysize, &iv);
 
-	crypt_loop(cipher, real_key, &iv, decrypting, block_size, padding,
+	crypt_loop(cipher, real_key, &iv, decrypting, data_unit_size, padding,
 		   params.iv_ino_lblk_64 || params.iv_ino_lblk_32);
 	return 0;
 }
diff --git a/tests/f2fs/002 b/tests/f2fs/002
index 8235d88a..c0bf440b 100755
--- a/tests/f2fs/002
+++ b/tests/f2fs/002
@@ -133,30 +133,30 @@ nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
 
 echo -e "\n# Dumping the file's raw data"
 _dump_ciphertext_blocks $SCRATCH_DEV $blocklist > $tmp.raw
 
 echo -e "\n# Decrypting the file's data"
 TEST_RAW_KEY_HEX=$(echo "$TEST_RAW_KEY" | tr -d '\\x')
 decrypt_blocks()
 {
 	$here/src/fscrypt-crypt-util "$@"			\
 		--decrypt					\
-		--block-size=$block_size			\
+		--data-unit-size=$block_size			\
 		--file-nonce=$nonce				\
 		--kdf=HKDF-SHA512				\
 		AES-256-XTS					\
 		$TEST_RAW_KEY_HEX
 }
 head -c $num_compressible_bytes $tmp.raw \
-	| decrypt_blocks --block-number=1 > $tmp.decrypted
+	| decrypt_blocks --data-unit-index=1 > $tmp.decrypted
 dd if=$tmp.raw bs=$cluster_bytes skip=$num_compressible_clusters status=none \
-	| decrypt_blocks --block-number=$num_compressible_blocks \
+	| decrypt_blocks --data-unit-index=$num_compressible_blocks \
 	>> $tmp.decrypted
 
 # Decompress the compressed clusters using the lz4 command-line tool.
 #
 # Each f2fs compressed cluster begins with a 24-byte header, starting with the
 # compressed size in bytes (excluding the header) as a __le32.  The header is
 # followed by the actual compressed data; for LZ4, that means an LZ4 block.
 #
 # Unfortunately, the lz4 command-line tool only deals with LZ4 *frames*
 # (https://github.com/lz4/lz4/blob/master/doc/lz4_Frame_format.md) and can't
-- 
2.42.0

