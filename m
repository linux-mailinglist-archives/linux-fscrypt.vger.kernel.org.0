Return-Path: <linux-fscrypt+bounces-1165-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iCvuK7Atmmm7ZQMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1165-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sat, 21 Feb 2026 23:12:00 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F09C16E127
	for <lists+linux-fscrypt@lfdr.de>; Sat, 21 Feb 2026 23:12:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E979A3028B34
	for <lists+linux-fscrypt@lfdr.de>; Sat, 21 Feb 2026 22:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C216131A07B;
	Sat, 21 Feb 2026 22:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F+R9WYSM"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EE93016FB;
	Sat, 21 Feb 2026 22:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771711915; cv=none; b=vBZox/f1o16yFKmsLQeIRhMuJk5JkQI4jpqQA+QA4QnV9NSmQh0boUlxPH92WHarDm35w4P7B/p5viMtKprhqpgU4pX/1NXySG2YnMuRpYR40avexi8iYpHVzCP+KYB9Z6TCFVM7SdF8brfpDycj3BmnVqcKIzbM0jb5wTdjvF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771711915; c=relaxed/simple;
	bh=Im1z0zOpLawmv/OjCDT7EX+Eo7PfHu61Azc2axlUICo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CHPErA4ZduzFKkcoW/+bsW9HPsuXr9ChZsBFIJX7aZRNnvaLEVaX4/+ONc28GyNzzJWHgnb8Myh7mU2HDSFjw4NlPx9XKIrjipGFBqjTgVQRkJjmp6G76QjbmobmH5/1CXTXc7Vu5UyeXCM3fJQ5AQ+kF91AiXL8Cs7iZuWOOqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F+R9WYSM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEA9C4CEF7;
	Sat, 21 Feb 2026 22:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771711915;
	bh=Im1z0zOpLawmv/OjCDT7EX+Eo7PfHu61Azc2axlUICo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F+R9WYSM/mN0t9pGSy7rUXPvFwM5xof48+6FYgMKgFlnVFdpfgNmgBjknZXyR2Ty3
	 nuvpprnCYJcB4dyo1bkgpgdwwLPr0/IuQNULpmAZ4DGnngKquOOOWUn0NWGGOcDdye
	 NfbljCL2nHDcfbXT+Ao1j+xOpip51OIeDK9SsuxENn4+RydDv6EkICexO+v4oUjHVo
	 zuI++eExJSewL5+T6ueOKVAkqddpch1PL4fxZ8wTOrbGNU0PRpuII1AODsc6LtViDE
	 kJonXuoZ2rg584chz9n7QcaStqrkOJD5vDu+HluV9K4jL0Rwd2W7JIDYcVmP+y6JGg
	 quIYfPgyF+zJg==
Date: Sat, 21 Feb 2026 14:11:53 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 01/43] fscrypt: add per-extent encryption support
Message-ID: <20260221221153.GA2123@quark>
References: <20260206182336.1397715-1-neelx@suse.com>
 <20260206182336.1397715-2-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206182336.1397715-2-neelx@suse.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1165-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0F09C16E127
X-Rspamd-Action: no action

I lost all my original comments on this patch due to a computer crash,
so apologies if this sounds a bit rushed.  (I should know better than to
run the latest mainline kernel.  Would be nice if kernel developers
focused on quality over new features...)

> +/*
> + * fscrypt_extent_context - the encryption context of an extent
> + *
> + * This is the on-disk information stored for an extent.  The nonce is used as a
> + * KDF input in conjuction with the inode context to derive a per-extent key for
> + * encryption.
> + *
> + * With the current implementation, master_key_identifier and encryption mode
> + * must match the inode context.  These are here for future expansion where we
> + * may want the option of mixing different keys and encryption modes for the
> + * same file.
> + */

Above comment should document that this is used only when the filesystem
uses per-extent encryption

> +/**
> + * fscrypt_set_bio_crypt_ctx_from_extent() - prepare a file contents bio for
> + *					     inline crypto with extent
> + *					     encryption
> + * @bio: a bio which will eventually be submitted to the file
> + * @ei: the extent's crypto info
> + * @first_lblk: the first file logical block number in the I/O

first_lblk probably should be 'pos' to match Christoph's pending patches
(https://lore.kernel.org/linux-fscrypt/20260218061531.3318130-1-hch@lst.de).
Either way, it also needs to be correctly documented to be an offset
into the extent, not the file.

> + * If the contents of the file should be encrypted (or decrypted) with inline
> + * encryption, then assign the appropriate encryption context to the bio.

Above comment was copy-pasted and is misleading in its new context.
This function assigns the encryption context unconditionally.

> + * Normally the bio should be newly allocated (i.e. no pages added yet), as
> + * otherwise fscrypt_mergeable_bio() won't work as intended.

Likewise, copy-pasted comment that is misleading in the new context.
It should refer to fscrypt_mergeable_extent_bio().

> +void fscrypt_set_bio_crypt_ctx_from_extent(struct bio *bio,
> +					   const struct fscrypt_extent_info *ei,
> +					   u64 first_lblk, gfp_t gfp_mask)
> +{
> +	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = { first_lblk };

Above needs to calculate the DUN correctly when the data unit size is
less than the file logical block size, or else the combination of
sub-block data units and per-extent encryption needs to be explicitly
not supported.  Probably just the latter for now (it can be enforced by
fscrypt_supported_v2_policy()).

> +/**
> + * fscrypt_mergeable_extent_bio() - test whether data can be added to a bio
> + * @bio: the bio being built up
> + * @ei: the fscrypt_extent_info for this extent
> + * @next_lblk: the next file logical block number in the I/O
> + *
> + * When building a bio which may contain data which should undergo inline
> + * encryption (or decryption) via fscrypt, filesystems should call this function
> + * to ensure that the resulting bio contains only contiguous data unit numbers.
> + * This will return false if the next part of the I/O cannot be merged with the
> + * bio because either the encryption key would be different or the encryption
> + * data unit numbers would be discontiguous.
> + *
> + * fscrypt_set_bio_crypt_ctx_from_extent() must have already been called on the
> + * bio.
> + *
> + * This function isn't required in cases where crypto-mergeability is ensured in
> + * another way, such as I/O targeting only a single file (and thus a single key)
> + * combined with fscrypt_limit_io_blocks() to ensure DUN contiguity.
> + *
> + * Return: true iff the I/O is mergeable
> + */
> +bool fscrypt_mergeable_extent_bio(struct bio *bio,
> +				  const struct fscrypt_extent_info *ei,
> +				  u64 next_lblk)
> +{
> +	const struct bio_crypt_ctx *bc = bio->bi_crypt_context;
> +	u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = { next_lblk };
> +
> +	if (!ei)
> +		return true;
> +	if (!bc)
> +		return true;
> +
> +	/*
> +	 * Comparing the key pointers is good enough, as all I/O for each key
> +	 * uses the same pointer.  I.e., there's currently no need to support
> +	 * merging requests where the keys are the same but the pointers differ.
> +	 */
> +	if (bc->bc_key != ei->prep_key.blk_key)
> +		return false;
> +
> +	return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
> +}
> +EXPORT_SYMBOL_GPL(fscrypt_mergeable_extent_bio);

Similar to fscrypt_set_bio_crypt_ctx_from_extent().  The copy-pasted
comment needs to be updated to remove no-longer-relevant information
specific to per-file encryption and correctly reflect per-extent
encryption.  The DUN needs to be calculated correctly for sub-block data
units or else the combination of the two needs to be unsupported.

> +static struct fscrypt_extent_info *
> +setup_extent_info(struct inode *inode, const u8 nonce[FSCRYPT_FILE_NONCE_SIZE])
> +{
> +	struct fscrypt_extent_info *ei;
> +	struct fscrypt_inode_info *ci;
> +	struct fscrypt_master_key *mk;
> +	u8 derived_key[FSCRYPT_MAX_RAW_KEY_SIZE];
> +	int err;
> +
> +	ci = *fscrypt_inode_info_addr(inode);
> +	mk = ci->ci_master_key;
> +	if (WARN_ON_ONCE(!mk))
> +		return ERR_PTR(-ENOKEY);
> +
> +	ei = kmem_cache_zalloc(fscrypt_extent_info_cachep, GFP_KERNEL);
> +	if (!ei)
> +		return ERR_PTR(-ENOMEM);
> +
> +	refcount_set(&ei->refs, 1);
> +	memcpy(ei->nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
> +	ei->sb = inode->i_sb;
> +
> +	down_read(&mk->mk_sem);
> +	/*
> +	 * We specifically don't check ->mk_present here because if the inode is
> +	 * open and has a reference on the master key then it should be
> +	 * available for us to use.
> +	 */

Above comment should be reworded to clarify that it is expected for
->mk_present to be either true or false here.  As-is, it can be
interpreted as meaning that checking ->mk_present is unnecessary because
it is guaranteed to be true.

The comment above struct fscrypt_master_key (which documents the
different states the master key can be in) also needs to be updated to
document that with filesystems that use per-extent encryption,
->mk_secret isn't wiped when the key is in the incompletely-removed
state (and why that needs to be the case).

> +/**
> + * fscrypt_prepare_new_extent() - prepare to create a new extent for a file
> + * @inode: the possibly-encrypted inode
> + *
> + * If the inode is encrypted, setup the fscrypt_extent_info for a new extent.
> + * This will include the nonce and the derived key necessary for the extent to
> + * be encrypted.  This is only meant to be used with inline crypto and on inodes
> + * that need their contents encrypted.
> + *
> + * This doesn't persist the new extents encryption context, this is done later
> + * by calling fscrypt_set_extent_context().
> + *
> + * Return: The newly allocated fscrypt_extent_info on success, -EOPNOTSUPP if
> + *	   we're not encrypted, or another -errno code
> + */
> +struct fscrypt_extent_info *fscrypt_prepare_new_extent(struct inode *inode)
> +{
> +	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
> +
> +	if (WARN_ON_ONCE(!*fscrypt_inode_info_addr(inode)))
> +		return ERR_PTR(-EOPNOTSUPP);
> +	if (WARN_ON_ONCE(!fscrypt_inode_uses_inline_crypto(inode)))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	get_random_bytes(nonce, FSCRYPT_FILE_NONCE_SIZE);
> +	return setup_extent_info(inode, nonce);
> +}
> +EXPORT_SYMBOL_GPL(fscrypt_prepare_new_extent);

Similarly, there seems to have been a lot of incorrect copy+pasting in
the function comment.  This new function requires that the caller *must*
provide an encrypted inode, otherwise it WARNs.  It can't be
"possibly-encrypted".

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
> +struct fscrypt_extent_info *fscrypt_load_extent_info(struct inode *inode,
> +						     u8 *ctx, size_t ctx_size)

ctx should have type 'const u8 *'

> +/**
> + * fscrypt_set_extent_context() - Set the fscrypt extent context of a new extent
> + * @inode: the inode this extent belongs to
> + * @ei: the fscrypt_extent_info for the given extent
> + * @buf: the buffer to copy the fscrypt extent context into
> + *
> + * This should be called after fscrypt_prepare_new_extent(), using the
> + * fscrypt_extent_info that was created at that point.
> + *
> + * buf must be at most FSCRYPT_SET_CONTEXT_MAX_SIZE.
> + *
> + * Return: the size of the fscrypt_extent_context, errno if the inode has the
> + *	   wrong policy version.
> + */
> +ssize_t fscrypt_context_for_new_extent(struct inode *inode,
> +				       struct fscrypt_extent_info *ei, u8 *buf)
> +{
> +	struct fscrypt_extent_context *ctx = (struct fscrypt_extent_context *)buf;
> +	const struct fscrypt_inode_info *ci = *fscrypt_inode_info_addr(inode);
> +
> +	BUILD_BUG_ON(sizeof(struct fscrypt_extent_context) >
> +		     FSCRYPT_SET_CONTEXT_MAX_SIZE);
> +
> +	if (WARN_ON_ONCE(ci->ci_policy.version != 2))
> +		return -EINVAL;
> +
> +	ctx->version = FSCRYPT_EXTENT_CONTEXT_V1;
> +	ctx->encryption_mode = ci->ci_policy.v2.contents_encryption_mode;
> +	memcpy(ctx->master_key_identifier,
> +	       ci->ci_policy.v2.master_key_identifier,
> +	       sizeof(ctx->master_key_identifier));
> +	memcpy(ctx->nonce, ei->nonce, FSCRYPT_FILE_NONCE_SIZE);
> +	return sizeof(struct fscrypt_extent_context);
> +}
> +EXPORT_SYMBOL_GPL(fscrypt_context_for_new_extent);

The documentation "buf must be at most FSCRYPT_SET_CONTEXT_MAX_SIZE" is
incorrect.  It must actually be *at least* the size of
'struct fscrypt_extent_context'.

Given that it's a fixed size, it probably would make sense to make the
ouptut parameter reflect that: 'u8 out[FSCRYPT_EXTENT_CONTEXT_SIZE]'.
Or even just use the struct itself.

> +	/*
> +	 * If set then extent based encryption will be used for this file
> +	 * system, and fs/crypto/ will enforce limits on the policies that are
> +	 * allowed to be chosen.  Currently this means only plain v2 policies
> +	 * are supported.
> +	 */
> +	unsigned int has_per_extent_encryption : 1;

Needs clarification about what is meant by "plain".  Some flags are
supported (specifically the filename padding ones), some flags are not.
All encryption modes still seem to be supported.

> +	if (count > 0 && inode->i_sb->s_cop->has_per_extent_encryption) {
> +		fscrypt_warn(inode,
> +			     "Encryption flags aren't supported on file systems that use extent encryption");
> +		return false;
> +	}

Similarly, this error message needs clarification.  Some encryption
flags are supported, some aren't.

- Eric

