Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD8724F270
	for <lists+linux-fscrypt@lfdr.de>; Mon, 24 Aug 2020 08:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgHXGSf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Aug 2020 02:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbgHXGS3 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Aug 2020 02:18:29 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 446D122B43;
        Mon, 24 Aug 2020 06:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598249900;
        bh=FMdqhGKiPJuHGox4c9HjS2vaN3+8vR0i3HMKgJxF+vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQyQZQJniVjChBFXxR3bF0x16R3eYZIA7rLFQeyDxK8kI1KwERQ2Wj5lm2hjVxMmg
         3Nxe/eWfi8Gq+7jcCSMCpgVFWl4M/qnEc4H3H+EjikdTyTQ7njVV+jR+9X8cw/bdtG
         QW0t7i1axoHJILN6yvBCn6ZUt3hNXnc1AUNSCwU0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>
Subject: [RFC PATCH 7/8] fscrypt: remove fscrypt_inherit_context()
Date:   Sun, 23 Aug 2020 23:17:11 -0700
Message-Id: <20200824061712.195654-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824061712.195654-1-ebiggers@kernel.org>
References: <20200824061712.195654-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that all filesystems have been converted to use
fscrypt_prepare_new_inode() and fscrypt_set_context(),
fscrypt_inherit_context() is no longer used.  So remove it.

Also change __fscrypt_encrypt_symlink() to no longer set up the inode's
key, since it's guaranteed to be set up already now that all filesystems
have been converted to fscrypt_prepare_new_inode().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/hooks.c       | 10 +++++++---
 fs/crypto/policy.c      | 37 -------------------------------------
 include/linux/fscrypt.h |  9 ---------
 3 files changed, 7 insertions(+), 49 deletions(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 09fb8aa0f2e93..b69cd29a01a2f 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -217,9 +217,13 @@ int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
 	struct fscrypt_symlink_data *sd;
 	unsigned int ciphertext_len;
 
-	err = fscrypt_require_key(inode);
-	if (err)
-		return err;
+	/*
+	 * fscrypt_prepare_new_inode() should have already set up the inode's
+	 * encryption key.  We don't wait until now to do it, since we may be in
+	 * a filesystem transaction now.
+	 */
+	if (WARN_ON_ONCE(!fscrypt_has_encryption_key(inode)))
+		return -ENOKEY;
 
 	if (disk_link->name) {
 		/* filesystem-provided buffer */
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index fbe4933206469..2220ef48d5846 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -625,43 +625,6 @@ int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
 }
 EXPORT_SYMBOL(fscrypt_has_permitted_context);
 
-/**
- * fscrypt_inherit_context() - Sets a child context from its parent
- * @parent: Parent inode from which the context is inherited.
- * @child:  Child inode that inherits the context from @parent.
- * @fs_data:  private data given by FS.
- * @preload:  preload child i_crypt_info if true
- *
- * Return: 0 on success, -errno on failure
- */
-int fscrypt_inherit_context(struct inode *parent, struct inode *child,
-						void *fs_data, bool preload)
-{
-	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
-	union fscrypt_context ctx;
-	int ctxsize;
-	struct fscrypt_info *ci;
-	int res;
-
-	res = fscrypt_get_encryption_info(parent);
-	if (res < 0)
-		return res;
-
-	ci = fscrypt_get_info(parent);
-	if (ci == NULL)
-		return -ENOKEY;
-
-	get_random_bytes(nonce, FSCRYPT_FILE_NONCE_SIZE);
-	ctxsize = fscrypt_new_context_from_policy(&ctx, &ci->ci_policy, nonce);
-
-	BUILD_BUG_ON(sizeof(ctx) != FSCRYPT_SET_CONTEXT_MAX_SIZE);
-	res = parent->i_sb->s_cop->set_context(child, &ctx, ctxsize, fs_data);
-	if (res)
-		return res;
-	return preload ? fscrypt_get_encryption_info(child): 0;
-}
-EXPORT_SYMBOL(fscrypt_inherit_context);
-
 /**
  * fscrypt_set_context() - Set the fscrypt context of a new inode
  * @inode: A new inode
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 726131dfa0a9b..4ee636e9e1fca 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -156,8 +156,6 @@ int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg);
 int fscrypt_ioctl_get_policy_ex(struct file *filp, void __user *arg);
 int fscrypt_ioctl_get_nonce(struct file *filp, void __user *arg);
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child);
-int fscrypt_inherit_context(struct inode *parent, struct inode *child,
-			    void *fs_data, bool preload);
 int fscrypt_set_context(struct inode *inode, void *fs_data);
 
 struct fscrypt_dummy_context {
@@ -343,13 +341,6 @@ static inline int fscrypt_has_permitted_context(struct inode *parent,
 	return 0;
 }
 
-static inline int fscrypt_inherit_context(struct inode *parent,
-					  struct inode *child,
-					  void *fs_data, bool preload)
-{
-	return -EOPNOTSUPP;
-}
-
 static inline int fscrypt_set_context(struct inode *inode, void *fs_data)
 {
 	return -EOPNOTSUPP;
-- 
2.28.0

