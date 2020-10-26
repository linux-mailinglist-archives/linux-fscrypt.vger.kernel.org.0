Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7BD29951A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 19:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773048AbgJZSRh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 14:17:37 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37450 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1769849AbgJZSRh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 14:17:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id c16so13476809wmd.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Oct 2020 11:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5MYUQKX/e6XA5sdk2SgI86D7lF2Aha4Zubtt7huWAVk=;
        b=HFmubvvFNAzM2Jt/PyNlkCcSSmvcgWjv0ST16dKhBlTFO9Zu2bKwTkvftnBfTIPm+d
         9PNYeT8dpdAdalScu5OS0GzuKTfZ7SsJ5a7RBcdxsLnhkMGv6UaQMIaLSbFhM7qdzyQ3
         WP1YM3JEnNWBpXHORLaJLHJNbr2m0TsO8v1Sck45rh11XjfX6yHiUyvt66MCEaX12f5O
         1etBybg1qubQzBI6Lk7VasNTMM+/YAM0qgClvMfmEPCEtJ2nzE1e8vWCZrZa0fHcmbZi
         +MW2WuTdyBFD7N+89pMs8u6ZUNiG5q1xINCU/uh8KgYPijVLOLEi4c9xVLOMf81Ak1sS
         DFvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5MYUQKX/e6XA5sdk2SgI86D7lF2Aha4Zubtt7huWAVk=;
        b=kOPVZPsNp5Mhj8Q8AbJ4d3mbVUGGggB0FloRUYjodG5p8K00I8000DQobNPhCsRiCm
         BLDbmycjttCsYZVN3msPrO1/BbLNCakwpGueg2+lIFyRzIrsjSCkuM0zw4/foDIStamd
         ybajya41jjmGhMe7vt1IaeRHd47uPtcKG7aB5z3bVsV2AsWsRvbLFICTdwxWQzchs8JH
         8yWK8qS9Dr4EAENgAQ3iXSKmErwHGsRTUfDOeB6+McOboC6o2zfuiAo70xTe1i93rJqv
         19p/rbLnvjgFyxxbuS59Ufe7hRdG7motuinhW0nO9O6++8eXOrZwL6d6AUaX2GtJ1E2M
         ryBQ==
X-Gm-Message-State: AOAM532hEPTu8aNBWnXA5D0o9juTL5R/maaS6U9xkCfkAMt5P0noS1Rs
        y1vA4b0u7MIa4Tja6hO2NRt/cdc7LFGCnA==
X-Google-Smtp-Source: ABdhPJwpkXLulDMuSOBFEYbyOshoq69BawEBTdh1cbnQd+y+Kxux4hasdcZ5C1G3Z1X1Ycp24EFjrw==
X-Received: by 2002:a7b:c957:: with SMTP id i23mr17047606wml.155.1603736254435;
        Mon, 26 Oct 2020 11:17:34 -0700 (PDT)
Received: from localhost ([2a01:4b00:f419:6f00:7a8e:ed70:5c52:ea3])
        by smtp.gmail.com with ESMTPSA id x22sm25048870wmj.25.2020.10.26.11.17.33
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 11:17:33 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Subject: [fsverity-utils PATCH v4] Add digest sub command
Date:   Mon, 26 Oct 2020 18:17:29 +0000
Message-Id: <20201026181729.3322756-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201026181105.3322022-1-luca.boccassi@gmail.com>
References: <20201026181105.3322022-1-luca.boccassi@gmail.com>
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

 Makefile              |   3 +
 README.md             |   4 ++
 programs/cmd_digest.c | 148 ++++++++++++++++++++++++++++++++++++++++++
 programs/cmd_sign.c   |   8 ---
 programs/fsverity.c   |   8 +++
 programs/fsverity.h   |   4 ++
 programs/utils.c      |   8 +++
 programs/utils.h      |   1 +
 8 files changed, 176 insertions(+), 8 deletions(-)
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
index 0000000..d06e0d9
--- /dev/null
+++ b/programs/cmd_digest.c
@@ -0,0 +1,148 @@
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
+/* Compute a file's fs-verity measurement, then print it in hex format. */
+int fsverity_cmd_digest(const struct fsverity_command *cmd,
+		      int argc, char *argv[])
+{
+	u8 *salt = NULL;
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
+		struct filedes file = { .fd = -1 };
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
index 95f6964..c7c4f75 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -21,6 +21,14 @@ static const struct fsverity_command {
 	const char *usage_str;
 } fsverity_commands[] = {
 	{
+		.name = "digest",
+		.func = fsverity_cmd_digest,
+		.short_desc = "Compute and print hex-encoded fs-verity digest of a file, for offline signing",
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

