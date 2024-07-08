Return-Path: <linux-fscrypt+bounces-330-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC4E929FD8
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 12:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 857251F21D93
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 10:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD01413ACC;
	Mon,  8 Jul 2024 10:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dK/6uR6G"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6B8770FE
	for <linux-fscrypt@vger.kernel.org>; Mon,  8 Jul 2024 10:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720433198; cv=none; b=lMvA6vWxPU13eLmlJBpREUpbldxjI/cu80jWvMVh/tKK8+K3h20qmJhDibTBkwxVSZtOD2qcLhE9ZwYhLfq+peN4VKQC8lqitezeIxL6tdGFupApn6/LwK7aEU2eMyHwKhm9LS7XEGX0q9VaIyR+7u2QYwK6OoXyaIhfNaRPIHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720433198; c=relaxed/simple;
	bh=P7OaU1ezIgpW6/4WHytXBtMimP58RhF0QQzrz4kizWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k8IDZiYRD5oAa9Y6KwuKdMKwQMWOipoAUP/tVB6A6hXmtWiVkU6onssKGA8PKLJnzsbyQn2eU9rDLkee31TgtbPmqLPYUb5FgdiAy/Puk/6XTqaoqDd87bYdtavpkRM8AxqHtBSqnRp8foERv2A5UB0ZAYZYQjtDNTL8OaOkDQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dK/6uR6G; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-25d6dd59170so1652038fac.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 08 Jul 2024 03:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720433196; x=1721037996; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qWX5Q5O5NiALQ1tJK5ppQuf8O8WFA9Gn/tOulONtFsw=;
        b=dK/6uR6GigwEiu8Jg+E+PwJtnzceh+Yf8HPkKqDUSTE83sabD9HqcI0Yx1dG8yB0Im
         FYdldXPEadysLEm9nsYjE44BA/XMfJ9C3NlZ5bw49QVt6pHozjHgExATuYb69weKk6OZ
         yzOaf6FUWJEsVBaQjQ3KmqEZX8mN0KMCT53fx31CnScoW1hEYmAsGKiWnkwqs0Qq5+g5
         zkvfqqg7C3krJeugC/P2ga0NHzXO5AyVnk+oYJhAtDmI+oGLhuXL2lsNNawMJ5ChrUGg
         9SaD/IqnUNEiEd9oWGTX5ckAdSKFVDqSLePZ5iw2j+aw6TuE0SJSlp6f/5ETmuH+NA0z
         la0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720433196; x=1721037996;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qWX5Q5O5NiALQ1tJK5ppQuf8O8WFA9Gn/tOulONtFsw=;
        b=c1Og6bt88TBlZuu3CTeMGKYZfo+DrLHbbJOo9bhDi6vqIwe61rHfTTcRoC/OVV4SbW
         1UnAdg8sCORAT8s/KacP3x7E/c+w0uraEiXdalAa5TWkKhgwNsnuCECaYaTCJV0QVnZE
         aWvS0zLhtH/+vLPB1+NYRzBSvAyj+xTo/bZpFn3orj5sQBojNXCtHLAIV8iOwIMGmypd
         1DiMToU2GxxZVUbERhdp2QEnCdrhDuJGZNEtFej2iLi/xt+y4NLHkZ9HnjRQb1a2iPQP
         73yvslVelzyDIa769GH0GAYYdAdR9EIFWtwyg5AYmOf/oLwu7jI0xq+N3zQ7qGivcBxY
         ZTzA==
X-Forwarded-Encrypted: i=1; AJvYcCU830pRLnlEHnJ8vDJkj3enNhDpkEXJJZSlFn7JCFt5oSxrdbun2wBaCtGsWnFIj4cAfYO3cmRRYUFArqZT4vgsoLBgsZteoV2G0y1+VA==
X-Gm-Message-State: AOJu0YxQUaXnGGg9MrLRKIsPTObM+C1vPFeiKp5LTwi2eoSEmPjP+1aN
	yF9++TRpQj2u784X+RVtHnOKAHstO5z27m/7WuO0Hy65wFDG6A40vqxfLJQQIPzNond13p+1TKD
	8CcrcMsVoKwu7OBFaUqh3dfXTQSWljFBvSToFEA==
X-Google-Smtp-Source: AGHT+IEgQYbQmWGrt9fgyJiO0ChAtyKfDdrUCIsSNJAN0RS6Om+uFgWmAgNurVJ6JWmy+EN9h5OUoOAEjttb3PLpzLI=
X-Received: by 2002:a05:6871:798e:b0:25e:1551:a2ec with SMTP id
 586e51a60fabf-25e2b9ea912mr7049472fac.3.1720433196248; Mon, 08 Jul 2024
 03:06:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240702072510.248272-1-ebiggers@kernel.org> <20240702072510.248272-4-ebiggers@kernel.org>
In-Reply-To: <20240702072510.248272-4-ebiggers@kernel.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Mon, 8 Jul 2024 11:06:25 +0100
Message-ID: <CADrjBPqVXHh1gPxQxuLHej76yWh6imJ9CAe-fFrX84gccc7_-g@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE
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
> Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE which tells the UFS core to not
> use the crypto enable bit defined by the UFS specification.  This is
> needed to support inline encryption on the "Exynos" UFS controller.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Reviewed-by:  Peter Griffin <peter.griffin@linaro.org>

[..]

regards,

Peter

