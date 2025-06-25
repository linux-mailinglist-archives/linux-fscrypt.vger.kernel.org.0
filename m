Return-Path: <linux-fscrypt+bounces-678-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B273FAE89E0
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jun 2025 18:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF556177422
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jun 2025 16:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D33EF2BF01C;
	Wed, 25 Jun 2025 16:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b="rh6geYpC"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E0D25BEF6;
	Wed, 25 Jun 2025 16:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.132.182.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869094; cv=none; b=SDhYCqHBzZ06iaqQr6N24LjKRCaA07mdm++kUu4C0v/eLsX0mzVZGrOmuoyGvWPMmNiuCdMNWbsM0KrnqUEVBjYLZ6bcOdfXFE4i42yLtzOkTHZh39I18K60Ipjwa35R1F4ALRRJK+ShCZB9YgdP9Y6STkrEbXJU/blpT1rmkpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869094; c=relaxed/simple;
	bh=XvWjfRUpM6UOkaW2IqYTCT+52cWrOu4ThwISek4k1ro=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=S6GPCgu3rKnfSaQ9Z8b2/cKYAswe73uRXMRYK1kQwZZSmeFfvqVzSPsURrN9BedMG1NVK9Nx0054KTIeZyJyxcoQhrC+dOso+8Yn6WUENIsh4Z7Om3bmoEvRfAdnY60BBDH01brZqkixnoRk7eqGhjXjZOHtnZDgGIn8bArwU8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com; spf=pass smtp.mailfrom=foss.st.com; dkim=pass (2048-bit key) header.d=foss.st.com header.i=@foss.st.com header.b=rh6geYpC; arc=none smtp.client-ip=185.132.182.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Received: from pps.filterd (m0369458.ppops.net [127.0.0.1])
	by mx07-00178001.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55PFw81R012645;
	Wed, 25 Jun 2025 18:31:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=selector1; bh=
	sYD/Lymlz7Mf2jc6nosjwnFLo2PusAF37AUx9QeP1Cg=; b=rh6geYpCt/a5QcHE
	Zg4iGmEtUbuC2rwrdezwKyU+87+2fCJpBJDjqzZaXVlyPLuewIdOevNI1GSeyKAr
	CnGMnOzWLlc4TRaP/DhGtvQtQw7MlttlbJXiQuPoYzKBTZCVSER5q5MgPI2ACYP4
	mpZeDT5HIVzcKN6rmJdbSx6SSgA7iPLyCLN+FJICA33t5Ttro0qPp+VEkQXvqY64
	194e7gv4CQbI04t0D+8/1tb1ANkTEPhXPywiBoFZfcJrD5XF7l4Lhm/sfEpESg/u
	y/4AnYW12AZEw6VfOMtqFugF8TV+asMQwKs36PQjceVjlRvuZjieC5VBpU/7y/Kh
	AGZtOA==
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
	by mx07-00178001.pphosted.com (PPS) with ESMTPS id 47e6a6rsdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Jun 2025 18:31:00 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 825BC40044;
	Wed, 25 Jun 2025 18:30:05 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node3.st.com [10.75.129.71])
	by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 55CA8BF539D;
	Wed, 25 Jun 2025 18:29:27 +0200 (CEST)
Received: from [10.48.86.103] (10.48.86.103) by SHFDAG1NODE3.st.com
 (10.75.129.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 25 Jun
 2025 18:29:26 +0200
Message-ID: <f174540e-4b9a-4dc1-9ab8-f4f36fe1f837@foss.st.com>
Date: Wed, 25 Jun 2025 18:29:26 +0200
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
To: Eric Biggers <ebiggers@kernel.org>,
        Simon Richter
	<Simon.Richter@hogyros.de>
CC: <linux-fscrypt@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
        <ceph-devel@vger.kernel.org>
References: <20250611205859.80819-1-ebiggers@kernel.org>
 <7f63be76-289b-4a99-b802-afd72e0512b8@hogyros.de>
 <20250612005914.GA546455@google.com> <20250612062521.GA1838@sol>
 <20250625063252.GD8962@sol>
Content-Language: en-US
From: Maxime MERE <maxime.mere@foss.st.com>
In-Reply-To: <20250625063252.GD8962@sol>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE3.st.com
 (10.75.129.71)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_05,2025-06-25_01,2025-03-28_01

Hi,

On 6/25/25 08:32, Eric Biggers wrote:
> That was the synchronous throughput.  However, submitting multiple requests
> asynchronously (which again, fscrypt doesn't actually do) barely helps.
> Apparently the STM32 crypto engine has only one hardware queue.
> 
> I already strongly suspected that these non-inline crypto engines aren't worth
> using.  But I didn't realize they are quite this bad.  Even with AES on a
> Cortex-A7 CPU that lacks AES instructions, the CPU is much faster!

 From a performance perspective, using hardware crypto offloads the CPU, 
which is important in real-world applications where the CPU must handle 
multiple tasks. Our processors are often single-core and not the highest 
performing, so hardware acceleration is valuable.

I can show you performance test realized with openSSL (3.2.4) who shows, 
less CPU usage and better performance for large block of data when our 
driver is used (via afalg):

command used: ```openssl speed -evp aes-256-cbc -engine afalg -elapsed```

+--------------------+--------------+-----------------+
| Block Size (bytes) | AFALG (MB/s) | SW BASED (MB/s) |
+--------------------+--------------+-----------------+
| 16                 | 0.09         | 9.44            |
| 64                 | 0.34         | 11.43           |
| 256                | 1.31         | 12.08           |
| 1024               | 4.96         | 12.27           |
| 8192               | 18.18        | 12.33           |
| 16384              | 22.48        | 12.33           |
+--------------------+--------------+-----------------+

to test CPU usage I've used a monocore stm32mp157f.
here with afalg, we have an average CPU usage of ~75%, with the sw based
approach CPU is used at ~100%

Maxime

