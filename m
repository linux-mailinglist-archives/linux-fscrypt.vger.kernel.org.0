Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810264C63FA
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Feb 2022 08:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbiB1Hte (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Feb 2022 02:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiB1Htd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Feb 2022 02:49:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D96C3D1D3;
        Sun, 27 Feb 2022 23:48:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CF496100E;
        Mon, 28 Feb 2022 07:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A82AC340E7;
        Mon, 28 Feb 2022 07:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646034533;
        bh=+C0ISWOcH2v1GhaoFWSDaSnTtBvVfHQlIZyiB7bk9Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfwRas64/Q/Jrvbz1zTyd4YaQzhJp07U7IGmETC0CJ3URDokgbErAArEZx/1z/cAD
         pGchxlQB2/qbMSqcD7Cb8umB5Y/0pHLRGrcxWi7xv9kkeAII3Qwrcjs3fYOyQhZJxt
         iVcSrVgfqUx46tJwURWOk5nA88jO7otFMHRm7AYwN1D5suWl6dzfi9z3XO2mgU9BKT
         QY20c/OtlzqpA/zoRQnK2C0oYfpkgJ6bKpcXZnN11/8kh11CmtFp+hY9eTv/iXKExd
         apJ/H2k6QE+BVRbAnJ5kNoQaD+1LisvjXJ5eq5O8scQtXVUcjNi0Ew3xqoRDOZtq+r
         bmIzp31SK5kjw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [RFC PATCH 2/8] fscrypt-crypt-util: refactor get_key_and_iv()
Date:   Sun, 27 Feb 2022 23:47:16 -0800
Message-Id: <20220228074722.77008-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228074722.77008-1-ebiggers@kernel.org>
References: <20220228074722.77008-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Split get_key_and_iv() into two distinct parts: (1) deriving the key and
(2) generating the IV.  Also, check for the presence of needed options
just before they are used rather than doing it all up-front.

These changes should make this code much easier to understand.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 115 ++++++++++++++++++++++-----------------
 1 file changed, 64 insertions(+), 51 deletions(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 022ff7bd..0ecf9272 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -1828,16 +1828,9 @@ static u32 hash_inode_number(const struct key_and_iv_params *params)
 	return (u32)siphash_1u64(hash_key.words, params->inode_number);
 }
 
-/*
- * Get the key and starting IV with which the encryption will actually be done.
- * If a KDF was specified, a subkey is derived from the master key and the mode
- * number or file nonce.  Otherwise, the master key is used directly.
- */
-static void get_key_and_iv(const struct key_and_iv_params *params,
-			   u8 *real_key, size_t real_key_size,
-			   union fscrypt_iv *iv)
+static void derive_real_key(const struct key_and_iv_params *params,
+			    u8 *real_key, size_t real_key_size)
 {
-	int iv_methods = 0;
 	struct aes_key aes_key;
 	u8 info[8 + 1 + 1 + UUID_SIZE] = "fscrypt";
 	size_t infolen = 8;
@@ -1845,41 +1838,6 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 
 	ASSERT(real_key_size <= params->master_key_size);
 
-	memset(iv, 0, sizeof(*iv));
-
-	/* Overridden later for iv_ino_lblk_{64,32} */
-	iv->block_number = cpu_to_le64(params->block_number);
-
-	iv_methods += params->direct_key;
-	iv_methods += params->iv_ino_lblk_64;
-	iv_methods += params->iv_ino_lblk_32;
-	if (iv_methods > 1)
-		die("Conflicting IV methods specified");
-	if (iv_methods != 0 && params->kdf == KDF_AES_128_ECB)
-		die("--kdf=AES-128-ECB is incompatible with IV method options");
-
-	if (params->direct_key) {
-		if (!params->file_nonce_specified)
-			die("--direct-key requires file nonce");
-		if (params->kdf != KDF_NONE && params->mode_num == 0)
-			die("--direct-key with KDF requires --mode-num");
-	} else if (params->iv_ino_lblk_64 || params->iv_ino_lblk_32) {
-		const char *opt = params->iv_ino_lblk_64 ? "--iv-ino-lblk-64" :
-							   "--iv-ino-lblk-32";
-		if (params->kdf != KDF_HKDF_SHA512)
-			die("%s requires --kdf=HKDF-SHA512", opt);
-		if (!params->fs_uuid_specified)
-			die("%s requires --fs-uuid", opt);
-		if (params->inode_number == 0)
-			die("%s requires --inode-number", opt);
-		if (params->mode_num == 0)
-			die("%s requires --mode-num", opt);
-		if (params->block_number > UINT32_MAX)
-			die("%s can't use --block-number > UINT32_MAX", opt);
-		if (params->inode_number > UINT32_MAX)
-			die("%s can't use --inode-number > UINT32_MAX", opt);
-	}
-
 	switch (params->kdf) {
 	case KDF_NONE:
 		memcpy(real_key, params->master_key, real_key_size);
@@ -1896,24 +1854,28 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 		break;
 	case KDF_HKDF_SHA512:
 		if (params->direct_key) {
+			if (params->mode_num == 0)
+				die("--direct-key requires --mode-num");
 			info[infolen++] = HKDF_CONTEXT_DIRECT_KEY;
 			info[infolen++] = params->mode_num;
 		} else if (params->iv_ino_lblk_64) {
+			if (params->mode_num == 0)
+				die("--iv-ino-lblk-64 requires --mode-num");
+			if (!params->fs_uuid_specified)
+				die("--iv-ino-lblk-64 requires --fs-uuid");
 			info[infolen++] = HKDF_CONTEXT_IV_INO_LBLK_64_KEY;
 			info[infolen++] = params->mode_num;
 			memcpy(&info[infolen], params->fs_uuid, UUID_SIZE);
 			infolen += UUID_SIZE;
-			iv->block_number32 = cpu_to_le32(params->block_number);
-			iv->inode_number = cpu_to_le32(params->inode_number);
 		} else if (params->iv_ino_lblk_32) {
+			if (params->mode_num == 0)
+				die("--iv-ino-lblk-32 requires --mode-num");
+			if (!params->fs_uuid_specified)
+				die("--iv-ino-lblk-32 requires --fs-uuid");
 			info[infolen++] = HKDF_CONTEXT_IV_INO_LBLK_32_KEY;
 			info[infolen++] = params->mode_num;
 			memcpy(&info[infolen], params->fs_uuid, UUID_SIZE);
 			infolen += UUID_SIZE;
-			iv->block_number32 =
-				cpu_to_le32(hash_inode_number(params) +
-					    params->block_number);
-			iv->inode_number = 0;
 		} else if (params->file_nonce_specified) {
 			info[infolen++] = HKDF_CONTEXT_PER_FILE_ENC_KEY;
 			memcpy(&info[infolen], params->file_nonce,
@@ -1928,9 +1890,60 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 	default:
 		ASSERT(0);
 	}
+}
 
-	if (params->direct_key)
+static void generate_iv(const struct key_and_iv_params *params,
+			union fscrypt_iv *iv)
+{
+	memset(iv, 0, sizeof(*iv));
+	if (params->direct_key) {
+		if (!params->file_nonce_specified)
+			die("--direct-key requires file nonce");
+		iv->block_number = cpu_to_le64(params->block_number);
 		memcpy(iv->nonce, params->file_nonce, FILE_NONCE_SIZE);
+	} else if (params->iv_ino_lblk_64) {
+		if (params->block_number > UINT32_MAX)
+			die("iv-ino-lblk-64 can't use --block-number > UINT32_MAX");
+		if (params->inode_number == 0)
+			die("iv-ino-lblk-64 requires --inode-number");
+		if (params->inode_number > UINT32_MAX)
+			die("iv-ino-lblk-64 can't use --inode-number > UINT32_MAX");
+		iv->block_number32 = cpu_to_le32(params->block_number);
+		iv->inode_number = cpu_to_le32(params->inode_number);
+	} else if (params->iv_ino_lblk_32) {
+		if (params->block_number > UINT32_MAX)
+			die("iv-ino-lblk-32 can't use --block-number > UINT32_MAX");
+		if (params->inode_number == 0)
+			die("iv-ino-lblk-32 requires --inode-number");
+		iv->block_number32 = cpu_to_le32(hash_inode_number(params) +
+						 params->block_number);
+	} else {
+		iv->block_number = cpu_to_le64(params->block_number);
+	}
+}
+
+/*
+ * Get the key and starting IV with which the encryption will actually be done.
+ * If a KDF was specified, then a subkey is derived from the master key.
+ * Otherwise, the master key is used directly.
+ */
+static void get_key_and_iv(const struct key_and_iv_params *params,
+			   u8 *real_key, size_t real_key_size,
+			   union fscrypt_iv *iv)
+{
+	int iv_methods = 0;
+
+	iv_methods += params->direct_key;
+	iv_methods += params->iv_ino_lblk_64;
+	iv_methods += params->iv_ino_lblk_32;
+	if (iv_methods > 1)
+		die("Conflicting IV methods specified");
+	if (iv_methods != 0 && params->kdf == KDF_AES_128_ECB)
+		die("--kdf=AES-128-ECB is incompatible with IV method options");
+
+	derive_real_key(params, real_key, real_key_size);
+
+	generate_iv(params, iv);
 }
 
 enum {
-- 
2.35.1

