Return-Path: <linux-fscrypt+bounces-677-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C74F0AE89D9
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jun 2025 18:31:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C9B9177C1A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jun 2025 16:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7409E2D5C77;
	Wed, 25 Jun 2025 16:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="snHTUn8v"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730F92D321A;
	Wed, 25 Jun 2025 16:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.207.212.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869084; cv=none; b=dNghOEJpW0dF7SMuICok794K9/d3bHS+6IkxuUvxDaSjHQFowW9Qpu5qaOYL/aQhKsR1VWfJ4xIVjFcbjmqtvQwmGPhB3spE1XOia3cKLY7oVeHZiGp0/EZYm36eLuYvGAMpDfMFmK2UjBtwW9X4KJRPqD9OgPDIWa3aUU/QWbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869084; c=relaxed/simple;
	bh=Zj0315h1+Ugs/regjOq5i5dG08rRrPa2Cmoyc3sj6SU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WWurkyqeuC934uhqmdun4PCPdL8rCPrUn3yuaYv7r1TkLl5FJ0n5kUKIjPzsLdedKKPIee/pgWLglhryhoIoO/XH9SSQ2G1UIMGc5sCl61FjDSBHkycjnEJU3qDfqHyDwm+Amtxjo2jFrSQSwqpzuVe7uiRMnRUf3pJcCZotylE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=snHTUn8v; arc=none smtp.client-ip=91.207.212.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55PFvITO009480;
	Wed, 25 Jun 2025 18:30:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	Ar5cY3eqwri9AVFjIOQsbTDZ2wnQ244y0/ufHL/uq/A=; b=snHTUn8v8zy4BnVf
	bkKsMzALzX/hWB50aMj4MxIHi4bX+SsAYGY3Ta0qS9W+Qov86Hf3IFmC6wwbjXKe
	z+7twjq4QjRMRhSZLUxgBzx2nUR3tozW2d6dCqKxErksVbCQU6VU/JiwQwzNDwcn
	U/1p4bdqn33j4ByolMt6WwqjLdE3h61JA8R5yccQhLkGEskbTqOvCPUA7/8p3XmS
	3qkplYuF9MJHqCdFCqu0QAWkYnOvwX3wSSg4FJ6n+6+HrXVAi9jrPcnDQBoDD8cW
	6WJ6dlJDiRbtJNS8vh0xlq+UK3j8XGCWgrXg1kalJWT759R+wTleuCh44x8N8dF3
	PYWGSA==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 47dkmjtf7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Jun 2025 18:30:47 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 5E1194002D;
	Wed, 25 Jun 2025 18:29:58 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node3.st.com [10.75.129.71])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id DD36CBF53B0;
	Wed, 25 Jun 2025 18:29:23 +0200 (CEST)
Received: from [10.48.86.103] (10.48.86.103) by SHFDAG1NODE3.st.com
 (10.75.129.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 25 Jun
 2025 18:29:23 +0200
Message-ID: <c1671c5e-d824-4131-861e-470d09371e05@foss.st.com>
Date: Wed, 25 Jun 2025 18:29:17 +0200
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
To: Eric Biggers <ebiggers@kernel.org>
CC: <linux-fscrypt@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
        <ceph-devel@vger.kernel.org>
References: <20250611205859.80819-1-ebiggers@kernel.org>
 <8f4c2f36-71af-4c84-bcee-2554cea991d0@foss.st.com>
 <20250613144239.GA1287@sol>
Content-Language: en-US
From: Maxime MERE <maxime.mere@foss.st.com>
In-Reply-To: <20250613144239.GA1287@sol>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE3.st.com
 (10.75.129.71)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_05,2025-06-25_01,2025-03-28_01



On 6/13/25 16:42, Eric Biggers wrote:
> Honestly, the responses to this thread so far have made it even more clear that
> this patch is the right decision.

The chaining system I previously presented is just an example intended 
to demonstrate the value of hardware drivers in the context of ST platforms.

The key point is that our hardware IP allows us to securely embed 
encryption keys directly in hardware, making sure they are never visible 
or accessible from Linux, which runs in a non-secure environment. Our 
software architectures rely on a Secure OS running in parallel with 
Linux, similar to what is done on Android. This Secure OS is responsible 
for sensitive cryptographic operations.

This Secure OS can manages the keys with a dedicated hardware peripheral 
(SAES). The Linux side never sees the keys directly. Instead, the Secure 
OS prepares the keys and shares them securely with the cryptographic 
engine (CRYP) through a dedicated hardware bus.

This architecture improves security boundary: keys isolated from the 
non-secure Linux environment. But decryption can be processed by the 
linux kernel.

In addition, ST’s hardware crypto peripherals come with built-in 
protections against side-channel attacks and have been certified with 
SESIP and PSA level 3 security assurance, providing a level of security 
difficult to achieve with software alone.

Regarding robustness and maintenance, ST ensures regular updates of its 
drivers and can fix any reported bugs. We have conducted internal tests 
with dm-crypt that demonstrate the proper functioning of these drivers 
for this type of application.

Maxime

