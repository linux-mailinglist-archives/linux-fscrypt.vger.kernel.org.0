Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7927DCEB0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Oct 2023 15:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbjJaOEx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Oct 2023 10:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjJaOEv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Oct 2023 10:04:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FEFDE;
        Tue, 31 Oct 2023 07:04:49 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39VCnvIS028101;
        Tue, 31 Oct 2023 14:04:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=sXhzPXYgQiU44onURBWftE53LVSJHMX5VyYBmJR7MEw=;
 b=0vMD9UdXLKhcQMshjMzAQdjVEWs5p1HHU+rSgX/3sAX5rqoT9Uf1yvpk6IK6Ugd4uo/4
 7ViJ7TGPs5Wn5Jbgx8nWPGMKzWKuu2Lniu0l6hkTZbi1W2Zrgp3x+YM5fphVbY4ItCKN
 5aj8Yp6lfH6Xugc1UKg9Ty9RsEuvYrHw6sB23lROYihAv0qWqIM7CmrP6eMV/Ke7aJBq
 j7VXv3c4TbahjcmKZjfNnOZlYs74V/+Jep7UnWul4200BkCt/BoM4VCWrAOlRaL7MrBP
 0zFY0bp9JqORLmCGx97dVq4Noikq/9FKXiofS0yLJQ9T6v7XcrG7ztIC0w3ley2gqGey zw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0rw2548c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:04:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39VD6bKG022634;
        Tue, 31 Oct 2023 14:04:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rr5qayk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:04:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCt9KA0gE+Mi1X2rRw3NLOGBbQSyvi9pfAX1X/GKARCIRonU5tqu43cIe6Y3kr4z7wptufMV0qA03gsOrJNofwXmIHugr+nWkEDg4CmLFfUhVjRAIJN+P2Pk+SCKAGkLfwKrxZngQlMZDPeQ6kDRl7mppRw1igkc22tJVE+ly4XOrleXPfrZaal1yjchXwB0HShfBCqNznRq3MuNGp90HXj9E2+yJRg30N+GUB/wxuQ2ohvfkaebiFAQnZ/fTnJ0SX29hMyB1xoGLF8tyU2EcMO1geM8r28KOQYsgUO0Ril8s/lvHraPqhzFx4AmtwQG5Z+/0xHgDvyNz2q2ywJ40g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sXhzPXYgQiU44onURBWftE53LVSJHMX5VyYBmJR7MEw=;
 b=c1sJsVRbROG01aoaYCm6azKoyCe8fUDJXtHGs+hrk0+NeZ8jGD/nPalBwONxs1Wb2SNfk9djGyEl0XF3Q1HyNJrhwUggQEWoNxm5gnJjFGvDOKJbWruEFLjVMMv6a39fNjNVnN1erTNifRvsWPt6WJHmdfapgf0FdHQHGa6NWcmdvKWt2TiC9mQCkwWwvnqeBajmhJNY9ErBmzxCM/nFlGBQKutvK5rcKHFgZcVxgJR51fn8tEVLBnth3EkLUdzMj9i7VYIMv47JqFh8SZQn9JHLhRAQzrg7Z+rlxoH9KMzYxI0LIuTSudWOehs5V51OpnHmJ74RIOHbFwBzHqGr7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXhzPXYgQiU44onURBWftE53LVSJHMX5VyYBmJR7MEw=;
 b=Z+dextQiGZ8hSHCPwc6CrTEkzonTksQLZZhLnWVYKGp6/FmdXx/o9q/pJGfRuXfJ/e+7KZkaPZieUuac6TTBuJn2ZaBdQf8GLZaNmbIOC5cZAJe7CO3tCjHKX/qJoIsxiyfT+5r3lE5qdZbt6yaWOOMXd9io2rWWmg+/lQoWZts=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CH0PR10MB4857.namprd10.prod.outlook.com (2603:10b6:610:c2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.30; Tue, 31 Oct
 2023 14:04:41 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb%4]) with mapi id 15.20.6933.029; Tue, 31 Oct 2023
 14:04:41 +0000
Message-ID: <ced06390-6146-b9fb-e21e-24a88f38a04a@oracle.com>
Date:   Tue, 31 Oct 2023 22:04:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 06/12] btrfs: add simple test of reflink of encrypted data
Content-Language: en-US
To:     Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <cover.1696969376.git.josef@toxicpanda.com>
 <723b5972c3d2d917acc23bf65eb3a5e5feba5ecc.1696969376.git.josef@toxicpanda.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <723b5972c3d2d917acc23bf65eb3a5e5feba5ecc.1696969376.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0236.apcprd06.prod.outlook.com
 (2603:1096:4:ac::20) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|CH0PR10MB4857:EE_
X-MS-Office365-Filtering-Correlation-Id: f045dcf6-8cbb-4ec0-11ba-08dbda1a53b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t4VS85s/XQIanYdSgjuF3IHiNPCk5iQ7jrw/445fj8vtqF/S/uxm7Fh9Yvw0u/oq2fZCJ4G/XQLe7Ak+n2VSSkWJaqXJ/j0PPNaYewkSDp9VJIsHiuFLYcp1mSoZSC3ELeeShma5W5Q0KXg1aF96jcvV64YwwVm9uaUq8gZTAdAUC0PeW5xkaKob7Ph63143W6nIlOlvh0zbAOCp12ByDAwB+wZBn4DFyHdx8ZHDN9RBtlcdH1Y06+fSiNvpbmSYceE0LUIitiJc9c3gddgE9lfwUsLjIBaAwZEErZXkFJtnqBWnupj0E3I5vnBKxHYs72oITUdGjhq5fv4GrLB5QQtugP49u37EwigsROtmI9y1qlEB5vmejYJQV0IC/x5B0NlEgB2hNk+Di0SqVMXRaA9Akc8Df+choMTOUQ8QgDVydqOG/voYzzLS96BWpFXqUlMmObP1TpISWxtbRo8yliOH7CN9ng3Mw7x89xunp+A6QzpleD7UWuqW4Z6yZ7/aY2ltV0MgnCQeG+py/Qpzxq5cONlFVgMx8MFJ299dBXHdaHcp9IuhCiIMDneX5fNARUvbK2dr9O/Oc5Nbear/B/ChXi8FcNvKT2+g4Z38/slC74Y6YlRK7G6fjjdxz0eL11YL2QzMvCdV0itluo+DPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(396003)(366004)(376002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(31686004)(26005)(6512007)(38100700002)(86362001)(36756003)(31696002)(2906002)(4744005)(478600001)(6506007)(53546011)(6666004)(8936002)(8676002)(2616005)(6486002)(66476007)(4326008)(316002)(5660300002)(66556008)(44832011)(41300700001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wk5ETlIrbUdQZDVZZGpMeDdvZFdiL0hrZEl5VFBFNEFOWVJYWDNxRHErbkll?=
 =?utf-8?B?TzZIQmFyaUswcmpmV3BmT3dnOFZBeERPZWE5OTl5NXl5cStXamVLeDZaRThz?=
 =?utf-8?B?aTFxcGFNT2JVSGN2NkdiaEJsY3RzdjFCRHpnR0NwYkJOc0lROTNZNTdDcHFO?=
 =?utf-8?B?MDBZYUFTUjczZG1yMEI3N2pCSDlwSWM1K2hpTUs1dWlQM2FsSUhXY1pIZERQ?=
 =?utf-8?B?WnRaUWJlRW0vS0hnOVVadnBrTmc4UDd5VUdBaFhETVNWYVREcENDRHVkVk1N?=
 =?utf-8?B?bjRuUTlPaGFyWXVZdDQ5aUJCQkZCRk1XbUJ3OEhUUEVNanNia0p6a3J1a1ZC?=
 =?utf-8?B?VVYzNjlSK3c0bDhhNDIrZ2NqcEU3dGUxYWtsOHNyKzdsNG5IV01vWFZyZ0JM?=
 =?utf-8?B?VUh5VVFFZjZsMklGL1d4aFpPMEdpaFBUU3puZUYvc3N4dWhxNktyZ0dHVWJZ?=
 =?utf-8?B?V1d5QVRQY1ZnRTRZaUthYVlxdXp6NVRRdnB4VzVvcEcvcXNvQllVbmF2SGJY?=
 =?utf-8?B?d1dQQ0xYQ211ZVBYNTNEVmhUZldwdUlYUUpJN2ZMWTVaY3NQWTlWSTZmZ3JF?=
 =?utf-8?B?Q1dUaUs5WnBmaEdLQjdaaDA2ZGRnaExzNG9JYTRKaDE4UFJWcWtiWnV0aVdN?=
 =?utf-8?B?MGVpNXNFVlNnTXE0ZFU0M3o0c1IzV3JKMENGN3BOY05uRGttMi9RREY1eHh6?=
 =?utf-8?B?Sjk3Mm5zMTVXdk1FTFoxWHlMLzhKYWpZRlVybHdXTnBKTGhMZnRkM1RZUFFy?=
 =?utf-8?B?S3ptZGNXQWZSZStTV2Q2NXVIWlRWSGw2TVRxWkZtdVJIQldSMVdtQmJrSjl5?=
 =?utf-8?B?YXNQYS94YzV5OTg5blRhQ2diRzhoTkxCUmd3UURTL1dSTncxL2thZmF2SHVC?=
 =?utf-8?B?UndOVFFMaFdPL0ZBVFVkb3kzUHJXNVFYZXhsR25DTVNxWHZ6bUF2R3ExK1VY?=
 =?utf-8?B?T056a3JEbGxGNmgxWEx1S1MrRU12UFdyU1VzZVl3OTNoR3ZXdlVRV3BQUmg1?=
 =?utf-8?B?dGhCVjRrdGU0ai9BNFVtQnc5V1dqc0N2UjRReG1zRUF6UU1Hak9NSHl2K2Jr?=
 =?utf-8?B?Vjg1ckZISG0xbGlMUW41Szg5dlVPcnFmaXhldlZZVkN2Z0JNR3hzL25WY0tz?=
 =?utf-8?B?UGRITDk5RDFuVHhiYnl2SFJjVUpGQlBnamR2aVJiQm0zbmczeS9LNHZVNTVQ?=
 =?utf-8?B?SUlpa2VhY3dvL3FhWVo0WmFjTGlwUGltMXhPQkplMW84QkRKb1N3cEJ2eW1u?=
 =?utf-8?B?MVU2QkdwRFkwSkRjNEoycytLRjlNWC9adGpmWDlXeS9kTzdWL3FqbXNMWWF2?=
 =?utf-8?B?bnQ4bTl4c3lzemR1NWFJMERNcm5tbWlnT05uOE9VWU5iZHB2Um85SzUzUnB1?=
 =?utf-8?B?OFBvd0VKcW5MZVNaaHFZT0lVM3dQYitEUmIyZjNZUUNuTjN4dDBEbzNxdzkx?=
 =?utf-8?B?ZklGUlI4cDlDNWx5RlVxRDZ1MEg3dEQ5UEg1eGZOSG5sa3FVbnRQdWs1Lzlk?=
 =?utf-8?B?YURrbTNwOG1tdkFyZ2xtdmZ6VkFWMVEzSXYvc3VEeTBsWTlHUjZMV0hhREJY?=
 =?utf-8?B?ZVpqQXc2bkdxa2EwcWRNd0tZNlNUSVlXdDdtYnczK0lrekFXRmtVQ1hpUmJ2?=
 =?utf-8?B?VGtQTW5wQ3pJeU83aVd5WDBDTWV0blZ5Z3R1dnNHN2hraWIwOGszTlp4elVx?=
 =?utf-8?B?dDdQMVZPZSszWlVhclNCRkEvNElzRmVkV3FhS3BzQkI0M1hxb3JHVFI0ZW5Z?=
 =?utf-8?B?S0hyUlo1MEhVZ2ZFZU9hVS84SmhkN2p2WTNNU2FZWGIxcEVnZHFGSTZRaUZX?=
 =?utf-8?B?TWJySFhiaGRaeitJMUJnSjZhck0zYm9aMXVCT2JEdnB2ekZETk4rMU16bzF6?=
 =?utf-8?B?dlhVV0ZWNnVlM0J4S0JMUEx1TzUwTmZ1aG44WVR0dnlhcWllMk1FT2ZWbXIr?=
 =?utf-8?B?bEJ1Ym9pTkJXTmlCeHlNcjROcW5uRlAxMjhWVHVjWU83TDBSdXBMRW1kZ01a?=
 =?utf-8?B?S0VKZkhCV3FLVysvR1F4dUVva3NjZnB1QkptbTVrcU0vcjk3Y1pjOTRuUVNv?=
 =?utf-8?B?OXROdHRmZjgxdHI5dnJqRGxJVDlJV2pucnFkMGtrQjlBeXV6aElGSUNHNEY1?=
 =?utf-8?Q?dsrt365JorwahxP3cSnD+YMmj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zgM6/Ur5mpebnzRRXGI4nmPYYH/Eb3QAY5CRicE3bJcLMaEvEqadojw2UgyIzolf7XztbeAd2ovFaHJaVLrk9SJlGskmRHH1gBIbtCz2nyIERaoeLjTpNcUSxSI1U/Tu6SPz9zHKv4jcCASc1WVVWdfqPYTH3p9YFaGFIQtVWDwtSP3dY5lc4LpzNhet00jCGATrnjt6ueDyGAucQn0avbE7AORLsnKIHYYS8MzwQgLFqCMX28F38LmPNd8mng58nheBw5Qg3q9dQTFxekoLNvUk3ZAmYAZCFfTnjsi+P38aj/SKw6p+uYKvVWdR4dHwgB99Ps758vKE05SkgHB/KE/8HICkTlg6BbElT+7kfeHft8dX0bjGFxVV3E8BVABSsm/J8o/MDA2Jzn1KRVV9zbKzsIwCKxpFwFqJzk05FVqPazc+OcT/3cj+shx+2PH/5iStYYEMay0LK7AsGytBxebjx2QpRU7lpQd1iU0cqA+dkMZgUivWBiyUN8OkOinxnTRSZjVYXupycfkauxOrhEhWKiltJUuqGoKzyDJbalN4TQt81M+ZhjRhh5i4WiP+bgxFeDgW9XR+CIMHQjX3yKsQxvELXkohVbzVl+hH05gO3qZ8P/s8r+/L8xP3xd3aLAEt14ML6b3d5ie3Kb84OgvLhe3hZESH9JhB1coYacvlUPVJo9VxVoWDetEk2/sjNXmqvdiAasOamm2py4Ro61lqWH3POfVue5Dix64C9HU/sm80JhYEWQGUWmyMJA5PGMPyKRNoKCCqg0r3ZmpOwHE75E/He3ZksNul3YLVcp2u3x9EpYoNQRIIgvSO1I5igGmPj4HNAanazwuo/RR7cA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f045dcf6-8cbb-4ec0-11ba-08dbda1a53b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 14:04:41.5842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2uIGZuZYya7zhGqyUcsvUy/lS9I3XjWsxDw1QuDa3aqlAlwe8lO5OHt6EakgAELaj47bfcKui+xbfYlz5J4zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4857
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-31_01,2023-10-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=851 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310310111
X-Proofpoint-GUID: EvdEAQikUjlItIPtQy-KL3Hw88AIvEEB
X-Proofpoint-ORIG-GUID: EvdEAQikUjlItIPtQy-KL3Hw88AIvEEB
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
> Make sure that we succeed at reflinking encrypted data.
> 
> Test deliberately numbered with a high number so it won't conflict with
> tests between now and merge.
> ---

Looks good. However, SOB is missing.

Thanks, Anand
