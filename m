Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E13D6E6A87
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Apr 2023 19:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbjDRRFm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 13:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjDRRFj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 13:05:39 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8846F9025
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 10:05:25 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id E41298023D;
        Tue, 18 Apr 2023 13:05:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681837525; bh=tOJ7dlXm0qa8vPXqSZDDPl8bul11m2OmAWQoQ5R4rK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrCFrlx+eZdeRirLQ5qgM6AriVlxO/dEOaQzfw/tdZc0A8DMvdzrPyrhyh0C2xlF6
         BDkouqLqfnN8HPt1Z93LHH4JJZpmMGhVJf/jDHBKoBNaW2w0+bTiAOmCR/t4Zjvhxd
         KfWunPo8hZs+Juzl6/y2RH/Kfo90mrHJUaM6dCIOFKcm1yTX+IwlB4HZ9VL9Xw3QMr
         L6sdaK+R74lEhdhEHENgW+/Bu3olWtV5eNXIOt0mKJJK/E6PdaS9aQxHvsFhCclIso
         h+HecGZ9XtsrQ+IkyyFtkivV+6tzXkR9m+0zbBl8BcJj39clRf4cQgR6Xmhy2K8pli
         p4hL3yXEVzI5g==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 10/11] fscrypt: split key alloc and preparation
Date:   Tue, 18 Apr 2023 13:04:47 -0400
Message-Id: <f7dfe5d7b3641d2671067ed593bd615eb67e99a5.1681837335.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1681837335.git.sweettea-kernel@dorminy.me>
References: <cover.1681837335.git.sweettea-kernel@dorminy.me>
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

For extent-based encryption, we plan to use pooled prepared keys, since
it's unsafe to allocate a new crypto_skcipher when performing IO. This
will require being able to set up a pre-allocated prepared key, while
the current code requires allocating and setting up simultaneously.

This pulls apart fscrypt_allocate_skcipher() to only allocate; pulls
allocation out of fscrypt_prepare_inline_crypt_key(); creates a new
function fscrypt_allocate_key_member() that allocates the appropriate
member of a prepared key; and reflects these changes throughout.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 14 +++++++++
 fs/crypto/inline_crypt.c    | 19 +++++++++----
 fs/crypto/keysetup.c        | 57 ++++++++++++++++++++++++++-----------
 fs/crypto/keysetup_v1.c     |  4 +++
 4 files changed, 72 insertions(+), 22 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 46a756c8a66f..eb302e342fb9 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -355,6 +355,9 @@ fscrypt_using_inline_encryption(const struct fscrypt_info *ci)
 	return ci->ci_inlinecrypt;
 }
 
+int fscrypt_allocate_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
+				      const struct fscrypt_info *ci);
+
 int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 				     const u8 *raw_key,
 				     const struct fscrypt_info *ci);
@@ -388,6 +391,14 @@ fscrypt_using_inline_encryption(const struct fscrypt_info *ci)
 	return false;
 }
 
+static inline int
+fscrypt_allocate_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
+				  const struct fscrypt_info *ci)
+{
+	WARN_ON(1);
+	return -EOPNOTSUPP;
+}
+
 static inline int
 fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 				 const u8 *raw_key,
@@ -604,6 +615,9 @@ struct fscrypt_mode {
 
 extern struct fscrypt_mode fscrypt_modes[];
 
+int fscrypt_allocate_key_member(struct fscrypt_prepared_key *prep_key,
+				const struct fscrypt_info *ci);
+
 int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 			const u8 *raw_key, const struct fscrypt_info *ci);
 
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index ce952dedba77..b527323ddf88 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -157,16 +157,12 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 	const struct inode *inode = ci->ci_inode;
 	struct super_block *sb = inode->i_sb;
 	enum blk_crypto_mode_num crypto_mode = ci->ci_mode->blk_crypto_mode;
-	struct blk_crypto_key *blk_key;
+	struct blk_crypto_key *blk_key = prep_key->blk_key;
 	struct block_device **devs;
 	unsigned int num_devs;
 	unsigned int i;
 	int err;
 
-	blk_key = kmalloc(sizeof(*blk_key), GFP_KERNEL);
-	if (!blk_key)
-		return -ENOMEM;
-
 	err = blk_crypto_init_key(blk_key, raw_key, crypto_mode,
 				  fscrypt_get_dun_bytes(ci), sb->s_blocksize);
 	if (err) {
@@ -191,7 +187,6 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 		goto fail;
 	}
 
-	prep_key->blk_key = blk_key;
 	return 0;
 
 fail:
@@ -199,6 +194,18 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 	return err;
 }
 
+int fscrypt_allocate_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
+				     const struct fscrypt_info *ci)
+{
+	struct blk_crypto_key *blk_key = kmalloc(sizeof(*blk_key), GFP_KERNEL);
+
+	if (!blk_key)
+		return -ENOMEM;
+
+	prep_key->blk_key = blk_key;
+	return 0;
+}
+
 void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
 				      struct fscrypt_prepared_key *prep_key)
 {
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index a5f23b996a23..55c416df6a71 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -106,9 +106,33 @@ select_encryption_mode(const union fscrypt_policy *policy,
 	return ERR_PTR(-EINVAL);
 }
 
-/* Create a symmetric cipher object for the given encryption mode and key */
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
+
+/* Create a symmetric cipher object for the given encryption mode */
 static struct crypto_skcipher *
-fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
+fscrypt_allocate_skcipher(struct fscrypt_mode *mode,
 			  const struct inode *inode)
 {
 	struct crypto_skcipher *tfm;
@@ -141,10 +165,6 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 		goto err_free_tfm;
 	}
 	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
-	err = crypto_skcipher_setkey(tfm, raw_key, mode->keysize);
-	if (err)
-		goto err_free_tfm;
-
 	return tfm;
 
 err_free_tfm:
@@ -152,21 +172,16 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 	return ERR_PTR(err);
 }
 
-/*
- * Prepare the crypto transform object or blk-crypto key in @prep_key, given the
- * raw key, encryption mode (@ci->ci_mode), flag indicating which encryption
- * implementation (fs-layer or blk-crypto) will be used (@ci->ci_inlinecrypt),
- * and IV generation method (@ci->ci_policy.flags).
- */
-int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
-			const u8 *raw_key, const struct fscrypt_info *ci)
+/* Allocate the relevant encryption member for the prepared key */
+int fscrypt_allocate_key_member(struct fscrypt_prepared_key *prep_key,
+				const struct fscrypt_info *ci)
 {
 	struct crypto_skcipher *tfm;
 
 	if (fscrypt_using_inline_encryption(ci))
-		return fscrypt_prepare_inline_crypt_key(prep_key, raw_key, ci);
+		return fscrypt_allocate_inline_crypt_key(prep_key, ci);
 
-	tfm = fscrypt_allocate_skcipher(ci->ci_mode, raw_key, ci->ci_inode);
+	tfm = fscrypt_allocate_skcipher(ci->ci_mode, ci->ci_inode);
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 	prep_key->tfm = tfm;
@@ -185,11 +200,17 @@ void fscrypt_destroy_prepared_key(struct super_block *sb,
 /* Given a per-file encryption key, set up the file's crypto transform object */
 int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
 {
+	int err;
+
 	ci->ci_enc_key = kzalloc(sizeof(*ci->ci_enc_key), GFP_KERNEL);
 	if (!ci->ci_enc_key)
 		return -ENOMEM;
 
 	ci->ci_enc_key->type = FSCRYPT_KEY_PER_INFO;
+	err = fscrypt_allocate_key_member(ci->ci_enc_key, ci);
+	if (err)
+		return err;
+
 	return fscrypt_prepare_key(ci->ci_enc_key, raw_key, ci);
 }
 
@@ -271,6 +292,10 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 	 */
 
 
+	err = fscrypt_allocate_key_member(prep_key, ci);
+	if (err)
+		return err;
+
 	BUILD_BUG_ON(sizeof(mode_num) != 1);
 	BUILD_BUG_ON(sizeof(sb->s_uuid) != 16);
 	BUILD_BUG_ON(sizeof(hkdf_info) != MAX_MODE_KEY_HKDF_INFO_SIZE);
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 119e80d6e81f..2db18bedfab5 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -239,6 +239,10 @@ fscrypt_get_direct_key(const struct fscrypt_info *ci, const u8 *raw_key)
 	refcount_set(&dk->dk_refcount, 1);
 	dk->dk_mode = ci->ci_mode;
 	dk->dk_key.type = FSCRYPT_KEY_DIRECT_V1;
+	err = fscrypt_allocate_key_member(&dk->dk_key, ci);
+	if (err)
+		goto err_free_dk;
+
 	err = fscrypt_prepare_key(&dk->dk_key, raw_key, ci);
 	if (err)
 		goto err_free_dk;
-- 
2.40.0

