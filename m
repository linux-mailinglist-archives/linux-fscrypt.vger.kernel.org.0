Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD136DCBBA
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 21:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjDJTkn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 15:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjDJTkn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 15:40:43 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294281717
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 12:40:42 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 4FD8980516;
        Mon, 10 Apr 2023 15:40:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681155641; bh=fPISzagGl1bOo9aNSqDTkAyacC799poKs6aM3P+PRaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gwQv6ymafEehHJfJ+QqwgMz6wfXEihx34HuOkizbcC40DyEOubwJLmuHWQnasY62q
         iP894UqiLBtJXQT8J+ETix/VpNz4R8HMziU/YeWCwyOmpKHVENhEuhDoR2gIxKHJjK
         u6ZuEAgwT6zur7E6+FU8/2b7ePmCYKICqVtf5iuNC6WSTryn5zZbaIxzGZOCfDJCnK
         r47Xp4vDMPKvpLAiLYlyE0qQYYD1BQC+d3lG8y4x+mfQ8XAEMCE6dMZiwBjR6dKcEE
         qe5yW6Zipt1a1+t+4M4s4aWXMCdSRPF4P7UcWwfoi6AgGiOa4cTKt+OrdCSckeafDg
         H5hKZl4LjOy9w==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 10/11] fscrypt: explicitly track prepared parts of key
Date:   Mon, 10 Apr 2023 15:40:03 -0400
Message-Id: <2a9bf42af2b2ac6289d0ac886d1f07042feafbe5.1681155143.git.sweettea-kernel@dorminy.me>
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

So far, it has sufficed to allocate and prepare the block key or the TFM
completely before ever setting the relevant field in the prepared key.
This is necessary for mode keys -- because multiple inodes could be
trying to set up the same per-mode prepared key at the same time on
different threads, we currently must not set the prepared key's tfm or
block key pointer until that key is completely set up. Otherwise,
another inode could see the key to be present and attempt to use it
before it is fully set up.

But when using pooled prepared keys, we'll have pre-allocated fields,
and if we separate allocating the fields of a prepared key from
preparing the fields, that inherently sets the fields before they're
ready to use. So, either pooled prepared keys must use different
allocation and setup functions, or we can split allocation and
preparation for all prepared keys and use some other mechanism to signal
that the key is fully prepared.

In order to avoid having similar yet different functions, this function
adds a new field to the prepared key to explicitly track which parts of
it are prepared, setting it explicitly. The same acquire/release
semantics are used to check it in the case of shared mode keys; the cost
lies in the extra byte per prepared key recording which members are
fully prepared.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 26 +++++++++++++++-----------
 fs/crypto/inline_crypt.c    |  8 +-------
 fs/crypto/keysetup.c        | 36 ++++++++++++++++++++++++++----------
 3 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index e726a1fb9f7e..7253cdb5e4d8 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -197,6 +197,8 @@ enum fscrypt_prepared_key_type {
  * @tfm: crypto API transform object
  * @blk_key: key for blk-crypto
  * @type: records the ownership type of the prepared key
+ * @prepared_members: records which of @tfm and @blk_key are prepared. tfm
+ *		      corresponds to bit 0; blk_key corresponds to bit 1.
  *
  * Normally only one of @tfm and @blk_key will be non-NULL, although it is
  * possible if @type is FSCRYPT_KEY_MASTER_KEY.
@@ -207,6 +209,7 @@ struct fscrypt_prepared_key {
 	struct blk_crypto_key *blk_key;
 #endif
 	enum fscrypt_prepared_key_type type;
+	u8 prepared_members;
 };
 
 /*
@@ -363,24 +366,25 @@ void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
 				      struct fscrypt_prepared_key *prep_key);
 
 /*
- * Check whether the crypto transform or blk-crypto key has been allocated in
+ * Check whether the crypto transform or blk-crypto key has been prepared in
  * @prep_key, depending on which encryption implementation the file will use.
  */
 static inline bool
 fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
 			const struct fscrypt_info *ci)
 {
+	u8 prepared_members = smp_load_acquire(&prep_key->prepared_members);
+	bool inlinecrypt = fscrypt_using_inline_encryption(ci);
+
 	/*
-	 * The two smp_load_acquire()'s here pair with the smp_store_release()'s
-	 * in fscrypt_prepare_inline_crypt_key() and fscrypt_prepare_key().
-	 * I.e., in some cases (namely, if this prep_key is a per-mode
-	 * encryption key) another task can publish blk_key or tfm concurrently,
-	 * executing a RELEASE barrier.  We need to use smp_load_acquire() here
-	 * to safely ACQUIRE the memory the other task published.
+	 * The smp_load_acquire() here pairs with the smp_store_release()
+	 * in fscrypt_prepare_key().  I.e., in some cases (namely, if this
+	 * prep_key is a per-mode encryption key) another task can publish
+	 * blk_key or tfm concurrently, executing a RELEASE barrier.  We need
+	 * to use smp_load_acquire() here to safely ACQUIRE the memory the
+	 * other task published.
 	 */
-	if (fscrypt_using_inline_encryption(ci))
-		return smp_load_acquire(&prep_key->blk_key) != NULL;
-	return smp_load_acquire(&prep_key->tfm) != NULL;
+	return prepared_members & (1U << inlinecrypt);
 }
 
 #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
@@ -415,7 +419,7 @@ static inline bool
 fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
 			const struct fscrypt_info *ci)
 {
-	return smp_load_acquire(&prep_key->tfm) != NULL;
+	return smp_load_acquire(&prep_key->prepared_members);
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
index f338bb544932..6efac89d49ec 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -155,21 +155,37 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 			const u8 *raw_key, const struct fscrypt_info *ci)
 {
-	struct crypto_skcipher *tfm;
+	int err;
+	bool inlinecrypt = fscrypt_using_inline_encryption(ci);
+	u8 prepared_member = (1 << inlinecrypt);
 
-	if (fscrypt_using_inline_encryption(ci))
-		return fscrypt_prepare_inline_crypt_key(prep_key, raw_key, ci);
+	if (inlinecrypt) {
+		err = fscrypt_prepare_inline_crypt_key(prep_key, raw_key, ci);
+	} else {
+		struct crypto_skcipher *tfm;
+
+		tfm = fscrypt_allocate_skcipher(ci->ci_mode, raw_key, ci->ci_inode);
+		if (IS_ERR(tfm))
+			return PTR_ERR(tfm);
+		}
+
+		prep_key->tfm = tfm;
+	}
 
-	tfm = fscrypt_allocate_skcipher(ci->ci_mode, raw_key, ci->ci_inode);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
 	/*
 	 * Pairs with the smp_load_acquire() in fscrypt_is_key_prepared().
-	 * I.e., here we publish ->tfm with a RELEASE barrier so that
-	 * concurrent tasks can ACQUIRE it.  Note that this concurrency is only
-	 * possible for per-mode keys, not for per-file keys.
+	 * I.e., here we publish ->prepared_members with a RELEASE barrier so
+	 * that concurrent tasks can ACQUIRE it.
+	 *
+	 * Note that this concurrency is only possible for per-mode keys,
+	 * not for per-file keys. For per-mode keys, we have smp_load_acquire'd
+	 * the value of ->prepared_members after taking a lock serializing
+	 * preparing this key, so the value is stable and no other thread can
+	 * have modified it since the read. So another thread can't be trying
+	 * to run this same code in parallel, and we don't need to use cmpxchg.
 	 */
-	smp_store_release(&prep_key->tfm, tfm);
+	smp_store_release(&prep_key->prepared_members,
+			  prep_key->prepared_members | prepared_member);
 	return 0;
 }
 
-- 
2.40.0

