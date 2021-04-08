Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6EC359000
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Apr 2021 00:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbhDHWuW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 18:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232632AbhDHWuW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 18:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 471F161106;
        Thu,  8 Apr 2021 22:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617922210;
        bh=LtzCTx1RUdTu2D2LUpGfjHRssVKWpttdFiKctyfo6SM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K2hPJpSyXNk+uyXWsaUPh1CCAUQMSRUwkLpz350G3ZyaepC9moAeocIlHx4NHgk9N
         JlTWuCPt9FTm38+P/DtUzHLie2fWdSCgEAdvSkJG4mvAq7+6MBYsEjRGrYIKEo+6Q2
         2sIDtMRqztUjo3i84VDNc62VzRk4MdNJWw+G35nP3UV6aMPc/Dn4vmHM7IFTmjCV/m
         H6Eft9DIKVIZlwt58rEJ4U6mQcxvn+J9nfzqoQzJPLbTdTqj5x1q5Fz6Tl2mZ1ZlsD
         kB1TBwwJL5UP63Eu3oBEVTut9kAOehjuTmcm1kqunESTq0DtoYb72NeZzcK4jnrfRc
         haHmNpJuPZ9KA==
Date:   Thu, 8 Apr 2021 15:50:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 2/5] btrfs: initial fsverity support
Message-ID: <YG+IoOqvDNtkwWQf@sol.localdomain>
References: <cover.1617900170.git.boris@bur.io>
 <c9335d862ee4ddc1f7193bbb06ca7313d9ff1b30.1617900170.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9335d862ee4ddc1f7193bbb06ca7313d9ff1b30.1617900170.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Apr 08, 2021 at 11:33:53AM -0700, Boris Burkov wrote:
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index f7a4ad86adee..e5282a8f566a 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1339,6 +1339,7 @@ static int btrfs_fill_super(struct super_block *sb,
>  	sb->s_op = &btrfs_super_ops;
>  	sb->s_d_op = &btrfs_dentry_operations;
>  	sb->s_export_op = &btrfs_export_ops;
> +	sb->s_vop = &btrfs_verityops;
>  	sb->s_xattr = btrfs_xattr_handlers;
>  	sb->s_time_gran = 1;

As the kernel test robot has hinted at, this line needs to be conditional on
CONFIG_FS_VERITY.

> +/*
> + * Helper function for computing cache index for Merkle tree pages
> + * @inode: verity file whose Merkle items we want.
> + * @merkle_index: index of the page in the Merkle tree (as in
> + *                read_merkle_tree_page).
> + * @ret_index: returned index in the inode's mapping
> + *
> + * Returns: 0 on success, -EFBIG if the location in the file would be beyond
> + * sb->s_maxbytes.
> + */
> +static int get_verity_mapping_index(struct inode *inode,
> +				    pgoff_t merkle_index,
> +				    pgoff_t *ret_index)
> +{
> +	/*
> +	 * the file is readonly, so i_size can't change here.  We jump
> +	 * some pages past the last page to cache our merkles.  The goal
> +	 * is just to jump past any hugepages that might be mapped in.
> +	 */
> +	pgoff_t merkle_offset = 2048;
> +	u64 index = (i_size_read(inode) >> PAGE_SHIFT) + merkle_offset + merkle_index;

Would it make more sense to align the page index to 2048, rather than adding
2048?  Or are huge pages not necessarily aligned in the page cache?

> +
> +	if (index > inode->i_sb->s_maxbytes >> PAGE_SHIFT)
> +		return -EFBIG;

There's an off-by-one error here; it's considering the beginning of the page
rather than the end of the page.

> +/*
> + * Insert and write inode items with a given key type and offset.
> + * @inode: The inode to insert for.
> + * @key_type: The key type to insert.
> + * @offset: The item offset to insert at.
> + * @src: Source data to write.
> + * @len: Length of source data to write.
> + *
> + * Write len bytes from src into items of up to 1k length.
> + * The inserted items will have key <ino, key_type, offset + off> where
> + * off is consecutively increasing from 0 up to the last item ending at
> + * offset + len.
> + *
> + * Returns 0 on success and a negative error code on failure.
> + */
> +static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
> +			   const char *src, u64 len)
> +{
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_path *path;
> +	struct btrfs_root *root = inode->root;
> +	struct extent_buffer *leaf;
> +	struct btrfs_key key;
> +	u64 orig_len = len;
> +	u64 copied = 0;
> +	unsigned long copy_bytes;
> +	unsigned long src_offset = 0;
> +	void *data;
> +	int ret;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	while (len > 0) {
> +		trans = btrfs_start_transaction(root, 1);
> +		if (IS_ERR(trans)) {
> +			ret = PTR_ERR(trans);
> +			break;
> +		}
> +
> +		key.objectid = btrfs_ino(inode);
> +		key.offset = offset;
> +		key.type = key_type;
> +
> +		/*
> +		 * insert 1K at a time mostly to be friendly for smaller
> +		 * leaf size filesystems
> +		 */
> +		copy_bytes = min_t(u64, len, 1024);
> +
> +		ret = btrfs_insert_empty_item(trans, root, path, &key, copy_bytes);
> +		if (ret) {
> +			btrfs_end_transaction(trans);
> +			break;
> +		}
> +
> +		leaf = path->nodes[0];
> +
> +		data = btrfs_item_ptr(leaf, path->slots[0], void);
> +		write_extent_buffer(leaf, src + src_offset,
> +				    (unsigned long)data, copy_bytes);
> +		offset += copy_bytes;
> +		src_offset += copy_bytes;
> +		len -= copy_bytes;
> +		copied += copy_bytes;
> +
> +		btrfs_release_path(path);
> +		btrfs_end_transaction(trans);
> +	}
> +
> +	btrfs_free_path(path);
> +
> +	if (!ret && copied != orig_len)
> +		ret = -EIO;

The condition '!ret && copied != orig_len' at the end appears to be unnecessary,
since this function doesn't do short writes.

> +/*
> + * fsverity op that gets the struct fsverity_descriptor.
> + * fsverity does a two pass setup for reading the descriptor, in the first pass
> + * it calls with buf_size = 0 to query the size of the descriptor,
> + * and then in the second pass it actually reads the descriptor off
> + * disk.
> + */
> +static int btrfs_get_verity_descriptor(struct inode *inode, void *buf,
> +				       size_t buf_size)
> +{
> +	size_t true_size;
> +	ssize_t ret = 0;
> +	struct btrfs_verity_descriptor_item item;
> +
> +	memset(&item, 0, sizeof(item));
> +	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY,
> +			     0, (char *)&item, sizeof(item), NULL);
> +	if (ret < 0)
> +		return ret;
> +
> +	true_size = btrfs_stack_verity_descriptor_size(&item);
> +	if (true_size > INT_MAX)

true_size is a __le64 on-disk, so it technically should be __u64 here; otherwise
its high 32 bits might be ignored.

> +struct btrfs_verity_descriptor_item {
> +	/* size of the verity descriptor in bytes */
> +	__le64 size;
> +	__le64 reserved[2];
> +	__u8 encryption;
> +} __attribute__ ((__packed__));

The 'reserved' field still isn't validated to be 0 before going ahead and using
the descriptor.  Is that still intentional?  If so, it might be clearer to call
this field 'unused'.

- Eric
