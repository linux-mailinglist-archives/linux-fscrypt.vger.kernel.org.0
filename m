Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5970B6E7130
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Apr 2023 04:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjDSCmh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 22:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjDSCmg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 22:42:36 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC3C6193
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 19:42:35 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 1E07180529;
        Tue, 18 Apr 2023 22:42:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681872155; bh=RQHMYnEA2bheNhtrp3LAHwHT0N8EYZ5uzLFJsZD4ZDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZx4j55XroOt2x8IkQHGrS5u7VRh9R6KwCaUL89hLhR26yTY+xgy5v+1Gt/NAxhUf
         Bgjzf1Bkr7rz36+7hobC1hkd/6l6KlmsybZolfENFTF81JXWLapWBb0+3zCNPOCj7d
         jINuBDDi7Rnpps6jeeyIf32oxmylETXRrbR3bhHFrsKwEYaBsyggEo5lOb0ZlRp/jF
         w/VOEy2RW3cW9GYw2TUelZqXXYc9K3hirEJ2bmITxEDKguc+/lodnBB69TXX6w6O86
         xlc+5ESBXQCNW8yj3RcZ8RPx8rM0sSxZjbsr7WpTj0XcZjzy8Fowz9fiuP4ReD1lVj
         FSIWkuKoiGvQQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 7/7] fscrypt: add lru mechanism to choose pooled key
Date:   Tue, 18 Apr 2023 22:42:16 -0400
Message-Id: <116883701e4763dbe2a81d39b36bb0d3aa0b2149.1681871298.git.sweettea-kernel@dorminy.me>
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

This improves the previous mechanism to select a key to steal: it keeps
track of the LRU active key, and steals that one. While the previous
mechanism isn't an invalid strategy, it is probably inferior and results
in excessive churn in very active keys.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h |  6 +++++-
 fs/crypto/keysetup.c        | 39 ++++++++++++++++++++++++++++++++++---
 2 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index cc6e4a2a942c..c23b222ca30b 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -461,7 +461,7 @@ struct fscrypt_master_key_secret {
  * fscrypt_pooled_prepared_keys (in keysetup.c).
  */
 struct fscrypt_key_pool {
-	/* Mutex protecting all the fields here */
+	/* Mutex protecting almost everything */
 	struct mutex mutex;
 	/* A list of active keys */
 	struct list_head active_keys;
@@ -471,6 +471,10 @@ struct fscrypt_key_pool {
 	size_t count;
 	/* Count of keys desired. Oft equal to count, but can be less. */
 	size_t desired;
+	/* Mutex protecting the lru list*/
+	struct mutex lru_mutex;
+	/* Same list of active keys, just ordered by usage. Head is oldest. */
+	struct list_head active_lru;
 };
 
 /*
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 57c343b78abc..d498b89cd097 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -92,11 +92,13 @@ static DEFINE_MUTEX(fscrypt_mode_key_setup_mutex);
 struct fscrypt_pooled_prepared_key {
 	/*
 	 * Must be held when the prep key is in use or the key is being
-	 * returned.
+	 * returned. Must not be held for interactions with pool_link and
+	 * pool_lru_link, which are protected by the pool locks.
 	 */
 	struct mutex mutex;
 	struct fscrypt_prepared_key prep_key;
 	struct list_head pool_link;
+	struct list_head pool_lru_link;
 	/* NULL when it's in the pool. */
 	struct fscrypt_info *owner;
 };
@@ -201,6 +203,18 @@ get_pooled_key_owner(struct fscrypt_pooled_prepared_key *key)
 	return smp_load_acquire(&key->owner);
 }
 
+/*
+ * Must be called with the key lock held and the pool lock not held.
+ */
+static void update_lru(struct fscrypt_key_pool *pool,
+		       struct fscrypt_pooled_prepared_key *key)
+{
+	mutex_lock(&pool->lru_mutex);
+	/* Bump this key up to the most recent end of the pool's lru list. */
+	list_move_tail(&pool->active_lru, &key->pool_lru_link);
+	mutex_unlock(&pool->lru_mutex);
+}
+
 /*
  * Lock the prepared key currently in ci->ci_enc_key, if it hasn't been stolen
  * for the use of some other ci. Once this function succeeds, the prepared
@@ -215,6 +229,9 @@ static int fscrypt_lock_pooled_key(struct fscrypt_info *ci)
 	struct fscrypt_pooled_prepared_key *pooled_key =
 		container_of(ci->ci_enc_key, struct fscrypt_pooled_prepared_key,
 			     prep_key);
+	struct fscrypt_master_key *mk = ci->ci_master_key;
+	const u8 mode_num = ci->ci_mode - fscrypt_modes;
+	struct fscrypt_key_pool *pool = &mk->mk_key_pools[mode_num];
 
 	/* Peek to see if someone's definitely stolen the pooled key */
 	if (get_pooled_key_owner(pooled_key) != ci)
@@ -233,6 +250,8 @@ static int fscrypt_lock_pooled_key(struct fscrypt_info *ci)
 		goto stolen;
 	}
 
+	update_lru(pool, pooled_key);
+
 	return 0;
 
 stolen:
@@ -270,12 +289,16 @@ static void __fscrypt_free_one_free_key(struct fscrypt_key_pool *pool)
 	pool->count--;
 }
 
+/* Must be called with the pool mutex held. Releases it. */
 static void __fscrypt_return_key_to_pool(struct fscrypt_key_pool *pool,
 					 struct fscrypt_pooled_prepared_key *key)
 {
 	/* Pairs with the acquire in get_pooled_key_owner() */
 	smp_store_release(&key->owner, NULL);
 	list_move(&key->pool_link, &pool->free_keys);
+	mutex_lock(&pool->lru_mutex);
+	list_del_init(&key->pool_lru_link);
+	mutex_unlock(&pool->lru_mutex);
 	mutex_unlock(&key->mutex);
 	if (pool->count > pool->desired)
 		__fscrypt_free_one_free_key(pool);
@@ -323,6 +346,7 @@ static int fscrypt_allocate_new_pooled_key(struct fscrypt_key_pool *pool,
 	pooled_key->prep_key.type = FSCRYPT_KEY_POOLED;
 	mutex_init(&pooled_key->mutex);
 	INIT_LIST_HEAD(&pooled_key->pool_link);
+	INIT_LIST_HEAD(&pooled_key->pool_lru_link);
 	mutex_lock(&pool->mutex);
 	pool->count++;
 	pool->desired++;
@@ -334,8 +358,15 @@ static int fscrypt_allocate_new_pooled_key(struct fscrypt_key_pool *pool,
 static struct fscrypt_pooled_prepared_key *
 fscrypt_select_victim_key(struct fscrypt_key_pool *pool)
 {
-	return list_first_entry(&pool->active_keys,
-				struct fscrypt_pooled_prepared_key, pool_link);
+	struct fscrypt_pooled_prepared_key *key;
+
+	mutex_lock(&pool->lru_mutex);
+	key = list_first_entry(&pool->active_lru,
+			       struct fscrypt_pooled_prepared_key,
+			       pool_lru_link);
+	list_del_init(&key->pool_lru_link);
+	mutex_unlock(&pool->lru_mutex);
+	return key;
 }
 
 static void fscrypt_steal_an_active_key(struct fscrypt_key_pool *pool)
@@ -399,7 +430,9 @@ void fscrypt_init_key_pool(struct fscrypt_key_pool *pool, size_t modenum)
 	struct fscrypt_mode *mode = &fscrypt_modes[modenum];
 
 	mutex_init(&pool->mutex);
+	mutex_init(&pool->lru_mutex);
 	INIT_LIST_HEAD(&pool->active_keys);
+	INIT_LIST_HEAD(&pool->active_lru);
 	INIT_LIST_HEAD(&pool->free_keys);
 
 	/*
-- 
2.40.0

