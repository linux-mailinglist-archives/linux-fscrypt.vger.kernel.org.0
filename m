Return-Path: <linux-fscrypt+bounces-1618-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMFXMu4PHmrugwkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1618-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 01:04:14 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C9D7B6262C0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 01:04:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D29E73006030
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jun 2026 23:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CAF34EEEE;
	Mon,  1 Jun 2026 23:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCkwUjVI"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19354224B15;
	Mon,  1 Jun 2026 23:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780355049; cv=none; b=bSjLwaP2rR6uWFfr78WeP2j6a5olqBxJrNWs/Wc5ZgVr3ZkJ0NahMVeDgDktQ4//zYdcQIJEXdoaR4ztdBh3SVj9wITLWFu58QmaULf2MVtxkToiPI3L5h0pe2o0aMkS9bDwNqiIpIiYdNK6f+4BB9ZS2PX7CrYgsf2gkmwlzAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780355049; c=relaxed/simple;
	bh=hccmhEM7NFTJfTbJKCVZ0R2DpNIGlpyM1E4p9C7ezKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MiTQgcfMfoQVJ146yQrZUWn9XPoALWT1qJXsKvjD5sKp5tzJmHdUCHSy+tvwxd8BT6+imvk0wx2S+3i5VA70FL8oyhShzPi4aHnBJE5YOaEEK2gH846I3zH2aDWu+JoWehtsyBW/aEXqH0VnlXZRK4kcOExqOHVIQUiS5uM1ibs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCkwUjVI; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC141F00893;
	Mon,  1 Jun 2026 23:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780355047;
	bh=iTlom6GZ9mm24ZCyyYADF1m0w1466DE5A0K+MWuDAMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VCkwUjVI1WkDbktWYZdENab7TzGFkQZC/6kM4pTnZcZLaGE0JcoTLMkLK7w1YViJl
	 KbVkaBjbRLE5sILzWg2mivI3IjavDGPpj4MGruENGwEFP0QtDQNy4d7bnssVEllgJr
	 RSAt/+VzqwHimfUnRzzmlKoI8TX6ZaJryXkeulsvNBLUx41C/kijCI2uwBVMMx8TtB
	 Nj+XHivSrUiBZJtpKX4HYeg/OSjUgOMG68rMYsFJCOo8uJCsLP/nsEg/UMVSg59+69
	 2ICq9Y9ao6PlhGK0dN1d/2/gzu7Ehz6rXvDdxheB8kQyhZPZODtP92cbtEGt/CtRqD
	 lM+tsW2mVkE+g==
Date: Mon, 1 Jun 2026 16:04:06 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 04/43] fscrypt: conditionally don't wipe mk secret
 until the last active user is done
Message-ID: <20260601230406.GC25574@quark>
References: <20260513085340.3673127-1-neelx@suse.com>
 <20260513085340.3673127-5-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085340.3673127-5-neelx@suse.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1618-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: C9D7B6262C0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 13, 2026 at 10:52:38AM +0200, Daniel Vacek wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Previously we were wiping the master key secret when we do
> FS_IOC_REMOVE_ENCRYPTION_KEY, and then using the fact that it was
> cleared as the mechanism from keeping new users from being setup.

This seems to be describing the state prior to commit 15baf55481de, not
the current tip of tree.  We do still wipe on
FS_IOC_REMOVE_ENCRYPTION_KEY, but there's a separate boolean that
maintains the status and everyone looks at that now.

>   * FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED
>   *	Removal of this key has been initiated, but some inodes that were
> - *	unlocked with it are still in-use.  Like ABSENT, ->mk_secret is wiped,
> - *	and the key can no longer be used to unlock inodes.  Unlike ABSENT, the
> - *	key is still in the keyring; ->mk_decrypted_inodes is nonempty; and
> + *	unlocked with it are still in-use.
> + *	For filesystems using per-extent encryption ->mk_secret is still
> + *	being kept as the per-extent keys are derived at writeout time.
> + *	Otherwise, like ABSENT, ->mk_secret is wiped, and the key can
> + *	no longer be used to unlock inodes.  Unlike ABSENT, the key is
> + *	still in the keyring; ->mk_decrypted_inodes is nonempty; and
>   *	->mk_active_refs > 0, being equal to the size of ->mk_decrypted_inodes.

This is saying that a bunch of things don't apply to extent-based
encryption, due to being after the "Otherwise," when in fact they
actually still do.  So the wording here needs improvement.  How about:

    ->mk_secret exists only if the filesystem uses extent-based
    encryption, to support key derivation during file data writeback;
    otherwise it is wiped.  Either way, the key can no longer be used to
    unlock inodes.  Unlike ABSENT, the key is still in the keyring;
    ->mk_decrypted_inodes is nonempty; and ->mk_active_refs
    > 0, being equal to the size of ->mk_decrypted_inodes.

>   *
>   *	This state transitions to ABSENT if ->mk_decrypted_inodes becomes empty,
> diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
> index be8e6e8011f2..796e02a0db25 100644
> --- a/fs/crypto/keyring.c
> +++ b/fs/crypto/keyring.c
> @@ -110,6 +110,14 @@ void fscrypt_put_master_key_activeref(struct super_block *sb,
>  	WARN_ON_ONCE(mk->mk_present);
>  	WARN_ON_ONCE(!list_empty(&mk->mk_decrypted_inodes));
>  
> +	/* We can't wipe the master key secret until the last activeref is
> +	 * dropped on the master key with per-extent encryption since the key
> +	 * derivation continues to happen as long as there are active refs.
> +	 * Wipe it here now that we're done using it.
> +	 */
> +	if (sb->s_cop->has_per_extent_encryption)
> +		wipe_master_key_secret(&mk->mk_secret);

wipe_master_key_secret() is idempotent, so we might as well just do it
unconditionally here.

- Eric

