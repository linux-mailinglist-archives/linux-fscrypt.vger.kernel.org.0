Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9524790579
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Sep 2023 07:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351617AbjIBF4E (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 2 Sep 2023 01:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343615AbjIBF4E (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 2 Sep 2023 01:56:04 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4AF10F4;
        Fri,  1 Sep 2023 22:56:00 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 727D3803B3;
        Sat,  2 Sep 2023 01:56:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1693634160; bh=KGmOigNZmiCYiYlflwG54i9oGQLZG48bRqPKe2ArkoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZ3boiZGzT0M9TFS1Jt360WK3yXhhnHy7KsRIWwtq8ozd+gFTMsVukkezahguV+55
         2IRRcW6W4wxj3MleYDUmJh9OPk5GSEtzFuJhDLqFdFLcu0+vdWvciknYsQjM3kGD1F
         6f6HrUaYj1RIvpYB98Hf21I9ycGcd3FnSjUwPOkUrhDyvPrJZIQeFf6TFk0WbsYC9t
         i4lHAfB/VnzP/2HAXloOTuPJh9/D25DIIacvktFZQp5v1AqIrtlC01xuPfMdlxWIP8
         oVBO37zMksniUO85CJboQH2SA0T1l/cHjdSsXJBklKAVaGDjcDssdtfEOgS8euMDqC
         gxJsYbaZ0LWHw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ebiggers@kernel.org, ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 06/13] fscrypt: allow load/save of extent contexts
Date:   Sat,  2 Sep 2023 01:54:24 -0400
Message-ID: <d8c497e023266d2a28810658d6e3f86863aaa14f.1693630890.git.sweettea-kernel@dorminy.me>
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

The other half of using per-extent infos is saving and loading them from
disk.

This is the one change which cares about whether a lightweight or
heavyweight extent context is stored on disk. This implements the
lightweight version.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c    | 39 +++++++++++++++++++++++++++++++++++++++
 fs/crypto/policy.c      | 22 ++++++++++++++++++++++
 include/linux/fscrypt.h | 19 +++++++++++++++++++
 3 files changed, 80 insertions(+)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index c9c16acf4c9b..90143377cc61 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -1044,6 +1044,45 @@ int fscrypt_prepare_new_extent(struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(fscrypt_prepare_new_extent);
 
+/**
+ * fscrypt_load_extent_info() - load a preexisting extent's fscrypt_extent_info
+ * @inode: the inode to which the extent belongs. Must be encrypted.
+ * @buf: a buffer containing the extent's stored context
+ * @len: the length of the @ctx buffer
+ * @info_ptr: a pointer to return the extent's fscrypt_extent_info into
+ *
+ * This is not %GFP_NOFS safe, so the caller is expected to call
+ * memalloc_nofs_save/restore() if appropriate.
+ *
+ * Return: 0 if successful, or -errno if it fails.
+ */
+int fscrypt_load_extent_info(struct inode *inode, void *buf, size_t len,
+			     struct fscrypt_extent_info **info_ptr)
+{
+	int res;
+	union fscrypt_context ctx;
+	const union fscrypt_policy *policy;
+
+	if (!fscrypt_has_encryption_key(inode))
+		return -EINVAL;
+
+	if (len != FSCRYPT_FILE_NONCE_SIZE) {
+		fscrypt_warn(inode,
+			     "Unrecognized or corrupt encryption context");
+		return -EINVAL;
+	}
+
+	policy = fscrypt_policy_to_inherit(inode);
+	if (policy == NULL)
+		return 0;
+	if (IS_ERR(policy))
+		return PTR_ERR(policy);
+
+	return fscrypt_setup_extent_info(inode, policy, buf,
+					 info_ptr);
+}
+EXPORT_SYMBOL_GPL(fscrypt_load_extent_info);
+
 /**
  * fscrypt_free_extent_info() - free an extent's fscrypt_extent_info
  * @info_ptr: a pointer containing the extent's fscrypt_extent_info pointer.
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index ceb648669832..cfbe83aee847 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -763,6 +763,28 @@ int fscrypt_set_context(struct inode *inode, void *fs_data)
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_context);
 
+/**
+ * fscrypt_set_extent_context() - Set the fscrypt extent context for an extent
+ * @ci: info from which to fetch policy and nonce
+ * @ctx: where context should be written
+ * @len: the size of ctx
+ *
+ * Given an fscrypt_extent_info belonging to an extent (generated via
+ * fscrypt_prepare_new_extent()), generate a new context and write it to @ctx.
+ * len is checked to be at least FSCRYPT_EXTENT_CONTEXT_MAX_SIZE bytes.
+ *
+ * Return: size of the resulting context or a negative error code.
+ */
+int fscrypt_set_extent_context(struct fscrypt_extent_info *ci, void *ctx,
+			       size_t len)
+{
+	if (len < FSCRYPT_EXTENT_CONTEXT_MAX_SIZE)
+		return -EINVAL;
+	memcpy(ctx, ci->info.ci_nonce, FSCRYPT_FILE_NONCE_SIZE);
+	return FSCRYPT_FILE_NONCE_SIZE;
+}
+EXPORT_SYMBOL_GPL(fscrypt_set_extent_context);
+
 /**
  * fscrypt_parse_test_dummy_encryption() - parse the test_dummy_encryption mount option
  * @param: the mount option
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index cc5de5ec888c..b57fc5645076 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -57,6 +57,7 @@ struct fscrypt_name {
 
 /* Maximum value for the third parameter of fscrypt_operations.set_context(). */
 #define FSCRYPT_SET_CONTEXT_MAX_SIZE	40
+#define FSCRYPT_EXTENT_CONTEXT_MAX_SIZE	16
 
 #ifdef CONFIG_FS_ENCRYPTION
 
@@ -317,6 +318,8 @@ int fscrypt_ioctl_get_nonce(struct file *filp, void __user *arg);
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child);
 int fscrypt_context_for_new_inode(void *ctx, struct inode *inode);
 int fscrypt_set_context(struct inode *inode, void *fs_data);
+int fscrypt_set_extent_context(struct fscrypt_extent_info *info, void *ctx,
+			       size_t len);
 
 struct fscrypt_dummy_policy {
 	const union fscrypt_policy *policy;
@@ -357,6 +360,9 @@ int fscrypt_drop_inode(struct inode *inode);
 int fscrypt_prepare_new_extent(struct inode *inode,
 			       struct fscrypt_extent_info **info_ptr);
 void fscrypt_free_extent_info(struct fscrypt_extent_info **info_ptr);
+int fscrypt_load_extent_info(struct inode *inode, void *buf, size_t len,
+			     struct fscrypt_extent_info **info_ptr);
+
 
 /* fname.c */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
@@ -533,6 +539,12 @@ static inline int fscrypt_set_context(struct inode *inode, void *fs_data)
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
 
@@ -632,6 +644,13 @@ static inline void fscrypt_free_extent_info(struct fscrypt_extent_info **info_pt
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
2.41.0

