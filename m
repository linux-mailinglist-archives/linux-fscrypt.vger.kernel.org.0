Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9B623D49
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 May 2019 18:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389712AbfETQaY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 May 2019 12:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730795AbfETQaY (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 May 2019 12:30:24 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23BF321743;
        Mon, 20 May 2019 16:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558369823;
        bh=FsQP/22WhDGSwV7eheG5LJxh8F1YOJFtBPeRIUtSKqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tTDTdCtFZWdMRppc12iWNivhCMli9AU6LE+jjt9uvdwTVFxa3KFrDikvO9dVkK3I
         U9zhYEYzW2vlWVUf/yTtQHCopNynk0H8CFyKpXGCmZzwblSxW/mZ660sNSuNYeyYBk
         CD6jBTj/f12yOD05IfYRdNc4yZUMaXnVj5CGCoTw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org,
        Chandan Rajendra <chandan@linux.ibm.com>
Subject: [PATCH v2 07/14] fscrypt: handle blocksize < PAGE_SIZE in fscrypt_zeroout_range()
Date:   Mon, 20 May 2019 09:29:45 -0700
Message-Id: <20190520162952.156212-8-ebiggers@kernel.org>
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

Adjust fscrypt_zeroout_range() to encrypt a block at a time rather than
a page at a time, so that it works when blocksize < PAGE_SIZE.

This isn't optimized for performance, but then again this function
already wasn't optimized for performance.  As a future optimization, we
could submit much larger bios here.

This is in preparation for allowing encryption on ext4 filesystems with
blocksize != PAGE_SIZE.

This is based on work by Chandan Rajendra.

Reviewed-by: Chandan Rajendra <chandan@linux.ibm.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/bio.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 92b2d5da5d8e1..f9111ffa12ffd 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -72,12 +72,12 @@ EXPORT_SYMBOL(fscrypt_enqueue_decrypt_bio);
 int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
 				sector_t pblk, unsigned int len)
 {
+	const unsigned int blockbits = inode->i_blkbits;
+	const unsigned int blocksize = 1 << blockbits;
 	struct page *ciphertext_page;
 	struct bio *bio;
 	int ret, err = 0;
 
-	BUG_ON(inode->i_sb->s_blocksize != PAGE_SIZE);
-
 	ciphertext_page = fscrypt_alloc_bounce_page(GFP_NOWAIT);
 	if (!ciphertext_page)
 		return -ENOMEM;
@@ -85,7 +85,7 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
 	while (len--) {
 		err = fscrypt_crypt_block(inode, FS_ENCRYPT, lblk,
 					  ZERO_PAGE(0), ciphertext_page,
-					  PAGE_SIZE, 0, GFP_NOFS);
+					  blocksize, 0, GFP_NOFS);
 		if (err)
 			goto errout;
 
@@ -95,14 +95,11 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
 			goto errout;
 		}
 		bio_set_dev(bio, inode->i_sb->s_bdev);
-		bio->bi_iter.bi_sector =
-			pblk << (inode->i_sb->s_blocksize_bits - 9);
+		bio->bi_iter.bi_sector = pblk << (blockbits - 9);
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
-		ret = bio_add_page(bio, ciphertext_page,
-					inode->i_sb->s_blocksize, 0);
-		if (ret != inode->i_sb->s_blocksize) {
+		ret = bio_add_page(bio, ciphertext_page, blocksize, 0);
+		if (WARN_ON(ret != blocksize)) {
 			/* should never happen! */
-			WARN_ON(1);
 			bio_put(bio);
 			err = -EIO;
 			goto errout;
-- 
2.21.0.1020.gf2820cf01a-goog

