Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1003C1B8139
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgDXUzZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUzZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:25 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E6DC09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:25 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id v38so5391076qvf.6
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AbZYgz07N6vO6xz3gyMK/EEn+/KhMs9hFMqiAian2RU=;
        b=X54twxHN2HKuEEisDSJkVhcTgcggDB8zrs6U0WbREC1adp4WCqNx/UWbhzRx5Ert5G
         L63fxo6zUW2TCQ9wAjyX8dOMns4nl2ELeL8n9sGVEI2s5qUP+zC8C4LRUNrwz1XmrJL7
         1uFs3Mar5O9C9ImRispDJdfAmu2WjMYQnikcFcrHrkdywPh86KsEO1Jrg6KrdwU9otKi
         IEHXOA7zdDN7Lt6XjYHPZfjgSju2pmipsF8Ft82Y9NYYTTmzqLcB5cDGUjOImVYYhkh1
         9vd/hTP3e+HxU2gKgCC/r1LkBuQZCqwvkbmwyg0oPImPab6BPnQAM4R5utIMq6QWbJmm
         FrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AbZYgz07N6vO6xz3gyMK/EEn+/KhMs9hFMqiAian2RU=;
        b=YUCzI14KRZNtHuE5WOSVh2TttV7jfHK9jA45wY0S3Eu0FwRO4+pNswwEe7nwVxSXb8
         +1MOx+W3kj4gaqCokm2ignIKZ6UJJVBGCNLiV1c8/ZKeYa0zQ5xsQqEA/LV2I07rHUo1
         lxRjaAbaOTy3qfMTdfZhvy/yc1VXgQ2QUlm0cOHG9c8zYJZmRFef6PLQ6dw7E81JFvpm
         2bVwK/CgnhU7VmnKetJyiUpUEe6js2vvBorBFKhbKVsxKS15CIzM1kmIEKmqNpMs7Ma1
         XnKNsdghcuUQKpLxwU+XfPH9xnonsohxPAjvKPTTbnTbzJEhGdtxZ3r6XQZABg47ZBKO
         +uTA==
X-Gm-Message-State: AGi0PubbZcUfJjvwwWUErlAecqya73vgtR3UExMTplj2S4J3cr4LbQIj
        OVGhwCPTzjxIDhYinKN96Lu+2K2xRqU=
X-Google-Smtp-Source: APiQypJ3BqpQiozMXuO3o2Ma1jMTmjigkiXCCxeXg67unCqYyuMYFs0vKI63ebpaYqT9UPA1QmHi3g==
X-Received: by 2002:a0c:9aea:: with SMTP id k42mr11178884qvf.91.1587761724036;
        Fri, 24 Apr 2020 13:55:24 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id a194sm4620809qkb.21.2020.04.24.13.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:23 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 10/20] Change libfsverity_compute_digest() to take a read function
Date:   Fri, 24 Apr 2020 16:54:54 -0400
Message-Id: <20200424205504.2586682-11-Jes.Sorensen@gmail.com>
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

This changes the library to take a read_fn as callback and a pointer to
an opaque file descriptor. This allows us to provide a custome read function
for things like rpm which reads from an cpio archive instead of a file on
disk.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_sign.c    | 20 +++++++++++++++++++-
 libfsverity.h |  3 ++-
 libverity.c   | 39 +++++++--------------------------------
 3 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/cmd_sign.c b/cmd_sign.c
index e48e0aa..15d0937 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -12,6 +12,7 @@
 #include <limits.h>
 #include <stdlib.h>
 #include <string.h>
+#include <errno.h>
 
 #include "commands.h"
 #include "libfsverity.h"
@@ -45,6 +46,16 @@ static const struct option longopts[] = {
 	{NULL, 0, NULL, 0}
 };
 
+static int read_callback(void *opague, void *buf, size_t count)
+{
+	int retval = -EBADF;
+
+	if (full_read(opague, buf, count))
+		retval = 0;
+
+	return retval;
+}
+
 /* Sign a file for fs-verity by computing its measurement, then signing it. */
 int fsverity_cmd_sign(const struct fsverity_command *cmd,
 		      int argc, char *argv[])
@@ -59,6 +70,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	struct libfsverity_digest *digest = NULL;
 	struct libfsverity_merkle_tree_params params;
 	struct libfsverity_signature_params sig_params;
+	u64 file_size;
 	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + 1];
 	u8 *sig = NULL;
 	size_t sig_size;
@@ -131,6 +143,11 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	if (!open_file(&file, argv[0], O_RDONLY, 0))
 		goto out_err;
 
+	if (!get_file_size(&file, &file_size)) {
+		error_msg_errno("unable to get file size");
+		goto out_err;
+	}
+
 	memset(&params, 0, sizeof(struct libfsverity_merkle_tree_params));
 	params.version = 1;
 	params.hash_algorithm = hash_alg->hash_num;
@@ -138,7 +155,8 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	params.salt_size = salt_size;
 	params.salt = salt;
 
-	if (libfsverity_compute_digest(file.fd, &params, &digest))
+	if (libfsverity_compute_digest(&file, file_size, read_callback,
+				       &params, &digest))
 		goto out_err;
 
 	filedes_close(&file);
diff --git a/libfsverity.h b/libfsverity.h
index f6c4b13..ea36b8e 100644
--- a/libfsverity.h
+++ b/libfsverity.h
@@ -79,7 +79,8 @@ struct fsverity_hash_alg {
  * * digest_ret returns a pointer to the digest on success.
  */
 int
-libfsverity_compute_digest(int fd,
+libfsverity_compute_digest(void *fd, size_t file_size,
+			   int (*read_fn)(void *, void *buf, size_t count),
 			   const struct libfsverity_merkle_tree_params *params,
 			   struct libfsverity_digest **digest_ret);
 
diff --git a/libverity.c b/libverity.c
index e16306d..f82f2d6 100644
--- a/libverity.c
+++ b/libverity.c
@@ -50,30 +50,13 @@ static bool hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
 	return next->filled + hash->alg->digest_size > block_size;
 }
 
-static int full_read_fd(int fd, void *buf, size_t count)
-{
-	while (count) {
-		int n = read(fd, buf, min(count, INT_MAX));
-
-		if (n < 0) {
-			error_msg_errno("reading from file");
-			return n;
-		}
-		if (n == 0) {
-			error_msg("unexpected end-of-file");
-			return -ENODATA;
-		}
-		buf += n;
-		count -= n;
-	}
-	return 0;
-}
-
 /*
  * Compute the file's Merkle tree root hash using the given hash algorithm,
  * block size, and salt.
  */
-static bool compute_root_hash(int fd, u64 file_size,
+static bool compute_root_hash(void *fd,
+			      int (*read_fn)(void *, void *buf, size_t count),
+			      u64 file_size,
 			      struct hash_ctx *hash, u32 block_size,
 			      const u8 *salt, u32 salt_size, u8 *root_hash)
 {
@@ -111,7 +94,7 @@ static bool compute_root_hash(int fd, u64 file_size,
 	for (offset = 0; offset < file_size; offset += block_size) {
 		buffers[-1].filled = min(block_size, file_size - offset);
 
-		if (full_read_fd(fd, buffers[-1].data, buffers[-1].filled))
+		if (read_fn(fd, buffers[-1].data, buffers[-1].filled))
 			goto out;
 
 		level = -1;
@@ -145,7 +128,8 @@ out:
  * contains the Merkle tree properties including the root hash.
  */
 int
-libfsverity_compute_digest(int fd,
+libfsverity_compute_digest(void *fd, size_t file_size,
+			   int (*read_fn)(void *, void *buf, size_t count),
 			   const struct libfsverity_merkle_tree_params *params,
 			   struct libfsverity_digest **digest_ret)
 {
@@ -153,8 +137,6 @@ libfsverity_compute_digest(int fd,
 	struct libfsverity_digest *digest;
 	struct hash_ctx *hash;
 	struct fsverity_descriptor desc;
-	struct stat stbuf;
-	u64 file_size;
 	int i, retval = -EINVAL;
 
 	if (!digest_ret)
@@ -191,13 +173,6 @@ libfsverity_compute_digest(int fd,
 	digest->digest_size = cpu_to_le16(hash_alg->digest_size);
 	memset(digest->digest, 0, hash_alg->digest_size);
 
-	if (fstat(fd, &stbuf) != 0) {
-		error_msg_errno("can't stat input file");
-		retval = -EBADF;
-		goto error_out;
-	}
-	file_size = stbuf.st_size;
-
 	memset(&desc, 0, sizeof(desc));
 	desc.version = 1;
 	desc.hash_algorithm = params->hash_algorithm;
@@ -213,7 +188,7 @@ libfsverity_compute_digest(int fd,
 
 	/* Root hash of empty file is all 0's */
 	if (file_size != 0 &&
-	    !compute_root_hash(fd, file_size, hash, params->block_size,
+	    !compute_root_hash(fd, read_fn, file_size, hash, params->block_size,
 			       params->salt, params->salt_size,
 			       desc.root_hash)) {
 		retval = -EAGAIN;
-- 
2.25.3

