Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCA673D1D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jul 2019 22:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404349AbfGXTya (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Jul 2019 15:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404351AbfGXTy3 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Jul 2019 15:54:29 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A83F217D4
        for <linux-fscrypt@vger.kernel.org>; Wed, 24 Jul 2019 19:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998068;
        bh=I7APpuVMA0gf6f1HZOU3ahDDWNpTj566Hv7PaJYTG8M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=I0IQOazeMVwFyEnXSzDtTFNGk2x5frLEneq1WdYGXOiT7aG7R1JSUnO5k4f+fiAav
         uTwUpV/KxXC656Ym2SUAM0RRdK8vA5W4nH5667uryvinp3YjbktODGtJKFZpuxMAY4
         WVzAIjPT3OKumb6peiSEruYCVFu1lrJevoYz19aM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 2/4] fscrypt: improve warning messages for unsupported encryption contexts
Date:   Wed, 24 Jul 2019 12:54:20 -0700
Message-Id: <20190724195422.42495-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
In-Reply-To: <20190724195422.42495-1-ebiggers@kernel.org>
References: <20190724195422.42495-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When fs/crypto/ encounters an inode with an invalid encryption context,
currently it prints a warning if the pair of encryption modes are
unrecognized, but it's silent if there are other problems such as
unsupported context size, format, or flags.  To help people debug such
situations, add more warning messages.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keyinfo.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index d0eb901a6d1a9f..e5ab18d98f32a3 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -510,8 +510,12 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
 	if (res < 0) {
 		if (!fscrypt_dummy_context_enabled(inode) ||
-		    IS_ENCRYPTED(inode))
+		    IS_ENCRYPTED(inode)) {
+			fscrypt_warn(inode,
+				     "Error %d getting encryption context",
+				     res);
 			return res;
+		}
 		/* Fake up a context for an unencrypted directory */
 		memset(&ctx, 0, sizeof(ctx));
 		ctx.format = FS_ENCRYPTION_CONTEXT_FORMAT_V1;
@@ -519,14 +523,22 @@ int fscrypt_get_encryption_info(struct inode *inode)
 		ctx.filenames_encryption_mode = FS_ENCRYPTION_MODE_AES_256_CTS;
 		memset(ctx.master_key_descriptor, 0x42, FS_KEY_DESCRIPTOR_SIZE);
 	} else if (res != sizeof(ctx)) {
+		fscrypt_warn(inode,
+			     "Unknown encryption context size (%d bytes)", res);
 		return -EINVAL;
 	}
 
-	if (ctx.format != FS_ENCRYPTION_CONTEXT_FORMAT_V1)
+	if (ctx.format != FS_ENCRYPTION_CONTEXT_FORMAT_V1) {
+		fscrypt_warn(inode, "Unknown encryption context version (%d)",
+			     ctx.format);
 		return -EINVAL;
+	}
 
-	if (ctx.flags & ~FS_POLICY_FLAGS_VALID)
+	if (ctx.flags & ~FS_POLICY_FLAGS_VALID) {
+		fscrypt_warn(inode, "Unknown encryption context flags (0x%02x)",
+			     ctx.flags);
 		return -EINVAL;
+	}
 
 	crypt_info = kmem_cache_zalloc(fscrypt_info_cachep, GFP_NOFS);
 	if (!crypt_info)
-- 
2.22.0.657.g960e92d24f-goog

