Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2546DC5B8
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 12:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjDJK0z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 06:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjDJK0x (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 06:26:53 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611BD1FF0
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 03:26:52 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 30B2D8060B;
        Mon, 10 Apr 2023 06:16:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681121810; bh=/xrIvuueTIYi8PCgwp8TTqp87peagz23ImqhwA+SXoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDm96r2rmTYTGTnA66ZVG9BEPVdau01GQtnAN3aMiCY3hqmY36sE+TIoUUKinwjCZ
         fz7DQUcArm5o+zzeHJqDz43KXPevZqYHgdXaFL+6Vp0boQbXIthsJD7UWn2qJykC9a
         3nmcGpI94mhpyCGevd0KSK1guNiArcQr42DVxcJ3Emr4zR5gK/MZurAOyB9KIOuptB
         9ogy8uRWHqhN+pPu+LpuBBmt70ylLfG8HRd5pBgRLqYbpibkzti4xOWpOdb3V2lD3C
         zGOA4BnUTTgZySmjZQeA43aD8ZO2IxtW8sJ/NPdheyNYDYD0BGEMcaHnv7QNbK2QWe
         SDqHoCTMrxZsA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 05/10] fscrypt: make infos have a pointer to prepared keys
Date:   Mon, 10 Apr 2023 06:16:26 -0400
Message-Id: <4ec283b09d403eadd5c6217b9978487e1001ab69.1681116739.git.sweettea-kernel@dorminy.me>
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

At present, it's not entirely clear who owns a prepared key. Under
default policies, infos own the prepared key; but under any of the
policy flag key policies, or with some v1 policies, the info merely has
a copy of the authoritative prepared key; the authoritative copy of the
prepared key lives in the master key or the direct key, but the info has
no way to get to the authoritative key or get updates from it.

A scenario which could occur is the following:

-A directory tree is set up to use v2 policy DIRECT_KEY, mode adiantum.
-One directory is opened, gets a prepared key with a crypto_skcipher.
-A file within it is opened, sets up and gets the 'same' prepared key,
 but it's set up the blk_crypto_key in the prepared key.
-Another directory in the tree is opened, and gets the 'same' prepared
 key, but it's now got a pointer to the blk_crypto_key too.
-The two directories' ci_enc_key values are different, even though for
 practical purposes they are the same.

While it has no correctness implications, it's confusing for debugging
when two directories with the same mode/policy have different prepared
key contents depending on what else happened.

Adding a layer of indirection makes everything clearer at the cost of
another pointer. Now everyone sharing a prepared key within a direct key
or a master key have the same pointer to the single prepared key.
Followups move information from the crypt_info into the prepared key,
which ends up reducing memory usage slightly. And, it makes using
pooled, pre-allocated objects which could be stolen from a dormant
fscrypt_info much easier.

So this change makes crypt_info->ci_enc_key a pointer and updates all
users thereof.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c          |  2 +-
 fs/crypto/fname.c           |  4 ++--
 fs/crypto/fscrypt_private.h |  2 +-
 fs/crypto/inline_crypt.c    |  4 ++--
 fs/crypto/keysetup.c        | 16 +++++++++++-----
 fs/crypto/keysetup_v1.c     |  2 +-
 6 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 6a837e4b80dc..9f3bda18c797 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -108,7 +108,7 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist dst, src;
 	struct fscrypt_info *ci = inode->i_crypt_info;
-	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
+	struct crypto_skcipher *tfm = ci->ci_enc_key->tfm;
 	int res = 0;
 
 	if (WARN_ON_ONCE(len <= 0))
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 6eae3f12ad50..edb78cd1b0e7 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -101,7 +101,7 @@ int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
 	const struct fscrypt_info *ci = inode->i_crypt_info;
-	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
+	struct crypto_skcipher *tfm = ci->ci_enc_key->tfm;
 	union fscrypt_iv iv;
 	struct scatterlist sg;
 	int res;
@@ -158,7 +158,7 @@ static int fname_decrypt(const struct inode *inode,
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist src_sg, dst_sg;
 	const struct fscrypt_info *ci = inode->i_crypt_info;
-	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
+	struct crypto_skcipher *tfm = ci->ci_enc_key->tfm;
 	union fscrypt_iv iv;
 	int res;
 
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 7ab5a7b7eef8..5011737b60b3 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -198,7 +198,7 @@ struct fscrypt_prepared_key {
 struct fscrypt_info {
 
 	/* The key in a form prepared for actual encryption/decryption */
-	struct fscrypt_prepared_key ci_enc_key;
+	struct fscrypt_prepared_key *ci_enc_key;
 
 	/* True if ci_enc_key should be freed when this fscrypt_info is freed */
 	bool ci_owns_key;
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 8bfb3ce86476..2063f7941ce6 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -273,7 +273,7 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 	ci = inode->i_crypt_info;
 
 	fscrypt_generate_dun(ci, first_lblk, dun);
-	bio_crypt_set_ctx(bio, ci->ci_enc_key.blk_key, dun, gfp_mask);
+	bio_crypt_set_ctx(bio, ci->ci_enc_key->blk_key, dun, gfp_mask);
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx);
 
@@ -360,7 +360,7 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 	 * uses the same pointer.  I.e., there's currently no need to support
 	 * merging requests where the keys are the same but the pointers differ.
 	 */
-	if (bc->bc_key != inode->i_crypt_info->ci_enc_key.blk_key)
+	if (bc->bc_key != inode->i_crypt_info->ci_enc_key->blk_key)
 		return false;
 
 	fscrypt_generate_dun(inode->i_crypt_info, next_lblk, next_dun);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 8b32200dbbc0..f07e3b9579cf 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -181,7 +181,11 @@ void fscrypt_destroy_prepared_key(struct super_block *sb,
 int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
 {
 	ci->ci_owns_key = true;
-	return fscrypt_prepare_key(&ci->ci_enc_key, raw_key, ci);
+	ci->ci_enc_key = kzalloc(sizeof(*ci->ci_enc_key), GFP_KERNEL);
+	if (!ci->ci_enc_key)
+		return -ENOMEM;
+
+	return fscrypt_prepare_key(ci->ci_enc_key, raw_key, ci);
 }
 
 static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
@@ -242,7 +246,7 @@ static int find_mode_prepared_key(struct fscrypt_info *ci,
 
 	prep_key = &keys[mode_num];
 	if (fscrypt_is_key_prepared(prep_key, ci)) {
-		ci->ci_enc_key = *prep_key;
+		ci->ci_enc_key = prep_key;
 		return 0;
 	}
 	err = setup_new_mode_prepared_key(mk, prep_key, ci, hkdf_context,
@@ -250,7 +254,7 @@ static int find_mode_prepared_key(struct fscrypt_info *ci,
 	if (err)
 		return err;
 
-	ci->ci_enc_key = *prep_key;
+	ci->ci_enc_key = prep_key;
 	return 0;
 }
 
@@ -537,9 +541,11 @@ static void put_crypt_info(struct fscrypt_info *ci)
 
 	if (ci->ci_direct_key)
 		fscrypt_put_direct_key(ci->ci_direct_key);
-	else if (ci->ci_owns_key)
+	else if (ci->ci_owns_key) {
 		fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
-					     &ci->ci_enc_key);
+					     ci->ci_enc_key);
+		kfree(ci->ci_enc_key);
+	}
 
 	mk = ci->ci_master_key;
 	if (mk) {
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 75dabd9b27f9..e1d761e8067f 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -259,7 +259,7 @@ static int setup_v1_file_key_direct(struct fscrypt_info *ci,
 	if (IS_ERR(dk))
 		return PTR_ERR(dk);
 	ci->ci_direct_key = dk;
-	ci->ci_enc_key = dk->dk_key;
+	ci->ci_enc_key = &dk->dk_key;
 	return 0;
 }
 
-- 
2.40.0

