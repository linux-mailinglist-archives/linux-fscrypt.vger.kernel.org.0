Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51722963A3
	for <lists+linux-fscrypt@lfdr.de>; Thu, 22 Oct 2020 19:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506309AbgJVRWH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 22 Oct 2020 13:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505706AbgJVRWH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 22 Oct 2020 13:22:07 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09462C0613CE
        for <linux-fscrypt@vger.kernel.org>; Thu, 22 Oct 2020 10:22:07 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id c77so3009657wmd.4
        for <linux-fscrypt@vger.kernel.org>; Thu, 22 Oct 2020 10:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7fP6Gz1JCqJWPDvpCk7xI5k9Yak7qcpDcxHcWDvRZPA=;
        b=EhrUPEexH6rFk3LjCOyNgOFxipiEHRUsYq6fHfWz1fiqy+Bsvc3EqaUtgzKDvBfs+W
         FEbMUhUDV36EwfUVOIhtnb2vtFBrFvXOOwrU9ieH/fixZd1950TPNwDUtA+zvKNwnHys
         q43m4pBnUoXC0joNFracOLGsRtpWz2jVknXzvl/v8+HdnhNI4CertHSZVozNd3z+2ZuG
         4knmUb+KID/lAVNN0EIjStwOSenyW6qYBldzn0gPl9e9MEmMrRmuALvhpV9MP5rnrWHK
         ExuHsudVU8CH5JOfm3zs0r56Y419xFLmIz81nwia1dykbhbBzT3PTIttyuzBa42Sr9AS
         myvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7fP6Gz1JCqJWPDvpCk7xI5k9Yak7qcpDcxHcWDvRZPA=;
        b=uD0ZbYsl7oubHmVIBaEhnyhqRkdb/TciHs8niaeAmy7Eu0XIRCoAV15xrzmUEBDc+k
         2EQ9VOEtOHP5AKKBGS4zIEgmHxaUiO4TNyWzBAg6Z1qYSGJn2JZDdd/zixYLoiOtkIdP
         N9Y68Uy+kCI56qBdKXf8JNAcJEpkhcTAzwQPMMZxPiMPNyA3unJGxaJ9CzAR8qVldOYw
         j5/xbb5lFxqYCjZAfkCvFIuputPN2iGf6EQeYBEolNkKqt2fGVFzD2g5bkbMr+mCji0f
         v3230+2hnOh3K12vie1u0lf1RtHpbJFKjWA3ZLN2z1bxgVr/zZlFF0VAym2a2DScJUXY
         fnSw==
X-Gm-Message-State: AOAM533rGmOIzMJZoCMb1b4p8NYaKBSl3F44vJWIScsUACFiVb5n1qTK
        J3oajgxoT2rQjdiEtTy956Tpn5KRQ02hQw==
X-Google-Smtp-Source: ABdhPJxeSqR9BI8RcIdz7cGmoUGEL+gqd6ZbXjzc9AmZ5491WoGTAPbf3gWI6+JVvCbsbapixw82TQ==
X-Received: by 2002:a1c:49c2:: with SMTP id w185mr3529077wma.70.1603387325016;
        Thu, 22 Oct 2020 10:22:05 -0700 (PDT)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id r1sm5477832wro.18.2020.10.22.10.22.02
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 10:22:03 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Subject: [fsverity-utils PATCH] Add digest sub command
Date:   Thu, 22 Oct 2020 18:21:55 +0100
Message-Id: <20201022172155.2994326-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.20.1
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
 Makefile              |   3 +
 README.md             |   4 ++
 programs/cmd_digest.c | 137 ++++++++++++++++++++++++++++++++++++++++++
 programs/cmd_sign.c   |   8 ---
 programs/fsverity.c   |   8 +++
 programs/fsverity.h   |   4 ++
 programs/utils.c      |   8 +++
 programs/utils.h      |   1 +
 8 files changed, 165 insertions(+), 8 deletions(-)
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
index 669a243..997b699 100644
--- a/README.md
+++ b/README.md
@@ -112,6 +112,10 @@ the set of X.509 certificates that have been loaded into the
     fsverity enable file --signature=file.sig
     rm -f file.sig
     sha256sum file
+
+    # The digest to be signed can also be printed separately, hex
+    # encoded, in case the integrated signing cannot be used:
+    fsverity digest file --compact | xxd -p -r | openssl smime -sign -in /dev/stdin ...
 ```
 
 By default, it's not required that verity files have a signature.
diff --git a/programs/cmd_digest.c b/programs/cmd_digest.c
new file mode 100644
index 0000000..314cda7
--- /dev/null
+++ b/programs/cmd_digest.c
@@ -0,0 +1,137 @@
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
+};
+
+static const struct option longopts[] = {
+	{"hash-alg",	required_argument, NULL, OPT_HASH_ALG},
+	{"block-size",	required_argument, NULL, OPT_BLOCK_SIZE},
+	{"salt",	    required_argument, NULL, OPT_SALT},
+	{"compact",	    no_argument, 	   NULL, OPT_COMPACT},
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
+    bool compact = false;
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
+	d = xzalloc(sizeof(*d) + digest->digest_size);
+	if (!d)
+		goto out_err;
+	memcpy(d->magic, "FSVerity", 8);
+	d->digest_algorithm = cpu_to_le16(digest->digest_algorithm);
+	d->digest_size = cpu_to_le16(digest->digest_size);
+	memcpy(d->digest, digest->digest, digest->digest_size);
+
+	bin2hex((const u8 *)d, sizeof(*d) + digest->digest_size, digest_hex);
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
index 95f6964..3e089b8 100644
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
+"               [--compact]\n"
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

