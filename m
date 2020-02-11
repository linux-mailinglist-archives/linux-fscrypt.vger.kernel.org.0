Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9147158659
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Feb 2020 01:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgBKAA5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Feb 2020 19:00:57 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39693 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbgBKAA5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Feb 2020 19:00:57 -0500
Received: by mail-pj1-f66.google.com with SMTP id e9so448930pjr.4
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Feb 2020 16:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7hEAib8ELxLbUK8nJSpAmW9igi7majswKHW1Qhm97zw=;
        b=ms0wiOM12RH2L35dkDNy2Zudo27lSsITpYI3AxGFM0RN7sHpc9bFpAqFijpwHbXd1b
         to93fN3iIoi/Dy7WuZ4o4W98uMxbLnWOTEjmD+LXHnc6vZ9MF12GaPAhIZcQgoZlOYrP
         PwG/7RAdT2ltj80fvgIqFtRcmT9Wg9nKaEwWuE/yAlk0WQsvilpA/DVJDt/T5VWpVQ8j
         Xuxj92ti6WsuafWLstz3H1lj/WCZ3bjhBeytY1rSZpq9QYkHKX2aW47//h8VzMmbFCmB
         CRAcQyedUAtT+oWbhD9VVx1lDrzHl8gUJNzdV3ch5rL10LgsEN9Mfueoe5LS0Yt23Xzm
         ObuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7hEAib8ELxLbUK8nJSpAmW9igi7majswKHW1Qhm97zw=;
        b=Tsrw+jIy4xSiacfJyKBEctRx+8/L+zmLNLyGjI9fF0N0+rNDGmtpEzMsoJjhuNTbRC
         3rJ1HEgf6OTpUdq2Ehd88Yyzprt9zfdtwZ2mRyom1MZBGlePlSGf4YnK5Z4gOeThi7BQ
         hCQxeizK6wtrMiHFolIa9Um0D88hvg5N7HtMcZXGpuGBcJX3Eqs341JGnW8PkVNbLKmL
         K3kJQjKYKHm+qmeyYixGntqzZMTifUMimskcfKL/iQPqJ+V+5dQRV+d2/icHUUl0SpM0
         sv7saxBFLgGeWC+YLvgCaK0/SCIhuQmTh3rRr4lnpxH5lDmQXCcf9JU2U6C/PtbuIgm3
         67PQ==
X-Gm-Message-State: APjAAAVgBXSDR7vsCUC5vuuNnGdlfiFjiKJc+8rPCsWBfcuyPGJYKNye
        xn+1zprapQDn2dt0yJQdN+ABfCWU4vU=
X-Google-Smtp-Source: APXvYqwd7AhJfs74E/4H4vfEh1vfqrTxa3pK0D6AZmdK0JMBfMOh6tjgofwQ0jVHr86RUpw20487jg==
X-Received: by 2002:a17:90a:fe02:: with SMTP id ck2mr1887438pjb.10.1581379254729;
        Mon, 10 Feb 2020 16:00:54 -0800 (PST)
Received: from localhost ([2620:10d:c090:200::6168])
        by smtp.gmail.com with ESMTPSA id r6sm1414846pfh.91.2020.02.10.16.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 16:00:54 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 2/7] Restructure fsverity_cmd_sign for shared libraries
Date:   Mon, 10 Feb 2020 19:00:32 -0500
Message-Id: <20200211000037.189180-3-Jes.Sorensen@gmail.com>
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

This moves the command line parsing, error reporting etc. to the command
line tool, and turns fsverity_cmd_sign() into a call returning the
digest and the signature.

It is the responsibility of the caller to decide what to do with the
returned objects.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_sign.c | 132 ++++++-----------------------------------------------
 commands.h |  23 +++++++++-
 fsverity.c | 129 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 163 insertions(+), 121 deletions(-)

diff --git a/cmd_sign.c b/cmd_sign.c
index dcb37ce..2d3fa54 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -8,7 +8,6 @@
  */
 
 #include <fcntl.h>
-#include <getopt.h>
 #include <limits.h>
 #include <openssl/bio.h>
 #include <openssl/err.h>
@@ -38,19 +37,6 @@ struct fsverity_descriptor {
 	__u8 signature[];	/* optional PKCS#7 signature */
 };
 
-/*
- * Format in which verity file measurements are signed.  This is the same as
- * 'struct fsverity_digest', except here some magic bytes are prepended to
- * provide some context about what is being signed in case the same key is used
- * for non-fsverity purposes, and here the fields have fixed endianness.
- */
-struct fsverity_signed_digest {
-	char magic[8];			/* must be "FSVerity" */
-	__le16 digest_algorithm;
-	__le16 digest_size;
-	__u8 digest[];
-};
-
 static void __printf(1, 2) __cold
 error_msg_openssl(const char *format, ...)
 {
@@ -340,18 +326,6 @@ out:
 	return ok;
 }
 
-static bool write_signature(const char *filename, const u8 *sig, u32 sig_size)
-{
-	struct filedes file;
-	bool ok;
-
-	if (!open_file(&file, filename, O_WRONLY|O_CREAT|O_TRUNC, 0644))
-		return false;
-	ok = full_write(&file, sig, sig_size);
-	ok &= filedes_close(&file);
-	return ok;
-}
-
 #define FS_VERITY_MAX_LEVELS	64
 
 struct block_buffer {
@@ -507,93 +481,27 @@ out:
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
-static const struct option longopts[] = {
-	{"hash-alg",	required_argument, NULL, OPT_HASH_ALG},
-	{"block-size",	required_argument, NULL, OPT_BLOCK_SIZE},
-	{"salt",	required_argument, NULL, OPT_SALT},
-	{"key",		required_argument, NULL, OPT_KEY},
-	{"cert",	required_argument, NULL, OPT_CERT},
-	{NULL, 0, NULL, 0}
-};
-
 /* Sign a file for fs-verity by computing its measurement, then signing it. */
-int fsverity_cmd_sign(const struct fsverity_command *cmd,
-		      int argc, char *argv[])
+int fsverity_cmd_sign(char *filename, const struct fsverity_hash_alg *hash_alg,
+		      u32 block_size, u8 *salt, u32 salt_size,
+		      const char *keyfile, const char *certfile,
+		      struct fsverity_signed_digest **retdigest,
+		      u8 **sig, u32 *sig_size)
 {
-	const struct fsverity_hash_alg *hash_alg = NULL;
-	u32 block_size = 0;
-	u8 *salt = NULL;
-	u32 salt_size = 0;
-	const char *keyfile = NULL;
-	const char *certfile = NULL;
 	struct fsverity_signed_digest *digest = NULL;
-	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + 1];
-	u8 *sig = NULL;
-	u32 sig_size;
 	int status;
-	int c;
-
-	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
-		switch (c) {
-		case OPT_HASH_ALG:
-			if (hash_alg != NULL) {
-				error_msg("--hash-alg can only be specified once");
-				goto out_usage;
-			}
-			hash_alg = find_hash_alg_by_name(optarg);
-			if (hash_alg == NULL)
-				goto out_usage;
-			break;
-		case OPT_BLOCK_SIZE:
-			if (!parse_block_size_option(optarg, &block_size))
-				goto out_usage;
-			break;
-		case OPT_SALT:
-			if (!parse_salt_option(optarg, &salt, &salt_size))
-				goto out_usage;
-			break;
-		case OPT_KEY:
-			if (keyfile != NULL) {
-				error_msg("--key can only be specified once");
-				goto out_usage;
-			}
-			keyfile = optarg;
-			break;
-		case OPT_CERT:
-			if (certfile != NULL) {
-				error_msg("--cert can only be specified once");
-				goto out_usage;
-			}
-			certfile = optarg;
-			break;
-		default:
-			goto out_usage;
-		}
-	}
 
-	argv += optind;
-	argc -= optind;
-
-	if (argc != 2)
-		goto out_usage;
-
-	if (hash_alg == NULL)
-		hash_alg = &fsverity_hash_algs[FS_VERITY_HASH_ALG_DEFAULT];
+	if (hash_alg == NULL) {
+		status = -EINVAL;
+		goto out;
+	}
 
 	if (block_size == 0)
 		block_size = get_default_block_size();
 
 	if (keyfile == NULL) {
-		error_msg("Missing --key argument");
-		goto out_usage;
+		status = -EINVAL;
+		goto out;
 	}
 	if (certfile == NULL)
 		certfile = keyfile;
@@ -603,33 +511,21 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	digest->digest_algorithm = cpu_to_le16(hash_alg - fsverity_hash_algs);
 	digest->digest_size = cpu_to_le16(hash_alg->digest_size);
 
-	if (!compute_file_measurement(argv[0], hash_alg, block_size,
+	if (!compute_file_measurement(filename, hash_alg, block_size,
 				      salt, salt_size, digest->digest))
 		goto out_err;
 
 	if (!sign_data(digest, sizeof(*digest) + hash_alg->digest_size,
-		       keyfile, certfile, hash_alg, &sig, &sig_size))
-		goto out_err;
-
-	if (!write_signature(argv[1], sig, sig_size))
+		       keyfile, certfile, hash_alg, sig, sig_size))
 		goto out_err;
 
-	bin2hex(digest->digest, hash_alg->digest_size, digest_hex);
-	printf("Signed file '%s' (%s:%s)\n", argv[0], hash_alg->name,
-	       digest_hex);
+	*retdigest = digest;
 	status = 0;
 out:
-	free(salt);
-	free(digest);
-	free(sig);
 	return status;
 
 out_err:
 	status = 1;
 	goto out;
 
-out_usage:
-	usage(cmd, stderr);
-	status = 2;
-	goto out;
 }
diff --git a/commands.h b/commands.h
index 98f9745..c38fcea 100644
--- a/commands.h
+++ b/commands.h
@@ -5,17 +5,36 @@
 #include <stdio.h>
 
 #include "util.h"
+#include "hash_algs.h"
+#include "fsverity_uapi.h"
 
 struct fsverity_command;
 
+/*
+ * Format in which verity file measurements are signed.  This is the same as
+ * 'struct fsverity_digest', except here some magic bytes are prepended to
+ * provide some context about what is being signed in case the same key is used
+ * for non-fsverity purposes, and here the fields have fixed endianness.
+ */
+struct fsverity_signed_digest {
+	char magic[8];			/* must be "FSVerity" */
+	__le16 digest_algorithm;
+	__le16 digest_size;
+	__u8 digest[];
+};
+
+
 void usage(const struct fsverity_command *cmd, FILE *fp);
 
 int fsverity_cmd_enable(const struct fsverity_command *cmd,
 			int argc, char *argv[]);
 int fsverity_cmd_measure(const struct fsverity_command *cmd,
 			 int argc, char *argv[]);
-int fsverity_cmd_sign(const struct fsverity_command *cmd,
-		      int argc, char *argv[]);
+int fsverity_cmd_sign(char *filename, const struct fsverity_hash_alg *hash_alg,
+		      u32 block_size, u8 *salt, u32 salt_size,
+		      const char *keyfile, const char *certfile,
+		      struct fsverity_signed_digest **retdigest,
+		      u8 **sig, u32 *sig_size);
 
 bool parse_block_size_option(const char *arg, u32 *size_ptr);
 u32 get_default_block_size(void);
diff --git a/fsverity.c b/fsverity.c
index 9a44df1..6246031 100644
--- a/fsverity.c
+++ b/fsverity.c
@@ -7,14 +7,141 @@
  * Written by Eric Biggers.
  */
 
+#include <fcntl.h>
 #include <limits.h>
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <getopt.h>
+#include <errno.h>
 
 #include "commands.h"
 #include "hash_algs.h"
 
+enum {
+	OPT_HASH_ALG,
+	OPT_BLOCK_SIZE,
+	OPT_SALT,
+	OPT_KEY,
+	OPT_CERT,
+};
+
+static const struct option longopts[] = {
+	{"hash-alg",	required_argument, NULL, OPT_HASH_ALG},
+	{"block-size",	required_argument, NULL, OPT_BLOCK_SIZE},
+	{"salt",	required_argument, NULL, OPT_SALT},
+	{"key",		required_argument, NULL, OPT_KEY},
+	{"cert",	required_argument, NULL, OPT_CERT},
+	{NULL, 0, NULL, 0}
+};
+
+static bool write_signature(const char *filename, const u8 *sig, u32 sig_size)
+{
+	struct filedes file;
+	bool ok;
+
+	if (!open_file(&file, filename, O_WRONLY|O_CREAT|O_TRUNC, 0644))
+		return false;
+	ok = full_write(&file, sig, sig_size);
+	ok &= filedes_close(&file);
+	return ok;
+}
+
+int wrap_cmd_sign(const struct fsverity_command *cmd, int argc, char *argv[])
+{
+	struct fsverity_signed_digest *digest = NULL;
+	u8 *sig = NULL;
+	u32 sig_size;
+	const struct fsverity_hash_alg *hash_alg = NULL;
+	u32 block_size = 0;
+	u8 *salt = NULL;
+	u32 salt_size = 0;
+	const char *keyfile = NULL;
+	const char *certfile = NULL;
+	int c, status;
+	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + 1];
+
+	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
+		switch (c) {
+		case OPT_HASH_ALG:
+			if (hash_alg != NULL) {
+				error_msg("--hash-alg can only be specified once");
+				goto out_usage;
+			}
+			hash_alg = find_hash_alg_by_name(optarg);
+			if (hash_alg == NULL)
+				goto out_usage;
+			break;
+		case OPT_BLOCK_SIZE:
+			if (!parse_block_size_option(optarg, &block_size))
+				goto out_usage;
+			break;
+		case OPT_SALT:
+			if (!parse_salt_option(optarg, &salt, &salt_size))
+				goto out_usage;
+			break;
+		case OPT_KEY:
+			if (keyfile != NULL) {
+				error_msg("--key can only be specified once");
+				goto out_usage;
+			}
+			keyfile = optarg;
+			break;
+		case OPT_CERT:
+			if (certfile != NULL) {
+				error_msg("--cert can only be specified once");
+				goto out_usage;
+			}
+			certfile = optarg;
+			break;
+		default:
+			goto out_usage;
+		}
+	}
+
+	if (keyfile == NULL) {
+		status = -EINVAL;
+		error_msg("Missing --key argument");
+		goto out_usage;
+	}
+
+	argv += optind;
+	argc -= optind;
+
+	if (hash_alg == NULL)
+		hash_alg = &fsverity_hash_algs[FS_VERITY_HASH_ALG_DEFAULT];
+
+	if (argc != 2)
+		goto out_usage;
+
+	status = fsverity_cmd_sign(argv[0], hash_alg, block_size, salt, salt_size,
+				   keyfile, certfile, &digest, &sig, &sig_size);
+	if (status == -EINVAL)
+		goto out_usage;
+	if (status != 0)
+		goto out;
+
+	if (!write_signature(argv[1], sig, sig_size)) {
+		status = -EIO;
+		goto out;
+	}
+
+	bin2hex(digest->digest, hash_alg->digest_size, digest_hex);
+	printf("Signed file '%s' (%s:%s)\n", argv[0], hash_alg->name,
+	       digest_hex);
+
+ out:
+	free(salt);
+	free(digest);
+	free(sig);
+	return status;
+
+ out_usage:
+	usage(cmd, stderr);
+	status = 2;
+	goto out;
+}
+
 static const struct fsverity_command {
 	const char *name;
 	int (*func)(const struct fsverity_command *cmd, int argc, char *argv[]);
@@ -38,7 +165,7 @@ static const struct fsverity_command {
 "    fsverity measure FILE...\n"
 	}, {
 		.name = "sign",
-		.func = fsverity_cmd_sign,
+		.func = wrap_cmd_sign,
 		.short_desc = "Sign a file for fs-verity",
 		.usage_str =
 "    fsverity sign FILE OUT_SIGFILE --key=KEYFILE\n"
-- 
2.24.1

