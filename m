Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B500183BAC
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 22:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgCLVsV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 17:48:21 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42028 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgCLVsU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 17:48:20 -0400
Received: by mail-qk1-f195.google.com with SMTP id e11so8988733qkg.9
        for <linux-fscrypt@vger.kernel.org>; Thu, 12 Mar 2020 14:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/1zpd8nL3AVJxNtJCcbQWyKUJc4t+uMhNqfQ81NWrRA=;
        b=O2XoH49WETweRIavuk9m9Q2GblcWASLsYUbaFzj2FyYGa6M98QPtSDxYVcsHLiNZrF
         jQtrKQiFvFZKVRCfKNABrhEVlRzVcyX2TrnWDY4SGsoR+SiS0lBF1jRqYNhsg8fPk9Tr
         sYM9AEWxRzN9KIhcUn4TG6wIzagz+42avRVQ0fRzn8wmlbxBaFeN0y+BV7dTASwYjFvR
         tVQo+Asf67vrslGxQ9g3jTT57l22jf2sTisgTU/EJu6iELT+tvkRu3VtrlT2mLLiyCO0
         iSueeeHal4DGrTeDQKVw9CnjebttUmeGtRAv3z98ijFwazVpfGOpdWLqf0/fyVOVAwTx
         ampA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/1zpd8nL3AVJxNtJCcbQWyKUJc4t+uMhNqfQ81NWrRA=;
        b=uOH6cBhDmXXgTuvbyUipTMAruEFX4BPBodm6JJjbAA7XItucuvoD6U24yhRdjA0WCf
         gtny8Qd47I+iJjyLuv3tB8IHRfTfN2RjI+TRy3S/gX1K7WOre+OQGashaXnDvbH2HmRI
         99Z63Y4kHTwCI3i9RW0zUcQ7tF5YozPHWdeGvAgFQqeclOgdSZNTZp55gMVLx8uiradY
         ukgsHWDMBmWYEEGj5ONGs4pI+nxhjakI+Te3AXmDHZypprM+sz4sHKISwywk9nAyPIWY
         cNkRFMcwh9akA2xWuFOyOGPed02RSG0HFQ3ghGlK+4RCY+FNbVTygnfr4ZWOpXAlQeKd
         JZvg==
X-Gm-Message-State: ANhLgQ2i/aggEJgNIunIvCNRKhL6jyNwyOJ7DpB5HxF1nVWpFia8SVnr
        55/BT5FWURryxScbSnDecN499F3O
X-Google-Smtp-Source: ADFU+vun/hhqTuEsnCWCPFCin+R/nkLllQUskbGmMv5tHsRcBL2QaMhdlpMOTgbpdV0iMXpseQKwOw==
X-Received: by 2002:a37:6807:: with SMTP id d7mr9938554qkc.112.1584049698904;
        Thu, 12 Mar 2020 14:48:18 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::fa82])
        by smtp.gmail.com with ESMTPSA id b145sm7637728qkg.52.2020.03.12.14.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 14:48:18 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 4/9] Move hash algorithm code to shared library
Date:   Thu, 12 Mar 2020 17:47:53 -0400
Message-Id: <20200312214758.343212-5-Jes.Sorensen@gmail.com>
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

Reimplement show_all_hash_algs() to not rely on direct access to the list,
and add the algorithm number to the struct, so the user can find it easily.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 Makefile      |  6 +++---
 cmd_enable.c  | 11 ++++++++---
 cmd_measure.c |  4 ++--
 cmd_sign.c    | 18 ++++++++++++------
 fsverity.c    | 15 ++++++++++++++-
 hash_algs.c   | 26 +++++++-------------------
 hash_algs.h   | 27 ---------------------------
 libfsverity.h | 22 ++++++++++++++++++++++
 util.h        |  2 ++
 9 files changed, 70 insertions(+), 61 deletions(-)

diff --git a/Makefile b/Makefile
index bb85896..966afa0 100644
--- a/Makefile
+++ b/Makefile
@@ -6,9 +6,9 @@ LDLIBS := -lcrypto
 DESTDIR := /usr/local
 LIBDIR := /usr/lib64
 SRC := $(wildcard *.c)
-OBJ := fsverity.o hash_algs.o cmd_enable.o cmd_measure.o cmd_sign.o util.o
-SSRC := libverity.c
-SOBJ := libverity.so
+OBJ := fsverity.o cmd_enable.o cmd_measure.o cmd_sign.o util.o
+SSRC := libverity.c hash_algs.c
+SOBJ := libverity.so hash_algs.so
 HDRS := $(wildcard *.h)
 
 all:$(EXE)
diff --git a/cmd_enable.c b/cmd_enable.c
index 1646299..1bed3ef 100644
--- a/cmd_enable.c
+++ b/cmd_enable.c
@@ -16,7 +16,7 @@
 
 #include "commands.h"
 #include "fsverity_uapi.h"
-#include "hash_algs.h"
+#include "libfsverity.h"
 
 static bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
 {
@@ -36,11 +36,16 @@ static bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
 	}
 
 	/* Specified by name? */
-	alg = find_hash_alg_by_name(arg);
+	alg = libfsverity_find_hash_alg_by_name(arg);
 	if (alg != NULL) {
-		*alg_ptr = alg - fsverity_hash_algs;
+		*alg_ptr = alg->hash_num;
 		return true;
 	}
+	error_msg("unknown hash algorithm: '%s'", arg);
+	fputs("Available hash algorithms: ", stderr);
+	show_all_hash_algs(stderr);
+	putc('\n', stderr);
+
 	return false;
 }
 
diff --git a/cmd_measure.c b/cmd_measure.c
index 574e3ca..4c0777f 100644
--- a/cmd_measure.c
+++ b/cmd_measure.c
@@ -13,7 +13,7 @@
 
 #include "commands.h"
 #include "fsverity_uapi.h"
-#include "hash_algs.h"
+#include "libfsverity.h"
 
 /* Display the measurement of the given verity file(s). */
 int fsverity_cmd_measure(const struct fsverity_command *cmd,
@@ -48,7 +48,7 @@ int fsverity_cmd_measure(const struct fsverity_command *cmd,
 
 		ASSERT(d->digest_size <= FS_VERITY_MAX_DIGEST_SIZE);
 		bin2hex(d->digest, d->digest_size, digest_hex);
-		hash_alg = find_hash_alg_by_num(d->digest_algorithm);
+		hash_alg = libfsverity_find_hash_alg_by_num(d->digest_algorithm);
 		if (hash_alg) {
 			hash_alg_name = hash_alg->name;
 		} else {
diff --git a/cmd_sign.c b/cmd_sign.c
index 1792084..5ad4eda 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -466,7 +466,7 @@ static bool compute_file_measurement(int fd,
 				     u32 block_size, const u8 *salt,
 				     u32 salt_size, u8 *measurement)
 {
-	struct hash_ctx *hash = hash_create(hash_alg);
+	struct hash_ctx *hash = hash_alg->create_ctx(hash_alg);
 	u64 file_size;
 	struct fsverity_descriptor desc;
 	struct stat stbuf;
@@ -480,7 +480,7 @@ static bool compute_file_measurement(int fd,
 
 	memset(&desc, 0, sizeof(desc));
 	desc.version = 1;
-	desc.hash_algorithm = hash_alg - fsverity_hash_algs;
+	desc.hash_algorithm = hash_alg->hash_num;
 
 	ASSERT(is_power_of_2(block_size));
 	desc.log_blocksize = ilog2(block_size);
@@ -552,9 +552,15 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 				error_msg("--hash-alg can only be specified once");
 				goto out_usage;
 			}
-			hash_alg = find_hash_alg_by_name(optarg);
-			if (hash_alg == NULL)
+			hash_alg = libfsverity_find_hash_alg_by_name(optarg);
+			if (hash_alg == NULL) {
+				error_msg("unknown hash algorithm: '%s'",
+					  optarg);
+				fputs("Available hash algorithms: ", stderr);
+				show_all_hash_algs(stderr);
+				putc('\n', stderr);
 				goto out_usage;
+			}
 			break;
 		case OPT_BLOCK_SIZE:
 			if (!parse_block_size_option(optarg, &block_size))
@@ -590,7 +596,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 		goto out_usage;
 
 	if (hash_alg == NULL)
-		hash_alg = &fsverity_hash_algs[FS_VERITY_HASH_ALG_DEFAULT];
+		hash_alg = libfsverity_find_hash_alg_by_num(FS_VERITY_HASH_ALG_DEFAULT);
 
 	if (block_size == 0)
 		block_size = get_default_block_size();
@@ -604,7 +610,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 
 	digest = xzalloc(sizeof(*digest) + hash_alg->digest_size);
 	memcpy(digest->magic, "FSVerity", 8);
-	digest->digest_algorithm = cpu_to_le16(hash_alg - fsverity_hash_algs);
+	digest->digest_algorithm = cpu_to_le16(hash_alg->hash_num);
 	digest->digest_size = cpu_to_le16(hash_alg->digest_size);
 
 	if (!open_file(&file, argv[0], O_RDONLY, 0))
diff --git a/fsverity.c b/fsverity.c
index c8fa1b5..f9df72e 100644
--- a/fsverity.c
+++ b/fsverity.c
@@ -13,7 +13,6 @@
 #include <unistd.h>
 
 #include "commands.h"
-#include "hash_algs.h"
 #include "libfsverity.h"
 
 static const struct fsverity_command {
@@ -48,6 +47,20 @@ static const struct fsverity_command {
 	}
 };
 
+void show_all_hash_algs(FILE *fp)
+{
+	int i = 1;
+	const char *sep = "";
+	const struct fsverity_hash_alg *alg;
+
+	while ((alg = libfsverity_find_hash_alg_by_num(i++))) {
+		if (alg && alg->name) {
+			fprintf(fp, "%s%s", sep, alg->name);
+			sep = ", ";
+		}
+	}
+}
+
 static void usage_all(FILE *fp)
 {
 	int i;
diff --git a/hash_algs.c b/hash_algs.c
index 7251bf2..d9f70b4 100644
--- a/hash_algs.c
+++ b/hash_algs.c
@@ -12,6 +12,7 @@
 #include <string.h>
 
 #include "fsverity_uapi.h"
+#include "libfsverity.h"
 #include "hash_algs.h"
 
 /* ========== libcrypto (OpenSSL) wrappers ========== */
@@ -106,17 +107,20 @@ const struct fsverity_hash_alg fsverity_hash_algs[] = {
 		.name = "sha256",
 		.digest_size = 32,
 		.block_size = 64,
+		.hash_num = FS_VERITY_HASH_ALG_SHA256,
 		.create_ctx = create_sha256_ctx,
 	},
 	[FS_VERITY_HASH_ALG_SHA512] = {
 		.name = "sha512",
 		.digest_size = 64,
 		.block_size = 128,
+		.hash_num = FS_VERITY_HASH_ALG_SHA512,
 		.create_ctx = create_sha512_ctx,
 	},
 };
 
-const struct fsverity_hash_alg *find_hash_alg_by_name(const char *name)
+const struct fsverity_hash_alg *
+libfsverity_find_hash_alg_by_name(const char *name)
 {
 	int i;
 
@@ -125,14 +129,11 @@ const struct fsverity_hash_alg *find_hash_alg_by_name(const char *name)
 		    !strcmp(name, fsverity_hash_algs[i].name))
 			return &fsverity_hash_algs[i];
 	}
-	error_msg("unknown hash algorithm: '%s'", name);
-	fputs("Available hash algorithms: ", stderr);
-	show_all_hash_algs(stderr);
-	putc('\n', stderr);
 	return NULL;
 }
 
-const struct fsverity_hash_alg *find_hash_alg_by_num(unsigned int num)
+const struct fsverity_hash_alg *
+libfsverity_find_hash_alg_by_num(unsigned int num)
 {
 	if (num < ARRAY_SIZE(fsverity_hash_algs) &&
 	    fsverity_hash_algs[num].name)
@@ -141,19 +142,6 @@ const struct fsverity_hash_alg *find_hash_alg_by_num(unsigned int num)
 	return NULL;
 }
 
-void show_all_hash_algs(FILE *fp)
-{
-	int i;
-	const char *sep = "";
-
-	for (i = 0; i < ARRAY_SIZE(fsverity_hash_algs); i++) {
-		if (fsverity_hash_algs[i].name) {
-			fprintf(fp, "%s%s", sep, fsverity_hash_algs[i].name);
-			sep = ", ";
-		}
-	}
-}
-
 /* ->init(), ->update(), and ->final() all in one step */
 void hash_full(struct hash_ctx *ctx, const void *data, size_t size, u8 *digest)
 {
diff --git a/hash_algs.h b/hash_algs.h
index 3e90f49..2c7269a 100644
--- a/hash_algs.h
+++ b/hash_algs.h
@@ -6,15 +6,6 @@
 
 #include "util.h"
 
-struct fsverity_hash_alg {
-	const char *name;
-	unsigned int digest_size;
-	unsigned int block_size;
-	struct hash_ctx *(*create_ctx)(const struct fsverity_hash_alg *alg);
-};
-
-extern const struct fsverity_hash_alg fsverity_hash_algs[];
-
 struct hash_ctx {
 	const struct fsverity_hash_alg *alg;
 	void (*init)(struct hash_ctx *ctx);
@@ -23,24 +14,6 @@ struct hash_ctx {
 	void (*free)(struct hash_ctx *ctx);
 };
 
-const struct fsverity_hash_alg *find_hash_alg_by_name(const char *name);
-const struct fsverity_hash_alg *find_hash_alg_by_num(unsigned int num);
-void show_all_hash_algs(FILE *fp);
-
-/* The hash algorithm that fsverity-utils assumes when none is specified */
-#define FS_VERITY_HASH_ALG_DEFAULT	FS_VERITY_HASH_ALG_SHA256
-
-/*
- * Largest digest size among all hash algorithms supported by fs-verity.
- * This can be increased if needed.
- */
-#define FS_VERITY_MAX_DIGEST_SIZE	64
-
-static inline struct hash_ctx *hash_create(const struct fsverity_hash_alg *alg)
-{
-	return alg->create_ctx(alg);
-}
-
 static inline void hash_init(struct hash_ctx *ctx)
 {
 	ctx->init(ctx);
diff --git a/libfsverity.h b/libfsverity.h
index 396a6ee..318dcd7 100644
--- a/libfsverity.h
+++ b/libfsverity.h
@@ -18,6 +18,9 @@
 #define FS_VERITY_HASH_ALG_SHA256       1
 #define FS_VERITY_HASH_ALG_SHA512       2
 
+/* The hash algorithm that fsverity-utils assumes when none is specified */
+#define FS_VERITY_HASH_ALG_DEFAULT	FS_VERITY_HASH_ALG_SHA256
+
 struct libfsverity_merkle_tree_params {
 	uint16_t version;
 	uint16_t hash_algorithm;	/* Matches the digest_algorithm type */
@@ -27,6 +30,12 @@ struct libfsverity_merkle_tree_params {
 	uint64_t reserved[11];
 };
 
+/*
+ * Largest digest size among all hash algorithms supported by fs-verity.
+ * This can be increased if needed.
+ */
+#define FS_VERITY_MAX_DIGEST_SIZE	64
+
 struct libfsverity_digest {
 	char magic[8];			/* must be "FSVerity" */
 	uint16_t digest_algorithm;
@@ -57,9 +66,22 @@ struct fsverity_descriptor {
 	uint8_t signature[];	/* optional PKCS#7 signature */
 };
 
+struct fsverity_hash_alg {
+	const char *name;
+	unsigned int digest_size;
+	unsigned int block_size;
+	uint16_t hash_num;
+	struct hash_ctx *(*create_ctx)(const struct fsverity_hash_alg *alg);
+};
+
 int
 libfsverity_compute_digest(int fd,
 			   const struct libfsverity_merkle_tree_params *params,
 			   struct libfsverity_digest **digest_ret);
 
+const struct fsverity_hash_alg *
+libfsverity_find_hash_alg_by_name(const char *name);
+const struct fsverity_hash_alg *
+libfsverity_find_hash_alg_by_num(unsigned int num);
+
 #endif
diff --git a/util.h b/util.h
index dfa10f2..dd9b803 100644
--- a/util.h
+++ b/util.h
@@ -122,4 +122,6 @@ bool filedes_close(struct filedes *file);
 bool hex2bin(const char *hex, u8 *bin, size_t bin_len);
 void bin2hex(const u8 *bin, size_t bin_len, char *hex);
 
+void show_all_hash_algs();
+
 #endif /* UTIL_H */
-- 
2.24.1

