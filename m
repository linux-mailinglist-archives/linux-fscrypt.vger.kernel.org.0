Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BF477439F
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbjHHSIK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbjHHSHo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:07:44 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7DEA799;
        Tue,  8 Aug 2023 10:08:44 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 21BCC83543;
        Tue,  8 Aug 2023 13:08:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514524; bh=kxcFIEA+Tz7C5XSXfEIV9jwTiWVBlr8UrdIiPo4CwNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RpXbYm2oW73XnXn6IIAir2piVjayWKOmwlkRCBPGqvC41pgZrJaFnIBJMocEd5WY0
         HWG81e29yLflbD8mmMt9Uyq6VSA4mP/C6dlVZutDaIMQd+6BwBKGWaS2AJoqbOQ2nP
         99ofWSwfE+8gB3qAZxKnIu1p6vf2qwP3hqjBlo6nVH0zirqcPy+NNI4GUv0D1HOFvV
         5Gps7z7XkAZR8OAgFcFqDj8IDUDEy4qQeLC4Y6ki5Yn/BUhBD2qRM7MbSlqNETr0jt
         BCs862L2paztf1EqKV9na+F+KgZyQV185lveTIkQB83b8h42q9vYZNAr99voA432xJ
         K7YIefx2piozQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 02/16] fscrypt: factor getting info for a specific block
Date:   Tue,  8 Aug 2023 13:08:19 -0400
Message-ID: <88e9d0d51a7adff46ebca4868e802d2b598f27d7.1691505882.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

For filesystems using extent-based encryption, the content of each
extent will be encrypted with a different fscrypt_info for each extent.
Meanwhile, directories and symlinks will continue to use the
fscrypt_info for the inode. Therefore, merely grabbing
inode->i_crypt_info will be insufficient; the caller must specifically
request the inode info or the info for a specific block.

Add fscrypt_get_lblk_info() to get info for a specific block, and update
all relevant callsites.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c          |  3 ++-
 fs/crypto/fscrypt_private.h | 29 +++++++++++++++++++++++++++++
 fs/crypto/inline_crypt.c    | 10 ++++++----
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 9f3bda18c797..1b7e375b1c6b 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -107,7 +107,8 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist dst, src;
-	struct fscrypt_info *ci = inode->i_crypt_info;
+	struct fscrypt_info *ci =
+		fscrypt_get_lblk_info(inode, lblk_num, NULL, NULL);
 	struct crypto_skcipher *tfm = ci->ci_enc_key->tfm;
 	int res = 0;
 
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index e2acd8894ea7..8a1fd1d33cfc 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -277,6 +277,35 @@ typedef enum {
 	FS_ENCRYPT,
 } fscrypt_direction_t;
 
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
+	return inode->i_crypt_info;
+}
+
+
 /* crypto.c */
 extern struct kmem_cache *fscrypt_info_cachep;
 int fscrypt_initialize(struct super_block *sb);
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 2063f7941ce6..885a2ec3d711 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -270,7 +270,7 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 
 	if (!fscrypt_inode_uses_inline_crypto(inode))
 		return;
-	ci = inode->i_crypt_info;
+	ci = fscrypt_get_lblk_info(inode, first_lblk, NULL, NULL);
 
 	fscrypt_generate_dun(ci, first_lblk, dun);
 	bio_crypt_set_ctx(bio, ci->ci_enc_key->blk_key, dun, gfp_mask);
@@ -349,21 +349,23 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
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
-	if (bc->bc_key != inode->i_crypt_info->ci_enc_key->blk_key)
+	if (bc->bc_key != ci->ci_enc_key->blk_key)
 		return false;
 
-	fscrypt_generate_dun(inode->i_crypt_info, next_lblk, next_dun);
+	fscrypt_generate_dun(ci, next_lblk, next_dun);
 	return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
 }
 EXPORT_SYMBOL_GPL(fscrypt_mergeable_bio);
@@ -465,7 +467,7 @@ u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
 	if (nr_blocks <= 1)
 		return nr_blocks;
 
-	ci = inode->i_crypt_info;
+	ci = fscrypt_get_lblk_info(inode, lblk, NULL, NULL);
 	if (!(fscrypt_policy_flags(&ci->ci_policy) &
 	      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))
 		return nr_blocks;
-- 
2.41.0

