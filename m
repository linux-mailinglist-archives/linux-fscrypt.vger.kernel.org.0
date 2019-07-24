Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 689C173DFC
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jul 2019 22:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390988AbfGXTp1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Jul 2019 15:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390979AbfGXTp0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Jul 2019 15:45:26 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E569121873;
        Wed, 24 Jul 2019 19:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997526;
        bh=eMvM/5Y2qdXA6o3NogQ4na9fMtAe0SAEM9lgHAsC384=;
        h=From:To:Cc:Subject:Date:From;
        b=yNwGV6U8YcB+KTC/l3AJw+gd6nz2AUFTvjTaGhQaCckZsEfpvTtfrSKmibR8ZlMcD
         OEs9qm/qshi5ncuUKu5SnTUQfklCvque9EBnma2E3MNYZ2gwS+GGf/zRuQbx98UZHE
         nGjitpHTKjJ9NLP+UfGwfzzdjj3hBI+2WVGbF758=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>
Subject: [PATCH] fscrypt: remove loadable module related code
Date:   Wed, 24 Jul 2019 12:44:38 -0700
Message-Id: <20190724194438.39975-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since commit 643fa9612bf1 ("fscrypt: remove filesystem specific build
config option"), fs/crypto/ can no longer be built as a loadable module.
Thus it no longer needs a module_exit function, nor a MODULE_LICENSE.
So remove them, and change module_init to late_initcall.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c          | 20 +-------------------
 fs/crypto/fscrypt_private.h |  2 --
 fs/crypto/keyinfo.c         |  5 -----
 3 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 45c3d0427fb253..d52c788b723d01 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -510,22 +510,4 @@ static int __init fscrypt_init(void)
 fail:
 	return -ENOMEM;
 }
-module_init(fscrypt_init)
-
-/**
- * fscrypt_exit() - Shutdown the fs encryption system
- */
-static void __exit fscrypt_exit(void)
-{
-	fscrypt_destroy();
-
-	if (fscrypt_read_workqueue)
-		destroy_workqueue(fscrypt_read_workqueue);
-	kmem_cache_destroy(fscrypt_ctx_cachep);
-	kmem_cache_destroy(fscrypt_info_cachep);
-
-	fscrypt_essiv_cleanup();
-}
-module_exit(fscrypt_exit);
-
-MODULE_LICENSE("GPL");
+late_initcall(fscrypt_init)
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 8978eec9d766dd..224178294371a4 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -166,6 +166,4 @@ struct fscrypt_mode {
 	bool needs_essiv;
 };
 
-extern void __exit fscrypt_essiv_cleanup(void);
-
 #endif /* _FSCRYPT_PRIVATE_H */
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 207ebed918c159..9bcadc09e2aded 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -437,11 +437,6 @@ static int init_essiv_generator(struct fscrypt_info *ci, const u8 *raw_key,
 	return err;
 }
 
-void __exit fscrypt_essiv_cleanup(void)
-{
-	crypto_free_shash(essiv_hash_tfm);
-}
-
 /*
  * Given the encryption mode and key (normally the derived key, but for
  * FS_POLICY_FLAG_DIRECT_KEY mode it's the master key), set up the inode's
-- 
2.22.0.657.g960e92d24f-goog

