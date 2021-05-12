Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBD037D4E3
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 May 2021 23:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbhELSeI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 12 May 2021 14:34:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:41644 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350736AbhELRwG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 12 May 2021 13:52:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 63FE5B201;
        Wed, 12 May 2021 17:50:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 81CF2DA89C; Wed, 12 May 2021 19:48:27 +0200 (CEST)
Date:   Wed, 12 May 2021 19:48:27 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v4 5/5] btrfs: verity metadata orphan items
Message-ID: <20210512174827.GV7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1620240133.git.boris@bur.io>
 <8e7e0d3dd84f729d86e7f1a466fe8828f0e7ba58.1620241221.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e7e0d3dd84f729d86e7f1a466fe8828f0e7ba58.1620241221.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 05, 2021 at 12:20:43PM -0700, Boris Burkov wrote:
> +/*
> + * Helper to manage the transaction for adding an orphan item.
> + */
> +static int add_orphan(struct btrfs_inode *inode)

I wonder if this helper is useful, it's used only once and the code is
not long. Simply wrapping btrfs_orphan_add into a transaction is short
enough to be in btrfs_begin_enable_verity.

> +{
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_root *root = inode->root;
> +	int ret = 0;
> +
> +	trans = btrfs_start_transaction(root, 1);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto out;
> +	}
> +	ret = btrfs_orphan_add(trans, inode);
> +	if (ret) {
> +		btrfs_abort_transaction(trans, ret);
> +		goto out;
> +	}
> +	btrfs_end_transaction(trans);
> +
> +out:
> +	return ret;
> +}
> +
> +/*
> + * Helper to manage the transaction for deleting an orphan item.
> + */
> +static int del_orphan(struct btrfs_inode *inode)

Same here.

> +{
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_root *root = inode->root;
> +	int ret;
> +
> +	/*
> +	 * If the inode has no links, it is either already unlinked, or was
> +	 * created with O_TMPFILE. In either case, it should have an orphan from
> +	 * that other operation. Rather than reference count the orphans, we
> +	 * simply ignore them here, because we only invoke the verity path in
> +	 * the orphan logic when i_nlink is 0.
> +	 */
> +	if (!inode->vfs_inode.i_nlink)
> +		return 0;
> +
> +	trans = btrfs_start_transaction(root, 1);
> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
> +
> +	ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
> +	if (ret) {
> +		btrfs_abort_transaction(trans, ret);
> +		return ret;
> +	}
> +
> +	btrfs_end_transaction(trans);
> +	return ret;
> +}
