Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439C36DC5BB
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 12:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjDJK06 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 06:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjDJK0y (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 06:26:54 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E782D198
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 03:26:52 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 8BCB28064B;
        Mon, 10 Apr 2023 06:16:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681121817; bh=fPISzagGl1bOo9aNSqDTkAyacC799poKs6aM3P+PRaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXVJAVoq/RHIC/LHsqEr6Qs02LXB6ZGTTzEO9S8Wo787xfr9olMAJrcjqkTfoe2WP
         hmXGUjUdMIAOdagGbWR824walIvd93FMVQTPYQ4liyJhXBI1KtqRwFbwXdwVatPuBa
         6zQxq4XOIKkkPaDGUyYkaaf/5lFZbWrICSED+uWVzSIBwql1IDs9ADe0RVXKm3bjCr
         L6lTdAcuYaju2nFY+TwxtDqOpKNG101KsIwdLJyFBbR5cbCcxFV2mt8TJB397Ik1MH
         GY5Ib0QRy+b7wgSoban1Juk+ytNJgFqL8kHtAI7GssTYI8XBvrhGcik2uaqMSkxSKx
         waxKvYDMU3d3g==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 09/10] fscrypt: explicitly track prepared parts of key
Date:   Mon, 10 Apr 2023 06:16:30 -0400
Message-Id: <7d901a1dfebb32fe84ea63938a2503f145480b02.1681116740.git.sweettea-kernel@dorminy.me>
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

