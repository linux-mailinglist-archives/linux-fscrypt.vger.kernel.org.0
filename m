Return-Path: <linux-fscrypt+bounces-668-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3AEDAD862F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Jun 2025 11:02:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4167166AC1
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Jun 2025 09:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEC9F239E8B;
	Fri, 13 Jun 2025 09:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="TJC+HIwQ"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5572DA751;
	Fri, 13 Jun 2025 09:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749805362; cv=none; b=l6JbK8Y/Ll3SKku9coQu2ZHVm9FpsmtJcpQ7h/W2EnfNDnBZczZWc3e7uMUZz5uvTbd1Yc9UVT8yFElAw3QxDZJzBhcZUI7LcpirpCA9ystFF67JlpjVnA1AGhd6jURz1SpOf9y9soes4hkTFkFyUEGsqTaJ5QQm4wTLBYdxJQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749805362; c=relaxed/simple;
	bh=Iu6PP0aeFHgxr8x/QF4l4Q7vhV0Xw+zRs3mVruxMCto=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=V5SPWcpiIzSYIqzhJJNwQN8bI4b8ve0jZEiHQb4oWd11ZTLexX49ownCDmQVufK234e6dJzdfxG4kaxLy8aJsYh//mMZ1Cj0maMKozGMemAgYZ9bOwiB9NiznwBdbe2fVKvreXu668q7Py8hPVI8+GBCOq8n4V/dR9huDCr359I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=TJC+HIwQ; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55D7x6wD001805;
	Fri, 13 Jun 2025 11:02:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	dhCZHLOoz/DA9KLk72kzXl6//47HjrLiscmsJROqQU4=; b=TJC+HIwQFnR8RuRE
	wppUKNBTKL3/NwpFH9nE0ngb/rqF9Lu/ileLRgMIYn9UyLjZyEKItkKvekDrpNco
	CH2Ar921nY18Xdl/0P13yXdoS1ZBzpkgQY+25liPF5pVzK8R6E9CTtow/QLDHGU6
	yPdG0oZwXpqhwfLaDOymuGleYwO6An1dIpbs9rOSkv8i7GQoffy8c3UWJ+uMlfvM
	tauK1RzCWrm/luM7ZBmnYOHOabBLRh89Nw6WHyd9Vc/fcI6/JJ5bdV1tgLduLKaj
	fzoB7FPeV6Etip+hdlvBfqPA2PiZJrvr7H+x16QQsMmf1UpyJFlDeSmTAZ3RplPw
	qdJ18Q==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 474ajaktns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Jun 2025 11:02:23 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 8DF594005E;
	Fri, 13 Jun 2025 11:01:37 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node3.st.com [10.75.129.71])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id DA3C7B9447F;
	Fri, 13 Jun 2025 11:01:04 +0200 (CEST)
Received: from [10.48.86.103] (10.48.86.103) by SHFDAG1NODE3.st.com
 (10.75.129.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Jun
 2025 11:01:04 +0200
Message-ID: <8f4c2f36-71af-4c84-bcee-2554cea991d0@foss.st.com>
Date: Fri, 13 Jun 2025 11:01:03 +0200
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
To: Eric Biggers <ebiggers@kernel.org>, <linux-fscrypt@vger.kernel.org>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>, <ceph-devel@vger.kernel.org>
References: <20250611205859.80819-1-ebiggers@kernel.org>
Content-Language: en-US
From: Maxime MERE <maxime.mere@foss.st.com>
In-Reply-To: <20250611205859.80819-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE3.st.com
 (10.75.129.71)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_10,2025-06-12_02,2025-03-28_01

Hello,

On 6/11/25 22:58, Eric Biggers wrote:
> To protect users from these buggy and seemingly unhelpful drivers that I
> have no way of testing, let's make fscrypt not use them.  Unfortunately
> there is no direct support for doing so in the Crypto API, but we can
> achieve something very close to it by disallowing algorithms that have
> ASYNC, ALLOCATES_MEMORY, or KERN_DRIVER_ONLY set.

I agree that software drivers are more efficient and less prone to bugs 
than hardware drivers. However, I would like to highlight the fact that 
certain ST products (the STM32MP2x series) have features that allow the 
loading of a secret key via an internal bus from a Secure OS to the CRYP 
peripheral (usable by the kernel). This enables cryptographic operations 
to be delegated to the non-secure side (the kernel) without exposing the 
key.

If fscrypt no longer supports hardware drivers, then this type of 
functionality could not be used, which I find unfortunate because it is 
something that might interest users.


cheers,

Maxime

