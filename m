Return-Path: <linux-fscrypt+bounces-344-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A923192C32C
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Jul 2024 20:14:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E14621C22953
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Jul 2024 18:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFEF17B027;
	Tue,  9 Jul 2024 18:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AYb+UqUe"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2404A1B86ED;
	Tue,  9 Jul 2024 18:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720548847; cv=none; b=mQ7g+MppP3xQHxQNsAWplaIybgscaMZk1v1kBMMxA8m3oC2fOUkrQwNdIrP10TFpvL5FK0OOrDatCZ5M3ZHNnlmZhrYJSI4tMdxrOJ8tqHw8l0mvPNFDFbCEEh/x472aQayny6EAuJnel7X0CPjE4Giy19PMdhWvTFAc9w7ET7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720548847; c=relaxed/simple;
	bh=OkowgpgSGdOlOcmFTSzXiX4gK6EF938iLA84IR85IRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GtYnlp/5yJnsUaf7dxGBfVwbBuIp2MD9CH89rAB4nGWfXAtsGUH4EaOJNZOLCuLody1LIzP6KBHW7cpc4jMXC1paYhYvTtVFczw3xGKePDS+LYWOMVkD4AMuW7wHjP54hdDhN2UESYtTmdJ5u3TpmD6ss0AU2z89kt6wDTeOv9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AYb+UqUe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FC8C3277B;
	Tue,  9 Jul 2024 18:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720548846;
	bh=OkowgpgSGdOlOcmFTSzXiX4gK6EF938iLA84IR85IRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AYb+UqUep5QeY5siW5Vh3TDhn5Yg8/TNan1enSZl6MkWY5Cjdy41as7syj6TqwBop
	 Z2n/onK6O2I/uIPtNER3t8GP1aVzUcekAOKgDv00U3uqcbK+8R4GZesAzXDWvDqXPx
	 x82SgABlWWVIJx04k81RvMtzLDWDXGoQYeZCVQ9wUEJ90jr9S3yk/7v3aRi9UuFF1G
	 ph9g0t6nle6jEx815WZ3pjstrUToNvbaBx76Nb1lKusy+17/gqLJbPsm4BcWjVdanf
	 aB4Tw9kzzi6jpUUbf2tFXeq5vG5+7DVOQIBcF0PSzR7q3gi3uN0PAQf7I7Ui66I1uJ
	 aXA0qigTpZ7Mw==
Date: Tue, 9 Jul 2024 11:14:04 -0700
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
Subject: Re: [PATCH v3 6/6] scsi: ufs: exynos: Add support for Flash Memory
 Protector (FMP)
Message-ID: <20240709181404.GA1945@sol.localdomain>
References: <20240708235330.103590-1-ebiggers@kernel.org>
 <20240708235330.103590-7-ebiggers@kernel.org>
 <CADrjBPq4sEamwD3+wT2p481en-J2Ee7G0f+UbXG3g3RqUMiv3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADrjBPq4sEamwD3+wT2p481en-J2Ee7G0f+UbXG3g3RqUMiv3w@mail.gmail.com>

On Tue, Jul 09, 2024 at 12:17:53PM +0100, Peter Griffin wrote:
> Hi Eric,
> 
> On Tue, 9 Jul 2024 at 00:55, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Add support for Flash Memory Protector (FMP), which is the inline
> > encryption hardware on Exynos and Exynos-based SoCs.
> >
> > Specifically, add support for the "traditional FMP mode" that works on
> > many Exynos-based SoCs including gs101.  This is the mode that uses
> > "software keys" and is compatible with the upstream kernel's existing
> > inline encryption framework in the block and filesystem layers.  I plan
> > to add support for the wrapped key support on gs101 at a later time.
> >
> > Tested on gs101 (specifically Pixel 6) by running the 'encrypt' group of
> > xfstests on a filesystem mounted with the 'inlinecrypt' mount option.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> 
> Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
> 
> and
> 
> Tested-by: Peter Griffin <peter.griffin@linaro.org>
> 
> Tested by running the encrypt group of xfstests on my Pixel 6, using
> the Yocto development env described here
> https://git.codelinaro.org/linaro/googlelt/pixelscripts
> 
> Notes on testing, in addition to above README.
> 
> 1. Enabled following additional kernel configs gs101_config.fragment
> CONFIG_FS_ENCRYPTION=y
> CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
> CONFIG_SCSI_UFS_CRYPTO=y
> CONFIG_BLK_INLINE_ENCRYPTION=y
> CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y
> CONFIG_CRYPTO_HCTR2=y
> 
> 2. Add meta-security layer to bblayers.conf and relevant packages to local.conf
> BBLAYERS += "/yocto-builds/yocto/meta-security"
> IMAGE_INSTALL:append = " xfstests ecryptfs-utils fscryptctl keyutils
> cryptmount "
> 
> 3. Rebuild/reflash Yocto rootfs
> 
> bitbake virtual/kernel core-image-full-cmdline
> fastboot flash userdata core-image-full-cmdline-google-gs.rootfs.ext4
> 
> 4. On the device ran the following
> 
> mkfs.ext4 -O encrypt /dev/sda26
> mkfs.ext4 -O encrypt /dev/sda20
> mkdir -p /mnt/scratchdev
> mkdir -p /mnt/testdev
> mount /dev/sda20 -o inlinecrypt /mnt/testdev
> mount /dev/sda26 -o inlinecrypt /mnt/scratchdev
> export TEST_DEV=/dev/sda20
> export TEST_DIR=/mnt/testdev
> export SCRATCH_DEV=/dev/sda26
> export SCRATCH_MNT=/mnt/scratchdev
> cd /usr/xfstests
> check -g encrypt
> 
> All 28 tests passed
> 
> <snip>
> Ran: ext4/024 generic/395 generic/396 generic/397 generic/398
> generic/399 generic/419 generic/421 generic/429 generic/435
> generic/440 generic/548 generic/549 generic/550 generic/576
> generic/580 gener9
> Not run: generic/399 generic/550 generic/576 generic/584 generic/613
> Passed all 28 tests
> 
> kind regards,
> 

Thanks!  This is similar to what I did.  But, to get the inlinecrypt mount
option to be used during the tests it's necessary to do the following:

    export EXT_MOUNT_OPTIONS="-o inlinecrypt"

The following message will appear in the kernel log:

    fscrypt: AES-256-XTS using blk-crypto (native)

- Eric

