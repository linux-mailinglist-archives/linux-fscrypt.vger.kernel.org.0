Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFADF25E588
	for <lists+linux-fscrypt@lfdr.de>; Sat,  5 Sep 2020 06:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgIEEi3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 5 Sep 2020 00:38:29 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:49606 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725554AbgIEEi3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 5 Sep 2020 00:38:29 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 730342478;
        Sat,  5 Sep 2020 04:38:26 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2693:2828:2910:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4117:4321:4559:4605:5007:6119:7903:8603:9108:10004:10848:11026:11232:11473:11658:11914:12043:12296:12297:12438:12555:12740:12760:12895:12986:13439:14659:21080:21212:21324:21433:21451:21611:21627:21660:21740:21939:21990:30054:30056:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: cart87_5d0b864270b8
X-Filterd-Recvd-Size: 6212
Received: from XPS-9350 (cpe-23-242-83-182.socal.res.rr.com [23.242.83.182])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Sat,  5 Sep 2020 04:38:25 +0000 (UTC)
Message-ID: <ec1347522c95c89425b3189b071b35f9d912e3e0.camel@perches.com>
Subject: Re: [PATCH] fscrypt: Reduce object size of logging messages
From:   Joe Perches <joe@perches.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date:   Fri, 04 Sep 2020 21:38:23 -0700
In-Reply-To: <20200904230341.GA6172@sol.localdomain>
References: <d9e2693cc157bbc09df92a91a9ecad8dcc8438ce.camel@perches.com>
         <20200904230341.GA6172@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 2020-09-04 at 16:03 -0700, Eric Biggers wrote:
> On Fri, Sep 04, 2020 at 03:10:15PM -0700, Joe Perches wrote:
> > Reduce the object size of logging messages by removing the
> > separate KERN_LEVEL argument and adding it to the format.
> > 
> > Miscellanea:
> > 
> > o Rename fscypt_msg to fscrypt_printk
> > 
> > x86-64 defconfig with fscrypto:
> > 
> > Original sizes:
> > $ size fs/crypto/built-in.a -t
> >    text	   data	    bss	    dec	    hex	filename
> >    3815	    300	     24	   4139	   102b	fs/crypto/crypto.o (ex fs/crypto/built-in.a)
> >    4354	     84	      0	   4438	   1156	fs/crypto/fname.o (ex fs/crypto/built-in.a)
> >    1484	     24	      0	   1508	    5e4	fs/crypto/hkdf.o (ex fs/crypto/built-in.a)
> >    2910	     68	      0	   2978	    ba2	fs/crypto/hooks.o (ex fs/crypto/built-in.a)
> >    7797	    664	     65	   8526	   214e	fs/crypto/keyring.o (ex fs/crypto/built-in.a)
> >    5005	    493	      0	   5498	   157a	fs/crypto/keysetup.o (ex fs/crypto/built-in.a)
> >    2805	      0	    544	   3349	    d15	fs/crypto/keysetup_v1.o (ex fs/crypto/built-in.a)
> >    6391	     90	      0	   6481	   1951	fs/crypto/policy.o (ex fs/crypto/built-in.a)
> >    1369	     40	      0	   1409	    581	fs/crypto/bio.o (ex fs/crypto/built-in.a)
> >   35930	   1763	    633	  38326	   95b6	(TOTALS)
> > 
> > New sizes:
> > $ size fs/crypto/built-in.a -t
> >    text	   data	    bss	    dec	    hex	filename
> >    3874	    300	     24	   4198	   1066	fs/crypto/crypto.o (ex fs/crypto/built-in.a)
> >    4347	     84	      0	   4431	   114f	fs/crypto/fname.o (ex fs/crypto/built-in.a)
> >    1476	     24	      0	   1500	    5dc	fs/crypto/hkdf.o (ex fs/crypto/built-in.a)
> >    2902	     68	      0	   2970	    b9a	fs/crypto/hooks.o (ex fs/crypto/built-in.a)
> >    7781	    664	     65	   8510	   213e	fs/crypto/keyring.o (ex fs/crypto/built-in.a)
> >    4961	    493	      0	   5454	   154e	fs/crypto/keysetup.o (ex fs/crypto/built-in.a)
> >    2790	      0	    544	   3334	    d06	fs/crypto/keysetup_v1.o (ex fs/crypto/built-in.a)
> >    6306	     90	      0	   6396	   18fc	fs/crypto/policy.o (ex fs/crypto/built-in.a)
> >    1369	     40	      0	   1409	    581	fs/crypto/bio.o (ex fs/crypto/built-in.a)
> >   35806	   1763	    633	  38202	   953a	(TOTALS)
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  fs/crypto/crypto.c          | 14 ++++++++------
> >  fs/crypto/fscrypt_private.h | 12 ++++++------
> >  2 files changed, 14 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> > index 9212325763b0..c82cc3907e43 100644
> > --- a/fs/crypto/crypto.c
> > +++ b/fs/crypto/crypto.c
> > @@ -329,25 +329,27 @@ int fscrypt_initialize(unsigned int cop_flags)
> >  	return err;
> >  }
> >  
> > -void fscrypt_msg(const struct inode *inode, const char *level,
> > -		 const char *fmt, ...)
> > +void fscrypt_printk(const struct inode *inode, const char *fmt, ...)
> >  {
> >  	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,
> >  				      DEFAULT_RATELIMIT_BURST);
> >  	struct va_format vaf;
> >  	va_list args;
> > +	int level;
> >  
> >  	if (!__ratelimit(&rs))
> >  		return;
> >  
> >  	va_start(args, fmt);
> > -	vaf.fmt = fmt;
> > +	level = printk_get_level(fmt);
> > +	vaf.fmt = printk_skip_level(fmt);
> >  	vaf.va = &args;
> >  	if (inode)
> > -		printk("%sfscrypt (%s, inode %lu): %pV\n",
> > -		       level, inode->i_sb->s_id, inode->i_ino, &vaf);
> > +		printk("%c%cfscrypt (%s, inode %lu): %pV\n",
> > +		       KERN_SOH_ASCII, level, inode->i_sb->s_id, inode->i_ino,
> > +		       &vaf);
> >  	else
> > -		printk("%sfscrypt: %pV\n", level, &vaf);
> > +		printk("%c%cfscrypt: %pV\n", KERN_SOH_ASCII, level, &vaf);
> >  	va_end(args);
> 
> The problem with this approach is that if fscrypt_printk() is called without
> providing a log level in the format string (which one would assume would work,
> since printk() allows it), then the real format string will be truncated to just
> KERN_SOH because 'level' will be 0.
> Can you find a way to avoid that?

While I don't think this is a problem in that all the fscrypt_<level>
calls will always prefix a KERN_<LEVEL>, another approach is to use
what btrfs uses:

	char lvl[PRINTK_MAX_SINGLE_HEADER_LEN + 1] = "\0";
...
	while ((kern_level = printk_get_level(fmt)) != 0) {
		size_t size = printk_skip_level(fmt) - fmt;

		if (kern_level >= '0' && kern_level <= '7') {
			memcpy(lvl, fmt,  size);
			lvl[size] = '\0';
		}
		fmt += size;
	}

and use "%s...", lvl, ...


> > -#define fscrypt_warn(inode, fmt, ...)		\
> > -	fscrypt_msg((inode), KERN_WARNING, fmt, ##__VA_ARGS__)
> > -#define fscrypt_err(inode, fmt, ...)		\
> > -	fscrypt_msg((inode), KERN_ERR, fmt, ##__VA_ARGS__)
> > +#define fscrypt_err(inode, fmt, ...)					\
> > +	fscrypt_printk(inode, KERN_ERR fmt, ##__VA_ARGS__)
> > +#define fscrypt_warn(inode, fmt, ...)					\
> > +	fscrypt_printk(inode, KERN_WARNING fmt, ##__VA_ARGS__)
> 
> It's probably best to keep the parentheses around 'inode'.

Not really as it's an independent argument that can't
effectively have any other purpose but to be an argument
to the fsrypt_printk function.


