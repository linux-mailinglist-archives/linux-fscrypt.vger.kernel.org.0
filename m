Return-Path: <linux-fscrypt+bounces-599-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E9D7A2F35B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Feb 2025 17:25:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 916131880716
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Feb 2025 16:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767742580ED;
	Mon, 10 Feb 2025 16:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjjBvG1I"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC162580D6;
	Mon, 10 Feb 2025 16:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739204710; cv=none; b=NL40TZb/79xdiFfirYAyXZN6lBEYj4yQg47xhEMPnuQmHf97hcFVyK7hTgaCByVVbnc4vm3dsjbnHDEJXNF90KoSushR4sJh1O5GZl7hDHCk2USanyzD85r+dm2BJKMG4VW4qeotiz+OI8LXgR1y9LRz/KOwWFhXirZw/A7Rv10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739204710; c=relaxed/simple;
	bh=J1vqTI0fG2ICMpAX1Wcx+LsnGdWVzwbfDeSxED93siY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WSOzxl9R5Wif/tj+moegY81lQuxfV6qLvrcv7U3El8vl4DHRhfVE5Tb10c2BkHBy+zrve6fq7z38HXFfzjOYmZnTu+nbAPb5sYyRcEGH1NqEZ0mC9AC6Ch/jtZ9kGQfhq+zXcyKLmp0oj7blcG5tczgOKlFup2f9wVXw3JgSR7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjjBvG1I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324A8C4CED1;
	Mon, 10 Feb 2025 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739204709;
	bh=J1vqTI0fG2ICMpAX1Wcx+LsnGdWVzwbfDeSxED93siY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RjjBvG1IZ2U2km/x14X8PR2pbtonsPBtFV7ehJYwJsZKDU9A0HwGEpFZzNnSDET7/
	 ysAxQQMGFU91ZsaxqoESdH1Tlxm32l4DXpkDCRkiyEUMs4d8gPA6cn6p/VRnIJ8ZEk
	 FuxofcV3pksQpMzY2ypnlz0VkSK5+6Ppf9rotw1nKCNIqPdV4MFIh5yXRKPKIK1WfS
	 45U3KmqBvrsxy4+t8/6vdRcnVYXXh7u4QjoeuFKjtRnGBApLiwqHf8BjFKTU0v6KMa
	 er5GsPMdd3UjQRGNgJ+czYXclEMzAMJr1WP6eRs7vX38CBncHKf2nWNJeb1hqXjPVv
	 xVSpf2HS1Z1qg==
Date: Mon, 10 Feb 2025 08:25:07 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	linux-fscrypt@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: Re: [PATCH v11 0/7] Support for hardware-wrapped inline encryption
 keys
Message-ID: <20250210162507.GB1264@sol.localdomain>
References: <20250204060041.409950-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204060041.409950-1-ebiggers@kernel.org>

Hi Jens,

On Mon, Feb 03, 2025 at 10:00:34PM -0800, Eric Biggers wrote:
> This is targeting 6.15.  As per the suggestion from Jens
> (https://lore.kernel.org/linux-block/c3407d1c-6c5c-42ee-b446-ccbab1643a62@kernel.dk/),
> I'd like patches 1-3 to be queued up into a branch that gets pulled into
> the block tree.  I'll then take patches 4-7 through the fscrypt tree,
> also for 6.15.  If I end up with too many merge conflicts by trying to
> take patches 5-7 (given that this is a cross-subsystem feature), my
> fallback plan will be to wait until 6.16 to land patches 5-7, when they
> will finally be unblocked by the block patches having landed.

Let me know what you think about this plan.

- Eric

