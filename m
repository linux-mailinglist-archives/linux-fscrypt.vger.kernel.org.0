Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17F537D4E2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 May 2021 23:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbhELSeF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 12 May 2021 14:34:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:55654 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348593AbhELRiC (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 12 May 2021 13:38:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 67F98B1DA;
        Wed, 12 May 2021 17:36:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8642FDA89C; Wed, 12 May 2021 19:34:23 +0200 (CEST)
Date:   Wed, 12 May 2021 19:34:23 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v4 2/5] btrfs: initial fsverity support
Message-ID: <20210512173423.GU7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1620240133.git.boris@bur.io>
 <dd0cfc38c6de927de63f34f96499dc8f80398754.1620241221.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd0cfc38c6de927de63f34f96499dc8f80398754.1620241221.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 05, 2021 at 12:20:40PM -0700, Boris Burkov wrote:
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

This starts transaction for each 1K of written data, this can become
potentially slow. In btrfs_end_enable_verity it's called 3 times and
then there's another transaction started to set the VERITY bit on the
inode. There's no commit called so it's not forced but it could happen
at any time independently. So this could result in partial verity data
stored.

We can't use join_transaction, or not without some block reserve magic.

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

The smallest we consider is 4K, I'm not sure if we would do eg. 2K to
allow testing the subpage blocksize even on x86_64. Otherwise I'd target
4K and adjust the limits accordingly. To reduce the transaction start
count, eg. 2K per round could half the number.

> +
> +		ret = btrfs_insert_empty_item(trans, root, path, &key, copy_bytes);
> +		if (ret) {

Does this also need to abort the transaction? This could lead to
filesystem in some incomplete state. If the whole operation is
restartable then it could avoid the abort and just return error, but
also must undo all changes. This is not always possible so aborting is
the only option left.

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
> +	return ret;
> +}
