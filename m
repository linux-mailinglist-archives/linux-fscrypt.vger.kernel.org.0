Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858327E3885
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Nov 2023 11:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbjKGKMQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Nov 2023 05:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjKGKMO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Nov 2023 05:12:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCBAF7;
        Tue,  7 Nov 2023 02:12:11 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A77idFJ029317;
        Tue, 7 Nov 2023 10:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=CxfW6eZVL+cS/oiW/LnLn/tJz/m6QurvvQ9oKI8O/Dg=;
 b=SfjDd7ldbgEKBw2SG5jup96cxAHSBRKjPqrcb1ON+Sal96E3UBxcm01fina+moShigIh
 jcA17IOmNFwuPMKcYD9xq+Svvj2uMzh+wUSM+AmSO22GCCdCO4inrIbjolLyLncmGtjm
 t/p1lWg3FKt1L0r9QrbUDQNmsDLGwXZthAJMtJSvZWH8N/LSF5ctEgU9T98EVYTl9Zgt
 oy7wYh0/s1PsKe672KURoDMoxrNfpeT3HNOLPuH4UTPug7aIu+tm2K2s0+cNPe9k6dcy
 3TotMVciMrAqMve06edYiLTn0KY6bP7Xi85z19Umgth/UbLSKc8pjMJkl2gDumwoee4f ZA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cj2wp5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Nov 2023 10:12:10 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7A0IeW024779;
        Tue, 7 Nov 2023 10:12:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdd8kyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Nov 2023 10:12:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nl9jll83L08TtHuAS3NP7pDuA2rfW29wUsKmFJsDpTONBC3VH7mbSgsvMWTvokF/P2f0mgthqZALVfwMjkBhZSgFQhw0OxtiWBs14IRFCfI0R2kwkVSEqkByuzFTTBUeq6cwwm6i8q+L1ju6N3FdnPJmlfApQ7GNNYj1BMFzP8RGuqVfw8vrdQzE5rt7iuzbTljOIoaX3ISTtc46/tO86BzhFunfVfJTnjy6fAMWcW5W5xwEBe3TMAj9vTQ3TAjaYDBku5l+Tahetmkp8rEmBvM6x/l8WDYH/O7PZg5cshAVudGALK2Ztzvwn1/9nnadnSsONgwrWOYdVzVjOx8DZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxfW6eZVL+cS/oiW/LnLn/tJz/m6QurvvQ9oKI8O/Dg=;
 b=GXqphAZTtUBZYqRnKSQHhd3124G3xS/34Spd7+mf3sGvwRGYJuvc8+JrNV2g5TRqnqnf58lT8j3LSyVxk0PbtN5kDehur48aNV34bhY4qEeXkuJ28zRikqQym4Hxqo4RuWIS41TsZ6WWA/a6sK2dfBsH8zD47s4dMSdsM12m5kLiSL4qMh1W0n1OtFXmVbFGRtZrOjrPqcFqSUZ/6SylldO6eRpRu31+0tT45dfTfR3XQqhZNN+P2P4HoHVkNpwQH4O8+vGxTTWS/FKulpbfJssWcKTX211yaa4L2Oad4uArdfgl3QqmT5L/xnwqNjCBzXs52yAtbphJ8W5Cs+lS3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxfW6eZVL+cS/oiW/LnLn/tJz/m6QurvvQ9oKI8O/Dg=;
 b=Rb2xiRU/csGRkUkY8+csKRn9lHi5j7LnbzvJMIq1Jlvfp5f44nHyewxlXtWkXYgzysoOZvdKy0cGNx4QUIX8jJ0x6iS3On7/6nFM+3BaW0X1lmCfDbKybyy8i1Ixj01DQeXBTwk4A8iwyFTLqwNiMBHcV7CtOoxNmIcqJKxNCkA=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by IA1PR10MB5923.namprd10.prod.outlook.com (2603:10b6:208:3d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 10:12:07 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb%4]) with mapi id 15.20.6954.027; Tue, 7 Nov 2023
 10:12:06 +0000
Message-ID: <f42e39a4-3606-4f5a-baf0-0cbdf497fadc@oracle.com>
Date:   Tue, 7 Nov 2023 18:12:00 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/12] fstest: add a fsstress+fscrypt test
Content-Language: en-US
To:     Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1696969376.git.josef@toxicpanda.com>
 <936037a6c2bcf5553145862c5358e175621983b0.1696969376.git.josef@toxicpanda.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <936037a6c2bcf5553145862c5358e175621983b0.1696969376.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:4:196::9) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|IA1PR10MB5923:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dfdced0-3d0e-469e-1e92-08dbdf79feeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uHD2zJhcQ8fUSLWh9f97tn5biz4x2HUX2LF4xkXxa5xozRkrOm1tPGCeCBbhkBaTzKesczh7abKUZQg+v0/fMNGN9TVXbskyyALQQ0/KovQYC+BEt+2BoVFcIW4nPxKoh/2HA2D73dLM5xpmJC7TgjVsHx8Hpr/prlruQj2tEPamdg5qYAL6/tVM0UdpnRFGR8unubTyC0AHe8tWxVsWrXh317j+9kWlwfdf0r4yXfmBDqGWLAPMUdngLM9ETmKw3yKaYJuLxDtf66WjktwIkgaQojPcD/yl7dEZXqrUzeusSZoWrGV9jAb42slVnTWyILBDA8OQvHNgjcy1SGsZMeMTApfApOw/0RqFN+QtWSTEzLKjl3eVsQ2TdeYBJ/aDLdHd1BPwmuEYf2ba7UUKU0+gMQiKmHnx4KklkYwDehVXrr7gidWLNLWYa1FLMIHrnGnRv5pIwBYSyHH9q+OOvWSPQctek9yHPqNnrl5a+jpYsNDN62y4rf7TcnUy1crtfAMwRpc2tDRNvuP5HSNXFqgKSvfFHLTxYJCTkw9ZsFwOP3V2QXoCouKuc/OLStgAIoFhiZ4hLGO3A6+jGl1rg0HcWi/U5UOOgjY9ZeiQviNWSYqCyCAPOTxQFQn94b6NM8Jka0OwrxvNG4E/6HINgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(396003)(366004)(136003)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(83380400001)(316002)(38100700002)(478600001)(6666004)(6506007)(53546011)(6486002)(66556008)(66476007)(66946007)(2616005)(6512007)(26005)(5660300002)(4744005)(2906002)(36756003)(86362001)(44832011)(8676002)(8936002)(41300700001)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDlUQWd2a0phakFFcmZVZzNYelR4YVVRVkhyL3dZVWZ0TllLYUhYazc2M1dB?=
 =?utf-8?B?aXpYZk4vdnI2NzF6dXk0OTZBV3IzMXhNMkxzVTdXNm9tRm94L0l1dHhZSDl6?=
 =?utf-8?B?L0NnbUs5SWRSanhoSmhDQXcvVUJWSU9TRkw0djFFREtFaVdUUlMvVExsaG03?=
 =?utf-8?B?NEVtMDN0YVgxcEpMVHYrdDBqMnlaTFErZ3k2eXJ5VzROY1JtNEppaDNKRktC?=
 =?utf-8?B?MUEwY29EUERoa3ZHWmZvcW10YnJBTm9obUNpV212ZjlyL0VLdkVzVzRuSzlV?=
 =?utf-8?B?Wk1nNEw2OEpJdENVSGlFY2hzc28wbkpYcDYyMlN1bzFiN3lsRVFlT28reEdW?=
 =?utf-8?B?OWFwNWxkaGlSREtTKzViUHF2MFZTTzRZWVNoc1g0Q0NDY3JVZTF0UGFUeXNp?=
 =?utf-8?B?TWVwMlRDSHNaUmVBSFpHekRkcGo2ekVFRE1PVlVQVkgvWDBxV3Vra28xaXRO?=
 =?utf-8?B?S2pKa2tRZUI1UkVaa0JLYXdnVHh6ZmpOOTRoSzNyVW1rMFFKMkh5WlBQSitE?=
 =?utf-8?B?OHErUlMrdzBLM1o4RDZmMU45L3luVXo2VVJOUmYrSGNjeWhQYW1EY0hQenk4?=
 =?utf-8?B?M2o3TTBzNmVaaGxoMDAvekFobkI3ajFSQ1ZnU0NDVmdXVFVicVZjSjJEYmF2?=
 =?utf-8?B?cEp2RG5sQXJFNHF0dmw4SGNZR285UnFuVUlNUGh3RUxOZzh4anJ3L3ZrL2FK?=
 =?utf-8?B?WkZsbHlVWU0vVTlPWVRPZ2Z3bXY1K1JCU2FNTkFRUzBtTTV4eUE3bHZDanJp?=
 =?utf-8?B?d2dyUENtZU5YczU1d1N3MWs3czcwd2c1akZidHR6TVg3Nmk0d1BLV3loaG02?=
 =?utf-8?B?TDAzT3JjcFQ3TktrZVRRcC8ra2g0ZUdpSTMvU1NKVnZjRWZaZVIvNExlYVVV?=
 =?utf-8?B?Y2dFR2hJWUwxNlh3ZEpUNldxVE9xOXRNQ1NtOTdBUUZoNVZZSjVJaVEzY09W?=
 =?utf-8?B?Sm5Nb2pSWldXckgyRUxDNFlxNUticllVRjBTcFhQQXhOanlzZHUzcWpZZmZV?=
 =?utf-8?B?U3ZnYXZ6YXQ0V1ZtaGY2bGtoUlpTek5nWmVpa2RHUlU2NWdkM1lLa0lxQ0xN?=
 =?utf-8?B?V1pGdkZWQmpqL2RUQ3lWTW5KL2RJYnlseVFkTFcvL254ZzhmdHJuSXk1bmhM?=
 =?utf-8?B?TklRQlc0TFIrUWgwNVhkVENCN2ZVZTRhS3pndVcrS2YvQVAvVFI2UklOMkdU?=
 =?utf-8?B?VzJ5SkRTbS8yeVlTVk9xd1AxQzFmSTY5WTRHRjZhMC9WV0hOQ2RIVXVuZTJi?=
 =?utf-8?B?Rm9Cc0M2dDNvazhsOFpUYlFaL3hia2hwaElwajIzV2hyeTBwOU1USVg4WVI0?=
 =?utf-8?B?UUFSaHlRdkx3QmJmQUpOaWwrRHljTG85R0ozbjVKRHh3enh5aTdvdGM4Qzlj?=
 =?utf-8?B?WGl5Unpac2I1UTlNRmZkenQyT3VHY3RlVGJmbHhwRXRZaW9KNkkwOS9WeTg5?=
 =?utf-8?B?YWYyK3V1VlFhcW5QdnlScGpXY1lwUVRQRVEzdGQxUnRWT1hnRXNnS1Z2N0Rs?=
 =?utf-8?B?eVBqZnZBOURlNU9hdVhpMi9DMFFvU3k1bGpRQytZRXBaaGI1b2V4Qytxb0d1?=
 =?utf-8?B?VkJJc2tlTDFXYzMzTmpvVWNxQzc5WDcrZjFYWERHeEFBbUxPY0hjdyt4Vm5q?=
 =?utf-8?B?R3N1cm5RdEw5bEF6dHVKWlZDNzZWUWJVL1hKRDArUVNQYjhXMldaM01YZ3RK?=
 =?utf-8?B?MDUza3hXZHozbWNKMjhTNE9Oc0QxSU5vMk51c0xydXRRWVovSDJneXlSOER3?=
 =?utf-8?B?WWV2Q1h4NkYwVGo0aHVHK2dIMThvdEhlcFdiWGVkSmlFOTk0L0Fxd0VuT0ww?=
 =?utf-8?B?dG5xa2dDYmo4Qk51WEtIQ09TVG1lV0FJdkRhMHVoL09lWnFjWm8zaUsrUDcv?=
 =?utf-8?B?WlNkWFRhMEd1VWEreXhqSUFRWXJGb1BUVGM3UkY5bHlaWnNwK1ZjNTJCbHY4?=
 =?utf-8?B?cU1JNGc3QjgxNEdqTGMveE5UOStESUhkazZ1RlFBdWRiZkN0NXV6ZjhaRUVB?=
 =?utf-8?B?QVZaRGhBZkxOdmVIL1ROdUNLMlhySGhxSElTQ1AzNG1VTjE5ZEEzeElrVWlt?=
 =?utf-8?B?MFdoT2QxUjM5QXZFTVZEUWE2NmJQcEluU3pUWUVmQnpxQ3ZDaWVQV1JMYlI4?=
 =?utf-8?Q?yMjbvzAhhfKy9ImXbBeqO44PV?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1MUj5GtcEKZbFMPB4F5enAmhAT1RBpI5BJSe/AdWmfJ79AZnG4QOS2xG22tQZjoeYpJdoq/iHbMSNzCXQOrx2SjMTy6t1otbLR/Kp46UwnIHA7aSIFddAYkRVhJtGm1GA1c/6WWxIH4PfhtD4HQd/z7o0advAnNyoV7fEhlJOWoe2WmejiOc5SKlh9ztJdzsiquTVaoEg6z6l7ST8B8h2hgY9CCeTbGIMKvzG8V/fha08pzpCNyxcmGMUGFBEP/mm9QekWkyST7QX28zZ8Poo29ol4pdYbkOfn/+vNPpc6C5nYQsty8Q8JmgJgtIw11aeXIZVDIYGaFrOXpN2xHwy46ZuOEOtCrwkyRfh+axoFPDUZVcS62LyqwxugxyEy2JKJSPwA5FEhwBEAzNuo5ewN8cVE+PQDHam7d0uha4ysNg2QkkKqrVXyVcxcEdwjpZmW9nftvL+NPp1n+fVFtmteAD5Oc03YAFAxds5HyjUG+ecWegV3HwaqyYj4a4pJDS47zNc2BEFXRVApK9Nj+GsYrJGNeiCc+qM0ckgUDHId1Ic4Kv6Zy7fjVtm+gyv6J0KCLFCpxnCitTv6norGQso3ftbqEvOQVWu+IPw2HX53UAaKwR2G7iUw6aLA+nqNi46L/Ei3NbOTon5j2rX8B8U6exVos0b2td1fmqkzZtZ/ZZNVhpoZ32X5P/P04j+lu5/b6Fo9sJuqwmnDy5KOW5l0QmdcCY8VfYWtVr8WSKh6IBwPGFFXA9oQ6ntxSjQou6y+jGzD3fch4lswyoHUl7EzbQhETzYBxVbFtAlI/LHXo78j+8MDgZUsSGDvkxNeXg
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dfdced0-3d0e-469e-1e92-08dbdf79feeb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 10:12:06.8860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nrk/idyvyFCaa7Xt2NA9ugXISe36eTB1hLHBa2kUP4LJuncbaj7ucDzC1doDQBjjp2xhEXJ5OkgMcsJKdxn0Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5923
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311070084
X-Proofpoint-ORIG-GUID: oazNTxqY53BU7MewsV4MUQFifW2Is8l-
X-Proofpoint-GUID: oazNTxqY53BU7MewsV4MUQFifW2Is8l-
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 10/11/23 04:26, Josef Bacik wrote:
> I noticed we don't run fsstress with fscrypt in any of our tests, and
> this was helpful in uncovering a couple of symlink related corner cases
> for the btrfs support work.  Add a basic test that creates a encrypted
> directory and runs fsstress in that directory.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Looks good.

Reviewed-by: Anand Jain <anand.jain@oracle.com>


