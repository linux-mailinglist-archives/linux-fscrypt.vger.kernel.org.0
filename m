Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5913A12DAD5
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Dec 2019 19:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfLaSLY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Dec 2019 13:11:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfLaSLX (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Dec 2019 13:11:23 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6D34206DB;
        Tue, 31 Dec 2019 18:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577815883;
        bh=9GmQT9cKcl7tj8wWoSiCtLS+8RmK775GLXVdqAQsdkc=;
        h=From:To:Cc:Subject:Date:From;
        b=UPxbqKznUELRcT9Vg+L07Hs0YDFBpLB7RPLZvgFur2FT+3aO3AJJP+/6mjeSrvG3y
         2XbhsKTVSYXt47sqWgKaspoRA8DUrzTf+SLq0AfeKXU7g74ZWYjaF59HxaLQQUV259
         xhZEC5r0r8XXfGiIstxIl0GPbyknRJPB245rcnY8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org
Subject: [PATCH] fscrypt: document gfp_flags for bounce page allocation
Date:   Tue, 31 Dec 2019 12:10:26 -0600
Message-Id: <20191231181026.47400-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Document that fscrypt_encrypt_pagecache_blocks() allocates the bounce
page from a mempool, and document what this means for the @gfp_flags
argument.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index fcc6ca792ba2..1ecaac7ee3cb 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -138,7 +138,7 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
  *		multiple of the filesystem's block size.
  * @offs:      Byte offset within @page of the first block to encrypt.  Must be
  *		a multiple of the filesystem's block size.
- * @gfp_flags: Memory allocation flags
+ * @gfp_flags: Memory allocation flags.  See details below.
  *
  * A new bounce page is allocated, and the specified block(s) are encrypted into
  * it.  In the bounce page, the ciphertext block(s) will be located at the same
@@ -148,6 +148,11 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
  *
  * This is for use by the filesystem's ->writepages() method.
  *
+ * The bounce page allocation is mempool-backed, so it will always succeed when
+ * @gfp_flags includes __GFP_DIRECT_RECLAIM, e.g. when it's GFP_NOFS.  However,
+ * only the first page of each bio can be allocated this way.  To prevent
+ * deadlocks, for any additional pages a mask like GFP_NOWAIT must be used.
+ *
  * Return: the new encrypted bounce page on success; an ERR_PTR() on failure
  */
 struct page *fscrypt_encrypt_pagecache_blocks(struct page *page,
-- 
2.24.1

