Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8770A1B8131
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgDXUzL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUzL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:11 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26B2C09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:10 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id n143so11676467qkn.8
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nx5wM1jHCr59FxTt41/wGF/CFTAQaSY0+ZYkuyUBmj8=;
        b=lzLAkZ+3kpztRSGpGgNP79WcR5o2ROZ4rEsiI4izuakm8X5zD+TLhh3c1kE4I8ybPV
         st1ejLpLFgSaGVqKxa3mw6K/DxJzaSoOMBn7Br8ZGepwPWUiHtA/6rjBGK9r8uYHgdie
         CJtLAsuRbCiCgPtkqZKdtVAURHUXEwedrEH9VAEca1BcbdDCBqm3PAT80gTsxp4vRToR
         VMpJME2rlQdN0KDDeCZqkObKbN/gw77+peUhxG0B+1Uj+8XTuVdSen1TmXXnCgctcQCE
         tHBUQRGMBaRP9D7Hmr5MDqpOejB8RFJJjpBFs05P8Nh0WqJqWsf4jLU7Y5YJBtF9kFvu
         o7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nx5wM1jHCr59FxTt41/wGF/CFTAQaSY0+ZYkuyUBmj8=;
        b=H/Fa82iuf9fd8MW1144ovlEggtWEvd8lRXzNGoihvSLA0Oqe7xSGcwTsUMWYwKRMgq
         3dGcFj/OKMoZkiY41eoSx2cK7FvUVLj3u/rwoAlLw0FjRcPk2iPjYM0S1wUc7BFle5SC
         qWpFlIzUylh1WkoCscuBrhOnQ6A90q19nIryjyftZsEtXxaDHvyq9Ap60K0712PWINxn
         pi2xrWFnHL8kLbghLCRNkpL2shLgfTilZaYotn+6AB6rlP6rSoi6qYYeNt/auvIrmSm0
         vNEQ/RJm8Gor6RVwitUfWgy4lsG40qvT0HKW24IRTgUPndJs7NV+4qw350sdgXfrtR21
         Y7SA==
X-Gm-Message-State: AGi0PubJcPl0r1pz2rel5i9C/x/Ti1fzbBhP1J1nGxs655pyRXS2Bzi5
        2A9ktK1jj14flArUG68pAImkJsoYut0=
X-Google-Smtp-Source: APiQypJVyb71ScBR5GvRKGinz+LR2lH7X+R4u/IAmcPJacKMkOZYm5u+aDSrlW5ovBYoXvt9zGL/1A==
X-Received: by 2002:a37:9ad0:: with SMTP id c199mr10310387qke.472.1587761709724;
        Fri, 24 Apr 2020 13:55:09 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id w42sm4786240qtj.63.2020.04.24.13.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:09 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 02/20] Change compute_file_measurement() to take a file descriptor as argument
Date:   Fri, 24 Apr 2020 16:54:46 -0400
Message-Id: <20200424205504.2586682-3-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
References: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

This preps the code for splitting the signing into the shared library

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_sign.c    | 48 +++++++++++++++++++++++++++++++++++++-----------
 fsverity.c    |  1 +
 libfsverity.h | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+), 11 deletions(-)
 create mode 100644 libfsverity.h

diff --git a/cmd_sign.c b/cmd_sign.c
index dcb37ce..dcc44f8 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -16,6 +16,8 @@
 #include <openssl/pkcs7.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/stat.h>
+#include <unistd.h>
 
 #include "commands.h"
 #include "fsverity_uapi.h"
@@ -382,11 +384,30 @@ static bool hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
 	return next->filled + hash->alg->digest_size > block_size;
 }
 
+static int full_read_fd(int fd, void *buf, size_t count)
+{
+	while (count) {
+		int n = read(fd, buf, min(count, INT_MAX));
+
+		if (n < 0) {
+			error_msg_errno("reading from file");
+			return n;
+		}
+		if (n == 0) {
+			error_msg("unexpected end-of-file");
+			return -ENODATA;
+		}
+		buf += n;
+		count -= n;
+	}
+	return 0;
+}
+
 /*
  * Compute the file's Merkle tree root hash using the given hash algorithm,
  * block size, and salt.
  */
-static bool compute_root_hash(struct filedes *file, u64 file_size,
+static bool compute_root_hash(int fd, u64 file_size,
 			      struct hash_ctx *hash, u32 block_size,
 			      const u8 *salt, u32 salt_size, u8 *root_hash)
 {
@@ -424,7 +445,7 @@ static bool compute_root_hash(struct filedes *file, u64 file_size,
 	for (offset = 0; offset < file_size; offset += block_size) {
 		buffers[-1].filled = min(block_size, file_size - offset);
 
-		if (!full_read(file, buffers[-1].data, buffers[-1].filled))
+		if (full_read_fd(fd, buffers[-1].data, buffers[-1].filled))
 			goto out;
 
 		level = -1;
@@ -457,22 +478,22 @@ out:
  * The fs-verity measurement is the hash of the fsverity_descriptor, which
  * contains the Merkle tree properties including the root hash.
  */
-static bool compute_file_measurement(const char *filename,
+static bool compute_file_measurement(int fd,
 				     const struct fsverity_hash_alg *hash_alg,
 				     u32 block_size, const u8 *salt,
 				     u32 salt_size, u8 *measurement)
 {
-	struct filedes file = { .fd = -1 };
 	struct hash_ctx *hash = hash_create(hash_alg);
 	u64 file_size;
 	struct fsverity_descriptor desc;
+	struct stat stbuf;
 	bool ok = false;
 
-	if (!open_file(&file, filename, O_RDONLY, 0))
-		goto out;
-
-	if (!get_file_size(&file, &file_size))
+	if (fstat(fd, &stbuf) != 0) {
+		error_msg_errno("can't stat input file");
 		goto out;
+	}
+	file_size = stbuf.st_size;
 
 	memset(&desc, 0, sizeof(desc));
 	desc.version = 1;
@@ -495,14 +516,13 @@ static bool compute_file_measurement(const char *filename,
 
 	/* Root hash of empty file is all 0's */
 	if (file_size != 0 &&
-	    !compute_root_hash(&file, file_size, hash, block_size, salt,
+	    !compute_root_hash(fd, file_size, hash, block_size, salt,
 			       salt_size, desc.root_hash))
 		goto out;
 
 	hash_full(hash, &desc, sizeof(desc), measurement);
 	ok = true;
 out:
-	filedes_close(&file);
 	hash_free(hash);
 	return ok;
 }
@@ -529,6 +549,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 		      int argc, char *argv[])
 {
 	const struct fsverity_hash_alg *hash_alg = NULL;
+	struct filedes file = { .fd = -1 };
 	u32 block_size = 0;
 	u8 *salt = NULL;
 	u32 salt_size = 0;
@@ -603,10 +624,15 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	digest->digest_algorithm = cpu_to_le16(hash_alg - fsverity_hash_algs);
 	digest->digest_size = cpu_to_le16(hash_alg->digest_size);
 
-	if (!compute_file_measurement(argv[0], hash_alg, block_size,
+	if (!open_file(&file, argv[0], O_RDONLY, 0))
+		goto out_err;
+
+	if (!compute_file_measurement(file.fd, hash_alg, block_size,
 				      salt, salt_size, digest->digest))
 		goto out_err;
 
+	filedes_close(&file);
+
 	if (!sign_data(digest, sizeof(*digest) + hash_alg->digest_size,
 		       keyfile, certfile, hash_alg, &sig, &sig_size))
 		goto out_err;
diff --git a/fsverity.c b/fsverity.c
index 9a44df1..c8fa1b5 100644
--- a/fsverity.c
+++ b/fsverity.c
@@ -14,6 +14,7 @@
 
 #include "commands.h"
 #include "hash_algs.h"
+#include "libfsverity.h"
 
 static const struct fsverity_command {
 	const char *name;
diff --git a/libfsverity.h b/libfsverity.h
new file mode 100644
index 0000000..ceebae1
--- /dev/null
+++ b/libfsverity.h
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * libfsverity API
+ *
+ * Copyright (C) 2018 Google LLC
+ * Copyright (C) 2020 Facebook
+ *
+ * Written by Eric Biggers and modified by Jes Sorensen.
+ */
+
+#ifndef _LIBFSVERITY_H
+#define _LIBFSVERITY_H
+
+#include <stddef.h>
+#include <stdint.h>
+
+#define FS_VERITY_HASH_ALG_SHA256       1
+#define FS_VERITY_HASH_ALG_SHA512       2
+
+struct libfsverity_merkle_tree_params {
+	uint16_t version;
+	uint16_t hash_algorithm;
+	uint32_t block_size;
+	uint32_t salt_size;
+	const uint8_t *salt;
+	uint64_t reserved[11];
+};
+
+struct libfsverity_digest {
+	uint16_t digest_algorithm;
+	uint16_t digest_size;
+	uint8_t digest[];
+};
+
+struct libfsverity_signature_params {
+	const char *keyfile;
+	const char *certfile;
+	uint64_t reserved[11];
+};
+
+#endif
-- 
2.25.3

