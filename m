Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A0E7AF226
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbjIZSD2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbjIZSD1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:27 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2684A10A
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:17 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-77409065623so557798385a.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751396; x=1696356196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qHTfmhZkLVoy1LsAIrl2EgcMX1KOx4Ne7j6F4pFm9/g=;
        b=IQ7l3oOXKJ2oEM0H0/jeAtl/b3C0DJt6MOfTBJF6rAI+1gpdCmg17oEayrbDCHxj91
         qupPsXvo+CIzxu4mEHmKP1n+upMERi34DEFLYq+CfUbceajtAxBQbE7huCPo4OMUbOMS
         r4Nba2x/p2i6N7A12/E7ssiZ4/hr64WVXjyxfxwKbatoZJkWoR+Wl0ZjgMazor26OIBk
         ZzocMoS4k5urgaJ0NHQC5KVHWbl7UE4ufU+6CwRruz59YNGymCBGJKqH/92fYAkgrYDx
         d9Bcb2wX5sdyfYmOAgvFz0tNO7U8KUljpcquMxghIhvaQ7isyx/cO//QruySLZCQN163
         eXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751396; x=1696356196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qHTfmhZkLVoy1LsAIrl2EgcMX1KOx4Ne7j6F4pFm9/g=;
        b=GAumPyfTtRGzTfVS9i0ggL8fMUbYnth1rSssc1tCZumX6hgX//68xS9SLe1TABpyhq
         ZJebVu8NwkN8uP/9xoMX9MN8fitp2wfeQ8xcmGtvFvTLieaop8M6MKYy5bArSYSs9vpE
         dulRvNEAXKLCtmBXj4/PAIhV2M5Mi3SOKvH44aZhc5CliQkjDpuqvNNIOAqNxEmTOYqc
         H5Z4dKho/bm0UN1ByTg+Rn29lfd2Ef8Mjhob62PB0UYgrFIVGL/ygpZcJBpXwahxTCe/
         pTmKS3kyIofe54T8g+JNfgzUclapE2Fq3yTpfSP1C3LAwm8g1TsZHqLGZgMqidP4CGtM
         RsAw==
X-Gm-Message-State: AOJu0YyGu7NIL0uFToIfyGbHwZeDrsYyDjBB1TuMJck1a7H+e7lhHWlB
        DxC2sukUkDfTyLmz20g87UTHMQ==
X-Google-Smtp-Source: AGHT+IHSQ679CijQOpdFJJbHD/hIB54OkkfKZd2ZBRuSrpjRwQ7W7lq4cVz0Gc2XAbRZz3qc72bdYA==
X-Received: by 2002:a05:620a:1998:b0:76f:24d2:e232 with SMTP id bm24-20020a05620a199800b0076f24d2e232mr10717412qkb.47.1695751396025;
        Tue, 26 Sep 2023 11:03:16 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id c26-20020a05620a11ba00b0076cb1eff83csm4899171qkk.5.2023.09.26.11.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:15 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 02/35] fscrypt: add per-extent encryption support
Date:   Tue, 26 Sep 2023 14:01:28 -0400
Message-ID: <3e82fb910f3f66bc0af854948c18a7cf476bbb1a.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 fs/crypto/fscrypt_private.h |  45 +++++++++++
 fs/crypto/inline_crypt.c    |  84 ++++++++++++++++++++
 fs/crypto/keysetup.c        | 152 ++++++++++++++++++++++++++++++++++++
 fs/crypto/policy.c          |  47 +++++++++++
 include/linux/fscrypt.h     |  66 ++++++++++++++++
 6 files changed, 403 insertions(+), 1 deletion(-)

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
index b982073d1fe2..a7e902813cde 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -30,6 +30,8 @@
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
 
+#define FSCRYPT_EXTENT_CONTEXT_V1	1
+
 /* Keep this in sync with include/uapi/linux/fscrypt.h */
 #define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
 
@@ -52,6 +54,28 @@ struct fscrypt_context_v2 {
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
@@ -260,6 +284,25 @@ struct fscrypt_inode_info {
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
@@ -267,6 +310,7 @@ typedef enum {
 
 /* crypto.c */
 extern struct kmem_cache *fscrypt_inode_info_cachep;
+extern struct kmem_cache *fscrypt_extent_info_cachep;
 int fscrypt_initialize(struct super_block *sb);
 int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 			u64 lblk_num, struct page *src_page,
@@ -326,6 +370,7 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 #define HKDF_CONTEXT_DIRHASH_KEY	5 /* info=file_nonce		*/
 #define HKDF_CONTEXT_IV_INO_LBLK_32_KEY	6 /* info=mode_num||fs_uuid	*/
 #define HKDF_CONTEXT_INODE_HASH_KEY	7 /* info=<empty>		*/
+#define HKDF_CONTEXT_PER_EXTENT_ENC_KEY	8 /* info=extent_nonce		*/
 
 int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
 			const u8 *info, unsigned int infolen,
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 3cfb04b8b64f..21e1851d4ba7 100644
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
@@ -369,6 +403,56 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
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
index cbcbe582737e..55716ed03478 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -806,3 +806,155 @@ int fscrypt_drop_inode(struct inode *inode)
 	return !is_master_key_secret_present(&ci->ci_master_key->mk_secret);
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
index aa94bfe6c172..8b8da04068b8 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -763,6 +763,53 @@ int fscrypt_set_context(struct inode *inode, void *fs_data)
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
index ece426ac1d73..266416742c72 100644
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
 
@@ -293,6 +297,11 @@ int fscrypt_ioctl_get_nonce(struct file *filp, void __user *arg);
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
@@ -329,6 +338,9 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 void fscrypt_put_encryption_info(struct inode *inode);
 void fscrypt_free_inode(struct inode *inode);
 int fscrypt_drop_inode(struct inode *inode);
+struct fscrypt_extent_info *fscrypt_prepare_new_extent(struct inode *inode);
+void fscrypt_put_extent_info(struct fscrypt_extent_info *ei);
+struct fscrypt_extent_info *fscrypt_get_extent_info(struct fscrypt_extent_info *ei);
 
 /* fname.c */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
@@ -539,6 +551,24 @@ fscrypt_free_dummy_policy(struct fscrypt_dummy_policy *dummy_policy)
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
@@ -591,6 +621,20 @@ static inline int fscrypt_drop_inode(struct inode *inode)
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
@@ -772,6 +816,11 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio,
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
@@ -782,6 +831,10 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 bool fscrypt_mergeable_bio_bh(struct bio *bio,
 			      const struct buffer_head *next_bh);
 
+bool fscrypt_mergeable_extent_bio(struct bio *bio, const struct inode *inode,
+				  const struct fscrypt_extent_info *ei,
+				  u64 next_lblk);
+
 bool fscrypt_dio_supported(struct inode *inode);
 
 u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks);
@@ -797,6 +850,11 @@ static inline void fscrypt_set_bio_crypt_ctx(struct bio *bio,
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
@@ -809,6 +867,14 @@ static inline bool fscrypt_mergeable_bio(struct bio *bio,
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

