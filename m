Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E125B1B813B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgDXUz3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUz3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:29 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E29C09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:29 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id c23so8595487qtp.11
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vCscx6wPKburaGs6JzY5/THwL2ZHuiVAAqG0FRCUyyA=;
        b=nOOlwtpRXXI6KJTXakhDnqefpJdmRGHkmeB0cIzlYdEOjRQnoEKXyGM2m7R+sViNDR
         5rDdoHOVoi8w6RFJoZHXw8phQd3RUEn0vJRTiqFNZJtAFnmDJvRF0WOwPA+SvjE/0atv
         gxKURWpEhLe2wmwfs5XG2zOglIMdHlH59RrpBPRT8yraE3jOINzrhZBR3zoXlB+x8pKY
         mWeOlpCxGDiiBD1LRSOihYlKfr08+NYsQE8rW7gIyNY1ZUjTCWlg+e5I58E828v/89U1
         O23jrPFG3V/MvnxgDA537QWwjTo4JAVTK4126SnRDNfz3KSDh/Qttm+uCB+qH2PCBgI9
         d16g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vCscx6wPKburaGs6JzY5/THwL2ZHuiVAAqG0FRCUyyA=;
        b=SPkoBfhrG08hNGSn3S7oPwSvr1rvjBChyhjL4u9CuLWOqzQ+eZEf/CGvK7CSg2Z9C4
         ITzKZAv/x993C4rVpX+WR1h9Z3uxp+XtO8+eDIzcPphDPeGgfFt/fHyQcm1fsXFsxBlW
         J8DSCirgJFdMEp13ocot3PATXepIgaE/gacg6wo1eylxFl6/TNL/0NEP9oQuFTyVhiKi
         M/Q34lnzREwLnkcU29TWWfyvCcRdQgAG1O+SkF+Omcsruu6Ke6Vs5233blsoIfb+NDyf
         1uE+X7WMVcD1zbRS8YpHbps6+owV9i/Izg9awNyElfFFSGIRB8lGj0Z+7fcXf2eZ6XY/
         INZQ==
X-Gm-Message-State: AGi0PuYP0Mk/R/V2gQvdNQ51UPgPj2x3ZJ5/dxmvOyd0vAmuROcFxN9R
        btOo1S/li4/1KkC6xoMBPun+qXM3Sus=
X-Google-Smtp-Source: APiQypLHGACvCpZK5bOlZt7S2a7/JHn327O5t6S3v6OrOA3q5Fk//YVXN6xBxSYfja0SL6fxnQjOcg==
X-Received: by 2002:ac8:7413:: with SMTP id p19mr11456160qtq.28.1587761727305;
        Fri, 24 Apr 2020 13:55:27 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id o13sm4431774qke.77.2020.04.24.13.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:26 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 12/20] libfsverity: Remove dependencies on util.c
Date:   Fri, 24 Apr 2020 16:54:56 -0400
Message-Id: <20200424205504.2586682-13-Jes.Sorensen@gmail.com>
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

There were a ton of cross dependencies to util.c. This gets rid of all
the use of string function wrappers, u<x> data types, and various debug
functions. Useful independent macros and inline functions are moved to
helpers.h which may be included by both libfsverity and the fsverity
application.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 fsverity.c  |   1 +
 hash_algs.c |  47 ++++++++++-----
 hash_algs.h |   9 ++-
 helpers.h   |  43 ++++++++++++++
 libverity.c | 165 ++++++++++++++++++++++++++++++++--------------------
 util.c      |   1 +
 util.h      |  56 ------------------
 7 files changed, 184 insertions(+), 138 deletions(-)
 create mode 100644 helpers.h

diff --git a/fsverity.c b/fsverity.c
index f9df72e..a176ead 100644
--- a/fsverity.c
+++ b/fsverity.c
@@ -13,6 +13,7 @@
 #include <unistd.h>
 
 #include "commands.h"
+#include "helpers.h"
 #include "libfsverity.h"
 
 static const struct fsverity_command {
diff --git a/hash_algs.c b/hash_algs.c
index d9f70b4..3066d87 100644
--- a/hash_algs.c
+++ b/hash_algs.c
@@ -10,7 +10,9 @@
 #include <openssl/evp.h>
 #include <stdlib.h>
 #include <string.h>
+#include <assert.h>
 
+#include "helpers.h"
 #include "fsverity_uapi.h"
 #include "libfsverity.h"
 #include "hash_algs.h"
@@ -27,9 +29,12 @@ static void openssl_digest_init(struct hash_ctx *_ctx)
 {
 	struct openssl_hash_ctx *ctx = (void *)_ctx;
 
-	if (EVP_DigestInit_ex(ctx->md_ctx, ctx->md, NULL) != 1)
-		fatal_error("EVP_DigestInit_ex() failed for algorithm '%s'",
-			    ctx->base.alg->name);
+	if (EVP_DigestInit_ex(ctx->md_ctx, ctx->md, NULL) != 1) {
+		fprintf(stderr,
+			"%s: EVP_DigestInit_ex() failed for algorithm '%s'",
+			__func__, ctx->base.alg->name);
+		abort();
+	}
 }
 
 static void openssl_digest_update(struct hash_ctx *_ctx,
@@ -37,18 +42,24 @@ static void openssl_digest_update(struct hash_ctx *_ctx,
 {
 	struct openssl_hash_ctx *ctx = (void *)_ctx;
 
-	if (EVP_DigestUpdate(ctx->md_ctx, data, size) != 1)
-		fatal_error("EVP_DigestUpdate() failed for algorithm '%s'",
-			    ctx->base.alg->name);
+	if (EVP_DigestUpdate(ctx->md_ctx, data, size) != 1) {
+		fprintf(stderr,
+			"%s: EVP_DigestUpdate() failed for algorithm '%s'",
+			__func__, ctx->base.alg->name);
+		abort();
+	}
 }
 
-static void openssl_digest_final(struct hash_ctx *_ctx, u8 *digest)
+static void openssl_digest_final(struct hash_ctx *_ctx, uint8_t *digest)
 {
 	struct openssl_hash_ctx *ctx = (void *)_ctx;
 
-	if (EVP_DigestFinal_ex(ctx->md_ctx, digest, NULL) != 1)
-		fatal_error("EVP_DigestFinal_ex() failed for algorithm '%s'",
-			    ctx->base.alg->name);
+	if (EVP_DigestFinal_ex(ctx->md_ctx, digest, NULL) != 1) {
+		fprintf(stderr,
+			"%s: EVP_DigestFinal_ex() failed for algorithm '%s'",
+			__func__, ctx->base.alg->name);
+		abort();
+	}
 }
 
 static void openssl_digest_ctx_free(struct hash_ctx *_ctx)
@@ -69,7 +80,10 @@ openssl_digest_ctx_create(const struct fsverity_hash_alg *alg, const EVP_MD *md)
 {
 	struct openssl_hash_ctx *ctx;
 
-	ctx = xzalloc(sizeof(*ctx));
+	ctx = malloc(sizeof(*ctx));
+	if (!ctx)
+		goto out_of_memory;
+	memset(ctx, 0, sizeof(*ctx));
 	ctx->base.alg = alg;
 	ctx->base.init = openssl_digest_init;
 	ctx->base.update = openssl_digest_update;
@@ -82,12 +96,16 @@ openssl_digest_ctx_create(const struct fsverity_hash_alg *alg, const EVP_MD *md)
 	 */
 	ctx->md_ctx = EVP_MD_CTX_create();
 	if (!ctx->md_ctx)
-		fatal_error("out of memory");
+		goto out_of_memory;
 
 	ctx->md = md;
-	ASSERT(EVP_MD_size(md) == alg->digest_size);
+	assert(EVP_MD_size(md) == alg->digest_size);
 
 	return &ctx->base;
+
+ out_of_memory:
+	fprintf(stderr, "%s: out of memory", __func__);
+	abort();
 }
 
 static struct hash_ctx *create_sha256_ctx(const struct fsverity_hash_alg *alg)
@@ -143,7 +161,8 @@ libfsverity_find_hash_alg_by_num(unsigned int num)
 }
 
 /* ->init(), ->update(), and ->final() all in one step */
-void hash_full(struct hash_ctx *ctx, const void *data, size_t size, u8 *digest)
+void hash_full(struct hash_ctx *ctx, const void *data, size_t size,
+	       uint8_t *digest)
 {
 	hash_init(ctx);
 	hash_update(ctx, data, size);
diff --git a/hash_algs.h b/hash_algs.h
index 2c7269a..546a601 100644
--- a/hash_algs.h
+++ b/hash_algs.h
@@ -4,13 +4,11 @@
 
 #include <stdio.h>
 
-#include "util.h"
-
 struct hash_ctx {
 	const struct fsverity_hash_alg *alg;
 	void (*init)(struct hash_ctx *ctx);
 	void (*update)(struct hash_ctx *ctx, const void *data, size_t size);
-	void (*final)(struct hash_ctx *ctx, u8 *out);
+	void (*final)(struct hash_ctx *ctx, uint8_t *out);
 	void (*free)(struct hash_ctx *ctx);
 };
 
@@ -25,7 +23,7 @@ static inline void hash_update(struct hash_ctx *ctx,
 	ctx->update(ctx, data, size);
 }
 
-static inline void hash_final(struct hash_ctx *ctx, u8 *digest)
+static inline void hash_final(struct hash_ctx *ctx, uint8_t *digest)
 {
 	ctx->final(ctx, digest);
 }
@@ -36,6 +34,7 @@ static inline void hash_free(struct hash_ctx *ctx)
 		ctx->free(ctx);
 }
 
-void hash_full(struct hash_ctx *ctx, const void *data, size_t size, u8 *digest);
+void hash_full(struct hash_ctx *ctx, const void *data, size_t size,
+	       uint8_t *digest);
 
 #endif /* HASH_ALGS_H */
diff --git a/helpers.h b/helpers.h
new file mode 100644
index 0000000..35ce626
--- /dev/null
+++ b/helpers.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Helper macros and inline functions for fsverity and libfsverity
+ *
+ * Copyright (C) 2018 Google LLC
+ * Copyright (C) 2020 Facebook
+ */
+#ifndef HELPERS_H
+#define HELPERS_H
+
+#include <stdbool.h>
+
+#define ARRAY_SIZE(A)		(sizeof(A) / sizeof((A)[0]))
+
+#define min(a, b) ({			\
+	__typeof__(a) _a = (a);		\
+	__typeof__(b) _b = (b);		\
+	_a < _b ? _a : _b;		\
+})
+#define max(a, b) ({			\
+	__typeof__(a) _a = (a);		\
+	__typeof__(b) _b = (b);		\
+	_a > _b ? _a : _b;		\
+})
+
+static inline bool is_power_of_2(unsigned long n)
+{
+	return n != 0 && ((n & (n - 1)) == 0);
+}
+
+static inline int ilog2(unsigned long n)
+{
+	return (8 * sizeof(n) - 1) - __builtin_clzl(n);
+}
+
+#define roundup(x, y) ({		\
+	__typeof__(y) _y = (y);		\
+	(((x) + _y - 1) / _y) * _y;	\
+})
+
+#define DIV_ROUND_UP(n, d)	(((n) + (d) - 1) / (d))
+
+#endif
diff --git a/libverity.c b/libverity.c
index f82f2d6..975d86e 100644
--- a/libverity.c
+++ b/libverity.c
@@ -14,17 +14,47 @@
 #include <openssl/pkcs7.h>
 #include <string.h>
 #include <sys/stat.h>
-#include <unistd.h>
+#include <inttypes.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <assert.h>
 
 #include "libfsverity.h"
 #include "libfsverity_private.h"
 #include "hash_algs.h"
+#include "helpers.h"
 
 #define FS_VERITY_MAX_LEVELS	64
 
+#ifndef __force
+#  ifdef __CHECKER__
+#    define __force	__attribute__((force))
+#  else
+#    define __force
+#  endif
+#endif
+
+/* ========== Endianness conversion ========== */
+
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#  define cpu_to_le16(v)	((__force __le16)(uint16_t)(v))
+#  define le16_to_cpu(v)	((__force uint16_t)(__le16)(v))
+#  define cpu_to_le32(v)	((__force __le32)(uint32_t)(v))
+#  define le32_to_cpu(v)	((__force uint32_t)(__le32)(v))
+#  define cpu_to_le64(v)	((__force __le64)(uint64_t)(v))
+#  define le64_to_cpu(v)	((__force uint64_t)(__le64)(v))
+#else
+#  define cpu_to_le16(v)	((__force __le16)__builtin_bswap16(v))
+#  define le16_to_cpu(v)	(__builtin_bswap16((__force uint16_t)(v)))
+#  define cpu_to_le32(v)	((__force __le32)__builtin_bswap32(v))
+#  define le32_to_cpu(v)	(__builtin_bswap32((__force uint32_t)(v)))
+#  define cpu_to_le64(v)	((__force __le64)__builtin_bswap64(v))
+#  define le64_to_cpu(v)	(__builtin_bswap64((__force uint64_t)(v)))
+#endif
+
 struct block_buffer {
-	u32 filled;
-	u8 *data;
+	uint32_t filled;
+	uint8_t *data;
 };
 
 /*
@@ -32,7 +62,8 @@ struct block_buffer {
  * Returns true if the next level's block became full, else false.
  */
 static bool hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
-			   u32 block_size, const u8 *salt, u32 salt_size)
+			   uint32_t block_size, const uint8_t *salt,
+			   uint32_t salt_size)
 {
 	struct block_buffer *next = cur + 1;
 
@@ -56,28 +87,33 @@ static bool hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
  */
 static bool compute_root_hash(void *fd,
 			      int (*read_fn)(void *, void *buf, size_t count),
-			      u64 file_size,
-			      struct hash_ctx *hash, u32 block_size,
-			      const u8 *salt, u32 salt_size, u8 *root_hash)
+			      uint64_t file_size, struct hash_ctx *hash,
+			      uint32_t block_size, const uint8_t *salt,
+			      uint32_t salt_size, uint8_t *root_hash)
 {
-	const u32 hashes_per_block = block_size / hash->alg->digest_size;
-	const u32 padded_salt_size = roundup(salt_size, hash->alg->block_size);
-	u8 *padded_salt = xzalloc(padded_salt_size);
-	u64 blocks;
+	const uint32_t hashes_per_block = block_size / hash->alg->digest_size;
+	const uint32_t padded_salt_size = roundup(salt_size, hash->alg->block_size);
+	uint8_t *padded_salt = NULL;
+	uint64_t blocks;
 	int num_levels = 0;
 	int level;
 	struct block_buffer _buffers[1 + FS_VERITY_MAX_LEVELS + 1] = {};
 	struct block_buffer *buffers = &_buffers[1];
-	u64 offset;
+	uint64_t offset;
 	bool ok = false;
 
-	if (salt_size != 0)
+	if (salt_size != 0) {
+		padded_salt = malloc(padded_salt_size);
+		assert(padded_salt);
+		memset(padded_salt, 0, padded_salt_size);
+
 		memcpy(padded_salt, salt, salt_size);
+	}
 
 	/* Compute number of levels */
 	for (blocks = DIV_ROUND_UP(file_size, block_size); blocks > 1;
 	     blocks = DIV_ROUND_UP(blocks, hashes_per_block)) {
-		ASSERT(num_levels < FS_VERITY_MAX_LEVELS);
+		assert(num_levels < FS_VERITY_MAX_LEVELS);
 		num_levels++;
 	}
 
@@ -86,8 +122,10 @@ static bool compute_root_hash(void *fd,
 	 * Buffers 0 <= level < num_levels are for the actual tree levels.
 	 * Buffer 'num_levels' is for the root hash.
 	 */
-	for (level = -1; level < num_levels; level++)
-		buffers[level].data = xmalloc(block_size);
+	for (level = -1; level < num_levels; level++) {
+		buffers[level].data = malloc(block_size);
+		assert (buffers[level].data);
+	}
 	buffers[num_levels].data = root_hash;
 
 	/* Hash each data block, also hashing the tree blocks as they fill up */
@@ -101,7 +139,7 @@ static bool compute_root_hash(void *fd,
 		while (hash_one_block(hash, &buffers[level], block_size,
 				      padded_salt, padded_salt_size)) {
 			level++;
-			ASSERT(level < num_levels);
+			assert(level < num_levels);
 		}
 	}
 	/* Finish all nonempty pending tree blocks */
@@ -112,7 +150,7 @@ static bool compute_root_hash(void *fd,
 	}
 
 	/* Root hash was filled by the last call to hash_one_block() */
-	ASSERT(buffers[num_levels].filled == hash->alg->digest_size);
+	assert(buffers[num_levels].filled == hash->alg->digest_size);
 	ok = true;
 out:
 	for (level = -1; level < num_levels; level++)
@@ -146,8 +184,9 @@ libfsverity_compute_digest(void *fd, size_t file_size,
 	if (!is_power_of_2(params->block_size))
 		return -EINVAL;
 	if (params->salt_size > sizeof(desc.salt)) {
-		error_msg("Salt too long (got %u bytes; max is %zu bytes)",
-			  params->salt_size, sizeof(desc.salt));
+		fprintf(stderr,
+			"%s: Salt too long (got %u bytes; max is %zu bytes)",
+			__func__, params->salt_size, sizeof(desc.salt));
 		return -EINVAL;
 	}
 	if (params->salt_size && !params->salt)
@@ -206,22 +245,6 @@ libfsverity_compute_digest(void *fd, size_t file_size,
 	return retval;
 }
 
-static void __printf(1, 2) __cold
-error_msg_openssl(const char *format, ...)
-{
-	va_list va;
-
-	va_start(va, format);
-	do_error_msg(format, va, 0);
-	va_end(va);
-
-	if (ERR_peek_error() == 0)
-		return;
-
-	fprintf(stderr, "OpenSSL library errors:\n");
-	ERR_print_errors_fp(stderr);
-}
-
 /* Read a PEM PKCS#8 formatted private key */
 static EVP_PKEY *read_private_key(const char *keyfile)
 {
@@ -230,15 +253,16 @@ static EVP_PKEY *read_private_key(const char *keyfile)
 
 	bio = BIO_new_file(keyfile, "r");
 	if (!bio) {
-		error_msg_openssl("can't open '%s' for reading", keyfile);
+		fprintf(stderr, "%s: can't open '%s' for reading",
+			__func__, keyfile);
 		return NULL;
 	}
 
 	pkey = PEM_read_bio_PrivateKey(bio, NULL, NULL, NULL);
 	if (!pkey) {
-		error_msg_openssl("Failed to parse private key file '%s'.\n"
-				  "       Note: it must be in PEM PKCS#8 format.",
-				  keyfile);
+		fprintf(stderr, "%s: Failed to parse private key file '%s'.\n"
+			"       Note: it must be in PEM PKCS#8 format.",
+			__func__, keyfile);
 	}
 	BIO_free(bio);
 	return pkey;
@@ -252,14 +276,16 @@ static X509 *read_certificate(const char *certfile)
 
 	bio = BIO_new_file(certfile, "r");
 	if (!bio) {
-		error_msg_openssl("can't open '%s' for reading", certfile);
+		fprintf(stderr, "%s: can't open '%s' for reading",
+			__func__, certfile);
 		return NULL;
 	}
 	cert = PEM_read_bio_X509(bio, NULL, NULL, NULL);
 	if (!cert) {
-		error_msg_openssl("Failed to parse X.509 certificate file '%s'.\n"
-				  "       Note: it must be in PEM format.",
-				  certfile);
+		fprintf(stderr,
+			"%s: Failed to parse X.509 certificate file '%s'.\n"
+			"       Note: it must be in PEM format.",
+			__func__, certfile);
 	}
 	BIO_free(bio);
 	return cert;
@@ -269,13 +295,13 @@ static X509 *read_certificate(const char *certfile)
 
 static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
 		       EVP_PKEY *pkey, X509 *cert, const EVP_MD *md,
-		       u8 **sig_ret, size_t *sig_size_ret)
+		       uint8_t **sig_ret, size_t *sig_size_ret)
 {
 	CBB out, outer_seq, wrapped_seq, seq, digest_algos_set, digest_algo,
 		null, content_info, issuer_and_serial, signer_infos,
 		signer_info, sign_algo, signature;
 	EVP_MD_CTX md_ctx;
-	u8 *name_der = NULL, *sig = NULL, *pkcs7_data = NULL;
+	uint8_t *name_der = NULL, *sig = NULL, *pkcs7_data = NULL;
 	size_t pkcs7_data_len, sig_len;
 	int name_der_len, sig_nid;
 	bool ok = false;
@@ -290,19 +316,20 @@ static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
 
 	name_der_len = i2d_X509_NAME(X509_get_subject_name(cert), &name_der);
 	if (name_der_len < 0) {
-		error_msg_openssl("i2d_X509_NAME failed");
+		fprintf(stderr, "%s: i2d_X509_NAME failed", __func__);
 		goto out;
 	}
 
 	if (!EVP_DigestSignInit(&md_ctx, NULL, md, NULL, pkey)) {
-		error_msg_openssl("EVP_DigestSignInit failed");
+		fprintf(stderr, "%s: EVP_DigestSignInit failed", __func__);
 		goto out;
 	}
 
 	sig_len = EVP_PKEY_size(pkey);
-	sig = xmalloc(sig_len);
+	sig = malloc(sig_len);
+	assert(sig);
 	if (!EVP_DigestSign(&md_ctx, sig, &sig_len, data_to_sign, data_size)) {
-		error_msg_openssl("EVP_DigestSign failed");
+		fprintf(stderr, "%s: EVP_DigestSign failed", __func__);
 		goto out;
 	}
 
@@ -344,11 +371,14 @@ static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
 	    !CBB_add_asn1(&signer_info, &signature, CBS_ASN1_OCTETSTRING) ||
 	    !CBB_add_bytes(&signature, sig, sig_len) ||
 	    !CBB_finish(&out, &pkcs7_data, &pkcs7_data_len)) {
-		error_msg_openssl("failed to construct PKCS#7 data");
+		fprintf(stderr, "%s: failed to construct PKCS#7 data",
+			__func__);
 		goto out;
 	}
 
-	*sig_ret = xmemdup(pkcs7_data, pkcs7_data_len);
+	*sig_ret = malloc(pkcs7_data_len);
+	assert(*sig_ret);
+	memcpy(*sig_ret, pkcs7_data, pkcs7_data_len);
 	*sig_size_ret = pkcs7_data_len;
 	ok = true;
 out:
@@ -367,7 +397,7 @@ static BIO *new_mem_buf(const void *buf, size_t size)
 {
 	BIO *bio;
 
-	ASSERT(size <= INT_MAX);
+	assert(size <= INT_MAX);
 	/*
 	 * Prior to OpenSSL 1.1.0, BIO_new_mem_buf() took a non-const pointer,
 	 * despite still marking the resulting bio as read-only.  So cast away
@@ -375,13 +405,13 @@ static BIO *new_mem_buf(const void *buf, size_t size)
 	 */
 	bio = BIO_new_mem_buf((void *)buf, size);
 	if (!bio)
-		error_msg_openssl("out of memory");
+		fprintf(stderr, "%s: out of memory", __func__);
 	return bio;
 }
 
 static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
 		       EVP_PKEY *pkey, X509 *cert, const EVP_MD *md,
-		       u8 **sig_ret, size_t *sig_size_ret)
+		       uint8_t **sig_ret, size_t *sig_size_ret)
 {
 	/*
 	 * PKCS#7 signing flags:
@@ -403,8 +433,8 @@ static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
 	 */
 	int pkcs7_flags = PKCS7_BINARY | PKCS7_DETACHED | PKCS7_NOATTR |
 			  PKCS7_NOCERTS | PKCS7_PARTIAL;
-	u8 *sig;
-	u32 sig_size;
+	uint8_t *sig;
+	uint32_t sig_size;
 	BIO *bio = NULL;
 	PKCS7 *p7 = NULL;
 	bool ok = false;
@@ -415,34 +445,43 @@ static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
 
 	p7 = PKCS7_sign(NULL, NULL, NULL, bio, pkcs7_flags);
 	if (!p7) {
-		error_msg_openssl("failed to initialize PKCS#7 signature object");
+		fprintf(stderr,
+			"%s: failed to initialize PKCS#7 signature object",
+			__func__);
 		goto out;
 	}
 
 	if (!PKCS7_sign_add_signer(p7, cert, pkey, md, pkcs7_flags)) {
-		error_msg_openssl("failed to add signer to PKCS#7 signature object");
+		fprintf(stderr,
+			"%s: failed to add signer to PKCS#7 signature object",
+			__func__);
 		goto out;
 	}
 
 	if (PKCS7_final(p7, bio, pkcs7_flags) != 1) {
-		error_msg_openssl("failed to finalize PKCS#7 signature");
+		fprintf(stderr, "%s: failed to finalize PKCS#7 signature",
+			__func__);
 		goto out;
 	}
 
 	BIO_free(bio);
 	bio = BIO_new(BIO_s_mem());
 	if (!bio) {
-		error_msg_openssl("out of memory");
+		fprintf(stderr, "%s: out of memory", __func__);
 		goto out;
 	}
 
 	if (i2d_PKCS7_bio(bio, p7) != 1) {
-		error_msg_openssl("failed to DER-encode PKCS#7 signature object");
+		fprintf(stderr,
+			"%s: failed to DER-encode PKCS#7 signature object",
+			__func__);
 		goto out;
 	}
 
 	sig_size = BIO_get_mem_data(bio, &sig);
-	*sig_ret = xmemdup(sig, sig_size);
+	*sig_ret = malloc(sig_size);
+	assert(*sig_ret);
+	memcpy(*sig_ret, sig, sig_size);
 	*sig_size_ret = sig_size;
 	ok = true;
 out:
diff --git a/util.c b/util.c
index 586d2b0..0c4bf79 100644
--- a/util.c
+++ b/util.c
@@ -18,6 +18,7 @@
 #include <unistd.h>
 
 #include "util.h"
+#include "helpers.h"
 
 /* ========== Memory allocation ========== */
 
diff --git a/util.h b/util.h
index c4dc066..bd7ab9c 100644
--- a/util.h
+++ b/util.h
@@ -17,14 +17,6 @@ typedef uint16_t u16;
 typedef uint32_t u32;
 typedef uint64_t u64;
 
-#ifndef __force
-#  ifdef __CHECKER__
-#    define __force	__attribute__((force))
-#  else
-#    define __force
-#  endif
-#endif
-
 #ifndef __printf
 #  define __printf(fmt_idx, vargs_idx) \
 	__attribute__((format(printf, fmt_idx, vargs_idx)))
@@ -38,54 +30,6 @@ typedef uint64_t u64;
 #  define __cold	__attribute__((cold))
 #endif
 
-#define min(a, b) ({			\
-	__typeof__(a) _a = (a);		\
-	__typeof__(b) _b = (b);		\
-	_a < _b ? _a : _b;		\
-})
-#define max(a, b) ({			\
-	__typeof__(a) _a = (a);		\
-	__typeof__(b) _b = (b);		\
-	_a > _b ? _a : _b;		\
-})
-
-#define roundup(x, y) ({		\
-	__typeof__(y) _y = (y);		\
-	(((x) + _y - 1) / _y) * _y;	\
-})
-
-#define ARRAY_SIZE(A)		(sizeof(A) / sizeof((A)[0]))
-
-#define DIV_ROUND_UP(n, d)	(((n) + (d) - 1) / (d))
-
-static inline bool is_power_of_2(unsigned long n)
-{
-	return n != 0 && ((n & (n - 1)) == 0);
-}
-
-static inline int ilog2(unsigned long n)
-{
-	return (8 * sizeof(n) - 1) - __builtin_clzl(n);
-}
-
-/* ========== Endianness conversion ========== */
-
-#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
-#  define cpu_to_le16(v)	((__force __le16)(u16)(v))
-#  define le16_to_cpu(v)	((__force u16)(__le16)(v))
-#  define cpu_to_le32(v)	((__force __le32)(u32)(v))
-#  define le32_to_cpu(v)	((__force u32)(__le32)(v))
-#  define cpu_to_le64(v)	((__force __le64)(u64)(v))
-#  define le64_to_cpu(v)	((__force u64)(__le64)(v))
-#else
-#  define cpu_to_le16(v)	((__force __le16)__builtin_bswap16(v))
-#  define le16_to_cpu(v)	(__builtin_bswap16((__force u16)(v)))
-#  define cpu_to_le32(v)	((__force __le32)__builtin_bswap32(v))
-#  define le32_to_cpu(v)	(__builtin_bswap32((__force u32)(v)))
-#  define cpu_to_le64(v)	((__force __le64)__builtin_bswap64(v))
-#  define le64_to_cpu(v)	(__builtin_bswap64((__force u64)(v)))
-#endif
-
 /* ========== Memory allocation ========== */
 
 void *xmalloc(size_t size);
-- 
2.25.3

