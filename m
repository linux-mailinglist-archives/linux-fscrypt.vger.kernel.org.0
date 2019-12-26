Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEFC12AD43
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Dec 2019 16:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfLZPlT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 26 Dec 2019 10:41:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfLZPlT (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 26 Dec 2019 10:41:19 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA472206A4;
        Thu, 26 Dec 2019 15:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577374879;
        bh=k34ID4CM5KwTXBHzWGuBSNb3G/RtrYHSsw5Hl0omWtc=;
        h=From:To:Cc:Subject:Date:From;
        b=hQSp1mAthg18MOIB9fsbveiTu7kFinMYQ/5WkO0Zv8v5n5unklmOruQFmbXyOTqUx
         kyjxfGNT8lUHEk7F+FpfgUtiIFJMz6ahcq5HbC8PCmCjqBYI8wLLWgWbxhVGvCPnK4
         NBbVPjO28prDfdaIdr9pe49NFRkFVNyWtq8+dkEc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] ext4: handle decryption error in __ext4_block_zero_page_range()
Date:   Thu, 26 Dec 2019 09:41:05 -0600
Message-Id: <20191226154105.4704-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fscrypt_decrypt_pagecache_blocks() can fail, because it uses
skcipher_request_alloc(), which uses kmalloc(), which can fail; and also
because it calls crypto_skcipher_decrypt(), which can fail depending on
the driver that actually implements the crypto.

Therefore it's not appropriate to WARN on decryption error in
__ext4_block_zero_page_range().

Remove the WARN and just handle the error instead.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 629a25d999f0..b8f8afd2e8b2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3701,8 +3701,12 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 		if (S_ISREG(inode->i_mode) && IS_ENCRYPTED(inode)) {
 			/* We expect the key to be set. */
 			BUG_ON(!fscrypt_has_encryption_key(inode));
-			WARN_ON_ONCE(fscrypt_decrypt_pagecache_blocks(
-					page, blocksize, bh_offset(bh)));
+			err = fscrypt_decrypt_pagecache_blocks(page, blocksize,
+							       bh_offset(bh));
+			if (err) {
+				clear_buffer_uptodate(bh);
+				goto unlock;
+			}
 		}
 	}
 	if (ext4_should_journal_data(inode)) {
-- 
2.24.1

