Return-Path: <linux-fscrypt+bounces-1635-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id oDKeKUevKmrEuwMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1635-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Jun 2026 14:51:19 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D26DA672098
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Jun 2026 14:51:18 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=EWCIR7jE;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1635-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1635-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BAF503083CEC
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Jun 2026 12:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7EA93F9F5C;
	Thu, 11 Jun 2026 12:50:20 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012024.outbound.protection.outlook.com [52.101.126.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9665A3F8EAB;
	Thu, 11 Jun 2026 12:50:18 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781182220; cv=fail; b=doMnULjI8eFAZlWudRL5SrT/63CSzkXiKP3HYj2Y1lRkn15dirpOjJO4vsHfPc14OZHrMdLyJNAbx2jdG95YhaIe39lsa6OffxZDLD5FnpJXVouf6pBMzENrwnZvFk3WfBR8GEOk8yaWKRzMdbOjflFCUr1Fsr6LWAB4mcHm4L4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781182220; c=relaxed/simple;
	bh=mK1HjNIxps7HHVkgliVXwznfjZ+UdIpBjFtUTG9/ZS0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j+bD0xfvJi8jtJMqWDcCu2KpvXZjwyTF2B9h1PLtQYIhIvdt89RHkNwK4K0RQltkxOb1zZZs/W6pyDwOeDwEWWBhzAW4Ozc3gmlv8OcuAKuh0OAQ0UzpXGZN+y1hTiHfcH7C8J49IoRsKvTqf4aHPXInBinISgCGhkyzV58E4Ns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=EWCIR7jE; arc=fail smtp.client-ip=52.101.126.24
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M7YX5dRQOVuMHekpJSuYOVnRDQYMS4si9r+T3nkS3RUMurj0lEEO+jtekiPoC5nd0tD+6qobf0DR2+PPZ+P34AE/LK0AZfyjuQzLXu+m+P8d1iwPAp96g/1LJ0jpBvb6FvkzUdDxAN6zwj5POC1TFVuhLXz5UVZRPLMJ0j+qvMYdtCq0pxEdURck03ZGY05YkiOJoH7hyRywzPNuBMBncTRDODJyOumpo1QBUyWOjGCxW28cmscxG8zeKq2tnPWYGkIgIGjOkm5dq4dxVw74PMU07HZzbZ/gmTfebOVl9O1CrIQGCB7OtWX/WgTzMWKZXEKaVZ4kGsMojAVSaeltkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mK1HjNIxps7HHVkgliVXwznfjZ+UdIpBjFtUTG9/ZS0=;
 b=G5qDucPpW9alSDr78qSBEo+r/i/M5Kf2lICWCszyReQru6h6IuP5QMdkJTZaE8YpCvEFWEPemBcWvpLtRt3LUcYMKMg5vKltny2ntJcinNs4XeCzC5RJeksv/EqsA7QAb05IKMoAMO8GfNpQRausSjzWKIBrMvz5sd/zzUdBKniQ3nYdLpyiW+RUX/2hX7/MYFuXAqB6/trkSfcDHopoea+k3koFich/KI7Ul1cVWOFEiIvWjAfW4UqcxRgT5HZ6L+OK5x3hvIcPgR+yHv5hHXPMbckuy511Nh91SWc2fkX3lbn8wCqsESdVxN3/35ijCcBHemlyDKT4UKhMGPA42Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mK1HjNIxps7HHVkgliVXwznfjZ+UdIpBjFtUTG9/ZS0=;
 b=EWCIR7jEu15AEefQODYBuxfCNMFrid9xiOgvdEWiR3Q/ozuIwKManJ20B8hPF8tgWAPiCCoHyr70bWuJTwoCNL0P9SSZmhc5A9YOAbHGkyKkixAtwKzpfIohZibFVEZZUKbY7wvaPVz146UHzbp4KY/1W32CD1aLhwVPAO9h4MX5G2fJTQ1m1ZnpALqttBwfHbxxB8MnqguUjUFWuc3QwSZ59bK98BEbC7pPOdFWVaG/XVdHJaHB50puXv+A1EJDMPyTkelW6NaLZwoJJZ9yU0314MPXVBgfcvG5efd3SBh2NO2wSYt1SWz16EgMOOltJbTe3j1lflCh7S6CD1GNpg==
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by TYPPR06MB8236.apcprd06.prod.outlook.com (2603:1096:405:385::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 12:50:16 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96%6]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 12:50:15 +0000
From: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
To: ebiggers@kernel.org
Cc: chao@kernel.org,
	corbet@lwn.net,
	jaegeuk@kernel.org,
	linux-doc@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	tytso@mit.edu,
	liaoyuanhong@vivo.com
Subject: Re: [PATCH v2 0/3] f2fs: support encrypted inline data
Date: Thu, 11 Jun 2026 20:50:06 +0800
Message-Id: <20260611125006.508734-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260602134104.348655-1-liaoyuanhong@vivo.com>
References: <20260602134104.348655-1-liaoyuanhong@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0022.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::9) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|TYPPR06MB8236:EE_
X-MS-Office365-Filtering-Correlation-Id: 04850615-e8ed-4281-622d-08dec7b7fbef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|52116014|7416014|376014|22082099003|18002099003|38350700014|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	miL2lU6UmOKAbzIdWUfLkzn1D5bqhK1XSaY+s0Dh4UhRZE6oyUExeRVcBncDlf4UGiJW8nV44nCxRcX9+eFVtDIQYfBlhcIDexuDRWTrah/PTUqvhk6O2j+11SVbpaT21E6jb4pH+ZG5IjFkEiTBws3Dd/ADj/VdMyM9g0RWCHd+q3FSRXCwSjLBDTKL8AB4Fas7UnDyBQAigVKb6zWqMkAF91ypaxDv82KgmbX4g5ywFXrUQl4SZyb008QnezydGk09GZNctJhecupM+TBuFykGHaQYv4lFnjHjbpXoPHWrjO081NmN4OV45cprlPJd/VtW2UHb2OpVPIoY3qTLngo+x4quLWFMvZJepiBWhSvOMbpHpywFN4f+1TcgpIcxh9BEzdFxz0Gz22WClUHXrczx67vpnHwL+uu0Uv85/SQQ71MZKFwjMA/tTE+UZtVe92BlDhabczjHWCEXfmq2Fi+NlY7P0urXBFlqIuw4PsWXXvLzEpaIsYd6ngUqpi7oWrnsE7sDQzbd59GgRlLnkq3Bbk3krGLfJgLg7o874NB7lyuUr2BpauT7P27CJTu8gw+Fm9vL83GyU7H9A1L2rMS0DQc/T5GrvfShLQ6nj2/kjGoI6vHXEP0BlFN8JXg2TYV/fI20/qqZxNSA4lH1WuAo55BflabUyu8zXeio5584Pr1settjSqzt1o8H+/heOXtKGVcpw4xmsB50b+Q3gcS1WwZHXCsAs6mUaeJiQfbUUs60mw39J/wzK4DelSkD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(52116014)(7416014)(376014)(22082099003)(18002099003)(38350700014)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oB+6P2K+kwD/Cvom3nHHQ7ZKrCuiDtCz/+Jd092+HfB//Zft8MrNnDrAm2Cl?=
 =?us-ascii?Q?+NDN+uEOKZZYGTZL0HMplg/Tw6ZIAVT96f+cU+KFzdQoZceVvcOdWEgEo7m9?=
 =?us-ascii?Q?pkojfrJ+1K4b5Sk7u7dOCzjn8cInd9TNZB7SHRYOkIlbhfBTHo1aMrH4Mexb?=
 =?us-ascii?Q?dZUh0dCGiarcJxIu4vKZAdY81vWpT4rs2IUWrTVUK6VxoiBmCVkn/9RmfYnt?=
 =?us-ascii?Q?kkte8lM2+cWpTzS3wdqk0hHZFIrGhyqb4lDEAe4hy/RxHZJPOYS9lJmYLu7m?=
 =?us-ascii?Q?/QPhVEe9gQbmzwb4J5IEeFZI9EPiCO0LU7WUY8Pys7jUJlF4UJLaJ2DRQWZc?=
 =?us-ascii?Q?uFc8LWNv2pQXEN2chsTpK28rCmMEYqzdl7cW2+Di9EfpdM3m8UOrSzbXN5zN?=
 =?us-ascii?Q?QYRErCbHY3XbBG7HtzU1vvrdy27xKrh2bY5nFceMYIMtcKwr/Qn2HLZmFgzG?=
 =?us-ascii?Q?xgxWk2J8EkGcIsxsgVm8IMQS7wMEidl/xHkgfJ8IIbp3dZ85MZMUW3U9CjId?=
 =?us-ascii?Q?vDa41kXRXkxlrPmSD+ehOdc0WZyi1kkAzpYj8D+VkHw9X4rVhABsQHbQABEW?=
 =?us-ascii?Q?qk4C4ghnrA1Lsou4RP+5K/Dtl9KXm2lOupS/DoZzyzkQHwd5P/L3tciZw1px?=
 =?us-ascii?Q?RFirJZyYzMh9Zf7h8s0mthhtx1BHPKJ2r/sn+q1wlW0AfNTtJKzYhBpQ4VFU?=
 =?us-ascii?Q?juCf6295fZWBh2o211CS/FOFtsEybTPg0wOxaOWffusf5NNP9nysSQU1ya1t?=
 =?us-ascii?Q?aKwbmz6oPnVXWtQz4PLCCV8uEcxwBV1lFcQXVbcLMAWeD6nSmV/KaS76Z37q?=
 =?us-ascii?Q?5YcjlJ0g4C7q8k65tsCaoai83ggtEbYbaqSTQA4euqhFR0Tw3QXMNnxLTCvM?=
 =?us-ascii?Q?7nPAKQ7aI2iheraQW0J59KLLabQc8d6lnma87/ljDs6TF5lQ30dQWbv0RN+4?=
 =?us-ascii?Q?/ooMTV4Xtaz33KaGqeKoo8HtQdlAPgLLGtyNisGphBrFIqLCrxtsPGwz/oD1?=
 =?us-ascii?Q?1AMdpfYPLB3GSuxZA5mzTLqrhx/HCpFSRejZiOBsuyPzkR2QiKQ6Trm9qqAz?=
 =?us-ascii?Q?LCCoBkzb1Vz1qhkMEW397r7c8J67QNQ1pOtKk919fqau7MALVThpV+EyWVci?=
 =?us-ascii?Q?gkQNWUYXeDWc6T66Y62jnYESFx5CekI9Gq3Uhh+ypZMyWOfNlVV736VRM4fw?=
 =?us-ascii?Q?nPWbnuX/F3th3yeVIdpwYkL/pAVT0L7AkDIErPhCV9Xo7XolfZMvoreVu1FC?=
 =?us-ascii?Q?soMd4ru8kpDyj0NEJZPleQk/zsq8LWxpFfFOyc/brML8Eqq7zkRCHskjsuNG?=
 =?us-ascii?Q?uSfmcGXy2Wq/evEntdj9MQteM8YDe8IFr7AX3EOWZjWrBvqSZajQh0kjb0p6?=
 =?us-ascii?Q?ocHs2txOKEfLTMYKfiw2zBhPNSSOd+POiGdFtXqSojlw4AszvATL5YuawQz4?=
 =?us-ascii?Q?+sefI+jKip8POnR9qBhrjWMEZdj7S8/hNxZKlfNPDFjuCOvTXxeAc/ofo40I?=
 =?us-ascii?Q?i6mHCfwZp/RSsf8MeZ8pFVJ//Bot8dAc02vQjMZZyhZ77qCpEk5k0nhl2uuf?=
 =?us-ascii?Q?hTh388+flvXtbr4fgLoIDbg4V8lXS/ZS8eldY+OROtjx3XhmRMlpzNy8q1aJ?=
 =?us-ascii?Q?tzeKZpxNq5XhO4yTKHgJGSNb2U4dm90WJzKivwaX+EY0RMXX6lzeY21zbd00?=
 =?us-ascii?Q?TMuvkW4pVXJ0e7nX6rPPUg0cyZusAKX9iL+PWFz7DzT6kqBnxcCeJBAyVG6Y?=
 =?us-ascii?Q?GtvuDxcRFQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04850615-e8ed-4281-622d-08dec7b7fbef
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 12:50:15.5313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/RJu8oZvxTLY2vFydRdOHujsjOXYw+nKMhtVF8DqAh7IDX4STbMjUP8/vFoi1T0i32+/gBUnu6phV6OMz6/KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR06MB8236
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[vivo.com,quarantine];
	R_DKIM_ALLOW(-0.20)[vivo.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_FROM(0.00)[bounces-1635-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:ebiggers@kernel.org,m:chao@kernel.org,m:corbet@lwn.net,m:jaegeuk@kernel.org,m:linux-doc@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-fscrypt@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:skhan@linuxfoundation.org,m:tytso@mit.edu,m:liaoyuanhong@vivo.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[liaoyuanhong@vivo.com,linux-fscrypt@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liaoyuanhong@vivo.com,linux-fscrypt@vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[vivo.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	ALIAS_RESOLVED(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp,vivo.com:dkim,vivo.com:mid,vivo.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D26DA672098

Hi,

Gentle ping on this series.

v2 tries to address the previous concerns by avoiding per-file software
tfm growth, preparing the software transform lazily, and explicitly
disabling unsupported key combinations.

The main remaining limitation is hardware-wrapped keys. If this makes
the feature unlikely to be accepted, please let me know. Otherwise, I
would appreciate any review comments on the current direction.

If maintainers have any feasible direction in mind, I would also
appreciate hearing it.

Thanks,
Liao Yuanhong

