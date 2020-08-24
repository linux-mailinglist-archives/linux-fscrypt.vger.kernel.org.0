Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE42C24F265
	for <lists+linux-fscrypt@lfdr.de>; Mon, 24 Aug 2020 08:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgHXGSh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Aug 2020 02:18:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726051AbgHXGSU (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Aug 2020 02:18:20 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92272214F1;
        Mon, 24 Aug 2020 06:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598249899;
        bh=z1QylT8I+NmBP0tutYhzY5oX1yelfT7mim0uD9smtgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J03KdJQJPdY77kdOSQzv1oF4glUgsguRLqZPw0bmItnjV4mkJE5kE2RoajSp2OA2U
         27gS97vYGnq70XXtnvPMkPnmelOpJ2j1BFFb6SLZjQ7BCzkaB8YdwP8CBA5bGWNP6A
         Kp0XyIGXauI0bFNXQVHCYVjI6Ho7Gg6A1rHVfTck=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>
Subject: [RFC PATCH 5/8] f2fs: use fscrypt_prepare_new_inode() and fscrypt_set_context()
Date:   Sun, 23 Aug 2020 23:17:09 -0700
Message-Id: <20200824061712.195654-6-ebiggers@kernel.org>
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

Convert f2fs to use the new functions fscrypt_prepare_new_inode() and
fscrypt_set_context().  This avoids calling
fscrypt_get_encryption_info() from under f2fs_lock_op(), which can
deadlock because fscrypt_get_encryption_info() isn't GFP_NOFS-safe.

For more details about this problem, see the earlier patch
"fscrypt: add fscrypt_prepare_new_inode() and fscrypt_set_context()".

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/dir.c   |  2 +-
 fs/f2fs/f2fs.h  | 16 ----------------
 fs/f2fs/namei.c |  7 ++++++-
 3 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 069f498af1e38..d627ca97fc500 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -537,7 +537,7 @@ struct page *f2fs_init_inode_metadata(struct inode *inode, struct inode *dir,
 			goto put_error;
 
 		if (IS_ENCRYPTED(inode)) {
-			err = fscrypt_inherit_context(dir, inode, page, false);
+			err = fscrypt_set_context(inode, page);
 			if (err)
 				goto put_error;
 		}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 16322ea5b4630..eb37d1974ba8e 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4022,22 +4022,6 @@ static inline bool f2fs_lfs_mode(struct f2fs_sb_info *sbi)
 	return F2FS_OPTION(sbi).fs_mode == FS_MODE_LFS;
 }
 
-static inline bool f2fs_may_encrypt(struct inode *dir, struct inode *inode)
-{
-#ifdef CONFIG_FS_ENCRYPTION
-	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
-	umode_t mode = inode->i_mode;
-
-	/*
-	 * If the directory encrypted or dummy encryption enabled,
-	 * then we should encrypt the inode.
-	 */
-	if (IS_ENCRYPTED(dir) || DUMMY_ENCRYPTION_ENABLED(sbi))
-		return (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode));
-#endif
-	return false;
-}
-
 static inline bool f2fs_may_compress(struct inode *inode)
 {
 	if (IS_SWAPFILE(inode) || f2fs_is_pinned_file(inode) ||
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 84e4bbc1a64de..45f324511a19e 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -28,6 +28,7 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	nid_t ino;
 	struct inode *inode;
 	bool nid_free = false;
+	bool encrypt = false;
 	int xattr_size = 0;
 	int err;
 
@@ -69,13 +70,17 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 		F2FS_I(inode)->i_projid = make_kprojid(&init_user_ns,
 							F2FS_DEF_PROJID);
 
+	err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
+	if (err)
+		goto fail_drop;
+
 	err = dquot_initialize(inode);
 	if (err)
 		goto fail_drop;
 
 	set_inode_flag(inode, FI_NEW_INODE);
 
-	if (f2fs_may_encrypt(dir, inode))
+	if (encrypt)
 		f2fs_set_encrypted_inode(inode);
 
 	if (f2fs_sb_has_extra_attr(sbi)) {
-- 
2.28.0

