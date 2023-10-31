Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EE97DCF12
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Oct 2023 15:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343636AbjJaORD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Oct 2023 10:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235132AbjJaORC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Oct 2023 10:17:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52462C1;
        Tue, 31 Oct 2023 07:17:00 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39VCnrsD004508;
        Tue, 31 Oct 2023 14:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=VRfiVE4lpLXw2R5Lr8aqjf9LnGlc2hKQchgTvUwvvqI=;
 b=13gYD7gaZaKVpu3zV0gIgGwJAb8UO3mp6vwfiuXttCv5m7nInV7YxmyFpsKtDXfpQp4Q
 3yUhPDO+T1VetXqr+xBc0039upd4gp7rUtkdr2ai9dj+RtPqvEE+UvLQS3N7MXR6BeZQ
 f9f06mZe5fmlX1FTP0GD8IfXzL8NMKmZXDkk0wvxek2TSrYUqikjlM1IGL4S/1F8aAJY
 aa1CgCcURPBJ2JaEejN3VZYm6wOGKrEr3HIbVyU/wVJ3b9jN1cJvoDScFkVjEH1wyVA3
 FOWvlSjLPVGBb5vSso8PbajDNqJFRMU2vXSAYRn4YZoAtYCGF8eRSdz6jdnFk/pqinso Zg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0t6b5328-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:16:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39VDKxdx009116;
        Tue, 31 Oct 2023 14:16:58 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u14x5kmfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:16:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wfm4ZfwQonFxv1R4/V+/V5Hwj7VEmSzJ1xzWwlpfYzJL61sp0zLB5PMqXoLNWdyxxNEttMV7DY/UuULDVbLMXGvg1vmsoDtK3/PLnqPoooD7xWGmV7KdZV4BuXtXMKvfYJI1tGkKaBvyyxb9bTUSNXkNCex8OD2Tjizv8GJVj2wkij4+yHVogelhFKSTIqcd29lFoX+vurPgT57iI/SfizDPsOOs/XfU3aViMhclyh8Zp3aWwKezpjQmYaIZCEzQx59iKgg5ADLBlhkoNiQa3I2jNDaqFlcKp2Q5zyjLp7Tp32oOKM3j/VX5Y84vnNlIbX88Bmw5RctKyu/YLekHxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRfiVE4lpLXw2R5Lr8aqjf9LnGlc2hKQchgTvUwvvqI=;
 b=RgAVA4opjhq4GANyZOM7y1WEygDy2k/iheBJIg2xVG592Tnfi5OX8TmLZQLk29ooDLONWVzFumioerY7mEP/wSNAJhlrj2mI+ozGTThfubRerBlXhCTkiI4VkOe/5R8keRD2KQM/rmDpzU5A8wno0Rt6UbE/c3Fjyc3TtHyhvCwimmEnmFLenstUxNNBRD2iaNSOtFGh7mLQe+4RmVyebgrI0Lmj+83Nc/iSck8BNjcH6R46ftykSlpmUqlP+Ty9eQC8AvjxBG0tfSELpR57K4MQo/uEcWBjQLGG8m6GR4bg3nod2Mr8u4iUhXMYCnNpyh7u9eX+cHzbQK84dUD3WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRfiVE4lpLXw2R5Lr8aqjf9LnGlc2hKQchgTvUwvvqI=;
 b=YWeAIMOQpkoWx6/oZq+mO2hJUlGKocXgDc1GLoGt6iQGNDtkvQSnzDUrEoZdAcG0gET6kc6phiuyYTIAr2xvtwl36/2LqR8bc+HnQwkmWG+MG1jes6mtMkb3+sFXvJRZ1+gLS8lLFG21lfaX8bUeF5xadrT6PK6A1IjXDnyeetU=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MW4PR10MB6605.namprd10.prod.outlook.com (2603:10b6:303:229::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29; Tue, 31 Oct
 2023 14:16:45 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb%4]) with mapi id 15.20.6933.029; Tue, 31 Oct 2023
 14:16:45 +0000
Message-ID: <c160994a-af1a-fbad-44f4-16961a4a90e3@oracle.com>
Date:   Tue, 31 Oct 2023 22:16:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 03/12] common/encrypt: add btrfs to
 get_ciphertext_filename
Content-Language: en-US
To:     Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <cover.1696969376.git.josef@toxicpanda.com>
 <b568ed0fa6b5a94c38dc1a08d07f4e289bf9d75f.1696969376.git.josef@toxicpanda.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <b568ed0fa6b5a94c38dc1a08d07f4e289bf9d75f.1696969376.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0198.apcprd06.prod.outlook.com (2603:1096:4:1::30)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|MW4PR10MB6605:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e4a0447-9409-4703-da82-08dbda1c0366
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: chtrKua0q8DL1vRJd3XzzMtdy22oaDFaj4k7/ibzUtnXL7zrrlH2u5HIAMi9bwLKrl+PQlSONjm0cwUF8frdsoxs6+WVmud5SsFrBRZEWW90OxsljFbVkNSYBZRbLRYT5T6YDf+0aHSmyr6F45/biTQi8ya3xygYtthgsfZrDpFvS/xkxpCIMPfSAjfSKDYUQXjxfiOyLqtDiuxb+7srySe6NlfHFg09vSBlWCuOwXBwI/AVPsciaEDv5eqrTBwDLyWOfI5ZYkHzKdhdbDTBBiicHXk+nww7qCoIvWNh8M+GM8aL5zuiJWzF7Rv72TbQLZdDpIrIvOqgZU/fhfhh8IbqYBk17IVfRPUJkDQNlQ4JogoqpPPFMz9/+yopBO8jsJKEEFuIKxRfZM+z7b4r55BpLAVuAlXS13DlosH3NwUrSrLN7zecOt8C435ph6QFoRAgz4uI8cGFxt46qPa/R5ltj4gJf9A9ndF1l1ZddfYyHcb0200dpAw2pBIuxm2FySOSS6ARgBGbGad37q2wwlFwLzhE8sX6AfTUHmjqM2L3T+BS5unTlnGFRxyiMOtTPrf3ZciIzyztGbVh9TM6ZzX4WD7oKiV79ntFEnGwPma3vAfR2eyxhx0J5qAlT+UT8t4XObk6O8WAvF5Llm8hTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(346002)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(2616005)(26005)(6506007)(53546011)(6512007)(38100700002)(36756003)(31696002)(558084003)(86362001)(66476007)(316002)(41300700001)(66946007)(5660300002)(66556008)(8676002)(4326008)(8936002)(44832011)(31686004)(6666004)(478600001)(6486002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkdhdE5QT0U1TkxHODRCMFNLT3ZGYmF4R3Zxb0pqSTN5RUUwczZPR01mL0RC?=
 =?utf-8?B?WlNUWkk3QVAvNVJ3dUlIRVFadkdhWkczYlhZR3BMQTJnVm1qV1ZwYlk2OVdH?=
 =?utf-8?B?a0VCY1NsTThlOTJiZGFFUFZ5R2ZQUTlERXVUQThUeGVGanMvUVhJdm5KSVJy?=
 =?utf-8?B?K1RkVTFyMkFkMjI2Vk4rZXowYmZvOVZGWG95emRlQURLdUh5Sm9aOTRuTHV2?=
 =?utf-8?B?NlR0U1ExcmVoYmFDS244MXBaM2RWdlhNQThYYWRDK1VZY1lTYTVSOENzc2gx?=
 =?utf-8?B?SUFCMFovMldxV1JGdEhWaGhzYURQaWkvWEpFSFJCc2p0UldVcXZnK3hsdDY2?=
 =?utf-8?B?aEE4TS9oVEJXdzlVZlNxSzlHMHRURDZPNk54azhuNGkwc3AvYlRFd2kzdWpV?=
 =?utf-8?B?SDlHL3JVelBqS2g0TG80RFBzaWYvVGszUDNWR1U3cWJ4bFVVcnlyeE9lY3Za?=
 =?utf-8?B?V3dGTmw5R3A1MHpSZm12WUd0em1waTNaTzdFV3VLWVVXZFZPNHJNbEIvQkxY?=
 =?utf-8?B?Z3lBU0tSYzFmeU9IekI4Sm94ZUxncGFTcHVnd3RmMWFHbEl3Y1hhSnFCTW1J?=
 =?utf-8?B?bmZlR1M1UjIrVFJvc2JKMzZFRzh0WlA4amFVWFM5WDNpckFlOTlQR01ZSUtC?=
 =?utf-8?B?L1RiOUkzVnViTEt3bHJkU3hBaXZpZHNYeEFiaHRFOE5zS1d3MEk4TGRiVVoy?=
 =?utf-8?B?MHBwMWQ1L2g2UkF0RCtnNjhUWG80QUhWMkNkWldMalk5VHM4Qm95WEljbjJU?=
 =?utf-8?B?d0xhNlBFWC9nNHZlcWRuZXRJeGlPQnh0c1d3U0U0emVlaE83L2hNQWpLbkdB?=
 =?utf-8?B?ZmpldjVKUFRiREMwQTlvNy9GY3NyT3N2eXlkbkp3SVFQd3pnV25IdWRLZERt?=
 =?utf-8?B?WXlpeGtpc3VVSGdMLzJkbU9XaXpSNEpiSkVBTjNxb3pJSkNSOXVZMzBBOHZC?=
 =?utf-8?B?ZmRBN3pwMWJlVC9TWGhzaDhjN3JpNGdsNjdhQjN4WWJPdWZ5RDIrU3B1RGxl?=
 =?utf-8?B?c3hud2o5emR4blRqTkRGVXFzcnlCZkZzUS9BYkRIOUhBcnlYVHhDNnBnWXh5?=
 =?utf-8?B?eTlxeVVjTWN1TXVLbUdrSjltd0ZsNG1jMVh6b2hIL2JPTVZVY1VpcWY1cksy?=
 =?utf-8?B?TThuZVJrUVlZWjFwMzhxNHJYWFZGUHRrUWFBV2NBbEhWdVY0a2ZyUGdDWXZw?=
 =?utf-8?B?SjBzYWkyeURvR2VOTXgxdFF1UUlSdm5ZTGJDV0xTZmJqZ3pqd29aK3A2NW44?=
 =?utf-8?B?SkNIR2RIRmxmdzBQbDZucFNaeTliRkhkN0RFOU92VWphWS9UTmN4ZS9VR0dB?=
 =?utf-8?B?R0hnQWhkbzVvM1dNMHJaNjA2QkxFOFpEVDc0d29DRXNwREpSSXo0ZHVQTm5V?=
 =?utf-8?B?YjMxWUw3S2l0UVNTN0M1S2VDekFwY2FGcDNNSWthV2gzMDAva1dmQXpMREpS?=
 =?utf-8?B?WXZpQmJMTUlIaEIxL2hSTEJOaG9QRCtuRDZwc2RRUURvZy9MSWg5MXZwMFpk?=
 =?utf-8?B?ZjlDN3NaYnRXeXBBczEzOVlCUVN4dHdYb21vTnIxL25ZTjhjRGM1QWtCK1JH?=
 =?utf-8?B?Sm9TUlFUUWY1N1lkNTIwSjZzeC9QV2g2b3BaakNoSWlFYktGN2lsa1lldExh?=
 =?utf-8?B?SHZhVGpUcXlDRzRzRVdmbDZOUzJCMTRpKzlnV3dwdjRGcm9mWSs4cjdsL3k0?=
 =?utf-8?B?V0V0bkRBcm1ydWtybnlIVDNZenFheHNJR2VtYU1kZ0FqUmJHSngwZU9XSGVW?=
 =?utf-8?B?MmNna3lFVGdGZVYrQ1U4WllRenlUWUNOeE5HR2lJTzg2ckkyTXFZeEYrRCtt?=
 =?utf-8?B?aVZrdGszU3lSZ2dYcTFkQTBoejY2enloWWNDYWVFcFZZcndjQkZpYzhWWTdF?=
 =?utf-8?B?YXZKTWFNOWtaZFVsbzlCWU95Vk1TYTRyZ2tjcnlpZnJGY2ZrL001c2lsUElM?=
 =?utf-8?B?djV5TE1nd09TM3RFOU1qMExLTXVBT3UyL3Y3aThHRGJjRjM5b0wvQnlxL2s4?=
 =?utf-8?B?OTZDcFh1MlhaMFdnRzBLVlZTWjdrQUlRbkhQRW5YTEtpcWkyTlhRRWt6ZUti?=
 =?utf-8?B?U2dpRTd5bno2Tm0xRFI2bzhWWk1mRFFjSm9wOXFZa3dNaTdoTk56R1k5UzNT?=
 =?utf-8?Q?YpqWN+JvjfyCLvuJgVAK+9Zi/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 8z9ne4I+U1jaapGgNImgpGqtC/fFi+EvPwfDEbaGk9LEkDX5gvhe5/sLSojVmT6bhMsQGoNvldF+DVXf3AWKtIyZMOCSu0+bf2l/aeMam52zSCUapAtzlvufVC3RMTTu5IgJ9bgiLHYTuNQb/ZgzNqZCVeteXYIqAy/j7ELEqjiHGTMrDK5xY8ftAGWUvbmlvhumirkh29kFiUvZ2tOA5swVUrefh/jJIMjwHqyLdpIc/6MInUqMF3OS33h8BoW9sPit2GGsUfckYfY03c0z19K7bT1aEbNvo2BQa7cFdgZk6UCJUiaE4RAzDzBXAzBjxYwqXRAgRc+5alLbp7jFeEjsk5oo3sA+VkSsKLFxw7Azs2QG0w6ZF8jq47NTY4iaqkWnV6kZGVtSrw7jLfyPwwAmBbiwAU65f2r9nR65uwI211d0QbdTbXjMXCKQw5E9ALVXa92bhotpYST4edApohM5cK7ZweoUAt4ZDaDDB5rJA5GLCBBvkeQncq1C0FQj4qwdetBorujpp9/z3FJVI0VOuZCEWn9QiXthiS0Fmjxo7ODoV3iksFT/HOkoHjno8+vwiPHTvax8GEH4qHOS44pFpSnIBh71jPQi+DqjFTuHdx1DLCthqPWdnxvSo80Z2pshoac5kYjO8X0Wy3d19/tJN8NKhnqmdeWxT+H+3l3/nZRAbGyu1FP6AuF0Ym6g8kXgdFwiZo1ZVOGUmGBsxl/Hgqig1bFAi+EHeuWIL0GSGqbDy/tgsB5OdCjoh59/trM9u7LX9lJaAxWsCIZqSRGEI2Hgpqs9FfE1XpH3HHHRP3+m4CBFeJ2KB1Eez8fIg1Dxq0phQcSz1HtfnIE2AA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e4a0447-9409-4703-da82-08dbda1c0366
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 14:16:45.7851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G+YsDnJJymRDEw2Z8zHaMxnauTVkF6nb8ExI/L6GHUzl8sqDiBXPCbCMga/7Q155LNRF7Ln9uwHtwdcYofDwgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-31_01,2023-10-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2310310112
X-Proofpoint-GUID: TK0JIS55BHT0WWbfv9tfNQ8ftrE_Rm9i
X-Proofpoint-ORIG-GUID: TK0JIS55BHT0WWbfv9tfNQ8ftrE_Rm9i
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 11/10/2023 04:25, Josef Bacik wrote:
> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> 
> Add the relevant call to get an encrypted filename from btrfs.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Looks good.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

