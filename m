Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331BC65A8FF
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjAAFNz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbjAAFNs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:48 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C740663CC
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:47 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id EF33A8263A;
        Sun,  1 Jan 2023 00:06:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549611; bh=vKdl56H3Eyn9tkwdYaYdYBVUmySGklaAQ944HyzOxvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+Lj2YATo3BpRGr9IYea1LP7ykI9Ewmd4AvDQKRIxvuJwP0WPf+TAIVTHpY9iUkc9
         4hSZdWs+LKQ3HKSvmIG97806Wr78F01nnCrfYJ9qA2mCYtuELHd8jz9ZIjlVtsfu9F
         HH1iyVil2NEj6P5FTcdPEzqUL8rs/0PAbyTRw/o1aqTf6uEo5cbtt+drvZHRB+nE6g
         nxE/9VEYxk9LII9/kedErvXZgJUPqr8gilCgg/Joac1YfJIo+bJHwqJQWh723p3LI8
         jUNOClmz6Q85BJEup6p53I1ltoq3pbRLDZxXiFrz5ShEol8QFj0v+qiiREXHabEB/r
         PVkIkfA3Letmg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 11/17] fscrypt: update all the *per_file_* function names
Date:   Sun,  1 Jan 2023 00:06:15 -0500
Message-Id: <a73edc7151764e82a26bf2682cc675e1d509e411.1672547582.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1672547582.git.sweettea-kernel@dorminy.me>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

As they are no longer per-file but per-info, whether that info is
per-inode or per-extent, it seems better to rename all the relevant
functions to be per_info instead of per-key.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h |  6 +++---
 fs/crypto/keysetup.c        | 22 +++++++++++-----------
 fs/crypto/keysetup_v1.c     | 18 +++++++++---------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index dc45cd35391f..a34d2e525ddf 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -687,7 +687,7 @@ int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 void fscrypt_destroy_prepared_key(struct super_block *sb,
 				  struct fscrypt_prepared_key *prep_key);
 
-int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key);
+int fscrypt_set_per_info_enc_key(struct fscrypt_info *ci, const u8 *raw_key);
 
 int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
 			       const struct fscrypt_master_key *mk);
@@ -727,10 +727,10 @@ static inline int fscrypt_require_key(struct inode *inode)
 
 void fscrypt_put_direct_key(struct fscrypt_direct_key *dk);
 
-int fscrypt_setup_v1_file_key(struct fscrypt_info *ci,
+int fscrypt_setup_v1_info_key(struct fscrypt_info *ci,
 			      const u8 *raw_master_key);
 
-int fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_info *ci);
+int fscrypt_setup_v1_info_key_via_subscribed_keyrings(struct fscrypt_info *ci);
 
 /* policy.c */
 
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index c611e2613aa6..1751e3ed9956 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -162,8 +162,8 @@ void fscrypt_destroy_prepared_key(struct super_block *sb,
 	memzero_explicit(prep_key, sizeof(*prep_key));
 }
 
-/* Given a per-file encryption key, set up the file's crypto transform object */
-int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
+/* Given a fscrypt_info, set up an appropriate crypto transform object */
+int fscrypt_set_per_info_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
 {
 	ci->ci_owns_key = true;
 	return fscrypt_prepare_key(&ci->ci_enc_key, raw_key, ci);
@@ -313,7 +313,7 @@ static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
 	return 0;
 }
 
-static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
+static int fscrypt_setup_v2_info_key(struct fscrypt_info *ci,
 				     struct fscrypt_master_key *mk,
 				     bool need_dirhash_key)
 {
@@ -321,8 +321,8 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 
 	if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) {
 		/*
-		 * DIRECT_KEY: instead of deriving per-file encryption keys, the
-		 * per-file nonce will be included in all the IVs.  But unlike
+		 * DIRECT_KEY: instead of deriving per-info encryption keys, the
+		 * per-info nonce will be included in all the IVs.  But unlike
 		 * v1 policies, for v2 policies in this case we don't encrypt
 		 * with the master key directly but rather derive a per-mode
 		 * encryption key.  This ensures that the master key is
@@ -354,7 +354,7 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 		if (err)
 			return err;
 
-		err = fscrypt_set_per_file_enc_key(ci, derived_key);
+		err = fscrypt_set_per_info_enc_key(ci, derived_key);
 		memzero_explicit(derived_key, ci->ci_mode->keysize);
 	}
 	if (err)
@@ -418,7 +418,7 @@ static bool fscrypt_valid_master_key_size(const struct fscrypt_master_key *mk,
  * multiple tasks may race to create an fscrypt_info for the same inode), and to
  * synchronize the master key being removed with a new inode starting to use it.
  */
-static int setup_file_encryption_key(struct fscrypt_info *ci,
+static int setup_info_encryption_key(struct fscrypt_info *ci,
 				     bool need_dirhash_key,
 				     struct fscrypt_master_key **mk_ret)
 {
@@ -445,7 +445,7 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 		 * to before the search of ->s_master_keys, since users
 		 * shouldn't be able to override filesystem-level keys.
 		 */
-		return fscrypt_setup_v1_file_key_via_subscribed_keyrings(ci);
+		return fscrypt_setup_v1_info_key_via_subscribed_keyrings(ci);
 	}
 	down_read(&mk->mk_sem);
 
@@ -462,10 +462,10 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 
 	switch (ci->ci_policy.version) {
 	case FSCRYPT_POLICY_V1:
-		err = fscrypt_setup_v1_file_key(ci, mk->mk_secret.raw);
+		err = fscrypt_setup_v1_info_key(ci, mk->mk_secret.raw);
 		break;
 	case FSCRYPT_POLICY_V2:
-		err = fscrypt_setup_v2_file_key(ci, mk, need_dirhash_key);
+		err = fscrypt_setup_v2_info_key(ci, mk, need_dirhash_key);
 		break;
 	default:
 		WARN_ON(1);
@@ -584,7 +584,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	WARN_ON(mode->ivsize > FSCRYPT_MAX_IV_SIZE);
 	crypt_info->ci_mode = mode;
 
-	res = setup_file_encryption_key(crypt_info, need_dirhash_key, &mk);
+	res = setup_info_encryption_key(crypt_info, need_dirhash_key, &mk);
 	if (res)
 		goto out;
 
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 3cbf1480c457..3c3a203c2a94 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -250,7 +250,7 @@ fscrypt_get_direct_key(const struct fscrypt_info *ci, const u8 *raw_key)
 }
 
 /* v1 policy, DIRECT_KEY: use the master key directly */
-static int setup_v1_file_key_direct(struct fscrypt_info *ci,
+static int setup_v1_info_key_direct(struct fscrypt_info *ci,
 				    const u8 *raw_master_key)
 {
 	struct fscrypt_direct_key *dk;
@@ -263,8 +263,8 @@ static int setup_v1_file_key_direct(struct fscrypt_info *ci,
 	return 0;
 }
 
-/* v1 policy, !DIRECT_KEY: derive the file's encryption key */
-static int setup_v1_file_key_derived(struct fscrypt_info *ci,
+/* v1 policy, !DIRECT_KEY: derive the info's encryption key */
+static int setup_v1_info_key_derived(struct fscrypt_info *ci,
 				     const u8 *raw_master_key)
 {
 	u8 *derived_key;
@@ -283,21 +283,21 @@ static int setup_v1_file_key_derived(struct fscrypt_info *ci,
 	if (err)
 		goto out;
 
-	err = fscrypt_set_per_file_enc_key(ci, derived_key);
+	err = fscrypt_set_per_info_enc_key(ci, derived_key);
 out:
 	kfree_sensitive(derived_key);
 	return err;
 }
 
-int fscrypt_setup_v1_file_key(struct fscrypt_info *ci, const u8 *raw_master_key)
+int fscrypt_setup_v1_info_key(struct fscrypt_info *ci, const u8 *raw_master_key)
 {
 	if (ci->ci_policy.v1.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY)
-		return setup_v1_file_key_direct(ci, raw_master_key);
+		return setup_v1_info_key_direct(ci, raw_master_key);
 	else
-		return setup_v1_file_key_derived(ci, raw_master_key);
+		return setup_v1_info_key_derived(ci, raw_master_key);
 }
 
-int fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_info *ci)
+int fscrypt_setup_v1_info_key_via_subscribed_keyrings(struct fscrypt_info *ci)
 {
 	struct key *key;
 	const struct fscrypt_key *payload;
@@ -314,7 +314,7 @@ int fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_info *ci)
 	if (IS_ERR(key))
 		return PTR_ERR(key);
 
-	err = fscrypt_setup_v1_file_key(ci, payload->raw);
+	err = fscrypt_setup_v1_info_key(ci, payload->raw);
 	up_read(&key->sem);
 	key_put(key);
 	return err;
-- 
2.38.1

