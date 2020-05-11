Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FE71CE3B0
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 May 2020 21:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731324AbgEKTQi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 11 May 2020 15:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731199AbgEKTQi (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 11 May 2020 15:16:38 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31D772078A;
        Mon, 11 May 2020 19:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589224597;
        bh=f1SsZ8S0Tc+NX/6mqK3Q1/MUIg/rcZWeqeOGAWgKAn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Apkk2SN0VlGSOEzimMSp0MLdP8xIFvGXTClD49l40f35lirdF5q57HXt0l+vhgZdV
         kWOythuutcj3ruTXj0vApFWocKED6BXleM2LNimAFl6WO0WGZRYxEkJSmw03qL0X5Y
         UFp6xm7qFeX/NFSw4nN/IO7If90vglGNcxOu6Dds=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/3] fscrypt: remove unnecessary extern keywords
Date:   Mon, 11 May 2020 12:13:58 -0700
Message-Id: <20200511191358.53096-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511191358.53096-1-ebiggers@kernel.org>
References: <20200511191358.53096-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Remove the unnecessary 'extern' keywords from function declarations.
This makes it so that we don't have a mix of both styles, so it won't be
ambiguous what to use in new fscrypt patches.  This also makes the code
shorter and matches the 'checkpatch --strict' expectation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h |  84 +++++++++++-----------
 include/linux/fscrypt.h     | 138 +++++++++++++++++-------------------
 2 files changed, 105 insertions(+), 117 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index f547094100be1e..20cbd9a4b28b0a 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -231,15 +231,14 @@ typedef enum {
 
 /* crypto.c */
 extern struct kmem_cache *fscrypt_info_cachep;
-extern int fscrypt_initialize(unsigned int cop_flags);
-extern int fscrypt_crypt_block(const struct inode *inode,
-			       fscrypt_direction_t rw, u64 lblk_num,
-			       struct page *src_page, struct page *dest_page,
-			       unsigned int len, unsigned int offs,
-			       gfp_t gfp_flags);
-extern struct page *fscrypt_alloc_bounce_page(gfp_t gfp_flags);
-
-extern void __printf(3, 4) __cold
+int fscrypt_initialize(unsigned int cop_flags);
+int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
+			u64 lblk_num, struct page *src_page,
+			struct page *dest_page, unsigned int len,
+			unsigned int offs, gfp_t gfp_flags);
+struct page *fscrypt_alloc_bounce_page(gfp_t gfp_flags);
+
+void __printf(3, 4) __cold
 fscrypt_msg(const struct inode *inode, const char *level, const char *fmt, ...);
 
 #define fscrypt_warn(inode, fmt, ...)		\
@@ -264,12 +263,10 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 			 const struct fscrypt_info *ci);
 
 /* fname.c */
-extern int fscrypt_fname_encrypt(const struct inode *inode,
-				 const struct qstr *iname,
-				 u8 *out, unsigned int olen);
-extern bool fscrypt_fname_encrypted_size(const struct inode *inode,
-					 u32 orig_len, u32 max_len,
-					 u32 *encrypted_len_ret);
+int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
+			  u8 *out, unsigned int olen);
+bool fscrypt_fname_encrypted_size(const struct inode *inode, u32 orig_len,
+				  u32 max_len, u32 *encrypted_len_ret);
 extern const struct dentry_operations fscrypt_d_ops;
 
 /* hkdf.c */
@@ -278,8 +275,8 @@ struct fscrypt_hkdf {
 	struct crypto_shash *hmac_tfm;
 };
 
-extern int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
-			     unsigned int master_key_size);
+int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
+		      unsigned int master_key_size);
 
 /*
  * The list of contexts in which fscrypt uses HKDF.  These values are used as
@@ -294,11 +291,11 @@ extern int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 #define HKDF_CONTEXT_IV_INO_LBLK_64_KEY	4
 #define HKDF_CONTEXT_DIRHASH_KEY	5
 
-extern int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
-			       const u8 *info, unsigned int infolen,
-			       u8 *okm, unsigned int okmlen);
+int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
+			const u8 *info, unsigned int infolen,
+			u8 *okm, unsigned int okmlen);
 
-extern void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf);
+void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf);
 
 /* keyring.c */
 
@@ -436,14 +433,14 @@ static inline int master_key_spec_len(const struct fscrypt_key_specifier *spec)
 	return 0;
 }
 
-extern struct key *
+struct key *
 fscrypt_find_master_key(struct super_block *sb,
 			const struct fscrypt_key_specifier *mk_spec);
 
-extern int fscrypt_verify_key_added(struct super_block *sb,
-				    const u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE]);
+int fscrypt_verify_key_added(struct super_block *sb,
+			     const u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE]);
 
-extern int __init fscrypt_init_keyring(void);
+int __init fscrypt_init_keyring(void);
 
 /* keysetup.c */
 
@@ -457,33 +454,32 @@ struct fscrypt_mode {
 
 extern struct fscrypt_mode fscrypt_modes[];
 
-extern struct crypto_skcipher *
-fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
-			  const struct inode *inode);
+struct crypto_skcipher *fscrypt_allocate_skcipher(struct fscrypt_mode *mode,
+						  const u8 *raw_key,
+						  const struct inode *inode);
 
-extern int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci,
-					const u8 *raw_key);
+int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key);
 
-extern int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
-				      const struct fscrypt_master_key *mk);
+int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
+			       const struct fscrypt_master_key *mk);
 
 /* keysetup_v1.c */
 
-extern void fscrypt_put_direct_key(struct fscrypt_direct_key *dk);
+void fscrypt_put_direct_key(struct fscrypt_direct_key *dk);
 
-extern int fscrypt_setup_v1_file_key(struct fscrypt_info *ci,
-				     const u8 *raw_master_key);
+int fscrypt_setup_v1_file_key(struct fscrypt_info *ci,
+			      const u8 *raw_master_key);
+
+int fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_info *ci);
 
-extern int fscrypt_setup_v1_file_key_via_subscribed_keyrings(
-					struct fscrypt_info *ci);
 /* policy.c */
 
-extern bool fscrypt_policies_equal(const union fscrypt_policy *policy1,
-				   const union fscrypt_policy *policy2);
-extern bool fscrypt_supported_policy(const union fscrypt_policy *policy_u,
-				     const struct inode *inode);
-extern int fscrypt_policy_from_context(union fscrypt_policy *policy_u,
-				       const union fscrypt_context *ctx_u,
-				       int ctx_size);
+bool fscrypt_policies_equal(const union fscrypt_policy *policy1,
+			    const union fscrypt_policy *policy2);
+bool fscrypt_supported_policy(const union fscrypt_policy *policy_u,
+			      const struct inode *inode);
+int fscrypt_policy_from_context(union fscrypt_policy *policy_u,
+				const union fscrypt_context *ctx_u,
+				int ctx_size);
 
 #endif /* _FSCRYPT_PRIVATE_H */
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 210a05dd9ecd4a..0e0c7ad1938368 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -108,22 +108,21 @@ static inline void fscrypt_handle_d_move(struct dentry *dentry)
 }
 
 /* crypto.c */
-extern void fscrypt_enqueue_decrypt_work(struct work_struct *);
-
-extern struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
-						     unsigned int len,
-						     unsigned int offs,
-						     gfp_t gfp_flags);
-extern int fscrypt_encrypt_block_inplace(const struct inode *inode,
-					 struct page *page, unsigned int len,
-					 unsigned int offs, u64 lblk_num,
-					 gfp_t gfp_flags);
-
-extern int fscrypt_decrypt_pagecache_blocks(struct page *page, unsigned int len,
-					    unsigned int offs);
-extern int fscrypt_decrypt_block_inplace(const struct inode *inode,
-					 struct page *page, unsigned int len,
-					 unsigned int offs, u64 lblk_num);
+void fscrypt_enqueue_decrypt_work(struct work_struct *);
+
+struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
+					      unsigned int len,
+					      unsigned int offs,
+					      gfp_t gfp_flags);
+int fscrypt_encrypt_block_inplace(const struct inode *inode, struct page *page,
+				  unsigned int len, unsigned int offs,
+				  u64 lblk_num, gfp_t gfp_flags);
+
+int fscrypt_decrypt_pagecache_blocks(struct page *page, unsigned int len,
+				     unsigned int offs);
+int fscrypt_decrypt_block_inplace(const struct inode *inode, struct page *page,
+				  unsigned int len, unsigned int offs,
+				  u64 lblk_num);
 
 static inline bool fscrypt_is_bounce_page(struct page *page)
 {
@@ -135,81 +134,74 @@ static inline struct page *fscrypt_pagecache_page(struct page *bounce_page)
 	return (struct page *)page_private(bounce_page);
 }
 
-extern void fscrypt_free_bounce_page(struct page *bounce_page);
+void fscrypt_free_bounce_page(struct page *bounce_page);
 
 /* policy.c */
-extern int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg);
-extern int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg);
-extern int fscrypt_ioctl_get_policy_ex(struct file *filp, void __user *arg);
-extern int fscrypt_ioctl_get_nonce(struct file *filp, void __user *arg);
-extern int fscrypt_has_permitted_context(struct inode *parent,
-					 struct inode *child);
-extern int fscrypt_inherit_context(struct inode *parent, struct inode *child,
-				   void *fs_data, bool preload);
+int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg);
+int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg);
+int fscrypt_ioctl_get_policy_ex(struct file *filp, void __user *arg);
+int fscrypt_ioctl_get_nonce(struct file *filp, void __user *arg);
+int fscrypt_has_permitted_context(struct inode *parent, struct inode *child);
+int fscrypt_inherit_context(struct inode *parent, struct inode *child,
+			    void *fs_data, bool preload);
 
 /* keyring.c */
-extern void fscrypt_sb_free(struct super_block *sb);
-extern int fscrypt_ioctl_add_key(struct file *filp, void __user *arg);
-extern int fscrypt_ioctl_remove_key(struct file *filp, void __user *arg);
-extern int fscrypt_ioctl_remove_key_all_users(struct file *filp,
-					      void __user *arg);
-extern int fscrypt_ioctl_get_key_status(struct file *filp, void __user *arg);
+void fscrypt_sb_free(struct super_block *sb);
+int fscrypt_ioctl_add_key(struct file *filp, void __user *arg);
+int fscrypt_ioctl_remove_key(struct file *filp, void __user *arg);
+int fscrypt_ioctl_remove_key_all_users(struct file *filp, void __user *arg);
+int fscrypt_ioctl_get_key_status(struct file *filp, void __user *arg);
 
 /* keysetup.c */
-extern int fscrypt_get_encryption_info(struct inode *inode);
-extern void fscrypt_put_encryption_info(struct inode *inode);
-extern void fscrypt_free_inode(struct inode *inode);
-extern int fscrypt_drop_inode(struct inode *inode);
+int fscrypt_get_encryption_info(struct inode *inode);
+void fscrypt_put_encryption_info(struct inode *inode);
+void fscrypt_free_inode(struct inode *inode);
+int fscrypt_drop_inode(struct inode *inode);
 
 /* fname.c */
-extern int fscrypt_setup_filename(struct inode *inode, const struct qstr *iname,
-				  int lookup, struct fscrypt_name *fname);
+int fscrypt_setup_filename(struct inode *inode, const struct qstr *iname,
+			   int lookup, struct fscrypt_name *fname);
 
 static inline void fscrypt_free_filename(struct fscrypt_name *fname)
 {
 	kfree(fname->crypto_buf.name);
 }
 
-extern int fscrypt_fname_alloc_buffer(const struct inode *inode,
-				      u32 max_encrypted_len,
-				      struct fscrypt_str *crypto_str);
-extern void fscrypt_fname_free_buffer(struct fscrypt_str *crypto_str);
-extern int fscrypt_fname_disk_to_usr(const struct inode *inode,
-				     u32 hash, u32 minor_hash,
-				     const struct fscrypt_str *iname,
-				     struct fscrypt_str *oname);
-extern bool fscrypt_match_name(const struct fscrypt_name *fname,
-			       const u8 *de_name, u32 de_name_len);
-extern u64 fscrypt_fname_siphash(const struct inode *dir,
-				 const struct qstr *name);
+int fscrypt_fname_alloc_buffer(const struct inode *inode, u32 max_encrypted_len,
+			       struct fscrypt_str *crypto_str);
+void fscrypt_fname_free_buffer(struct fscrypt_str *crypto_str);
+int fscrypt_fname_disk_to_usr(const struct inode *inode,
+			      u32 hash, u32 minor_hash,
+			      const struct fscrypt_str *iname,
+			      struct fscrypt_str *oname);
+bool fscrypt_match_name(const struct fscrypt_name *fname,
+			const u8 *de_name, u32 de_name_len);
+u64 fscrypt_fname_siphash(const struct inode *dir, const struct qstr *name);
 
 /* bio.c */
-extern void fscrypt_decrypt_bio(struct bio *bio);
-extern int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
-				 sector_t pblk, unsigned int len);
+void fscrypt_decrypt_bio(struct bio *bio);
+int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
+			  sector_t pblk, unsigned int len);
 
 /* hooks.c */
-extern int fscrypt_file_open(struct inode *inode, struct file *filp);
-extern int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
-				  struct dentry *dentry);
-extern int __fscrypt_prepare_rename(struct inode *old_dir,
-				    struct dentry *old_dentry,
-				    struct inode *new_dir,
-				    struct dentry *new_dentry,
-				    unsigned int flags);
-extern int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry,
-				    struct fscrypt_name *fname);
-extern int fscrypt_prepare_setflags(struct inode *inode,
-				    unsigned int oldflags, unsigned int flags);
-extern int __fscrypt_prepare_symlink(struct inode *dir, unsigned int len,
-				     unsigned int max_len,
-				     struct fscrypt_str *disk_link);
-extern int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
-				     unsigned int len,
-				     struct fscrypt_str *disk_link);
-extern const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
-				       unsigned int max_size,
-				       struct delayed_call *done);
+int fscrypt_file_open(struct inode *inode, struct file *filp);
+int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
+			   struct dentry *dentry);
+int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
+			     struct inode *new_dir, struct dentry *new_dentry,
+			     unsigned int flags);
+int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry,
+			     struct fscrypt_name *fname);
+int fscrypt_prepare_setflags(struct inode *inode,
+			     unsigned int oldflags, unsigned int flags);
+int __fscrypt_prepare_symlink(struct inode *dir, unsigned int len,
+			      unsigned int max_len,
+			      struct fscrypt_str *disk_link);
+int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
+			      unsigned int len, struct fscrypt_str *disk_link);
+const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
+				unsigned int max_size,
+				struct delayed_call *done);
 static inline void fscrypt_set_ops(struct super_block *sb,
 				   const struct fscrypt_operations *s_cop)
 {
-- 
2.26.2

