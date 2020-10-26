Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B597D2996AA
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 20:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783857AbgJZTS4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 15:18:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36772 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1773370AbgJZTS4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 15:18:56 -0400
Received: by mail-wm1-f68.google.com with SMTP id e2so13657945wme.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Oct 2020 12:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zE33YAaExqxT+iGv+RZ8XYwrHYsN9QieWVrpspqmlOw=;
        b=SxbHadvt34otbZPfYExkS5lRYi7HIhWP2Qbh1oHXNQ6r1I4IJfryJCr4r3m2eA5VQa
         dc476OeHOCLB1Hlz3uLvZcC5uie57bm7pb+en8PcvJUhsKyGk1KP+lEk3PYzi7I4IU8F
         9/1Sq1iVxTZn2T91JXRWY9/M0mU1O7ab599UFcnFP+pfYRXfQOYUsGc4EvQNxAqrg/ds
         Scm+hOLy+uQlA4DkE7H6q/V/TWsvnZLpbI2a8YWG+8HREvERf1puJAJzSIOIGOZEMMlA
         7FxXCPfpN6orYKyvNRprEYDUnfeOrydGqM6fFuXPMjj4W6911JLQYwyStHBAX3Y9stF2
         DJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zE33YAaExqxT+iGv+RZ8XYwrHYsN9QieWVrpspqmlOw=;
        b=H1B949iQuMZX43Pa52IxeO9zSES7FzkMnLiiKX6tUE+fKYfkPZAIrZCDn3whcBUZc2
         anr+YhYAv3QGHT69Km3P/XkhTeTPKv9VtBjsHLa4tQTT+ZqF8vT3H9so7uxzUSZZfNzq
         /ke/TQGXlSSdReOiQUHf21UsABbiY5WoZHaSAtOPYYaPCe/ntAq1Znj1bnAUEVVRMTGF
         mwLEvBQReM/nHRp+6oJ5ICbkYSr1rCjueIma2unJo7sMkCtXpPx275/AFth/idBelIg0
         eBJN9yfXT9ApFLWcd02llVBu8N13HTthVBhQbdZ/2v1UWCq4QnYm5Sw+s7jl9jnMhxAn
         cWgg==
X-Gm-Message-State: AOAM533k2/q55lLSi8amkAh5NSmt/NSg99daE0zZGZZNnJxSHDNPQFns
        Z6qMRmTqOrEUUH/JFe9BQpG7REgKyDi+0A==
X-Google-Smtp-Source: ABdhPJyHNyIJs+EPo4UdGmROzzsLWHZJg4fZJ1ATKO7MPfxGOkc2fMlyuM0YCLOoZKo5mqczAV0foQ==
X-Received: by 2002:a7b:c408:: with SMTP id k8mr17386004wmi.68.1603739930642;
        Mon, 26 Oct 2020 12:18:50 -0700 (PDT)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id b18sm2357592wmj.41.2020.10.26.12.18.49
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 12:18:49 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Subject: [fsverity-utils PATCH v5] Add digest sub command
Date:   Mon, 26 Oct 2020 19:18:39 +0000
Message-Id: <20201026191839.3329948-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201026181729.3322756-1-luca.boccassi@gmail.com>
References: <20201026181729.3322756-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Luca Boccassi <luca.boccassi@microsoft.com>

Add a digest sub command that prints a hex-encoded digest of
a file, ready to be signed offline (ie: includes the full
data that is expected by the kernel - magic string, digest
algorithm and size).

Useful in case the integrated signing mechanism with local cert/key
cannot be used.

Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
---
v2: add --for-builtin-sig and default to printing only the digest,
    without the extra values the kernel expects
v3: change output to match the measure command
    support multiple files as input
v4: fix cleanup issue introduced in v3
v5: Adjust comments to mention multi-file support in input
    Do not print the hash algo with --for-builtin-sig
    Close file handle on error

 Makefile              |   3 +
 README.md             |   4 ++
 programs/cmd_digest.c | 151 ++++++++++++++++++++++++++++++++++++++++++
 programs/cmd_sign.c   |   8 ---
 programs/fsverity.c   |   8 +++
 programs/fsverity.h   |   4 ++
 programs/utils.c      |   8 +++
 programs/utils.h      |   1 +
 8 files changed, 179 insertions(+), 8 deletions(-)
 create mode 100644 programs/cmd_digest.c

diff --git a/Makefile b/Makefile
index b3d5041..6c6c8c9 100644
--- a/Makefile
+++ b/Makefile
@@ -150,6 +150,7 @@ ALL_PROG_HEADERS  := $(wildcard programs/*.h) $(COMMON_HEADERS)
 PROG_COMMON_SRC   := programs/utils.c
 PROG_COMMON_OBJ   := $(PROG_COMMON_SRC:.c=.o)
 FSVERITY_PROG_OBJ := $(PROG_COMMON_OBJ)		\
+		     programs/cmd_digest.o	\
 		     programs/cmd_enable.o	\
 		     programs/cmd_measure.o	\
 		     programs/cmd_sign.o	\
@@ -204,6 +205,8 @@ check:fsverity test_programs
 	$(RUN_FSVERITY) sign fsverity fsverity.sig --hash=sha512 \
 		--block-size=512 --salt=12345678 \
 		--key=testdata/key.pem --cert=testdata/cert.pem > /dev/null
+	$(RUN_FSVERITY) digest fsverity --hash=sha512 \
+		--block-size=512 --salt=12345678 > /dev/null
 	rm -f fsverity.sig
 	@echo "All tests passed!"
 
diff --git a/README.md b/README.md
index 669a243..36a52e9 100644
--- a/README.md
+++ b/README.md
@@ -112,6 +112,10 @@ the set of X.509 certificates that have been loaded into the
     fsverity enable file --signature=file.sig
     rm -f file.sig
     sha256sum file
+
+    # The digest to be signed can also be printed separately, hex
+    # encoded, in case the integrated signing cannot be used:
+    fsverity digest file --compact --for-builtin-sig | tr -d '\n' | xxd -p -r | openssl smime -sign -in /dev/stdin ...
 ```
 
 By default, it's not required that verity files have a signature.
diff --git a/programs/cmd_digest.c b/programs/cmd_digest.c
new file mode 100644
index 0000000..88843d1
--- /dev/null
+++ b/programs/cmd_digest.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: MIT
+/*
+ * The 'fsverity digest' command
+ *
+ * Copyright 2020 Microsoft
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
+ */
+
+#include "fsverity.h"
+
+#include <fcntl.h>
+#include <getopt.h>
+
+enum {
+	OPT_HASH_ALG,
+	OPT_BLOCK_SIZE,
+	OPT_SALT,
+	OPT_COMPACT,
+	OPT_FOR_BUILTIN_SIG,
+};
+
+static const struct option longopts[] = {
+	{"hash-alg",		required_argument, NULL, OPT_HASH_ALG},
+	{"block-size",		required_argument, NULL, OPT_BLOCK_SIZE},
+	{"salt",		required_argument, NULL, OPT_SALT},
+	{"compact",		no_argument, 	   NULL, OPT_COMPACT},
+	{"for-builtin-sig",	no_argument, 	   NULL, OPT_FOR_BUILTIN_SIG},
+	{NULL, 0, NULL, 0}
+};
+
+struct fsverity_signed_digest {
+	char magic[8];			/* must be "FSVerity" */
+	__le16 digest_algorithm;
+	__le16 digest_size;
+	__u8 digest[];
+};
+
+/* Compute the fs-verity measurement of the given file(s), for offline signing. */
+int fsverity_cmd_digest(const struct fsverity_command *cmd,
+		      int argc, char *argv[])
+{
+	u8 *salt = NULL;
+	struct filedes file = { .fd = -1 };
+	struct libfsverity_merkle_tree_params tree_params = { .version = 1 };
+	bool compact = false, for_builtin_sig = false;
+	int status;
+	int c;
+
+	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
+		switch (c) {
+		case OPT_HASH_ALG:
+			if (!parse_hash_alg_option(optarg,
+						   &tree_params.hash_algorithm))
+				goto out_usage;
+			break;
+		case OPT_BLOCK_SIZE:
+			if (!parse_block_size_option(optarg,
+						     &tree_params.block_size))
+				goto out_usage;
+			break;
+		case OPT_SALT:
+			if (!parse_salt_option(optarg, &salt,
+					       &tree_params.salt_size))
+				goto out_usage;
+			tree_params.salt = salt;
+			break;
+		case OPT_COMPACT:
+			compact = true;
+			break;
+		case OPT_FOR_BUILTIN_SIG:
+			for_builtin_sig = true;
+			break;
+		default:
+			goto out_usage;
+		}
+	}
+
+	argv += optind;
+	argc -= optind;
+
+	if (argc < 1)
+		goto out_usage;
+
+	if (tree_params.hash_algorithm == 0)
+		tree_params.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
+
+	if (tree_params.block_size == 0)
+		tree_params.block_size = get_default_block_size();
+
+	for (int i = 0; i < argc; i++) {
+		struct fsverity_signed_digest *d = NULL;
+		struct libfsverity_digest *digest = NULL;
+		char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + sizeof(struct fsverity_signed_digest) * 2 + 1];
+
+		if (!open_file(&file, argv[i], O_RDONLY, 0))
+			goto out_err;
+
+		if (!get_file_size(&file, &tree_params.file_size))
+			goto out_err;
+
+		if (libfsverity_compute_digest(&file, read_callback,
+						&tree_params, &digest) != 0) {
+			error_msg("failed to compute digest");
+			goto out_err;
+		}
+
+		ASSERT(digest->digest_size <= FS_VERITY_MAX_DIGEST_SIZE);
+
+		/* The kernel expects more than the digest as the signed payload */
+		if (for_builtin_sig) {
+			d = xzalloc(sizeof(*d) + digest->digest_size);
+			memcpy(d->magic, "FSVerity", 8);
+			d->digest_algorithm = cpu_to_le16(digest->digest_algorithm);
+			d->digest_size = cpu_to_le16(digest->digest_size);
+			memcpy(d->digest, digest->digest, digest->digest_size);
+
+			bin2hex((const u8 *)d, sizeof(*d) + digest->digest_size, digest_hex);
+		} else
+			bin2hex(digest->digest, digest->digest_size, digest_hex);
+
+		if (compact)
+			printf("%s\n", digest_hex);
+		else if (for_builtin_sig)
+			printf("%s %s\n", digest_hex, argv[i]);
+		else
+			printf("%s:%s %s\n",
+				libfsverity_get_hash_name(tree_params.hash_algorithm),
+				digest_hex, argv[i]);
+
+		filedes_close(&file);
+		free(digest);
+		free(d);
+	}
+	status = 0;
+out:
+	free(salt);
+	return status;
+
+out_err:
+	filedes_close(&file);
+	status = 1;
+	goto out;
+
+out_usage:
+	usage(cmd, stderr);
+	status = 2;
+	goto out;
+}
diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
index e1bbfd6..580e4df 100644
--- a/programs/cmd_sign.c
+++ b/programs/cmd_sign.c
@@ -43,14 +43,6 @@ static const struct option longopts[] = {
 	{NULL, 0, NULL, 0}
 };
 
-static int read_callback(void *file, void *buf, size_t count)
-{
-	errno = 0;
-	if (!full_read(file, buf, count))
-		return errno ? -errno : -EIO;
-	return 0;
-}
-
 /* Sign a file for fs-verity by computing its measurement, then signing it. */
 int fsverity_cmd_sign(const struct fsverity_command *cmd,
 		      int argc, char *argv[])
diff --git a/programs/fsverity.c b/programs/fsverity.c
index 95f6964..0f9da42 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -21,6 +21,14 @@ static const struct fsverity_command {
 	const char *usage_str;
 } fsverity_commands[] = {
 	{
+		.name = "digest",
+		.func = fsverity_cmd_digest,
+		.short_desc = "Compute the fs-verity measurement of the given file(s), for offline signing",
+		.usage_str =
+"    fsverity digest FILE...\n"
+"               [--hash-alg=HASH_ALG] [--block-size=BLOCK_SIZE] [--salt=SALT]\n"
+"               [--compact] [--for-builtin-sig]\n"
+	}, {
 		.name = "enable",
 		.func = fsverity_cmd_enable,
 		.short_desc = "Enable fs-verity on a file",
diff --git a/programs/fsverity.h b/programs/fsverity.h
index fd9bc4a..669fef2 100644
--- a/programs/fsverity.h
+++ b/programs/fsverity.h
@@ -25,6 +25,10 @@
 
 struct fsverity_command;
 
+/* cmd_digest.c */
+int fsverity_cmd_digest(const struct fsverity_command *cmd,
+			int argc, char *argv[]);
+
 /* cmd_enable.c */
 int fsverity_cmd_enable(const struct fsverity_command *cmd,
 			int argc, char *argv[]);
diff --git a/programs/utils.c b/programs/utils.c
index 0aca98d..facccda 100644
--- a/programs/utils.c
+++ b/programs/utils.c
@@ -175,6 +175,14 @@ bool filedes_close(struct filedes *file)
 	return res == 0;
 }
 
+int read_callback(void *file, void *buf, size_t count)
+{
+	errno = 0;
+	if (!full_read(file, buf, count))
+		return errno ? -errno : -EIO;
+	return 0;
+}
+
 /* ========== String utilities ========== */
 
 static int hex2bin_char(char c)
diff --git a/programs/utils.h b/programs/utils.h
index 6968708..ab5005f 100644
--- a/programs/utils.h
+++ b/programs/utils.h
@@ -43,6 +43,7 @@ bool get_file_size(struct filedes *file, u64 *size_ret);
 bool full_read(struct filedes *file, void *buf, size_t count);
 bool full_write(struct filedes *file, const void *buf, size_t count);
 bool filedes_close(struct filedes *file);
+int read_callback(void *file, void *buf, size_t count);
 
 bool hex2bin(const char *hex, u8 *bin, size_t bin_len);
 void bin2hex(const u8 *bin, size_t bin_len, char *hex);
-- 
2.20.1

