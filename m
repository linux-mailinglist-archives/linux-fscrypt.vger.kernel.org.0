Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8B9405CF4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Sep 2021 20:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbhIISqt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Sep 2021 14:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237208AbhIISqs (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Sep 2021 14:46:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE7B8610CE;
        Thu,  9 Sep 2021 18:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631213139;
        bh=aoyQEZvSd1+vYy9qkBjguGDggRTI0dLHoK9hq7Mx2yY=;
        h=From:To:Cc:Subject:Date:From;
        b=KXvkGpIrxCmJIdH1Km0g/8dgNjJHNKJJjqP5enlPVfhL+RYlDftQ7viPPIy8THpR8
         quKG2AnonGHE5r2rhH8iPJejTdvE+0/IKAS0AlZTE67DfWfmStoSo1STy0uhp3O/3J
         WzJBeoe1XtOeeVT+d4oRzrcQ82eexPguYWwiRLqDzRxQ4LQqnZ2m9Ag3wmcOquaCWs
         POCb9PUcH+dYTMwRwMYHI81XtGSSfr9/S5+/s63PsGqNWuoW0q+O6HTBPmUYgojO3i
         fQEADAswkp/rtccTS8vLlJ49dNtxGcC8gtcM5JdR1CWyxizM4p2g65XnKOJp5rMYZ8
         SANHIGYjwBAVA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH] fscrypt: remove fscrypt_operations::max_namelen
Date:   Thu,  9 Sep 2021 11:45:13 -0700
Message-Id: <20210909184513.139281-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The max_namelen field is unnecessary, as it is set to 255 (NAME_MAX) on
all filesystems that support fscrypt (or plan to support fscrypt).  For
simplicity, just use NAME_MAX directly instead.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c       | 3 +--
 fs/ext4/super.c         | 1 -
 fs/f2fs/super.c         | 1 -
 fs/ubifs/crypto.c       | 1 -
 include/linux/fscrypt.h | 3 ---
 5 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index eb538c28df940..a9be4bc74a94a 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -429,8 +429,7 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 
 	if (fscrypt_has_encryption_key(dir)) {
 		if (!fscrypt_fname_encrypted_size(&dir->i_crypt_info->ci_policy,
-						  iname->len,
-						  dir->i_sb->s_cop->max_namelen,
+						  iname->len, NAME_MAX,
 						  &fname->crypto_buf.len))
 			return -ENAMETOOLONG;
 		fname->crypto_buf.name = kmalloc(fname->crypto_buf.len,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 136940af00b88..47212d7c02b84 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1566,7 +1566,6 @@ static const struct fscrypt_operations ext4_cryptops = {
 	.set_context		= ext4_set_context,
 	.get_dummy_policy	= ext4_get_dummy_policy,
 	.empty_dir		= ext4_empty_dir,
-	.max_namelen		= EXT4_NAME_LEN,
 	.has_stable_inodes	= ext4_has_stable_inodes,
 	.get_ino_and_lblk_bits	= ext4_get_ino_and_lblk_bits,
 };
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 78ebc306ee2b5..cf049a042482b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2976,7 +2976,6 @@ static const struct fscrypt_operations f2fs_cryptops = {
 	.set_context		= f2fs_set_context,
 	.get_dummy_policy	= f2fs_get_dummy_policy,
 	.empty_dir		= f2fs_empty_dir,
-	.max_namelen		= F2FS_NAME_LEN,
 	.has_stable_inodes	= f2fs_has_stable_inodes,
 	.get_ino_and_lblk_bits	= f2fs_get_ino_and_lblk_bits,
 	.get_num_devices	= f2fs_get_num_devices,
diff --git a/fs/ubifs/crypto.c b/fs/ubifs/crypto.c
index 22be7aeb96c4f..c57b46a352d8f 100644
--- a/fs/ubifs/crypto.c
+++ b/fs/ubifs/crypto.c
@@ -82,5 +82,4 @@ const struct fscrypt_operations ubifs_crypt_operations = {
 	.get_context		= ubifs_crypt_get_context,
 	.set_context		= ubifs_crypt_set_context,
 	.empty_dir		= ubifs_crypt_empty_dir,
-	.max_namelen		= UBIFS_MAX_NLEN,
 };
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index e912ed9141d9d..91ea9477e9bd2 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -118,9 +118,6 @@ struct fscrypt_operations {
 	 */
 	bool (*empty_dir)(struct inode *inode);
 
-	/* The filesystem's maximum ciphertext filename length, in bytes */
-	unsigned int max_namelen;
-
 	/*
 	 * Check whether the filesystem's inode numbers and UUID are stable,
 	 * meaning that they will never be changed even by offline operations
-- 
2.33.0

