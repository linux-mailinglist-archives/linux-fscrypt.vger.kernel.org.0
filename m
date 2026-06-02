Return-Path: <linux-fscrypt+bounces-1629-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oG8dN3xOHmrmiQkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1629-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 05:31:08 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4946F627C98
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 05:31:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D841C3025731
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jun 2026 03:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD905366DB9;
	Tue,  2 Jun 2026 03:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SA2RrcxG"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C5B2E06E4;
	Tue,  2 Jun 2026 03:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780370820; cv=none; b=XUAipFpyHpR2Jbyza11KQv93zn5EbwDIW1CTLBX8TItitHf2XYz8QhLjbCoadhvJpqFs/cUWKJ9SOVBxJbBpuURz1Bu6nn3E6podcS0fgQgOTfNaQpLGRMw8XtD1NGGMByGcVKmNTdPVY7qHLa4yOAx2Vk3m4Jnii1juJZP+oDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780370820; c=relaxed/simple;
	bh=sOiCbqd6sd7M6p22oDKsCvbwQDHi7E3cb9YQYxPSRVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dM2zHQ9CGERX30SgbfQhsS2FBSJcdtPxdtTkIrwz1LfTpxRpblZ2bzV1fqk770R80ZIYU3OEc4xi8644zxdYmhBKwU5hAeRzdnYjd9lLU6sBLHdphswhiLsnl81L7ikJrcv3Qq9i9qzjlYnEPo5nvX7qG8ZyyrqQNz8hizha1dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SA2RrcxG; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD10D1F00893;
	Tue,  2 Jun 2026 03:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780370819;
	bh=3+ETgr+OhMXlGmjB6rEaEkx+mf2NSa5ihBAMGaz8UPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SA2RrcxGxcRUINTVwqUpk1w6s9S4bosswnqURsTQKWY/mw3dwfxF00kA2F8fUHQ9q
	 FJk7VS1FJXejBsmKPq70+VZeCZhWCaG1Mx/lKaGfIywZq4hW6Zgp4eML7E00ab5seN
	 X8arQnsgvOA8sNxw2ASjaubrsG8wf63tndQhi2m8GjycSwBwNzz7rBeIx000UVHeWG
	 14dzoZnzGrdQx9hvuMrdUSKOjxoK9xmnSz4W+uNwlq1HVRrtWvvQVtaixQ+J2clmui
	 C5nCjB3gjpsnM0+mpQkeVHzi/aNN8Bh80R6mAi/CmkpdUkspbo6fxqVzl+522LR4OS
	 iSGwsMnab97sQ==
Date: Mon, 1 Jun 2026 20:25:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH v7 11/43] btrfs: add inode encryption contexts
Message-ID: <20260602032534.GH2295@sol>
References: <20260513085340.3673127-1-neelx@suse.com>
 <20260513085340.3673127-12-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085340.3673127-12-neelx@suse.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1629-lists,linux-fscrypt=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,dorminy.me:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,suse.com:email]
X-Rspamd-Queue-Id: 4946F627C98
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 13, 2026 at 10:52:45AM +0200, Daniel Vacek wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> fscrypt stores a context item with encrypted inodes that contains the
> related encryption information.  fscrypt provides an arbitrary blob for
> the filesystem to store, and it does not clearly fit into an existing
> structure, so this goes in a new item type.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
> 
> v7 changes:
>  * Fix a path leak as found by Chri's AI review.
> v6 changes:
>  * Shorten the inode context key macro name to BTRFS_FSCRYPT_INODE_CTX_KEY.
> v5: https://lore.kernel.org/linux-btrfs/5a88efb484b0874a7430b83bc6e5f6b9aa5858d5.1706116485.git.josef@toxicpanda.com/
> ---
>  fs/btrfs/fscrypt.c              | 116 ++++++++++++++++++++++++++++++++
>  fs/btrfs/fscrypt.h              |   2 +
>  fs/btrfs/inode.c                |  19 ++++++
>  fs/btrfs/ioctl.c                |   8 ++-
>  include/uapi/linux/btrfs_tree.h |  10 +++
>  5 files changed, 153 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> index 6cfba7d94e72..c503f817cbe7 100644
> --- a/fs/btrfs/fscrypt.c
> +++ b/fs/btrfs/fscrypt.c
> @@ -1,10 +1,126 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
> +#include <linux/iversion.h>
>  #include "ctree.h"
> +#include "accessors.h"
>  #include "btrfs_inode.h"
> +#include "disk-io.h"
> +#include "fs.h"
>  #include "fscrypt.h"
> +#include "ioctl.h"
> +#include "messages.h"
> +#include "transaction.h"
> +#include "xattr.h"
> +
> +static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
> +{
> +	struct btrfs_key key = {
> +		.objectid = btrfs_ino(BTRFS_I(inode)),
> +		.type = BTRFS_FSCRYPT_INODE_CTX_KEY,
> +		.offset = 0,
> +	};
> +	struct btrfs_path *path;
> +	struct extent_buffer *leaf;
> +	unsigned long ptr;
> +	int ret;
> +
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	ret = btrfs_search_slot(NULL, BTRFS_I(inode)->root, &key, path, 0, 0);
> +	if (ret) {
> +		len = -ENOENT;
> +		goto out;
> +	}
> +
> +	leaf = path->nodes[0];
> +	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +	/* fscrypt provides max context length, but it could be less */
> +	len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
> +	read_extent_buffer(leaf, ctx, ptr, len);
> +
> +out:
> +	btrfs_free_path(path);
> +	return len;
> +}

This doesn't conform to the calling convention for
fscrypt_operations::get_context, specifically in the cases where
-ENODATA and -ERANGE are expected.

        /*
         * Get the fscrypt context of the given inode.
         *
         * @inode: the inode whose context to get
         * @ctx: the buffer into which to get the context
         * @len: length of the @ctx buffer in bytes
         *
         * Return: On success, returns the length of the context in bytes; this
         *         may be less than @len.  On failure, returns -ENODATA if the
         *         inode doesn't have a context, -ERANGE if the context is
         *         longer than @len, or another -errno code.
         */
        int (*get_context)(struct inode *inode, void *ctx, size_t len);

It also seems to be assuming that any error from btrfs_search_slot()
means "not found", which isn't correct.

The size_t variable called 'len' is also being used to store negative
errno values, which is weird.

> +static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
> +				     size_t len, void *fs_data)
> +{
> +	struct btrfs_trans_handle *trans = fs_data;
> +	struct btrfs_key key = {
> +		.objectid = btrfs_ino(BTRFS_I(inode)),
> +		.type = BTRFS_FSCRYPT_INODE_CTX_KEY,
> +		.offset = 0,
> +	};
> +	struct btrfs_path *path = NULL;
> +	struct extent_buffer *leaf;
> +	unsigned long ptr;
> +	int ret;
> +
> +	if (!trans)
> +		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 2);
> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
> +
> +	path = btrfs_alloc_path();
> +	if (!path) {
> +		ret = -ENOMEM;
> +		goto out_err;
> +	}
> +
> +	ret = btrfs_search_slot(trans, BTRFS_I(inode)->root, &key, path, 0, 1);
> +	if (ret < 0)
> +		goto out_err;
> +
> +	if (ret > 0) {
> +		btrfs_release_path(path);
> +		ret = btrfs_insert_empty_item(trans, BTRFS_I(inode)->root, path, &key, len);
> +		if (ret)
> +			goto out_err;
> +	}
> +
> +	leaf = path->nodes[0];
> +	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +
> +	len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
> +	write_extent_buffer(leaf, ctx, ptr, len);
> +	btrfs_mark_buffer_dirty(trans, leaf);
> +	btrfs_release_path(path);
> +
> +	if (fs_data)
> +		goto out_err;
> +
> +	BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
> +	btrfs_sync_inode_flags_to_i_flags(BTRFS_I(inode));
> +	inode_inc_iversion(inode);
> +	inode_set_ctime_current(inode);
> +	ret = btrfs_update_inode(trans, BTRFS_I(inode));
> +	if (ret)
> +		goto out_abort;
> +	btrfs_free_path(path);
> +	btrfs_end_transaction(trans);
> +	return 0;
> +out_abort:
> +	btrfs_abort_transaction(trans, ret);
> +out_err:
> +	if (!fs_data)
> +		btrfs_end_transaction(trans);
> +	btrfs_free_path(path);
> +	return ret;
> +}

The 'len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));'
line seems scary, since it just truncates the data given.

> @@ -199,7 +203,7 @@ static int check_fsflags(unsigned int old_flags, unsigned int flags)
>  		      FS_NOATIME_FL | FS_NODUMP_FL | \
>  		      FS_SYNC_FL | FS_DIRSYNC_FL | \
>  		      FS_NOCOMP_FL | FS_COMPR_FL |
> -		      FS_NOCOW_FL))
> +		      FS_NOCOW_FL | FS_ENCRYPT_FL))
>  		return -EOPNOTSUPP;

Do you know why FS_VERITY_FL isn't in this mask?

- Eric

