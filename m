Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F83625E3ED
	for <lists+linux-fscrypt@lfdr.de>; Sat,  5 Sep 2020 01:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgIDXDo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Sep 2020 19:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgIDXDo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Sep 2020 19:03:44 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF92B2078E;
        Fri,  4 Sep 2020 23:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599260622;
        bh=1rEb6oJ/Q9tioEm7DsXCupEdYTkjmI5hngC5BIXq3hY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aqt8lZtOvNKJeAA/aMCLl+iX0KV/RJSYfz0u8633/pYvvrmYgBQQyyGWjl3ICqmW5
         HQVf14BQD38DUv1Vtj1flsEsam5Nf3RS1zTSk/wT5sBwhjjL2ogmCEoLOhcYGewmu5
         m30TVebSdsadE9hP5TwtCazv7F/gCafG4Yw2VzBI=
Date:   Fri, 4 Sep 2020 16:03:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fscrypt: Reduce object size of logging messages
Message-ID: <20200904230341.GA6172@sol.localdomain>
References: <d9e2693cc157bbc09df92a91a9ecad8dcc8438ce.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9e2693cc157bbc09df92a91a9ecad8dcc8438ce.camel@perches.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Sep 04, 2020 at 03:10:15PM -0700, Joe Perches wrote:
> Reduce the object size of logging messages by removing the
> separate KERN_LEVEL argument and adding it to the format.
> 
> Miscellanea:
> 
> o Rename fscypt_msg to fscrypt_printk
> 
> x86-64 defconfig with fscrypto:
> 
> Original sizes:
> $ size fs/crypto/built-in.a -t
>    text	   data	    bss	    dec	    hex	filename
>    3815	    300	     24	   4139	   102b	fs/crypto/crypto.o (ex fs/crypto/built-in.a)
>    4354	     84	      0	   4438	   1156	fs/crypto/fname.o (ex fs/crypto/built-in.a)
>    1484	     24	      0	   1508	    5e4	fs/crypto/hkdf.o (ex fs/crypto/built-in.a)
>    2910	     68	      0	   2978	    ba2	fs/crypto/hooks.o (ex fs/crypto/built-in.a)
>    7797	    664	     65	   8526	   214e	fs/crypto/keyring.o (ex fs/crypto/built-in.a)
>    5005	    493	      0	   5498	   157a	fs/crypto/keysetup.o (ex fs/crypto/built-in.a)
>    2805	      0	    544	   3349	    d15	fs/crypto/keysetup_v1.o (ex fs/crypto/built-in.a)
>    6391	     90	      0	   6481	   1951	fs/crypto/policy.o (ex fs/crypto/built-in.a)
>    1369	     40	      0	   1409	    581	fs/crypto/bio.o (ex fs/crypto/built-in.a)
>   35930	   1763	    633	  38326	   95b6	(TOTALS)
> 
> New sizes:
> $ size fs/crypto/built-in.a -t
>    text	   data	    bss	    dec	    hex	filename
>    3874	    300	     24	   4198	   1066	fs/crypto/crypto.o (ex fs/crypto/built-in.a)
>    4347	     84	      0	   4431	   114f	fs/crypto/fname.o (ex fs/crypto/built-in.a)
>    1476	     24	      0	   1500	    5dc	fs/crypto/hkdf.o (ex fs/crypto/built-in.a)
>    2902	     68	      0	   2970	    b9a	fs/crypto/hooks.o (ex fs/crypto/built-in.a)
>    7781	    664	     65	   8510	   213e	fs/crypto/keyring.o (ex fs/crypto/built-in.a)
>    4961	    493	      0	   5454	   154e	fs/crypto/keysetup.o (ex fs/crypto/built-in.a)
>    2790	      0	    544	   3334	    d06	fs/crypto/keysetup_v1.o (ex fs/crypto/built-in.a)
>    6306	     90	      0	   6396	   18fc	fs/crypto/policy.o (ex fs/crypto/built-in.a)
>    1369	     40	      0	   1409	    581	fs/crypto/bio.o (ex fs/crypto/built-in.a)
>   35806	   1763	    633	  38202	   953a	(TOTALS)
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/crypto/crypto.c          | 14 ++++++++------
>  fs/crypto/fscrypt_private.h | 12 ++++++------
>  2 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index 9212325763b0..c82cc3907e43 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -329,25 +329,27 @@ int fscrypt_initialize(unsigned int cop_flags)
>  	return err;
>  }
>  
> -void fscrypt_msg(const struct inode *inode, const char *level,
> -		 const char *fmt, ...)
> +void fscrypt_printk(const struct inode *inode, const char *fmt, ...)
>  {
>  	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,
>  				      DEFAULT_RATELIMIT_BURST);
>  	struct va_format vaf;
>  	va_list args;
> +	int level;
>  
>  	if (!__ratelimit(&rs))
>  		return;
>  
>  	va_start(args, fmt);
> -	vaf.fmt = fmt;
> +	level = printk_get_level(fmt);
> +	vaf.fmt = printk_skip_level(fmt);
>  	vaf.va = &args;
>  	if (inode)
> -		printk("%sfscrypt (%s, inode %lu): %pV\n",
> -		       level, inode->i_sb->s_id, inode->i_ino, &vaf);
> +		printk("%c%cfscrypt (%s, inode %lu): %pV\n",
> +		       KERN_SOH_ASCII, level, inode->i_sb->s_id, inode->i_ino,
> +		       &vaf);
>  	else
> -		printk("%sfscrypt: %pV\n", level, &vaf);
> +		printk("%c%cfscrypt: %pV\n", KERN_SOH_ASCII, level, &vaf);
>  	va_end(args);

The problem with this approach is that if fscrypt_printk() is called without
providing a log level in the format string (which one would assume would work,
since printk() allows it), then the real format string will be truncated to just
KERN_SOH because 'level' will be 0.

Can you find a way to avoid that?

> -#define fscrypt_warn(inode, fmt, ...)		\
> -	fscrypt_msg((inode), KERN_WARNING, fmt, ##__VA_ARGS__)
> -#define fscrypt_err(inode, fmt, ...)		\
> -	fscrypt_msg((inode), KERN_ERR, fmt, ##__VA_ARGS__)
> +#define fscrypt_err(inode, fmt, ...)					\
> +	fscrypt_printk(inode, KERN_ERR fmt, ##__VA_ARGS__)
> +#define fscrypt_warn(inode, fmt, ...)					\
> +	fscrypt_printk(inode, KERN_WARNING fmt, ##__VA_ARGS__)

It's probably best to keep the parentheses around 'inode'.

- Eric
