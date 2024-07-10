Return-Path: <linux-fscrypt+bounces-352-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB44592D462
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 16:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE9921C209B4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 14:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD64193476;
	Wed, 10 Jul 2024 14:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZpSjZ7hi"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84724193472
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 14:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720622421; cv=none; b=JpJqgZSP21YF9UsmKXDhhb6H3UkE5HF+9XCUUTvCIrLs9qX5GCzTJvRwRKvEPbG4GmsYwFjrrVFqdkd1tbs0RhTZSfcbKdOMTCATdJmWUzpMkDGnGQJcHiY99yDGxq1JPu4b4263LTn5I98n33wFeuc+NXrW5/QK40Af/aW0ufM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720622421; c=relaxed/simple;
	bh=DRVcwf7YUoO1RXe82JhfMETgwcBrO4qMd2b8uknKS/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jwvgQ7tR2H8q0Xb03kPXkw9B/x5cneN/UW/xugAj0gU527LKzpAx5wzAIJwy+zCCXfJcPzi4SRhSoBQ17Mcj6UCtsWfpj6ZUfclRhJ6u1XpmlSLw8T7pGnYCHgQN9DGxTgxvZPPWQUalBL5rjoFf0JU6ecprXDjQONaqV9cPNZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZpSjZ7hi; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5c6924f2383so955991eaf.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 07:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720622418; x=1721227218; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5MBKPXiqwYRjqjz2+BCt5W9uLgVhHA565KHdY/VvTM=;
        b=ZpSjZ7hieDLP5PVm5E7cDcAjCySP3NWW5JxtgdIkbNKzQvi644tRU3EcJ4LoQ3Qs0h
         pV7HXc8tYhOxb+Usxc7NEgsTTgWVexlkqzhOimQUW/7/+0ky6r/voWt5tp7tDGCJGajB
         Td/bCzO0+Lck8GnYxfrbNapTnYa/g0+CmZXOYxTAyIHu1G7FL2rOmloswAHuTcY2G39Q
         uUlGHLCmE0eG70OPP4Ge5A013zi8LBVNsmI+bMf8CgV3CDVk5JB9eT5Z2NQbiOBb6Dho
         kOucbBkcZoefm47LoQoTRVuMLvFmqjBqbSyqy30rW6en6GRZAowczhY925Zw7tUCmM/5
         OYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720622418; x=1721227218;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q5MBKPXiqwYRjqjz2+BCt5W9uLgVhHA565KHdY/VvTM=;
        b=g9Jt36wLzX3uR4wNfvIR1cFVWQIrRwg09JXS0Kokqyt/BFwBLrH2Nvtn6AKd5Ike8L
         0y4z0l9ETBrIihyQFp6S/kjg+VwKQt3+ynL39SkW342YajCU1XF61c0KIumBQBhMhKiS
         ef7kRYtu2qSW+plh87YCPvUAM7dTF3tOy2QtP/9/Kdvd9fDh+/6bUZm1Dm9d1hPaebmo
         g9ZCR8QYp1zkFqoluPiX6oVEQcS1ku8oBghr39pqJdtbvHQenGa7lQOW/IE2a53W2of5
         cGqYNjtYMxI6ElQK7GKn1XhH0UNOKMFdIWKcaLJ4aBMKdQ8AP01gL4+Sw97jJYnCyIub
         1LpA==
X-Forwarded-Encrypted: i=1; AJvYcCX2RFpJQwOYQjxhMoRhSRIIlWXRDTiLxaoDxGL2MC+o9hevM5a8QdBixPBULIkOjjnVxWW1w7MDYbZbpfF3IBlIAdgGxo+JZI1ygh8f4Q==
X-Gm-Message-State: AOJu0YwVYXjevY0tZFdCrmAQo+RADmKmLUfdALMsPdSMWq1P1fIcGVSD
	ZtXGh+jAjg8SF3/Lqv7tjZ583vj9oy3iAbqt/LVAF4VvCvubyPnKBZYJwoUIgcEz1/5zilj7zhP
	j5/goMRmZp2Sv0jp4N5oW30UheBjAE/bSCsarJg==
X-Google-Smtp-Source: AGHT+IGPbA+7U0GVSWHLJgAcEq7ch7u4XfLCU5CQ1jMlzvqMmVL+V7Jj4ZiAiKi9goWHX+sUxcTZNyMRh0XmCjCA6ME=
X-Received: by 2002:a05:6820:c92:b0:5c4:796a:2c93 with SMTP id
 006d021491bc7-5c7b7c1c2e3mr1845799eaf.1.1720622418551; Wed, 10 Jul 2024
 07:40:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708235330.103590-1-ebiggers@kernel.org> <20240708235330.103590-7-ebiggers@kernel.org>
 <CADrjBPq4sEamwD3+wT2p481en-J2Ee7G0f+UbXG3g3RqUMiv3w@mail.gmail.com> <20240709181404.GA1945@sol.localdomain>
In-Reply-To: <20240709181404.GA1945@sol.localdomain>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Wed, 10 Jul 2024 15:40:07 +0100
Message-ID: <CADrjBPpHcXvX-eEbWzCFBNhf9N0hYssPiESKiyNRrzbb6uibdg@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] scsi: ufs: exynos: Add support for Flash Memory
 Protector (FMP)
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
	William McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Tue, 9 Jul 2024 at 19:14, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Jul 09, 2024 at 12:17:53PM +0100, Peter Griffin wrote:
> > Hi Eric,
> >
> > On Tue, 9 Jul 2024 at 00:55, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > Add support for Flash Memory Protector (FMP), which is the inline
> > > encryption hardware on Exynos and Exynos-based SoCs.
> > >
> > > Specifically, add support for the "traditional FMP mode" that works on
> > > many Exynos-based SoCs including gs101.  This is the mode that uses
> > > "software keys" and is compatible with the upstream kernel's existing
> > > inline encryption framework in the block and filesystem layers.  I plan
> > > to add support for the wrapped key support on gs101 at a later time.
> > >
> > > Tested on gs101 (specifically Pixel 6) by running the 'encrypt' group of
> > > xfstests on a filesystem mounted with the 'inlinecrypt' mount option.
> > >
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> >
> > Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
> >
> > and
> >
> > Tested-by: Peter Griffin <peter.griffin@linaro.org>
> >
> > Tested by running the encrypt group of xfstests on my Pixel 6, using
> > the Yocto development env described here
> > https://git.codelinaro.org/linaro/googlelt/pixelscripts
> >
> > Notes on testing, in addition to above README.
> >
> > 1. Enabled following additional kernel configs gs101_config.fragment
> > CONFIG_FS_ENCRYPTION=y
> > CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
> > CONFIG_SCSI_UFS_CRYPTO=y
> > CONFIG_BLK_INLINE_ENCRYPTION=y
> > CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y
> > CONFIG_CRYPTO_HCTR2=y
> >
> > 2. Add meta-security layer to bblayers.conf and relevant packages to local.conf
> > BBLAYERS += "/yocto-builds/yocto/meta-security"
> > IMAGE_INSTALL:append = " xfstests ecryptfs-utils fscryptctl keyutils
> > cryptmount "
> >
> > 3. Rebuild/reflash Yocto rootfs
> >
> > bitbake virtual/kernel core-image-full-cmdline
> > fastboot flash userdata core-image-full-cmdline-google-gs.rootfs.ext4
> >
> > 4. On the device ran the following
> >
> > mkfs.ext4 -O encrypt /dev/sda26
> > mkfs.ext4 -O encrypt /dev/sda20
> > mkdir -p /mnt/scratchdev
> > mkdir -p /mnt/testdev
> > mount /dev/sda20 -o inlinecrypt /mnt/testdev
> > mount /dev/sda26 -o inlinecrypt /mnt/scratchdev
> > export TEST_DEV=/dev/sda20
> > export TEST_DIR=/mnt/testdev
> > export SCRATCH_DEV=/dev/sda26
> > export SCRATCH_MNT=/mnt/scratchdev
> > cd /usr/xfstests
> > check -g encrypt
> >
> > All 28 tests passed
> >
> > <snip>
> > Ran: ext4/024 generic/395 generic/396 generic/397 generic/398
> > generic/399 generic/419 generic/421 generic/429 generic/435
> > generic/440 generic/548 generic/549 generic/550 generic/576
> > generic/580 gener9
> > Not run: generic/399 generic/550 generic/576 generic/584 generic/613
> > Passed all 28 tests
> >
> > kind regards,
> >
>
> Thanks!  This is similar to what I did.  But, to get the inlinecrypt mount
> option to be used during the tests it's necessary to do the following:
>
>     export EXT_MOUNT_OPTIONS="-o inlinecrypt"
>

OK great, thanks Eric! I will update my notes to include that. That
was actually one reason to include all the test instructions in the
email to check I was running this correctly :)

> The following message will appear in the kernel log:
>
>     fscrypt: AES-256-XTS using blk-crypto (native)

I just ran the tests again setting EXT_MOUNT_OPTIONS and I see

root@google-gs:/usr/xfstests# dmesg | grep "fscrypt: AES-256-XTS"
[ 1319.539742] fscrypt: AES-256-XTS using blk-crypto (native)

I also added in fsverity-utils and xz which are required by a couple
of the skipped tests.

Thanks,

Peter

