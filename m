Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417ED3898BF
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 May 2021 23:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhESVqq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 May 2021 17:46:46 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55107 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229454AbhESVqq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 May 2021 17:46:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4E5D35C01A0;
        Wed, 19 May 2021 17:45:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 19 May 2021 17:45:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=fm3; bh=Y9amePRs67LQDdr3pQ/dN6yGqZARTcSTCwbFAfgb
        6C0=; b=L+ZkeErn3+FORR7ket8nF/8AsnBUC+ktvkBv6XVT674X8QXVJWt4iORf
        l3VYkZQ1m8EBYcvGEAn4mTMPhnQtcGKP03QWcQQAMKG8SJnSpPH8XQPDjxcDORxC
        n2Tu3CNqe7LwzdG5Otf4XGbZv5bPC+XU+JR3DN7OKz9KoanR/LHs0vZA/7YwYHls
        0ba6H+nz+GKwCW0nH1xGjv+PfgzgAJyjmTn7MSouEtkETwnXtTxFJHmX+0dJrLxh
        PpezRTOReYZilY3i1sEcN3iygJlJlnxDk+XDJe8sW172KK7p52QhcWJsD3Pgi3yg
        ESULL71QYrtrPq3ZknhPb2Oob0xyOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Y9ameP
        Rs67LQDdr3pQ/dN6yGqZARTcSTCwbFAfgb6C0=; b=Pi3XE3jRCus2Cn+WWndOZi
        tK8liEzVxVkyFAx/k3Q6M9DEnSG2ZPLnPOk0lmB83J1MqIfqWyxPQOApvNtDknpH
        0JesDHJpcLfzewEGf3jON/thMqphoqA3FMdYv5TbHlPnsmin2WvKF1zKfVIOQrT9
        dbgRIaIJpRS/JyH1ipo2Ej3xAaKaVYeFb81B41DOFtR9WQiyxga5XqFyCdHniPty
        PNQy/V572smZlr9gKSGWGuBmKUzshDJE3PH0eWoSTUPyTvWPuVVU5YP7pHnuTlry
        q8QCVPVHcPjXjkjMRmOf7RS82hsmioJpcoEwVqEdIVIuNBUXEkjFNQOqMuvpLK4g
        ==
X-ME-Sender: <xms:9YalYEBFXj-U5ilAC7hW979damFtgDM8KXQpZ5KAIs4diYQHoXXp6A>
    <xme:9YalYGgYUUx4yl8VtK8hfLNjQhDSyM0Y9tNQfnKM3waaz9_zXK5tXU5mvaykrAOe1
    BVfpBfhrWD6E-YrEUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejtddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeehudevleekieetleevieeuhfduhedtiefgheekfe
    efgeelvdeuveeggfduueevfeenucfkphepvddtjedrheefrddvheefrdejnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurh
    drihho
X-ME-Proxy: <xmx:9YalYHkstQFcX57AnI6ot_fEPxj_unqqcGYMqfuF38yDSHZyiVdTcw>
    <xmx:9YalYKwRiLKOwPFtEjUDXVjey0kpzXjiQqNmUvT4VppU2hNJS8xtqQ>
    <xmx:9YalYJTSo_KyZtV59QAp66i13hu67JUrExT6XjR_6oMTSVnbncfXIg>
    <xmx:9YalYIImtwN7ckfOAFf2s35LUItbFiKhqSCe_F4W_2B2wBTdAQqDiQ>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 19 May 2021 17:45:24 -0400 (EDT)
Date:   Wed, 19 May 2021 14:45:23 -0700
From:   Boris Burkov <boris@bur.io>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 1/5] btrfs: add compat_flags to btrfs_inode_item
Message-ID: <YKWG86j7MpECAo+s@zen>
References: <cover.1620240133.git.boris@bur.io>
 <6ed83a27f88e18f295f7d661e9c87e7ec7d33428.1620241221.git.boris@bur.io>
 <20210511191108.GL7604@twin.jikos.cz>
 <20210517214859.GS7604@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517214859.GS7604@twin.jikos.cz>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, May 17, 2021 at 11:48:59PM +0200, David Sterba wrote:
> On Tue, May 11, 2021 at 09:11:08PM +0200, David Sterba wrote:
> > On Wed, May 05, 2021 at 12:20:39PM -0700, Boris Burkov wrote:
> > > --- a/fs/btrfs/btrfs_inode.h
> > > +++ b/fs/btrfs/btrfs_inode.h
> > > @@ -191,6 +191,7 @@ struct btrfs_inode {
> > >  
> > >  	/* flags field from the on disk inode */
> > >  	u32 flags;
> > > +	u64 compat_flags;
> > 
> > This got me curious, u32 flags is for the in-memory inode, but the
> > on-disk inode_item::flags is u64
> > 
> > >  BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
> >                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > > +BTRFS_SETGET_FUNCS(inode_compat_flags, struct btrfs_inode_item, compat_flags, 64);
> > 
> > >  	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
> > 
> > Which means we currently use only 32 bits and half of the on-disk
> > inode_item::flags is always zero. So the idea is to repurpose this for
> > the incompat bits (say upper 16 bits). With a minimal patch to tree
> > checker we can make old kernels accept a verity-enabled kernel.
> > 
> > It could be tricky, but for backport only additional bitmask would be
> > added to BTRFS_INODE_FLAG_MASK to ignore bits 48-63.
> > 
> > For proper support the inode_item::flags can be simply used as one space
> > where the split would be just logical, and IMO manageable.
> 
> To demonstrate the idea, here's a compile-tested patch, based on
> current misc-next but the verity bits are easy to match to your
> patchset:

Thanks for taking the time to prove this idea out. However, I'd still
like to discuss the pros/cons of this approach for this application.

As far as I can tell, the two issues at hand are ensuring compatibility
and using fewer of the reserved bits. Your proposal uses 0 reserved
bits, which is great, but is still quite a headache for compatibility,
as an administrator would have to backport the compat patch on any kernel
they wanted to roll back to before the one this went out on.

This is especially painful for less well-loved things like
dracut/systemd mounting the root filesystem and doing a pivot_root during
boot. You would have to make sure that any machine using fsverity btrfs
files has an updated initramfs kernel or it won't be able to boot.

Alternatively, we could have our cake and eat it too if we separate the
idea of unlocking the top 32 bits of the inode flags from adding compat
flags.

If we:
1. take a u16 or a u32 out of reserved and make it compat flags (my
patch, but shrinking from u64)
2. implement something similar to your patch, but don't use those 32
bits just yet

Then we are setup to more conveniently use the freed-up 32 bits in the
future, as the application which wants reserved bytes then will have a
buffer of kernel versions to trivially roll back into, which may cover
most practical rollbacks.

For what it's worth, I do like that your proposal stuffs inode flags and
inode compat flags together, which is certainly neater than turning the
upper 32 of inode flags into general reserved bits. But I'm just not
sure that the aesthetic benefit is worth the real pain now.

> 
> - btrfs_inode::ro_flags - in-memory representation of the ro flags
> - tree-checker verifies the flags separately
>   - errors if there are unkonwn flags (u32)
>   - errors if ro_flags don't match fs ro_compat bits
> - inode_item::flags gets synced with btrfs_inode::flags + ro_flags
> - the split of inode_item::flags is 32/32 for simplicity as it matches
>   the current type, we can make it 48/16 if that would work (maybe not)
> 
> ---
> 
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -189,8 +189,10 @@ struct btrfs_inode {
>  	 */
>  	u64 csum_bytes;
>  
> -	/* flags field from the on disk inode */
> +	/* Flags field from the on disk inode, lower half of inode_item::flags  */
>  	u32 flags;
> +	/* Read-only compatibility flags, upper half of inode_item::flags */
> +	u32 ro_flags;
>  
>  	/*
>  	 * Counters to keep track of the number of extent item's we may use due
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -281,7 +281,8 @@ struct btrfs_super_block {
>  
>  #define BTRFS_FEATURE_COMPAT_RO_SUPP			\
>  	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
> -	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID)
> +	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID | \
> +	 BTRFS_FEATURE_COMPAT_RO_VERITY)
>  
>  #define BTRFS_FEATURE_COMPAT_RO_SAFE_SET	0ULL
>  #define BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR	0ULL
> @@ -1490,6 +1491,8 @@ do {                                                                   \
>  
>  #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
>  
> +#define BTRFS_INODE_RO_VERITY		(1ULL << 32)
> +
>  #define BTRFS_INODE_FLAG_MASK						\
>  	(BTRFS_INODE_NODATASUM |					\
>  	 BTRFS_INODE_NODATACOW |					\
> @@ -1505,6 +1508,9 @@ do {                                                                   \
>  	 BTRFS_INODE_COMPRESS |						\
>  	 BTRFS_INODE_ROOT_ITEM_INIT)
>  
> +#define BTRFS_INODE_FLAG_INCOMPAT_MASK			(0x00000000FFFFFFFF)
> +#define BTRFS_INODE_FLAG_RO_COMPAT_MASK			(0xFFFFFFFF00000000)
> +
>  struct btrfs_map_token {
>  	struct extent_buffer *eb;
>  	char *kaddr;
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1717,7 +1717,8 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
>  				       inode_peek_iversion(inode));
>  	btrfs_set_stack_inode_transid(inode_item, trans->transid);
>  	btrfs_set_stack_inode_rdev(inode_item, inode->i_rdev);
> -	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
> +	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags |
> +			((u64)BTRFS_I(inode)->ro_flags << 32));
>  	btrfs_set_stack_inode_block_group(inode_item, 0);
>  
>  	btrfs_set_stack_timespec_sec(&inode_item->atime,
> @@ -1775,7 +1776,8 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
>  				   btrfs_stack_inode_sequence(inode_item));
>  	inode->i_rdev = 0;
>  	*rdev = btrfs_stack_inode_rdev(inode_item);
> -	BTRFS_I(inode)->flags = btrfs_stack_inode_flags(inode_item);
> +	BTRFS_I(inode)->flags = (u32)btrfs_stack_inode_flags(inode_item);
> +	BTRFS_I(inode)->ro_flags = (u32)(btrfs_stack_inode_flags(inode_item) >> 32);
>  
>  	inode->i_atime.tv_sec = btrfs_stack_timespec_sec(&inode_item->atime);
>  	inode->i_atime.tv_nsec = btrfs_stack_timespec_nsec(&inode_item->atime);
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3630,7 +3630,8 @@ static int btrfs_read_locked_inode(struct inode *inode,
>  	rdev = btrfs_inode_rdev(leaf, inode_item);
>  
>  	BTRFS_I(inode)->index_cnt = (u64)-1;
> -	BTRFS_I(inode)->flags = btrfs_inode_flags(leaf, inode_item);
> +	BTRFS_I(inode)->flags = (u32)btrfs_inode_flags(leaf, inode_item);
> +	BTRFS_I(inode)->ro_flags = (u32)(btrfs_inode_flags(leaf, inode_item) >> 32);
>  
>  cache_index:
>  	/*
> @@ -3796,7 +3797,8 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
>  	btrfs_set_token_inode_sequence(&token, item, inode_peek_iversion(inode));
>  	btrfs_set_token_inode_transid(&token, item, trans->transid);
>  	btrfs_set_token_inode_rdev(&token, item, inode->i_rdev);
> -	btrfs_set_token_inode_flags(&token, item, BTRFS_I(inode)->flags);
> +	btrfs_set_token_inode_flags(&token, item, BTRFS_I(inode)->flags |
> +			((u64)BTRFS_I(inode)->ro_flags << 32));
>  	btrfs_set_token_inode_block_group(&token, item, 0);
>  }
>  
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -378,7 +378,7 @@ static int check_csum_item(struct extent_buffer *leaf, struct btrfs_key *key,
>  
>  /* Inode item error output has the same format as dir_item_err() */
>  #define inode_item_err(eb, slot, fmt, ...)			\
> -	dir_item_err(eb, slot, fmt, __VA_ARGS__)
> +	dir_item_err(eb, slot, fmt, ## __VA_ARGS__)
>  
>  static int check_inode_key(struct extent_buffer *leaf, struct btrfs_key *key,
>  			   int slot)
> @@ -999,6 +999,7 @@ static int check_inode_item(struct extent_buffer *leaf,
>  	u32 valid_mask = (S_IFMT | S_ISUID | S_ISGID | S_ISVTX | 0777);
>  	u32 mode;
>  	int ret;
> +	u64 inode_flags;
>  
>  	ret = check_inode_key(leaf, key, slot);
>  	if (unlikely(ret < 0))
> @@ -1054,13 +1055,22 @@ static int check_inode_item(struct extent_buffer *leaf,
>  			btrfs_inode_nlink(leaf, iitem));
>  		return -EUCLEAN;
>  	}
> -	if (unlikely(btrfs_inode_flags(leaf, iitem) & ~BTRFS_INODE_FLAG_MASK)) {
> +	inode_flags = btrfs_inode_flags(leaf, iitem);
> +	if (unlikely(inode_flags & ~BTRFS_INODE_FLAG_INCOMPAT_MASK)) {
>  		inode_item_err(leaf, slot,
> -			       "unknown flags detected: 0x%llx",
> -			       btrfs_inode_flags(leaf, iitem) &
> -			       ~BTRFS_INODE_FLAG_MASK);
> +			       "unknown incompat flags detected: 0x%llx",
> +			       inode_flags & ~BTRFS_INODE_FLAG_INCOMPAT_MASK);
>  		return -EUCLEAN;
>  	}
> +	if (unlikely(inode_flags & ~BTRFS_INODE_FLAG_RO_COMPAT_MASK)) {
> +		if (unlikely(inode_flags & BTRFS_INODE_RO_VERITY)) {
> +			if (btrfs_fs_compat_ro(fs_info, VERITY)) {
> +				inode_item_err(leaf, slot,
> +			"inode ro compat VERITY flag set but not on filesystem");
> +				return -EUCLEAN;
> +			}
> +		}
> +	}
>  	return 0;
>  }
>  
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3941,7 +3941,8 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
>  	btrfs_set_token_inode_sequence(&token, item, inode_peek_iversion(inode));
>  	btrfs_set_token_inode_transid(&token, item, trans->transid);
>  	btrfs_set_token_inode_rdev(&token, item, inode->i_rdev);
> -	btrfs_set_token_inode_flags(&token, item, BTRFS_I(inode)->flags);
> +	btrfs_set_token_inode_flags(&token, item, BTRFS_I(inode)->flags |
> +			((u64)BTRFS_I(inode)->ro_flags << 32));
>  	btrfs_set_token_inode_block_group(&token, item, 0);
>  }
>  
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -288,6 +288,7 @@ struct btrfs_ioctl_fs_info_args {
>   * first mount when booting older kernel versions.
>   */
>  #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID	(1ULL << 1)
> +#define BTRFS_FEATURE_COMPAT_RO_VERITY			(1ULL << 2)
>  
>  #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
>  #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
> -- 
> 2.29.2
> 
