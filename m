Return-Path: <linux-fscrypt+bounces-699-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 043BDAFF968
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 08:14:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 213B47BFEA3
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 06:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F08B28FA87;
	Thu, 10 Jul 2025 06:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DLQ2tnzf"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DBF28F527;
	Thu, 10 Jul 2025 06:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127806; cv=none; b=lA8wsjIsDXWbA9OFl5nhsEsgJIHORj65063vw4xP7s23wcd5OOY6tBR782TDT5C2cYg6EODEEMbmJMNTqifPNxcUPcIkf35q+ubSde1fSQ+wPooFtqpC0/aIWuJQ4b0pLvYDvhVlFKfjSGifv3zof+W4mCzPxSb+xuldbCkOKvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127806; c=relaxed/simple;
	bh=rxPyY/T+UiU1XFDx1UIdsdBoQBGeiEvi+e66q05QgMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AW5xanP+4Rr8v7HrpXPMWeJ/Xu79WeSzhVY6Ufu6KldgLRqx9mYjp1teTsJzDOetEMYqTsXrsCFSz1uvgTEfz5UK+GpqsSFd3wnr1nCF0zC4Fp42F4CT2/7/vCwYN5IRsPQAkmqtiPR8BN/tt8paXfZeaNjQ5atc1GBLI9lbfgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DLQ2tnzf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB96C4CEFE;
	Thu, 10 Jul 2025 06:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752127805;
	bh=rxPyY/T+UiU1XFDx1UIdsdBoQBGeiEvi+e66q05QgMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLQ2tnzf0j5AB+ktyie53hSM7Vn0K0RU3O8yVIY1lRhX2YUV36H0Am6AR+O+g9cTk
	 vzIHITOndLhr0vcWN2Rbl+CC6Sgnk045fNoHw6uW7h0aRGo3/wvX8E8fNks2PRPAWs
	 XGIsWz6XqvESW//al3nR5uasGT9S5LSbuMhDUZofIHcAZmXeJWf5TzEmUGQ0t2cf54
	 5X8iHIAQfxO+EoBZKnJmVtUZXIa33MYsrZc5h+Ij8Ib5PGbh5bauPpqTBvAr47tl2l
	 nYkUQrvPcAkhi8JvrudnADYUvdT+xp9pMR1eBrsdaBszqY/oXF+NNPKRf7BWWHx6Xj
	 +vBsy/dj6RxFQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Yuwen Chen <ywen.chen@foxmail.com>,
	linux-mtd@lists.infradead.org,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 5/6] fscrypt: Remove gfp_t argument from fscrypt_encrypt_block_inplace()
Date: Wed,  9 Jul 2025 23:07:52 -0700
Message-ID: <20250710060754.637098-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250710060754.637098-1-ebiggers@kernel.org>
References: <20250710060754.637098-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This argument is no longer used, so remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/ceph/crypto.c        | 3 +--
 fs/crypto/crypto.c      | 3 +--
 fs/ubifs/crypto.c       | 2 +-
 include/linux/fscrypt.h | 5 ++---
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 3b3c4d8d401ec..6d04d528ed038 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -521,12 +521,11 @@ int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
 {
 	struct ceph_client *cl = ceph_inode_to_client(inode);
 
 	doutc(cl, "%p %llx.%llx len %u offs %u blk %llu\n", inode,
 	      ceph_vinop(inode), len, offs, lblk_num);
-	return fscrypt_encrypt_block_inplace(inode, page, len, offs, lblk_num,
-					     gfp_flags);
+	return fscrypt_encrypt_block_inplace(inode, page, len, offs, lblk_num);
 }
 
 /**
  * ceph_fscrypt_decrypt_pages - decrypt an array of pages
  * @inode: pointer to inode associated with these pages
diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index bab0aacd4da36..b6ccab524fdef 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -215,11 +215,10 @@ EXPORT_SYMBOL(fscrypt_encrypt_pagecache_blocks);
  * @len:       Size of block to encrypt.  This must be a multiple of
  *		FSCRYPT_CONTENTS_ALIGNMENT.
  * @offs:      Byte offset within @page at which the block to encrypt begins
  * @lblk_num:  Filesystem logical block number of the block, i.e. the 0-based
  *		number of the block within the file
- * @gfp_flags: Memory allocation flags
  *
  * Encrypt a possibly-compressed filesystem block that is located in an
  * arbitrary page, not necessarily in the original pagecache page.  The @inode
  * and @lblk_num must be specified, as they can't be determined from @page.
  *
@@ -227,11 +226,11 @@ EXPORT_SYMBOL(fscrypt_encrypt_pagecache_blocks);
  *
  * Return: 0 on success; -errno on failure
  */
 int fscrypt_encrypt_block_inplace(const struct inode *inode, struct page *page,
 				  unsigned int len, unsigned int offs,
-				  u64 lblk_num, gfp_t gfp_flags)
+				  u64 lblk_num)
 {
 	if (WARN_ON_ONCE(inode->i_sb->s_cop->supports_subblock_data_units))
 		return -EOPNOTSUPP;
 	return fscrypt_crypt_data_unit(inode->i_crypt_info, FS_ENCRYPT,
 				       lblk_num, page, page, len, offs);
diff --git a/fs/ubifs/crypto.c b/fs/ubifs/crypto.c
index 921f9033d0d2d..fb5ac358077b1 100644
--- a/fs/ubifs/crypto.c
+++ b/fs/ubifs/crypto.c
@@ -49,11 +49,11 @@ int ubifs_encrypt(const struct inode *inode, struct ubifs_data_node *dn,
 	/* pad to full block cipher length */
 	if (pad_len != in_len)
 		memset(p + in_len, 0, pad_len - in_len);
 
 	err = fscrypt_encrypt_block_inplace(inode, virt_to_page(p), pad_len,
-					    offset_in_page(p), block, GFP_NOFS);
+					    offset_in_page(p), block);
 	if (err) {
 		ubifs_err(c, "fscrypt_encrypt_block_inplace() failed: %d", err);
 		return err;
 	}
 	*out_len = pad_len;
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 56fad33043d53..8d0e3ad89b940 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -312,11 +312,11 @@ void fscrypt_enqueue_decrypt_work(struct work_struct *);
 
 struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 		size_t len, size_t offs, gfp_t gfp_flags);
 int fscrypt_encrypt_block_inplace(const struct inode *inode, struct page *page,
 				  unsigned int len, unsigned int offs,
-				  u64 lblk_num, gfp_t gfp_flags);
+				  u64 lblk_num);
 
 int fscrypt_decrypt_pagecache_blocks(struct folio *folio, size_t len,
 				     size_t offs);
 int fscrypt_decrypt_block_inplace(const struct inode *inode, struct page *page,
 				  unsigned int len, unsigned int offs,
@@ -485,12 +485,11 @@ static inline struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 }
 
 static inline int fscrypt_encrypt_block_inplace(const struct inode *inode,
 						struct page *page,
 						unsigned int len,
-						unsigned int offs, u64 lblk_num,
-						gfp_t gfp_flags)
+						unsigned int offs, u64 lblk_num)
 {
 	return -EOPNOTSUPP;
 }
 
 static inline int fscrypt_decrypt_pagecache_blocks(struct folio *folio,
-- 
2.50.1


