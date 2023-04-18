Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2026E6A74
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Apr 2023 19:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbjDRRE6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 13:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjDRRE5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 13:04:57 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF288A270
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 10:04:55 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 659B78258F;
        Tue, 18 Apr 2023 13:04:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681837495; bh=dEb4cofQP0SC/9D0jU/fr3XiGsvihKGFpokT9e+n0h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UV0kIGLWSgm+XD/bK9e3qOnabBUO5i5OnVYBQtF3GUVkaVjGqbcBEGe1yGiZQcUZk
         p7wuznOcy5CiTHg39D1C6D7kAXc3YPw/M5T8fZQeInv9zJNXEFwstZkHCKQ3Jd++nz
         gRBJdaAJAJTBnLkAb9Z5TzFtcGLmNg83zJf3tJtF8ENt1DhLDDis/zYY8X6Cn3YgLI
         w/4/PnXKA3IiqOoCiLlYNPoZMTrQsC33rfdiMuBSlSGxUdFhyRJSXbnzYmewL5HhTN
         9qJ+oWaQj+Wn9bSMNsMwGbKI6gmvDSYuil2sIWilILyXM/GgfC5tgNlprODEMf4ogG
         t6BA0rwH1qIwg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 03/11] fscrypt: split setup_per_mode_enc_key()
Date:   Tue, 18 Apr 2023 13:04:28 -0400
Message-Id: <26d53ea3abac1fddc7fee5e36fe512cd41d039fe.1681837291.git.sweettea-kernel@dorminy.me>
In-Reply-To: <1edeb5c4936667b6493b50776cd1cbf5e4cf2fdd.1681837291.git.sweettea-kernel@dorminy.me>
References: <1edeb5c4936667b6493b50776cd1cbf5e4cf2fdd.1681837291.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

At present, setup_per_mode_enc_key() tries to find, within an array of
mode keys in the master key, an already prepared key, and if it doesn't
find a pre-prepared key, sets up a new one. This caching is not super
clear, at least to me, and splitting this function makes it clearer.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 59 +++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 727d473b6b03..69bd27b7e9d8 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -184,34 +184,24 @@ int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
 	return fscrypt_prepare_key(&ci->ci_enc_key, raw_key, ci);
 }
 
-static int setup_per_mode_enc_key(struct fscrypt_info *ci,
-				  struct fscrypt_master_key *mk,
-				  struct fscrypt_prepared_key *keys,
-				  u8 hkdf_context, bool include_fs_uuid)
+static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
+				       struct fscrypt_prepared_key *prep_key,
+				       const struct fscrypt_info *ci,
+				       u8 hkdf_context, bool include_fs_uuid)
 {
 	const struct inode *inode = ci->ci_inode;
 	const struct super_block *sb = inode->i_sb;
 	struct fscrypt_mode *mode = ci->ci_mode;
 	const u8 mode_num = mode - fscrypt_modes;
-	struct fscrypt_prepared_key *prep_key;
 	u8 mode_key[FSCRYPT_MAX_KEY_SIZE];
 	u8 hkdf_info[sizeof(mode_num) + sizeof(sb->s_uuid)];
 	unsigned int hkdf_infolen = 0;
 	int err;
 
-	if (WARN_ON_ONCE(mode_num > FSCRYPT_MODE_MAX))
-		return -EINVAL;
-
-	prep_key = &keys[mode_num];
-	if (fscrypt_is_key_prepared(prep_key, ci)) {
-		ci->ci_enc_key = *prep_key;
-		return 0;
-	}
-
 	mutex_lock(&fscrypt_mode_key_setup_mutex);
 
 	if (fscrypt_is_key_prepared(prep_key, ci))
-		goto done_unlock;
+		goto out_unlock;
 
 	BUILD_BUG_ON(sizeof(mode_num) != 1);
 	BUILD_BUG_ON(sizeof(sb->s_uuid) != 16);
@@ -229,16 +219,39 @@ static int setup_per_mode_enc_key(struct fscrypt_info *ci,
 		goto out_unlock;
 	err = fscrypt_prepare_key(prep_key, mode_key, ci);
 	memzero_explicit(mode_key, mode->keysize);
-	if (err)
-		goto out_unlock;
-done_unlock:
-	ci->ci_enc_key = *prep_key;
-	err = 0;
+
 out_unlock:
 	mutex_unlock(&fscrypt_mode_key_setup_mutex);
 	return err;
 }
 
+static int find_mode_prepared_key(struct fscrypt_info *ci,
+				  struct fscrypt_master_key *mk,
+				  struct fscrypt_prepared_key *keys,
+				  u8 hkdf_context, bool include_fs_uuid)
+{
+	struct fscrypt_mode *mode = ci->ci_mode;
+	const u8 mode_num = mode - fscrypt_modes;
+	struct fscrypt_prepared_key *prep_key;
+	int err;
+
+	if (WARN_ON_ONCE(mode_num > FSCRYPT_MODE_MAX))
+		return -EINVAL;
+
+	prep_key = &keys[mode_num];
+	if (fscrypt_is_key_prepared(prep_key, ci)) {
+		ci->ci_enc_key = *prep_key;
+		return 0;
+	}
+	err = setup_new_mode_prepared_key(mk, prep_key, ci, hkdf_context,
+					  include_fs_uuid);
+	if (err)
+		return err;
+
+	ci->ci_enc_key = *prep_key;
+	return 0;
+}
+
 /*
  * Derive a SipHash key from the given fscrypt master key and the given
  * application-specific information string.
@@ -294,7 +307,7 @@ static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
 {
 	int err;
 
-	err = setup_per_mode_enc_key(ci, mk, mk->mk_iv_ino_lblk_32_keys,
+	err = find_mode_prepared_key(ci, mk, mk->mk_iv_ino_lblk_32_keys,
 				     HKDF_CONTEXT_IV_INO_LBLK_32_KEY, true);
 	if (err)
 		return err;
@@ -344,7 +357,7 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 		 * encryption key.  This ensures that the master key is
 		 * consistently used only for HKDF, avoiding key reuse issues.
 		 */
-		err = setup_per_mode_enc_key(ci, mk, mk->mk_direct_keys,
+		err = find_mode_prepared_key(ci, mk, mk->mk_direct_keys,
 					     HKDF_CONTEXT_DIRECT_KEY, false);
 	} else if (ci->ci_policy.v2.flags &
 		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
@@ -354,7 +367,7 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 		 * the IVs.  This format is optimized for use with inline
 		 * encryption hardware compliant with the UFS standard.
 		 */
-		err = setup_per_mode_enc_key(ci, mk, mk->mk_iv_ino_lblk_64_keys,
+		err = find_mode_prepared_key(ci, mk, mk->mk_iv_ino_lblk_64_keys,
 					     HKDF_CONTEXT_IV_INO_LBLK_64_KEY,
 					     true);
 	} else if (ci->ci_policy.v2.flags &
-- 
2.40.0

