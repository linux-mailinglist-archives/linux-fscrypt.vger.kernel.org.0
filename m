Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5314624DF73
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Aug 2020 20:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgHUS2S (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 14:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgHUS2Q (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 14:28:16 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE5AC23100;
        Fri, 21 Aug 2020 18:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598034496;
        bh=fpltE6CsINdq5JTodJ6i1B2vTSGZq6xV+oRtSc2jF0Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=2mmFNCUnCcFDCCVUQ3AK4EU06TnCDTzaMH5NGuTntrT8KOvD0Ww0cwKe1LvZCecM5
         7ulbBmEg7dd+v8m9LbjHRrQOfdpQF5bgIbYasR+WAQUA9iCEY4nOqTCwEJaIQ9TAJ+
         nsnxfWCw61Fcj+QkTYsPUF1hYlV7nxQYb5RV2/eg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 02/14] fscrypt: add fscrypt_new_context_from_parent
Date:   Fri, 21 Aug 2020 14:28:01 -0400
Message-Id: <20200821182813.52570-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821182813.52570-1-jlayton@kernel.org>
References: <20200821182813.52570-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Network filesystems usually don't know what inode number they'll have
until after the reply to a create RPC comes in. But we do need a
(blank) crypto context before that point. Break out the part of
fscrypt_inherit_context that creates a new context without setting it
into the new inode just yet.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/crypto/policy.c      | 42 ++++++++++++++++++++++++++++++-----------
 include/linux/fscrypt.h |  6 ++++++
 2 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 2d73fd39ad96..13e0a50157d5 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -621,19 +621,19 @@ int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 EXPORT_SYMBOL(fscrypt_has_permitted_context);
 
 /**
- * fscrypt_inherit_context() - Sets a child context from its parent
+ * fscrypt_new_context_from_parent() - generate a new fscrypt context from its parent
  * @parent: Parent inode from which the context is inherited.
- * @child:  Child inode that inherits the context from @parent.
- * @fs_data:  private data given by FS.
- * @preload:  preload child i_crypt_info if true
+ * @ctx: destination for new encryption context
  *
- * Return: 0 on success, -errno on failure
+ * Generate a new encryption context for an inode from its parent, suitable
+ * for later installation into a child dentry's inode. Returns positive
+ * length of the new context on success, or -errno on failure.
+ *
+ * Note that the caller must ensure that it provides sufficient buffer space
+ * to write out the context (at least FSCRYPT_SET_CONTEXT_MAX_SIZE bytes).
  */
-int fscrypt_inherit_context(struct inode *parent, struct inode *child,
-						void *fs_data, bool preload)
+int fscrypt_new_context_from_parent(struct inode *parent, void *ctx)
 {
-	union fscrypt_context ctx;
-	int ctxsize;
 	struct fscrypt_info *ci;
 	int res;
 
@@ -645,10 +645,30 @@ int fscrypt_inherit_context(struct inode *parent, struct inode *child,
 	if (ci == NULL)
 		return -ENOKEY;
 
-	ctxsize = fscrypt_new_context_from_policy(&ctx, &ci->ci_policy);
+	return fscrypt_new_context_from_policy(ctx, &ci->ci_policy);
+}
+EXPORT_SYMBOL(fscrypt_new_context_from_parent);
+
+/**
+ * fscrypt_inherit_context() - Sets a child context from its parent
+ * @parent: Parent inode from which the context is inherited.
+ * @child:  Child inode that inherits the context from @parent.
+ * @fs_data:  private data given by FS.
+ * @preload:  preload child i_crypt_info if true
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int fscrypt_inherit_context(struct inode *parent, struct inode *child,
+						void *fs_data, bool preload)
+{
+	union fscrypt_context ctx;
+	int res;
 
 	BUILD_BUG_ON(sizeof(ctx) != FSCRYPT_SET_CONTEXT_MAX_SIZE);
-	res = parent->i_sb->s_cop->set_context(child, &ctx, ctxsize, fs_data);
+	res = fscrypt_new_context_from_parent(parent, &ctx);
+	if (res < 0)
+		return res;
+	res = parent->i_sb->s_cop->set_context(child, &ctx, res, fs_data);
 	if (res)
 		return res;
 	return preload ? fscrypt_get_encryption_info(child): 0;
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index eaf16eb55788..c5fe6f334a1d 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -156,6 +156,7 @@ int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg);
 int fscrypt_ioctl_get_policy_ex(struct file *filp, void __user *arg);
 int fscrypt_ioctl_get_nonce(struct file *filp, void __user *arg);
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child);
+int fscrypt_new_context_from_parent(struct inode *parent, void *);
 int fscrypt_inherit_context(struct inode *parent, struct inode *child,
 			    void *fs_data, bool preload);
 
@@ -340,6 +341,11 @@ static inline int fscrypt_has_permitted_context(struct inode *parent,
 	return 0;
 }
 
+static inline int fscrypt_new_context_from_parent(struct inode *parent, void *ctx);
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int fscrypt_inherit_context(struct inode *parent,
 					  struct inode *child,
 					  void *fs_data, bool preload)
-- 
2.26.2

