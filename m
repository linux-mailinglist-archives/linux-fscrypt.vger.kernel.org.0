Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDBF6E712C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Apr 2023 04:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjDSCmb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 22:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjDSCma (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 22:42:30 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94E3619B
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 19:42:28 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 10EF480546;
        Tue, 18 Apr 2023 22:42:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681872148; bh=VKJi9NRErSIhRXxpg5LvzxbdnB6T7+0eLcLcYk7Cmcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOkUzoeoHbZHkdvjk2Te09fCnDV01rkTjVZowZTVo895m+qX+cACtf0PhzIAG9gIP
         J9dwIlVnHFfrn41utw8qhZm+t8oIxnqOGkZANvX+wS4sylUVEZuNO+mI6OciNWE88w
         pUNbJKfDjXbyf9jeUP0QztCAdQRkmG5v5Xkzu8xLJ4zdMwfWG/U+QDI4wQsiya9vKV
         QMl/jYqkqJx1HrU9geem0zCydOJbMnwCwFc3Vw4zzPz1lXWA5asYjfcpbEdUAqcYjZ
         vRhrdytVjetapbxUH5SfeG+0J4RUS6OK6aTPULo5KTArr3JGYKv5w5nsJ1Lmf+i69R
         9KSoSNVbtnF5w==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 3/7] fscrypt: add pooling of pooled prepared keys.
Date:   Tue, 18 Apr 2023 22:42:12 -0400
Message-Id: <f1b6d90f37ff8f3e1b1e3c51c288759d62e539a3.1681871298.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1681871298.git.sweettea-kernel@dorminy.me>
References: <cover.1681871298.git.sweettea-kernel@dorminy.me>
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

This change adds the actual infrastructure to set up prepared key pools.
It sets up one key pool per mode per master key, starting out with one
prepared key each. However, it continues to allocate a new prepared key
at each new relevant info creation, which is added to the relevant pool
and then immediately pulled back out for the info.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h |  17 +++
 fs/crypto/keyring.c         |   7 +
 fs/crypto/keysetup.c        | 273 +++++++++++++++++++++++++-----------
 3 files changed, 217 insertions(+), 80 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 143dc039bb03..86a5a7dbd3be 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -456,6 +456,19 @@ struct fscrypt_master_key_secret {
 
 } __randomize_layout;
 
+/*
+ * fscrypt_key_pool - a management structure which handles a number of opaque
+ * fscrypt_pooled_prepared_keys (in keysetup.c).
+ */
+struct fscrypt_key_pool {
+	/* Mutex protecting all the fields here */
+	struct mutex mutex;
+	/* A list of active keys */
+	struct list_head active_keys;
+	/* Inactive keys available for use */
+	struct list_head free_keys;
+};
+
 /*
  * fscrypt_master_key - an in-use master key
  *
@@ -545,6 +558,7 @@ struct fscrypt_master_key {
 	struct fscrypt_prepared_key mk_direct_keys[FSCRYPT_MODE_MAX + 1];
 	struct fscrypt_prepared_key mk_iv_ino_lblk_64_keys[FSCRYPT_MODE_MAX + 1];
 	struct fscrypt_prepared_key mk_iv_ino_lblk_32_keys[FSCRYPT_MODE_MAX + 1];
+	struct fscrypt_key_pool mk_key_pools[FSCRYPT_MODE_MAX + 1];
 
 	/* Hash key for inode numbers.  Initialized only when needed. */
 	siphash_key_t		mk_ino_hash_key;
@@ -624,6 +638,9 @@ struct fscrypt_mode {
 
 extern struct fscrypt_mode fscrypt_modes[];
 
+void fscrypt_init_key_pool(struct fscrypt_key_pool *pool, size_t mode_num);
+void fscrypt_destroy_key_pool(struct fscrypt_key_pool *pool);
+
 struct crypto_skcipher *fscrypt_get_contents_tfm(struct fscrypt_info *ci);
 
 int fscrypt_allocate_key_member(struct fscrypt_prepared_key *prep_key,
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 7cbb1fd872ac..a24cbf901faf 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -76,6 +76,10 @@ void fscrypt_put_master_key(struct fscrypt_master_key *mk)
 	WARN_ON_ONCE(refcount_read(&mk->mk_active_refs) != 0);
 	key_put(mk->mk_users);
 	mk->mk_users = NULL;
+
+	for (int i = 0; i <= FSCRYPT_MODE_MAX; i++)
+		fscrypt_destroy_key_pool(&mk->mk_key_pools[i]);
+
 	call_rcu(&mk->mk_rcu_head, fscrypt_free_master_key);
 }
 
@@ -429,6 +433,9 @@ static int add_new_master_key(struct super_block *sb,
 	INIT_LIST_HEAD(&mk->mk_decrypted_inodes);
 	spin_lock_init(&mk->mk_decrypted_inodes_lock);
 
+	for (size_t i = 0; i <= FSCRYPT_MODE_MAX; i++)
+		fscrypt_init_key_pool(&mk->mk_key_pools[i], i);
+
 	if (mk_spec->type == FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER) {
 		err = allocate_master_key_users_keyring(mk);
 		if (err)
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index c179a478020a..6e9f02620f18 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -90,7 +90,13 @@ struct fscrypt_mode fscrypt_modes[] = {
 static DEFINE_MUTEX(fscrypt_mode_key_setup_mutex);
 
 struct fscrypt_pooled_prepared_key {
+	/*
+	 * Must be held when the prep key is in use or the key is being
+	 * returned.
+	 */
+	struct mutex mutex;
 	struct fscrypt_prepared_key prep_key;
+	struct list_head pool_link;
 };
 
 /* Forward declaration so that all the prepared key handling can stay together */
@@ -125,69 +131,6 @@ static int lock_master_key(struct fscrypt_master_key *mk)
 	return 0;
 }
 
-static inline bool
-fscrypt_using_pooled_prepared_key(const struct fscrypt_info *ci)
-{
-	if (ci->ci_policy.version != FSCRYPT_POLICY_V2)
-		return false;
-	if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAGS_KEY_MASK)
-		return false;
-	if (fscrypt_using_inline_encryption(ci))
-		return false;
-
-	if (!S_ISREG(ci->ci_inode->i_mode))
-		return false;
-	return false;
-}
-
-/*
- * Prepare the crypto transform object or blk-crypto key in @prep_key, given the
- * raw key, encryption mode (@ci->ci_mode), flag indicating which encryption
- * implementation (fs-layer or blk-crypto) will be used (@ci->ci_inlinecrypt),
- * and IV generation method (@ci->ci_policy.flags). The relevant member must
- * already be allocated and set in @prep_key.
- */
-int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
-			const u8 *raw_key, const struct fscrypt_info *ci)
-{
-	int err;
-	bool inlinecrypt = fscrypt_using_inline_encryption(ci);
-
-	if (inlinecrypt) {
-		err = fscrypt_prepare_inline_crypt_key(prep_key, raw_key, ci);
-	} else {
-		err = crypto_skcipher_setkey(prep_key->tfm, raw_key,
-					     ci->ci_mode->keysize);
-	}
-
-	return err;
-}
-
-struct crypto_skcipher *fscrypt_get_contents_tfm(struct fscrypt_info *ci)
-{
-	int err;
-	struct fscrypt_master_key *mk = ci->ci_master_key;
-	unsigned int allocflags;
-
-	if (!fscrypt_using_pooled_prepared_key(ci))
-		return ci->ci_enc_key->tfm;
-
-	err = lock_master_key(mk);
-	if (err) {
-		up_read(&mk->mk_sem);
-		return ERR_PTR(err);
-	}
-
-	allocflags = memalloc_nofs_save();
-	err = fscrypt_setup_v2_file_key(ci, mk);
-	up_read(&mk->mk_sem);
-	memalloc_nofs_restore(allocflags);
-	if (err)
-		return ERR_PTR(err);
-
-	return ci->ci_enc_key->tfm;
-}
-
 /* Create a symmetric cipher object for the given encryption mode */
 static struct crypto_skcipher *
 fscrypt_allocate_skcipher(struct fscrypt_mode *mode,
@@ -230,6 +173,173 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode,
 	return ERR_PTR(err);
 }
 
+static inline bool
+fscrypt_using_pooled_prepared_key(const struct fscrypt_info *ci)
+{
+	if (ci->ci_policy.version != FSCRYPT_POLICY_V2)
+		return false;
+	if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAGS_KEY_MASK)
+		return false;
+	if (fscrypt_using_inline_encryption(ci))
+		return false;
+
+	if (!S_ISREG(ci->ci_inode->i_mode))
+		return false;
+	return false;
+}
+
+static void fscrypt_return_key_to_pool(struct fscrypt_key_pool *pool,
+				       struct fscrypt_pooled_prepared_key *key)
+{
+	mutex_lock(&pool->mutex);
+	list_move(&key->pool_link, &pool->free_keys);
+	mutex_unlock(&pool->mutex);
+}
+
+static int fscrypt_allocate_new_pooled_key(struct fscrypt_key_pool *pool,
+					   struct fscrypt_mode *mode)
+{
+	struct fscrypt_pooled_prepared_key *pooled_key;
+	struct crypto_skcipher *tfm;
+
+	pooled_key = kzalloc(sizeof(*pooled_key), GFP_KERNEL);
+	if (!pooled_key)
+		return -ENOMEM;
+
+	tfm = fscrypt_allocate_skcipher(mode, NULL);
+	if (IS_ERR(tfm)) {
+		kfree(pooled_key);
+		return PTR_ERR(tfm);
+	}
+
+	pooled_key->prep_key.tfm = tfm;
+	pooled_key->prep_key.type = FSCRYPT_KEY_POOLED;
+	mutex_init(&pooled_key->mutex);
+	INIT_LIST_HEAD(&pooled_key->pool_link);
+	fscrypt_return_key_to_pool(pool, pooled_key);
+	return 0;
+}
+
+/*
+ * Gets a key out of the free list, and locks it for use.
+ */
+static struct fscrypt_pooled_prepared_key *
+fscrypt_get_key_from_pool(struct fscrypt_key_pool *pool)
+{
+	struct fscrypt_pooled_prepared_key *key;
+
+	mutex_lock(&pool->mutex);
+	if (WARN_ON_ONCE(list_empty(&pool->free_keys))) {
+		mutex_unlock(&pool->mutex);
+		return ERR_PTR(-EBUSY);
+	}
+	key = list_first_entry(&pool->free_keys,
+			       struct fscrypt_pooled_prepared_key, pool_link);
+
+	list_move(&key->pool_link, &pool->active_keys);
+	mutex_unlock(&pool->mutex);
+	return key;
+}
+
+/*
+ * Do initial setup for a particular key pool, allocated as part of an array
+ */
+void fscrypt_init_key_pool(struct fscrypt_key_pool *pool, size_t modenum)
+{
+	struct fscrypt_mode *mode = &fscrypt_modes[modenum];
+
+	mutex_init(&pool->mutex);
+	INIT_LIST_HEAD(&pool->active_keys);
+	INIT_LIST_HEAD(&pool->free_keys);
+
+	/*
+	 * Always try to allocate one pooled key in
+	 * case we never have another opportunity. But if it doesn't succeed,
+	 * it's fine, we just need to never use the pool.
+	 */
+	fscrypt_allocate_new_pooled_key(pool, mode);
+}
+
+/*
+ * Destroy a particular key pool, allocated as part
+ * of an array, freeing all prepared keys within.
+ */
+void fscrypt_destroy_key_pool(struct fscrypt_key_pool *pool)
+{
+	struct fscrypt_pooled_prepared_key *tmp;
+
+	mutex_lock(&pool->mutex);
+	WARN_ON_ONCE(!list_empty(&pool->active_keys));
+	while (!list_empty(&pool->active_keys)) {
+		tmp = list_first_entry(&pool->active_keys,
+				       struct fscrypt_pooled_prepared_key,
+				       pool_link);
+		fscrypt_destroy_prepared_key(NULL, &tmp->prep_key);
+		list_del_init(&tmp->pool_link);
+		kfree(tmp);
+	}
+	while (!list_empty(&pool->free_keys)) {
+		tmp = list_first_entry(&pool->free_keys,
+				       struct fscrypt_pooled_prepared_key,
+				       pool_link);
+		fscrypt_destroy_prepared_key(NULL, &tmp->prep_key);
+		list_del_init(&tmp->pool_link);
+		kfree(tmp);
+	}
+	mutex_unlock(&pool->mutex);
+}
+
+/*
+ * Prepare the crypto transform object or blk-crypto key in @prep_key, given the
+ * raw key, encryption mode (@ci->ci_mode), flag indicating which encryption
+ * implementation (fs-layer or blk-crypto) will be used (@ci->ci_inlinecrypt),
+ * and IV generation method (@ci->ci_policy.flags). The relevant member must
+ * already be allocated and set in @prep_key.
+ */
+int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
+			const u8 *raw_key, const struct fscrypt_info *ci)
+{
+	int err;
+	bool inlinecrypt = fscrypt_using_inline_encryption(ci);
+
+	if (inlinecrypt) {
+		err = fscrypt_prepare_inline_crypt_key(prep_key, raw_key, ci);
+	} else {
+		err = crypto_skcipher_setkey(prep_key->tfm, raw_key,
+					     ci->ci_mode->keysize);
+	}
+
+	return err;
+}
+
+struct crypto_skcipher *fscrypt_get_contents_tfm(struct fscrypt_info *ci)
+{
+	int err;
+	struct fscrypt_master_key *mk = ci->ci_master_key;
+	unsigned int allocflags;
+
+	if (!fscrypt_using_pooled_prepared_key(ci))
+		return ci->ci_enc_key->tfm;
+
+	if (ci->ci_enc_key)
+		return ci->ci_enc_key->tfm;
+
+	err = lock_master_key(mk);
+	if (err) {
+		up_read(&mk->mk_sem);
+		return ERR_PTR(err);
+	}
+
+	allocflags = memalloc_nofs_save();
+	err = fscrypt_setup_v2_file_key(ci, mk);
+	up_read(&mk->mk_sem);
+	memalloc_nofs_restore(allocflags);
+	if (err)
+		return ERR_PTR(err);
+
+	return ci->ci_enc_key->tfm;
+}
+
 /* Allocate the relevant encryption member for the prepared key */
 int fscrypt_allocate_key_member(struct fscrypt_prepared_key *prep_key,
 				const struct fscrypt_info *ci)
@@ -262,23 +372,19 @@ int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
 
 	if (fscrypt_using_pooled_prepared_key(ci)) {
 		struct fscrypt_pooled_prepared_key *pooled_key;
+		struct fscrypt_master_key *mk = ci->ci_master_key;
+		const u8 mode_num = ci->ci_mode - fscrypt_modes;
+		struct fscrypt_key_pool *pool = &mk->mk_key_pools[mode_num];
 
-		if (ci->ci_enc_key)
-			return fscrypt_prepare_key(ci->ci_enc_key, raw_key, ci);
-
-		pooled_key = kzalloc(sizeof(*pooled_key), GFP_KERNEL);
-		if (!pooled_key)
-			return -ENOMEM;
-
-		err = fscrypt_allocate_key_member(&pooled_key->prep_key, ci);
-		if (err) {
-			kfree(pooled_key);
+		err = fscrypt_allocate_new_pooled_key(pool, ci->ci_mode);
+		if (err)
 			return err;
-		}
 
-		pooled_key->prep_key.type = FSCRYPT_KEY_POOLED;
+		pooled_key = fscrypt_get_key_from_pool(pool);
+		if (IS_ERR(pooled_key))
+			return PTR_ERR(pooled_key);
+
 		ci->ci_enc_key = &pooled_key->prep_key;
-		return 0;
 	} else {
 		ci->ci_enc_key = kzalloc(sizeof(*ci->ci_enc_key), GFP_KERNEL);
 		if (!ci->ci_enc_key)
@@ -527,6 +633,10 @@ static int fscrypt_setup_file_key(struct fscrypt_info *ci,
 {
 	int err;
 
+	if (fscrypt_using_pooled_prepared_key(ci)) {
+		return 0;
+	}
+
 	if (!mk) {
 		if (ci->ci_policy.version != FSCRYPT_POLICY_V1)
 			return -ENOKEY;
@@ -674,6 +784,8 @@ static void put_crypt_info(struct fscrypt_info *ci)
 	if (!ci)
 		return;
 
+	mk = ci->ci_master_key;
+
 	if (ci->ci_enc_key) {
 		enum fscrypt_prepared_key_type type = ci->ci_enc_key->type;
 
@@ -686,18 +798,19 @@ static void put_crypt_info(struct fscrypt_info *ci)
 		}
 		if (type == FSCRYPT_KEY_POOLED) {
 			struct fscrypt_pooled_prepared_key *pooled_key;
+			const u8 mode_num = ci->ci_mode - fscrypt_modes;
 
 			pooled_key = container_of(ci->ci_enc_key,
 						  struct fscrypt_pooled_prepared_key,
 						  prep_key);
 
-			fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
-						     ci->ci_enc_key);
-			kfree_sensitive(pooled_key);
+			fscrypt_return_key_to_pool(&mk->mk_key_pools[mode_num],
+						   pooled_key);
+			ci->ci_enc_key = NULL;
 		}
 	}
 
-	mk = ci->ci_master_key;
+
 	if (mk) {
 		/*
 		 * Remove this inode from the list of inodes that were unlocked
-- 
2.40.0

