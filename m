Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7100E35A945
	for <lists+linux-fscrypt@lfdr.de>; Sat, 10 Apr 2021 01:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbhDIXdO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 9 Apr 2021 19:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235166AbhDIXdO (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 9 Apr 2021 19:33:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92D1D610CB;
        Fri,  9 Apr 2021 23:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618011180;
        bh=YcY00fH/7Dp1kwuiezzM0Tg4sto0VII5LNVvyfDkoIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rvnByRKgEGuRIsOFEHgvLqMBj/7OfPvtD5SIvzEcZWWQMGxU1r+rHNRbD92aIBXKH
         u1dsqZ7FiXU/OxE0OkvTpF2fowtj85OCOYHH9KgIEciJJQhTBaV92roNCk+9oGCMPI
         PdNRD7B/+dzY8zG+Y0GamNoOblfGYTJyK578J2DGYuxBk7Ds76+/YZswIG/27kU5CD
         WTaQZ4QoUTDQfF953oNGLutd1HCRDsOXtDLr6j+8CyAkf8SOgehXp9l1hx+DM8eoPG
         9P6+HXVz7ePq1WoYyM2DwTb6Hy3cMlxjEqEzNyDV9Ev5Ejq+pxbytffE270StJzhcp
         gdaULOWbpsisw==
Date:   Fri, 9 Apr 2021 16:32:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 2/5] btrfs: initial fsverity support
Message-ID: <YHDkK9W9N2UWEEyv@sol.localdomain>
References: <cover.1617900170.git.boris@bur.io>
 <c9335d862ee4ddc1f7193bbb06ca7313d9ff1b30.1617900170.git.boris@bur.io>
 <YG+IoOqvDNtkwWQf@sol.localdomain>
 <YHDY/ekYdxHhvHRW@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHDY/ekYdxHhvHRW@zen>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 09, 2021 at 03:45:17PM -0700, Boris Burkov wrote:
> On Thu, Apr 08, 2021 at 03:50:08PM -0700, Eric Biggers wrote:
> > On Thu, Apr 08, 2021 at 11:33:53AM -0700, Boris Burkov wrote:
> > > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > > index f7a4ad86adee..e5282a8f566a 100644
> > > --- a/fs/btrfs/super.c
> > > +++ b/fs/btrfs/super.c
> > > @@ -1339,6 +1339,7 @@ static int btrfs_fill_super(struct super_block *sb,
> > >  	sb->s_op = &btrfs_super_ops;
> > >  	sb->s_d_op = &btrfs_dentry_operations;
> > >  	sb->s_export_op = &btrfs_export_ops;
> > > +	sb->s_vop = &btrfs_verityops;
> > >  	sb->s_xattr = btrfs_xattr_handlers;
> > >  	sb->s_time_gran = 1;
> > 
> > As the kernel test robot has hinted at, this line needs to be conditional on
> > CONFIG_FS_VERITY.
> > 
> > > +/*
> > > + * Helper function for computing cache index for Merkle tree pages
> > > + * @inode: verity file whose Merkle items we want.
> > > + * @merkle_index: index of the page in the Merkle tree (as in
> > > + *                read_merkle_tree_page).
> > > + * @ret_index: returned index in the inode's mapping
> > > + *
> > > + * Returns: 0 on success, -EFBIG if the location in the file would be beyond
> > > + * sb->s_maxbytes.
> > > + */
> > > +static int get_verity_mapping_index(struct inode *inode,
> > > +				    pgoff_t merkle_index,
> > > +				    pgoff_t *ret_index)
> > > +{
> > > +	/*
> > > +	 * the file is readonly, so i_size can't change here.  We jump
> > > +	 * some pages past the last page to cache our merkles.  The goal
> > > +	 * is just to jump past any hugepages that might be mapped in.
> > > +	 */
> > > +	pgoff_t merkle_offset = 2048;
> > > +	u64 index = (i_size_read(inode) >> PAGE_SHIFT) + merkle_offset + merkle_index;
> > 
> > Would it make more sense to align the page index to 2048, rather than adding
> > 2048?  Or are huge pages not necessarily aligned in the page cache?
> > 
> 
> What advantages are there to aligning? I don't have any objection to
> doing it besides keeping things as simple as possible.

It just seems like the logical thing to do, and it's what ext4 and f2fs do; they
align the start of the verity metadata to 65536 bytes so that it's page-aligned
on all architectures.

Actually, you might want to choose a fixed value like that as well (rather than
some constant multiple of PAGE_SIZE) so that your maximum file size isn't
different on different architectures.

Can you elaborate on what sort of huge page scenario you have in mind here?

> 
> > > +
> > > +	if (index > inode->i_sb->s_maxbytes >> PAGE_SHIFT)
> > > +		return -EFBIG;
> > 
> > There's an off-by-one error here; it's considering the beginning of the page
> > rather than the end of the page.
> > 
> 
> I can't see the error myself, yet..
> 
> read_merkle_tree_page is what interacts with the page cache and does it
> with read_key_bytes in PAGE_SIZE chunks. So if index == maxbytes >>
> PAGE_SHIFT, I take that to mean we match on the start of the last
> possible page, which seems fine to read in all of. The next index will
> fail.

The maximum number of pages is s_maxbytes >> PAGE_SHIFT, and you're allowing the
page with that index, which means you're allowing one too many pages.  Hence, an
off-by-one-error.

> 
> I think the weird thing is I called get_verity_merkle_index to
> write_merkle_tree_block. It doesn't do much there since we aren't
> affecting the page cache till we read.
> 
> As far as I can see, to make the btrfs implementation behave as
> similarly as possible to ext4, it should either interact with the page
> cache on the write path, or if that is undesirable (haven't thought it
> through carefully yet), it should accurately fail writes with EFBIG that
> would later fail as reads.
> 

Yes, you need to enforce the limit at write time, not just at read time.  But
make sure you're using the page index, not the block index (to be ready for
Merkle tree block size != PAGE_SIZE in the future).

- Eric
