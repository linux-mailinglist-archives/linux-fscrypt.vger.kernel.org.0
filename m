Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BD479057C
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Sep 2023 07:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351612AbjIBF4B (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 2 Sep 2023 01:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjIBF4B (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 2 Sep 2023 01:56:01 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD8E10F5;
        Fri,  1 Sep 2023 22:55:57 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 5206E803B8;
        Sat,  2 Sep 2023 01:55:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1693634157; bh=fiVfVaVeSO8+LySxAwlXQQui2JcU6Eza8j+LxYs3Nmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sad7seUUZDFSagU6zNxRvOfHcLYcFTFtetX1d5k4LkRk9Br4FlEdH8UjjUKClaQQV
         tzblnBeRBNdJRtAX+z8gv7sBGm05e9Ag+QsrlAqfrOipIdjryuLlTQc+s2LdWcElbx
         4FBDjhoQOTI18U9G4noc4BkAspiqXqoNwiuJWavrbWVwLsHWX0h8Y7Lz1yaes8qBFz
         5R86mnv3h52SQELApB03aVOtC2LFPMj9Pi9e21F2Lk3rtxu8gCL5RAJRgX3l2sHMIT
         A9Z6He4NVfZi0mEutvvlYHpCkou8Mo8tsdf39OtTgmLIzUuaGhni+o1DWd/aSbMWfz
         wADXuNc2T9gnw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ebiggers@kernel.org, ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 05/13] fscrypt: add creation/usage/freeing of per-extent infos
Date:   Sat,  2 Sep 2023 01:54:23 -0400
Message-ID: <7045a2f0f411494e53b6ef1f995bd0e4cfc73f17.1693630890.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1693630890.git.sweettea-kernel@dorminy.me>
References: <cover.1693630890.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 fs/crypto/crypto.c          | 14 +++++-
 fs/crypto/fscrypt_private.h | 53 ++++++++++++++++++--
 fs/crypto/inline_crypt.c    |  5 ++
 fs/crypto/keysetup.c        | 97 +++++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h     | 41 ++++++++++++++++
 5 files changed, 204 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index d5c9326a1919..5a93c30e6b86 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -40,6 +40,7 @@ static struct workqueue_struct *fscrypt_read_workqueue;
 static DEFINE_MUTEX(fscrypt_init_mutex);
 
 struct kmem_cache *fscrypt_inode_info_cachep;
+struct kmem_cache *fscrypt_extent_info_cachep;
 
 void fscrypt_enqueue_decrypt_work(struct work_struct *work)
 {
@@ -113,6 +114,8 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 	struct crypto_skcipher *tfm = cci->ci_enc_key->tfm;
 	int res = 0;
 
+	if (WARN_ON_ONCE(!cci))
+		return -EINVAL;
 	if (WARN_ON_ONCE(len <= 0))
 		return -EINVAL;
 	if (WARN_ON_ONCE(len % FSCRYPT_CONTENTS_ALIGNMENT != 0))
@@ -397,13 +400,20 @@ static int __init fscrypt_init(void)
 	if (!fscrypt_inode_info_cachep)
 		goto fail_free_queue;
 
+	fscrypt_extent_info_cachep = KMEM_CACHE(fscrypt_extent_info,
+						SLAB_RECLAIM_ACCOUNT);
+	if (!fscrypt_extent_info_cachep)
+		goto fail_free_inode_info;
+
 	err = fscrypt_init_keyring();
 	if (err)
-		goto fail_free_info;
+		goto fail_free_extent_info;
 
 	return 0;
 
-fail_free_info:
+fail_free_extent_info:
+	kmem_cache_destroy(fscrypt_extent_info_cachep);
+fail_free_inode_info:
 	kmem_cache_destroy(fscrypt_inode_info_cachep);
 fail_free_queue:
 	destroy_workqueue(fscrypt_read_workqueue);
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index cc1a61ade2a4..9320428f8915 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -294,13 +294,47 @@ struct fscrypt_info {
 };
 
 /*
+ * fscrypt_extent_info - the "encryption key" for an extent
  */
+struct fscrypt_extent_info {
+	struct fscrypt_common_info info;
+};
 
 typedef enum {
 	FS_DECRYPT = 0,
 	FS_ENCRYPT,
 } fscrypt_direction_t;
 
+/**
+ * fscrypt_fs_uses_extent_encryption() -- whether a filesystem uses extent
+ *					  encryption
+ *
+ * @sb: the superblock of the relevant filesystem
+ *
+ * Return: true if the fs uses extent encryption, else false
+ */
+static inline bool
+fscrypt_fs_uses_extent_encryption(const struct super_block *sb)
+{
+	return !!sb->s_cop->get_extent_info;
+}
+
+/**
+ * fscrypt_uses_extent_encryption() -- whether an inode uses extent encryption
+ *
+ * @inode: the inode in question
+ *
+ * Return: true if the inode uses extent encryption, else false
+ */
+static inline bool fscrypt_uses_extent_encryption(const struct inode *inode)
+{
+	/* Non-regular files don't have extents. */
+	if (!S_ISREG(inode->i_mode))
+		return false;
+
+	return fscrypt_fs_uses_extent_encryption(inode->i_sb);
+}
+
 /**
  * fscrypt_get_lblk_info() - get the fscrypt_common_info to crypt a particular
  *			     block
@@ -313,15 +347,26 @@ typedef enum {
  *              always be @lblk; for extent-based encryption, this will be in
  *              the range [0, lblk]. Can be NULL
  * @extent_len: a pointer to return the minimum number of lblks starting at
- *              this offset which also belong to the same fscrypt_info. Can be
- *              NULL
+ *              this offset which also belong to the same fscrypt_common_info.
+ *              Can be NULL
  *
- * Return: the appropriate fscrypt_info if there is one, else NULL.
+ * Return: the appropriate fscrypt_common_info if there is one, else NULL.
  */
 static inline struct fscrypt_common_info *
 fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
 		      u64 *extent_len)
 {
+	if (fscrypt_uses_extent_encryption(inode)) {
+		struct fscrypt_extent_info *cei;
+		int res;
+
+		res = inode->i_sb->s_cop->get_extent_info(inode, lblk, &cei,
+							  offset, extent_len);
+		if (res == 0)
+			return &cei->info;
+		return NULL;
+	}
+
 	if (offset)
 		*offset = lblk;
 	if (extent_len)
@@ -330,9 +375,9 @@ fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
 	return &inode->i_crypt_info->info;
 }
 
-
 /* crypto.c */
 extern struct kmem_cache *fscrypt_inode_info_cachep;
+extern struct kmem_cache *fscrypt_extent_info_cachep;
 int fscrypt_initialize(struct super_block *sb);
 int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 			u64 lblk_num, struct page *src_page,
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 09ec82b8a98a..f0229234249c 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -272,6 +272,8 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 	if (!fscrypt_inode_uses_inline_crypto(inode))
 		return;
 	cci = fscrypt_get_lblk_info(inode, first_lblk, &ci_offset, NULL);
+	if (!cci)
+		return;
 
 	fscrypt_generate_dun(cci, ci_offset, dun);
 	bio_crypt_set_ctx(bio, cci->ci_enc_key->blk_key, dun, gfp_mask);
@@ -359,6 +361,9 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 		return true;
 
 	cci = fscrypt_get_lblk_info(inode, next_lblk, &ci_offset, NULL);
+	if (!cci)
+		return false;
+
 	/*
 	 * Comparing the key pointers is good enough, as all I/O for each key
 	 * uses the same pointer.  I.e., there's currently no need to support
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index ae250e432dcd..c9c16acf4c9b 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -957,3 +957,100 @@ int fscrypt_drop_inode(struct inode *inode)
 	return !is_master_key_secret_present(&ci->info.ci_master_key->mk_secret);
 }
 EXPORT_SYMBOL_GPL(fscrypt_drop_inode);
+
+static void put_crypt_extent_info(struct fscrypt_extent_info *ci)
+{
+	if (!ci)
+		return;
+
+	free_prepared_key(&ci->info);
+	remove_info_from_mk_decrypted_list(&ci->info);
+
+	memzero_explicit(ci, sizeof(*ci));
+	kmem_cache_free(fscrypt_extent_info_cachep, ci);
+}
+
+static int
+fscrypt_setup_extent_info(struct inode *inode,
+			  const union fscrypt_policy *policy,
+			  const u8 nonce[FSCRYPT_FILE_NONCE_SIZE],
+			  struct fscrypt_extent_info **info_ptr)
+{
+	struct fscrypt_extent_info *crypt_extent_info;
+	struct fscrypt_common_info *crypt_info;
+	struct fscrypt_master_key *mk = NULL;
+	int res;
+
+	crypt_extent_info = kmem_cache_zalloc(fscrypt_extent_info_cachep,
+					      GFP_KERNEL);
+	if (!crypt_extent_info)
+		return -ENOMEM;
+	crypt_info = &crypt_extent_info->info;
+
+	res = fscrypt_setup_common_info(crypt_info, inode, policy, nonce,
+					CI_EXTENT, &mk);
+	if (res)
+		goto out;
+
+	*info_ptr = crypt_extent_info;
+	add_info_to_mk_decrypted_list(crypt_info, mk);
+
+	crypt_extent_info = NULL;
+	res = 0;
+out:
+	if (mk) {
+		up_read(&mk->mk_sem);
+		fscrypt_put_master_key(mk);
+	}
+	put_crypt_extent_info(crypt_extent_info);
+	return res;
+}
+
+/**
+ * fscrypt_prepare_new_extent() - set up the fscrypt_extent_info for a new extent
+ * @inode: the inode to which the extent belongs
+ * @info_ptr: a pointer to return the extent's fscrypt_extent_info into
+ * *
+ * If the extent is part of an encrypted inode, set up a fscrypt_extent_info in
+ * preparation for encrypting data.
+ *
+ * This isn't %GFP_NOFS-safe.
+ *
+ * This doesn't persist the new extent's encryption context.  That still needs to
+ * be done later by calling fscrypt_set_extent_context().
+ *
+ * Return: 0 on success, -ENOKEY if the encryption key is missing, or another
+ *	   -errno code
+ */
+int fscrypt_prepare_new_extent(struct inode *inode,
+			       struct fscrypt_extent_info **info_ptr)
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
+	return fscrypt_setup_extent_info(inode, policy, nonce,
+					 info_ptr);
+}
+EXPORT_SYMBOL_GPL(fscrypt_prepare_new_extent);
+
+/**
+ * fscrypt_free_extent_info() - free an extent's fscrypt_extent_info
+ * @info_ptr: a pointer containing the extent's fscrypt_extent_info pointer.
+ */
+void fscrypt_free_extent_info(struct fscrypt_extent_info **info_ptr)
+{
+	put_crypt_extent_info(*info_ptr);
+	*info_ptr = NULL;
+}
+EXPORT_SYMBOL_GPL(fscrypt_free_extent_info);
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index c895b12737a1..cc5de5ec888c 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -32,6 +32,7 @@
 
 union fscrypt_policy;
 struct fscrypt_info;
+struct fscrypt_extent_info;
 struct fs_parameter;
 struct seq_file;
 
@@ -113,6 +114,29 @@ struct fscrypt_operations {
 	int (*set_context)(struct inode *inode, const void *ctx, size_t len,
 			   void *fs_data);
 
+	/*
+	 * Get the fscrypt_info for the given inode at the given block, for
+	 * extent-based encryption only.
+	 *
+	 * @inode: the inode in question
+	 * @lblk: the logical block number in question
+	 * @ci: a pointer to return the fscrypt_extent_info
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
+			       struct fscrypt_extent_info **ci, u64 *offset,
+			       u64 *extent_len);
+
 	/*
 	 * Get the dummy fscrypt policy in use on the filesystem (if any).
 	 *
@@ -330,6 +354,10 @@ void fscrypt_put_encryption_info(struct inode *inode);
 void fscrypt_free_inode(struct inode *inode);
 int fscrypt_drop_inode(struct inode *inode);
 
+int fscrypt_prepare_new_extent(struct inode *inode,
+			       struct fscrypt_extent_info **info_ptr);
+void fscrypt_free_extent_info(struct fscrypt_extent_info **info_ptr);
+
 /* fname.c */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 			  u8 *out, unsigned int olen);
@@ -591,6 +619,19 @@ static inline int fscrypt_drop_inode(struct inode *inode)
 	return 0;
 }
 
+static inline int
+fscrypt_prepare_new_extent(struct inode *inode,
+			   struct fscrypt_extent_info **info_ptr)
+{
+	if (IS_ENCRYPTED(inode))
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static inline void fscrypt_free_extent_info(struct fscrypt_extent_info **info_ptr)
+{
+}
+
  /* fname.c */
 static inline int fscrypt_setup_filename(struct inode *dir,
 					 const struct qstr *iname,
-- 
2.41.0

