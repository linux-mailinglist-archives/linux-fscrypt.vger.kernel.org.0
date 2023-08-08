Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8623E774632
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjHHSyX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbjHHSyB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:54:01 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802EC1A77F;
        Tue,  8 Aug 2023 10:08:27 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id DE4EA83546;
        Tue,  8 Aug 2023 13:08:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514505; bh=aTSgRaKoyZXOKio0Qeto3AOD8EsEQ5Vi7X+iufCiWwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDrukw0alMlnR3CHpwMq69UsKZ26hp5nasovN7kaZdb5DVR40QL02hIk1fdi5995w
         bxoUHFOoJnyv+3cpFncJ8elwVT22eBETo/JwDq48f4u2k2TTiMAAbMZO0eRxhPu5rb
         cgXGuLIzSTSIyXtKMlsNX/NTUI0X/6iyv9xsWOw5AMKcz8Dq5kLZotM0Ll25EujIdw
         Gj3A2MPzL+9ER4Op1AoB9yofPvW74fWQUZKXq1oC8h98lExwIDQ+HkHct7zJUzEuTp
         MTQB5sFfiz3oTnYeCrSoe2ZjgQvC7kW6E+I2xhjsfLQItX8zboChn8kn3IMi5cuklZ
         +yI7kH02Q9VbA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v6 6/8] fscrypt: move all the shared mode key setup deeper
Date:   Tue,  8 Aug 2023 13:08:06 -0400
Message-ID: <953985195b4cce824ed64ee68827558544e93dcc.1691505830.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505830.git.sweettea-kernel@dorminy.me>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Currently, fscrypt_setup_v2_file_key() has a set of ifs which encode
various information about how to set up a new mode key if necessary for
a shared-key policy (DIRECT or IV_INO_LBLK_*). This is somewhat awkward
-- this information is only needed at the point that we need to setup a
new key, which is not the common case; the setup details are recorded as
function parameters relatively far from where they're actually used; and
at the point we use the parameters, we can derive the information
equally well.

So this moves mode and policy checking as deep into the callstack as
possible. mk_prepared_key_for_mode_policy() deals with the array lookup
within a master key. And fill_hkdf_info_for mode_key() deals with
filling in the hkdf info as necessary for a particular policy. These
seem a little clearer in broad strokes, emphasizing the similarities
between the policies, but it does spread out the information on how the
key is derived for a particular policy more.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 131 +++++++++++++++++++++++++++++--------------
 1 file changed, 88 insertions(+), 43 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 8b201b91c036..7dd12c1821dd 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -13,6 +13,17 @@
 
 #include "fscrypt_private.h"
 
+#define MAX_MODE_KEY_HKDF_INFO_SIZE 17
+
+/*
+ * Constant defining the various policy flags which require a non-default key
+ * policy.
+ */
+#define FSCRYPT_POLICY_FLAGS_KEY_MASK		\
+	(FSCRYPT_POLICY_FLAG_DIRECT_KEY		\
+	 | FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64	\
+	 | FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)
+
 struct fscrypt_mode fscrypt_modes[] = {
 	[FSCRYPT_MODE_AES_256_XTS] = {
 		.friendly_name = "AES-256-XTS",
@@ -184,20 +195,83 @@ int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
 	return fscrypt_prepare_key(&ci->ci_enc_key, raw_key, ci);
 }
 
+static struct fscrypt_prepared_key *
+mk_prepared_key_for_mode_policy(struct fscrypt_master_key *mk,
+				union fscrypt_policy *policy,
+				struct fscrypt_mode *mode)
+{
+	const u8 mode_num = mode - fscrypt_modes;
+
+	switch (policy->v2.flags & FSCRYPT_POLICY_FLAGS_KEY_MASK) {
+	case FSCRYPT_POLICY_FLAG_DIRECT_KEY:
+		return &mk->mk_direct_keys[mode_num];
+	case FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64:
+		return &mk->mk_iv_ino_lblk_64_keys[mode_num];
+	case FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32:
+		return &mk->mk_iv_ino_lblk_32_keys[mode_num];
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+}
+
+static size_t
+fill_hkdf_info_for_mode_key(const struct fscrypt_info *ci,
+			    u8 hkdf_info[MAX_MODE_KEY_HKDF_INFO_SIZE])
+{
+	const u8 mode_num = ci->ci_mode - fscrypt_modes;
+	const struct super_block *sb = ci->ci_inode->i_sb;
+	u8 hkdf_infolen = 0;
+
+	hkdf_info[hkdf_infolen++] = mode_num;
+	if (!(ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY)) {
+		memcpy(&hkdf_info[hkdf_infolen], &sb->s_uuid,
+				sizeof(sb->s_uuid));
+		hkdf_infolen += sizeof(sb->s_uuid);
+	}
+	return hkdf_infolen;
+}
+
 static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 				       struct fscrypt_prepared_key *prep_key,
-				       const struct fscrypt_info *ci,
-				       u8 hkdf_context, bool include_fs_uuid)
+				       const struct fscrypt_info *ci)
 {
 	const struct inode *inode = ci->ci_inode;
 	const struct super_block *sb = inode->i_sb;
+	unsigned int policy_flags = fscrypt_policy_flags(&ci->ci_policy);
 	struct fscrypt_mode *mode = ci->ci_mode;
 	const u8 mode_num = mode - fscrypt_modes;
 	u8 mode_key[FSCRYPT_MAX_KEY_SIZE];
 	u8 hkdf_info[sizeof(mode_num) + sizeof(sb->s_uuid)];
 	unsigned int hkdf_infolen = 0;
+	u8 hkdf_context = 0;
 	int err = 0;
 
+	switch (policy_flags & FSCRYPT_POLICY_FLAGS_KEY_MASK) {
+	case FSCRYPT_POLICY_FLAG_DIRECT_KEY:
+		hkdf_context = HKDF_CONTEXT_DIRECT_KEY;
+		break;
+	case FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64:
+		hkdf_context = HKDF_CONTEXT_IV_INO_LBLK_64_KEY;
+		break;
+	case FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32:
+		hkdf_context = HKDF_CONTEXT_IV_INO_LBLK_32_KEY;
+		break;
+	}
+
+	/*
+	 * For DIRECT_KEY policies: instead of deriving per-file encryption
+	 * keys, the per-file nonce will be included in all the IVs.  But
+	 * unlike v1 policies, for v2 policies in this case we don't encrypt
+	 * with the master key directly but rather derive a per-mode encryption
+	 * key.  This ensures that the master key is consistently used only for
+	 * HKDF, avoiding key reuse issues.
+	 *
+	 * For IV_INO_LBLK policies: encryption keys are derived from
+	 * (master_key, mode_num, filesystem_uuid), and inode number is
+	 * included in the IVs.  This format is optimized for use with inline
+	 * encryption hardware compliant with the UFS standard.
+	 */
+
 	mutex_lock(&fscrypt_mode_key_setup_mutex);
 
 	if (fscrypt_is_key_prepared(prep_key, ci))
@@ -205,13 +279,9 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 
 	BUILD_BUG_ON(sizeof(mode_num) != 1);
 	BUILD_BUG_ON(sizeof(sb->s_uuid) != 16);
-	BUILD_BUG_ON(sizeof(hkdf_info) != 17);
-	hkdf_info[hkdf_infolen++] = mode_num;
-	if (include_fs_uuid) {
-		memcpy(&hkdf_info[hkdf_infolen], &sb->s_uuid,
-		       sizeof(sb->s_uuid));
-		hkdf_infolen += sizeof(sb->s_uuid);
-	}
+	BUILD_BUG_ON(sizeof(hkdf_info) != MAX_MODE_KEY_HKDF_INFO_SIZE);
+	hkdf_infolen = fill_hkdf_info_for_mode_key(ci, hkdf_info);
+
 	err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
 				  hkdf_context, hkdf_info, hkdf_infolen,
 				  mode_key, mode->keysize);
@@ -225,10 +295,8 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 	return err;
 }
 
-static int find_mode_prepared_key(struct fscrypt_info *ci,
-				  struct fscrypt_master_key *mk,
-				  struct fscrypt_prepared_key *keys,
-				  u8 hkdf_context, bool include_fs_uuid)
+static int setup_mode_prepared_key(struct fscrypt_info *ci,
+				  struct fscrypt_master_key *mk)
 {
 	struct fscrypt_mode *mode = ci->ci_mode;
 	const u8 mode_num = mode - fscrypt_modes;
@@ -238,13 +306,15 @@ static int find_mode_prepared_key(struct fscrypt_info *ci,
 	if (WARN_ON_ONCE(mode_num > FSCRYPT_MODE_MAX))
 		return -EINVAL;
 
-	prep_key = &keys[mode_num];
+	prep_key = mk_prepared_key_for_mode_policy(mk, &ci->ci_policy, mode);
+	if (IS_ERR(prep_key))
+		return PTR_ERR(prep_key);
+
 	if (fscrypt_is_key_prepared(prep_key, ci)) {
 		ci->ci_enc_key = *prep_key;
 		return 0;
 	}
-	err = setup_new_mode_prepared_key(mk, prep_key, ci, hkdf_context,
-					  include_fs_uuid);
+	err = setup_new_mode_prepared_key(mk, prep_key, ci);
 	if (err)
 		return err;
 
@@ -333,33 +403,8 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 {
 	int err;
 
-	if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) {
-		/*
-		 * DIRECT_KEY: instead of deriving per-file encryption keys, the
-		 * per-file nonce will be included in all the IVs.  But unlike
-		 * v1 policies, for v2 policies in this case we don't encrypt
-		 * with the master key directly but rather derive a per-mode
-		 * encryption key.  This ensures that the master key is
-		 * consistently used only for HKDF, avoiding key reuse issues.
-		 */
-		err = find_mode_prepared_key(ci, mk, mk->mk_direct_keys,
-					     HKDF_CONTEXT_DIRECT_KEY, false);
-	} else if (ci->ci_policy.v2.flags &
-		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
-		/*
-		 * IV_INO_LBLK_64: encryption keys are derived from (master_key,
-		 * mode_num, filesystem_uuid), and inode number is included in
-		 * the IVs.  This format is optimized for use with inline
-		 * encryption hardware compliant with the UFS standard.
-		 */
-		err = find_mode_prepared_key(ci, mk, mk->mk_iv_ino_lblk_64_keys,
-					     HKDF_CONTEXT_IV_INO_LBLK_64_KEY,
-					     true);
-	} else if (ci->ci_policy.v2.flags &
-		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
-		err = find_mode_prepared_key(ci, mk, mk->mk_iv_ino_lblk_32_keys,
-					     HKDF_CONTEXT_IV_INO_LBLK_32_KEY,
-					     true);
+	if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAGS_KEY_MASK) {
+		err = setup_mode_prepared_key(ci, mk);
 	} else {
 		u8 derived_key[FSCRYPT_MAX_KEY_SIZE];
 
-- 
2.41.0

