Return-Path: <linux-fscrypt+bounces-1625-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6BU9H4VDHmraiAkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1625-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 04:44:21 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE7356275BB
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 04:44:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0372F30065F5
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jun 2026 02:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C34F833D4E5;
	Tue,  2 Jun 2026 02:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ezJ+I9f+"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8AA2010EE;
	Tue,  2 Jun 2026 02:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780368258; cv=none; b=qLUfkQ1OL9IoxbdunsLazmdVaXWwt7570jw454kfsX+HCXEcxQ0k+P8Mbjtf1cF3VtAi9XUNkr18KI8eubYpLtQFRDnlC9JUpVyWk2r4cIcF1C76t7EhVeYwj9u3JZ3Xlwja0R/0T+l51j81YaE4j1yZMi99xYLIQINr1c5T9cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780368258; c=relaxed/simple;
	bh=+XmuWlYhTiGmsCI4VothlVzBVtFcGZqioM02u69DrP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oPZIlewKhrTEx6vxEsK4GihzciWfvpfFkWbtewBbSUaZHqyN8zaG2ZPJyktfIXEQxoT9Ep3HdnMn0wivF6Hc50q/PyjergrrzOdQdGwF3wyuh6cqBXPS1Dk+Glp6M4T2riwYHBQalRpmBmTRzKmV8XbViJOsn/3gIX3bLnwA4/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ezJ+I9f+; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048E71F00893;
	Tue,  2 Jun 2026 02:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780368257;
	bh=Y4+34rADgxCwFAIURmToK3k1LlbMQhZN2+W42i8hbLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ezJ+I9f+yY5uO9suor+/Yg0R9GFiKd4A8UPK30O7jK+WBDh/uzGqdwf2aBN5L2SR+
	 LomF5C2oUXergM5ru3hOR+fGEMT02RIFlfJC86wWjagsrfih8lBoEjOG57mE/df8nu
	 O5AP6x5NQtH28FiXFMRHZzbGsCimMF6hcIGRTFunoIu4WDmChZZd0F4Z2piCMuRA11
	 hcW/NNFQzGxpq5O8WDKJJNrYwn02XmR8wqYB7APGyrzlmygEs5FTtYlfNVmZNF+tAb
	 uQ7jn+RvRURT5TMlnSwaGVuD+EInBAq1Npxmt705Dauvkczup6XFR8NXaqrthnAX1P
	 Na81djBI3fAVQ==
Date: Mon, 1 Jun 2026 19:42:53 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 36/43] btrfs: deal with encrypted symlinks in send
Message-ID: <20260602024253.GD2295@sol>
References: <20260513085340.3673127-1-neelx@suse.com>
 <20260513085340.3673127-37-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085340.3673127-37-neelx@suse.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1625-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: DE7356275BB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 13, 2026 at 10:53:10AM +0200, Daniel Vacek wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Send needs to send the decrypted value of the symlinks, handle the case
> where the inode is encrypted and decrypt the symlink name into a buffer
> and copy this buffer into our fs_path struct.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
> 
> No changes in v7.
> v6 changes:
>  * read_symlink_encrypted() reworked from using pages to using folios.
> v5: https://lore.kernel.org/linux-btrfs/4d97f35d6f85ff041b09bed33b63446a92b7a20c.1706116485.git.josef@toxicpanda.com/
> ---
>  fs/btrfs/send.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 42 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 89d72d8cb85f..d5256c22fe7a 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1701,9 +1701,7 @@ static int find_extent_clone(struct send_ctx *sctx,
>  	return ret;
>  }
>  
> -static int read_symlink(struct btrfs_root *root,
> -			u64 ino,
> -			struct fs_path *dest)
> +static int read_symlink_unencrypted(struct btrfs_root *root, u64 ino, struct fs_path *dest)
>  {
>  	int ret;
>  	BTRFS_PATH_AUTO_FREE(path);
> @@ -1764,6 +1762,47 @@ static int read_symlink(struct btrfs_root *root,
>  	return fs_path_add_from_extent_buffer(dest, path->nodes[0], off, len);
>  }
>  
> +static int read_symlink_encrypted(struct btrfs_root *root, u64 ino, struct fs_path *dest)
> +{
> +	DEFINE_DELAYED_CALL(done);
> +	const char *buf;
> +	struct folio *folio;
> +	struct btrfs_inode *inode;
> +	int ret = 0;
> +
> +	inode = btrfs_iget(ino, root);
> +	if (IS_ERR(inode))
> +		return PTR_ERR(inode);
> +
> +	folio = read_mapping_folio(inode->vfs_inode.i_mapping, 0, NULL);
> +	if (IS_ERR(folio)) {
> +		iput(&inode->vfs_inode);
> +		return PTR_ERR(folio);
> +	}
> +
> +	buf = fscrypt_get_symlink(&inode->vfs_inode, folio_address(folio),
> +				  BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info),
> +				  &done);
> +	folio_put(folio);
> +	iput(&inode->vfs_inode);
> +
> +	if (IS_ERR(buf))
> +		return PTR_ERR(buf);
> +
> +	ret = fs_path_add(dest, buf, strlen(buf));
> +	do_delayed_call(&done);
> +	return ret;
> +}
> +
> +
> +static int read_symlink(struct btrfs_root *root, u64 ino,
> +			struct fs_path *dest)
> +{
> +	if (btrfs_fs_incompat(root->fs_info, ENCRYPT))
> +		return read_symlink_encrypted(root, ino, dest);
> +	return read_symlink_unencrypted(root, ino, dest);
> +}

This just assumes that all the symlinks on the filesystem are encrypted,
without checking the actual encrypt flag in the inode.

Of course, looking at the Sashiko review for this patch, it already
found this, as well as a use-after-free.

I don't know why I'm even reviewing this.

- Eric

