Return-Path: <linux-fscrypt+bounces-971-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C6FD7C66016
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Nov 2025 20:43:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A7B484E03D5
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Nov 2025 19:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76B81DF27D;
	Mon, 17 Nov 2025 19:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NkW+YgfW"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD86C276046;
	Mon, 17 Nov 2025 19:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763408579; cv=fail; b=ImAuGpQszYBcMBQL4LXMgtqBId0yc4+1q6kaWNTp4ylBnS/nZNM01TdbpgRXKEJUhXnNeZQWit1kltVIY7u2nxqXat3EaJtmbB2mI0n63CP/xoL0D0Q3va8OByumkyDgPSM8XwG0wqgCE9c9ZqDS69EC+y6BYibG3DqQMavrEkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763408579; c=relaxed/simple;
	bh=eYBP4dCBuTxWTF+c6yrxsQLqQDNEhO6UhDmyRV4GWqE=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=EORRYT+ZowU0EvKRIUvNtQ/klEJjcJTa5hkj7Nrus7Hc7zyj3g58ud6CIY5q3XC6IUtIVX+Tqb7CGdDvL109F/TgKr1LghxeV2r7JIe2GoAgQCnxf72OlOUi+x7AGPhlDiowZYVY02HZlyoXwbQMpSc5w+m76JPE+UZjSIrd3Bg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NkW+YgfW; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHEJrjm021095;
	Mon, 17 Nov 2025 19:42:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=eYBP4dCBuTxWTF+c6yrxsQLqQDNEhO6UhDmyRV4GWqE=; b=NkW+YgfW
	C4qQ/eEtezpfOwPXIBWXMbZ1bOmUPFXv4gX3Wm3xzpAQBp4iRbJ1AxmfWgr15nRP
	3sm4M4X3oR57ZrNiBrPQlsMVJnT/ng/9nXu9auKrjGmuJyAZXav9W37hpsFjmTur
	MlOMPB1/ErBIqIutnIO2SzcnQLGPkYLFTSt5zMWvR4mRNT/JCCs8CHJiD5tbqnFw
	ZlebhpUqlEguPMgGRTqw+sIWnbP4JidTkc16dAyp3QboFAmiNt48RS3gXnpOiyFG
	ETPiWrpGFFIm7ZqQ4gCw/PRVZdezhU136B+NstHTDQFN+kWUvWVelbIxx7VvsycN
	jefM4GOprn+3+Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjtqkpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Nov 2025 19:42:29 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AHJfx1K028337;
	Mon, 17 Nov 2025 19:42:29 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010001.outbound.protection.outlook.com [52.101.201.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjtqkp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Nov 2025 19:42:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JgJ35X1+HMvyQ8BNJRhf8KuVcOx2YwOs2nnsZPfqHzT4FLOXv4uQn1OB01z8vytu6dch49bOMLOj8TOJjXdbjfxfbnEwda+7xXP+9pqkXzrzwQO4bYQ7b30U+qlWN20z+iywiN24WPDT1lqGzH19/n9f62bAiHeSLu2TQ6nV8yGbp8GkSLm6chAN6mzJqdX3vCh5sRGngHn/lIxNTURmObQ5yq+sW1SYH2w6uPJGCLeYSZ2t37nO82tmj1zzNkBGLcXA5/8z2HgUQnwQ4lwrSu7U0o1St3nlvyvIg1nL8GrxtpD9YpjidMzZqbl+03Xxm2IV0cQfjlQBzdsaSauFfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eYBP4dCBuTxWTF+c6yrxsQLqQDNEhO6UhDmyRV4GWqE=;
 b=rIpO5J5fXcuwqF6+nzGezGi1Cr+rJ1nHls6IiTIum2zYw+oUhJx+e2400scxKpYtz4EXC2YBenSajd4Fb0YRLgeM7pOSu6OS9DCNh/Bl7T7tV8R2Shj+cZSARiA1DffilYfMp5KPhfCoRmATEYFeQ0JGFcPWCLMV9vGJW7oETr/RNuZHVPKRs8/cczhAEtxYgHZt853fzfBgTDhbRVnUYCsSD5z+x69ItrlGwGBfXTBLjKHh7oU+kU/7S17gjWhtMxjSYksGhyYrvVvRoLI19c2LvcwRFX2mpzq39/PUxJ1dzgq6xIxPIDNJTyLRsaLq5sXCAaPFLQcXcKzeCNciFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CY8PR15MB5505.namprd15.prod.outlook.com (2603:10b6:930:90::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 19:42:25 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 19:42:25 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "409411716@gms.tku.edu.tw" <409411716@gms.tku.edu.tw>
CC: "david.laight.linux@gmail.com" <david.laight.linux@gmail.com>,
        Xiubo Li
	<xiubli@redhat.com>, "sagi@grimberg.me" <sagi@grimberg.me>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>,
        "linux-fscrypt@vger.kernel.org"
	<linux-fscrypt@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "visitorckw@gmail.com"
	<visitorckw@gmail.com>,
        "hch@lst.de" <hch@lst.de>,
        "home7438072@gmail.com"
	<home7438072@gmail.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "tytso@mit.edu"
	<tytso@mit.edu>,
        "andriy.shevchenko@intel.com" <andriy.shevchenko@intel.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [PATCH v5 6/6] ceph: replace local base64 helpers
 with lib/base64
Thread-Index: AQHcVuTze5+5k8xJkE6UsebHAHkrOLT3Rs0A
Date: Mon, 17 Nov 2025 19:42:25 +0000
Message-ID: <e39846e70cf60611400827614278895104cc03be.camel@ibm.com>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
	 <20251114060240.89965-1-409411716@gms.tku.edu.tw>
	 <afb5eb0324087792e1217577af6a2b90be21b327.camel@ibm.com>
	 <aRmpQmMtfZQ8f95s@wu-Pro-E500-G6-WS720T>
In-Reply-To: <aRmpQmMtfZQ8f95s@wu-Pro-E500-G6-WS720T>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CY8PR15MB5505:EE_
x-ms-office365-filtering-correlation-id: 38ad258e-b6b7-44af-b016-08de26116f2e
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|7416014|1800799024|366016|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?dTgyMmY0WGp6Q2hoay8wNFd2SlJCWjhCZ1VLY3dQTEFaL3A5SUVEYm9NMFFa?=
 =?utf-8?B?OXJ0bmV4NkdaTlE4aVhLQjBuRUNOU0RRWmR4Q3MzZUFSR3VnY25ncjQ1eDEz?=
 =?utf-8?B?TVlLZm5tbFYxaHFOZy9lakdRSG1VajAwNlQ4NUxhS2ZDMW9TSkxJYzh0K1dH?=
 =?utf-8?B?SE13QTJmRU91MVVJS3JwM0JzVkRkR0JyTkZ0U3BraW0vNWExQ0loRFZNbzVl?=
 =?utf-8?B?blNMN3ZCUE42RjE1UDkzS3J2UTk2blJxYzRsbjVLSy9ZSzZ4cnE2K3Ixdzd5?=
 =?utf-8?B?MTl0ZWdNWC9IdWFUZFNDcDI0SW5ERjRWQXlIa24xNk5Ra0RBT0dFT1BXMHAw?=
 =?utf-8?B?cU9OdWFibmxvMld5S1hpZFBmOXFMNTU2dGxWTmVzQTlUaVYvc0VhMUp1NWN3?=
 =?utf-8?B?VXhBbWd0VDNWU1hpdkZvMHFMWm8wZ280anpoSm5vOE1RZERPY3FQd1V5ckVU?=
 =?utf-8?B?VXJQTVJ4eTh1K1dDK25WaTVNZEQ2R0szaStWcjhoejJmeW1nRHlMQUw4T0ZV?=
 =?utf-8?B?SElTQnNiRGZXVzlnNVNxVWpsMmVKS0lqMEJOTGYrazVBQ3hiam4vQjRES1Jz?=
 =?utf-8?B?WnZSdkFZQWZkV25kQmVYN1hDUG4yWjVGak0xeDkyNzFBdG1DMzlSYmhkQnFV?=
 =?utf-8?B?MDM4cFVtczNRUFc5RE50czg2RkR1a0t1bmxyUDZqcmtBZnV3a1gxVG1Ub0hw?=
 =?utf-8?B?amdwazNaSHJyYisxbGJBWlBodzJpUWpleFFNWklYZ1NhZ3RrTXNrUm5QcFY5?=
 =?utf-8?B?SUtqK1lIcUdqQndqc2swYlpPbWdKTHZzYWgvSENlRTNub0ZoMEpkeXp0UCtF?=
 =?utf-8?B?Rm1ocTBWY2NkK2Yyc05OdGFGOHVrWmlMTW1OVHNpVDBnUFc1MUhkMnhaeS9z?=
 =?utf-8?B?Zlo2Y1JDOTQyYlhNT3BxRGRkVzYreW5tM3gvNUpsSmVTdWlNcUNlV3RRZGlj?=
 =?utf-8?B?VGVxNUkxbjFjTlBHTEFMNG5rU3FlY1ZFZnJFREFPZGprTFQzWUdEQnV0VjJK?=
 =?utf-8?B?Qi9od2h1aE1XbmNmZ2tqTmR2eWNKbzB2REJrVDFqMzZsSlRLd2xRQVdQazRM?=
 =?utf-8?B?Wm5DdTkzMUVuOGMwYW0vbThNeGw0eUlMa0tFUUxyNGNhNGZyRUkyQ01Ca3o3?=
 =?utf-8?B?S0Ftd214dHBNdGx0eEpuVTkrVTRhbHYyQVdWOXVLZW5qK0ZIa0hpNVdsNXV4?=
 =?utf-8?B?Nk93UHZXanFLbi9YTnNzZ25qRkc1ZHVUdXNhR0c1d1BvU3F2a1l4ZGFONU1G?=
 =?utf-8?B?NWhIZXpNdmQyMDMxWFhhMXQzbzBrbDF4bmVyYmtlYms5SXlVSnpVdUhMUy9C?=
 =?utf-8?B?RkplS2pTSWp6d2pCSS9MWmViUDhuSFR1WiszQWh5R1cxT2pWU3hOdk4ra2Nm?=
 =?utf-8?B?ZmlJUHY5YUUyYTc0Q0s2STVuajNOQ2puWUNqd1FBd3h1OTVNYmdzQ21vQ1E4?=
 =?utf-8?B?Nnc3WHFpSnJpWHhJZjNsQWdYd2xibHNLYkdOeEM4Mk1OVnlGdWVYa0JkMnpD?=
 =?utf-8?B?S2h5K2pNK0dIYXhrWFpUQnQ1QWxZWnZJVmlURlo0SzllL3RpMUZlZ1ZsS1Ev?=
 =?utf-8?B?OHhhRUdvcFQ3blhPamFlc0hmbk1nV01tWjFJM3NpdlIraDlYVXY1OGRzTkl3?=
 =?utf-8?B?ZUlpYWRrZWgycHJabHFZWVNDTHMrS0pXTFI2TEg2dm84K3RKYll5ZVpPYm4w?=
 =?utf-8?B?U3c1Yi8wTDBIc2UwbU1zK2gycmZKUEcxK2hiZlBBanRwQkZtWjJ3TFdzQ1hu?=
 =?utf-8?B?NUVVZWZQVzQxeVFhV3dtWERGVlNKSDNjL1hRZjlwWnNJYzc2dVJqOEJIRTZR?=
 =?utf-8?B?U01QLzB4TTlCUVlXQ0lTYU8xTTRWUnM2UUgzMkhQcnJGYnJKVG1HWUlyZm5t?=
 =?utf-8?B?TXYxV2pWY1AzQlZOZk5hZ3lPRjRxYmRNekswWVRLZUFyMmp4aHpWc3ZGUW44?=
 =?utf-8?B?N2Z6MXF0MUtlNllHMXVWM3I2TDh2S1NXS2t0NTFqRGxDRUduVmliMUZPTjFK?=
 =?utf-8?B?WTZWbzRaSU10YkxPNi93VDhMbi9UZU0xNFlyeVRNeGhWTHNpMDFsVXdYaERG?=
 =?utf-8?Q?iBDbz+?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(7416014)(1800799024)(366016)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NExlK09nNGkxV3FGWGhjU09aYmV3YkFJNmYxS0I4cGNMRFFvOHd6QnpXY25u?=
 =?utf-8?B?NHUrblR5QlhBbHB2b1ptOTZ5L09JMEp3bDQzWVVLRTY1SjhuQm5STHZ4aDJI?=
 =?utf-8?B?TzlQZ2l3RUZHYXpnZTFzSk1GOWZDUUtjZTdHWVFUcnptMWxtSk1nZklpRHVz?=
 =?utf-8?B?VTJuNHFDTnN0clNDZlY1QStJM050dGdlK01jMUpNNTVJRHZSU1JJRlIzeUxB?=
 =?utf-8?B?Q0tGRWlVd0RISWM2UkdNL2VwbS9LYUg4STZSTTEyKzI1ZVB2WnovL3pCaFlj?=
 =?utf-8?B?aHA5RmRJMXl6b3gwS1dNNWVaaWQ4UTlSdytNdGZlUFNoNDJtV2hEcVU3azZV?=
 =?utf-8?B?bDFYUEprSVl0elRHY3p3T1hTUnVGQ0JSWCtQN1UrcnF2LzBWSlNkZHdsRTFz?=
 =?utf-8?B?U2R2WW5EQmlSK0MrblpSK3JTMUVjZmltelBzVFBNQ0U5YjhqTnVWUnl0U1VL?=
 =?utf-8?B?Y3ZyZ04yWjBVQk1RMjZqRC9MeFBTYzhWN0hJdEpqN2ZmenVJZ05NKzArREth?=
 =?utf-8?B?Mm1laWxDZCtZTmFRZmRPV21uQ0RtcUZSR25RY2R5dEUyc1ZJOWhaWWV4T091?=
 =?utf-8?B?L2pOQ3RtcG5wKzlDdGFmTDRCWXJna0p1eWZuSzVuN2dYSjEwVENvU1EvNjVX?=
 =?utf-8?B?MlRrYWhsSW1iOUNuSkdaRWx1Q0N4RnZGc2ZkSjE3ZXlhUjlmbnJxbTlEbUJ2?=
 =?utf-8?B?YnlaNWJuSmM3aktNVU5vdmF5NXRjTGFuZHVQcDQreHF0Sng1QlNJbENlNzND?=
 =?utf-8?B?dHpFcVVqL1JQZU0xdWoxUEhUaVJQRmsvSHliTzk0bmo5bUNZSFVIeGhmWmYw?=
 =?utf-8?B?SUZwZXArOXZpRXRNemd0T3hHb2RyL2hBUkgrTmQ5Vk5rdWRzMW50NFg2NVFi?=
 =?utf-8?B?bWVTTnJsZFJQUDkyUmZCb3laMUgrUXJmMnlMb2VycE4zVnk3UWhrNEoveGVP?=
 =?utf-8?B?Mld6SU04UThhNFQ4MkJLNndoRVhHdXFldGFzZVRaU0swalg5S01vTVdwYVNu?=
 =?utf-8?B?TlFrNm1LYUVzV09jbmdPV0xPbnRHUzFSYVVSSjRFMmZacG1XYUVkQVNIY2NL?=
 =?utf-8?B?U1M4NkFYSkZvWEFzVE0rK0dWZ1F1SWMvYnhwM3J2c2R6RGhLL29WZE1Lc1Z0?=
 =?utf-8?B?cExoeVZpNnVIVHNSbnVPNU51TDZXQjN2cVBsa3lnT1NWdVIrdGZMc1lxTlo1?=
 =?utf-8?B?KytSYk9Ba1k2dkVjdXZxb3V6MEpyVGFWLzRCTkU5SzJzakFacGl3YzdkemV1?=
 =?utf-8?B?aGhZT1NMb0tZQWg3eWl0Y2pEVU9UNXJDM3ZkVHdGT1RUUDVCK3FQU0ZoelA0?=
 =?utf-8?B?d25pYWtYSHUwck9qTzQ1d2g4dXlicmg2SEpFZFFYWDNKbUZYZ21mcG9INjdX?=
 =?utf-8?B?ZTlObjFNc1dvTXI1NjZ4YmJHamFJTVVTZjY5UFpkMnpEclZRUmU3T21wdGVt?=
 =?utf-8?B?Z3YrTjFaMXRYV1EwWnFQSzhnd1A3aStINlF2NThpSk9UYW9uV1hFbGcrdzBt?=
 =?utf-8?B?c3ZmRzZuc0dXcUpxT1lNWXEwSEp2K2IwNmQ4bThXTVJCd2o3T3IxU2hYTUlZ?=
 =?utf-8?B?UXNtcVBuR0JWYm9EY0JqMEVkNERSU0xJR3JCYkY5Q1k1NEd2c3JwTEZkZldS?=
 =?utf-8?B?SDBSTzBTbExDcUNyTFZ1VTYyTDRVcWdESUVUMXRSZU0ybVRWdUYzMERtemFo?=
 =?utf-8?B?Uzc5VGZPazlnNUQvUXJQcWU4QVZGVkZhLzBnbkl6aElVUFNYd01jc29RekIx?=
 =?utf-8?B?eDUwUTI4ODVYZTJFUmtnVTUwUG9NYzBTOVdtYU16ay9QaGUwTElQbVZEeXRz?=
 =?utf-8?B?VnBYejVjc1BJRmwvZnY2QzMzeHlWMlkzVklLbDM5Q1Vyd0NXRzFlWHdyamo2?=
 =?utf-8?B?eUJ3VHp3cHM4R0dQd1A1bDBDWUo1V2liSUZ4YWNHMnRIK3R5Qjloc2xicFNw?=
 =?utf-8?B?eGg2djZVSmxVSG50RFNQOHhqNElVVThmUzk3Skw1cUdxc1ZZcE8rNGNTZTBJ?=
 =?utf-8?B?RHBxUm9GL3NvZzhpU2tpVnFJSGIxK01ucHpZQ2dSSERoQlEwMHErOHBPT0dP?=
 =?utf-8?B?dmp6ZU45SVZSaWljNlNqUUMzNjMvUEx1U3BEVlVXNUNkdldUT2IzZS9WckFi?=
 =?utf-8?B?Y04wUmhuNHNBWllqaWUvZGQ5Zmk3bStJSVBENk1rM3Z1WTlneWozK1d0VHRC?=
 =?utf-8?Q?YHAejypybzY4LMZ4++GsObU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6FED3BAD55455345891E747C72777AE3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38ad258e-b6b7-44af-b016-08de26116f2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2025 19:42:25.4684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2wqxrT49OFkTLrFHM3tBTX90GN7o+UzRH9yPxtCvXw5iVvqvmfsvfTZ/XtQ/7AhufsdIxSKkya/4DoD5zyeA5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR15MB5505
X-Proofpoint-GUID: iSCkeWI7z4YUCpnQfU3RNzs1i32hwLrf
X-Proofpoint-ORIG-GUID: 8ZCOALobOObbtDFCoiyyx3rQYT3Mpkgh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXxQtEhmRUsrh2
 OIXsGNecPs/SHuLlQP6WCPhwuFEQIdlZYoYcB8k+y8+uLzytc0BP9ysjzsMp/cy4P8hkJU8hwJ6
 M5XbjkA4HDc1wDD723XP2xrjXLdNhZuXgUiDTjviae25HjuOhArCRYann/r0khvqVSNvtE9fjBT
 1sGAR8hegBEB7L8dyG+gzC74sZiWKcmMstdBhUgJodOZ/TXPelowDwc13HQfbiuQUA8mRroSA53
 /cB68WSn8loIMJIzPZYvaTKxcg0sw1qMv/SWieOoXGv68PVA6SkUVt06tOcuOQ9slaYwl82R//g
 oYF8CzNefArxzCwSj1vkrWDPxwh13icvqdhhHBLTV+tJr7ioiN5IDmtBRrRMKLddm4Mic7YDatT
 SXVwy/vBsZ7AIrq/eNJ3koOx53QhEA==
X-Authority-Analysis: v=2.4 cv=SvOdKfO0 c=1 sm=1 tr=0 ts=691b7aa6 cx=c_pps
 a=k7JwuLoshMfzPsPeu96bmQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=yVdA5p22Akk7jD9B_LEA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
Subject: RE: [PATCH v5 6/6] ceph: replace local base64 helpers with lib/base64
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 clxscore=1015
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511150032

T24gU3VuLCAyMDI1LTExLTE2IGF0IDE4OjM2ICswODAwLCBHdWFuLUNodW4gV3Ugd3JvdGU6DQo+
IE9uIEZyaSwgTm92IDE0LCAyMDI1IGF0IDA2OjA3OjI2UE0gKzAwMDAsIFZpYWNoZXNsYXYgRHVi
ZXlrbyB3cm90ZToNCj4gPiBPbiBGcmksIDIwMjUtMTEtMTQgYXQgMTQ6MDIgKzA4MDAsIEd1YW4t
Q2h1biBXdSB3cm90ZToNCj4gPiA+IFJlbW92ZSB0aGUgY2VwaF9iYXNlNjRfZW5jb2RlKCkgYW5k
IGNlcGhfYmFzZTY0X2RlY29kZSgpIGZ1bmN0aW9ucyBhbmQNCj4gPiA+IHJlcGxhY2UgdGhlaXIg
dXNhZ2Ugd2l0aCB0aGUgZ2VuZXJpYyBiYXNlNjRfZW5jb2RlKCkgYW5kIGJhc2U2NF9kZWNvZGUo
KQ0KPiA+ID4gaGVscGVycyBmcm9tIGxpYi9iYXNlNjQuDQo+ID4gPiANCj4gPiA+IFRoaXMgZWxp
bWluYXRlcyB0aGUgY3VzdG9tIGltcGxlbWVudGF0aW9uIGluIENlcGgsIHJlZHVjZXMgY29kZQ0K
PiA+ID4gZHVwbGljYXRpb24sIGFuZCByZWxpZXMgb24gdGhlIHNoYXJlZCBCYXNlNjQgY29kZSBp
biBsaWIuDQo+ID4gPiBUaGUgaGVscGVycyBwcmVzZXJ2ZSBSRkMgMzUwMS1jb21wbGlhbnQgQmFz
ZTY0IGVuY29kaW5nIHdpdGhvdXQgcGFkZGluZywNCj4gPiA+IHNvIHRoZXJlIGFyZSBubyBmdW5j
dGlvbmFsIGNoYW5nZXMuDQo+ID4gPiANCj4gPiA+IFRoaXMgY2hhbmdlIGFsc28gaW1wcm92ZXMg
cGVyZm9ybWFuY2U6IGVuY29kaW5nIGlzIGFib3V0IDIuN3ggZmFzdGVyIGFuZA0KPiA+ID4gZGVj
b2RpbmcgYWNoaWV2ZXMgNDMtNTJ4IHNwZWVkdXBzIGNvbXBhcmVkIHRvIHRoZSBwcmV2aW91cyBs
b2NhbA0KPiA+ID4gaW1wbGVtZW50YXRpb24uDQo+ID4gPiANCj4gPiA+IFJldmlld2VkLWJ5OiBL
dWFuLVdlaSBDaGl1IDx2aXNpdG9yY2t3QGdtYWlsLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6
IEd1YW4tQ2h1biBXdSA8NDA5NDExNzE2QGdtcy50a3UuZWR1LnR3Pg0KPiA+ID4gLS0tDQo+ID4g
PiAgZnMvY2VwaC9jcnlwdG8uYyB8IDYwICsrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQ0KPiA+ID4gIGZzL2NlcGgvY3J5cHRvLmggfCAgNiArLS0tLQ0KPiA+
ID4gIGZzL2NlcGgvZGlyLmMgICAgfCAgNSArKy0tDQo+ID4gPiAgZnMvY2VwaC9pbm9kZS5jICB8
ICAyICstDQo+ID4gPiAgNCBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDY0IGRlbGV0
aW9ucygtKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZnMvY2VwaC9jcnlwdG8uYyBiL2Zz
L2NlcGgvY3J5cHRvLmMNCj4gPiA+IGluZGV4IDcwMjZlNzk0ODEzYy4uYjYwMTZkY2ZmYmI2IDEw
MDY0NA0KPiA+ID4gLS0tIGEvZnMvY2VwaC9jcnlwdG8uYw0KPiA+ID4gKysrIGIvZnMvY2VwaC9j
cnlwdG8uYw0KPiA+ID4gQEAgLTE1LDU5ICsxNSw2IEBADQo+ID4gPiAgI2luY2x1ZGUgIm1kc19j
bGllbnQuaCINCj4gPiA+ICAjaW5jbHVkZSAiY3J5cHRvLmgiDQo+ID4gPiAgDQo+ID4gPiAtLyoN
Cj4gPiA+IC0gKiBUaGUgYmFzZTY0dXJsIGVuY29kaW5nIHVzZWQgYnkgZnNjcnlwdCBpbmNsdWRl
cyB0aGUgJ18nIGNoYXJhY3Rlciwgd2hpY2ggbWF5DQo+ID4gPiAtICogY2F1c2UgcHJvYmxlbXMg
aW4gc25hcHNob3QgbmFtZXMgKHdoaWNoIGNhbiBub3Qgc3RhcnQgd2l0aCAnXycpLiAgVGh1cywg
d2UNCj4gPiA+IC0gKiB1c2VkIHRoZSBiYXNlNjQgZW5jb2RpbmcgZGVmaW5lZCBmb3IgSU1BUCBt
YWlsYm94IG5hbWVzIChSRkMgMzUwMSkgaW5zdGVhZCwNCj4gPiA+IC0gKiB3aGljaCByZXBsYWNl
cyAnLScgYW5kICdfJyBieSAnKycgYW5kICcsJy4NCj4gPiA+IC0gKi8NCj4gPiA+IC1zdGF0aWMg
Y29uc3QgY2hhciBiYXNlNjRfdGFibGVbNjVdID0NCj4gPiA+IC0JIkFCQ0RFRkdISUpLTE1OT1BR
UlNUVVZXWFlaYWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXowMTIzNDU2Nzg5KywiOw0KPiA+ID4g
LQ0KPiA+ID4gLWludCBjZXBoX2Jhc2U2NF9lbmNvZGUoY29uc3QgdTggKnNyYywgaW50IHNyY2xl
biwgY2hhciAqZHN0KQ0KPiA+ID4gLXsNCj4gPiA+IC0JdTMyIGFjID0gMDsNCj4gPiA+IC0JaW50
IGJpdHMgPSAwOw0KPiA+ID4gLQlpbnQgaTsNCj4gPiA+IC0JY2hhciAqY3AgPSBkc3Q7DQo+ID4g
PiAtDQo+ID4gPiAtCWZvciAoaSA9IDA7IGkgPCBzcmNsZW47IGkrKykgew0KPiA+ID4gLQkJYWMg
PSAoYWMgPDwgOCkgfCBzcmNbaV07DQo+ID4gPiAtCQliaXRzICs9IDg7DQo+ID4gPiAtCQlkbyB7
DQo+ID4gPiAtCQkJYml0cyAtPSA2Ow0KPiA+ID4gLQkJCSpjcCsrID0gYmFzZTY0X3RhYmxlWyhh
YyA+PiBiaXRzKSAmIDB4M2ZdOw0KPiA+ID4gLQkJfSB3aGlsZSAoYml0cyA+PSA2KTsNCj4gPiA+
IC0JfQ0KPiA+ID4gLQlpZiAoYml0cykNCj4gPiA+IC0JCSpjcCsrID0gYmFzZTY0X3RhYmxlWyhh
YyA8PCAoNiAtIGJpdHMpKSAmIDB4M2ZdOw0KPiA+ID4gLQlyZXR1cm4gY3AgLSBkc3Q7DQo+ID4g
PiAtfQ0KPiA+ID4gLQ0KPiA+ID4gLWludCBjZXBoX2Jhc2U2NF9kZWNvZGUoY29uc3QgY2hhciAq
c3JjLCBpbnQgc3JjbGVuLCB1OCAqZHN0KQ0KPiA+ID4gLXsNCj4gPiA+IC0JdTMyIGFjID0gMDsN
Cj4gPiA+IC0JaW50IGJpdHMgPSAwOw0KPiA+ID4gLQlpbnQgaTsNCj4gPiA+IC0JdTggKmJwID0g
ZHN0Ow0KPiA+ID4gLQ0KPiA+ID4gLQlmb3IgKGkgPSAwOyBpIDwgc3JjbGVuOyBpKyspIHsNCj4g
PiA+IC0JCWNvbnN0IGNoYXIgKnAgPSBzdHJjaHIoYmFzZTY0X3RhYmxlLCBzcmNbaV0pOw0KPiA+
ID4gLQ0KPiA+ID4gLQkJaWYgKHAgPT0gTlVMTCB8fCBzcmNbaV0gPT0gMCkNCj4gPiA+IC0JCQly
ZXR1cm4gLTE7DQo+ID4gPiAtCQlhYyA9IChhYyA8PCA2KSB8IChwIC0gYmFzZTY0X3RhYmxlKTsN
Cj4gPiA+IC0JCWJpdHMgKz0gNjsNCj4gPiA+IC0JCWlmIChiaXRzID49IDgpIHsNCj4gPiA+IC0J
CQliaXRzIC09IDg7DQo+ID4gPiAtCQkJKmJwKysgPSAodTgpKGFjID4+IGJpdHMpOw0KPiA+ID4g
LQkJfQ0KPiA+ID4gLQl9DQo+ID4gPiAtCWlmIChhYyAmICgoMSA8PCBiaXRzKSAtIDEpKQ0KPiA+
ID4gLQkJcmV0dXJuIC0xOw0KPiA+ID4gLQlyZXR1cm4gYnAgLSBkc3Q7DQo+ID4gPiAtfQ0KPiA+
ID4gLQ0KPiA+ID4gIHN0YXRpYyBpbnQgY2VwaF9jcnlwdF9nZXRfY29udGV4dChzdHJ1Y3QgaW5v
ZGUgKmlub2RlLCB2b2lkICpjdHgsIHNpemVfdCBsZW4pDQo+ID4gPiAgew0KPiA+ID4gIAlzdHJ1
Y3QgY2VwaF9pbm9kZV9pbmZvICpjaSA9IGNlcGhfaW5vZGUoaW5vZGUpOw0KPiA+ID4gQEAgLTMx
OCw3ICsyNjUsNyBAQCBpbnQgY2VwaF9lbmNvZGVfZW5jcnlwdGVkX2RuYW1lKHN0cnVjdCBpbm9k
ZSAqcGFyZW50LCBjaGFyICpidWYsIGludCBlbGVuKQ0KPiA+ID4gIAl9DQo+ID4gPiAgDQo+ID4g
PiAgCS8qIGJhc2U2NCBlbmNvZGUgdGhlIGVuY3J5cHRlZCBuYW1lICovDQo+ID4gPiAtCWVsZW4g
PSBjZXBoX2Jhc2U2NF9lbmNvZGUoY3J5cHRidWYsIGxlbiwgcCk7DQo+ID4gPiArCWVsZW4gPSBi
YXNlNjRfZW5jb2RlKGNyeXB0YnVmLCBsZW4sIHAsIGZhbHNlLCBCQVNFNjRfSU1BUCk7DQo+ID4g
PiAgCWRvdXRjKGNsLCAiYmFzZTY0LWVuY29kZWQgY2lwaGVydGV4dCBuYW1lID0gJS4qc1xuIiwg
ZWxlbiwgcCk7DQo+ID4gPiAgDQo+ID4gPiAgCS8qIFRvIHVuZGVyc3RhbmQgdGhlIDI0MCBsaW1p
dCwgc2VlIENFUEhfTk9IQVNIX05BTUVfTUFYIGNvbW1lbnRzICovDQo+ID4gPiBAQCAtNDEyLDcg
KzM1OSw4IEBAIGludCBjZXBoX2ZuYW1lX3RvX3Vzcihjb25zdCBzdHJ1Y3QgY2VwaF9mbmFtZSAq
Zm5hbWUsIHN0cnVjdCBmc2NyeXB0X3N0ciAqdG5hbWUsDQo+ID4gPiAgCQkJdG5hbWUgPSAmX3Ru
YW1lOw0KPiA+ID4gIAkJfQ0KPiA+ID4gIA0KPiA+ID4gLQkJZGVjbGVuID0gY2VwaF9iYXNlNjRf
ZGVjb2RlKG5hbWUsIG5hbWVfbGVuLCB0bmFtZS0+bmFtZSk7DQo+ID4gPiArCQlkZWNsZW4gPSBi
YXNlNjRfZGVjb2RlKG5hbWUsIG5hbWVfbGVuLA0KPiA+ID4gKwkJCQkgICAgICAgdG5hbWUtPm5h
bWUsIGZhbHNlLCBCQVNFNjRfSU1BUCk7DQo+ID4gPiAgCQlpZiAoZGVjbGVuIDw9IDApIHsNCj4g
PiA+ICAJCQlyZXQgPSAtRUlPOw0KPiA+ID4gIAkJCWdvdG8gb3V0Ow0KPiA+ID4gQEAgLTQyNiw3
ICszNzQsNyBAQCBpbnQgY2VwaF9mbmFtZV90b191c3IoY29uc3Qgc3RydWN0IGNlcGhfZm5hbWUg
KmZuYW1lLCBzdHJ1Y3QgZnNjcnlwdF9zdHIgKnRuYW1lLA0KPiA+ID4gIA0KPiA+ID4gIAlyZXQg
PSBmc2NyeXB0X2ZuYW1lX2Rpc2tfdG9fdXNyKGRpciwgMCwgMCwgJmluYW1lLCBvbmFtZSk7DQo+
ID4gPiAgCWlmICghcmV0ICYmIChkaXIgIT0gZm5hbWUtPmRpcikpIHsNCj4gPiA+IC0JCWNoYXIg
dG1wX2J1ZltDRVBIX0JBU0U2NF9DSEFSUyhOQU1FX01BWCldOw0KPiA+ID4gKwkJY2hhciB0bXBf
YnVmW0JBU0U2NF9DSEFSUyhOQU1FX01BWCldOw0KPiA+ID4gIA0KPiA+ID4gIAkJbmFtZV9sZW4g
PSBzbnByaW50Zih0bXBfYnVmLCBzaXplb2YodG1wX2J1ZiksICJfJS4qc18lbGQiLA0KPiA+ID4g
IAkJCQkgICAgb25hbWUtPmxlbiwgb25hbWUtPm5hbWUsIGRpci0+aV9pbm8pOw0KPiA+ID4gZGlm
ZiAtLWdpdCBhL2ZzL2NlcGgvY3J5cHRvLmggYi9mcy9jZXBoL2NyeXB0by5oDQo+ID4gPiBpbmRl
eCAyMzYxMmIyZTk4MzcuLmI3NDhlMjA2MGJjOSAxMDA2NDQNCj4gPiA+IC0tLSBhL2ZzL2NlcGgv
Y3J5cHRvLmgNCj4gPiA+ICsrKyBiL2ZzL2NlcGgvY3J5cHRvLmgNCj4gPiA+IEBAIC04LDYgKzgs
NyBAQA0KPiA+ID4gIA0KPiA+ID4gICNpbmNsdWRlIDxjcnlwdG8vc2hhMi5oPg0KPiA+ID4gICNp
bmNsdWRlIDxsaW51eC9mc2NyeXB0Lmg+DQo+ID4gPiArI2luY2x1ZGUgPGxpbnV4L2Jhc2U2NC5o
Pg0KPiA+ID4gIA0KPiA+ID4gICNkZWZpbmUgQ0VQSF9GU0NSWVBUX0JMT0NLX1NISUZUICAgMTIN
Cj4gPiA+ICAjZGVmaW5lIENFUEhfRlNDUllQVF9CTE9DS19TSVpFICAgIChfQUMoMSwgVUwpIDw8
IENFUEhfRlNDUllQVF9CTE9DS19TSElGVCkNCj4gPiA+IEBAIC04OSwxMSArOTAsNiBAQCBzdGF0
aWMgaW5saW5lIHUzMiBjZXBoX2ZzY3J5cHRfYXV0aF9sZW4oc3RydWN0IGNlcGhfZnNjcnlwdF9h
dXRoICpmYSkNCj4gPiA+ICAgKi8NCj4gPiA+ICAjZGVmaW5lIENFUEhfTk9IQVNIX05BTUVfTUFY
ICgxODAgLSBTSEEyNTZfRElHRVNUX1NJWkUpDQo+ID4gPiAgDQo+ID4gPiAtI2RlZmluZSBDRVBI
X0JBU0U2NF9DSEFSUyhuYnl0ZXMpIERJVl9ST1VORF9VUCgobmJ5dGVzKSAqIDQsIDMpDQo+ID4g
PiAtDQo+ID4gPiAtaW50IGNlcGhfYmFzZTY0X2VuY29kZShjb25zdCB1OCAqc3JjLCBpbnQgc3Jj
bGVuLCBjaGFyICpkc3QpOw0KPiA+ID4gLWludCBjZXBoX2Jhc2U2NF9kZWNvZGUoY29uc3QgY2hh
ciAqc3JjLCBpbnQgc3JjbGVuLCB1OCAqZHN0KTsNCj4gPiA+IC0NCj4gPiA+ICB2b2lkIGNlcGhf
ZnNjcnlwdF9zZXRfb3BzKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpOw0KPiA+ID4gIA0KPiA+ID4g
IHZvaWQgY2VwaF9mc2NyeXB0X2ZyZWVfZHVtbXlfcG9saWN5KHN0cnVjdCBjZXBoX2ZzX2NsaWVu
dCAqZnNjKTsNCj4gPiA+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2Rpci5jIGIvZnMvY2VwaC9kaXIu
Yw0KPiA+ID4gaW5kZXggZDE4YzBlYWVmOWI3Li4wZmE3Yzc3NzcyNDIgMTAwNjQ0DQo+ID4gPiAt
LS0gYS9mcy9jZXBoL2Rpci5jDQo+ID4gPiArKysgYi9mcy9jZXBoL2Rpci5jDQo+ID4gPiBAQCAt
OTk4LDEzICs5OTgsMTQgQEAgc3RhdGljIGludCBwcmVwX2VuY3J5cHRlZF9zeW1saW5rX3Rhcmdl
dChzdHJ1Y3QgY2VwaF9tZHNfcmVxdWVzdCAqcmVxLA0KPiA+ID4gIAlpZiAoZXJyKQ0KPiA+ID4g
IAkJZ290byBvdXQ7DQo+ID4gPiAgDQo+ID4gPiAtCXJlcS0+cl9wYXRoMiA9IGttYWxsb2MoQ0VQ
SF9CQVNFNjRfQ0hBUlMob3NkX2xpbmsubGVuKSArIDEsIEdGUF9LRVJORUwpOw0KPiA+ID4gKwly
ZXEtPnJfcGF0aDIgPSBrbWFsbG9jKEJBU0U2NF9DSEFSUyhvc2RfbGluay5sZW4pICsgMSwgR0ZQ
X0tFUk5FTCk7DQo+ID4gPiAgCWlmICghcmVxLT5yX3BhdGgyKSB7DQo+ID4gPiAgCQllcnIgPSAt
RU5PTUVNOw0KPiA+ID4gIAkJZ290byBvdXQ7DQo+ID4gPiAgCX0NCj4gPiA+ICANCj4gPiA+IC0J
bGVuID0gY2VwaF9iYXNlNjRfZW5jb2RlKG9zZF9saW5rLm5hbWUsIG9zZF9saW5rLmxlbiwgcmVx
LT5yX3BhdGgyKTsNCj4gPiA+ICsJbGVuID0gYmFzZTY0X2VuY29kZShvc2RfbGluay5uYW1lLCBv
c2RfbGluay5sZW4sDQo+ID4gPiArCQkJICAgIHJlcS0+cl9wYXRoMiwgZmFsc2UsIEJBU0U2NF9J
TUFQKTsNCj4gPiA+ICAJcmVxLT5yX3BhdGgyW2xlbl0gPSAnXDAnOw0KPiA+ID4gIG91dDoNCj4g
PiA+ICAJZnNjcnlwdF9mbmFtZV9mcmVlX2J1ZmZlcigmb3NkX2xpbmspOw0KPiA+ID4gZGlmZiAt
LWdpdCBhL2ZzL2NlcGgvaW5vZGUuYyBiL2ZzL2NlcGgvaW5vZGUuYw0KPiA+ID4gaW5kZXggYTZl
MjYwZDllNDIwLi5iNjkxMzQzY2I3ZjEgMTAwNjQ0DQo+ID4gPiAtLS0gYS9mcy9jZXBoL2lub2Rl
LmMNCj4gPiA+ICsrKyBiL2ZzL2NlcGgvaW5vZGUuYw0KPiA+ID4gQEAgLTk1OCw3ICs5NTgsNyBA
QCBzdGF0aWMgaW50IGRlY29kZV9lbmNyeXB0ZWRfc3ltbGluayhzdHJ1Y3QgY2VwaF9tZHNfY2xp
ZW50ICptZHNjLA0KPiA+ID4gIAlpZiAoIXN5bSkNCj4gPiA+ICAJCXJldHVybiAtRU5PTUVNOw0K
PiA+ID4gIA0KPiA+ID4gLQlkZWNsZW4gPSBjZXBoX2Jhc2U2NF9kZWNvZGUoZW5jc3ltLCBlbmNs
ZW4sIHN5bSk7DQo+ID4gPiArCWRlY2xlbiA9IGJhc2U2NF9kZWNvZGUoZW5jc3ltLCBlbmNsZW4s
IHN5bSwgZmFsc2UsIEJBU0U2NF9JTUFQKTsNCj4gPiA+ICAJaWYgKGRlY2xlbiA8IDApIHsNCj4g
PiA+ICAJCXByX2Vycl9jbGllbnQoY2wsDQo+ID4gPiAgCQkJImNhbid0IGRlY29kZSBzeW1saW5r
ICglZCkuIENvbnRlbnQ6ICUuKnNcbiIsDQo+ID4gDQo+ID4gTG9va3MgZ29vZCENCj4gPiANCj4g
PiBSZXZpZXdlZC1ieTogVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5jb20+
DQo+ID4gDQo+ID4gSGF2ZSB5b3UgcnVuIHhmc3Rlc3RzIGZvciB0aGlzIHBhdGNoc2V0Pw0KPiAN
Cj4gSGkgU2xhdmEsDQo+IA0KPiBUaGFua3MgZm9yIHRoZSByZXZpZXcuDQo+IA0KPiBJIGhhdmVu
J3QgcnVuIHhmc3Rlc3RzIG9uIHRoaXMgcGF0Y2hzZXQgeWV0Lg0KPiANCj4gDQoNCkkgaGF2ZSBy
dW4gdGhlIHhmc3Rlc3RzIGZvciBDZXBoRlMgd2l0aCBhcHBsaWVkIHBhdGNoc2V0LiBJIGRvbid0
IHNlZSBhbnkgbmV3DQppc3N1ZXMuIFdlIGhhZCBmYWlsdXJlcyB3aXRoIGdlbmVyaWMvNDUyIGdl
bmVyaWMvNjM5IGJlZm9yZSBhcHBseWluZyB0aGUNCnBhdGNoc2V0LiBTbywgYXMgZmFyIGFzIEkg
Y2FuIHNlZSwgcGF0Y2hzZXQgd29ya3Mgd2VsbC4NCg0KVGVzdGVkLWJ5OiBWaWFjaGVzbGF2IER1
YmV5a28gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4NCg0KVGhhbmtzLA0KU2xhdmEuDQo=

