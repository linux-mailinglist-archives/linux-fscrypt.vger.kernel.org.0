Return-Path: <linux-fscrypt+bounces-331-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A460F929FF1
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 12:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BAB31F245AF
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 10:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E42B97603A;
	Mon,  8 Jul 2024 10:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hGBA/mAh"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D86446B4
	for <linux-fscrypt@vger.kernel.org>; Mon,  8 Jul 2024 10:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720433587; cv=none; b=Knku2cW7ErYQVAV8zd2f36x6ODsJZ1Umbf1FDMvww8xO9UkjGt7JXj6rX+HIRGzWmjRqMMYx0ic6HzlXQoSvdeDQgecEzbNvT1LYs0bh0XmxBABpOpigDZl7dOHEbmMN5QSTHzx4WX0YxX4+qT2GsfbqWIVZls7X3SDv39EegHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720433587; c=relaxed/simple;
	bh=2RmdxV+3VSNyvZhEEgpIWbdydLkzqKnXJBVxNC6Ml3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R11Myof+MlC/F1y9Woo3b0jBreniB2kWelc2YRIN9WxVtMMbAmDXpgrKf0tOGmtF6M+X7lDvbE/ewNPHk4lVkl8SF00OtQDbHFEd7+o6pBQ2jL51J35sZZxE1Epc3rVstWzs7Q0ttGa89AyA5Q5ZmRU9btM7/q1+aQ3tJ27hOSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hGBA/mAh; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5c229aa4d35so1847668eaf.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 08 Jul 2024 03:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720433585; x=1721038385; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NynB88z8W6QEiHA6gsmDf2tTIxeEI7sjADoAf98ZwG8=;
        b=hGBA/mAhUJsOR8FxfY9p67HU1zm2G8Pqq5jkJJlEUDbLS3FO9VNmnsXcMh45DczdyR
         Zo1ckDCcYiDVt+YLl1hjlgKYBFBnYhA6aQdio+/65/gYn4QDd1fOO2X2PpiHOUud1ebH
         qdZKnppYRMmNm/0FmEtzEq781Srt61tdrv2COra9Ti9TyUfLxddtuP9JAlmFfu1B9EOa
         HvSD9pKtUYubdg1yULJ5LzHcnJ3WvcIC+7xCOHwXjtcY6g8qHhB3k8zZN8JiZYDVNzNL
         s30cdkH0x12wZm0N51KqC2yUpuioSwLo9xqoKAtVuW7n35gcKlo4Or/4ZAWdssHgN02z
         8C0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720433585; x=1721038385;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NynB88z8W6QEiHA6gsmDf2tTIxeEI7sjADoAf98ZwG8=;
        b=sVr7sWsC9J5MAiHkEPpt5v2PO3AptxWq9pIjk1aB9BzhyBVyAvNoV1MAyojF025wB8
         +Xu+cgVly5HzuwN8bW8FJ880FL/QVObjJRhYSghe/6sA8TCYkOmTrPX+PYR0roC3Y0Bf
         jNYn6DPTA02ZbXP/BmLELD7YsywVW0wPfUJy1IEdfTJHFKBQaUM9FkBuG86QL5lmffxR
         dmhaSYjTc5hraubv4eBuofxwFz2BscfY0+LiJgH7nSAMxoNe9p4pHAOx3fPaXmC9K1jY
         kqlF4eApFpveoxN0i+yve9QFL1p7RkNQ6Ao+OFcfKu67FmwmRqSgKbgxwEP8qWD2kx/y
         bYTw==
X-Forwarded-Encrypted: i=1; AJvYcCW4KvfJDmuHHDz6OKFWL9YUhSS4utFT4APHPgI3p+go+2LCtIPuEJqO6CketyEBRiaIa1fxhP2Xf12fKbbYneDXMdW9sFNwtEIunCYHmQ==
X-Gm-Message-State: AOJu0YxRiPMk6c16Ir7c/C8PD7lv9MhWJu6ansB2k0sIK2uJUzffHHBa
	flMZ6vwxwM9He5AxzZhXq87o+uo1PwRHLKcH9w6ov1WQbX+OEUOWgxv5mDL8Bj3esvP+gT/ST5K
	IEqqzU3lT3HprPpYMNBrWeWx3m2KcCOIfdOzPK1XpSmNIvw+snpg=
X-Google-Smtp-Source: AGHT+IGivyDRrIsg9lng9e/JVVkngxmkaCgNcGy0evjFYNtJazKIxfyqs/mZGknAEQ9yczSNL2j+NXR7PUtpSN+8eKE=
X-Received: by 2002:a4a:5404:0:b0:5c4:57b6:ffbf with SMTP id
 006d021491bc7-5c646cda66dmr9779604eaf.0.1720433585464; Mon, 08 Jul 2024
 03:13:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240702072510.248272-1-ebiggers@kernel.org> <20240702072510.248272-5-ebiggers@kernel.org>
In-Reply-To: <20240702072510.248272-5-ebiggers@kernel.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Mon, 8 Jul 2024 11:12:54 +0100
Message-ID: <CADrjBPqXOJ6h+Vx9tUgvC7fGPPySzZDA+M80rEDBsqBHEMsCqg@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] scsi: ufs: core: Add fill_crypto_prdt variant op
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
	William McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Tue, 2 Jul 2024 at 08:28, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add a variant op to allow host drivers to initialize nonstandard
> crypto-related fields in the PRDT.  This is needed to support inline
> encryption on the "Exynos" UFS controller.
>
> Note that this will be used together with the support for overriding the
> PRDT entry size that was already added by commit ada1e653a5ea ("scsi:
> ufs: core: Allow UFS host drivers to override the sg entry size").
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Reviewed-by:  Peter Griffin <peter.griffin@linaro.org>

[..]

regards,

Peter

