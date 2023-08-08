Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F4577462A
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbjHHSyI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbjHHSxp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:53:45 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D3A15A8F7;
        Tue,  8 Aug 2023 10:08:22 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 5228583542;
        Tue,  8 Aug 2023 13:08:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514500; bh=h27qIlwt20auHIvCc2yPFpadI21oe/SGA4sS3MlQVqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzpIYSD9sdb3wJc1GaeXTq5KUF+0GD9VAueEiHJ5veD8j43AH5tu2CroRq0h8cWVt
         0Cxep7fL3qCqjuuuB7UUb9Qw9LieZnpqotcnGb4ycgsX4Su8RKns8ARLHeL4NO3Ozc
         H65TVAHkyBkJ3ta+OJjcs3i7wMQSbNwGMjehzWRIMlSkllu0+uOh2Hlp+n9Q0Bd6vb
         WMesqFsUaouH2IgrDf6caD0UtYpmm2AKPM0WWlDjy4z4HuiVYP98XX5Z9LmZkdMD+Z
         72vAxq2sKClKDImMqM+Pdzya7S/oWv8GdO1Edu3Mq6nGG20/nSzU+q724TIt/yNKvK
         uT60d5LeRDc/g==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v6 3/8] fscrypt: split setup_per_mode_enc_key()
Date:   Tue,  8 Aug 2023 13:08:03 -0400
Message-ID: <cd8fffce4ec37af89c5f92fd8077e7f055fccc0e.1691505830.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505830.git.sweettea-kernel@dorminy.me>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
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
2.41.0

