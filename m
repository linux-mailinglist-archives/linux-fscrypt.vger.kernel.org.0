Return-Path: <linux-fscrypt+bounces-335-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C17B292ACA7
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Jul 2024 01:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7788B1F2204D
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 23:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC1B715252E;
	Mon,  8 Jul 2024 23:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="se1Fj11r"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A379914F9D9;
	Mon,  8 Jul 2024 23:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720482553; cv=none; b=KojONpPzWzHPvGDz5LUH/c36TaIErj5Q8ko5u1D+/YgACFxtwwWKinUHMyJmN+E7TQjdQQW1p9IO9cHGaDdY/v0/lW3JNhunSublKJ7v4podPpROPhkw26LcCgNHIdhpDX37chyp8wO34S2aG8IapKtoEvq3EgUdQwsSqctdSw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720482553; c=relaxed/simple;
	bh=ZdDfcMsQPc2BEgw8D2wuQ0A8t+bcrirSmWoZGGiWYrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I83DSlB/wzHBgPtQbOFpK5dyio1Pl8SuUge9JQXdd0/5D+ibb/roS38dXOnXenpQ3OGVxcBG72QrVVCj0WuOqOadNleAIX0Rct0gIHqm4/bcBnlE1BUYFqIobL7XvD1ww1oRvKxFYhVZF59ENBCjP6BU/Sw9W07VKSX25thGWlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=se1Fj11r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4335C116B1;
	Mon,  8 Jul 2024 23:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720482553;
	bh=ZdDfcMsQPc2BEgw8D2wuQ0A8t+bcrirSmWoZGGiWYrU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=se1Fj11rVRIdCuB+gFzBTILUucn5NAxWdBzGnfETrdipSuxgQTEcDwH7MvPQnixBP
	 zfJQ/Gx3gdNJJefZgQyhYSiDHlre+R38yZVzjo0WmzUCZQ8BE/huqZtebCO/gtXcGa
	 Lua1xXbM/ZCOvdtB0Bd3H/KlkWvwjN3kTlkD7uLHjwXK6i53rl3OEqfdoSV05XI+KL
	 rTJBtt8SAzDFMyOhjw+EQOiZZsZgWV5LiIFbPgOFtS0tfn378/CCksDqSeEztJjnnR
	 VP3LTi8t4HTJxGQmqDy47rm2LX9MxdNhqOolL0hr+4bCyjRU7rsEqX2V64DfFttpNt
	 t+eaSFrGprlmA==
Date: Mon, 8 Jul 2024 16:49:11 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	=?iso-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>,
	William McVicker <willmcvicker@google.com>
Subject: Re: [PATCH v2 6/6] scsi: ufs: exynos: Add support for Flash Memory
 Protector (FMP)
Message-ID: <20240708234911.GA1730@sol.localdomain>
References: <20240702072510.248272-1-ebiggers@kernel.org>
 <20240702072510.248272-7-ebiggers@kernel.org>
 <CADrjBPoWVq-eu4Wa6_hrkk067tnZGC82UCJDyjSRGoG254w6vg@mail.gmail.com>
 <20240708202630.GA47857@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240708202630.GA47857@sol.localdomain>

On Mon, Jul 08, 2024 at 01:26:30PM -0700, Eric Biggers wrote:
> Hi Peter,
> 
> On Thu, Jul 04, 2024 at 02:26:05PM +0100, Peter Griffin wrote:
> > Do you know how these FMP registers (FMPSECURITY0 etc) relate to the
> > UFSPR* registers set in the existing exynos_ufs_config_smu()? The
> > UFS_LINK spec talks about UFSPR(FMP), so I had assumed the FMP support
> > would be writing these same registers but via SMC call.
> > 
> > I think by the looks of things
> > 
> > #define UFSPRSECURITY 0x010
> > #define UFSPSBEGIN0 0x200
> > #define UFSPSEND0 0x204
> > #define UFSPSLUN0 0x208
> > #define UFSPSCTRL0 0x20C
> > 
> > relates to the following registers in gs101 spec
> > 
> > FMPSECURITY0 0x0010
> > FMPSBEGIN0 0x2000
> > FMPSEND0 0x2004
> > FMPSLUN0 0x2008
> > FMPSCTRL0 0x200C
> > 
> > And the SMC calls your calling set those same registers as
> > exynos_ufs_config_smu() function. Although it is hard to be certain as
> > I don't have access to the firmware code. Certainly the comment below
> > about FMPSECURITY0 implies that :)
> > 
> > With that in mind I think exynos_ufs_fmp_init() function in this patch
> > needs to be better integrated with the EXYNOS_UFS_OPT_UFSPR_SECURE
> > flag and the existing exynos_ufs_config_smu() function that is
> > currently just disabling decryption on platforms where it can access
> > the UFSPR(FMP) regs via mmio.
> 
> I think that is all correct.  For some reason, on gs101 the FMP registers are
> not accessible by the "normal world", and SMC calls need to be used instead.
> The sequences of SMC calls originated from Samsung's Linux driver code for FMP.
> So I know they are the magic incantations that are needed, but I don't have
> access to the source code or documentation for them.  It does seem clear that
> one of the things they must do is write the needed values to the FMP registers.
> 
> I'd hope that these same SMC calls also work on Exynos-based SoCs that do make
> the FMP registers accessible to the "normal world", and therefore they can just
> be used on all Exynos-based SoCs and ufs-exynos won't need two different code
> paths.  But I don't have a way to confirm this myself.  Until someone is able to
> confirm this, I think we need to make the FMP support depend on
> EXYNOS_UFS_OPT_UFSPR_SECURE so that it doesn't conflict with
> exynos_ufs_config_smu() which runs when !EXYNOS_UFS_OPT_UFSPR_SECURE.
> 

These same SMC calls can be found in the downstream source for other
Exynos-based SoCs.  I suspect that exynos_ufs_config_smu() should be removed,
and exynos_ufs_fmp_init() should run regardless of EXYNOS_UFS_OPT_UFSPR_SECURE.
It still would need to be tested, though, which I'm not able to do.  (And
especially as a cryptography feature, this *must* be tested...)  So for now I'm
going to make the FMP support conditional on EXYNOS_UFS_OPT_UFSPR_SECURE.

- Eric

