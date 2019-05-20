Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2009223D56
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 May 2019 18:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392350AbfETQa1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 May 2019 12:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390599AbfETQaY (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 May 2019 12:30:24 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 254B721783;
        Mon, 20 May 2019 16:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558369824;
        bh=o0e8iPypj6yg/PXej9C7BCFNXDHwPIDoUEs1N2gsreM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3WypIvT53nUzt687xIv8X7+zzm9Q2xFxN4jz0ofhZURnAQ5c4fU0s/I61jcsJwXG
         cTB6wJ4w3DJGxyP5QnmI3QvLKWf3fgOJhVTB7vS5lJk+ra4zja9hZs9H6VM0dzXDBO
         ha1yDoBFkgl6IHXYqBjrsuemCqqQQTLJRN71rTbA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org,
        Chandan Rajendra <chandan@linux.ibm.com>
Subject: [PATCH v2 10/14] fscrypt: decrypt only the needed blocks in __fscrypt_decrypt_bio()
Date:   Mon, 20 May 2019 09:29:48 -0700
Message-Id: <20190520162952.156212-11-ebiggers@kernel.org>
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

In __fscrypt_decrypt_bio(), only decrypt the blocks that actually
comprise the bio, rather than assuming blocksize == PAGE_SIZE and
decrypting the entirety of every page used in the bio.

This is in preparation for allowing encryption on ext4 filesystems with
blocksize != PAGE_SIZE.

This is based on work by Chandan Rajendra.

Reviewed-by: Chandan Rajendra <chandan@linux.ibm.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/bio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 61da06fda45cc..82da2510721f6 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -33,8 +33,8 @@ static void __fscrypt_decrypt_bio(struct bio *bio, bool done)
 
 	bio_for_each_segment_all(bv, bio, iter_all) {
 		struct page *page = bv->bv_page;
-		int ret = fscrypt_decrypt_pagecache_blocks(page, PAGE_SIZE, 0);
-
+		int ret = fscrypt_decrypt_pagecache_blocks(page, bv->bv_len,
+							   bv->bv_offset);
 		if (ret)
 			SetPageError(page);
 		else if (done)
-- 
2.21.0.1020.gf2820cf01a-goog

