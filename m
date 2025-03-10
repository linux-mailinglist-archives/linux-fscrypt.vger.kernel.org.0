Return-Path: <linux-fscrypt+bounces-629-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA22A59B74
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Mar 2025 17:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D1BA1888720
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Mar 2025 16:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FFA5231A2B;
	Mon, 10 Mar 2025 16:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gut4zvA9"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A40231A22;
	Mon, 10 Mar 2025 16:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741624920; cv=none; b=n2XqwbP1i6OH/iFGcaRff0v7Ca+AghmspeyJXSnxsoHbR1P97dRK4vv7XeWA31+oTw2rdZbOK2uOoGl89D2oQHK5BwSqcF4M35vbtgG9pOpYsPnF6ISGy8K/o3p/CG8D2oN757TKTW4QD09i7rVUpxIE0ChJW6Y0nfvRDFEUJMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741624920; c=relaxed/simple;
	bh=AonGS/l9pN/Ns1XP5OZmwRVEfJkZ3sbj6I9acRs39sE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q50/nSn2zxdZLkVu1CoWEy35xpfB1OCNPu3CWJKYR82h6LDy+01CweaAIOdP3O2uOxiwBkadXNAftggazfxsbP+7hXJOPKS0yKDJLmJIxfH6HqSdDaEtMdQ3HcXSDDbxZYTXP+7tNWrC3SW0yiX099EUAnYK4xpHAM+bzRSZOBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gut4zvA9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A759CC4CEE5;
	Mon, 10 Mar 2025 16:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741624920;
	bh=AonGS/l9pN/Ns1XP5OZmwRVEfJkZ3sbj6I9acRs39sE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gut4zvA9kSCVVqb5oEIk8UB9IOhmL4oBHTFbGoJztp6Zqvb/DrD/Va8bPfj94dGwC
	 ikHc7Eh8+LX8looTrA7reyhmYHHbJdEuhPR1H9QoyG28tfYDeyKy37medElaSpwPRu
	 YJCkVJ/egYaHHU6+XQVehmImsNMchRh2RdUs8lJcKWr+EOrPc+udO/qXtYSaCARlHn
	 14RAfMCjToz2fgO4f4I0b9o6xZ10Lyr0J2QSIpM6FM5o47pY2d0lkPV0qCEZsyycZP
	 zJnC8XZ945L10nmbU+DpkCVRj1lPJzcj8oD0OPq8TiiuluI4Ddco+B4GQjzmZSd1Fp
	 OXhceAqh5whUQ==
Date: Mon, 10 Mar 2025 09:41:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bjorn Andersson <andersson@kernel.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>, linux-fscrypt@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH v12 0/4] Driver and fscrypt support for HW-wrapped inline
 encryption keys
Message-ID: <20250310164158.GA1701@sol.localdomain>
References: <20250210202336.349924-1-ebiggers@kernel.org>
 <CAMRc=Md0fsB7Yfx9Au1pXi+7Y_5DQf2z430c9R+tyS9e60-y5w@mail.gmail.com>
 <20250302222336.GD2079@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302222336.GD2079@quark.localdomain>

On Sun, Mar 02, 2025 at 02:23:36PM -0800, Eric Biggers wrote:
> > > TBD whether these will land in 6.15 too, or wait until 6.16 when the
> > > block patches that patches 2-4 depend on will have landed.
> > >
> > 
> > Could Jens provide an immutable branch with these patches? I don't
> > think there's a reason to delay it for another 3 months TBH.
> 
> They don't seem to be on an immutable branch, so I'll just wait until the next
> cycle, rather than trying to do something weird where I rebase the fscrypt tree
> onto the block tree and also include driver patches.  TBH, I've already been
> waiting 5 years to land this, so an extra 9 weeks is not a big deal :-)
> 
> The first patch "soc: qcom: ice: make qcom_ice_program_key() take struct
> blk_crypto_key" does not depend on the block ones though, and it could land in
> 6.15.  Bjorn, would you like to take that patch through your tree to get it out
> of the way?

Bjorn, could you apply patch 1 to your tree?  Thanks!

- Eric

