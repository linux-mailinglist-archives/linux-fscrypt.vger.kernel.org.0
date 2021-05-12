Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407E537D4E0
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 May 2021 23:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243431AbhELSeA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 12 May 2021 14:34:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:38396 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236219AbhELROT (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 12 May 2021 13:14:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 889FEB1C1;
        Wed, 12 May 2021 17:13:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7E3DBDA83F; Wed, 12 May 2021 19:10:37 +0200 (CEST)
Date:   Wed, 12 May 2021 19:10:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 2/5] btrfs: initial fsverity support
Message-ID: <20210512171037.GT7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1620240133.git.boris@bur.io>
 <dd0cfc38c6de927de63f34f96499dc8f80398754.1620241221.git.boris@bur.io>
 <20210511203143.GN7604@twin.jikos.cz>
 <YJr8j3Kd6d1yW5bc@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJr8j3Kd6d1yW5bc@zen>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 11, 2021 at 02:52:15PM -0700, Boris Burkov wrote:
> On Tue, May 11, 2021 at 10:31:43PM +0200, David Sterba wrote:
> > On Wed, May 05, 2021 at 12:20:40PM -0700, Boris Burkov wrote:
> > > From: Chris Mason <clm@fb.com>
> > > 
> > > Add support for fsverity in btrfs. To support the generic interface in
> > > fs/verity, we add two new item types in the fs tree for inodes with
> > > verity enabled. One stores the per-file verity descriptor and the other
> > > stores the Merkle tree data itself.
> > > 
> > > Verity checking is done at the end of IOs to ensure each page is checked
> > > before it is marked uptodate.
> > > 
> > > Verity relies on PageChecked for the Merkle tree data itself to avoid
> > > re-walking up shared paths in the tree. For this reason, we need to
> > > cache the Merkle tree data.
> > 
> > What's the estimated size of the Merkle tree data? Does the whole tree
> > need to be kept cached or is it only for data that are in page cache?
> 
> With the default of SHA256 and 4K blocks, we have 32 byte digests which
> which fits 128 digests per block, so the Merkle tree will be almost
> exactly 1/127 of the size of the file.

Thanks, so it's roughly 8K per 1M.

> As far as I know, there is no special requirement that the Merkle tree
> data stays cached. If a Merkle tree block is evicted, then a data block
> is evicted and re-read, we would need to read the Merkle tree block
> again and possibly up the path to the root until a cached block with
> PageChecked.
> 
> > > +++ b/fs/btrfs/file.c
> > > @@ -16,6 +16,7 @@
> > >  #include <linux/btrfs.h>
> > >  #include <linux/uio.h>
> > >  #include <linux/iversion.h>
> > > +#include <linux/fsverity.h>
> > >  #include "ctree.h"
> > >  #include "disk-io.h"
> > >  #include "transaction.h"
> > > @@ -3593,7 +3594,12 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int whence)
> > >  
> > >  static int btrfs_file_open(struct inode *inode, struct file *filp)
> > >  {
> > > +	int ret;
> > 
> > Missing newline
> 
> Weird, I ran checkpatch so many times.. My bad.

No big deal, such things can slip in. I would not point them out unless
there's another reason to resend the patches. Once all the real things
are done I do a pass just fixing style.

> > > +#include <linux/sched/mm.h>
> > > +#include "ctree.h"
> > > +#include "btrfs_inode.h"
> > > +#include "transaction.h"
> > > +#include "disk-io.h"
> > > +#include "locking.h"
> > > +
> > > +/*
> > > + * Just like ext4, we cache the merkle tree in pages after EOF in the page
> > > + * cache.  Unlike ext4, we're storing these in dedicated btree items and
> > > + * not just shoving them after EOF in the file.  This means we'll need to
> > > + * do extra work to encrypt them once encryption is supported in btrfs,
> > > + * but btrfs has a lot of careful code around i_size and it seems better
> > > + * to make a new key type than try and adjust all of our expectations
> > > + * for i_size.
> > 
> > Can you please rephrase that so it does not start with what other
> > filesystems do but what is the actual design and put references to ext4
> > eventually?
> > 
> > > + *
> > > + * fs verity items are stored under two different key types on disk.
> > > + *
> > > + * The descriptor items:
> > > + * [ inode objectid, BTRFS_VERITY_DESC_ITEM_KEY, offset ]
> > 
> > Please put that to the key definitions
> 
> Do you mean to move this whole comment to btrfs_tree.h?

Yeah, there are already some key descriptions, so that should be the
palce where to look. You can of course repeat what yout need in this
comment for context and so that the text is understandable without going
to other files.

> > > +static loff_t merkle_file_pos(const struct inode *inode)
> > > +{
> > > +	u64 sz = inode->i_size;
> > > +	u64 ret = round_up(sz, 65536);
> > 
> > What's the reason for the extra variable sz? If that is meant to make
> > the whole u64 is read consistently, then it needs protection and the
> > i_read_size if the status of inode lock and context of call is unknown.
> > Compiler will happily merge that to round_up(inode->i_size).
> 
> This was the result of getting a bit lazy reading assembly. My intent
> was to ensure that we don't overflow the round_up, which is a macro that
> depends on the type of the input. I was messing around figuring out what
> effect casting had on it but gave up and just put it in a u64 before
> calling it.

Forcing the type by assigning it to another variable is ok. The problem
is potential multiple evaluation of inode->i_size. Here's a real example
how this can lead to real bugs
https://git.kernel.org/linus/d98da49977f67394db492 , in that case it was
inside max(). Reading that again, just using i_size_read is not
sufficient because it still does not have READ_ONCE. We had to emulate
it using compiler barrier.

But now I realize the i_size can't change because fsverity works in
read-only mode once enabled on the inode, right? In that case the only
concern would indeed be the type safety for round_up.

> > Next, what's the meaning of the constant 65536?
> > 
> 
> It's arbitrary, and copied from ext4. I _believe_ the idea behind it is
> that it should be a fixed constant to avoid making the page size change
> the maximum file size subtly, but should be big enough to be a fresh
> page truly past the end of the file pages on a 64K page size system.

Yeah, according to commit c93d8f88580921c84d it seems to be the maximum
expected page size, in that case a symbolic name would be more
appropriate.

fs/ext4/verity.c:
* Using a 64K boundary rather than a 4K one keeps things ready for
* architectures with 64K pages, and it doesn't necessarily waste space on-disk
* since there can be a hole between i_size and the start of the Merkle tree.

> > > +	if (ret > inode->i_sb->s_maxbytes)
> > > +		return -EFBIG;
> > > +	return ret;
> > 
> > ret is u64 so the function should also return u64
> 
> This was intentional as we do want an loff_t (long long) returned, but
> use the u64 for the overflow checking above.

So the reason why you probably want to use loff_t is
inode->i_sb->s_maxbytes, which is loff_t. As this is a constant
MAX_LFS_FILESIZE (sb initialized in btrfs_fill_super), I think you can
replace all instances of sb->s_maxbytes by that, or add something like
BTRFS_MAX_INODE_SIZE that will be u64.

The VFS interface has to use loff_t but as we use u64 in btrfs for
almost everything I'd rather unify that according to the style used in
btrfs and make sure that the conversion is OK on the VFS->FS boundary.

> > > +static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
> > > +					       pgoff_t index,
> > > +					       unsigned long num_ra_pages)
> > > +{
> > > +	struct page *p;
> > 
> > Please don't use single letter variables
> > 
> > > +	u64 off = index << PAGE_SHIFT;
> > 
> > pgoff_t is unsigned long, the shift will trim high bytes, you may want
> > to use the page_offset helper instead.
> 
> Ah, my intent was that it should all fit in off, but yes this does seem
> like it could lose bytes (I thiiiink we might be safe because a write
> would fail first, but I would like this code to be correct). I'll look
> into the helper.

The index gets cast to loff_t before shift, so that's what you'd have to
do here too.

> Thank you for the in-depth review, and sorry for the sloppy newline
> stuff. Everything I didn't explicitly respond to, I'll either fix or
> study further.

Thanks.
