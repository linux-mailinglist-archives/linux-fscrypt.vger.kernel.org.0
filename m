Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC0B12DAD7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Dec 2019 19:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfLaSMS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Dec 2019 13:12:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:49866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfLaSMR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Dec 2019 13:12:17 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24A47206DB;
        Tue, 31 Dec 2019 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577815937;
        bh=3w6Tqz6ueWQmYAc9y5MHb7VV8NOhy18y1NXJnrZB9r4=;
        h=From:To:Cc:Subject:Date:From;
        b=Mm7U13xEQY5R5VLNawwgv+UDO4Tm4+clvpIvNgQ0Z6WzzaxNryKCWzxK3GBqQJbon
         zkaDer0HqvI2MzaIRucQbcGBXAjDnVfAbPLfegUWCrIRLENmrmCliulKydCsnRkdAc
         19NbdsrFbO/DQHo2r2YJAiACHxGc6JZipqHFYFJ0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] ext4: fix deadlock allocating crypto bounce page from mempool
Date:   Tue, 31 Dec 2019 12:11:49 -0600
Message-Id: <20191231181149.47619-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

ext4_writepages() on an encrypted file has to encrypt the data, but it
can't modify the pagecache pages in-place, so it encrypts the data into
bounce pages and writes those instead.  All bounce pages are allocated
from a mempool using GFP_NOFS.

This is not correct use of a mempool, and it can deadlock.  This is
because GFP_NOFS includes __GFP_DIRECT_RECLAIM, which enables the "never
fail" mode for mempool_alloc() where a failed allocation will fall back
to waiting for one of the preallocated elements in the pool.

But since this mode is used for all a bio's pages and not just the
first, it can deadlock waiting for pages already in the bio to be freed.

This deadlock can be reproduced by patching mempool_alloc() to pretend
that pool->alloc() always fails (so that it always falls back to the
preallocations), and then creating an encrypted file of size > 128 KiB.

Fix it by only using GFP_NOFS for the first page in the bio.  For
subsequent pages just use GFP_NOWAIT, and if any of those fail, just
submit the bio and start a new one.

This will need to be fixed in f2fs too, but that's less straightforward.

Fixes: c9af28fdd449 ("ext4 crypto: don't let data integrity writebacks fail with ENOMEM")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/page-io.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 24aeedb8fc75..68b39e75446a 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -512,17 +512,26 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 		gfp_t gfp_flags = GFP_NOFS;
 		unsigned int enc_bytes = round_up(len, i_blocksize(inode));
 
+		/*
+		 * Since bounce page allocation uses a mempool, we can only use
+		 * a waiting mask (i.e. request guaranteed allocation) on the
+		 * first page of the bio.  Otherwise it can deadlock.
+		 */
+		if (io->io_bio)
+			gfp_flags = GFP_NOWAIT | __GFP_NOWARN;
 	retry_encrypt:
 		bounce_page = fscrypt_encrypt_pagecache_blocks(page, enc_bytes,
 							       0, gfp_flags);
 		if (IS_ERR(bounce_page)) {
 			ret = PTR_ERR(bounce_page);
-			if (ret == -ENOMEM && wbc->sync_mode == WB_SYNC_ALL) {
-				if (io->io_bio) {
+			if (ret == -ENOMEM &&
+			    (io->io_bio || wbc->sync_mode == WB_SYNC_ALL)) {
+				gfp_flags = GFP_NOFS;
+				if (io->io_bio)
 					ext4_io_submit(io);
-					congestion_wait(BLK_RW_ASYNC, HZ/50);
-				}
-				gfp_flags |= __GFP_NOFAIL;
+				else
+					gfp_flags |= __GFP_NOFAIL;
+				congestion_wait(BLK_RW_ASYNC, HZ/50);
 				goto retry_encrypt;
 			}
 
-- 
2.24.1

