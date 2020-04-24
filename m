Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6367A1B813E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDXUze (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUzd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:33 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B442C09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:33 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id q2so5409200qvd.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PF8Wn3/jzuwAy8wnSAMpG2Cm2x5tCqjN/JAQ+KXIqIU=;
        b=qe/hfFB+AcNLN0+mZxtiC31fNwdNv8bicfPZq3A5v7dsqCDcwFMkEPczszt+pnJxoq
         vuDHbaRPNcQgGKumuamPJYueaaFqwtFN7fcIFDz85Z3pOUJqkXUoyl3VCzRjt1T1xiyu
         hwtCMNylfV9+B1R0nDxN61Z/Wxml3rxNAYYMWyzuem2YbNnfPu7whIp/2CXiNdwKbOJB
         lVS2x+y9TGEJEz6kEtIF48kTFzY1FdwNHVHppH1vacGbvo11luBhmwOgGMF5OXl+QAyU
         bH1Q8/r7coI8WAbTShu40GHZe5rA239A9OUZ6xODqSKo0shp9ph5ba0rRvvx0/qbD6vT
         okdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PF8Wn3/jzuwAy8wnSAMpG2Cm2x5tCqjN/JAQ+KXIqIU=;
        b=flHzlPmiAjCFEIQ1ocLuRfhE5z8Z82asrHFasmAOCQ2FpuRQ2m6S5yf2Qdap0Ax1FL
         pAlXQvsxL0CX2roQVKpSfCoyC9w1DDhRCDLAYAZNLA1S4l+reGrxGzetABEDpVHxu+jX
         IKoSalMoEP4ZGAom3F+X7uQbKG4ET86OFDMZYR7NO8nHmkWDSsD7aXIDgM++GLnRi1BQ
         cB5e2IK1Lgc7jbKznbQ72zL1yA5UoB+ioM8z4YQcamYtWfXZwwZ7YZmVAW5vUglR7xGi
         LQk9qMgF2T+cjD0Iztfg++rcX9tH8GXaIqYtSENgieQ6suKfW9qP+1zXJZQg3kixF6ON
         IUhA==
X-Gm-Message-State: AGi0PubCamf6pDzeHykbosaxcDDKR1m/vNt6tWvqwnRr7ph/Fz+DoyMy
        lMZzmQFVuY+8EldVkmtc9bcKG8x+a0Y=
X-Google-Smtp-Source: APiQypKKjMrLGvHABm4CrzAP1A6P6zWqOSCJkQbS3b+uoW/0hBsjybRXRwjqEfG/xSUzhEOiHmHBqA==
X-Received: by 2002:ad4:42b1:: with SMTP id e17mr11312834qvr.149.1587761732420;
        Fri, 24 Apr 2020 13:55:32 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id a27sm4919535qtb.26.2020.04.24.13.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:31 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 15/20] Make libfsverity_find_hash_alg_by_name() private to the shared library
Date:   Fri, 24 Apr 2020 16:54:59 -0400
Message-Id: <20200424205504.2586682-16-Jes.Sorensen@gmail.com>
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

This moves struct fsverity_hash_alg out of the public API. Instead
implement show_all_hash_algs() by calling libfsverity_hash_name()
until it returns null.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_enable.c          |  2 +-
 cmd_measure.c         | 17 ++++++++---------
 cmd_sign.c            |  2 +-
 fsverity.c            | 16 +++++++---------
 hash_algs.c           |  1 +
 libfsverity.h         | 19 -------------------
 libfsverity_private.h | 19 +++++++++++++++++++
 7 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/cmd_enable.c b/cmd_enable.c
index ac977e7..632ac84 100644
--- a/cmd_enable.c
+++ b/cmd_enable.c
@@ -42,7 +42,7 @@ static bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
 		return true;
 	}
 	error_msg("unknown hash algorithm: '%s'", arg);
-	fputs("Available hash algorithms: ", stderr);
+	fputs("Available hash algorithms:", stderr);
 	show_all_hash_algs(stderr);
 	putc('\n', stderr);
 
diff --git a/cmd_measure.c b/cmd_measure.c
index 4c0777f..df39da0 100644
--- a/cmd_measure.c
+++ b/cmd_measure.c
@@ -22,9 +22,8 @@ int fsverity_cmd_measure(const struct fsverity_command *cmd,
 	struct fsverity_digest *d = NULL;
 	struct filedes file;
 	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + 1];
-	const struct fsverity_hash_alg *hash_alg;
 	char _hash_alg_name[32];
-	const char *hash_alg_name;
+	char *hash_alg_name;
 	int status;
 	int i;
 
@@ -48,14 +47,14 @@ int fsverity_cmd_measure(const struct fsverity_command *cmd,
 
 		ASSERT(d->digest_size <= FS_VERITY_MAX_DIGEST_SIZE);
 		bin2hex(d->digest, d->digest_size, digest_hex);
-		hash_alg = libfsverity_find_hash_alg_by_num(d->digest_algorithm);
-		if (hash_alg) {
-			hash_alg_name = hash_alg->name;
-		} else {
+		hash_alg_name = libfsverity_hash_name(d->digest_algorithm);
+		if (!hash_alg_name)
 			sprintf(_hash_alg_name, "ALG_%u", d->digest_algorithm);
-			hash_alg_name = _hash_alg_name;
-		}
-		printf("%s:%s %s\n", hash_alg_name, digest_hex, argv[i]);
+
+		printf("%s:%s %s\n",
+		       hash_alg_name ? hash_alg_name :_hash_alg_name,
+		       digest_hex, argv[i]);
+		free(hash_alg_name);
 	}
 	status = 0;
 out:
diff --git a/cmd_sign.c b/cmd_sign.c
index 80e62d5..57a9250 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -87,7 +87,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 			if (!alg_nr) {
 				error_msg("unknown hash algorithm: '%s'",
 					  optarg);
-				fputs("Available hash algorithms: ", stderr);
+				fputs("Available hash algorithms:", stderr);
 				show_all_hash_algs(stderr);
 				putc('\n', stderr);
 				goto out_usage;
diff --git a/fsverity.c b/fsverity.c
index a176ead..2e2b553 100644
--- a/fsverity.c
+++ b/fsverity.c
@@ -51,14 +51,12 @@ static const struct fsverity_command {
 void show_all_hash_algs(FILE *fp)
 {
 	int i = 1;
-	const char *sep = "";
-	const struct fsverity_hash_alg *alg;
-
-	while ((alg = libfsverity_find_hash_alg_by_num(i++))) {
-		if (alg && alg->name) {
-			fprintf(fp, "%s%s", sep, alg->name);
-			sep = ", ";
-		}
+	const char *sep = " ";
+	char *alg;
+
+	while ((alg = libfsverity_hash_name(i++))) {
+		fprintf(fp, "%s%s", sep, alg);
+		free(alg);
 	}
 }
 
@@ -75,7 +73,7 @@ static void usage_all(FILE *fp)
 "    fsverity --help\n"
 "    fsverity --version\n"
 "\n"
-"Available hash algorithms: ", fp);
+"Available hash algorithms:", fp);
 	show_all_hash_algs(fp);
 	putc('\n', fp);
 }
diff --git a/hash_algs.c b/hash_algs.c
index 120d1be..03b9de9 100644
--- a/hash_algs.c
+++ b/hash_algs.c
@@ -15,6 +15,7 @@
 #include "helpers.h"
 #include "fsverity_uapi.h"
 #include "libfsverity.h"
+#include "libfsverity_private.h"
 #include "hash_algs.h"
 
 /* ========== libcrypto (OpenSSL) wrappers ========== */
diff --git a/libfsverity.h b/libfsverity.h
index a505cbe..4f0f885 100644
--- a/libfsverity.h
+++ b/libfsverity.h
@@ -56,14 +56,6 @@ struct libfsverity_signature_params {
 	uint64_t reserved[11];
 };
 
-struct fsverity_hash_alg {
-	const char *name;
-	int digest_size;
-	unsigned int block_size;
-	uint16_t hash_num;
-	struct hash_ctx *(*create_ctx)(const struct fsverity_hash_alg *alg);
-};
-
 /*
  * libfsverity_compute_digest - Compute digest of a file
  * @fd: open file descriptor of file to compute digest for
@@ -112,17 +104,6 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
  */
 uint16_t libfsverity_find_hash_alg_by_name(const char *name);
 
-/*
- * libfsverity_find_hash_alg_by_num - Find hash algorithm by number
- * @name: Number of hash algorithm
- *
- * Returns:
- * struct fsverity_hash_alg success
- * NULL on error
- */
-const struct fsverity_hash_alg *
-libfsverity_find_hash_alg_by_num(unsigned int num);
-
 /*
  * libfsverity_digest_size - Return size of digest for a given algorithm
  * @alg_nr: Valid hash algorithm number
diff --git a/libfsverity_private.h b/libfsverity_private.h
index 5f3e1b4..f8eebe2 100644
--- a/libfsverity_private.h
+++ b/libfsverity_private.h
@@ -30,4 +30,23 @@ struct fsverity_descriptor {
 	uint8_t signature[];	/* optional PKCS#7 signature */
 };
 
+struct fsverity_hash_alg {
+	const char *name;
+	int digest_size;
+	unsigned int block_size;
+	uint16_t hash_num;
+	struct hash_ctx *(*create_ctx)(const struct fsverity_hash_alg *alg);
+};
+
+/*
+ * libfsverity_find_hash_alg_by_num - Find hash algorithm by number
+ * @name: Number of hash algorithm
+ *
+ * Returns:
+ * struct fsverity_hash_alg success
+ * NULL on error
+ */
+const struct fsverity_hash_alg *
+libfsverity_find_hash_alg_by_num(unsigned int num);
+
 #endif
-- 
2.25.3

