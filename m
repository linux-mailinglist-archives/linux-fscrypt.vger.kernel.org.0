Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7BB65A8FC
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjAAFNu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjAAFNr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:47 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CF863FF
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:46 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id A07DE82612;
        Sun,  1 Jan 2023 00:06:33 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549594; bh=/0KsiKITv755odE4hV+51/rBkhkC+Aktg2KUCYeJUeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pn2IP1cHuuhaTvCbZ7JQUPqQRmYW8oQVPIlygdpoyhRJIRSRNBDV4Y8MEoDrNgNZI
         lQikXEHs7BkFLGTzELhnJRp7kx60pXN7YQG8ih4TZGuYrVqQ/G8Wjp9szIItVo3ZUg
         pWSBXyaCjG+Jr1hYsvW3LK9xSFveHyr17+GKfcsyw6wIFec64z4ZVhJMW/6z/JzwOL
         Oc/trRqo+2VUeeiQelB56/tGvmxg6SEJNbvgGeM3LV5ObA39H3VPucSqCnM223SwFH
         i6L67gkRoExQy1Si4IcSUn6pdTW4xUSy3NjbBPru2O4wEnGf81aWMCuO2yzrJVA/k+
         jt806YvZ7I3Og==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 02/17] fscrypt: separate getting info for a specific block
Date:   Sun,  1 Jan 2023 00:06:06 -0500
Message-Id: <ed3a25e816af4e5b4cfb8b8323c77fdcee2da00d.1672547582.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1672547582.git.sweettea-kernel@dorminy.me>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

For filesystems using extent-based encryption, the content of each extent will be
encrypted with a different fscrypt_info for each extent. Meanwhile,
directories and symlinks will continue to use the fscrypt_info for the
inode. Therefore, merely calling fscrypt_get_info() will be
insufficient; the caller must specifically request the inode info or the
info for a specific block.

Add that distinction, adding both fscrypt_get_inode_info() and
fscrypt_get_lblk_info(), and updating all callsites to call the
appropriate one.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c          |  3 ++-
 fs/crypto/fname.c           |  8 +++----
 fs/crypto/fscrypt_private.h | 46 +++++++++++++++++++++++++++++++++++++
 fs/crypto/hooks.c           |  2 +-
 fs/crypto/inline_crypt.c    | 12 ++++++----
 fs/crypto/keysetup.c        |  4 ++--
 fs/crypto/policy.c          |  8 +++----
 7 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 2efd1da9df8d..41c60c60b74c 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -107,7 +107,8 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist dst, src;
-	struct fscrypt_info *ci = fscrypt_get_info(inode);
+	struct fscrypt_info *ci = fscrypt_get_lblk_info(inode, lblk_num, NULL,
+							NULL);
 	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
 	int res = 0;
 
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 6efb53cba523..e1474f24d014 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -100,7 +100,7 @@ int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 {
 	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
-	const struct fscrypt_info *ci = fscrypt_get_info(inode);
+	const struct fscrypt_info *ci = fscrypt_get_inode_info(inode);
 	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
 	union fscrypt_iv iv;
 	struct scatterlist sg;
@@ -157,7 +157,7 @@ static int fname_decrypt(const struct inode *inode,
 	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist src_sg, dst_sg;
-	const struct fscrypt_info *ci = fscrypt_get_info(inode);
+	const struct fscrypt_info *ci = fscrypt_get_inode_info(inode);
 	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
 	union fscrypt_iv iv;
 	int res;
@@ -299,7 +299,7 @@ bool __fscrypt_fname_encrypted_size(const union fscrypt_policy *policy,
 bool fscrypt_fname_encrypted_size(const struct inode *inode, u32 orig_len,
 				  u32 max_len, u32 *encrypted_len_ret)
 {
-	struct fscrypt_info *ci = fscrypt_get_info(inode);
+	struct fscrypt_info *ci = fscrypt_get_inode_info(inode);
 	return __fscrypt_fname_encrypted_size(&ci->ci_policy,
 					      orig_len, max_len,
 					      encrypted_len_ret);
@@ -569,7 +569,7 @@ EXPORT_SYMBOL_GPL(fscrypt_match_name);
  */
 u64 fscrypt_fname_siphash(const struct inode *dir, const struct qstr *name)
 {
-	const struct fscrypt_info *ci = fscrypt_get_info(dir);
+	const struct fscrypt_info *ci = fscrypt_get_inode_info(dir);
 
 	WARN_ON(!ci->ci_dirhash_key_initialized);
 
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index d5f68a0c5d15..2df28c6fe558 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -262,6 +262,52 @@ typedef enum {
 	FS_ENCRYPT,
 } fscrypt_direction_t;
 
+/**
+ * fscrypt_get_inode_info() - get the fscrypt_info for a particular inode
+ *
+ * @inode: the inode in question
+ *
+ * For inode-based encryption, this will return the same info as
+ * fscrypt_get_lblk_info(). For extent-based encryption, for extentless
+ * files this will return the inode's info, otherwise it will return the info
+ * that new extents should inherit.
+ *
+ * Return: the appropriate fscrypt_info if there is one, else NULL.
+ */
+static inline struct fscrypt_info *
+fscrypt_get_inode_info(const struct inode *inode)
+{
+	return fscrypt_get_info(inode);
+}
+
+/**
+ * fscrypt_get_lblk_info() - get the fscrypt_info to crypt a particular block
+ *
+ * @inode:      the inode to which the block belongs
+ * @lblk:       the offset of the block within the file which the inode
+ *              references
+ * @offset:     a pointer to return the offset of the block from the first block
+ *              that the info covers. For inode-based encryption, this will
+ *              always be @lblk; for extent-based encryption, this will be in
+ *              the range [0, lblk]. Can be NULL
+ * @extent_len: a pointer to return the minimum number of lblks starting at
+ *              this offset which also belong to the same fscrypt_info. Can be
+ *              NULL
+ *
+ * Return: the appropriate fscrypt_info if there is one, else NULL.
+ */
+static inline struct fscrypt_info *
+fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
+		      u64 *extent_len)
+{
+	if (offset)
+		*offset = lblk;
+	if (extent_len)
+		*extent_len = U64_MAX;
+
+	return fscrypt_get_info(inode);
+}
+
 /* crypto.c */
 extern struct kmem_cache *fscrypt_info_cachep;
 int fscrypt_initialize(unsigned int cop_flags);
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index b605660fb3f1..929749c77440 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -152,7 +152,7 @@ int fscrypt_prepare_setflags(struct inode *inode,
 		err = fscrypt_require_key(inode);
 		if (err)
 			return err;
-		ci = fscrypt_get_info(inode);
+		ci = fscrypt_get_inode_info(inode);
 		if (ci->ci_policy.version != FSCRYPT_POLICY_V2)
 			return -EINVAL;
 		mk = ci->ci_master_key;
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 4b1373715018..56d69b231875 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -232,7 +232,7 @@ void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
 
 bool __fscrypt_inode_uses_inline_crypto(const struct inode *inode)
 {
-	return fscrypt_get_info(inode)->ci_inlinecrypt;
+	return fscrypt_get_inode_info(inode)->ci_inlinecrypt;
 }
 EXPORT_SYMBOL_GPL(__fscrypt_inode_uses_inline_crypto);
 
@@ -274,7 +274,7 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 
 	if (!fscrypt_inode_uses_inline_crypto(inode))
 		return;
-	ci = fscrypt_get_info(inode);
+	ci = fscrypt_get_lblk_info(inode, first_lblk, NULL, NULL);
 
 	fscrypt_generate_dun(ci, first_lblk, dun);
 	bio_crypt_set_ctx(bio, ci->ci_enc_key.blk_key, dun, gfp_mask);
@@ -353,21 +353,23 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 {
 	const struct bio_crypt_ctx *bc = bio->bi_crypt_context;
 	u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
+	struct fscrypt_info *ci;
 
 	if (!!bc != fscrypt_inode_uses_inline_crypto(inode))
 		return false;
 	if (!bc)
 		return true;
 
+	ci = fscrypt_get_lblk_info(inode, next_lblk, NULL, NULL);
 	/*
 	 * Comparing the key pointers is good enough, as all I/O for each key
 	 * uses the same pointer.  I.e., there's currently no need to support
 	 * merging requests where the keys are the same but the pointers differ.
 	 */
-	if (bc->bc_key != fscrypt_get_info(inode)->ci_enc_key.blk_key)
+	if (bc->bc_key != ci->ci_enc_key.blk_key)
 		return false;
 
-	fscrypt_generate_dun(fscrypt_get_info(inode), next_lblk, next_dun);
+	fscrypt_generate_dun(ci, next_lblk, next_dun);
 	return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
 }
 EXPORT_SYMBOL_GPL(fscrypt_mergeable_bio);
@@ -469,7 +471,7 @@ u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
 	if (nr_blocks <= 1)
 		return nr_blocks;
 
-	ci = fscrypt_get_info(inode);
+	ci = fscrypt_get_lblk_info(inode, lblk, NULL, NULL);
 	if (!(fscrypt_policy_flags(&ci->ci_policy) &
 	      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))
 		return nr_blocks;
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index ad56192305b3..87f28d666602 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -706,7 +706,7 @@ EXPORT_SYMBOL_GPL(fscrypt_prepare_new_inode);
  */
 void fscrypt_put_encryption_info(struct inode *inode)
 {
-	put_crypt_info(fscrypt_get_info(inode));
+	put_crypt_info(fscrypt_get_inode_info(inode));
 	inode->i_crypt_info = NULL;
 }
 EXPORT_SYMBOL(fscrypt_put_encryption_info);
@@ -739,7 +739,7 @@ EXPORT_SYMBOL(fscrypt_free_inode);
  */
 int fscrypt_drop_inode(struct inode *inode)
 {
-	const struct fscrypt_info *ci = fscrypt_get_info(inode);
+	const struct fscrypt_info *ci = fscrypt_get_inode_info(inode);
 
 	/*
 	 * If ci is NULL, then the inode doesn't have an encryption key set up
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index ccab27afd3cc..e7de4872d375 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -398,7 +398,7 @@ static int fscrypt_get_policy(struct inode *inode, union fscrypt_policy *policy)
 	union fscrypt_context ctx;
 	int ret;
 
-	ci = fscrypt_get_info(inode);
+	ci = fscrypt_get_inode_info(inode);
 	if (ci) {
 		/* key available, use the cached policy */
 		*policy = ci->ci_policy;
@@ -687,7 +687,7 @@ const union fscrypt_policy *fscrypt_policy_to_inherit(struct inode *dir)
 		err = fscrypt_require_key(dir);
 		if (err)
 			return ERR_PTR(err);
-		return &fscrypt_get_info(dir)->ci_policy;
+		return &fscrypt_get_inode_info(dir)->ci_policy;
 	}
 
 	return fscrypt_get_dummy_policy(dir->i_sb);
@@ -706,7 +706,7 @@ const union fscrypt_policy *fscrypt_policy_to_inherit(struct inode *dir)
  */
 int fscrypt_context_for_new_inode(void *ctx, struct inode *inode)
 {
-	struct fscrypt_info *ci = fscrypt_get_info(inode);
+	struct fscrypt_info *ci = fscrypt_get_inode_info(inode);
 
 	BUILD_BUG_ON(sizeof(union fscrypt_context) !=
 			FSCRYPT_SET_CONTEXT_MAX_SIZE);
@@ -731,7 +731,7 @@ EXPORT_SYMBOL_GPL(fscrypt_context_for_new_inode);
  */
 int fscrypt_set_context(struct inode *inode, void *fs_data)
 {
-	struct fscrypt_info *ci = fscrypt_get_info(inode);
+	struct fscrypt_info *ci = fscrypt_get_inode_info(inode);
 	union fscrypt_context ctx;
 	int ctxsize;
 
-- 
2.38.1

