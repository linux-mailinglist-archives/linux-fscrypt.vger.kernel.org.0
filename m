Return-Path: <linux-fscrypt+bounces-657-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E398BAA9DE0
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 May 2025 23:14:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2778A3BE599
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 May 2025 21:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C085270563;
	Mon,  5 May 2025 21:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lshh8F54"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2473B1C861D;
	Mon,  5 May 2025 21:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746479671; cv=none; b=i5BCBNY0b7vzahwFrru/Gr0soKIzv2uNjUrf1RVV4z5z/TsbYObAmHdVaLnw67FZZ5mdQLlHKo7Jly2HIrbafKMg8KWF39xzOvD56iqr7pH3tVbeHbbMFItk0Y4O2Xn2maZuGizd/hNuE1RRw4BMPoxIrgGyoGUKR3t0A9k96is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746479671; c=relaxed/simple;
	bh=qS4T1MGud+iM/nNdmWWGGoUtuRQIzjgo2jsCErrjUQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mjJeovVGkCbhIj2Ms1GRRHiG0CTELdT8xTRiqMfZ9XBAOaZk5CsD0Q/sOvsQ+WmLhcDaWfv63TgXgZg51L+llupFP4a72s0Jtw4VDg9MzUiP+zTnjMHI77OBQ3K7XfpMSs+atRbq73lxI2y1kVgu7m5EqlyKnUuZZsS7cP1AMlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lshh8F54; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FF8C4CEE4;
	Mon,  5 May 2025 21:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746479670;
	bh=qS4T1MGud+iM/nNdmWWGGoUtuRQIzjgo2jsCErrjUQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lshh8F54s6ZKNLWxDHn+oaPmXhS1kqVBQb2eENyq7dHadOwbHxI6ximMpr1rOSQHf
	 oft01/qPH+oQV0lWFp1Epm9J0fg4KgGzbJU3hBu2OZSJ6oHw2LYh7CiBkVwhsBXlwZ
	 IEiDlGxr4AMLEdMnyD6h5EakXSDFVmkhZ3EElw4beoaf09uvkaeKj736fih2vrJUPk
	 qDoX0+O4fYHJNld1R3YFBLYn279pZgQEIRrhXv6oZco739iy4p/VPCrCJYXpHqKrdA
	 SzQgMzfGzBUSBaZJwt1rzXjG1UbZzsQZxB2kHTTQ4fHQ2pe86yW4VLp6OY/ETzXoIX
	 emev4TC/rp2jg==
Date: Mon, 5 May 2025 21:14:28 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: Re: [PATCH v2 2/2] dm: pass through operations on wrapped inline
 crypto keys
Message-ID: <20250505211428.GA10047@google.com>
References: <20250501212320.8281-1-ebiggers@kernel.org>
 <20250501212320.8281-3-ebiggers@kernel.org>
 <af9771ce-5e88-02d1-3595-fd18a6f2eb28@redhat.com>
 <20250505170336.GA197153@sol>
 <5ca7e728-96ed-4419-6689-f36081b7e2da@redhat.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ca7e728-96ed-4419-6689-f36081b7e2da@redhat.com>

On Mon, May 05, 2025 at 11:01:38PM +0200, Mikulas Patocka wrote:
> 
> 
> On Mon, 5 May 2025, Eric Biggers wrote:
> 
> > On Mon, May 05, 2025 at 06:15:01PM +0200, Mikulas Patocka wrote:
> > > 
> > > I have a dumb question - if it doesn't matter through which block device 
> > > do you set up the keys, why do you set them up through a block device at 
> > > all?
> > > 
> > > What about making functions that set up the keys without taking block 
> > > device as an argument, calling these functions directly and bypassing 
> > > device mapper entirely?
> > 
> > Userspace needs to direct the key setup operations, so we'd need a UAPI for it
> > to do so.  We could add a custom syscall, or some hacked-up extension of
> > add_key(), and add a custom registration mechanism to allow a single
> > implementation of wrapped keys (e.g. from ufs-qcom) to register itself as the
> 
> What happens if there are multiple ufs-qcom controllers? Is it 
> unsupported?

They would accept the same wrapped keys, I think.  But that is theoretical,
since multiple ufs-qcom hosts are currently unsupported for other reasons.

> > system's wrapped key provider which the syscall would then use.
> > 
> > But it seemed cleaner to instead use block device ioctls and take advantage of
> > the existing blk-crypto-profile.  That already handles registering and
> > unregistering the implementation, and it also already handles things like
> > locking, and resuming the UFS controller if it's in suspend.
> > 
> > It also keeps the door open to supporting the case where different
> > wrapped-key-capable block devices don't necessarily accept the same keys, even
> > if that isn't the case currently.
> > 
> > - Eric
> 
> I think that using ioctl on block device is ok.
> 
> But I don't see why do you need to perform the ioctl on device mapper 
> device and let device mapper select a random underlying device where the 
> ioctl is forwarded? You can as well select a random physical disk in your 
> userspace application and call the ioctl on it.

We have to forward derive_sw_secret anyway, since that's invoked by the
filesystem, not by the ioctls.

The other operations are for the ioctls, but I don't see a reason to make things
harder for userspace by forcing userspace to implement logic like:

    if (is_dm(blkdev))
        blkdev = underlying_device(blkdev)
    ioctl(blkdev)

The device-mapper block device has a blk-crypto profile that declares wrapped
key support.  We should just make the ioctls work on that block device, so that
upper layers don't need to care whether it's device-mapper or native.

- Eric

