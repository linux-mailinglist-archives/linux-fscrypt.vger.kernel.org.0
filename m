Return-Path: <linux-fscrypt+bounces-334-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E804D92AA89
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 22:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D46F1F22562
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 20:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E23114D6F9;
	Mon,  8 Jul 2024 20:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULGuEKof"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7210714D444;
	Mon,  8 Jul 2024 20:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720470392; cv=none; b=dxUKo8L0+r9QSfVxO92q8/mHbbfek340FRzPF1RTwS+P1svgf73pssC/0HHcKaFP7JdoJFPp/VPiVH1eNpzKf9VP5QqEjmxMydRANxTpIwLKPhcp4QbLnoUpY1vCG66znCgqDVaYxyIfouqyJ0nnntm58B0KU7m88V3YCavfPMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720470392; c=relaxed/simple;
	bh=+6YheFz+kLx2rM0m2RczYow7VkKXHg66pCP5r1wwAr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b42KYHg8Ncl0WtrZYzqQaV7TZ6qYE30ImvfNMfCpE/KX4jUKwt5D3KltzhIPxYwcyh0BlqCvKhwv/T5sJI0P8C4C78vPJtVNVg/snrPDfGTgXaRbQlcVPG3bJJo67yLTE+1ctL0q7vr9ztVymuZ2moH9fHgb29GbT89ljMGuIGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULGuEKof; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0495DC3277B;
	Mon,  8 Jul 2024 20:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720470392;
	bh=+6YheFz+kLx2rM0m2RczYow7VkKXHg66pCP5r1wwAr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ULGuEKofNcRRrB8NkgVnDyYWfv0JlNkXpd5cSpFi1/vEWRSy3i5Jd7n2TwKy1rc/z
	 zS+/CoWw1W4P+u/QHCsrr/MQkE/gzgjWTg8PyQq7l0bzi07FJ9sdaxRs5IEAkmtk9V
	 If3160+E9b/QJLEOxgZwpfpS8Vl4k+k5YhNkJRj5gGf1k85l/FF8YVTZMAp8IwC3cB
	 +F84i5wdyG98B56+jxS3GLqHdVSg5STwouHAE4rShUXxmG04w8HX3mN/4FTjkRtiAb
	 OQ+Psu/SUo+aNjJFjarLGJwhPsZ4o4j4ZbHIWN/zdwdX4z81YfUC5vnTGFDq4K53c8
	 OtNJM1cWBCgBg==
Date: Mon, 8 Jul 2024 13:26:30 -0700
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
Message-ID: <20240708202630.GA47857@sol.localdomain>
References: <20240702072510.248272-1-ebiggers@kernel.org>
 <20240702072510.248272-7-ebiggers@kernel.org>
 <CADrjBPoWVq-eu4Wa6_hrkk067tnZGC82UCJDyjSRGoG254w6vg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADrjBPoWVq-eu4Wa6_hrkk067tnZGC82UCJDyjSRGoG254w6vg@mail.gmail.com>

Hi Peter,

On Thu, Jul 04, 2024 at 02:26:05PM +0100, Peter Griffin wrote:
> Do you know how these FMP registers (FMPSECURITY0 etc) relate to the
> UFSPR* registers set in the existing exynos_ufs_config_smu()? The
> UFS_LINK spec talks about UFSPR(FMP), so I had assumed the FMP support
> would be writing these same registers but via SMC call.
> 
> I think by the looks of things
> 
> #define UFSPRSECURITY 0x010
> #define UFSPSBEGIN0 0x200
> #define UFSPSEND0 0x204
> #define UFSPSLUN0 0x208
> #define UFSPSCTRL0 0x20C
> 
> relates to the following registers in gs101 spec
> 
> FMPSECURITY0 0x0010
> FMPSBEGIN0 0x2000
> FMPSEND0 0x2004
> FMPSLUN0 0x2008
> FMPSCTRL0 0x200C
> 
> And the SMC calls your calling set those same registers as
> exynos_ufs_config_smu() function. Although it is hard to be certain as
> I don't have access to the firmware code. Certainly the comment below
> about FMPSECURITY0 implies that :)
> 
> With that in mind I think exynos_ufs_fmp_init() function in this patch
> needs to be better integrated with the EXYNOS_UFS_OPT_UFSPR_SECURE
> flag and the existing exynos_ufs_config_smu() function that is
> currently just disabling decryption on platforms where it can access
> the UFSPR(FMP) regs via mmio.

I think that is all correct.  For some reason, on gs101 the FMP registers are
not accessible by the "normal world", and SMC calls need to be used instead.
The sequences of SMC calls originated from Samsung's Linux driver code for FMP.
So I know they are the magic incantations that are needed, but I don't have
access to the source code or documentation for them.  It does seem clear that
one of the things they must do is write the needed values to the FMP registers.

I'd hope that these same SMC calls also work on Exynos-based SoCs that do make
the FMP registers accessible to the "normal world", and therefore they can just
be used on all Exynos-based SoCs and ufs-exynos won't need two different code
paths.  But I don't have a way to confirm this myself.  Until someone is able to
confirm this, I think we need to make the FMP support depend on
EXYNOS_UFS_OPT_UFSPR_SECURE so that it doesn't conflict with
exynos_ufs_config_smu() which runs when !EXYNOS_UFS_OPT_UFSPR_SECURE.

- Eric

