Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091D7240766
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Aug 2020 16:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgHJOVl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Aug 2020 10:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbgHJOVl (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Aug 2020 10:21:41 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 935072070B
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Aug 2020 14:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597069300;
        bh=Y9wJvCBZwpXKmBd2JudHP20xlz3pIc12TPRmbavKFN0=;
        h=From:To:Subject:Date:From;
        b=lA7qLUaPa4DbgOQ0M/Dq89pW5X1zim9kSNat4OsA+G7QNLz8zJ1s+pmaUGOMmK71s
         TM4Z+Ci0GyufJeQYMgB85Kr7ZGqIcV7TsWsMAqPf+oU5VmIjXIVmCi3P4zNoh+IH+N
         O74oqPRmEo1HSKQ6zjon2XVKTO1Ju4zBfLbF9RNE=
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: drop unused inode argument from fscrypt_fname_alloc_buffer
Date:   Mon, 10 Aug 2020 10:21:39 -0400
Message-Id: <20200810142139.487631-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/crypto/fname.c       | 5 +----
 fs/crypto/hooks.c       | 2 +-
 fs/ext4/dir.c           | 2 +-
 fs/ext4/namei.c         | 7 +++----
 fs/f2fs/dir.c           | 2 +-
 fs/ubifs/dir.c          | 2 +-
 include/linux/fscrypt.h | 5 ++---
 7 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 83ca5f1e7934..7f3a52073f9c 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -277,8 +277,6 @@ bool fscrypt_fname_encrypted_size(const struct inode *inode, u32 orig_len,
 
 /**
  * fscrypt_fname_alloc_buffer() - allocate a buffer for presented filenames
- * @inode: inode of the parent directory (for regular filenames)
- *	   or of the symlink (for symlink targets)
  * @max_encrypted_len: maximum length of encrypted filenames the buffer will be
  *		       used to present
  * @crypto_str: (output) buffer to allocate
@@ -288,8 +286,7 @@ bool fscrypt_fname_encrypted_size(const struct inode *inode, u32 orig_len,
  *
  * Return: 0 on success, -errno on failure
  */
-int fscrypt_fname_alloc_buffer(const struct inode *inode,
-			       u32 max_encrypted_len,
+int fscrypt_fname_alloc_buffer(u32 max_encrypted_len,
 			       struct fscrypt_str *crypto_str)
 {
 	const u32 max_encoded_len = BASE64_CHARS(FSCRYPT_NOKEY_NAME_MAX);
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 09fb8aa0f2e9..491b252843eb 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -319,7 +319,7 @@ const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
 	if (cstr.len + sizeof(*sd) - 1 > max_size)
 		return ERR_PTR(-EUCLEAN);
 
-	err = fscrypt_fname_alloc_buffer(inode, cstr.len, &pstr);
+	err = fscrypt_fname_alloc_buffer(cstr.len, &pstr);
 	if (err)
 		return ERR_PTR(err);
 
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 1d82336b1cd4..efe77cffc322 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -148,7 +148,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 	}
 
 	if (IS_ENCRYPTED(inode)) {
-		err = fscrypt_fname_alloc_buffer(inode, EXT4_NAME_LEN, &fstr);
+		err = fscrypt_fname_alloc_buffer(EXT4_NAME_LEN, &fstr);
 		if (err < 0)
 			return err;
 	}
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 56738b538ddf..f41c8bfe8b5a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -663,8 +663,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 
 					/* Directory is encrypted */
 					res = fscrypt_fname_alloc_buffer(
-						dir, len,
-						&fname_crypto_str);
+						len, &fname_crypto_str);
 					if (res)
 						printk(KERN_WARNING "Error "
 							"allocating crypto "
@@ -1016,8 +1015,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 			brelse(bh);
 			return err;
 		}
-		err = fscrypt_fname_alloc_buffer(dir, EXT4_NAME_LEN,
-						     &fname_crypto_str);
+		err = fscrypt_fname_alloc_buffer(EXT4_NAME_LEN,
+						 &fname_crypto_str);
 		if (err < 0) {
 			brelse(bh);
 			return err;
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index d35976785e8c..74002b10c39f 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -1032,7 +1032,7 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 		if (err)
 			goto out;
 
-		err = fscrypt_fname_alloc_buffer(inode, F2FS_NAME_LEN, &fstr);
+		err = fscrypt_fname_alloc_buffer(F2FS_NAME_LEN, &fstr);
 		if (err < 0)
 			goto out;
 	}
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index ef85ec167a84..03fb4cb57244 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -515,7 +515,7 @@ static int ubifs_readdir(struct file *file, struct dir_context *ctx)
 		if (err)
 			return err;
 
-		err = fscrypt_fname_alloc_buffer(dir, UBIFS_MAX_NLEN, &fstr);
+		err = fscrypt_fname_alloc_buffer(UBIFS_MAX_NLEN, &fstr);
 		if (err)
 			return err;
 
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 2862ca5fea33..f025c669a943 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -189,7 +189,7 @@ static inline void fscrypt_free_filename(struct fscrypt_name *fname)
 	kfree(fname->crypto_buf.name);
 }
 
-int fscrypt_fname_alloc_buffer(const struct inode *inode, u32 max_encrypted_len,
+int fscrypt_fname_alloc_buffer(u32 max_encrypted_len,
 			       struct fscrypt_str *crypto_str);
 void fscrypt_fname_free_buffer(struct fscrypt_str *crypto_str);
 int fscrypt_fname_disk_to_usr(const struct inode *inode,
@@ -420,8 +420,7 @@ static inline void fscrypt_free_filename(struct fscrypt_name *fname)
 	return;
 }
 
-static inline int fscrypt_fname_alloc_buffer(const struct inode *inode,
-					     u32 max_encrypted_len,
+static inline int fscrypt_fname_alloc_buffer(u32 max_encrypted_len,
 					     struct fscrypt_str *crypto_str)
 {
 	return -EOPNOTSUPP;
-- 
2.26.2

