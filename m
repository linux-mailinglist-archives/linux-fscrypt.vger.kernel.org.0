Return-Path: <linux-fscrypt+bounces-358-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3425D939353
	for <lists+linux-fscrypt@lfdr.de>; Mon, 22 Jul 2024 19:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE9B41F21DE3
	for <lists+linux-fscrypt@lfdr.de>; Mon, 22 Jul 2024 17:55:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95F4F16E87A;
	Mon, 22 Jul 2024 17:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lnZ12k2r"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3167C13C;
	Mon, 22 Jul 2024 17:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721670898; cv=none; b=DDRvAt1hWkukyGXh4WBVLS4m2y+ze0Zih+rVOVtYucCvmp/p9xoS+ANHtmpASrcECP/4COlxLdERk2DlmpVTtfR3FkrmHvmHYrOX/G+40+Z372IsDTBzNJ75IlPySiRsYOYszbdhc+Ral/YJLjtTeXx3uuFOPUrnn6CRu+NBgvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721670898; c=relaxed/simple;
	bh=tTFV7zk4wwXKze0dSQKpph7TsFyabr3+7UzKTScePo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bpsZd1acyn8H+VJMQaCkmuB1o/0q0I/iEiQFjwnu0UqZSIABZaBLFnReaO3cH48zgJLXyY8aui2p3r04XZZtAi5Aay5SBs3jx2gtrfBFUfFBv96BH3905G8EaN9tmnTgW4jV7gmW+flqD0xt9Jk+ONVJnRNLnRpvW7YpmLBGstc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lnZ12k2r; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WSSbZ2FZWzlgVnF;
	Mon, 22 Jul 2024 17:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1721670887; x=1724262888; bh=tTFV7zk4wwXKze0dSQKpph7T
	sFyabr3+7UzKTScePo0=; b=lnZ12k2rkRvAez4AiH3xE3EP1D20myHNsJPOMWxX
	8bhLCUrympXW0D/25hUwjMBS7XTiq+8saGCaXctZAL1vx0Xd9vhtC0P8pioP6xU2
	aZxny/I3oZwmXw8nXlH1jlxBG8GokfYqjNVlz/ZZB9EQ/Fn2wJDkc5oggAbjL9Zt
	TAMGTc4Zh112RiMUhcKzBs4PLfJJMBpz2ngMKr7RnlRFKQVddbRDpBtZK3ryMte0
	OqBtzm5OnrSUwllV4h7kq0FBQyvQKLXBgPUduPHPZfFwhLa+QshlaU/TNPKHMQTf
	3DGngkzkSX67yYOpiaG8io9ptq1u3l8sG/hQOZvVUirJxA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1-ZWSxRy_cuE; Mon, 22 Jul 2024 17:54:47 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WSSbT2wYLzlgTGW;
	Mon, 22 Jul 2024 17:54:45 +0000 (UTC)
Message-ID: <8474f605-f92c-4b03-8f41-ed6d35f012a2@acm.org>
Date: Mon, 22 Jul 2024 10:54:43 -0700
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: exynos: Don't resume FMP when crypto support
 disabled
To: Eric Biggers <ebiggers@kernel.org>, linux-scsi@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Peter Griffin <peter.griffin@linaro.org>,
 =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>,
 William McVicker <willmcvicker@google.com>
References: <20240721183840.209284-1-ebiggers@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240721183840.209284-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/24 11:38 AM, Eric Biggers wrote:
> If exynos_ufs_fmp_init() did not enable FMP support, then
> exynos_ufs_fmp_resume() should not execute the FMP-related SMC calls.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

