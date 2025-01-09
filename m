Return-Path: <linux-fscrypt+bounces-581-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F740A07FC6
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jan 2025 19:27:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B58B1888081
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jan 2025 18:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A1C199949;
	Thu,  9 Jan 2025 18:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IKsnRn9t"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586FA747F;
	Thu,  9 Jan 2025 18:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736447255; cv=none; b=ZHbfNG4FV8aHggQqM/dYR+cjx1VT5n1+mSMmyyb+bREEuPcfqA5zI8XNhiWmN00ncPCj3fcacSBVJOKsq3UCwGZv7cJ0Wh2+m1SPhofBawSndXwOPIx2mFzSrr1YCdfRK6FFwr9KMHy0xPmOFU/LGZuTNFIV4CJCqiFbuV+lTtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736447255; c=relaxed/simple;
	bh=Fs8V4twkvk7tBlRqTJ3la6qhRiYYNbCMyra3K2Ht4fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U18bSn3Tox4H3xGrkr1SHO4T47XwGC1zoUf7L2+pWTO6fq7+y4PYsB7l25NKR+xLxGn8vfmOM8R1fUZLkhiCcYQQyHxMZbXmAuEK4JLdL4My59w4isToZFLYIJej3Y6rXEOA+gdjIQI1Y5a6h/SNXu8O9L8GegDwWMTFB5fROVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IKsnRn9t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32312C4CED2;
	Thu,  9 Jan 2025 18:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736447254;
	bh=Fs8V4twkvk7tBlRqTJ3la6qhRiYYNbCMyra3K2Ht4fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKsnRn9tgf6bkHGuyCYIhEtGjOs3/JOEQ3xCFVM1fXm2hbf3MZqFxPNTP8m4kGsG7
	 XDcYq9nDfUtKOL3VGzLOkqDzmlHA4OoJzV5dkVkKOFbQWSFZYeE8JVKIs+R9kkE3wK
	 fZU58ILbdCY+lIxowE6myw1RGBLRMLGMTMOCsOkvBL+ea9pUwT0SkRuCx01d6ZhjGe
	 GxlWHW/acd33Oy9n3Z8JNrlJGNUVUrV17bZ/ZuuiqtoVU9gR66wCbpemQBELfl4if8
	 F0ocnGq7ho2LdG++gMPHV5OYYuRGslDQn+m5h6pceBc8/ntrcG04ZoTuTpkD7UgIi1
	 j84aHqfEfEX5w==
From: Bjorn Andersson <andersson@kernel.org>
To: linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	Eric Biggers <ebiggers@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: (subset) [PATCH v10 00/15] Support for hardware-wrapped inline encryption keys
Date: Thu,  9 Jan 2025 12:27:30 -0600
Message-ID: <173644724820.201886.13724110526590928756.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241213041958.202565-1-ebiggers@kernel.org>
References: <20241213041958.202565-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 12 Dec 2024 20:19:43 -0800, Eric Biggers wrote:
> This patchset is based on next-20241212 and is also available in git via:
> 
>     git fetch https://git.kernel.org/pub/scm/fs/fscrypt/linux.git wrapped-keys-v10
> 
> This patchset adds support for hardware-wrapped inline encryption keys, a
> security feature supported by some SoCs.  It adds the block and fscrypt
> framework for the feature as well as support for it with UFS on Qualcomm SoCs.
> 
> [...]

Applied, thanks!

[08/15] firmware: qcom: scm: add calls for wrapped key support
        commit: 1d45a1cd9f3ae849db868e07e5fee5e5b37eff55

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>

