Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8656D6E6A7A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Apr 2023 19:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjDRRFG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 13:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjDRRFG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 13:05:06 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2318A7F
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 10:05:04 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 191E18262C;
        Tue, 18 Apr 2023 13:05:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681837504; bh=ORVmwNqbQKLCskjvXLbGb7Ibv0eWPRiWJyuZGGvLDAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuDlvRAkqGs96cizX9kvcRFFL/XvLDQdku+d5HTqMuIu/KMcDJjZ+BWAsAi2cbivD
         ZwYHNf+vMgxaM6hJZr6BOHHyKt/CSxUgld+vmyrl9sCOzCFftccRTonD259n3Jkapm
         7u5Oft7gbV9+oAxB1pe+rY1hmkWnnIps6w+dBxEHj0wHnXMdVTATdMVHN4L48KUTcy
         HXEBXqvXUts950HWZ4/zoElSQpK8YsxuTKAiYRVuDdQYjGk+PW7blveCXHtsanxORA
         7OX+lgw5MVSxYgMhwT3GJWT0ZUlC01On0V/gMqR3RpkHCu7EpiaQkBQrXk4EyzpduL
         Y2iMMS9EIehLQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 09/11] fscrypt: lock every time a info needs a mode key
Date:   Tue, 18 Apr 2023 13:04:34 -0400
Message-Id: <26631684ca79332e0c2fa57f6246c703d017637f.1681837291.git.sweettea-kernel@dorminy.me>
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

Currently, the non-NULL status of the sub-fields of the prepared key are
used as booleans indicating whether the prepared key is ready for use.
However, when allocation and preparation of prepared keys are split, the
fields are set before the key is ready for use, so some other mechanism
is needed.

Since per-mode keys are not that common, if an info is using a per-mode
key, just grab the setup mutex to check whether the key is set up. Since
the setup mutex is held during key set up, this keeps any info from
observing a half-setup key.

If lock contention becomes an issue, the setup mutex could be split by
policy or by mode+policy in the future.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 20 ++++++--------------
 fs/crypto/inline_crypt.c    |  8 +-------
 fs/crypto/keysetup.c        | 26 +++++++-------------------
 fs/crypto/keysetup_v1.c     |  2 +-
 4 files changed, 15 insertions(+), 41 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index e726a1fb9f7e..46a756c8a66f 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -367,20 +367,12 @@ void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
  * @prep_key, depending on which encryption implementation the file will use.
  */
 static inline bool
-fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
+fscrypt_is_key_allocated(struct fscrypt_prepared_key *prep_key,
 			const struct fscrypt_info *ci)
 {
-	/*
-	 * The two smp_load_acquire()'s here pair with the smp_store_release()'s
-	 * in fscrypt_prepare_inline_crypt_key() and fscrypt_prepare_key().
-	 * I.e., in some cases (namely, if this prep_key is a per-mode
-	 * encryption key) another task can publish blk_key or tfm concurrently,
-	 * executing a RELEASE barrier.  We need to use smp_load_acquire() here
-	 * to safely ACQUIRE the memory the other task published.
-	 */
 	if (fscrypt_using_inline_encryption(ci))
-		return smp_load_acquire(&prep_key->blk_key) != NULL;
-	return smp_load_acquire(&prep_key->tfm) != NULL;
+		return prep_key->blk_key != NULL;
+	return prep_key->tfm != NULL;
 }
 
 #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
@@ -412,10 +404,10 @@ fscrypt_destroy_inline_crypt_key(struct super_block *sb,
 }
 
 static inline bool
-fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
-			const struct fscrypt_info *ci)
+fscrypt_is_key_allocated(struct fscrypt_prepared_key *prep_key,
+			 const struct fscrypt_info *ci)
 {
-	return smp_load_acquire(&prep_key->tfm) != NULL;
+	return prep_key->tfm != NULL;
 }
 #endif /* !CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 2063f7941ce6..ce952dedba77 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -191,13 +191,7 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 		goto fail;
 	}
 
-	/*
-	 * Pairs with the smp_load_acquire() in fscrypt_is_key_prepared().
-	 * I.e., here we publish ->blk_key with a RELEASE barrier so that
-	 * concurrent tasks can ACQUIRE it.  Note that this concurrency is only
-	 * possible for per-mode keys, not for per-file keys.
-	 */
-	smp_store_release(&prep_key->blk_key, blk_key);
+	prep_key->blk_key = blk_key;
 	return 0;
 
 fail:
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 3c5ab1349247..a5f23b996a23 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -169,13 +169,7 @@ int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 	tfm = fscrypt_allocate_skcipher(ci->ci_mode, raw_key, ci->ci_inode);
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
-	/*
-	 * Pairs with the smp_load_acquire() in fscrypt_is_key_prepared().
-	 * I.e., here we publish ->tfm with a RELEASE barrier so that
-	 * concurrent tasks can ACQUIRE it.  Note that this concurrency is only
-	 * possible for per-mode keys, not for per-file keys.
-	 */
-	smp_store_release(&prep_key->tfm, tfm);
+	prep_key->tfm = tfm;
 	return 0;
 }
 
@@ -276,10 +270,6 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 	 * encryption hardware compliant with the UFS standard.
 	 */
 
-	mutex_lock(&fscrypt_mode_key_setup_mutex);
-
-	if (fscrypt_is_key_prepared(prep_key, ci))
-		goto out_unlock;
 
 	BUILD_BUG_ON(sizeof(mode_num) != 1);
 	BUILD_BUG_ON(sizeof(sb->s_uuid) != 16);
@@ -290,13 +280,11 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 				  hkdf_context, hkdf_info, hkdf_infolen,
 				  mode_key, mode->keysize);
 	if (err)
-		goto out_unlock;
+		return err;
 	prep_key->type = FSCRYPT_KEY_MASTER_KEY;
 	err = fscrypt_prepare_key(prep_key, mode_key, ci);
 	memzero_explicit(mode_key, mode->keysize);
 
-out_unlock:
-	mutex_unlock(&fscrypt_mode_key_setup_mutex);
 	return err;
 }
 
@@ -315,11 +303,11 @@ static int setup_mode_prepared_key(struct fscrypt_info *ci,
 	if (IS_ERR(prep_key))
 		return PTR_ERR(prep_key);
 
-	if (fscrypt_is_key_prepared(prep_key, ci)) {
-		ci->ci_enc_key = prep_key;
-		return 0;
-	}
-	err = setup_new_mode_prepared_key(mk, prep_key, ci);
+	mutex_lock(&fscrypt_mode_key_setup_mutex);
+	if (!fscrypt_is_key_allocated(prep_key, ci))
+		err = setup_new_mode_prepared_key(mk, prep_key, ci);
+
+	mutex_unlock(&fscrypt_mode_key_setup_mutex);
 	if (err)
 		return err;
 
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 1e785cedead0..119e80d6e81f 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -203,7 +203,7 @@ find_or_insert_direct_key(struct fscrypt_direct_key *to_insert,
 			continue;
 		if (ci->ci_mode != dk->dk_mode)
 			continue;
-		if (!fscrypt_is_key_prepared(&dk->dk_key, ci))
+		if (!fscrypt_is_key_allocated(&dk->dk_key, ci))
 			continue;
 		if (crypto_memneq(raw_key, dk->dk_raw, ci->ci_mode->keysize))
 			continue;
-- 
2.40.0

