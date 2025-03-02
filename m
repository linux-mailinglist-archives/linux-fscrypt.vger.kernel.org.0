Return-Path: <linux-fscrypt+bounces-621-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E7BAA4B540
	for <lists+linux-fscrypt@lfdr.de>; Sun,  2 Mar 2025 23:23:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62F087A564E
	for <lists+linux-fscrypt@lfdr.de>; Sun,  2 Mar 2025 22:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C4D01EEA34;
	Sun,  2 Mar 2025 22:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="opq66txW"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213FE1C5D50;
	Sun,  2 Mar 2025 22:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740954225; cv=none; b=AB4RjSuSXcpMmfno2KIujMyzXjBNdEiISqr5sVwNuyB6Tm3ObnjQE1itqNQmWoGltEv2AJbXSApBeBSu934BIR+wp3yMoPX3zm9ZV/ZmE8KnNqkZIX8piCoeB30m/Z6vXlsChSlvtJz9Gec+ALOaa1zIS1/x3dc4ckPhnAeiJgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740954225; c=relaxed/simple;
	bh=nLV+62Qa713WIu46HAPLlFz0UlZWvoKKx2UAgpOocIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGsRGc7EDQTto5g9LY1JaEYYqmmo895+fLrBuILudLnzD680X2zh29LUVFnP/la6WVKbbWZPCI0ZyrugYSXztsTCgi/pmf/h7hGZQyeRvtbiEoSlnoQ82kg7QsvYr50F+nZwdGQcMcS9jK6lBjMTXyxtwg4st8tR7plURkV4n0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=opq66txW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A623C4CED6;
	Sun,  2 Mar 2025 22:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740954224;
	bh=nLV+62Qa713WIu46HAPLlFz0UlZWvoKKx2UAgpOocIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=opq66txWaieBNphh77G4K/3QDIyPz5IYBhi8JsbxISX2zX0H8iOSu3crjwnMb0B27
	 9a/USK+8NUXXnoV/sCf6UC1FCBuvqF3mIlc0j+CA3nHa1mwMpwXl1FzluTotcnxugx
	 e/meZQGd6sJ4S7GdR4vLeBh1Hx5bo5NM0OnzZU8TCASpTvakVoxbdyDqJkPI4eE4kz
	 SZBVDP9lICT47poXWmkH+JoqEiEU2tND1jYPEhEWDNYzLT9jHuDQOWkOK0xhCLVxas
	 YWPE/a+SgSa/bpdb6GbXNKg3llv4p74PJ1NzDnZ4zPr74mScLcZh8IwSPvUrVHZe0t
	 L3/RXhdgtFIdA==
Date: Sun, 2 Mar 2025 14:23:36 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH v12 0/4] Driver and fscrypt support for HW-wrapped inline
 encryption keys
Message-ID: <20250302222336.GD2079@quark.localdomain>
References: <20250210202336.349924-1-ebiggers@kernel.org>
 <CAMRc=Md0fsB7Yfx9Au1pXi+7Y_5DQf2z430c9R+tyS9e60-y5w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMRc=Md0fsB7Yfx9Au1pXi+7Y_5DQf2z430c9R+tyS9e60-y5w@mail.gmail.com>

On Tue, Feb 11, 2025 at 09:12:11AM +0100, Bartosz Golaszewski wrote:
> On Mon, Feb 10, 2025 at 9:25 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > This patchset is based on linux-block/for-next and is also available at:
> >
> >     git fetch https://git.kernel.org/pub/scm/fs/fscrypt/linux.git wrapped-keys-v12
> >
> > Now that the block layer support for hardware-wrapped inline encryption
> > keys has been applied for 6.15
> > (https://lore.kernel.org/r/173920649542.40307.8847368467858129326.b4-ty@kernel.dk),
> > this series refreshes the remaining patches.  They add the support for
> > hardware-wrapped inline encryption keys to the Qualcomm ICE and UFS
> > drivers and to fscrypt.  All tested on SM8650 with xfstests.
> >
> > TBD whether these will land in 6.15 too, or wait until 6.16 when the
> > block patches that patches 2-4 depend on will have landed.
> >
> 
> Could Jens provide an immutable branch with these patches? I don't
> think there's a reason to delay it for another 3 months TBH.

They don't seem to be on an immutable branch, so I'll just wait until the next
cycle, rather than trying to do something weird where I rebase the fscrypt tree
onto the block tree and also include driver patches.  TBH, I've already been
waiting 5 years to land this, so an extra 9 weeks is not a big deal :-)

The first patch "soc: qcom: ice: make qcom_ice_program_key() take struct
blk_crypto_key" does not depend on the block ones though, and it could land in
6.15.  Bjorn, would you like to take that patch through your tree to get it out
of the way?

- Eric

