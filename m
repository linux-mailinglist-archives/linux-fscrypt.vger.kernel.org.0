Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C4E1B813D
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgDXUzc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUzc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:32 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B94C09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:32 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id 71so9111675qtc.12
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DrbAVWu4qCkcBZ8zvuLQ6tYHAf4DmA7axJJr6fBOg9Q=;
        b=G75R4FvwdRBLKdgFnZxKzd0d2fDkHQ0pKpiivNyuLUb0T+2YraSS/7Jv31q8rLQ4ca
         qSyD4VYi7R7sIihLBkG2gt/7vY6bq/Ae8FhvfJ47+abAK7kDSoRIOi4/vtS75gH8KzYd
         CmXDAaYK6FzOej1IpdaGim9d+FoiofSySA86tjSZ4oYOGOaqluhmX5T5w6TIJhOfSCil
         KvtrhWnjwQzMiIQpDXI0Xgp4FStmfvgH2jlLNCZhKtAo9XB+0L9ZBYjYSUet/7QIvQfY
         JIvCIz/sUkjFntG0TRixYEVN8GabJnCPlMwfTU2PFKP3XdXqrxR1rdhEOwwMX+w/R04t
         AfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DrbAVWu4qCkcBZ8zvuLQ6tYHAf4DmA7axJJr6fBOg9Q=;
        b=EFJ/wuCNdn3hP1nlINdyXPq2vS9NfyBBuME9eKTjOGhLdNzI+9HfjUsqiaaznu+ZNL
         ZDKjY3yuUXVZwmBwPunbj0/Tks5dYEnlFkbUTcmBg/ahyX3/cL/Odp/JqUhu+PlKTQc5
         leoFX1aVOgB+ksDWdDszvtzbpfC8vO/IjSRBTBQmjaDVB3wrDLEprelVw7AT9+najqqL
         2DDY8ZybUDdOqpJfqJxuvzHbnUsBDQOsg1L25Kplcf3r7o5u0AEHmRomg0xaObT+0icC
         9S32BmyOokOmGiOja5/IvLRUOyljr1EGsFZaGsvFYPZreDLVQteV8LFtxfAHR1ZskMA/
         vTsA==
X-Gm-Message-State: AGi0Pub5i+pdT4buVERdglImBxZZBVkuPPvQyDNZdyz64aIHUIZCZaYw
        2aD8L7Ij+ca10rUdYGqHleXF735GNwA=
X-Google-Smtp-Source: APiQypL5ATtEOApjVZDwyl0c7nTc+sCFNwJkL+qm3f08IBeHVy9Fo/7IhAxi4ojcwQdp1rxjw7WmYw==
X-Received: by 2002:ac8:7683:: with SMTP id g3mr11771149qtr.166.1587761730754;
        Fri, 24 Apr 2020 13:55:30 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id u5sm4428174qkm.116.2020.04.24.13.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:30 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 14/20] Change libfsverity_find_hash_alg_by_name() to return the alg number
Date:   Fri, 24 Apr 2020 16:54:58 -0400
Message-Id: <20200424205504.2586682-15-Jes.Sorensen@gmail.com>
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

This elimnates the need for struct fsverity_hash_alg in the use case
of libfsverity_find_hash_alg_by_name(). In addition this introduces a
libfsverity_digest_size() which returns the size of the digest for the
given algorithm, and libfsverity_hash_name() which returns a string
with the name of the algorithm. Note the returned string must be
freed by the caller.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_enable.c  |  6 +++---
 cmd_sign.c    | 25 +++++++++++++++----------
 hash_algs.c   | 35 ++++++++++++++++++++++++++++++-----
 libfsverity.h | 28 +++++++++++++++++++++++-----
 4 files changed, 71 insertions(+), 23 deletions(-)

diff --git a/cmd_enable.c b/cmd_enable.c
index 9612778..ac977e7 100644
--- a/cmd_enable.c
+++ b/cmd_enable.c
@@ -22,7 +22,7 @@ static bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
 {
 	char *end;
 	unsigned long n = strtoul(arg, &end, 10);
-	const struct fsverity_hash_alg *alg;
+	uint16_t alg;
 
 	if (*alg_ptr != 0) {
 		error_msg("--hash-alg can only be specified once");
@@ -37,8 +37,8 @@ static bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
 
 	/* Specified by name? */
 	alg = libfsverity_find_hash_alg_by_name(arg);
-	if (alg != NULL) {
-		*alg_ptr = alg->hash_num;
+	if (alg) {
+		*alg_ptr = alg;
 		return true;
 	}
 	error_msg("unknown hash algorithm: '%s'", arg);
diff --git a/cmd_sign.c b/cmd_sign.c
index 959e6d9..80e62d5 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -57,7 +57,6 @@ static int read_callback(void *opague, void *buf, size_t count)
 int fsverity_cmd_sign(const struct fsverity_command *cmd,
 		      int argc, char *argv[])
 {
-	const struct fsverity_hash_alg *hash_alg = NULL;
 	struct filedes file = { .fd = -1 };
 	u32 block_size = 0;
 	u8 *salt = NULL;
@@ -69,7 +68,10 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	struct libfsverity_signature_params sig_params;
 	u64 file_size;
 	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + 1];
+	char *hash_name = NULL;
 	u8 *sig = NULL;
+	u16 alg_nr = 0;
+	int digest_size;
 	size_t sig_size;
 	int status;
 	int c;
@@ -77,12 +79,12 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
 		switch (c) {
 		case OPT_HASH_ALG:
-			if (hash_alg != NULL) {
+			if (alg_nr) {
 				error_msg("--hash-alg can only be specified once");
 				goto out_usage;
 			}
-			hash_alg = libfsverity_find_hash_alg_by_name(optarg);
-			if (hash_alg == NULL) {
+			alg_nr = libfsverity_find_hash_alg_by_name(optarg);
+			if (!alg_nr) {
 				error_msg("unknown hash algorithm: '%s'",
 					  optarg);
 				fputs("Available hash algorithms: ", stderr);
@@ -124,8 +126,8 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	if (argc != 2)
 		goto out_usage;
 
-	if (hash_alg == NULL)
-		hash_alg = libfsverity_find_hash_alg_by_num(FS_VERITY_HASH_ALG_DEFAULT);
+	if (!alg_nr)
+		alg_nr = FS_VERITY_HASH_ALG_DEFAULT;
 
 	if (block_size == 0)
 		block_size = get_default_block_size();
@@ -147,7 +149,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 
 	memset(&params, 0, sizeof(struct libfsverity_merkle_tree_params));
 	params.version = 1;
-	params.hash_algorithm = hash_alg->hash_num;
+	params.hash_algorithm = alg_nr;
 	params.block_size = block_size;
 	params.salt_size = salt_size;
 	params.salt = salt;
@@ -158,6 +160,8 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 
 	filedes_close(&file);
 
+	digest_size = libfsverity_digest_size(alg_nr);
+
 	memset(&sig_params, 0, sizeof(struct libfsverity_signature_params));
 	sig_params.keyfile = keyfile;
 	sig_params.certfile = certfile;
@@ -169,9 +173,10 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	if (!write_signature(argv[1], sig, sig_size))
 		goto out_err;
 
-	bin2hex(digest->digest, hash_alg->digest_size, digest_hex);
-	printf("Signed file '%s' (%s:%s)\n", argv[0], hash_alg->name,
-	       digest_hex);
+	hash_name = libfsverity_hash_name(alg_nr);
+	bin2hex(digest->digest, digest_size, digest_hex);
+	printf("Signed file '%s' (%s:%s)\n", argv[0], hash_name, digest_hex);
+	free(hash_name);
 	status = 0;
 out:
 	free(salt);
diff --git a/hash_algs.c b/hash_algs.c
index 3066d87..120d1be 100644
--- a/hash_algs.c
+++ b/hash_algs.c
@@ -137,17 +137,17 @@ const struct fsverity_hash_alg fsverity_hash_algs[] = {
 	},
 };
 
-const struct fsverity_hash_alg *
-libfsverity_find_hash_alg_by_name(const char *name)
+uint16_t libfsverity_find_hash_alg_by_name(const char *name)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(fsverity_hash_algs); i++) {
 		if (fsverity_hash_algs[i].name &&
-		    !strcmp(name, fsverity_hash_algs[i].name))
-			return &fsverity_hash_algs[i];
+		    !strcmp(name, fsverity_hash_algs[i].name)) {
+			return fsverity_hash_algs[i].hash_num;
+		}
 	}
-	return NULL;
+	return 0;
 }
 
 const struct fsverity_hash_alg *
@@ -160,6 +160,31 @@ libfsverity_find_hash_alg_by_num(unsigned int num)
 	return NULL;
 }
 
+int libfsverity_digest_size(uint16_t alg_nr)
+{
+	if (alg_nr < ARRAY_SIZE(fsverity_hash_algs) &&
+	    fsverity_hash_algs[alg_nr].name)
+		return fsverity_hash_algs[alg_nr].digest_size;
+
+	return -1;
+}
+
+char *libfsverity_hash_name(uint16_t alg_nr)
+{
+	int namelen;
+	char *hash_name = NULL;
+
+	if (alg_nr < ARRAY_SIZE(fsverity_hash_algs) &&
+	    fsverity_hash_algs[alg_nr].name) {
+		namelen = strlen(fsverity_hash_algs[alg_nr].name);
+		hash_name = malloc(namelen + 1);
+		if (hash_name)
+			strcpy(hash_name, fsverity_hash_algs[alg_nr].name);
+	}
+
+	return hash_name;
+}
+
 /* ->init(), ->update(), and ->final() all in one step */
 void hash_full(struct hash_ctx *ctx, const void *data, size_t size,
 	       uint8_t *digest)
diff --git a/libfsverity.h b/libfsverity.h
index ea36b8e..a505cbe 100644
--- a/libfsverity.h
+++ b/libfsverity.h
@@ -58,7 +58,7 @@ struct libfsverity_signature_params {
 
 struct fsverity_hash_alg {
 	const char *name;
-	unsigned int digest_size;
+	int digest_size;
 	unsigned int block_size;
 	uint16_t hash_num;
 	struct hash_ctx *(*create_ctx)(const struct fsverity_hash_alg *alg);
@@ -108,11 +108,9 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
  * @name: Pointer to name of hash algorithm
  *
  * Returns:
- * struct fsverity_hash_alg success
- * NULL on error
+ * uint16_t containing hash algorithm number, zero on error.
  */
-const struct fsverity_hash_alg *
-libfsverity_find_hash_alg_by_name(const char *name);
+uint16_t libfsverity_find_hash_alg_by_name(const char *name);
 
 /*
  * libfsverity_find_hash_alg_by_num - Find hash algorithm by number
@@ -125,4 +123,24 @@ libfsverity_find_hash_alg_by_name(const char *name);
 const struct fsverity_hash_alg *
 libfsverity_find_hash_alg_by_num(unsigned int num);
 
+/*
+ * libfsverity_digest_size - Return size of digest for a given algorithm
+ * @alg_nr: Valid hash algorithm number
+ *
+ * Returns:
+ * int containing size of digest, -1 on error.
+ */
+int libfsverity_digest_size(uint16_t alg_nr);
+
+/*
+ * libfsverity_find_hash_name - Find name of hash algorithm by number
+ * @name: Number of hash algorithm
+ *
+ * Returns:
+ *  New allocated string containing name of algorithm.
+ *  String must be freed by caller.
+ * NULL on error
+ */
+char *libfsverity_hash_name(uint16_t num);
+
 #endif
-- 
2.25.3

