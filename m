Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A671C1179A8
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 23:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfLIWs7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 17:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:47714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfLIWs7 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 17:48:59 -0500
Received: from localhost (unknown [104.132.0.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B30B206E0;
        Mon,  9 Dec 2019 22:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575931738;
        bh=vH/farJSG9hZlw716Zi6z129RFHZDQbeYF7NgRiLsNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m2OuwtQVogLLsogmcxJG4JtV7InjbGD1Bfo85gKPBONLaJs02fww+Yx/uZUV8UcqM
         VrcMJr9GuaK8C0gxNcijjyJncvI6T3r8Soq2BdetO55jVSvDK9kwZ/q2+xJnELZj8x
         a/mRBEyRkThfDm9iC4DjUlSLoriKTfZIlvPwboRQ=
Date:   Mon, 9 Dec 2019 14:48:57 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] f2fs: don't keep META_MAPPING pages used for moving
 verity file blocks
Message-ID: <20191209224857.GC798@jaegeuk-macbookpro.roam.corp.google.com>
References: <20191209200055.204040-1-ebiggers@kernel.org>
 <20191209222828.GA798@jaegeuk-macbookpro.roam.corp.google.com>
 <20191209224051.GF149190@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209224051.GF149190@gmail.com>
User-Agent: Mutt/1.8.2 (2017-04-18)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 12/09, Eric Biggers wrote:
> On Mon, Dec 09, 2019 at 02:28:28PM -0800, Jaegeuk Kim wrote:
> > On 12/09, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > META_MAPPING is used to move blocks for both encrypted and verity files.
> > > So the META_MAPPING invalidation condition in do_checkpoint() should
> > > consider verity too, not just encrypt.
> > > 
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> > >  fs/f2fs/checkpoint.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > > index ffdaba0c55d29..44e84ac5c9411 100644
> > > --- a/fs/f2fs/checkpoint.c
> > > +++ b/fs/f2fs/checkpoint.c
> > > @@ -1509,10 +1509,10 @@ static int do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
> > >  	f2fs_wait_on_all_pages_writeback(sbi);
> > >  
> > >  	/*
> > > -	 * invalidate intermediate page cache borrowed from meta inode
> > > -	 * which are used for migration of encrypted inode's blocks.
> > > +	 * invalidate intermediate page cache borrowed from meta inode which are
> > > +	 * used for migration of encrypted or verity inode's blocks.
> > >  	 */
> > > -	if (f2fs_sb_has_encrypt(sbi))
> > > +	if (f2fs_sb_has_encrypt(sbi) || f2fs_sb_has_verity(sbi))
> > 
> > Do we need f2fs_post_read_required() aligned to the condition of
> > move_data_block()?
> > 
> 
> I think you're asking why verity files have to be moved via META_MAPPING?  The
> reason is that we have to be super careful not to read pages of a verity file
> into its own address_space without doing the fs-verity data verification, as
> then unverified data would be available to userspace.
> 
> In theory, F2FS's garbage collector could do the data verification.  But it's
> tricky because ->i_verity_info may not have been set up yet.  So it might be
> easiest to continue to treat verity files like encrypted files.

I meant to ask why not just checking f2fs_post_read_required() here so that we
could sync the check across multiple places.

> 
> - Eric
