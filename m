Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6616E4D720B
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Mar 2022 02:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbiCMBHq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 12 Mar 2022 20:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbiCMBHp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 12 Mar 2022 20:07:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9D3148937;
        Sat, 12 Mar 2022 17:06:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0A06B80A28;
        Sun, 13 Mar 2022 01:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861B7C340EC;
        Sun, 13 Mar 2022 01:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647133595;
        bh=to6IW2z9U18TCna1FETwt+H7w+MF+NBX+9yA6HLX51w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZuCvijrPx7w/6sbzTX4IMtT47ee+ckrR8TWvzKmJ5bKyS/nTTI4/gL0FOPYyCUnF
         +CAfMCuweUgMO36OHTNdG4CLQdAbo+uw0b8c8eEOnwnZ3wAag7dxh+0CPtCx5a0OFO
         kB7qL/F6g12Z9I2BtAc8yCKFcT4TeLr5/BMFq04/z2FirwQvw3tw8bND3L8PGzwFJz
         SyvP4fzdlW5WO19y7hBfvCyW8jSlZwrpZFquyoJ8d/omQm34Qufhy2VeV533NGNkl0
         bus1F50F3kJGC8Kz0n/lSxgdDx2JYHnHjF9bISXhgmEYa9jMGsyesyLAYBFPTKj5li
         oDID8pktuz2pA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 1/5] fscrypt-crypt-util: use an explicit --direct-key option
Date:   Sat, 12 Mar 2022 17:05:55 -0800
Message-Id: <20220313010559.545995-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313010559.545995-1-ebiggers@kernel.org>
References: <20220313010559.545995-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make fscrypt-crypt-util use an option --direct-key to specify the use of
the DIRECT_KEY method for key derivation and IV generation.  Previously,
this method was implicitly detected via --mode-num being given without
either --iv-ino-lblk-64 or --iv-ino-lblk-32, or --kdf=none being given
in combination with --file-nonce.

The benefit of this change is that it makes the various options to
fscrypt-crypt-util behave more consistently.  --direct-key,
--iv-ino-lblk-64, and --iv-ino-lblk-32 now all work similarly (they
select a key derivation and IV generation method); likewise, --mode-num,
--file-nonce, --inode-number, and --fs-uuid now all work similarly (they
provide information that key derivation and IV generation may need).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt           | 10 ++++----
 src/fscrypt-crypt-util.c | 52 ++++++++++++++++++++++++----------------
 2 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index f90c4ef0..2cf02ca0 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -842,27 +842,25 @@ _verify_ciphertext_for_encryption_policy()
 
 	set_encpolicy_args+=" -c $contents_mode_num"
 	set_encpolicy_args+=" -n $filenames_mode_num"
+	crypt_util_contents_args+=" --mode-num=$contents_mode_num"
+	crypt_util_filename_args+=" --mode-num=$filenames_mode_num"
 
 	if (( policy_version > 1 )); then
 		set_encpolicy_args+=" -v 2"
 		crypt_util_args+=" --kdf=HKDF-SHA512"
 		if (( policy_flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY )); then
-			crypt_util_args+=" --mode-num=$contents_mode_num"
+			crypt_util_args+=" --direct-key"
 		elif (( policy_flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 )); then
 			crypt_util_args+=" --iv-ino-lblk-64"
-			crypt_util_contents_args+=" --mode-num=$contents_mode_num"
-			crypt_util_filename_args+=" --mode-num=$filenames_mode_num"
 		elif (( policy_flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32 )); then
 			crypt_util_args+=" --iv-ino-lblk-32"
-			crypt_util_contents_args+=" --mode-num=$contents_mode_num"
-			crypt_util_filename_args+=" --mode-num=$filenames_mode_num"
 		fi
 	else
 		if (( policy_flags & ~FSCRYPT_POLICY_FLAG_DIRECT_KEY )); then
 			_fail "unsupported flags for v1 policy: $policy_flags"
 		fi
 		if (( policy_flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY )); then
-			crypt_util_args+=" --kdf=none"
+			crypt_util_args+=" --direct-key --kdf=none"
 		else
 			crypt_util_args+=" --kdf=AES-128-ECB"
 		fi
diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 03cc3c4a..e5992275 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -64,6 +64,8 @@ static void usage(FILE *fp)
 "  --block-size=BLOCK_SIZE     Encrypt each BLOCK_SIZE bytes independently.\n"
 "                                Default: 4096 bytes\n"
 "  --decrypt                   Decrypt instead of encrypt\n"
+"  --direct-key                Use the format where the IVs include the file\n"
+"                                nonce and the same key is shared across files.\n"
 "  --file-nonce=NONCE          File's nonce as a 32-character hex string\n"
 "  --fs-uuid=UUID              The filesystem UUID as a 32-character hex string.\n"
 "                                Required for --iv-ino-lblk-32 and\n"
@@ -76,11 +78,10 @@ static void usage(FILE *fp)
 "                                32-bit variant.\n"
 "  --iv-ino-lblk-64            Use the format where the IVs include the inode\n"
 "                                number and the same key is shared across files.\n"
-"                                Requires --kdf=HKDF-SHA512, --fs-uuid,\n"
-"                                --inode-number, and --mode-num.\n"
 "  --kdf=KDF                   Key derivation function to use: AES-128-ECB,\n"
 "                                HKDF-SHA512, or none.  Default: none\n"
-"  --mode-num=NUM              Derive per-mode key using mode number NUM\n"
+"  --mode-num=NUM              The encryption mode number.  This may be required\n"
+"                                for key derivation, depending on other options.\n"
 "  --padding=PADDING           If last block is partial, zero-pad it to next\n"
 "                                PADDING-byte boundary.  Default: BLOCK_SIZE\n"
 	, fp);
@@ -1790,6 +1791,7 @@ struct key_and_iv_params {
 	u8 mode_num;
 	u8 file_nonce[FILE_NONCE_SIZE];
 	bool file_nonce_specified;
+	bool direct_key;
 	bool iv_ino_lblk_64;
 	bool iv_ino_lblk_32;
 	u64 block_number;
@@ -1835,7 +1837,7 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 			   u8 *real_key, size_t real_key_size,
 			   union fscrypt_iv *iv)
 {
-	bool file_nonce_in_iv = false;
+	int iv_methods = 0;
 	struct aes_key aes_key;
 	u8 info[8 + 1 + 1 + UUID_SIZE] = "fscrypt";
 	size_t infolen = 8;
@@ -1848,11 +1850,22 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 	/* Overridden later for iv_ino_lblk_{64,32} */
 	iv->block_number = cpu_to_le64(params->block_number);
 
-	if (params->iv_ino_lblk_64 || params->iv_ino_lblk_32) {
+	iv_methods += params->direct_key;
+	iv_methods += params->iv_ino_lblk_64;
+	iv_methods += params->iv_ino_lblk_32;
+	if (iv_methods > 1)
+		die("Conflicting IV methods specified");
+	if (iv_methods > 0 && params->kdf == KDF_AES_128_ECB)
+		die("--kdf=AES-128-ECB is incompatible with IV method options");
+
+	if (params->direct_key) {
+		if (!params->file_nonce_specified)
+			die("--direct-key requires --file-nonce");
+		if (params->kdf != KDF_NONE && params->mode_num == 0)
+			die("--direct-key with KDF requires --mode-num");
+	} else if (params->iv_ino_lblk_64 || params->iv_ino_lblk_32) {
 		const char *opt = params->iv_ino_lblk_64 ? "--iv-ino-lblk-64" :
 							   "--iv-ino-lblk-32";
-		if (params->iv_ino_lblk_64 && params->iv_ino_lblk_32)
-			die("--iv-ino-lblk-64 and --iv-ino-lblk-32 are mutually exclusive");
 		if (params->kdf != KDF_HKDF_SHA512)
 			die("%s requires --kdf=HKDF-SHA512", opt);
 		if (!params->fs_uuid_specified)
@@ -1869,16 +1882,11 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 
 	switch (params->kdf) {
 	case KDF_NONE:
-		if (params->mode_num != 0)
-			die("--mode-num isn't supported with --kdf=none");
 		memcpy(real_key, params->master_key, real_key_size);
-		file_nonce_in_iv = true;
 		break;
 	case KDF_AES_128_ECB:
 		if (!params->file_nonce_specified)
-			die("--file-nonce is required with --kdf=AES-128-ECB");
-		if (params->mode_num != 0)
-			die("--mode-num isn't supported with --kdf=AES-128-ECB");
+			die("--kdf=AES-128-ECB requires --file-nonce");
 		STATIC_ASSERT(FILE_NONCE_SIZE == AES_128_KEY_SIZE);
 		ASSERT(real_key_size % AES_BLOCK_SIZE == 0);
 		aes_setkey(&aes_key, params->file_nonce, AES_128_KEY_SIZE);
@@ -1887,7 +1895,10 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 				    &real_key[i]);
 		break;
 	case KDF_HKDF_SHA512:
-		if (params->iv_ino_lblk_64) {
+		if (params->direct_key) {
+			info[infolen++] = HKDF_CONTEXT_DIRECT_KEY;
+			info[infolen++] = params->mode_num;
+		} else if (params->iv_ino_lblk_64) {
 			info[infolen++] = HKDF_CONTEXT_IV_INO_LBLK_64_KEY;
 			info[infolen++] = params->mode_num;
 			memcpy(&info[infolen], params->fs_uuid, UUID_SIZE);
@@ -1903,17 +1914,13 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 				cpu_to_le32(hash_inode_number(params) +
 					    params->block_number);
 			iv->inode_number = 0;
-		} else if (params->mode_num != 0) {
-			info[infolen++] = HKDF_CONTEXT_DIRECT_KEY;
-			info[infolen++] = params->mode_num;
-			file_nonce_in_iv = true;
 		} else if (params->file_nonce_specified) {
 			info[infolen++] = HKDF_CONTEXT_PER_FILE_ENC_KEY;
 			memcpy(&info[infolen], params->file_nonce,
 			       FILE_NONCE_SIZE);
 			infolen += FILE_NONCE_SIZE;
 		} else {
-			die("With --kdf=HKDF-SHA512, at least one of --file-nonce and --mode-num must be specified");
+			die("--kdf=HKDF-SHA512 requires --file-nonce or --iv-ino-lblk-{64,32}");
 		}
 		hkdf_sha512(params->master_key, params->master_key_size,
 			    NULL, 0, info, infolen, real_key, real_key_size);
@@ -1922,7 +1929,7 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 		ASSERT(0);
 	}
 
-	if (file_nonce_in_iv && params->file_nonce_specified)
+	if (params->direct_key)
 		memcpy(iv->nonce, params->file_nonce, FILE_NONCE_SIZE);
 }
 
@@ -1930,6 +1937,7 @@ enum {
 	OPT_BLOCK_NUMBER,
 	OPT_BLOCK_SIZE,
 	OPT_DECRYPT,
+	OPT_DIRECT_KEY,
 	OPT_FILE_NONCE,
 	OPT_FS_UUID,
 	OPT_HELP,
@@ -1945,6 +1953,7 @@ static const struct option longopts[] = {
 	{ "block-number",    required_argument, NULL, OPT_BLOCK_NUMBER },
 	{ "block-size",      required_argument, NULL, OPT_BLOCK_SIZE },
 	{ "decrypt",         no_argument,       NULL, OPT_DECRYPT },
+	{ "direct-key",      no_argument,       NULL, OPT_DIRECT_KEY },
 	{ "file-nonce",      required_argument, NULL, OPT_FILE_NONCE },
 	{ "fs-uuid",         required_argument, NULL, OPT_FS_UUID },
 	{ "help",            no_argument,       NULL, OPT_HELP },
@@ -1999,6 +2008,9 @@ int main(int argc, char *argv[])
 		case OPT_DECRYPT:
 			decrypting = true;
 			break;
+		case OPT_DIRECT_KEY:
+			params.direct_key = true;
+			break;
 		case OPT_FILE_NONCE:
 			if (hex2bin(optarg, params.file_nonce, FILE_NONCE_SIZE)
 			    != FILE_NONCE_SIZE)
-- 
2.35.1

