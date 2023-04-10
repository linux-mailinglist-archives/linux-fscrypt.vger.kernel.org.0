Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349766DC5BD
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 12:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjDJK07 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 06:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjDJK0y (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 06:26:54 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B761AB
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 03:26:52 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 87BF780581;
        Mon, 10 Apr 2023 06:16:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681121804; bh=5nRHX81h0KqwjjUiKDGpJl8ybfFXjI7s7YYv/VC9bSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJVcg1PcFZOvTPds2tvJy3JV7Bp97cVXTFdwlGwIG5ZkFQm8tioyMMomNPwNjbNIN
         woMddE90gvKQQ/XRk7zAq4G403EcJntsbQw96VA1Flji9C4dfLc2YQcrqiz6wLq5rL
         62+eDn4/lm5AlAGHRFP1rNXOdnog9CGKlVKluUiyyF4+BgBAp/yzBeQCZCQKNMGfZu
         5h9uo4FaUzJzP0bM+BwynXt6kG1pBw2RU3fO4Y0jbYqEX62RJ4rkn/nhKU62VJ2xUH
         0C77WbsV8lQNPswzqpe0lfhjnk/IzxRGdOdadJHTXI80UvP3yRx+VSO/ZAbGVwhsp8
         qyJgA2UiuB+4A==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 02/10] fscrypt: split and rename setup_per_mode_enc_key()
Date:   Mon, 10 Apr 2023 06:16:23 -0400
Message-Id: <ce606f56fd22df9c6a69219b82b1dcd074c08ba9.1681116739.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1681116739.git.sweettea-kernel@dorminy.me>
References: <cover.1681116739.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

At present, setup_per_mode_enc_key() tries to find, within an array of
mode keys in the master key, an already prepared key, and if it doesn't
find a pre-prepared key, sets up a new one. This caching is not super
clear, at least to me, and splitting this function makes it clearer.

So, the new find_mode_prepared_key() decides if a pre-prepared key
already exists. If not, the renamed setup_new_mode_prepared_key()
deals with taking the mode setup lock and creating the new prepared key
for the master key.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 57 ++++++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 5989d53971ca..7a3147382033 100644
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
@@ -231,14 +221,39 @@ static int setup_per_mode_enc_key(struct fscrypt_info *ci,
 	memzero_explicit(mode_key, mode->keysize);
 	if (err)
 		goto out_unlock;
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
@@ -294,7 +309,7 @@ static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
 {
 	int err;
 
-	err = setup_per_mode_enc_key(ci, mk, mk->mk_iv_ino_lblk_32_keys,
+	err = find_mode_prepared_key(ci, mk, mk->mk_iv_ino_lblk_32_keys,
 				     HKDF_CONTEXT_IV_INO_LBLK_32_KEY, true);
 	if (err)
 		return err;
@@ -344,7 +359,7 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 		 * encryption key.  This ensures that the master key is
 		 * consistently used only for HKDF, avoiding key reuse issues.
 		 */
-		err = setup_per_mode_enc_key(ci, mk, mk->mk_direct_keys,
+		err = find_mode_prepared_key(ci, mk, mk->mk_direct_keys,
 					     HKDF_CONTEXT_DIRECT_KEY, false);
 	} else if (ci->ci_policy.v2.flags &
 		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
@@ -354,7 +369,7 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
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

