Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009CB1B8132
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDXUzN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUzN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:13 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE56C09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:13 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id g74so11621432qke.13
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jSBbEcOwFMhqBX1vDwrRIhewNSVL0qTYjHJFLo6awkE=;
        b=UggLd/5olYLSzu52Nia68NcVS9BuXtjEJfACdibcxDMNlxv7OAMICDtZ8mH81Mxr1s
         TDj/qcAcXPhgo8B1NHp/b45tYwNfxejHymndbXJVbmtGFGb0a5Pwr6wwy5S6rLUHs1xC
         6OEL+RDoH3eI63UQsEmGuYKlOdsPy0JfObM3yDplJlU7qZjjJhkge5M0l37AkcVvfzdb
         5xqtOOlGCeFBljKDGYjriAgynLOZJI2FRd417bgXbVOpVLyS9VYc0leuhNouyFBh/v84
         +n/+cd9H0eOKbdl0OLj+thgGfk7gdUSCwe/Uy+XTXS3y0BfpxH0zL/VkWKf6nsixqpWw
         MSVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jSBbEcOwFMhqBX1vDwrRIhewNSVL0qTYjHJFLo6awkE=;
        b=k21FszBJeqgY/twQ4KdS8wPwciDpYUk4EIfcQxexoB2d1b+eG5epldxQ5T6T5Xa3O1
         9K72n3XUtMmYkDQ+IUiY6gRarlyzpWPugLq27hkgiAq23gyECmbyxd/cg+kmHG6XiRPr
         zlWN+LGQSuXB2VHeYAl9EY+r3bAMk8Y+oV3NUXP9FDYBcJXijVuavQ1sqgQWhJ0/BBa9
         hEaYRo/b7wCQSF4DIyaemeMUi0/xmGV+ydNl+alr7Zu+vacoG1nENuasIia7gwEiREh5
         ovDuRKNsdUP527aFfrPFqGCpeoU3cAn9+0qr7zG7zeHS72iPVcLrHDj5uI1XLa1fY/S6
         I6PQ==
X-Gm-Message-State: AGi0PubdDYBpH8dWbLwAkPWwGgyqz9ujCYBkb4Ytc0v+CM4X91QzEyz7
        02vco8fv5kvy7Bcq6lp6/4AX5IMIBW4=
X-Google-Smtp-Source: APiQypLaaFKHkdz/GgFVNYLIlWwKInKNDvS0982EPZaJVK9GmZthP6IMedXVk8YlWNCNFeS3QPqLbg==
X-Received: by 2002:a05:620a:b97:: with SMTP id k23mr10778689qkh.174.1587761711350;
        Fri, 24 Apr 2020 13:55:11 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id h23sm4398873qkk.90.2020.04.24.13.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:10 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 03/20] Move fsverity_descriptor definition to libfsverity.h
Date:   Fri, 24 Apr 2020 16:54:47 -0400
Message-Id: <20200424205504.2586682-4-Jes.Sorensen@gmail.com>
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
2.25.3

