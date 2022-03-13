Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D92F4D7208
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Mar 2022 02:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiCMBHo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 12 Mar 2022 20:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiCMBHn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 12 Mar 2022 20:07:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF51145E38;
        Sat, 12 Mar 2022 17:06:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F46C60DC6;
        Sun, 13 Mar 2022 01:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B1EC340F3;
        Sun, 13 Mar 2022 01:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647133596;
        bh=xSWwMaATSOlo0tZ18wM2im1YC+0I7XtkCleyPTUOXE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KIbbAyZlVUwPQlgZ4+NSZ/FEnOTksBOI1IV1qg2wxSAhHNaVp9mj6GZXgsvEsWyAf
         Ajbu+dLoAOCn9e/oe01r8n+XXKlaZbiaiDU/U1hEsko8WWbg7D2LqsDR8CbspxN8vX
         GHbCks97u3Mls0XG5oVRPJBYlGPzx7MGXieQr2HVS4R0Ki1jyPavi72zdSPCNjtgay
         QqyPulnAaIkVcKByCReAEj+zZgiKTVWsI+pQdLLtHfr8ryT6RsAlSHq5lxP+hm4Y7s
         G4q8hBSrZyl0eGiYqqfmduUEsYPKpN3u8AvIx/QjCkQxQzvUPyuhhfypZYd6UmcxOX
         MSTMzhpV+8Fog==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 3/5] fscrypt-crypt-util: add support for dumping key identifier
Date:   Sat, 12 Mar 2022 17:05:57 -0800
Message-Id: <20220313010559.545995-4-ebiggers@kernel.org>
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

Add an option to fscrypt-crypt-util to make it compute the key
identifier for the given key.  This will allow testing the correctness
of the filesystem's key identifier computation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 51 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 124eb23f..ffb9534d 100644
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
@@ -1949,11 +1951,38 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 	generate_iv(params, iv);
 }
 
+static void do_dump_key_identifier(const struct key_and_iv_params *params)
+{
+	u8 info[9] = "fscrypt";
+	u8 key_identifier[16];
+	int i;
+
+	info[8] = HKDF_CONTEXT_KEY_IDENTIFIER;
+
+	if (params->kdf != KDF_HKDF_SHA512)
+		die("--dump-key-identifier requires --kdf=HKDF-SHA512");
+	hkdf_sha512(params->master_key, params->master_key_size,
+		    NULL, 0, info, sizeof(info),
+		    key_identifier, sizeof(key_identifier));
+
+	for (i = 0; i < sizeof(key_identifier); i++)
+		printf("%02x", key_identifier[i]);
+}
+
+static void parse_master_key(const char *arg, struct key_and_iv_params *params)
+{
+	params->master_key_size = hex2bin(arg, params->master_key,
+					  MAX_KEY_SIZE);
+	if (params->master_key_size < 0)
+		die("Invalid master_key: %s", arg);
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
@@ -1970,6 +1999,7 @@ static const struct option longopts[] = {
 	{ "block-size",      required_argument, NULL, OPT_BLOCK_SIZE },
 	{ "decrypt",         no_argument,       NULL, OPT_DECRYPT },
 	{ "direct-key",      no_argument,       NULL, OPT_DIRECT_KEY },
+	{ "dump-key-identifier", no_argument,   NULL, OPT_DUMP_KEY_IDENTIFIER },
 	{ "file-nonce",      required_argument, NULL, OPT_FILE_NONCE },
 	{ "fs-uuid",         required_argument, NULL, OPT_FS_UUID },
 	{ "help",            no_argument,       NULL, OPT_HELP },
@@ -1986,6 +2016,7 @@ int main(int argc, char *argv[])
 {
 	size_t block_size = 4096;
 	bool decrypting = false;
+	bool dump_key_identifier = false;
 	struct key_and_iv_params params;
 	size_t padding = 0;
 	const struct fscrypt_cipher *cipher;
@@ -2027,6 +2058,9 @@ int main(int argc, char *argv[])
 		case OPT_DIRECT_KEY:
 			params.direct_key = true;
 			break;
+		case OPT_DUMP_KEY_IDENTIFIER:
+			dump_key_identifier = true;
+			break;
 		case OPT_FILE_NONCE:
 			if (hex2bin(optarg, params.file_nonce, FILE_NONCE_SIZE)
 			    != FILE_NONCE_SIZE)
@@ -2074,6 +2108,15 @@ int main(int argc, char *argv[])
 	argc -= optind;
 	argv += optind;
 
+	if (dump_key_identifier) {
+		if (argc != 1) {
+			usage(stderr);
+			return 2;
+		}
+		parse_master_key(argv[0], &params);
+		do_dump_key_identifier(&params);
+		return 0;
+	}
 	if (argc != 2) {
 		usage(stderr);
 		return 2;
@@ -2087,10 +2130,8 @@ int main(int argc, char *argv[])
 		die("Block size of %zu bytes is too small for cipher %s",
 		    block_size, cipher->name);
 
-	params.master_key_size = hex2bin(argv[1], params.master_key,
-					 MAX_KEY_SIZE);
-	if (params.master_key_size < 0)
-		die("Invalid master_key: %s", argv[1]);
+	parse_master_key(argv[1], &params);
+
 	if (params.master_key_size < cipher->keysize)
 		die("Master key is too short for cipher %s", cipher->name);
 
-- 
2.35.1

