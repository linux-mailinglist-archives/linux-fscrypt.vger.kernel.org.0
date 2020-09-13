Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDB6267EBF
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Sep 2020 10:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgIMIix (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 13 Sep 2020 04:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgIMIiC (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 13 Sep 2020 04:38:02 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668D421D1A;
        Sun, 13 Sep 2020 08:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599986279;
        bh=QcAYVOOtDATZpIRqzv/LkDypHnDI6SB1ZfPpGvjEMKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUtAxnwOQeM7Dr2kgVlV4dfly4HkPpXojureiWqD3KugJJtonikaBJ/0WmS3mzwuK
         qMm4vt2DVIHEOZTV+hdqzAxhm6zjVO48B+OZgoviTP4C8OaMEwnUsQFSxeKIaiKp0X
         OfnRS1CorFgwModQHk4r5wqxh3MkMjhLTDRNgh6Y=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>,
        Daniel Rosenberg <drosen@google.com>
Subject: [PATCH v2 06/11] fscrypt: remove fscrypt_inherit_context()
Date:   Sun, 13 Sep 2020 01:36:15 -0700
Message-Id: <20200913083620.170627-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200913083620.170627-1-ebiggers@kernel.org>
References: <20200913083620.170627-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that all filesystems have been converted to use
fscrypt_prepare_new_inode() and fscrypt_set_context(),
fscrypt_inherit_context() is no longer used.  Remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/policy.c      | 37 -------------------------------------
 include/linux/fscrypt.h |  9 ---------
 2 files changed, 46 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 7e96953d385ec..4ff893f7b030a 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -628,43 +628,6 @@ int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
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
-	ctxsize = fscrypt_new_context(&ctx, &ci->ci_policy, nonce);
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
  * @inode: a new inode
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 9cf7ca90f3abb..81d6ded243288 100644
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

