Return-Path: <linux-fscrypt+bounces-594-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22C9EA26F6C
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Feb 2025 11:43:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCFDC1887120
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Feb 2025 10:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A807020AF9D;
	Tue,  4 Feb 2025 10:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="I7lYGzHv"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1FA20A5F1
	for <linux-fscrypt@vger.kernel.org>; Tue,  4 Feb 2025 10:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738665781; cv=none; b=Ax3Xr/uEhZ7rL3FZZv0GupSOcLOKtJK1nbAI5/ae/6qVgeb/cbqhhMvJuA1P9Lf38KmntMVk/CtobQpgnrU3UA6sroy7NjIIG/rAOpvzDscGwNBtTgFBkwnUHsfIFsKq6NP2ez3Wb21mZqToxPQj1HDTJaGyM3tuTkG2F4RlUcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738665781; c=relaxed/simple;
	bh=O9fK3I1pzwKP4nLc6/iAkvLdftAlb3h+THZJIPaOcUM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OCvsnuIRFbosph2oU+ostgT2RtFY1FSHPmzfsFezaxqastPbKCkY4XKBJn6VsZ5nAv5A5mKdpMI0hEjcD5Ed0AM+G7qpTaDIH3klBNVY3V/ni5k/KQH63lQmqoe92Bm5cEu+aQoGpCYb0HAdS2IcYpEnQl6epIkXA0qL7gi0jpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=I7lYGzHv; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5401be44b58so5752065e87.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 04 Feb 2025 02:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1738665777; x=1739270577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lE2w/bQJpX8Ezf3hOPnZ8S+RoX8BTDVVvaDLT5mRYhc=;
        b=I7lYGzHvU0BIKzXN8+MYN6s/pBGNbsu18VNl0KVMsNRP/0bQJL0KbLWpSvTLgIL6fm
         xZcumAOfZcd1ZZM1Au5prZx3JuRGG36Uddc6zNG5mX1QqVr1FbQfMafvYZXC5fUyxEN3
         06zeMYaNVxPHWmxAVm4q9Ti5UiExaSR1/CSJLFFTfAjCc0HiNWwnTRWb8U2CRzz4v9ps
         6GqUzZj4enmv9KiMdaKU8d/rIq95qB91+dXwCcx0WsdxsmlWhJQK0F0DKap/fnuPAI38
         WbvBRHTiAy1yJb6bv6MqPpjRW6NncHqUQp3wjlw8d8nxjrklqtNTkb+rNH7Y61hLQJK7
         lw6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738665777; x=1739270577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lE2w/bQJpX8Ezf3hOPnZ8S+RoX8BTDVVvaDLT5mRYhc=;
        b=PbGkny8NmSZU4qJI4Cjv4G1WLb2g9ZqvtQtewBCpOxvRCP37o3JX4QqDIH97dDty4u
         LeJcXB3a2HHy+hlfgtapvzy53UKqmsvtIORRG4HliS1A8qGxLvcp7PzWpNDU6/bAh+Mg
         3BAmUd7SH6J6ZlXDzeYbLX2baMmYqDpUB3QkZQh6ZNZAopLtqtXJgqkoLZwpa/hbq9a+
         25dLKyhAzbzQKLzuoG9YBK8kE2h3ut2W3QpDP7OGE3SJ1D5cL4ChOCSH/nQBvfGdQUWL
         xdH7qxi2y5zpdzRGGNBbeTWO4IJuLkm+n88ASoUT29XswCCCNwB7AoDB3TPPvCZnuzFQ
         ElIw==
X-Forwarded-Encrypted: i=1; AJvYcCU7DLzyU1bF3bLZHcgiRqNISJT9gF+/wdzIEBbf1pwTYFZ9ZRYhNu7MIl+gV1L9GXXHPiERAilqHrXuWDCp@vger.kernel.org
X-Gm-Message-State: AOJu0YxYVDmjGMjJldCN/cHw+IeO8iMvJpF3tjIT00jD9t67/ZxsZHJi
	kvLHAx83WNDL/l76ebCVSJkjqJ07oJvdf5WO1omDPgx3XRlQDpwQvuTILek5NYRWtAlDstgbcdd
	eCKYCnKthJ1aruBHWJmzatVVhIzYaXS60HbxRhw==
X-Gm-Gg: ASbGncuEvJRixQF/AeCnledS/ze12hfNv1bfdNogclP9QOV1y9Qhb+rN1HFQv9vF30x
	Jy6IiOZ6KSQafjxELtb5+rFD5MgoTvyRp70b7owqjbJRb1e4eMLZ6PQsFB+rZsAm2B8ZLOSwk7b
	YYnAoWsIRxh28NdggzK0b0gznDiibc
X-Google-Smtp-Source: AGHT+IE5CYBdpn6DfP3V68IEBp+LNXJHRO3XMVbiHUUscPeksGzYuA8lgJODapvJJrdvbNiLHm9bcRL2vHNots0NUJA=
X-Received: by 2002:ac2:4f85:0:b0:542:2999:399c with SMTP id
 2adb3069b0e04-543e4c3cac2mr6409529e87.46.1738665776073; Tue, 04 Feb 2025
 02:42:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250204060041.409950-1-ebiggers@kernel.org>
In-Reply-To: <20250204060041.409950-1-ebiggers@kernel.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 4 Feb 2025 11:42:45 +0100
X-Gm-Features: AWEUYZnKZTyWo8D9zkwZDMqGx-d60ikbe91VkAnSO7h5ypwW4ujvIIcv_3fYFsw
Message-ID: <CAMRc=Mf-iTgUM4K1c6NpsWL+dk9BP72rJsXKf6tCKUTB=SSizA@mail.gmail.com>
Subject: Re: [PATCH v11 0/7] Support for hardware-wrapped inline encryption keys
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Gaurav Kashyap <quic_gaurkash@quicinc.com>, linux-fscrypt@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 7:03=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> This patchset is based on v6.14-rc1 and is also available at:
>
>     git fetch https://git.kernel.org/pub/scm/fs/fscrypt/linux.git wrapped=
-keys-v11
>
> This patchset adds support for hardware-wrapped inline encryption keys,
> a security feature supported by some SoCs.  It adds the block and
> fscrypt framework for the feature as well as support for it with UFS on
> Qualcomm SoCs.
>
> This feature is described in full detail in the included Documentation
> changes.  But to summarize, hardware-wrapped keys are inline encryption
> keys that are wrapped (encrypted) by a key internal to the hardware so
> that they can only be unwrapped (decrypted) by the hardware.  Initially
> keys are wrapped with a permanent hardware key, but during actual use
> they are re-wrapped with a per-boot ephemeral key for improved security.
> The hardware supports importing keys as well as generating keys itself.
>
> This differs from the existing support for hardware-wrapped keys in the
> kernel crypto API (also called "hardware-bound keys" in some places) in
> the same way that the crypto API differs from blk-crypto: the crypto API
> is for general crypto operations, whereas blk-crypto is for inline
> storage encryption.
>
> This feature is already being used by Android downstream for several
> years
> (https://source.android.com/docs/security/features/encryption/hw-wrapped-=
keys),
> but on other platforms userspace support will be provided via fscryptctl
> and tests via xfstests.  The tests have been merged into xfstests, and
> they pass on the SM8650 HDK with the upstream kernel plus this patchset.
>
> This is targeting 6.15.  As per the suggestion from Jens
> (https://lore.kernel.org/linux-block/c3407d1c-6c5c-42ee-b446-ccbab1643a62=
@kernel.dk/),
> I'd like patches 1-3 to be queued up into a branch that gets pulled into
> the block tree.  I'll then take patches 4-7 through the fscrypt tree,
> also for 6.15.  If I end up with too many merge conflicts by trying to
> take patches 5-7 (given that this is a cross-subsystem feature), my
> fallback plan will be to wait until 6.16 to land patches 5-7, when they
> will finally be unblocked by the block patches having landed.
>
> Changed in v11:
>   - Rebased onto v6.14-rc1.  Dropped the patches that were upstreamed in
>     6.14, and put the block patches first in the series again.
>   - Significantly cleaned up the patch "soc: qcom: ice: add HWKM support
>     to the ICE driver".  Some of the notable changes were dropping the
>     unnecessary support for HWKM v1, and replacing qcom_ice_using_hwkm()
>     with qcom_ice_get_supported_key_type().
>   - Consistently used and documented the EBADMSG error code for invalid
>     hardware-wrapped keys.
>   - Other minor cleanups.
>

Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org> # sm8650

