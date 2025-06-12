Return-Path: <linux-fscrypt+bounces-662-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F65EAD647F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Jun 2025 02:28:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 642E817ADD0
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Jun 2025 00:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD08E11CA0;
	Thu, 12 Jun 2025 00:28:51 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897AA17BD9;
	Thu, 12 Jun 2025 00:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.187.169.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749688131; cv=none; b=DpYFgWxS4T3FKbzLkzCyQrS4n2YbNDE+vxYc6Sm28UbC6VFHPpPzoQs5Tfv5U3EqmnZwYg9DGbCb1h+TMSW8/0Y0qJXZQSLmUkwAFGrkgNkvNInLZhEDXgN6/DQMl0S0fFmbG9A5TCM71kYa9HXg02daB/6JUFPtyfaJv/aUBaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749688131; c=relaxed/simple;
	bh=10Ny718cs6wTvWxt7/tFucUabFRVIP8QvQckf3AJQss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QGNq+FnLM8psxVPqJpCu1MJRcYWD6Dw7FgmsgJ3+yWFCAMvrLGZgb+2heOHAyQKDJJ55NaNBWDf2E5UeGd01GyqKAofUaGxfHZVmkkXRzFB2fhc1BUBvzO8Lbg5VkRVLFeim+6BgYMJd6/ZFqMCIHBpOdrAvRlFXcKyJtft4AHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de; spf=pass smtp.mailfrom=hogyros.de; arc=none smtp.client-ip=185.187.169.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hogyros.de
Received: from [IPV6:2400:2410:b120:f200:a1f3:73da:3a04:160d] (unknown [IPv6:2400:2410:b120:f200:a1f3:73da:3a04:160d])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by psionic.psi5.com (Postfix) with ESMTPSA id 6EA343F1E0;
	Thu, 12 Jun 2025 02:21:29 +0200 (CEST)
Message-ID: <7f63be76-289b-4a99-b802-afd72e0512b8@hogyros.de>
Date: Thu, 12 Jun 2025 09:21:26 +0900
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
To: Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, ceph-devel@vger.kernel.org
References: <20250611205859.80819-1-ebiggers@kernel.org>
Content-Language: en-US
From: Simon Richter <Simon.Richter@hogyros.de>
In-Reply-To: <20250611205859.80819-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 6/12/25 05:58, Eric Biggers wrote:

> But
> otherwise this style of hardware offload is basically obsolete and has
> been superseded by hardware-accelerated crypto instructions directly on
> the CPU as well as inline storage encryption (UFS/eMMC).

For desktop, yes, but embedded still has quite a few of these, for 
example the STM32 crypto offload engine, and I expect quite a few FPGA 
based implementations exist, so this would require vendors to maintain a 
fork to keep their out-of-tree drivers functional when updating the kernel.

POWER also has an asynchronous offload engine with AES, SHA and gzip 
support, these are significantly faster than the CPU.

If a buggy engine passes self-test, can this simply be fixed by adding 
more tests? :>

    Simon

