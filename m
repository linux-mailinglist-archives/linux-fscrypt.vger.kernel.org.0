Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B226E712D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Apr 2023 04:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjDSCmd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 22:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjDSCmc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 22:42:32 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7946658E
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 19:42:30 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id C5D5F80530;
        Tue, 18 Apr 2023 22:42:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681872150; bh=Cp0xXopDD+XJKz9rNS1FCkH0sHqNmuYJe9ZrIk4JWkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubYgP+qr9IFa05yqLAHuAcDzLOjuEcW/jA/fGQfeEXOwydEBVpKVIITEKihNGzmoz
         ozX4as+IuS3sfq0KKAeEIb7rN6wj4MezGlFHWSsNOZmzIn91vuWS/YO19GEIEvtn9j
         ROH8KFz5ev/CxUZKMZTVrXor0q1v523B0vu1pq2zGYSg2zeEWOrUPNqrUE+iZjcFNv
         6iJFvILcDLxFwUo62e+rwo1VnxfIjM5UNrx21JMrPQnDak3hd/ay2OUOrNOe6v52rE
         YI/LTd4XdOs8Di4wsA7ArwhupIKaEnqJUC0xaVm2Ygx1zfKhYPLA+BCoMQsZPmjSei
         MKRpIUiaXL8IA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 4/7] fscrypt: add pooled prepared key locking around use
Date:   Tue, 18 Apr 2023 22:42:13 -0400
Message-Id: <5dcbbc23cd327b0700a316dff411ff38e539d808.1681871298.git.sweettea-kernel@dorminy.me>
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

So far the prepared key pools have no provision for running out of
prepared keys. However, it is necessary to add some mechanism to request
some infos free their pooled prepared key in response to pool pressure,
and in order to do that, we must add a per-pooled-prepared-key facility
to mark the critical region where the info can't tolerate losing its
prepared key.

Thus, add locking to infos using pooled keys around the time when the
key is actually in use. This doesn't actually add stealing a prepared
key from an existing info, but prepares to do so.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c          |  24 +++--
 fs/crypto/fscrypt_private.h |   1 +
 fs/crypto/keysetup.c        | 173 ++++++++++++++++++++++++++++--------
 3 files changed, 153 insertions(+), 45 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 91ef520a9961..6b1b0953e7cc 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -113,16 +113,22 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
-	if (WARN_ON_ONCE(len <= 0))
-		return -EINVAL;
-	if (WARN_ON_ONCE(len % FSCRYPT_CONTENTS_ALIGNMENT != 0))
-		return -EINVAL;
 
+	if (WARN_ON_ONCE(len <= 0)) {
+		res = -EINVAL;
+		goto unlock;
+	}
+	if (WARN_ON_ONCE(len % FSCRYPT_CONTENTS_ALIGNMENT != 0)) {
+		res = -EINVAL;
+		goto unlock;
+	}
 	fscrypt_generate_iv(&iv, lblk_num, ci);
 
 	req = skcipher_request_alloc(tfm, gfp_flags);
-	if (!req)
-		return -ENOMEM;
+	if (!req) {
+		res = -ENOMEM;
+		goto unlock;
+	}
 
 	skcipher_request_set_callback(
 		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
@@ -141,9 +147,11 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 	if (res) {
 		fscrypt_err(inode, "%scryption failed for block %llu: %d",
 			    (rw == FS_DECRYPT ? "De" : "En"), lblk_num, res);
-		return res;
 	}
-	return 0;
+
+unlock:
+	fscrypt_unlock_key_if_pooled(ci);
+	return res;
 }
 
 /**
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 86a5a7dbd3be..2737545ce4a6 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -642,6 +642,7 @@ void fscrypt_init_key_pool(struct fscrypt_key_pool *pool, size_t mode_num);
 void fscrypt_destroy_key_pool(struct fscrypt_key_pool *pool);
 
 struct crypto_skcipher *fscrypt_get_contents_tfm(struct fscrypt_info *ci);
+void fscrypt_unlock_key_if_pooled(struct fscrypt_info *ci);
 
 int fscrypt_allocate_key_member(struct fscrypt_prepared_key *prep_key,
 				const struct fscrypt_info *ci);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 6e9f02620f18..aed60280ad32 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -97,6 +97,8 @@ struct fscrypt_pooled_prepared_key {
 	struct mutex mutex;
 	struct fscrypt_prepared_key prep_key;
 	struct list_head pool_link;
+	/* NULL when it's in the pool. */
+	struct fscrypt_info *owner;
 };
 
 /* Forward declaration so that all the prepared key handling can stay together */
@@ -188,12 +190,96 @@ fscrypt_using_pooled_prepared_key(const struct fscrypt_info *ci)
 	return false;
 }
 
-static void fscrypt_return_key_to_pool(struct fscrypt_key_pool *pool,
-				       struct fscrypt_pooled_prepared_key *key)
+static struct fscrypt_info *
+get_pooled_key_owner(struct fscrypt_pooled_prepared_key *key)
 {
-	mutex_lock(&pool->mutex);
+	/*
+	 * Pairs with the smp_store_release() in fscrypt_get_key_from_pool()
+	 * and __fscrypt_return_key_to_pool() below. The owner is
+	 * potentially unstable unless the key's lock is taken.
+	 */
+	return smp_load_acquire(&key->owner);
+}
+
+/*
+ * Lock the prepared key currently in ci->ci_enc_key, if it hasn't been stolen
+ * for the use of some other ci. Once this function succeeds, the prepared
+ * key cannot be stolen by another ci until fscrypt_unlock_key_if_pooled() is
+ * called.
+ *
+ * Returns 0 if the lock was successful, -ESTALE if the pooled key is now owned
+ * by some other ci (and ci->ci_enc_key is reset to NULL)
+ */
+static int fscrypt_lock_pooled_key(struct fscrypt_info *ci)
+{
+	struct fscrypt_pooled_prepared_key *pooled_key =
+		container_of(ci->ci_enc_key, struct fscrypt_pooled_prepared_key,
+			     prep_key);
+
+	/* Peek to see if someone's definitely stolen the pooled key */
+	if (get_pooled_key_owner(pooled_key) != ci)
+		goto stolen;
+
+	/*
+	 * Try to grab the lock. If we don't immediately succeed, some other
+	 * ci has stolen the key.
+	 */
+	if (!mutex_trylock(&pooled_key->mutex))
+		goto stolen;
+
+	/* We got the lock! Make sure we're still the owner. */
+	if (get_pooled_key_owner(pooled_key) != ci) {
+		mutex_unlock(&pooled_key->mutex);
+		goto stolen;
+	}
+
+	return 0;
+
+stolen:
+	ci->ci_enc_key = NULL;
+	return -ESTALE;
+}
+
+void fscrypt_unlock_key_if_pooled(struct fscrypt_info *ci)
+{
+	struct fscrypt_pooled_prepared_key *pooled_key;
+
+	if (!fscrypt_using_pooled_prepared_key(ci))
+		return;
+
+	pooled_key = container_of(ci->ci_enc_key,
+				  struct fscrypt_pooled_prepared_key,
+				  prep_key);
+
+	mutex_unlock(&pooled_key->mutex);
+}
+
+static void __fscrypt_return_key_to_pool(struct fscrypt_key_pool *pool,
+					 struct fscrypt_pooled_prepared_key *key)
+{
+	/* Pairs with the acquire in get_pooled_key_owner() */
+	smp_store_release(&key->owner, NULL);
 	list_move(&key->pool_link, &pool->free_keys);
 	mutex_unlock(&pool->mutex);
+	mutex_unlock(&key->mutex);
+}
+
+static void fscrypt_return_key_to_pool(struct fscrypt_info *ci)
+{
+	struct fscrypt_pooled_prepared_key *pooled_key;
+	const u8 mode_num = ci->ci_mode - fscrypt_modes;
+	struct fscrypt_master_key *mk = ci->ci_master_key;
+
+	mutex_lock(&pool->mutex);
+	/* Try to lock the key. If we don't, it's already been stolen. */
+	if (fscrypt_lock_pooled_key(ci) != 0)
+		return;
+
+	pooled_key = container_of(ci->ci_enc_key,
+				  struct fscrypt_pooled_prepared_key,
+				  prep_key);
+
+	__fscrypt_return_key_to_pool(&mk->mk_key_pools[mode_num], pooled_key);
 }
 
 static int fscrypt_allocate_new_pooled_key(struct fscrypt_key_pool *pool,
@@ -216,29 +302,34 @@ static int fscrypt_allocate_new_pooled_key(struct fscrypt_key_pool *pool,
 	pooled_key->prep_key.type = FSCRYPT_KEY_POOLED;
 	mutex_init(&pooled_key->mutex);
 	INIT_LIST_HEAD(&pooled_key->pool_link);
-	fscrypt_return_key_to_pool(pool, pooled_key);
+	mutex_lock(&pooled_key->mutex);
+	__fscrypt_return_key_to_pool(pool, pooled_key);
 	return 0;
 }
 
 /*
  * Gets a key out of the free list, and locks it for use.
  */
-static struct fscrypt_pooled_prepared_key *
-fscrypt_get_key_from_pool(struct fscrypt_key_pool *pool)
+static int fscrypt_get_key_from_pool(struct fscrypt_key_pool *pool,
+				     struct fscrypt_info *ci)
 {
 	struct fscrypt_pooled_prepared_key *key;
 
 	mutex_lock(&pool->mutex);
 	if (WARN_ON_ONCE(list_empty(&pool->free_keys))) {
 		mutex_unlock(&pool->mutex);
-		return ERR_PTR(-EBUSY);
+		return -EBUSY;
 	}
 	key = list_first_entry(&pool->free_keys,
 			       struct fscrypt_pooled_prepared_key, pool_link);
 
+	/* Pairs with the acquire in get_pooled_key_owner() */
+	smp_store_release(&key->owner, ci);
+	ci->ci_enc_key = &key->prep_key;
 	list_move(&key->pool_link, &pool->active_keys);
+
 	mutex_unlock(&pool->mutex);
-	return key;
+	return 0;
 }
 
 /*
@@ -317,12 +408,22 @@ struct crypto_skcipher *fscrypt_get_contents_tfm(struct fscrypt_info *ci)
 	int err;
 	struct fscrypt_master_key *mk = ci->ci_master_key;
 	unsigned int allocflags;
+	const u8 mode_num = ci->ci_mode - fscrypt_modes;
+	struct fscrypt_key_pool *pool = &mk->mk_key_pools[mode_num];
 
 	if (!fscrypt_using_pooled_prepared_key(ci))
 		return ci->ci_enc_key->tfm;
 
-	if (ci->ci_enc_key)
-		return ci->ci_enc_key->tfm;
+	/* do we need to set it up? */
+	if (!ci->ci_enc_key)
+		goto lock_for_new_key;
+
+	if (fscrypt_lock_pooled_key(ci) != 0)
+		goto lock_for_new_key;
+
+	return ci->ci_enc_key->tfm;
+
+lock_for_new_key:
 
 	err = lock_master_key(mk);
 	if (err) {
@@ -330,6 +431,17 @@ struct crypto_skcipher *fscrypt_get_contents_tfm(struct fscrypt_info *ci)
 		return ERR_PTR(err);
 	}
 
+setup_new_key:
+	err = fscrypt_get_key_from_pool(pool, ci);
+	if (err) {
+		up_read(&mk->mk_sem);
+		return ERR_PTR(err);
+	}
+
+	/* Make sure nobody stole our fresh key already */
+	if (fscrypt_lock_pooled_key(ci) != 0)
+		goto setup_new_key;
+
 	allocflags = memalloc_nofs_save();
 	err = fscrypt_setup_v2_file_key(ci, mk);
 	up_read(&mk->mk_sem);
@@ -371,20 +483,6 @@ int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
 	int err;
 
 	if (fscrypt_using_pooled_prepared_key(ci)) {
-		struct fscrypt_pooled_prepared_key *pooled_key;
-		struct fscrypt_master_key *mk = ci->ci_master_key;
-		const u8 mode_num = ci->ci_mode - fscrypt_modes;
-		struct fscrypt_key_pool *pool = &mk->mk_key_pools[mode_num];
-
-		err = fscrypt_allocate_new_pooled_key(pool, ci->ci_mode);
-		if (err)
-			return err;
-
-		pooled_key = fscrypt_get_key_from_pool(pool);
-		if (IS_ERR(pooled_key))
-			return PTR_ERR(pooled_key);
-
-		ci->ci_enc_key = &pooled_key->prep_key;
 	} else {
 		ci->ci_enc_key = kzalloc(sizeof(*ci->ci_enc_key), GFP_KERNEL);
 		if (!ci->ci_enc_key)
@@ -797,16 +895,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
 			kfree_sensitive(ci->ci_enc_key);
 		}
 		if (type == FSCRYPT_KEY_POOLED) {
-			struct fscrypt_pooled_prepared_key *pooled_key;
-			const u8 mode_num = ci->ci_mode - fscrypt_modes;
-
-			pooled_key = container_of(ci->ci_enc_key,
-						  struct fscrypt_pooled_prepared_key,
-						  prep_key);
-
-			fscrypt_return_key_to_pool(&mk->mk_key_pools[mode_num],
-						   pooled_key);
-			ci->ci_enc_key = NULL;
+			fscrypt_return_key_to_pool(ci);
 		}
 	}
 
@@ -866,9 +955,19 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (res)
 		goto out;
 
-	res = fscrypt_setup_file_key(crypt_info, mk);
-	if (res)
-		goto out;
+	if (!fscrypt_using_pooled_prepared_key(crypt_info)) {
+		res = fscrypt_setup_file_key(crypt_info, mk);
+		if (res)
+			goto out;
+	} else {
+		const u8 mode_num = mode - fscrypt_modes;
+		struct fscrypt_key_pool *pool = &mk->mk_key_pools[mode_num];
+
+		res = fscrypt_allocate_new_pooled_key(pool, mode);
+		if (res)
+			return res;
+	}
+
 
 	/*
 	 * Derive a secret dirhash key for directories that need it. It
-- 
2.40.0

