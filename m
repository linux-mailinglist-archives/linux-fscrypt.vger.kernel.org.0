Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9541179E3
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 23:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfLIWxb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 17:53:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfLIWxb (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 17:53:31 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8626206D5;
        Mon,  9 Dec 2019 22:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575932010;
        bh=iVY/LHU59YNkIrKmss+YACySzYJGFP4oy3lehsHNIP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GxPLLO5LmxtmITVr9gbcIJoUvdBWWtsew49E8i8Z792pfMBZGV4slPXw838nG7zEa
         tnN31FChr8VKWCVMxRAixj8/YlAnmTY4D04vcXwXvxkHxrylMsgmTdNqiNaOmM81PL
         zjevy++uZE0YNgQ6Elwtbzpkd8e6m15oeygm7ND4=
Date:   Mon, 9 Dec 2019 14:53:29 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] f2fs: don't keep META_MAPPING pages used for moving
 verity file blocks
Message-ID: <20191209225328.GG149190@gmail.com>
References: <20191209200055.204040-1-ebiggers@kernel.org>
 <20191209222828.GA798@jaegeuk-macbookpro.roam.corp.google.com>
 <20191209224051.GF149190@gmail.com>
 <20191209224857.GC798@jaegeuk-macbookpro.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209224857.GC798@jaegeuk-macbookpro.roam.corp.google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 09, 2019 at 02:48:57PM -0800, Jaegeuk Kim wrote:
> On 12/09, Eric Biggers wrote:
> > On Mon, Dec 09, 2019 at 02:28:28PM -0800, Jaegeuk Kim wrote:
> > > On 12/09, Eric Biggers wrote:
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > META_MAPPING is used to move blocks for both encrypted and verity files.
> > > > So the META_MAPPING invalidation condition in do_checkpoint() should
> > > > consider verity too, not just encrypt.
> > > > 
> > > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > > ---
> > > >  fs/f2fs/checkpoint.c | 6 +++---
> > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > > > index ffdaba0c55d29..44e84ac5c9411 100644
> > > > --- a/fs/f2fs/checkpoint.c
> > > > +++ b/fs/f2fs/checkpoint.c
> > > > @@ -1509,10 +1509,10 @@ static int do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
> > > >  	f2fs_wait_on_all_pages_writeback(sbi);
> > > >  
> > > >  	/*
> > > > -	 * invalidate intermediate page cache borrowed from meta inode
> > > > -	 * which are used for migration of encrypted inode's blocks.
> > > > +	 * invalidate intermediate page cache borrowed from meta inode which are
> > > > +	 * used for migration of encrypted or verity inode's blocks.
> > > >  	 */
> > > > -	if (f2fs_sb_has_encrypt(sbi))
> > > > +	if (f2fs_sb_has_encrypt(sbi) || f2fs_sb_has_verity(sbi))
> > > 
> > > Do we need f2fs_post_read_required() aligned to the condition of
> > > move_data_block()?
> > > 
> > 
> > I think you're asking why verity files have to be moved via META_MAPPING?  The
> > reason is that we have to be super careful not to read pages of a verity file
> > into its own address_space without doing the fs-verity data verification, as
> > then unverified data would be available to userspace.
> > 
> > In theory, F2FS's garbage collector could do the data verification.  But it's
> > tricky because ->i_verity_info may not have been set up yet.  So it might be
> > easiest to continue to treat verity files like encrypted files.
> 
> I meant to ask why not just checking f2fs_post_read_required() here so that we
> could sync the check across multiple places.
> 

We can't use f2fs_post_read_required() here because f2fs_post_read_required()
deals with a specific inode, but do_checkpoint() is dealing with the entire
filesystem.  It's checking whether the filesystem might have *any* files that
were moved via META_MAPPING.

- Eric
