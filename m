Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08EC33C9D3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Mar 2021 00:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhCOXRX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Mar 2021 19:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233641AbhCOXRT (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Mar 2021 19:17:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C74C164F5F;
        Mon, 15 Mar 2021 23:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615850239;
        bh=f8Uf43byQzR86G+j0jA7fHCtw123p6qP+oz+iW0WJsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eA15e+Mnt3AKVbN5aqj+XIwvquZGiyM6KdGAyqFAOPb9PWFXLOUzXZ5dehmJZrO9d
         I2gakELC6KchEaACyqLuJaEP06svAc5Es79V3KlbSHw2ItQH5nitcI25YnwucnLe0w
         eavt+vuWe5TDzmM3NwRVr2Ue1VrA2gM8lQA1YmP41m5BViaG13eigj940dh0ifDPyv
         ltluuWBj1xf76VQb5BzjcSTFPYIibcCAD/jp4raU5uGGrOZshL8KtCB4pQsePBlVZW
         PWKpx1JHIqlRYNhwVtzqkOyuBe5Es7yIP/knCNgXA46NwYRq7wuHYIpTqxYtcU5Ici
         MmFZEJweTDnlA==
Date:   Mon, 15 Mar 2021 16:17:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 2/5] btrfs: initial fsverity support
Message-ID: <YE/q/bYckkAewbbl@gmail.com>
References: <cover.1614971203.git.boris@bur.io>
 <71249018efc661fdd3c43bda5d7cea271904ae1a.1614971203.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71249018efc661fdd3c43bda5d7cea271904ae1a.1614971203.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Mar 05, 2021 at 11:26:30AM -0800, Boris Burkov wrote:
> +static int end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
>  {
> -	struct btrfs_fs_info *fs_info = btrfs_sb(page->mapping->host->i_sb);
> +	int ret = 0;
> +	struct inode *inode = page->mapping->host;
> +	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  
>  	ASSERT(page_offset(page) <= start &&
>  		start + len <= page_offset(page) + PAGE_SIZE);
>  
>  	if (uptodate) {
> -		btrfs_page_set_uptodate(fs_info, page, start, len);
> +		/*
> +		 * buffered reads of a file with page alignment will issue a
> +		 * 0 length read for one page past the end of file, so we must
> +		 * explicitly skip checking verity on that page of zeros.
> +		 */
> +		if (!PageError(page) && !PageUptodate(page) &&
> +		    start < i_size_read(inode) &&
> +		    fsverity_active(inode) &&
> +		    fsverity_verify_page(page) != true)
> +			ret = -EIO;
> +		else
> +			btrfs_page_set_uptodate(fs_info, page, start, len);
>  	} else {

'fsverity_verify_page(page) != true' is better written as
'!fsverity_verify_page(page)'.

> +/*
> + * Just like ext4, we cache the merkle tree in pages after EOF in the page
> + * cache.  Unlike ext4, we're storing these in dedicated btree items and
> + * not just shoving them after EOF in the file.  This means we'll need to
> + * do extra work to encrypt them once encryption is supported in btrfs,
> + * but btrfs has a lot of careful code around i_size and it seems better
> + * to make a new key type than try and adjust all of our expectations
> + * for i_size.
> + *
> + * fs verity items are stored under two different key types on disk.
> + *
> + * The descriptor items:
> + * [ inode objectid, BTRFS_VERITY_DESC_ITEM_KEY, offset ]
> + *
> + * At offset 0, we store a btrfs_verity_descriptor_item which tracks the
> + * size of the descriptor item and some extra data for encryption.

Is the separate size field really needed?  It seems like the type of thing that
would be redundant with information that btrfs already stores about the tree
items.  Having two sources of truth is error-prone.

> +/*
> + * Insert and write inode items with a given key type and offset.
> + * @inode: The inode to insert for.
> + * @key_type: The key type to insert.
> + * @offset: The item offset to insert at.
> + * @src: Source data to write.
> + * @len: Length of source data to write.
> + * @max_item_size: Break up the write into items of this size at most.
> + *                 Useful for small leaf size file systems.
> + *
> + * Write len bytes from src into items of up to max_item_size length.
> + * The inserted items will have key <ino, key_type, offset + off> where
> + * off is consecutively increasing from 0 up to the last item ending at
> + * offset + len.
> + *
> + * Returns 0 on success and a negative error code on failure.
> + */
> +static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
> +			   const char *src, u64 len)

The max_item_size parameter is documented but doesn't exist.

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
> +	if (!buf_size)
> +		return true_size;
> +	if (buf_size < true_size)
> +		return -ERANGE;


It would be good to validate that true_size <= INT_MAX, as it's returned it an
'int'.

> +
> +	ret = read_key_bytes(BTRFS_I(inode),
> +			     BTRFS_VERITY_DESC_ITEM_KEY, 1,
> +			     buf, buf_size, NULL);
> +	if (ret < 0)
> +		return ret;
> +	if (ret != buf_size)
> +		return -EIO;
> +
> +	return buf_size;

Shouldn't this part use true_size, not buf_size?

> +/*
> + * fsverity op that writes a merkle tree block into the btree in 1k chunks.
> + */
> +static int btrfs_write_merkle_tree_block(struct inode *inode, const void *buf,
> +					u64 index, int log_blocksize)
> +{
> +	u64 start = index << log_blocksize;
> +	u64 len = 1 << log_blocksize;
> +	unsigned long mapping_index = get_verity_mapping_index(inode, index);
> +
> +	if (mapping_index > inode->i_sb->s_maxbytes >> PAGE_SHIFT)
> +		return -EFBIG;

I don't think this overflow check will work correctly, as 'mapping_index' can
overflow a ULONG_MAX before the overflow check is done.

> +struct btrfs_verity_descriptor_item {
> +	/* size of the verity descriptor in bytes */
> +	__le64 size;
> +	__le64 reserved[2];
> +	__u8 encryption;
> +} __attribute__ ((__packed__));

Should these reserved fields be strictly validated?  Currently they appear to be
ignored.

- Eric
