Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724B02606E1
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Sep 2020 00:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgIGWXm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Sep 2020 18:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgIGWXl (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Sep 2020 18:23:41 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C2F4215A4;
        Mon,  7 Sep 2020 22:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599517420;
        bh=Pao4NsJGj158+INc442LutV3UkAUffpThetfSRwJlm8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GOjvICHaaE1GyrJlCxMfbMuPlPP46n6ugcwDfu/sCesso3O2kYDTCKLE5GjgAG1K1
         G205SVk3bVh1QKiQRi3yOTrBuyAuzbdBHvcj7xqbCbFYWg5PTqxGTwQ4aRbQV2YfuP
         0qhk2GV32r+L3xdL/iEYhrUXiUB6acvpVr/gYVSQ=
Date:   Mon, 7 Sep 2020 15:23:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fscrypt: Reduce object size of logging messages
Message-ID: <20200907222338.GA68127@sol.localdomain>
References: <d9e2693cc157bbc09df92a91a9ecad8dcc8438ce.camel@perches.com>
 <20200904230341.GA6172@sol.localdomain>
 <ec1347522c95c89425b3189b071b35f9d912e3e0.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec1347522c95c89425b3189b071b35f9d912e3e0.camel@perches.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Sep 04, 2020 at 09:38:23PM -0700, Joe Perches wrote:
> > > diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> > > index 9212325763b0..c82cc3907e43 100644
> > > --- a/fs/crypto/crypto.c
> > > +++ b/fs/crypto/crypto.c
> > > @@ -329,25 +329,27 @@ int fscrypt_initialize(unsigned int cop_flags)
> > >  	return err;
> > >  }
> > >  
> > > -void fscrypt_msg(const struct inode *inode, const char *level,
> > > -		 const char *fmt, ...)
> > > +void fscrypt_printk(const struct inode *inode, const char *fmt, ...)
> > >  {
> > >  	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,
> > >  				      DEFAULT_RATELIMIT_BURST);
> > >  	struct va_format vaf;
> > >  	va_list args;
> > > +	int level;
> > >  
> > >  	if (!__ratelimit(&rs))
> > >  		return;
> > >  
> > >  	va_start(args, fmt);
> > > -	vaf.fmt = fmt;
> > > +	level = printk_get_level(fmt);
> > > +	vaf.fmt = printk_skip_level(fmt);
> > >  	vaf.va = &args;
> > >  	if (inode)
> > > -		printk("%sfscrypt (%s, inode %lu): %pV\n",
> > > -		       level, inode->i_sb->s_id, inode->i_ino, &vaf);
> > > +		printk("%c%cfscrypt (%s, inode %lu): %pV\n",
> > > +		       KERN_SOH_ASCII, level, inode->i_sb->s_id, inode->i_ino,
> > > +		       &vaf);
> > >  	else
> > > -		printk("%sfscrypt: %pV\n", level, &vaf);
> > > +		printk("%c%cfscrypt: %pV\n", KERN_SOH_ASCII, level, &vaf);
> > >  	va_end(args);
> > 
> > The problem with this approach is that if fscrypt_printk() is called without
> > providing a log level in the format string (which one would assume would work,
> > since printk() allows it), then the real format string will be truncated to just
> > KERN_SOH because 'level' will be 0.
> > Can you find a way to avoid that?
> 
> While I don't think this is a problem in that all the fscrypt_<level>
> calls will always prefix a KERN_<LEVEL>,

It's still a pitfall that people could run into later.  It would be better to
make fscrypt_printk() work in the expected way.

> what btrfs uses:
> 
> 	char lvl[PRINTK_MAX_SINGLE_HEADER_LEN + 1] = "\0";
> ...
> 	while ((kern_level = printk_get_level(fmt)) != 0) {
> 		size_t size = printk_skip_level(fmt) - fmt;
> 
> 		if (kern_level >= '0' && kern_level <= '7') {
> 			memcpy(lvl, fmt,  size);
> 			lvl[size] = '\0';
> 		}
> 		fmt += size;
> 	}
> 
> and use "%s...", lvl, ...
> 

Is the loop really needed?  How about just:

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 9212325763b0f..c5a87c2fe1020 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -329,11 +329,12 @@ int fscrypt_initialize(unsigned int cop_flags)
 	return err;
 }
 
-void fscrypt_msg(const struct inode *inode, const char *level,
-		 const char *fmt, ...)
+void fscrypt_printk(const struct inode *inode, const char *fmt, ...)
 {
 	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
+	const char *raw_fmt = printk_skip_level(fmt);
+	int hdr_len = raw_fmt - fmt;
 	struct va_format vaf;
 	va_list args;
 
@@ -341,13 +342,13 @@ void fscrypt_msg(const struct inode *inode, const char *level,
 		return;
 
 	va_start(args, fmt);
-	vaf.fmt = fmt;
+	vaf.fmt = raw_fmt;
 	vaf.va = &args;
 	if (inode)
-		printk("%sfscrypt (%s, inode %lu): %pV\n",
-		       level, inode->i_sb->s_id, inode->i_ino, &vaf);
+		printk("%.*sfscrypt (%s, inode %lu): %pV\n",
+		       hdr_len, fmt, inode->i_sb->s_id, inode->i_ino, &vaf);
 	else
-		printk("%sfscrypt: %pV\n", level, &vaf);
+		printk("%.*sfscrypt: %pV\n", hdr_len, fmt, &vaf);
 	va_end(args);
 }

> 
> > > -#define fscrypt_warn(inode, fmt, ...)		\
> > > -	fscrypt_msg((inode), KERN_WARNING, fmt, ##__VA_ARGS__)
> > > -#define fscrypt_err(inode, fmt, ...)		\
> > > -	fscrypt_msg((inode), KERN_ERR, fmt, ##__VA_ARGS__)
> > > +#define fscrypt_err(inode, fmt, ...)					\
> > > +	fscrypt_printk(inode, KERN_ERR fmt, ##__VA_ARGS__)
> > > +#define fscrypt_warn(inode, fmt, ...)					\
> > > +	fscrypt_printk(inode, KERN_WARNING fmt, ##__VA_ARGS__)
> > 
> > It's probably best to keep the parentheses around 'inode'.
> 
> Not really as it's an independent argument that can't
> effectively have any other purpose but to be an argument
> to the fsrypt_printk function.

True, but since forgetting to include parentheses around macro arguments is such
a common mistake, IMO they should just always be included so that people don't
have to think about whether the omission is correct or not.

- Eric
