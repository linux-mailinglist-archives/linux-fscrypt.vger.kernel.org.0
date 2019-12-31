Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376CE12DAE3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Dec 2019 19:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfLaSPR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Dec 2019 13:15:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfLaSPR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Dec 2019 13:15:17 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9F58206E0;
        Tue, 31 Dec 2019 18:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577816117;
        bh=R7F0k84TKiRuXBbh08JjpWu+dILQdgBWUuwJnRPVITs=;
        h=From:To:Cc:Subject:Date:From;
        b=VvBZ6DKLJT67FOwaf2TjKTfeJkQtxdwc1JKZLSGwK7uxvTFC0Yen37Bm4uySTPGit
         8Iq+XBuHVNxJN9Z0/rGmLuz31TE7TdPcRtlOrOYjFeoZuect9/f2tFsFXhla5wgpv4
         +NKXpZwcV8tBvHd2cqOsJWT9qDan88gnaAgejH8Q=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] f2fs: remove unneeded check for error allocating bio_post_read_ctx
Date:   Tue, 31 Dec 2019 12:14:56 -0600
Message-Id: <20191231181456.47957-1-ebiggers@kernel.org>
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/data.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 618a05bf356e..b52e1512f82e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -939,11 +939,8 @@ static struct bio *f2fs_grab_read_bio(struct inode *inode, block_t blkaddr,
 		post_read_steps |= 1 << STEP_VERITY;
 
 	if (post_read_steps) {
+		/* Due to the mempool, this never fails. */
 		ctx = mempool_alloc(bio_post_read_ctx_pool, GFP_NOFS);
-		if (!ctx) {
-			bio_put(bio);
-			return ERR_PTR(-ENOMEM);
-		}
 		ctx->bio = bio;
 		ctx->sbi = sbi;
 		ctx->enabled_steps = post_read_steps;
-- 
2.24.1

