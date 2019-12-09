Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 565221177A8
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 21:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfLIUor (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 15:44:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbfLIUor (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 15:44:47 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AF9020637
        for <linux-fscrypt@vger.kernel.org>; Mon,  9 Dec 2019 20:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575924286;
        bh=norcLkOxXNB//5GnFyI+TMDf176TflLTuzeaMjsVcRU=;
        h=From:To:Subject:Date:From;
        b=hABDK1FKwHkwKb4a0tx4X/yIrA2hAoppn2VvFy8qa2bQIeq4j+6Qc3qswg4LNttpx
         obz7dY5ustvH+zJJzxurgugkNo3pCNcWAA4IbKjEBiGi/n/tsx/vsTkhzfEgYfboQ8
         C/ANgxUM7rdLQZoHsmm51kuiHvC0TikKjnfvrQAQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: move fscrypt_d_revalidate() to fname.c
Date:   Mon,  9 Dec 2019 12:43:59 -0800
Message-Id: <20191209204359.228544-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fscrypt_d_revalidate() and fscrypt_d_ops really belong in fname.c, since
they're specific to filenames encryption.  crypto.c is for contents
encryption and general fs/crypto/ initialization and utilities.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c          | 50 -------------------------------------
 fs/crypto/fname.c           | 49 ++++++++++++++++++++++++++++++++++++
 fs/crypto/fscrypt_private.h |  2 +-
 3 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 3719efa546c65..fcc6ca792ba2c 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -25,8 +25,6 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/ratelimit.h>
-#include <linux/dcache.h>
-#include <linux/namei.h>
 #include <crypto/skcipher.h>
 #include "fscrypt_private.h"
 
@@ -286,54 +284,6 @@ int fscrypt_decrypt_block_inplace(const struct inode *inode, struct page *page,
 }
 EXPORT_SYMBOL(fscrypt_decrypt_block_inplace);
 
-/*
- * Validate dentries in encrypted directories to make sure we aren't potentially
- * caching stale dentries after a key has been added.
- */
-static int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
-{
-	struct dentry *dir;
-	int err;
-	int valid;
-
-	/*
-	 * Plaintext names are always valid, since fscrypt doesn't support
-	 * reverting to ciphertext names without evicting the directory's inode
-	 * -- which implies eviction of the dentries in the directory.
-	 */
-	if (!(dentry->d_flags & DCACHE_ENCRYPTED_NAME))
-		return 1;
-
-	/*
-	 * Ciphertext name; valid if the directory's key is still unavailable.
-	 *
-	 * Although fscrypt forbids rename() on ciphertext names, we still must
-	 * use dget_parent() here rather than use ->d_parent directly.  That's
-	 * because a corrupted fs image may contain directory hard links, which
-	 * the VFS handles by moving the directory's dentry tree in the dcache
-	 * each time ->lookup() finds the directory and it already has a dentry
-	 * elsewhere.  Thus ->d_parent can be changing, and we must safely grab
-	 * a reference to some ->d_parent to prevent it from being freed.
-	 */
-
-	if (flags & LOOKUP_RCU)
-		return -ECHILD;
-
-	dir = dget_parent(dentry);
-	err = fscrypt_get_encryption_info(d_inode(dir));
-	valid = !fscrypt_has_encryption_key(d_inode(dir));
-	dput(dir);
-
-	if (err < 0)
-		return err;
-
-	return valid;
-}
-
-const struct dentry_operations fscrypt_d_ops = {
-	.d_revalidate = fscrypt_d_revalidate,
-};
-
 /**
  * fscrypt_initialize() - allocate major buffers for fs encryption.
  * @cop_flags:  fscrypt operations flags
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index c87b71aa23533..3fd27e14ebdd6 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -11,6 +11,7 @@
  * This has not yet undergone a rigorous security audit.
  */
 
+#include <linux/namei.h>
 #include <linux/scatterlist.h>
 #include <crypto/skcipher.h>
 #include "fscrypt_private.h"
@@ -400,3 +401,51 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 	return ret;
 }
 EXPORT_SYMBOL(fscrypt_setup_filename);
+
+/*
+ * Validate dentries in encrypted directories to make sure we aren't potentially
+ * caching stale dentries after a key has been added.
+ */
+static int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	struct dentry *dir;
+	int err;
+	int valid;
+
+	/*
+	 * Plaintext names are always valid, since fscrypt doesn't support
+	 * reverting to ciphertext names without evicting the directory's inode
+	 * -- which implies eviction of the dentries in the directory.
+	 */
+	if (!(dentry->d_flags & DCACHE_ENCRYPTED_NAME))
+		return 1;
+
+	/*
+	 * Ciphertext name; valid if the directory's key is still unavailable.
+	 *
+	 * Although fscrypt forbids rename() on ciphertext names, we still must
+	 * use dget_parent() here rather than use ->d_parent directly.  That's
+	 * because a corrupted fs image may contain directory hard links, which
+	 * the VFS handles by moving the directory's dentry tree in the dcache
+	 * each time ->lookup() finds the directory and it already has a dentry
+	 * elsewhere.  Thus ->d_parent can be changing, and we must safely grab
+	 * a reference to some ->d_parent to prevent it from being freed.
+	 */
+
+	if (flags & LOOKUP_RCU)
+		return -ECHILD;
+
+	dir = dget_parent(dentry);
+	err = fscrypt_get_encryption_info(d_inode(dir));
+	valid = !fscrypt_has_encryption_key(d_inode(dir));
+	dput(dir);
+
+	if (err < 0)
+		return err;
+
+	return valid;
+}
+
+const struct dentry_operations fscrypt_d_ops = {
+	.d_revalidate = fscrypt_d_revalidate,
+};
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 5792ecbd4d24e..37c418d23962b 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -233,7 +233,6 @@ extern int fscrypt_crypt_block(const struct inode *inode,
 			       unsigned int len, unsigned int offs,
 			       gfp_t gfp_flags);
 extern struct page *fscrypt_alloc_bounce_page(gfp_t gfp_flags);
-extern const struct dentry_operations fscrypt_d_ops;
 
 extern void __printf(3, 4) __cold
 fscrypt_msg(const struct inode *inode, const char *level, const char *fmt, ...);
@@ -265,6 +264,7 @@ extern int fname_encrypt(const struct inode *inode, const struct qstr *iname,
 extern bool fscrypt_fname_encrypted_size(const struct inode *inode,
 					 u32 orig_len, u32 max_len,
 					 u32 *encrypted_len_ret);
+extern const struct dentry_operations fscrypt_d_ops;
 
 /* hkdf.c */
 
-- 
2.24.0.393.g34dc348eaf-goog

