Return-Path: <linux-fscrypt+bounces-315-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D18D909114
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Jun 2024 19:09:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CAB01C208C2
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Jun 2024 17:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 358ED19AA41;
	Fri, 14 Jun 2024 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="t9DbYtCD"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A848197A8A;
	Fri, 14 Jun 2024 17:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718384937; cv=none; b=D8UD3wvIYN5c+mPPpftrj3i6H/A0qBbdYPirthOpoQb2ca98pfdQ6iJm+/lyxB1CNlOUdxEhXzKiqw9/cNMHSVPsadQQVRx70c9vCnb+GUnspw5xBaLPmCMuJAHOaDjHbr/NVZ40MivoF+J/Pc+7hvGBmNDLjQhcgSk7p/LOQ5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718384937; c=relaxed/simple;
	bh=zDgquWL9WTZHVxMSBM55tUA3TUtmDG9t57fELwdqvgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jJqaCFVnnPZnHYztmavir2pf9uRX0nD0gu1FlZVHyKP69pLnM3bHG9dmvt4oworAwBXjj4AVVOrR0yHD+BTwgF3BhbD1vww9iX3aXUpHnFT+piGBKvDru6nw4FLjajS+GBcZ1QUvuYYOhT9DQNltjzD7tb1tGG69sND00Kubj38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=t9DbYtCD; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W15N6712Gz6Cnv3g;
	Fri, 14 Jun 2024 17:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718384931; x=1720976932; bh=KwEa/QCzQe9/zSgXOq1yzUeW
	viOivvbVdURGowWehwk=; b=t9DbYtCDyoG+Tii0ZUizV6fCSWB/JEvzRbKsdOHs
	utxBEeLwTfqk8H2CrukrfkwaN7d/sRRKk8sUprhJmzXDMpojZPDj4bIJshQ2lR+g
	ziBQ15zptcITec0dOxL+k3G2IDBOo10KL0w4R6vRjUz1HEPHdIG9wh3LjDgMtKIL
	eWTsDRhzS3ShLsRiBYk9x4IA+PimGPijaODDGbk6JsFxa77Lv/piTMJ05N11Y+N3
	/HBKmNwhEIu/jTUVoWj7GwJGLABpP1cXUJrV28fV/o3pgMT3tdR2nreqasISDBxS
	abZtt/9qdVXcAYYCtxs6Kg5JwxL981Fck9KjyRmTwomceQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pJSbmmB6srOS; Fri, 14 Jun 2024 17:08:51 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W15N30F7Pz6Cnk98;
	Fri, 14 Jun 2024 17:08:50 +0000 (UTC)
Message-ID: <4dfd06ba-7d95-435b-95e1-e864a33447b9@acm.org>
Date: Fri, 14 Jun 2024 10:08:49 -0700
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] scsi: ufs: exynos: Add support for Flash Memory
 Protector (FMP)
To: Eric Biggers <ebiggers@kernel.org>, linux-scsi@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Peter Griffin <peter.griffin@linaro.org>,
 =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>,
 William McVicker <willmcvicker@google.com>
References: <20240611223419.239466-1-ebiggers@kernel.org>
 <20240611223419.239466-7-ebiggers@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240611223419.239466-7-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/24 3:34 PM, Eric Biggers wrote:
> +#define FMP_DATA_UNIT_SIZE	SZ_4K

A Samsung employee told me that the Exynos encryption data unit size is configurable
and also that it is set by the following code:

	hci_writel(ufs, PRDT_SET_SIZE(12), HCI_TXPRDT_ENTRY_SIZE);
	hci_writel(ufs, PRDT_SET_SIZE(12), HCI_RXPRDT_ENTRY_SIZE);

How about introducing a new macro that represents the TX PRDT entry size, the RX PRDT
entry size and the encryption data unit size?

Thanks,

Bart.

