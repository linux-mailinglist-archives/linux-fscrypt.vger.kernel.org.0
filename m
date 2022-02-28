Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6154C6409
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Feb 2022 08:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiB1Hth (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Feb 2022 02:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbiB1Htf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Feb 2022 02:49:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAABC3D1CE;
        Sun, 27 Feb 2022 23:48:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D17FB80E58;
        Mon, 28 Feb 2022 07:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3FEC340F3;
        Mon, 28 Feb 2022 07:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646034533;
        bh=SVSbmmZuBNWRYo5l3+eRPfTfeDjvLCb7XGjy8DkFlBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWXczMefXLjGBj96On3ikhUuVhRq/7D5npkeBWWyKAmR7I39iKcvi3RyFEUF3YPKm
         x84aTpWMqL9JAg3fPWwy1ox5/22kipHipaTWoWxFrRP+85b8gwngzw04L6lcBkG4ei
         +e1ukdrIOhG/Hb6YmwP0r8CZ0fqmSy14TdC+qrpaYQyHq8/mj5wfAG+nsa5B0QOmVz
         LflPEm9HoSQ9WDlIJYvUAqapKNHY4wHwUsiMTtQVP/4z8g/+Ls6bm6hnvBPu5qgCOJ
         2TaWGz3Ph/T8xUIC3Y4JbzqtmlxsJnDP7hcEy59CbDfOr3hWRdCjeXExQ2Nar//MZB
         v+4BCpel/vIgg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [RFC PATCH 3/8] fscrypt-crypt-util: add support for dumping key identifier
Date:   Sun, 27 Feb 2022 23:47:17 -0800
Message-Id: <20220228074722.77008-4-ebiggers@kernel.org>
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

Add an option to fscrypt-crypt-util to make it compute the key
identifier for the given key.  This will allow testing the correctness
of the filesystem's key identifier computation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 82 +++++++++++++++++++++++++++++-----------
 1 file changed, 60 insertions(+), 22 deletions(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 0ecf9272..876d9f5c 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -46,7 +46,7 @@
 static void usage(FILE *fp)
 {
 	fputs(
-"Usage: " PROGRAM_NAME " [OPTION]... CIPHER MASTER_KEY\n"
+"Usage: " PROGRAM_NAME " [OPTION]... [CIPHER | --dump-key-identifier] MASTER_KEY\n"
 "\n"
 "Utility for verifying fscrypt-encrypted data.  This program encrypts\n"
 "(or decrypts) the data on stdin using the given CIPHER with the given\n"
@@ -66,6 +66,8 @@ static void usage(FILE *fp)
 "  --decrypt                   Decrypt instead of encrypt\n"
 "  --direct-key                Use the format where the IVs include the file\n"
 "                                nonce and the same key is shared across files.\n"
+"  --dump-key-identifier       Instead of encrypting/decrypting data, just\n"
+"                                compute and dump the key identifier.\n"
 "  --file-nonce=NONCE          File's nonce as a 32-character hex string\n"
 "  --fs-uuid=UUID              The filesystem UUID as a 32-character hex string.\n"
 "                                Required for --iv-ino-lblk-32 and\n"
@@ -1946,11 +1948,31 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 	generate_iv(params, iv);
 }
 
+static void do_dump_key_identifier(const struct key_and_iv_params *params)
+{
+	u8 info[9] = "fscrypt";
+	u8 key_identifier[16];
+	int i;
+
+	if (params->kdf != KDF_HKDF_SHA512)
+		die("--dump-key-identifier requires --kdf=HKDF-SHA512");
+
+	info[8] = HKDF_CONTEXT_KEY_IDENTIFIER;
+
+	hkdf_sha512(params->master_key, params->master_key_size,
+		    NULL, 0, info, sizeof(info), key_identifier,
+		    sizeof(key_identifier));
+
+	for (i = 0; i < sizeof(key_identifier); i++)
+		printf("%02x", key_identifier[i]);
+}
+
 enum {
 	OPT_BLOCK_NUMBER,
 	OPT_BLOCK_SIZE,
 	OPT_DECRYPT,
 	OPT_DIRECT_KEY,
+	OPT_DUMP_KEY_IDENTIFIER,
 	OPT_FILE_NONCE,
 	OPT_FS_UUID,
 	OPT_HELP,
@@ -1967,6 +1989,7 @@ static const struct option longopts[] = {
 	{ "block-size",      required_argument, NULL, OPT_BLOCK_SIZE },
 	{ "decrypt",         no_argument,       NULL, OPT_DECRYPT },
 	{ "direct-key",      no_argument,       NULL, OPT_DIRECT_KEY },
+	{ "dump-key-identifier", no_argument,   NULL, OPT_DUMP_KEY_IDENTIFIER },
 	{ "file-nonce",      required_argument, NULL, OPT_FILE_NONCE },
 	{ "fs-uuid",         required_argument, NULL, OPT_FS_UUID },
 	{ "help",            no_argument,       NULL, OPT_HELP },
@@ -1983,9 +2006,10 @@ int main(int argc, char *argv[])
 {
 	size_t block_size = 4096;
 	bool decrypting = false;
+	bool dump_key_identifier = false;
 	struct key_and_iv_params params;
 	size_t padding = 0;
-	const struct fscrypt_cipher *cipher;
+	const struct fscrypt_cipher *cipher = NULL;
 	u8 real_key[MAX_KEY_SIZE];
 	union fscrypt_iv iv;
 	char *tmp;
@@ -2024,6 +2048,9 @@ int main(int argc, char *argv[])
 		case OPT_DIRECT_KEY:
 			params.direct_key = true;
 			break;
+		case OPT_DUMP_KEY_IDENTIFIER:
+			dump_key_identifier = true;
+			break;
 		case OPT_FILE_NONCE:
 			if (hex2bin(optarg, params.file_nonce, FILE_NONCE_SIZE)
 			    != FILE_NONCE_SIZE)
@@ -2071,29 +2098,40 @@ int main(int argc, char *argv[])
 	argc -= optind;
 	argv += optind;
 
-	if (argc != 2) {
-		usage(stderr);
-		return 2;
+	if (dump_key_identifier) {
+		if (argc != 1) {
+			usage(stderr);
+			return 2;
+		}
+	} else {
+		if (argc != 2) {
+			usage(stderr);
+			return 2;
+		}
+		cipher = find_fscrypt_cipher(*argv);
+		if (cipher == NULL)
+			die("Unknown cipher: %s", *argv);
+
+		if (block_size < cipher->min_input_size)
+			die("Block size of %zu bytes is too small for cipher %s",
+			    block_size, cipher->name);
+		argv++;
 	}
-
-	cipher = find_fscrypt_cipher(argv[0]);
-	if (cipher == NULL)
-		die("Unknown cipher: %s", argv[0]);
-
-	if (block_size < cipher->min_input_size)
-		die("Block size of %zu bytes is too small for cipher %s",
-		    block_size, cipher->name);
-
-	params.master_key_size = hex2bin(argv[1], params.master_key,
+	params.master_key_size = hex2bin(*argv, params.master_key,
 					 MAX_KEY_SIZE);
 	if (params.master_key_size < 0)
-		die("Invalid master_key: %s", argv[1]);
-	if (params.master_key_size < cipher->keysize)
-		die("Master key is too short for cipher %s", cipher->name);
+		die("Invalid master_key: %s", *argv);
 
-	get_key_and_iv(&params, real_key, cipher->keysize, &iv);
-
-	crypt_loop(cipher, real_key, &iv, decrypting, block_size, padding,
-		   params.iv_ino_lblk_64 || params.iv_ino_lblk_32);
+	if (dump_key_identifier) {
+		do_dump_key_identifier(&params);
+	} else {
+		if (params.master_key_size < cipher->keysize)
+			die("Master key is too short for cipher %s",
+			    cipher->name);
+		get_key_and_iv(&params, real_key, cipher->keysize, &iv);
+		crypt_loop(cipher, real_key, &iv, decrypting, block_size,
+			   padding,
+			   params.iv_ino_lblk_64 || params.iv_ino_lblk_32);
+	}
 	return 0;
 }
-- 
2.35.1

