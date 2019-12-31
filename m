Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDB312DAE1
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Dec 2019 19:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfLaSOv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Dec 2019 13:14:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfLaSOv (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Dec 2019 13:14:51 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74F33206E0;
        Tue, 31 Dec 2019 18:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577816090;
        bh=VRBAeHHuBqRZmHtfK71JmXlieh+xplwpOzsMUUyH3lA=;
        h=From:To:Cc:Subject:Date:From;
        b=n3I6UYzPFU3JqjaAcvlcWImIBC7EiiW3MHlCFhZlohMvYyZs2ojPdGSAmBWzo4fzf
         ZPYHgQrQXefmMgO63Xi83gw0/Oue3SN6rmZvuJBwLQ9VNmToOfFQdJ0zIEwx2ZyvGe
         QUfAv3GQX0MsNamVa99kRxGvfeXZBWZzYqhWgyxs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] f2fs: fix deadlock allocating bio_post_read_ctx from mempool
Date:   Tue, 31 Dec 2019 12:14:16 -0600
Message-Id: <20191231181416.47875-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Without any form of coordination, any case where multiple allocations
from the same mempool are needed at a time to make forward progress can
deadlock under memory pressure.

This is the case for struct bio_post_read_ctx, as one can be allocated
to decrypt a Merkle tree page during fsverity_verify_bio(), which itself
is running from a post-read callback for a data bio which has its own
struct bio_post_read_ctx.

Fix this by freeing first bio_post_read_ctx before calling
fsverity_verify_bio().  This works because verity (if enabled) is always
the last post-read step.

This deadlock can be reproduced by trying to read from an encrypted
verity file after reducing NUM_PREALLOC_POST_READ_CTXS to 1 and patching
mempool_alloc() to pretend that pool->alloc() always fails.

Note that since NUM_PREALLOC_POST_READ_CTXS is actually 128, to actually
hit this bug in practice would require reading from lots of encrypted
verity files at the same time.  But it's theoretically possible, as N
available objects doesn't guarantee forward progress when > N/2 threads
each need 2 objects at a time.

Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/data.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 19cd03450066..618a05bf356e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -199,19 +199,32 @@ static void f2fs_verity_work(struct work_struct *work)
 {
 	struct bio_post_read_ctx *ctx =
 		container_of(work, struct bio_post_read_ctx, work);
+	struct bio *bio = ctx->bio;
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+	unsigned int enabled_steps = ctx->enabled_steps;
+#endif
+
+	/*
+	 * fsverity_verify_bio() may call readpages() again, and while verity
+	 * will be disabled for this, decryption may still be needed, resulting
+	 * in another bio_post_read_ctx being allocated.  So to prevent
+	 * deadlocks we need to release the current ctx to the mempool first.
+	 * This assumes that verity is the last post-read step.
+	 */
+	mempool_free(ctx, bio_post_read_ctx_pool);
+	bio->bi_private = NULL;
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 	/* previous step is decompression */
-	if (ctx->enabled_steps & (1 << STEP_DECOMPRESS)) {
-
-		f2fs_verify_bio(ctx->bio);
-		f2fs_release_read_bio(ctx->bio);
+	if (enabled_steps & (1 << STEP_DECOMPRESS)) {
+		f2fs_verify_bio(bio);
+		f2fs_release_read_bio(bio);
 		return;
 	}
 #endif
 
-	fsverity_verify_bio(ctx->bio);
-	__f2fs_read_end_io(ctx->bio, false, false);
+	fsverity_verify_bio(bio);
+	__f2fs_read_end_io(bio, false, false);
 }
 
 static void f2fs_post_read_work(struct work_struct *work)
-- 
2.24.1

