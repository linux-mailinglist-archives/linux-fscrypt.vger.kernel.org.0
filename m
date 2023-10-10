Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0EB7C416E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbjJJUlR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234416AbjJJUlN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:13 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A98EA7
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:09 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-59f6441215dso75755027b3.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970468; x=1697575268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ptIykhvVmDV5wYmbmhkhou1KdWmw8NP+zHPSeBcATWU=;
        b=J2Yn96UvMXSVCiMs2b+YgkcYW9RnFa0V/y/A1K8qcDpAtJ1ACutYMXx+6RTi7buGOL
         15wLMYSxhRG6WEA1gZlGBmb3rNG5JKeykQ6c1q+Dv+iaQpiYYDab5MHr84yxEXvZZUF4
         GZmGleyL5I0t4W8CdFu+fUQTu6FrOUz+rYApH/jZwmeRGFImDX26b/hdJcAB1aPXyKVv
         6pwzp2LigpTcnBJxPlr8Js7wfhjNoo6d8V102Ht6aVZ6jBxIADC5+QE/9vi2wXuh29q8
         PlV6yGpyWuRknl5jaMfLL45GPibxxVH4RPuqCyf0K44OWHeGWrbao+/COVcK9E2j4h+g
         8zbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970468; x=1697575268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ptIykhvVmDV5wYmbmhkhou1KdWmw8NP+zHPSeBcATWU=;
        b=Yem3J7FGk55zBGgD0B2axiEMIXXeJ0M7SRxFZA/1ZR+BRJ9xcYXVXikifKPBZw0GMt
         lsiFZLaQbWBRlLgBGKOSKv9A0DKKuwO05oWpni9aAj23QM8qGuyame+vyUcIUpMW648R
         BonkP5XdeojO5uus3HyWCLHoW5x9CWCy0DxFSLd7TZnHNNM3249AJRcd8dZvMRhZ1lBh
         41GKVBHwa0IHZcgCe1meK3/eVbTCo5xIMs2uEU66kceJ5r8jMKdJrWaDK1Iov/qDFWzj
         272OaGcb8B6L2xOqApTNY0kkk1tiuIyaU0QyqIav4w6zIsQNWBN4KosmPrvXDy9VLgco
         gQkA==
X-Gm-Message-State: AOJu0YzLBWJgiT/8LbmlBDJyPkTpiBmBJAxC3SSd5dRBluMKQ3OLHFiw
        ITepuH7hpBCZnfLWzIWRm+0NM+AVuQTzqxWNXn+2wA==
X-Google-Smtp-Source: AGHT+IGScARPLfxJAJxWq4Ayy1mL7Y/VqtKIttBRulZlEyVjZxjIWSk5h2DRzV2cHEZoG0D2o+OmyA==
X-Received: by 2002:a25:b203:0:b0:d9a:61d1:3a85 with SMTP id i3-20020a25b203000000b00d9a61d13a85mr2597733ybj.0.1696970467579;
        Tue, 10 Oct 2023 13:41:07 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id x142-20020a25ce94000000b00d89679f6d22sm795669ybe.64.2023.10.10.13.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:06 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 03/36] fscrypt: add per-extent encryption support
Date:   Tue, 10 Oct 2023 16:40:18 -0400
Message-ID: <f2096b710ebad976d9bb5f3176e6c6fa8bab19dc.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 fs/crypto/fscrypt_private.h |  44 ++++++++++
 fs/crypto/inline_crypt.c    |  84 +++++++++++++++++++
 fs/crypto/keysetup.c        | 155 ++++++++++++++++++++++++++++++++++++
 fs/crypto/policy.c          |  47 +++++++++++
 include/linux/fscrypt.h     |  71 +++++++++++++++++
 6 files changed, 410 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 328470d40dec..18bd96b9db4e 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -40,6 +40,7 @@ static struct workqueue_struct *fscrypt_read_workqueue;
 static DEFINE_MUTEX(fscrypt_init_mutex);
 
 struct kmem_cache *fscrypt_inode_info_cachep;
+struct kmem_cache *fscrypt_extent_info_cachep;
 
 void fscrypt_enqueue_decrypt_work(struct work_struct *work)
 {
@@ -414,12 +415,19 @@ static int __init fscrypt_init(void)
 	if (!fscrypt_inode_info_cachep)
 		goto fail_free_queue;
 
+	fscrypt_extent_info_cachep = KMEM_CACHE(fscrypt_extent_info,
+						SLAB_RECLAIM_ACCOUNT);
+	if (!fscrypt_extent_info_cachep)
+		goto fail_free_inode_info;
+
 	err = fscrypt_init_keyring();
 	if (err)
-		goto fail_free_inode_info;
+		goto fail_free_extent_info;
 
 	return 0;
 
+fail_free_extent_info:
+	kmem_cache_destroy(fscrypt_extent_info_cachep);
 fail_free_inode_info:
 	kmem_cache_destroy(fscrypt_inode_info_cachep);
 fail_free_queue:
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index f44342f17269..c672c3e537f3 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -30,6 +30,8 @@
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
 
+#define FSCRYPT_EXTENT_CONTEXT_V1	1
+
 /* Keep this in sync with include/uapi/linux/fscrypt.h */
 #define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
 
@@ -53,6 +55,28 @@ struct fscrypt_context_v2 {
 	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
 };
 
+/*
+ * fscrypt_extent_context - the encryption context of an extent
+ *
+ * This is the on-disk information stored for an extent.  The policy and
+ * relevante information is stored in the inode, the per-extent information is
+ * simply the nonce that's used in as KDF input in conjunction with the inode
+ * context to derive a per-extent key for encryption.
+ *
+ * At this point the master_key_identifier exists only for possible future
+ * expansion.  This will allow for an inode to have extents with multiple master
+ * keys, although sharing the same encryption mode.  This would be for re-keying
+ * or for reflinking between two differently encrypted inodes.  For now the
+ * master_key_descriptor must match the inode's, and we'll be using the inode's
+ * for all key derivation.
+ */
+struct fscrypt_extent_context {
+	u8 version; /* FSCRYPT_EXTENT_CONTEXT_V2 */
+	u8 encryption_mode;
+	u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
+	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
+};
+
 /*
  * fscrypt_context - the encryption context of an inode
  *
@@ -288,6 +312,25 @@ struct fscrypt_inode_info {
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
@@ -295,6 +338,7 @@ typedef enum {
 
 /* crypto.c */
 extern struct kmem_cache *fscrypt_inode_info_cachep;
+extern struct kmem_cache *fscrypt_extent_info_cachep;
 int fscrypt_initialize(struct super_block *sb);
 int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
 			    fscrypt_direction_t rw, u64 index,
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index b4002aea7cdb..4eeb75410ba8 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -279,6 +279,40 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
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
@@ -370,6 +404,56 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(fscrypt_mergeable_bio);
 
+/**
+ * fscrypt_mergeable_extent_bio() - test whether data can be added to a bio
+ * @bio: the bio being built up
+ * @inode: the inode for the next part of the I/O
+ * @ei: the fscrypt_extent_info for this extent
+ * @next_lblk: the next file logical block number in the I/O
+ *
+ * When building a bio which may contain data which should undergo inline
+ * encryption (or decryption) via fscrypt, filesystems should call this function
+ * to ensure that the resulting bio contains only contiguous data unit numbers.
+ * This will return false if the next part of the I/O cannot be merged with the
+ * bio because either the encryption key would be different or the encryption
+ * data unit numbers would be discontiguous.
+ *
+ * fscrypt_set_bio_crypt_ctx_from_extent() must have already been called on the
+ * bio.
+ *
+ * This function isn't required in cases where crypto-mergeability is ensured in
+ * another way, such as I/O targeting only a single file (and thus a single key)
+ * combined with fscrypt_limit_io_blocks() to ensure DUN contiguity.
+ *
+ * Return: true iff the I/O is mergeable
+ */
+bool fscrypt_mergeable_extent_bio(struct bio *bio, const struct inode *inode,
+				  const struct fscrypt_extent_info *ei,
+				  u64 next_lblk)
+{
+	const struct bio_crypt_ctx *bc = bio->bi_crypt_context;
+	u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
+
+	if (!ei)
+		return true;
+	if (!!bc != fscrypt_inode_uses_inline_crypto(inode))
+		return false;
+	if (!bc)
+		return true;
+
+	/*
+	 * Comparing the key pointers is good enough, as all I/O for each key
+	 * uses the same pointer.  I.e., there's currently no need to support
+	 * merging requests where the keys are the same but the pointers differ.
+	 */
+	if (bc->bc_key != ei->prep_key.blk_key)
+		return false;
+
+	fscrypt_generate_dun(inode->i_crypt_info, next_lblk, next_dun);
+	return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
+}
+EXPORT_SYMBOL_GPL(fscrypt_mergeable_extent_bio);
+
 /**
  * fscrypt_mergeable_bio_bh() - test whether data can be added to a bio
  * @bio: the bio being built up
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 92eca1400b2d..6d1f00be44f8 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -811,3 +811,158 @@ int fscrypt_drop_inode(struct inode *inode)
 	return !is_master_key_secret_present(ci->ci_master_key);
 }
 EXPORT_SYMBOL_GPL(fscrypt_drop_inode);
+
+static struct fscrypt_extent_info *
+setup_extent_info(struct inode *inode, const u8 nonce[FSCRYPT_FILE_NONCE_SIZE])
+{
+	struct fscrypt_extent_info *ei;
+	struct fscrypt_inode_info *ci;
+	struct fscrypt_master_key *mk;
+	u8 derived_key[FSCRYPT_MAX_KEY_SIZE];
+	int err;
+
+	ci = inode->i_crypt_info;
+	mk = ci->ci_master_key;
+	if (!mk)
+		return ERR_PTR(-ENOKEY);
+
+	ei = kmem_cache_zalloc(fscrypt_extent_info_cachep, GFP_KERNEL);
+	if (!ei)
+		return ERR_PTR(-ENOMEM);
+
+	refcount_set(&ei->refs, 1);
+	memcpy(ei->nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
+	ei->sb = inode->i_sb;
+
+	down_read(&mk->mk_sem);
+	/*
+	 * We specifically don't do is_master_key_secret_present() here because
+	 * if the inode is open and has a reference on the master key then it
+	 * should be available for us to use.
+	 */
+
+	err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
+				  HKDF_CONTEXT_PER_FILE_ENC_KEY, ei->nonce,
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
+	const struct fscrypt_inode_info *ci = inode->i_crypt_info;
+	const struct fscrypt_policy_v2 *policy = &ci->ci_policy.v2;
+
+	if (!fscrypt_inode_uses_inline_crypto(inode))
+		return ERR_PTR(-EOPNOTSUPP);
+	if (ctx_size < sizeof(extent_ctx))
+		return ERR_PTR(-EINVAL);
+
+	memcpy(&extent_ctx, ctx, sizeof(extent_ctx));
+
+	/*
+	 * For now we need to validate that the master key for the inode matches
+	 * the extent.
+	 */
+	if (memcmp(extent_ctx.master_key_identifier,
+		   policy->master_key_identifier,
+		   sizeof(extent_ctx.master_key_identifier)))
+		return ERR_PTR(-EINVAL);
+
+	return setup_extent_info(inode, extent_ctx.nonce);
+}
+EXPORT_SYMBOL(fscrypt_load_extent_info);
+
+/**
+ * fscrypt_put_extent_info() - free the extent_info fscrypt data
+ * @ei: the extent_info being evicted
+ *
+ * Drop a reference and possibly free the fscrypt_extent_info.
+ *
+ * Note this will unload the key from the block layer, which takes the crypto
+ * profile semaphore to unload the key.  Make sure you're not dropping this in a
+ * context that can't sleep.
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
index 701259991277..4729f21e21d8 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -789,6 +789,53 @@ int fscrypt_set_context(struct inode *inode, void *fs_data)
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
+ * Return: the size of the fscrypt_extent_context, errno if the inode has the
+ *	   wrong policy version.
+ */
+ssize_t fscrypt_set_extent_context(struct inode *inode,
+				   struct fscrypt_extent_info *ei, u8 *buf)
+{
+	struct fscrypt_extent_context *ctx = (struct fscrypt_extent_context *)buf;
+	const struct fscrypt_inode_info *ci = inode->i_crypt_info;
+
+	if (ci->ci_policy.version != 2)
+		return -EINVAL;
+
+	ctx->version = 1;
+	memcpy(ctx->master_key_identifier,
+	       ci->ci_policy.v2.master_key_identifier,
+	       sizeof(ctx->master_key_identifier));
+	memcpy(ctx->nonce, ei->nonce, FSCRYPT_FILE_NONCE_SIZE);
+	return sizeof(struct fscrypt_extent_context);
+}
+EXPORT_SYMBOL_GPL(fscrypt_set_extent_context);
+
+/**
+ * fscrypt_extent_context_size() - Return the size of the on-disk extent context
+ * @inode: the inode this extent belongs to.
+ *
+ * Return the size of the extent context for this inode.  Since there is only
+ * one extent context version currently this is just the size of the extent
+ * context if the inode is encrypted.
+ */
+size_t fscrypt_extent_context_size(struct inode *inode)
+{
+	if (!IS_ENCRYPTED(inode))
+		return 0;
+
+	return sizeof(struct fscrypt_extent_context);
+}
+EXPORT_SYMBOL_GPL(fscrypt_extent_context_size);
+
 /**
  * fscrypt_parse_test_dummy_encryption() - parse the test_dummy_encryption mount option
  * @param: the mount option
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 12f9e455d569..ea8fdc6f3b83 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -32,6 +32,7 @@
 
 union fscrypt_policy;
 struct fscrypt_inode_info;
+struct fscrypt_extent_info;
 struct fs_parameter;
 struct seq_file;
 
@@ -97,6 +98,14 @@ struct fscrypt_operations {
 	 */
 	unsigned int supports_subblock_data_units : 1;
 
+	/*
+	 * If set then extent based encryption will be used for this file
+	 * system, and fs/crypto/ will enforce limits on the policies that are
+	 * allowed to be chosen.  Currently this means only plain v2 policies
+	 * are supported.
+	 */
+	unsigned int has_per_extent_encryption : 1;
+
 	/*
 	 * This field exists only for backwards compatibility reasons and should
 	 * only be set by the filesystems that are setting it already.  It
@@ -308,6 +317,11 @@ int fscrypt_ioctl_get_nonce(struct file *filp, void __user *arg);
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child);
 int fscrypt_context_for_new_inode(void *ctx, struct inode *inode);
 int fscrypt_set_context(struct inode *inode, void *fs_data);
+ssize_t fscrypt_set_extent_context(struct inode *inode,
+				   struct fscrypt_extent_info *ei, u8 *buf);
+struct fscrypt_extent_info *fscrypt_load_extent_info(struct inode *inode,
+						     u8 *ctx, size_t ctx_size);
+size_t fscrypt_extent_context_size(struct inode *inode);
 
 struct fscrypt_dummy_policy {
 	const union fscrypt_policy *policy;
@@ -344,6 +358,9 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 void fscrypt_put_encryption_info(struct inode *inode);
 void fscrypt_free_inode(struct inode *inode);
 int fscrypt_drop_inode(struct inode *inode);
+struct fscrypt_extent_info *fscrypt_prepare_new_extent(struct inode *inode);
+void fscrypt_put_extent_info(struct fscrypt_extent_info *ei);
+struct fscrypt_extent_info *fscrypt_get_extent_info(struct fscrypt_extent_info *ei);
 
 /* fname.c */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
@@ -555,6 +572,24 @@ fscrypt_free_dummy_policy(struct fscrypt_dummy_policy *dummy_policy)
 {
 }
 
+static inline ssize_t
+fscrypt_set_extent_context(struct inode *inode, struct fscrypt_extent_info *ei,
+			   u8 *buf)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline struct fscrypt_extent_info *
+fscrypt_load_extent_info(struct inode *inode, u8 *ctx, size_t ctx_size)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline size_t fscrypt_extent_context_size(struct inode *inode)
+{
+	return 0;
+}
+
 /* keyring.c */
 static inline void fscrypt_destroy_keyring(struct super_block *sb)
 {
@@ -607,6 +642,20 @@ static inline int fscrypt_drop_inode(struct inode *inode)
 	return 0;
 }
 
+static inline struct fscrypt_extent_info *
+fscrypt_prepare_new_extent(struct inode *inode)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline void fscrypt_put_extent_info(struct fscrypt_extent_info *ei) { }
+
+static inline struct fscrypt_extent_info *
+fscrypt_get_extent_info(struct fscrypt_extent_info *ei)
+{
+	return ei;
+}
+
  /* fname.c */
 static inline int fscrypt_setup_filename(struct inode *dir,
 					 const struct qstr *iname,
@@ -788,6 +837,11 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio,
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
@@ -798,6 +852,10 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 bool fscrypt_mergeable_bio_bh(struct bio *bio,
 			      const struct buffer_head *next_bh);
 
+bool fscrypt_mergeable_extent_bio(struct bio *bio, const struct inode *inode,
+				  const struct fscrypt_extent_info *ei,
+				  u64 next_lblk);
+
 bool fscrypt_dio_supported(struct inode *inode);
 
 u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks);
@@ -813,6 +871,11 @@ static inline void fscrypt_set_bio_crypt_ctx(struct bio *bio,
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
@@ -825,6 +888,14 @@ static inline bool fscrypt_mergeable_bio(struct bio *bio,
 	return true;
 }
 
+static inline bool fscrypt_mergeable_extent_bio(struct bio *bio,
+						const struct inode *inode,
+						const struct fscrypt_extent_info *ei,
+						u64 next_lblk)
+{
+	return true;
+}
+
 static inline bool fscrypt_mergeable_bio_bh(struct bio *bio,
 					    const struct buffer_head *next_bh)
 {
-- 
2.41.0

