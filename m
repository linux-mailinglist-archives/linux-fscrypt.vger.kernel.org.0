Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D306665A8FE
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjAAFNy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjAAFNs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:48 -0500
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDC16402
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:47 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 3A2388265A;
        Sun,  1 Jan 2023 00:06:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549616; bh=a8XzKLzTV30UHtrV3sNb1efDRQt9J0wbwog5h8XPlpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsaakzQgOFu3hMx+HbgT0NeV6o1jessPHqt9qsENi+eMq3/CX7VTB0Ag4mQx0KNJV
         mkA9X5wRg5tyNuEbvjvu8y6Au3bFki2S+BwY6ESVOHCbfMlnVFNtYOKGQQhFt+TIql
         WLYlzzt/oNEZ5yOZWLpyYZTgK51khuugb8cLwqRFNFMROnerM3LYbbz97REkoQT68B
         ZE2md2/x76PQX/d9Gx9xZlIlFgtlTYRtgZu9674l/IpRcNMaIMP56kebwLX3jUbfeu
         bkTf6UaKB9wDz8k1zjLIh674J9o2KdSoag9ui6hmRZ7I7XxSFomp0KRaPL8rCVjkjs
         YjTEdvsZeV+7w==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 14/17] fscrypt: add creation/usage/freeing of per-extent infos
Date:   Sun,  1 Jan 2023 00:06:18 -0500
Message-Id: <9e1c2b101025a3388a6b31a8bdfb2b1cf59bf97c.1672547582.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1672547582.git.sweettea-kernel@dorminy.me>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

This change does not deal with saving and loading an extent's info, but
introduces the mechanics necessary therefore.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c          |  6 ++++
 fs/crypto/fscrypt_private.h | 14 +++++++--
 fs/crypto/keysetup.c        | 57 +++++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h     | 41 ++++++++++++++++++++++++++
 4 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 4760adc1158f..b2a293e1df29 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -118,6 +118,12 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 		return -EINVAL;
 	if (WARN_ON_ONCE(len % FSCRYPT_CONTENTS_ALIGNMENT != 0))
 		return -EINVAL;
+	if (!ci) {
+		fscrypt_err(inode,
+			    "Error %d getting extent info for block %llu",
+			    res, lblk_num);
+		return -EINVAL;
+	}
 
 	fscrypt_generate_iv(&iv, ci_offset, ci);
 
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index d937a320361e..eca911cca8a0 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -294,8 +294,7 @@ static inline bool fscrypt_uses_extent_encryption(const struct inode *inode)
 	if (!S_ISREG(inode->i_mode))
 		return false;
 
-	// No filesystem currently uses per-extent infos
-	return false;
+	return !!inode->i_sb->s_cop->get_extent_info;
 }
 
 /**
@@ -336,6 +335,17 @@ static inline struct fscrypt_info *
 fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
 		      u64 *extent_len)
 {
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
 	if (offset)
 		*offset = lblk;
 	if (extent_len)
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index f32b6f0a8336..136156487e8f 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -742,6 +742,63 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
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
+			       struct fscrypt_info **info_ptr,
+			       bool *encrypt_ret)
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
+	*encrypt_ret = true;
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
+	fscrypt_set_info(info_ptr, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(fscrypt_free_extent_info);
+
 /**
  * fscrypt_put_encryption_info() - free most of an inode's fscrypt data
  * @inode: an inode being evicted
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index c05e6ad3e729..6afdcb27f8a2 100644
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
@@ -340,6 +363,11 @@ void fscrypt_put_encryption_info(struct inode *inode);
 void fscrypt_free_inode(struct inode *inode);
 int fscrypt_drop_inode(struct inode *inode);
 
+int fscrypt_prepare_new_extent(struct inode *inode,
+			       struct fscrypt_info **info_ptr,
+			       bool *encrypt_ret);
+void fscrypt_free_extent_info(struct fscrypt_info **info_ptr);
+
 /* fname.c */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 			  u8 *out, unsigned int olen);
@@ -597,6 +625,19 @@ static inline int fscrypt_drop_inode(struct inode *inode)
 	return 0;
 }
 
+static inline int fscrypt_prepare_new_extent(struct inode *inode,
+					     struct fscrypt_info **info_ptr,
+					     bool *encrypt_ret)
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
2.38.1

