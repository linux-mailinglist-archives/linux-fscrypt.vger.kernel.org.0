Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754B86DCBB9
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 21:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjDJTkl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 15:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjDJTkl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 15:40:41 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7AD1717
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 12:40:40 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 8BDE180527;
        Mon, 10 Apr 2023 15:40:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681155639; bh=5qI9lseYBOQjFI+MjnBOC8vBkDnenCRrDv0FmOHY7eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bx0xV9ixcn5EbYdXQXhQf95zmthH90XIAbiWIEdPeOPE7KOLnViJ5osk2PzFwfrT0
         j5irFmIsWY8dTar7BOiE28vjxw5I6ULjqJ3ZhyhWn0pju/UFWL8j8M8CdAytHECCmm
         HYIkzFfW3JttcoLktP7VDzHJ7lWxXb4bVEMwNkkzutdeu5DnSbOQ+1/LIxanLwf7bp
         cRIW6hS3WjxuNNqK7RVfiQSDm8c2d6HLrxkkG723iQlD1Nr5WYGFKklH6pE/IKthDh
         cK+EiYgU3IBxGxTmlkjjiNYvechnXlTbAC1EkCEuPwAp2H7lIt3NtZ6caX8cbGtnLC
         Ihq2/WuMjLDJg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 09/11] fscrypt: make prepared keys record their type.
Date:   Mon, 10 Apr 2023 15:40:02 -0400
Message-Id: <200f769192ef1e8291827164816b6497aef3526d.1681155143.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1681155143.git.sweettea-kernel@dorminy.me>
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
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

Right now fscrypt_infos have two fields dedicated solely to recording
what type of prepared key the info has: whether it solely owns the
prepared key, or has borrowed it from a master key, or from a direct
key.

This information doesn't change during the lifetime of a prepared key.
Since at worst there's a prepared key per info, and at best many infos
share a single prepared key, it is slightly more efficient to store this
ownership info in the prepared key instead of in the fscrypt_info.
Especially since we can squash both fields down into a single enum. This
will also make it easy to record that a prepared key is part of the
pooled prepared keys when extent-based encryption is used.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 28 ++++++++++++++++++++++------
 fs/crypto/keysetup.c        | 19 ++++++++++++-------
 fs/crypto/keysetup_v1.c     |  2 +-
 3 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index b575fb58a506..e726a1fb9f7e 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -174,18 +174,39 @@ struct fscrypt_symlink_data {
 	char encrypted_path[1];
 } __packed;
 
+/**
+ * enum fscrypt_prepared_key_type - records a prepared key's ownership
+ *
+ * @FSCRYPT_KEY_PER_INFO: this prepared key is allocated for a specific info
+ *		          and is never shared.
+ * @FSCRYPT_KEY_DIRECT_V1: this prepared key is embedded in a fscrypt_direct_key
+ *		           used in v1 direct key policies.
+ * @FSCRYPT_KEY_MASTER_KEY: this prepared key is a per-mode and policy key,
+ *			    part of a fscrypt_master_key, shared between all
+ *			    users of this master key having this mode and
+ *			    policy.
+ */
+enum fscrypt_prepared_key_type {
+	FSCRYPT_KEY_PER_INFO = 1,
+	FSCRYPT_KEY_DIRECT_V1,
+	FSCRYPT_KEY_MASTER_KEY,
+} __packed;
+
 /**
  * struct fscrypt_prepared_key - a key prepared for actual encryption/decryption
  * @tfm: crypto API transform object
  * @blk_key: key for blk-crypto
+ * @type: records the ownership type of the prepared key
  *
- * Normally only one of the fields will be non-NULL.
+ * Normally only one of @tfm and @blk_key will be non-NULL, although it is
+ * possible if @type is FSCRYPT_KEY_MASTER_KEY.
  */
 struct fscrypt_prepared_key {
 	struct crypto_skcipher *tfm;
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 	struct blk_crypto_key *blk_key;
 #endif
+	enum fscrypt_prepared_key_type type;
 };
 
 /*
@@ -233,11 +254,6 @@ struct fscrypt_info {
 	 */
 	struct list_head ci_master_key_link;
 
-	/*
-	 * If true, then encryption is done using the master key directly.
-	 */
-	bool ci_direct_key;
-
 	/*
 	 * This inode's hash key for filenames.  This is a 128-bit SipHash-2-4
 	 * key.  This is only set for directories that use a keyed dirhash over
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index d81001bf0a51..f338bb544932 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -185,11 +185,11 @@ void fscrypt_destroy_prepared_key(struct super_block *sb,
 /* Given a per-file encryption key, set up the file's crypto transform object */
 int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
 {
-	ci->ci_owns_key = true;
 	ci->ci_enc_key = kzalloc(sizeof(*ci->ci_enc_key), GFP_KERNEL);
 	if (!ci->ci_enc_key)
 		return -ENOMEM;
 
+	ci->ci_enc_key->type = FSCRYPT_KEY_PER_INFO;
 	return fscrypt_prepare_key(ci->ci_enc_key, raw_key, ci);
 }
 
@@ -284,6 +284,7 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 				  mode_key, mode->keysize);
 	if (err)
 		goto out_unlock;
+	prep_key->type = FSCRYPT_KEY_MASTER_KEY;
 	err = fscrypt_prepare_key(prep_key, mode_key, ci);
 	memzero_explicit(mode_key, mode->keysize);
 	if (err)
@@ -577,12 +578,16 @@ static void put_crypt_info(struct fscrypt_info *ci)
 	if (!ci)
 		return;
 
-	if (ci->ci_direct_key)
-		fscrypt_put_direct_key(ci->ci_enc_key);
-	else if (ci->ci_owns_key) {
-		fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
-					     ci->ci_enc_key);
-		kfree(ci->ci_enc_key);
+	if (ci->ci_enc_key) {
+		enum fscrypt_prepared_key_type type = ci->ci_enc_key->type;
+
+		if (type == FSCRYPT_KEY_DIRECT_V1)
+			fscrypt_put_direct_key(ci->ci_enc_key);
+		if (type == FSCRYPT_KEY_PER_INFO) {
+			fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
+						     ci->ci_enc_key);
+			kfree(ci->ci_enc_key);
+		}
 	}
 
 	mk = ci->ci_master_key;
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 09de84c65368..1e785cedead0 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -238,6 +238,7 @@ fscrypt_get_direct_key(const struct fscrypt_info *ci, const u8 *raw_key)
 	dk->dk_sb = ci->ci_inode->i_sb;
 	refcount_set(&dk->dk_refcount, 1);
 	dk->dk_mode = ci->ci_mode;
+	dk->dk_key.type = FSCRYPT_KEY_DIRECT_V1;
 	err = fscrypt_prepare_key(&dk->dk_key, raw_key, ci);
 	if (err)
 		goto err_free_dk;
@@ -261,7 +262,6 @@ static int setup_v1_file_key_direct(struct fscrypt_info *ci,
 	dk = fscrypt_get_direct_key(ci, raw_master_key);
 	if (IS_ERR(dk))
 		return PTR_ERR(dk);
-	ci->ci_direct_key = true;
 	ci->ci_enc_key = &dk->dk_key;
 	return 0;
 }
-- 
2.40.0

