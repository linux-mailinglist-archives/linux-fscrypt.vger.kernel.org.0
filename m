Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A69C606673
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 18:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJTQ7L (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 12:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiJTQ7J (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 12:59:09 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81A01B65FF;
        Thu, 20 Oct 2022 09:59:07 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id DD825811B7;
        Thu, 20 Oct 2022 12:59:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666285147; bh=ZJb/nWtK7JLaDRMSgEotHlusdMQM0WtK8YP4s0ijPTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7mzc6XKlACXs2GtmCeoY+UzDiRSlewCv2zniijr0/t04Yh0QjvF8wZpecLZQIIh9
         Ugd4LGZ3QGAFszM1QWY/+ea6VrsO9ArN3EIAWFpT7xZmU9kW075mCs9lu8sMh+iVjV
         SU6zCqtm1Os/rPaU9uKlkt4W2YW5aFfR8Z4LCFp6w2egOZPIWer22TwdWoBo0CQsLa
         YCxieLLfjY8RkHqeo03AnGGpIYrxrQ9yQIqfhgNNThDrz0tmCegqsqEGfBX5JMrRY7
         xpo1PiZ0AqA6RRoWK/PLU8a7+vkG9M/Gae/LR9GQZrV5DKVXSDScBYwSVkNgw3GUAK
         C6e59wjmkHtQw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 04/22] fscrypt: add extent-based encryption
Date:   Thu, 20 Oct 2022 12:58:23 -0400
Message-Id: <d7246959ee0b8d2eeb7d6eb8cf40240374c6035c.1666281277.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1666281276.git.sweettea-kernel@dorminy.me>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Some filesystems need to encrypt data based on extents, rather than on
inodes, due to features incompatible with inode-based encryption. For
instance, btrfs can have multiple inodes referencing a single block of
data, and moves logical data blocks to different physical locations on
disk in the background; these two features mean traditional inode-based
file contents encryption will not work for btrfs.

This change introduces fscrypt_extent_context objects, in analogy to
existing context objects based on inodes. For a filesystem which opts to
use extent-based encryption, a new hook provides a new
fscrypt_extent_context, generated in close analogy to the IVs generated
with existing policies. During file content encryption/decryption, the
existing fscrypt_context object provides key information, while the new
fscrypt_extent_context provides IV information. For filename encryption,
the existing IV generation methods are still used, since filenames are
not stored in extents.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c          | 20 ++++++++--
 fs/crypto/fscrypt_private.h | 25 +++++++++++-
 fs/crypto/inline_crypt.c    | 28 ++++++++++---
 fs/crypto/policy.c          | 79 +++++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h     | 47 ++++++++++++++++++++++
 5 files changed, 189 insertions(+), 10 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 7fe5979fbea2..08b495dc5c0c 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -81,8 +81,22 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 			 const struct fscrypt_info *ci)
 {
 	u8 flags = fscrypt_policy_flags(&ci->ci_policy);
+	struct inode *inode = ci->ci_inode;
+	const struct fscrypt_operations *s_cop = inode->i_sb->s_cop;
 
-	memset(iv, 0, ci->ci_mode->ivsize);
+	memset(iv, 0, sizeof(*iv));
+	if (s_cop->get_extent_context && lblk_num != U64_MAX) {
+		size_t extent_offset;
+		union fscrypt_extent_context ctx;
+		int ret;
+
+		ret = fscrypt_get_extent_context(inode, lblk_num, &ctx,
+						 &extent_offset, NULL);
+		WARN_ON_ONCE(ret);
+		memcpy(iv->raw, ctx.v1.iv.raw, sizeof(*iv));
+		iv->lblk_num += cpu_to_le64(extent_offset);
+		return;
+	}
 
 	/*
 	 * Filename encryption. For inode-based policies, filenames are
@@ -93,8 +107,8 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 
 	if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
 		WARN_ON_ONCE(lblk_num > U32_MAX);
-		WARN_ON_ONCE(ci->ci_inode->i_ino > U32_MAX);
-		lblk_num |= (u64)ci->ci_inode->i_ino << 32;
+		WARN_ON_ONCE(inode->i_ino > U32_MAX);
+		lblk_num |= (u64)inode->i_ino << 32;
 	} else if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
 		WARN_ON_ONCE(lblk_num > U32_MAX);
 		lblk_num = (u32)(ci->ci_hashed_ino + lblk_num);
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index d5f68a0c5d15..9c4cae2580de 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -280,7 +280,6 @@ fscrypt_msg(const struct inode *inode, const char *level, const char *fmt, ...);
 	fscrypt_msg((inode), KERN_ERR, fmt, ##__VA_ARGS__)
 
 #define FSCRYPT_MAX_IV_SIZE	32
-
 union fscrypt_iv {
 	struct {
 		/* logical block number within the file */
@@ -293,6 +292,27 @@ union fscrypt_iv {
 	__le64 dun[FSCRYPT_MAX_IV_SIZE / sizeof(__le64)];
 };
 
+
+/*
+ * fscrypt_extent_context - the encryption context for an extent
+ *
+ * For filesystems that support extent encryption, this context provides the
+ * necessary randomly-initialized IV in order to encrypt/decrypt the data
+ * stored in the extent. It is stored alongside each extent, and is
+ * insufficient to decrypt the extent: the extent's owning inode(s) provide the
+ * policy information (including key identifier) necessary to decrypt.
+ */
+struct fscrypt_extent_context_v1 {
+	u8 version;
+	union fscrypt_iv iv;
+} __packed;
+
+union fscrypt_extent_context {
+	u8 version;
+	struct fscrypt_extent_context_v1 v1;
+};
+
+
 void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 			 const struct fscrypt_info *ci);
 
@@ -662,5 +682,8 @@ int fscrypt_policy_from_context(union fscrypt_policy *policy_u,
 				const union fscrypt_context *ctx_u,
 				int ctx_size);
 const union fscrypt_policy *fscrypt_policy_to_inherit(struct inode *dir);
+int fscrypt_get_extent_context(const struct inode *inode, u64 lblk_num,
+			       union fscrypt_extent_context *ctx,
+			       size_t *extent_offset, size_t *extent_length);
 
 #endif /* _FSCRYPT_PRIVATE_H */
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index cea8b14007e6..6adb72c52ce2 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -460,6 +460,7 @@ EXPORT_SYMBOL_GPL(fscrypt_dio_supported);
  */
 u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
 {
+	const struct fscrypt_operations *s_cop = inode->i_sb->s_cop;
 	const struct fscrypt_info *ci;
 	u32 dun;
 
@@ -470,14 +471,29 @@ u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
 		return nr_blocks;
 
 	ci = inode->i_crypt_info;
-	if (!(fscrypt_policy_flags(&ci->ci_policy) &
-	      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))
-		return nr_blocks;
 
-	/* With IV_INO_LBLK_32, the DUN can wrap around from U32_MAX to 0. */
+	if (s_cop->get_extent_context) {
+		size_t extent_offset, extent_length;
+		int ret = fscrypt_get_extent_context(inode, lblk, NULL,
+						     &extent_offset,
+						     &extent_length);
+		if (ret < 0) {
+			WARN_ON_ONCE(ret < 0);
+			return 1;
+		}
+		return extent_length - extent_offset;
+	}
 
-	dun = ci->ci_hashed_ino + lblk;
+	if ((fscrypt_policy_flags(&ci->ci_policy) &
+	      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)) {
+		/*
+		 * With IV_INO_LBLK_32, the DUN can wrap around from U32_MAX to
+		 * 0.
+		 */
+		dun = ci->ci_hashed_ino + lblk;
+		return min_t(u64, nr_blocks, (u64)U32_MAX + 1 - dun);
+	}
 
-	return min_t(u64, nr_blocks, (u64)U32_MAX + 1 - dun);
+	return nr_blocks;
 }
 EXPORT_SYMBOL_GPL(fscrypt_limit_io_blocks);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index b7c4820a8001..0a9bd20db023 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -777,6 +777,85 @@ int fscrypt_set_context(struct inode *inode, void *fs_data)
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_context);
 
+/**
+ * fscrypt_get_extent_context() - Get the fscrypt extent context for a location
+ *
+ * @inode: an inode associated with the extent
+ * @lblk_num: a logical block number within the inode owned by the extent
+ * @ctx: a pointer to return the context found (may be NULL)
+ * @extent_offset: a pointer to return the offset of @lblk_num within the
+ *                 extent (may be NULL)
+ * @extent_length: a pointer to return the length of the extent found (may be
+ *                 NULL)
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int fscrypt_get_extent_context(const struct inode *inode, u64 lblk_num,
+			       union fscrypt_extent_context *ctx,
+			       size_t *extent_offset, size_t *extent_length)
+{
+	int ret;
+	int ctxsize = (ctx == NULL ? 0 : sizeof(*ctx));
+
+	if (!IS_ENCRYPTED(inode))
+		return -ENODATA;
+
+	ret = inode->i_sb->s_cop->get_extent_context(inode, lblk_num, ctx,
+						     ctxsize, extent_offset,
+						     extent_length);
+	if (ret == ctxsize && (!ctx || ctx->version == 1))
+		return 0;
+	if (ret >= 0)
+		return -EINVAL;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fscrypt_get_extent_context);
+
+/**
+ * fscrypt_set_extent_context() - Set an extent's fscrypt context
+ *
+ * @inode: an inode to which the extent belongs
+ * @lblk_num: the offset into the inode at which the extent starts
+ * @extent: private data referring to the extent, given by the FS and passed
+ *          to ->set_extent_context()
+ *
+ * This should be called after fscrypt_prepare_new_inode(), generally during a
+ * filesystem transaction.  Everything here must be %GFP_NOFS-safe.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int fscrypt_set_extent_context(struct inode *inode, u64 lblk_num, void *extent)
+{
+	struct fscrypt_info *ci = fscrypt_get_info(inode);
+	u8 flags = fscrypt_policy_flags(&ci->ci_policy);
+	union fscrypt_extent_context ctx;
+
+	if (!IS_ENCRYPTED(inode))
+		return -ENODATA;
+
+	/*
+	 * Since the inode using this extent context is variable, most of the
+	 * IV generation policies that are in fscrypt_generate_iv() must be
+	 * implemented here for extent-based policies.
+	 */
+	ctx.v1.version = 1;
+	if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
+		WARN_ON_ONCE(lblk_num > U32_MAX);
+		WARN_ON_ONCE(inode->i_ino > U32_MAX);
+		lblk_num |= (u64)inode->i_ino << 32;
+	} else if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
+		WARN_ON_ONCE(lblk_num > U32_MAX);
+		lblk_num = (u32)(ci->ci_hashed_ino + lblk_num);
+	} else if (flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) {
+		memcpy(ctx.v1.iv.nonce, ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE);
+	}
+	ctx.v1.iv.lblk_num = cpu_to_le64(lblk_num);
+
+	return inode->i_sb->s_cop->set_extent_context(extent,
+						      &ctx, sizeof(ctx));
+}
+EXPORT_SYMBOL_GPL(fscrypt_set_extent_context);
+
 /**
  * fscrypt_parse_test_dummy_encryption() - parse the test_dummy_encryption mount option
  * @param: the mount option
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 9cc5a61c1200..4143c722ea1b 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -94,6 +94,13 @@ struct fscrypt_nokey_name {
 /* Maximum value for the third parameter of fscrypt_operations.set_context(). */
 #define FSCRYPT_SET_CONTEXT_MAX_SIZE	40
 
+/*
+ * Maximum value for the third parameter of
+ * fscrypt_operations.set_extent_context(). Update if fscrypt_private.h:
+ * FSCRYPT_MAX_IVSIZE changes
+ */
+#define FSCRYPT_EXTENT_CONTEXT_MAX_SIZE	33
+
 #ifdef CONFIG_FS_ENCRYPTION
 
 /*
@@ -150,6 +157,39 @@ struct fscrypt_operations {
 	int (*set_context)(struct inode *inode, const void *ctx, size_t len,
 			   void *fs_data);
 
+	/*
+	 * Get the fscrypt extent context for a given inode and lblk number.
+	 *
+	 * @inode: the inode to which the extent belongs
+	 * @lblk_num: the block number within the file whose extent is being
+	 *            queried
+	 * @ctx: the buffer into which to get the context (may be NULL)
+	 * @len: the length of the @ctx buffer in bytes
+	 * @extent_offset: a pointer to return the offset of @lblk_num within
+	 *                 the extent whose context is returned (may be NULL)
+	 * @extent_length: a pointer to return the total length of the extent
+	 *                 whose context was found (may be NULL)
+	 *
+	 * Return: On success, returns the length of the context in bytes,
+	 * which may be less than @len. On failure, returns -ENODATA if the
+	 * extent doesn't have a context, -ERANGE if the context is longer
+	 * than @len, or another -errno code.
+	 */
+	int (*get_extent_context)(const struct inode *inode, u64 lblk_num,
+				  void *ctx, size_t len,
+				  size_t *extent_offset, size_t *extent_length);
+
+	/*
+	 * Set the fscrypt extent context for an extent.
+	 *
+	 * @extent: an opaque pointer to the filesystem's extent object
+	 * @ctx: the buffer containing the extent context to set
+	 * @len: the length of the @ctx buffer in bytes
+	 *
+	 * Return: 0 on success, -errno on failure.
+	 */
+	int (*set_extent_context)(void *extent, void *ctx, size_t len);
+
 	/*
 	 * Get the dummy fscrypt policy in use on the filesystem (if any).
 	 *
@@ -321,6 +361,7 @@ int fscrypt_ioctl_get_nonce(struct file *filp, void __user *arg);
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child);
 int fscrypt_context_for_new_inode(void *ctx, struct inode *inode);
 int fscrypt_set_context(struct inode *inode, void *fs_data);
+int fscrypt_set_extent_context(struct inode *inode, u64 offset, void *extent);
 
 struct fscrypt_dummy_policy {
 	const union fscrypt_policy *policy;
@@ -530,6 +571,12 @@ static inline int fscrypt_set_context(struct inode *inode, void *fs_data)
 	return -EOPNOTSUPP;
 }
 
+static inline int fscrypt_set_extent_context(struct inode *inode, u64 offset,
+					     void *extent)
+{
+	return -EOPNOTSUPP;
+}
+
 struct fscrypt_dummy_policy {
 };
 
-- 
2.35.1

