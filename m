Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95BD33DCC0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Mar 2021 19:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240104AbhCPSpK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 16 Mar 2021 14:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhCPSoh (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 16 Mar 2021 14:44:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 868F565118;
        Tue, 16 Mar 2021 18:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615920276;
        bh=gqgWe/snPz3cPzLiE4nMX2O8k/NQVN+I3y8NE9h6q8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c5EwcF6aGyPf8SvXXDPparf+jfwY/El4DQi/oASmyHp6ME0BZSSLYEF8McP8eqnLv
         /tmOiUhfWkBMsL0pQCj9yBuVcx5nquC+BLXzeOZG5muVR/j/s1fZjeBpIpEnMUUgaz
         syH/njykCwSZ80f7OQNJr2cctG7xq2ODTY7xe7ch42HS9G5HI99+ehXNcLA4ruodv4
         EmsqDLfm6puVy4iij963VfMiDoPbV2GdvsAXKoCr6Revkz+bqoKFloGCB7WemX98aC
         Ye2fg1pmOgAGZf8IUbJX6/x/zSZjEwS1rLUjih2nDvW/6SklukBUBI57xI9mrhhDW9
         7GUll8apa/g4A==
Date:   Tue, 16 Mar 2021 11:44:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 2/5] btrfs: initial fsverity support
Message-ID: <YFD8kq1j5ZqN6Wgl@gmail.com>
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
> +/*
> + * fsverity op that ends enabling verity.
> + * fsverity calls this when it's done with all of the pages in the file
> + * and all of the merkle items have been inserted.  We write the
> + * descriptor and update the inode in the btree to reflect its new life
> + * as a verity file.
> + */
> +static int btrfs_end_enable_verity(struct file *filp, const void *desc,
> +				  size_t desc_size, u64 merkle_tree_size)
> +{
> +	struct btrfs_trans_handle *trans;
> +	struct inode *inode = file_inode(filp);
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_verity_descriptor_item item;
> +	int ret;
> +
> +	if (desc != NULL) {
> +		/* write out the descriptor item */
> +		memset(&item, 0, sizeof(item));
> +		btrfs_set_stack_verity_descriptor_size(&item, desc_size);
> +		ret = write_key_bytes(BTRFS_I(inode),
> +				      BTRFS_VERITY_DESC_ITEM_KEY, 0,
> +				      (const char *)&item, sizeof(item));
> +		if (ret)
> +			goto out;
> +		/* write out the descriptor itself */
> +		ret = write_key_bytes(BTRFS_I(inode),
> +				      BTRFS_VERITY_DESC_ITEM_KEY, 1,
> +				      desc, desc_size);
> +		if (ret)
> +			goto out;
> +
> +		/* update our inode flags to include fs verity */
> +		trans = btrfs_start_transaction(root, 1);
> +		if (IS_ERR(trans)) {
> +			ret = PTR_ERR(trans);
> +			goto out;
> +		}
> +		BTRFS_I(inode)->compat_flags |= BTRFS_INODE_VERITY;
> +		btrfs_sync_inode_flags_to_i_flags(inode);
> +		ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
> +		btrfs_end_transaction(trans);
> +	}
> +
> +out:
> +	if (desc == NULL || ret) {
> +		/* If we failed, drop all the verity items */
> +		drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY);
> +		drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY);
> +	} else
> +		btrfs_set_fs_compat_ro(root->fs_info, VERITY);
> +	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &BTRFS_I(inode)->runtime_flags);
> +	return ret;
> +}

If enabling verity failed, I think you also need to call
truncate_inode_pages(inode->i_mapping, inode->i_size)
to remove the cached Merkle tree pages from the page cache.  Otherwise they can
be exposed to userspace if the file is later extended.  I recently fixed this
same problem for ext4 and f2fs:
https://lkml.kernel.org/linux-f2fs-devel/20210302200420.137977-1-ebiggers@kernel.org/T/#u

- Eric
