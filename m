Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481746D9F94
	for <lists+linux-fscrypt@lfdr.de>; Thu,  6 Apr 2023 20:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjDFSNs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 6 Apr 2023 14:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240033AbjDFSNX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 6 Apr 2023 14:13:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0496083F6
        for <linux-fscrypt@vger.kernel.org>; Thu,  6 Apr 2023 11:13:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 867B560E17
        for <linux-fscrypt@vger.kernel.org>; Thu,  6 Apr 2023 18:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A9BC433EF
        for <linux-fscrypt@vger.kernel.org>; Thu,  6 Apr 2023 18:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680804801;
        bh=2teUQ8h65toPOZ3e0V5ChDgazwKYCdaN9Lw8AuHGGR8=;
        h=From:To:Subject:Date:From;
        b=NQexWqnvFQ1RLUA9ji4Pyx4MrBm54yBG3X5BCQ6klj4rrnrJuerzwBxY5Q0p3qoPO
         UGSqMwSfQjCzPVVOgyRYVBD7nAceI324ujIQ/tFvoxVYOSTJbbYjDAV9eAjob5LTTo
         TZ4Y/vF70neF5na5HJ5gWgthMT4VLR4YTU3UBcHabDHg3jgNUa9fftciZxq1Js/y4e
         nGGgeF8uhwxRZRVVEnSmX6wDvpVEw5jUKi5KAEh/DZi5O4bZaKRXp/icSSXFO5Rss1
         aNOK31egqqgQK93SXBMPGVHp7EefwKdsudmm9nTEtaNgKhxZRdtfM5b1okCovFCMW0
         MmC72au5clWBg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: optimize fscrypt_initialize()
Date:   Thu,  6 Apr 2023 11:12:45 -0700
Message-Id: <20230406181245.36091-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fscrypt_initialize() is a "one-time init" function that is called
whenever the key is set up for any inode on any filesystem.  Make it
implement "one-time init" more efficiently by not taking a global mutex
in the "already initialized case" and doing fewer pointer dereferences.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c          | 19 ++++++++++++-------
 fs/crypto/fscrypt_private.h |  2 +-
 fs/crypto/keysetup.c        |  2 +-
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index bf642479269a5..6a837e4b80dcb 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -308,19 +308,24 @@ EXPORT_SYMBOL(fscrypt_decrypt_block_inplace);
 
 /**
  * fscrypt_initialize() - allocate major buffers for fs encryption.
- * @cop_flags:  fscrypt operations flags
+ * @sb: the filesystem superblock
  *
  * We only call this when we start accessing encrypted files, since it
  * results in memory getting allocated that wouldn't otherwise be used.
  *
  * Return: 0 on success; -errno on failure
  */
-int fscrypt_initialize(unsigned int cop_flags)
+int fscrypt_initialize(struct super_block *sb)
 {
 	int err = 0;
+	mempool_t *pool;
+
+	/* pairs with smp_store_release() below */
+	if (likely(smp_load_acquire(&fscrypt_bounce_page_pool)))
+		return 0;
 
 	/* No need to allocate a bounce page pool if this FS won't use it. */
-	if (cop_flags & FS_CFLG_OWN_PAGES)
+	if (sb->s_cop->flags & FS_CFLG_OWN_PAGES)
 		return 0;
 
 	mutex_lock(&fscrypt_init_mutex);
@@ -328,11 +333,11 @@ int fscrypt_initialize(unsigned int cop_flags)
 		goto out_unlock;
 
 	err = -ENOMEM;
-	fscrypt_bounce_page_pool =
-		mempool_create_page_pool(num_prealloc_crypto_pages, 0);
-	if (!fscrypt_bounce_page_pool)
+	pool = mempool_create_page_pool(num_prealloc_crypto_pages, 0);
+	if (!pool)
 		goto out_unlock;
-
+	/* pairs with smp_load_acquire() above */
+	smp_store_release(&fscrypt_bounce_page_pool, pool);
 	err = 0;
 out_unlock:
 	mutex_unlock(&fscrypt_init_mutex);
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 05310aa741fd6..7ab5a7b7eef8c 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -264,7 +264,7 @@ typedef enum {
 
 /* crypto.c */
 extern struct kmem_cache *fscrypt_info_cachep;
-int fscrypt_initialize(unsigned int cop_flags);
+int fscrypt_initialize(struct super_block *sb);
 int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 			u64 lblk_num, struct page *src_page,
 			struct page *dest_page, unsigned int len,
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 84cdae3063280..361f41ef46c78 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -560,7 +560,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	struct fscrypt_master_key *mk = NULL;
 	int res;
 
-	res = fscrypt_initialize(inode->i_sb->s_cop->flags);
+	res = fscrypt_initialize(inode->i_sb);
 	if (res)
 		return res;
 

base-commit: 41b2ad80fdcaafd42fce173cb95847d0cd8614c2
-- 
2.40.0

