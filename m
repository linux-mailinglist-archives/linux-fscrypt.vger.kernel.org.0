Return-Path: <linux-fscrypt+bounces-1664-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id O+oPMd5mO2qcXQgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1664-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 07:10:54 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D1C36BB6F9
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 07:10:54 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DSFCnIkn;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1664-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1664-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D4B963155251
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 05:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D78E238238A;
	Wed, 24 Jun 2026 05:06:09 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C293812C8;
	Wed, 24 Jun 2026 05:06:07 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782277569; cv=none; b=CcCptgaZnfmN6VqAa5ouikOgAKADw3Xau8wDexKXfgbiG0NxKpzmC1tLXHrnw7tax/KHfffXsiOrkJKHPbt3HNz2cR6zKSaLCf2Qhz9Ti5gEY2+1IDwDJb3I9PIKhjAOBe43Dy3gnYdQNQdpNZZ//8zMdJh1AYo/H6DSSYeX0Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782277569; c=relaxed/simple;
	bh=VO38566/Gnj4AiTDe/+Op5b3oXjxlS2pyd6uXsCYnNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kce7/gnfqUxgl8yxMZloJhQCMqygaay9IYa5ywgCApS0DYBq1CA7/dfrn3rZ52YPw53sg0XCJ/z8l+y7rmMr65vosDwfX+UKy4REIysbo5stWYZeR5vyHlbOCf0hk+0tVhQGOEzNEzNfFzdCBWt4g/LI9I3Fv4dHQQ5xeSf4F7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DSFCnIkn; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E5A1F00A3D;
	Wed, 24 Jun 2026 05:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782277567;
	bh=klO3I4gbr+5T+kAUtraramyA7ErT+tHz21v36Ugnnss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DSFCnIkn/LtHel2fVHfieqJbYzfA/4Ksjer9jr5GWn153GtlnJpsDLXDtfF3xpEuN
	 l3ZRbwi5NE51QIdNstm6/YjUnvcyQ7waZPpgElau/+Jre/ueNo15r7TPII/QIcTmu6
	 UUZGUqgh+BhGZxMa0/6GsHEWKDhzJV7Hky+H9o8I8ZvP6lF0wRVGSmEp1BkChRbcv2
	 j0CCnaepJAIMdhdCjg6M/1wvCI/Hwtf9Tp2tv9CcvvoTO61nQEfqM+aiBpHYbOZ37M
	 9DPgVlyvIxZlGDUuDCoXhPv+sp4Ib3LbQjVs0G70EyKXGur0phOnN9scbKNrqmOuWF
	 Qw8564P8Z3mdg==
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
Subject: [PATCH 15/16] fscrypt: Merge bio.c and inline_crypt.c into block.c
Date: Tue, 23 Jun 2026 22:03:33 -0700
Message-ID: <20260624050334.124606-16-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624050334.124606-1-ebiggers@kernel.org>
References: <20260624050334.124606-1-ebiggers@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1664-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 5D1C36BB6F9

Now that fscrypt always uses blk-crypto on block-based filesystems,
there's no meaningful difference between bio.c and inline_crypt.c.
Therefore merge the two files into one named block.c.

Note: I didn't carry over bio.c's "Copyright (C) 2015, Motorola
Mobility", as none of the code that applied to remained.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/crypto/Makefile                    |   3 +-
 fs/crypto/bio.c                       | 100 --------------------------
 fs/crypto/{inline_crypt.c => block.c} |  96 +++++++++++++++++++++++--
 fs/crypto/fscrypt_private.h           |   2 +-
 include/linux/fscrypt.h               |  22 +++---
 5 files changed, 101 insertions(+), 122 deletions(-)
 delete mode 100644 fs/crypto/bio.c
 rename fs/crypto/{inline_crypt.c => block.c} (79%)

diff --git a/fs/crypto/Makefile b/fs/crypto/Makefile
index 652c7180ec6d..b03e02f0f09d 100644
--- a/fs/crypto/Makefile
+++ b/fs/crypto/Makefile
@@ -8,7 +8,6 @@ fscrypto-y := crypto.o \
 	      keyring.o \
 	      keysetup.o \
 	      keysetup_v1.o \
 	      policy.o
 
-fscrypto-$(CONFIG_BLOCK) += bio.o
-fscrypto-$(CONFIG_FS_ENCRYPTION_INLINE_CRYPT) += inline_crypt.o
+fscrypto-$(CONFIG_BLOCK) += block.o
diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
deleted file mode 100644
index db095258cfca..000000000000
--- a/fs/crypto/bio.c
+++ /dev/null
@@ -1,100 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Utility functions for file contents encryption/decryption on
- * block device-based filesystems.
- *
- * Copyright (C) 2015, Google, Inc.
- * Copyright (C) 2015, Motorola Mobility
- */
-
-#include <linux/bio.h>
-#include <linux/export.h>
-#include <linux/module.h>
-#include <linux/namei.h>
-#include <linux/pagemap.h>
-
-#include "fscrypt_private.h"
-
-struct fscrypt_zero_done {
-	atomic_t		pending;
-	blk_status_t		status;
-	struct completion	done;
-};
-
-static void fscrypt_zeroout_range_done(struct fscrypt_zero_done *done)
-{
-	if (atomic_dec_and_test(&done->pending))
-		complete(&done->done);
-}
-
-static void fscrypt_zeroout_range_end_io(struct bio *bio)
-{
-	struct fscrypt_zero_done *done = bio->bi_private;
-
-	if (bio->bi_status)
-		cmpxchg(&done->status, 0, bio->bi_status);
-	fscrypt_zeroout_range_done(done);
-	bio_put(bio);
-}
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
-	struct fscrypt_zero_done done = {
-		.pending	= ATOMIC_INIT(1),
-		.done		= COMPLETION_INITIALIZER_ONSTACK(done.done),
-	};
-
-	if (len == 0)
-		return 0;
-
-	do {
-		struct bio *bio;
-		unsigned int n;
-
-		bio = bio_alloc(inode->i_sb->s_bdev, BIO_MAX_VECS, REQ_OP_WRITE,
-				GFP_NOFS);
-		bio->bi_iter.bi_sector = sector;
-		bio->bi_private = &done;
-		bio->bi_end_io = fscrypt_zeroout_range_end_io;
-		fscrypt_set_bio_crypt_ctx(bio, inode, pos, GFP_NOFS);
-
-		for (n = 0; n < BIO_MAX_VECS; n++) {
-			unsigned int bytes_this_page = min(len, PAGE_SIZE);
-
-			__bio_add_page(bio, ZERO_PAGE(0), bytes_this_page, 0);
-			len -= bytes_this_page;
-			pos += bytes_this_page;
-			sector += (bytes_this_page >> SECTOR_SHIFT);
-			if (!len || !fscrypt_mergeable_bio(bio, inode, pos))
-				break;
-		}
-
-		atomic_inc(&done.pending);
-		blk_crypto_submit_bio(bio);
-	} while (len);
-
-	fscrypt_zeroout_range_done(&done);
-
-	wait_for_completion(&done.done);
-	return blk_status_to_errno(done.status);
-}
-EXPORT_SYMBOL(fscrypt_zeroout_range);
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/block.c
similarity index 79%
rename from fs/crypto/inline_crypt.c
rename to fs/crypto/block.c
index 3c3a46c5af42..60e687da7760 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/block.c
@@ -1,22 +1,22 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Inline encryption support for fscrypt
+ * File contents en/decryption on block-based filesystems
  *
  * Copyright 2019 Google LLC
  */
 
 /*
- * With "inline encryption", the block layer handles the decryption/encryption
- * as part of the bio, instead of the filesystem doing the crypto itself via
- * crypto API.  See Documentation/block/inline-encryption.rst.  fscrypt still
- * provides the key and IV to use.
+ * This file implements fscrypt's file contents en/decryption using blk-crypto
+ * (Documentation/block/inline-encryption.rst).  fscrypt assigns a bio_crypt_ctx
+ * with a key and IV to each bio, and the block layer does the en/decryption.
+ *
+ * This file's exported functions are called only by block-based filesystems.
  */
 
 #include <linux/blk-crypto.h>
 #include <linux/blkdev.h>
-#include <linux/buffer_head.h>
 #include <linux/export.h>
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
 #include <linux/uio.h>
 
@@ -338,5 +338,89 @@ u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
 	dun = ci->ci_hashed_ino + lblk;
 
 	return min_t(u64, nr_blocks, (u64)U32_MAX + 1 - dun);
 }
 EXPORT_SYMBOL_GPL(fscrypt_limit_io_blocks);
+
+struct fscrypt_zero_done {
+	atomic_t		pending;
+	blk_status_t		status;
+	struct completion	done;
+};
+
+static void fscrypt_zeroout_range_done(struct fscrypt_zero_done *done)
+{
+	if (atomic_dec_and_test(&done->pending))
+		complete(&done->done);
+}
+
+static void fscrypt_zeroout_range_end_io(struct bio *bio)
+{
+	struct fscrypt_zero_done *done = bio->bi_private;
+
+	if (bio->bi_status)
+		cmpxchg(&done->status, 0, bio->bi_status);
+	fscrypt_zeroout_range_done(done);
+	bio_put(bio);
+}
+
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
+{
+	struct fscrypt_zero_done done = {
+		.pending	= ATOMIC_INIT(1),
+		.done		= COMPLETION_INITIALIZER_ONSTACK(done.done),
+	};
+
+	if (len == 0)
+		return 0;
+
+	do {
+		struct bio *bio;
+		unsigned int n;
+
+		bio = bio_alloc(inode->i_sb->s_bdev, BIO_MAX_VECS, REQ_OP_WRITE,
+				GFP_NOFS);
+		bio->bi_iter.bi_sector = sector;
+		bio->bi_private = &done;
+		bio->bi_end_io = fscrypt_zeroout_range_end_io;
+		fscrypt_set_bio_crypt_ctx(bio, inode, pos, GFP_NOFS);
+
+		for (n = 0; n < BIO_MAX_VECS; n++) {
+			unsigned int bytes_this_page = min(len, PAGE_SIZE);
+
+			__bio_add_page(bio, ZERO_PAGE(0), bytes_this_page, 0);
+			len -= bytes_this_page;
+			pos += bytes_this_page;
+			sector += (bytes_this_page >> SECTOR_SHIFT);
+			if (!len || !fscrypt_mergeable_bio(bio, inode, pos))
+				break;
+		}
+
+		atomic_inc(&done.pending);
+		blk_crypto_submit_bio(bio);
+	} while (len);
+
+	fscrypt_zeroout_range_done(&done);
+
+	wait_for_completion(&done.done);
+	return blk_status_to_errno(done.status);
+}
+EXPORT_SYMBOL(fscrypt_zeroout_range);
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index da9040407d4a..74329e0953d1 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -393,11 +393,11 @@ void fscrypt_init_hkdf(struct hmac_sha512_key *hkdf, const u8 *master_key,
 
 void fscrypt_hkdf_expand(const struct hmac_sha512_key *hkdf, u8 context,
 			 const u8 *info, unsigned int infolen,
 			 u8 *okm, unsigned int okmlen);
 
-/* inline_crypt.c */
+/* block.c */
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 static inline bool
 fscrypt_using_inline_encryption(const struct fscrypt_inode_info *ci)
 {
 	const struct inode *inode = ci->ci_inode;
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index acf5b28eb9d7..52ff014aeae6 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -444,14 +444,10 @@ int fscrypt_fname_disk_to_usr(const struct inode *inode,
 			      struct fscrypt_str *oname);
 bool fscrypt_match_name(const struct fscrypt_name *fname,
 			const u8 *de_name, u32 de_name_len);
 u64 fscrypt_fname_siphash(const struct inode *dir, const struct qstr *name);
 
-/* bio.c */
-int fscrypt_zeroout_range(const struct inode *inode, loff_t pos,
-			  sector_t sector, u64 len);
-
 /* hooks.c */
 int fscrypt_file_open(struct inode *inode, struct file *filp);
 int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
 			   struct dentry *dentry);
 int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -735,18 +731,10 @@ static inline int fscrypt_d_revalidate(struct inode *dir, const struct qstr *nam
 				       struct dentry *dentry, unsigned int flags)
 {
 	return 1;
 }
 
-/* bio.c */
-
-static inline int fscrypt_zeroout_range(const struct inode *inode, loff_t pos,
-					sector_t sector, u64 len)
-{
-	return -EOPNOTSUPP;
-}
-
 /* hooks.c */
 
 static inline int fscrypt_file_open(struct inode *inode, struct file *filp)
 {
 	if (IS_ENCRYPTED(inode))
@@ -842,20 +830,22 @@ static inline void fscrypt_set_ops(struct super_block *sb,
 {
 }
 
 #endif	/* !CONFIG_FS_ENCRYPTION */
 
-/* inline_crypt.c */
+/* block.c */
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 
 void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 			       loff_t pos, gfp_t gfp_mask);
 
 bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 			   loff_t pos);
 
 u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks);
+int fscrypt_zeroout_range(const struct inode *inode, loff_t pos,
+			  sector_t sector, u64 len);
 
 #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
 static inline void fscrypt_set_bio_crypt_ctx(struct bio *bio,
 					     const struct inode *inode,
@@ -871,10 +861,16 @@ static inline bool fscrypt_mergeable_bio(struct bio *bio,
 static inline u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk,
 					  u64 nr_blocks)
 {
 	return nr_blocks;
 }
+
+static inline int fscrypt_zeroout_range(const struct inode *inode, loff_t pos,
+					sector_t sector, u64 len)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* !CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
 /**
  * fscrypt_has_encryption_key() - check whether an inode has had its key set up
  * @inode: the inode to check
-- 
2.54.0


