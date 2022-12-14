Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF2364D276
	for <lists+linux-fscrypt@lfdr.de>; Wed, 14 Dec 2022 23:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiLNWpo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Dec 2022 17:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLNWpn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Dec 2022 17:45:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7601DE096;
        Wed, 14 Dec 2022 14:45:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F46961C2E;
        Wed, 14 Dec 2022 22:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DCBC433EF;
        Wed, 14 Dec 2022 22:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671057941;
        bh=PpIDTRfGV+7IlKXrZnNL1XI8NOCD138aZ//MeOn5bJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIxb3U19TdTMW/XjZRbF5iSsWfBW1G2AXMyGoj7Rdb/4gR2zYLH0BcqXN+abh/pRv
         M7fnNFvC1yHuSa/Rvuuild7RK7E4EbaNcmm+Ik+HNTLRUeoW0otySnAkIkZ/vv6vJt
         Jujbk5HQA56SgDMPGaAK7Eg4z8F2fnlagjLJB2zoExMnvKcwnJ4yXR07hZzEVZTVQH
         dgOPGr6mDo4GxlfwomIGxxLJPigyEUCALpmIEEb/mpEXbjGR9ixUq6wOOtWgIzawTk
         zhCMPqNy34vmxw2ZYbKx+2WRBdFtYz3IfQT8BKzOGIRKH1c2VK0ptVVK5UowjlbROW
         s9TwIHGJ4YSbg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] fsverity: optimize fsverity_file_open() on non-verity files
Date:   Wed, 14 Dec 2022 14:43:01 -0800
Message-Id: <20221214224304.145712-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221214224304.145712-1-ebiggers@kernel.org>
References: <20221214224304.145712-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,SUSPICIOUS_RECIPS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make fsverity_file_open() an inline function that does the IS_VERITY()
check, then (if needed) calls __fsverity_file_open() to do the real
work.  This reduces the overhead on non-verity files.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/open.c         | 20 ++------------------
 include/linux/fsverity.h | 26 +++++++++++++++++++++++---
 2 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index 81ff94442f7b..673d6db9abdf 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -325,24 +325,8 @@ static int ensure_verity_info(struct inode *inode)
 	return err;
 }
 
-/**
- * fsverity_file_open() - prepare to open a verity file
- * @inode: the inode being opened
- * @filp: the struct file being set up
- *
- * When opening a verity file, deny the open if it is for writing.  Otherwise,
- * set up the inode's ->i_verity_info if not already done.
- *
- * When combined with fscrypt, this must be called after fscrypt_file_open().
- * Otherwise, we won't have the key set up to decrypt the verity metadata.
- *
- * Return: 0 on success, -errno on failure
- */
-int fsverity_file_open(struct inode *inode, struct file *filp)
+int __fsverity_file_open(struct inode *inode, struct file *filp)
 {
-	if (!IS_VERITY(inode))
-		return 0;
-
 	if (filp->f_mode & FMODE_WRITE) {
 		pr_debug("Denying opening verity file (ino %lu) for write\n",
 			 inode->i_ino);
@@ -351,7 +335,7 @@ int fsverity_file_open(struct inode *inode, struct file *filp)
 
 	return ensure_verity_info(inode);
 }
-EXPORT_SYMBOL_GPL(fsverity_file_open);
+EXPORT_SYMBOL_GPL(__fsverity_file_open);
 
 /**
  * fsverity_prepare_setattr() - prepare to change a verity inode's attributes
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 40f14e5fed9d..326bf2e2b903 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -148,7 +148,7 @@ int fsverity_get_digest(struct inode *inode,
 
 /* open.c */
 
-int fsverity_file_open(struct inode *inode, struct file *filp);
+int __fsverity_file_open(struct inode *inode, struct file *filp);
 int fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 void fsverity_cleanup_inode(struct inode *inode);
 
@@ -193,9 +193,9 @@ static inline int fsverity_get_digest(struct inode *inode,
 
 /* open.c */
 
-static inline int fsverity_file_open(struct inode *inode, struct file *filp)
+static inline int __fsverity_file_open(struct inode *inode, struct file *filp)
 {
-	return IS_VERITY(inode) ? -EOPNOTSUPP : 0;
+	return -EOPNOTSUPP;
 }
 
 static inline int fsverity_prepare_setattr(struct dentry *dentry,
@@ -254,4 +254,24 @@ static inline bool fsverity_active(const struct inode *inode)
 	return fsverity_get_info(inode) != NULL;
 }
 
+/**
+ * fsverity_file_open() - prepare to open a verity file
+ * @inode: the inode being opened
+ * @filp: the struct file being set up
+ *
+ * When opening a verity file, deny the open if it is for writing.  Otherwise,
+ * set up the inode's ->i_verity_info if not already done.
+ *
+ * When combined with fscrypt, this must be called after fscrypt_file_open().
+ * Otherwise, we won't have the key set up to decrypt the verity metadata.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static inline int fsverity_file_open(struct inode *inode, struct file *filp)
+{
+	if (IS_VERITY(inode))
+		return __fsverity_file_open(inode, filp);
+	return 0;
+}
+
 #endif	/* _LINUX_FSVERITY_H */
-- 
2.38.1

