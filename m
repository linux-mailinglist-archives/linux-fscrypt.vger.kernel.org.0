Return-Path: <linux-fscrypt+bounces-582-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F40FDA08A99
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jan 2025 09:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF5F5168644
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jan 2025 08:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49562080F6;
	Fri, 10 Jan 2025 08:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="oqhdcaDh"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28F72080D7
	for <linux-fscrypt@vger.kernel.org>; Fri, 10 Jan 2025 08:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736498662; cv=none; b=qEBLWwgj8ancLV2tKTjIoH/sCEJtVwZ/uKsToWJxDShe5o/uikQpGEGs0O7p3YJX06oaZWKoC+d5pmtk8JAy5+YJEfp3Cby/KAsD1wYd1UlzAqVf601w1Xz2hSpMlTCov+n0Zg83THa5/5xUkPrkisabZA8ghwf5cCdktGajQjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736498662; c=relaxed/simple;
	bh=bcs5XrixjJuICcKrOi0QLiwMCzGybnpSV1jIYpcaEdk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ll9kN5oCp27raH+TH9HDzKtcD8TGaPn3T3PEFFjRJD4FI0oJw3BI4YnPe1ZJMxEyqRvSKEv04vaOishDKHy6Z24oFxsxNkeHpQpY67V5D5dz9Jn/APlrLLg2mSF4gkIFoS32JPyp4u4x+BUkfVRKVyHGNdhEcnXkDg/yFBr6wcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=oqhdcaDh; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5401e6efffcso1929204e87.3
        for <linux-fscrypt@vger.kernel.org>; Fri, 10 Jan 2025 00:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1736498659; x=1737103459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3J6ybie5MZTohAU5zO4AHtHmlS6SVT///Z6RnwOTF0I=;
        b=oqhdcaDhpg7uKVN/GIznd4jiSK2ORwiXk9h/zpw9FR245bEuGdgGwuv+iH7nlP+B8m
         9zSJy/VKhvJMc6ppvhGlbHo0DpM4g+sUf+393Z8NQE5l644lXXhX/hc02MoRYreuPbqy
         1r7QVc8llQBVdCfRPVAL+k/Y9s9TGUl8HgbN9u680Qy4aSKB90ejT4XD+RT9i7blL+NE
         cGP+WYt29uNl4d9Gw2WB4t37qzpLJXDzmBUYGtIqQZ/70PnLzFAUzfmBXAjKu9Q09iGx
         +l7IMfhAkeuAw4F38csY9kRhSxRMk/6yUGsObLAkdEDRMnEffvi9RyOJf1veWr4qfHlw
         KPfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736498659; x=1737103459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3J6ybie5MZTohAU5zO4AHtHmlS6SVT///Z6RnwOTF0I=;
        b=vYmmfLV0X2WzydlDkPAd/eqENQSCnIoX/KQP2kbMCR7Ei2UCNu7M2Ovd2s55Iew028
         PUND2sPYftJ3Fou3ruyOLBS0Ni6BuCdeorNX5Pf8C2O/KWCMfmX2NSp08FpGwFpowz/H
         mXPtaCnXJlQWvE07c4CKsOC6kpXt8LdwgupggOQDBr2c6ZuRWp10M8ssC67Yvu7JKFfN
         iFrHmoDQ1v89m7riyyBcecSOc6fSaThhKY+AsOfFWtxnSmEcj3o1qzZK3vLYy6OQE2sK
         aZpSK7BZQC/WLolp9mkReKfZNl5MeHPDJSAwLY7qqqyqWtZkMmruFVMAzaVeZomr6lFN
         HOgg==
X-Forwarded-Encrypted: i=1; AJvYcCXD7+FO8nHWisAFV7EG66dOUXmDuvwIAYkUo4S7degE95MfWYMXxK7hOU2fjT3eVH5af3iw9bJlYv2O2m7w@vger.kernel.org
X-Gm-Message-State: AOJu0YxTBm1Ac21Tqp2M3ggWsgPPWpj7LIH9O7r6ZEB5aQgrpOMRXGsC
	R9lljWVr9nJIl5KUjKDtF3380kB7A90jIPMXYGT6V7scC4FhjZpO/bHlNuBb/bpoOEYyGwIgD6B
	3/3LBpVoMaUyGYSj66KyUMe4MWq6ofKXhpTY+4Q==
X-Gm-Gg: ASbGncstrQ0iBADALkfv/aVq5bwnR/sWriUSkvkwhsZPH8gWmrc4sQLo3g0xHc9dqYa
	tSSqw21K0YeYeu0OZ6x1ONh1u7s3GNhHL3vd2PdmGnoW48cCoorH2YaFFUIuYDrLAWYc8
X-Google-Smtp-Source: AGHT+IEyB2cuChMeX1r+nZtaJdP6Mzdmo0n9PGPsFhkwAW7ukTnXjzzz9a+MUocObbefl6A9T2AxU0IqAEz7Wjzjkhg=
X-Received: by 2002:a05:6512:2399:b0:540:1ea7:44db with SMTP id
 2adb3069b0e04-542845b1aedmr3480546e87.4.1736498658964; Fri, 10 Jan 2025
 00:44:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241213041958.202565-1-ebiggers@kernel.org>
In-Reply-To: <20241213041958.202565-1-ebiggers@kernel.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 10 Jan 2025 09:44:07 +0100
X-Gm-Features: AbW1kvYIJl4nVvnVQIFwQlGZKMe8mAAA_MH2MqnfAcbAm7yp2J-zmj2cn1w9I5U
Message-ID: <CAMRc=MdeZ_k9z+ZKW1ub0m9ymh3eABUU7ZRPY9TYHM_fc+D+qQ@mail.gmail.com>
Subject: Re: [PATCH v10 00/15] Support for hardware-wrapped inline encryption keys
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

On Fri, Dec 13, 2024 at 5:20=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> This patchset is based on next-20241212 and is also available in git via:
>
>     git fetch https://git.kernel.org/pub/scm/fs/fscrypt/linux.git wrapped=
-keys-v10
>
> This patchset adds support for hardware-wrapped inline encryption keys, a
> security feature supported by some SoCs.  It adds the block and fscrypt
> framework for the feature as well as support for it with UFS on Qualcomm =
SoCs.
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
> crypto API (also called "hardware-bound keys" in some places) in the same=
 way
> that the crypto API differs from blk-crypto: the crypto API is for genera=
l
> crypto operations, whereas blk-crypto is for inline storage encryption.
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
> Maintainers, please consider merging the following preparatory patches fo=
r 6.14:
>
>   - UFS / SCSI tree: patches 1-4
>   - MMC tree: patches 5-7
>   - Qualcomm / MSM tree: patch 8
>

IIUC The following patches will have to wait for the v6.15 cycle?

[PATCH v10 9/15] soc: qcom: ice: make qcom_ice_program_key() take
struct blk_crypto_key
[PATCH v10 10/15] blk-crypto: add basic hardware-wrapped key support
[PATCH v10 11/15] blk-crypto: show supported key types in sysfs
[PATCH v10 12/15] blk-crypto: add ioctls to create and prepare
hardware-wrapped keys
[PATCH v10 13/15] fscrypt: add support for hardware-wrapped keys
[PATCH v10 14/15] soc: qcom: ice: add HWKM support to the ICE driver
[PATCH v10 15/15] ufs: qcom: add support for wrapped keys

Bartosz

