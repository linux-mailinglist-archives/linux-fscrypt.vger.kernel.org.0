Return-Path: <linux-fscrypt+bounces-546-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 403CD9E99D2
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 16:01:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E914C284197
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 15:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22E551E9B09;
	Mon,  9 Dec 2024 15:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="aoXCH3sx"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DCA1C5CB3
	for <linux-fscrypt@vger.kernel.org>; Mon,  9 Dec 2024 15:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756434; cv=none; b=Gj7R7YXIFC937q75JAXN9hp+5xWBlFTA7htFp/O/vJ/h9woGodWu9OuPNKvNOruAvDYIiUcUW5B4umyrlvMVe8NZBWSqmjO/8k6iZ2ICpUVkzYDRvsjMNBkU3AwIK/2YXuG85tl/VZUKLP8pyMSXxYdon2EAmgl6LGZ4yGeSApg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756434; c=relaxed/simple;
	bh=gInSWd5MMgRSUDhcccm5xbE2Hvza006RfXp+2PMcT7Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UP2rMAY/oKxt/w2Kd7nK4EcmaqVzi9B+khlxfblR4UBFM9+fiALXYjQXzhhfSS2Uf9JYQa21OIAna1Xs7jibr0aNBV9s1bGl3pZj/9uARjkkrU699THIEoya5vm0JXWuILBgTCr8UA20+jJsdrXnRrbgUv31aHE0RYZK7C+ASkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=aoXCH3sx; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3003e203acaso19705011fa.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 09 Dec 2024 07:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733756430; x=1734361230; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ViivlbqXyCtIkKHXArGajb/AAWt9vADZPoV9+phTFlo=;
        b=aoXCH3sxRISaxVLkB0NYkY2oPKmKDvGsDSvJGFupR3cllSb0XJenYVHF/Ef2xVfobB
         29OTF25OceH8nH3iPbveAXe78xJsSVt6mcpECQh8FNRJtDANUItmpgQECc1ny5TvdpyE
         b2usxrlPWDOJijVpVMbIwMgSezImRBXBzgSUCEcn+YMySVdOyflwibnoef1oRIupypNs
         J4n2rsuO2gT1VhTwOKZytD4DK0vxg/4QOVXLORHn8w2kBS+YPEfYJ3IpN24vHLK8BAAr
         9wmPJ7wspM2vqkDJS+vwyYoOAsG+/w2K85YtX9V5abLH7Dlq9UhAM6sKBfI8eaIuyd2S
         CssA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733756430; x=1734361230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ViivlbqXyCtIkKHXArGajb/AAWt9vADZPoV9+phTFlo=;
        b=U78SHd0OEuDrYrmlLY7gB1wocIS7ehpzHn6fl7kIW0pa1a9KEHfr3qD82iDR9XCVrI
         o0AHioF/AGehpLqI9Gc7AzrKdyNEQxJf02eyfLoC7ES9ZOs7LsQPfISLzbKR0kqT0zMg
         AfkJItri3RVtj6kZxXaoVZ1WtpU0n+5ACen8an/5iV6ve/iCZWB91grGd9V5f9n0mPS4
         l1Bh5tN6oxgnNKDELfs7xypjqkM88o68uyvx9PAEUHH7Q0pRbz3Ymy8YmFXNjnvkVMum
         ij9bdyCdjViwhHh17hzENWYkxcwWQy5TWed8qovEKbqMCbY98KODkvI8yz1++HDL/xxY
         CAWA==
X-Forwarded-Encrypted: i=1; AJvYcCWQI50PNJ8J8UUgZJURp5BmaMsvrZKoOizBfZID+QNpW+G+9pdeLBU3wYtUGZP0tlplTW/pYJB97ssw2I6R@vger.kernel.org
X-Gm-Message-State: AOJu0YwGzoD/B27K6XHLjABm+9WmJ/oGyTRkEqshGFtIv9JKoKXkE0J/
	mk5WMVHBOlO27j/jwDdJ1pXTOHi0ZzsacaiHkMw2/Gcnweb4V1AawOVp8WV8IP07mI1FzRvDR0W
	q4MoqQD/KqkDLd4xpGNLT8+qSRh7OCqYfmMN18w==
X-Gm-Gg: ASbGncsa2/VasCCk3HZVV9WiZKUywIsxxip16mjPz1KXzAI/rg2tdtT8RImZ6Dm9ATA
	SoYQOB2JsHl3YW0VzlJMdt2AuEVzTDiV2EgewfYiEpa+xbysw5oOXuqeCP188NL4=
X-Google-Smtp-Source: AGHT+IGGxxX04Cbn5rlonlQPpTX4R1IKg0lQHDiZvcFPtN+IOQ1z4+qoEWIFalB4udM1M5wmHyTfRxBaDGcpotYHS/0=
X-Received: by 2002:a05:651c:887:b0:302:2baf:6d14 with SMTP id
 38308e7fff4ca-3022ff81a70mr2237501fa.40.1733756429625; Mon, 09 Dec 2024
 07:00:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209045530.507833-1-ebiggers@kernel.org>
In-Reply-To: <20241209045530.507833-1-ebiggers@kernel.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 9 Dec 2024 16:00:18 +0100
Message-ID: <CAMRc=MfLzuNjRqURpVwLzVTsdr8OmtK+NQZ6XU4hUsawKWTcqQ@mail.gmail.com>
Subject: Re: [PATCH v9 00/12] Support for hardware-wrapped inline encryption keys
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bjorn Andersson <andersson@kernel.org>, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Jens Axboe <axboe@kernel.dk>, 
	Konrad Dybcio <konradybcio@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 9, 2024 at 5:56=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> This patchset is also available in git via:
>
>     git fetch https://git.kernel.org/pub/scm/fs/fscrypt/linux.git wrapped=
-keys-v9
>
> This is a reworked version of the patchset
> https://lore.kernel.org/linux-fscrypt/20241202-wrapped-keys-v7-0-67c3ca3f=
3282@linaro.org/T/#u
> that was recently sent by Bartosz Golaszewski.  It turned out there were =
a lot
> of things I wanted to fix, and it would have taken much too long to addre=
ss them
> in a code review.  For now this is build-tested only; I've errored on the=
 side
> of sending this out early since others are working on this too.  Besides =
many
> miscellaneous fixes and cleanups, I've made the following notable changes=
:
>
> - ufs-qcom and sdhci-msm now just initialize the blk_crypto_profile thems=
elves,
>   like what ufs-exynos was doing.  This avoids needing to add all the
>   host-specific hooks for wrapped key support to the MMC and UFS core dri=
vers.
>
> - When passing the blk_crypto_key further down the stack, it now replaces
>   parameters like the algorithm ID, to avoid creating two sources of trut=
h.
>
> - The module parameter qcom_ice.use_wrapped_keys should work correctly no=
w.
>
> - The fscrypt support no longer uses a policy flag to indicate when a fil=
e is
>   protected by a HW-wrapped key, since it was already implied by the file=
's key
>   identifier being that of a HW-wrapped key.  Originally there was an iss=
ue
>   where raw and HW-wrapped keys could share key identifiers, but I had fi=
xed
>   that earlier by introducing a new HKDF context byte.
>
> - The term "standard keys" is no longer used.  Now "raw keys" is consiste=
ntly
>   used instead.  I've found that people find the term "raw keys" to be mo=
re
>   intuitive.  Also HW-wrapped keys could in principle be standardized.
>
> - I've reordered the patchset to place preparatory patches that don't dep=
end on
>   the actual HW-wrapped key support first.
>
> My current thinking is that for 6.14 we should just aim to get the prepar=
atory
> patches 1-5 merged via the ufs and mmc trees, while the actual HW-wrapped=
 key
> support continues to be finalized and properly tested.  But let me know i=
f
> anyone has any other thoughts.
>
> A quick intro to the patchset for anyone who hasn't been following along:
>
> This patchset adds support for hardware-wrapped inline encryption keys, a
> security feature supported by some SoCs and that has already seen a lot o=
f
> real-world use downstream.  It adds the block and fscrypt framework for t=
he
> feature as well as support for it with UFS on Qualcomm SoCs.
>
> This feature is described in full detail in the included Documentation ch=
anges.
> But to summarize, hardware-wrapped keys are inline encryption keys that a=
re
> wrapped (encrypted) by a key internal to the hardware so that they can on=
ly be
> unwrapped (decrypted) by the hardware.  Initially keys are wrapped with a
> permanent hardware key, but during actual use they are re-wrapped with a
> per-boot ephemeral key for improved security.  The hardware supports impo=
rting
> keys as well as generating keys itself.
>
> This differs from the existing support for hardware-wrapped keys in the k=
ernel
> crypto API (which also goes by names such as "hardware-bound keys", depen=
ding on
> the driver) in the same way that the crypto API differs from blk-crypto: =
the
> crypto API is for general crypto operations, whereas blk-crypto is for in=
line
> storage encryption.
>
> This feature is already being used by Android downstream for several year=
s
> (https://source.android.com/docs/security/features/encryption/hw-wrapped-=
keys),
> but on other platforms userspace support will be provided via fscryptctl =
and
> tests via xfstests (I have some old patches for this that need to be upda=
ted).
>
> Eric Biggers (10):
>   ufs: crypto: add ufs_hba_from_crypto_profile()
>   ufs: qcom: convert to use UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE
>   mmc: crypto: add mmc_from_crypto_profile()
>   mmc: sdhci-msm: convert to use custom crypto profile
>   soc: qcom: ice: make qcom_ice_program_key() take struct blk_crypto_key
>   blk-crypto: add basic hardware-wrapped key support
>   blk-crypto: show supported key types in sysfs
>   blk-crypto: add ioctls to create and prepare hardware-wrapped keys
>   fscrypt: add support for hardware-wrapped keys
>   ufs: qcom: add support for wrapped keys
>
> Gaurav Kashyap (2):
>   firmware: qcom: scm: add calls for wrapped key support
>   soc: qcom: ice: add HWKM support to the ICE driver
>
>  Documentation/ABI/stable/sysfs-block          |  18 +
>  Documentation/block/inline-encryption.rst     | 251 +++++++++++-
>  Documentation/filesystems/fscrypt.rst         | 201 +++++++--
>  .../userspace-api/ioctl/ioctl-number.rst      |   2 +
>  block/blk-crypto-fallback.c                   |   7 +-
>  block/blk-crypto-internal.h                   |  10 +
>  block/blk-crypto-profile.c                    | 103 +++++
>  block/blk-crypto-sysfs.c                      |  35 ++
>  block/blk-crypto.c                            | 196 ++++++++-
>  block/ioctl.c                                 |   5 +
>  drivers/firmware/qcom/qcom_scm.c              | 214 ++++++++++
>  drivers/firmware/qcom/qcom_scm.h              |   4 +
>  drivers/md/dm-table.c                         |   1 +
>  drivers/mmc/host/cqhci-crypto.c               |  38 +-
>  drivers/mmc/host/cqhci.h                      |   8 +-
>  drivers/mmc/host/sdhci-msm.c                  | 102 +++--
>  drivers/soc/qcom/ice.c                        | 383 +++++++++++++++++-
>  drivers/ufs/core/ufshcd-crypto.c              |  33 +-
>  drivers/ufs/host/ufs-exynos.c                 |   3 +-
>  drivers/ufs/host/ufs-qcom.c                   | 137 +++++--
>  fs/crypto/fscrypt_private.h                   |  75 +++-
>  fs/crypto/hkdf.c                              |   4 +-
>  fs/crypto/inline_crypt.c                      |  42 +-
>  fs/crypto/keyring.c                           | 157 +++++--
>  fs/crypto/keysetup.c                          |  63 ++-
>  fs/crypto/keysetup_v1.c                       |   4 +-
>  include/linux/blk-crypto-profile.h            |  73 ++++
>  include/linux/blk-crypto.h                    |  73 +++-
>  include/linux/firmware/qcom/qcom_scm.h        |   8 +
>  include/linux/mmc/host.h                      |   8 +
>  include/soc/qcom/ice.h                        |  34 +-
>  include/uapi/linux/blk-crypto.h               |  44 ++
>  include/uapi/linux/fs.h                       |   6 +-
>  include/uapi/linux/fscrypt.h                  |   7 +-
>  include/ufs/ufshcd.h                          |  11 +-
>  35 files changed, 2091 insertions(+), 269 deletions(-)
>  create mode 100644 include/uapi/linux/blk-crypto.h
>
>
> base-commit: f486c8aa16b8172f63bddc70116a0c897a7f3f02
> --
> 2.47.1
>

I haven't gotten to the bottom of this yet but the
FS_IOC_ADD_ENCRYPTION_KEY ioctl doesn't work due to the SCM call
returning EINVAL. Just FYI. I'm still figuring out what's wrong.

Bart

