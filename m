Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D24F3C3D75
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Jul 2021 16:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhGKOzq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Jul 2021 10:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233808AbhGKOzq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Jul 2021 10:55:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE97F611AF;
        Sun, 11 Jul 2021 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626015179;
        bh=en8NWBS7SQkMrCqsmNM4oGOlzvfsho8bNhtN/lwORWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MWeL/oZLN9zPaECz0poIzr3eyBT7BjOkEnZSGnBQv6JPOziR5NXbr0j9ugRVfG/ii
         zgcrh2d3zcpfy7h7YOh6A+Hteyd8EjtqD/k1Sorb5fjDByfMEygrq/air5gGN7Sdsn
         lA4ehwuL4wSOeJlC59gisI6AKBWz4zZGirlMMxPbMNROp0wQ6SH2ZqFrIZU/ZIIUna
         yBxlG6nVfXrGEcAdv6HUsOJFtNSxDVLuzn3cWn6d/VcdOrRg8z+xKwX5k/KQCKFRsV
         rrtEg94C6ISzvbnasiWy9CmhrHsviI0ApRnb1YoJZIEAVc9t3Nk7ZxD1qusksYx/2P
         XzHCMADzhpcLA==
Date:   Sun, 11 Jul 2021 09:52:56 -0500
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v6 2/3] btrfs: initial fsverity support
Message-ID: <YOsFyCA1QIKlgHFh@quark.localdomain>
References: <cover.1625083099.git.boris@bur.io>
 <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 30, 2021 at 01:01:49PM -0700, Boris Burkov wrote:
> Add support for fsverity in btrfs. To support the generic interface in
> fs/verity, we add two new item types in the fs tree for inodes with
> verity enabled. One stores the per-file verity descriptor and btrfs
> verity item and the other stores the Merkle tree data itself.
> 
> Verity checking is done in end_page_read just before a page is marked
> uptodate. This naturally handles a variety of edge cases like holes,
> preallocated extents, and inline extents. Some care needs to be taken to
> not try to verity pages past the end of the file, which are accessed by
> the generic buffered file reading code under some circumstances like
> reading to the end of the last page and trying to read again. Direct IO
> on a verity file falls back to buffered reads.
> 
> Verity relies on PageChecked for the Merkle tree data itself to avoid
> re-walking up shared paths in the tree. For this reason, we need to
> cache the Merkle tree data. Since the file is immutable after verity is
> turned on, we can cache it at an index past EOF.
> 
> Use the new inode ro_flags to store verity on the inode item, so that we
> can enable verity on a file, then rollback to an older kernel and still
> mount the file system and read the file. Since we can't safely write the
> file anymore without ruining the invariants of the Merkle tree, we mark
> a ro_compat flag on the file system when a file has verity enabled.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Co-developed-by: Chris Mason <clm@fb.com>
> Signed-off-by: Chris Mason <clm@fb.com>
> Signed-off-by: Boris Burkov <boris@bur.io>

Generally looks good, feel free to add:

Acked-by: Eric Biggers <ebiggers@google.com>

A few minor comments below:

> @@ -2688,7 +2677,14 @@ static void end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
>  	       start + len <= page_offset(page) + PAGE_SIZE);
>  
>  	if (uptodate) {
> -		btrfs_page_set_uptodate(fs_info, page, start, len);
> +		if (!PageError(page) && !PageUptodate(page) &&
> +		    start < i_size_read(page->mapping->host) &&
> +		    fsverity_active(page->mapping->host) &&
> +		    !fsverity_verify_page(page)) {
> +			btrfs_page_set_error(fs_info, page, start, len);
> +		} else {
> +			btrfs_page_set_uptodate(fs_info, page, start, len);
> +		}

When is it ever the case that PageError(page) or PageUptodate(page) here?

Also: in general, fsverity_active() should be checked first, in order to avoid
any overhead when !CONFIG_FS_VERITY.

> @@ -5014,6 +5020,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_get_subvol_rootref(file, argp);
>  	case BTRFS_IOC_INO_LOOKUP_USER:
>  		return btrfs_ioctl_ino_lookup_user(file, argp);
> +	case FS_IOC_ENABLE_VERITY:
> +		return fsverity_ioctl_enable(file, (const void __user *)argp);
> +	case FS_IOC_MEASURE_VERITY:
> +		return fsverity_ioctl_measure(file, argp);

You could wire up FS_IOC_READ_VERITY_METADATA as well.  It should just work
without having to do anything else.

> + * The merkle tree items:
> + * [ inode objectid, BTRFS_VERITY_MERKLE_ITEM_KEY, offset ]
> + *
> + * These also start at offset 0, and correspond to the merkle tree bytes.
> + * So when fsverity asks for page 0 of the merkle tree, we pull up one page
> + * starting at offset 0 for this key type.  These are also opaque to btrfs,
> + * we're blindly storing whatever fsverity sends down.
> + */

Is it defined which offsets, specifically, the Merkle tree items start at?  Or
is any arrangement valid -- say, one filesystem might use one item per Merkle
tree block, while another might have multiple blocks per item, while another
might have multiple items per block?  What about the degenerate case where there
is a separate btrfs item for each individual Merkle tree byte, and maybe even
some empty items -- is that being considered a valid/supported on-disk format,
or is there a limit?

> +static loff_t merkle_file_pos(const struct inode *inode)
> +{
> +	loff_t ret;
> +	u64 sz = inode->i_size;
> +	u64 rounded = round_up(sz, MERKLE_START_ALIGN);
> +
> +	if (rounded > inode->i_sb->s_maxbytes)
> +		return -EFBIG;
> +	ret = rounded;
> +	return ret;
> +}

The 'ret' variable is unnecessary; this can just 'return rounded'.

> +/*
> + * Drop all the items for this inode with this key_type.
> + *
> + * @inode: The inode to drop items for
> + * @key_type: The type of items to drop (VERITY_DESC_ITEM or
> + *            VERITY_MERKLE_ITEM)

BTRFS_VERITY_DESC_ITEM_KEY or BTRFS_VERITY_MERKLE_ITEM_KEY

> + *
> + * Before doing a verity enable we cleanup any existing verity items.
> + * This is also used to clean up if a verity enable failed half way
> + * through.
> + *
> + * Returns number of dropped items on success, negative error code on failure.
> + */
> +static int drop_verity_items(struct btrfs_inode *inode, u8 key_type)

The caller doesn't actually care about the number of dropped items, so this
could just return 0 on success or a negative error code on failure.

> +	while (1) {
> +		/*
> +		 * 1 for the item being dropped
> +		 */
> +		trans = btrfs_start_transaction(root, 1);
> +		if (IS_ERR(trans)) {
> +			ret = PTR_ERR(trans);
> +			goto out;
> +		}
> +
> +		/*
> +		 * Walk backwards through all the items until we find one
> +		 * that isn't from our key type or objectid
> +		 */
> +		key.objectid = btrfs_ino(inode);
> +		key.type = key_type;
> +		key.offset = (u64)-1;
> +
> +		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
> +		if (ret > 0) {
> +			ret = 0;
> +			/* No more keys of this type, we're done */
> +			if (path->slots[0] == 0)
> +				break;
> +			path->slots[0]--;
> +		} else if (ret < 0) {
> +			btrfs_end_transaction(trans);
> +			goto out;
> +		}

Pardon my unfamiliarity with btrfs, but it looks like if the key isn't present,
then btrfs_search_slot() returns the position where the key would be inserted.
What if the previous leaf is completely full -- does btrfs_search_slot() return
a new leaf, or does it return a pointer past the end of the previous one?  (It
looks like the latter is assumed here.)  The comment for btrfs_search_slot()
doesn't make this clear.

> +int btrfs_drop_verity_items(struct btrfs_inode *inode)
> +{
> +	int ret;
> +
> +	ret = drop_verity_items(inode, BTRFS_VERITY_DESC_ITEM_KEY);
> +	if (ret < 0)
> +		goto out;
> +	ret = drop_verity_items(inode, BTRFS_VERITY_MERKLE_ITEM_KEY);
> +	if (ret < 0)
> +		goto out;
> +	ret = 0;
> +out:
> +	return ret;
> +}

This could be simplified a bit if drop_verity_items() returned 0 on success.

> +/*
> + * Insert and write inode items with a given key type and offset.
> + *
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

The comment says items of up to 1k length, but the code uses 2K.

> +/*
> + * Read inode items of the given key type and offset from the btree.
> + *
> + * @inode: The inode to read items of.
> + * @key_type: The key type to read.
> + * @offset: The item offset to read from.
> + * @dest: The buffer to read into. This parameter has slightly tricky
> + *        semantics.  If it is NULL, the function will not do any copying
> + *        and will just return the size of all the items up to len bytes.
> + *        If dest_page is passed, then the function will kmap_local the
> + *        page and ignore dest, but it must still be non-NULL to avoid the
> + *        counting-only behavior.
> + * @len: Length in bytes to read.
> + * @dest_page: Copy into this page instead of the dest buffer.
> + *
> + * Helper function to read items from the btree.  This returns the number
> + * of bytes read or < 0 for errors.  We can return short reads if the
> + * items don't exist on disk or aren't big enough to fill the desired length.
> + * Supports reading into a provided buffer (dest) or into the page cache
> + *
> + * Returns number of bytes read or a negative error code on failure.
> + */
> +static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
> +			  char *dest, u64 len, struct page *dest_page)
> +{
> +	struct btrfs_path *path;
> +	struct btrfs_root *root = inode->root;
> +	struct extent_buffer *leaf;
> +	struct btrfs_key key;
> +	u64 item_end;
> +	u64 copy_end;
> +	int copied = 0;
> +	u32 copy_offset;
> +	unsigned long copy_bytes;
> +	unsigned long dest_offset = 0;
> +	void *data;
> +	char *kaddr = dest;
> +	int ret;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	if (dest_page)
> +		path->reada = READA_FORWARD;
> +
> +	key.objectid = btrfs_ino(inode);
> +	key.type = key_type;
> +	key.offset = offset;
> +
> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret < 0) {
> +		goto out;
> +	} else if (ret > 0) {
> +		ret = 0;
> +		if (path->slots[0] == 0)
> +			goto out;
> +		path->slots[0]--;
> +	}

Same question about btrfs_search_slot() here.  If the key isn't found and the
previous leaf is completely full, will it return a pointer past the end of it?

> +/*
> + * fsverity op that begins enabling verity.
> + *
> + * @filp: the file to enable verity on
> + *
> + * Begin enabling fsverity for the file. We drop any existing verity items
> + * and set the in progress bit.
> + *
> + * Returns 0 on success, negative error code on failure.
> + */
> +static int btrfs_begin_enable_verity(struct file *filp)
> +{
> +	struct btrfs_inode *inode = BTRFS_I(file_inode(filp));
> +	int ret;
> +
> +	ASSERT(inode_is_locked(file_inode(filp)));
> +
> +	if (test_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	ret = btrfs_drop_verity_items(inode);
> +	if (ret)
> +		goto out;
> +
> +	set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
> +out:
> +	return ret;
> +}

There's no need for 'goto out' if no cleanup is being done.  Just return
directly instead.

> +static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
> +					       pgoff_t index,
> +					       unsigned long num_ra_pages)
> +{
> +	struct page *page;
> +	u64 off = (u64)index << PAGE_SHIFT;
> +	loff_t merkle_pos = merkle_file_pos(inode);
> +	int ret;
> +
> +	if (merkle_pos < 0)
> +		return ERR_PTR(merkle_pos);
> +	if (merkle_pos > inode->i_sb->s_maxbytes - off - PAGE_SIZE)
> +		return ERR_PTR(-EFBIG);
> +	index += merkle_pos >> PAGE_SHIFT;
> +again:
> +	page = find_get_page_flags(inode->i_mapping, index, FGP_ACCESSED);
> +	if (page) {
> +		if (PageUptodate(page))
> +			return page;
> +
> +		lock_page(page);
> +		/*
> +		 * We only insert uptodate pages, so !Uptodate has to be
> +		 * an error
> +		 */
> +		if (!PageUptodate(page)) {
> +			unlock_page(page);
> +			put_page(page);
> +			return ERR_PTR(-EIO);
> +		}
> +		unlock_page(page);
> +		return page;

As per the comment above, aren't the Merkle tree pages marked Uptodate before
being inserted into the page cache?  If so, isn't it unnecessary to re-check
Uptodate under the page lock?

> +struct btrfs_verity_descriptor_item {
> +	/* size of the verity descriptor in bytes */
> +	__le64 size;
> +	/*
> +	 * When we implement support for fscrypt, we will need to encrypt the
> +	 * Merkle tree for encrypted verity files. These 128 bits are for the
> +	 * eventual storage of an fscrypt initialization vector.
> +	 */
> +	__le64 reserved[2];
> +	__u8 encryption;
> +} __attribute__ ((__packed__));

Do you have something in mind for how an initialization vector stored here would
be used?  I'd have thought that if/when fscrypt support is added, you'd either
derive a new per-file key for encrypting the verity metadata specifically, or
you'd encrypt the verity metadata with the regular per-file key using IVs that
are chosen as if the verity metadata were appended to the file contents.
Neither case would require that any additional information be stored here.

- Eric
