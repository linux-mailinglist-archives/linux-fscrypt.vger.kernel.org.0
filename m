Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3BB23D59
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 May 2019 18:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392210AbfETQa0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 May 2019 12:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392239AbfETQa0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 May 2019 12:30:26 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75FAB217D8;
        Mon, 20 May 2019 16:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558369825;
        bh=nukFlueEKdgNJgzso/AFsN3Mr+EdXgyUtrGGf/8u+g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1Vz3x+6nxyFBaE2h8BSCuzL5qFe0UHFxvGgBIrdA8tW7WyZbF/6R2LpBd+1TkCzr
         pB4VpfNErXPtOKrXOnjcA6qsOyyIUIO3CgBChitVl3yi1JSURZCiGD6g6S4l1QcvOE
         4ZUU82xl6pdJqBCczP5WFk45xzIteoWph7h/RoPM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org,
        Chandan Rajendra <chandan@linux.ibm.com>
Subject: [PATCH v2 14/14] ext4: encrypt only up to last block in ext4_bio_write_page()
Date:   Mon, 20 May 2019 09:29:52 -0700
Message-Id: <20190520162952.156212-15-ebiggers@kernel.org>
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

As an optimization, don't encrypt blocks fully beyond i_size, since
those definitely won't need to be written out.  Also add a comment.

This is in preparation for allowing encryption on ext4 filesystems with
blocksize != PAGE_SIZE.

This is based on work by Chandan Rajendra.

Reviewed-by: Chandan Rajendra <chandan@linux.ibm.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/page-io.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 40ee33df57649..a18a47a2a1d1a 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -467,11 +467,19 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 
 	bh = head = page_buffers(page);
 
+	/*
+	 * If any blocks are being written to an encrypted file, encrypt them
+	 * into a bounce page.  For simplicity, just encrypt until the last
+	 * block which might be needed.  This may cause some unneeded blocks
+	 * (e.g. holes) to be unnecessarily encrypted, but this is rare and
+	 * can't happen in the common case of blocksize == PAGE_SIZE.
+	 */
 	if (IS_ENCRYPTED(inode) && S_ISREG(inode->i_mode) && nr_to_submit) {
 		gfp_t gfp_flags = GFP_NOFS;
+		unsigned int enc_bytes = round_up(len, i_blocksize(inode));
 
 	retry_encrypt:
-		bounce_page = fscrypt_encrypt_pagecache_blocks(page, PAGE_SIZE,
+		bounce_page = fscrypt_encrypt_pagecache_blocks(page, enc_bytes,
 							       0, gfp_flags);
 		if (IS_ERR(bounce_page)) {
 			ret = PTR_ERR(bounce_page);
-- 
2.21.0.1020.gf2820cf01a-goog

