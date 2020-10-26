Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25937298C2B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 12:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773911AbgJZLkP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 07:40:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34266 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1773909AbgJZLkP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 07:40:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id i1so12057499wro.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Oct 2020 04:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mAtANtUp0obcgpmEInDlEpbjEpb4HbEL/pJhCR5pOoA=;
        b=s14Zjj8OUBRppozRbDx+alJe0v5Yl2Iy+6f3aBMiNmDGnFSmtBvMwjfCu1RvNc6a0f
         IfUftQAlU81Bz7xUNRyI7G1yU7vPYE/7+JWdeRkxzcBwM5iHh7fufKi4Fkcy2OcXR06P
         Qmdl2Glzoki+/oZ4RBGPJWN9//tJoyWcT2P10iUXebrUtOjTNe0FNv26fM3PokLmUhxf
         QB7ghGzy/kx9mXcqZlNPe6/jxqLK5qBEwYzlUikaqS0KZEc+bwOaBb/4Sr53qLmjKZ4x
         fSpHzQ1+fdQ4PfaVmsbJZSjR0w98jIc6gAGJHJQVTNl5VzPCVDiohkDCwQD0T8tFGIk3
         TI3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mAtANtUp0obcgpmEInDlEpbjEpb4HbEL/pJhCR5pOoA=;
        b=gKnxLi0in8b4PQO1OKt4TVGz4+O5C4vm9CgLHoeb5V2WmLj32fH9hrMzmaMFs63S5s
         JU+akIZEYWZdFBwe1iGm3dTol7Jirp0rHR+MJm4cBzVRbUGQiaC39ZZrbseVXBO7/ik3
         4rF705jhDI0dQXiCiqlpVJ6G3HkrTqicjycsioWWCF3Dr5TE6j2PWPWPM4fErtSH+oMk
         QVZgLWKsLE4RHHsQ64+NI04BATaMwK28mC+EHJ1aTCgsOCXB6DHA3kQa80wmhBZo8z0C
         kZk0TNwCMZSvyyPZzd421ev8Qvr1XMmUn8D+JokGinHSf7gjoUoftTXD1ybJkn6Le3N6
         dIhQ==
X-Gm-Message-State: AOAM532RoGkOiFU0/k5sVGGRywWArRZNivu7NpeQhH4M3suQhuWpXA5X
        7iosHQuHd2Uy1DEswSJx2WmdenAIg8+/4h0B
X-Google-Smtp-Source: ABdhPJwN2srV12ovrI/0lmugD6/euKsQFoxH2QMw5Alk0u8G9c6hdFTnxPgPXrlYZrKjvwbGaKnPGA==
X-Received: by 2002:a5d:4ccd:: with SMTP id c13mr17209765wrt.221.1603712411631;
        Mon, 26 Oct 2020 04:40:11 -0700 (PDT)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id h206sm21009307wmf.47.2020.10.26.04.40.10
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 04:40:10 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Subject: [fsverity-utils PATCH v2] Add digest sub command
Date:   Mon, 26 Oct 2020 11:40:07 +0000
Message-Id: <20201026114007.3218645-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201022172155.2994326-1-luca.boccassi@gmail.com>
References: <20201022172155.2994326-1-luca.boccassi@gmail.com>
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

 Makefile              |   3 +
 README.md             |   4 ++
 programs/cmd_digest.c | 146 ++++++++++++++++++++++++++++++++++++++++++
 programs/cmd_sign.c   |   8 ---
 programs/fsverity.c   |   8 +++
 programs/fsverity.h   |   4 ++
 programs/utils.c      |   8 +++
 programs/utils.h      |   1 +
 8 files changed, 174 insertions(+), 8 deletions(-)
 create mode 100644 programs/cmd_digest.c

diff --git a/Makefile b/Makefile
index 2a2e067..3fc1bec 100644
--- a/Makefile
+++ b/Makefile
@@ -127,6 +127,7 @@ ALL_PROG_HEADERS  := $(wildcard programs/*.h) $(COMMON_HEADERS)
 PROG_COMMON_SRC   := programs/utils.c
 PROG_COMMON_OBJ   := $(PROG_COMMON_SRC:.c=.o)
 FSVERITY_PROG_OBJ := $(PROG_COMMON_OBJ)		\
+		     programs/cmd_digest.o	\
 		     programs/cmd_enable.o	\
 		     programs/cmd_measure.o	\
 		     programs/cmd_sign.o	\
@@ -181,6 +182,8 @@ check:fsverity test_programs
 	$(RUN_FSVERITY) sign fsverity fsverity.sig --hash=sha512 \
 		--block-size=512 --salt=12345678 \
 		--key=testdata/key.pem --cert=testdata/cert.pem > /dev/null
+	$(RUN_FSVERITY) digest fsverity --hash=sha512 \
+		--block-size=512 --salt=12345678 > /dev/null
 	rm -f fsverity.sig
 	@echo "All tests passed!"
 
diff --git a/README.md b/README.md
index 669a243..f219cf7 100644
--- a/README.md
+++ b/README.md
@@ -112,6 +112,10 @@ the set of X.509 certificates that have been loaded into the
     fsverity enable file --signature=file.sig
     rm -f file.sig
     sha256sum file
+
+    # The digest to be signed can also be printed separately, hex
+    # encoded, in case the integrated signing cannot be used:
+    fsverity digest file --compact --for-builtin-sig | xxd -p -r | openssl smime -sign -in /dev/stdin ...
 ```
 
 By default, it's not required that verity files have a signature.
diff --git a/programs/cmd_digest.c b/programs/cmd_digest.c
new file mode 100644
index 0000000..b9a1945
--- /dev/null
+++ b/programs/cmd_digest.c
@@ -0,0 +1,146 @@
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
+	struct filedes file = { .fd = -1 };
+	u8 *salt = NULL;
+	struct libfsverity_merkle_tree_params tree_params = { .version = 1 };
+	struct libfsverity_digest *digest = NULL;
+	struct fsverity_signed_digest *d = NULL;
+	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + sizeof(struct fsverity_signed_digest) * 2 + 1];
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
+	if (argc != 1)
+		goto out_usage;
+
+	if (tree_params.hash_algorithm == 0)
+		tree_params.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
+
+	if (tree_params.block_size == 0)
+		tree_params.block_size = get_default_block_size();
+
+	if (!open_file(&file, argv[0], O_RDONLY, 0))
+		goto out_err;
+
+	if (!get_file_size(&file, &tree_params.file_size))
+		goto out_err;
+
+	if (libfsverity_compute_digest(&file, read_callback,
+				       &tree_params, &digest) != 0) {
+		error_msg("failed to compute digest");
+		goto out_err;
+	}
+
+	ASSERT(digest->digest_size <= FS_VERITY_MAX_DIGEST_SIZE);
+
+	/* The kernel expects more than the digest as the signed payload */
+	if (for_builtin_sig) {
+		d = xzalloc(sizeof(*d) + digest->digest_size);
+		if (!d)
+			goto out_err;
+		memcpy(d->magic, "FSVerity", 8);
+		d->digest_algorithm = cpu_to_le16(digest->digest_algorithm);
+		d->digest_size = cpu_to_le16(digest->digest_size);
+		memcpy(d->digest, digest->digest, digest->digest_size);
+
+		bin2hex((const u8 *)d, sizeof(*d) + digest->digest_size, digest_hex);
+	} else
+		bin2hex(digest->digest, digest->digest_size, digest_hex);
+
+	if (compact)
+		printf("%s", digest_hex);
+	else
+		printf("File '%s' (%s:%s)\n", argv[0],
+			   libfsverity_get_hash_name(tree_params.hash_algorithm),
+			   digest_hex);
+	status = 0;
+out:
+	filedes_close(&file);
+	free(salt);
+	free(digest);
+	free(d);
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
index 95f6964..7afd569 100644
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
+"    fsverity digest FILE\n"
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

