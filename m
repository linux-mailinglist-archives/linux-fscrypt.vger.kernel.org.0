Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C04312B0BA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 27 Dec 2019 03:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfL0CrI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 26 Dec 2019 21:47:08 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:51058 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727002AbfL0CrH (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 26 Dec 2019 21:47:07 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ikfeZ-0002ni-4M; Fri, 27 Dec 2019 10:47:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ikfeW-0003Ko-Ai; Fri, 27 Dec 2019 10:47:00 +0800
Date:   Fri, 27 Dec 2019 10:47:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fscrypt@vger.kernel.org
Subject: [v4 PATCH] fscrypt: Allow modular crypto algorithms
Message-ID: <20191227024700.7vrzuux32uyfdgum@gondor.apana.org.au>
References: <20191221143020.hbgeixvlmzt7nh54@gondor.apana.org.au>
 <20191221234428.GA551@zzz.localdomain>
 <20191222084155.n4mbomsw6pl4c7kv@gondor.apana.org.au>
 <20191222164545.GA157733@zzz.localdomain>
 <20191223074623.you4ivf2yuxk4ad2@gondor.apana.org.au>
 <20191224223852.GA178036@zzz.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224223852.GA178036@zzz.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 24, 2019 at 04:38:52PM -0600, Eric Biggers wrote:
> 
> This needs to be under EXT4_FS, not EXT3_FS.  That should address the kbuild
> test robot error.

Yes indeed.

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
index ff5a1746cbae..02df95b44331 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -2,13 +2,8 @@
 config FS_ENCRYPTION
 	bool "FS Encryption (Per-file encryption)"
 	select CRYPTO
-	select CRYPTO_AES
-	select CRYPTO_CBC
-	select CRYPTO_ECB
-	select CRYPTO_XTS
-	select CRYPTO_CTS
-	select CRYPTO_SHA512
-	select CRYPTO_HMAC
+	select CRYPTO_HASH
+	select CRYPTO_SKCIPHER
 	select KEYS
 	help
 	  Enable encryption of files and directories.  This
@@ -16,3 +11,15 @@ config FS_ENCRYPTION
 	  efficient since it avoids caching the encrypted and
 	  decrypted pages in the page cache.  Currently Ext4,
 	  F2FS and UBIFS make use of this feature.
+
+# Filesystems supporting encryption must select this if FS_ENCRYPTION.  This
+# allows the algorithms to be built as modules when all the filesystems are.
+config FS_ENCRYPTION_ALGS
+	tristate
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_CTS
+	select CRYPTO_ECB
+	select CRYPTO_HMAC
+	select CRYPTO_SHA512
+	select CRYPTO_XTS
diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index ef42ab040905..db9bfa08d3e0 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -39,6 +39,7 @@ config EXT4_FS
 	select CRYPTO
 	select CRYPTO_CRC32C
 	select FS_IOMAP
+	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
 	help
 	  This is the next generation of the ext3 filesystem.
 
diff --git a/fs/f2fs/Kconfig b/fs/f2fs/Kconfig
index 652fd2e2b23d..599fb9194c6a 100644
--- a/fs/f2fs/Kconfig
+++ b/fs/f2fs/Kconfig
@@ -6,6 +6,7 @@ config F2FS_FS
 	select CRYPTO
 	select CRYPTO_CRC32
 	select F2FS_FS_XATTR if FS_ENCRYPTION
+	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
 	help
 	  F2FS is based on Log-structured File System (LFS), which supports
 	  versatile "flash-friendly" features. The design has been focused on
diff --git a/fs/ubifs/Kconfig b/fs/ubifs/Kconfig
index 69932bcfa920..45d3d207fb99 100644
--- a/fs/ubifs/Kconfig
+++ b/fs/ubifs/Kconfig
@@ -12,6 +12,7 @@ config UBIFS_FS
 	select CRYPTO_ZSTD if UBIFS_FS_ZSTD
 	select CRYPTO_HASH_INFO
 	select UBIFS_FS_XATTR if FS_ENCRYPTION
+	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
 	depends on MTD_UBI
 	help
 	  UBIFS is a file system for flash devices which works on top of UBI.

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
