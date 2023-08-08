Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9867743A4
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbjHHSIP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235265AbjHHSHp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:07:45 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F5B15C7A2;
        Tue,  8 Aug 2023 10:08:55 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 3199C83543;
        Tue,  8 Aug 2023 13:08:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514535; bh=fOSvrrVtQ5iVMFBJHPU0XoJq9Jff085wcvNJlZttEIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ixv/kZv1JgW6Iwe6b9oWHgaCvuzgbYKXaIwRuaU7Uje5ghwIlTGMx3x5SoPoJepfc
         /hVadZUafX4Z60mfT57uOTQkty5IK+hk00DVFQfNZBneAkQzOqwaL+CuoE24/qi7tj
         JeUb2g8w3f1zKj4PBZxZiBgwJCLwfzmC1hzonuQ1S5DANswymNA/fG7OhGXFgMbVOg
         WZigw9FQN4d4iRe32s91L4PPP4M29jHCYORGtavhXnc5XD4Guyq+s4QE+JgOzs6WaN
         X/dE8UU9kSbC+FCdlAXwCdR7MgjJd7PsinenLLCz38xR3RYAkNl/B5EyS+8nOH5I7+
         A75o3LVJEJPww==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 10/16] fscrypt: add creation/usage/freeing of per-extent infos
Date:   Tue,  8 Aug 2023 13:08:27 -0400
Message-ID: <9405e6a6ea1891b0fbe5b3e871b80b4079ab4df6.1691505882.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This change adds the superblock function pointer to get the info
corresponding to a specific block in an inode for a filesystem using
per-extent infos. It allows creating a info for a new extent and freeing
that info, and uses the extent's info if appropriate in encrypting
blocks of data.

It also makes sure that the return value of fscrypt_get_lblk_info() is
non-NULL before using it, since there's no longer a mechanical guarantee
that we'll never call fscrypt_get_lblk_info() without having the
relevant info loaded. We *oughtn't*, but we're not explicitly checking
that it's loaded before these points.

This change does not deal with saving and loading an extent's info, but
introduces the mechanics necessary therefore.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c          |  2 +
 fs/crypto/fscrypt_private.h | 74 +++++++++++++++++++++----------------
 fs/crypto/inline_crypt.c    |  5 ++-
 fs/crypto/keysetup.c        | 54 +++++++++++++++++++++++++++
 include/linux/fscrypt.h     | 39 +++++++++++++++++++
 5 files changed, 141 insertions(+), 33 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index d75f1b3f5795..0f0c721e40fe 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -113,6 +113,8 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 	struct crypto_skcipher *tfm = ci->ci_enc_key->tfm;
 	int res = 0;
 
+	if (!ci)
+		return -EINVAL;
 	if (WARN_ON_ONCE(len <= 0))
 		return -EINVAL;
 	if (WARN_ON_ONCE(len % FSCRYPT_CONTENTS_ALIGNMENT != 0))
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 21e4e138cfcc..c6bf0bd0259a 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -287,31 +287,17 @@ typedef enum {
 } fscrypt_direction_t;
 
 /**
- * fscrypt_get_lblk_info() - get the fscrypt_info to crypt a particular block
+ * fscrypt_fs_uses_extent_encryption() -- whether a filesystem uses per-extent
+ *				          encryption
  *
- * @inode:      the inode to which the block belongs
- * @lblk:       the offset of the block within the file which the inode
- *              references
- * @offset:     a pointer to return the offset of the block from the first block
- *              that the info covers. For inode-based encryption, this will
- *              always be @lblk; for extent-based encryption, this will be in
- *              the range [0, lblk]. Can be NULL
- * @extent_len: a pointer to return the minimum number of lblks starting at
- *              this offset which also belong to the same fscrypt_info. Can be
- *              NULL
+ * @sb: the superblock of the filesystem in question
  *
- * Return: the appropriate fscrypt_info if there is one, else NULL.
+ * Return: true if the fs uses per-extent fscrypt_infos, false otherwise
  */
-static inline struct fscrypt_info *
-fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
-		      u64 *extent_len)
+static inline bool
+fscrypt_fs_uses_extent_encryption(const struct super_block *sb)
 {
-	if (offset)
-		*offset = lblk;
-	if (extent_len)
-		*extent_len = U64_MAX;
-
-	return inode->i_crypt_info;
+	return !!sb->s_cop->get_extent_info;
 }
 
 /**
@@ -324,27 +310,51 @@ fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
  */
 static inline bool fscrypt_uses_extent_encryption(const struct inode *inode)
 {
-	/* Non-regular files don't have extents */
+	/* Non-regular files don't have extents. */
 	if (!S_ISREG(inode->i_mode))
 		return false;
 
-	/* No filesystems currently use per-extent infos */
-	return false;
+	return fscrypt_fs_uses_extent_encryption(inode->i_sb);
 }
 
+
 /**
- * fscrypt_fs_uses_extent_encryption() -- whether a filesystem uses per-extent
- *				          encryption
+ * fscrypt_get_lblk_info() - get the fscrypt_info to crypt a particular block
  *
- * @sb: the superblock of the filesystem in question
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
  *
- * Return: true if the fs uses per-extent fscrypt_infos, false otherwise
+ * Return: the appropriate fscrypt_info if there is one, else NULL.
  */
-static inline bool
-fscrypt_fs_uses_extent_encryption(const struct super_block *sb)
+static inline struct fscrypt_info *
+fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
+		      u64 *extent_len)
 {
-	// No filesystems currently use per-extent infos
-	return false;
+	if (fscrypt_uses_extent_encryption(inode)) {
+		struct fscrypt_info *info;
+		int res;
+
+		res = inode->i_sb->s_cop->get_extent_info(inode, lblk, &info,
+							  offset, extent_len);
+		if (res == 0)
+			return info;
+		return NULL;
+	}
+
+	if (offset)
+		*offset = lblk;
+	if (extent_len)
+		*extent_len = U64_MAX;
+
+	return inode->i_crypt_info;
 }
 
 /**
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 260152d5e673..76274b736e1a 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -271,7 +271,10 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 
 	if (!fscrypt_inode_uses_inline_crypto(inode))
 		return;
+
 	ci = fscrypt_get_lblk_info(inode, first_lblk, &ci_offset, NULL);
+	if (!ci)
+		return;
 
 	fscrypt_generate_dun(ci, ci_offset, dun);
 	bio_crypt_set_ctx(bio, ci->ci_enc_key->blk_key, dun, gfp_mask);
@@ -364,7 +367,7 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 	 * uses the same pointer.  I.e., there's currently no need to support
 	 * merging requests where the keys are the same but the pointers differ.
 	 */
-	if (bc->bc_key != ci->ci_enc_key->blk_key)
+	if (!ci || bc->bc_key != ci->ci_enc_key->blk_key)
 		return false;
 
 	fscrypt_generate_dun(ci, ci_offset, next_dun);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 51d3787fc964..c4ec042ca892 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -929,6 +929,60 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(fscrypt_prepare_new_inode);
 
+/**
+ * fscrypt_prepare_new_extent() - set up the fscrypt_info for a new extent
+ * @inode: the inode to which the extent belongs
+ * @info_ptr: a pointer to return the extent's fscrypt_info into. Should be
+ *	      a pointer to a member of the extent struct, as it will be passed
+ *	      back to the filesystem if key removal demands removal of the
+ *	      info from the extent
+ * @encrypt_ret: (output) set to %true if the new inode will be encrypted
+ *
+ * If the extent is part of an encrypted inode, set up its fscrypt_info in
+ * preparation for encrypting data and set *encrypt_ret=true.
+ *
+ * This isn't %GFP_NOFS-safe, and therefore it should be called before starting
+ * any filesystem transaction to create the inode.
+ *
+ * This doesn't persist the new inode's encryption context.  That still needs to
+ * be done later by calling fscrypt_set_context().
+ *
+ * Return: 0 on success, -ENOKEY if the encryption key is missing, or another
+ *	   -errno code
+ */
+int fscrypt_prepare_new_extent(struct inode *inode,
+			       struct fscrypt_info **info_ptr)
+{
+	const union fscrypt_policy *policy;
+	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
+
+	policy = fscrypt_policy_to_inherit(inode);
+	if (policy == NULL)
+		return 0;
+	if (IS_ERR(policy))
+		return PTR_ERR(policy);
+
+	/* Only regular files can have extents.  */
+	if (WARN_ON_ONCE(!S_ISREG(inode->i_mode)))
+		return -EINVAL;
+
+	get_random_bytes(nonce, FSCRYPT_FILE_NONCE_SIZE);
+	return fscrypt_setup_encryption_info(inode, policy, nonce,
+					     false, info_ptr);
+}
+EXPORT_SYMBOL_GPL(fscrypt_prepare_new_extent);
+
+/**
+ * fscrypt_free_extent_info() - free an extent's fscrypt_info
+ * @info_ptr: a pointer containing the extent's fscrypt_info pointer.
+ */
+void fscrypt_free_extent_info(struct fscrypt_info **info_ptr)
+{
+	put_crypt_info(*info_ptr);
+	*info_ptr = NULL;
+}
+EXPORT_SYMBOL_GPL(fscrypt_free_extent_info);
+
 /**
  * fscrypt_put_encryption_info() - free most of an inode's fscrypt data
  * @inode: an inode being evicted
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 2a64e7a71a53..e39165fbed41 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -113,6 +113,29 @@ struct fscrypt_operations {
 	int (*set_context)(struct inode *inode, const void *ctx, size_t len,
 			   void *fs_data);
 
+	/*
+	 * Get the fscrypt_info for the given inode at the given block, for
+	 * extent-based encryption only.
+	 *
+	 * @inode: the inode in question
+	 * @lblk: the logical block number in question
+	 * @ci: a pointer to return the fscrypt_info
+	 * @offset: a pointer to return the offset of @lblk into the extent,
+	 *          in blocks (may be NULL)
+	 * @extent_len: a pointer to return the number of blocks in this extent
+	 *              starting at this point (may be NULL)
+	 *
+	 * May cause the filesystem to allocate memory, which the filesystem
+	 * must do with %GFP_NOFS, including calls into fscrypt to create or
+	 * load an fscrypt_info.
+	 *
+	 * Return: 0 if an extent is found with an info, -ENODATA if the key is
+	 *         unavailable, or another -errno.
+	 */
+	int (*get_extent_info)(const struct inode *inode, u64 lblk,
+			       struct fscrypt_info **ci, u64 *offset,
+			       u64 *extent_len);
+
 	/*
 	 * Get the dummy fscrypt policy in use on the filesystem (if any).
 	 *
@@ -339,6 +362,10 @@ void fscrypt_put_encryption_info(struct inode *inode);
 void fscrypt_free_inode(struct inode *inode);
 int fscrypt_drop_inode(struct inode *inode);
 
+int fscrypt_prepare_new_extent(struct inode *inode,
+			       struct fscrypt_info **info_ptr);
+void fscrypt_free_extent_info(struct fscrypt_info **info_ptr);
+
 /* fname.c */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 			  u8 *out, unsigned int olen);
@@ -600,6 +627,18 @@ static inline int fscrypt_drop_inode(struct inode *inode)
 	return 0;
 }
 
+static inline int fscrypt_prepare_new_extent(struct inode *inode,
+					     struct fscrypt_info **info_ptr)
+{
+	if (IS_ENCRYPTED(inode))
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static inline void fscrypt_free_extent_info(struct fscrypt_info **info_ptr)
+{
+}
+
  /* fname.c */
 static inline int fscrypt_setup_filename(struct inode *dir,
 					 const struct qstr *iname,
-- 
2.41.0

