Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBD623D4E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 May 2019 18:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389658AbfETQaY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 May 2019 12:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389579AbfETQaW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 May 2019 12:30:22 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 249E721726;
        Mon, 20 May 2019 16:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558369822;
        bh=R+LKrmanbtXNSZ9aCaevL40joIkJjiQUGQoY5lghui0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUYjoQZ6VxD6QzIvpWgy0FCq3Ij2nX5S7S15m3oehysH76SCTGMtidJ4r6WRf95zK
         ZlOR/OCn3fkjrnuq6bVGbQNjoHZZYn8diig0hr31takBi5qxGbGdJTJQfWsOPyN0Lp
         NmmBn3GUmrPIvffTfoPuFStwqAR8dIeL4/gu8pxM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org,
        Chandan Rajendra <chandan@linux.ibm.com>
Subject: [PATCH v2 04/14] fscrypt: clean up some BUG_ON()s in block encryption/decryption
Date:   Mon, 20 May 2019 09:29:42 -0700
Message-Id: <20190520162952.156212-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190520162952.156212-1-ebiggers@kernel.org>
References: <20190520162952.156212-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Replace some BUG_ON()s with WARN_ON_ONCE() and returning an error code,
and move the check for len divisible by FS_CRYPTO_BLOCK_SIZE into
fscrypt_crypt_block() so that it's done for both encryption and
decryption, not just encryption.

Reviewed-by: Chandan Rajendra <chandan@linux.ibm.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index e6802d7aca3c7..9cda0147fca95 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -161,7 +161,10 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 	struct crypto_skcipher *tfm = ci->ci_ctfm;
 	int res = 0;
 
-	BUG_ON(len == 0);
+	if (WARN_ON_ONCE(len <= 0))
+		return -EINVAL;
+	if (WARN_ON_ONCE(len % FS_CRYPTO_BLOCK_SIZE != 0))
+		return -EINVAL;
 
 	fscrypt_generate_iv(&iv, lblk_num, ci);
 
@@ -224,8 +227,6 @@ struct page *fscrypt_encrypt_page(const struct inode *inode,
 	struct page *ciphertext_page = page;
 	int err;
 
-	BUG_ON(len % FS_CRYPTO_BLOCK_SIZE != 0);
-
 	if (inode->i_sb->s_cop->flags & FS_CFLG_OWN_PAGES) {
 		/* with inplace-encryption we just encrypt the page */
 		err = fscrypt_crypt_block(inode, FS_ENCRYPT, lblk_num, page,
@@ -237,7 +238,8 @@ struct page *fscrypt_encrypt_page(const struct inode *inode,
 		return ciphertext_page;
 	}
 
-	BUG_ON(!PageLocked(page));
+	if (WARN_ON_ONCE(!PageLocked(page)))
+		return ERR_PTR(-EINVAL);
 
 	/* The encryption operation will require a bounce page. */
 	ciphertext_page = fscrypt_alloc_bounce_page(gfp_flags);
@@ -274,8 +276,9 @@ EXPORT_SYMBOL(fscrypt_encrypt_page);
 int fscrypt_decrypt_page(const struct inode *inode, struct page *page,
 			unsigned int len, unsigned int offs, u64 lblk_num)
 {
-	if (!(inode->i_sb->s_cop->flags & FS_CFLG_OWN_PAGES))
-		BUG_ON(!PageLocked(page));
+	if (WARN_ON_ONCE(!PageLocked(page) &&
+			 !(inode->i_sb->s_cop->flags & FS_CFLG_OWN_PAGES)))
+		return -EINVAL;
 
 	return fscrypt_crypt_block(inode, FS_DECRYPT, lblk_num, page, page,
 				   len, offs, GFP_NOFS);
-- 
2.21.0.1020.gf2820cf01a-goog

