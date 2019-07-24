Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39BF73D20
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jul 2019 22:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404356AbfGXTy3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Jul 2019 15:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404349AbfGXTy3 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Jul 2019 15:54:29 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DFA0214AF
        for <linux-fscrypt@vger.kernel.org>; Wed, 24 Jul 2019 19:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998068;
        bh=9GlLzK5h7SHOxqNjyThth87N9txHqhVxOKdcHbWJDpU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XFPJ80EPAzr0aPYDWrDAVV29dQbY8i0LNkl0537ZOkKlAsVQmkT6oTXMO75y1Bdah
         8jEsewZN5EbCnEyBitrq8FsmowBe7ISPK4HVXKVsigYa5Y8eAFE+zW1kZx6PSkMF/1
         NamsMXxI6A5SawthgUggvOSvNjJPds3lyc7LojAM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 1/4] fscrypt: make fscrypt_msg() take inode instead of super_block
Date:   Wed, 24 Jul 2019 12:54:19 -0700
Message-Id: <20190724195422.42495-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
In-Reply-To: <20190724195422.42495-1-ebiggers@kernel.org>
References: <20190724195422.42495-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Most of the warning and error messages in fs/crypto/ are for situations
related to a specific inode, not merely to a super_block.  So to make
things easier, make fscrypt_msg() take an inode rather than a
super_block, and make it print the inode number.

Note: This is the same approach I'm taking for fsverity_msg().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c          | 13 ++++++-------
 fs/crypto/fname.c           |  8 ++------
 fs/crypto/fscrypt_private.h | 10 +++++-----
 fs/crypto/hooks.c           |  6 +++---
 fs/crypto/keyinfo.c         | 26 ++++++++++++--------------
 5 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index d52c788b723d01..3e4624cfe4b54d 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -188,10 +188,8 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 		res = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
 	skcipher_request_free(req);
 	if (res) {
-		fscrypt_err(inode->i_sb,
-			    "%scryption failed for inode %lu, block %llu: %d",
-			    (rw == FS_DECRYPT ? "de" : "en"),
-			    inode->i_ino, lblk_num, res);
+		fscrypt_err(inode, "%scryption failed for block %llu: %d",
+			    (rw == FS_DECRYPT ? "De" : "En"), lblk_num, res);
 		return res;
 	}
 	return 0;
@@ -453,7 +451,7 @@ int fscrypt_initialize(unsigned int cop_flags)
 	return res;
 }
 
-void fscrypt_msg(struct super_block *sb, const char *level,
+void fscrypt_msg(const struct inode *inode, const char *level,
 		 const char *fmt, ...)
 {
 	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,
@@ -467,8 +465,9 @@ void fscrypt_msg(struct super_block *sb, const char *level,
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	if (sb)
-		printk("%sfscrypt (%s): %pV\n", level, sb->s_id, &vaf);
+	if (inode)
+		printk("%sfscrypt (%s, inode %lu): %pV\n",
+		       level, inode->i_sb->s_id, inode->i_ino, &vaf);
 	else
 		printk("%sfscrypt: %pV\n", level, &vaf);
 	va_end(args);
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 6f9daba991684e..5cab3bb2d1fc00 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -71,9 +71,7 @@ int fname_encrypt(struct inode *inode, const struct qstr *iname,
 	res = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
 	skcipher_request_free(req);
 	if (res < 0) {
-		fscrypt_err(inode->i_sb,
-			    "Filename encryption failed for inode %lu: %d",
-			    inode->i_ino, res);
+		fscrypt_err(inode, "Filename encryption failed: %d", res);
 		return res;
 	}
 
@@ -117,9 +115,7 @@ static int fname_decrypt(struct inode *inode,
 	res = crypto_wait_req(crypto_skcipher_decrypt(req), &wait);
 	skcipher_request_free(req);
 	if (res < 0) {
-		fscrypt_err(inode->i_sb,
-			    "Filename decryption failed for inode %lu: %d",
-			    inode->i_ino, res);
+		fscrypt_err(inode, "Filename decryption failed: %d", res);
 		return res;
 	}
 
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 224178294371a4..4d715708c6e1f7 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -125,12 +125,12 @@ extern struct page *fscrypt_alloc_bounce_page(gfp_t gfp_flags);
 extern const struct dentry_operations fscrypt_d_ops;
 
 extern void __printf(3, 4) __cold
-fscrypt_msg(struct super_block *sb, const char *level, const char *fmt, ...);
+fscrypt_msg(const struct inode *inode, const char *level, const char *fmt, ...);
 
-#define fscrypt_warn(sb, fmt, ...)		\
-	fscrypt_msg(sb, KERN_WARNING, fmt, ##__VA_ARGS__)
-#define fscrypt_err(sb, fmt, ...)		\
-	fscrypt_msg(sb, KERN_ERR, fmt, ##__VA_ARGS__)
+#define fscrypt_warn(inode, fmt, ...)		\
+	fscrypt_msg((inode), KERN_WARNING, fmt, ##__VA_ARGS__)
+#define fscrypt_err(inode, fmt, ...)		\
+	fscrypt_msg((inode), KERN_ERR, fmt, ##__VA_ARGS__)
 
 #define FSCRYPT_MAX_IV_SIZE	32
 
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index c1d6715d88e93c..bb3b7fcfdd48a3 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -39,9 +39,9 @@ int fscrypt_file_open(struct inode *inode, struct file *filp)
 	dir = dget_parent(file_dentry(filp));
 	if (IS_ENCRYPTED(d_inode(dir)) &&
 	    !fscrypt_has_permitted_context(d_inode(dir), inode)) {
-		fscrypt_warn(inode->i_sb,
-			     "inconsistent encryption contexts: %lu/%lu",
-			     d_inode(dir)->i_ino, inode->i_ino);
+		fscrypt_warn(inode,
+			     "Inconsistent encryption context (parent directory: %lu)",
+			     d_inode(dir)->i_ino);
 		err = -EPERM;
 	}
 	dput(dir);
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 9bcadc09e2aded..d0eb901a6d1a9f 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -166,10 +166,9 @@ static struct fscrypt_mode *
 select_encryption_mode(const struct fscrypt_info *ci, const struct inode *inode)
 {
 	if (!fscrypt_valid_enc_modes(ci->ci_data_mode, ci->ci_filename_mode)) {
-		fscrypt_warn(inode->i_sb,
-			     "inode %lu uses unsupported encryption modes (contents mode %d, filenames mode %d)",
-			     inode->i_ino, ci->ci_data_mode,
-			     ci->ci_filename_mode);
+		fscrypt_warn(inode,
+			     "Unsupported encryption modes (contents mode %d, filenames mode %d)",
+			     ci->ci_data_mode, ci->ci_filename_mode);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -206,14 +205,14 @@ static int find_and_derive_key(const struct inode *inode,
 
 	if (ctx->flags & FS_POLICY_FLAG_DIRECT_KEY) {
 		if (mode->ivsize < offsetofend(union fscrypt_iv, nonce)) {
-			fscrypt_warn(inode->i_sb,
-				     "direct key mode not allowed with %s",
+			fscrypt_warn(inode,
+				     "Direct key mode not allowed with %s",
 				     mode->friendly_name);
 			err = -EINVAL;
 		} else if (ctx->contents_encryption_mode !=
 			   ctx->filenames_encryption_mode) {
-			fscrypt_warn(inode->i_sb,
-				     "direct key mode not allowed with different contents and filenames modes");
+			fscrypt_warn(inode,
+				     "Direct key mode not allowed with different contents and filenames modes");
 			err = -EINVAL;
 		} else {
 			memcpy(derived_key, payload->raw, mode->keysize);
@@ -238,9 +237,8 @@ allocate_skcipher_for_mode(struct fscrypt_mode *mode, const u8 *raw_key,
 
 	tfm = crypto_alloc_skcipher(mode->cipher_str, 0, 0);
 	if (IS_ERR(tfm)) {
-		fscrypt_warn(inode->i_sb,
-			     "error allocating '%s' transform for inode %lu: %ld",
-			     mode->cipher_str, inode->i_ino, PTR_ERR(tfm));
+		fscrypt_warn(inode, "Error allocating '%s' transform: %ld",
+			     mode->cipher_str, PTR_ERR(tfm));
 		return tfm;
 	}
 	if (unlikely(!mode->logged_impl_name)) {
@@ -471,9 +469,9 @@ static int setup_crypto_transform(struct fscrypt_info *ci,
 
 		err = init_essiv_generator(ci, raw_key, mode->keysize);
 		if (err) {
-			fscrypt_warn(inode->i_sb,
-				     "error initializing ESSIV generator for inode %lu: %d",
-				     inode->i_ino, err);
+			fscrypt_warn(inode,
+				     "Error initializing ESSIV generator: %d",
+				     err);
 			return err;
 		}
 	}
-- 
2.22.0.657.g960e92d24f-goog

