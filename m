Return-Path: <linux-fscrypt+bounces-646-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9E7A80B15
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Apr 2025 15:12:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EE1F1BC2416
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Apr 2025 13:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0583279321;
	Tue,  8 Apr 2025 12:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XlmfdtPt"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1468B27816E
	for <linux-fscrypt@vger.kernel.org>; Tue,  8 Apr 2025 12:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116901; cv=none; b=BX2qM+hM0LpQXeSVZU8Gou1YJ6bjAEpnOI0OJnQLBzOtTUFGG+LcDQ2Hw9y+Qf72dFMTvkb+VnSuOgqLaHuTdWQt6JUFNuyg7Uo6KQGtfe//tE8LjgA+3uKrrQW69+6w8kb1ouWK0AV+V58pnki4OLCmiOHok7GyplCobbtKgJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116901; c=relaxed/simple;
	bh=r4MPn5KxjvOr4Rq45HUgATPOr8OD0EgPiS0EyQ/17RI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B4DRYb+ZscKGrmUFkyuzKReNiqifAqcbWX9EijYwjnxqi6/v5EklWb7Q4Udik6j8dXWZ+pFXVAy0fp0FFm5RJ/O8WTXxSQxPfTLB08Mg7vLpeFzOD/l3KhJ3D7DCDmvDDaJ0g1Gn4c/eWjrdcN2xudTxeK9lNthinPw1+YScrwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XlmfdtPt; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6ef60e500d7so45034107b3.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 08 Apr 2025 05:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744116898; x=1744721698; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yk0jmNlqMc02tYB39edyin8JE2b7A3WmTNlfw1td2zw=;
        b=XlmfdtPteNtmxLSaAFDZCgyC0gXBE4Q6LOV+ivJ5FKCJZuURNljXMOOq26YNmJliFy
         Rszwth1hXnyLQx4yb9DhsErl4BweF5LI0V2BFbMpZTFiNjt2uY7YoxLfubbn9Wbpt+zg
         hI1KGrIWi6VqA739abL87CzgvsNKJ1nDbOTMC9E2k7uKW41zkimJCDDHCodwP+zxROi2
         hmg5lobOjZCjRQxMxGHD0qthbkQLznjRwWR1aIzkuNsCXygex5jezvYjQb5fDcuibkAF
         uwPJVU5v0TafnLjbSk/C9IGm0JVbGdidheF3z6TF27NeuNNqHqdLQN1Bx1+kbi/gKOCY
         L8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744116898; x=1744721698;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yk0jmNlqMc02tYB39edyin8JE2b7A3WmTNlfw1td2zw=;
        b=MTa4/pbJS3wRnY8elD1mjtz5nkDzTJqQKPpk381MjLdsgCPZzlV9+Jam8L1oxq2a1R
         wu8aCxQtNhXjA7XErE1aynIIU6yBbMkuVORmP8hk9gX9i5hPrfBfgMtF5AV4mF9GdgtL
         xqNlHbbhdpx1AWr0Z8ohUpvXcGiVtqxqoEQDY9bpy7mjk8IRXQpREBQjh9+fQ96nyext
         JdiZhgo5E9WvEKfZ0u0k+HzGePF4SqaefwZgW/0TfFYBpW8Oa7nWFZ+MG1DTDhi2UVXf
         ADx/M9ssmNbsHZ31TjcZ0YMAKBtZ3NJQFFuy85U1WHxuwHQTVnTYPOVT8kBPf6Bbqe3K
         kNyA==
X-Forwarded-Encrypted: i=1; AJvYcCWWms3hNOPCX9aekzC4sldvfGM/CZKcmdd3NnUidIY47BgUmLeDKB8xsCdjzFyoVdguHCD0hX88R+R0MTVD@vger.kernel.org
X-Gm-Message-State: AOJu0YwBSn2gou5/J+yTwElVopulcvYHgObeDTXNXgl+OKYdc1ngzzlV
	J26tuA8LAGG8E1D0yDl7+AtydzPowCWZWGeBcpuatWjN5bejefMGZbnZsahhLgwFsr0uRM/4+/T
	FIvL8gBXarxrTJu2k8FbPQn5Raa5kxJtKtpSV5Q==
X-Gm-Gg: ASbGncvImRbCx99gEENodQJoW76jTVgZZ2czTM/q5WeYbCnxRhXujfebG5QFHe34dFD
	uRqLEC35zlHnEynqE7hAVGXaaUx+oCO9kHiwQtlwvn2Ttmiz+JJO7LrmNHRF/pIOi2yyv9lDzrR
	Sww4PJtjPAQSQ5MB2teOjjzd+OCHg=
X-Google-Smtp-Source: AGHT+IHTxHBd425yatfvjSy7aWzx/QfcCVYH5495z1ua7eNtDp8zPmcN+TAK9mP9YSF4OzEsmd0vPSFHANuJwlrpgWw=
X-Received: by 2002:a05:690c:a84:b0:6f9:9d40:35cb with SMTP id
 00721157ae682-703f41267b0mr224639557b3.6.1744116898053; Tue, 08 Apr 2025
 05:54:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250404231533.174419-1-ebiggers@kernel.org>
In-Reply-To: <20250404231533.174419-1-ebiggers@kernel.org>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 8 Apr 2025 14:54:21 +0200
X-Gm-Features: ATxdqUF-OlOdEIxCE1qPuhQhC_jv3bjWDPwF3BCWGXm2DWhZIQfUgr8SjCy-Un8
Message-ID: <CAPDyKFqmgUUWOmH-r20VSfNZW7KC4RX4BTobGHf5F3uuLZtj0A@mail.gmail.com>
Subject: Re: [PATCH v13 0/3] Support for wrapped inline encryption keys on
 Qualcomm SoCs
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	Bartosz Golaszewski <brgl@bgdev.pl>, Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
	Bjorn Andersson <andersson@kernel.org>, Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Jens Axboe <axboe@kernel.dk>, Konrad Dybcio <konradybcio@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 5 Apr 2025 at 01:16, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Add support for hardware-wrapped inline encryption keys to the Qualcomm
> ICE (Inline Crypto Engine) and UFS (Universal Flash Storage) drivers.
>
> I'd like these patches to be taken through the scsi tree for 6.16.
> But the Qualcomm / msm tree would be okay too if that is preferred.
>
> The block layer framework for this feature was merged in 6.15; refer to
> the "Hardware-wrapped keys" section of
> Documentation/block/inline-encryption.rst.  This patchset wires it up
> for the newer Qualcomm SoCs, such as SM8650, which have a HWKM (Hardware
> Key Manager) and support the SCM calls needed to easily use it.
>
> Tested on the SM8650 HDK with xfstests, specifically generic/368 and
> generic/369, in combination with the required fscrypt patch
> https://lore.kernel.org/r/20250404225859.172344-1-ebiggers@kernel.org
> which I plan to apply separately.
>
> Changed in v13:
>    - Rebased onto latest upstream
>    - Resent just the remaining driver patches
>
> For changes in v12 and earlier, see
> https://lore.kernel.org/r/20250210202336.349924-1-ebiggers@kernel.org
>
> Eric Biggers (2):
>   soc: qcom: ice: make qcom_ice_program_key() take struct blk_crypto_key
>   ufs: qcom: add support for wrapped keys
>
> Gaurav Kashyap (1):
>   soc: qcom: ice: add HWKM support to the ICE driver
>
>  drivers/mmc/host/sdhci-msm.c |  16 +-
>  drivers/soc/qcom/ice.c       | 350 ++++++++++++++++++++++++++++++++---
>  drivers/ufs/host/ufs-qcom.c  |  57 ++++--
>  include/soc/qcom/ice.h       |  34 ++--
>  4 files changed, 396 insertions(+), 61 deletions(-)
>

For the series and MMC parts:

Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC

Kind regards
Uffe

