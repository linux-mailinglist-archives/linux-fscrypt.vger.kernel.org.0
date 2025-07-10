Return-Path: <linux-fscrypt+bounces-700-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D77A6AFF980
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 08:16:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9564B4015A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 06:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE30291157;
	Thu, 10 Jul 2025 06:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PYovnpkz"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C192900A0;
	Thu, 10 Jul 2025 06:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127806; cv=none; b=BI7gJZzNyOYaD0H6x4HIeiKdbi72lfImofzS41xPHonOVtQ8iclgJMx2uRK2132cluAHRESEw/0c28uxF/TUFok0kgb2h3HaMk+5kv8toRd3b1AVgHxgIfqJ9kCgZAG9wGFF+bZSe79fl+cUQlEFgNmS8VGAEEMR9LArifcBVtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127806; c=relaxed/simple;
	bh=ISOZqqMIoJ6Bo5XTcKQL1qoCe0p7TsANa33nW9/riCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9IT1n2qmGRYtH+NVjIJsUpOR+jva02GvnZ5a1UnLvz1B9f4si617msRQLJmfQjjO602KW//ivN949nJesPneF17une3sUVWRFJ//Vwo625WyJ+ShmPfLbWX0ZZJ0iSXGDji1VYQfERVoSsljaO8AKeaMuJpDv+4pKhbT26+/Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PYovnpkz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117B6C4CEF5;
	Thu, 10 Jul 2025 06:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752127806;
	bh=ISOZqqMIoJ6Bo5XTcKQL1qoCe0p7TsANa33nW9/riCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYovnpkzkt5PCA7vwOfL7C9eve152diJJlXfQx15ECLzlSRHlPsJXGI7QIgDzWuoP
	 KudQTYDaakvkIV42pmfVyvPlJa9ZF74H5TewLj2ilLCEeTo3pna7RkK0mGcIk6yvvo
	 5FxRLBVr6R79yOMb1tCqOk6u+95B63IVaZeFE/rwBYd1ch+ESB5jj1VHX08Y4jhOBH
	 59teAf9H1O4Ztnx0cJeZWnu+2mUyKUeAvwwofKB9C4FLCdRinGdO5fULHMSzLgu93W
	 p7TdAuxyh4mVuB10S9v+8y+T03k3vfl/ITOeeGJufJA03zOH7HGV8ORpz3aoe4a4ca
	 hJl5D/+QR0cJw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Yuwen Chen <ywen.chen@foxmail.com>,
	linux-mtd@lists.infradead.org,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 6/6] ceph: Remove gfp_t argument from ceph_fscrypt_encrypt_*()
Date: Wed,  9 Jul 2025 23:07:53 -0700
Message-ID: <20250710060754.637098-7-ebiggers@kernel.org>
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
 fs/ceph/crypto.c | 10 ++++------
 fs/ceph/crypto.h | 10 ++++------
 fs/ceph/file.c   |  3 +--
 fs/ceph/inode.c  |  3 +--
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 6d04d528ed038..91e62db0c2050 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -514,12 +514,11 @@ int ceph_fscrypt_decrypt_block_inplace(const struct inode *inode,
 	return fscrypt_decrypt_block_inplace(inode, page, len, offs, lblk_num);
 }
 
 int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
 				  struct page *page, unsigned int len,
-				  unsigned int offs, u64 lblk_num,
-				  gfp_t gfp_flags)
+				  unsigned int offs, u64 lblk_num)
 {
 	struct ceph_client *cl = ceph_inode_to_client(inode);
 
 	doutc(cl, "%p %llx.%llx len %u offs %u blk %llu\n", inode,
 	      ceph_vinop(inode), len, offs, lblk_num);
@@ -639,21 +638,20 @@ int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page,
  * ceph_fscrypt_encrypt_pages - encrypt an array of pages
  * @inode: pointer to inode associated with these pages
  * @page: pointer to page array
  * @off: offset into the file that the data starts
  * @len: max length to encrypt
- * @gfp: gfp flags to use for allocation
  *
- * Decrypt an array of cleartext pages and return the amount of
+ * Encrypt an array of cleartext pages and return the amount of
  * data encrypted. Any data in the page prior to the start of the
  * first complete block in the read is ignored. Any incomplete
  * crypto blocks at the end of the array are ignored.
  *
  * Returns the length of the encrypted data or a negative errno.
  */
 int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, u64 off,
-				int len, gfp_t gfp)
+				int len)
 {
 	int i, num_blocks;
 	u64 baseblk = off >> CEPH_FSCRYPT_BLOCK_SHIFT;
 	int ret = 0;
 
@@ -670,11 +668,11 @@ int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, u64 off,
 		unsigned int pgoffs = offset_in_page(blkoff);
 		int fret;
 
 		fret = ceph_fscrypt_encrypt_block_inplace(inode, page[pgidx],
 				CEPH_FSCRYPT_BLOCK_SIZE, pgoffs,
-				baseblk + i, gfp);
+				baseblk + i);
 		if (fret < 0) {
 			if (ret == 0)
 				ret = fret;
 			break;
 		}
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index d0768239a1c9c..6db28464ff803 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -153,19 +153,18 @@ static inline void ceph_fscrypt_adjust_off_and_len(struct inode *inode,
 int ceph_fscrypt_decrypt_block_inplace(const struct inode *inode,
 				  struct page *page, unsigned int len,
 				  unsigned int offs, u64 lblk_num);
 int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
 				  struct page *page, unsigned int len,
-				  unsigned int offs, u64 lblk_num,
-				  gfp_t gfp_flags);
+				  unsigned int offs, u64 lblk_num);
 int ceph_fscrypt_decrypt_pages(struct inode *inode, struct page **page,
 			       u64 off, int len);
 int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page,
 				 u64 off, struct ceph_sparse_extent *map,
 				 u32 ext_cnt);
 int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, u64 off,
-			       int len, gfp_t gfp);
+			       int len);
 
 static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
 {
 	return fscrypt_is_bounce_page(page) ? fscrypt_pagecache_page(page) : page;
 }
@@ -244,12 +243,11 @@ static inline int ceph_fscrypt_decrypt_block_inplace(const struct inode *inode,
 	return 0;
 }
 
 static inline int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
 					  struct page *page, unsigned int len,
-					  unsigned int offs, u64 lblk_num,
-					  gfp_t gfp_flags)
+					  unsigned int offs, u64 lblk_num)
 {
 	return 0;
 }
 
 static inline int ceph_fscrypt_decrypt_pages(struct inode *inode,
@@ -267,11 +265,11 @@ static inline int ceph_fscrypt_decrypt_extents(struct inode *inode,
 	return 0;
 }
 
 static inline int ceph_fscrypt_encrypt_pages(struct inode *inode,
 					     struct page **page, u64 off,
-					     int len, gfp_t gfp)
+					     int len)
 {
 	return 0;
 }
 
 static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index a7254cab44cc2..9b79da6d1aee7 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1990,12 +1990,11 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 			break;
 		}
 
 		if (IS_ENCRYPTED(inode)) {
 			ret = ceph_fscrypt_encrypt_pages(inode, pages,
-							 write_pos, write_len,
-							 GFP_KERNEL);
+							 write_pos, write_len);
 			if (ret < 0) {
 				doutc(cl, "encryption failed with %d\n", ret);
 				ceph_release_page_vector(pages, num_pages);
 				break;
 			}
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 06cd2963e41ee..fc543075b827a 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2434,12 +2434,11 @@ static int fill_fscrypt_truncate(struct inode *inode,
 		memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
 
 		/* encrypt the last block */
 		ret = ceph_fscrypt_encrypt_block_inplace(inode, page,
 						    CEPH_FSCRYPT_BLOCK_SIZE,
-						    0, block,
-						    GFP_KERNEL);
+						    0, block);
 		if (ret)
 			goto out;
 	}
 
 	/* Insert the header */
-- 
2.50.1


