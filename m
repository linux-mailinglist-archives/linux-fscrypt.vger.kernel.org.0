Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B626E712E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Apr 2023 04:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbjDSCmd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 22:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbjDSCmd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 22:42:33 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC656193
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 19:42:31 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 6C1DA80528;
        Tue, 18 Apr 2023 22:42:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681872151; bh=DCuGe2EMfqw30Uyiyal3MXPhj3fD0ZmeexLJI5ywca0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJKKnuRId3nibXmqvzXR0BLC5snrURRR/znABLR0QXizVShRhctbD2xlw7ZICRDX0
         wx423HS2/xzyW5DzoMGxZkHo3EOYxAJ28nYBEPEfnH9XxQqksXo2Jt5gzWL01LYWjf
         sWJ8VsLvg3PD7vSYRoqVOMv/N0826EvylHTmEpYY6vc5Analf10qCHzhikLv7Fan1G
         g0PNIhZlPAbecOslaGemI4uft1dNeJVibShIT/L4VpO56Lo/n+CFxxSWEK+/zsfTg7
         K9PzphMtZHGVRqNOyAKvCce3hS6XO3/m2CjneBbS5fkko+Jd2REZXIDC/qhurLMfz9
         SPP1Wx6IsSrcw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 5/7] fscrypt: reclaim pooled prepared keys under pressure
Date:   Tue, 18 Apr 2023 22:42:14 -0400
Message-Id: <4513ae7360866fee4bbc2f800f77d0b74a9fa3ec.1681871298.git.sweettea-kernel@dorminy.me>
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

While it is to be hoped that the pools of prepared keys are sized
appropriately, there is no way to guarantee that they will never have
pressure short of expanding the pool for every user -- and that defeats
the goal of not allocating a prepared key for every user. So, a
mechanism to 'steal' a prepared key from its current owner must be
added, to support another info using the prepared key.

This adds that stealing mechanism. Currently, on pressure, the head of
the active prepared key list is stolen; this selection mechanism is
likely suboptimal, and is improved in a later change.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 47 +++++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index aed60280ad32..c12a26c81611 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -260,8 +260,8 @@ static void __fscrypt_return_key_to_pool(struct fscrypt_key_pool *pool,
 	/* Pairs with the acquire in get_pooled_key_owner() */
 	smp_store_release(&key->owner, NULL);
 	list_move(&key->pool_link, &pool->free_keys);
-	mutex_unlock(&pool->mutex);
 	mutex_unlock(&key->mutex);
+	mutex_unlock(&pool->mutex);
 }
 
 static void fscrypt_return_key_to_pool(struct fscrypt_info *ci)
@@ -269,17 +269,20 @@ static void fscrypt_return_key_to_pool(struct fscrypt_info *ci)
 	struct fscrypt_pooled_prepared_key *pooled_key;
 	const u8 mode_num = ci->ci_mode - fscrypt_modes;
 	struct fscrypt_master_key *mk = ci->ci_master_key;
+	struct fscrypt_key_pool *pool = &mk->mk_key_pools[mode_num];
 
 	mutex_lock(&pool->mutex);
 	/* Try to lock the key. If we don't, it's already been stolen. */
-	if (fscrypt_lock_pooled_key(ci) != 0)
+	if (fscrypt_lock_pooled_key(ci) != 0) {
+		mutex_unlock(&pool->mutex);
 		return;
+	}
 
 	pooled_key = container_of(ci->ci_enc_key,
 				  struct fscrypt_pooled_prepared_key,
 				  prep_key);
 
-	__fscrypt_return_key_to_pool(&mk->mk_key_pools[mode_num], pooled_key);
+	__fscrypt_return_key_to_pool(pool, pooled_key);
 }
 
 static int fscrypt_allocate_new_pooled_key(struct fscrypt_key_pool *pool,
@@ -302,13 +305,33 @@ static int fscrypt_allocate_new_pooled_key(struct fscrypt_key_pool *pool,
 	pooled_key->prep_key.type = FSCRYPT_KEY_POOLED;
 	mutex_init(&pooled_key->mutex);
 	INIT_LIST_HEAD(&pooled_key->pool_link);
+	mutex_lock(&pool->mutex);
 	mutex_lock(&pooled_key->mutex);
 	__fscrypt_return_key_to_pool(pool, pooled_key);
 	return 0;
 }
 
+static struct fscrypt_pooled_prepared_key *
+fscrypt_select_victim_key(struct fscrypt_key_pool *pool)
+{
+	return list_first_entry(&pool->active_keys,
+				struct fscrypt_pooled_prepared_key, pool_link);
+}
+
+static void fscrypt_steal_an_active_key(struct fscrypt_key_pool *pool)
+{
+	struct fscrypt_pooled_prepared_key *key;
+
+	key = fscrypt_select_victim_key(pool);
+	mutex_lock(&key->mutex);
+	/* Pairs with the acquire in get_pooled_key_owner() */
+	smp_store_release(&key->owner, NULL);
+	list_move(&key->pool_link, &pool->free_keys);
+	mutex_unlock(&key->mutex);
+}
+
 /*
- * Gets a key out of the free list, and locks it for use.
+ * Gets a key out of the free list, possibly stealing it along the way.
  */
 static int fscrypt_get_key_from_pool(struct fscrypt_key_pool *pool,
 				     struct fscrypt_info *ci)
@@ -316,10 +339,14 @@ static int fscrypt_get_key_from_pool(struct fscrypt_key_pool *pool,
 	struct fscrypt_pooled_prepared_key *key;
 
 	mutex_lock(&pool->mutex);
-	if (WARN_ON_ONCE(list_empty(&pool->free_keys))) {
+	if (list_empty(&pool->free_keys) && list_empty(&pool->active_keys)) {
 		mutex_unlock(&pool->mutex);
-		return -EBUSY;
+		return -EINVAL;
 	}
+
+	if (list_empty(&pool->free_keys))
+		fscrypt_steal_an_active_key(pool);
+
 	key = list_first_entry(&pool->free_keys,
 			       struct fscrypt_pooled_prepared_key, pool_link);
 
@@ -959,16 +986,8 @@ fscrypt_setup_encryption_info(struct inode *inode,
 		res = fscrypt_setup_file_key(crypt_info, mk);
 		if (res)
 			goto out;
-	} else {
-		const u8 mode_num = mode - fscrypt_modes;
-		struct fscrypt_key_pool *pool = &mk->mk_key_pools[mode_num];
-
-		res = fscrypt_allocate_new_pooled_key(pool, mode);
-		if (res)
-			return res;
 	}
 
-
 	/*
 	 * Derive a secret dirhash key for directories that need it. It
 	 * should be impossible to set flags such that a v1 policy sets
-- 
2.40.0

