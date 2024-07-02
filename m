Return-Path: <linux-fscrypt+bounces-326-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E11F0924B5B
	for <lists+linux-fscrypt@lfdr.de>; Wed,  3 Jul 2024 00:15:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B2181F23463
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 22:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4910C191F61;
	Tue,  2 Jul 2024 22:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="U2GuGzV7"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851B26A342;
	Tue,  2 Jul 2024 22:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957977; cv=none; b=I+QvWXmW5Y6siUsKMLbuI5Xh6b7J/O+nQvdrW8BDyEHck3hYDMaEzx2cIc9Oi2otP9XVlm2NzpBd8gYUg8/3knlJ0YOlAimdSEEcDkrSlXvRKl9Nak4P4K22sK5/crsbjwm7NiseDinaR5aK862Ogy7hVk5C6Y3yYL8E7XZvwMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957977; c=relaxed/simple;
	bh=yoMDGGwqTVXI17wNYQaDCOxxPTHrbhvRwcACZIYsh6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CzGDhlroWW8klMG4IEXFjbGZ2bCxkKYtlhXeXN+lRvIBldj5jqXowX0zcqcMyVKQbX6hFBycqQUtCjaLsXR7EJ026oJnjMSMg9CigeVLOs3mQONsqpm47FGm9o3XjXnSRtDchpfGtWkx2XjH+as+mMkN9Hp0J+0LLiKH/5wAAnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=U2GuGzV7; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WDH6t6vNjz6CmR07;
	Tue,  2 Jul 2024 22:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719957969; x=1722549970; bh=53t/1vaV5VWoDO4McN2tJQwG
	rleSCJWNTeOAz3dTpvQ=; b=U2GuGzV7ph5Uhf5iOniPYc3AnB6b4HupvSMX/r7F
	ecf6TyvDtMXcC5qOwe6UOird18nb9rQiNisOMgYfWtP2+93fRKVdfH2wAI8iuqvS
	Lbh8pqbK/YEzpG6oL223IB8JgnU0QJw+BRYugu2M4iAi3M826+bs6eqhcn4tB5VY
	oyn7jO+as2hFNYfULz6miH9RVa5MbLNZt8hmoO3XuEoUyYFk86wG03YUTq7OQU89
	L7zSHQoFUcdToLsPnIQ+HiluPB+L0N9j513N+A9RoR9wUIOc50viOk1olD04TVVp
	A1tQadu/fEcBdNNW59P3LwE2/MlsiCPj5grplPA8HztmGw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RvjfZ_96gQmZ; Tue,  2 Jul 2024 22:06:09 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WDH6m5zTyz6Cnv3Q;
	Tue,  2 Jul 2024 22:06:08 +0000 (UTC)
Message-ID: <97452445-2db8-4c78-a410-ec8b34e56148@acm.org>
Date: Tue, 2 Jul 2024 15:06:08 -0700
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] scsi: ufs: exynos: Add support for Flash Memory
 Protector (FMP)
To: Eric Biggers <ebiggers@kernel.org>, linux-scsi@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Peter Griffin <peter.griffin@linaro.org>,
 =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>,
 William McVicker <willmcvicker@google.com>
References: <20240702072510.248272-1-ebiggers@kernel.org>
 <20240702072510.248272-7-ebiggers@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240702072510.248272-7-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/24 12:25 AM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add support for Flash Memory Protector (FMP), which is the inline
> encryption hardware on Exynos and Exynos-based SoCs.
> 
> Specifically, add support for the "traditional FMP mode" that works on
> many Exynos-based SoCs including gs101.  This is the mode that uses
> "software keys" and is compatible with the upstream kernel's existing
> inline encryption framework in the block and filesystem layers.  I plan
> to add support for the wrapped key support on gs101 at a later time.
> 
> Tested on gs101 (specifically Pixel 6) by running the 'encrypt' group of
> xfstests on a filesystem mounted with the 'inlinecrypt' mount option.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   drivers/ufs/host/ufs-exynos.c | 228 +++++++++++++++++++++++++++++++++-
>   1 file changed, 222 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
> index 88d125d1ee3c..dd545ef7c361 100644
> --- a/drivers/ufs/host/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -6,10 +6,13 @@
>    * Author: Seungwon Jeon  <essuuj@gmail.com>
>    * Author: Alim Akhtar <alim.akhtar@samsung.com>
>    *
>    */
>   
> +#include <asm/unaligned.h>
> +#include <crypto/aes.h>
> +#include <linux/arm-smccc.h>
>   #include <linux/clk.h>
>   #include <linux/delay.h>
>   #include <linux/module.h>
>   #include <linux/of.h>
>   #include <linux/of_address.h>
> @@ -23,16 +26,18 @@
>   #include <ufs/ufshci.h>
>   #include <ufs/unipro.h>
>   
>   #include "ufs-exynos.h"
>   
> +#define DATA_UNIT_SIZE		4096
> +#define LOG2_DATA_UNIT_SIZE	12

If this series has to be reposted, please consider changing "12" into
"ilog2(DATA_UNIT_SIZE)". I think that the ilog2() macro generates a
constant expression if its argument is a constant.

In case it wouldn't be clear, I'm fine with this patch with or without
that change.

Thanks,

Bart.


