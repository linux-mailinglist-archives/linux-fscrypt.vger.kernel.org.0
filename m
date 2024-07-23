Return-Path: <linux-fscrypt+bounces-359-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADA3E9397AC
	for <lists+linux-fscrypt@lfdr.de>; Tue, 23 Jul 2024 02:52:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AA21B21631
	for <lists+linux-fscrypt@lfdr.de>; Tue, 23 Jul 2024 00:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D045B13210A;
	Tue, 23 Jul 2024 00:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WcOza7KS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oThe8Nv0"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B993B32C8B;
	Tue, 23 Jul 2024 00:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721695968; cv=fail; b=d0+e7RTqbWVv872KhW632oWin5troBz/dzcEB0O3YYf320Fpv7hL3LFWnheu91L6AcbIwTuZ99Ns94tcXROFYR4yOV9j7zxVgMqoFGjp/9TLH0lJ/wjAxN45lPTBrXx7MMCNPPrJcF9ntIKVlgO9C3WvfzXImkIZkmm93IN/0+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721695968; c=relaxed/simple;
	bh=uKhGfL6Z2ES+sXAYRWpQpcAcrfyQXWgXiFwe2FZD6Ao=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=k7fKEVqIVEtoTvfjbxMxG/cRT07Rxp7HOngW5HavfYNSIgITMMhLK32+ppM7N3g56kaQ6+N3CoHrO8u/ANPJM4k1ahERz+gCeMQnd45gcvFzyreeh+qZ9fKG52YO5SbTH2SPA6Ev3YB4/dTOwCHOhRyrlzsKr+qBwlfqeSDLpds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WcOza7KS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oThe8Nv0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46MKtns2018961;
	Tue, 23 Jul 2024 00:52:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=hGjaAMsKsU65M0
	X5VQyI33k+6eEJAkAedy+zz42nAmQ=; b=WcOza7KSsADKHQJC1iL5GZqFbcQxE3
	PpPG9/hb/EH70xFu1n7X9EtihAb1cRhZPia5Pr+2de1B90HOsp1VYFTFeXfpFcHT
	J39DT0/qTaXOcKlfr4TiQCt6d5C04R134MWS0xk/ri1D4WBYC5znSj/ClpwwjTb0
	r3phiQMvDK6wdKrp1VsgCVpe/r8KfuLFqvilrcm44s1UijF38nNfiwquV0y3un9M
	OIm3xKRHar1+Y11B6eEhCdJYPQ4IF8+DGa55Ao1w4v4G0+/gYDJKxLDnYZYkpro+
	Osl1wnoar4azhbyX0oPmiuNGZ8La41E/D6CMHArgdjmmyL7dEbPp3yDA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hg10v5tp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 00:52:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46MMq7Lq024617;
	Tue, 23 Jul 2024 00:52:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h2a0r3b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 00:52:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LWkr3NhywYC05zHSvHmTx7kq/VeFRTNivHN8sgR3acDk2dk9fTdRbUUKLTf1g/cLuUu15Y7QnRjdLSM8Cc8IV9NiWo7trWO4IY5qXiHvazmQmPc/v4kBc4W32huK9AVfQ4gIRX5Z5mLlJrIDiI5ngP93Zp1vTjWhQ7R1hsi6054z/bbYT+NM+cfVJWCkCgOvFcue3iseTnY+dNT/Obpn6pgmtTmOTFkCZQmQGTlGuiu7Rg9pws0NP+65osKV63qsJbZWpMq3juFdyoc8EiNVsfbq3dSshdqL2N3cbczNGflmD2jshfJUXv824v3g0RuoFpfF84y6cKSYvoBCrlwEUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hGjaAMsKsU65M0X5VQyI33k+6eEJAkAedy+zz42nAmQ=;
 b=WfNOYvTmOb83BpcFQSoLZg+DnyxXQvZk4/QmLMqe+0fxVGJwiisN/YBp0h9kLuVRt6CiXOOdg8C4j/7/u6Bygmzp+w0GJ6bVj5+YpkOhFzP++lDGNYPvmMD0CNiOqMSH+rgO1A3/yirKX4lnd2aVDD8hBqSrHJsbKnPvkDPAIypBtAL33YYzEhTYjUbHhFW6PYzPYAYxMKV0Y7BrC5WOpGdpQ1FP2/6eplOL4qcrVFwBW1KjLhK9fR2mymANZDQxMRvkcRTIjIAxXtaEarIOJS2vlKVY+tI+9ahkxy0EUnH4FZGwNk45oD4XmY7oeKBZvteFPUA8UsnsTgkP+sbsGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGjaAMsKsU65M0X5VQyI33k+6eEJAkAedy+zz42nAmQ=;
 b=oThe8Nv0V2pOhKIYzs7A5UgsWaD5DgouGZPIorMLcfOvpFSAkXnO/yvpZTwB5c3uFOT8h7Y/ZULZZgF/B9Bb1/Od5K4flO3c6QN7PasQE9xEvACU5JOdpX3+JxAu9n4l4NHOX46SmzC4d5d37JCgfHGS7YkH6fZkG4XtQo2f4IQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB8128.namprd10.prod.outlook.com (2603:10b6:8:204::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.32; Tue, 23 Jul
 2024 00:52:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7784.017; Tue, 23 Jul 2024
 00:52:30 +0000
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
Subject: Re: [PATCH] scsi: ufs: exynos: Don't resume FMP when crypto support
 disabled
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240721183840.209284-1-ebiggers@kernel.org> (Eric Biggers's
	message of "Sun, 21 Jul 2024 11:38:40 -0700")
Organization: Oracle Corporation
Message-ID: <yq1plr5c4l8.fsf@ca-mkp.ca.oracle.com>
References: <20240721183840.209284-1-ebiggers@kernel.org>
Date: Mon, 22 Jul 2024 20:52:26 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO0P265CA0013.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 842e9fa0-9973-4b41-ba18-08dcaab1bb32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dGXLxZ6I5T4Coi2JPjUL1rnn09ar7bC+Ez0FqpVAOClJRbkNeuoknOqaajVj?=
 =?us-ascii?Q?9B2gLudL38dQWi0PcZzwFaf0hWzRGL1s09sgdIy6vKOrYtcFXvBW9fdH2A1p?=
 =?us-ascii?Q?IiyZVO8HNL1+xImNYq9arBP3S0aH6inwUcJF1/06BJfcwRUA38IApGnRTPc8?=
 =?us-ascii?Q?GTioox2gIMV0rILKjuTzkjF+VppQfw65VjjvV8CEPk1RnfKhkHwUkhojsR9Q?=
 =?us-ascii?Q?t+KoPRCd2nXP+7z63quioBgYGNBtjZab+S/eIwFV393hsncvGoGEbA8wuQyr?=
 =?us-ascii?Q?dnP2MbzhwR/h08P3mStBZ6iq9XDPt4AvMKvSqXx70z4+pF/bntLwmbYhWQtB?=
 =?us-ascii?Q?D9EzjoPDyof+hdEuXpwZIEwqFw0qK9pxX6soILSE3zC685SFyqZZS7Uua4fY?=
 =?us-ascii?Q?3BRF/LcoBtqqz1ynOzeMALGBDZmonM2zuzt+B49sDuZm7RnGHcViwwKFDWy9?=
 =?us-ascii?Q?fCI1cjzdIIrx1X5/mwmug2GfwptAvDa1LbXmtqKQtwrfRoBHjdw3U9TrwLYs?=
 =?us-ascii?Q?ynaMPVH6xt0J+uWggrZiFGOJgJLEdx2eW/m5wQpPOXL+DEmAHI0RyPpIbuED?=
 =?us-ascii?Q?7vXXQD3DxoB31MY001BospDjL+lgMkJoDFRVb9zyQ14eJgwzw4TNI9vvBk9T?=
 =?us-ascii?Q?KroQDLvWuwbGUH6rts00a52H4KvI7/YF/WJN87hi7zZ3qy1qtMCUuWPLcjI0?=
 =?us-ascii?Q?fUh56k3vEAi1oD6r0DElGJUQsfmxDUvKCADJ0dPpeIW7K7HDoy0iYY7vJtpv?=
 =?us-ascii?Q?Cr5BOKqWShS6LDorQw2Zv2V8jNTnEQo737yWd2rN/E2/m8MPvH+Wl0Sl0z8s?=
 =?us-ascii?Q?cowRXpy0tliavluFAjWkHNHO/HTq+SKI6Mso36uINk9okkk6228rXPbrjcuB?=
 =?us-ascii?Q?eZ1aBXtfD6kaZqJUXbsVKM1vWxa6HbHeYt0h6268HSpZ2EobV9QBBfI9LdOx?=
 =?us-ascii?Q?E9sDyRGXaAI2Rd0MB50sTEv8RVv4ZsVE+/6CfW56pizpUXUVW8dGgSVjs4aI?=
 =?us-ascii?Q?vEn6fpoozXCku542nXjaUKKv5F7f2vBgWDHT59sHYs5FEXAFn0CiG0NUj1Ef?=
 =?us-ascii?Q?aDVgRHDQJAW7y81GZ39FZuNHEmntDJ11JBRI9z8JptjkKfHLcYajd2sn9HXN?=
 =?us-ascii?Q?gYxLPPVZ6CehM4dkkHG2IwK4pC90Nfo+CdzcuduY3oAJkKSnCoaFlRIr+6FB?=
 =?us-ascii?Q?TttEvEYqh8MoJYZD8CsdIRH1r6kEZX32sYqRfmI2f/6kTHhji//fpu/WCNtg?=
 =?us-ascii?Q?w9rLAXGpWK1bSgYdqrVM2cdI8mEKFRhrp5UWUjdNV7FvMHgEy2+Ocxwvl7RS?=
 =?us-ascii?Q?Bu9XsbcEn96n1ZqMz/d8RXJxmWQJ25bSSAuJLkq7Rq3EuQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AOruSX36iT1aVxixmedbTTQs/XFRqmVu301u2dLwXpKFJN+PsB1ycralM0K2?=
 =?us-ascii?Q?AL4x86Fqv+cEbfO2kr7AMeSv6rup2+8nb4+aC73nSLSecVYIvTIFIGv/DLck?=
 =?us-ascii?Q?zfYnz/fXJsTzTSg2dqnE4XUzmH/gULrpz1bdeA5v5hZ50PPXzrUrtjhM1BY/?=
 =?us-ascii?Q?+IoTSZxK9URna2gS7L8/EUZMtsdQpS19YSgKZN0ixZ2eGb/vzGRxIVy4A7JP?=
 =?us-ascii?Q?Je4DnxM2UTGtWT27Ww+Nwd7O6PqRymF2Y4rQrYZr1BVNWnU0vZv8e6i9wlCH?=
 =?us-ascii?Q?VpXxCwmcuxcMvlxBixnut43v4ehk+g2oOUGZ3fYbSDHqzlkVG1RseX0jDqlm?=
 =?us-ascii?Q?YxOswCBcfSsUDZfXuQ7RvDIJMmvsHjGFvUXVlLG20WtSBpKHAKFHjX3YDDEu?=
 =?us-ascii?Q?UalzosXL5mSydLxc1yVkNEOEe5uKrqlgJrzCoeo4fa4Rnq3XAMDB+vqvPkxT?=
 =?us-ascii?Q?QrqTZfY5F303vB2c6IGt1C0Sul0Cdf7C4le4xuMd7tcf6IdDqktWtlK5SttY?=
 =?us-ascii?Q?6NAOkcpluylunktHLUCMPArUCI1DEbECpKi/JrgKRyjQv18qR6pt7AIlbbc8?=
 =?us-ascii?Q?pFHsxYpoFKBnqgCcCr2N8Zf/nvsDLzp/HOo49JY2qtqrtzbtr9XhhcfOPza6?=
 =?us-ascii?Q?qnA+e3aXIiihs180/oi0SRe8hPFreDa4YnEGWMu7ALwKs60VCDIkzPnge2g/?=
 =?us-ascii?Q?phDJVyQA8VpB71xuZy02gVQDCkPBLWzX0OKQ9kmhzVMaWjacN4Jm+EbYwaNZ?=
 =?us-ascii?Q?exs5RkDEN9J7RifkLITdzgzsxLuZM8F1gFdMuI8fsYNOckUCLcmYkjAmZLZP?=
 =?us-ascii?Q?JTGS/DHcB8Y5kz6gFvmd6+EeIk2fsCbC06ThYAgmDe0thN5yjC9CvhcfqPRf?=
 =?us-ascii?Q?qe76YBhiJ8JWpCTQkvm3WV2gMivqeDszEXNYXSp2hnpTtk9B/ZIA/Jseahx1?=
 =?us-ascii?Q?5n0a3Id9j7fCAp4J1qEHw1JpSAqLkc+7R/vhYYcWhKxQT/cGF12d8K8dKCKT?=
 =?us-ascii?Q?o3n+WKzbFaF9TWqRYanKrGO5CkX9b3mz+rokdyd7088ZPGBzgyrdemhseUOh?=
 =?us-ascii?Q?NwTgDRzGtWm0uag8xEbuPVHQo0HRUlEX/HCSc6H3p7HKNqgS3MtMwG8ji7wM?=
 =?us-ascii?Q?u53mpwWqj91s/0sQsHQTL6MTR9iYee24hXkLfoIck8pWcj+gy0EOn/iP2M3J?=
 =?us-ascii?Q?BlzwmtjtEJzzxeTP7k3+16rA1svmdIjWqyAtrhk7XufOQufM6nyuQuoEmZXz?=
 =?us-ascii?Q?ygU9Abbvdsy2jA9lX+J1qM48Xqm+PeKBNcMXMP9/jTkQcnpiKhi6viEdQQ/G?=
 =?us-ascii?Q?ZtZ1zPaw45uu54HBKVeOnpiHb5LSwstr54HhUM1Dw+hlz43siNpqhCspXaN2?=
 =?us-ascii?Q?9TWAjFbDGkfPupcObiBakipaU7wLCx3y/Xo7oevnHZmnj7aEJAvzh/09J/QY?=
 =?us-ascii?Q?aSR/2HWu52pPudfyswkqwpF+7BTT2tP1dNx5qUDg6KqwCm9ZPuwu76xd7Rsx?=
 =?us-ascii?Q?h7EhmnvpylVuVow8OvVQuetqiNhKB83vs4cBcA3oW4c5gaWaAuMWtBqW9iff?=
 =?us-ascii?Q?xz9z3EfwW4B2oorQ8pyJT95hXV780hgUqWV3WO73UbN56y2Q2JeDx4o15Efe?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3pzE9z7qUY4qk8Oy24LmPPNNK85AS7R+ZRarPpAtjIL3iQkFa7RdODtsLeEQlZH8+clDWPFClIYwtABgoe51966Qy3/II7oGUTJbasY6jO4kyAEnukCXuX6KPq1NPpmhxo5Mn5/TbMvAnXDk5bGTXNXldERecg0sNakD2z+8InHs56PWYOvceuc/D54rLpCHr5RXlmWC/2C7mk6Rpfq3pdfwvqYwYZpR0SCRRZXXC1LOjGjfYbaV7h+FTIjZJwUbUioz+PjtrkZTEfooFCgcu2LMpdFggNW7UWjld0pi8/QR1UWaHgNWj0FRFiQaUj8VzePm+Nig2wO9gkLDJUIswPacYvqasY0P6cBBBeEUxhO8D9oobYyf+Irdxzjy+jJ6BqCSYdOtkmmYlXkXdD/r8djitxutrlTgtJbSs4BBkJsjpoxN5WvdwukpwB3zH7cTxmKQrL+fBhPsihJPITxfH7LyKLLPi6FIddb/BtnxdB6NFIbVWiAfMKEKAznPjJ/Y7NPrJL4CrpzjeQoWUVznqEXmby2vmFulaC5mOdrNy40qjFva69tsB+YTUY2qMqTLk4EJDDNAdcB3Pbu1k2yCOYcq8ZCy6+g15gPVdl8ZEd0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 842e9fa0-9973-4b41-ba18-08dcaab1bb32
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2024 00:52:30.7213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DaShmInISJLVxGiH283+u5kDM3Ui6I7UuKddc4nz7+G9rBUCYcpzTCOKTvEIcqX+yCJr1fsSrdRR5vcz0AYfS2eCrvjpIG9BzCXuC2jiNHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-22_18,2024-07-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=753 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407230004
X-Proofpoint-ORIG-GUID: WCx_ZigEsaTGVv9a2tOUDCAdvLMuV5Bw
X-Proofpoint-GUID: WCx_ZigEsaTGVv9a2tOUDCAdvLMuV5Bw


Eric,

> If exynos_ufs_fmp_init() did not enable FMP support, then
> exynos_ufs_fmp_resume() should not execute the FMP-related SMC calls.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

