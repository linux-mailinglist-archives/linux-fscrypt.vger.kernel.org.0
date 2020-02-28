Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C14174174
	for <lists+linux-fscrypt@lfdr.de>; Fri, 28 Feb 2020 22:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgB1V2e (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 28 Feb 2020 16:28:34 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42337 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgB1V2d (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 28 Feb 2020 16:28:33 -0500
Received: by mail-qk1-f196.google.com with SMTP id o28so4438016qkj.9
        for <linux-fscrypt@vger.kernel.org>; Fri, 28 Feb 2020 13:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EEa6E/kcmO4TFUTsFSZc68iuqwq/gtvcWasaJFfhB/8=;
        b=dCRqUHF1SoWhSR3KwURCwyNMJQa7xjaCG2bkBXj9iWgAc4VkgII1ltoIbgTddazGfG
         d+J5QtOIKEsW0rknVQaK+Y8tgMxdBOlLqy/ouegcg3mn0otalEydmXawk6efJZQyuDAt
         Ni3cgumyMPZerdsXEQWMfWeK1G3RIqVINm52SUr8IJVEuKCs/EK8bTpnVqM8Xkpn4jtn
         RR/FTF5oFmBFtB6XbxYCKmIWThTRUmoPqS2bBXQajiLpZro7AK1135U8pRrCVabevv/d
         auoILPEeL+6Pvh2RYiPefxRdp6WxfgZSDgmR7/ndZS707WFKCvchQNVgG6pADLFH/2/X
         EwZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EEa6E/kcmO4TFUTsFSZc68iuqwq/gtvcWasaJFfhB/8=;
        b=bdIMGkSJoMekctSGmG62rep/F5Mk+CLCj8RAN4zuatDUhP91RQmYlFQ+zr3WPl5j8e
         hFMBYV6/7VRTguXMQ6OU+yth245ythUiOZlUbETSC1ml7C6/Hes/kLIw9ZS1HwfBRZXB
         hjPW4p0o7nBzmQxXMZmi8iGO+YbYSicGLzP3uhNmvp6pKp0aCOjm0osytSksG84RyT/e
         9zXJIbq/DmixhPJm/nN/za2KQAg0eUDM8kmCgJDh9saus0coJAgKE16kN70Jpl2eg+g4
         4+znKH1APeuiPM5JTffKYctQt+BYJOZRG5zXIWjsuxUO9WR9txE5/7tuSLdbddkIIPaf
         bPJQ==
X-Gm-Message-State: APjAAAWxgY8Hua/0eKRvqzmXA4QGKadnV2BM+DN2CGJy+5zdurd3t0rF
        VZxOzM5mODwzge7SQqR9+dBBBzqm
X-Google-Smtp-Source: APXvYqy1FO/ZCgzgzMvpcmk1/JygIYdq6xsYW7Jxl2/xMrE1xZ0+9YmZRgATtN1jJk8sRcNN6Ynp3Q==
X-Received: by 2002:a05:620a:89e:: with SMTP id b30mr6235641qka.398.1582925310913;
        Fri, 28 Feb 2020 13:28:30 -0800 (PST)
Received: from localhost ([2620:10d:c091:500::1:bc9d])
        by smtp.gmail.com with ESMTPSA id p2sm5751010qkg.102.2020.02.28.13.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 13:28:30 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 3/6] Move fsverity_descriptor definition to libfsverity.h
Date:   Fri, 28 Feb 2020 16:28:11 -0500
Message-Id: <20200228212814.105897-4-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228212814.105897-1-Jes.Sorensen@gmail.com>
References: <20200228212814.105897-1-Jes.Sorensen@gmail.com>
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

