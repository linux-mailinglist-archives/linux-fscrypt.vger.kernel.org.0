Return-Path: <linux-fscrypt+bounces-698-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61AB3AFF964
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 08:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10BDC3B7D62
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 06:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306F628F942;
	Thu, 10 Jul 2025 06:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TNn2rCNH"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC0328EA5A;
	Thu, 10 Jul 2025 06:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127806; cv=none; b=AFcWYeuZjrbmBNjDzvWLN4pTQRZ5HkTOuRv0CAsGyrvfM6vJ1A8wn4yJFUd6+xHY8JinagY1f2cHRb15ttN3yCAKOQTBYUXABAIfGC8GcjM9yGq8fmn1PJ5TEGMdkzPp7Llyv+yX8MH3XCtvI+XCM5PDWrLUUrXcOpcZeqxXnPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127806; c=relaxed/simple;
	bh=qDZA3q6MtJW6bQsPm9daCNoU1IFqN8412dZMoCnn0Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKOsmfV/1RBtFqapdck7GGjgFvmRkQjgj6lEyJKjd8lPKRc17vmj0kH3OjZqz9UuNxGgrPSICEIEumLOPt4QsNa/ChS0klPz7hfM221huALaLZ2JjUzZdDGtEdPBB8Lsdr0NfrkWZn3IyD9Fl9/t4SPNMRL1P8A3kGW6zmKJ+ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TNn2rCNH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EA1C4CEF7;
	Thu, 10 Jul 2025 06:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752127805;
	bh=qDZA3q6MtJW6bQsPm9daCNoU1IFqN8412dZMoCnn0Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNn2rCNHY0NRRm1MIqGuPjwXrcH5FXxY27IDshq9VsRnJdBWbB/ZAj8iZwoOsexLh
	 VbKneDzh4Ggfq30V0oCFgLPSUY7YiBkKNxBy7z8LC463pGS5vMXvfgopgj/DqkGmbc
	 xQSTO9QIi1cevXJVksNpcRmPMOFaj0mvNSIMO60rjeEfKN7HlA8kTS0voOSsRhHWGJ
	 6VIyQD7waoS5wiRl9frOl4GczOLR+mCezepQvGDFQAOs5EMej4c9jp6SBpQEvQCBAx
	 2aKzO+7+Qo5OgQrkjgGSSMP/Y46E1B35NCkAu+WSlzH4FANfyPLkB2x2QijZcIF5BK
	 +prBB4Nl0q/Ng==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Yuwen Chen <ywen.chen@foxmail.com>,
	linux-mtd@lists.infradead.org,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 4/6] fscrypt: Remove gfp_t argument from fscrypt_crypt_data_unit()
Date: Wed,  9 Jul 2025 23:07:51 -0700
Message-ID: <20250710060754.637098-5-ebiggers@kernel.org>
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
 fs/crypto/bio.c             |  3 +--
 fs/crypto/crypto.c          | 14 +++++---------
 fs/crypto/fscrypt_private.h |  3 +--
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 13ad2dd771b64..486fcb2ecf13e 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -165,12 +165,11 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
 		i = 0;
 		offset = 0;
 		do {
 			err = fscrypt_crypt_data_unit(ci, FS_ENCRYPT, du_index,
 						      ZERO_PAGE(0), pages[i],
-						      du_size, offset,
-						      GFP_NOFS);
+						      du_size, offset);
 			if (err)
 				goto out;
 			du_index++;
 			sector += 1U << (du_bits - SECTOR_SHIFT);
 			du_remaining--;
diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 646b1831e6831..bab0aacd4da36 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -108,12 +108,11 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 index,
 
 /* Encrypt or decrypt a single "data unit" of file contents. */
 int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
 			    fscrypt_direction_t rw, u64 index,
 			    struct page *src_page, struct page *dest_page,
-			    unsigned int len, unsigned int offs,
-			    gfp_t gfp_flags)
+			    unsigned int len, unsigned int offs)
 {
 	struct crypto_sync_skcipher *tfm = ci->ci_enc_key.tfm;
 	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
 	union fscrypt_iv iv;
 	struct scatterlist dst, src;
@@ -195,11 +194,11 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 		return ERR_PTR(-ENOMEM);
 
 	for (i = offs; i < offs + len; i += du_size, index++) {
 		err = fscrypt_crypt_data_unit(ci, FS_ENCRYPT, index,
 					      &folio->page, ciphertext_page,
-					      du_size, i, gfp_flags);
+					      du_size, i);
 		if (err) {
 			fscrypt_free_bounce_page(ciphertext_page);
 			return ERR_PTR(err);
 		}
 	}
@@ -233,12 +232,11 @@ int fscrypt_encrypt_block_inplace(const struct inode *inode, struct page *page,
 				  u64 lblk_num, gfp_t gfp_flags)
 {
 	if (WARN_ON_ONCE(inode->i_sb->s_cop->supports_subblock_data_units))
 		return -EOPNOTSUPP;
 	return fscrypt_crypt_data_unit(inode->i_crypt_info, FS_ENCRYPT,
-				       lblk_num, page, page, len, offs,
-				       gfp_flags);
+				       lblk_num, page, page, len, offs);
 }
 EXPORT_SYMBOL(fscrypt_encrypt_block_inplace);
 
 /**
  * fscrypt_decrypt_pagecache_blocks() - Decrypt data from a pagecache folio
@@ -274,12 +272,11 @@ int fscrypt_decrypt_pagecache_blocks(struct folio *folio, size_t len,
 
 	for (i = offs; i < offs + len; i += du_size, index++) {
 		struct page *page = folio_page(folio, i >> PAGE_SHIFT);
 
 		err = fscrypt_crypt_data_unit(ci, FS_DECRYPT, index, page,
-					      page, du_size, i & ~PAGE_MASK,
-					      GFP_NOFS);
+					      page, du_size, i & ~PAGE_MASK);
 		if (err)
 			return err;
 	}
 	return 0;
 }
@@ -308,12 +305,11 @@ int fscrypt_decrypt_block_inplace(const struct inode *inode, struct page *page,
 				  u64 lblk_num)
 {
 	if (WARN_ON_ONCE(inode->i_sb->s_cop->supports_subblock_data_units))
 		return -EOPNOTSUPP;
 	return fscrypt_crypt_data_unit(inode->i_crypt_info, FS_DECRYPT,
-				       lblk_num, page, page, len, offs,
-				       GFP_NOFS);
+				       lblk_num, page, page, len, offs);
 }
 EXPORT_SYMBOL(fscrypt_decrypt_block_inplace);
 
 /**
  * fscrypt_initialize() - allocate major buffers for fs encryption.
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index bffeb14501fd0..d8b485b9881c5 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -335,12 +335,11 @@ typedef enum {
 extern struct kmem_cache *fscrypt_inode_info_cachep;
 int fscrypt_initialize(struct super_block *sb);
 int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
 			    fscrypt_direction_t rw, u64 index,
 			    struct page *src_page, struct page *dest_page,
-			    unsigned int len, unsigned int offs,
-			    gfp_t gfp_flags);
+			    unsigned int len, unsigned int offs);
 struct page *fscrypt_alloc_bounce_page(gfp_t gfp_flags);
 
 void __printf(3, 4) __cold
 fscrypt_msg(const struct inode *inode, const char *level, const char *fmt, ...);
 
-- 
2.50.1


