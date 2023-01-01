Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE3465A907
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjAAFN7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbjAAFNt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:49 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95346410
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:47 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 6B999825FF;
        Sun,  1 Jan 2023 00:06:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549591; bh=Qv1TeX542er9NMo8QNyHPEGrBDJKAGVwPmLI7IoKOyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llIgTTnA0i3tW7VDJLT8XZpGMe1rMCaL2aSShVrM5+kC+jYdwPjWKSKzVD42966bL
         Hzt3pOdSYmifFcj+gy68C93LpPusSgV2rao1XeNKKJRD8O1MlnSgy1VYjlN44mtD02
         EIBEckkAJolevWzYSYoRnmIKscQQQgHXDWCCKfK28vynOeULahMSsoPhXR+QST51LO
         TxLhU4An4B6F3KR4Nteu4kf6oEV8MmlXQa/Wsw6xMAcGNmb2+w2xGXW9Myq18Vxo0V
         B2dm9UreXEgT88DeQu1h7r/iTGhDqsXXUdkXe5O8al1twT3teMAfRyn1h5YKYHa/XF
         d/DVsFfOzXWJg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 01/17] fscrypt: factor accessing inode->i_crypt_info
Date:   Sun,  1 Jan 2023 00:06:05 -0500
Message-Id: <1d69320524e31f4f0ece20ba3c0d2b8244228f4f.1672547582.git.sweettea-kernel@dorminy.me>
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

Currently, inode->i_crypt_info is accessed directly in many places;
the initial setting occurs in one place, via cmpxchg_release, and
the initial access is abstracted into fscrypt_get_info() which uses
smp_load_acquire(), but there are many direct accesses. While many of
them follow calls to fscrypt_get_info() on the same thread, verifying
this is not always trivial.

For instance, fscrypt_crypt_block() does not obviously follow a call to
fscrypt_get_info() on the same cpu; if some other mechanism does not
ensure a memory barrier, it is conceivable that a filesystem could call
fscrypt_crypt_block() on a cpu which had an old (NULL) i_crypt_info
cached. Even if the cpu does READ_ONCE(i_crypt_info), I believe it's
theoretically possible for it to see the old NULL value, since this
could be happening on a cpu which did not do the smp_load_acquire().  (I
may be misunderstanding, but memory-barriers.txt says that only the cpus
involved in an acquire/release chain are guaranteed to see the correct
order of operations, which seems to imply that a cpu which does not do
an acquire may be able to see a memory value from before the release.)

For safety, then, and so each site doesn't need to be individually
evaluated, this change factors all accesses of i_crypt_info to go
through fscrypt_get_info(), ensuring every access uses acquire and is
thus paired against an appropriate release.

(The same treatment is not necessary for setting i_crypt_info; the
only unprotected setting is during inode cleanup, which is inevitably
followed by freeing the inode; there are no uses past the unprotected
setting possible.)

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c       |  2 +-
 fs/crypto/fname.c        |  9 +++++----
 fs/crypto/hooks.c        |  2 +-
 fs/crypto/inline_crypt.c | 10 +++++-----
 fs/crypto/keysetup.c     |  2 +-
 fs/crypto/policy.c       |  6 +++---
 6 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index e78be66bbf01..2efd1da9df8d 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -107,7 +107,7 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist dst, src;
-	struct fscrypt_info *ci = inode->i_crypt_info;
+	struct fscrypt_info *ci = fscrypt_get_info(inode);
 	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
 	int res = 0;
 
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 12bd61d20f69..6efb53cba523 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -100,7 +100,7 @@ int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 {
 	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
-	const struct fscrypt_info *ci = inode->i_crypt_info;
+	const struct fscrypt_info *ci = fscrypt_get_info(inode);
 	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
 	union fscrypt_iv iv;
 	struct scatterlist sg;
@@ -157,7 +157,7 @@ static int fname_decrypt(const struct inode *inode,
 	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist src_sg, dst_sg;
-	const struct fscrypt_info *ci = inode->i_crypt_info;
+	const struct fscrypt_info *ci = fscrypt_get_info(inode);
 	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
 	union fscrypt_iv iv;
 	int res;
@@ -299,7 +299,8 @@ bool __fscrypt_fname_encrypted_size(const union fscrypt_policy *policy,
 bool fscrypt_fname_encrypted_size(const struct inode *inode, u32 orig_len,
 				  u32 max_len, u32 *encrypted_len_ret)
 {
-	return __fscrypt_fname_encrypted_size(&inode->i_crypt_info->ci_policy,
+	struct fscrypt_info *ci = fscrypt_get_info(inode);
+	return __fscrypt_fname_encrypted_size(&ci->ci_policy,
 					      orig_len, max_len,
 					      encrypted_len_ret);
 }
@@ -568,7 +569,7 @@ EXPORT_SYMBOL_GPL(fscrypt_match_name);
  */
 u64 fscrypt_fname_siphash(const struct inode *dir, const struct qstr *name)
 {
-	const struct fscrypt_info *ci = dir->i_crypt_info;
+	const struct fscrypt_info *ci = fscrypt_get_info(dir);
 
 	WARN_ON(!ci->ci_dirhash_key_initialized);
 
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 7b8c5a1104b5..b605660fb3f1 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -152,7 +152,7 @@ int fscrypt_prepare_setflags(struct inode *inode,
 		err = fscrypt_require_key(inode);
 		if (err)
 			return err;
-		ci = inode->i_crypt_info;
+		ci = fscrypt_get_info(inode);
 		if (ci->ci_policy.version != FSCRYPT_POLICY_V2)
 			return -EINVAL;
 		mk = ci->ci_master_key;
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index cea8b14007e6..4b1373715018 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -232,7 +232,7 @@ void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
 
 bool __fscrypt_inode_uses_inline_crypto(const struct inode *inode)
 {
-	return inode->i_crypt_info->ci_inlinecrypt;
+	return fscrypt_get_info(inode)->ci_inlinecrypt;
 }
 EXPORT_SYMBOL_GPL(__fscrypt_inode_uses_inline_crypto);
 
@@ -274,7 +274,7 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 
 	if (!fscrypt_inode_uses_inline_crypto(inode))
 		return;
-	ci = inode->i_crypt_info;
+	ci = fscrypt_get_info(inode);
 
 	fscrypt_generate_dun(ci, first_lblk, dun);
 	bio_crypt_set_ctx(bio, ci->ci_enc_key.blk_key, dun, gfp_mask);
@@ -364,10 +364,10 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 	 * uses the same pointer.  I.e., there's currently no need to support
 	 * merging requests where the keys are the same but the pointers differ.
 	 */
-	if (bc->bc_key != inode->i_crypt_info->ci_enc_key.blk_key)
+	if (bc->bc_key != fscrypt_get_info(inode)->ci_enc_key.blk_key)
 		return false;
 
-	fscrypt_generate_dun(inode->i_crypt_info, next_lblk, next_dun);
+	fscrypt_generate_dun(fscrypt_get_info(inode), next_lblk, next_dun);
 	return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
 }
 EXPORT_SYMBOL_GPL(fscrypt_mergeable_bio);
@@ -469,7 +469,7 @@ u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
 	if (nr_blocks <= 1)
 		return nr_blocks;
 
-	ci = inode->i_crypt_info;
+	ci = fscrypt_get_info(inode);
 	if (!(fscrypt_policy_flags(&ci->ci_policy) &
 	      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))
 		return nr_blocks;
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index f7407071a952..ad56192305b3 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -706,7 +706,7 @@ EXPORT_SYMBOL_GPL(fscrypt_prepare_new_inode);
  */
 void fscrypt_put_encryption_info(struct inode *inode)
 {
-	put_crypt_info(inode->i_crypt_info);
+	put_crypt_info(fscrypt_get_info(inode));
 	inode->i_crypt_info = NULL;
 }
 EXPORT_SYMBOL(fscrypt_put_encryption_info);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 46757c3052ef..ccab27afd3cc 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -687,7 +687,7 @@ const union fscrypt_policy *fscrypt_policy_to_inherit(struct inode *dir)
 		err = fscrypt_require_key(dir);
 		if (err)
 			return ERR_PTR(err);
-		return &dir->i_crypt_info->ci_policy;
+		return &fscrypt_get_info(dir)->ci_policy;
 	}
 
 	return fscrypt_get_dummy_policy(dir->i_sb);
@@ -706,7 +706,7 @@ const union fscrypt_policy *fscrypt_policy_to_inherit(struct inode *dir)
  */
 int fscrypt_context_for_new_inode(void *ctx, struct inode *inode)
 {
-	struct fscrypt_info *ci = inode->i_crypt_info;
+	struct fscrypt_info *ci = fscrypt_get_info(inode);
 
 	BUILD_BUG_ON(sizeof(union fscrypt_context) !=
 			FSCRYPT_SET_CONTEXT_MAX_SIZE);
@@ -731,7 +731,7 @@ EXPORT_SYMBOL_GPL(fscrypt_context_for_new_inode);
  */
 int fscrypt_set_context(struct inode *inode, void *fs_data)
 {
-	struct fscrypt_info *ci = inode->i_crypt_info;
+	struct fscrypt_info *ci = fscrypt_get_info(inode);
 	union fscrypt_context ctx;
 	int ctxsize;
 
-- 
2.38.1

