Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9931423D6
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Jan 2020 07:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgATGyZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Jan 2020 01:54:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgATGyZ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Jan 2020 01:54:25 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6811F2073D;
        Mon, 20 Jan 2020 06:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579503264;
        bh=3/g8O0L8/HHyUM7mzXuzKScJszx17sO0OT6iedMCQbY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Occ+eKdYD75/B0vY5B8dPtboth69kxcmqdb2JLdJfROsBnMGeKyITZlIB9awuY89K
         KQZYwiWpREBVfe06v6ipryJId0Yd/UXeOZFkyWeO/P8Ch6xhbBjbuVhTsehCJbJCqC
         mtRjU2mVA2Mghajjr+xVlGKp6LibusrEYHO2AHRg=
Date:   Sun, 19 Jan 2020 22:54:22 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Richard Weinberger <richard.weinberger@gmail.com>
Cc:     Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        linux-fscrypt@vger.kernel.org,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] ubifs: use IS_ENCRYPTED() instead of
 ubifs_crypt_is_encrypted()
Message-ID: <20200120065422.GA976@sol.localdomain>
References: <20191209212721.244396-1-ebiggers@kernel.org>
 <20200103170927.GO19521@gmail.com>
 <CAFLxGvwA6y2+Azm1Xc+-cz1N_jjJXY3uZBVDqGGLvc6GMcb5JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvwA6y2+Azm1Xc+-cz1N_jjJXY3uZBVDqGGLvc6GMcb5JA@mail.gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jan 09, 2020 at 09:01:09AM +0100, Richard Weinberger wrote:
> On Fri, Jan 3, 2020 at 6:09 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Mon, Dec 09, 2019 at 01:27:21PM -0800, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > There's no need for the ubifs_crypt_is_encrypted() function anymore.
> > > Just use IS_ENCRYPTED() instead, like ext4 and f2fs do.  IS_ENCRYPTED()
> > > checks the VFS-level flag instead of the UBIFS-specific flag, but it
> > > shouldn't change any behavior since the flags are kept in sync.
> > >
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> > >  fs/ubifs/dir.c     | 8 ++++----
> > >  fs/ubifs/file.c    | 4 ++--
> > >  fs/ubifs/journal.c | 6 +++---
> > >  fs/ubifs/ubifs.h   | 7 -------
> > >  4 files changed, 9 insertions(+), 16 deletions(-)
> >
> > Richard, can you consider applying this to the UBIFS tree for 5.6?
> 
> Sure. I'm back from the x-mas break and start collecting patches.
> 

Ping?  I see the other UBIFS patches I sent in linux-ubifs.git#linux-next,
but not this one.

- Eric
