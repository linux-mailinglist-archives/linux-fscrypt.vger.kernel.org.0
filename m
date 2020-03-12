Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA2B183BAB
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 22:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgCLVsQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 17:48:16 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42683 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgCLVsQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 17:48:16 -0400
Received: by mail-qt1-f193.google.com with SMTP id g16so5748713qtp.9
        for <linux-fscrypt@vger.kernel.org>; Thu, 12 Mar 2020 14:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EEa6E/kcmO4TFUTsFSZc68iuqwq/gtvcWasaJFfhB/8=;
        b=tIrOTssJ2v62INPxEtKGH2HBFxIMg6sEx72XIfZLPhQtV+dLuPma2SoQKYSbxbCv/w
         lRNwqgK+cfqTQ5gZ91+/POntyoLfgCR9YZ+YDwmMMJAngnaUn4aK0EBlnHgWiZzy8D29
         QMzg+cEziMcz4dvlBwnvBRVDYpDtC0jV1YdGkQ2ucx9LtBSLVe+N16oj1s8mXh/RXT9i
         Y4ErEgFIX87IhuHz99lrzVhyhbRILMSAeLrY1fOfuj3iknKD3AvJXVibQkZl0ZiCDDMA
         URTXXQZROTRcuijeu5tWlQOC2G2UacwvR5qVFfPdCctWFEQ11jPSr9P/KDlKmTzAoLOa
         FIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EEa6E/kcmO4TFUTsFSZc68iuqwq/gtvcWasaJFfhB/8=;
        b=pYkvgNWSSEwS/kMTbbAvx6q9SlAUe4fYlyzIrl8PXVX3oMXvCiL2VhPyCAxmPRBkD6
         dLk/jt11p/JcyvP+PTioi/fYjRA54hvv04pyFAUDZWlQVcSf4HD4v8VulY4x5KCsuw6v
         g6/9xIVgf3Lfc5j2yAc1xOramnr94qcylCk+jFbxxybuFYFJfeLlfT5xasTnxdC+7a75
         xFFp+TtLZeRSQhGjEdZluzbGDlejG1w6WAUuRmDZxHrhzxWYckcz/uiWyTjJsOpI+bfX
         pH8N8HJ4GJgWUfYaIe7XHdkEK/XMXG/NOGETugEJ1w+3GV7nU5uU4TxVfU+ynG0JPat/
         0ECA==
X-Gm-Message-State: ANhLgQ3DvyUs9oi793RcCowaLJX2DKigoRWyCLbwIrssCnaef2ARi1Ya
        oAA1IsI2r8CrjDlKGa4syxGoYhxV
X-Google-Smtp-Source: ADFU+vtrRPDPAtfSua1hu2qjQ56JyokNjKKcecK4V8jB+jq8e1+j4k7t6HH1E8SZjZZ14Bsscn+l5w==
X-Received: by 2002:ac8:6b54:: with SMTP id x20mr9453088qts.41.1584049694841;
        Thu, 12 Mar 2020 14:48:14 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::fa82])
        by smtp.gmail.com with ESMTPSA id 199sm9853918qkm.7.2020.03.12.14.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 14:48:14 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 3/9] Move fsverity_descriptor definition to libfsverity.h
Date:   Thu, 12 Mar 2020 17:47:52 -0400
Message-Id: <20200312214758.343212-4-Jes.Sorensen@gmail.com>
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

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_sign.c    | 19 +------------------
 libfsverity.h | 26 +++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/cmd_sign.c b/cmd_sign.c
index dcc44f8..1792084 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -20,26 +20,9 @@
 #include <unistd.h>
 
 #include "commands.h"
-#include "fsverity_uapi.h"
+#include "libfsverity.h"
 #include "hash_algs.h"
 
-/*
- * Merkle tree properties.  The file measurement is the hash of this structure
- * excluding the signature and with the sig_size field set to 0.
- */
-struct fsverity_descriptor {
-	__u8 version;		/* must be 1 */
-	__u8 hash_algorithm;	/* Merkle tree hash algorithm */
-	__u8 log_blocksize;	/* log2 of size of data and tree blocks */
-	__u8 salt_size;		/* size of salt in bytes; 0 if none */
-	__le32 sig_size;	/* size of signature in bytes; 0 if none */
-	__le64 data_size;	/* size of file the Merkle tree is built over */
-	__u8 root_hash[64];	/* Merkle tree root hash */
-	__u8 salt[32];		/* salt prepended to each hashed block */
-	__u8 __reserved[144];	/* must be 0's */
-	__u8 signature[];	/* optional PKCS#7 signature */
-};
-
 /*
  * Format in which verity file measurements are signed.  This is the same as
  * 'struct fsverity_digest', except here some magic bytes are prepended to
diff --git a/libfsverity.h b/libfsverity.h
index ceebae1..396a6ee 100644
--- a/libfsverity.h
+++ b/libfsverity.h
@@ -13,13 +13,14 @@
 
 #include <stddef.h>
 #include <stdint.h>
+#include <linux/types.h>
 
 #define FS_VERITY_HASH_ALG_SHA256       1
 #define FS_VERITY_HASH_ALG_SHA512       2
 
 struct libfsverity_merkle_tree_params {
 	uint16_t version;
-	uint16_t hash_algorithm;
+	uint16_t hash_algorithm;	/* Matches the digest_algorithm type */
 	uint32_t block_size;
 	uint32_t salt_size;
 	const uint8_t *salt;
@@ -27,6 +28,7 @@ struct libfsverity_merkle_tree_params {
 };
 
 struct libfsverity_digest {
+	char magic[8];			/* must be "FSVerity" */
 	uint16_t digest_algorithm;
 	uint16_t digest_size;
 	uint8_t digest[];
@@ -38,4 +40,26 @@ struct libfsverity_signature_params {
 	uint64_t reserved[11];
 };
 
+/*
+ * Merkle tree properties.  The file measurement is the hash of this structure
+ * excluding the signature and with the sig_size field set to 0.
+ */
+struct fsverity_descriptor {
+	uint8_t version;	/* must be 1 */
+	uint8_t hash_algorithm;	/* Merkle tree hash algorithm */
+	uint8_t log_blocksize;	/* log2 of size of data and tree blocks */
+	uint8_t salt_size;	/* size of salt in bytes; 0 if none */
+	__le32 sig_size;	/* size of signature in bytes; 0 if none */
+	__le64 data_size;	/* size of file the Merkle tree is built over */
+	uint8_t root_hash[64];	/* Merkle tree root hash */
+	uint8_t salt[32];	/* salt prepended to each hashed block */
+	uint8_t __reserved[144];/* must be 0's */
+	uint8_t signature[];	/* optional PKCS#7 signature */
+};
+
+int
+libfsverity_compute_digest(int fd,
+			   const struct libfsverity_merkle_tree_params *params,
+			   struct libfsverity_digest **digest_ret);
+
 #endif
-- 
2.24.1

