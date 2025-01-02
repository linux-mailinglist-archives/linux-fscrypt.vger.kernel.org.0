Return-Path: <linux-fscrypt+bounces-578-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B2A9FFEB4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jan 2025 19:44:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A5C11880210
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jan 2025 18:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA07191494;
	Thu,  2 Jan 2025 18:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2tBHY7R"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76DA43173;
	Thu,  2 Jan 2025 18:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735843445; cv=none; b=OjyNJD0NusVwj9pK4rONEmEzWGEHrkKZhpPuTbFFNkfT9SID3sSSYmHYN/hCoBcvli581wqaYhy13RK2MhtQSU1NhSnAdvBcF7XGX+yYwTn7PzLyMqRD7fkLvimBd/67Fh6UBwvuUjALhySx2iArfOMSmfxZivwbZbrp9TDf4cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735843445; c=relaxed/simple;
	bh=bzCCR7I1hYB6mMtP87y2PHNk4bChXkKHtX8anutuhM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i07wsqHSbSdrX0k2to2wRtD9NnBFzW8YkhbMz1vTFu8FRn3z8XZwMnkqHlPUkyLvQI+OR1QfyRyoNPe06u0oLydz8Ao4hCxFB/pBrgTrZ7KwIJgIu+sfw/TlkBfw4kFIVORHLDMThUnC+5HVFlwNNtuWA3XgTvCtpDKHAmWGhoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2tBHY7R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02F1C4CED6;
	Thu,  2 Jan 2025 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735843445;
	bh=bzCCR7I1hYB6mMtP87y2PHNk4bChXkKHtX8anutuhM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q2tBHY7R4JhKArYRaLv4nJ746fLZDog3ea8uPpowXsNZFscEwoRVzKLK/iCbDvG9C
	 tM0LejspIkmTD7RlTNjpXuSa/koKi3hQnQ7M5jSBMF7MpWGW5dts7e+8bjZiUbzYug
	 tLEZTXcTooiysKrUmk8Dv7cyKbvZaobhcgBYamgRDqz7Bu6aaLDNorXGimoOH1mjPK
	 5ZXY6efsx5LLtMvet2z218dtawUgGcTjLTzLFIEDdre+PnDnZpvnBfJHTNTpSFVOTD
	 fCVYTfJH0Mltg3nJrtzgfOQiiMDLJw3eQkRu019mqVucMtj8DdpmVjdkyPs/2HaoDG
	 WBxTJ40ROYCFQ==
Date: Thu, 2 Jan 2025 18:44:03 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v10 00/15] Support for hardware-wrapped inline encryption
 keys
Message-ID: <20250102184403.GD49952@google.com>
References: <20241213041958.202565-1-ebiggers@kernel.org>
 <yq1v7uxf4fd.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1v7uxf4fd.fsf@ca-mkp.ca.oracle.com>

On Thu, Jan 02, 2025 at 01:40:48PM -0500, Martin K. Petersen wrote:
> 
> Eric,
> 
> > This patchset adds support for hardware-wrapped inline encryption
> > keys, a security feature supported by some SoCs. It adds the block and
> > fscrypt framework for the feature as well as support for it with UFS
> > on Qualcomm SoCs.
> 
> Applied patches 1-4 to 6.14/scsi-staging, thanks!
> 
> I had originally queued patch 1 in 6.13/scsi-fixes but moved it to 6.14
> and kept the stable tag to accommodate the rest of the series. Hope
> that's OK given the short runway we have left for this release.

Yes, that's fine.  Thanks.

- Eric

