Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBCF12DADB
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Dec 2019 19:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfLaSNr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Dec 2019 13:13:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfLaSNr (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Dec 2019 13:13:47 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06FCE206E0;
        Tue, 31 Dec 2019 18:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577816026;
        bh=tupViY1NQukOCz9x8lkwFdyVoNumpI6Im2bz7Rceb6U=;
        h=From:To:Cc:Subject:Date:From;
        b=syYBCv+NOoJYZAitPqINPaRGB+/4XWDmT8/NFSwCoI5vbXOlKTv31TDIPvLyb5zMs
         gXe1TjfbbUAbajG29J3afBd54M0imkZ/HKoZplgLFHu3VxMOnfzEicjYjJOCytIBFP
         VXkFHrbX/DSvrd/FSe43rvGSCLU1FCL/ndhJyNlI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] ext4: remove unneeded check for error allocating bio_post_read_ctx
Date:   Tue, 31 Dec 2019 12:12:56 -0600
Message-Id: <20191231181256.47770-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since allocating an object from a mempool never fails when
__GFP_DIRECT_RECLAIM (which is included in GFP_NOFS) is set, the check
for failure to allocate a bio_post_read_ctx is unnecessary.  Remove it.

Also remove the redundant assignment to ->bi_private.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/readpage.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 410c904cf59b..c1769afbf799 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -189,12 +189,11 @@ static inline bool ext4_need_verity(const struct inode *inode, pgoff_t idx)
 	       idx < DIV_ROUND_UP(inode->i_size, PAGE_SIZE);
 }
 
-static struct bio_post_read_ctx *get_bio_post_read_ctx(struct inode *inode,
-						       struct bio *bio,
-						       pgoff_t first_idx)
+static void ext4_set_bio_post_read_ctx(struct bio *bio,
+				       const struct inode *inode,
+				       pgoff_t first_idx)
 {
 	unsigned int post_read_steps = 0;
-	struct bio_post_read_ctx *ctx = NULL;
 
 	if (IS_ENCRYPTED(inode) && S_ISREG(inode->i_mode))
 		post_read_steps |= 1 << STEP_DECRYPT;
@@ -203,14 +202,14 @@ static struct bio_post_read_ctx *get_bio_post_read_ctx(struct inode *inode,
 		post_read_steps |= 1 << STEP_VERITY;
 
 	if (post_read_steps) {
-		ctx = mempool_alloc(bio_post_read_ctx_pool, GFP_NOFS);
-		if (!ctx)
-			return ERR_PTR(-ENOMEM);
+		/* Due to the mempool, this never fails. */
+		struct bio_post_read_ctx *ctx =
+			mempool_alloc(bio_post_read_ctx_pool, GFP_NOFS);
+
 		ctx->bio = bio;
 		ctx->enabled_steps = post_read_steps;
 		bio->bi_private = ctx;
 	}
-	return ctx;
 }
 
 static inline loff_t ext4_readpage_limit(struct inode *inode)
@@ -371,24 +370,16 @@ int ext4_mpage_readpages(struct address_space *mapping,
 			bio = NULL;
 		}
 		if (bio == NULL) {
-			struct bio_post_read_ctx *ctx;
-
 			/*
 			 * bio_alloc will _always_ be able to allocate a bio if
 			 * __GFP_DIRECT_RECLAIM is set, see bio_alloc_bioset().
 			 */
 			bio = bio_alloc(GFP_KERNEL,
 				min_t(int, nr_pages, BIO_MAX_PAGES));
-			ctx = get_bio_post_read_ctx(inode, bio, page->index);
-			if (IS_ERR(ctx)) {
-				bio_put(bio);
-				bio = NULL;
-				goto set_error_page;
-			}
+			ext4_set_bio_post_read_ctx(bio, inode, page->index);
 			bio_set_dev(bio, bdev);
 			bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
 			bio->bi_end_io = mpage_end_io;
-			bio->bi_private = ctx;
 			bio_set_op_attrs(bio, REQ_OP_READ,
 						is_readahead ? REQ_RAHEAD : 0);
 		}
-- 
2.24.1

