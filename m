Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B4B12898C
	for <lists+linux-fscrypt@lfdr.de>; Sat, 21 Dec 2019 15:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfLUOaa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 21 Dec 2019 09:30:30 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:51000 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbfLUOaa (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 21 Dec 2019 09:30:30 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iiflv-00005n-H9; Sat, 21 Dec 2019 22:30:23 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iifls-0006cC-Bs; Sat, 21 Dec 2019 22:30:20 +0800
Date:   Sat, 21 Dec 2019 22:30:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: Restore modular support
Message-ID: <20191221143020.hbgeixvlmzt7nh54@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The commit 643fa9612bf1 ("fscrypt: remove filesystem specific
build config option") removed modular support for fs/crypto.  This
causes the Crypto API to be built-in whenever fscrypt is enabled.
This makes it very difficult for me to test modular builds of
the Crypto API without disabling fscrypt which is a pain.

AFAICS there is no reason why fscrypt has to be built-in.  The
commit above appears to have done this way purely for the sake of
simplicity.  In fact some simple Kconfig tweaking is sufficient
to retain a single FS_ENCRYPTION option while maintaining modularity.

This patch restores modular support to fscrypt by adding a new
hidden FS_ENCRYPTION_TRI tristate option that is selected by all
the FS_ENCRYPTION users.

Subsequent to the above commit, some core code has been introduced
to fs/buffer.c that makes restoring modular support non-trivial.
This patch deals with this by adding a function pointer that defaults
to end_buffer_async_read function until fscrypt is loaded.  When
fscrypt is loaded it modifies the function pointer to its own
function which used to be end_buffer_async_read_io but now resides
in fscrypt.  When it is unloaded the function pointer is restored.

In order for this to be safe with respect to module removal, the
check for whether the host inode is encrypted has been moved into
mark_buffer_async_read.  The assumption is that as long as the
bh is alive the calling filesystem module will be resident.  The
calling filesystem would then guarantee that fscrypt is loaded.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/fs/buffer.c b/fs/buffer.c
index d8c7242426bb..eb3553fb5877 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -47,10 +47,13 @@
 #include <linux/pagevec.h>
 #include <linux/sched/mm.h>
 #include <trace/events/block.h>
-#include <linux/fscrypt.h>
 
 #include "internal.h"
 
+void (*end_buffer_async_read_io)(struct buffer_head *bh, int uptodate) =
+	end_buffer_async_read;
+EXPORT_SYMBOL_GPL(end_buffer_async_read_io);
+
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
 static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
 			 enum rw_hint hint, struct writeback_control *wbc);
@@ -249,7 +252,11 @@ __find_get_block_slow(struct block_device *bdev, sector_t block)
 	return ret;
 }
 
-static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
+/*
+ * I/O completion handler for block_read_full_page() - pages
+ * which come unlocked at the end of I/O.
+ */
+void end_buffer_async_read(struct buffer_head *bh, int uptodate)
 {
 	unsigned long flags;
 	struct buffer_head *first;
@@ -305,47 +312,7 @@ static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
 	local_irq_restore(flags);
 	return;
 }
-
-struct decrypt_bh_ctx {
-	struct work_struct work;
-	struct buffer_head *bh;
-};
-
-static void decrypt_bh(struct work_struct *work)
-{
-	struct decrypt_bh_ctx *ctx =
-		container_of(work, struct decrypt_bh_ctx, work);
-	struct buffer_head *bh = ctx->bh;
-	int err;
-
-	err = fscrypt_decrypt_pagecache_blocks(bh->b_page, bh->b_size,
-					       bh_offset(bh));
-	end_buffer_async_read(bh, err == 0);
-	kfree(ctx);
-}
-
-/*
- * I/O completion handler for block_read_full_page() - pages
- * which come unlocked at the end of I/O.
- */
-static void end_buffer_async_read_io(struct buffer_head *bh, int uptodate)
-{
-	/* Decrypt if needed */
-	if (uptodate && IS_ENABLED(CONFIG_FS_ENCRYPTION) &&
-	    IS_ENCRYPTED(bh->b_page->mapping->host) &&
-	    S_ISREG(bh->b_page->mapping->host->i_mode)) {
-		struct decrypt_bh_ctx *ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
-
-		if (ctx) {
-			INIT_WORK(&ctx->work, decrypt_bh);
-			ctx->bh = bh;
-			fscrypt_enqueue_decrypt_work(&ctx->work);
-			return;
-		}
-		uptodate = 0;
-	}
-	end_buffer_async_read(bh, uptodate);
-}
+EXPORT_SYMBOL_GPL(end_buffer_async_read);
 
 /*
  * Completion handler for block_write_full_page() - pages which are unlocked
@@ -419,7 +386,11 @@ EXPORT_SYMBOL(end_buffer_async_write);
  */
 static void mark_buffer_async_read(struct buffer_head *bh)
 {
-	bh->b_end_io = end_buffer_async_read_io;
+	bh->b_end_io = end_buffer_async_read;
+	if (IS_ENABLED(CONFIG_FS_ENCRYPTION) &&
+	    IS_ENCRYPTED(bh->b_page->mapping->host) &&
+	    S_ISREG(bh->b_page->mapping->host->i_mode))
+		bh->b_end_io = end_buffer_async_read_io;
 	set_buffer_async_read(bh);
 }
 
diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index ff5a1746cbae..5c32902ed50f 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -1,6 +1,16 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config FS_ENCRYPTION
 	bool "FS Encryption (Per-file encryption)"
+	select KEYS
+	help
+	  Enable encryption of files and directories.  This
+	  feature is similar to ecryptfs, but it is more memory
+	  efficient since it avoids caching the encrypted and
+	  decrypted pages in the page cache.  Currently Ext4,
+	  F2FS and UBIFS make use of this feature.
+
+config FS_ENCRYPTION_TRI
+	tristate
 	select CRYPTO
 	select CRYPTO_AES
 	select CRYPTO_CBC
@@ -9,10 +19,3 @@ config FS_ENCRYPTION
 	select CRYPTO_CTS
 	select CRYPTO_SHA512
 	select CRYPTO_HMAC
-	select KEYS
-	help
-	  Enable encryption of files and directories.  This
-	  feature is similar to ecryptfs, but it is more memory
-	  efficient since it avoids caching the encrypted and
-	  decrypted pages in the page cache.  Currently Ext4,
-	  F2FS and UBIFS make use of this feature.
diff --git a/fs/crypto/Makefile b/fs/crypto/Makefile
index 232e2bb5a337..9e0513e8626f 100644
--- a/fs/crypto/Makefile
+++ b/fs/crypto/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_FS_ENCRYPTION)	+= fscrypto.o
+obj-$(CONFIG_FS_ENCRYPTION_TRI)	+= fscrypto.o
 
 fscrypto-y := crypto.o \
 	      fname.o \
diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 3719efa546c6..6bf7f05120bd 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -20,6 +20,7 @@
  * Special Publication 800-38E and IEEE P1619/D16.
  */
 
+#include <linux/buffer_head.h>
 #include <linux/pagemap.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
@@ -286,6 +287,41 @@ int fscrypt_decrypt_block_inplace(const struct inode *inode, struct page *page,
 }
 EXPORT_SYMBOL(fscrypt_decrypt_block_inplace);
 
+struct decrypt_bh_ctx {
+	struct work_struct work;
+	struct buffer_head *bh;
+};
+
+static void decrypt_bh(struct work_struct *work)
+{
+	struct decrypt_bh_ctx *ctx =
+		container_of(work, struct decrypt_bh_ctx, work);
+	struct buffer_head *bh = ctx->bh;
+	int err;
+
+	err = fscrypt_decrypt_pagecache_blocks(bh->b_page, bh->b_size,
+					       bh_offset(bh));
+	end_buffer_async_read(bh, err == 0);
+	kfree(ctx);
+}
+
+static void fscrypt_end_buffer_async_read(struct buffer_head *bh, int uptodate)
+{
+	/* Decrypt if needed */
+	if (uptodate) {
+		struct decrypt_bh_ctx *ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
+
+		if (ctx) {
+			INIT_WORK(&ctx->work, decrypt_bh);
+			ctx->bh = bh;
+			fscrypt_enqueue_decrypt_work(&ctx->work);
+			return;
+		}
+		uptodate = 0;
+	}
+	end_buffer_async_read(bh, uptodate);
+}
+
 /*
  * Validate dentries in encrypted directories to make sure we aren't potentially
  * caching stale dentries after a key has been added.
@@ -418,6 +454,8 @@ static int __init fscrypt_init(void)
 	if (err)
 		goto fail_free_info;
 
+	end_buffer_async_read_io = fscrypt_end_buffer_async_read;
+
 	return 0;
 
 fail_free_info:
@@ -427,4 +465,18 @@ static int __init fscrypt_init(void)
 fail:
 	return err;
 }
-late_initcall(fscrypt_init)
+module_init(fscrypt_init)
+
+/**
+ * fscrypt_exit() - Shutdown the fs encryption system
+ */
+static void __exit fscrypt_exit(void)
+{
+	end_buffer_async_read_io = end_buffer_async_read;
+
+	kmem_cache_destroy(fscrypt_info_cachep);
+	destroy_workqueue(fscrypt_read_workqueue);
+}
+module_exit(fscrypt_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index ef42ab040905..5de0bcc50d37 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -10,6 +10,7 @@ config EXT3_FS
 	select CRC16
 	select CRYPTO
 	select CRYPTO_CRC32C
+	select FS_ENCRYPTION_TRI if FS_ENCRYPTION
 	help
 	  This config option is here only for backward compatibility. ext3
 	  filesystem is now handled by the ext4 driver.
diff --git a/fs/f2fs/Kconfig b/fs/f2fs/Kconfig
index 652fd2e2b23d..9ccaec60af47 100644
--- a/fs/f2fs/Kconfig
+++ b/fs/f2fs/Kconfig
@@ -6,6 +6,7 @@ config F2FS_FS
 	select CRYPTO
 	select CRYPTO_CRC32
 	select F2FS_FS_XATTR if FS_ENCRYPTION
+	select FS_ENCRYPTION_TRI if FS_ENCRYPTION
 	help
 	  F2FS is based on Log-structured File System (LFS), which supports
 	  versatile "flash-friendly" features. The design has been focused on
diff --git a/fs/ubifs/Kconfig b/fs/ubifs/Kconfig
index 69932bcfa920..ea2d43829c18 100644
--- a/fs/ubifs/Kconfig
+++ b/fs/ubifs/Kconfig
@@ -12,6 +12,7 @@ config UBIFS_FS
 	select CRYPTO_ZSTD if UBIFS_FS_ZSTD
 	select CRYPTO_HASH_INFO
 	select UBIFS_FS_XATTR if FS_ENCRYPTION
+	select FS_ENCRYPTION_TRI if FS_ENCRYPTION
 	depends on MTD_UBI
 	help
 	  UBIFS is a file system for flash devices which works on top of UBI.
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 7b73ef7f902d..66249a98e003 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -164,6 +164,8 @@ void create_empty_buffers(struct page *, unsigned long,
 			unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
+extern void (*end_buffer_async_read_io)(struct buffer_head *bh, int uptodate);
+void end_buffer_async_read(struct buffer_head *bh, int uptodate);
 void end_buffer_async_write(struct buffer_head *bh, int uptodate);
 
 /* Things to do with buffers at mapping->private_list */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
