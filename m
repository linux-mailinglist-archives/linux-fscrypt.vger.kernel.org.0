Return-Path: <linux-fscrypt+bounces-353-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 190DA92DBE1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Jul 2024 00:28:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CFE81C235C6
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 22:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA6F146D7D;
	Wed, 10 Jul 2024 22:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhgIZlj+"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3147A219F9;
	Wed, 10 Jul 2024 22:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720650476; cv=none; b=OsBWt+vYHce9bYQWnzGyBnvRsa/i/C++/Vz7M83LCJlc92byYZjzBCRESfbOJ0SU0jQ8vJSaXlEE4HBKx9/RqqT8Md6Ywtty2yrmsjmlxLuGOCKpdwsNn2StwqZgw8fadR7chOKYwEtgPdQgQd3eINtOO7azUlx/3K5cq6WBu3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720650476; c=relaxed/simple;
	bh=sDjrlm87jTQ5dHlmWNVG/Mqu/ru5Bck/do57WLsHjMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DjqrksQd+75rxtbypRaa3z3+dji476XZPJLwnMOzZNFGhC37VdwCfy3Gg+6zU5GTRYSAE0sri7Bp+yAfJ6m9OV3iYR38+l78NgHCjXnEOZclfdk9ZGtl5ea20ZreVTpDfT98w1XZgKkhu9kxMI7mey7dAWe2+VZXVJLz/+UNWaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhgIZlj+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87466C32781;
	Wed, 10 Jul 2024 22:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720650475;
	bh=sDjrlm87jTQ5dHlmWNVG/Mqu/ru5Bck/do57WLsHjMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VhgIZlj+fJixHRwMyCaZtoc8pVnNdnaV0xOZESQzYGSqbDKkNMbzTD3WBcuSLg24E
	 dsM0eIZa2UYVk9/ko7dp5TcU0EzK77rKToYtRjGquN4N81HVCF/fkA2Aq77Yu1sJrQ
	 rtodP3t3IiLKkEk8OUP9dM7vvO0LkJRiUdgCajXnvE7ti+mLGu0IPr1y4zoMMQJF6m
	 AjivBMOemlk5KtmeHSweMc5eQ36GxvlRencOFiPPpdx5wAxaYrrvP3hdP+Wrdd3E8e
	 2lkMvm37gbQVjH2jnge57o+DKAFjKUl/EPNgH9iJpJ2dfggX+bYNKARpj3h76jvIzv
	 3WCoMRZ1q7yNg==
Date: Wed, 10 Jul 2024 22:27:54 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: 'Peter Griffin' <peter.griffin@linaro.org>, linux-scsi@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	'Avri Altman' <avri.altman@wdc.com>,
	'Bart Van Assche' <bvanassche@acm.org>,
	"'Martin K . Petersen'" <martin.petersen@oracle.com>,
	=?iso-8859-1?Q?'Andr=E9?= Draszik' <andre.draszik@linaro.org>,
	'William McVicker' <willmcvicker@google.com>
Subject: Re: [PATCH v2 6/6] scsi: ufs: exynos: Add support for Flash Memory
 Protector (FMP)
Message-ID: <20240710222754.GA1120171@google.com>
References: <20240702072510.248272-1-ebiggers@kernel.org>
 <20240702072510.248272-7-ebiggers@kernel.org>
 <CADrjBPoWVq-eu4Wa6_hrkk067tnZGC82UCJDyjSRGoG254w6vg@mail.gmail.com>
 <20240708202630.GA47857@sol.localdomain>
 <CGME20240708234916epcas5p1c94255e4c8c77e2929d62144e2277fc8@epcas5p1.samsung.com>
 <20240708234911.GA1730@sol.localdomain>
 <017e01dad28d$68911050$39b330f0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <017e01dad28d$68911050$39b330f0$@samsung.com>

On Wed, Jul 10, 2024 at 11:22:52AM +0530, Alim Akhtar wrote:
> Hello Eric,
> 
> > -----Original Message-----
> > From: Eric Biggers <ebiggers@kernel.org>
> > Sent: Tuesday, July 9, 2024 5:19 AM
> > To: Peter Griffin <peter.griffin@linaro.org>
> > Cc: linux-scsi@vger.kernel.org; linux-samsung-soc@vger.kernel.org; linux-
> > fscrypt@vger.kernel.org; Alim Akhtar <alim.akhtar@samsung.com>; Avri
> > Altman <avri.altman@wdc.com>; Bart Van Assche <bvanassche@acm.org>;
> > Martin K . Petersen <martin.petersen@oracle.com>; André Draszik
> > <andre.draszik@linaro.org>; William McVicker <willmcvicker@google.com>
> > Subject: Re: [PATCH v2 6/6] scsi: ufs: exynos: Add support for Flash
> Memory
> > Protector (FMP)
> > 
> > On Mon, Jul 08, 2024 at 01:26:30PM -0700, Eric Biggers wrote:
> > > Hi Peter,
> > >
> > > On Thu, Jul 04, 2024 at 02:26:05PM +0100, Peter Griffin wrote:
> > > > Do you know how these FMP registers (FMPSECURITY0 etc) relate to the
> > > > UFSPR* registers set in the existing exynos_ufs_config_smu()? The
> > > > UFS_LINK spec talks about UFSPR(FMP), so I had assumed the FMP
> > > > support would be writing these same registers but via SMC call.
> > > >
> > > > I think by the looks of things
> > > >
> > > > #define UFSPRSECURITY 0x010
> > > > #define UFSPSBEGIN0 0x200
> > > > #define UFSPSEND0 0x204
> > > > #define UFSPSLUN0 0x208
> > > > #define UFSPSCTRL0 0x20C
> > > >
> > > > relates to the following registers in gs101 spec
> > > >
> > > > FMPSECURITY0 0x0010
> > > > FMPSBEGIN0 0x2000
> > > > FMPSEND0 0x2004
> > > > FMPSLUN0 0x2008
> > > > FMPSCTRL0 0x200C
> > > >
> > > > And the SMC calls your calling set those same registers as
> > > > exynos_ufs_config_smu() function. Although it is hard to be certain
> > > > as I don't have access to the firmware code. Certainly the comment
> > > > below about FMPSECURITY0 implies that :)
> > > >
> > > > With that in mind I think exynos_ufs_fmp_init() function in this
> > > > patch needs to be better integrated with the
> > > > EXYNOS_UFS_OPT_UFSPR_SECURE flag and the existing
> > > > exynos_ufs_config_smu() function that is currently just disabling
> > > > decryption on platforms where it can access the UFSPR(FMP) regs via
> > mmio.
> > >
> > > I think that is all correct.  For some reason, on gs101 the FMP
> > > registers are not accessible by the "normal world", and SMC calls need
> to
> > be used instead.
> > > The sequences of SMC calls originated from Samsung's Linux driver code
> > for FMP.
> > > So I know they are the magic incantations that are needed, but I don't
> > > have access to the source code or documentation for them.  It does
> > > seem clear that one of the things they must do is write the needed
> values
> > to the FMP registers.
> > >
> > > I'd hope that these same SMC calls also work on Exynos-based SoCs that
> > > do make the FMP registers accessible to the "normal world", and
> > > therefore they can just be used on all Exynos-based SoCs and
> > > ufs-exynos won't need two different code paths.  But I don't have a
> > > way to confirm this myself.  Until someone is able to confirm this, I
> > > think we need to make the FMP support depend on
> > > EXYNOS_UFS_OPT_UFSPR_SECURE so that it doesn't conflict with
> > > exynos_ufs_config_smu() which runs when
> > !EXYNOS_UFS_OPT_UFSPR_SECURE.
> > >
> > 
> > These same SMC calls can be found in the downstream source for other
> > Exynos-based SoCs.  I suspect that exynos_ufs_config_smu() should be
> > removed, and exynos_ufs_fmp_init() should run regardless of
> > EXYNOS_UFS_OPT_UFSPR_SECURE.
> > It still would need to be tested, though, which I'm not able to do.  (And
> > especially as a cryptography feature, this *must* be tested...)  So for
> now I'm
> > going to make the FMP support conditional on
> > EXYNOS_UFS_OPT_UFSPR_SECURE.
> > 
> SMU controls the security access aspect of the FMP, one can have a usecase
> where one wants to enable inline encryption using FMP in a non-secure
> mode/world after a secure boot of the system
> and in another case, configure FMP in secure mode/world during secure boot.
> I am not sure how it is designed in gs101 though.
> Currently, exynos_ufs_config_smu() just allows SMU registers modification by
> non-secure world.
> 

Apparently, gs101 has two levels of access control for FMP.  Access to the range
configuration registers like FMPSBEGIN0 (UFSPSBEGIN0 in the upstream source) is
controlled by FMPSECURITY0.NSSMU (UFSPRSECURITY.NSSMU in the upstream source).
But access to FMPSECURITY0 itself is controlled by TZPC.NSFMP, which is writable
only by the "secure world".  In the current upstream source,
exynos_ufs_config_smu() writes to FMPSECURITY0, and this crashes on gs101 if
actually executed (it's currently disabled on gs101 for that reason).  So the
secure world software on gs101 must be setting TZPC.NSFMP = 0.

I expect that this isn't specific to gs101, and some other Exynos-based SoCs use
this same design.  This would explain the presence of the SMC calls in the
downstream source used on other Exynos-based SoCs.

So it seems that for now ufs-exynos has to use the SMC calls, as this patch
does.  This is similar to how ufs-qcom and ufs-mediatek similarly use their
SoC's respective set of SMC calls to configure inline encryption, in order to
work around similar designs where the inline encryption hardware can only be
configured by secure world software.  (I don't know why so many SoC vendors are
choosing this design, given that in practice only the normal world wants to
configure inline encryption.  The detour to the secure world seems unnecessary.)

- Eric

