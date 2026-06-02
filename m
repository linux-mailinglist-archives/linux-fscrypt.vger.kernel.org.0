Return-Path: <linux-fscrypt+bounces-1623-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UOKYDFtCHmraiAkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1623-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 04:39:23 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C92A862756B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 04:39:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 953253033082
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jun 2026 02:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E3636404D;
	Tue,  2 Jun 2026 02:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ala2GhQH"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C502360EEA;
	Tue,  2 Jun 2026 02:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780367696; cv=none; b=Wu26d/t471d55/8c7GMqVpZzgeJK9quSijWvtbhE8X7xF+JUaiXdrmxBYK341a/zzuVwiu6JdTd4L1ujL/pzpKuJVFiO6hOY5jSMVmxzXWretZFqL1iHGWgUIu57lep+TXSzkpvAUq18SSk7D07pDnoO6VK5CMwZL7Kb2YNGCe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780367696; c=relaxed/simple;
	bh=2tShorXRDReeAJVBHRTidHF+h9tfBZ3nRXlgTfSN5qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o3ztbfmlHtmmP5gg9uaELE0PlAURUoHUq1TnNUb89j3Ax7Ih1XmAA71fZVaLUC8GJbQ4QYXxGD6ZmKn/E5xh+qFj5WykgpHcxXOXm2eymIMHImkPsUCXOeNgF2AQNjjbp1wc2KoCQBAWP9qdJfVC9sI91epDa0x3Ft+SqoncBbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ala2GhQH; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD181F00893;
	Tue,  2 Jun 2026 02:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780367695;
	bh=+6j85ulevrPveFbfd3LbMkWTpBVsa0Psgc9o5Czs1OI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ala2GhQH0LiwO2PoeleVAwN70S7OSTTs4pFL4Surly1rCjqAOs6EP3zuBEglDz7fs
	 E28vZhqDTFJHo3WZF/WabUaBKZ2PHmvdz7ipG3mxTw+2SPajJhpq39jeEXaH4UvwBq
	 +fB7V2yDZSkHAInT4E9N144edTdSkv8+FE5IyihJvaP/EbIwoCuuGvM3+IOfQiAYhy
	 8t+DBLYO/Z/QvFb/ayPPZ8Yjssd4JTvDbUHLsjlTiu3yrq5dR3+PqhJRV9uKQpNDX3
	 L28I50V1DzDdA3wNAsGD1MNVzY75d2rxBFWYw5cSuNKkChAjETYeNyg2aJh+/QadiD
	 EPOiskyDqs4yg==
Date: Mon, 1 Jun 2026 19:33:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 03/43] fscrypt: add a __fscrypt_file_open helper
Message-ID: <20260602023330.GB2295@sol>
References: <20260513085340.3673127-1-neelx@suse.com>
 <20260513085340.3673127-4-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085340.3673127-4-neelx@suse.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1623-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: C92A862756B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 13, 2026 at 10:52:37AM +0200, Daniel Vacek wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> We have fscrypt_file_open() which is meant to be called on files being
> opened so that their key is loaded when we start reading data from them.
> 
> However for btrfs send we are opening the inode directly without a filp,
> so we need a different helper to make sure we can load the fscrypt
> context for the inode before reading its contents.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
> 
> No changes in v7.
> v6 changes:
>  * Adapted to fscrypt changes since the last two years.
> v5: https://lore.kernel.org/linux-btrfs/4a372419c3fe6ad425e1b124c342a054e9d6db23.1706116485.git.josef@toxicpanda.com/
> ---
>  fs/crypto/hooks.c       | 38 ++++++++++++++++++++++++++++++++------
>  include/linux/fscrypt.h |  8 ++++++++
>  2 files changed, 40 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
> index a7a8a3f581a0..3142cf106bde 100644
> --- a/fs/crypto/hooks.c
> +++ b/fs/crypto/hooks.c
> @@ -9,6 +9,37 @@
>  
>  #include "fscrypt_private.h"
>  
> +/**
> + * __fscrypt_file_open() - prepare for filesystem-internal access to a
> + *			   possibly-encrypted regular file
> + * @dir: the inode for the directory via which the file is being accessed
> + * @inode: the inode being "opened"
> + *
> + * This is like fscrypt_file_open(), but instead of taking the 'struct file'
> + * being opened it takes the parent directory explicitly.  This is intended for
> + * use cases such as "send/receive" which involve the filesystem accessing file
> + * contents without setting up a 'struct file'.
> + *
> + * Return: 0 on success, -ENOKEY if the key is missing, or another -errno code
> + */
> +int __fscrypt_file_open(struct inode *dir, struct inode *inode)
> +{
> +	int err;
> +
> +	err = fscrypt_require_key(inode);
> +	if (err)
> +		return err;
> +
> +	if (!fscrypt_has_permitted_context(dir, inode)) {
> +		fscrypt_warn(inode,
> +			     "Inconsistent encryption context (parent directory: %llu)",
> +			     dir->i_ino);
> +		return -EPERM;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(__fscrypt_file_open);
> +
>  /**
>   * fscrypt_file_open() - prepare to open a possibly-encrypted regular file
>   * @inode: the inode being opened
> @@ -60,12 +91,7 @@ int fscrypt_file_open(struct inode *inode, struct file *filp)
>  	rcu_read_unlock();
>  
>  	dentry_parent = dget_parent(dentry);
> -	if (!fscrypt_has_permitted_context(d_inode(dentry_parent), inode)) {
> -		fscrypt_warn(inode,
> -			     "Inconsistent encryption context (parent directory: %llu)",
> -			     d_inode(dentry_parent)->i_ino);
> -		err = -EPERM;
> -	}
> +	err = __fscrypt_file_open(d_inode(dentry_parent), inode);
>  	dput(dentry_parent);
>  	return err;
>  }

This change makes fscrypt_file_open() execute an unnecessary extra
fscrypt_require_key().  Could we just leave fscrypt_file_open() as-is?

- Eric

