Return-Path: <linux-fscrypt+bounces-583-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0627CA09B9A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jan 2025 20:10:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3AA9188E817
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jan 2025 19:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C23524B244;
	Fri, 10 Jan 2025 19:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9cnfvGh"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4BD24B221;
	Fri, 10 Jan 2025 19:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736536222; cv=none; b=sTJZUvSJhjfOuRFwHINFTZCH3sqC3plkYjBmJqhOVYhb9wT+1r4DFAUHeHM+io8GZ15qWLs9gDY/A6ca4BrkDjnXK3vpr4GwtSJFteYRY8J9eLBfxMr3bklGVF2kftoRQ2ETxUZDuySlPJNXa73hxkir7b45ePHLX8b4eiG8Zac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736536222; c=relaxed/simple;
	bh=abbuXe0efS2QoH5PhHzMi7xNGC82etU29gnMzoWoI/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZuR84ylJcaluZFOZrC3wspEZ3eObEhYPjhEexu+7iyCFeCXgj+IXGkmpJq9Q2l2m2Kyusoryv8D3JRZS1+bv6lbydUjvxIjgq/J7DGM56QUT8HVV92kQXrgMWAKEI5JdlLE/G5ZTMp7L4Ip4vqngYreVCAOwScm3STV4B7KdNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9cnfvGh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E47C4CED6;
	Fri, 10 Jan 2025 19:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736536221;
	bh=abbuXe0efS2QoH5PhHzMi7xNGC82etU29gnMzoWoI/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j9cnfvGhPribEablygATyI8cVaiAVMmdZ4x67bKDp5+0wzkYaydbp5k+y3SCoi5TO
	 a0QggZ3C+xAbDTdqBQdX/U/CmMfgOdnhPNf96KqTfbXn09Cnrm1Xp4y2D+vJEdTkuX
	 RaCIP5VCKuGDCqXsiDf0G5BTU0vRWp8pmNgjOu1MBMAeWCrmGhvUmFzAfZxXzCUjZX
	 bj2AqhIxiLJp3OE6t9/YlO5/1A5ZvnWj+4c2qJvDqK09/iyJ+5tUghc+KEXYUCHowP
	 JszbfYa/8cu3WAYKVCTzbGl0+PQbsMjtwBKMgISsDXXqMamRAZ0I+eRBL0eBYBoGjM
	 LgSGugnselPBA==
Date: Fri, 10 Jan 2025 19:10:19 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
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
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v10 00/15] Support for hardware-wrapped inline encryption
 keys
Message-ID: <20250110191019.GA24424@google.com>
References: <20241213041958.202565-1-ebiggers@kernel.org>
 <CAMRc=MdeZ_k9z+ZKW1ub0m9ymh3eABUU7ZRPY9TYHM_fc+D+qQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMRc=MdeZ_k9z+ZKW1ub0m9ymh3eABUU7ZRPY9TYHM_fc+D+qQ@mail.gmail.com>

On Fri, Jan 10, 2025 at 09:44:07AM +0100, Bartosz Golaszewski wrote:
> On Fri, Dec 13, 2024 at 5:20 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > This patchset is based on next-20241212 and is also available in git via:
> >
> >     git fetch https://git.kernel.org/pub/scm/fs/fscrypt/linux.git wrapped-keys-v10
> >
> > This patchset adds support for hardware-wrapped inline encryption keys, a
> > security feature supported by some SoCs.  It adds the block and fscrypt
> > framework for the feature as well as support for it with UFS on Qualcomm SoCs.
> >
> > This feature is described in full detail in the included Documentation changes.
> > But to summarize, hardware-wrapped keys are inline encryption keys that are
> > wrapped (encrypted) by a key internal to the hardware so that they can only be
> > unwrapped (decrypted) by the hardware.  Initially keys are wrapped with a
> > permanent hardware key, but during actual use they are re-wrapped with a
> > per-boot ephemeral key for improved security.  The hardware supports importing
> > keys as well as generating keys itself.
> >
> > This differs from the existing support for hardware-wrapped keys in the kernel
> > crypto API (also called "hardware-bound keys" in some places) in the same way
> > that the crypto API differs from blk-crypto: the crypto API is for general
> > crypto operations, whereas blk-crypto is for inline storage encryption.
> >
> > This feature is already being used by Android downstream for several years
> > (https://source.android.com/docs/security/features/encryption/hw-wrapped-keys),
> > but on other platforms userspace support will be provided via fscryptctl and
> > tests via xfstests (I have some old patches for this that need to be updated).
> >
> > Maintainers, please consider merging the following preparatory patches for 6.14:
> >
> >   - UFS / SCSI tree: patches 1-4
> >   - MMC tree: patches 5-7
> >   - Qualcomm / MSM tree: patch 8
> >
> 
> IIUC The following patches will have to wait for the v6.15 cycle?
> 
> [PATCH v10 9/15] soc: qcom: ice: make qcom_ice_program_key() take
> struct blk_crypto_key
> [PATCH v10 10/15] blk-crypto: add basic hardware-wrapped key support
> [PATCH v10 11/15] blk-crypto: show supported key types in sysfs
> [PATCH v10 12/15] blk-crypto: add ioctls to create and prepare
> hardware-wrapped keys
> [PATCH v10 13/15] fscrypt: add support for hardware-wrapped keys
> [PATCH v10 14/15] soc: qcom: ice: add HWKM support to the ICE driver
> [PATCH v10 15/15] ufs: qcom: add support for wrapped keys

Yes, that's correct.

- Eric

