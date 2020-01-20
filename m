Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B71B61431CC
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Jan 2020 19:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgATSr1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Jan 2020 13:47:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgATSr0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Jan 2020 13:47:26 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 512DF22527;
        Mon, 20 Jan 2020 18:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579546046;
        bh=OTFRQhfPut/J4I3VCk7tAM12sQ+tDDYC3vUdMIRPwZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sHbm3oSrbqC4caH/FoWY2eVqVBDAFNprJD/wuDn4cztRHfqVdoBnmoTK9lzci+4bw
         IwRRPYlwCgnWiTbnM09n7zRP/pePGaocppmiSag3qO9exq8Rr9NxewAjoF+iAFarsV
         LpB1K5mRj1TAD687fJBIAts+i7yAqMSAxfBNdglg=
Date:   Mon, 20 Jan 2020 10:47:24 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Richard Weinberger <richard@nod.at>
Cc:     linux-mtd <linux-mtd@lists.infradead.org>,
        linux-fscrypt <linux-fscrypt@vger.kernel.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: Re: [PATCH] ubifs: use IS_ENCRYPTED() instead of
 ubifs_crypt_is_encrypted()
Message-ID: <20200120184724.GA4118@sol.localdomain>
References: <20191209212721.244396-1-ebiggers@kernel.org>
 <20200103170927.GO19521@gmail.com>
 <CAFLxGvwA6y2+Azm1Xc+-cz1N_jjJXY3uZBVDqGGLvc6GMcb5JA@mail.gmail.com>
 <20200120065422.GA976@sol.localdomain>
 <397871241.24589.1579513469565.JavaMail.zimbra@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <397871241.24589.1579513469565.JavaMail.zimbra@nod.at>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 20, 2020 at 10:44:29AM +0100, Richard Weinberger wrote:
> 
> ----- Ursprüngliche Mail -----
> > Von: "Eric Biggers" <ebiggers@kernel.org>
> > An: "Richard Weinberger" <richard.weinberger@gmail.com>
> > CC: "richard" <richard@nod.at>, "linux-mtd" <linux-mtd@lists.infradead.org>, "linux-fscrypt"
> > <linux-fscrypt@vger.kernel.org>, "Chandan Rajendra" <chandan@linux.vnet.ibm.com>
> > Gesendet: Montag, 20. Januar 2020 07:54:22
> > Betreff: Re: [PATCH] ubifs: use IS_ENCRYPTED() instead of ubifs_crypt_is_encrypted()
> 
> > On Thu, Jan 09, 2020 at 09:01:09AM +0100, Richard Weinberger wrote:
> >> On Fri, Jan 3, 2020 at 6:09 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >> >
> >> > On Mon, Dec 09, 2019 at 01:27:21PM -0800, Eric Biggers wrote:
> >> > > From: Eric Biggers <ebiggers@google.com>
> >> > >
> >> > > There's no need for the ubifs_crypt_is_encrypted() function anymore.
> >> > > Just use IS_ENCRYPTED() instead, like ext4 and f2fs do.  IS_ENCRYPTED()
> >> > > checks the VFS-level flag instead of the UBIFS-specific flag, but it
> >> > > shouldn't change any behavior since the flags are kept in sync.
> >> > >
> >> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> >> > > ---
> >> > >  fs/ubifs/dir.c     | 8 ++++----
> >> > >  fs/ubifs/file.c    | 4 ++--
> >> > >  fs/ubifs/journal.c | 6 +++---
> >> > >  fs/ubifs/ubifs.h   | 7 -------
> >> > >  4 files changed, 9 insertions(+), 16 deletions(-)
> >> >
> >> > Richard, can you consider applying this to the UBIFS tree for 5.6?
> >> 
> >> Sure. I'm back from the x-mas break and start collecting patches.
> >> 
> > 
> > Ping?  I see the other UBIFS patches I sent in linux-ubifs.git#linux-next,
> > but not this one.
> 
> Oh dear, I reviewed but forgot to apply it. Now I'm already traveling without my
> kernel.org PGP keys.
> 
> The patch is simple and sane, so I'm totally fine if you carry it via fscrypt.
> Another option is that Miquel carries it via MTD this time.
> 
> In any case:
> 
> Acked-by: Richard Weinberger <richard@nod.at>
> 
> Sorry for messing this up. :-(
> 

I just went ahead and applied it to the fscrypt tree with your Acked-by, since
it doesn't conflict with anything in the UBIFS tree.  Thanks,

- Eric
