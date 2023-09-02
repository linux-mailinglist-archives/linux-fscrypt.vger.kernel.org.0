Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E13790571
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Sep 2023 07:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjIBF4C (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 2 Sep 2023 01:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343615AbjIBF4B (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 2 Sep 2023 01:56:01 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CFB10F4;
        Fri,  1 Sep 2023 22:55:55 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 46AE1803B3;
        Sat,  2 Sep 2023 01:55:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1693634155; bh=92wmtNloBcIIjyPTTS4nZf/dWbNcmusT5rrcU+kWjSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9S8WHiXqVP17hCJiBaEttcXQ3MI6vHYHJYgWahGctkg6Ll9tzXacKy0L3OfIZ/81
         hSJ1CPedwWkFtwLB8rd0EkFpICezQyKv9obuaPb4+rW+PJRjR/tmI1i9pNrm9fC/qk
         wGrmxn7TtwBK97v5Y7BAbzWj44NyuCoclvemWhhCc5YOrtiW3llwehuKK/QTCOpEG+
         mmWo49A4/63Qg3jZ39vd6dTbjgArW/cahEH7a64Wj29VslvZXcERi8TvatsfR3QfED
         yeXvks48paySEZ7S1hgqfp5j7GVbhMJ7ZjxFGSeLIqxMOK2WjIvMuwQENfjFX6KrhS
         I9bqiBE+rqoKg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ebiggers@kernel.org, ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 04/13] fscrypt: split fscrypt_info into general and inode specific parts
Date:   Sat,  2 Sep 2023 01:54:22 -0400
Message-ID: <b8437c911db3a74aa6af3c1f58b8013d36d09271.1693630890.git.sweettea-kernel@dorminy.me>
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

In preparation for adding extent infos, split up the existing
fscrypt_info structure into a fscrypt_common_info structure which tracks
the information needed for data encryption and for freeing itself, and a
fscrypt_info structure containing a fscrypt_common_info and the parts only needed for inodes.
All external users continue to use a fscrypt_info, and most functions
don't need to deal with inode-specific parts so they use fscrypt_common_infos.

Similarly, split up the creation and freeing paths to have common parts that deal
with fscrypt_common_infos, and inode-specific parts dealing in
fscrypt_infos.

Alternately, the common struct could be a fscrypt_info, and only the
internal parts that need to deal in a specialized one could cast to the
enclosing specialized type; however, this seems to be less typesafe.
---
 fs/crypto/crypto.c          |  32 ++--
 fs/crypto/fname.c           |  13 +-
 fs/crypto/fscrypt_private.h | 122 +++++++++------
 fs/crypto/hooks.c           |   6 +-
 fs/crypto/inline_crypt.c    |  62 ++++----
 fs/crypto/keyring.c         |  40 ++---
 fs/crypto/keysetup.c        | 296 +++++++++++++++++++++---------------
 fs/crypto/keysetup_v1.c     |  74 ++++-----
 fs/crypto/policy.c          |  13 +-
 9 files changed, 371 insertions(+), 287 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index d75f1b3f5795..d5c9326a1919 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * This contains encryption functions for per-file encryption.
+ * This contains encryption functions for fscrypt encryption.
  *
  * Copyright (C) 2015, Google, Inc.
  * Copyright (C) 2015, Motorola Mobility
@@ -39,7 +39,7 @@ static mempool_t *fscrypt_bounce_page_pool = NULL;
 static struct workqueue_struct *fscrypt_read_workqueue;
 static DEFINE_MUTEX(fscrypt_init_mutex);
 
-struct kmem_cache *fscrypt_info_cachep;
+struct kmem_cache *fscrypt_inode_info_cachep;
 
 void fscrypt_enqueue_decrypt_work(struct work_struct *work)
 {
@@ -70,7 +70,7 @@ void fscrypt_free_bounce_page(struct page *bounce_page)
 EXPORT_SYMBOL(fscrypt_free_bounce_page);
 
 /*
- * Generate the IV for the given logical block number within the given file.
+ * Generate the IV for the given logical block number within the given info.
  * For filenames encryption, lblk_num == 0.
  *
  * Keep this in sync with fscrypt_limit_io_blocks().  fscrypt_limit_io_blocks()
@@ -78,21 +78,21 @@ EXPORT_SYMBOL(fscrypt_free_bounce_page);
  * simply contain the lblk_num (e.g., IV_INO_LBLK_32).
  */
 void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
-			 const struct fscrypt_info *ci)
+			 const struct fscrypt_common_info *cci)
 {
-	u8 flags = fscrypt_policy_flags(&ci->ci_policy);
+	u8 flags = fscrypt_policy_flags(&cci->ci_policy);
 
-	memset(iv, 0, ci->ci_mode->ivsize);
+	memset(iv, 0, cci->ci_mode->ivsize);
 
 	if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
 		WARN_ON_ONCE(lblk_num > U32_MAX);
-		WARN_ON_ONCE(ci->ci_inode->i_ino > U32_MAX);
-		lblk_num |= (u64)ci->ci_inode->i_ino << 32;
+		WARN_ON_ONCE(cci->ci_inode->i_ino > U32_MAX);
+		lblk_num |= (u64)cci->ci_inode->i_ino << 32;
 	} else if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
 		WARN_ON_ONCE(lblk_num > U32_MAX);
-		lblk_num = (u32)(ci->ci_hashed_ino + lblk_num);
+		lblk_num = (u32)(cci->ci_hashed_ino + lblk_num);
 	} else if (flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) {
-		memcpy(iv->nonce, ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE);
+		memcpy(iv->nonce, cci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE);
 	}
 	iv->lblk_num = cpu_to_le64(lblk_num);
 }
@@ -108,9 +108,9 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist dst, src;
 	u64 ci_offset = 0;
-	struct fscrypt_info *ci =
+	struct fscrypt_common_info *cci =
 		fscrypt_get_lblk_info(inode, lblk_num, &ci_offset, NULL);
-	struct crypto_skcipher *tfm = ci->ci_enc_key->tfm;
+	struct crypto_skcipher *tfm = cci->ci_enc_key->tfm;
 	int res = 0;
 
 	if (WARN_ON_ONCE(len <= 0))
@@ -118,7 +118,7 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 	if (WARN_ON_ONCE(len % FSCRYPT_CONTENTS_ALIGNMENT != 0))
 		return -EINVAL;
 
-	fscrypt_generate_iv(&iv, lblk_num, ci);
+	fscrypt_generate_iv(&iv, lblk_num, cci);
 
 	req = skcipher_request_alloc(tfm, gfp_flags);
 	if (!req)
@@ -393,8 +393,8 @@ static int __init fscrypt_init(void)
 	if (!fscrypt_read_workqueue)
 		goto fail;
 
-	fscrypt_info_cachep = KMEM_CACHE(fscrypt_info, SLAB_RECLAIM_ACCOUNT);
-	if (!fscrypt_info_cachep)
+	fscrypt_inode_info_cachep = KMEM_CACHE(fscrypt_info, SLAB_RECLAIM_ACCOUNT);
+	if (!fscrypt_inode_info_cachep)
 		goto fail_free_queue;
 
 	err = fscrypt_init_keyring();
@@ -404,7 +404,7 @@ static int __init fscrypt_init(void)
 	return 0;
 
 fail_free_info:
-	kmem_cache_destroy(fscrypt_info_cachep);
+	kmem_cache_destroy(fscrypt_inode_info_cachep);
 fail_free_queue:
 	destroy_workqueue(fscrypt_read_workqueue);
 fail:
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index edb78cd1b0e7..ae20a886dbdf 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -101,7 +101,8 @@ int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
 	const struct fscrypt_info *ci = inode->i_crypt_info;
-	struct crypto_skcipher *tfm = ci->ci_enc_key->tfm;
+	const struct fscrypt_common_info *cci = &ci->info;
+	struct crypto_skcipher *tfm = cci->ci_enc_key->tfm;
 	union fscrypt_iv iv;
 	struct scatterlist sg;
 	int res;
@@ -116,7 +117,7 @@ int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 	memset(out + iname->len, 0, olen - iname->len);
 
 	/* Initialize the IV */
-	fscrypt_generate_iv(&iv, 0, ci);
+	fscrypt_generate_iv(&iv, 0, cci);
 
 	/* Set up the encryption request */
 	req = skcipher_request_alloc(tfm, GFP_NOFS);
@@ -158,7 +159,8 @@ static int fname_decrypt(const struct inode *inode,
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist src_sg, dst_sg;
 	const struct fscrypt_info *ci = inode->i_crypt_info;
-	struct crypto_skcipher *tfm = ci->ci_enc_key->tfm;
+	const struct fscrypt_common_info *cci = &ci->info;
+	struct crypto_skcipher *tfm = cci->ci_enc_key->tfm;
 	union fscrypt_iv iv;
 	int res;
 
@@ -171,7 +173,7 @@ static int fname_decrypt(const struct inode *inode,
 		crypto_req_done, &wait);
 
 	/* Initialize IV */
-	fscrypt_generate_iv(&iv, 0, ci);
+	fscrypt_generate_iv(&iv, 0, cci);
 
 	/* Create decryption request */
 	sg_init_one(&src_sg, iname->name, iname->len);
@@ -299,7 +301,8 @@ bool __fscrypt_fname_encrypted_size(const union fscrypt_policy *policy,
 bool fscrypt_fname_encrypted_size(const struct inode *inode, u32 orig_len,
 				  u32 max_len, u32 *encrypted_len_ret)
 {
-	return __fscrypt_fname_encrypted_size(&inode->i_crypt_info->ci_policy,
+	struct fscrypt_common_info *cci = &inode->i_crypt_info->info;
+	return __fscrypt_fname_encrypted_size(&cci->ci_policy,
 					      orig_len, max_len,
 					      encrypted_len_ret);
 }
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 8a1fd1d33cfc..cc1a61ade2a4 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -53,14 +53,15 @@ struct fscrypt_context_v2 {
 };
 
 /*
- * fscrypt_context - the encryption context of an inode
+ * fscrypt_context - the encryption context of an object
  *
  * This is the on-disk equivalent of an fscrypt_policy, stored alongside each
- * encrypted file usually in a hidden extended attribute.  It contains the
- * fields from the fscrypt_policy, in order to identify the encryption algorithm
- * and key with which the file is encrypted.  It also contains a nonce that was
- * randomly generated by fscrypt itself; this is used as KDF input or as a tweak
- * to cause different files to be encrypted differently.
+ * encrypted object, usually in a hidden extended attribute for a file.  It
+ * contains the fields from the fscrypt_policy, in order to identify the
+ * encryption algorithm and key with which the file is encrypted.  It also
+ * contains a nonce that was randomly generated by fscrypt itself; this is used
+ * as KDF input or as a tweak to cause different objects to be encrypted
+ * differently.
  */
 union fscrypt_context {
 	u8 version;
@@ -209,32 +210,41 @@ struct fscrypt_prepared_key {
 	enum fscrypt_prepared_key_type type;
 };
 
+typedef enum {
+	CI_INODE = 1,
+	CI_EXTENT,
+} __packed fscrypt_ci_type_t;
+
 /*
- * fscrypt_info - the "encryption key" for an inode
+ * fscrypt_common_info -- shared objects needed for data encryption
  *
- * When an encrypted file's key is made available, an instance of this struct is
- * allocated and stored in ->i_crypt_info.  Once created, it remains until the
- * inode is evicted.
+ * This keeps track of the information needed to actually encrypt/decrypt data
+ * (the prepared key, nonce, inode, policy, superblock) and the master key
+ * information needed to free this info.
  */
-struct fscrypt_info {
+struct fscrypt_common_info {
 
 	/* The key in a form prepared for actual encryption/decryption */
 	struct fscrypt_prepared_key *ci_enc_key;
 
-	/* True if ci_enc_key should be freed when this fscrypt_info is freed */
+	/*
+	 * True if ci_enc_key should be freed when this fscrypt_common_info is
+	 * freed.
+	 */
 	bool ci_owns_key;
 
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 	/*
-	 * True if this inode will use inline encryption (blk-crypto) instead of
+	 * True if this info will use inline encryption (blk-crypto) instead of
 	 * the traditional filesystem-layer encryption.
 	 */
 	bool ci_inlinecrypt;
 #endif
 
+	fscrypt_ci_type_t ci_type;
 	/*
-	 * Encryption mode used for this inode.  It corresponds to either the
-	 * contents or filenames encryption mode, depending on the inode type.
+	 * Encryption mode used for this info.  It corresponds to either the
+	 * contents or filenames encryption mode, depending on the info.
 	 */
 	struct fscrypt_mode *ci_mode;
 
@@ -242,18 +252,38 @@ struct fscrypt_info {
 	struct inode *ci_inode;
 
 	/*
-	 * The master key with which this inode was unlocked (decrypted).  This
+	 * The master key with which this info was unlocked (decrypted).  This
 	 * will be NULL if the master key was found in a process-subscribed
 	 * keyring rather than in the filesystem-level keyring.
 	 */
 	struct fscrypt_master_key *ci_master_key;
 
 	/*
-	 * Link in list of inodes that were unlocked with the master key.
+	 * Link in list of infos that were unlocked with the master key.
 	 * Only used when ->ci_master_key is set.
 	 */
 	struct list_head ci_master_key_link;
 
+	/* The encryption policy used by this object */
+	union fscrypt_policy ci_policy;
+
+	/* This object's nonce, copied from the fscrypt_context */
+	u8 ci_nonce[FSCRYPT_FILE_NONCE_SIZE];
+
+	/* Hashed inode number.  Only set for IV_INO_LBLK_32 */
+	u32 ci_hashed_ino;
+};
+
+/*
+ * fscrypt_info - the "encryption key" for an inode
+ *
+ * When an encrypted file's key is made available, an instance of this struct is
+ * allocated and stored in ->i_crypt_info.  Once created, it remains until the
+ * inode is evicted.
+ */
+struct fscrypt_info {
+	struct fscrypt_common_info info;
+
 	/*
 	 * This inode's hash key for filenames.  This is a 128-bit SipHash-2-4
 	 * key.  This is only set for directories that use a keyed dirhash over
@@ -261,24 +291,19 @@ struct fscrypt_info {
 	 */
 	siphash_key_t ci_dirhash_key;
 	bool ci_dirhash_key_initialized;
-
-	/* The encryption policy used by this inode */
-	union fscrypt_policy ci_policy;
-
-	/* This inode's nonce, copied from the fscrypt_context */
-	u8 ci_nonce[FSCRYPT_FILE_NONCE_SIZE];
-
-	/* Hashed inode number.  Only set for IV_INO_LBLK_32 */
-	u32 ci_hashed_ino;
 };
 
+/*
+ */
+
 typedef enum {
 	FS_DECRYPT = 0,
 	FS_ENCRYPT,
 } fscrypt_direction_t;
 
 /**
- * fscrypt_get_lblk_info() - get the fscrypt_info to crypt a particular block
+ * fscrypt_get_lblk_info() - get the fscrypt_common_info to crypt a particular
+ *			     block
  *
  * @inode:      the inode to which the block belongs
  * @lblk:       the offset of the block within the file which the inode
@@ -293,7 +318,7 @@ typedef enum {
  *
  * Return: the appropriate fscrypt_info if there is one, else NULL.
  */
-static inline struct fscrypt_info *
+static inline struct fscrypt_common_info *
 fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
 		      u64 *extent_len)
 {
@@ -302,12 +327,12 @@ fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
 	if (extent_len)
 		*extent_len = U64_MAX;
 
-	return inode->i_crypt_info;
+	return &inode->i_crypt_info->info;
 }
 
 
 /* crypto.c */
-extern struct kmem_cache *fscrypt_info_cachep;
+extern struct kmem_cache *fscrypt_inode_info_cachep;
 int fscrypt_initialize(struct super_block *sb);
 int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 			u64 lblk_num, struct page *src_page,
@@ -338,7 +363,7 @@ union fscrypt_iv {
 };
 
 void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
-			 const struct fscrypt_info *ci);
+			 const struct fscrypt_common_info *ci);
 
 /* fname.c */
 bool __fscrypt_fname_encrypted_size(const union fscrypt_policy *policy,
@@ -376,17 +401,17 @@ void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf);
 
 /* inline_crypt.c */
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
-int fscrypt_select_encryption_impl(struct fscrypt_info *ci);
+int fscrypt_select_encryption_impl(struct fscrypt_common_info *ci);
 
 static inline bool
-fscrypt_using_inline_encryption(const struct fscrypt_info *ci)
+fscrypt_using_inline_encryption(const struct fscrypt_common_info *ci)
 {
 	return ci->ci_inlinecrypt;
 }
 
 int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 				     const u8 *raw_key,
-				     const struct fscrypt_info *ci);
+				     const struct fscrypt_common_info *ci);
 
 void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
 				      struct fscrypt_prepared_key *prep_key);
@@ -397,7 +422,7 @@ void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
  */
 static inline bool
 fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
-			const struct fscrypt_info *ci)
+			const struct fscrypt_common_info *ci)
 {
 	/*
 	 * The two smp_load_acquire()'s here pair with the smp_store_release()'s
@@ -414,13 +439,13 @@ fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
 
 #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
-static inline int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
+static inline int fscrypt_select_encryption_impl(struct fscrypt_common_info *ci)
 {
 	return 0;
 }
 
 static inline bool
-fscrypt_using_inline_encryption(const struct fscrypt_info *ci)
+fscrypt_using_inline_encryption(const struct fscrypt_common_info *ci)
 {
 	return false;
 }
@@ -428,7 +453,7 @@ fscrypt_using_inline_encryption(const struct fscrypt_info *ci)
 static inline int
 fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 				 const u8 *raw_key,
-				 const struct fscrypt_info *ci)
+				 const struct fscrypt_common_info *ci)
 {
 	WARN_ON_ONCE(1);
 	return -EOPNOTSUPP;
@@ -442,7 +467,7 @@ fscrypt_destroy_inline_crypt_key(struct super_block *sb,
 
 static inline bool
 fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
-			const struct fscrypt_info *ci)
+			const struct fscrypt_common_info *ci)
 {
 	return smp_load_acquire(&prep_key->tfm) != NULL;
 }
@@ -499,7 +524,7 @@ struct fscrypt_master_key {
 	 * A structural ref only guarantees that the struct continues to exist.
 	 *
 	 * There is one active ref associated with ->mk_secret being present,
-	 * and one active ref for each inode in ->mk_decrypted_inodes.
+	 * and one active ref for each inode in ->mk_decrypted_infos.
 	 *
 	 * There is one structural ref associated with the active refcount being
 	 * nonzero.  Finding a key in the keyring also takes a structural ref,
@@ -513,7 +538,7 @@ struct fscrypt_master_key {
 	/*
 	 * The secret key material.  After FS_IOC_REMOVE_ENCRYPTION_KEY is
 	 * executed, this is wiped and no new inodes can be unlocked with this
-	 * key; however, there may still be inodes in ->mk_decrypted_inodes
+	 * key; however, there may still be inodes in ->mk_decrypted_infos
 	 * which could not be evicted.  As long as some inodes still remain,
 	 * FS_IOC_REMOVE_ENCRYPTION_KEY can be retried, or
 	 * FS_IOC_ADD_ENCRYPTION_KEY can add the secret again.
@@ -552,8 +577,8 @@ struct fscrypt_master_key {
 	 * List of inodes that were unlocked using this key.  This allows the
 	 * inodes to be evicted efficiently if the key is removed.
 	 */
-	struct list_head	mk_decrypted_inodes;
-	spinlock_t		mk_decrypted_inodes_lock;
+	struct list_head	mk_decrypted_infos;
+	spinlock_t		mk_decrypted_infos_lock;
 
 	/*
 	 * Per-mode encryption keys for the various types of encryption policies
@@ -642,17 +667,18 @@ struct fscrypt_mode {
 extern struct fscrypt_mode fscrypt_modes[];
 
 int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
-			const u8 *raw_key, const struct fscrypt_info *ci);
+			const u8 *raw_key,
+			const struct fscrypt_common_info *ci);
 
 void fscrypt_destroy_prepared_key(struct super_block *sb,
 				  struct fscrypt_prepared_key *prep_key);
 
-int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key);
+int fscrypt_set_per_info_enc_key(struct fscrypt_common_info *ci, const u8 *raw_key);
 
 int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
 			       const struct fscrypt_master_key *mk);
 
-void fscrypt_hash_inode_number(struct fscrypt_info *ci,
+void fscrypt_hash_inode_number(struct fscrypt_common_info *ci,
 			       const struct fscrypt_master_key *mk);
 
 int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported);
@@ -687,10 +713,10 @@ static inline int fscrypt_require_key(struct inode *inode)
 
 void fscrypt_put_direct_key(struct fscrypt_prepared_key *prep_key);
 
-int fscrypt_setup_v1_file_key(struct fscrypt_info *ci,
+int fscrypt_setup_v1_info_key(struct fscrypt_common_info *ci,
 			      const u8 *raw_master_key);
 
-int fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_info *ci);
+int fscrypt_setup_v1_info_key_via_subscribed_keyrings(struct fscrypt_common_info *ci);
 
 /* policy.c */
 
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 6238dbcadcad..3c1d51724768 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -170,6 +170,7 @@ int fscrypt_prepare_setflags(struct inode *inode,
 			     unsigned int oldflags, unsigned int flags)
 {
 	struct fscrypt_info *ci;
+	struct fscrypt_common_info *cci;
 	struct fscrypt_master_key *mk;
 	int err;
 
@@ -183,9 +184,10 @@ int fscrypt_prepare_setflags(struct inode *inode,
 		if (err)
 			return err;
 		ci = inode->i_crypt_info;
-		if (ci->ci_policy.version != FSCRYPT_POLICY_V2)
+		cci = &ci->info;
+		if (cci->ci_policy.version != FSCRYPT_POLICY_V2)
 			return -EINVAL;
-		mk = ci->ci_master_key;
+		mk = cci->ci_master_key;
 		down_read(&mk->mk_sem);
 		if (is_master_key_secret_present(&mk->mk_secret))
 			err = fscrypt_derive_dirhash_key(ci, mk);
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 2d08abbf5892..09ec82b8a98a 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -39,10 +39,10 @@ static struct block_device **fscrypt_get_devices(struct super_block *sb,
 	return devs;
 }
 
-static unsigned int fscrypt_get_dun_bytes(const struct fscrypt_info *ci)
+static unsigned int fscrypt_get_dun_bytes(const struct fscrypt_common_info *cci)
 {
-	struct super_block *sb = ci->ci_inode->i_sb;
-	unsigned int flags = fscrypt_policy_flags(&ci->ci_policy);
+	struct super_block *sb = cci->ci_inode->i_sb;
+	unsigned int flags = fscrypt_policy_flags(&cci->ci_policy);
 	int ino_bits = 64, lblk_bits = 64;
 
 	if (flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY)
@@ -90,9 +90,9 @@ static void fscrypt_log_blk_crypto_impl(struct fscrypt_mode *mode,
 }
 
 /* Enable inline encryption for this file if supported. */
-int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
+int fscrypt_select_encryption_impl(struct fscrypt_common_info *cci)
 {
-	const struct inode *inode = ci->ci_inode;
+	const struct inode *inode = cci->ci_inode;
 	struct super_block *sb = inode->i_sb;
 	struct blk_crypto_config crypto_cfg;
 	struct block_device **devs;
@@ -104,7 +104,7 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 		return 0;
 
 	/* The crypto mode must have a blk-crypto counterpart */
-	if (ci->ci_mode->blk_crypto_mode == BLK_ENCRYPTION_MODE_INVALID)
+	if (cci->ci_mode->blk_crypto_mode == BLK_ENCRYPTION_MODE_INVALID)
 		return 0;
 
 	/* The filesystem must be mounted with -o inlinecrypt */
@@ -119,7 +119,7 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 	 * doesn't work with IV_INO_LBLK_32. For now, simply exclude
 	 * IV_INO_LBLK_32 with blocksize != PAGE_SIZE from inline encryption.
 	 */
-	if ((fscrypt_policy_flags(&ci->ci_policy) &
+	if ((fscrypt_policy_flags(&cci->ci_policy) &
 	     FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) &&
 	    sb->s_blocksize != PAGE_SIZE)
 		return 0;
@@ -128,9 +128,9 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 	 * On all the filesystem's block devices, blk-crypto must support the
 	 * crypto configuration that the file would use.
 	 */
-	crypto_cfg.crypto_mode = ci->ci_mode->blk_crypto_mode;
+	crypto_cfg.crypto_mode = cci->ci_mode->blk_crypto_mode;
 	crypto_cfg.data_unit_size = sb->s_blocksize;
-	crypto_cfg.dun_bytes = fscrypt_get_dun_bytes(ci);
+	crypto_cfg.dun_bytes = fscrypt_get_dun_bytes(cci);
 
 	devs = fscrypt_get_devices(sb, &num_devs);
 	if (IS_ERR(devs))
@@ -141,9 +141,9 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 			goto out_free_devs;
 	}
 
-	fscrypt_log_blk_crypto_impl(ci->ci_mode, devs, num_devs, &crypto_cfg);
+	fscrypt_log_blk_crypto_impl(cci->ci_mode, devs, num_devs, &crypto_cfg);
 
-	ci->ci_inlinecrypt = true;
+	cci->ci_inlinecrypt = true;
 out_free_devs:
 	kfree(devs);
 
@@ -152,11 +152,11 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 
 int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 				     const u8 *raw_key,
-				     const struct fscrypt_info *ci)
+				     const struct fscrypt_common_info *cci)
 {
-	const struct inode *inode = ci->ci_inode;
+	const struct inode *inode = cci->ci_inode;
 	struct super_block *sb = inode->i_sb;
-	enum blk_crypto_mode_num crypto_mode = ci->ci_mode->blk_crypto_mode;
+	enum blk_crypto_mode_num crypto_mode = cci->ci_mode->blk_crypto_mode;
 	struct blk_crypto_key *blk_key;
 	struct block_device **devs;
 	unsigned int num_devs;
@@ -168,7 +168,7 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 		return -ENOMEM;
 
 	err = blk_crypto_init_key(blk_key, raw_key, crypto_mode,
-				  fscrypt_get_dun_bytes(ci), sb->s_blocksize);
+				  fscrypt_get_dun_bytes(cci), sb->s_blocksize);
 	if (err) {
 		fscrypt_err(inode, "error %d initializing blk-crypto key", err);
 		goto fail;
@@ -228,21 +228,21 @@ void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
 
 bool __fscrypt_inode_uses_inline_crypto(const struct inode *inode)
 {
-	return inode->i_crypt_info->ci_inlinecrypt;
+	return inode->i_crypt_info->info.ci_inlinecrypt;
 }
 EXPORT_SYMBOL_GPL(__fscrypt_inode_uses_inline_crypto);
 
-static void fscrypt_generate_dun(const struct fscrypt_info *ci, u64 lblk_num,
+static void fscrypt_generate_dun(const struct fscrypt_common_info *cci, u64 lblk_num,
 				 u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE])
 {
 	union fscrypt_iv iv;
 	int i;
 
-	fscrypt_generate_iv(&iv, lblk_num, ci);
+	fscrypt_generate_iv(&iv, lblk_num, cci);
 
 	BUILD_BUG_ON(FSCRYPT_MAX_IV_SIZE > BLK_CRYPTO_MAX_IV_SIZE);
 	memset(dun, 0, BLK_CRYPTO_MAX_IV_SIZE);
-	for (i = 0; i < ci->ci_mode->ivsize/sizeof(dun[0]); i++)
+	for (i = 0; i < cci->ci_mode->ivsize/sizeof(dun[0]); i++)
 		dun[i] = le64_to_cpu(iv.dun[i]);
 }
 
@@ -265,16 +265,16 @@ static void fscrypt_generate_dun(const struct fscrypt_info *ci, u64 lblk_num,
 void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 			       u64 first_lblk, gfp_t gfp_mask)
 {
-	const struct fscrypt_info *ci;
+	const struct fscrypt_common_info *cci;
 	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
 	u64 ci_offset = 0;
 
 	if (!fscrypt_inode_uses_inline_crypto(inode))
 		return;
-	ci = fscrypt_get_lblk_info(inode, first_lblk, &ci_offset, NULL);
+	cci = fscrypt_get_lblk_info(inode, first_lblk, &ci_offset, NULL);
 
-	fscrypt_generate_dun(ci, ci_offset, dun);
-	bio_crypt_set_ctx(bio, ci->ci_enc_key->blk_key, dun, gfp_mask);
+	fscrypt_generate_dun(cci, ci_offset, dun);
+	bio_crypt_set_ctx(bio, cci->ci_enc_key->blk_key, dun, gfp_mask);
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx);
 
@@ -350,7 +350,7 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 {
 	const struct bio_crypt_ctx *bc = bio->bi_crypt_context;
 	u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
-	struct fscrypt_info *ci;
+	struct fscrypt_common_info *cci;
 	u64 ci_offset = 0;
 
 	if (!!bc != fscrypt_inode_uses_inline_crypto(inode))
@@ -358,16 +358,16 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 	if (!bc)
 		return true;
 
-	ci = fscrypt_get_lblk_info(inode, next_lblk, &ci_offset, NULL);
+	cci = fscrypt_get_lblk_info(inode, next_lblk, &ci_offset, NULL);
 	/*
 	 * Comparing the key pointers is good enough, as all I/O for each key
 	 * uses the same pointer.  I.e., there's currently no need to support
 	 * merging requests where the keys are the same but the pointers differ.
 	 */
-	if (bc->bc_key != ci->ci_enc_key->blk_key)
+	if (bc->bc_key != cci->ci_enc_key->blk_key)
 		return false;
 
-	fscrypt_generate_dun(ci, ci_offset, next_dun);
+	fscrypt_generate_dun(cci, ci_offset, next_dun);
 	return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
 }
 EXPORT_SYMBOL_GPL(fscrypt_mergeable_bio);
@@ -460,7 +460,7 @@ EXPORT_SYMBOL_GPL(fscrypt_dio_supported);
  */
 u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
 {
-	const struct fscrypt_info *ci;
+	const struct fscrypt_common_info *cci;
 	u32 dun;
 	u64 ci_offset = 0;
 	u64 extent_len = 0;
@@ -471,18 +471,18 @@ u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
 	if (nr_blocks <= 1)
 		return nr_blocks;
 
-	ci = fscrypt_get_lblk_info(inode, lblk, &ci_offset, &extent_len);
+	cci = fscrypt_get_lblk_info(inode, lblk, &ci_offset, &extent_len);
 
 	/* Spanning an extent boundary will change the DUN */
 	nr_blocks = min_t(u64, nr_blocks, extent_len);
 
-	if (!(fscrypt_policy_flags(&ci->ci_policy) &
+	if (!(fscrypt_policy_flags(&cci->ci_policy) &
 	      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))
 		return nr_blocks;
 
 	/* With IV_INO_LBLK_32, the DUN can wrap around from U32_MAX to 0. */
 
-	dun = ci->ci_hashed_ino + ci_offset;
+	dun = cci->ci_hashed_ino + ci_offset;
 
 	return min_t(u64, nr_blocks, (u64)U32_MAX + 1 - dun);
 }
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index d153988b7403..27ae0345fa85 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -100,10 +100,10 @@ void fscrypt_put_master_key_activeref(struct super_block *sb,
 
 	/*
 	 * ->mk_active_refs == 0 implies that ->mk_secret is not present and
-	 * that ->mk_decrypted_inodes is empty.
+	 * that ->mk_decrypted_infos is empty.
 	 */
 	WARN_ON_ONCE(is_master_key_secret_present(&mk->mk_secret));
-	WARN_ON_ONCE(!list_empty(&mk->mk_decrypted_inodes));
+	WARN_ON_ONCE(!list_empty(&mk->mk_decrypted_infos));
 
 	for (i = 0; i <= FSCRYPT_MODE_MAX; i++) {
 		fscrypt_destroy_prepared_key(
@@ -426,8 +426,8 @@ static int add_new_master_key(struct super_block *sb,
 	refcount_set(&mk->mk_struct_refs, 1);
 	mk->mk_spec = *mk_spec;
 
-	INIT_LIST_HEAD(&mk->mk_decrypted_inodes);
-	spin_lock_init(&mk->mk_decrypted_inodes_lock);
+	INIT_LIST_HEAD(&mk->mk_decrypted_infos);
+	spin_lock_init(&mk->mk_decrypted_infos_lock);
 
 	if (mk_spec->type == FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER) {
 		err = allocate_master_key_users_keyring(mk);
@@ -865,16 +865,16 @@ static void shrink_dcache_inode(struct inode *inode)
 	d_prune_aliases(inode);
 }
 
-static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
+static void evict_dentries_for_decrypted_infos(struct fscrypt_master_key *mk)
 {
-	struct fscrypt_info *ci;
+	struct fscrypt_common_info *cci;
 	struct inode *inode;
 	struct inode *toput_inode = NULL;
 
-	spin_lock(&mk->mk_decrypted_inodes_lock);
+	spin_lock(&mk->mk_decrypted_infos_lock);
 
-	list_for_each_entry(ci, &mk->mk_decrypted_inodes, ci_master_key_link) {
-		inode = ci->ci_inode;
+	list_for_each_entry(cci, &mk->mk_decrypted_infos, ci_master_key_link) {
+		inode = cci->ci_inode;
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
 			spin_unlock(&inode->i_lock);
@@ -882,16 +882,16 @@ static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&mk->mk_decrypted_inodes_lock);
+		spin_unlock(&mk->mk_decrypted_infos_lock);
 
 		shrink_dcache_inode(inode);
 		iput(toput_inode);
 		toput_inode = inode;
 
-		spin_lock(&mk->mk_decrypted_inodes_lock);
+		spin_lock(&mk->mk_decrypted_infos_lock);
 	}
 
-	spin_unlock(&mk->mk_decrypted_inodes_lock);
+	spin_unlock(&mk->mk_decrypted_infos_lock);
 	iput(toput_inode);
 }
 
@@ -903,25 +903,25 @@ static int check_for_busy_inodes(struct super_block *sb,
 	unsigned long ino;
 	char ino_str[50] = "";
 
-	spin_lock(&mk->mk_decrypted_inodes_lock);
+	spin_lock(&mk->mk_decrypted_infos_lock);
 
-	list_for_each(pos, &mk->mk_decrypted_inodes)
+	list_for_each(pos, &mk->mk_decrypted_infos)
 		busy_count++;
 
 	if (busy_count == 0) {
-		spin_unlock(&mk->mk_decrypted_inodes_lock);
+		spin_unlock(&mk->mk_decrypted_infos_lock);
 		return 0;
 	}
 
 	{
 		/* select an example file to show for debugging purposes */
 		struct inode *inode =
-			list_first_entry(&mk->mk_decrypted_inodes,
-					 struct fscrypt_info,
+			list_first_entry(&mk->mk_decrypted_infos,
+					 struct fscrypt_common_info,
 					 ci_master_key_link)->ci_inode;
 		ino = inode->i_ino;
 	}
-	spin_unlock(&mk->mk_decrypted_inodes_lock);
+	spin_unlock(&mk->mk_decrypted_infos_lock);
 
 	/* If the inode is currently being created, ino may still be 0. */
 	if (ino)
@@ -942,7 +942,7 @@ static int try_to_lock_encrypted_files(struct super_block *sb,
 
 	/*
 	 * An inode can't be evicted while it is dirty or has dirty pages.
-	 * Thus, we first have to clean the inodes in ->mk_decrypted_inodes.
+	 * Thus, we first have to clean the inodes in ->mk_decrypted_infos.
 	 *
 	 * Just do it the easy way: call sync_filesystem().  It's overkill, but
 	 * it works, and it's more important to minimize the amount of caches we
@@ -960,7 +960,7 @@ static int try_to_lock_encrypted_files(struct super_block *sb,
 	 * and inappropriate for use by unprivileged users.  So instead go
 	 * through the inodes' alias lists and try to evict each dentry.
 	 */
-	evict_dentries_for_decrypted_inodes(mk);
+	evict_dentries_for_decrypted_infos(mk);
 
 	return err;
 }
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index a19650f954e2..ae250e432dcd 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -101,7 +101,7 @@ select_encryption_mode(const union fscrypt_policy *policy,
 	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
 		return &fscrypt_modes[fscrypt_policy_fnames_mode(policy)];
 
-	WARN_ONCE(1, "fscrypt: filesystem tried to load encryption info for inode %lu, which is not encryptable (file type %d)\n",
+	WARN_ONCE(1, "fscrypt: filesystem tried to load an encryption info for inode %lu, which is not encryptable (file type %d)\n",
 		  inode->i_ino, (inode->i_mode & S_IFMT));
 	return ERR_PTR(-EINVAL);
 }
@@ -159,14 +159,14 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
  * and IV generation method (@ci->ci_policy.flags).
  */
 int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
-			const u8 *raw_key, const struct fscrypt_info *ci)
+			const u8 *raw_key, const struct fscrypt_common_info *cci)
 {
 	struct crypto_skcipher *tfm;
 
-	if (fscrypt_using_inline_encryption(ci))
-		return fscrypt_prepare_inline_crypt_key(prep_key, raw_key, ci);
+	if (fscrypt_using_inline_encryption(cci))
+		return fscrypt_prepare_inline_crypt_key(prep_key, raw_key, cci);
 
-	tfm = fscrypt_allocate_skcipher(ci->ci_mode, raw_key, ci->ci_inode);
+	tfm = fscrypt_allocate_skcipher(cci->ci_mode, raw_key, cci->ci_inode);
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 	/*
@@ -188,15 +188,16 @@ void fscrypt_destroy_prepared_key(struct super_block *sb,
 	memzero_explicit(prep_key, sizeof(*prep_key));
 }
 
-/* Given a per-file encryption key, set up the file's crypto transform object */
-int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
+/* Given a per-info encryption key, set up the info's crypto transform object */
+int fscrypt_set_per_info_enc_key(struct fscrypt_common_info *cci,
+				 const u8 *raw_key)
 {
-	ci->ci_enc_key = kzalloc(sizeof(*ci->ci_enc_key), GFP_KERNEL);
-	if (!ci->ci_enc_key)
+	cci->ci_enc_key = kzalloc(sizeof(*cci->ci_enc_key), GFP_KERNEL);
+	if (!cci->ci_enc_key)
 		return -ENOMEM;
 
-	ci->ci_enc_key->type = FSCRYPT_KEY_PER_INFO;
-	return fscrypt_prepare_key(ci->ci_enc_key, raw_key, ci);
+	cci->ci_enc_key->type = FSCRYPT_KEY_PER_INFO;
+	return fscrypt_prepare_key(cci->ci_enc_key, raw_key, cci);
 }
 
 static struct fscrypt_prepared_key *
@@ -219,15 +220,15 @@ mk_prepared_key_for_mode_policy(struct fscrypt_master_key *mk,
 }
 
 static size_t
-fill_hkdf_info_for_mode_key(const struct fscrypt_info *ci,
+fill_hkdf_info_for_mode_key(const struct fscrypt_common_info *cci,
 			    u8 hkdf_info[MAX_MODE_KEY_HKDF_INFO_SIZE])
 {
-	const u8 mode_num = ci->ci_mode - fscrypt_modes;
-	const struct super_block *sb = ci->ci_inode->i_sb;
+	const u8 mode_num = cci->ci_mode - fscrypt_modes;
+	const struct super_block *sb = cci->ci_inode->i_sb;
 	u8 hkdf_infolen = 0;
 
 	hkdf_info[hkdf_infolen++] = mode_num;
-	if (!(ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY)) {
+	if (!(cci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY)) {
 		memcpy(&hkdf_info[hkdf_infolen], &sb->s_uuid,
 				sizeof(sb->s_uuid));
 		hkdf_infolen += sizeof(sb->s_uuid);
@@ -237,12 +238,12 @@ fill_hkdf_info_for_mode_key(const struct fscrypt_info *ci,
 
 static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 				       struct fscrypt_prepared_key *prep_key,
-				       const struct fscrypt_info *ci)
+				       const struct fscrypt_common_info *cci)
 {
-	const struct inode *inode = ci->ci_inode;
+	const struct inode *inode = cci->ci_inode;
 	const struct super_block *sb = inode->i_sb;
-	unsigned int policy_flags = fscrypt_policy_flags(&ci->ci_policy);
-	struct fscrypt_mode *mode = ci->ci_mode;
+	unsigned int policy_flags = fscrypt_policy_flags(&cci->ci_policy);
+	struct fscrypt_mode *mode = cci->ci_mode;
 	const u8 mode_num = mode - fscrypt_modes;
 	u8 mode_key[FSCRYPT_MAX_KEY_SIZE];
 	u8 hkdf_info[sizeof(mode_num) + sizeof(sb->s_uuid)];
@@ -263,8 +264,8 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 	}
 
 	/*
-	 * For DIRECT_KEY policies: instead of deriving per-file encryption
-	 * keys, the per-file nonce will be included in all the IVs.  But
+	 * For DIRECT_KEY policies: instead of deriving per-info encryption
+	 * keys, the per-info nonce will be included in all the IVs.  But
 	 * unlike v1 policies, for v2 policies in this case we don't encrypt
 	 * with the master key directly but rather derive a per-mode encryption
 	 * key.  This ensures that the master key is consistently used only for
@@ -278,13 +279,13 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 
 	mutex_lock(&fscrypt_mode_key_setup_mutex);
 
-	if (fscrypt_is_key_prepared(prep_key, ci))
+	if (fscrypt_is_key_prepared(prep_key, cci))
 		goto out_unlock;
 
 	BUILD_BUG_ON(sizeof(mode_num) != 1);
 	BUILD_BUG_ON(sizeof(sb->s_uuid) != 16);
 	BUILD_BUG_ON(sizeof(hkdf_info) != MAX_MODE_KEY_HKDF_INFO_SIZE);
-	hkdf_infolen = fill_hkdf_info_for_mode_key(ci, hkdf_info);
+	hkdf_infolen = fill_hkdf_info_for_mode_key(cci, hkdf_info);
 
 	err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
 				  hkdf_context, hkdf_info, hkdf_infolen,
@@ -292,7 +293,7 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 	if (err)
 		return err;
 	prep_key->type = FSCRYPT_KEY_MASTER_KEY;
-	err = fscrypt_prepare_key(prep_key, mode_key, ci);
+	err = fscrypt_prepare_key(prep_key, mode_key, cci);
 	memzero_explicit(mode_key, mode->keysize);
 
 out_unlock:
@@ -300,10 +301,10 @@ static int setup_new_mode_prepared_key(struct fscrypt_master_key *mk,
 	return err;
 }
 
-static int setup_mode_prepared_key(struct fscrypt_info *ci,
+static int setup_mode_prepared_key(struct fscrypt_common_info *cci,
 				  struct fscrypt_master_key *mk)
 {
-	struct fscrypt_mode *mode = ci->ci_mode;
+	struct fscrypt_mode *mode = cci->ci_mode;
 	const u8 mode_num = mode - fscrypt_modes;
 	struct fscrypt_prepared_key *prep_key;
 	int err;
@@ -311,19 +312,19 @@ static int setup_mode_prepared_key(struct fscrypt_info *ci,
 	if (WARN_ON_ONCE(mode_num > FSCRYPT_MODE_MAX))
 		return -EINVAL;
 
-	prep_key = mk_prepared_key_for_mode_policy(mk, &ci->ci_policy, mode);
+	prep_key = mk_prepared_key_for_mode_policy(mk, &cci->ci_policy, mode);
 	if (IS_ERR(prep_key))
 		return PTR_ERR(prep_key);
 
-	if (fscrypt_is_key_prepared(prep_key, ci)) {
-		ci->ci_enc_key = prep_key;
+	if (fscrypt_is_key_prepared(prep_key, cci)) {
+		cci->ci_enc_key = prep_key;
 		return 0;
 	}
-	err = setup_new_mode_prepared_key(mk, prep_key, ci);
+	err = setup_new_mode_prepared_key(mk, prep_key, cci);
 	if (err)
 		return err;
 
-	ci->ci_enc_key = prep_key;
+	cci->ci_enc_key = prep_key;
 	return 0;
 }
 
@@ -359,7 +360,7 @@ int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
 	int err;
 
 	err = fscrypt_derive_siphash_key(mk, HKDF_CONTEXT_DIRHASH_KEY,
-					 ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
+					 ci->info.ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
 					 &ci->ci_dirhash_key);
 	if (err)
 		return err;
@@ -367,14 +368,14 @@ int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
 	return 0;
 }
 
-void fscrypt_hash_inode_number(struct fscrypt_info *ci,
+void fscrypt_hash_inode_number(struct fscrypt_common_info *cci,
 			       const struct fscrypt_master_key *mk)
 {
-	WARN_ON_ONCE(ci->ci_inode->i_ino == 0);
+	WARN_ON_ONCE(cci->ci_inode->i_ino == 0);
 	WARN_ON_ONCE(!mk->mk_ino_hash_key_initialized);
 
-	ci->ci_hashed_ino = (u32)siphash_1u64(ci->ci_inode->i_ino,
-					      &mk->mk_ino_hash_key);
+	cci->ci_hashed_ino = (u32)siphash_1u64(cci->ci_inode->i_ino,
+					       &mk->mk_ino_hash_key);
 }
 
 static int fscrypt_setup_ino_hash_key(struct fscrypt_master_key *mk)
@@ -403,25 +404,25 @@ static int fscrypt_setup_ino_hash_key(struct fscrypt_master_key *mk)
 	return err;
 }
 
-static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
+static int fscrypt_setup_v2_info_key(struct fscrypt_common_info *cci,
 				     struct fscrypt_master_key *mk)
 {
 	int err;
 
-	if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAGS_KEY_MASK) {
-		err = setup_mode_prepared_key(ci, mk);
+	if (cci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAGS_KEY_MASK) {
+		err = setup_mode_prepared_key(cci, mk);
 	} else {
 		u8 derived_key[FSCRYPT_MAX_KEY_SIZE];
 
 		err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
 					  HKDF_CONTEXT_PER_FILE_ENC_KEY,
-					  ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
-					  derived_key, ci->ci_mode->keysize);
+					  cci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
+					  derived_key, cci->ci_mode->keysize);
 		if (err)
 			return err;
 
-		err = fscrypt_set_per_file_enc_key(ci, derived_key);
-		memzero_explicit(derived_key, ci->ci_mode->keysize);
+		err = fscrypt_set_per_info_enc_key(cci, derived_key);
+		memzero_explicit(derived_key, cci->ci_mode->keysize);
 	}
 
 	return err;
@@ -430,13 +431,13 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 /*
  * Find or create the appropriate prepared key for an info.
  */
-static int fscrypt_setup_file_key(struct fscrypt_info *ci,
+static int fscrypt_setup_info_key(struct fscrypt_common_info *cci,
 				  struct fscrypt_master_key *mk)
 {
 	int err;
 
 	if (!mk) {
-		if (ci->ci_policy.version != FSCRYPT_POLICY_V1)
+		if (cci->ci_policy.version != FSCRYPT_POLICY_V1)
 			return -ENOKEY;
 
 		/*
@@ -445,15 +446,15 @@ static int fscrypt_setup_file_key(struct fscrypt_info *ci,
 		 * to before the search of ->s_master_keys, since users
 		 * shouldn't be able to override filesystem-level keys.
 		 */
-		return fscrypt_setup_v1_file_key_via_subscribed_keyrings(ci);
+		return fscrypt_setup_v1_info_key_via_subscribed_keyrings(cci);
 	}
 
-	switch (ci->ci_policy.version) {
+	switch (cci->ci_policy.version) {
 	case FSCRYPT_POLICY_V1:
-		err = fscrypt_setup_v1_file_key(ci, mk->mk_secret.raw);
+		err = fscrypt_setup_v1_info_key(cci, mk->mk_secret.raw);
 		break;
 	case FSCRYPT_POLICY_V2:
-		err = fscrypt_setup_v2_file_key(ci, mk);
+		err = fscrypt_setup_v2_info_key(cci, mk);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -465,30 +466,30 @@ static int fscrypt_setup_file_key(struct fscrypt_info *ci,
 
 /*
  * Check whether the size of the given master key (@mk) is appropriate for the
- * encryption settings which a particular file will use (@ci).
+ * encryption settings which a particular info will use (@cci).
  *
- * If the file uses a v1 encryption policy, then the master key must be at least
+ * If the info uses a v1 encryption policy, then the master key must be at least
  * as long as the derived key, as this is a requirement of the v1 KDF.
  *
  * Otherwise, the KDF can accept any size key, so we enforce a slightly looser
  * requirement: we require that the size of the master key be at least the
  * maximum security strength of any algorithm whose key will be derived from it
- * (but in practice we only need to consider @ci->ci_mode, since any other
+ * (but in practice we only need to consider @cci->ci_mode, since any other
  * possible subkeys such as DIRHASH and INODE_HASH will never increase the
- * required key size over @ci->ci_mode).  This allows AES-256-XTS keys to be
+ * required key size over @cci->ci_mode).  This allows AES-256-XTS keys to be
  * derived from a 256-bit master key, which is cryptographically sufficient,
  * rather than requiring a 512-bit master key which is unnecessarily long.  (We
  * still allow 512-bit master keys if the user chooses to use them, though.)
  */
 static bool fscrypt_valid_master_key_size(const struct fscrypt_master_key *mk,
-					  const struct fscrypt_info *ci)
+					  const struct fscrypt_common_info *cci)
 {
 	unsigned int min_keysize;
 
-	if (ci->ci_policy.version == FSCRYPT_POLICY_V1)
-		min_keysize = ci->ci_mode->keysize;
+	if (cci->ci_policy.version == FSCRYPT_POLICY_V1)
+		min_keysize = cci->ci_mode->keysize;
 	else
-		min_keysize = ci->ci_mode->security_strength;
+		min_keysize = cci->ci_mode->security_strength;
 
 	if (mk->mk_secret.size < min_keysize) {
 		fscrypt_warn(NULL,
@@ -507,19 +508,19 @@ static bool fscrypt_valid_master_key_size(const struct fscrypt_master_key *mk,
  *
  * If the master key is found in the filesystem-level keyring, then it is
  * returned in *mk_ret with its semaphore read-locked.  This is needed to ensure
- * that only one task links the fscrypt_info into ->mk_decrypted_inodes (as
+ * that only one task links inode fscrypt_info into ->mk_decrypted_infos (as
  * multiple tasks may race to create an fscrypt_info for the same inode), and to
  * synchronize the master key being removed with a new inode starting to use it.
  */
-static int find_and_lock_master_key(const struct fscrypt_info *ci,
+static int find_and_lock_master_key(const struct fscrypt_common_info *cci,
 				    struct fscrypt_master_key **mk_ret)
 {
-	struct super_block *sb = ci->ci_inode->i_sb;
+	struct super_block *sb = cci->ci_inode->i_sb;
 	struct fscrypt_key_specifier mk_spec;
 	struct fscrypt_master_key *mk;
 	int err;
 
-	err = fscrypt_policy_to_key_spec(&ci->ci_policy, &mk_spec);
+	err = fscrypt_policy_to_key_spec(&cci->ci_policy, &mk_spec);
 	if (err)
 		return err;
 
@@ -529,13 +530,13 @@ static int find_and_lock_master_key(const struct fscrypt_info *ci,
 			fscrypt_get_dummy_policy(sb);
 
 		/*
-		 * Add the test_dummy_encryption key on-demand.  In principle,
+		 * Add the test_dummy_encryption key on-demand.  In princciple,
 		 * it should be added at mount time.  Do it here instead so that
 		 * the individual filesystems don't need to worry about adding
 		 * this key at mount time and cleaning up on mount failure.
 		 */
 		if (dummy_policy &&
-		    fscrypt_policies_equal(dummy_policy, &ci->ci_policy)) {
+		    fscrypt_policies_equal(dummy_policy, &cci->ci_policy)) {
 			err = fscrypt_add_test_dummy_key(sb, &mk_spec);
 			if (err)
 				return err;
@@ -544,7 +545,7 @@ static int find_and_lock_master_key(const struct fscrypt_info *ci,
 	}
 
 	if (unlikely(!mk)) {
-		if (ci->ci_policy.version != FSCRYPT_POLICY_V1)
+		if (cci->ci_policy.version != FSCRYPT_POLICY_V1)
 			return -ENOKEY;
 
 		/*
@@ -564,7 +565,7 @@ static int find_and_lock_master_key(const struct fscrypt_info *ci,
 		goto out_release_key;
 	}
 
-	if (!fscrypt_valid_master_key_size(mk, ci)) {
+	if (!fscrypt_valid_master_key_size(mk, cci)) {
 		err = -ENOKEY;
 		goto out_release_key;
 	}
@@ -578,26 +579,24 @@ static int find_and_lock_master_key(const struct fscrypt_info *ci,
 	return err;
 }
 
-static void put_crypt_info(struct fscrypt_info *ci)
+static void free_prepared_key(struct fscrypt_common_info *cci)
 {
-	struct fscrypt_master_key *mk;
-
-	if (!ci)
-		return;
-
-	if (ci->ci_enc_key) {
-		enum fscrypt_prepared_key_type type = ci->ci_enc_key->type;
+	if (cci->ci_enc_key) {
+		enum fscrypt_prepared_key_type type = cci->ci_enc_key->type;
 
 		if (type == FSCRYPT_KEY_DIRECT_V1)
-			fscrypt_put_direct_key(ci->ci_enc_key);
+			fscrypt_put_direct_key(cci->ci_enc_key);
 		if (type == FSCRYPT_KEY_PER_INFO) {
-			fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
-						     ci->ci_enc_key);
-			kfree_sensitive(ci->ci_enc_key);
+			fscrypt_destroy_prepared_key(cci->ci_inode->i_sb,
+						     cci->ci_enc_key);
+			kfree_sensitive(cci->ci_enc_key);
 		}
 	}
+}
 
-	mk = ci->ci_master_key;
+static void remove_info_from_mk_decrypted_list(struct fscrypt_common_info *cci)
+{
+	struct fscrypt_master_key *mk = cci->ci_master_key;
 	if (mk) {
 		/*
 		 * Remove this inode from the list of inodes that were unlocked
@@ -605,22 +604,36 @@ static void put_crypt_info(struct fscrypt_info *ci)
 		 * inode from a master key struct that already had its secret
 		 * removed, then complete the full removal of the struct.
 		 */
-		spin_lock(&mk->mk_decrypted_inodes_lock);
-		list_del(&ci->ci_master_key_link);
-		spin_unlock(&mk->mk_decrypted_inodes_lock);
-		fscrypt_put_master_key_activeref(ci->ci_inode->i_sb, mk);
+		spin_lock(&mk->mk_decrypted_infos_lock);
+		list_del(&cci->ci_master_key_link);
+		spin_unlock(&mk->mk_decrypted_infos_lock);
+		fscrypt_put_master_key_activeref(cci->ci_inode->i_sb, mk);
 	}
+}
+
+static void put_crypt_inode_info(struct fscrypt_info *ci)
+{
+	if (!ci)
+		return;
+
+	free_prepared_key(&ci->info);
+	remove_info_from_mk_decrypted_list(&ci->info);
+
 	memzero_explicit(ci, sizeof(*ci));
-	kmem_cache_free(fscrypt_info_cachep, ci);
+	kmem_cache_free(fscrypt_inode_info_cachep, ci);
 }
 
-static int
-fscrypt_setup_encryption_info(struct inode *inode,
-			      const union fscrypt_policy *policy,
-			      const u8 nonce[FSCRYPT_FILE_NONCE_SIZE],
-			      bool need_dirhash_key)
+/*
+ * Sets up the fscrypt_common_info structure, and returns the relevant master
+ * key, if any, locked, for further type-specific processing.
+ */
+static int fscrypt_setup_common_info(struct fscrypt_common_info *crypt_info,
+				     struct inode *inode,
+				     const union fscrypt_policy *policy,
+				     const u8 nonce[FSCRYPT_FILE_NONCE_SIZE],
+				     fscrypt_ci_type_t type,
+				     struct fscrypt_master_key **mk_ret)
 {
-	struct fscrypt_info *crypt_info;
 	struct fscrypt_mode *mode;
 	struct fscrypt_master_key *mk = NULL;
 	int res;
@@ -629,12 +642,10 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (res)
 		return res;
 
-	crypt_info = kmem_cache_zalloc(fscrypt_info_cachep, GFP_KERNEL);
-	if (!crypt_info)
-		return -ENOMEM;
-
 	crypt_info->ci_inode = inode;
 	crypt_info->ci_policy = *policy;
+	crypt_info->ci_type = type;
+
 	memcpy(crypt_info->ci_nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
 
 	mode = select_encryption_mode(&crypt_info->ci_policy, inode);
@@ -653,7 +664,66 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (res)
 		goto out;
 
-	res = fscrypt_setup_file_key(crypt_info, mk);
+	res = fscrypt_setup_info_key(crypt_info, mk);
+	if (res)
+		goto out;
+
+	/*
+	 * The IV_INO_LBLK_32 policy needs a hashed inode number, but new
+	 * inodes may not have an inode number assigned yet.
+	 */
+	if (policy->version == FSCRYPT_POLICY_V2 &&
+	    (policy->v2.flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)) {
+		res = fscrypt_setup_ino_hash_key(mk);
+		if (res)
+			goto out;
+
+		if (inode->i_ino)
+			fscrypt_hash_inode_number(crypt_info, mk);
+	}
+
+	*mk_ret = mk;
+	return res;
+
+out:
+	if (mk) {
+		up_read(&mk->mk_sem);
+		fscrypt_put_master_key(mk);
+	}
+	return res;
+}
+
+static void add_info_to_mk_decrypted_list(struct fscrypt_common_info *cci,
+					  struct fscrypt_master_key *mk)
+{
+	if (mk) {
+		cci->ci_master_key = mk;
+		refcount_inc(&mk->mk_active_refs);
+		spin_lock(&mk->mk_decrypted_infos_lock);
+		list_add(&cci->ci_master_key_link, &mk->mk_decrypted_infos);
+		spin_unlock(&mk->mk_decrypted_infos_lock);
+	}
+}
+
+static int
+fscrypt_setup_encryption_info(struct inode *inode,
+			      const union fscrypt_policy *policy,
+			      const u8 nonce[FSCRYPT_FILE_NONCE_SIZE],
+			      bool need_dirhash_key)
+{
+	struct fscrypt_info *crypt_inode_info;
+	struct fscrypt_common_info *crypt_info;
+	struct fscrypt_master_key *mk = NULL;
+	int res;
+
+	crypt_inode_info = kmem_cache_zalloc(fscrypt_inode_info_cachep,
+					     GFP_KERNEL);
+	if (!crypt_inode_info)
+		return -ENOMEM;
+	crypt_info = &crypt_inode_info->info;
+
+	res = fscrypt_setup_common_info(crypt_info, inode, policy, nonce,
+					CI_INODE, &mk);
 	if (res)
 		goto out;
 
@@ -668,23 +738,9 @@ fscrypt_setup_encryption_info(struct inode *inode,
 			goto out;
 		}
 
-		res = fscrypt_derive_dirhash_key(crypt_info, mk);
-		if (res)
-			goto out;
-	}
-
-	/*
-	 * The IV_INO_LBLK_32 policy needs a hashed inode number, but new
-	 * inodes may not have an inode number assigned yet.
-	 */
-	if (policy->version == FSCRYPT_POLICY_V2 &&
-	    (policy->v2.flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)) {
-		res = fscrypt_setup_ino_hash_key(mk);
+		res = fscrypt_derive_dirhash_key(crypt_inode_info, mk);
 		if (res)
 			goto out;
-
-		if (inode->i_ino)
-			fscrypt_hash_inode_number(crypt_info, mk);
 	}
 
 	/*
@@ -693,20 +749,14 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	 * fscrypt_get_info().  I.e., here we publish ->i_crypt_info with a
 	 * RELEASE barrier so that other tasks can ACQUIRE it.
 	 */
-	if (cmpxchg_release(&inode->i_crypt_info, NULL, crypt_info) == NULL) {
+	if (cmpxchg_release(&inode->i_crypt_info, NULL,
+			    crypt_inode_info) == NULL) {
 		/*
 		 * We won the race and set ->i_crypt_info to our crypt_info.
 		 * Now link it into the master key's inode list.
 		 */
-		if (mk) {
-			crypt_info->ci_master_key = mk;
-			refcount_inc(&mk->mk_active_refs);
-			spin_lock(&mk->mk_decrypted_inodes_lock);
-			list_add(&crypt_info->ci_master_key_link,
-				 &mk->mk_decrypted_inodes);
-			spin_unlock(&mk->mk_decrypted_inodes_lock);
-		}
-		crypt_info = NULL;
+		add_info_to_mk_decrypted_list(crypt_info, mk);
+		crypt_inode_info = NULL;
 	}
 	res = 0;
 out:
@@ -714,7 +764,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 		up_read(&mk->mk_sem);
 		fscrypt_put_master_key(mk);
 	}
-	put_crypt_info(crypt_info);
+	put_crypt_inode_info(crypt_inode_info);
 	return res;
 }
 
@@ -843,7 +893,7 @@ EXPORT_SYMBOL_GPL(fscrypt_prepare_new_inode);
  */
 void fscrypt_put_encryption_info(struct inode *inode)
 {
-	put_crypt_info(inode->i_crypt_info);
+	put_crypt_inode_info(inode->i_crypt_info);
 	inode->i_crypt_info = NULL;
 }
 EXPORT_SYMBOL(fscrypt_put_encryption_info);
@@ -884,7 +934,7 @@ int fscrypt_drop_inode(struct inode *inode)
 	 * was provided via the legacy mechanism of the process-subscribed
 	 * keyrings, so we don't know whether it's been removed or not.
 	 */
-	if (!ci || !ci->ci_master_key)
+	if (!ci || !ci->info.ci_master_key)
 		return 0;
 
 	/*
@@ -904,6 +954,6 @@ int fscrypt_drop_inode(struct inode *inode)
 	 * then the thread removing the key will either evict the inode itself
 	 * or will correctly detect that it wasn't evicted due to the race.
 	 */
-	return !is_master_key_secret_present(&ci->ci_master_key->mk_secret);
+	return !is_master_key_secret_present(&ci->info.ci_master_key->mk_secret);
 }
 EXPORT_SYMBOL_GPL(fscrypt_drop_inode);
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 1e785cedead0..b57ed49ac201 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -9,7 +9,7 @@
  * This file implements compatibility functions for the original encryption
  * policy version ("v1"), including:
  *
- * - Deriving per-file encryption keys using the AES-128-ECB based KDF
+ * - Deriving per-info encryption keys using the AES-128-ECB based KDF
  *   (rather than the new method of using HKDF-SHA512)
  *
  * - Retrieving fscrypt master keys from process-subscribed keyrings
@@ -181,7 +181,8 @@ void fscrypt_put_direct_key(struct fscrypt_prepared_key *prep_key)
  */
 static struct fscrypt_direct_key *
 find_or_insert_direct_key(struct fscrypt_direct_key *to_insert,
-			  const u8 *raw_key, const struct fscrypt_info *ci)
+			  const u8 *raw_key,
+			  const struct fscrypt_common_info *cci)
 {
 	unsigned long hash_key;
 	struct fscrypt_direct_key *dk;
@@ -193,19 +194,19 @@ find_or_insert_direct_key(struct fscrypt_direct_key *to_insert,
 	 */
 
 	BUILD_BUG_ON(sizeof(hash_key) > FSCRYPT_KEY_DESCRIPTOR_SIZE);
-	memcpy(&hash_key, ci->ci_policy.v1.master_key_descriptor,
+	memcpy(&hash_key, cci->ci_policy.v1.master_key_descriptor,
 	       sizeof(hash_key));
 
 	spin_lock(&fscrypt_direct_keys_lock);
 	hash_for_each_possible(fscrypt_direct_keys, dk, dk_node, hash_key) {
-		if (memcmp(ci->ci_policy.v1.master_key_descriptor,
+		if (memcmp(cci->ci_policy.v1.master_key_descriptor,
 			   dk->dk_descriptor, FSCRYPT_KEY_DESCRIPTOR_SIZE) != 0)
 			continue;
-		if (ci->ci_mode != dk->dk_mode)
+		if (cci->ci_mode != dk->dk_mode)
 			continue;
-		if (!fscrypt_is_key_prepared(&dk->dk_key, ci))
+		if (!fscrypt_is_key_prepared(&dk->dk_key, cci))
 			continue;
-		if (crypto_memneq(raw_key, dk->dk_raw, ci->ci_mode->keysize))
+		if (crypto_memneq(raw_key, dk->dk_raw, cci->ci_mode->keysize))
 			continue;
 		/* using existing tfm with same (descriptor, mode, raw_key) */
 		refcount_inc(&dk->dk_refcount);
@@ -221,13 +222,13 @@ find_or_insert_direct_key(struct fscrypt_direct_key *to_insert,
 
 /* Prepare to encrypt directly using the master key in the given mode */
 static struct fscrypt_direct_key *
-fscrypt_get_direct_key(const struct fscrypt_info *ci, const u8 *raw_key)
+fscrypt_get_direct_key(const struct fscrypt_common_info *cci, const u8 *raw_key)
 {
 	struct fscrypt_direct_key *dk;
 	int err;
 
 	/* Is there already a tfm for this key? */
-	dk = find_or_insert_direct_key(NULL, raw_key, ci);
+	dk = find_or_insert_direct_key(NULL, raw_key, cci);
 	if (dk)
 		return dk;
 
@@ -235,18 +236,18 @@ fscrypt_get_direct_key(const struct fscrypt_info *ci, const u8 *raw_key)
 	dk = kzalloc(sizeof(*dk), GFP_KERNEL);
 	if (!dk)
 		return ERR_PTR(-ENOMEM);
-	dk->dk_sb = ci->ci_inode->i_sb;
+	dk->dk_sb = cci->ci_inode->i_sb;
 	refcount_set(&dk->dk_refcount, 1);
-	dk->dk_mode = ci->ci_mode;
+	dk->dk_mode = cci->ci_mode;
 	dk->dk_key.type = FSCRYPT_KEY_DIRECT_V1;
-	err = fscrypt_prepare_key(&dk->dk_key, raw_key, ci);
+	err = fscrypt_prepare_key(&dk->dk_key, raw_key, cci);
 	if (err)
 		goto err_free_dk;
-	memcpy(dk->dk_descriptor, ci->ci_policy.v1.master_key_descriptor,
+	memcpy(dk->dk_descriptor, cci->ci_policy.v1.master_key_descriptor,
 	       FSCRYPT_KEY_DESCRIPTOR_SIZE);
-	memcpy(dk->dk_raw, raw_key, ci->ci_mode->keysize);
+	memcpy(dk->dk_raw, raw_key, cci->ci_mode->keysize);
 
-	return find_or_insert_direct_key(dk, raw_key, ci);
+	return find_or_insert_direct_key(dk, raw_key, cci);
 
 err_free_dk:
 	free_direct_key(dk);
@@ -254,20 +255,20 @@ fscrypt_get_direct_key(const struct fscrypt_info *ci, const u8 *raw_key)
 }
 
 /* v1 policy, DIRECT_KEY: use the master key directly */
-static int setup_v1_file_key_direct(struct fscrypt_info *ci,
+static int setup_v1_info_key_direct(struct fscrypt_common_info *cci,
 				    const u8 *raw_master_key)
 {
 	struct fscrypt_direct_key *dk;
 
-	dk = fscrypt_get_direct_key(ci, raw_master_key);
+	dk = fscrypt_get_direct_key(cci, raw_master_key);
 	if (IS_ERR(dk))
 		return PTR_ERR(dk);
-	ci->ci_enc_key = &dk->dk_key;
+	cci->ci_enc_key = &dk->dk_key;
 	return 0;
 }
 
-/* v1 policy, !DIRECT_KEY: derive the file's encryption key */
-static int setup_v1_file_key_derived(struct fscrypt_info *ci,
+/* v1 policy, !DIRECT_KEY: derive the info's encryption key */
+static int setup_v1_info_key_derived(struct fscrypt_common_info *cci,
 				     const u8 *raw_master_key)
 {
 	u8 *derived_key;
@@ -277,47 +278,48 @@ static int setup_v1_file_key_derived(struct fscrypt_info *ci,
 	 * This cannot be a stack buffer because it will be passed to the
 	 * scatterlist crypto API during derive_key_aes().
 	 */
-	derived_key = kmalloc(ci->ci_mode->keysize, GFP_KERNEL);
+	derived_key = kmalloc(cci->ci_mode->keysize, GFP_KERNEL);
 	if (!derived_key)
 		return -ENOMEM;
 
-	err = derive_key_aes(raw_master_key, ci->ci_nonce,
-			     derived_key, ci->ci_mode->keysize);
+	err = derive_key_aes(raw_master_key, cci->ci_nonce,
+			     derived_key, cci->ci_mode->keysize);
 	if (err)
 		goto out;
 
-	err = fscrypt_set_per_file_enc_key(ci, derived_key);
+	err = fscrypt_set_per_info_enc_key(cci, derived_key);
 out:
 	kfree_sensitive(derived_key);
 	return err;
 }
 
-int fscrypt_setup_v1_file_key(struct fscrypt_info *ci, const u8 *raw_master_key)
+int fscrypt_setup_v1_info_key(struct fscrypt_common_info *cci,
+			      const u8 *raw_master_key)
 {
-	if (ci->ci_policy.v1.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY)
-		return setup_v1_file_key_direct(ci, raw_master_key);
+	if (cci->ci_policy.v1.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY)
+		return setup_v1_info_key_direct(cci, raw_master_key);
 	else
-		return setup_v1_file_key_derived(ci, raw_master_key);
+		return setup_v1_info_key_derived(cci, raw_master_key);
 }
 
-int fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_info *ci)
+int fscrypt_setup_v1_info_key_via_subscribed_keyrings(struct fscrypt_common_info *cci)
 {
 	struct key *key;
 	const struct fscrypt_key *payload;
 	int err;
 
 	key = find_and_lock_process_key(FSCRYPT_KEY_DESC_PREFIX,
-					ci->ci_policy.v1.master_key_descriptor,
-					ci->ci_mode->keysize, &payload);
-	if (key == ERR_PTR(-ENOKEY) && ci->ci_inode->i_sb->s_cop->key_prefix) {
-		key = find_and_lock_process_key(ci->ci_inode->i_sb->s_cop->key_prefix,
-						ci->ci_policy.v1.master_key_descriptor,
-						ci->ci_mode->keysize, &payload);
+					cci->ci_policy.v1.master_key_descriptor,
+					cci->ci_mode->keysize, &payload);
+	if (key == ERR_PTR(-ENOKEY) && cci->ci_inode->i_sb->s_cop->key_prefix) {
+		key = find_and_lock_process_key(cci->ci_inode->i_sb->s_cop->key_prefix,
+						cci->ci_policy.v1.master_key_descriptor,
+						cci->ci_mode->keysize, &payload);
 	}
 	if (IS_ERR(key))
 		return PTR_ERR(key);
 
-	err = fscrypt_setup_v1_file_key(ci, payload->raw);
+	err = fscrypt_setup_v1_info_key(cci, payload->raw);
 	up_read(&key->sem);
 	key_put(key);
 	return err;
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index f4456ecb3f87..ceb648669832 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -412,7 +412,7 @@ static int fscrypt_get_policy(struct inode *inode, union fscrypt_policy *policy)
 	ci = fscrypt_get_info(inode);
 	if (ci) {
 		/* key available, use the cached policy */
-		*policy = ci->ci_policy;
+		*policy = ci->info.ci_policy;
 		return 0;
 	}
 
@@ -698,7 +698,7 @@ const union fscrypt_policy *fscrypt_policy_to_inherit(struct inode *dir)
 		err = fscrypt_require_key(dir);
 		if (err)
 			return ERR_PTR(err);
-		return &dir->i_crypt_info->ci_policy;
+		return &dir->i_crypt_info->info.ci_policy;
 	}
 
 	return fscrypt_get_dummy_policy(dir->i_sb);
@@ -726,7 +726,7 @@ int fscrypt_context_for_new_inode(void *ctx, struct inode *inode)
 	if (WARN_ON_ONCE(!ci))
 		return -ENOKEY;
 
-	return fscrypt_new_context(ctx, &ci->ci_policy, ci->ci_nonce);
+	return fscrypt_new_context(ctx, &ci->info.ci_policy, ci->info.ci_nonce);
 }
 EXPORT_SYMBOL_GPL(fscrypt_context_for_new_inode);
 
@@ -743,6 +743,7 @@ EXPORT_SYMBOL_GPL(fscrypt_context_for_new_inode);
 int fscrypt_set_context(struct inode *inode, void *fs_data)
 {
 	struct fscrypt_info *ci = inode->i_crypt_info;
+	struct fscrypt_common_info *cci = &ci->info;
 	union fscrypt_context ctx;
 	int ctxsize;
 
@@ -754,9 +755,9 @@ int fscrypt_set_context(struct inode *inode, void *fs_data)
 	 * This may be the first time the inode number is available, so do any
 	 * delayed key setup that requires the inode number.
 	 */
-	if (ci->ci_policy.version == FSCRYPT_POLICY_V2 &&
-	    (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))
-		fscrypt_hash_inode_number(ci, ci->ci_master_key);
+	if (cci->ci_policy.version == FSCRYPT_POLICY_V2 &&
+	    (cci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))
+		fscrypt_hash_inode_number(cci, cci->ci_master_key);
 
 	return inode->i_sb->s_cop->set_context(inode, &ctx, ctxsize, fs_data);
 }
-- 
2.41.0

