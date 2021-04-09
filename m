Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2124535A5A8
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Apr 2021 20:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbhDISUs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 9 Apr 2021 14:20:48 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43281 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233332AbhDISUr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 9 Apr 2021 14:20:47 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 4010C5C009F;
        Fri,  9 Apr 2021 14:20:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 09 Apr 2021 14:20:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=DhH21a7Jp/LLnvw3iBNXY+AXe1C
        35eXFmWbH0+mQBGY=; b=BsxgpKUL49QUAW/8L9PXZX30GUTT4bkUgBjQga3cLvE
        Ak5iqJva57F3gDYmsiVBQJ6ZQtn/SNmTapkyJr++s3onM2IPEBF+VXTcOML8qW1U
        Nk/iPzHLBafm1cXWUZD/lwRMZHHmUlET0PBDJ+tNmiKXqWlmwmYxqPy1I+tgl+PX
        w9/M272bNwZzgFJcSI5ECKDrMX2Ihg8UvXh2We687EYQJXepKPQmOTBVmO3gIvsx
        TA3rXfc2igEylhFoMqGvtN1TMKnVfOyqJTkNzrF/AOJEr1wo7Mjzv/tuPlFVTE/W
        sS2w7rMFZljOaP9BgVo+uzBX7zf/LBiiHFbBhEh+RoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DhH21a
        7Jp/LLnvw3iBNXY+AXe1C35eXFmWbH0+mQBGY=; b=FfTjf5Eh2DA6JAkD0afUng
        LXCFICwgTUy4jcWakml83zr2RFU0dxsUkjf36bhzsR1R9Ds39TzboqSNJw7QgCJ7
        GcbwUYGGHx1Fiq06Z+oo7l/Al1xDdR0MYZgydRWw605E9kPn9D7mlElb15a+MS5F
        HTx+9+lI08NtWN+fDkSpOMblxrghqIlSWrY21pv5JptFCVbLSi9BeTDH+tC40y1J
        RjmAB6gpqobGa0Uenpbss+4dG77RQOk0VfJOrgcLCN8ARW04QQux/LnESjCE8M4+
        f2Wbd0XKEUpYcWbSgWlt1sYDwvfbspBFZ7vo2QqoNYbyfCXLmMKqnwx/rpsDCk4A
        ==
X-ME-Sender: <xms:8ppwYHC5ox0O-huVeDA7I7DV5cYxfbAl6Kr-WdR9ktg6yxjQPX078Q>
    <xme:8ppwYNiwhhILM86Z_E9AYJfbuPELaGXCbMjyKJuuhmiuY1vmrRHHRN2h_QT1g8XFK
    0VxoYKRQ9s7tBAxpgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekuddguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    ehudevleekieetleevieeuhfduhedtiefgheekfeefgeelvdeuveeggfduueevfeenucfk
    phepvddtjedrheefrddvheefrdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:8ppwYCm0uzRlDJ_0mCs4Oxo4MS3VQCYAw3Qxv9-8aak27RYpTY6WcA>
    <xmx:8ppwYJz3dwDG2O3gR7izM1E6JC54nZcDUa7RKEFltIgLDui7mAMQ2Q>
    <xmx:8ppwYMRZnsNkJOLCHjInD42-7zTKJmCD8smnZDNjOMVFjZNkb6Oxiw>
    <xmx:8ppwYHLaI1stCA-EK26lQ9dcc9jKrI9T_jQRG4rhGCN51mCF1Vigyg>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id F3C6D1080057;
        Fri,  9 Apr 2021 14:20:33 -0400 (EDT)
Date:   Fri, 9 Apr 2021 11:20:32 -0700
From:   Boris Burkov <boris@bur.io>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 1/5] btrfs: add compat_flags to btrfs_inode_item
Message-ID: <YHCa2lw4vBw/3ea1@zen>
References: <cover.1617900170.git.boris@bur.io>
 <7fd3068c977de9dd25eb98fa2b9d3cd928613138.1617900170.git.boris@bur.io>
 <f0c82e93-6d21-740e-5ece-e3b5cc5a8677@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0c82e93-6d21-740e-5ece-e3b5cc5a8677@oracle.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 09, 2021 at 07:40:44AM +0800, Anand Jain wrote:
> On 09/04/2021 02:33, Boris Burkov wrote:
> > The tree checker currently rejects unrecognized flags when it reads
> > btrfs_inode_item. Practically, this means that adding a new flag makes
> > the change backwards incompatible if the flag is ever set on a file.
> 
> 
> > Take up one of the 4 reserved u64 fields in the btrfs_inode_item as a
> > new "compat_flags". These flags are zero on inode creation in btrfs and
> > mkfs and are ignored by an older kernel, so it should be safe to use
> > them in this way.
> 
> I don't see an incompt flags check during mount, how does this patch will
> handle if you mount a disk with an older on-disk btrfs_inode_item data
> structure which has no compat_flags?

I'm referring to check_inode_item in fs/btrfs/tree-checker.c
Specificall, the last check it does that fails with the string: "unknown
flags detected".

This patch ignores the new compat_flags from a checking perspective, so
it won't complain no matter what an old on-disk format put there. As far
as I can tell from inspecting the code and mkfs, it should be zero,
though I suppose it's possible an older version of btrfs did not zero
it. I think the worst case would be if it weren't zero and we
incorrectly interpreted the file as having a compat_flags flag set.

> 
> Why not update the tree checker (need to fix stable kernel as well) and
> inode flags, so that we spare u64 space in the btrfs_inode_item?

I don't understand this suggestion, could you be more specific?

> 
> Also, I think we need the incompt flags to check during mount.

Same for this one, sorry. What do you think I should check?

> 
> Thanks, Anand

Thank you for the review,
Boris
> 
> 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >   fs/btrfs/btrfs_inode.h          | 1 +
> >   fs/btrfs/ctree.h                | 2 ++
> >   fs/btrfs/delayed-inode.c        | 2 ++
> >   fs/btrfs/inode.c                | 3 +++
> >   fs/btrfs/ioctl.c                | 7 ++++---
> >   fs/btrfs/tree-log.c             | 1 +
> >   include/uapi/linux/btrfs_tree.h | 7 ++++++-
> >   7 files changed, 19 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> > index c652e19ad74e..e8dbc8e848ce 100644
> > --- a/fs/btrfs/btrfs_inode.h
> > +++ b/fs/btrfs/btrfs_inode.h
> > @@ -191,6 +191,7 @@ struct btrfs_inode {
> >   	/* flags field from the on disk inode */
> >   	u32 flags;
> > +	u64 compat_flags;
> >   	/*
> >   	 * Counters to keep track of the number of extent item's we may use due
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index f2fd73e58ee6..d633c563164b 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -1754,6 +1754,7 @@ BTRFS_SETGET_FUNCS(inode_gid, struct btrfs_inode_item, gid, 32);
> >   BTRFS_SETGET_FUNCS(inode_mode, struct btrfs_inode_item, mode, 32);
> >   BTRFS_SETGET_FUNCS(inode_rdev, struct btrfs_inode_item, rdev, 64);
> >   BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
> > +BTRFS_SETGET_FUNCS(inode_compat_flags, struct btrfs_inode_item, compat_flags, 64);
> >   BTRFS_SETGET_STACK_FUNCS(stack_inode_generation, struct btrfs_inode_item,
> >   			 generation, 64);
> >   BTRFS_SETGET_STACK_FUNCS(stack_inode_sequence, struct btrfs_inode_item,
> > @@ -1771,6 +1772,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_inode_gid, struct btrfs_inode_item, gid, 32);
> >   BTRFS_SETGET_STACK_FUNCS(stack_inode_mode, struct btrfs_inode_item, mode, 32);
> >   BTRFS_SETGET_STACK_FUNCS(stack_inode_rdev, struct btrfs_inode_item, rdev, 64);
> >   BTRFS_SETGET_STACK_FUNCS(stack_inode_flags, struct btrfs_inode_item, flags, 64);
> > +BTRFS_SETGET_STACK_FUNCS(stack_inode_compat_flags, struct btrfs_inode_item, compat_flags, 64);
> >   BTRFS_SETGET_FUNCS(timespec_sec, struct btrfs_timespec, sec, 64);
> >   BTRFS_SETGET_FUNCS(timespec_nsec, struct btrfs_timespec, nsec, 32);
> >   BTRFS_SETGET_STACK_FUNCS(stack_timespec_sec, struct btrfs_timespec, sec, 64);
> > diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> > index 1a88f6214ebc..ef4e0265dbe3 100644
> > --- a/fs/btrfs/delayed-inode.c
> > +++ b/fs/btrfs/delayed-inode.c
> > @@ -1718,6 +1718,7 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
> >   	btrfs_set_stack_inode_transid(inode_item, trans->transid);
> >   	btrfs_set_stack_inode_rdev(inode_item, inode->i_rdev);
> >   	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
> > +	btrfs_set_stack_inode_compat_flags(inode_item, BTRFS_I(inode)->compat_flags);
> >   	btrfs_set_stack_inode_block_group(inode_item, 0);
> >   	btrfs_set_stack_timespec_sec(&inode_item->atime,
> > @@ -1776,6 +1777,7 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
> >   	inode->i_rdev = 0;
> >   	*rdev = btrfs_stack_inode_rdev(inode_item);
> >   	BTRFS_I(inode)->flags = btrfs_stack_inode_flags(inode_item);
> > +	BTRFS_I(inode)->compat_flags = btrfs_stack_inode_compat_flags(inode_item);
> >   	inode->i_atime.tv_sec = btrfs_stack_timespec_sec(&inode_item->atime);
> >   	inode->i_atime.tv_nsec = btrfs_stack_timespec_nsec(&inode_item->atime);
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 1e0e20ad25e4..3aa96ec27045 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -3627,6 +3627,7 @@ static int btrfs_read_locked_inode(struct inode *inode,
> >   	BTRFS_I(inode)->index_cnt = (u64)-1;
> >   	BTRFS_I(inode)->flags = btrfs_inode_flags(leaf, inode_item);
> > +	BTRFS_I(inode)->compat_flags = btrfs_inode_compat_flags(leaf, inode_item);
> >   cache_index:
> >   	/*
> > @@ -3793,6 +3794,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
> >   	btrfs_set_token_inode_transid(&token, item, trans->transid);
> >   	btrfs_set_token_inode_rdev(&token, item, inode->i_rdev);
> >   	btrfs_set_token_inode_flags(&token, item, BTRFS_I(inode)->flags);
> > +	btrfs_set_token_inode_compat_flags(&token, item, BTRFS_I(inode)->compat_flags);
> >   	btrfs_set_token_inode_block_group(&token, item, 0);
> >   }
> > @@ -8859,6 +8861,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
> >   	ei->defrag_bytes = 0;
> >   	ei->disk_i_size = 0;
> >   	ei->flags = 0;
> > +	ei->compat_flags = 0;
> >   	ei->csum_bytes = 0;
> >   	ei->index_cnt = (u64)-1;
> >   	ei->dir_index = 0;
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 3415a9f06c81..2c9cbd2642b1 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -102,8 +102,9 @@ static unsigned int btrfs_mask_fsflags_for_type(struct inode *inode,
> >    * Export internal inode flags to the format expected by the FS_IOC_GETFLAGS
> >    * ioctl.
> >    */
> > -static unsigned int btrfs_inode_flags_to_fsflags(unsigned int flags)
> > +static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
> >   {
> > +	unsigned int flags = binode->flags;
> >   	unsigned int iflags = 0;
> >   	if (flags & BTRFS_INODE_SYNC)
> > @@ -156,7 +157,7 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
> >   static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
> >   {
> >   	struct btrfs_inode *binode = BTRFS_I(file_inode(file));
> > -	unsigned int flags = btrfs_inode_flags_to_fsflags(binode->flags);
> > +	unsigned int flags = btrfs_inode_flags_to_fsflags(binode);
> >   	if (copy_to_user(arg, &flags, sizeof(flags)))
> >   		return -EFAULT;
> > @@ -228,7 +229,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
> >   	btrfs_inode_lock(inode, 0);
> >   	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
> > -	old_fsflags = btrfs_inode_flags_to_fsflags(binode->flags);
> > +	old_fsflags = btrfs_inode_flags_to_fsflags(binode);
> >   	ret = vfs_ioc_setflags_prepare(inode, old_fsflags, fsflags);
> >   	if (ret)
> > diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> > index 72c4b66ed516..fed638f995ba 100644
> > --- a/fs/btrfs/tree-log.c
> > +++ b/fs/btrfs/tree-log.c
> > @@ -3944,6 +3944,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
> >   	btrfs_set_token_inode_transid(&token, item, trans->transid);
> >   	btrfs_set_token_inode_rdev(&token, item, inode->i_rdev);
> >   	btrfs_set_token_inode_flags(&token, item, BTRFS_I(inode)->flags);
> > +	btrfs_set_token_inode_compat_flags(&token, item, BTRFS_I(inode)->compat_flags);
> >   	btrfs_set_token_inode_block_group(&token, item, 0);
> >   }
> > diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> > index 58d7cff9afb1..ae25280316bd 100644
> > --- a/include/uapi/linux/btrfs_tree.h
> > +++ b/include/uapi/linux/btrfs_tree.h
> > @@ -574,11 +574,16 @@ struct btrfs_inode_item {
> >   	/* modification sequence number for NFS */
> >   	__le64 sequence;
> > +	/*
> > +	 * flags which aren't checked for corruption at mount
> > +	 * and can be added in a backwards compatible way
> > +	 */
> > +	__le64 compat_flags;
> >   	/*
> >   	 * a little future expansion, for more than this we can
> >   	 * just grow the inode item and version it
> >   	 */
> > -	__le64 reserved[4];
> > +	__le64 reserved[3];
> >   	struct btrfs_timespec atime;
> >   	struct btrfs_timespec ctime;
> >   	struct btrfs_timespec mtime;
> > 
> 
