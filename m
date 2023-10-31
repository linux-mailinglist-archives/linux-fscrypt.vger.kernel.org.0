Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C29B7DCF1E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Oct 2023 15:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343655AbjJaOSV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Oct 2023 10:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbjJaOSV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Oct 2023 10:18:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D706BD;
        Tue, 31 Oct 2023 07:18:19 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39VCnsCI000459;
        Tue, 31 Oct 2023 14:18:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Nkaarwspkodf2sc21DtFILWcprWb/fyketCJzRf7vPY=;
 b=decAAeFIqKZU8Cu/tpJm0dubxYgwmkfyj2HMzZ+guLDUdFHHU+3faDUB19oo/+6kiOkC
 zI/qdoeLNGleeO7kjnoAS/TDj5OjwolclxRdS7kzsU8aWrrathA9uSrX0NNKXT40t9NW
 KgEgdZMebuQxuFi/R5+mm5RQn8oJorgeX0qwpDv1OMd6iOJ9dciQ8T7HDIfbUHUaz4cj
 evd7sqr+MacY1BrAMww84EquaI8jvm1bu7XKmn27baatnzLyzsOMpbom20JJNX96ziq/
 pUN4lS2KAtZml2hUFAzyBZR3OPGf2UpdOow/JuZ/mhQaOBltSbg5BfAirjYPd2xvmT5D Mw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0s7bw678-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:18:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39VDGsnr020099;
        Tue, 31 Oct 2023 14:18:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rr5smrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:18:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7QOvkV6Pnok6OYyFy4o0NQtokt2STnO9gLXgmwVbvfh/6Yn59z1VgXhRBaVvOrMLdq716vTMhe2cGN5gTsw8ToTgtX+Ot+hOymKqs1QqeMFuE9obSLnL1k2veylYyJZz3ATcO1jO0lBquy3JmjEFYEG40sCrtT4RbVi9Oqzdetk1VTgNSs5GEnPDdtEfGZamnT07ZnewcBHq+V0FiDHqE5yQRS0WIz4ViMlPT9FrASU784sSNtfOJTA7MW5rqxXgPb9IBI1ywGR8NgtuC5sEMz3LFwaXUADJh4bPlFeqH+kiagk/sRK8wwxtG3Y5Xuu9KsImcNTE/xDgiZM8QL02g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nkaarwspkodf2sc21DtFILWcprWb/fyketCJzRf7vPY=;
 b=AFUM/QQonbDCpt23DGe2WUfGoznaUNN731rk8zHkRSfS1wrmBpvV+lk3+8pm4LKSv79aB+GwBHl6PWDhZ98ziACcKPx0naqW/MRImPurWEfSW1Zt/eDJa/6urqKbW7Kp/StLjkIBo0eVq/N+pTLPiPus/ofchNiJ0ZcjSwmiNnMoTjE3yhl6El51Lj3xrjiPghJIxZeVn3sd6Fx5lC8xTwonDZ9ZBizbWvjLC8uNEIf6a9zho8InHRAfidwlgyYH3b9cmt2R6AhFWIJTakel4rdHo0tIzcYRJpWi3/JqasedIIj94ieAUlLNhKine1uEwAIchpJVj9mG+K2cochU8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nkaarwspkodf2sc21DtFILWcprWb/fyketCJzRf7vPY=;
 b=RYtNAnTcSEAxJEHZqzXgXnCsi3NTrNyfT7MiooFS/ywpgO5RbbYdh0jWrEUIJUCamCYmTeEK3/9K/toEss6TTq41L8hsx17j5KXQSrXvJ/c/R90n1R4pKWQk5OTArueGitM+5ipF7wE2dgmbzvZCyRAjReUrcgKQvKZ5dHV85kM=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DS0PR10MB7203.namprd10.prod.outlook.com (2603:10b6:8:f5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.24; Tue, 31 Oct 2023 14:17:51 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb%4]) with mapi id 15.20.6933.029; Tue, 31 Oct 2023
 14:17:51 +0000
Message-ID: <cf85e88e-cad9-1284-588b-4cf6385b7e6e@oracle.com>
Date:   Tue, 31 Oct 2023 22:17:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 04/12] common/encrypt: enable making a encrypted btrfs
 filesystem
Content-Language: en-US
To:     Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <cover.1696969376.git.josef@toxicpanda.com>
 <905514b9fa178c51afde27c4eff456079e010750.1696969376.git.josef@toxicpanda.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <905514b9fa178c51afde27c4eff456079e010750.1696969376.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0213.apcprd06.prod.outlook.com
 (2603:1096:4:68::21) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|DS0PR10MB7203:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e8870ef-a532-43f4-619b-08dbda1c2a71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l02zrU/3UeJVD3g1dI5FtU8OJmHO5MffMU1zcdvjJ9IjUw0ailJfRTRuOJ/Ke19rLiP1zZ0mty6Zivp0LENBH8YZORkakn8fUSnZpcqYKoy1k88EAfLGlDFL8uauW8mOjmSvUL9ZngH+7VpTGPfCqo/eev/rJRxPT2U9tGrpswlwMCdBmozCH8s+ARU8gC7q2gHPIMnxSrjv9sP7EzembSjg3tkD6MvFKp8Uq1ME6QmJf2goHUcJYolDlc08AHTxD2LL2SProrypnSt9LqNiv1casqEN9fA+KSpFwz9Dtj0sZ+ZxgQmq5zl7NCSUUzFJyiTrb4Ut83iba7z0958ulerDx6KM08yNywT6Br5/jr/i2twlGEQGGiOerH7taq4Hsn9fDN9mxqJPwIXyiQQyOkHDbWOP0SnjC0fVXJAHfYCm8f2q/qCaDh3Yp8KC3jUD5G4Ao3Ll3cDVrJ+F2VThhlOxjiCTyJE5j3P5oKMigE+lhK9wcXkC3NPYqsqV1qGa1IWHiyaFQr/gCzAALyuobaNh0AHpt0r+lasjap0hXowvhSgJkbHkLzCWOwd3ObJ0tiIpu8wyy45oaTqhNdjq8j/eFZ/dOjDjMXF+iizCq/8vZot2icxi9/3Ctpu3uTHyco+TO10tEXjKjJN/wZDqvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(39860400002)(376002)(346002)(366004)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(6486002)(26005)(478600001)(6666004)(53546011)(6512007)(2616005)(6506007)(66946007)(66476007)(66556008)(316002)(31686004)(38100700002)(41300700001)(2906002)(31696002)(5660300002)(36756003)(8676002)(8936002)(4326008)(86362001)(44832011)(558084003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHB0UHdyMWk2L09kQnArdEVRSWZ2bFJhQWFEOW9RRUpocVUvcGx1azAxS0ZF?=
 =?utf-8?B?cEhydlVYR3pZZS9XMGJyV0dVTnlRb2pFTVZQSEpkRnRoM2J0YXYweTg5QzdS?=
 =?utf-8?B?YTQyYzVQNzJHRjFFU2pqSm5nZVdFV3lzWmRhVDZVckx4amtEbDhiQkdKSEJU?=
 =?utf-8?B?Z1pEUGhZRjk2amlTRW5TL3V0WmFvaytGTnpEMTkrcjBLUG82Wi9VVXFXbnRH?=
 =?utf-8?B?YVcwNzExWGxyc1FWeGgyeSsxYmRIZDliMUh2Rlgzdm1XUU5xWndwYndqUjVn?=
 =?utf-8?B?TFR5Rk0yWUxxblpOMEdqMHkyVnV6aUpSV3IvOWFySE9kUTBCajBud0k4QXA1?=
 =?utf-8?B?OHBZL3V6UlFjdlpDNkhETk5XZWVTUkcwNmdhUHdKWUw3WU1pdzVEendaek1H?=
 =?utf-8?B?RWZsa1J2ZGdvT0ZkcWJCcDEwQ084ZTl0UmRmbFhmc09sR2ZNNjBFd0ZyVmhk?=
 =?utf-8?B?Vy8xUGx6Zng4MUNLd3hTZlhZQUJuOFB6ZUtia3VRZWhaV0sxUVJmN01TOGI4?=
 =?utf-8?B?dW1HSUpvL1VWSTBWYzN0NUVMbEowNEl0YThRZWZQalgvdWlnMkR0NXpRS054?=
 =?utf-8?B?VUcvYnRublJ1ekkvdTdObWdHNlFaQzRtbzh0a1hxc2xCQUdwT0Y1OEJIUE1q?=
 =?utf-8?B?ZTlOS1YyalBPcC9sRnVoeUhDdnUvNXJaSGxHSDRxOWRFNmRIUzdGbU8zL2RM?=
 =?utf-8?B?dllWUW8xWHBaWm1KRGx2bmNYOXlLN3hQSUlSUWk4SDRjRnhQWkc5ZFh4UENL?=
 =?utf-8?B?dE1DdE8ycFZ5cm9JNG1MSTNrZ1JNT2I2M0xUSFZLL1k4V0FaSUpBRHdmY2hp?=
 =?utf-8?B?Q1BMWDR6aUxXT2NVN2dRYitpdkhNT3JSNVZVSUEzenIyMC9vbDg1ejRUMDBK?=
 =?utf-8?B?Z01MV0MrQ3JDVjU5Q1FnZU1mK1lEcElhOCt3dnNLZU5kbStsSVJGOUxRT0NJ?=
 =?utf-8?B?TFRBQW1PaHNkSmd6aDY1TkNUbzdNd1B4Zk9RRkdSUkcweWVnYmdkaUM5UE9J?=
 =?utf-8?B?eUtzTEk4SnNFdXdjS0k2WTVFK21TTGtxaFNOalcvRmZ1aHNYMy95cE42aWN4?=
 =?utf-8?B?dW54YzZjYXdCS2toOHdyNEVUSHJac2ZzR2paR2tGNXZad3RSM1RDUkNZbFdi?=
 =?utf-8?B?WmtPTGZjRVBBbk1tYkRVbk5sbjMwaW1CQTFia3hNcERIVUU4ODdRUnN5OEVU?=
 =?utf-8?B?b3dHWGhMSXlCbGJ5L3VwU3dZR0VRT0xVQ3lmOGQ2Y3NaQW1QQnlNY2xHbFNv?=
 =?utf-8?B?b0sxd2oycExLTit1UVgzV2NlNVU1TGRkNkk2NHhLNlpqb1FLMTlBejhEWDVj?=
 =?utf-8?B?NHlqQ2xDUE9KNTJUcXlkZGRQMUZMMmEwQU96QUhKSXp6dHI4SVZwREJxWHVT?=
 =?utf-8?B?SDJQWGM5ZU1XWFRtUm5lM3hEWkVGclZZaTNNaW81aGN6YVRMTVM1TGNIRlJx?=
 =?utf-8?B?MDBKOUVwcTUvTDg5VyswR1VKQ2h4VTl5VURsMm5MK1pybmJacXphTU50SXNY?=
 =?utf-8?B?TlpxZEUwTzRKcSt5eUE2aEdPa0VMbmdXUGc0Zng5L3VrbGNRVGEzcHdLcWFz?=
 =?utf-8?B?M1MwcW5MOHlkT0Z4UzNOd3JTem1Memx6YTdKSldlR1lJVG44WkRQR2hPOEhi?=
 =?utf-8?B?ck9UbmkrU1FpaVZSNi9tdHZEOHFJUFptakI4VTN0QW4rQzZicVQ4cFc3SktX?=
 =?utf-8?B?aUtCT3d3R1RmVitWQk1Ba29QMVNKLzZNTXBRMDZpYzFkSGJ3aHFnQnNsUnll?=
 =?utf-8?B?YzV1Z2dyZXBVckN6dFRsaFlMQ1JGdlZjN2JmSGxPZUJ0US9YTEZRZ01aYnVH?=
 =?utf-8?B?TDc1QTRrY1NLd0RwZHFadFRETXk0bDhzUExzbmlpT1crR0FGRGh6SURZVjky?=
 =?utf-8?B?QlpyV3BxS3ZiL095T2VMZnVSQjJHZ1piZkxZaFNHeldJREpCZUp1Qk5FN0dT?=
 =?utf-8?B?UFhZY25iRlNSeXdvSHpGcS9hSzlKRmxWYnRKWFZrNXR4bUdmbjFsZjhRVG9j?=
 =?utf-8?B?MFQ1UXh3WlN6d0FMcEJLS2k4Y3dkeWpCVzRFYjdzTHhhYW9aSmtOQmJGR1JQ?=
 =?utf-8?B?M0EzbWoyMFk5UmZkc3VMcUhJbjlXS3dRMm9lWVI1dnNTSVFRMlZWb1UxOHZ2?=
 =?utf-8?B?aFNweDcvdlVUdHJIc2pDV2ttUVF6Q0QxNWoyRHc5N01SZUlmVGNjV250dHZn?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tYW7U3HjHHmkogkHLv0MGs29a9vXw3pkRN1z01X0ObCRoc0femLpgxacZ5Ki5ttd1O3GbQ3zKAYHtNjqe5U/O218p9rVrCY8rlZeI1MncyioYLr4JON0K/fAmjXReNkZ3chPKv1FKIIG2Ndi2BeUURNtYuTN5xB1M7eZrQndolTF3Ti8LyjeM92ikEpMS4eV0dqtfsYOJwM5tTIcDJxrFuf1Xpq7/MjEwpMdzJFd2eAMoHXQAqMQXRlZpeoA5hUlzdmJiTb/ffETFY8QD6PTV2YG4kkvJYYRevf35sp0wba9MNPKq0Sbh4iQg0ihsqMowqMUXUsRyHtb+qF/sZXdT8RA+5rcYnnGU4CyPN0H1F5kRtQYnoFXf/7J+ebwXp7ujE/F8nCbtR1RAtdTwI10DHc5D2mvJFo//EOqpFKpGc37AOTnvO5eU/vWkjW9Wluaz6vIKHnfvCfVX4Q1/rBwYimbIQX/UwpWzAqqAOjxNVAxGDDdQ7i3V4V8jfIAYE2dI/JBwcIoJJmHvm1EwWcsvdR2pPxyHqS63pbuvHaXV7p+NQASf5u1B6h3vaqN8qHZ56pD+UzT+/jiy2vQhrurTvnHRM9N1L+XVpHjdQ44ijRLt0VifgqskAy6O3Hrei0VMRkdhoHgYIZJFSUQSWT42n8Wq/GUxlXK/iHvzTxfWMaPJgSc6xvRLvr6w245NQvVt/XWQElhCdizoqjOBuYSNu60hxD03Zl4tF2v+HNpJnVYHhLNnLK2PfeseOAPjJhPgh9TU8HqS3Re4gZbyFRSkJrOJNlSbv80zfX1FSnzVRUDHUptIYwXNAf2dMEOHyKE6hG7j7SuKT/KeiFQiKGIKA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e8870ef-a532-43f4-619b-08dbda1c2a71
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 14:17:51.2994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xf4Qj8umflf3B/O+RpVz8N/hk0YLBbTaGrhCX8UegtEJ25ZpOn4Axa8YLc4vYc2PTdawdNzJK9MN3TNCEHStVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7203
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-31_01,2023-10-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2310310113
X-Proofpoint-GUID: 2WXR1BP85Ca2H3-fdRhG3IrkbKV_7PPZ
X-Proofpoint-ORIG-GUID: 2WXR1BP85Ca2H3-fdRhG3IrkbKV_7PPZ
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
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---

Looks good.

Reviewed-by: Anand Jain <anand.jain@oracle.com>


Thanks, Anand

