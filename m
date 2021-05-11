Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44F937AF26
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 May 2021 21:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhEKTOq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 May 2021 15:14:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:55612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231454AbhEKTOq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 May 2021 15:14:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7078BAEFB;
        Tue, 11 May 2021 19:13:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 063B6DAF29; Tue, 11 May 2021 21:11:08 +0200 (CEST)
Date:   Tue, 11 May 2021 21:11:08 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v4 1/5] btrfs: add compat_flags to btrfs_inode_item
Message-ID: <20210511191108.GL7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1620240133.git.boris@bur.io>
 <6ed83a27f88e18f295f7d661e9c87e7ec7d33428.1620241221.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ed83a27f88e18f295f7d661e9c87e7ec7d33428.1620241221.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 05, 2021 at 12:20:39PM -0700, Boris Burkov wrote:
> The tree checker currently rejects unrecognized flags when it reads
> btrfs_inode_item. Practically, this means that adding a new flag makes
> the change backwards incompatible if the flag is ever set on a file.

Is there any other known problem when the verity flag is set? The tree
checker is naturally the first instance where it gets noticed and I
haven't found any other place as the flag would be just another one.

Why am I asking: allocating 8 bytes for incompat bits where we know
there will be likely just one used is wasteful. I'm exploring
possibilities if the incompat flags can be squeezed to existing flags.
In the end the size can be reduced to u16, u64 is really too much.

> Take up one of the 4 reserved u64 fields in the btrfs_inode_item as a
> new "compat_flags". These flags are zero on inode creation in btrfs and
> mkfs and are ignored by an older kernel, so it should be safe to use
> them in this way.

Yeah this should be safe.

> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/btrfs_inode.h          | 1 +
>  fs/btrfs/ctree.h                | 2 ++
>  fs/btrfs/delayed-inode.c        | 2 ++
>  fs/btrfs/inode.c                | 3 +++
>  fs/btrfs/ioctl.c                | 7 ++++---
>  fs/btrfs/tree-log.c             | 1 +
>  include/uapi/linux/btrfs_tree.h | 7 ++++++-
>  7 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index c652e19ad74e..e8dbc8e848ce 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -191,6 +191,7 @@ struct btrfs_inode {
>  
>  	/* flags field from the on disk inode */
>  	u32 flags;
> +	u64 compat_flags;

This got me curious, u32 flags is for the in-memory inode, but the
on-disk inode_item::flags is u64

>  BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> +BTRFS_SETGET_FUNCS(inode_compat_flags, struct btrfs_inode_item, compat_flags, 64);

>  	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);

Which means we currently use only 32 bits and half of the on-disk
inode_item::flags is always zero. So the idea is to repurpose this for
the incompat bits (say upper 16 bits). With a minimal patch to tree
checker we can make old kernels accept a verity-enabled kernel.

It could be tricky, but for backport only additional bitmask would be
added to BTRFS_INODE_FLAG_MASK to ignore bits 48-63.

For proper support the inode_item::flags can be simply used as one space
where the split would be just logical, and IMO manageable.

> +	btrfs_set_stack_inode_compat_flags(inode_item, BTRFS_I(inode)->compat_flags);
>  	btrfs_set_stack_inode_block_group(inode_item, 0);
>  
>  	btrfs_set_stack_timespec_sec(&inode_item->atime,
> @@ -1776,6 +1777,7 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
>  	inode->i_rdev = 0;
>  	*rdev = btrfs_stack_inode_rdev(inode_item);
>  	BTRFS_I(inode)->flags = btrfs_stack_inode_flags(inode_item);

As another example, the stack inode flags get trimmed from u64 to u32,
so old kernels won't notice.

> +	BTRFS_I(inode)->compat_flags = btrfs_stack_inode_compat_flags(inode_item);
>  
>  	inode->i_atime.tv_sec = btrfs_stack_timespec_sec(&inode_item->atime);
>  	inode->i_atime.tv_nsec = btrfs_stack_timespec_nsec(&inode_item->atime);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 69fcdf8f0b1c..d89000577f7f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3627,6 +3627,7 @@ static int btrfs_read_locked_inode(struct inode *inode,
>  
>  	BTRFS_I(inode)->index_cnt = (u64)-1;
>  	BTRFS_I(inode)->flags = btrfs_inode_flags(leaf, inode_item);
> +	BTRFS_I(inode)->compat_flags = btrfs_inode_compat_flags(leaf, inode_item);
>  
>  cache_index:
>  	/*
> @@ -3793,6 +3794,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
>  	btrfs_set_token_inode_transid(&token, item, trans->transid);
>  	btrfs_set_token_inode_rdev(&token, item, inode->i_rdev);
>  	btrfs_set_token_inode_flags(&token, item, BTRFS_I(inode)->flags);
> +	btrfs_set_token_inode_compat_flags(&token, item, BTRFS_I(inode)->compat_flags);
>  	btrfs_set_token_inode_block_group(&token, item, 0);
>  }
>  
> @@ -8857,6 +8859,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
>  	ei->defrag_bytes = 0;
>  	ei->disk_i_size = 0;
>  	ei->flags = 0;
> +	ei->compat_flags = 0;
>  	ei->csum_bytes = 0;
>  	ei->index_cnt = (u64)-1;
>  	ei->dir_index = 0;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 0ba0e4ddaf6b..ff335c192170 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -102,8 +102,9 @@ static unsigned int btrfs_mask_fsflags_for_type(struct inode *inode,
>   * Export internal inode flags to the format expected by the FS_IOC_GETFLAGS
>   * ioctl.
>   */
> -static unsigned int btrfs_inode_flags_to_fsflags(unsigned int flags)
> +static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
>  {
> +	unsigned int flags = binode->flags;

So things like the above must be careful and store the variables to
properly sized integers.

>  	unsigned int iflags = 0;
>  
>  	if (flags & BTRFS_INODE_SYNC)
> @@ -156,7 +157,7 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
>  static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
>  {
>  	struct btrfs_inode *binode = BTRFS_I(file_inode(file));
> -	unsigned int flags = btrfs_inode_flags_to_fsflags(binode->flags);
> +	unsigned int flags = btrfs_inode_flags_to_fsflags(binode);

This now does not apply to 5.13-rc1 as there was a patchset converting
all the file attributes to a common API and this hunk now does not apply
as the btrfs_ioctl_getflags is handled by fileattr_fill_flags in
btrfs_fileattr_get.

The fix seem to be simple as it's using the same helpers but I did not
get far enough to resolve the conflict compeletely, so please rebase and
resend.
