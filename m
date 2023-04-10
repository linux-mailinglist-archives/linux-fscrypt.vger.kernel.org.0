Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9366DC5B6
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 12:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjDJK0y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 06:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDJK0x (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 06:26:53 -0400
X-Greylist: delayed 607 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Apr 2023 03:26:50 PDT
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBE1131
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 03:26:50 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 3B52B80637;
        Mon, 10 Apr 2023 06:16:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681121812; bh=dITwpJXBFQATzfqUa2IKjEtpeXr+UJkEsha1AtXZA34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xAHKNJv4U8votjijpTkIyY3yLXV/QR94zEeasCAN5rYgriVlDH+OXdjCexYxFSrEv
         Uf0X56gxP9LHx7OcYziEPX54P4QlUeCwNlJSKC5I3zssi+5rJ3CS76yoVF2oVz2rYT
         spYN/+Qy5nbWszCQxhh6RZuaMG4veBRnw3PwqfvIX9d/4Vy65c7TIHt++aMj/SJ63C
         4vNxOEtpivWJobHPpGjBkG1rbLQPMw2QqnL9xx3udueBFOfzZ5rl9lvfdmayu8zS5z
         1vIm2q7/FZ3bPj30RlX5maka0eoMw1MHfLgMTFBaB14yAUWK2mAmrQ1ECH6vjC+2N5
         htvWdVJuZeScA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 06/10] fscrypt: move all the shared mode key setup deeper
Date:   Mon, 10 Apr 2023 06:16:27 -0400
Message-Id: <553bf33a8264e8f6c0ec61a1039bda5f0b91bd4f.1681116740.git.sweettea-kernel@dorminy.me>
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
within a master key. fill_hkdf_info() deals with filling in the hkdf
info as necessary for a particular policy. And hkdf_context_for_policy()
translates policy into hkdf context for key derivation. These seem a
little clearer in broad strokes, emphasizing the similarities between
the policies, but it does spread out the information on how the key is
derived for a particular policy more.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 120 ++++++++++++++++++++++++++++---------------
 1 file changed, 79 insertions(+), 41 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index f07e3b9579cf..845a92203c87 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -78,6 +78,11 @@ struct fscrypt_mode fscrypt_modes[] = {
 
 static DEFINE_MUTEX(fscrypt_mode_key_setup_mutex);
 
+static const u8 FSCRYPT_POLICY_FLAGS_KEY_MASK =
+	(FSCRYPT_POLICY_FLAG_DIRECT_KEY
+	 | FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64
+	 | FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32);
+
 static struct fscrypt_mode *
 select_encryption_mode(const union fscrypt_policy *policy,
 		       const struct inode *inode)
@@ -188,10 +193,57 @@ int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
 	return fscrypt_prepare_key(ci->ci_enc_key, raw_key, ci);
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
+static size_t fill_hkdf_info(const struct fscrypt_info *ci, u8 *hkdf_info)
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
+static u8 hkdf_context_for_policy(const union fscrypt_policy *policy)
+{
+	switch (fscrypt_policy_flags(policy) & FSCRYPT_POLICY_FLAGS_KEY_MASK) {
+		case FSCRYPT_POLICY_FLAG_DIRECT_KEY:
+			return HKDF_CONTEXT_DIRECT_KEY;
+		case FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64:
+			return HKDF_CONTEXT_IV_INO_LBLK_64_KEY;
+		case FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32:
+			return HKDF_CONTEXT_IV_INO_LBLK_32_KEY;
+		default:
+			return 0;
+	}
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
@@ -200,8 +252,23 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 	u8 mode_key[FSCRYPT_MAX_KEY_SIZE];
 	u8 hkdf_info[sizeof(mode_num) + sizeof(sb->s_uuid)];
 	unsigned int hkdf_infolen = 0;
+	u8 hkdf_context = hkdf_context_for_policy(&ci->ci_policy);
 	int err;
 
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
@@ -210,12 +277,8 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 	BUILD_BUG_ON(sizeof(mode_num) != 1);
 	BUILD_BUG_ON(sizeof(sb->s_uuid) != 16);
 	BUILD_BUG_ON(sizeof(hkdf_info) != 17);
-	hkdf_info[hkdf_infolen++] = mode_num;
-	if (include_fs_uuid) {
-		memcpy(&hkdf_info[hkdf_infolen], &sb->s_uuid,
-		       sizeof(sb->s_uuid));
-		hkdf_infolen += sizeof(sb->s_uuid);
-	}
+	hkdf_infolen = fill_hkdf_info(ci, hkdf_info);
+
 	err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
 				  hkdf_context, hkdf_info, hkdf_infolen,
 				  mode_key, mode->keysize);
@@ -232,9 +295,7 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 }
 
 static int find_mode_prepared_key(struct fscrypt_info *ci,
-				  struct fscrypt_master_key *mk,
-				  struct fscrypt_prepared_key *keys,
-				  u8 hkdf_context, bool include_fs_uuid)
+				  struct fscrypt_master_key *mk)
 {
 	struct fscrypt_mode *mode = ci->ci_mode;
 	const u8 mode_num = mode - fscrypt_modes;
@@ -244,13 +305,15 @@ static int find_mode_prepared_key(struct fscrypt_info *ci,
 	if (WARN_ON_ONCE(mode_num > FSCRYPT_MODE_MAX))
 		return -EINVAL;
 
-	prep_key = &keys[mode_num];
+	prep_key = mk_prepared_key_for_mode_policy(mk, &ci->ci_policy, mode);
+	if (IS_ERR(prep_key))
+		return PTR_ERR(prep_key);
+
 	if (fscrypt_is_key_prepared(prep_key, ci)) {
 		ci->ci_enc_key = prep_key;
 		return 0;
 	}
-	err = setup_new_mode_prepared_key(mk, prep_key, ci, hkdf_context,
-					  include_fs_uuid);
+	err = setup_new_mode_prepared_key(mk, prep_key, ci);
 	if (err)
 		return err;
 
@@ -341,33 +404,8 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
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
+		err = find_mode_prepared_key(ci, mk);
 	} else {
 		u8 derived_key[FSCRYPT_MAX_KEY_SIZE];
 
-- 
2.40.0

