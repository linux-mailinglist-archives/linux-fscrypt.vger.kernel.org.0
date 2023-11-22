Return-Path: <linux-fscrypt+bounces-29-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D3047F4B3B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 16:42:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24C1028123E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 15:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E0574EB4E;
	Wed, 22 Nov 2023 15:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JaIWyJqW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IJEYtdHY"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864AD26A5;
	Wed, 22 Nov 2023 07:42:13 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AMF2cmp005999;
	Wed, 22 Nov 2023 15:42:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=FISz3IhLaGHoRbezXV+xlOUTdfj5xoG8Tk7kn4RET20=;
 b=JaIWyJqWkM/M9htEOY5IScfokAo/3SnM7M39sH6g8wltff/qP+aIb/btgCyvwCK9Ifli
 UhQimLgHuGGbedLWY5jHrGh8lzCRSFCZ2K9ZL1bZ6T8SwNbyjSn886KNmen6OMHpx2xS
 HaBYmJiBfwXBPGHgz0Sl8K2RBbQAoRSP3kKGwKNP/xGxtAdcGiPiIUzlf3DAA8PdH4NW
 XrdDKwWfEF0RZ7nrRP3nJA8qzODux/ajDpVDtccObRTZcJEDjK0qEEyUpD1p3v+EahUp
 LAOjjTAvr2ZDsszyCa/ipvyLv1I1ERmFSa2yYDjB227vfR+xle1tu+CWwPqrS6SgQMdE gQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uentvfsjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Nov 2023 15:42:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AMEJc1A002365;
	Wed, 22 Nov 2023 15:42:08 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uekq8x2pc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Nov 2023 15:42:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MU1B7FMdPDdyHcrjOJG2WOkkpn2sMe+BpgbGzJl2gX8xpq/s3SXRQRvHGDWXzYniwrCZrOB7YhxtWKX5LkHmMYb1yL2J50nrcQKZUh2tnbwUzLGiek5SA08oxGJMTfkM5dCK6TdTih0iMcT2KmINcAxy0tRXTXccS+GEajq8PzVhaAKzFeE4gPBTciNYYGt3daq5rYqgV/le2tyHn92zlxWNOLNOSOVcS5kcWekxsSKZeFNlUcrV0Uldn6mtilhWwdV37dJ2qWBdtTmeLK7acWJUSbx377wPTTL8qWe8WcF7kQ6x795+U9pwR92jfcNXpcnuz6TFkDgB5nsGzSFEGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FISz3IhLaGHoRbezXV+xlOUTdfj5xoG8Tk7kn4RET20=;
 b=JDPGk99A1UvzXZavzCBSXD50awmfQoklQeGmhw0tTxzoypsKDY9U3DkAHyM02bqeB8saOp+zjIs6xldUq3Ex/e+j3V9n1kCfmMg6cuCguRJxc3REcSZbV/7q02qaf4llhHskSNeBAFNFrutzDwTyOCG8x+KHPDlDfj18o5ojTlfWQTSKWSvX37vhIDvDVV9RLMFlFimXrApInRh2/1mTNQ4+WcG7IzXUUlylq05goRPyWa6FHbdevVSckcTlFQzg0oV4vL7YZsBxPqRf8LS/HW+42cPm8/x/skPOrzY5c42+pBfVdYjyEBPWhbFw5anYEgUa0OBL/5B3TOHxkRp2Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FISz3IhLaGHoRbezXV+xlOUTdfj5xoG8Tk7kn4RET20=;
 b=IJEYtdHYapUb4rxTUxQfqKIjceu5Jp3mnbf8IzEjje3s77RxGbCgO8XVyXtOcb7aVkXijXmF8OjGsAGUNs3sV2UhSZVmvMAoytdFnA5KVokQs4tlsfqxL7xyboT/SS4gQtMnLaLMG3M33CxX5UPWXsr2G3teMQFLZg19bgesMQA=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by IA1PR10MB6856.namprd10.prod.outlook.com (2603:10b6:208:423::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.28; Wed, 22 Nov
 2023 15:42:06 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::2000:9c78:19f5:176a]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::2000:9c78:19f5:176a%3]) with mapi id 15.20.7002.028; Wed, 22 Nov 2023
 15:42:06 +0000
Message-ID: <437e189e-475a-46d7-b7ea-a8d919d53032@oracle.com>
Date: Wed, 22 Nov 2023 23:41:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/12] fstests: split generic/580 into two tests
To: Josef Bacik <josef@toxicpanda.com>
Cc: fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <cover.1696969376.git.josef@toxicpanda.com>
 <ecf95cca70aa11c64455893ea823ec8de0249cf5.1696969376.git.josef@toxicpanda.com>
 <7cba2927-5636-4039-9e76-f01a5b86c108@oracle.com>
 <20231108202550.GA548237@perftesting>
Content-Language: en-US
From: Anand Jain <anand.jain@oracle.com>
In-Reply-To: <20231108202550.GA548237@perftesting>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:3:18::27) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|IA1PR10MB6856:EE_
X-MS-Office365-Filtering-Correlation-Id: e16ad86e-baf5-4e30-abef-08dbeb7194e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ZyFO477ZDO/kWVsRybsDgGpEuT/sDJue8p1y6kZpfPG22Xw1sooOl3EkzeiuxWMrwcvHmh3bPoFGwsEKZIAlSmISEKMK4Ps2IV88ZLOTqAdqcpvstXipCOuyD9NqIyqxLPi70zcOdv3eb0pTQXecwK7VCrxnX4W0cRcvgw7cRhhQ1Kb1qbVQRI+u1CgZHQ4OEZ8Ib0IN9Smp5tyKINEYok5k+gqQpesneL52AZnDCmVkr97nQ+HM4Ewg7pyE9Abdi2mWcgZ1u2bRRmqRTPIDw/SBuAjEJjye/HLOXJ5AXS0JF+DpJ9WYBFGFt9stoqe35hvq/519nV5AGMTpuKl6Il6MjlnM8bfMjq33yZYpdJJVqwK6ji/r7ezSYX/8vYWbaoz984C6ZzgXzkr4s/UnVoz9vx+HZNNeZf9DGVvKaI+jwt7f2U8TbWDB/f6qiVHjjM2Yyupuol6zHSrcWljj1ptOO4D7xyu+yYd7RbROam9VtYUItIooEnmmqQP90CTBMFE7zYe19h2I5RnNNC4iR8j3oZTZQLQnaCXlncN19tIYjJPYLjlB5nKR3Ima698sg8a3ilPjb/KgcuJMGP8gsWaAhDC5K/2iLbCBi/m6liuSb9hF9MP2miBOJBYUv7HFyQWI6b3Dvaf7BJJVgsjrQRI1d5aB3AFVBGNjbJr/TeM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(396003)(366004)(39860400002)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6916009)(66476007)(66556008)(316002)(6666004)(36756003)(6512007)(2616005)(6486002)(26005)(478600001)(38100700002)(53546011)(31696002)(66946007)(86362001)(6506007)(44832011)(5660300002)(4744005)(2906002)(31686004)(8936002)(41300700001)(8676002)(4326008)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UlowOFhEOEVSMmUramZ3b0ErWXVZSkYydzRUbVczYUNjelFReFQzZllyZmRt?=
 =?utf-8?B?KzluRkRsUjF0aUdtdU9tQVZHWHRNQjlNWE1WRTIrL1pCTUh5bTk2K1VRS2Jp?=
 =?utf-8?B?bVk2SzYyZ3pNT09ZOC9BZ2o5UUxaSVU3OVZ6SWRBMG1xblBFWGRJOFp3RTdj?=
 =?utf-8?B?bDJmQ05TT0hVTFRFaUloZkFvbUUzRkYydjV3U3craU1jOVV1TmRJdWIvVGMx?=
 =?utf-8?B?d1o2UG5kV3NXSVBZd0VTdkpITklJNlJtRGRFLzIrUTBNR2tseFhJdkRwLzBX?=
 =?utf-8?B?aWNxMUZSUE82dUxaNWZsWFQ3NTlzMHk5c25HeGIwSTJRcklXMllVWE5WaTUy?=
 =?utf-8?B?d1VLdWlvbUFFMk5JdHhWZUlxUjRTQ1hxYklhbzlOaUh0RTBJaDllaVVGL0s4?=
 =?utf-8?B?RXZ2dmlWeUo2d3Q5dW5OZXpMbDVXWm1WdDloSkwxSzlrUGdsV1FadG1ZN3Zo?=
 =?utf-8?B?bzJYaWdQaVFiRndsZmljUlkrQUVycUZ3T3dtWkFVOUhNeGxuaEFJN1A0OUZ0?=
 =?utf-8?B?cFZYdmxYdzd2VjJmZUo3c211bU5ZVnkvWkdiREFpZHNsNU9salQ4THZ3NUt5?=
 =?utf-8?B?cmVVNDBFTGROOVpLTkMzU3NtWHlscG4rZmlVSFJzc09PK3g4cTdCTVpqSHJl?=
 =?utf-8?B?ZENwSDJxQjhCTHFsblN0ZlJya3VTYWE3TzlEdEhYYlNTYk9mL2grT0NDUEZp?=
 =?utf-8?B?ZmYzdUNDTGFsTGhJZkllc2xBUFVxWitWNWg5c01BSGtYbGZsbVN6TlgvUFky?=
 =?utf-8?B?RjMrMGFSYkg1bit4ajgrWVlSU2lCVFZzT3FvVzduTER1Z2s0T0pOZnEyN3Yz?=
 =?utf-8?B?VURYUzVUVVVsaXBtcVpvSjJ0cEVnOEkrY1YxRFQ5NmFhcXRMdm8wbG1NbCtW?=
 =?utf-8?B?NFpJZFcwcFdBcUYwV0RvQ0lkaVlGdHI2NHdUbnMwN2IrNE5NZ3k4Y1ZMVzJL?=
 =?utf-8?B?bWRBMW5udjB3QnpGMVFpV2J1WUoyRVlhVW4vSUNYdmNoazVaZ0h6Y2w4VWpa?=
 =?utf-8?B?MTRoZ3M5M2tadFRJeGtwWnVVNjRvVlhOK0VTMHJVM0hOdGRiRmdSUGZoZzAv?=
 =?utf-8?B?Ynh5U0JrZ1hpenAyZWpBU051MTNUeTJHMnlFTHQ1eXJHRHFkWWZFd1B6bzlp?=
 =?utf-8?B?amJqV1Q3Y21HVHYzK0xxdXpjdjBacmJNZ0RSNU14T0lQckIvK0w5d3NUMDM5?=
 =?utf-8?B?bmwwSisxNFhNN0svNHhZd3h0SGprWkF0OTFYNVJDQWRhMmNKVzdzV1VCQ3pD?=
 =?utf-8?B?bFJKQ2ZybGt0ZG1xWG5BZ2VrWCtiYWF0UGcwdWFsM1BvcGI2L09DWWdLR1ov?=
 =?utf-8?B?QW93MHY0aFBsZ24rV2VTZDFtRC9zRzc4aGJrSDRBRFpHMDhncXpMb2g2RjVQ?=
 =?utf-8?B?K2F1UzZjeDZrV3JtWmxBTFpPRnNaMDNOZjFZQ2gxRTdsa3NBbHlhSCtyZVpX?=
 =?utf-8?B?enlXeEFSRks3KzIzdnFjemRyYU9uT2JRM3JwMGtPdUJYbmVldEU2VW5LczB4?=
 =?utf-8?B?ZE15WkR3Sy9XWWpJTTlvZ0JJQWhHVkVvQUYwb1hzcEw1QzRkdzBUVlBkb0N0?=
 =?utf-8?B?dzJ4R2s1ODI2L3A5MHlId29paDY3aUdGTGk3UkFERVlqVldZMmtySUtWcXRi?=
 =?utf-8?B?bG1EODNZV1dsYXlrVGFORmxzTENWTVMvdStoU3hxSms0MVJtQ0dvMzRWKzhz?=
 =?utf-8?B?RithVUFZV3ZRY1Z4SEN6RGN2ZlVLOWl6eTI5MXUyWEJkUWlzeHRKY1B3SWpU?=
 =?utf-8?B?MXpBNnNmdTd3UjJlKy80RGxsa0NTekltaDlaUUFLWVRqYlV3a2xjTEI5TUI0?=
 =?utf-8?B?ZkU0UTJscGF0OTR0dzUycmsyd2txWjArMTh5WUJYUW5WQzRLMjFKUi81Mllk?=
 =?utf-8?B?ZFdyMGk2ZmJKTDZ4TUYyQnZ4eUlEOERXSkRWeW5EUzhWTGdyUjlBUytiQXg4?=
 =?utf-8?B?OUNLNWM4S0I5b0dINnpRbGsyNkNwbzVwVHBacHVTbEdVRS9QL2VONFpWeWdw?=
 =?utf-8?B?bVlCYnNpZjJRTVhGQmFQT1pQYXFDQVMvcWprTjd6enlxblQ0QTBrVTFHU1U2?=
 =?utf-8?B?eVFXdmdQTXdZNVdySmJ1UElqQnBOeWNSNGdjRUVTbWd6a1FxckYvM3hkbzZk?=
 =?utf-8?Q?PNup6ZutH43dIBWVnxr9lUqAr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	PqN7kpldc6toIfjZXSbSwFmTnQvJDA6o6bmJUYQgj7Uyd3hzkbi5/mc7JgFu23WejUKSIpynCf0l0g9oCEVolxD1IwUCATahIw8wpV3wvH1GgMs9knEZ67klsWhhWNv1HJXEhs+0srgLlUQi3qBMc/S7kMQkJDVzoUUWqc8hdS/9wJ085PMQaeYByxaTodlKoJnoh39tOejpMt9/SXlEZ2Hj5E6zeUTp7BmUA/OI3ejuLpAqOc2v9c15p6lJFRr+McYo//9117d/e/+u2ZY1TJTbBCyAvp2RjGWOOWfC+2oCKWPMhmRJpWuIaccDfA0tYhb85as+FKxK+UA+GhQpoM/7G+rUVNPdCXraflJ4aZnwcs96Fmy3+csGFSWTxl5n+XMHqUv2NpCc4mM33XtO0WfmXwBbu5YdMbH8AFM71sp3zdUM6fmhqDf3wTfbCkHUV5kiK7v6t2WILmEUXwuvUy/AK2LqyNPPSg3GoFSO/tg3nhY1S6WJc0YGn+XjnVrfQ7kfNdQHOYvWKw6257+KSBFR2AYp7gV4pc0roFa0Kb5FlzjEOLW8xOY4xfKyCQG1cIaTI/YCc6ppFNJu5Aze7zpm56572t5ZWVekybPfXlIZKoDFKcW2j4+ry547GW6L1B12Vt8AujYWGIPeyl9jJQiPJZFj+h2myiG5S/d73ettZBXIIx3iHrNx9ozInbtYafAu3eLAhjxMIj98+Njc6bEIaVaTFEPOJY3a0rBNvgRpyN8wwMBN2xDGWta1GFelDq3nK/7h3zyO6mlFKZLYHgWFg0MrW06Kpf5gCxUJERbSsdTgcbxHQ5cybll9c0VN
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e16ad86e-baf5-4e30-abef-08dbeb7194e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2023 15:42:06.7925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZbeJjpcRfw9lPSC/KJeNOxWZc7gFb9MFl/MMT/thLSedtLXX5YYTeYj9yyhdpAO/Ube8/7hj+thpY5pOyX7GIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6856
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-22_11,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311220112
X-Proofpoint-ORIG-GUID: GzfKcktswhwDKo7YuXpdvfa3SLupg0Wh
X-Proofpoint-GUID: GzfKcktswhwDKo7YuXpdvfa3SLupg0Wh

On 11/9/23 04:25, Josef Bacik wrote:
> On Thu, Nov 02, 2023 at 07:42:50PM +0800, Anand Jain wrote:
>> On 10/11/23 04:26, Josef Bacik wrote:
>>> generic/580 tests both v1 and v2 encryption policies, however btrfs only
>>> supports v2 policies.  Split this into two tests so that we can get the
>>> v2 coverage for btrfs.
>>
>> Instead of duplicating the test cases for v1 and v2 encryption policies,
>> can we check the supported version and run them accordingly within a
>> single test case?
>>
>> The same applies 10 and 11/12 patches as well.
> 
> This will be awkward for file systems that support both, hence the split.  I
> don't love suddenly generating a bunch of new tests, but this seems like the
> better option since btrfs is the only file system that only supports v2, and
> everybody else supports everything.  Thanks,
> 
> Josef


Ok. That's fair.



