Return-Path: <linux-fscrypt+bounces-35-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BBE37FA247
	for <lists+linux-fscrypt@lfdr.de>; Mon, 27 Nov 2023 15:16:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 211DC281798
	for <lists+linux-fscrypt@lfdr.de>; Mon, 27 Nov 2023 14:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC32331590;
	Mon, 27 Nov 2023 14:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n6Wfe/nD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZUpxWJl/"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BBA4229;
	Mon, 27 Nov 2023 06:16:44 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ARE3vCS003494;
	Mon, 27 Nov 2023 14:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=xEyJpn88/5A4BDhM2cRKewHEWup0rL5Z6cu9MNGa0fQ=;
 b=n6Wfe/nD7MfL5JgDoztpmxiolgH5gcne8MHoSY7smfCLWz1lC5oY1e8ELzOFqBIFxfvR
 c677cHe9/JCyxMHTU9O2s3uGjJVqQXul72ULhatNmqCi+n9RQ83sgmpIxshNmB42ARn8
 ZIxNaYmauuSAU1ReYDDT1PqyGFhszBXUY5IoaYDh9tudnmcrWumyLDN1R2NQPWeaDI6C
 GX2X2li2TbBFSCbDcNr2NTF+1nrbYdK4wl32kkSxfL9Bslqte7BxfzzUSRMyWUutg034
 xrVExecF/I5LymIqHwbh4BVkhn2QCr4+y8ooFC1Mcxbsx4hhdCXMFZ6jA5V68GbXdkiH 9A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uk8yd32h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Nov 2023 14:16:38 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3ARDUUsx009249;
	Mon, 27 Nov 2023 14:16:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uk7c53jr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Nov 2023 14:16:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBMXjlEgo73Eu03tlf35EbxumkC9FzZYivoUbewTRBZbBRz327IY1VQT0Wl3V11eMOFFIEIzva1Ml/OY6//s+4YHW6kFUA4RIbJfTnaE8/wI64Jj0zVXzfjx22kLA5G5UE2d6n8cWNzRWgcKW/ZyCiIAicKZiYEnN1qVvmqqQK4J6zrdDonv/1NqoYDd5SGO3IIp70nFUANqIcwPd/o7Xq9rw0fIprPF6tlPZRYC0P0RvldZBsCGZ42hOVYlP+hooQDUlfP72DfOE1vBtvEiP5GRl5SUcTZRq9RK/SL5PCLKGHbmUh91H+dlbxQKsiPYXUZ6dS2wMRwxfxWaqTCBzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEyJpn88/5A4BDhM2cRKewHEWup0rL5Z6cu9MNGa0fQ=;
 b=a2PQF9/yPcqEQ04GaQHespMRR5gOHQpog4zuhhR3aoCxphPui9FjqhxFpSnEMiGj7jHjv5PHcPThGoCspNO/2yBl8hqAd1h3L25YzvQdt1unbVvCrucecfzDMyEQu/abLMUKFUx93xstcMicixptJ+HIPIq01d4xzB0wElC/q90aC88J5zenW5PwHlvkFGj6B8oqfBvJgkEdKbccTwZhm50WI5wXzzw/hpnoQIJfrTyu5qRJQ+i65qQnyVntUiFig3CvL/FXtBwXgivsOvPFDc9e8Cn+Pf/dcY7tl1Qvp/RJun8qIpeXvOSzZEy1c1F3qCZeNYfIMheu243OwvzmsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEyJpn88/5A4BDhM2cRKewHEWup0rL5Z6cu9MNGa0fQ=;
 b=ZUpxWJl/4r08q1hxNva8488dBTej4JCAGdqYFEP8/OAvsCl6HQuOqvNwEhQeklTJtn/1VDsfPgAbDYmPTw0r6faAOVzhTPig0BTOpjF3wIVxX7F8tnwkm2XKuYaHCqzhglKbYIcAd/Lf8ZAqW79fWT1mX/v04P+Bjf1kd6vcsqM=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CYYPR10MB7605.namprd10.prod.outlook.com (2603:10b6:930:c8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Mon, 27 Nov
 2023 14:16:34 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::2000:9c78:19f5:176a]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::2000:9c78:19f5:176a%3]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 14:16:34 +0000
Message-ID: <4507f07c-f101-e223-a804-7d0d69b07b76@oracle.com>
Date: Mon, 27 Nov 2023 22:16:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 07/12] btrfs: test snapshotting encrypted subvol
To: Josef Bacik <josef@toxicpanda.com>
Cc: fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Filipe Manana <fdmanana@kernel.org>
References: <cover.1696969376.git.josef@toxicpanda.com>
 <9a17afb133849c2321bb98c07c48cff2aaf1d87a.1696969376.git.josef@toxicpanda.com>
 <CAL3q7H5eg0Xs+-JYnHnh11ogUB=GSaCGT_C0a4QFVnj_--oFng@mail.gmail.com>
Content-Language: en-US
From: Anand Jain <anand.jain@oracle.com>
In-Reply-To: <CAL3q7H5eg0Xs+-JYnHnh11ogUB=GSaCGT_C0a4QFVnj_--oFng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0019.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::6)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|CYYPR10MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a782b0c-1989-4450-c5ff-08dbef53758a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	42kPwp1snqYVlq7DOQZfVaVGyIXQJLJMuXMmW+349F2bq7pmNJjp8wBV20u1IeRw0vW0u5SOe4v63nUp51LGKE9kVUd+K2aLmO4T9ARfvtQ+w97uwKSBsYQ5djoIsVj4Ucg9EPfCUY41Q1rKXBBPdGjlX1Gh56r0udpV7jLQGR7rGxNE2F9u/wUmwWT9Ue/r158qjyWyrUGVIF2orefDXZNpIjDK4Q1GovFrCduBoE4zcX09BmpJVVuuvWYjcyw9aqDs7Ix177IBVzErIEga89mk64bIcBJP5V5IxordNjvNTw7HGNMGO/Y1r45vR4NefHtkDYbtz8EkQXp7wlKBvUcGnpaqnrvhBggRPkLMqz7WVta4mhaYd6v1xLY37COFMgQ3WHvXiuo1cnUo2pa7QZ5NvypTN8PrkAinFgRL4TTc2LDxgdCkW92Hh1lsLNzW/V5/Y0TohbyUHY8gVLCxcNkMJ1ZweE9jMMvDcvAPtyZcWzA7q7onNauqZAl57/AUy0mrcxWqlnazGObwqG32JPqB0KpLYh8KMkg7Unv3/1H9jdzY+e1KZAZCJCRKBcrrho9TDIMfrnhBNQgMVQnHQIs3uU1Lq3Roh8cwYJ5qRGkSdCNkW6+ApcvKyNu83e9nMYhV+z8NnIxPoZ9Xc3xsiw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(136003)(396003)(366004)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(2616005)(26005)(6506007)(6666004)(6512007)(31696002)(8936002)(8676002)(4326008)(53546011)(44832011)(86362001)(5660300002)(478600001)(6486002)(316002)(54906003)(66946007)(66476007)(66556008)(6916009)(38100700002)(83380400001)(30864003)(31686004)(2906002)(41300700001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SG0xY0NTQnZHNitQUklyTFN2K3NDVDRkUFpWNktHNzdhVWZVczRlTWpJVGh0?=
 =?utf-8?B?ME9WTGYvQXNJbldDL1p4eUFRblRLaW9vdVNpR3RIUTRkNFVtRDBaNmpTOVNV?=
 =?utf-8?B?emR0c0dHRmpVTi96TEJwVFR3a0prZURjNEFkaW04Q1k0ZHZOZ0VXTTlzenl0?=
 =?utf-8?B?L1c0L2o2bk5rTGhSUzZxV3hPTGlibVQ2NXBZeWIrT0l2ZnFGTG0xdlBuWm5l?=
 =?utf-8?B?dGFRU0xoWVJCYkFCbjhKSDBQYVdjK0d5WmJhWWg0TFVJRnZsS1ZEeXFpbHA5?=
 =?utf-8?B?c25RWFBTSmZwVlVxb0tsSzRMV2I0V2Z5STM1Z3NnSTEwMUc3Sk1HelVycGVa?=
 =?utf-8?B?T2xPb0JtclNhcnVuVHZ2TW1JQm1zYmhhOVhZUC9FZUx6OUF6SjFqOW5tMXVN?=
 =?utf-8?B?SVJaQ3NQSmxnenMrWHRQK3QweGl1M1pPbEdlUzh6ZURwVUEvdWF4MWdJMmtO?=
 =?utf-8?B?bUhNUXdFWWFtMklYUHd4OEdKamxNODNZWTlFT0FxSlY3SFhwZy9rMVc5LzUv?=
 =?utf-8?B?Q3FHdi9CVkd3ZGUrS2JQQXBNM0ZTUkR3eDVCQWNqRHBrMWNLbm04NXhBQmJF?=
 =?utf-8?B?cFBDMVpDUHhNR0tzZWFseGU5Z3NuZ2c5c2tjeVpRWDRCZ0FZb1F5aHBDOFFH?=
 =?utf-8?B?WU94d2xRUWtEQVo3VUZYV2trZzRDWWdqNUR3OUtrd0tmWklOK0VEaFAxanB4?=
 =?utf-8?B?VnpHWVpjOGQzc3VzM25sT2pTWFJZTjVzQXQvT3lyRCt0TEVUMFIvRU1iZ2Vx?=
 =?utf-8?B?ZUw0MFp6YmF4NzM5QWc5Q1ZicDRUeFNleTBBZlZmTVJhWjJtT2JmbzVDTkR3?=
 =?utf-8?B?OG50NEY2K09aVDdYUVg1WEtjdFlqK2p3aHdITEVKb1V4SUszNXVsTXpwbXpQ?=
 =?utf-8?B?NHRoVm5tQndMSFkwNk9pQWVUa3NiUnhyTC9ibFBIQnpxRmUzaTBSM2tWUS91?=
 =?utf-8?B?NzRWSC9ZeEdRQmx4c2lvRmdxdTY5aURIREU0K2JWY0NrVDRGU3RjcEprV1ZN?=
 =?utf-8?B?dm1MVG40bUthMDlNS1d2Z0FDb2hjbytTYldOcXNIY0NHS1NRNXo3dXVDQmtK?=
 =?utf-8?B?bHh0VjFBN0xTdWk5ZEphMVBoQ0I2eEovWU1GUldDYXVqaDYxZTVSQmFhdk5S?=
 =?utf-8?B?Z2tlcHdzanJ3NERnbDNtSFIwMWs5ZXJDMlhRejZzRzZxNStXWmVmT2NyNlN3?=
 =?utf-8?B?QXJEUzFhQ2Fod2dVS05LY1dpSlMySEJOeXN5dXJrN3QyMVF5a1dxNEREKzVt?=
 =?utf-8?B?OU03MldaclNPNkJpZjQyS0Jyb2lzSStMREw2eDZUYnNQSm5GWWRyNk9VU1Y2?=
 =?utf-8?B?QkJ3bmpvYU9RVDNPQm1JRS9LMmhSNTlUZk9pZSs2bHFNVVp2VUtmdk9qWk10?=
 =?utf-8?B?dzBxVjMxeFFwSHJZRXBFV0ZwYnVFQ2J2N2pQalJhUklldDE5NGQ2K2VEYURR?=
 =?utf-8?B?VzFkck1pSDlZTVcwSUEwc3lVQnBJcHM2NFA4dHpUVldwUGkwNUJIMlYxd0ZU?=
 =?utf-8?B?N0t5eHU0bytoYjd6aHRIT0N6ZFNBNjQvaEdRWHdJZWVnOVZNd0VRakhPTncx?=
 =?utf-8?B?elA1MEhMaXpPT3k5M2x5a3dJODNPc1N6OC9SOEl2YmFHVDU0cC9FY2VJUnJh?=
 =?utf-8?B?eEJNczNXR2tySHVIUjlqOWgybVNPOUtKWEdCajZSU2RCb1duZFp6V3pvYjI4?=
 =?utf-8?B?UnZYYVhDVXdLNHdTZmIxNXJaV3p4alJoa2JnbW1TbnBnVzhDTnVtdzM3Znpo?=
 =?utf-8?B?U0NZSG1jNzB5bENUTTBYbWRBaE5TQmxGaXdBQ2ZRVnN2U0xMalI4UzBNekRF?=
 =?utf-8?B?R05RNVk5d0ZSY3kwQnZqSFhJc3Nyb3ZxLzhoenF1YVExeDJIZzF3M0RXenRC?=
 =?utf-8?B?UEdYaU9kaHVlb20wc25XWS9xWllpRHRacFk4OGRudDNJdUVuT0NZWTk2NllI?=
 =?utf-8?B?b3hCMk9BdlErckx3ak9KMGpjb2QyWjI4bEhkVC9ZWlh5cnVGWTZTejRUd1Uy?=
 =?utf-8?B?Qkp6enB1ZzRrbFY3dXFNWVdJNjFhRkxYSjArOTAzekt1aXNabER6SUV0MUdP?=
 =?utf-8?B?ZkJYNnp4N2FkMTNZaVcwQW1xM3pOaTF5TDB2dmxYRWp3Ukc5TmlqelpqN3l6?=
 =?utf-8?Q?0D55nlwRO4BYj79kX2rSyPh2s?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	NpOPQU5YNU98tz3JXrc6zimnNpkuX92kSRNbZAF6XS46MlAp/OLMpk1kK0pEzQSfA9v5Jzosc3aLrR6F6ZmQtyfyKuRI7Hh4fpRkZT99XHnR8FAA95R+ujkoAKkCAceqhVSUqmp8guDQSvVwePWSSY2xB3NImlYyrV2OHkLb6tEAfkCgYOd6ny3MxIswjtegza8/bCfTjqN3qAASXRdqaRF+P8yxTVG/DBnuchnRgQ7S5y6ugIadkBKi9dmfAip4Zftkb2M70ZgD6D/tu++dGI/WJLrUzCvrs+qyqbXICXNRYmx9dTEc/MvzXs7evPlYyRc3EUJ+AZtVhqhAbXuQwQ+zq4xc/KXmGUSJk6cOz63hc/BiIuDqeKZdFHaQODWqBHAPhE0QyKueEwpXtMOt2aNEiyBSIBkLWBxPFmt8lNCl2bI0JDsAecXhy/93Qw1uOjJaET0IFs4Sc8B1ASRfNW1GCCL0F1/GUByy3uiUR70I5fIcYcfBroIb9pXe0uueOO/CEnN5Lg7J6yt789a7w7YuCbCwbCw9l0Sooek+/JIDFqzicrc8WevGmdeoubrJaJXNxQ01irAGmAXfzjAjZes7I0g3IF1ecnJp5BVakLmCjbg+Zn91pR6byWkze2I9qvvqVcGGjptjMpMaqrY/m2NT7nPSVwPl672pFKTlAwbWixAeFmawpVwkKjeYTxLz9RgL8GTyH+oUCjsxdwYkRGj9mYFTap6P9blX6r3aASZbBiJ2pMmlu4GjaVB0t5S1iIZqC0CfkKq4RikDqNwkEdh0jXCDn/vrdCBags6jw8oqvCr101Pc253gFN1IyWD1EFGuDqed+0DHuBrwMBTfgBkQNYaL7ThTuskW8BuIcBs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a782b0c-1989-4450-c5ff-08dbef53758a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 14:16:34.1995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3AtOXJGOLIQleYq2Ay3gmkoF7MudcjhNcpWUqGcpQsenrwUoPqtpW004JKAsSdgO4yrMe8jiLT+7GH2DWVRMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-27_12,2023-11-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311270097
X-Proofpoint-ORIG-GUID: 2OL0SXSAE8Aj6G_XQaHQ6ZkxWCEvbOa1
X-Proofpoint-GUID: 2OL0SXSAE8Aj6G_XQaHQ6ZkxWCEvbOa1



On 31/10/2023 23:39, Filipe Manana wrote:
> On Tue, Oct 10, 2023 at 9:26 PM Josef Bacik <josef@toxicpanda.com> wrote:
>>
>> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>>
>> Make sure that snapshots of encrypted data are readable and writeable.
>>
>> Test deliberately high-numbered to not conflict.
>>
>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>> ---
>>   tests/btrfs/614     |  76 ++++++++++++++++++++++++++++++
>>   tests/btrfs/614.out | 111 ++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 187 insertions(+)
>>   create mode 100755 tests/btrfs/614
>>   create mode 100644 tests/btrfs/614.out
>>
>> diff --git a/tests/btrfs/614 b/tests/btrfs/614
>> new file mode 100755
>> index 00000000..87dd27f9
>> --- /dev/null
>> +++ b/tests/btrfs/614
>> @@ -0,0 +1,76 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2023 Meta Platforms, Inc.  All Rights Reserved.
>> +#
>> +# FS QA Test 614
>> +#
>> +# Try taking a snapshot of an encrypted subvolume. Make sure the snapshot is
>> +# still readable. Rewrite part of the subvol with the same data; make sure it's
>> +# still readable.
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto encrypt
> 
> Should be in the 'snapshot' and 'subvol' groups too, as it creates a
> snapshot and a subvolume.
> Also maybe in the 'quick' group too, see the comments further below.
> 
>> +
>> +# Import common functions.
>> +. ./common/encrypt
>> +. ./common/filter
>> +
>> +# real QA test starts here
>> +_supported_fs btrfs
>> +
>> +_require_test
> 
> The test device is not used, so this can go away.
> 
>> +_require_scratch
>> +_require_scratch_encryption -v 2
>> +_require_command "$KEYCTL_PROG" keyctl
>> +
>> +_scratch_mkfs_encrypted &>> $seqres.full
>> +_scratch_mount
>> +
>> +udir=$SCRATCH_MNT/reference
>> +dir=$SCRATCH_MNT/subvol
>> +dir2=$SCRATCH_MNT/subvol2
>> +$BTRFS_UTIL_PROG subvolume create $dir >> $seqres.full
>> +mkdir $udir
>> +
>> +_set_encpolicy $dir $TEST_KEY_IDENTIFIER
>> +_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
>> +
>> +# get files with lots of extents by using backwards writes.
>> +for j in `seq 0 50`; do
>> +       for i in `seq 20 -1 1`; do
>> +               $XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
>> +               $dir/foo-$j >> $seqres.full | _filter_xfs_io
>> +               $XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
>> +               $udir/foo-$j >> $seqres.full | _filter_xfs_io
>> +       done
>> +done
>> +
>> +$BTRFS_UTIL_PROG subvolume snapshot $dir $dir2 | _filter_scratch
>> +
>> +_scratch_remount
>> +_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
>> +sleep 30
> 
> What's the sleep for?
> Is the 30 seconds to wait for a transaction commit?
> If it is then I'd rather mount the fs with -o commit=3 (or some other
> low value) and then "sleep 3" to make the test run much faster.
> A comment explaining why the sleep is there, what is its purpose,
> should also be in place.
> 
>> +echo "Diffing $dir and $dir2"
>> +diff $dir $dir2
>> +
>> +echo "Rewriting $dir2 partly"
>> +# rewrite half of each file in the snapshot
>> +for j in `seq 0 50`; do
>> +       for i in `seq 10 -1 1`; do
>> +               $XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
>> +               $dir2/foo-$j >> $seqres.full | _filter_xfs_io
>> +       done
>> +done
>> +
>> +echo "Diffing $dir and $dir2"
>> +diff $dir $dir2
>> +
>> +echo "Dropping key and diffing"
>> +_rm_enckey $SCRATCH_MNT $TEST_KEY_IDENTIFIER
>> +diff $dir $dir2 |& _filter_scratch | _filter_nokey_filenames
>> +
>> +$BTRFS_UTIL_PROG subvolume delete $dir > /dev/null 2>&1
> 
> What's the purpose of this subvolume delete?
> It's ignoring stdout and stderr, so it doesn't care whether it
> succeeds or fails, and we
> don't do any tests/checks after it.
> 
> Thanks.


Josef, I'm planning to get this patchset ready for the PR. Are you 
planning to address the review comments as mentioned above? These
aren't bugs, but they definitely add more clarity and adds to the
missing groups.


Thanks, Anand


> 
> 
> 
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/btrfs/614.out b/tests/btrfs/614.out
>> new file mode 100644
>> index 00000000..390807e8
>> --- /dev/null
>> +++ b/tests/btrfs/614.out
>> @@ -0,0 +1,111 @@
>> +QA output created by 614
>> +Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
>> +Create a snapshot of 'SCRATCH_MNT/subvol' in 'SCRATCH_MNT/subvol2'
>> +Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
>> +Diffing /mnt/scratch/subvol and /mnt/scratch/subvol2
>> +Rewriting /mnt/scratch/subvol2 partly
>> +Diffing /mnt/scratch/subvol and /mnt/scratch/subvol2
>> +Dropping key and diffing
>> +Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> +NOKEY_NAME: NOKEY_NAME/NOKEY_NAME/NOKEY_NAME: NOKEY_NAME NOKEY_NAME NOKEY_NAME NOKEY_NAME
>> --
>> 2.41.0
>>


