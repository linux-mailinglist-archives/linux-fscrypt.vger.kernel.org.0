Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7BA1751E
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 May 2019 11:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfEHJ2C (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 May 2019 05:28:02 -0400
Received: from asrmicro.com ([210.13.118.86]:14012 "EHLO mail2012.asrmicro.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbfEHJ2C (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 May 2019 05:28:02 -0400
Received: from localhost (10.1.170.159) by mail2012.asrmicro.com (10.1.24.123)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Wed, 8 May 2019 17:27:42
 +0800
From:   hongjiefang <hongjiefang@asrmicro.com>
To:     <tytso@mit.edu>, <jaegeuk@kernel.org>, <ebiggers@kernel.org>
CC:     <linux-fscrypt@vger.kernel.org>,
        hongjiefang <hongjiefang@asrmicro.com>, <stable@vger.kernel.org>
Subject: [PATCH V2] fscrypt: don't set policy for a dead directory
Date:   Wed, 8 May 2019 17:27:34 +0800
Message-ID: <1557307654-673-1-git-send-email-hongjiefang@asrmicro.com>
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

the directory maybe has been removed when enter fscrypt_ioctl_set_policy().
it this case, the empty_dir() check will return error for ext4 file system.

ext4_rmdir() sets i_size = 0, then ext4_empty_dir() reports an error
because 'inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2)'.
if the fs is mounted with errors=panic, it will trigger a panic issue.

add the check IS_DEADDIR() to fix this problem.

Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
Cc: <stable@vger.kernel.org> # v4.1+
Signed-off-by: hongjiefang <hongjiefang@asrmicro.com>
---
 fs/crypto/policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index bd7eaf9..a4eca6e 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -81,6 +81,8 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 	if (ret == -ENODATA) {
 		if (!S_ISDIR(inode->i_mode))
 			ret = -ENOTDIR;
+		else if (IS_DEADDIR(inode))
+			ret = -ENOENT;
 		else if (!inode->i_sb->s_cop->empty_dir(inode))
 			ret = -ENOTEMPTY;
 		else
-- 
1.9.1

