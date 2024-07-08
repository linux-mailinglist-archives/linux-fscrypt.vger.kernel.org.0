Return-Path: <linux-fscrypt+bounces-329-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C905F929FCB
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 12:02:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 045291C21B0E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 10:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5AFD36134;
	Mon,  8 Jul 2024 10:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Gxny2AqM"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C790340848
	for <linux-fscrypt@vger.kernel.org>; Mon,  8 Jul 2024 10:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720432920; cv=none; b=Laud+q0RdaxcViP1exKeyaludloi7qDWU2gcNYK1mIat3JAIEz3TLZJj4QxKTnLZAMlMpjevk5tdgnWRyyXD7h9rVdkeFZkjQ7AfwEiCznFrLFyANyZMzLmCJrpdJLt9aJX44Cnu04rWvXsxKFooFcu0Ntvdz9CnzgJsFinlmYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720432920; c=relaxed/simple;
	bh=SVihhqPsjw1aby9Mnriupbd1CRSchBT64K5CWP/L6Hk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hlFTRonqZ1yxBKbJnmERCwOmcfTz7jC+aXBhnJPu9Cr52hArTGG8t9SY149awj2Jn4B7wJlcaW3hOgyyWMKsxWVWRWEJMUdEfrPX8lJ07wMglQ+kdMAavwVS79XGIh/woVHy7++bvDXbDn+ApxaPsSFu9nOBxURGf3EwGUckCo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Gxny2AqM; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3d9303ae2f2so527171b6e.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 08 Jul 2024 03:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720432917; x=1721037717; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6qk7Fc3i9dd3OlZuL04X6Rue/WRCbHYH2AlZY6gbT1k=;
        b=Gxny2AqMbwE1d+LxjEoKIm/ybDX9dE1fcvgo710lEpPeUFAr7F0Ak4xAURbzAtKwYB
         PpS7tcT2pBnTI+EeYQGsyw9LcoC9o902B2SHRGDoXSjoPkmWX1siZhXK6j9Fqa3K0ZN4
         RdRUycV42/AOFeaUvTggmcNesWaioRj2pO9Yuek19EmnKkCJlegbIGI96bkeo0EPSetf
         vhOteFXR33w0fDso1UUofW9IfFL5J35zG2QEiaqzTyoyO0WeCNCBUEwrx3qlF4nDQlZ2
         wyIq3KCeD6Uw1+ABjbcczLIgORnPdU3jSbWfrcDYBXm7DBoiuhaj8h/6mbgeu4F3b8YB
         1Tyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720432917; x=1721037717;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6qk7Fc3i9dd3OlZuL04X6Rue/WRCbHYH2AlZY6gbT1k=;
        b=UQfaqkIxfU4l+J2dHYFGzlBZbx7Zq54bqDvLcvYB1i9mCe7Qj8yIIbMucJO/xHQuaa
         7sG7j/VcFaoTvpYqHzmzZunkAAxhHHMt0FtOp164R8V+vrr6uupHxLZqaN13iEdEwjf+
         qmM2ZlCDUgMtHbgdVTvPESVsk5XucWktCnHOQrRMtWCrbL6zNWHRXMG3kuQV33dHy2DV
         ZtlTUteVIM22k6FEWfV7xMx1BZAUWQiqN8t0QWNEIOtzUzwPCY9k+WnIhErvg0/WtCfB
         6w6sDDNHj9bCEj3ScssglnMvudbk676swBbDqd8hwZZXc0jDYZbwPiu6cQahhpKuYlek
         TgwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFWHGETr+/noN92Gq0e6msuQR2K/quKo8wvegI1/yz7hja9B9IjMF/c20/bs+F8RUk9ATo79a54XKIRCqaJrVf4AgmjGGyJ5UrYAlIYQ==
X-Gm-Message-State: AOJu0YyNhUrrS/JrcFlwPj7VXXtIQa8qCMshW29E4vf46h18c97FgePS
	41Ulx1OdXyh5cSAfdHsxxK/By/Aza3bjfrB/7FeIx1Q4pgDMbaI19RRT1Ld2rCa4v7ZWZ99fRRw
	i8fT/fVPknFX2j/BDYeqTvMVNrffJvLuHCXh/aw==
X-Google-Smtp-Source: AGHT+IF3h2FT1NdyCnJBUlwrVg0fkKLI6Bw9BPSqTY3LI5E43LkfcHgkqRxr3+bNUcKY9t3hgY9B887bEbhhWArf5iw=
X-Received: by 2002:a05:6870:2195:b0:25e:24b:e65b with SMTP id
 586e51a60fabf-25e2bec9856mr9419383fac.42.1720432916918; Mon, 08 Jul 2024
 03:01:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240702072510.248272-1-ebiggers@kernel.org> <20240702072510.248272-6-ebiggers@kernel.org>
In-Reply-To: <20240702072510.248272-6-ebiggers@kernel.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Mon, 8 Jul 2024 11:01:45 +0100
Message-ID: <CADrjBPqrdoDzBesV7e=paz4mj3VDnZTynjPYD6kCV=xe9aszbQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] scsi: ufs: core: Add UFSHCD_QUIRK_KEYS_IN_PRDT
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
> Since the nonstandard inline encryption support on Exynos SoCs requires
> that raw cryptographic keys be copied into the PRDT, it is desirable to
> zeroize those keys after each request to keep them from being left in
> memory.  Therefore, add a quirk bit that enables the zeroization.
>
> We could instead do the zeroization unconditionally.  However, using a
> quirk bit avoids adding the zeroization overhead to standard devices.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Reviewed-by:  Peter Griffin <peter.griffin@linaro.org>

[..]

regards,

Peter

