Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE33D37B111
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 May 2021 23:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhEKVx0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 May 2021 17:53:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52829 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhEKVxZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 May 2021 17:53:25 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id DA1865C00D4;
        Tue, 11 May 2021 17:52:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 11 May 2021 17:52:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=fm3; bh=4F9IhBCXlBm3lNOKPN9+0FsQ5fXPDkV14yHIUMq9
        fj0=; b=XbhgUl31Y2Q0rsuk/FA6unDD9kH9+LGZPQjAMltkmP+gV/Vcg/SAKBi4
        bTJjVtREUaUxkl2ZZwG5Kw+P9gkmqyFanXWuuAQndNpBdc29F4wl8H9r+lDmUcj0
        gwhr33zInSFiMqQ4ZFhK2TZs4/pzmzRVrwZHO6w2AkfRN04ssIUooG++ezQqbh5k
        CQ7jCzDDuAwmhKrmW8y4ZgfP9Eh4s17ZbmQbNq4CgmQfSrc9e85LAm646GuagPoF
        kLLGkNRNPj8YLuZ2UvGPG6YrKkH78iMtchswDFLoC4Z+Ry5FjhixI13XnzIA2y6s
        e0L1PYut8pLYv1UGDahh67tU5MVxRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4F9IhB
        CXlBm3lNOKPN9+0FsQ5fXPDkV14yHIUMq9fj0=; b=Tn04Ym1rA7QamDhNnyyw4T
        3LhKDbVJxYUZMf/d/6Bp4Ce5VfWur/RZ6gwdsrv2TwJzMprgwHqurCLdc2V2h/40
        sCFrCryCY7uCjw6sRB+DZtvfZcN2hCgtJ9+AmvE18XTOY9/cBqTANaumkdSk6VDV
        hHU4rV1KR9pq5yshM/qIuHcYJFxYpm+NgO+NwaTTmZyLlpX3hit7qC1//4AXhtj7
        L1s1f68uwf69Q69IEgu0n8ZByZ3wyfT5EV5vQpiXW2Cl/nyEBkCbUbZKhvfQBq6f
        QbVj8B5G1EHJ2RkPEeOchgJrocShWKF0pqdV6ZJviKIDf30JyWr3J2YuxT4TZ9Lw
        ==
X-ME-Sender: <xms:kfyaYJjWQic3YqSde2ibwqcLtqt2jSEsPOkSgl8_J7tF0tWEGxejfw>
    <xme:kfyaYOAKWLDGG-uk62uOQSnjd-kC0rYp2NNniCHztNjZWSY8Yo0uvR-uU2GeGy2P1
    Uq-fA5JH4YH0PxjRX8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehuddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpedtvdfftddvveduieejtedufeeuudefueefhfduje
    dutdegtddtffffiefgtefgtdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    pedvtdejrdehfedrvdehfedrjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:kfyaYJE5Im1z0gA-y12xTiWMU40TkUSI4Plbh-BV30CLKgHe7Fyvag>
    <xmx:kfyaYOQ02kvhbOOjUzZMeKVDkbwFg3I9Pk2NP5LK7TZMIZS0i_EJhw>
    <xmx:kfyaYGwh4Q0Iit4ImrFurnBFLTOeZHyKz7MH-o03R1SuoEyL8jRjhA>
    <xmx:kfyaYLp4RapS255ZbsUcWNdWjzjnBtRwDy7JkyimXZizfxckokq1ig>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 11 May 2021 17:52:17 -0400 (EDT)
Date:   Tue, 11 May 2021 14:52:15 -0700
From:   Boris Burkov <boris@bur.io>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 2/5] btrfs: initial fsverity support
Message-ID: <YJr8j3Kd6d1yW5bc@zen>
References: <cover.1620240133.git.boris@bur.io>
 <dd0cfc38c6de927de63f34f96499dc8f80398754.1620241221.git.boris@bur.io>
 <20210511203143.GN7604@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511203143.GN7604@twin.jikos.cz>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 11, 2021 at 10:31:43PM +0200, David Sterba wrote:
> On Wed, May 05, 2021 at 12:20:40PM -0700, Boris Burkov wrote:
> > From: Chris Mason <clm@fb.com>
> > 
> > Add support for fsverity in btrfs. To support the generic interface in
> > fs/verity, we add two new item types in the fs tree for inodes with
> > verity enabled. One stores the per-file verity descriptor and the other
> > stores the Merkle tree data itself.
> > 
> > Verity checking is done at the end of IOs to ensure each page is checked
> > before it is marked uptodate.
> > 
> > Verity relies on PageChecked for the Merkle tree data itself to avoid
> > re-walking up shared paths in the tree. For this reason, we need to
> > cache the Merkle tree data.
> 
> What's the estimated size of the Merkle tree data? Does the whole tree
> need to be kept cached or is it only for data that are in page cache?

With the default of SHA256 and 4K blocks, we have 32 byte digests which
which fits 128 digests per block, so the Merkle tree will be almost
exactly 1/127 of the size of the file.

As far as I know, there is no special requirement that the Merkle tree
data stays cached. If a Merkle tree block is evicted, then a data block
is evicted and re-read, we would need to read the Merkle tree block
again and possibly up the path to the root until a cached block with
PageChecked.

> 
> > Since the file is immutable after verity is
> > turned on, we can cache it at an index past EOF.
> > 
> > Use the new inode compat_flags to store verity on the inode item, so
> > that we can enable verity on a file, then rollback to an older kernel
> > and still mount the file system and read the file. Since we can't safely
> > write the file anymore without ruining the invariants of the Merkle
> > tree, we mark a ro_compat flag on the file system when a file has verity
> > enabled.
> > 
> > Signed-off-by: Chris Mason <clm@fb.com>
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >  fs/btrfs/Makefile               |   1 +
> >  fs/btrfs/btrfs_inode.h          |   1 +
> >  fs/btrfs/ctree.h                |  30 +-
> >  fs/btrfs/extent_io.c            |  27 +-
> >  fs/btrfs/file.c                 |   6 +
> >  fs/btrfs/inode.c                |   7 +
> >  fs/btrfs/ioctl.c                |  14 +-
> >  fs/btrfs/super.c                |   3 +
> >  fs/btrfs/sysfs.c                |   6 +
> >  fs/btrfs/verity.c               | 617 ++++++++++++++++++++++++++++++++
> >  include/uapi/linux/btrfs.h      |   2 +-
> >  include/uapi/linux/btrfs_tree.h |  15 +
> >  12 files changed, 718 insertions(+), 11 deletions(-)
> >  create mode 100644 fs/btrfs/verity.c
> > 
> > diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
> > index cec88a66bd6c..3dcf9bcc2326 100644
> > --- a/fs/btrfs/Makefile
> > +++ b/fs/btrfs/Makefile
> > @@ -36,6 +36,7 @@ btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
> >  btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
> >  btrfs-$(CONFIG_BTRFS_FS_REF_VERIFY) += ref-verify.o
> >  btrfs-$(CONFIG_BLK_DEV_ZONED) += zoned.o
> > +btrfs-$(CONFIG_FS_VERITY) += verity.o
> >  
> >  btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o \
> >  	tests/extent-buffer-tests.o tests/btrfs-tests.o \
> > diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> > index e8dbc8e848ce..4536548b9e79 100644
> > --- a/fs/btrfs/btrfs_inode.h
> > +++ b/fs/btrfs/btrfs_inode.h
> > @@ -51,6 +51,7 @@ enum {
> >  	 * the file range, inode's io_tree).
> >  	 */
> >  	BTRFS_INODE_NO_DELALLOC_FLUSH,
> > +	BTRFS_INODE_VERITY_IN_PROGRESS,
> 
> Please add a comment
> 
> >  };
> >  
> >  /* in memory btrfs inode */
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 0546273a520b..c5aab6a639ef 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -279,9 +279,10 @@ struct btrfs_super_block {
> >  #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
> >  #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
> >  
> > -#define BTRFS_FEATURE_COMPAT_RO_SUPP			\
> > -	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
> > -	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID)
> > +#define BTRFS_FEATURE_COMPAT_RO_SUPP				\
> > +	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |		\
> > +	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID |	\
> > +	 BTRFS_FEATURE_COMPAT_RO_VERITY)
> >  
> >  #define BTRFS_FEATURE_COMPAT_RO_SAFE_SET	0ULL
> >  #define BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR	0ULL
> > @@ -1505,6 +1506,11 @@ do {                                                                   \
> >  	 BTRFS_INODE_COMPRESS |						\
> >  	 BTRFS_INODE_ROOT_ITEM_INIT)
> >  
> > +/*
> > + * Inode compat flags
> > + */
> > +#define BTRFS_INODE_VERITY		(1 << 0)
> > +
> >  struct btrfs_map_token {
> >  	struct extent_buffer *eb;
> >  	char *kaddr;
> > @@ -3766,6 +3772,24 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
> >  	return signal_pending(current);
> >  }
> >  
> > +/* verity.c */
> > +#ifdef CONFIG_FS_VERITY
> > +extern const struct fsverity_operations btrfs_verityops;
> > +int btrfs_drop_verity_items(struct btrfs_inode *inode);
> > +BTRFS_SETGET_FUNCS(verity_descriptor_encryption, struct btrfs_verity_descriptor_item,
> > +		   encryption, 8);
> > +BTRFS_SETGET_FUNCS(verity_descriptor_size, struct btrfs_verity_descriptor_item, size, 64);
> > +BTRFS_SETGET_STACK_FUNCS(stack_verity_descriptor_encryption, struct btrfs_verity_descriptor_item,
> > +			 encryption, 8);
> > +BTRFS_SETGET_STACK_FUNCS(stack_verity_descriptor_size, struct btrfs_verity_descriptor_item,
> > +			 size, 64);
> > +#else
> > +static inline int btrfs_drop_verity_items(struct btrfs_inode *inode)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> >  /* Sanity test specific functions */
> >  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> >  void btrfs_test_destroy_inode(struct inode *inode);
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index 4fb33cadc41a..d1f57a4ad2fb 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/pagevec.h>
> >  #include <linux/prefetch.h>
> >  #include <linux/cleancache.h>
> > +#include <linux/fsverity.h>
> >  #include "misc.h"
> >  #include "extent_io.h"
> >  #include "extent-io-tree.h"
> > @@ -2862,15 +2863,28 @@ static void begin_page_read(struct btrfs_fs_info *fs_info, struct page *page)
> >  	btrfs_subpage_start_reader(fs_info, page, page_offset(page), PAGE_SIZE);
> >  }
> >  
> > -static void end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
> > +static int end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
> >  {
> > -	struct btrfs_fs_info *fs_info = btrfs_sb(page->mapping->host->i_sb);
> > +	int ret = 0;
> > +	struct inode *inode = page->mapping->host;
> > +	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> >  
> >  	ASSERT(page_offset(page) <= start &&
> >  		start + len <= page_offset(page) + PAGE_SIZE);
> >  
> >  	if (uptodate) {
> > -		btrfs_page_set_uptodate(fs_info, page, start, len);
> > +		/*
> > +		 * buffered reads of a file with page alignment will issue a
> > +		 * 0 length read for one page past the end of file, so we must
> > +		 * explicitly skip checking verity on that page of zeros.
> > +		 */
> > +		if (!PageError(page) && !PageUptodate(page) &&
> > +		    start < i_size_read(inode) &&
> > +		    fsverity_active(inode) &&
> > +		    !fsverity_verify_page(page))
> > +			ret = -EIO;
> > +		else
> > +			btrfs_page_set_uptodate(fs_info, page, start, len);
> >  	} else {
> >  		btrfs_page_clear_uptodate(fs_info, page, start, len);
> >  		btrfs_page_set_error(fs_info, page, start, len);
> > @@ -2878,12 +2892,13 @@ static void end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
> >  
> >  	if (fs_info->sectorsize == PAGE_SIZE)
> >  		unlock_page(page);
> > -	else if (is_data_inode(page->mapping->host))
> > +	else if (is_data_inode(inode))
> >  		/*
> >  		 * For subpage data, unlock the page if we're the last reader.
> >  		 * For subpage metadata, page lock is not utilized for read.
> >  		 */
> >  		btrfs_subpage_end_reader(fs_info, page, start, len);
> > +	return ret;
> >  }
> >  
> >  /*
> > @@ -3059,7 +3074,9 @@ static void end_bio_extent_readpage(struct bio *bio)
> >  		bio_offset += len;
> >  
> >  		/* Update page status and unlock */
> > -		end_page_read(page, uptodate, start, len);
> > +		ret = end_page_read(page, uptodate, start, len);
> > +		if (ret)
> > +			uptodate = 0;
> >  		endio_readpage_release_extent(&processed, BTRFS_I(inode),
> >  					      start, end, uptodate);
> >  	}
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 3b10d98b4ebb..a99470303bd9 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/btrfs.h>
> >  #include <linux/uio.h>
> >  #include <linux/iversion.h>
> > +#include <linux/fsverity.h>
> >  #include "ctree.h"
> >  #include "disk-io.h"
> >  #include "transaction.h"
> > @@ -3593,7 +3594,12 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int whence)
> >  
> >  static int btrfs_file_open(struct inode *inode, struct file *filp)
> >  {
> > +	int ret;
> 
> Missing newline

Weird, I ran checkpatch so many times.. My bad.

> 
> >  	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
> > +
> > +	ret = fsverity_file_open(inode, filp);
> > +	if (ret)
> > +		return ret;
> >  	return generic_file_open(inode, filp);
> >  }
> >  
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index d89000577f7f..1b1101369777 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/sched/mm.h>
> >  #include <linux/iomap.h>
> >  #include <asm/unaligned.h>
> > +#include <linux/fsverity.h>
> >  #include "misc.h"
> >  #include "ctree.h"
> >  #include "disk-io.h"
> > @@ -5405,7 +5406,9 @@ void btrfs_evict_inode(struct inode *inode)
> >  
> >  	trace_btrfs_inode_evict(inode);
> >  
> > +
> 
> Extra newline
> 
> >  	if (!root) {
> > +		fsverity_cleanup_inode(inode);
> >  		clear_inode(inode);
> >  		return;
> >  	}
> > @@ -5488,6 +5491,7 @@ void btrfs_evict_inode(struct inode *inode)
> >  	 * to retry these periodically in the future.
> >  	 */
> >  	btrfs_remove_delayed_node(BTRFS_I(inode));
> > +	fsverity_cleanup_inode(inode);
> >  	clear_inode(inode);
> >  }
> >  
> > @@ -9041,6 +9045,7 @@ static int btrfs_getattr(struct user_namespace *mnt_userns,
> >  	struct inode *inode = d_inode(path->dentry);
> >  	u32 blocksize = inode->i_sb->s_blocksize;
> >  	u32 bi_flags = BTRFS_I(inode)->flags;
> > +	u32 bi_compat_flags = BTRFS_I(inode)->compat_flags;
> >  
> >  	stat->result_mask |= STATX_BTIME;
> >  	stat->btime.tv_sec = BTRFS_I(inode)->i_otime.tv_sec;
> > @@ -9053,6 +9058,8 @@ static int btrfs_getattr(struct user_namespace *mnt_userns,
> >  		stat->attributes |= STATX_ATTR_IMMUTABLE;
> >  	if (bi_flags & BTRFS_INODE_NODUMP)
> >  		stat->attributes |= STATX_ATTR_NODUMP;
> > +	if (bi_compat_flags & BTRFS_INODE_VERITY)
> > +		stat->attributes |= STATX_ATTR_VERITY;
> >  
> >  	stat->attributes_mask |= (STATX_ATTR_APPEND |
> >  				  STATX_ATTR_COMPRESSED |
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index ff335c192170..4b8f38fe4226 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/btrfs.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/iversion.h>
> > +#include <linux/fsverity.h>
> >  #include "ctree.h"
> >  #include "disk-io.h"
> >  #include "export.h"
> > @@ -105,6 +106,7 @@ static unsigned int btrfs_mask_fsflags_for_type(struct inode *inode,
> >  static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
> >  {
> >  	unsigned int flags = binode->flags;
> > +	unsigned int compat_flags = binode->compat_flags;
> >  	unsigned int iflags = 0;
> >  
> >  	if (flags & BTRFS_INODE_SYNC)
> > @@ -121,6 +123,8 @@ static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
> >  		iflags |= FS_DIRSYNC_FL;
> >  	if (flags & BTRFS_INODE_NODATACOW)
> >  		iflags |= FS_NOCOW_FL;
> > +	if (compat_flags & BTRFS_INODE_VERITY)
> > +		iflags |= FS_VERITY_FL;
> >  
> >  	if (flags & BTRFS_INODE_NOCOMPRESS)
> >  		iflags |= FS_NOCOMP_FL;
> > @@ -148,10 +152,12 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
> >  		new_fl |= S_NOATIME;
> >  	if (binode->flags & BTRFS_INODE_DIRSYNC)
> >  		new_fl |= S_DIRSYNC;
> > +	if (binode->compat_flags & BTRFS_INODE_VERITY)
> > +		new_fl |= S_VERITY;
> >  
> >  	set_mask_bits(&inode->i_flags,
> > -		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC,
> > -		      new_fl);
> > +		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC |
> > +		      S_VERITY, new_fl);
> >  }
> >  
> >  static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
> > @@ -5072,6 +5078,10 @@ long btrfs_ioctl(struct file *file, unsigned int
> >  		return btrfs_ioctl_get_subvol_rootref(file, argp);
> >  	case BTRFS_IOC_INO_LOOKUP_USER:
> >  		return btrfs_ioctl_ino_lookup_user(file, argp);
> > +	case FS_IOC_ENABLE_VERITY:
> > +		return fsverity_ioctl_enable(file, (const void __user *)argp);
> > +	case FS_IOC_MEASURE_VERITY:
> > +		return fsverity_ioctl_measure(file, argp);
> >  	}
> >  
> >  	return -ENOTTY;
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 4a396c1147f1..aa41ee30e3ca 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -1365,6 +1365,9 @@ static int btrfs_fill_super(struct super_block *sb,
> >  	sb->s_op = &btrfs_super_ops;
> >  	sb->s_d_op = &btrfs_dentry_operations;
> >  	sb->s_export_op = &btrfs_export_ops;
> > +#ifdef CONFIG_FS_VERITY
> > +	sb->s_vop = &btrfs_verityops;
> > +#endif
> >  	sb->s_xattr = btrfs_xattr_handlers;
> >  	sb->s_time_gran = 1;
> >  #ifdef CONFIG_BTRFS_FS_POSIX_ACL
> > diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> > index 436ac7b4b334..331ea4febcb1 100644
> > --- a/fs/btrfs/sysfs.c
> > +++ b/fs/btrfs/sysfs.c
> > @@ -267,6 +267,9 @@ BTRFS_FEAT_ATTR_INCOMPAT(raid1c34, RAID1C34);
> >  #ifdef CONFIG_BTRFS_DEBUG
> >  BTRFS_FEAT_ATTR_INCOMPAT(zoned, ZONED);
> >  #endif
> > +#ifdef CONFIG_FS_VERITY
> > +BTRFS_FEAT_ATTR_COMPAT_RO(verity, VERITY);
> > +#endif
> >  
> >  static struct attribute *btrfs_supported_feature_attrs[] = {
> >  	BTRFS_FEAT_ATTR_PTR(mixed_backref),
> > @@ -284,6 +287,9 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
> >  	BTRFS_FEAT_ATTR_PTR(raid1c34),
> >  #ifdef CONFIG_BTRFS_DEBUG
> >  	BTRFS_FEAT_ATTR_PTR(zoned),
> > +#endif
> > +#ifdef CONFIG_FS_VERITY
> > +	BTRFS_FEAT_ATTR_PTR(verity),
> >  #endif
> >  	NULL
> >  };
> > diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> > new file mode 100644
> > index 000000000000..feaf5908b3d3
> > --- /dev/null
> > +++ b/fs/btrfs/verity.c
> > @@ -0,0 +1,617 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2020 Facebook.  All rights reserved.
> > + */
> 
> This is not necessary since we have the SPDX tags,
> https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Copyright_notices_in_files.2C_SPDX
> 
> > +
> > +#include <linux/init.h>
> > +#include <linux/fs.h>
> > +#include <linux/slab.h>
> > +#include <linux/rwsem.h>
> > +#include <linux/xattr.h>
> > +#include <linux/security.h>
> > +#include <linux/posix_acl_xattr.h>
> > +#include <linux/iversion.h>
> > +#include <linux/fsverity.h>
> > +#include <linux/sched/mm.h>
> > +#include "ctree.h"
> > +#include "btrfs_inode.h"
> > +#include "transaction.h"
> > +#include "disk-io.h"
> > +#include "locking.h"
> > +
> > +/*
> > + * Just like ext4, we cache the merkle tree in pages after EOF in the page
> > + * cache.  Unlike ext4, we're storing these in dedicated btree items and
> > + * not just shoving them after EOF in the file.  This means we'll need to
> > + * do extra work to encrypt them once encryption is supported in btrfs,
> > + * but btrfs has a lot of careful code around i_size and it seems better
> > + * to make a new key type than try and adjust all of our expectations
> > + * for i_size.
> 
> Can you please rephrase that so it does not start with what other
> filesystems do but what is the actual design and put references to ext4
> eventually?
> 
> > + *
> > + * fs verity items are stored under two different key types on disk.
> > + *
> > + * The descriptor items:
> > + * [ inode objectid, BTRFS_VERITY_DESC_ITEM_KEY, offset ]
> 
> Please put that to the key definitions

Do you mean to move this whole comment to btrfs_tree.h?

> 
> > + *
> > + * At offset 0, we store a btrfs_verity_descriptor_item which tracks the
> > + * size of the descriptor item and some extra data for encryption.
> > + * Starting at offset 1, these hold the generic fs verity descriptor.
> > + * These are opaque to btrfs, we just read and write them as a blob for
> > + * the higher level verity code.  The most common size for this is 256 bytes.
> > + *
> > + * The merkle tree items:
> > + * [ inode objectid, BTRFS_VERITY_MERKLE_ITEM_KEY, offset ]
> > + *
> > + * These also start at offset 0, and correspond to the merkle tree bytes.
> > + * So when fsverity asks for page 0 of the merkle tree, we pull up one page
> > + * starting at offset 0 for this key type.  These are also opaque to btrfs,
> > + * we're blindly storing whatever fsverity sends down.
> > + */
> > +
> > +/*
> > + * Compute the logical file offset where we cache the Merkle tree.
> > + *
> > + * @inode: the inode of the verity file
> > + *
> > + * For the purposes of caching the Merkle tree pages, as required by
> > + * fs-verity, it is convenient to do size computations in terms of a file
> > + * offset, rather than in terms of page indices.
> > + *
> > + * Returns the file offset on success, negative error code on failure.
> > + */
> > +static loff_t merkle_file_pos(const struct inode *inode)
> > +{
> > +	u64 sz = inode->i_size;
> > +	u64 ret = round_up(sz, 65536);
> 
> What's the reason for the extra variable sz? If that is meant to make
> the whole u64 is read consistently, then it needs protection and the
> i_read_size if the status of inode lock and context of call is unknown.
> Compiler will happily merge that to round_up(inode->i_size).

This was the result of getting a bit lazy reading assembly. My intent
was to ensure that we don't overflow the round_up, which is a macro that
depends on the type of the input. I was messing around figuring out what
effect casting had on it but gave up and just put it in a u64 before
calling it.

> 
> Next, what's the meaning of the constant 65536?
> 

It's arbitrary, and copied from ext4. I _believe_ the idea behind it is
that it should be a fixed constant to avoid making the page size change
the maximum file size subtly, but should be big enough to be a fresh
page truly past the end of the file pages on a 64K page size system.

> > +
> > +	if (ret > inode->i_sb->s_maxbytes)
> > +		return -EFBIG;
> > +	return ret;
> 
> ret is u64 so the function should also return u64

This was intentional as we do want an loff_t (long long) returned, but
use the u64 for the overflow checking above.

> 
> > +}
> > +
> > +/*
> > + * Drop all the items for this inode with this key_type.
> 
> Newline
> 
> > + * @inode: The inode to drop items for
> > + * @key_type: The type of items to drop (VERITY_DESC_ITEM or
> > + *            VERITY_MERKLE_ITEM)
> 
> Please format the agrumgenst according to the description in
> https://btrfs.wiki.kernel.org/index.php/Development_notes#Comments
> 
> > + *
> > + * Before doing a verity enable we cleanup any existing verity items.
> > + *
> > + * This is also used to clean up if a verity enable failed half way
> > + * through.
> > + *
> > + * Returns 0 on success, negative error code on failure.
> > + */
> > +static int drop_verity_items(struct btrfs_inode *inode, u8 key_type)
> > +{
> > +	struct btrfs_trans_handle *trans;
> > +	struct btrfs_root *root = inode->root;
> > +	struct btrfs_path *path;
> > +	struct btrfs_key key;
> > +	int ret;
> > +
> > +	path = btrfs_alloc_path();
> > +	if (!path)
> > +		return -ENOMEM;
> > +
> > +	while (1) {
> > +		trans = btrfs_start_transaction(root, 1);
> 
> Transaction start should document what are the reserved items, ie. what
> is the 1 related to.
> 
> > +		if (IS_ERR(trans)) {
> > +			ret = PTR_ERR(trans);
> > +			goto out;
> > +		}
> > +
> > +		/*
> > +		 * walk backwards through all the items until we find one
> 
> Comments should start with uppercase unless it's and identifier name.
> This is in many other places so please update them as well.
> 
> > +		 * that isn't from our key type or objectid
> > +		 */
> > +		key.objectid = btrfs_ino(inode);
> > +		key.offset = (u64)-1;
> > +		key.type = key_type;
> 
> It's common to sort the members as they go in order so
> objectid/type/offset, this helps to keep the idea of the key.
> 
> > +
> > +		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
> > +		if (ret > 0) {
> > +			ret = 0;
> > +			/* no more keys of this type, we're done */
> > +			if (path->slots[0] == 0)
> > +				break;
> > +			path->slots[0]--;
> > +		} else if (ret < 0) {
> > +			break;
> > +		}
> > +
> > +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> > +
> > +		/* no more keys of this type, we're done */
> > +		if (key.objectid != btrfs_ino(inode) || key.type != key_type)
> > +			break;
> > +
> > +		/*
> > +		 * this shouldn't be a performance sensitive function because
> > +		 * it's not used as part of truncate.  If it ever becomes
> > +		 * perf sensitive, change this to walk forward and bulk delete
> > +		 * items
> > +		 */
> > +		ret = btrfs_del_items(trans, root, path,
> > +				      path->slots[0], 1);
> 
> This will probably fit on one line, no need to split the parameters.
> 
> > +		btrfs_release_path(path);
> > +		btrfs_end_transaction(trans);
> > +
> > +		if (ret)
> > +			goto out;
> > +	}
> > +
> > +	btrfs_end_transaction(trans);
> > +out:
> > +	btrfs_free_path(path);
> > +	return ret;
> > +
> > +}
> > +
> > +/*
> > + * Insert and write inode items with a given key type and offset.
> > + * @inode: The inode to insert for.
> > + * @key_type: The key type to insert.
> > + * @offset: The item offset to insert at.
> > + * @src: Source data to write.
> > + * @len: Length of source data to write.
> > + *
> > + * Write len bytes from src into items of up to 1k length.
> > + * The inserted items will have key <ino, key_type, offset + off> where
> > + * off is consecutively increasing from 0 up to the last item ending at
> > + * offset + len.
> > + *
> > + * Returns 0 on success and a negative error code on failure.
> > + */
> > +static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
> > +			   const char *src, u64 len)
> > +{
> > +	struct btrfs_trans_handle *trans;
> > +	struct btrfs_path *path;
> > +	struct btrfs_root *root = inode->root;
> > +	struct extent_buffer *leaf;
> > +	struct btrfs_key key;
> > +	u64 copied = 0;
> > +	unsigned long copy_bytes;
> > +	unsigned long src_offset = 0;
> > +	void *data;
> > +	int ret;
> > +
> > +	path = btrfs_alloc_path();
> > +	if (!path)
> > +		return -ENOMEM;
> > +
> > +	while (len > 0) {
> > +		trans = btrfs_start_transaction(root, 1);
> 
> Same as before, please document what items are reserved
> 
> > +		if (IS_ERR(trans)) {
> > +			ret = PTR_ERR(trans);
> > +			break;
> > +		}
> > +
> > +		key.objectid = btrfs_ino(inode);
> > +		key.offset = offset;
> > +		key.type = key_type;
> 
> objectid/type/offset
> 
> > +
> > +		/*
> > +		 * insert 1K at a time mostly to be friendly for smaller
> > +		 * leaf size filesystems
> > +		 */
> > +		copy_bytes = min_t(u64, len, 1024);
> > +
> > +		ret = btrfs_insert_empty_item(trans, root, path, &key, copy_bytes);
> > +		if (ret) {
> > +			btrfs_end_transaction(trans);
> > +			break;
> > +		}
> > +
> > +		leaf = path->nodes[0];
> > +
> > +		data = btrfs_item_ptr(leaf, path->slots[0], void);
> > +		write_extent_buffer(leaf, src + src_offset,
> > +				    (unsigned long)data, copy_bytes);
> > +		offset += copy_bytes;
> > +		src_offset += copy_bytes;
> > +		len -= copy_bytes;
> > +		copied += copy_bytes;
> > +
> > +		btrfs_release_path(path);
> > +		btrfs_end_transaction(trans);
> > +	}
> > +
> > +	btrfs_free_path(path);
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Read inode items of the given key type and offset from the btree.
> > + * @inode: The inode to read items of.
> > + * @key_type: The key type to read.
> > + * @offset: The item offset to read from.
> > + * @dest: The buffer to read into. This parameter has slightly tricky
> > + *        semantics.  If it is NULL, the function will not do any copying
> > + *        and will just return the size of all the items up to len bytes.
> > + *        If dest_page is passed, then the function will kmap_atomic the
> > + *        page and ignore dest, but it must still be non-NULL to avoid the
> > + *        counting-only behavior.
> > + * @len: Length in bytes to read.
> > + * @dest_page: Copy into this page instead of the dest buffer.
> > + *
> > + * Helper function to read items from the btree.  This returns the number
> > + * of bytes read or < 0 for errors.  We can return short reads if the
> > + * items don't exist on disk or aren't big enough to fill the desired length.
> > + *
> > + * Supports reading into a provided buffer (dest) or into the page cache
> > + *
> > + * Returns number of bytes read or a negative error code on failure.
> > + */
> > +static ssize_t read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
> 
> Why does this return ssize_t? The type is not utilized anywhere in the
> function an 'int' should work.
> 
> > +			  char *dest, u64 len, struct page *dest_page)
> > +{
> > +	struct btrfs_path *path;
> > +	struct btrfs_root *root = inode->root;
> > +	struct extent_buffer *leaf;
> > +	struct btrfs_key key;
> > +	u64 item_end;
> > +	u64 copy_end;
> > +	u64 copied = 0;
> 
> Here copied is u64
> 
> > +	u32 copy_offset;
> > +	unsigned long copy_bytes;
> > +	unsigned long dest_offset = 0;
> > +	void *data;
> > +	char *kaddr = dest;
> > +	int ret;
> 
> and ret is int
> 
> > +
> > +	path = btrfs_alloc_path();
> > +	if (!path)
> > +		return -ENOMEM;
> > +
> > +	if (dest_page)
> > +		path->reada = READA_FORWARD;
> > +
> > +	key.objectid = btrfs_ino(inode);
> > +	key.offset = offset;
> > +	key.type = key_type;
> > +
> > +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> > +	if (ret < 0) {
> > +		goto out;
> > +	} else if (ret > 0) {
> > +		ret = 0;
> > +		if (path->slots[0] == 0)
> > +			goto out;
> > +		path->slots[0]--;
> > +	}
> > +
> > +	while (len > 0) {
> > +		leaf = path->nodes[0];
> > +		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
> > +
> > +		if (key.objectid != btrfs_ino(inode) ||
> > +		    key.type != key_type)
> > +			break;
> > +
> > +		item_end = btrfs_item_size_nr(leaf, path->slots[0]) + key.offset;
> > +
> > +		if (copied > 0) {
> > +			/*
> > +			 * once we've copied something, we want all of the items
> > +			 * to be sequential
> > +			 */
> > +			if (key.offset != offset)
> > +				break;
> > +		} else {
> > +			/*
> > +			 * our initial offset might be in the middle of an
> > +			 * item.  Make sure it all makes sense
> > +			 */
> > +			if (key.offset > offset)
> > +				break;
> > +			if (item_end <= offset)
> > +				break;
> > +		}
> > +
> > +		/* desc = NULL to just sum all the item lengths */
> > +		if (!dest)
> > +			copy_end = item_end;
> > +		else
> > +			copy_end = min(offset + len, item_end);
> > +
> > +		/* number of bytes in this item we want to copy */
> > +		copy_bytes = copy_end - offset;
> > +
> > +		/* offset from the start of item for copying */
> > +		copy_offset = offset - key.offset;
> > +
> > +		if (dest) {
> > +			if (dest_page)
> > +				kaddr = kmap_atomic(dest_page);
> 
> I think the kmap_atomic should not be used, there was a patchset
> cleaning it up and replacing by kmap_local so we should not introduce
> new instances.
> 
> > +
> > +			data = btrfs_item_ptr(leaf, path->slots[0], void);
> > +			read_extent_buffer(leaf, kaddr + dest_offset,
> > +					   (unsigned long)data + copy_offset,
> > +					   copy_bytes);
> > +
> > +			if (dest_page)
> > +				kunmap_atomic(kaddr);
> > +		}
> > +
> > +		offset += copy_bytes;
> > +		dest_offset += copy_bytes;
> > +		len -= copy_bytes;
> > +		copied += copy_bytes;
> > +
> > +		path->slots[0]++;
> > +		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
> > +			/*
> > +			 * we've reached the last slot in this leaf and we need
> > +			 * to go to the next leaf.
> > +			 */
> > +			ret = btrfs_next_leaf(root, path);
> > +			if (ret < 0) {
> > +				break;
> > +			} else if (ret > 0) {
> > +				ret = 0;
> > +				break;
> > +			}
> > +		}
> > +	}
> > +out:
> > +	btrfs_free_path(path);
> > +	if (!ret)
> > +		ret = copied;
> > +	return ret;
> 
> In the end it's int and copied u64 is truncated to int.
> 
> > +}
> > +
> > +/*
> > + * Drop verity items from the btree and from the page cache
> > + *
> > + * @inode: the inode to drop items for
> > + *
> > + * If we fail partway through enabling verity, enable verity and have some
> > + * partial data extant, or cleanup orphaned verity data, we need to truncate it
>                    extent
> 
> > + * from the cache and delete the items themselves from the btree.
> > + *
> > + * Returns 0 on success, negative error code on failure.
> > + */
> > +int btrfs_drop_verity_items(struct btrfs_inode *inode)
> > +{
> > +	int ret;
> > +	struct inode *ino = &inode->vfs_inode;
> 
> 'ino' is usually used for inode number so this is a bit confusing,
> 
> > +
> > +	truncate_inode_pages(ino->i_mapping, ino->i_size);
> > +	ret = drop_verity_items(inode, BTRFS_VERITY_DESC_ITEM_KEY);
> > +	if (ret)
> > +		return ret;
> > +	return drop_verity_items(inode, BTRFS_VERITY_MERKLE_ITEM_KEY);
> > +}
> > +
> > +/*
> > + * fsverity op that begins enabling verity.
> > + * fsverity calls this to ask us to setup the inode for enabling.  We
> > + * drop any existing verity items and set the in progress bit.
> 
> Please rephrase it so it says something like "Begin enabling verity on
> and inode. We drop ... "
> 
> > + */
> > +static int btrfs_begin_enable_verity(struct file *filp)
> > +{
> > +	struct inode *inode = file_inode(filp);
> 
> Please replace this with struct btrfs_inode * inode = ... and don't do
> the BTRFS_I conversion in the rest of the function.
> 
> > +	int ret;
> > +
> > +	if (test_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &BTRFS_I(inode)->runtime_flags))
> > +		return -EBUSY;
> > +
> > +	set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &BTRFS_I(inode)->runtime_flags);
> 
> So the test and set are separate, can this race? No, as this is called
> under the inode lock but this needs a trip to fsverity sources so be
> sure. I'd suggest to put at least inode lock assertion, or a comment but
> this is weaker than a runtime check.
> 
> > +	ret = drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY);
> > +	if (ret)
> > +		goto err;
> > +
> > +	ret = drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY);
> > +	if (ret)
> > +		goto err;
> > +
> > +	return 0;
> > +
> > +err:
> > +	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &BTRFS_I(inode)->runtime_flags);
> > +	return ret;
> > +
> 
> Extra newline
> 
> > +}
> > +
> > +/*
> > + * fsverity op that ends enabling verity.
> > + * fsverity calls this when it's done with all of the pages in the file
> > + * and all of the merkle items have been inserted.  We write the
> > + * descriptor and update the inode in the btree to reflect its new life
> > + * as a verity file.
> 
> Please rephrase
> 
> > + */
> > +static int btrfs_end_enable_verity(struct file *filp, const void *desc,
> > +				  size_t desc_size, u64 merkle_tree_size)
> > +{
> > +	struct btrfs_trans_handle *trans;
> > +	struct inode *inode = file_inode(filp);
> 
> Same as above, replace by btrfs inode and drop BTRFS_I below
> 
> > +	struct btrfs_root *root = BTRFS_I(inode)->root;
> > +	struct btrfs_verity_descriptor_item item;
> > +	int ret;
> > +
> > +	if (desc != NULL) {
> > +		/* write out the descriptor item */
> > +		memset(&item, 0, sizeof(item));
> > +		btrfs_set_stack_verity_descriptor_size(&item, desc_size);
> > +		ret = write_key_bytes(BTRFS_I(inode),
> > +				      BTRFS_VERITY_DESC_ITEM_KEY, 0,
> > +				      (const char *)&item, sizeof(item));
> > +		if (ret)
> > +			goto out;
> > +		/* write out the descriptor itself */
> > +		ret = write_key_bytes(BTRFS_I(inode),
> > +				      BTRFS_VERITY_DESC_ITEM_KEY, 1,
> > +				      desc, desc_size);
> > +		if (ret)
> > +			goto out;
> > +
> > +		/* update our inode flags to include fs verity */
> > +		trans = btrfs_start_transaction(root, 1);
> > +		if (IS_ERR(trans)) {
> > +			ret = PTR_ERR(trans);
> > +			goto out;
> > +		}
> > +		BTRFS_I(inode)->compat_flags |= BTRFS_INODE_VERITY;
> > +		btrfs_sync_inode_flags_to_i_flags(inode);
> > +		ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
> > +		btrfs_end_transaction(trans);
> > +	}
> > +
> > +out:
> > +	if (desc == NULL || ret) {
> > +		/* If we failed, drop all the verity items */
> > +		drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY);
> > +		drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY);
> > +	} else
> 
> 	} else {
> 
> > +		btrfs_set_fs_compat_ro(root->fs_info, VERITY);
> 
> 	}
> 
> > +	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &BTRFS_I(inode)->runtime_flags);
> > +	return ret;
> > +}
> > +
> > +/*
> > + * fsverity op that gets the struct fsverity_descriptor.
> > + * fsverity does a two pass setup for reading the descriptor, in the first pass
> > + * it calls with buf_size = 0 to query the size of the descriptor,
> > + * and then in the second pass it actually reads the descriptor off
> > + * disk.
> > + */
> > +static int btrfs_get_verity_descriptor(struct inode *inode, void *buf,
> > +				       size_t buf_size)
> > +{
> > +	u64 true_size;
> > +	ssize_t ret = 0;
> > +	struct btrfs_verity_descriptor_item item;
> > +
> > +	memset(&item, 0, sizeof(item));
> > +	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY,
> > +			     0, (char *)&item, sizeof(item), NULL);
> 
> Given that read_key_bytes does not need to return ssize_t, you can
> switch ret to 0 here, so the function return type actually matches what
> you return.

I apologize, I don't think I understand this one. Do you mean to change
ret (and read_key_bytes) from ssize_t to int? Or is there something else
I should do here as well?

> 
> > +	if (ret < 0)
> > +		return ret;
> 
> eg. here
> 
> > +
> > +	if (item.reserved[0] != 0 || item.reserved[1] != 0)
> > +		return -EUCLEAN;
> > +
> > +	true_size = btrfs_stack_verity_descriptor_size(&item);
> > +	if (true_size > INT_MAX)
> > +		return -EUCLEAN;
> > +
> > +	if (!buf_size)
> > +		return true_size;
> > +	if (buf_size < true_size)
> > +		return -ERANGE;
> > +
> > +	ret = read_key_bytes(BTRFS_I(inode),
> > +			     BTRFS_VERITY_DESC_ITEM_KEY, 1,
> > +			     buf, buf_size, NULL);
> > +	if (ret < 0)
> > +		return ret;
> > +	if (ret != true_size)
> > +		return -EIO;
> > +
> > +	return true_size;
> > +}
> > +
> > +/*
> > + * fsverity op that reads and caches a merkle tree page.  These are stored
> > + * in the btree, but we cache them in the inode's address space after EOF.
> > + */
> > +static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
> > +					       pgoff_t index,
> > +					       unsigned long num_ra_pages)
> > +{
> > +	struct page *p;
> 
> Please don't use single letter variables
> 
> > +	u64 off = index << PAGE_SHIFT;
> 
> pgoff_t is unsigned long, the shift will trim high bytes, you may want
> to use the page_offset helper instead.

Ah, my intent was that it should all fit in off, but yes this does seem
like it could lose bytes (I thiiiink we might be safe because a write
would fail first, but I would like this code to be correct). I'll look
into the helper.

> 
> > +	loff_t merkle_pos = merkle_file_pos(inode);
> 
> u64, that should work with comparison to loff_t
> 
> > +	ssize_t ret;
> > +	int err;
> > +
> > +	if (merkle_pos > inode->i_sb->s_maxbytes - off - PAGE_SIZE)
> > +		return ERR_PTR(-EFBIG);
> > +	index += merkle_pos >> PAGE_SHIFT;
> > +again:
> > +	p = find_get_page_flags(inode->i_mapping, index, FGP_ACCESSED);
> > +	if (p) {
> > +		if (PageUptodate(p))
> > +			return p;
> > +
> > +		lock_page(p);
> > +		/*
> > +		 * we only insert uptodate pages, so !Uptodate has to be
> > +		 * an error
> > +		 */
> > +		if (!PageUptodate(p)) {
> > +			unlock_page(p);
> > +			put_page(p);
> > +			return ERR_PTR(-EIO);
> > +		}
> > +		unlock_page(p);
> > +		return p;
> > +	}
> > +
> > +	p = page_cache_alloc(inode->i_mapping);
> 
> So this performs an allocation with GFP flags from the inode mapping.
> I'm not sure if this is safe, eg. in add_ra_bio_pages we do 
> 
> 548     page = __page_cache_alloc(mapping_gfp_constraint(mapping,                                                                                                
> 549                                                      ~__GFP_FS));
> 
> to emulate GFP_NOFS. Either that or do the scoped nofs with
> memalloc_nofs_save/_restore.
> 
> > +	if (!p)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	/*
> > +	 * merkle item keys are indexed from byte 0 in the merkle tree.
> > +	 * they have the form:
> > +	 *
> > +	 * [ inode objectid, BTRFS_MERKLE_ITEM_KEY, offset in bytes ]
> > +	 */
> > +	ret = read_key_bytes(BTRFS_I(inode),
> > +			     BTRFS_VERITY_MERKLE_ITEM_KEY, off,
> > +			     page_address(p), PAGE_SIZE, p);
> > +	if (ret < 0) {
> > +		put_page(p);
> > +		return ERR_PTR(ret);
> > +	}
> > +
> > +	/* zero fill any bytes we didn't write into the page */
> > +	if (ret < PAGE_SIZE) {
> > +		char *kaddr = kmap_atomic(p);
> > +
> > +		memset(kaddr + ret, 0, PAGE_SIZE - ret);
> > +		kunmap_atomic(kaddr);
> 
> There's helper memzero_page wrapping the kmap
> 
> > +	}
> > +	SetPageUptodate(p);
> > +	err = add_to_page_cache_lru(p, inode->i_mapping, index,
> 
> Please drop err and use ret
> 
> > +				    mapping_gfp_mask(inode->i_mapping));
> > +
> > +	if (!err) {
> > +		/* inserted and ready for fsverity */
> > +		unlock_page(p);
> > +	} else {
> > +		put_page(p);
> > +		/* did someone race us into inserting this page? */
> > +		if (err == -EEXIST)
> > +			goto again;
> > +		p = ERR_PTR(err);
> > +	}
> > +	return p;
> > +}
> > +
> > +/*
> > + * fsverity op that writes a merkle tree block into the btree in 1k chunks.
> 
> Should it say "in 2^log_blocksize chunks" instead?

I was trying to highlight that though we are writing a 4K merkle block,
we will write it in 1k pieces (per write_key_bytes). Happy to change
this comment to be more useful, though.

> 
> > + */
> > +static int btrfs_write_merkle_tree_block(struct inode *inode, const void *buf,
> > +					u64 index, int log_blocksize)
> > +{
> > +	u64 off = index << log_blocksize;
> > +	u64 len = 1 << log_blocksize;
> > +
> > +	if (merkle_file_pos(inode) > inode->i_sb->s_maxbytes - off - len)
> > +		return -EFBIG;
> > +
> > +	return write_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY,
> > +			       off, buf, len);
> > +}
> > +
> > +const struct fsverity_operations btrfs_verityops = {
> > +	.begin_enable_verity	= btrfs_begin_enable_verity,
> > +	.end_enable_verity	= btrfs_end_enable_verity,
> > +	.get_verity_descriptor	= btrfs_get_verity_descriptor,
> > +	.read_merkle_tree_page	= btrfs_read_merkle_tree_page,
> > +	.write_merkle_tree_block = btrfs_write_merkle_tree_block,
> > +};
> > diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> > index 5df73001aad4..fa21c8aac78d 100644
> > --- a/include/uapi/linux/btrfs.h
> > +++ b/include/uapi/linux/btrfs.h
> > @@ -288,6 +288,7 @@ struct btrfs_ioctl_fs_info_args {
> >   * first mount when booting older kernel versions.
> >   */
> >  #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID	(1ULL << 1)
> > +#define BTRFS_FEATURE_COMPAT_RO_VERITY		(1ULL << 2)
> >  
> >  #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
> >  #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
> > @@ -308,7 +309,6 @@ struct btrfs_ioctl_fs_info_args {
> >  #define BTRFS_FEATURE_INCOMPAT_METADATA_UUID	(1ULL << 10)
> >  #define BTRFS_FEATURE_INCOMPAT_RAID1C34		(1ULL << 11)
> >  #define BTRFS_FEATURE_INCOMPAT_ZONED		(1ULL << 12)
> > -
> 
> Keep the newline please
> 
> >  struct btrfs_ioctl_feature_flags {
> >  	__u64 compat_flags;
> >  	__u64 compat_ro_flags;
> > diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> > index ae25280316bd..2be57416f886 100644
> > --- a/include/uapi/linux/btrfs_tree.h
> > +++ b/include/uapi/linux/btrfs_tree.h
> > @@ -118,6 +118,14 @@
> >  #define BTRFS_INODE_REF_KEY		12
> >  #define BTRFS_INODE_EXTREF_KEY		13
> >  #define BTRFS_XATTR_ITEM_KEY		24
> > +
> > +/*
> > + * fsverity has a descriptor per file, and then
> > + * a number of sha or csum items indexed by offset in to the file.
> > + */
> > +#define BTRFS_VERITY_DESC_ITEM_KEY	36
> > +#define BTRFS_VERITY_MERKLE_ITEM_KEY	37
> > +
> >  #define BTRFS_ORPHAN_ITEM_KEY		48
> >  /* reserve 2-15 close to the inode for later flexibility */
> >  
> > @@ -996,4 +1004,11 @@ struct btrfs_qgroup_limit_item {
> >  	__le64 rsv_excl;
> >  } __attribute__ ((__packed__));
> >  
> > +struct btrfs_verity_descriptor_item {
> > +	/* size of the verity descriptor in bytes */
> > +	__le64 size;
> > +	__le64 reserved[2];
> 
> Is the reserved space "just in case" or are there plans to use it? For
> items the extension and compatibility can be done by checking the item
> size, without further flags or bits set to distinguish that.
> 
> If the extension happens rarely it's manageable to do the size check
> instead of reserving the space.
> 
> The reserved space must be otherwise zero if not used, this serves as
> the way to check the compatibility. It still may need additional code to
> make sure old kernel does recognize unkown contents and eg. refuses to
> work. I can imagine in the context of verity it could be significant.
> 
> > +	__u8 encryption;
> > +} __attribute__ ((__packed__));
> > +
> >  #endif /* _BTRFS_CTREE_H_ */
> 
> 

Thank you for the in-depth review, and sorry for the sloppy newline
stuff. Everything I didn't explicitly respond to, I'll either fix or
study further.
