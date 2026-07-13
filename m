Return-Path: <linux-fscrypt+bounces-1773-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id qTgiGXJQVGoukgMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1773-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 04:41:54 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1462746B90
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 04:41:53 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ANkDROT4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1773-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1773-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DEA81302ACF2
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 02:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA001374A11;
	Mon, 13 Jul 2026 02:39:57 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB65374A1A;
	Mon, 13 Jul 2026 02:39:55 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910397; cv=none; b=dLQOhBilRFh+MVVnsDqxi+17aHB718hY8DK+ZtO7kY+P+9XvYkQEsi/xscmoQxPLpHYnE1TnLm5BGhCTChmlIS5sGMApHLdmsEmOnpiVWfRN0E1vJwVcO9c5dKS4tLspSHIxTIzngmZ2uAUKLiKyLqsyzewKGaKFaTM+OkrC+mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910397; c=relaxed/simple;
	bh=AOzw4CRA8IEhLWcMvI7vlzS3zO4bY8TUqRFXWxSZZA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoytZQlClcDhChb6Poay8+Q4jL4gUduFDIa+Qi2eGaUiuCVbXQGhFJ5WgEZlJWDeJmS57iwASAn2T03ND3EUzQoSrdSTTJjp0S+mVT2BsXa2J7hOnNkhH5HhZYehxRPS4DUr09SRCj/hlUVgJeLvPbZn2/YLAto3/pYUq3vyfyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ANkDROT4; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC381F00ACA;
	Mon, 13 Jul 2026 02:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783910395;
	bh=pE7bbyCIfEGQNNQjWamewFFH78jPMNhR5rgr+ViUAxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANkDROT4zMUquKbNg79DiTBRB2KaONx4VL4tRsPrOnL1S89gwLaDleVkkic/mTBEf
	 0LMsEOvaCRf/xAE9PvC0SrmuU06RsX0kr2LuFfEj67FCsC4UdqKpuCD2TxqARRl+bW
	 /L/VZmOJ1phODXlH6KKN49NUV9KCfe7Tu4ZzTVzosCWZD3qHozbpU+L4ZU6gYvJBI4
	 eFvPPhW/miGQB453uD69mQqi3Z4YhYbR3QSeT0yiqZBv2DE+3K54I6ESqKbWwlLIWq
	 UeT9iOkNTfmEPI496CcAm0r6aw2RpbILrrElltAkZ5xb7Kj5VS3wWvh1zylhg3/uA7
	 QmCofVXcg0DsA==
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
Subject: [PATCH v3 16/17] fscrypt: Merge bio.c and inline_crypt.c into block.c
Date: Sun, 12 Jul 2026 22:37:07 -0400
Message-ID: <20260713023708.9245-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260713023708.9245-1-ebiggers@kernel.org>
References: <20260713023708.9245-1-ebiggers@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-1773-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,lst.de:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C1462746B90

Now that fscrypt always uses blk-crypto on block-based filesystems,
there's no meaningful difference between bio.c and inline_crypt.c.
Therefore merge the two files into one named block.c.

Note: I didn't carry over bio.c's "Copyright (C) 2015, Motorola
Mobility", as none of the code that applied to remained.

Reviewed-by: Christoph Hellwig <hch@lst.de>
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
@@ -10,5 +10,4 @@ fscrypto-y := crypto.o \
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
index 14c8af322c2f..059b7ecc70ea 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/block.c
@@ -1,20 +1,20 @@
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
@@ -341,3 +341,87 @@ u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
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
@@ -395,7 +395,7 @@ void fscrypt_hkdf_expand(const struct hmac_sha512_key *hkdf, u8 context,
 			 const u8 *info, unsigned int infolen,
 			 u8 *okm, unsigned int okmlen);
 
-/* inline_crypt.c */
+/* block.c */
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 static inline bool
 fscrypt_using_inline_encryption(const struct fscrypt_inode_info *ci)
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index acf5b28eb9d7..52ff014aeae6 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -446,10 +446,6 @@ bool fscrypt_match_name(const struct fscrypt_name *fname,
 			const u8 *de_name, u32 de_name_len);
 u64 fscrypt_fname_siphash(const struct inode *dir, const struct qstr *name);
 
-/* bio.c */
-int fscrypt_zeroout_range(const struct inode *inode, loff_t pos,
-			  sector_t sector, u64 len);
-
 /* hooks.c */
 int fscrypt_file_open(struct inode *inode, struct file *filp);
 int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
@@ -737,14 +733,6 @@ static inline int fscrypt_d_revalidate(struct inode *dir, const struct qstr *nam
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
@@ -844,7 +832,7 @@ static inline void fscrypt_set_ops(struct super_block *sb,
 
 #endif	/* !CONFIG_FS_ENCRYPTION */
 
-/* inline_crypt.c */
+/* block.c */
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 
 void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
@@ -854,6 +842,8 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 			   loff_t pos);
 
 u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks);
+int fscrypt_zeroout_range(const struct inode *inode, loff_t pos,
+			  sector_t sector, u64 len);
 
 #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
@@ -873,6 +863,12 @@ static inline u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk,
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
-- 
2.55.0


