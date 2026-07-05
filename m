Return-Path: <linux-fscrypt+bounces-1732-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 6ig/HV21SmpfGgEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1732-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:49:49 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9192870B2C9
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:49:48 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hYV0S4Cg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1732-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1732-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E9440301ACAE
	for <lists+linux-fscrypt@lfdr.de>; Sun,  5 Jul 2026 19:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E3C3A6B89;
	Sun,  5 Jul 2026 19:48:10 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6183A544D;
	Sun,  5 Jul 2026 19:48:08 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783280890; cv=none; b=bEaudbi3NEF9nEbGJLjhnw76o6HlS4WtT9MXn8T9L62lSrp1iJPTY7md8m6cK2G3983gq9Gyxbe0KuvbtyKWDdcCo16xzWU2+vKz2o1nfSt2KjtysWkjdqEmUKdmk5gI6QnO4m4kvAgiQyR2nysvhgEJw+D+roeIaKHMPvGsDvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783280890; c=relaxed/simple;
	bh=vFGLoAw0iVuruMWjO47oa7826z6sq7y0Wv7ss2ggcAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdQ3mg2qXSruhDFzL4HtA++RCfSn+slA5TsY1+Pppw8pzHUTQT4DwuQXJQ/Y7xu0nKj1towqdp0rxJ7103fLHeKiMtXGu9+ylx+cTH/Y13vIih6EIDUGXklXvrqET9IpyeiqSsUy/RaLrU5FLr6c88lrUwpk1AK1Z5WKpwX6o0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hYV0S4Cg; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1611F00A3D;
	Sun,  5 Jul 2026 19:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783280888;
	bh=mDDfCYjtzprRlgnqdPFYv/dPOBGyJWISt7xllfL2rQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYV0S4Cgmqb/GlNaJZTT0Rf3cFwwDmiYPNrJTkBVt171qM4tmB1OsMJgatAORooAu
	 YV4Iwvcajg6yYNcZzQRyGkyRwI4tYc67eGXsrqDqqN7f0ugvIv3NgO19SlKBWBeL4D
	 kdHq71B3RYnHLU0PqCuvs6WPCqjDj6kAbxumqmfTvmWkKFc67L/VlbpLNCxa8caEeK
	 ya5w+z1JSslhKwwYMcsOcAJ49E3IORm2tQ5LKMlX50mdE5OQqEoO0yRe+BsTYIQB5E
	 3uUIL6YwtGPEDxHKM3h103sdnAbqNplz3VvtV0XFYocXvvfZpRHYJChj4IT+/q2Wdb
	 V3cwnRNbcTrxQ==
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
Subject: [PATCH v2 14/17] fscrypt: Remove fs-layer zeroout code
Date: Sun,  5 Jul 2026 12:45:51 -0700
Message-ID: <20260705194555.75030-15-ebiggers@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1732-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,vger.kernel.org:from_smtp,lst.de:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9192870B2C9

Now that fscrypt's file contents en/decryption is always implemented
using blk-crypto when the filesystem is block-based, the fs-layer
zeroout code in fs/crypto/bio.c is unused code.  Remove it, then fold
fscrypt_zeroout_range_inline_crypt() into fscrypt_zeroout_range().

Then make fscrypt_alloc_bounce_page() and fscrypt_crypt_data_unit()
static, since they're no longer called from any other file.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/crypto/bio.c             | 134 +++++++-----------------------------
 fs/crypto/crypto.c          |  14 ++--
 fs/crypto/fscrypt_private.h |   5 --
 3 files changed, 32 insertions(+), 121 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index d07740680602..58b6b13eeedd 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -69,16 +69,36 @@ static void fscrypt_zeroout_range_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
-static int fscrypt_zeroout_range_inline_crypt(const struct inode *inode,
-					      loff_t pos, sector_t sector,
-					      u64 len)
+/**
+ * fscrypt_zeroout_range() - zero out a range of blocks in an encrypted file
+ * @inode: the file's inode
+ * @pos: the first file position (in bytes) to zero out
+ * @sector: the first sector to zero out
+ * @len: bytes to zero out
+ *
+ * Zero out filesystem blocks in an encrypted regular file on-disk, i.e. write
+ * ciphertext blocks which decrypt to the all-zeroes block.  The blocks must be
+ * both logically and physically contiguous.  It's also assumed that the
+ * filesystem only uses a single block device, ->s_bdev.  @len must be a
+ * multiple of the file system logical block size.
+ *
+ * Note that since each block uses a different IV, this involves writing a
+ * different ciphertext to each block; we can't simply reuse the same one.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int fscrypt_zeroout_range(const struct inode *inode, loff_t pos,
+			  sector_t sector, u64 len)
 {
 	struct fscrypt_zero_done done = {
 		.pending	= ATOMIC_INIT(1),
 		.done		= COMPLETION_INITIALIZER_ONSTACK(done.done),
 	};
 
-	while (len) {
+	if (len == 0)
+		return 0;
+
+	do {
 		struct bio *bio;
 		unsigned int n;
 
@@ -102,115 +122,11 @@ static int fscrypt_zeroout_range_inline_crypt(const struct inode *inode,
 
 		atomic_inc(&done.pending);
 		blk_crypto_submit_bio(bio);
-	}
+	} while (len);
 
 	fscrypt_zeroout_range_done(&done);
 
 	wait_for_completion(&done.done);
 	return blk_status_to_errno(done.status);
 }
-
-/**
- * fscrypt_zeroout_range() - zero out a range of blocks in an encrypted file
- * @inode: the file's inode
- * @pos: the first file position (in bytes) to zero out
- * @sector: the first sector to zero out
- * @len: bytes to zero out
- *
- * Zero out filesystem blocks in an encrypted regular file on-disk, i.e. write
- * ciphertext blocks which decrypt to the all-zeroes block.  The blocks must be
- * both logically and physically contiguous.  It's also assumed that the
- * filesystem only uses a single block device, ->s_bdev.  @len must be a
- * multiple of the file system logical block size.
- *
- * Note that since each block uses a different IV, this involves writing a
- * different ciphertext to each block; we can't simply reuse the same one.
- *
- * Return: 0 on success; -errno on failure.
- */
-int fscrypt_zeroout_range(const struct inode *inode, loff_t pos,
-			  sector_t sector, u64 len)
-{
-	const struct fscrypt_inode_info *ci = fscrypt_get_inode_info_raw(inode);
-	const unsigned int du_bits = ci->ci_data_unit_bits;
-	const unsigned int du_size = 1U << du_bits;
-	const unsigned int du_per_page_bits = PAGE_SHIFT - du_bits;
-	const unsigned int du_per_page = 1U << du_per_page_bits;
-	u64 du_index = pos >> du_bits;
-	u64 du_remaining = len >> du_bits;
-	struct page *pages[16]; /* write up to 16 pages at a time */
-	unsigned int nr_pages;
-	unsigned int i;
-	unsigned int offset;
-	struct bio *bio;
-	int ret, err;
-
-	if (len == 0)
-		return 0;
-
-	if (fscrypt_inode_uses_inline_crypto(inode))
-		return fscrypt_zeroout_range_inline_crypt(inode, pos, sector,
-							  len);
-
-	BUILD_BUG_ON(ARRAY_SIZE(pages) > BIO_MAX_VECS);
-	nr_pages = min_t(u64, ARRAY_SIZE(pages),
-			 (du_remaining + du_per_page - 1) >> du_per_page_bits);
-
-	/*
-	 * We need at least one page for ciphertext.  Allocate the first one
-	 * from a mempool, with __GFP_DIRECT_RECLAIM set so that it can't fail.
-	 *
-	 * Any additional page allocations are allowed to fail, as they only
-	 * help performance, and waiting on the mempool for them could deadlock.
-	 */
-	for (i = 0; i < nr_pages; i++) {
-		pages[i] = fscrypt_alloc_bounce_page(i == 0 ? GFP_NOFS :
-						     GFP_NOWAIT);
-		if (!pages[i])
-			break;
-	}
-	nr_pages = i;
-	if (WARN_ON_ONCE(nr_pages <= 0))
-		return -EINVAL;
-
-	/* This always succeeds since __GFP_DIRECT_RECLAIM is set. */
-	bio = bio_alloc(inode->i_sb->s_bdev, nr_pages, REQ_OP_WRITE, GFP_NOFS);
-
-	do {
-		bio->bi_iter.bi_sector = sector;
-
-		i = 0;
-		offset = 0;
-		do {
-			err = fscrypt_crypt_data_unit(ci, FS_ENCRYPT, du_index,
-						      ZERO_PAGE(0), pages[i],
-						      du_size, offset);
-			if (err)
-				goto out;
-			du_index++;
-			sector += 1U << (du_bits - SECTOR_SHIFT);
-			du_remaining--;
-			offset += du_size;
-			if (offset == PAGE_SIZE || du_remaining == 0) {
-				ret = bio_add_page(bio, pages[i++], offset, 0);
-				if (WARN_ON_ONCE(ret != offset)) {
-					err = -EIO;
-					goto out;
-				}
-				offset = 0;
-			}
-		} while (i != nr_pages && du_remaining != 0);
-
-		err = submit_bio_wait(bio);
-		if (err)
-			goto out;
-		bio_reset(bio, inode->i_sb->s_bdev, REQ_OP_WRITE);
-	} while (du_remaining != 0);
-	err = 0;
-out:
-	bio_put(bio);
-	for (i = 0; i < nr_pages; i++)
-		fscrypt_free_bounce_page(pages[i]);
-	return err;
-}
 EXPORT_SYMBOL(fscrypt_zeroout_range);
diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 94dd6c89ddcd..8c4660429418 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -49,7 +49,7 @@ void fscrypt_enqueue_decrypt_work(struct work_struct *work)
 }
 EXPORT_SYMBOL(fscrypt_enqueue_decrypt_work);
 
-struct page *fscrypt_alloc_bounce_page(gfp_t gfp_flags)
+static struct page *fscrypt_alloc_bounce_page(gfp_t gfp_flags)
 {
 	if (WARN_ON_ONCE(!fscrypt_bounce_page_pool)) {
 		/*
@@ -65,8 +65,7 @@ struct page *fscrypt_alloc_bounce_page(gfp_t gfp_flags)
  * fscrypt_free_bounce_page() - free a ciphertext bounce page
  * @bounce_page: the bounce page to free, or NULL
  *
- * Free a bounce page that was allocated by fscrypt_encrypt_pagecache_blocks(),
- * or by fscrypt_alloc_bounce_page() directly.
+ * Free a bounce page that was allocated by fscrypt_encrypt_pagecache_blocks().
  */
 void fscrypt_free_bounce_page(struct page *bounce_page)
 {
@@ -107,10 +106,11 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 index,
 }
 
 /* Encrypt or decrypt a single "data unit" of file contents. */
-int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
-			    fscrypt_direction_t rw, u64 index,
-			    struct page *src_page, struct page *dest_page,
-			    unsigned int len, unsigned int offs)
+static int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
+				   fscrypt_direction_t rw, u64 index,
+				   struct page *src_page,
+				   struct page *dest_page, unsigned int len,
+				   unsigned int offs)
 {
 	struct crypto_sync_skcipher *tfm = ci->ci_enc_key.tfm;
 	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 57b7ae2cfafc..da9040407d4a 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -329,11 +329,6 @@ typedef enum {
 /* crypto.c */
 extern struct kmem_cache *fscrypt_inode_info_cachep;
 int fscrypt_initialize(struct super_block *sb);
-int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
-			    fscrypt_direction_t rw, u64 index,
-			    struct page *src_page, struct page *dest_page,
-			    unsigned int len, unsigned int offs);
-struct page *fscrypt_alloc_bounce_page(gfp_t gfp_flags);
 
 void __printf(3, 4) __cold
 fscrypt_msg(const struct inode *inode, const char *level, const char *fmt, ...);
-- 
2.54.0


