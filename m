Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237EF12AD5E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Dec 2019 17:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfLZQJG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 26 Dec 2019 11:09:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfLZQJG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 26 Dec 2019 11:09:06 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07026206CB;
        Thu, 26 Dec 2019 16:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577376545;
        bh=EO2McqdgWCWQbimoE6fuo4fjQkHh8guPRUrjhSXzsQ0=;
        h=From:To:Cc:Subject:Date:From;
        b=g7b+Nf9/JsKmlUhMM6a8kNHZKRh7e5FJJu/VpaVOuuUmp2ZoxNHz14VT28aKzpguk
         GbJ8//slVoVkoQlPR2ORbI1kp93nKPb1MF5CAOyQknGLRVyIXwLivfIYsV1g8WjVn2
         fydz/M5TZj7Yxe1aoexqETtKfKWfJQC0k5nawwhM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org
Subject: [PATCH] fscrypt: optimize fscrypt_zeroout_range()
Date:   Thu, 26 Dec 2019 10:08:13 -0600
Message-Id: <20191226160813.53182-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Currently fscrypt_zeroout_range() issues and waits on a bio for each
block it writes, which makes it very slow.

Optimize it to write up to 16 pages at a time instead.

Also add a function comment, and improve reliability by allowing the
allocations of the bio and the first ciphertext page to wait on the
corresponding mempools.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/bio.c | 112 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 81 insertions(+), 31 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index b88d417e186e..4fa18fff9c4e 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -41,51 +41,101 @@ void fscrypt_decrypt_bio(struct bio *bio)
 }
 EXPORT_SYMBOL(fscrypt_decrypt_bio);
 
+/**
+ * fscrypt_zeroout_range() - zero out a range of blocks in an encrypted file
+ * @inode: the file's inode
+ * @lblk: the first file logical block to zero out
+ * @pblk: the first filesystem physical block to zero out
+ * @len: number of blocks to zero out
+ *
+ * Zero out filesystem blocks in an encrypted regular file on-disk, i.e. write
+ * ciphertext blocks which decrypt to the all-zeroes block.  The blocks must be
+ * both logically and physically contiguous.  It's also assumed that the
+ * filesystem only uses a single block device, ->s_bdev.
+ *
+ * Note that since each block uses a different IV, this involves writing a
+ * different ciphertext to each block; we can't simply reuse the same one.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
 int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
-				sector_t pblk, unsigned int len)
+			  sector_t pblk, unsigned int len)
 {
 	const unsigned int blockbits = inode->i_blkbits;
 	const unsigned int blocksize = 1 << blockbits;
-	struct page *ciphertext_page;
+	const unsigned int blocks_per_page_bits = PAGE_SHIFT - blockbits;
+	const unsigned int blocks_per_page = 1 << blocks_per_page_bits;
+	struct page *pages[16]; /* write up to 16 pages at a time */
+	unsigned int nr_pages;
+	unsigned int i;
+	unsigned int offset;
 	struct bio *bio;
-	int ret, err = 0;
+	int ret, err;
 
-	ciphertext_page = fscrypt_alloc_bounce_page(GFP_NOWAIT);
-	if (!ciphertext_page)
-		return -ENOMEM;
+	if (len == 0)
+		return 0;
 
-	while (len--) {
-		err = fscrypt_crypt_block(inode, FS_ENCRYPT, lblk,
-					  ZERO_PAGE(0), ciphertext_page,
-					  blocksize, 0, GFP_NOFS);
-		if (err)
-			goto errout;
+	BUILD_BUG_ON(ARRAY_SIZE(pages) > BIO_MAX_PAGES);
+	nr_pages = min_t(unsigned int, ARRAY_SIZE(pages),
+			 (len + blocks_per_page - 1) >> blocks_per_page_bits);
 
-		bio = bio_alloc(GFP_NOWAIT, 1);
-		if (!bio) {
-			err = -ENOMEM;
-			goto errout;
-		}
+	/*
+	 * We need at least one page for ciphertext.  Allocate the first one
+	 * from a mempool, with __GFP_DIRECT_RECLAIM set so that it can't fail.
+	 *
+	 * Any additional page allocations are allowed to fail, as they only
+	 * help performance, and waiting on the mempool for them could deadlock.
+	 */
+	for (i = 0; i < nr_pages; i++) {
+		pages[i] = fscrypt_alloc_bounce_page(i == 0 ? GFP_NOFS :
+						     GFP_NOWAIT | __GFP_NOWARN);
+		if (!pages[i])
+			break;
+	}
+	nr_pages = i;
+	if (WARN_ON(nr_pages <= 0))
+		return -EINVAL;
+
+	/* This always succeeds since __GFP_DIRECT_RECLAIM is set. */
+	bio = bio_alloc(GFP_NOFS, nr_pages);
+
+	do {
 		bio_set_dev(bio, inode->i_sb->s_bdev);
 		bio->bi_iter.bi_sector = pblk << (blockbits - 9);
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
-		ret = bio_add_page(bio, ciphertext_page, blocksize, 0);
-		if (WARN_ON(ret != blocksize)) {
-			/* should never happen! */
-			bio_put(bio);
-			err = -EIO;
-			goto errout;
-		}
+
+		i = 0;
+		offset = 0;
+		do {
+			err = fscrypt_crypt_block(inode, FS_ENCRYPT, lblk,
+						  ZERO_PAGE(0), pages[i],
+						  blocksize, offset, GFP_NOFS);
+			if (err)
+				goto out;
+			lblk++;
+			pblk++;
+			len--;
+			offset += blocksize;
+			if (offset == PAGE_SIZE || len == 0) {
+				ret = bio_add_page(bio, pages[i++], offset, 0);
+				if (WARN_ON(ret != offset)) {
+					err = -EIO;
+					goto out;
+				}
+				offset = 0;
+			}
+		} while (i != nr_pages && len != 0);
+
 		err = submit_bio_wait(bio);
-		bio_put(bio);
 		if (err)
-			goto errout;
-		lblk++;
-		pblk++;
-	}
+			goto out;
+		bio_reset(bio);
+	} while (len != 0);
 	err = 0;
-errout:
-	fscrypt_free_bounce_page(ciphertext_page);
+out:
+	bio_put(bio);
+	for (i = 0; i < nr_pages; i++)
+		fscrypt_free_bounce_page(pages[i]);
 	return err;
 }
 EXPORT_SYMBOL(fscrypt_zeroout_range);
-- 
2.24.1

