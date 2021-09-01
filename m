Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD0B3FDFE7
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Sep 2021 18:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245188AbhIAQ3M (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Sep 2021 12:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245531AbhIAQ3L (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Sep 2021 12:29:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6297A61059;
        Wed,  1 Sep 2021 16:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630513694;
        bh=ufeFbhxKyUYKrRSmcthT4Y2VdtA2h/ddAx00Dkj2THQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHNqRcE6RuyEMJdPr3gAfHaqAsveuXooYEeExP1YG+vnZ80Qp+zJa3yZRR44ZfrDP
         WnhSbg+DRNt5rXbtZTHzyzw74uQZwsOwpIPugBMzfKSQTcJ6awFPgNAARD1V0f26Vt
         aHXeHvZrHCDWyRnH0Z6iG13cn5W3k9QOSz4Q5Z+XFJdiAPdMhC3qW7KuBsgQytm6JA
         MNqXOqnceGeeCIAzB4LPCD9RWWINkR9YIt/GSF9OBbbWPjfglIJvEFbaLqfbjUJWN0
         leqnQdXHqMFGPzvq2E7yg26c0bYm2cjVeXgSg6m89IAK0QBuPQs/TyjO2KBjGrSfnJ
         pu/VDLSmrQbfw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 5.10 4/4] ubifs: report correct st_size for encrypted symlinks
Date:   Wed,  1 Sep 2021 09:27:21 -0700
Message-Id: <20210901162721.138605-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901162721.138605-1-ebiggers@kernel.org>
References: <20210901162721.138605-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 064c734986011390b4d111f1a99372b7f26c3850 upstream.

The stat() family of syscalls report the wrong size for encrypted
symlinks, which has caused breakage in several userspace programs.

Fix this by calling fscrypt_symlink_getattr() after ubifs_getattr() for
encrypted symlinks.  This function computes the correct size by reading
and decrypting the symlink target (if it's not already cached).

For more details, see the commit which added fscrypt_symlink_getattr().

Fixes: ca7f85be8d6c ("ubifs: Add support for encrypted symlinks")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210702065350.209646-5-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ubifs/file.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index b77d1637bbbc8..f4826b6da6828 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1629,6 +1629,16 @@ static const char *ubifs_get_link(struct dentry *dentry,
 	return fscrypt_get_symlink(inode, ui->data, ui->data_len, done);
 }
 
+static int ubifs_symlink_getattr(const struct path *path, struct kstat *stat,
+				 u32 request_mask, unsigned int query_flags)
+{
+	ubifs_getattr(path, stat, request_mask, query_flags);
+
+	if (IS_ENCRYPTED(d_inode(path->dentry)))
+		return fscrypt_symlink_getattr(path, stat);
+	return 0;
+}
+
 const struct address_space_operations ubifs_file_address_operations = {
 	.readpage       = ubifs_readpage,
 	.writepage      = ubifs_writepage,
@@ -1654,7 +1664,7 @@ const struct inode_operations ubifs_file_inode_operations = {
 const struct inode_operations ubifs_symlink_inode_operations = {
 	.get_link    = ubifs_get_link,
 	.setattr     = ubifs_setattr,
-	.getattr     = ubifs_getattr,
+	.getattr     = ubifs_symlink_getattr,
 #ifdef CONFIG_UBIFS_FS_XATTR
 	.listxattr   = ubifs_listxattr,
 #endif
-- 
2.33.0

