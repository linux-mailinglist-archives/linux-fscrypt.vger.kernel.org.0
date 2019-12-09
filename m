Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A33DC117882
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 22:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfLIV2H (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 16:28:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfLIV2H (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 16:28:07 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1812206E0;
        Mon,  9 Dec 2019 21:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575926886;
        bh=Frp8QcVy6is/NCPye8pqNlRu3Z5/47R1LsMLNMzigbI=;
        h=From:To:Cc:Subject:Date:From;
        b=g25a24KspPruH8wRsvMoNSKeU1mQgTjrhMMF4ALB99tPc/zwxD9sferf8zPq10X6/
         sM8Egootu/xEz/lpyU8aqN9vw58zfdoKQHzTtVSg0qAmLbZNNUDRrXpbCckPhi/NhK
         WDuDZMXR5TmogxYAWNdpjfsk0+DN9jrAa6ydBJms=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-mtd@lists.infradead.org
Cc:     linux-fscrypt@vger.kernel.org,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] ubifs: use IS_ENCRYPTED() instead of ubifs_crypt_is_encrypted()
Date:   Mon,  9 Dec 2019 13:27:21 -0800
Message-Id: <20191209212721.244396-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

There's no need for the ubifs_crypt_is_encrypted() function anymore.
Just use IS_ENCRYPTED() instead, like ext4 and f2fs do.  IS_ENCRYPTED()
checks the VFS-level flag instead of the UBIFS-specific flag, but it
shouldn't change any behavior since the flags are kept in sync.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ubifs/dir.c     | 8 ++++----
 fs/ubifs/file.c    | 4 ++--
 fs/ubifs/journal.c | 6 +++---
 fs/ubifs/ubifs.h   | 7 -------
 4 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index acc4f942d25b6..636c3222c2308 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -81,7 +81,7 @@ struct inode *ubifs_new_inode(struct ubifs_info *c, struct inode *dir,
 	struct ubifs_inode *ui;
 	bool encrypted = false;
 
-	if (ubifs_crypt_is_encrypted(dir)) {
+	if (IS_ENCRYPTED(dir)) {
 		err = fscrypt_get_encryption_info(dir);
 		if (err) {
 			ubifs_err(c, "fscrypt_get_encryption_info failed: %i", err);
@@ -261,7 +261,7 @@ static struct dentry *ubifs_lookup(struct inode *dir, struct dentry *dentry,
 		goto done;
 	}
 
-	if (ubifs_crypt_is_encrypted(dir) &&
+	if (IS_ENCRYPTED(dir) &&
 	    (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)) &&
 	    !fscrypt_has_permitted_context(dir, inode)) {
 		ubifs_warn(c, "Inconsistent encryption contexts: %lu/%lu",
@@ -499,7 +499,7 @@ static int ubifs_readdir(struct file *file, struct dir_context *ctx)
 	struct ubifs_dent_node *dent;
 	struct inode *dir = file_inode(file);
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
-	bool encrypted = ubifs_crypt_is_encrypted(dir);
+	bool encrypted = IS_ENCRYPTED(dir);
 
 	dbg_gen("dir ino %lu, f_pos %#llx", dir->i_ino, ctx->pos);
 
@@ -1618,7 +1618,7 @@ int ubifs_getattr(const struct path *path, struct kstat *stat,
 
 static int ubifs_dir_open(struct inode *dir, struct file *file)
 {
-	if (ubifs_crypt_is_encrypted(dir))
+	if (IS_ENCRYPTED(dir))
 		return fscrypt_get_encryption_info(dir) ? -EACCES : 0;
 
 	return 0;
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index cd52585c8f4fe..c8e8f50c6054f 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -67,7 +67,7 @@ static int read_block(struct inode *inode, void *addr, unsigned int block,
 
 	dlen = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
 
-	if (ubifs_crypt_is_encrypted(inode)) {
+	if (IS_ENCRYPTED(inode)) {
 		err = ubifs_decrypt(inode, dn, &dlen, block);
 		if (err)
 			goto dump;
@@ -647,7 +647,7 @@ static int populate_page(struct ubifs_info *c, struct page *page,
 			dlen = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
 			out_len = UBIFS_BLOCK_SIZE;
 
-			if (ubifs_crypt_is_encrypted(inode)) {
+			if (IS_ENCRYPTED(inode)) {
 				err = ubifs_decrypt(inode, dn, &dlen, page_block);
 				if (err)
 					goto out_err;
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 388fe8f5dc51d..a38e18d3ef1d7 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -727,7 +727,7 @@ int ubifs_jnl_write_data(struct ubifs_info *c, const struct inode *inode,
 	int dlen = COMPRESSED_DATA_NODE_BUF_SZ, allocated = 1;
 	int write_len;
 	struct ubifs_inode *ui = ubifs_inode(inode);
-	bool encrypted = ubifs_crypt_is_encrypted(inode);
+	bool encrypted = IS_ENCRYPTED(inode);
 	u8 hash[UBIFS_HASH_ARR_SZ];
 
 	dbg_jnlk(key, "ino %lu, blk %u, len %d, key ",
@@ -1449,7 +1449,7 @@ static int truncate_data_node(const struct ubifs_info *c, const struct inode *in
 	dlen = old_dlen = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
 	compr_type = le16_to_cpu(dn->compr_type);
 
-	if (ubifs_crypt_is_encrypted(inode)) {
+	if (IS_ENCRYPTED(inode)) {
 		err = ubifs_decrypt(inode, dn, &dlen, block);
 		if (err)
 			goto out;
@@ -1465,7 +1465,7 @@ static int truncate_data_node(const struct ubifs_info *c, const struct inode *in
 		ubifs_compress(c, buf, *new_len, &dn->data, &out_len, &compr_type);
 	}
 
-	if (ubifs_crypt_is_encrypted(inode)) {
+	if (IS_ENCRYPTED(inode)) {
 		err = ubifs_encrypt(inode, dn, out_len, &old_dlen, block);
 		if (err)
 			goto out;
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index c55f212dcb759..bff682309fbef 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -2095,13 +2095,6 @@ int ubifs_decrypt(const struct inode *inode, struct ubifs_data_node *dn,
 
 extern const struct fscrypt_operations ubifs_crypt_operations;
 
-static inline bool ubifs_crypt_is_encrypted(const struct inode *inode)
-{
-	const struct ubifs_inode *ui = ubifs_inode(inode);
-
-	return ui->flags & UBIFS_CRYPT_FL;
-}
-
 /* Normal UBIFS messages */
 __printf(2, 3)
 void ubifs_msg(const struct ubifs_info *c, const char *fmt, ...);
-- 
2.24.0.393.g34dc348eaf-goog

