Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB8341176F0
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 21:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfLIUBo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 15:01:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfLIUBn (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 15:01:43 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C210207FF;
        Mon,  9 Dec 2019 20:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575921703;
        bh=K1d911qmlv1lt+lM91/RWn4jQvLczI5FAJzlB1rg+t4=;
        h=From:To:Cc:Subject:Date:From;
        b=cg/H6mPUzr8Li5z+rJENvwBBYqtRHdnrkBtX+3f/107hzIHP/WxjS+SscCVweBB8S
         zsM9X8KuEx1Eqp8xq649mLGxFi8wuz5aKMKYsQM9DFsS9cVix1IcnGsF1Kl7eDp8SH
         a8TDcjX3+b6n2/3zo/asKApOonQJlkxjmjLToDs8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] f2fs: don't keep META_MAPPING pages used for moving verity file blocks
Date:   Mon,  9 Dec 2019 12:00:55 -0800
Message-Id: <20191209200055.204040-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

META_MAPPING is used to move blocks for both encrypted and verity files.
So the META_MAPPING invalidation condition in do_checkpoint() should
consider verity too, not just encrypt.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/checkpoint.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index ffdaba0c55d29..44e84ac5c9411 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1509,10 +1509,10 @@ static int do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	f2fs_wait_on_all_pages_writeback(sbi);
 
 	/*
-	 * invalidate intermediate page cache borrowed from meta inode
-	 * which are used for migration of encrypted inode's blocks.
+	 * invalidate intermediate page cache borrowed from meta inode which are
+	 * used for migration of encrypted or verity inode's blocks.
 	 */
-	if (f2fs_sb_has_encrypt(sbi))
+	if (f2fs_sb_has_encrypt(sbi) || f2fs_sb_has_verity(sbi))
 		invalidate_mapping_pages(META_MAPPING(sbi),
 				MAIN_BLKADDR(sbi), MAX_BLKADDR(sbi) - 1);
 
-- 
2.24.0.393.g34dc348eaf-goog

