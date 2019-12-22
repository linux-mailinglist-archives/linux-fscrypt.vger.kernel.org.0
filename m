Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E641A128EE9
	for <lists+linux-fscrypt@lfdr.de>; Sun, 22 Dec 2019 17:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfLVQpt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 22 Dec 2019 11:45:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbfLVQpt (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 22 Dec 2019 11:45:49 -0500
Received: from zzz.localdomain (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD96F206D3;
        Sun, 22 Dec 2019 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577033148;
        bh=Jb1ShKcDyr+7GrlrbaN9KEkTJcpeAmVUdwzduV45FxU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pQqH0q+VSvb0A1sObtgdoYDMaCSuPoZqLqLcrXc35C8aQmYF9tq838Fm1Q5utPKSV
         QFGERRKCU6E+r6wdghLv4HmbsFqjccLpWC2I27t2Ae9bKEbiVuMxA7c7UhZhnlVMi0
         k7Fyu7QswYPxjAfxA1LHlpCa1dNuqcW0NdFXleuc=
Date:   Sun, 22 Dec 2019 10:45:45 -0600
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [v2 PATCH] fscrypt: Allow modular crypto algorithms
Message-ID: <20191222164545.GA157733@zzz.localdomain>
References: <20191221143020.hbgeixvlmzt7nh54@gondor.apana.org.au>
 <20191221234428.GA551@zzz.localdomain>
 <20191222084155.n4mbomsw6pl4c7kv@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191222084155.n4mbomsw6pl4c7kv@gondor.apana.org.au>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Dec 22, 2019 at 04:41:55PM +0800, Herbert Xu wrote:
> On Sat, Dec 21, 2019 at 05:44:28PM -0600, Eric Biggers wrote:
> >
> > I'm not sure this is a good idea, since there will probably need to be more
> > places where built-in code calls into fs/crypto/ too.
> 
> Clearly it's going to be too much trouble for now.  I may revisit
> this once the fscrypt code has settled down a little.
> 
> However, we can at least build the algorithms as modules, like this:
> 
> ---8<---
> The commit 643fa9612bf1 ("fscrypt: remove filesystem specific
> build config option") removed modular support for fs/crypto.  This
> causes the Crypto API to be built-in whenever fscrypt is enabled.
> This makes it very difficult for me to test modular builds of
> the Crypto API without disabling fscrypt which is a pain.
> 
> As fscrypt is still evolving and it's developing new ties with the
> fs layer, it's hard to build it as a module for now.
> 
> However, the actual algorithms are not required until a filesystem
> is mounted.  Therefore we can allow them to be built as modules.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> index ff5a1746cbae..ae929fbc0f29 100644
> --- a/fs/crypto/Kconfig
> +++ b/fs/crypto/Kconfig
> @@ -1,7 +1,19 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config FS_ENCRYPTION
>  	bool "FS Encryption (Per-file encryption)"
> +	select KEYS
>  	select CRYPTO
> +	select CRYPTO_SKCIPHER
> +	select CRYPTO_HASH
> +	help
> +	  Enable encryption of files and directories.  This
> +	  feature is similar to ecryptfs, but it is more memory
> +	  efficient since it avoids caching the encrypted and
> +	  decrypted pages in the page cache.  Currently Ext4,
> +	  F2FS and UBIFS make use of this feature.
> +
> +config FS_ENCRYPTION_TRI
> +	tristate
>  	select CRYPTO_AES
>  	select CRYPTO_CBC
>  	select CRYPTO_ECB
> @@ -9,10 +21,3 @@ config FS_ENCRYPTION
>  	select CRYPTO_CTS
>  	select CRYPTO_SHA512
>  	select CRYPTO_HMAC
> -	select KEYS
> -	help
> -	  Enable encryption of files and directories.  This
> -	  feature is similar to ecryptfs, but it is more memory
> -	  efficient since it avoids caching the encrypted and
> -	  decrypted pages in the page cache.  Currently Ext4,
> -	  F2FS and UBIFS make use of this feature.
> diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
> index ef42ab040905..5de0bcc50d37 100644
> --- a/fs/ext4/Kconfig
> +++ b/fs/ext4/Kconfig
> @@ -10,6 +10,7 @@ config EXT3_FS
>  	select CRC16
>  	select CRYPTO
>  	select CRYPTO_CRC32C
> +	select FS_ENCRYPTION_TRI if FS_ENCRYPTION
>  	help
>  	  This config option is here only for backward compatibility. ext3
>  	  filesystem is now handled by the ext4 driver.
> diff --git a/fs/f2fs/Kconfig b/fs/f2fs/Kconfig
> index 652fd2e2b23d..9ccaec60af47 100644
> --- a/fs/f2fs/Kconfig
> +++ b/fs/f2fs/Kconfig
> @@ -6,6 +6,7 @@ config F2FS_FS
>  	select CRYPTO
>  	select CRYPTO_CRC32
>  	select F2FS_FS_XATTR if FS_ENCRYPTION
> +	select FS_ENCRYPTION_TRI if FS_ENCRYPTION
>  	help
>  	  F2FS is based on Log-structured File System (LFS), which supports
>  	  versatile "flash-friendly" features. The design has been focused on
> diff --git a/fs/ubifs/Kconfig b/fs/ubifs/Kconfig
> index 69932bcfa920..ea2d43829c18 100644
> --- a/fs/ubifs/Kconfig
> +++ b/fs/ubifs/Kconfig
> @@ -12,6 +12,7 @@ config UBIFS_FS
>  	select CRYPTO_ZSTD if UBIFS_FS_ZSTD
>  	select CRYPTO_HASH_INFO
>  	select UBIFS_FS_XATTR if FS_ENCRYPTION
> +	select FS_ENCRYPTION_TRI if FS_ENCRYPTION
>  	depends on MTD_UBI
>  	help
>  	  UBIFS is a file system for flash devices which works on top of UBI.

Okay, this approach looks fine.  But can you rename the option to something more
self-explanatory like FS_ENCRYPTION_ALGS, and add a comment?  Like:

# Filesystems supporting encryption must select this if FS_ENCRYPTION.  This
# allows the algorithms to be built as modules when all the filesystems are.
config FS_ENCRYPTION_ALGS
	tristate
	select CRYPTO_AES
	select CRYPTO_CBC
	select CRYPTO_ECB
	select CRYPTO_XTS
	select CRYPTO_CTS
	select CRYPTO_SHA512
	select CRYPTO_HMAC
