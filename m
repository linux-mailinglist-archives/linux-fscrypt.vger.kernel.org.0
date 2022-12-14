Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E8864D282
	for <lists+linux-fscrypt@lfdr.de>; Wed, 14 Dec 2022 23:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiLNWps (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Dec 2022 17:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiLNWpq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Dec 2022 17:45:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F8A25D4;
        Wed, 14 Dec 2022 14:45:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14DE2B81A45;
        Wed, 14 Dec 2022 22:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9331AC433F0;
        Wed, 14 Dec 2022 22:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671057941;
        bh=uJ3FO4tiueVTb/4lrSOqyDlwjeWDWqy+a4fT7SmmDcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0QbxiKYE2VOxgX/uB7OvsCcHekCwBxYw2+DygusA8QIW/Quxt8Sawkvfo9So92Wj
         mjwygoQ2CFNs9P6CmgHk/tVl+ql2dSMbauBMdaAScm4f6KWZgeoWkweCOQGhMKhbqX
         3k7Xy5GcgXcmkNtcKsbSDkNOzSK3XXnsz1gjrM8Z5VFoVvaxhpTxejOCJY/1i2yFci
         eF3GpIKe7EAvDJq1hWb/td9LMQxR5YRfLmjCBdXQL3XOOQcGyez3hIv9Hmkk9Qcswn
         BxQvfLOScLeHlnKv4MPCW/egRGUiIAei68p7yH4P5nrWUOsjxEnLojV0nDm308RKYn
         NCDecNzthjJjQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] fsverity: optimize fsverity_prepare_setattr() on non-verity files
Date:   Wed, 14 Dec 2022 14:43:02 -0800
Message-Id: <20221214224304.145712-3-ebiggers@kernel.org>
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

Make fsverity_prepare_setattr() an inline function that does the
IS_VERITY() check, then (if needed) calls __fsverity_prepare_setattr()
to do the real work.  This reduces the overhead on non-verity files.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/open.c         | 16 +++-------------
 include/linux/fsverity.h | 26 ++++++++++++++++++++++----
 2 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index 673d6db9abdf..e1e531d5e09a 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -337,26 +337,16 @@ int __fsverity_file_open(struct inode *inode, struct file *filp)
 }
 EXPORT_SYMBOL_GPL(__fsverity_file_open);
 
-/**
- * fsverity_prepare_setattr() - prepare to change a verity inode's attributes
- * @dentry: dentry through which the inode is being changed
- * @attr: attributes to change
- *
- * Verity files are immutable, so deny truncates.  This isn't covered by the
- * open-time check because sys_truncate() takes a path, not a file descriptor.
- *
- * Return: 0 on success, -errno on failure
- */
-int fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr)
+int __fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr)
 {
-	if (IS_VERITY(d_inode(dentry)) && (attr->ia_valid & ATTR_SIZE)) {
+	if (attr->ia_valid & ATTR_SIZE) {
 		pr_debug("Denying truncate of verity file (ino %lu)\n",
 			 d_inode(dentry)->i_ino);
 		return -EPERM;
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(fsverity_prepare_setattr);
+EXPORT_SYMBOL_GPL(__fsverity_prepare_setattr);
 
 /**
  * fsverity_cleanup_inode() - free the inode's verity info, if present
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 326bf2e2b903..84b498fff7ec 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -149,7 +149,7 @@ int fsverity_get_digest(struct inode *inode,
 /* open.c */
 
 int __fsverity_file_open(struct inode *inode, struct file *filp);
-int fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
+int __fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 void fsverity_cleanup_inode(struct inode *inode);
 
 /* read_metadata.c */
@@ -198,10 +198,10 @@ static inline int __fsverity_file_open(struct inode *inode, struct file *filp)
 	return -EOPNOTSUPP;
 }
 
-static inline int fsverity_prepare_setattr(struct dentry *dentry,
-					   struct iattr *attr)
+static inline int __fsverity_prepare_setattr(struct dentry *dentry,
+					     struct iattr *attr)
 {
-	return IS_VERITY(d_inode(dentry)) ? -EOPNOTSUPP : 0;
+	return -EOPNOTSUPP;
 }
 
 static inline void fsverity_cleanup_inode(struct inode *inode)
@@ -274,4 +274,22 @@ static inline int fsverity_file_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+/**
+ * fsverity_prepare_setattr() - prepare to change a verity inode's attributes
+ * @dentry: dentry through which the inode is being changed
+ * @attr: attributes to change
+ *
+ * Verity files are immutable, so deny truncates.  This isn't covered by the
+ * open-time check because sys_truncate() takes a path, not a file descriptor.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static inline int fsverity_prepare_setattr(struct dentry *dentry,
+					   struct iattr *attr)
+{
+	if (IS_VERITY(d_inode(dentry)))
+		return __fsverity_prepare_setattr(dentry, attr);
+	return 0;
+}
+
 #endif	/* _LINUX_FSVERITY_H */
-- 
2.38.1

