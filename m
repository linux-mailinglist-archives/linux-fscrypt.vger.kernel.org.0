Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C1C7A1285
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Sep 2023 02:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjIOAsz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 14 Sep 2023 20:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjIOAsz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 14 Sep 2023 20:48:55 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5561826B8
        for <linux-fscrypt@vger.kernel.org>; Thu, 14 Sep 2023 17:48:51 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-4121788397fso12514861cf.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 14 Sep 2023 17:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1694738930; x=1695343730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VHxasxPzlM7gSK+4lCZU3UQ7GN+BnRfxyDsB+mM7MsU=;
        b=mRuxVBEzjUWhDZnPnt+OKuK2oCYCRfsn/WZtYLow2+5rKnys4fB3NZ1XdxXlvJeihG
         OOlUy2+2kq5NHpRG3kbt71nvW83IyquX0LSq8BsI3H8mdqTvRc+tu4B9fZl7OEqQw6tv
         wCFQ3GSDAQ4RMg5TDEJkwEQ4GVF5cnDhdubHMxbz+tjC8DU6wLSc78Ttv5zEHqGSYFNr
         Y1mEQ0D+s0XY03QcXothXM0rrGwZV3oFDdmvYZlJSINLdT1oFGRgBZc0Wx1+9fDwsI08
         TWuT11oedXUvLlEjfPSrN0yCDx1NQJmyO55lb2bjTA1XKX4od0aiHb0xaYWP2JZtI5hK
         Nfyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694738930; x=1695343730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VHxasxPzlM7gSK+4lCZU3UQ7GN+BnRfxyDsB+mM7MsU=;
        b=IM9uonYbQgfmbfn2BExixqRkMOdwaOoI/e6v12AKY/G/VgaGV+bM3KJjmYKM3yFN3W
         6clkLs7GvcJAvxw2UTdej3iFpm7phEJIFqAPwFYegVdKO9sjYAqF//z1oKEM7/y8K8WK
         53sUlJnr/airXpG/09KzCABcqEU3PJ00mhRNePzqZZS/E739jYtkfBLZci6unKUDsRm1
         eFcEwL1XT6d4SI5PwcEy+5yHf0aJVI8Os9inwqspjXknQ9Xv9fbgS2PYJ5JG1UjBA2ia
         m4cm1euQXGB/9wYWu38vDF7OPZtT8fE5+Xh5YlVQmWEmOJSIQQ8Mur6WWdtX3ytnGPVO
         Xsbg==
X-Gm-Message-State: AOJu0Yz8savDBM6WObn4qhg0qPf0WBr/xza+qiU6WCEu8+zXLjYKpMmQ
        7+GJPPAwjx9yPXtC9FbJd7inFQ==
X-Google-Smtp-Source: AGHT+IFm45hooztaHinViIdTLjikL5qr6TYi7KTqfhSwJSaLBHdWR9VHUcNUyhFHlL1mb1k1bNkdTA==
X-Received: by 2002:a05:622a:1452:b0:412:18c6:438b with SMTP id v18-20020a05622a145200b0041218c6438bmr4932725qtx.13.1694738930394;
        Thu, 14 Sep 2023 17:48:50 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d26-20020ac8669a000000b00403ff38d855sm831329qtp.4.2023.09.14.17.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 17:48:50 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        clm@fb.com, ebiggers@kernel.org, ngompa13@gmail.com,
        sweettea-kernel@dorminy.me, kernel-team@meta.com
Subject: [PATCH 2/4] fscrypt: add per-extent encryption support
Date:   Thu, 14 Sep 2023 20:47:43 -0400
Message-ID: <29b2303463c3b4978d17a6a257e7a8aa3da23de4.1694738282.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694738282.git.josef@toxicpanda.com>
References: <cover.1694738282.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This adds the code necessary for per-extent encryption.  We will store a
nonce for every extent we create, and then use the inode's policy and
the extents nonce to derive a per-extent key.

This is meant to be flexible, if we choose to expand the on-disk extent
information in the future we have a version number we can use to change
what exists on disk.

The file system indicates it wants to use per-extent encryption by
setting s_cop->set_extent_context.  This also requires the use of inline
block encryption.

The support is relatively straightforward, the only "extra" bit is we're
deriving a per-extent key to use for the encryption, the inode still
controls the policy and access to the master key.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/crypto/crypto.c          |  10 ++-
 fs/crypto/fscrypt_private.h |  36 ++++++++++
 fs/crypto/inline_crypt.c    |  34 +++++++++
 fs/crypto/keysetup.c        | 136 ++++++++++++++++++++++++++++++++++++
 fs/crypto/policy.c          |  22 ++++++
 include/linux/fscrypt.h     |  21 ++++++
 6 files changed, 258 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 2b2bb5740322..e3ba06cb4082 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -40,6 +40,7 @@ static struct workqueue_struct *fscrypt_read_workqueue;
 static DEFINE_MUTEX(fscrypt_init_mutex);
 
 struct kmem_cache *fscrypt_inode_info_cachep;
+struct kmem_cache *fscrypt_extent_info_cachep;
 
 void fscrypt_enqueue_decrypt_work(struct work_struct *work)
 {
@@ -396,12 +397,19 @@ static int __init fscrypt_init(void)
 	if (!fscrypt_inode_info_cachep)
 		goto fail_free_queue;
 
+	fscrypt_extent_info_cachep = KMEM_CACHE(fscrypt_extent_info,
+						SLAB_RECLAIM_ACCOUNT);
+	if (!fscrypt_extent_info_cachep)
+		goto fail_free_info;
+
 	err = fscrypt_init_keyring();
 	if (err)
-		goto fail_free_info;
+		goto fail_free_extent_info;
 
 	return 0;
 
+fail_free_extent_info:
+	kmem_cache_destroy(fscrypt_extent_info_cachep);
 fail_free_info:
 	kmem_cache_destroy(fscrypt_inode_info_cachep);
 fail_free_queue:
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index b982073d1fe2..7e5ab3695023 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -30,6 +30,8 @@
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
 
+#define FSCRYPT_EXTENT_CONTEXT_V1	1
+
 /* Keep this in sync with include/uapi/linux/fscrypt.h */
 #define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
 
@@ -52,6 +54,19 @@ struct fscrypt_context_v2 {
 	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
 };
 
+/*
+ * fscrypt_extent_context - the encryption context of an extent
+ *
+ * This is the on-disk information stored for an extent.  The policy and
+ * relevante information is stored in the inode, the per-extent information is
+ * simply the nonce that's used in as KDF input in conjunction with the inode
+ * context to derive a per-extent key for encryption.
+ */
+struct fscrypt_extent_context {
+	u8 version; /* FSCRYPT_EXTENT_CONTEXT_V2 */
+	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
+};
+
 /*
  * fscrypt_context - the encryption context of an inode
  *
@@ -260,6 +275,25 @@ struct fscrypt_inode_info {
 	u32 ci_hashed_ino;
 };
 
+/*
+ * fscrypt_extent_info - the "encryption key" for an extent.
+ *
+ * This contains the dervied key for the given extent and the nonce for the
+ * extent.
+ */
+struct fscrypt_extent_info {
+	refcount_t refs;
+
+	/* The derived key for this extent. */
+	struct fscrypt_prepared_key prep_key;
+
+	/* The super block that this extent belongs to. */
+	struct super_block *sb;
+
+	/* This is the extents nonce, loaded from the fscrypt_extent_context */
+	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
+};
+
 typedef enum {
 	FS_DECRYPT = 0,
 	FS_ENCRYPT,
@@ -267,6 +301,7 @@ typedef enum {
 
 /* crypto.c */
 extern struct kmem_cache *fscrypt_inode_info_cachep;
+extern struct kmem_cache *fscrypt_extent_info_cachep;
 int fscrypt_initialize(struct super_block *sb);
 int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 			u64 lblk_num, struct page *src_page,
@@ -326,6 +361,7 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 #define HKDF_CONTEXT_DIRHASH_KEY	5 /* info=file_nonce		*/
 #define HKDF_CONTEXT_IV_INO_LBLK_32_KEY	6 /* info=mode_num||fs_uuid	*/
 #define HKDF_CONTEXT_INODE_HASH_KEY	7 /* info=<empty>		*/
+#define HKDF_CONTEXT_PER_EXTENT_ENC_KEY	8 /* info=extent_nonce		*/
 
 int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
 			const u8 *info, unsigned int infolen,
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 3cfb04b8b64f..69bb6ac9a7f7 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -278,6 +278,40 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx);
 
+/**
+ * fscrypt_set_bio_crypt_ctx() - prepare a file contents bio for inline crypto
+ * @bio: a bio which will eventually be submitted to the file
+ * @inode: the file's inode
+ * @ei: the extent's crypto info
+ * @first_lblk: the first file logical block number in the I/O
+ * @gfp_mask: memory allocation flags - these must be a waiting mask so that
+ *					bio_crypt_set_ctx can't fail.
+ *
+ * If the contents of the file should be encrypted (or decrypted) with inline
+ * encryption, then assign the appropriate encryption context to the bio.
+ *
+ * Normally the bio should be newly allocated (i.e. no pages added yet), as
+ * otherwise fscrypt_mergeable_bio() won't work as intended.
+ *
+ * The encryption context will be freed automatically when the bio is freed.
+ */
+void fscrypt_set_bio_crypt_ctx_from_extent(struct bio *bio,
+					   const struct inode *inode,
+					   const struct fscrypt_extent_info *ei,
+					   u64 first_lblk, gfp_t gfp_mask)
+{
+	const struct fscrypt_inode_info *ci;
+	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
+
+	if (!fscrypt_inode_uses_inline_crypto(inode))
+		return;
+	ci = inode->i_crypt_info;
+
+	fscrypt_generate_dun(ci, first_lblk, dun);
+	bio_crypt_set_ctx(bio, ei->prep_key.blk_key, dun, gfp_mask);
+}
+EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx_from_extent);
+
 /* Extract the inode and logical block number from a buffer_head. */
 static bool bh_get_inode_and_lblk_num(const struct buffer_head *bh,
 				      const struct inode **inode_ret,
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index cbcbe582737e..a7fc191efc06 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -806,3 +806,139 @@ int fscrypt_drop_inode(struct inode *inode)
 	return !is_master_key_secret_present(&ci->ci_master_key->mk_secret);
 }
 EXPORT_SYMBOL_GPL(fscrypt_drop_inode);
+
+static struct fscrypt_extent_info *setup_extent_info(struct inode *inode,
+						     const u8 nonce[FSCRYPT_FILE_NONCE_SIZE])
+{
+	struct fscrypt_extent_info *ei;
+	struct fscrypt_inode_info *ci;
+	struct fscrypt_master_key *mk;
+	u8 derived_key[FSCRYPT_MAX_KEY_SIZE];
+	int err;
+
+	ci = inode->i_crypt_info;
+
+	ei = kmem_cache_zalloc(fscrypt_extent_info_cachep, GFP_KERNEL);
+	if (!ei)
+		return ERR_PTR(-ENOMEM);
+
+	refcount_set(&ei->refs, 1);
+	memcpy(ei->nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
+	ei->sb = inode->i_sb;
+
+	mk = ci->ci_master_key;
+	down_read(&mk->mk_sem);
+	if (!is_master_key_secret_present(&mk->mk_secret)) {
+		err = -ENOKEY;
+		goto out_free;
+	}
+
+	err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
+				  HKDF_CONTEXT_PER_EXTENT_ENC_KEY, ei->nonce,
+				  FSCRYPT_FILE_NONCE_SIZE, derived_key,
+				  ci->ci_mode->keysize);
+	if (err)
+		goto out_free;
+
+	err = fscrypt_prepare_inline_crypt_key(&ei->prep_key, derived_key, ci);
+	memzero_explicit(derived_key, ci->ci_mode->keysize);
+	if (err)
+		goto out_free;
+	up_read(&mk->mk_sem);
+	return ei;
+out_free:
+	up_read(&mk->mk_sem);
+	memzero_explicit(ei, sizeof(*ei));
+	kmem_cache_free(fscrypt_extent_info_cachep, ei);
+	return ERR_PTR(err);
+}
+
+/**
+ * fscrypt_prepare_new_extent() - prepare to create a new extent for a file
+ * @inode: the possibly-encrypted inode
+ *
+ * If the inode is encrypted, setup the fscrypt_extent_info for a new extent.
+ * This will include the nonce and the derived key necessary for the extent to
+ * be encrypted.  This is only meant to be used with inline crypto.
+ *
+ * This doesn't persist the new extents encryption context, this is done later
+ * by calling fscrypt_set_extent_context().
+ *
+ * Return: The newly allocated fscrypt_extent_info on success, -EOPNOTSUPP if
+ *	   we're not encrypted, or another -errno code
+ */
+struct fscrypt_extent_info *fscrypt_prepare_new_extent(struct inode *inode)
+{
+	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
+
+	if (!fscrypt_inode_uses_inline_crypto(inode))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	get_random_bytes(nonce, FSCRYPT_FILE_NONCE_SIZE);
+	return setup_extent_info(inode, nonce);
+}
+EXPORT_SYMBOL_GPL(fscrypt_prepare_new_extent);
+
+/**
+ * fscrypt_load_extent_info() - create an fscrypt_extent_info from the context
+ * @inode: the inode
+ * @ctx: the context buffer
+ * @ctx_size: the size of the context buffer
+ *
+ * Create the file_extent_info and derive the key based on the
+ * fscrypt_extent_context buffer that is probided.
+ *
+ * Return: The newly allocated fscrypt_extent_info on success, -EOPNOTSUPP if
+ *	   we're not encrypted, or another -errno code
+ */
+struct fscrypt_extent_info *fscrypt_load_extent_info(struct inode *inode,
+						     u8 *ctx, size_t ctx_size)
+{
+	struct fscrypt_extent_context extent_ctx;
+
+	if (!fscrypt_inode_uses_inline_crypto(inode))
+		return ERR_PTR(-EOPNOTSUPP);
+	if (ctx_size < sizeof(extent_ctx))
+		return ERR_PTR(-EINVAL);
+
+	memcpy(&extent_ctx, ctx, sizeof(ctx));
+	return setup_extent_info(inode, extent_ctx.nonce);
+}
+EXPORT_SYMBOL(fscrypt_load_extent_info);
+
+/**
+ * fscrypt_put_extent_info() - free the extent_info fscrypt data
+ * @ei: the extent_info being evicted
+ *
+ * Drop a reference and possibly free the fscrypt_extent_info.
+ */
+void fscrypt_put_extent_info(struct fscrypt_extent_info *ei)
+{
+	if (!ei)
+		return;
+
+	if (!refcount_dec_and_test(&ei->refs))
+		return;
+
+	fscrypt_destroy_prepared_key(ei->sb, &ei->prep_key);
+	memzero_explicit(ei, sizeof(*ei));
+	kmem_cache_free(fscrypt_extent_info_cachep, ei);
+}
+EXPORT_SYMBOL_GPL(fscrypt_put_extent_info);
+
+/**
+ * fscrypt_get_extent_info() - get a ref on the fscrypt extent info
+ * @ei: the extent_info to get.
+ *
+ * Get a reference on the fscrypt_extent_info.
+ *
+ * Return: the ei with an extra ref, NULL if there was no ei passed in.
+ */
+struct fscrypt_extent_info *fscrypt_get_extent_info(struct fscrypt_extent_info *ei)
+{
+	if (!ei)
+		return NULL;
+	refcount_inc(&ei->refs);
+	return ei;
+}
+EXPORT_SYMBOL_GPL(fscrypt_get_extent_info);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index aa94bfe6c172..cb944338271d 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -763,6 +763,28 @@ int fscrypt_set_context(struct inode *inode, void *fs_data)
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_context);
 
+/**
+ * fscrypt_set_extent_context() - Set the fscrypt extent context of a new extent
+ * @inode: the inode this extent belongs to
+ * @ei: the fscrypt_extent_info for the given extent
+ * @buf: the buffer to copy the fscrypt extent context into
+ *
+ * This should be called after fscrypt_prepare_new_extent(), using the
+ * fscrypt_extent_info that was created at that point.
+ *
+ * Return: the size of the fscrypt_extent_context.
+ */
+size_t fscrypt_set_extent_context(struct inode *inode,
+				  struct fscrypt_extent_info *ei, u8 *buf)
+{
+	struct fscrypt_extent_context *ctx = (struct fscrypt_extent_context *)buf;
+
+	ctx->version = 1;
+	memcpy(ctx->nonce, ei->nonce, FSCRYPT_FILE_NONCE_SIZE);
+	return sizeof(struct fscrypt_extent_context);
+}
+EXPORT_SYMBOL_GPL(fscrypt_set_extent_context);
+
 /**
  * fscrypt_parse_test_dummy_encryption() - parse the test_dummy_encryption mount option
  * @param: the mount option
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index ece426ac1d73..b01327191b4a 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -32,6 +32,7 @@
 
 union fscrypt_policy;
 struct fscrypt_inode_info;
+struct fscrypt_extent_info;
 struct fs_parameter;
 struct seq_file;
 
@@ -66,6 +67,9 @@ struct fscrypt_name {
  */
 #define FS_CFLG_OWN_PAGES (1U << 1)
 
+/* If set, the file system is using extent based encryption. */
+#define FS_CFLG_EXTENT_ENCRYPTION (1U << 2)
+
 /* Crypto operations for filesystems */
 struct fscrypt_operations {
 
@@ -293,6 +297,10 @@ int fscrypt_ioctl_get_nonce(struct file *filp, void __user *arg);
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child);
 int fscrypt_context_for_new_inode(void *ctx, struct inode *inode);
 int fscrypt_set_context(struct inode *inode, void *fs_data);
+size_t fscrypt_set_extent_context(struct inode *inode,
+				  struct fscrypt_extent_info *ei, u8 *buf);
+struct fscrypt_extent_info *fscrypt_load_extent_info(struct inode *inode,
+						     u8 *ctx, size_t ctx_size);
 
 struct fscrypt_dummy_policy {
 	const union fscrypt_policy *policy;
@@ -329,6 +337,9 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 void fscrypt_put_encryption_info(struct inode *inode);
 void fscrypt_free_inode(struct inode *inode);
 int fscrypt_drop_inode(struct inode *inode);
+struct fscrypt_extent_info *fscrypt_prepare_new_extent(struct inode *inode);
+void fscrypt_put_extent_info(struct fscrypt_extent_info *ei);
+struct fscrypt_extent_info *fscrypt_get_extent_info(struct fscrypt_extent_info *ei);
 
 /* fname.c */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
@@ -772,6 +783,11 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio,
 			       const struct inode *inode, u64 first_lblk,
 			       gfp_t gfp_mask);
 
+void fscrypt_set_bio_crypt_ctx_from_extent(struct bio *bio,
+					   const struct inode *inode,
+					   const struct fscrypt_extent_info *ei,
+					   u64 first_lblk, gfp_t gfp_mask);
+
 void fscrypt_set_bio_crypt_ctx_bh(struct bio *bio,
 				  const struct buffer_head *first_bh,
 				  gfp_t gfp_mask);
@@ -797,6 +813,11 @@ static inline void fscrypt_set_bio_crypt_ctx(struct bio *bio,
 					     const struct inode *inode,
 					     u64 first_lblk, gfp_t gfp_mask) { }
 
+static inline void fscrypt_set_bio_crypt_ctx_from_extent(struct bio *bio,
+					const struct inode *inode,
+					const struct fscrypt_extent_info *ei,
+					u64 first_lblk, gfp_t gfp_mask) { }
+
 static inline void fscrypt_set_bio_crypt_ctx_bh(
 					 struct bio *bio,
 					 const struct buffer_head *first_bh,
-- 
2.41.0

