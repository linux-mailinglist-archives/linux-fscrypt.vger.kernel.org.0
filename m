Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560392B29C1
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 Nov 2020 01:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgKNAQL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 19:16:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgKNAQL (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 19:16:11 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD5C822258;
        Sat, 14 Nov 2020 00:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605312970;
        bh=RmtBP+EuL5wGMDzAmc87QKdbWaGmJ527ZAnw9hjmNnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUQh/daM6RMnSf2J2IaKbGTqP4imM0npvOM+Z7XWX36zyQwe1Ye27hXBaxvTbyzys
         Ls78GFfKEptEYHXW6jRSWxTsOcjh5NOa/fTtkfJsbT9/zQ3YyfkobeUbLxLoZS6TUR
         U/zAWwi5oG1FR+svkp3oz2MxMWAoaB5yPC6Usuaw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Luca Boccassi <luca.boccassi@gmail.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: [fsverity-utils PATCH 2/2] programs/fsverity: share code to parse tree parameters
Date:   Fri, 13 Nov 2020 16:15:29 -0800
Message-Id: <20201114001529.185751-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201114001529.185751-1-ebiggers@kernel.org>
References: <20201114001529.185751-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The "digest", "enable", and "sign" commands all parse the --hash-alg,
--block-size, and --salt options and initialize a struct
libfsverity_merkle_tree_params, so share the code that does this.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 programs/cmd_digest.c | 31 ++++---------------------------
 programs/cmd_enable.c | 30 ++++--------------------------
 programs/cmd_sign.c   | 31 ++++---------------------------
 programs/fsverity.c   | 42 ++++++++++++++++++++++++++++++++++++++----
 programs/fsverity.h   | 19 +++++++++++++++----
 5 files changed, 65 insertions(+), 88 deletions(-)

diff --git a/programs/cmd_digest.c b/programs/cmd_digest.c
index 180f438..e420d17 100644
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
@@ -44,9 +36,8 @@ struct fsverity_signed_digest {
 int fsverity_cmd_digest(const struct fsverity_command *cmd,
 		      int argc, char *argv[])
 {
-	u8 *salt = NULL;
 	struct filedes file = { .fd = -1 };
-	struct libfsverity_merkle_tree_params tree_params = { .version = 1 };
+	struct libfsverity_merkle_tree_params tree_params = {};
 	bool compact = false, for_builtin_sig = false;
 	int status;
 	int c;
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
@@ -86,11 +67,7 @@ int fsverity_cmd_digest(const struct fsverity_command *cmd,
 	if (argc < 1)
 		goto out_usage;
 
-	if (tree_params.hash_algorithm == 0)
-		tree_params.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
-
-	if (tree_params.block_size == 0)
-		tree_params.block_size = get_default_block_size();
+	finalize_tree_params(&tree_params);
 
 	for (int i = 0; i < argc; i++) {
 		struct fsverity_signed_digest *d = NULL;
@@ -146,7 +123,7 @@ int fsverity_cmd_digest(const struct fsverity_command *cmd,
 	}
 	status = 0;
 out:
-	free(salt);
+	destroy_tree_params(&tree_params);
 	return status;
 
 out_err:
diff --git a/programs/cmd_enable.c b/programs/cmd_enable.c
index 48d33c2..3c722e5 100644
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
@@ -68,8 +61,7 @@ static const struct option longopts[] = {
 int fsverity_cmd_enable(const struct fsverity_command *cmd,
 			int argc, char *argv[])
 {
-	struct libfsverity_merkle_tree_params tree_params = { .version = 1 };
-	u8 *salt = NULL;
+	struct libfsverity_merkle_tree_params tree_params = {};
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
@@ -113,11 +95,7 @@ int fsverity_cmd_enable(const struct fsverity_command *cmd,
 	if (argc != 1)
 		goto out_usage;
 
-	if (tree_params.hash_algorithm == 0)
-		tree_params.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
-
-	if (tree_params.block_size == 0)
-		tree_params.block_size = get_default_block_size();
+	finalize_tree_params(&tree_params);
 
 	if (!open_file(&file, argv[0], O_RDONLY, 0))
 		goto out_err;
@@ -133,7 +111,7 @@ int fsverity_cmd_enable(const struct fsverity_command *cmd,
 
 	status = 0;
 out:
-	free(salt);
+	destroy_tree_params(&tree_params);
 	free(sig);
 	return status;
 
diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
index 580e4df..fb17b8a 100644
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
@@ -48,8 +40,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 		      int argc, char *argv[])
 {
 	struct filedes file = { .fd = -1 };
-	u8 *salt = NULL;
-	struct libfsverity_merkle_tree_params tree_params = { .version = 1 };
+	struct libfsverity_merkle_tree_params tree_params = {};
 	struct libfsverity_signature_params sig_params = {};
 	struct libfsverity_digest *digest = NULL;
 	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + 1];
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
@@ -101,11 +82,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	if (argc != 2)
 		goto out_usage;
 
-	if (tree_params.hash_algorithm == 0)
-		tree_params.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
-
-	if (tree_params.block_size == 0)
-		tree_params.block_size = get_default_block_size();
+	finalize_tree_params(&tree_params);
 
 	if (sig_params.keyfile == NULL) {
 		error_msg("Missing --key argument");
@@ -143,7 +120,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	status = 0;
 out:
 	filedes_close(&file);
-	free(salt);
+	destroy_tree_params(&tree_params);
 	free(digest);
 	free(sig);
 	return status;
diff --git a/programs/fsverity.c b/programs/fsverity.c
index 4a2f8df..052a640 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -134,7 +134,7 @@ static const struct fsverity_command *find_command(const char *name)
 	return NULL;
 }
 
-bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
+static bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
 {
 	char *end;
 	unsigned long n = strtoul(arg, &end, 10);
@@ -159,7 +159,7 @@ bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
 	return false;
 }
 
-bool parse_block_size_option(const char *arg, u32 *size_ptr)
+static bool parse_block_size_option(const char *arg, u32 *size_ptr)
 {
 	char *end;
 	unsigned long n = strtoul(arg, &end, 10);
@@ -177,7 +177,8 @@ bool parse_block_size_option(const char *arg, u32 *size_ptr)
 	return true;
 }
 
-bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr)
+static bool parse_salt_option(const char *arg, u8 **salt_ptr,
+			      u32 *salt_size_ptr)
 {
 	if (*salt_ptr != NULL) {
 		error_msg("--salt can only be specified once");
@@ -192,7 +193,23 @@ bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr)
 	return true;
 }
 
-u32 get_default_block_size(void)
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
+static u32 get_default_block_size(void)
 {
 	long n = sysconf(_SC_PAGESIZE);
 
@@ -205,6 +222,23 @@ u32 get_default_block_size(void)
 	return n;
 }
 
+void finalize_tree_params(struct libfsverity_merkle_tree_params *params)
+{
+	params->version = 1;
+
+	if (params->hash_algorithm == 0)
+		params->hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
+
+	if (params->block_size == 0)
+		params->block_size = get_default_block_size();
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
index 669fef2..51bba32 100644
--- a/programs/fsverity.h
+++ b/programs/fsverity.h
@@ -23,6 +23,17 @@
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
@@ -43,9 +54,9 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 
 /* fsverity.c */
 void usage(const struct fsverity_command *cmd, FILE *fp);
-bool parse_hash_alg_option(const char *arg, u32 *alg_ptr);
-bool parse_block_size_option(const char *arg, u32 *size_ptr);
-bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr);
-u32 get_default_block_size(void);
+bool parse_tree_param(int opt_char, const char *arg,
+		      struct libfsverity_merkle_tree_params *params);
+void finalize_tree_params(struct libfsverity_merkle_tree_params *params);
+void destroy_tree_params(struct libfsverity_merkle_tree_params *params);
 
 #endif /* PROGRAMS_FSVERITY_H */
-- 
2.29.2

