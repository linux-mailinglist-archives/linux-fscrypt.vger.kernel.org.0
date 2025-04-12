Return-Path: <linux-fscrypt+bounces-647-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4982EA869F9
	for <lists+linux-fscrypt@lfdr.de>; Sat, 12 Apr 2025 03:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37AEF467DB9
	for <lists+linux-fscrypt@lfdr.de>; Sat, 12 Apr 2025 01:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13771AAC9;
	Sat, 12 Apr 2025 01:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n62rH6Db";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FKSCNkFC"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6352A846F;
	Sat, 12 Apr 2025 01:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744420697; cv=fail; b=pjvdLhe4bj4VaTioVNLa4WpkYu3gXsUwfnL5uhDNKArtmznwjVw1/XonuH7Pw4zHqfFlTUXoHcg532KOdhT0r7T9BWpALx2IqinqibHguIKnZmBb/FlWPeyQOkdfiIJutB0MO+mJJxyiHdxTKFb7gPs0K/lB4xk//7G0QuQ2bU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744420697; c=relaxed/simple;
	bh=0HSA/Wqo0IE5s9RJQSOXNw5qv+3WVUPr/2LGrbgNl44=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TFKX5WQljZ97g9tvE1aTSaaU7ji4o5GlCDwvZkJ+Eqvl40XHv1ebZRvltgnMr5DwnYSURdB9fiBra/BnNLre0GryhwPL45Wd/YPkUHpovnQUFQBFQ2CxOm8ihMS1tDbD5RnP1DUnS9UxbZNLvV+qZMkrpwjiZcoOBXJRXydrZQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n62rH6Db; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FKSCNkFC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53BLHhhO030641;
	Sat, 12 Apr 2025 01:18:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=7ypKL8MWJJg1c1u2sx
	JtTKmCRgyYCaXesG6R7+drnqk=; b=n62rH6DbMbn5Rs9Db3efgfKwMTVgnDY4Ds
	wp2jDd0l+SSfS9fbrqbJ5+VKfIG4tAJIBuVMv4g0M2AhqZhDICzIIHhC8qLz9Q5u
	jsiUmbAC09EtkgyMB/u/XGTu/JZK/rcdxoH9DQ8U9jjtINOIxKEjRZ07IjUxUa6q
	qcJjr/rzH0L1B6tUG3QYBpLITi4t+fEDAz0P0j/uZfuTd9Roy0zbjgbMwgA5roJP
	DgC+nlRz77Ke2Hq867jiHq2BCI9kx+62njH2cYPWl0qGStKyhg2vJqPfTXhoVhDZ
	DyaISn6QbW+6Lq2yt7kA9emw07TWIIWDdQPzFg7bAjVwgSEnamIg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45y9fe0k0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 01:18:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53C0O2RS016340;
	Sat, 12 Apr 2025 01:18:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyebj3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 01:18:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WRd9M2aYwNCBmWd32xc25ILGr5/oZ1X4Ip9cXgvq+xwnwUaxlRxDaNygu4xrZKMvNwp00eL9XvdcOdQ3L7yrN2yYrJtafb/uiO7NBovgmRL6RViT1mPwCZzz7BFOLFAg0tMcr3J93E2gGL3laL9i/aqtV72q2jWGxAO3Np1x8US9VSSLpVB44u3C/N9UqquZPQNqUt+PBKej+WvP80zR1eQlzIpkFbj5L0g7fwMFvcjEtDlIB2+LEzHqLQxpHYPlFuNW6srVqNR1+Cu3dfA0+MR0z0c0FQgfi09mkhvPQyqStucEysCD0ZYTkxEyH6eTmxmbrRn2njQxXHH7b9fD5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ypKL8MWJJg1c1u2sxJtTKmCRgyYCaXesG6R7+drnqk=;
 b=KSDFmCUuDdltbHT9PDrpnMJ9ySe202P0FCC+Ora8RKDNVADau0bltsjIjsS5JNcdXNOdHukvnmqw6KJcMC8n0o/4aUN9/3IfBw65vhgDT3kpyRxrt3qNGhw4UNh4/Mz1rGE96XGQDkepgLoTafkIg74+TtBMkMod26gyf1AVsilvM2RgGamfoQM1VB3/NrtjcdVZusw7RW1KZdCcqvl4w3kP14e57ZCiDMLOPBRf742daBdCoxt9EypFLDMcEGFKKm/eAQygxFudZm2ziC+OSUde9fPOG02Ts3tnvI8sL1y/bMZ74MFM7aaVtSD8ywsGQoVz9ghYSrnLSfwGQbryrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ypKL8MWJJg1c1u2sxJtTKmCRgyYCaXesG6R7+drnqk=;
 b=FKSCNkFCR/JwCG0BD0ffct1X9V5o80QrIWCU3sN0DR2hFcJy0TzMVvNFnWx5Pq+5NowEu0DLOXZ47WXeBibWZXVXiu5s//Sdfz/EChMYp2Vz8LejOkl0m/Wa320UDgermrwKBaeS/u8UkHMz5IPD0y+uZfeDG6JwySZd3OrGzcY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV3PR10MB8129.namprd10.prod.outlook.com (2603:10b6:408:285::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Sat, 12 Apr
 2025 01:17:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%3]) with mapi id 15.20.8632.025; Sat, 12 Apr 2025
 01:17:59 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Bartosz
 Golaszewski <brgl@bgdev.pl>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Dmitry Baryshkov
 <dmitry.baryshkov@oss.qualcomm.com>,
        Jens Axboe <axboe@kernel.dk>, Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH v13 0/3] Support for wrapped inline encryption keys on
 Qualcomm SoCs
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250404231533.174419-1-ebiggers@kernel.org> (Eric Biggers's
	message of "Fri, 4 Apr 2025 16:15:29 -0700")
Organization: Oracle Corporation
Message-ID: <yq1ecxyjhzd.fsf@ca-mkp.ca.oracle.com>
References: <20250404231533.174419-1-ebiggers@kernel.org>
Date: Fri, 11 Apr 2025 21:17:57 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0405.namprd03.prod.outlook.com
 (2603:10b6:408:111::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV3PR10MB8129:EE_
X-MS-Office365-Filtering-Correlation-Id: 15fb5815-3bf3-437e-af9d-08dd795fdcc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qARDgTBEDD93aQNViyOg2eeuccsvDVxlqOF8Z0LC22RvyiE+iE8WGZnmfnAZ?=
 =?us-ascii?Q?KdPNb4bREItCUekh85uXTW3BR1BCrUMyGrjDjEqqR/xD/218iRPWagoa09j0?=
 =?us-ascii?Q?VyhOJRy19O10kBAaLbpVAH+TI18O9ALP3Zjaau5a5EA865EChUOqJgy+qIKj?=
 =?us-ascii?Q?W+tINLcVLKBopi8iuMCr2ZlCObj+WfSp0YBrK4/hEnWzd4+XEs2+RqaC+2q+?=
 =?us-ascii?Q?Xx/4ojh8WDJohI4/IYhHTefxy3QvY+qoy8Owvz3RhI1RhkQ7khIVueEeAjwV?=
 =?us-ascii?Q?mceujqI6s/YkekQ9Ik8nzNdn2gZU2NkfIB+n1Q1R9tNGElarFRfSmHnltlSs?=
 =?us-ascii?Q?/VKDzJiW7CgKtWnffCpIumzku4977Q6jRCzHxzVmPosn4LBsmIraDglBZW5t?=
 =?us-ascii?Q?ZQZ1oPZL0I3IBMamnRZX9Eb0LKsRNMtOI5NMw8KsvNWsylz/ESX7Z9HSarpi?=
 =?us-ascii?Q?CCmwEL9ukZEaFl2Ul1YAGcMECzWe42K2ywWHyIGiTI1p2wWoZEXj2n0Itn8a?=
 =?us-ascii?Q?TJSWBR1+GVEDDwIp7Oo4mF/Dlu5pEFCdNSghJQunB/vpHC2lUF5EXRtCA+cY?=
 =?us-ascii?Q?EDqRGbp+4hbu+Q9kEivuYfZ0IBflWlEbsG2jI8xEHHvGNEIpiXTHlq7yVvKz?=
 =?us-ascii?Q?oIVA9SpyatbjqKEtXByZtk/Q4kQTMqyHyVAZgwMCfoK8Y4nDfiizPOSj2k+A?=
 =?us-ascii?Q?hIQbjTEn1T9aCJdpoRFI1/4OdpxSjTzqu4gtuhkrY8NMATinEUK+aT/YpaLc?=
 =?us-ascii?Q?wMc4PZOqZp9qTgFjhKHZFPvyD0eVjOUZv5vodXFaWScGXF6nBCv+HaoJ1NhI?=
 =?us-ascii?Q?KCjLkgByiUKHfe48qxszH8fhR0lhwl+twcr+I+91/JQcyCqqCENiNxYyIYic?=
 =?us-ascii?Q?FGTV6zT9Cip17bDxQfE1aVHc/lcRivE4gGnlPv5HxMXyNuH5xYtcNp0cshzk?=
 =?us-ascii?Q?iN4zsG7L99mQ1ENVbiIM4LRiG2zxL5na6oxzekwbucaiaFMgJojvzbWvWuxh?=
 =?us-ascii?Q?PaxoVNjfS6Xf0bw+XM+BQ/NVl78Rv036XZNTutFRd/Z1SnOtOMT88z3x+Dmv?=
 =?us-ascii?Q?7LdIN/sflH3uCgFD27+U9yalQFAWXzVHHOf/60oNs+TGVoXMxxGFt60mxQvA?=
 =?us-ascii?Q?WWdt44HA3vPMOXrFAwhYxpTaK7nUP5TPS1dFD/X3kZXhNjiNt0tjdRZvbeWv?=
 =?us-ascii?Q?gvSHlTIeKRfM+9lwbz9AN9VCfIJYnExDRviom8/uy+3W8s9+PmcNmzU38mjm?=
 =?us-ascii?Q?kXO8qyRaT8tTiOSVpn9NWLWueK8eps2dXnLNddRWs+/vi8iYPzbrC1wftio5?=
 =?us-ascii?Q?cSsbL2wZUQrMeK/lvp9yM0TLtxzq17YIB9VTtBIgwprloQXRc3mMFY8uxEi2?=
 =?us-ascii?Q?OhTAS4ZgUDU85LXnyijq6Se4bP9WRhr+AN5khbX9w6Slr2GuetwFRPOerA81?=
 =?us-ascii?Q?RHz8O1W/1a8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?us5+Heh6YArXO/X9t2Pb5d3sd64wVWh0qYQVmNDy6t56HnrOu46xTlNue6fc?=
 =?us-ascii?Q?fsSoAQKva6U4w5FNWnoElUT7Znp2s3cXzkqWq0dVCXCocY3obLZvS0/HIRlO?=
 =?us-ascii?Q?QxN+BG1XbUUumSijryHGG5le1eAWCHHv62PjPKdCU5Ln7XMD7B0bEPkAulAW?=
 =?us-ascii?Q?YeSZrW2MbIcl0yKKeLUDUJ0ZGoZ4VORff1RM9p+EgRp09LdW/NXtaaqNkYVW?=
 =?us-ascii?Q?iOZtFdC/BAMm1bSyooyxMQ7STiOolhQTPEeSxprAX3qIUyvH40dyqygEGrTU?=
 =?us-ascii?Q?3ekZJZufGY3HCnnvqFGwbK5N7CMRjyuufEv+uiwRavAWzYvHavrGCPjVhg/o?=
 =?us-ascii?Q?Bu1uy3oplJdVekHiuO9RWMQZvcDBJsCN4yjMaUzGxwyxCr7ILCJo7Bp2Dx+f?=
 =?us-ascii?Q?aWIMToqrDYy3sbJAccveasXoyq13RTr0zeLS1xe7uyCOlif+00z+OEVvArRk?=
 =?us-ascii?Q?vFYCNt9KwZwjnTH3lkwNfdYtrslDt0jgIMwbcXffZcWVePs3ih/TtNxDnP2h?=
 =?us-ascii?Q?Q2NpodH6IGApYdGOZTUwaFAUZJkeOd9mzgDI7Guz/e+YPNPFSSTAVhOzh+5m?=
 =?us-ascii?Q?e2bLc0/kE5kTQxo6scdO8iYcNymCIK8u8qMmkxYEoI8aYnD6axSlOmyUZl0B?=
 =?us-ascii?Q?eJhtmyO0+zv4TAsFNnnEn02KNTbuOpo9rtMpEJMyflRKV9NBV/xFIbGBjUfM?=
 =?us-ascii?Q?N7BMKENsIyUbqLkUTc1WWOxNO6L0NH9ER4sldZ4cc3N4s/83gHOanBUl0ad0?=
 =?us-ascii?Q?ajO5awUoHjNQee8Ft5SiMQLJKRbVlSu/PyNiOiO3j1JGNyiD4WQCPIbbDtBX?=
 =?us-ascii?Q?KfWMfPu+PWqjQvm4oj3uLRtO9yQeIWYKGGZpGQ1+krOnWSFRVtitwjtBD9Fz?=
 =?us-ascii?Q?dAvbJNOqJpFnp/CSX6YXpsuGGojSK3u1+4+TJafdIpOqTEYczotZ8JSUDrbg?=
 =?us-ascii?Q?Z+iyR6UhublZvqkrdWS7JSQ6j/iVxgIJm3qFkQCop3hY+rWQFoOfm3luw9DI?=
 =?us-ascii?Q?dGPmbHhKnblCpNgVH2JM4KBvUJrZDIAaoiOYjrk/k7yY1wVGGYGjx6rV/6iN?=
 =?us-ascii?Q?qRF76/Yunn7WqNIR5lZt84CAUz1tGkPLbwbXEJNDCDBxhCKRO6ZKqanGMw0C?=
 =?us-ascii?Q?hRU4vzWgetyk8mx7SwoxUNoieaZo9Yh3fxR4iRdgE7Rs0PSk8jNCsIbUhE/B?=
 =?us-ascii?Q?k6kZ0hPzGntprsQBFulGewpd/refkidzc+DtGYMRkjFTMTowPyzQ7YZ/2F4S?=
 =?us-ascii?Q?ickUHrrPbfSkq8E3cPEnX1vVKC2ac6w4WZEh1LXpf+zvFOOAEpJWhz6a0KoQ?=
 =?us-ascii?Q?LDpuGO1JV3Id/Gyleg+PlWyGZ2gmuWX7CLt3LO9Zg4BskCdGBrdzDCWIC9g1?=
 =?us-ascii?Q?UGbt93ihCQu35olllRznBOvsnlY2ILWB7gpoavn57ZVH6tzZuW73W1FZd1XE?=
 =?us-ascii?Q?tQRswVGICw4zXuNU7Sk1lmUqXtU1MCWEW7tIkpS2FRrN0Iw3jSIOzXOguC8v?=
 =?us-ascii?Q?9nEO5/1BTa/lzl0kFkQJZSWq8fq7g/LIS1aFtpZvZS1KGWx14TNVh2IjP4p/?=
 =?us-ascii?Q?+dFJVcykYFqPyjtkQwMd0PXUayEGke/q19AFIRdrDcNvjeOpqcRQP9aUSQ6X?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fbE2otAt3z888MsfL/GO0Xlq4Vne1+2nXJLxHL6rOJ3ddv/jct1RSNmsC8i/ja1ouRz/+L/bqpJMbzrGyDwEizmOfRFviwlIYRfbxHtD4LwZHMzw8Q7W5JoNflbcODPdw6dPTPyWMJWRvRnfwmfvjp8LzsklQ8U6qpDKhIHlY/m3gzLnpHyy7igXQ8r6NLQvvAUwREtMZRW6XEP87kRywBHyGbt0cFuASfGj8Bc85uolfmdKi3NsrnhUcKKP4v6GVcebuDLxl5SaD9qgCn0DXcFfi992oxFak66Al7SuESzFmsNWyDF9bFc9stQKspiKwlaNzqPT5NJa5PpLXum1ddiD0uqTX+tngVVFJA5Rn+7XPrfQde3/U0BIIP5dyQK6aLpbVAAcDymeqMtNl0MyVrohFgxr/2WxQSz6zcuUwwR33NsPSAdMWu4bJX3UApIn+sXoGRUA3VODKVhohq377Y08iqbGBJPrc+lQtzyrTyAgCc0q0V5e7qR35rgq5Z1U6ozUNMB4cgAobzLfw0pcSKqWoWdVfv/LJ6A98lsJx02wu+6uuH65cDv5QxREMDDGR8UKBYq2VpXLgwOdWvGbHQsV2GDy0HX8AeGpjMy8lbY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15fb5815-3bf3-437e-af9d-08dd795fdcc4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2025 01:17:59.1030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aen7IaHEi38MRNShKiDilsfi6/7L41oZQnIcXO44qoLD3fyC2GA8cyyyruq1SEIxo+QDCIdKk24QSYaDzovoUncsZVDR1ixrrXrG7gXCj2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8129
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-12_01,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=938
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504120007
X-Proofpoint-GUID: zXu-sQSIpSjEsMWhkUharuunhWPlTYt-
X-Proofpoint-ORIG-GUID: zXu-sQSIpSjEsMWhkUharuunhWPlTYt-


Eric,

> Add support for hardware-wrapped inline encryption keys to the
> Qualcomm ICE (Inline Crypto Engine) and UFS (Universal Flash Storage)
> drivers.
>
> I'd like these patches to be taken through the scsi tree for 6.16.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen

