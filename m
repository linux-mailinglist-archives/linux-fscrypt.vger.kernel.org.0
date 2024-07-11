Return-Path: <linux-fscrypt+bounces-354-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 240E392DE6B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Jul 2024 04:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A87B21F22102
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Jul 2024 02:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 800CDC121;
	Thu, 11 Jul 2024 02:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E1XyzriP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Rme+BLDI"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B186829CF0;
	Thu, 11 Jul 2024 02:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720665333; cv=fail; b=lLq+k+yIMqVBBXowK3GiWFEqoOIdkPyyJSPwZ8Rop6v/3QByhkylZf53PC8vXDonqUs7Tnttt8MMdocjJ633y3y32L9MXVK7vjXL5WNXRytMADW2W/MjRkgO0TsWVyIK0u7a5/r4r6tyw+Cp0uGi2dvbnsvXg6gsmUH90dpCkO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720665333; c=relaxed/simple;
	bh=lGjkEG83NSPGNUKaPmUj/biDJySxKjmw+LUzifPSe08=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UJPwgPs1kODSYTQoKpFKD5LymDtlLgIHD/hMdnG48xphKZ8dpOwhQs7F6oEmEUqZoZQbXY5o+vsbMY1EkjSeYqGfpZVvxm+L4lY6UUeZwa5VApJWnkMH9FCOaQHEa18pxAyzZXTFGWtSNjIfDJtEbaPs48IsxcTctxD4pF5NzLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E1XyzriP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Rme+BLDI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46B24MEX019297;
	Thu, 11 Jul 2024 02:35:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=wlSIkL/ewvW72H
	2I9LRXtjxtuPpihceNehyj9H7HC4k=; b=E1XyzriPfKd5rf2VW1VO3NuXSk9Vf4
	d6XJPhTvaijSlAf8vdfXhJdXDHKD2VVQxse4iXo/lMly/EtQWk/fuDxdKP9dnrm7
	ZbWxXc/Hw1Tgyt6E8Vmn45d3sYsT2nXYE0Ac5qqCUQuhn9R8VY/DGOCA50jmVsD7
	bFQ5AGi2oRvNoweflrWXtmySZdECPrgHUJ1pG3UOmujXDktr6NJeisj03cYkslDn
	uNN8qr4s3z9rTgeN1lo/gI8BDZxGzhj70vpq8Up0KpFTsmgdTwbOoHZTU70KzKhN
	Un0zIXBc7Hn9iNxtrn5AEc6ipEJO6q0kCazC4V8gniJoRVn0DpKx9Ymw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wky8pdw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 02:35:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46B1UbFN029938;
	Thu, 11 Jul 2024 02:35:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vvan4y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 02:35:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fbuwj2LvfOBYOfzzwyyrq1RCai6xPEdpsaWsCxgApf2jwzPFkHvpTvI0ZsZjN9W2fI7XtRJv76guWWIzUIuDJM/GNGL75r2KuP4LGMG5mq63D1tjHpOcuw2dNB6COxFQHS32bWZfPKMTMsk3on+hfw/wZTm4F1HtvwYw1kLJAZAKHap32zrTICZqqiAj13QqgethwbqmeRxqQMcUSNaj71/Cyodtm0X60wX9at/Lp7jd6LgEQREf8hIt/0aNrlNO6mWOaRD7JzAaopYC65XAiWoIZLcyOWycb994Po2IHamrrfM9Xgwin8TnW4BkmMv0CviWkQ7+1nbYd1htioS8FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlSIkL/ewvW72H2I9LRXtjxtuPpihceNehyj9H7HC4k=;
 b=mY28ItzBqivrxYLhLHAUFwQqDKZX8QRyXPZVc7+8KUyS/PwDdkZLkdY7NR6MLjsH/O0iePIyuV70VwzTyVyymTfTj46KICruY9b2PbRImaP6fKhn2ifnl0J+H1OrqSUHE73S6xSwfL1yJ6P2XRYbSYqjcBIavGajCw/AOLf84ncJBk4kdobYYzvi9Pd25AXtDP3o15i5+BUnk9lwh/KXvOfPgX56NxbyYoC8kjDXKo/kIjoFufP2JD047z901a+SsP5CBh/Oe+0UbDSFqPRqSjNChg8OZc+CDwHw+pRU5H1aisGSRlGtLvp6j5f8eQkwiD5iUd5A9weZauWbTU3cfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlSIkL/ewvW72H2I9LRXtjxtuPpihceNehyj9H7HC4k=;
 b=Rme+BLDItfcxU+lgINcOxnBNtVqH2Hx2C+VY1ms6Fk8+29ohY+uiSfjtKdIXA05WNu7Jf1Bg38zTQlkT3l+9lQgNVbfGzC5Yp8/3jq9j76FCz7ekX6FhUBEI+IqI3BxgZdCWUeNQEhYd7HdIUxWdndb/bdD31QFxOJCy7QqaoBo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB7311.namprd10.prod.outlook.com (2603:10b6:208:3fa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Thu, 11 Jul
 2024 02:35:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7741.033; Thu, 11 Jul 2024
 02:35:17 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Peter Griffin
 <peter.griffin@linaro.org>,
        =?utf-8?Q?Andr=C3=A9?= Draszik
 <andre.draszik@linaro.org>,
        William McVicker <willmcvicker@google.com>
Subject: Re: [PATCH v3 0/6] Basic inline encryption support for ufs-exynos
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240708235330.103590-1-ebiggers@kernel.org> (Eric Biggers's
	message of "Mon, 8 Jul 2024 16:53:24 -0700")
Organization: Oracle Corporation
Message-ID: <yq1h6cwoduw.fsf@ca-mkp.ca.oracle.com>
References: <20240708235330.103590-1-ebiggers@kernel.org>
Date: Wed, 10 Jul 2024 22:35:15 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:a03:505::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB7311:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c74b4f9-5667-45ec-b287-08dca15219dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?UgH1gx7SpwBTM2jYzO5O/N7QPbn9ONmi6msWl/fSULyRfInLgc65sJNXOx4a?=
 =?us-ascii?Q?g2NlSe2B3/a/ThrWiYAH9hYcbh5abIL/aI7henjVbU26fUT/B4KboIlY6JG5?=
 =?us-ascii?Q?9CmKuKXRsceWErCAGt4/6xQ3pfuY2vu/J+9Swh3KT2ggSKnVLzVZwPYFWSbD?=
 =?us-ascii?Q?ZnsSYdcKqfOtkrWuUlsOWWmPH11lAE2K0HHr7TU/J0iygPsRvOmbD5qqexHx?=
 =?us-ascii?Q?SYRCauKa6nykOb6+CH9FmAa+R4AvdEv86A/3T7lnbrkv0lO96sX8m3FXTUYn?=
 =?us-ascii?Q?22H0AP2+poSWVfdxgS5qt30/usyOhGWgc7aDORAQ+JFogdV5/XIXJYdqj54q?=
 =?us-ascii?Q?JV4rbJI5iC1RVU+/4xTg9GhxKDwKizr5H0YeHyLY9NALQTBNEheI8n6F3AMq?=
 =?us-ascii?Q?KgcmuExa//lpSezdZtAAGlE1/HmJMMuILRoqz9j+MNkho1xtDx8c1SRPCtx7?=
 =?us-ascii?Q?7NMyfBqSYXURxc6KXcES0ryMWGmy6h3tUPfRLsbyIuZBfCU512OyfFx0f3bP?=
 =?us-ascii?Q?+Bzax2oQHFooZNSplFMpaxPbs/4b7ar6RiuVpv78tYpASmckvVJ2813kFXNa?=
 =?us-ascii?Q?3MI6wpqMn1GKN+uY+9G7YucW7KdlPibsdOrA1tZWHbS5WHCEqBmosBNcpin6?=
 =?us-ascii?Q?ZvTjjqJUjDihoBX6DwwSVBu4WJPo8js+FxFN4mIYNdVDvYpuNDD/2oh1ClJA?=
 =?us-ascii?Q?+c+3cQ1A/bcXBjfHbJmUOFEgxHZk/AZO0uRLe6PJGKvTpioeQoKA4FlJoWsC?=
 =?us-ascii?Q?zs2aHGAcqSrfGybV2g8rIbIjfpbz1SfilCTQV8LdrMXv+XEbZpfu32gMGKlg?=
 =?us-ascii?Q?imhHdo4s9KVizCj/CBPSj5ejy17T4I0KybLcWZtvDz4D2ux8tWyB4ad78EzB?=
 =?us-ascii?Q?jmj9uN2iLTc9rURQYwfyeS5BL27ryuFH/KrqbL1k7lcJ92r24tJTXpTT0WYv?=
 =?us-ascii?Q?IV+AUU9e4cQpa1QqYmDCTgFn7OYNI4+y0oKbpfKKAB+3t0m0fpo15DVXFG1Q?=
 =?us-ascii?Q?OD9Xgzo0MQ+yjBsod7sk8qmAuy5HmmkPP7384FzxJEzfglBR9qJ9ILWQzhhG?=
 =?us-ascii?Q?TjM5e9g2wMNPOA3cjBkwTHbjhvFMJT/xbe96f6gjUtn8IfeND3JsATnfsbBu?=
 =?us-ascii?Q?WlissoaSoWxYIxAHmpkDp4HWLnp0LCU5oUelGtZ/6zxksjqp3gDuQRcTIy7p?=
 =?us-ascii?Q?e6la+GOdLwYWdVzVHsKd9HvWSJPZnorbIDyPRn0C2AHaAH1O1tKKoO+1Ru+i?=
 =?us-ascii?Q?Cr5SF/XIJkBuvkgKJFrXfsjkpYyizkn+kE2633J7Jh68exnlG9Aags7jKTAT?=
 =?us-ascii?Q?zV2OgeH6S9FYKRt85mi3sWZ9Colm4AJ/mEQh7u+hBVptvg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?NhUullbXjT8DY4RpY5PPNHqu/s7ugPTu7oIeieKupwf44LXNNoNYvcxFEIiR?=
 =?us-ascii?Q?ipms1pLytCJN9uP7q916lW8b7kqTa6Vuint7XOQfRWSJuZj7z3RdJYnvUh6u?=
 =?us-ascii?Q?cEvbUI+8ts+hwBuIozE2zVqH37YTFVX2bp4MMghMFnoxkc7+/yy67q2qDKox?=
 =?us-ascii?Q?fSVlNz6EehuUkBPnE6ejasCWQvVM8PfDETbjrJyMUKDeQgGBJOtjSkYnDzJd?=
 =?us-ascii?Q?B+lhRu7fZQHSW86hHezTc6Q53tATVsw/lLPBzd9DM+m1lshmJe+qiGUzW6cK?=
 =?us-ascii?Q?zO0ETVrlqIdyvjr2iMt9H8B5CAJSSPracN3YLsmwxkkVJ1GqSiHtJ/WG/mgl?=
 =?us-ascii?Q?3nFqZ7K7YKyJznjwuxjM6SobM4lIZmhUNaunw5qSv6/On0EAYIQjfmhHz30c?=
 =?us-ascii?Q?fCZ+ugQWcs7yu+XYyNCOXlXdfblovZRYzU7TJRRmW+NwTbYBIZmqtzoFnuWD?=
 =?us-ascii?Q?n7+6/B66pYZg21qirQLEvPVhCIjHlJeW7TenpUUB5RIBb1M7ePBJmo4NjWaZ?=
 =?us-ascii?Q?eViVVIZXiHJtvI1Q0lY0nGmexpfivB7k4xUK2xT9bLifsLV6CbhrAOglhHd1?=
 =?us-ascii?Q?FUpu28tzmOEJgvz2UPzweXQ9p5u1F7hsh2eRe7elsJ3RD4gktllBU4jLRFms?=
 =?us-ascii?Q?SSBgZvOStGpyEnYPh0QvREUu9fFoHTrNj7VOu8iIjNoZOLx1lg/G2+0HomkX?=
 =?us-ascii?Q?1yVC5VIRLWFRELVrasnltngOaJcYDGbtUq+D2/U+7LOU5fktSpxRBD7E1FMX?=
 =?us-ascii?Q?iLvEi49/79bZK22Xsmmn2BjULkOC/TtOhNFHmCy80wEEfhEQ13m2ETWiahw+?=
 =?us-ascii?Q?Z3YayZ9TJ/J8eehUaeCJOwmo68gQPfSE8n8975cypuUPqWMjCjxsUh1L6gme?=
 =?us-ascii?Q?bsNZBIh6TZ2oKUJZsyfMz8jpSdRytvyzIgvwnwz0QUSJ0MVgOoem3VydSX25?=
 =?us-ascii?Q?3tvu9+WZVK6fs9AkcftiSCboUrrZkjcV9kYUxw1lu6xtSCYJP/EGfAa2/vj2?=
 =?us-ascii?Q?zEXqroA+Z8vKJ8Tz8u+bu7xlzu2p+kN703Sk309QR+ht4+uMJPjxsq0cD9gf?=
 =?us-ascii?Q?EDrVMA5O86eZrvrXuq2RIgjjCt4sKRerSw2KRmpdZ38RY2jaunhO9GEO5pVY?=
 =?us-ascii?Q?O4SdpNfyl+1hqQbrzm9LckQE740zfnwmSb1Wt+5/cclnuslzOKLCjARPqJKH?=
 =?us-ascii?Q?lZSK4XrlbYw8CTdG10C1R+gWa1SMWzjsvpq2IFsvqngYKMOsyWAOHMsEhU9k?=
 =?us-ascii?Q?pVdGM9N5Sgc3LaDH/fwQy5lfr0OuMOx1EpjszZxtDALmZAt6yEt/JkMSlu7I?=
 =?us-ascii?Q?DCmw3dgz0l5CgvxW34XZJcY/hiycg19PROUKYrqst5f25xwdYjwlaPF3wG4s?=
 =?us-ascii?Q?vIrM91tUIAuoWOtyKKxqxHqNvRpMmzuMToxjai3puVs/aCFbr/Qxf01ZVBmg?=
 =?us-ascii?Q?k/YdrcV5dr3Cff1lT+QEB8ie01DF9FZ4HFDWN0P2VDD+jvv3OysWPDcyEpP7?=
 =?us-ascii?Q?fbVBbsFAmzyHmPbJ5WQlpA2dNEjGONK20BbFHNBnjDF4ULUFAvXT/xKh/W25?=
 =?us-ascii?Q?5TNtU61dM5bwOHdNHFaybf5E2Go0ZG8PNOzyFKBgVvqsJs3MxeFZGnx9tCL0?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	FCChTWW/W4TQQT/XLGnL8rX+daR86Ub8EC+x2hQ9bxSRUJTH/YIcEq/W4QPfCqYAH7qaZB6oUo9P8tKpYIDC1Jc8CPpv7VxrtGQ6megKSk2inEoSACJ5Ep0Jfy3kEzaQfrwt0Nd3MkGBhfZ9C2QA0RUY9xb0fBRdGr+xvKS5Kwa1SNgaP9gVDMd4CFB3zUvKMibTkvcnP7Mn5HuldYBWQTBl6r+R6M+hu1c1m/yO9JG7ySQnkqrceijF9HrO9hHxw2gcMDoS0OLKsLTOFaWoEnW6StplpsF8/JsK0OlEHraWQ9HJRWNODCSYEegtbxY6LQ5NFu0hebhwUjNXpUrrR1TOiYSd5/0TkZDwWsTEtbtuTY6umFTlegdt6Iwf0dhRAUGQKQCGzbh+O3mWhMIplsEs4bL8D339rLBa2fpFWeLeuD0SRMctvvB6qUo+REHw+dH3Ydq5+7nMNE1G+OXxDOSDKCATmwXF+0bBWSPT+YcKtE9bdpAIumey9lpU2tibLAbwXVYLfJePoh/X3GVbqJBZP0XfIoLUc53l133C3IZfq6ekkJWwPdstcLPql8snheO6UUWX3V3fHhiFgTSnWxX/X8yXBkvFFg9LUaq3eK8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c74b4f9-5667-45ec-b287-08dca15219dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2024 02:35:17.4178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +dIfjsqmvyHd+pCqUlsAIpgp3eytDil/RbCzwSKXNQEnyi40yPvxdBXjtw4lHi9nF3xTYe5ES/VKnrvZZwJFb3U57TPRgw6GSVHBVtbfdtg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7311
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_20,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=589 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110015
X-Proofpoint-ORIG-GUID: VlD-pGKLYhfz1BXR8K9gg4rQD4Om_Vip
X-Proofpoint-GUID: VlD-pGKLYhfz1BXR8K9gg4rQD4Om_Vip


Eric,

> Add support for Flash Memory Protector (FMP), which is the inline
> encryption hardware on Exynos and Exynos-based SoCs.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

