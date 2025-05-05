Return-Path: <linux-fscrypt+bounces-655-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 018E2AA9A09
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 May 2025 19:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 607191894553
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 May 2025 17:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228BF26B95B;
	Mon,  5 May 2025 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvubux5p"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F4826B2B0;
	Mon,  5 May 2025 17:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746464623; cv=none; b=XQtH34oV7gEN5LHh5tL//2eXY91NSXFeLiFBk2sh83m+iudNiXRt17psOKOMNaF3932T2OQSB2XFnWyfCbFAG+y6xLoS4KkCoixrd01OOhaqfYaLSKHf2+nzmz05fP2Ic+0YbA16j88a97lLtAdQgyxC0n/mrA19eAeVxtDkHP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746464623; c=relaxed/simple;
	bh=HrusCc9SBsT/pb7NKHxA3xrw80w8tMv119nD1CjzK+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EP1pD/ZUHeIv4cRsPd+D3SAieVGZNF5LzlYeAQ7Kg2tOdb74U7E2xIpp6x1DxTCCRqL6gIqxIlQkBljIK27n0OE6BYeJRvqB6Syh+VoNs0pmnYQ6gNA281jyEyfTvF4ACtsfz59vYT3DiTWIaOjKt02DnvdoYJ3XmzZ4Gyl+PYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvubux5p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BFDC4CEE4;
	Mon,  5 May 2025 17:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746464620;
	bh=HrusCc9SBsT/pb7NKHxA3xrw80w8tMv119nD1CjzK+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hvubux5pL2EOx+kHP1U90MusMRROW6uMVmzZrOMwGL1OkdOm+EGwA3NRRo/u96oqI
	 lPW4AOB0NjOAv1hMaEV3MVkiW9fjyLqhnRpPClxqdYm3GSL/afBpH4faP7tHqN9+p4
	 Kn6OafJCkdT0njX3PkrTQ+MGgX7NB/XjdoH91FqGxcvHkq9fd3FkxaGhESnpeEyIko
	 NrgqUWZy9dB1bPvhpT/0+HbD4x3kYpsPj130Fid8tq/KZITK7l8nppMDqLeS3hptgV
	 hUl0tZ8TPp2TXKsMr/Ljib2TsW9INPsmX4HTZV5jkrWqozhnAJvrfnxBJjw4mUR0iu
	 VdNZ7So4f39VQ==
Date: Mon, 5 May 2025 10:03:36 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: Re: [PATCH v2 2/2] dm: pass through operations on wrapped inline
 crypto keys
Message-ID: <20250505170336.GA197153@sol>
References: <20250501212320.8281-1-ebiggers@kernel.org>
 <20250501212320.8281-3-ebiggers@kernel.org>
 <af9771ce-5e88-02d1-3595-fd18a6f2eb28@redhat.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af9771ce-5e88-02d1-3595-fd18a6f2eb28@redhat.com>

On Mon, May 05, 2025 at 06:15:01PM +0200, Mikulas Patocka wrote:
> 
> 
> On Thu, 1 May 2025, Eric Biggers wrote:
> 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Make the device-mapper layer pass through the derive_sw_secret,
> > import_key, generate_key, and prepare_key blk-crypto operations when all
> > underlying devices support hardware-wrapped inline crypto keys and are
> > passing through inline crypto support.
> > 
> > Commit ebc4176551cd ("blk-crypto: add basic hardware-wrapped key
> > support") already made BLK_CRYPTO_KEY_TYPE_HW_WRAPPED be passed through
> > in the same way that the other crypto capabilities are.  But the wrapped
> > key support also includes additional operations in blk_crypto_ll_ops,
> > and the dm layer needs to implement those to pass them through.
> > derive_sw_secret is needed by fscrypt, while the other operations are
> > needed for the new blk-crypto ioctls to work on device-mapper devices
> > and not just the raw partitions.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  drivers/md/dm-table.c | 177 ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 177 insertions(+)
> > 
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index a937e1e12482e..0a71bedff81c5 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > +
> > +static int dm_exec_wrappedkey_op(struct blk_crypto_profile *profile,
> > +				 struct dm_wrappedkey_op_args *args)
> > +{
> > +	struct mapped_device *md =
> > +		container_of(profile, struct dm_crypto_profile, profile)->md;
> > +	struct dm_target *ti;
> > +	struct dm_table *t;
> > +	int srcu_idx;
> > +	int i;
> > +
> > +	args->err = -EOPNOTSUPP;
> > +
> > +	t = dm_get_live_table(md, &srcu_idx);
> > +	if (!t)
> > +		goto out;
> > +
> > +	/*
> > +	 * blk-crypto currently has no support for multiple incompatible
> > +	 * implementations of wrapped inline crypto keys on a single system.
> > +	 * It was already checked earlier that support for wrapped keys was
> > +	 * declared on all underlying devices.  Thus, all the underlying devices
> > +	 * should support all wrapped key operations and they should behave
> > +	 * identically, i.e. work with the same keys.  So, just executing the
> > +	 * operation on the first device on which it works suffices for now.
> > +	 */
> > +	for (i = 0; i < t->num_targets; i++) {
> > +		ti = dm_table_get_target(t, i);
> > +		if (!ti->type->iterate_devices)
> > +			continue;
> > +		ti->type->iterate_devices(ti, dm_wrappedkey_op_callback, args);
> > +		if (!args->err)
> > +			break;
> > +	}
> 
> I have a dumb question - if it doesn't matter through which block device 
> do you set up the keys, why do you set them up through a block device at 
> all?
> 
> What about making functions that set up the keys without taking block 
> device as an argument, calling these functions directly and bypassing 
> device mapper entirely?

Userspace needs to direct the key setup operations, so we'd need a UAPI for it
to do so.  We could add a custom syscall, or some hacked-up extension of
add_key(), and add a custom registration mechanism to allow a single
implementation of wrapped keys (e.g. from ufs-qcom) to register itself as the
system's wrapped key provider which the syscall would then use.

But it seemed cleaner to instead use block device ioctls and take advantage of
the existing blk-crypto-profile.  That already handles registering and
unregistering the implementation, and it also already handles things like
locking, and resuming the UFS controller if it's in suspend.

It also keeps the door open to supporting the case where different
wrapped-key-capable block devices don't necessarily accept the same keys, even
if that isn't the case currently.

- Eric

