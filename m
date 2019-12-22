Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB8D128D3B
	for <lists+linux-fscrypt@lfdr.de>; Sun, 22 Dec 2019 09:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfLVImF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 22 Dec 2019 03:42:05 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:43684 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfLVImF (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 22 Dec 2019 03:42:05 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iiwoJ-00026b-5h; Sun, 22 Dec 2019 16:41:59 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iiwoF-0002uQ-JV; Sun, 22 Dec 2019 16:41:55 +0800
Date:   Sun, 22 Dec 2019 16:41:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fscrypt@vger.kernel.org
Subject: [v2 PATCH] fscrypt: Allow modular crypto algorithms
Message-ID: <20191222084155.n4mbomsw6pl4c7kv@gondor.apana.org.au>
References: <20191221143020.hbgeixvlmzt7nh54@gondor.apana.org.au>
 <20191221234428.GA551@zzz.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191221234428.GA551@zzz.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Dec 21, 2019 at 05:44:28PM -0600, Eric Biggers wrote:
>
> I'm not sure this is a good idea, since there will probably need to be more
> places where built-in code calls into fs/crypto/ too.

Clearly it's going to be too much trouble for now.  I may revisit
this once the fscrypt code has settled down a little.

However, we can at least build the algorithms as modules, like this:

---8<---
The commit 643fa9612bf1 ("fscrypt: remove filesystem specific
build config option") removed modular support for fs/crypto.  This
causes the Crypto API to be built-in whenever fscrypt is enabled.
This makes it very difficult for me to test modular builds of
the Crypto API without disabling fscrypt which is a pain.

As fscrypt is still evolving and it's developing new ties with the
fs layer, it's hard to build it as a module for now.

However, the actual algorithms are not required until a filesystem
is mounted.  Therefore we can allow them to be built as modules.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index ff5a1746cbae..ae929fbc0f29 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -1,7 +1,19 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config FS_ENCRYPTION
 	bool "FS Encryption (Per-file encryption)"
+	select KEYS
 	select CRYPTO
+	select CRYPTO_SKCIPHER
+	select CRYPTO_HASH
+	help
+	  Enable encryption of files and directories.  This
+	  feature is similar to ecryptfs, but it is more memory
+	  efficient since it avoids caching the encrypted and
+	  decrypted pages in the page cache.  Currently Ext4,
+	  F2FS and UBIFS make use of this feature.
+
+config FS_ENCRYPTION_TRI
+	tristate
 	select CRYPTO_AES
 	select CRYPTO_CBC
 	select CRYPTO_ECB
@@ -9,10 +21,3 @@ config FS_ENCRYPTION
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
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
