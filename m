Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D26EE183BAA
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 22:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgCLVsN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 17:48:13 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39633 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgCLVsN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 17:48:13 -0400
Received: by mail-qk1-f195.google.com with SMTP id e16so8997614qkl.6
        for <linux-fscrypt@vger.kernel.org>; Thu, 12 Mar 2020 14:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yTz/zrKC5DUn7VmN5TQnFzT4to91FgezOCmUOZJeHkg=;
        b=FdRX3T7WEDOAohTclktdLNxwzM/s12LLVWFlx9sHEO33WieLJNW5aLXPGsBjTV7vkw
         atYB47+/c9ADrIQxk3DbTTV99ZNVGePSaFHhHvOvsSBceaNJkwCUZKbp5iRreZ4ZATg7
         dakB2NGXQvzwKhCNADLzCzcIG4wn6ZM6fm4dcPGsYuOVXUQ0ctMKGr0KltH1rsQ3S3xI
         Mz7BzHu5Cflv5jZNHQb6woSLVENtt0u2zVJPFgtxGnO/mBJa/sZ4LXXpu1GnxCxiud0x
         t7JoKjWc9bRRLsvK84dhHH7d9AZPBGKOMWwqtsQtby0aYjagC8jU1kWDfvEV7BV0xIcT
         IvZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yTz/zrKC5DUn7VmN5TQnFzT4to91FgezOCmUOZJeHkg=;
        b=nHYS6nNlF+/2rCEomKEoYtMGRxYH9ZBKLlqOqiEm0sjh8zJ/h6OGDO2glZBl6kn3Jy
         vCB/d6LECTvwbnTgaG7JICXtJrFpYVptS9al0BFqktk37p5EF8xHBprjft781Wp+6gtH
         d1UCmvjjF4f6tDoGtdJuwxh6LikC564uS4ETpEtgG4Ry/aXe+BGoNouM/+8GRlNgnloZ
         oakNGqkyGorMj69cya3KOzGDNUqSp5j4yCvF9j7UKyjti86etFJbrmvIYj9XC6dtj3T8
         3weSwJg4bSK2TSTDlbK0zlo+LHNd86zG+o5pRsdISL5vkTgt3aYDJ45tJo3jCNzU+UjU
         d6VQ==
X-Gm-Message-State: ANhLgQ2jBCTXv6AumV6ussFpnUYhI8xXd7WV7uYmyd/V1XJ/aLGheyR7
        eN1p90mWx8XmmTNWneyewYn4rola
X-Google-Smtp-Source: ADFU+vsceMzPrrq02hbB6+yzo8+ty3BKj99h0WQI78wC4UhQXYdoef1YiNp6staE45Wn7vUC53G4mQ==
X-Received: by 2002:a05:620a:12a3:: with SMTP id x3mr10303648qki.367.1584049691536;
        Thu, 12 Mar 2020 14:48:11 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::fa82])
        by smtp.gmail.com with ESMTPSA id x1sm27773530qkf.38.2020.03.12.14.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 14:48:10 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 2/9] Change compute_file_measurement() to take a file descriptor as argument
Date:   Thu, 12 Mar 2020 17:47:51 -0400
Message-Id: <20200312214758.343212-3-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
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
2.24.1

