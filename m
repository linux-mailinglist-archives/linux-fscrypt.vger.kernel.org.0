Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8FF15865B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Feb 2020 01:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgBKABF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Feb 2020 19:01:05 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44164 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbgBKABE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Feb 2020 19:01:04 -0500
Received: by mail-pg1-f196.google.com with SMTP id g3so4729587pgs.11
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Feb 2020 16:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zt2NAcTQdEecK9A1hvj/zrK0BwYTai/7XWAy7cHFWkQ=;
        b=DOe3U8tb4rcSbd9YR96ps7iyShWDaWO4tTsD05Aqvwz5OYrfcceuId25Xu81snFUiV
         blErD2Jnh/YmlvRZBMeTEjqFEmewmXNBot8g2/rxC+YRBfUSuNeBZhyTR7CXnCvisUg/
         Pm+zGWyf6jiVlVeggzacKTAV3pNqzksTzXIf0738sLLQ1nwCilmLpFrqL+ztM/gavSmU
         NsPkBMrCrjkBeukoleJ2exdgK9MB5N6d33spS355TGwKBwhqQ+klYpOJQG9oWXMFJIes
         uUVux72gJoM8e9FbMXn/OecnwtsFJz5rdmDc9B6FfzGHxJxf5bf1iISSMgehTI/L2kTF
         dSxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zt2NAcTQdEecK9A1hvj/zrK0BwYTai/7XWAy7cHFWkQ=;
        b=aRkCpKHRrd64WyghZMyVfBczxr0Q7wWb8ze4oudDx/MmcjaFH+Bm24kgzkgCp2LA70
         89qK83JpMEW9UPT6wGt00CAVLZ2OBj4lLCrj5r8Rg3InhKYo2dfXvi8Q8Yu/v3iaoj1n
         uRswKKBFckHteBABtBOAMkorJtgZ+PUpaUH4ybOOBNPbt2olFzT6IJCEq9YD30QbpBI3
         Wc3ljFf1Ce4s500cVTH/NOkAErJoN/B+iOI2UJw8pEX94yIYuG5bhOQI7KDh7zrDGjRA
         Sn1odG0Vx6PPMX0Xdqe/1m9yyV0DwT/1X4m5oXGTPo+lHnc19KHxpFI7alhHV2PUrHce
         SHww==
X-Gm-Message-State: APjAAAWZt5dexA9rlHYLFbBXvqcXdl3zuBIh5GCdZG7beYKZOI/L5QLv
        BMeYcvuX3ir0Ph3btSUtUPYEUDuD8Do=
X-Google-Smtp-Source: APXvYqy+Qn/+0n0Q7Tp8+NUQLjmcaK1pGZptBqvyLNez1cG7bxzRrDghxx2ZHtBiEQHMs5qhqqPNVQ==
X-Received: by 2002:a63:4525:: with SMTP id s37mr4042448pga.418.1581379263634;
        Mon, 10 Feb 2020 16:01:03 -0800 (PST)
Received: from localhost ([2620:10d:c090:200::6168])
        by smtp.gmail.com with ESMTPSA id d14sm540030pjz.12.2020.02.10.16.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 16:01:03 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 4/7] Make fsverity_cmd_enable a library call()
Date:   Mon, 10 Feb 2020 19:00:34 -0500
Message-Id: <20200211000037.189180-5-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Split the parsing of command line arguments from the actual cmd call,
which allows this to be called by other users.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_enable.c | 131 ++----------------------------------------------
 commands.h   |   3 +-
 fsverity.c   | 137 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 140 insertions(+), 131 deletions(-)

diff --git a/cmd_enable.c b/cmd_enable.c
index 1646299..8c55722 100644
--- a/cmd_enable.c
+++ b/cmd_enable.c
@@ -18,137 +18,17 @@
 #include "fsverity_uapi.h"
 #include "hash_algs.h"
 
-static bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
-{
-	char *end;
-	unsigned long n = strtoul(arg, &end, 10);
-	const struct fsverity_hash_alg *alg;
-
-	if (*alg_ptr != 0) {
-		error_msg("--hash-alg can only be specified once");
-		return false;
-	}
-
-	/* Specified by number? */
-	if (n > 0 && n < INT32_MAX && *end == '\0') {
-		*alg_ptr = n;
-		return true;
-	}
-
-	/* Specified by name? */
-	alg = find_hash_alg_by_name(arg);
-	if (alg != NULL) {
-		*alg_ptr = alg - fsverity_hash_algs;
-		return true;
-	}
-	return false;
-}
-
-static bool read_signature(const char *filename, u8 **sig_ret,
-			   u32 *sig_size_ret)
-{
-	struct filedes file = { .fd = -1 };
-	u64 file_size;
-	u8 *sig = NULL;
-	bool ok = false;
-
-	if (!open_file(&file, filename, O_RDONLY, 0))
-		goto out;
-	if (!get_file_size(&file, &file_size))
-		goto out;
-	if (file_size <= 0) {
-		error_msg("signature file '%s' is empty", filename);
-		goto out;
-	}
-	if (file_size > 1000000) {
-		error_msg("signature file '%s' is too large", filename);
-		goto out;
-	}
-	sig = xmalloc(file_size);
-	if (!full_read(&file, sig, file_size))
-		goto out;
-	*sig_ret = sig;
-	*sig_size_ret = file_size;
-	sig = NULL;
-	ok = true;
-out:
-	filedes_close(&file);
-	free(sig);
-	return ok;
-}
-
-enum {
-	OPT_HASH_ALG,
-	OPT_BLOCK_SIZE,
-	OPT_SALT,
-	OPT_SIGNATURE,
-};
-
-static const struct option longopts[] = {
-	{"hash-alg",	required_argument, NULL, OPT_HASH_ALG},
-	{"block-size",	required_argument, NULL, OPT_BLOCK_SIZE},
-	{"salt",	required_argument, NULL, OPT_SALT},
-	{"signature",	required_argument, NULL, OPT_SIGNATURE},
-	{NULL, 0, NULL, 0}
-};
-
 /* Enable fs-verity on a file. */
-int fsverity_cmd_enable(const struct fsverity_command *cmd,
-			int argc, char *argv[])
+int fsverity_cmd_enable(char *filename, struct fsverity_enable_arg *arg)
 {
-	struct fsverity_enable_arg arg = { .version = 1 };
 	u8 *salt = NULL;
 	u8 *sig = NULL;
 	struct filedes file;
 	int status;
-	int c;
-
-	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
-		switch (c) {
-		case OPT_HASH_ALG:
-			if (!parse_hash_alg_option(optarg, &arg.hash_algorithm))
-				goto out_usage;
-			break;
-		case OPT_BLOCK_SIZE:
-			if (!parse_block_size_option(optarg, &arg.block_size))
-				goto out_usage;
-			break;
-		case OPT_SALT:
-			if (!parse_salt_option(optarg, &salt, &arg.salt_size))
-				goto out_usage;
-			arg.salt_ptr = (uintptr_t)salt;
-			break;
-		case OPT_SIGNATURE:
-			if (sig != NULL) {
-				error_msg("--signature can only be specified once");
-				goto out_usage;
-			}
-			if (!read_signature(optarg, &sig, &arg.sig_size))
-				goto out_err;
-			arg.sig_ptr = (uintptr_t)sig;
-			break;
-		default:
-			goto out_usage;
-		}
-	}
 
-	argv += optind;
-	argc -= optind;
-
-	if (argc != 1)
-		goto out_usage;
-
-	if (arg.hash_algorithm == 0)
-		arg.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
-
-	if (arg.block_size == 0)
-		arg.block_size = get_default_block_size();
-
-	if (!open_file(&file, argv[0], O_RDONLY, 0))
+	if (!open_file(&file, filename, O_RDONLY, 0))
 		goto out_err;
-	if (ioctl(file.fd, FS_IOC_ENABLE_VERITY, &arg) != 0) {
-		error_msg_errno("FS_IOC_ENABLE_VERITY failed on '%s'",
-				file.name);
+	if (ioctl(file.fd, FS_IOC_ENABLE_VERITY, arg) != 0) {
 		filedes_close(&file);
 		goto out_err;
 	}
@@ -164,9 +44,4 @@ out:
 out_err:
 	status = 1;
 	goto out;
-
-out_usage:
-	usage(cmd, stderr);
-	status = 2;
-	goto out;
 }
diff --git a/commands.h b/commands.h
index 3e07f3d..e490c25 100644
--- a/commands.h
+++ b/commands.h
@@ -26,8 +26,7 @@ struct fsverity_signed_digest {
 
 void usage(const struct fsverity_command *cmd, FILE *fp);
 
-int fsverity_cmd_enable(const struct fsverity_command *cmd,
-			int argc, char *argv[]);
+int fsverity_cmd_enable(char *filename, struct fsverity_enable_arg *arg);
 int fsverity_cmd_measure(char *filename, struct fsverity_digest *d);
 int fsverity_cmd_sign(char *filename, const struct fsverity_hash_alg *hash_alg,
 		      u32 block_size, u8 *salt, u32 salt_size,
diff --git a/fsverity.c b/fsverity.c
index 49eca14..b4e67a2 100644
--- a/fsverity.c
+++ b/fsverity.c
@@ -24,6 +24,7 @@ enum {
 	OPT_SALT,
 	OPT_KEY,
 	OPT_CERT,
+	OPT_SIGNATURE,
 };
 
 static const struct option longopts[] = {
@@ -35,6 +36,14 @@ static const struct option longopts[] = {
 	{NULL, 0, NULL, 0}
 };
 
+static const struct option enable_longopts[] = {
+	{"hash-alg",	required_argument, NULL, OPT_HASH_ALG},
+	{"block-size",	required_argument, NULL, OPT_BLOCK_SIZE},
+	{"salt",	required_argument, NULL, OPT_SALT},
+	{"signature",	required_argument, NULL, OPT_SIGNATURE},
+	{NULL, 0, NULL, 0}
+};
+
 static bool write_signature(const char *filename, const u8 *sig, u32 sig_size)
 {
 	struct filedes file;
@@ -47,6 +56,65 @@ static bool write_signature(const char *filename, const u8 *sig, u32 sig_size)
 	return ok;
 }
 
+static bool read_signature(const char *filename, u8 **sig_ret,
+			   u32 *sig_size_ret)
+{
+	struct filedes file = { .fd = -1 };
+	u64 file_size;
+	u8 *sig = NULL;
+	bool ok = false;
+
+	if (!open_file(&file, filename, O_RDONLY, 0))
+		goto out;
+	if (!get_file_size(&file, &file_size))
+		goto out;
+	if (file_size <= 0) {
+		error_msg("signature file '%s' is empty", filename);
+		goto out;
+	}
+	if (file_size > 1000000) {
+		error_msg("signature file '%s' is too large", filename);
+		goto out;
+	}
+	sig = xmalloc(file_size);
+	if (!full_read(&file, sig, file_size))
+		goto out;
+	*sig_ret = sig;
+	*sig_size_ret = file_size;
+	sig = NULL;
+	ok = true;
+out:
+	filedes_close(&file);
+	free(sig);
+	return ok;
+}
+
+static bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
+{
+	char *end;
+	unsigned long n = strtoul(arg, &end, 10);
+	const struct fsverity_hash_alg *alg;
+
+	if (*alg_ptr != 0) {
+		error_msg("--hash-alg can only be specified once");
+		return false;
+	}
+
+	/* Specified by number? */
+	if (n > 0 && n < INT32_MAX && *end == '\0') {
+		*alg_ptr = n;
+		return true;
+	}
+
+	/* Specified by name? */
+	alg = find_hash_alg_by_name(arg);
+	if (alg != NULL) {
+		*alg_ptr = alg - fsverity_hash_algs;
+		return true;
+	}
+	return false;
+}
+
 int wrap_cmd_sign(const struct fsverity_command *cmd, int argc, char *argv[])
 {
 	struct fsverity_signed_digest *digest = NULL;
@@ -190,6 +258,73 @@ out_usage:
 	goto out;
 }
 
+int wrap_cmd_enable(const struct fsverity_command *cmd,
+		    int argc, char *argv[])
+{
+	struct fsverity_enable_arg arg = { .version = 1 };
+	u8 *salt = NULL;
+	u8 *sig = NULL;
+	int status;
+	int c;
+
+	while ((c = getopt_long(argc, argv, "", enable_longopts, NULL)) != -1) {
+		switch (c) {
+		case OPT_HASH_ALG:
+			if (!parse_hash_alg_option(optarg, &arg.hash_algorithm))
+				goto out_usage;
+			break;
+		case OPT_BLOCK_SIZE:
+			if (!parse_block_size_option(optarg, &arg.block_size))
+				goto out_usage;
+			break;
+		case OPT_SALT:
+			if (!parse_salt_option(optarg, &salt, &arg.salt_size))
+				goto out_usage;
+			arg.salt_ptr = (uintptr_t)salt;
+			break;
+		case OPT_SIGNATURE:
+			if (sig != NULL) {
+				error_msg("--signature can only be specified once");
+				goto out_usage;
+			}
+			if (!read_signature(optarg, &sig, &arg.sig_size)) {
+				error_msg("unable to read signature file %s",
+					  optarg);
+				status = 1;
+				goto out;
+			}
+			arg.sig_ptr = (uintptr_t)sig;
+			break;
+		default:
+			goto out_usage;
+		}
+	}
+
+	argv += optind;
+	argc -= optind;
+
+	if (argc != 1)
+		goto out_usage;
+
+	if (arg.hash_algorithm == 0)
+		arg.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
+
+	if (arg.block_size == 0)
+		arg.block_size = get_default_block_size();
+
+	status = fsverity_cmd_enable(argv[0], &arg);
+
+out:
+	free(salt);
+	free(sig);
+	return status;
+
+out_usage:
+	usage(cmd, stderr);
+	status = 2;
+	goto out;
+}
+
 static const struct fsverity_command {
 	const char *name;
 	int (*func)(const struct fsverity_command *cmd, int argc, char *argv[]);
@@ -198,7 +333,7 @@ static const struct fsverity_command {
 } fsverity_commands[] = {
 	{
 		.name = "enable",
-		.func = fsverity_cmd_enable,
+		.func = wrap_cmd_enable,
 		.short_desc = "Enable fs-verity on a file",
 		.usage_str =
 "    fsverity enable FILE\n"
-- 
2.24.1

