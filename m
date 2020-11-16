Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE472B5350
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 21:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgKPU4z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 15:56:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732799AbgKPU4z (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 15:56:55 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57E712225B;
        Mon, 16 Nov 2020 20:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605560214;
        bh=9Iip2WkgK1PGmkcJlDwmOLzdD2wYnCdSVf69NKdbLzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kel2iFLdC5qdKFToH7ucakJw/mYZ4Ljm3VlT0BX6yerWCu20y/1wOhmFVpZ8GXkxp
         yagnXcn1eVsJ+sgxDVMbb8RqrWjny3Jj2ThgTkrWb1CNwytTAl5CzzSDAyNnqTuk0t
         ISCykJSiRhADHLK7b6012YnYPOB7miE9bFk7XVfQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Luca Boccassi <luca.boccassi@gmail.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Luca Boccassi <luca.boccassi@microsoft.com>
Subject: [fsverity-utils PATCH v2 4/4] programs/fsverity: share code to parse tree parameters
Date:   Mon, 16 Nov 2020 12:56:28 -0800
Message-Id: <20201116205628.262173-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116205628.262173-1-ebiggers@kernel.org>
References: <20201116205628.262173-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The "digest", "enable", and "sign" commands all parse the --hash-alg,
--block-size, and --salt options and initialize a struct
libfsverity_merkle_tree_params, so share the code that does this.

Acked-by: Luca Boccassi <luca.boccassi@microsoft.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 programs/cmd_digest.c | 23 ++---------------------
 programs/cmd_enable.c | 22 ++--------------------
 programs/cmd_sign.c   | 23 ++---------------------
 programs/fsverity.c   | 29 ++++++++++++++++++++++++++---
 programs/fsverity.h   | 17 ++++++++++++++---
 5 files changed, 46 insertions(+), 68 deletions(-)

diff --git a/programs/cmd_digest.c b/programs/cmd_digest.c
index 4f7818e..68a1c9a 100644
--- a/programs/cmd_digest.c
+++ b/programs/cmd_digest.c
@@ -14,14 +14,6 @@
 #include <fcntl.h>
 #include <getopt.h>
 
-enum {
-	OPT_HASH_ALG,
-	OPT_BLOCK_SIZE,
-	OPT_SALT,
-	OPT_COMPACT,
-	OPT_FOR_BUILTIN_SIG,
-};
-
 static const struct option longopts[] = {
 	{"hash-alg",		required_argument, NULL, OPT_HASH_ALG},
 	{"block-size",		required_argument, NULL, OPT_BLOCK_SIZE},
@@ -44,7 +36,6 @@ struct fsverity_signed_digest {
 int fsverity_cmd_digest(const struct fsverity_command *cmd,
 		      int argc, char *argv[])
 {
-	u8 *salt = NULL;
 	struct filedes file = { .fd = -1 };
 	struct libfsverity_merkle_tree_params tree_params = { .version = 1 };
 	bool compact = false, for_builtin_sig = false;
@@ -54,20 +45,10 @@ int fsverity_cmd_digest(const struct fsverity_command *cmd,
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
 		switch (c) {
 		case OPT_HASH_ALG:
-			if (!parse_hash_alg_option(optarg,
-						   &tree_params.hash_algorithm))
-				goto out_usage;
-			break;
 		case OPT_BLOCK_SIZE:
-			if (!parse_block_size_option(optarg,
-						     &tree_params.block_size))
-				goto out_usage;
-			break;
 		case OPT_SALT:
-			if (!parse_salt_option(optarg, &salt,
-					       &tree_params.salt_size))
+			if (!parse_tree_param(c, optarg, &tree_params))
 				goto out_usage;
-			tree_params.salt = salt;
 			break;
 		case OPT_COMPACT:
 			compact = true;
@@ -140,7 +121,7 @@ int fsverity_cmd_digest(const struct fsverity_command *cmd,
 	}
 	status = 0;
 out:
-	free(salt);
+	destroy_tree_params(&tree_params);
 	return status;
 
 out_err:
diff --git a/programs/cmd_enable.c b/programs/cmd_enable.c
index b0e0c98..fdf26c7 100644
--- a/programs/cmd_enable.c
+++ b/programs/cmd_enable.c
@@ -49,13 +49,6 @@ out:
 	return ok;
 }
 
-enum {
-	OPT_HASH_ALG,
-	OPT_BLOCK_SIZE,
-	OPT_SALT,
-	OPT_SIGNATURE,
-};
-
 static const struct option longopts[] = {
 	{"hash-alg",	required_argument, NULL, OPT_HASH_ALG},
 	{"block-size",	required_argument, NULL, OPT_BLOCK_SIZE},
@@ -69,7 +62,6 @@ int fsverity_cmd_enable(const struct fsverity_command *cmd,
 			int argc, char *argv[])
 {
 	struct libfsverity_merkle_tree_params tree_params = { .version = 1 };
-	u8 *salt = NULL;
 	u8 *sig = NULL;
 	u32 sig_size = 0;
 	struct filedes file;
@@ -79,20 +71,10 @@ int fsverity_cmd_enable(const struct fsverity_command *cmd,
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
 		switch (c) {
 		case OPT_HASH_ALG:
-			if (!parse_hash_alg_option(optarg,
-						   &tree_params.hash_algorithm))
-				goto out_usage;
-			break;
 		case OPT_BLOCK_SIZE:
-			if (!parse_block_size_option(optarg,
-						     &tree_params.block_size))
-				goto out_usage;
-			break;
 		case OPT_SALT:
-			if (!parse_salt_option(optarg, &salt,
-					       &tree_params.salt_size))
+			if (!parse_tree_param(c, optarg, &tree_params))
 				goto out_usage;
-			tree_params.salt = salt;
 			break;
 		case OPT_SIGNATURE:
 			if (sig != NULL) {
@@ -127,7 +109,7 @@ int fsverity_cmd_enable(const struct fsverity_command *cmd,
 
 	status = 0;
 out:
-	free(salt);
+	destroy_tree_params(&tree_params);
 	free(sig);
 	return status;
 
diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
index 4b90944..0a08faa 100644
--- a/programs/cmd_sign.c
+++ b/programs/cmd_sign.c
@@ -26,14 +26,6 @@ static bool write_signature(const char *filename, const u8 *sig, u32 sig_size)
 	return ok;
 }
 
-enum {
-	OPT_HASH_ALG,
-	OPT_BLOCK_SIZE,
-	OPT_SALT,
-	OPT_KEY,
-	OPT_CERT,
-};
-
 static const struct option longopts[] = {
 	{"hash-alg",	required_argument, NULL, OPT_HASH_ALG},
 	{"block-size",	required_argument, NULL, OPT_BLOCK_SIZE},
@@ -48,7 +40,6 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 		      int argc, char *argv[])
 {
 	struct filedes file = { .fd = -1 };
-	u8 *salt = NULL;
 	struct libfsverity_merkle_tree_params tree_params = { .version = 1 };
 	struct libfsverity_signature_params sig_params = {};
 	struct libfsverity_digest *digest = NULL;
@@ -61,20 +52,10 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
 		switch (c) {
 		case OPT_HASH_ALG:
-			if (!parse_hash_alg_option(optarg,
-						   &tree_params.hash_algorithm))
-				goto out_usage;
-			break;
 		case OPT_BLOCK_SIZE:
-			if (!parse_block_size_option(optarg,
-						     &tree_params.block_size))
-				goto out_usage;
-			break;
 		case OPT_SALT:
-			if (!parse_salt_option(optarg, &salt,
-					       &tree_params.salt_size))
+			if (!parse_tree_param(c, optarg, &tree_params))
 				goto out_usage;
-			tree_params.salt = salt;
 			break;
 		case OPT_KEY:
 			if (sig_params.keyfile != NULL) {
@@ -136,7 +117,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	status = 0;
 out:
 	filedes_close(&file);
-	free(salt);
+	destroy_tree_params(&tree_params);
 	free(digest);
 	free(sig);
 	return status;
diff --git a/programs/fsverity.c b/programs/fsverity.c
index 33d0a3f..60ae05b 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -133,7 +133,7 @@ static const struct fsverity_command *find_command(const char *name)
 	return NULL;
 }
 
-bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
+static bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
 {
 	char *end;
 	unsigned long n = strtoul(arg, &end, 10);
@@ -158,7 +158,7 @@ bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
 	return false;
 }
 
-bool parse_block_size_option(const char *arg, u32 *size_ptr)
+static bool parse_block_size_option(const char *arg, u32 *size_ptr)
 {
 	char *end;
 	unsigned long n = strtoul(arg, &end, 10);
@@ -176,7 +176,8 @@ bool parse_block_size_option(const char *arg, u32 *size_ptr)
 	return true;
 }
 
-bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr)
+static bool parse_salt_option(const char *arg, u8 **salt_ptr,
+			      u32 *salt_size_ptr)
 {
 	if (*salt_ptr != NULL) {
 		error_msg("--salt can only be specified once");
@@ -191,6 +192,28 @@ bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr)
 	return true;
 }
 
+bool parse_tree_param(int opt_char, const char *arg,
+		      struct libfsverity_merkle_tree_params *params)
+{
+	switch (opt_char) {
+	case OPT_HASH_ALG:
+		return parse_hash_alg_option(arg, &params->hash_algorithm);
+	case OPT_BLOCK_SIZE:
+		return parse_block_size_option(arg, &params->block_size);
+	case OPT_SALT:
+		return parse_salt_option(arg, (u8 **)&params->salt,
+					 &params->salt_size);
+	default:
+		ASSERT(0);
+	}
+}
+
+void destroy_tree_params(struct libfsverity_merkle_tree_params *params)
+{
+	free((u8 *)params->salt);
+	memset(params, 0, sizeof(*params));
+}
+
 int main(int argc, char *argv[])
 {
 	const struct fsverity_command *cmd;
diff --git a/programs/fsverity.h b/programs/fsverity.h
index 37a6294..45c4fe1 100644
--- a/programs/fsverity.h
+++ b/programs/fsverity.h
@@ -20,6 +20,17 @@
  */
 #define FS_VERITY_MAX_DIGEST_SIZE	64
 
+enum {
+	OPT_BLOCK_SIZE,
+	OPT_CERT,
+	OPT_COMPACT,
+	OPT_FOR_BUILTIN_SIG,
+	OPT_HASH_ALG,
+	OPT_KEY,
+	OPT_SALT,
+	OPT_SIGNATURE,
+};
+
 struct fsverity_command;
 
 /* cmd_digest.c */
@@ -40,8 +51,8 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 
 /* fsverity.c */
 void usage(const struct fsverity_command *cmd, FILE *fp);
-bool parse_hash_alg_option(const char *arg, u32 *alg_ptr);
-bool parse_block_size_option(const char *arg, u32 *size_ptr);
-bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr);
+bool parse_tree_param(int opt_char, const char *arg,
+		      struct libfsverity_merkle_tree_params *params);
+void destroy_tree_params(struct libfsverity_merkle_tree_params *params);
 
 #endif /* PROGRAMS_FSVERITY_H */
-- 
2.29.2

