Return-Path: <linux-fscrypt+bounces-509-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ED429A72F3
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Oct 2024 21:10:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FE1F28399D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Oct 2024 19:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 917F61FBC8C;
	Mon, 21 Oct 2024 19:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhS8MIpP"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461F01FB3F6;
	Mon, 21 Oct 2024 19:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729537811; cv=none; b=XCZxHvge8gzyGL74wUvodmHGQfhc2iMKRM07IuqJg4LKpZBRiRm+oT0RfDpFt2RjvPq/CgybFcU1Oblz8IRC2F403VOCjjGGnA/lYGXHT0+Te/dd7J6KiO/nN7PaT6u5b13FaAkgqFmf6rqQ69ZUlCnZ6upmWTiLDyY1U1ePjrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729537811; c=relaxed/simple;
	bh=LYfZM6Q6uUneW9KRYJEfi2BKTV//PDb/wWBvvJxwfR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XalskxB4sUZR84qRhzQ9+EHfvIq3+uHP5jn2v0XoUV52GeLpCoDQi6uJEEAci64b8Rf0E+m6EB5/udhouqpmRzqMDGqMawcokaowwkZZp2eLu7qMIoZQLIcoR2rZOYsZ2CYgO6Jq0KfkBev0SGdrpQlDJdMvuH5Zp0/qYzjgEgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhS8MIpP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F563C4CEE5;
	Mon, 21 Oct 2024 19:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729537810;
	bh=LYfZM6Q6uUneW9KRYJEfi2BKTV//PDb/wWBvvJxwfR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fhS8MIpPoWxTg9VRlPO9/Q30BPSxXPRqalwXfqAi/ZezydoSfQSqJz9IdPNGv08sn
	 BX2WZirNj0hQXfKA8AAb64kCR8J3dlJ3/VQN7x/KDyiF3vBRaHAitmtksGjTRx3Gmh
	 HxwZnTmVBWmOP4JW4TYRMztJgo8rsRGWD4T4P2cUsb3VsB8pHWQ1loS3BNwaJvgnVn
	 OwaXjtFFQjM6gT8tKQqbte4wxL1995C2rWoRXAjx4886cGz6IkulPql2Hz5cgcgD09
	 4pAZDg+6PHfU+0VgddrHP5LEVQRt0fnzCrTwrz1DbsA+TzNBMRNb6NL2XSCuzbpxZD
	 5CmcqjjNnusfA==
Date: Mon, 21 Oct 2024 19:10:08 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>,
	Milan Broz <gmazyland@gmail.com>,
	Adrian Vovk <adrianvovk@gmail.com>
Subject: Re: [RFC PATCH 0/4] dm-default-key: target for filesystem metadata
 encryption
Message-ID: <20241021191008.GB1395714@google.com>
References: <20241018184339.66601-1-ebiggers@kernel.org>
 <b56689c6-c0cd-c44e-16fb-8a73c460aa87@redhat.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b56689c6-c0cd-c44e-16fb-8a73c460aa87@redhat.com>

On Mon, Oct 21, 2024 at 01:52:58PM +0200, Mikulas Patocka wrote:
> On Fri, 18 Oct 2024, Eric Biggers wrote:
> 
> > This series adds "metadata encryption" support to ext4 and f2fs via a
> > new device-mapper target dm-default-key.  dm-default-key encrypts all
> > data on a block device that isn't already encrypted by the filesystem.
> > 
> > Except for the passthrough support, dm-default-key is basically the same
> > as the proposed dm-inlinecrypt which omits that feature
> > (https://lore.kernel.org/dm-devel/20241016232748.134211-1-ebiggers@kernel.org/).
> > 
> > I am sending this out for reference, as dm-default-key (which Android
> > has been using for a while) hasn't previously been sent to the lists in
> > full, and there has been interest in it.  However, my current impression
> > is that this feature will need to be redesigned as a filesystem native
> > feature in order to make it upstream.  If that is indeed the case, then
> > IMO it would make sense to merge dm-inlinecrypt in the mean time instead
> > (or add its functionality to dm-crypt) so that anyone who just wants
> > "dm-crypt + inline encryption hardware" gets a solution for that.
> 
> I we merge dm-inlinecrypt, we can't remove it later because users will 
> depend on it. I think it is not sensible to have two targets 
> (dm-inlinecrypt and dm-default-key) that do almost the same thing.

The code would not need to be duplicated, though.  E.g. dm-default-key
functionality could be added as an enable_passthrough option to dm-inlinecrypt.
Or the same .c file could register both targets sharing most of the same code.

> I've got another idea - what about a new target "dm-metadata-switch" that 
> will take two block devices as arguments and it will pass metadata bios to 
> the first device and data bios to the second device - so that the logic 
> to decide where the bio will go would be decoupled from the encryption. 
> Then, you can put dm-crypt or dm-inlinecrypt underneath 
> "dm-metadata-switch".
> 
> ----------------------
> |     filesystem     |
> ----------------------
>           |
>           V
> ----------------------
> | dm-metadata-switch |
> ----------------------
>       |           |
>       V           |
> ------------      |
> | dm-crypt |      |
> ------------      |
>       |           |
>       V           V
> -------------------------
> | physical block device |
> -------------------------

Would this have any use case other than what dm-default-key does?

Keep in mind that dm-metadata-switch would have to pass through all sector
addresses unchanged.  So if you wanted to reuse this to actually put your
filesystem metadata on one disk and data on another, this wouldn't be very
effective at that, as both data and metadata would take up the full space.

- Eric

