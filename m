Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525307DE05F
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Nov 2023 12:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjKALd5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Nov 2023 07:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbjKALd4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Nov 2023 07:33:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0187EF4;
        Wed,  1 Nov 2023 04:33:53 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A1AG7BW008115;
        Wed, 1 Nov 2023 11:33:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=3EcMT98Lb5S3U/Nv/Dw3bMYnLxPYi1CeqoCqxCF0TJ4=;
 b=0L9roAGW1fZ4wYsNwpFSxpI2SQDkqY4TPLPr6a6bbHkk0enZurHINfViyHheOnEkbF4F
 Mbn0+lrPOcYeCau6sUFCgYMSuMulA/lEGI3qKoRGa5pzLwaJFsBLldcZcPzjDm6Fjm/l
 NZO7FZEoz/AVhN8C0ise2G/lbuxI5ocQCg29EhaSR4YUh5k8ofglwdJbTn5zHU0LVCuW
 WqfgUGfCzCRtt3h/urbpScfzRFOW9xjirtJb3FhjAc7nVgARAlB7SF4WHrd0dtoNGL+4
 pGwBs9ke5vFhUWKMsGSDe+EyHT3JwNFCizrEk+cxIks62KwTmkWQkAqkTxs4uX4WB5QO dQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0rqdy95j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Nov 2023 11:33:52 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A18t3LD020087;
        Wed, 1 Nov 2023 11:33:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rrd5w9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Nov 2023 11:33:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbrTog3mUGz9aWO68UGR4tpGua5d+V/n4zqx1cQFSWfaf5gPAZcoP4AajME4T/h4/vkgz8KnKKH6sRokCIketnvmNgf/xQnK1m5xy4S0HZIYkubORH5OKaOxwEtGHUNsCS3hKrNuAP3TdhKexuljhe3CKcAsX7D8J0aHxpi7al7WuBkYJZPgocxCPMxsC+e+GTh5IR7dFmNEtOCCKmkrlSFB3ty43LXCON7BQT7g6FnQrI6UepUKfPzD0EeA2k2rYN0qgsDdiXY3fZ//03d4zPtk63sBFWydIfBNobUlXjB5J9yGPCvuGKwKaoTNgOdKSMuwJqykFBfxUJmJ6RVAjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EcMT98Lb5S3U/Nv/Dw3bMYnLxPYi1CeqoCqxCF0TJ4=;
 b=PfaI0UFN6R3VbpAg8xYFOVlUB4wllbs8H5voIOhVPVcTc/6qpkLVAFlF1yWn+wnozbWF5orZejNH/O3HkZPmPm54fbnb88rV2MF7Z6SmTavin17bf6t36d8LoaqUcZqmz1UPAcCxzkfbZHXxR9SmxldOtbJPAE5yTJchkuxx74UZjYMrzMPZ+wJdkonjcKDU/blma8NJxyHe2OXH5Fz5cm9uwtsz1DnFC4FWmNNncSCUIjqwEkkKzeGsU7mzXdWILGc2qTtHonoTK5NYfyVfIAfq0nla7slHNyGGJM3GQ70Pi0QKlqtp7jpOY+5jIYZY7ZQMGP3jTZQnJPg3wL+y5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EcMT98Lb5S3U/Nv/Dw3bMYnLxPYi1CeqoCqxCF0TJ4=;
 b=yxud7Q4wYaplZ5QUAbXt3BeY907oW4KHr9JJTqF/dJzXkJvgoPW54YjOCOqSWKvuFgrdO4YNyJwaf+h32vpAmkDdQLDUMOYZmqUofoFzVwsMnAhIrTLMxUiHhmb2xSQi6SolCUhpipY0K1IBZynmuRKeKhKd4PHd2dXBjw6A6H4=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Wed, 1 Nov
 2023 11:33:40 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb%4]) with mapi id 15.20.6933.029; Wed, 1 Nov 2023
 11:33:40 +0000
Message-ID: <1cf813b0-0545-8654-7cbc-ccd173ba1e0f@oracle.com>
Date:   Wed, 1 Nov 2023 19:33:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 08/12] fstests: properly test for v1 encryption policies
 in encrypt tests
Content-Language: en-US
To:     Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1696969376.git.josef@toxicpanda.com>
 <c77a1a8ca09b2738f432d586177801a579a775e4.1696969376.git.josef@toxicpanda.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <c77a1a8ca09b2738f432d586177801a579a775e4.1696969376.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0178.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::34) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|PH0PR10MB4677:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f83dbd9-ed00-4eec-e604-08dbdace6524
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XkqNSFRlglgl6rF3fN3Zm78Kd+hZL/JPjDe0JF1RDYFOouHB+V/DAmMu+7GKRtAM3mDFkPlSXk5aJ2gurzC8SrNpMoRCFbhM5OIbwJAUTi0OUL4nrw8ztZDrGuyEXd0Wo+HtOk6fl/6VdpelDRBoGRKdP/IsCsl0UQoOXLaCoB4WZxeC1K0oWk19usIMs2rNOcruull37V8t+d3ReJpmPA14u9OLLpQwZIE2iItkyPjae2ODEtCIuqIupEh3YB9s3qBYbun5Sl5JCEWUAazovOANuZFjKFIjya6fDeFUf9B41BD9r8sKajthXhPvbbEUe3/JJWKadyrYmXQGVokR54zdIrHSNvBSB1nKcjfwxY8FbqRCbnDYV7Q5rJgrOSN7/rSi+eZk51lxN9lfKJDaMP62KtqYo3Kc/bRRju8XrZ6cStbZ6WFHfg43Ce6Hw41CB3r9//XoYTrAL/y7NTXXbDqqJ9NI7lcImlQkUCEHW6zWKBR0omO6qLDVd2+z4JLi3S82SbfEZmoTWzuqppoO/mB4aj5p9RjIHwUv08aVKN/IirXU4T6tXz3iMnIZJ22Iqn36pm7AQAAqPaUOM6QjNXd7jrJujNdYKdIrENrkF+llbTscXhUothj2vw6Avnx3q9cET3ApOL+zM5ZR1ozHeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(396003)(346002)(366004)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(4744005)(31696002)(8936002)(8676002)(6486002)(31686004)(66946007)(6666004)(66476007)(478600001)(66556008)(86362001)(41300700001)(316002)(5660300002)(2906002)(44832011)(6506007)(38100700002)(36756003)(2616005)(6512007)(26005)(53546011)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm14c3IvZmR0NFlDUWprSHo3TURCdkllRlJzNS9JbzROeG1vZEZiaHpFME8v?=
 =?utf-8?B?Z0Fyb0RzUmtCVDNla1FFYmYxMDREQXozMndqT2JSV3k5T0liVDBGRkRxSjZW?=
 =?utf-8?B?eVAvZ2tjNlAwQmg3ZmdQWG82dyt0amlvdmN1Zlh1TEpMY0FYSGJJdlhYRWhm?=
 =?utf-8?B?NHlOaUxtU3BDT0pqU1J2T3k5MjVLZStBaEwxdFJ5RjdQeGUrYkNVTkZLS28y?=
 =?utf-8?B?OXRxUnRQMWdaZU53Znlpc0hGRkdyOE83SEhvQmsrSjg3NlhoV3dKaUsvdllV?=
 =?utf-8?B?NmJVdzY2am5walpGeVdBZzh0dERKNHA3ZnU1QmpJdkZqTXNBWjZsZDEzRmN2?=
 =?utf-8?B?Q0lIckNMbmZlSEIvbGFLb3F4THBPaUZVYnVQL3krRFJIbmR5NEpXL0RiUGU0?=
 =?utf-8?B?Mjc1QmFkcys3ZXo5U21YY1pYWGY5U0hTUjRNMTYwMWU0UXZudTZtT3pIMXhP?=
 =?utf-8?B?eEJkTzV3ZlhKWDJ3KzlpSmI3aklJUk9mN2EyYldZMnpNNmdBaTQyQktxWlhm?=
 =?utf-8?B?UnRNWmxtNWxHNkRod1NPVUF1Rjd3UmR5MytuLzlzOEptRHF3NGdzbDcyVUNF?=
 =?utf-8?B?MWJ1S21ocitoZGdSaEVUdDBjalZsaWhtbFd4WnR3Vm84ZGlSSmlTTERpbHpB?=
 =?utf-8?B?YnhiZG1ha0k3OTIwRVdKaDBHOTFBYTR3VkNwQzVFNmdXRW4vSVpxbVlGNTl2?=
 =?utf-8?B?Zms2eHJQaDRoZWZZY2dGSmR4SVJtNTZueW9vSFdoWU9iZ245ZWN4WldzaGpo?=
 =?utf-8?B?dzg2eUFwRzNPTVFXZkJSMEcwYXAyQUd0NmlwalVhQkdPSkhpSE1qUUlFcjZh?=
 =?utf-8?B?YjVHK1N6STFvclkzeEJ2dFBGQkMrWENJeHhTTExXcHIzclJhd1psVzFDeWND?=
 =?utf-8?B?aWIwbE9uM2luWXZsb1ZpSXBoTGpPbGpuUG1xOGUvVGt1dXRCNkN5MUw2SFl5?=
 =?utf-8?B?bldkNHNWUHBlaFo5RDdXZkkzSWFwNVpUc1d0eXBEdUpuTHJKQnVEMk5TWVVC?=
 =?utf-8?B?OFRKWGZoZmxHeUJ0K1RDdjgwelh4cUFKMDBFa1IwdTNGNUFZSFpZRkRpREtD?=
 =?utf-8?B?bmorSFNFeWxPZC9JcXF3b0VyWnhERlFoblhCNndUVy96MEhJT096TFNOTW40?=
 =?utf-8?B?dDM5NWtGN3kvdVh3TUY3QURma2ZKS2w3a2ZSQWJla0dxR0JBOWY0TWpIZEFz?=
 =?utf-8?B?S0pRdm5rRVNIbEQrdXRBMjUzdEIzekZMWmJRY3ByblNybDF0bmw1S3N0bU5t?=
 =?utf-8?B?c1JjcGNnbW5aUmxUNlc1SjNKR1hKUVg5Y2orcGphQlN1Q0gwTWpXSTl3U2wx?=
 =?utf-8?B?ZURhRUdyMnkvY3VaVHMrTUNEZkVqVVdSZFpTKzI5MytMWFFBc0ZzenZYQWU1?=
 =?utf-8?B?dGtaVzRTbnpXTHV6MWNXdnEzSXBISXA0SDhFcWtkTFUwWEJKNEJheEJncTFN?=
 =?utf-8?B?R3didkxMZHJMOFJJcVUzSnlibjNMWFZnUDhUMkhDUEIyR0Uyb1NyL24yaXJi?=
 =?utf-8?B?L3JoZlFVdUsxb3NRcXNMSHFGeVc3UGlId09KQWFRcUJrSGZXT2U3WHZ0bEZt?=
 =?utf-8?B?THErcDhhSmFpL1kwYWVDSlY0eWNUUVJwY1JUYUE5UWJUczlIQXUvU3EvN0Jz?=
 =?utf-8?B?U20vbzFYa2hMdGIrYXFOYkVsOHF4dU5HaEsvUkVpbGExNHRPVGxFbVBseDg0?=
 =?utf-8?B?R2xMQytQRnVsYnk1bXFkK2xJZFpDbVpyUGN0cDJFbzE5U3VFTm1kL0l5d3dw?=
 =?utf-8?B?ZG1ubmVnamIrWThtVWk2YzdKb25DREtqbTF2emxtSTRHd3I5K0h2dDRvU3FQ?=
 =?utf-8?B?djdqSzU1aEFUWFJkTEtUeWVJWVJCYzdlemx0dW9SNWRGS3gveXYrRnFwVFpR?=
 =?utf-8?B?T1lKYUJENGtCaGlFUVZTVnZpTkR0OXZjQ2Y1UlBJODA4KzlCOG1rOWtLdHFE?=
 =?utf-8?B?UFVFNnVxblc5RFR2cU0rTXFtL1MxeEFRU3pGaEtXaUtlYXJUTldKSFYyZXhV?=
 =?utf-8?B?VkRLaUJFOGp1cFJrWTNZTG9Ea1JrM2xycVZTdDZQWFRjUnNmdnIybGM2c0NT?=
 =?utf-8?B?czFLMEJ2YW1xLzR0TXBwL0wwZzBvVXhhR3BYcGllOXU3T2pRVUs2VjVQNTIv?=
 =?utf-8?Q?mF/zhLgR/1XKRpvKP8DzhM/rb?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9bhJMlaX4IIjq/QaL4uuwLVFjnSSqd0/+yWqzLYpbK69DUAcsJfuIePEtow24IE4y/8yX5d58WW67XdHWDwSs1zgQyeh8kt4eYoHZcQk7M0L90wT+4pyKkyk5N+T360ndY2ButI5YZquRe9sR+BKKYTdDlAXzawyShCPeZIqdYBerFynH0XTknGSv6luZ5PJ704zXe/uMDDt+NqD+13T2qup3gDTG41CaT/UrSkS8fiuYewFneoXpV3qfxEBjHmDidCXYf0oT3LRvFECcwNuemW4mhtashShZrc2UsvHjFJmJIdEe8PxZklJOFoNcs5rpKH5/lNz/ToowjjSRQRD53yzEcp/B2O2BeFLnmbadR9kI69EY6KCQCsu6mPljh8TNOMhlL/MVUZBeTvstgJ6csub7Nf+atKg+a6fr+vzWdbywAc/Z+FjyueTpIdqLLi0djDw0wXRCgmwk73zWCeXlAVDtvqCAdzAMKFHEdPcAbU2gEEUBYmddBIlzl175p/hDKN+hzvNqy0ud36sPj5x+QI0NS5NhryXf9GRcnoiKVgKu8hDNi1U6SUFxy0rqjGh9Wo7pGJnv85OqznK4C7PXljE4MCNHHQSViAqxwlIU5XUySxluQliti0NQJd/jqNB2UPd7JLDU4BRiR05T0Od7hPjDbNtUedvhBTzc+YUsEZLmHNwths7qN4INv9M4zHx1zxfATKJxi4db8HVh/TqITLzacaXFqmMNVFcNkjd7WGUhBRpzPhKZuy+ykosCQ3IaLXPsoosh3/li1uGIeg6EsG+PXEdWdUSuJShYUn1my1A33GFf6BEnqB6N7m70gam
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f83dbd9-ed00-4eec-e604-08dbdace6524
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2023 11:33:40.3148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0VV1s7cD+a/hzzYuYXWOg6gATyRpa6ABjwW3zvP2cugFSo4pNR9oKZQWHBnS9pvfZWXSJXY6PKLTUnOcNZ0Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-01_08,2023-11-01_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311010096
X-Proofpoint-ORIG-GUID: YSEGw-24LLJztrfp7GO7nI8pae6FKsdW
X-Proofpoint-GUID: YSEGw-24LLJztrfp7GO7nI8pae6FKsdW
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 11/10/2023 04:26, Josef Bacik wrote:
> With btrfs adding fscrypt support we're limiting the usage to plain v2
> policies only.  This means we need to update the _require's for
> generic/593 that tests both v1 and v2 policies.  The other sort of tests
> will be split into two tests in later patches.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---

For now this looks good;

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

