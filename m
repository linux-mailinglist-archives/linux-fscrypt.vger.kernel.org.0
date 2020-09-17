Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CAE26D258
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Sep 2020 06:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgIQEVQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Sep 2020 00:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgIQEUv (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Sep 2020 00:20:51 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F35EA221E8;
        Thu, 17 Sep 2020 04:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600315991;
        bh=SHrYUdtm1g7ntgYtdzixMrvNEz6L5/D07nXI8RMvuM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0aZjJ50kI4WEJr9D62QjYoMh11x5Tz6VA/g+py5rlDxfKeC3rajPvnUPVqMZknrFY
         SuDXRZDPiTFzMBkCxcHGjYVuu5AN236OvZ4HJ4kYKHBG5HEMQlSdjEC39hh/8n1BjV
         V6rVVgLbSNn9KahPShkzKXqNX9H1Ek/XaZTG/iJ0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>,
        Daniel Rosenberg <drosen@google.com>
Subject: [PATCH v3 11/13] fscrypt: move fscrypt_prepare_symlink() out-of-line
Date:   Wed, 16 Sep 2020 21:11:34 -0700
Message-Id: <20200917041136.178600-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200917041136.178600-1-ebiggers@kernel.org>
References: <20200917041136.178600-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In preparation for moving the logic for "get the encryption policy
inherited by new files in this directory" to a single place, make
fscrypt_prepare_symlink() a regular function rather than an inline
function that wraps __fscrypt_prepare_symlink().

This way, the new function fscrypt_policy_to_inherit() won't need to be
exported to filesystems.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/hooks.c       | 39 ++++++++++++++++++++++---
 include/linux/fscrypt.h | 63 ++++++++++-------------------------------
 2 files changed, 50 insertions(+), 52 deletions(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 7748db5092409..a399c54947f28 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -166,12 +166,43 @@ int fscrypt_prepare_setflags(struct inode *inode,
 	return 0;
 }
 
-int __fscrypt_prepare_symlink(struct inode *dir, unsigned int len,
-			      unsigned int max_len,
-			      struct fscrypt_str *disk_link)
+/**
+ * fscrypt_prepare_symlink() - prepare to create a possibly-encrypted symlink
+ * @dir: directory in which the symlink is being created
+ * @target: plaintext symlink target
+ * @len: length of @target excluding null terminator
+ * @max_len: space the filesystem has available to store the symlink target
+ * @disk_link: (out) the on-disk symlink target being prepared
+ *
+ * This function computes the size the symlink target will require on-disk,
+ * stores it in @disk_link->len, and validates it against @max_len.  An
+ * encrypted symlink may be longer than the original.
+ *
+ * Additionally, @disk_link->name is set to @target if the symlink will be
+ * unencrypted, but left NULL if the symlink will be encrypted.  For encrypted
+ * symlinks, the filesystem must call fscrypt_encrypt_symlink() to create the
+ * on-disk target later.  (The reason for the two-step process is that some
+ * filesystems need to know the size of the symlink target before creating the
+ * inode, e.g. to determine whether it will be a "fast" or "slow" symlink.)
+ *
+ * Return: 0 on success, -ENAMETOOLONG if the symlink target is too long,
+ * -ENOKEY if the encryption key is missing, or another -errno code if a problem
+ * occurred while setting up the encryption key.
+ */
+int fscrypt_prepare_symlink(struct inode *dir, const char *target,
+			    unsigned int len, unsigned int max_len,
+			    struct fscrypt_str *disk_link)
 {
 	int err;
 
+	if (!IS_ENCRYPTED(dir) && !fscrypt_get_dummy_context(dir->i_sb)) {
+		disk_link->name = (unsigned char *)target;
+		disk_link->len = len + 1;
+		if (disk_link->len > max_len)
+			return -ENAMETOOLONG;
+		return 0;
+	}
+
 	/*
 	 * To calculate the size of the encrypted symlink target we need to know
 	 * the amount of NUL padding, which is determined by the flags set in
@@ -207,7 +238,7 @@ int __fscrypt_prepare_symlink(struct inode *dir, unsigned int len,
 	disk_link->name = NULL;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__fscrypt_prepare_symlink);
+EXPORT_SYMBOL_GPL(fscrypt_prepare_symlink);
 
 int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
 			      unsigned int len, struct fscrypt_str *disk_link)
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 81d6ded243288..39e7397a3f103 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -225,9 +225,9 @@ int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry,
 			     struct fscrypt_name *fname);
 int fscrypt_prepare_setflags(struct inode *inode,
 			     unsigned int oldflags, unsigned int flags);
-int __fscrypt_prepare_symlink(struct inode *dir, unsigned int len,
-			      unsigned int max_len,
-			      struct fscrypt_str *disk_link);
+int fscrypt_prepare_symlink(struct inode *dir, const char *target,
+			    unsigned int len, unsigned int max_len,
+			    struct fscrypt_str *disk_link);
 int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
 			      unsigned int len, struct fscrypt_str *disk_link);
 const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
@@ -520,15 +520,21 @@ static inline int fscrypt_prepare_setflags(struct inode *inode,
 	return 0;
 }
 
-static inline int __fscrypt_prepare_symlink(struct inode *dir,
-					    unsigned int len,
-					    unsigned int max_len,
-					    struct fscrypt_str *disk_link)
+static inline int fscrypt_prepare_symlink(struct inode *dir,
+					  const char *target,
+					  unsigned int len,
+					  unsigned int max_len,
+					  struct fscrypt_str *disk_link)
 {
-	return -EOPNOTSUPP;
+	if (IS_ENCRYPTED(dir))
+		return -EOPNOTSUPP;
+	disk_link->name = (unsigned char *)target;
+	disk_link->len = len + 1;
+	if (disk_link->len > max_len)
+		return -ENAMETOOLONG;
+	return 0;
 }
 
-
 static inline int __fscrypt_encrypt_symlink(struct inode *inode,
 					    const char *target,
 					    unsigned int len,
@@ -793,45 +799,6 @@ static inline int fscrypt_prepare_setattr(struct dentry *dentry,
 	return 0;
 }
 
-/**
- * fscrypt_prepare_symlink() - prepare to create a possibly-encrypted symlink
- * @dir: directory in which the symlink is being created
- * @target: plaintext symlink target
- * @len: length of @target excluding null terminator
- * @max_len: space the filesystem has available to store the symlink target
- * @disk_link: (out) the on-disk symlink target being prepared
- *
- * This function computes the size the symlink target will require on-disk,
- * stores it in @disk_link->len, and validates it against @max_len.  An
- * encrypted symlink may be longer than the original.
- *
- * Additionally, @disk_link->name is set to @target if the symlink will be
- * unencrypted, but left NULL if the symlink will be encrypted.  For encrypted
- * symlinks, the filesystem must call fscrypt_encrypt_symlink() to create the
- * on-disk target later.  (The reason for the two-step process is that some
- * filesystems need to know the size of the symlink target before creating the
- * inode, e.g. to determine whether it will be a "fast" or "slow" symlink.)
- *
- * Return: 0 on success, -ENAMETOOLONG if the symlink target is too long,
- * -ENOKEY if the encryption key is missing, or another -errno code if a problem
- * occurred while setting up the encryption key.
- */
-static inline int fscrypt_prepare_symlink(struct inode *dir,
-					  const char *target,
-					  unsigned int len,
-					  unsigned int max_len,
-					  struct fscrypt_str *disk_link)
-{
-	if (IS_ENCRYPTED(dir) || fscrypt_get_dummy_context(dir->i_sb) != NULL)
-		return __fscrypt_prepare_symlink(dir, len, max_len, disk_link);
-
-	disk_link->name = (unsigned char *)target;
-	disk_link->len = len + 1;
-	if (disk_link->len > max_len)
-		return -ENAMETOOLONG;
-	return 0;
-}
-
 /**
  * fscrypt_encrypt_symlink() - encrypt the symlink target if needed
  * @inode: symlink inode
-- 
2.28.0

