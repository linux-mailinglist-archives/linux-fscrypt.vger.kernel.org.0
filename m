Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C9812FB16
	for <lists+linux-fscrypt@lfdr.de>; Fri,  3 Jan 2020 18:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgACRE5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 3 Jan 2020 12:04:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727912AbgACRE4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 3 Jan 2020 12:04:56 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F1B0206DB;
        Fri,  3 Jan 2020 17:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578071096;
        bh=m/EN5MLwJFCtJUWPR2Z3EwYPHIk+mvcgomL1P2CXfZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ro+HK4nG4yyPsOMDNcpscatDMXL1tDCqowctNrDPBSvGSCesA5yJO1XuJ1Ydq1RX/
         UE15DkTdx2VGXxAibCndRh2A1ZerIM1EeYpzOkyoo8N1PTRYTwxQJxucIaoPh2roJv
         zMyuZGda1fBZO7D03av4zgkmAjVY2wGjVfbJAu1A=
Date:   Fri, 3 Jan 2020 09:04:54 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [v4 PATCH] fscrypt: Allow modular crypto algorithms
Message-ID: <20200103170454.GM19521@gmail.com>
References: <20191221143020.hbgeixvlmzt7nh54@gondor.apana.org.au>
 <20191221234428.GA551@zzz.localdomain>
 <20191222084155.n4mbomsw6pl4c7kv@gondor.apana.org.au>
 <20191222164545.GA157733@zzz.localdomain>
 <20191223074623.you4ivf2yuxk4ad2@gondor.apana.org.au>
 <20191224223852.GA178036@zzz.localdomain>
 <20191227024700.7vrzuux32uyfdgum@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191227024700.7vrzuux32uyfdgum@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Dec 27, 2019 at 10:47:00AM +0800, Herbert Xu wrote:
> On Tue, Dec 24, 2019 at 04:38:52PM -0600, Eric Biggers wrote:
> > 
> > This needs to be under EXT4_FS, not EXT3_FS.  That should address the kbuild
> > test robot error.
> 
> Yes indeed.
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
> index ff5a1746cbae..02df95b44331 100644
> --- a/fs/crypto/Kconfig
> +++ b/fs/crypto/Kconfig
> @@ -2,13 +2,8 @@
>  config FS_ENCRYPTION
>  	bool "FS Encryption (Per-file encryption)"
>  	select CRYPTO
> -	select CRYPTO_AES
> -	select CRYPTO_CBC
> -	select CRYPTO_ECB
> -	select CRYPTO_XTS
> -	select CRYPTO_CTS
> -	select CRYPTO_SHA512
> -	select CRYPTO_HMAC
> +	select CRYPTO_HASH
> +	select CRYPTO_SKCIPHER
>  	select KEYS
>  	help
>  	  Enable encryption of files and directories.  This
> @@ -16,3 +11,15 @@ config FS_ENCRYPTION
>  	  efficient since it avoids caching the encrypted and
>  	  decrypted pages in the page cache.  Currently Ext4,
>  	  F2FS and UBIFS make use of this feature.
> +
> +# Filesystems supporting encryption must select this if FS_ENCRYPTION.  This
> +# allows the algorithms to be built as modules when all the filesystems are.
> +config FS_ENCRYPTION_ALGS
> +	tristate
> +	select CRYPTO_AES
> +	select CRYPTO_CBC
> +	select CRYPTO_CTS
> +	select CRYPTO_ECB
> +	select CRYPTO_HMAC
> +	select CRYPTO_SHA512
> +	select CRYPTO_XTS
> diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
> index ef42ab040905..db9bfa08d3e0 100644
> --- a/fs/ext4/Kconfig
> +++ b/fs/ext4/Kconfig
> @@ -39,6 +39,7 @@ config EXT4_FS
>  	select CRYPTO
>  	select CRYPTO_CRC32C
>  	select FS_IOMAP
> +	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
>  	help
>  	  This is the next generation of the ext3 filesystem.
>  
> diff --git a/fs/f2fs/Kconfig b/fs/f2fs/Kconfig
> index 652fd2e2b23d..599fb9194c6a 100644
> --- a/fs/f2fs/Kconfig
> +++ b/fs/f2fs/Kconfig
> @@ -6,6 +6,7 @@ config F2FS_FS
>  	select CRYPTO
>  	select CRYPTO_CRC32
>  	select F2FS_FS_XATTR if FS_ENCRYPTION
> +	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
>  	help
>  	  F2FS is based on Log-structured File System (LFS), which supports
>  	  versatile "flash-friendly" features. The design has been focused on
> diff --git a/fs/ubifs/Kconfig b/fs/ubifs/Kconfig
> index 69932bcfa920..45d3d207fb99 100644
> --- a/fs/ubifs/Kconfig
> +++ b/fs/ubifs/Kconfig
> @@ -12,6 +12,7 @@ config UBIFS_FS
>  	select CRYPTO_ZSTD if UBIFS_FS_ZSTD
>  	select CRYPTO_HASH_INFO
>  	select UBIFS_FS_XATTR if FS_ENCRYPTION
> +	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
>  	depends on MTD_UBI
>  	help
>  	  UBIFS is a file system for flash devices which works on top of UBI.
> 

Applied to fscrypt.git#master for 5.6.

- Eric
