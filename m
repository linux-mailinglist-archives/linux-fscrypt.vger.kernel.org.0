Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3306E712F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Apr 2023 04:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjDSCmf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 22:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbjDSCmf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 22:42:35 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6DB658E
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 19:42:34 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 84B8480530;
        Tue, 18 Apr 2023 22:42:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681872153; bh=h4rid5pQaBGmVGprf2ZfCdtfSejfQT+F7ZSk6curq2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdK/TyNM/pqO+sSoBrJlZB6tPcXS3Kp4fjyUo1hjOXPrDWr8EmMfQeGEv7x3dlmtf
         nXq+Wv7GgCMHjh/gkhdCi9BnE+24kh/mYrQOTwnenxBfnPmQB7NIJ3fh7Re/llRP1O
         Gx4ukEr5t30LlL1+EoxqF4GAkwlzTtJSSJXTq2fhoaSfFEv+Cpm0i6/Zj/KA0pKv7I
         EIbvK2TQbvMFvDdIFjyeSBRoyNpSECauB7x5Owe6ODgnWsQVh3Xl5WpMpzJ3IAA8xh
         CnxCqWo1t4kWz0yPVObXVeXiV4L12Vz/Lm6i3cScTI9W1Xi5jC32bisnMZOVAddQnI
         iZJl7Q/ED6Gnw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 6/7] fscrypt: add facility to shrink a pool of keys
Date:   Tue, 18 Apr 2023 22:42:15 -0400
Message-Id: <0ec2076fa7ebc3b44aaaab3a0ffb703e853dce28.1681871298.git.sweettea-kernel@dorminy.me>
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

One expected mechanism to size the pools for extent-based encryption is
to allocate one new pooled prepared key when each inode using such is
opened, and to free it when that inode is closed. This provides roughly
equally many active prepared keys as the non-extent-based scheme, one
prepared key per 'leaf' inode for contents encryption.

This change introduces the ability to shrink a prepared key pool by one
key, including deferring freeing until the next prepared key is freed
back to the pool. This avoids issues with stealing a prepared key from
an info and then freeing it while the old info still references it.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h |  4 ++++
 fs/crypto/keysetup.c        | 43 ++++++++++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 2737545ce4a6..cc6e4a2a942c 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -467,6 +467,10 @@ struct fscrypt_key_pool {
 	struct list_head active_keys;
 	/* Inactive keys available for use */
 	struct list_head free_keys;
+	/* Count of keys currently managed */
+	size_t count;
+	/* Count of keys desired. Oft equal to count, but can be less. */
+	size_t desired;
 };
 
 /*
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index c12a26c81611..57c343b78abc 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -254,6 +254,22 @@ void fscrypt_unlock_key_if_pooled(struct fscrypt_info *ci)
 	mutex_unlock(&pooled_key->mutex);
 }
 
+/*
+ * Free one key from the free list.
+ */
+static void __fscrypt_free_one_free_key(struct fscrypt_key_pool *pool)
+{
+	struct fscrypt_pooled_prepared_key *tmp;
+
+	tmp = list_first_entry(&pool->free_keys,
+			       struct fscrypt_pooled_prepared_key,
+			       pool_link);
+	fscrypt_destroy_prepared_key(NULL, &tmp->prep_key);
+	list_del_init(&tmp->pool_link);
+	kfree(tmp);
+	pool->count--;
+}
+
 static void __fscrypt_return_key_to_pool(struct fscrypt_key_pool *pool,
 					 struct fscrypt_pooled_prepared_key *key)
 {
@@ -261,6 +277,8 @@ static void __fscrypt_return_key_to_pool(struct fscrypt_key_pool *pool,
 	smp_store_release(&key->owner, NULL);
 	list_move(&key->pool_link, &pool->free_keys);
 	mutex_unlock(&key->mutex);
+	if (pool->count > pool->desired)
+		__fscrypt_free_one_free_key(pool);
 	mutex_unlock(&pool->mutex);
 }
 
@@ -306,6 +324,8 @@ static int fscrypt_allocate_new_pooled_key(struct fscrypt_key_pool *pool,
 	mutex_init(&pooled_key->mutex);
 	INIT_LIST_HEAD(&pooled_key->pool_link);
 	mutex_lock(&pool->mutex);
+	pool->count++;
+	pool->desired++;
 	mutex_lock(&pooled_key->mutex);
 	__fscrypt_return_key_to_pool(pool, pooled_key);
 	return 0;
@@ -359,6 +379,18 @@ static int fscrypt_get_key_from_pool(struct fscrypt_key_pool *pool,
 	return 0;
 }
 
+/*
+ * Shrink the pool by one key.
+ */
+static void fscrypt_shrink_key_pool(struct fscrypt_key_pool *pool)
+{
+	mutex_lock(&pool->mutex);
+	pool->desired--;
+	if (!list_empty(&pool->free_keys))
+		__fscrypt_free_one_free_key(pool);
+	mutex_unlock(&pool->mutex);
+}
+
 /*
  * Do initial setup for a particular key pool, allocated as part of an array
  */
@@ -396,14 +428,9 @@ void fscrypt_destroy_key_pool(struct fscrypt_key_pool *pool)
 		list_del_init(&tmp->pool_link);
 		kfree(tmp);
 	}
-	while (!list_empty(&pool->free_keys)) {
-		tmp = list_first_entry(&pool->free_keys,
-				       struct fscrypt_pooled_prepared_key,
-				       pool_link);
-		fscrypt_destroy_prepared_key(NULL, &tmp->prep_key);
-		list_del_init(&tmp->pool_link);
-		kfree(tmp);
-	}
+	while (!list_empty(&pool->free_keys))
+		__fscrypt_free_one_free_key(pool);
+
 	mutex_unlock(&pool->mutex);
 }
 
-- 
2.40.0

