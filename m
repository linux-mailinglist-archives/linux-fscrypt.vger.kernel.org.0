Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACBA24F256
	for <lists+linux-fscrypt@lfdr.de>; Mon, 24 Aug 2020 08:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgHXGSa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Aug 2020 02:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgHXGST (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Aug 2020 02:18:19 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E15422087D;
        Mon, 24 Aug 2020 06:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598249899;
        bh=IH6sTOwkbzPMf4x5Li5gjFgkfm2HNIgk1xMl8TNxDTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDKODAQpPTq5huUKShVPhJTG2Df1AHur6QPxO7Njy/ZJwbOEtmt/3AwrwdxS7/TVN
         ZMC92UTKIOeYa+JwpYJPxIO128wY9hOL8oTYduzs1O3YrW9UDLUMuf7TCoC739bDtJ
         CfMQrNc+4ZGVgY9GdtXke3sxODPPYPwCrcKZmOoM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>
Subject: [RFC PATCH 3/8] ext4: remove some #ifdefs in ext4_xattr_credits_for_new_inode()
Date:   Sun, 23 Aug 2020 23:17:07 -0700
Message-Id: <20200824061712.195654-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824061712.195654-1-ebiggers@kernel.org>
References: <20200824061712.195654-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

We don't need #ifdefs for CONFIG_SECURITY and CONFIG_INTEGRITY;
IS_ENABLED() is sufficient.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/ialloc.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 0cc576005a923..3e9c50eb857be 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -763,13 +763,12 @@ static int ext4_xattr_credits_for_new_inode(struct inode *dir, mode_t mode,
 	}
 #endif
 
-#ifdef CONFIG_SECURITY
-	{
+	if (IS_ENABLED(CONFIG_SECURITY)) {
 		int num_security_xattrs = 1;
 
-#ifdef CONFIG_INTEGRITY
-		num_security_xattrs++;
-#endif
+		if (IS_ENABLED(CONFIG_INTEGRITY))
+			num_security_xattrs++;
+
 		/*
 		 * We assume that security xattrs are never more than 1k.
 		 * In practice they are under 128 bytes.
@@ -779,7 +778,7 @@ static int ext4_xattr_credits_for_new_inode(struct inode *dir, mode_t mode,
 						 NULL /* block_bh */, 1024,
 						 true /* is_create */);
 	}
-#endif
+
 	if (encrypt)
 		nblocks += __ext4_xattr_set_credits(sb,
 						    NULL /* inode */,
-- 
2.28.0

