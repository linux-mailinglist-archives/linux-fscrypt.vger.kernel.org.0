Return-Path: <linux-fscrypt+bounces-1616-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBfiIFYLHmoHgwkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1616-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 00:44:38 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F49626006
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 00:44:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 82A26301829B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jun 2026 22:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C866538C402;
	Mon,  1 Jun 2026 22:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kSGsNGhP"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8855135E955;
	Mon,  1 Jun 2026 22:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780353874; cv=none; b=jg68BuWIEqwWYAaITB7ypp43ZM/D3jR49cAOzirurpqAgaOiMSxpDMS3W9I8qR39Pb+n8u3gndeZFJHIpk59Js+Yfekk2wh0pHkM+rqtjmtTuMnJh1GQFfNNv0DIdWsYQTK254wZhUyI1neJhGv2GhAqAnxuyRu9dcOuaNLw/Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780353874; c=relaxed/simple;
	bh=KATu1tbAfIEkqkYeh6tnDsAXn3aaawi1mSWivWHp8ZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LrbEqykmPbKpkulPKmyyU9smZzauIJqjEvF9qfhpZPj2ouapWmsX793MJFXA8bUUW8NZ7geQukl7O40zRl35zaJnGEQ7kPf0p9uEnpBJuXUCcpQm1yswLsqdtQeFvsVInZqig4R9H4+iVs5NWKVKWSNjgWwa0Sr9i1HSgKSdMes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kSGsNGhP; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C6E1F00893;
	Mon,  1 Jun 2026 22:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780353873;
	bh=wmQ9u5ZuVB+sDWrTh7arox0x0/2Gndy3fkUKRY4auvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kSGsNGhP+li+wMowRfEj9qd97Ew4kdZExza47xVMnjSM1FZC0Hq30zUB1lRoRL4Ze
	 oCkQbrkiEtMt+LSzXOPJdUNFk6s148BA/5vrsiHPHWWlzoqTy7m8eHFZOHkZOaOyVD
	 41IHY9PGNltK+5JjBO8f5nCSQ9Nvor/ZjqyeZXkyZ3RF1VxiinxJ7zGylRmU45PQjZ
	 rejP+AYE9Zz4eh1POJwPX5giwexb/ZAWonmdttaUBLU2W7WX989w8YMOKJC1X9Jxwa
	 GjyV/nIYH5oaqBTnrUrzAL8n1sjN720KY18hL54pa97K4xobCEJRxd4P7hN9YwWRvc
	 pzjqNwsMaM4Jg==
Date: Mon, 1 Jun 2026 15:44:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 01/43] fscrypt: add per-extent encryption support
Message-ID: <20260601224431.GA25574@quark>
References: <20260513085340.3673127-1-neelx@suse.com>
 <20260513085340.3673127-2-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085340.3673127-2-neelx@suse.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1616-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: E9F49626006
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 13, 2026 at 10:52:35AM +0200, Daniel Vacek wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> This adds the code necessary for per-extent encryption.  We will store a
> nonce for every extent we create, and then use the inode's policy and
> the extents nonce to derive a per-extent key.
> 
> This is meant to be flexible, if we choose to expand the on-disk extent
> information in the future we have a version number we can use to change
> what exists on disk.
> 
> The file system indicates it wants to use per-extent encryption by
> setting s_cop->has_per_extent_encryption.  This also requires the use of
> inline block encryption.
> 
> The support is relatively straightforward, the only "extra" bit is we're
> deriving a per-extent key to use for the encryption, the inode still
> controls the policy and access to the master key.
> 
> Since extent based encryption uses a lot of keys, we're requiring the
> use of inline block crypto if you use extent-based encryption.  This
> enables us to take advantage of the built in pooling and reclamation of
> the crypto structures that underpin all of the encryption.

The whole reason for extent-based encryption is that extents can be
shared between inodes.  So the repeated mentions of "the inode" are
really confusing.  This shows up in a lot of different places.

What's actually implemented is that each extent stores its own
(encryption_mode, master_key_identifier, nonce), but for now the
invariant is maintained that all inodes that reference an extent share
the same (encryption_mode, master_key_identifier) as the extent.

It would be helpful to document this stuff accordingly.

> +/*
> + * fscrypt_extent_context - the encryption context of an extent
> + *
> + * This is the on-disk information stored for an extent.  The nonce is used as a
> + * KDF input in conjuction with the inode context to derive a per-extent key for
> + * encryption.  This is used only when the filesystem uses per-extent encryption.
> + *

Basically the same issue here.  The master_key_identifier is actually
stored in the extent.  Just the current implementation enforces that
when the filesystem accesses the extent through some inode, that inode
also has the same master_key_identifier.  How about replacing the second
sentence with something like: "The nonce and master_key_identifier are
used to derive the key which encrypts the extent."

> + * With the current implementation, master_key_identifier and encryption mode
> + * must match the inode context.  These are here for future expansion where we
> + * may want the option of mixing different keys and encryption modes for the
> + * same file.
> + */

Likewise.  Something like: With the current implementation,
master_key_identifier and encryption_mode always match the corresponding
values from the fscrypt_context in each inode that shares the extent.

> +struct fscrypt_extent_context {
> +	u8 version; /* FSCRYPT_EXTENT_CONTEXT_V1 */
> +	u8 encryption_mode;
> +	u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
> +	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
> +};

Well, it's an extent nonce, not a file nonce.  It seems it's handled
completely separately from the existing file nonce, so it probably
should get its own size constant FSCRYPT_EXTENT_NONCE_SIZE.

> +/**
> + * fscrypt_set_bio_crypt_ctx_from_extent() - prepare a file contents bio for
> + *					     inline crypto with extent
> + *					     encryption
> + * @bio: a bio which will eventually be submitted to the file
> + * @ei: the extent's crypto info

@ei: the extent's crypto info, or NULL if the extent is unencrypted

> + * If the contents of the file should be encrypted (or decrypted) with inline
> + * encryption, then assign the appropriate encryption context to the bio.

"If the contents of the file should be encrypted (or decrypted) with
inline encryption" => "If the extent should be encrypted (or decrypted)"

There's no "file" here.  And inline encryption is the only option for
extents.

> +/**
> + * fscrypt_mergeable_extent_bio() - test whether data can be added to a bio
> + * @bio: the bio being built up
> + * @ei: the fscrypt_extent_info for this extent

@ei: the extent's crypto info, or NULL if the extent is unencrypted

> + * @pos: the next extent logical offset (in bytes) in the I/O
> + *
> + * When building a bio which may contain data which should undergo inline
> + * encryption (or decryption) via fscrypt,

When building a bio which may contain data which should undergo extent
encryption (or decryption)

> +static struct fscrypt_extent_info *
> +setup_extent_info(struct inode *inode, const u8 nonce[FSCRYPT_FILE_NONCE_SIZE])
> +{
> +	struct fscrypt_extent_info *ei;
> +	struct fscrypt_inode_info *ci;
> +	struct fscrypt_master_key *mk;
> +	u8 derived_key[FSCRYPT_MAX_RAW_KEY_SIZE];
> +	int keysize;
> +	int err;
> +
> +	ci = *fscrypt_inode_info_addr(inode);

fscrypt_get_inode_info_raw()

> +/**
> + * fscrypt_prepare_new_extent() - prepare to create a new extent for a file
> + * @inode: the encrypted inode
> + *
> + * If the inode is encrypted, setup the fscrypt_extent_info for a new extent.
> +
> + * This will include the nonce and the derived key necessary for the extent to
> + * be encrypted.  This is only meant to be used with inline crypto and on inodes
> + * that need their contents encrypted.

This is ambiguous and contradictory about what type of @inode is
required.  It should be something like:

* @inode: an encrypted regular file with its key already set up, on a
*        filesystem that uses per-extent encryption
*
* Prepare to encrypt a new extent by generating a new extent nonce,
* deriving an extent key, and allocating an fscrypt_extent_info.

> * This doesn't persist the new extents encryption context, this is done later   
> * by calling fscrypt_set_extent_context().

There's no function with that name

> +	if (WARN_ON_ONCE(!*fscrypt_inode_info_addr(inode)))
> +		return ERR_PTR(-EOPNOTSUPP);
> +	if (WARN_ON_ONCE(!fscrypt_inode_uses_inline_crypto(inode)))
> +		return ERR_PTR(-EOPNOTSUPP);

I'm confused what these checks are trying to do.  The first part checks
for the inode's encryption key, but setup_extent_info() does that
anyway.  The second part is maybe intended to check that the file uses
extent encryption, but it doesn't do it correctly.  That would require:
fscrypt_needs_contents_encryption(inode) &&
inode->i_sb->s_cop->has_per_extent_encryption.

It probably would make sense to check that directly in
setup_extent_info(), so that it's closer to the call to
fscrypt_hkdf_expand() which would has a *very* bad failure mode when
!has_per_extent_encryption.

> +/**
> + * fscrypt_load_extent_info() - create an fscrypt_extent_info from the context
> + * @inode: the inode
> + * @ctx: the context buffer
> + * @ctx_size: the size of the context buffer
> + *
> + * Create the fscrypt_extent_info and derive the key based on the
> + * fscrypt_extent_context buffer that is provided.
> + *
> + * Return: The newly allocated fscrypt_extent_info on success, -EOPNOTSUPP if
> + *	   we're not encrypted, or another -errno code
> + */

What context is this expected to be called in?  I see the caller uses
memalloc_nofs_save().  This would require making ->mk_sem nofs-safe; is
there a plan to do that?  (Sashiko noticed this too, by the way.)

> +	const struct fscrypt_inode_info *ci = *fscrypt_inode_info_addr(inode);

fscrypt_get_inode_info_raw(inode)

> +/**
> + * fscrypt_set_extent_context() - Set the fscrypt extent context of a new extent

It seems the function name and semantics changed at some point, but the
kerneldoc wasn't updated.

> + * @inode: the inode this extent belongs to

The inode that the extent will initially belong to, I guess?

> +ssize_t fscrypt_context_for_new_extent(struct inode *inode,
> +				       struct fscrypt_extent_info *ei, u8 *buf)
> +{
> +	struct fscrypt_extent_context *ctx = (struct fscrypt_extent_context *)buf;
> +	const struct fscrypt_inode_info *ci = *fscrypt_inode_info_addr(inode);

fscrypt_get_inode_info_raw(inode)

- Eric

