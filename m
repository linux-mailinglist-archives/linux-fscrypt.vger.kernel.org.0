Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9902912DAD9
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Dec 2019 19:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfLaSMw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Dec 2019 13:12:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfLaSMw (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Dec 2019 13:12:52 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4165D206E0;
        Tue, 31 Dec 2019 18:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577815971;
        bh=gGMnwHoI+uzaVop3AvM64UyZ6itwwMeAjyrW0WCa2II=;
        h=From:To:Cc:Subject:Date:From;
        b=2ipVsB9t84xDlI5XkStOUnkqNdrznfPUDq3ocS1q5YKZLCWpFHmduVWPM8P+qvXcZ
         pU45uGE0+Grc8kv7GYrUiEfprSljAYwaK+uFan9xC+dS22nIeYGmaOkXm5Spbc8EQt
         Qo0I7zp4+sHNCqEZD1M+J5Rw6Bt15mJUoxKRWd6E=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] ext4: fix deadlock allocating bio_post_read_ctx from mempool
Date:   Tue, 31 Dec 2019 12:12:22 -0600
Message-Id: <20191231181222.47684-1-ebiggers@kernel.org>
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

Fix this by freeing the first bio_post_read_ctx before calling
fsverity_verify_bio().  This works because verity (if enabled) is always
the last post-read step.

This deadlock can be reproduced by trying to read from an encrypted
verity file after reducing NUM_PREALLOC_POST_READ_CTXS to 1 and patching
mempool_alloc() to pretend that pool->alloc() always fails.

Note that since NUM_PREALLOC_POST_READ_CTXS is actually 128, to actually
hit this bug in practice would require reading from lots of encrypted
verity files at the same time.  But it's theoretically possible, as N
available objects isn't enough to guarantee forward progress when > N/2
threads each need 2 objects at a time.

Fixes: 22cfe4b48ccb ("ext4: add fs-verity read support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/readpage.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index fef7755300c3..410c904cf59b 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -57,6 +57,7 @@ enum bio_post_read_step {
 	STEP_INITIAL = 0,
 	STEP_DECRYPT,
 	STEP_VERITY,
+	STEP_MAX,
 };
 
 struct bio_post_read_ctx {
@@ -106,10 +107,22 @@ static void verity_work(struct work_struct *work)
 {
 	struct bio_post_read_ctx *ctx =
 		container_of(work, struct bio_post_read_ctx, work);
+	struct bio *bio = ctx->bio;
 
-	fsverity_verify_bio(ctx->bio);
+	/*
+	 * fsverity_verify_bio() may call readpages() again, and although verity
+	 * will be disabled for that, decryption may still be needed, causing
+	 * another bio_post_read_ctx to be allocated.  So to guarantee that
+	 * mempool_alloc() never deadlocks we must free the current ctx first.
+	 * This is safe because verity is the last post-read step.
+	 */
+	BUILD_BUG_ON(STEP_VERITY + 1 != STEP_MAX);
+	mempool_free(ctx, bio_post_read_ctx_pool);
+	bio->bi_private = NULL;
 
-	bio_post_read_processing(ctx);
+	fsverity_verify_bio(bio);
+
+	__read_end_io(bio);
 }
 
 static void bio_post_read_processing(struct bio_post_read_ctx *ctx)
-- 
2.24.1

