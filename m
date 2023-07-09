Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC4374C785
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 20:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjGISxa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 14:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjGISxV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 14:53:21 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3976410C;
        Sun,  9 Jul 2023 11:53:20 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 9E5BA80B04;
        Sun,  9 Jul 2023 14:53:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688928800; bh=XorauFcYszE4NtmB+tgCalkvH3zKdP0cFzAea5tR7hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjrUgzmAOBvcNyVuNB/dZLDnZu8PhBmjJKtXUuZn6ICEN8ILVDHjXSLE1nyGIsOXi
         0hgHUHioIQR74yas869hjnBxciuFGxsoaJHBI/fCx8A3M7IcG258yAkU0NhwNFpmA2
         0G7WpkVSjazBe9bEULuw1CGZgNq6i+NEi6urtT1Zpqj6KRdvfLBzHETm5zPlqFg7eA
         JcUlXPRHrawsqX9kQY6cl0hf9uoBar+qLwP3ap6fRqGT99YSYZDwKLRWrStxPaax2D
         npDFf6I3TO1mTPDpWLoqsFjFWQ01rVQaQZ8aBy6HOz4NN/rTMup5R+4CyFLkFF1ZGr
         2Wfe9RyoB95ig==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v5 3/8] fscrypt: split setup_per_mode_enc_key()
Date:   Sun,  9 Jul 2023 14:53:03 -0400
Message-Id: <6e759d93fbc1b7aab538d1ad6eb231def7b4ec8a.1688927423.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1688927423.git.sweettea-kernel@dorminy.me>
References: <cover.1688927423.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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
 fs/crypto/keysetup.c | 61 +++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 727d473b6b03..06deac6f4487 100644
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
-	int err;
-
-	if (WARN_ON_ONCE(mode_num > FSCRYPT_MODE_MAX))
-		return -EINVAL;
-
-	prep_key = &keys[mode_num];
-	if (fscrypt_is_key_prepared(prep_key, ci)) {
-		ci->ci_enc_key = *prep_key;
-		return 0;
-	}
+	int err = 0;
 
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
2.40.1

