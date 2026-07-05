Return-Path: <linux-fscrypt+bounces-1733-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id SkYmM6S1Smp4GgEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1733-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:51:00 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E86270B30F
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:51:00 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CCcsiSy4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1733-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1733-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 35E0E30495A3
	for <lists+linux-fscrypt@lfdr.de>; Sun,  5 Jul 2026 19:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B1C23A544D;
	Sun,  5 Jul 2026 19:48:11 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC94E3A6B70;
	Sun,  5 Jul 2026 19:48:09 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783280891; cv=none; b=M1Kb/ZFvSHgt0g4kmHre/Znt0eniNK3IT7j/2GlHLD4xBuAX9S2/vpMhQafXu/HMNUgPwEj+MqZre7yj+xiW655d1DN+RfvBiXHt4slAPDtM0dfo5uC2jg9NYP8QyzmOXmo8JwqVKNiyRJVvpdR4G2cPnsU3bHhotJgB5SqBLos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783280891; c=relaxed/simple;
	bh=W/2gOErph7MgtY2KhuumxY37b8RIbEOm35wYWe1TXnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXSeaw/hoghHdeFl7afv/O2HsVBQZdH7qVzVeuIuMIrs7hBroGGJ1K15nY8bOOyRyadwZfuuvCp3Ohfr5iyXZ0lv9OwE1e4K6AVdG6HM2/AUAXThBRu7jLyTIvTJfOSROsZZdIxD2v9wLmy2t/nmYEEkgzXU/i2Ysl586AwZn3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CCcsiSy4; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763791F000E9;
	Sun,  5 Jul 2026 19:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783280889;
	bh=mdn0/KlnnnFr6c6YDDlxu+OvAmaNgOoYS6mC7YT9bRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCcsiSy4+Oi39jXqhKnzox1krnT5bvky+oBwyVWTlvGVI357P1udMNggl1uy3xL/B
	 WslevkJCwz/m4jPXev1waznexhSS6sYLQLLy2VZajYB5/LwzXQ/5cNPS4XOVRCxOSy
	 cmW1N0zcAY5WTnTwqjN+/hLUK4lsqi4TtIa1c00yaGZyjNMZooHIX+Mzs7q1nabANr
	 HWbIq6LnwxB2VwvW44GohP0diVDNch64Cs8glQLZhsVnuDca5KlIeWFGgTUTeA1Dat
	 ZI/uL29VYaKOqIuWuh5JCzZQZCzeqMNMy83udeNkFUp9SOX9OL5bYc0hsMMkvPeSjT
	 JS5pWKb/E7SkA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 15/17] fscrypt: Remove unused functions and workqueue
Date: Sun,  5 Jul 2026 12:45:52 -0700
Message-ID: <20260705194555.75030-16-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260705194555.75030-1-ebiggers@kernel.org>
References: <20260705194555.75030-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1733-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-block@vger.kernel.org,m:hch@lst.de,m:tytso@mit.edu,m:adilger.kernel@dilger.ca,m:libaokun@linux.alibaba.com,m:jack@suse.cz,m:ojaswin@linux.ibm.com,m:ritesh.list@gmail.com,m:yi.zhang@huawei.com,m:jaegeuk@kernel.org,m:chao@kernel.org,m:ebiggers@kernel.org,m:riteshlist@gmail.com,s:lists@lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.sourceforge.net,lst.de,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,lst.de:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3E86270B30F

Remove functions that are no longer used:

- fscrypt_decrypt_bio()
- fscrypt_decrypt_pagecache_blocks()
- fscrypt_inode_uses_fs_layer_crypto()
- fscrypt_inode_uses_inline_crypto()
- fscrypt_enqueue_decrypt_work()

This makes the decryption workqueue unused, so remove it too.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/crypto/bio.c         | 32 --------------------
 fs/crypto/crypto.c      | 65 -----------------------------------------
 include/linux/fscrypt.h | 47 -----------------------------
 3 files changed, 144 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 58b6b13eeedd..db095258cfca 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -15,38 +15,6 @@
 
 #include "fscrypt_private.h"
 
-/**
- * fscrypt_decrypt_bio() - decrypt the contents of a bio
- * @bio: the bio to decrypt
- *
- * Decrypt the contents of a "read" bio following successful completion of the
- * underlying disk read.  The bio must be reading a whole number of blocks of an
- * encrypted file directly into the page cache.  If the bio is reading the
- * ciphertext into bounce pages instead of the page cache (for example, because
- * the file is also compressed, so decompression is required after decryption),
- * then this function isn't applicable.  This function may sleep, so it must be
- * called from a workqueue rather than from the bio's bi_end_io callback.
- *
- * Return: %true on success; %false on failure.  On failure, bio->bi_status is
- *	   also set to an error status.
- */
-bool fscrypt_decrypt_bio(struct bio *bio)
-{
-	struct folio_iter fi;
-
-	bio_for_each_folio_all(fi, bio) {
-		int err = fscrypt_decrypt_pagecache_blocks(fi.folio, fi.length,
-							   fi.offset);
-
-		if (err) {
-			bio->bi_status = errno_to_blk_status(err);
-			return false;
-		}
-	}
-	return true;
-}
-EXPORT_SYMBOL(fscrypt_decrypt_bio);
-
 struct fscrypt_zero_done {
 	atomic_t		pending;
 	blk_status_t		status;
diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 8c4660429418..27663f4d8705 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -38,17 +38,10 @@ MODULE_PARM_DESC(num_prealloc_crypto_pages,
 
 static mempool_t *fscrypt_bounce_page_pool = NULL;
 
-static struct workqueue_struct *fscrypt_read_workqueue;
 static DEFINE_MUTEX(fscrypt_init_mutex);
 
 struct kmem_cache *fscrypt_inode_info_cachep;
 
-void fscrypt_enqueue_decrypt_work(struct work_struct *work)
-{
-	queue_work(fscrypt_read_workqueue, work);
-}
-EXPORT_SYMBOL(fscrypt_enqueue_decrypt_work);
-
 static struct page *fscrypt_alloc_bounce_page(gfp_t gfp_flags)
 {
 	if (WARN_ON_ONCE(!fscrypt_bounce_page_pool)) {
@@ -238,50 +231,6 @@ int fscrypt_encrypt_block_inplace(const struct inode *inode, struct page *page,
 }
 EXPORT_SYMBOL(fscrypt_encrypt_block_inplace);
 
-/**
- * fscrypt_decrypt_pagecache_blocks() - Decrypt data from a pagecache folio
- * @folio: the pagecache folio containing the data to decrypt
- * @len: size of the data to decrypt, in bytes
- * @offs: offset within @folio of the data to decrypt, in bytes
- *
- * Decrypt data that has just been read from an encrypted file.  The data must
- * be located in a pagecache folio that is still locked and not yet uptodate.
- * The length and offset of the data must be aligned to the file's crypto data
- * unit size.  Alignment to the filesystem block size fulfills this requirement,
- * as the filesystem block size is always a multiple of the data unit size.
- *
- * Return: 0 on success; -errno on failure
- */
-int fscrypt_decrypt_pagecache_blocks(struct folio *folio, size_t len,
-				     size_t offs)
-{
-	const struct inode *inode = folio->mapping->host;
-	const struct fscrypt_inode_info *ci = fscrypt_get_inode_info_raw(inode);
-	const unsigned int du_bits = ci->ci_data_unit_bits;
-	const unsigned int du_size = 1U << du_bits;
-	u64 index = ((u64)folio->index << (PAGE_SHIFT - du_bits)) +
-		    (offs >> du_bits);
-	size_t i;
-	int err;
-
-	if (WARN_ON_ONCE(!folio_test_locked(folio)))
-		return -EINVAL;
-
-	if (WARN_ON_ONCE(len <= 0 || !IS_ALIGNED(len | offs, du_size)))
-		return -EINVAL;
-
-	for (i = offs; i < offs + len; i += du_size, index++) {
-		struct page *page = folio_page(folio, i >> PAGE_SHIFT);
-
-		err = fscrypt_crypt_data_unit(ci, FS_DECRYPT, index, page,
-					      page, du_size, i & ~PAGE_MASK);
-		if (err)
-			return err;
-	}
-	return 0;
-}
-EXPORT_SYMBOL(fscrypt_decrypt_pagecache_blocks);
-
 /**
  * fscrypt_decrypt_block_inplace() - Decrypt a filesystem block in-place
  * @inode:     The inode to which this block belongs
@@ -371,20 +320,6 @@ void fscrypt_msg(const struct inode *inode, const char *level,
 
 static int __init fscrypt_init(void)
 {
-	/*
-	 * Use an unbound workqueue to allow bios to be decrypted in parallel
-	 * even when they happen to complete on the same CPU.  This sacrifices
-	 * locality, but it's worthwhile since decryption is CPU-intensive.
-	 *
-	 * Also use a high-priority workqueue to prioritize decryption work,
-	 * which blocks reads from completing, over regular application tasks.
-	 */
-	fscrypt_read_workqueue = alloc_workqueue("fscrypt_read_queue",
-						 WQ_UNBOUND | WQ_HIGHPRI,
-						 num_online_cpus());
-	if (!fscrypt_read_workqueue)
-		panic("failed to allocate fscrypt_read_queue");
-
 	fscrypt_inode_info_cachep = KMEM_CACHE(fscrypt_inode_info,
 					       SLAB_RECLAIM_ACCOUNT |
 					       SLAB_PANIC);
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 43bafdd67dd7..acf5b28eb9d7 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -343,7 +343,6 @@ static inline void fscrypt_prepare_dentry(struct dentry *dentry,
 }
 
 /* crypto.c */
-void fscrypt_enqueue_decrypt_work(struct work_struct *);
 
 struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 		size_t len, size_t offs, gfp_t gfp_flags);
@@ -351,8 +350,6 @@ int fscrypt_encrypt_block_inplace(const struct inode *inode, struct page *page,
 				  unsigned int len, unsigned int offs,
 				  u64 lblk_num);
 
-int fscrypt_decrypt_pagecache_blocks(struct folio *folio, size_t len,
-				     size_t offs);
 int fscrypt_decrypt_block_inplace(const struct inode *inode, struct page *page,
 				  unsigned int len, unsigned int offs,
 				  u64 lblk_num);
@@ -450,7 +447,6 @@ bool fscrypt_match_name(const struct fscrypt_name *fname,
 u64 fscrypt_fname_siphash(const struct inode *dir, const struct qstr *name);
 
 /* bio.c */
-bool fscrypt_decrypt_bio(struct bio *bio);
 int fscrypt_zeroout_range(const struct inode *inode, loff_t pos,
 			  sector_t sector, u64 len);
 
@@ -510,9 +506,6 @@ static inline void fscrypt_prepare_dentry(struct dentry *dentry,
 }
 
 /* crypto.c */
-static inline void fscrypt_enqueue_decrypt_work(struct work_struct *work)
-{
-}
 
 static inline struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 		size_t len, size_t offs, gfp_t gfp_flags)
@@ -528,12 +521,6 @@ static inline int fscrypt_encrypt_block_inplace(const struct inode *inode,
 	return -EOPNOTSUPP;
 }
 
-static inline int fscrypt_decrypt_pagecache_blocks(struct folio *folio,
-						   size_t len, size_t offs)
-{
-	return -EOPNOTSUPP;
-}
-
 static inline int fscrypt_decrypt_block_inplace(const struct inode *inode,
 						struct page *page,
 						unsigned int len,
@@ -751,10 +738,6 @@ static inline int fscrypt_d_revalidate(struct inode *dir, const struct qstr *nam
 }
 
 /* bio.c */
-static inline bool fscrypt_decrypt_bio(struct bio *bio)
-{
-	return true;
-}
 
 static inline int fscrypt_zeroout_range(const struct inode *inode, loff_t pos,
 					sector_t sector, u64 len)
@@ -892,36 +875,6 @@ static inline u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk,
 }
 #endif /* !CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
-/**
- * fscrypt_inode_uses_inline_crypto() - test whether an inode uses inline
- *					encryption
- * @inode: an inode. If encrypted, its key must be set up.
- *
- * Return: true if the inode requires file contents encryption and if the
- *	   encryption should be done in the block layer via blk-crypto rather
- *	   than in the filesystem layer.
- */
-static inline bool fscrypt_inode_uses_inline_crypto(const struct inode *inode)
-{
-	return fscrypt_needs_contents_encryption(inode) &&
-	       inode->i_sb->s_cop->is_block_based;
-}
-
-/**
- * fscrypt_inode_uses_fs_layer_crypto() - test whether an inode uses fs-layer
- *					  encryption
- * @inode: an inode. If encrypted, its key must be set up.
- *
- * Return: true if the inode requires file contents encryption and if the
- *	   encryption should be done in the filesystem layer rather than in the
- *	   block layer via blk-crypto.
- */
-static inline bool fscrypt_inode_uses_fs_layer_crypto(const struct inode *inode)
-{
-	return fscrypt_needs_contents_encryption(inode) &&
-	       !inode->i_sb->s_cop->is_block_based;
-}
-
 /**
  * fscrypt_has_encryption_key() - check whether an inode has had its key set up
  * @inode: the inode to check
-- 
2.54.0


