Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CE735A937
	for <lists+linux-fscrypt@lfdr.de>; Sat, 10 Apr 2021 01:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbhDIXZg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 9 Apr 2021 19:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234880AbhDIXZg (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 9 Apr 2021 19:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52C8B610CB;
        Fri,  9 Apr 2021 23:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618010722;
        bh=m8Y8YkwWvLsH/zJ7/OiVgT6EC7WkYUaQ23XiBX7F56E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hQJu2/i77DdGKHcLZucX7bTAXMeHIThi0AIasd/mDeh8BNnhDUFahq69k4d6e3B6b
         k4rWjkP/gM8ypSDmnlw8A2ZJuDzAC6fp9MEZMsGjhcCBoGGpTVZj2xqbHEawqFqneN
         KpkJTwSbaN5eB0kuYuhlQzdPKAkDCt2NQsSCb0T7YWRLWRvjzhZuSpiBP2HhEJk82P
         WpRMo2Se+avGExU/9fViThC/44o5vH0zBqqjpVu6GnBmnWsQyhV0gbQ8kVJmB5ODnt
         nAe/5ajelvaOXdCGlIVeLWX6FqL73VOFYbD95JKSwRLzpHLOY+9uxGiD0m4bgYF+lU
         SLUVbN0+1XPqg==
Date:   Fri, 9 Apr 2021 16:25:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 2/5] btrfs: initial fsverity support
Message-ID: <YHDiYIu6pz0nLveM@sol.localdomain>
References: <cover.1617900170.git.boris@bur.io>
 <c9335d862ee4ddc1f7193bbb06ca7313d9ff1b30.1617900170.git.boris@bur.io>
 <YG+IoOqvDNtkwWQf@sol.localdomain>
 <YHCXQ7dM9sRPGHzR@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHCXQ7dM9sRPGHzR@zen>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 09, 2021 at 11:05:05AM -0700, Boris Burkov wrote:
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
> > > +
> > > +	if (index > inode->i_sb->s_maxbytes >> PAGE_SHIFT)
> > > +		return -EFBIG;
> > 
> > There's an off-by-one error here; it's considering the beginning of the page
> > rather than the end of the page.
> > 
> > > +/*
> > > + * Insert and write inode items with a given key type and offset.
> > > + * @inode: The inode to insert for.
> > > + * @key_type: The key type to insert.
> > > + * @offset: The item offset to insert at.
> > > + * @src: Source data to write.
> > > + * @len: Length of source data to write.
> > > + *
> > > + * Write len bytes from src into items of up to 1k length.
> > > + * The inserted items will have key <ino, key_type, offset + off> where
> > > + * off is consecutively increasing from 0 up to the last item ending at
> > > + * offset + len.
> > > + *
> > > + * Returns 0 on success and a negative error code on failure.
> > > + */
> > > +static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
> > > +			   const char *src, u64 len)
> > > +{
> > > +	struct btrfs_trans_handle *trans;
> > > +	struct btrfs_path *path;
> > > +	struct btrfs_root *root = inode->root;
> > > +	struct extent_buffer *leaf;
> > > +	struct btrfs_key key;
> > > +	u64 orig_len = len;
> > > +	u64 copied = 0;
> > > +	unsigned long copy_bytes;
> > > +	unsigned long src_offset = 0;
> > > +	void *data;
> > > +	int ret;
> > > +
> > > +	path = btrfs_alloc_path();
> > > +	if (!path)
> > > +		return -ENOMEM;
> > > +
> > > +	while (len > 0) {
> > > +		trans = btrfs_start_transaction(root, 1);
> > > +		if (IS_ERR(trans)) {
> > > +			ret = PTR_ERR(trans);
> > > +			break;
> > > +		}
> > > +
> > > +		key.objectid = btrfs_ino(inode);
> > > +		key.offset = offset;
> > > +		key.type = key_type;
> > > +
> > > +		/*
> > > +		 * insert 1K at a time mostly to be friendly for smaller
> > > +		 * leaf size filesystems
> > > +		 */
> > > +		copy_bytes = min_t(u64, len, 1024);
> > > +
> > > +		ret = btrfs_insert_empty_item(trans, root, path, &key, copy_bytes);
> > > +		if (ret) {
> > > +			btrfs_end_transaction(trans);
> > > +			break;
> > > +		}
> > > +
> > > +		leaf = path->nodes[0];
> > > +
> > > +		data = btrfs_item_ptr(leaf, path->slots[0], void);
> > > +		write_extent_buffer(leaf, src + src_offset,
> > > +				    (unsigned long)data, copy_bytes);
> > > +		offset += copy_bytes;
> > > +		src_offset += copy_bytes;
> > > +		len -= copy_bytes;
> > > +		copied += copy_bytes;
> > > +
> > > +		btrfs_release_path(path);
> > > +		btrfs_end_transaction(trans);
> > > +	}
> > > +
> > > +	btrfs_free_path(path);
> > > +
> > > +	if (!ret && copied != orig_len)
> > > +		ret = -EIO;
> > 
> > The condition '!ret && copied != orig_len' at the end appears to be unnecessary,
> > since this function doesn't do short writes.
> > 
> > > +/*
> > > + * fsverity op that gets the struct fsverity_descriptor.
> > > + * fsverity does a two pass setup for reading the descriptor, in the first pass
> > > + * it calls with buf_size = 0 to query the size of the descriptor,
> > > + * and then in the second pass it actually reads the descriptor off
> > > + * disk.
> > > + */
> > > +static int btrfs_get_verity_descriptor(struct inode *inode, void *buf,
> > > +				       size_t buf_size)
> > > +{
> > > +	size_t true_size;
> > > +	ssize_t ret = 0;
> > > +	struct btrfs_verity_descriptor_item item;
> > > +
> > > +	memset(&item, 0, sizeof(item));
> > > +	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY,
> > > +			     0, (char *)&item, sizeof(item), NULL);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	true_size = btrfs_stack_verity_descriptor_size(&item);
> > > +	if (true_size > INT_MAX)
> > 
> > true_size is a __le64 on-disk, so it technically should be __u64 here; otherwise
> > its high 32 bits might be ignored.
> > 
> > > +struct btrfs_verity_descriptor_item {
> > > +	/* size of the verity descriptor in bytes */
> > > +	__le64 size;
> > > +	__le64 reserved[2];
> > > +	__u8 encryption;
> > > +} __attribute__ ((__packed__));
> > 
> > The 'reserved' field still isn't validated to be 0 before going ahead and using
> > the descriptor.  Is that still intentional?  If so, it might be clearer to call
> > this field 'unused'.
> > 
> 
> I should have asked about this last time, sorry I didn't get around to
> it. I'm not familiar with the implied semantics of something called
> reserved vs unused, so if you wouldn't mind explaining that a bit more,
> I would appreciate it.

"reserved" normally means a field is reserved for future use, so unrecognized
values result in an error (like an "incompat" flag).  "unused" usually means the
field is simply not used (like a "compat" flag).

> 
> Thinking out loud, and apologies in advance that this is a bit naive:
> Whether or not I validate it in kernel K1 will affect two things: not
> accidentally putting junk in s.t. it is hard for K2 to properly use the
> field, and it ensures that K1 can never understand the file if K2 uses
> the field and we roll back to K1. Is that correct? 100% committing to
> the latter seems like a negative, since I'm not sure the future use
> can't be compatible. The validation against junk is nice, but I
> personally don't know how critical it is. Currently, it feels sufficient
> to always zero the item before filling it out and writing it to disk.

Which you want depends on what sort of thing you are hoping to use this field
for in the future.

Usually failing to validate flags/fields causes more problems than not
validating them, though.

- Eric
