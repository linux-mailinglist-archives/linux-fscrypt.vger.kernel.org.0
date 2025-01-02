Return-Path: <linux-fscrypt+bounces-577-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B1249FFEA4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jan 2025 19:41:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DDDB18804CE
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jan 2025 18:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ADC81ADFEB;
	Thu,  2 Jan 2025 18:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J8Elu9o/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yIE0rXox"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F2C6FB0;
	Thu,  2 Jan 2025 18:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735843289; cv=fail; b=jU89kdJrNfFpbCpoPYpxAYI8GTTJJL2Gi9BurfhfkiKrIs6IUvz0jMxCePryj/90jWeIAioJ+adxYLefgvTjjb0zBGuLRiO0rcGpjiaXg5ZIHUow9sWRMdS1XCtpkTd5WNcW0J9ELcOyzF/qFYEDCo8EY47UGhTB9ZIM738gfaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735843289; c=relaxed/simple;
	bh=0qvPsrcFs0jHwhh68ziKmGb//C8k4aQHUjvRdf2EgtU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=r+/xeiUMVyBB5osZK6iFzLE2RbaFYj72f+/tPt/oAEHDDe/jl58yajS5bmCnDyxBQQQ9V58lH3qCygiYsnc8HVmB6IFtAh5ydtbOStMxgiDUel1Cx/oNTTv69fl2RP6JAHwlEGt/EpAw3bkQUiUR4PkanwFqXXsR7PK0usMAeNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J8Elu9o/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yIE0rXox; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502HXsJL018959;
	Thu, 2 Jan 2025 18:41:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=puHlVkBm6PHcaeW+DI
	1fJCtbdPc2WoQ3Hx89fyoKDn0=; b=J8Elu9o/vAkl619gky3AFXtjO+tcuVjeap
	0D+8xTBf4d6+MJpqwqwmuTMCi6fAr0qm3+sZeGzTPAIMgT11jYUH8ldp/Ch1XORk
	JmTmC8biJT6TkATIJ/fv0avc55xro5KVqNR1XqeUfA+PvdnZfQj1l9p0KyKKBgiL
	CkXcsTbi5nMhCZCCGlHbJf0Y7GMHM2eV6Q2oYKyjmyojY3J+2zakv9/XRkwCCV3S
	HBiJhgVRuFAfsktdg0P3Vgh8FFpzzvgsgZrRV2FRZIGQMAxS5HrFoXbTC7eqWHVk
	E01QZtB8f7rdul9Hppqut5G1TlVbpRFJhBjr3nFIQnqseiGAqG4Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t978pc3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:41:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502IDjdE027804;
	Thu, 2 Jan 2025 18:41:03 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43vry1xmys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:41:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AlWj3ER7l+WZ0QUkXATlvgWNPAFq3L+d7QaYSrD1LvR8rderU5LjQysZtqM5eYH/QUS9tDPgmJemCcch1gu4Hih/fanEvkvowY9Ang8te8WKSiQ3A52el8nCLcnmi2DQw2zQVuyG1UvlwSBpONVze7ndVXH7/hJ1M6qi7vMcOJaDjoYBObfZ2WyW+scixiTZaQ9ECJgFOed2M+BgrCsBEr8Zoht5pak07Bo6YI4I4qYJ2nXqQrAYlGo2E51SYHhyXiNXFhd2QECEvR/4FikEMxawYfQOjFQ1LizP1c/P6lDfKY2hhLeBPvG47x96RZcezyCrpjY1Da/81zj+r8kPbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=puHlVkBm6PHcaeW+DI1fJCtbdPc2WoQ3Hx89fyoKDn0=;
 b=yhfwDDbtIL4kr622zmWNFr4fH3yGrcOil0+R620F3QTYlKwNEYXQZJp1tjNqT1BttnN5Fffpvbt7k0tv1fpvLJSJsO0Q7qlDp6Di60fSJ8TPNC8HhD2SS9anTDVMT5qGgjF97qL3bY0G0Ax2nFOKtVuNqEMbjVcGehh/q1PqJzmbYVgvu1Wq1gPOhqmLkiYjzdV7FgbZ7yMN34d2s64XKpLuNM6Pu3UhWmpG4JsLg1PJ6JjpnQ907aHwF/ryFnesNULAGlJF0+/jvUl/Vot6OWWlbnIJ3XG+Dc9oVvxQ0ItQI0taXfFyrQGI0DBFs4UpC08jnN2siYLY6NlWTLLtVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puHlVkBm6PHcaeW+DI1fJCtbdPc2WoQ3Hx89fyoKDn0=;
 b=yIE0rXoxoHdvR7ktJLB44zQ+PYIYiN6LfCuTunxYI90QzXttAsHF+nf/RpzrGXW52GZ+yRB9UeMBhV7UBMDPIU+TxoLZjxdqZeW/+XdsSpEbJs/3PUuzJlZUNT8kN7kVlUdfb5Xf7FDBdHihFj8wSnN7TXVUfwKAH2BOuGBsrDE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ2PR10MB7812.namprd10.prod.outlook.com (2603:10b6:a03:574::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.19; Thu, 2 Jan
 2025 18:40:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 18:40:56 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Adrian Hunter
 <adrian.hunter@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri
 Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Dmitry Baryshkov
 <dmitry.baryshkov@linaro.org>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v10 00/15] Support for hardware-wrapped inline
 encryption keys
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241213041958.202565-1-ebiggers@kernel.org> (Eric Biggers's
	message of "Thu, 12 Dec 2024 20:19:43 -0800")
Organization: Oracle Corporation
Message-ID: <yq1v7uxf4fd.fsf@ca-mkp.ca.oracle.com>
References: <20241213041958.202565-1-ebiggers@kernel.org>
Date: Thu, 02 Jan 2025 13:40:48 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0149.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ2PR10MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: b68af011-8c1d-4a7a-fda5-08dd2b5cfe83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?knFFuMAuvfBtb47Sih/1971nanHeJ84H8li4XK0XZ7w4Sy3x7ZrIcLTCChSV?=
 =?us-ascii?Q?pGKqbmCpnFneeXTvD7BjDTtOSf0vBlzZRA14TqOhQyy3a7lKHl2rnXG+VuoI?=
 =?us-ascii?Q?RXAqdAuwcP95CSHdrWFpUzK4U3d49EngMAjGwRbwPRJ+K2WeEPpua3UNirSh?=
 =?us-ascii?Q?31DGrS50PlG28lsacWG4CtHMlEVlN8kghEgLOKBiknwGs/KO+ZlwCagzZ/Mm?=
 =?us-ascii?Q?vLiOBkdT8K7UCpteeFoLp+5yx2IHAPfqvsFEoNfwh8g4KxYflCYoW8rneTtZ?=
 =?us-ascii?Q?08IuFavGJFi7J2H2fptGsEvrW+1ZwSJT3sz/XywoKvfw/4nI4wzKI3YhI4OW?=
 =?us-ascii?Q?R3CqIQ538X4DQg1KK8JAFBZmFeyxlNkMpRI9BKdjoYEbJOzipIQ8TRDJedhY?=
 =?us-ascii?Q?mBPEjmdrhDf8Q3bdnjGQQQl31lr6Ka1Anj4bXEh0XfTArxRoaellDHhnk+PP?=
 =?us-ascii?Q?Jn5KW1FgS/zF0l3dvAdhuFABR+kODHeA5FyoVcU/Oezfh9XOkBMWKisClwA7?=
 =?us-ascii?Q?1X1FxhQJKY6SBNygfOT1RJPWG/07Na/w+KEgztqFn/6fwTj5wQlqL7dsPGSe?=
 =?us-ascii?Q?zGTVMbjqbqIEgXIMYEaaqWYFKK6HfgRZukJewI235Du+UozyE1GoHnI4XESp?=
 =?us-ascii?Q?Z2yV0u/UVKh9qxUOIrEWNU6yaAq02DN9Qd+10XKJsCEwKJjG1YtvPVoUfBIP?=
 =?us-ascii?Q?xFBpvIjzRlpi2OQBrZgguzdGQ2cpZGJtE2X+zb+8E2OqT3yZyF7IDdAFWCsS?=
 =?us-ascii?Q?4JRspBjFi8I+CY3DhgKtZ4WuFPZybTwkgjccJEkmIeLTWYYG3aaRNT905S5a?=
 =?us-ascii?Q?t7RrDsqoHgKyVmIXGQ8a7fEYY+9tsG0ETeQH2HZdPns/Yc+SoPgXOKx5uMFt?=
 =?us-ascii?Q?J4txhmVIlEyKJtl287MNEgLITFw3s2+V82YNB0QaO83Bs63f7Z3j8p/sW2AI?=
 =?us-ascii?Q?QdL32cHWHJh9UXuoRMfk0PNwl51zUbo/EJsLZr5WnHMjHLAV55IClI2Lwrc7?=
 =?us-ascii?Q?BGtfyLkNBlIkrbw2vkXqOQ4oVdV4UWfvpASQWP11v1sAZ5G5lvv6OB66lfTC?=
 =?us-ascii?Q?1asVfXHY0p4yOl+n4WVFER97cDBAPremvLXDkBkQqLO0Z/bQMJnKhA8NoiRw?=
 =?us-ascii?Q?yz0/Ku2sNHVTKzBdlnherYg75QVWcayGqptAexC9PP9ka3MxKQeZnJOpr+Md?=
 =?us-ascii?Q?nVXYtCPbuGJugkSbhhgB2KSZPAJk+HZfd8a0idvKhcnteP8FKTKvrRQP+ZHp?=
 =?us-ascii?Q?lU6NvJjTMF5zRbRDgpG5J2bUuEYdBPX7CAxrbQMqNjZY3ZX2KUdB+5JESd7J?=
 =?us-ascii?Q?LpZD1S/77zz1N7weQaXr2lBb+qEildLsRhfdjYtJK8n83WD/9ycR+xV4xG2H?=
 =?us-ascii?Q?b2ATnKz/kj/unmeN9v3xEBp5/XkK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k1wuHun/T9tye+9uos2NDa/9RDdJCeA2aVLuNcbjNuW2XpfD5RTuN4aNh535?=
 =?us-ascii?Q?Mde99PAvCdCzdgVRh6bRpvsKS7RwbrQ5UGl1I7Q3yXmzAhqki/YTH36BU72M?=
 =?us-ascii?Q?Zq9RvdkDnVR0v0oScYSRZcirD3GkjZ/QVZ9E0LFBn5jx1q8fjOMlANgH16xI?=
 =?us-ascii?Q?7Y6k5fNHsQkSH2mCjmqOk2QT5HZIYKBfpkp8ZbH/DXW1hVjVQlkKpQGrIWPh?=
 =?us-ascii?Q?FcgjjrTmhmE/T80vZqF1eUkf5cax1bpoK1tgsxTSXWByrY5yyMF74n39Ta5z?=
 =?us-ascii?Q?xlw7jpnaYO2Gr7GMpje2eXtmwLZ8T7SlOSyyewr2ZjY4rPR29U/8N+85fzgD?=
 =?us-ascii?Q?CxZ783vWnyBrrRVx6T/fx+zLdws22aAPIy44rm7uxIAsn3JXcEpBdsM8jaE3?=
 =?us-ascii?Q?pQtDhuaQVnIjvqrj6CgDe0N0kuNKKEQtev6oD0kh78XYUPOrwuC7ar0M6ysz?=
 =?us-ascii?Q?YeC8iVFscg4EoaQn8J9s8QAR94TLIPf09twhPOUk8bCnys8vBNaZD6OFtpPu?=
 =?us-ascii?Q?foPa80Iozck4n8d3jjJen6hsmFktj220yC+M06vUgClI5tUNILeTQG83ulkZ?=
 =?us-ascii?Q?B7WnM3sQz31NYslAEvYCyT3ktDsgvj/GflmFxzrTafCBoMIWn3aMnocqdKzf?=
 =?us-ascii?Q?EoFIWN4BZdSwlk8nhEdR73lZeEuD8lNdeJR9euoJZ55xfjDonapOxYGZSTJH?=
 =?us-ascii?Q?lEN4pa1as8B/qYAnb2sC1XUMHsZXHv/qXQwn0nZeviyPvWOGp+AhDwZC9SS6?=
 =?us-ascii?Q?SgRUlEwPVQ/Vg3lqfUJ1wvW1CcSacQzkUJnqOXqHwbqirngCjaHJ9kXy2Gbz?=
 =?us-ascii?Q?OcSLcXjL9KyjtKNmA29vyuDs7vTd89Vydw2fYy1c3f5WqwiyS/K3Hv/QCSIG?=
 =?us-ascii?Q?CfmNo1+SFmeZC6uW2rAQtQ/VG8v2QYjJeN/7W442ezvciS8MUrI1g76onk+G?=
 =?us-ascii?Q?PE5m/V14pamzNxZdiokfu97yAKFj5dnBbe6ZrHgmX0gr7fKrDi1Cr7RFkhv+?=
 =?us-ascii?Q?J6p77aX2vCq8Wm6CIxklQj+fizhtYkuPuGJRfiaClXp4AaIUegrDoXG1Ml7A?=
 =?us-ascii?Q?jQP1BgOq5BFsWh/Zaq6XeV5eYckIqb/5Bf18GDzTbnJa1P/2gcokGGRwKofD?=
 =?us-ascii?Q?8di+WoUyVMOLmfflndF68FpCkCwjVJardZMzvDETVZ2spo3LMJFxGGg7R2WJ?=
 =?us-ascii?Q?nbBOmTHP3yQKrFmbmptTRIxK03CIswlBeFAigPXPmRuJWnwLduclyJJTPSb+?=
 =?us-ascii?Q?BcwzZ+IDDRXxjOYNlnkcFVoa6EDQ+wT1348p21dYE8ZjjXVTQUmjkeDPEpMa?=
 =?us-ascii?Q?51vxUIgKtc5Dyb/c/TvUMMDM4+EBOwJcpP7il8YTLVQ0hnwJSCS9ZP8+G4ot?=
 =?us-ascii?Q?3Vt3HqDx7U4UWruwkjmjMtfNs7vTOIA20OhHghODo5lGAkmVEzHPFEv3hbG1?=
 =?us-ascii?Q?3Yb+shjzbMWgo6bp0BR12KNEIn4GYlf5vfRvAD1t6JBKPlI6i94E3fvBE5c0?=
 =?us-ascii?Q?HysJxnrWTXvMWQKgx1oX/XRY80VgzmLXPQ6m03PnMeBYfLxKOH9nQtYhygw1?=
 =?us-ascii?Q?yZUYcuwawc0lB5jDhgwfhQRXgmUMR1FvVZV2KDww90lA3ko8mLopQFLZlspz?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aIEAgWN/aC3s4AqhXxwXilhFRK3xYO6BTVdD0lFjzn3YOm42XtN1ru9bLxcQMTT8o4cHZzImRVtDA+ILe2Mw2hTpxib+EUFbPSoZjY9vy10Asj/onFpeS015Zikwg5Q6rVeHIg+KzixrhkcziE949RYGIe/PPsbkhJx/9ivEz6eY52tXioGB1WcEAerWbGvPR8AmQsTxzlC5NATwcOk7JNbBL4lkXZs+xDWN8zSGlXPZv93/Wk+vSn+OfIku1zSBdZohxZP6G6a0FPbw+SXnSf3UpiFNw3wvIhIbwUk8ekBT6uW0RA/NUEY4HUAZPXZ08I3lj+Cv0qM6csRZmJ4ZsSzHpjVC3zl/Cq0xcvARc/K2r1DZKfLZpwZ/pbJLXtRT8n29B0xdmQ2gCHL6U/maPUg6d1M351JmmscsqsyqgursRodxwP7NEfbv+kiX8j5eci2wmzs6B2fHEBAWFRhxQAloAE0D7CpMf7QuKFSKM1s5XB9EdwWFAcG2w/SJjKT4klxqPbIPNxVNabalwOXH2dOI/z3Nlyq6eGGgJ89Dwyw/YdkWzz2HKP4YPUrxpbIoSc5AvlHQCvtU07wika1p+FuynxQcY14ZjN91IG9Ee80=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b68af011-8c1d-4a7a-fda5-08dd2b5cfe83
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 18:40:56.5685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jd/o7vlSWQIlHEeAdwUNpKbmMhFCaC8GB0SruRH7dsTxnFmXAPR/iAX85NasBDQmqJaKxUff/7+1qnlcIgaBpUlK+9010iPuqL8LFANX4MM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 mlxlogscore=753 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020164
X-Proofpoint-ORIG-GUID: 9owOWuPP_iAoqVEBOi-e3ZCWxXzr092M
X-Proofpoint-GUID: 9owOWuPP_iAoqVEBOi-e3ZCWxXzr092M


Eric,

> This patchset adds support for hardware-wrapped inline encryption
> keys, a security feature supported by some SoCs. It adds the block and
> fscrypt framework for the feature as well as support for it with UFS
> on Qualcomm SoCs.

Applied patches 1-4 to 6.14/scsi-staging, thanks!

I had originally queued patch 1 in 6.13/scsi-fixes but moved it to 6.14
and kept the stable tag to accommodate the rest of the series. Hope
that's OK given the short runway we have left for this release.

-- 
Martin K. Petersen	Oracle Linux Engineering

