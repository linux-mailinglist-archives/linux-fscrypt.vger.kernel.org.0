Return-Path: <linux-fscrypt+bounces-1553-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ANDKHgdS6Wl2XgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1553-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Apr 2026 00:56:07 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA9244B5EE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Apr 2026 00:56:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 69F6E3051BFF
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Apr 2026 22:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2754337BE78;
	Wed, 22 Apr 2026 22:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFESlm5X"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023CA32ED40;
	Wed, 22 Apr 2026 22:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776898466; cv=none; b=etU5OFau05BGOXsm99LZWHPiJmflOsPYwmTK/hE+1UpAsOfgttkoxw9U9K+l5NwFI6zA2KIuzgtXFR2JRUCpP7UgZzyw7A8CLLTdMutomZ0hwOKSi1F5VXDECr3DkcMZsl41E1DQPXK+Z+3DKCBI7m5pJk/0DJZa6FOvTomv6Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776898466; c=relaxed/simple;
	bh=Xwdj3WPtuVugPCCdzzAsmUilrlXNct1Zv2lAeA2Zzxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f/9kx20EMI2/QzHszxVVgtq8pxwqd7hSr3qzG2RcJUdCSs4whyQF5qDUKhPdQK0wA1XZSEBxvjTFJvTTCt4Euc7mDWQfaIyiWICEcdReEfZRce2FYkOhMSM0rWPa2BLfPqgxC94hoVin4WFRcjxeRN/z0rrjbPoSHMXOQJnvCK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFESlm5X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853CEC19425;
	Wed, 22 Apr 2026 22:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776898465;
	bh=Xwdj3WPtuVugPCCdzzAsmUilrlXNct1Zv2lAeA2Zzxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nFESlm5X3p9423YsQhMhvWhuNIU93mJ3vAInWDA9ykantZvTRsXwxfkwD/exp4d+X
	 wpwR8pZIA6cmduvSklON9PDdhFUmOFDwhjpbXbRVdrE9GaW2xjkNZf9dNzzDUXw7Q1
	 Wpe3ubCm97yLTMqe8waKErBGZ94e+Z/7KxdGoUny/LQ1va6PiZiYn2v5bHpDSYb8gj
	 sn6u9EPhbUkjeQqc8eQQxxGAJ6Qe8OG5tZPPRSCpJFD8aRenVOXRdT0IN30Kg1uneI
	 +Y1bxXhDJSfrRefYZxsanllXb14+ttOrJY6Mme41mXoLIRbgbjNPnb/ix10x8WOuz0
	 znQU3BP4UL3fA==
Date: Wed, 22 Apr 2026 15:53:10 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 01/43] fscrypt: add per-extent encryption support
Message-ID: <20260422225310.GB2226@sol>
References: <20260206182336.1397715-1-neelx@suse.com>
 <20260206182336.1397715-2-neelx@suse.com>
 <20260221221153.GA2123@quark>
 <CAPjX3FficsLf2QXFU70sR6PN7h8rj5opz_wntLm+Acd3YLvu+A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPjX3FficsLf2QXFU70sR6PN7h8rj5opz_wntLm+Acd3YLvu+A@mail.gmail.com>
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
	TAGGED_FROM(0.00)[bounces-1553-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CAA9244B5EE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 22, 2026 at 10:17:40AM +0200, Daniel Vacek wrote:
> > > +/**
> > > + * fscrypt_mergeable_extent_bio() - test whether data can be added to a bio
> > > + * @bio: the bio being built up
> > > + * @ei: the fscrypt_extent_info for this extent
> > > + * @next_lblk: the next file logical block number in the I/O
> > > + *
> > > + * When building a bio which may contain data which should undergo inline
> > > + * encryption (or decryption) via fscrypt, filesystems should call this function
> > > + * to ensure that the resulting bio contains only contiguous data unit numbers.
> > > + * This will return false if the next part of the I/O cannot be merged with the
> > > + * bio because either the encryption key would be different or the encryption
> > > + * data unit numbers would be discontiguous.
> > > + *
> > > + * fscrypt_set_bio_crypt_ctx_from_extent() must have already been called on the
> > > + * bio.
> > > + *
> > > + * This function isn't required in cases where crypto-mergeability is ensured in
> > > + * another way, such as I/O targeting only a single file (and thus a single key)
> > > + * combined with fscrypt_limit_io_blocks() to ensure DUN contiguity.
> > > + *
> > > + * Return: true iff the I/O is mergeable
> > > + */
> > > +bool fscrypt_mergeable_extent_bio(struct bio *bio,
> > > +                               const struct fscrypt_extent_info *ei,
> > > +                               u64 next_lblk)
> > > +{
> > > +     const struct bio_crypt_ctx *bc = bio->bi_crypt_context;
> > > +     u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = { next_lblk };
> > > +
> > > +     if (!ei)
> > > +             return true;
> > > +     if (!bc)
> > > +             return true;
> > > +
> > > +     /*
> > > +      * Comparing the key pointers is good enough, as all I/O for each key
> > > +      * uses the same pointer.  I.e., there's currently no need to support
> > > +      * merging requests where the keys are the same but the pointers differ.
> > > +      */
> > > +     if (bc->bc_key != ei->prep_key.blk_key)
> > > +             return false;
> > > +
> > > +     return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
> > > +}
> > > +EXPORT_SYMBOL_GPL(fscrypt_mergeable_extent_bio);
> >
> > Similar to fscrypt_set_bio_crypt_ctx_from_extent().  The copy-pasted
> > comment needs to be updated to remove no-longer-relevant information
> > specific to per-file encryption and correctly reflect per-extent
> > encryption.  The DUN needs to be calculated correctly for sub-block data
> > units or else the combination of the two needs to be unsupported.
> 
> The DUN is fixed as per above. Regarding the comment, it looks quite
> valid to me. What exactly would you like to change?

It's now been a while since I was looking at this, but looking at it
again now, at least the following parts are incorrect:

    "the next file logical block number in the I/O"

    "I/O targeting only a single file (and thus a single key)"

It's actually the block number in the *extent*.  And it's a single key
only when the I/O targets a single *extent*.

- Eric

