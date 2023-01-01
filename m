Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A6265A906
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjAAFN6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjAAFNt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:49 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AA563EB
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:47 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 19FD68265C;
        Sun,  1 Jan 2023 00:06:57 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549618; bh=SfbgwRvRXjakyDVaKMDHVQf4IR1C+seOS2+bYdbuWNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqIvraUpNpmm8JGSsr+LuhEm9MOi/T0J4kAZRmyLYcjsXEgDQPcSibxx0/QP14i4N
         Y8E8O0Qga7P9tvp8sttgwo8p57hCxOl6Xu+BaLbCeRILFN69yRxO9kVCK02Z+UaztW
         QAl15ABW5BargQiUoAXDTXnYFtteSEzprcwd+OPqcrZfWKo7FjV0Z2Fy/iuQE34FfH
         AL2xRIqdP6xpZphss+i/jKGnGi43JuqLUHf1zzQ7nylauptxuBOaQup5dGx0M6akhG
         mPn48El7g1a6cRiCsQHLtLe2R8kvbyRwVyU3Wi6bsdpz0qdh5LC8LdhCNjAW6umY7M
         HIxcIN9QhqD1w==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 15/17] fscrypt: allow load/save of extent contexts
Date:   Sun,  1 Jan 2023 00:06:19 -0500
Message-Id: <fd5c7a78de125737abe447370fe37f9fe90155d6.1672547582.git.sweettea-kernel@dorminy.me>
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

The other half of using per-extent infos is saving and loading them from
disk.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c    | 50 +++++++++++++++++++++++++++++++++++++++++
 fs/crypto/policy.c      | 20 +++++++++++++++++
 include/linux/fscrypt.h | 17 ++++++++++++++
 3 files changed, 87 insertions(+)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 136156487e8f..82439fb73dd9 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -799,6 +799,56 @@ void fscrypt_free_extent_info(struct fscrypt_info **info_ptr)
 }
 EXPORT_SYMBOL_GPL(fscrypt_free_extent_info);
 
+/**
+ * fscrypt_load_extent_info() - set up a preexisting extent's fscrypt_info
+ * @inode: the inode to which the extent belongs. Must be encrypted.
+ * @buf: a buffer containing the extent's stored context
+ * @len: the length of the @ctx buffer
+ * @info_ptr: a pointer to return the extent's fscrypt_info into. Should be
+ *	      a pointer to a member of the extent struct, as it will be passed
+ *	      back to the filesystem if key removal demands removal of the
+ *	      info from the extent
+ *
+ * This is not %GFP_NOFS safe, so the caller is expected to call
+ * memalloc_nofs_save/restore() if appropriate.
+ *
+ * Return: 0 if successful, or -errno if it fails.
+ */
+int fscrypt_load_extent_info(struct inode *inode, void *buf, size_t len,
+			     struct fscrypt_info **info_ptr)
+{
+	int res;
+	union fscrypt_context ctx;
+	union fscrypt_policy policy;
+
+	if (!fscrypt_has_encryption_key(inode))
+		return -EINVAL;
+
+	memcpy(&ctx, buf, len);
+
+	res = fscrypt_policy_from_context(&policy, &ctx, res);
+	if (res) {
+		fscrypt_warn(inode,
+			     "Unrecognized or corrupt encryption context");
+		return res;
+	}
+
+	if (!fscrypt_supported_policy(&policy, inode)) {
+		return -EINVAL;
+	}
+
+	res = fscrypt_setup_encryption_info(inode, &policy,
+					    fscrypt_context_nonce(&ctx),
+					    IS_CASEFOLDED(inode) &&
+					    S_ISDIR(inode->i_mode),
+					    info_ptr);
+
+	if (res == -ENOPKG) /* Algorithm unavailable? */
+		res = 0;
+	return res;
+}
+EXPORT_SYMBOL_GPL(fscrypt_load_extent_info);
+
 /**
  * fscrypt_put_encryption_info() - free most of an inode's fscrypt data
  * @inode: an inode being evicted
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index e7de4872d375..aab5edc1155e 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -751,6 +751,26 @@ int fscrypt_set_context(struct inode *inode, void *fs_data)
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_context);
 
+/**
+ * fscrypt_set_extent_context() - Set the fscrypt context for an extent
+ * @ci: info from which to fetch policy and nonce
+ * @ctx: where context should be written
+ * @len: the size of ctx
+ *
+ * Given an fscrypt_info belonging to an extent (generated via
+ * fscrypt_prepare_new_extent()), generate a new context and write it to @ctx.
+ * len is checked to be at least FSCRYPT_SET_CONTEXT_MAX_SIZE bytes.
+ *
+ * Return: size of the resulting context or a negative error code.
+ */
+int fscrypt_set_extent_context(struct fscrypt_info *ci, void *ctx, size_t len)
+{
+	if (len < FSCRYPT_SET_CONTEXT_MAX_SIZE)
+		return -EINVAL;
+	return fscrypt_new_context(ctx, &ci->ci_policy, ci->ci_nonce);
+}
+EXPORT_SYMBOL_GPL(fscrypt_set_extent_context);
+
 /**
  * fscrypt_parse_test_dummy_encryption() - parse the test_dummy_encryption mount option
  * @param: the mount option
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 6afdcb27f8a2..47c2df1061c7 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -324,6 +324,8 @@ int fscrypt_ioctl_get_nonce(struct file *filp, void __user *arg);
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child);
 int fscrypt_context_for_new_inode(void *ctx, struct inode *inode);
 int fscrypt_set_context(struct inode *inode, void *fs_data);
+int fscrypt_set_extent_context(struct fscrypt_info *info, void *ctx,
+			       size_t len);
 
 struct fscrypt_dummy_policy {
 	const union fscrypt_policy *policy;
@@ -367,6 +369,8 @@ int fscrypt_prepare_new_extent(struct inode *inode,
 			       struct fscrypt_info **info_ptr,
 			       bool *encrypt_ret);
 void fscrypt_free_extent_info(struct fscrypt_info **info_ptr);
+int fscrypt_load_extent_info(struct inode *inode, void *buf, size_t len,
+			     struct fscrypt_info **info_ptr);
 
 /* fname.c */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
@@ -532,6 +536,12 @@ static inline int fscrypt_set_context(struct inode *inode, void *fs_data)
 	return -EOPNOTSUPP;
 }
 
+static inline int fscrypt_set_extent_context(struct fscrypt_info *info,
+					     void *ctx, size_t len)
+{
+	return -EOPNOTSUPP;
+}
+
 struct fscrypt_dummy_policy {
 };
 
@@ -638,6 +648,13 @@ static inline void fscrypt_free_extent_info(struct fscrypt_info **info_ptr)
 {
 }
 
+static inline int fscrypt_load_extent_info(struct inode *inode, void *buf,
+					   size_t len,
+					   struct fscrypt_info **info_ptr)
+{
+	return -EOPNOTSUPP;
+}
+
  /* fname.c */
 static inline int fscrypt_setup_filename(struct inode *dir,
 					 const struct qstr *iname,
-- 
2.38.1

