Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8DB23D5B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 May 2019 18:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392315AbfETQa0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 May 2019 12:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389633AbfETQaZ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 May 2019 12:30:25 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 253F2217D7;
        Mon, 20 May 2019 16:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558369825;
        bh=bNfXVLtoITf8LG1OztsuiNKS3cmbu3tuokayi1NgBvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICE9E/nKHvk1KzmTsv7NT0zAmnnMv0GrRE2cFsDrCO79Pr0l3xR0tSZLRKaQVfww+
         F04rJTlzFdv6lvY0pRaVYsuTSOPIoF++p0FCAK1lDPym0h4D0leBHCyOc51fQtejoy
         koS9Idc5jJ0aNk3g4RQTFT+39LtMR4UmJSSj47mg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org,
        Chandan Rajendra <chandan@linux.ibm.com>
Subject: [PATCH v2 13/14] ext4: decrypt only the needed block in __ext4_block_zero_page_range()
Date:   Mon, 20 May 2019 09:29:51 -0700
Message-Id: <20190520162952.156212-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190520162952.156212-1-ebiggers@kernel.org>
References: <20190520162952.156212-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Chandan Rajendra <chandan@linux.ibm.com>

In __ext4_block_zero_page_range(), only decrypt the block that actually
needs to be decrypted, rather than assuming blocksize == PAGE_SIZE and
decrypting the whole page.

This is in preparation for allowing encryption on ext4 filesystems with
blocksize != PAGE_SIZE.

Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
(EB: rebase onto previous changes, improve the commit message, and use
 bh_offset())
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8b3ea9c8ac988..77c43c50e4580 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4075,9 +4075,8 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 		if (S_ISREG(inode->i_mode) && IS_ENCRYPTED(inode)) {
 			/* We expect the key to be set. */
 			BUG_ON(!fscrypt_has_encryption_key(inode));
-			BUG_ON(blocksize != PAGE_SIZE);
 			WARN_ON_ONCE(fscrypt_decrypt_pagecache_blocks(
-						page, PAGE_SIZE, 0));
+					page, blocksize, bh_offset(bh)));
 		}
 	}
 	if (ext4_should_journal_data(inode)) {
-- 
2.21.0.1020.gf2820cf01a-goog

