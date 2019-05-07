Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0173158A8
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 May 2019 06:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbfEGE5z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 May 2019 00:57:55 -0400
Received: from asrmicro.com ([210.13.118.86]:37981 "EHLO mail2012.asrmicro.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfEGE5z (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 May 2019 00:57:55 -0400
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2019 00:57:54 EDT
Received: from localhost (10.1.170.159) by mail2012.asrmicro.com (10.1.24.123)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Tue, 7 May 2019 12:42:01
 +0800
From:   hongjiefang <hongjiefang@asrmicro.com>
To:     <tytso@mit.edu>, <jaegeuk@kernel.org>, <ebiggers@kernel.org>
CC:     <linux-fscrypt@vger.kernel.org>,
        hongjiefang <hongjiefang@asrmicro.com>
Subject: [PATCH] fscrypt: don't set policy for a dead directory
Date:   Tue, 7 May 2019 12:41:48 +0800
Message-ID: <1557204108-29048-1-git-send-email-hongjiefang@asrmicro.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.170.159]
X-ClientProxiedBy: mail2012.asrmicro.com (10.1.24.123) To
 mail2012.asrmicro.com (10.1.24.123)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

if the directory had been removed, should not set policy for it.

Signed-off-by: hongjiefang <hongjiefang@asrmicro.com>
---
 fs/crypto/policy.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index bd7eaf9..82900a4 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -77,6 +77,12 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 
 	inode_lock(inode);
 
+	/* don't set policy for a dead directory */
+	if (IS_DEADDIR(inode)) {
+		ret = -ENOENT;
+		goto deaddir_out;
+	}
+
 	ret = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
 	if (ret == -ENODATA) {
 		if (!S_ISDIR(inode->i_mode))
@@ -96,6 +102,7 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 		ret = -EEXIST;
 	}
 
+deaddir_out:
 	inode_unlock(inode);
 
 	mnt_drop_write_file(filp);
-- 
1.9.1

