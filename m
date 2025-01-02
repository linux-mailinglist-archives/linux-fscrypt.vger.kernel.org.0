Return-Path: <linux-fscrypt+bounces-576-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 262579FFE99
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jan 2025 19:38:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1327162A68
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jan 2025 18:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941C01B2522;
	Thu,  2 Jan 2025 18:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U5+1bRN4"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CD14315E;
	Thu,  2 Jan 2025 18:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735843101; cv=none; b=k4z8pz03Z0gOyx8FjwP9G/w79Mj7IgVS85f5a+Hq/T3go892CcPHd8CkrN43QAOt+llO11HVCPJyr2W0OGmglvK1/2MAM3972bVRsOwQvTX68akPj3Dp9vdzS4OCDiValENZ9fBydnUIUpR40SryrrVL0rhrC+PfGhFDGPXkC7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735843101; c=relaxed/simple;
	bh=nSBmEv7YrbcW+nsh4X7lXEP5ZHbxAIY85GquQsl40SM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KZ++5w6L6ljHwKyw5LnVm7GHwdx0YPdZ36l+5RBG5J/OT3CkOYFsaZxvCtd4OdNcLkgDXVxtBI7chipLCqaJNvhkUKZzk8E44MMpTVz8yEuEn4ALj1EOnayx0nGPU8djW81pJ3Ulzlu18ltvEwcvfnzaXsJU63LcG8j8dv5TYYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U5+1bRN4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66970C4CED6;
	Thu,  2 Jan 2025 18:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735843098;
	bh=nSBmEv7YrbcW+nsh4X7lXEP5ZHbxAIY85GquQsl40SM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U5+1bRN4nWutfGWtzVLQNdbz974nrdqTj/qm8FeBVioGjPfKZc5QxgpezcPtHDzck
	 lliFu0642K7auEyqV1lxeJzGCU/1iPFZMnxCZ9gqCIAwaEOAqN0+zeBH6tv+65ZyN/
	 18IqQQT2lVll+15WAitljEyBeg7Xs/7PgNRNIy6H2mwzpvXUOMZ2+cS1nsWENxKd6w
	 wyEpEqJ9H0vT6WEF8iIAWKPV69R3J4pK7jUZein/f+l3uvdIN+R+W5IhedJEaaCzBK
	 U/Od7qY1+rYZUtZseZ8G6WTwpv2cnEIHl3n9/T2A52cAPyqveArSfPLliznUM6DrOc
	 ia/cxp03yJlmw==
Date: Thu, 2 Jan 2025 18:38:16 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v10 00/15] Support for hardware-wrapped inline encryption
 keys
Message-ID: <20250102183816.GC49952@google.com>
References: <20241213041958.202565-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213041958.202565-1-ebiggers@kernel.org>

On Thu, Dec 12, 2024 at 08:19:43PM -0800, Eric Biggers wrote:
> Maintainers, please consider merging the following preparatory patches for 6.14:
> 
>   - UFS / SCSI tree: patches 1-4
>   - MMC tree: patches 5-7
>   - Qualcomm / MSM tree: patch 8

Happy new year everyone.

We are 1 of 3 so far, with Ulf having applied patches 5-7.

Martin, can you consider applying patches 1-4?

Bjorn, can you consider applying patch 8?

Additional reviews or acks from anyone on any of the patches in this series
would always be appreciated, of course.

Thank you!

- Eric

