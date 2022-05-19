Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED1F52D3EC
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 15:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbiESN1k (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 May 2022 09:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbiESN1j (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 May 2022 09:27:39 -0400
X-Greylist: delayed 363 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 06:27:37 PDT
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04329B040B
        for <linux-fscrypt@vger.kernel.org>; Thu, 19 May 2022 06:27:36 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 87CBBEDA;
        Thu, 19 May 2022 09:21:31 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 805F610171A; Thu, 19 May 2022 09:21:31 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH] fscrypt: allow alternative bounce buffers
Date:   Thu, 19 May 2022 09:21:25 -0400
Message-Id: <1652966485-7418-1-git-send-email-jsimmons@infradead.org>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Currently fscrypt offers two options. One option is to use the
internal bounce buffer allocated or perform inline encrpytion.
Add the option to use an external bounce buffer. This change can
be used useful for example for a network file systems which can
pass in a page from the page cache and place the encrypted data
into a page for a network packet to be sent. Another potential
use is the use of GPU pages with RDMA being the final destination
for the encrypted data. Lastly in performance measurements the
allocation of the bounce page incures a heavy cost. Using a page
from a predefined memory pool can lower the case. We can replace
the one off case of inplace encryption with the new general
functions.

Signed-Off-By: James Simmons <jsimmons@infradead.org>
---
 fs/crypto/crypto.c      | 34 +++++++++++++++++++---------------
 fs/ubifs/crypto.c       | 16 +++++++++-------
 include/linux/fscrypt.h | 31 ++++++++++++++++---------------
 3 files changed, 44 insertions(+), 37 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index e78be66bbf01..f241c697b1f9 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -210,9 +210,10 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
 EXPORT_SYMBOL(fscrypt_encrypt_pagecache_blocks);
 
 /**
- * fscrypt_encrypt_block_inplace() - Encrypt a filesystem block in-place
+ * fscrypt_encrypt_page() - Cache an encrypt filesystem block in a page
  * @inode:     The inode to which this block belongs
- * @page:      The page containing the block to encrypt
+ * @src:       The page containing the block to encrypt
+ * @dst:       The page which will contain the encrypted data
  * @len:       Size of block to encrypt.  This must be a multiple of
  *		FSCRYPT_CONTENTS_ALIGNMENT.
  * @offs:      Byte offset within @page at which the block to encrypt begins
@@ -223,17 +224,18 @@ EXPORT_SYMBOL(fscrypt_encrypt_pagecache_blocks);
  * Encrypt a possibly-compressed filesystem block that is located in an
  * arbitrary page, not necessarily in the original pagecache page.  The @inode
  * and @lblk_num must be specified, as they can't be determined from @page.
+ * The decrypted data will be stored in @dst.
  *
  * Return: 0 on success; -errno on failure
  */
-int fscrypt_encrypt_block_inplace(const struct inode *inode, struct page *page,
-				  unsigned int len, unsigned int offs,
-				  u64 lblk_num, gfp_t gfp_flags)
+int fscrypt_encrypt_page(const struct inode *inode, struct page *src,
+			 struct page *dst, unsigned int len, unsigned int offs,
+			 u64 lblk_num, gfp_t gfp_flags)
 {
-	return fscrypt_crypt_block(inode, FS_ENCRYPT, lblk_num, page, page,
+	return fscrypt_crypt_block(inode, FS_ENCRYPT, lblk_num, src, dst,
 				   len, offs, gfp_flags);
 }
-EXPORT_SYMBOL(fscrypt_encrypt_block_inplace);
+EXPORT_SYMBOL(fscrypt_encrypt_page);
 
 /**
  * fscrypt_decrypt_pagecache_blocks() - Decrypt filesystem blocks in a
@@ -280,9 +282,10 @@ int fscrypt_decrypt_pagecache_blocks(struct page *page, unsigned int len,
 EXPORT_SYMBOL(fscrypt_decrypt_pagecache_blocks);
 
 /**
- * fscrypt_decrypt_block_inplace() - Decrypt a filesystem block in-place
+ * fscrypt_decrypt_page() - Cache a decrypt a filesystem block in a page
  * @inode:     The inode to which this block belongs
- * @page:      The page containing the block to decrypt
+ * @src:       The page containing the block to decrypt
+ * @dst:       The page which will contain the plain data
  * @len:       Size of block to decrypt.  This must be a multiple of
  *		FSCRYPT_CONTENTS_ALIGNMENT.
  * @offs:      Byte offset within @page at which the block to decrypt begins
@@ -292,17 +295,18 @@ EXPORT_SYMBOL(fscrypt_decrypt_pagecache_blocks);
  * Decrypt a possibly-compressed filesystem block that is located in an
  * arbitrary page, not necessarily in the original pagecache page.  The @inode
  * and @lblk_num must be specified, as they can't be determined from @page.
+ * The encrypted data will be stored in @dst.
  *
  * Return: 0 on success; -errno on failure
  */
-int fscrypt_decrypt_block_inplace(const struct inode *inode, struct page *page,
-				  unsigned int len, unsigned int offs,
-				  u64 lblk_num)
+int fscrypt_decrypt_page(const struct inode *inode, struct page *src,
+			 struct page *dst, unsigned int len, unsigned int offs,
+			 u64 lblk_num, gfp_t gfp_flags)
 {
-	return fscrypt_crypt_block(inode, FS_DECRYPT, lblk_num, page, page,
-				   len, offs, GFP_NOFS);
+	return fscrypt_crypt_block(inode, FS_DECRYPT, lblk_num, src, dst,
+				   len, offs, gfp_flags);
 }
-EXPORT_SYMBOL(fscrypt_decrypt_block_inplace);
+EXPORT_SYMBOL(fscrypt_decrypt_page);
 
 /**
  * fscrypt_initialize() - allocate major buffers for fs encryption.
diff --git a/fs/ubifs/crypto.c b/fs/ubifs/crypto.c
index c57b46a352d8..c4cb1a8207e0 100644
--- a/fs/ubifs/crypto.c
+++ b/fs/ubifs/crypto.c
@@ -39,10 +39,11 @@ int ubifs_encrypt(const struct inode *inode, struct ubifs_data_node *dn,
 	if (pad_len != in_len)
 		memset(p + in_len, 0, pad_len - in_len);
 
-	err = fscrypt_encrypt_block_inplace(inode, virt_to_page(p), pad_len,
-					    offset_in_page(p), block, GFP_NOFS);
+	/* Encrypt inplace */
+	err = fscrypt_encrypt_page(inode, virt_to_page(p), virt_to_page(p),
+				   pad_len, offset_in_page(p), block, GFP_NOFS);
 	if (err) {
-		ubifs_err(c, "fscrypt_encrypt_block_inplace() failed: %d", err);
+		ubifs_err(c, "fscrypt_encrypt_page() failed: %d", err);
 		return err;
 	}
 	*out_len = pad_len;
@@ -64,11 +65,12 @@ int ubifs_decrypt(const struct inode *inode, struct ubifs_data_node *dn,
 	}
 
 	ubifs_assert(c, dlen <= UBIFS_BLOCK_SIZE);
-	err = fscrypt_decrypt_block_inplace(inode, virt_to_page(&dn->data),
-					    dlen, offset_in_page(&dn->data),
-					    block);
+	/* Decrypt inplace */
+	err = fscrypt_decrypt_page(inode, virt_to_page(&dn->data),
+				   virt_to_page(&dn->data), dlen,
+				   offset_in_page(&dn->data), block, GFP_NOFS);
 	if (err) {
-		ubifs_err(c, "fscrypt_decrypt_block_inplace() failed: %d", err);
+		ubifs_err(c, "fscrypt_decrypt_page() failed: %d", err);
 		return err;
 	}
 	*out_len = clen;
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index e60d57c99cb6..87efd61a764a 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -256,15 +256,16 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
 					      unsigned int len,
 					      unsigned int offs,
 					      gfp_t gfp_flags);
-int fscrypt_encrypt_block_inplace(const struct inode *inode, struct page *page,
-				  unsigned int len, unsigned int offs,
-				  u64 lblk_num, gfp_t gfp_flags);
+int fscrypt_encrypt_page(const struct inode *inode, struct page *src,
+			 struct page *dst, unsigned int len,
+			 unsigned int offs, u64 lblk_num, gfp_t gfp_flags);
 
 int fscrypt_decrypt_pagecache_blocks(struct page *page, unsigned int len,
 				     unsigned int offs);
-int fscrypt_decrypt_block_inplace(const struct inode *inode, struct page *page,
-				  unsigned int len, unsigned int offs,
-				  u64 lblk_num);
+
+int fscrypt_decrypt_page(const struct inode *inode, struct page *src,
+			 struct page *dst, unsigned int len,
+			 unsigned int offs, u64 lblk_num, gfp_t gfp_flags);
 
 static inline bool fscrypt_is_bounce_page(struct page *page)
 {
@@ -413,11 +414,11 @@ static inline struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
-static inline int fscrypt_encrypt_block_inplace(const struct inode *inode,
-						struct page *page,
-						unsigned int len,
-						unsigned int offs, u64 lblk_num,
-						gfp_t gfp_flags)
+static inline int fscrypt_encrypt_page(const struct inode *inode,
+				       struct page *src, struct page *dst,
+				       unsigned int len,
+				       unsigned int offs, u64 lblk_num,
+				       gfp_t gfp_flags)
 {
 	return -EOPNOTSUPP;
 }
@@ -429,10 +430,10 @@ static inline int fscrypt_decrypt_pagecache_blocks(struct page *page,
 	return -EOPNOTSUPP;
 }
 
-static inline int fscrypt_decrypt_block_inplace(const struct inode *inode,
-						struct page *page,
-						unsigned int len,
-						unsigned int offs, u64 lblk_num)
+static inline int fscrypt_decrypt_page(const struct inode *inode,
+				       struct page *src, struct page *dst,
+				       unsigned int len,
+				       unsigned int offs, u64 lblk_num)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.34.1

