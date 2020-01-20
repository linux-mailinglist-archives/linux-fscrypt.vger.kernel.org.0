Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE76142421
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Jan 2020 08:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgATHSW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Jan 2020 02:18:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgATHSW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Jan 2020 02:18:22 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7FF42073A
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Jan 2020 07:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579504701;
        bh=l7+rqIVeTZuGzvlkySnrYZK/RMCYXk2WKjFd1T+SJrQ=;
        h=From:To:Subject:Date:From;
        b=Z3RdVYaYzrCzBTObx6CVV7EowSs1kLXFY/4p1ijswkXyy56DM9wb1SuXT75pQnIDL
         4zS99Se2mt7nU43pf5c3PzwRcQ/y1QY1KdHSkqTUrCA6cXc2LsOzvsYgqEwrd/hPKR
         /jiwaSPh5afM/aj5IDyxQsOoh0ydkn90ae6UwFfQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: add "fscrypt_" prefix to fname_encrypt()
Date:   Sun, 19 Jan 2020 23:17:36 -0800
Message-Id: <20200120071736.45915-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fname_encrypt() is a global function, due to being used in both fname.c
and hooks.c.  So it should be prefixed with "fscrypt_", like all the
other global functions in fs/crypto/.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c           | 10 +++++-----
 fs/crypto/fscrypt_private.h |  5 +++--
 fs/crypto/hooks.c           |  3 ++-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 938220292e8de..4c212442a8f7f 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -104,15 +104,15 @@ static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
 }
 
 /**
- * fname_encrypt() - encrypt a filename
+ * fscrypt_fname_encrypt() - encrypt a filename
  *
  * The output buffer must be at least as large as the input buffer.
  * Any extra space is filled with NUL padding before encryption.
  *
  * Return: 0 on success, -errno on failure
  */
-int fname_encrypt(const struct inode *inode, const struct qstr *iname,
-		  u8 *out, unsigned int olen)
+int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
+			  u8 *out, unsigned int olen)
 {
 	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
@@ -431,8 +431,8 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 		if (!fname->crypto_buf.name)
 			return -ENOMEM;
 
-		ret = fname_encrypt(dir, iname, fname->crypto_buf.name,
-				    fname->crypto_buf.len);
+		ret = fscrypt_fname_encrypt(dir, iname, fname->crypto_buf.name,
+					    fname->crypto_buf.len);
 		if (ret)
 			goto errout;
 		fname->disk_name.name = fname->crypto_buf.name;
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 5546e28ec5690..038ba59f8b207 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -244,8 +244,9 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 			 const struct fscrypt_info *ci);
 
 /* fname.c */
-extern int fname_encrypt(const struct inode *inode, const struct qstr *iname,
-			 u8 *out, unsigned int olen);
+extern int fscrypt_fname_encrypt(const struct inode *inode,
+				 const struct qstr *iname,
+				 u8 *out, unsigned int olen);
 extern bool fscrypt_fname_encrypted_size(const struct inode *inode,
 					 u32 orig_len, u32 max_len,
 					 u32 *encrypted_len_ret);
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index bbb31dca0311e..8139e4a19e695 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -232,7 +232,8 @@ int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
 	ciphertext_len = disk_link->len - sizeof(*sd);
 	sd->len = cpu_to_le16(ciphertext_len);
 
-	err = fname_encrypt(inode, &iname, sd->encrypted_path, ciphertext_len);
+	err = fscrypt_fname_encrypt(inode, &iname, sd->encrypted_path,
+				    ciphertext_len);
 	if (err)
 		goto err_free_sd;
 
-- 
2.25.0

