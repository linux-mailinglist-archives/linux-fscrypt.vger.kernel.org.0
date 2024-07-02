Return-Path: <linux-fscrypt+bounces-327-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C93F7924B5D
	for <lists+linux-fscrypt@lfdr.de>; Wed,  3 Jul 2024 00:15:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73ABC1F23DE0
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 22:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FFBC17DA15;
	Tue,  2 Jul 2024 22:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hSy4/ML5"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04CD191F6C;
	Tue,  2 Jul 2024 22:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719958010; cv=none; b=POJXkbS/19kYv7Z0B44HQhMZNEYCBVt2mvv/gLOn02wOjofgLowQcK+9DBKawjRiX4ph/omZm0rM/cdUt9L2UVHcy/TqtiG+qO3nRZNisIJqvYENMZ5Atuo8LcjN/Xp3V+aPwF6FY3hsJAshFv6YA3/18v89YS1WNTrMxubs/qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719958010; c=relaxed/simple;
	bh=j9hnxaL841XudYvilwEk38JXwKZgG9J/FfmxI79LAEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=el9Mwv4/TJJ8mtSAXcIhdoMn1AO97m7XNprkwCiogYBiVbdze2g206Ikktvdrq9g7SbjibKSxIgIZsuszfD9kkSLUY5aoNatsSJYJ/DsYVYyQ5MYmpjKmuQUkaKoir53NNmj5U4zQXzFDAMcssIkdCDOkvL5lFCfMTPztfxdisg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hSy4/ML5; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDH7X2NZxzlnQkj;
	Tue,  2 Jul 2024 22:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719958005; x=1722550006; bh=8HA5lduqBcxnJD/PUY/OFsBA
	QvT5VaYw8AuGYseB1h0=; b=hSy4/ML5rNLai6Kibcqihg1AanecDQ2gb7Fu/Pyx
	H/ZOuk3QZyMMja0B/y+4y+SLNJRVXdjEyB3eR/QCLTB5gXLdKDi11WgWX3ZYuUHk
	yz8XVIPUVfuNT05EIkB3e1TvUAkj48td5enRoMal8rJQGTkCPKAabZhdMFXi9Ir3
	evylLo0uHJCCanF9ZyQScdxOQyZ5389/cFJjywPoLb+n/yW2yxk2K5oPxdntb+oj
	cFDC5Y0RHZ9XjW27+Xl0arjXlJTtiLdZiI6hvnzX3sHM+g4PBKHZHwveygRk3AY8
	eqHblerKVx6qt2kRyUBv8NZQF2SFo1jJfL3Yd21HNogLWw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DVhAqn_S5oEi; Tue,  2 Jul 2024 22:06:45 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDH7S2zZfzlnRR8;
	Tue,  2 Jul 2024 22:06:44 +0000 (UTC)
Message-ID: <f9e3fd94-5519-4c4e-959a-644c22064a48@acm.org>
Date: Tue, 2 Jul 2024 15:06:43 -0700
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/6] Basic inline encryption support for ufs-exynos
To: Eric Biggers <ebiggers@kernel.org>, linux-scsi@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Peter Griffin <peter.griffin@linaro.org>,
 =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>,
 William McVicker <willmcvicker@google.com>
References: <20240702072510.248272-1-ebiggers@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240702072510.248272-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/24 12:25 AM, Eric Biggers wrote:
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
> This patchset applies to v6.10-rc6, and it has no prerequisites that
> aren't already upstream.

For the entire series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

