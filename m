Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2497DCEF5
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Oct 2023 15:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbjJaOOA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Oct 2023 10:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbjJaONx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Oct 2023 10:13:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51118DE;
        Tue, 31 Oct 2023 07:13:51 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39VCnsk7000446;
        Tue, 31 Oct 2023 14:13:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=fBw7yHKpJCvlqmNQJIvuOSJsMo+SYHXVzUf+3Q2tGSY=;
 b=OasYDako0mzD/J3lXs83tbsss7kmIKwel9F6ajERl/XfNfMfKUlv7SabzwyGGMR/t6CB
 0A/h6ioSInDQ2vgQYOwYba7Qs0NvJ4LR9IstJmFB+sKN5T8qYnn1JiTX+nU9p2odz2m+
 ymHM8bMv9M1H6InJ2t1eipiiNKfR5Vfyc4XCBw7q81NrrsWjV8to1UqJh1wo3mfSRmkq
 VLZ45KsOqINdDR/gYMWgGVCiEVzLz5gR28qWGkyyZ/PGNgA7rAv1gCG5LGHfaadRodj1
 J6B20bADhUZUKM6NaIVpWh7WStiZ/vB170Qw0CxNmjgBedG5/PrtHnABvdCjOXRb03ww Fw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0s7bw5ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:13:49 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39VDRVWt009247;
        Tue, 31 Oct 2023 14:13:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u14x5kg7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:13:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2j4s7oYUiioc3yg36mVqSdSfpz9lrbbUGkngfSAqKm9Lo/7khDfPjzMfe5PEdbx8kKeDK229DvBMrTfGvYeCDlsA1yXeRByUHrucqyuSZytzKkQni5qUhJBrLTbG4vQYVd/H0hYKu34JC/CbMxwnrfDTnm1vHj20knOJ8qShAs9pgOACtU8a9u4TEwKfJxxeIHzV3Tb9hCRb/IvO/3IA4OGk1TBCRsKpvEbUW58+WkTmyRFLlQnrd7SJytOKDfG0WPY/7StLRmOj4qAboVHmtOXcF7jwHVF58sWlpE8JCQ1dtLbfc5ijukM53z3Y70yp5RPNQirC39I/C/gKbHGNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBw7yHKpJCvlqmNQJIvuOSJsMo+SYHXVzUf+3Q2tGSY=;
 b=UDLAWejn9Tn/RsCsuTpIGYPSNX7Ti7DF2EtiwVetOQjb2fOS5kq7PA7PmvD3jbsUdqQdpbQSvd3tnlwgY0yeng0itYdCMfpoKhx+HIYd7bzFD0X/g+cdbPwlU1pxdhRGnPux7aa4F9kv/gKllr5wZ6bf6DSY6fuD6NOZFktyNYl96yOnuE0h4Q3wnOYa6/ODA9rDRBw+3/hTiswHvCSxTb2aAWJLeDFq933nD7bvj+A/aqQcXTQI0U/ylRcn0qOR8aPvH9AV7gF1UwuUVoVIeRN5dzRtRDYda7X8ZxHrIZgbtQ3zHd4T+SeqqJgnJK1PozP0Q4Ha7nmVZR9j0YBNbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBw7yHKpJCvlqmNQJIvuOSJsMo+SYHXVzUf+3Q2tGSY=;
 b=rYFDJuhPVIlUebidsCrBJbPLpOlhKFDrYSrvdzm3lRysnaZXLIA5Rr8bpHVJJtadpEdlSL1w8Utafo02o1camisq4l6vn6xiIeqmGCPXEX1XsmFjXrrbOEZ90O7lPQX4F+CbbyuOA13hb7y+kMTvRuWbGxVmSLdNgec7o2iQeJ4=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by SA2PR10MB4442.namprd10.prod.outlook.com (2603:10b6:806:11a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.23; Tue, 31 Oct
 2023 14:13:46 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb%4]) with mapi id 15.20.6933.029; Tue, 31 Oct 2023
 14:13:46 +0000
Message-ID: <6e202446-46d4-4db3-7620-d20b7d22b512@oracle.com>
Date:   Tue, 31 Oct 2023 22:13:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 01/12] common/encrypt: separate data and inode nonces
Content-Language: en-US
To:     Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <cover.1696969376.git.josef@toxicpanda.com>
 <d5a7bbf5027095a1177c0da42c26aa72aba84064.1696969376.git.josef@toxicpanda.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <d5a7bbf5027095a1177c0da42c26aa72aba84064.1696969376.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::25)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|SA2PR10MB4442:EE_
X-MS-Office365-Filtering-Correlation-Id: 2baec4e6-a516-47c6-45a6-08dbda1b984a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yDvVnK24PlSNGFLlgqnRQZgIWs/emrnZLvzJhZFXw22bLHNvgiFhv0wYv4t9PMfLSowjc5Ob+EE+akESR85NKNmNvI5M52WhvP+bD53g7Lz85KmdjhsTPW6C8KdzSL673aeO003bU75NR7NHv0nUTOAAJagIs3X7y10u+7Jp137L4LNz/RfOISFhEXxFALJXppHiM3MoJLQElbYOufco9kTPoGnARk2aYs987/3Yv3GTXuJPfjHDAi2KsbjRfiJKVpWfmrdgY8bJWNEwfHpGZk1yIADKhQ2mP/DRke4G0mqD9APUzLRs1AV+Up+iKMauA0gijImsrBVEW4vL53Or73SD7SWSVhAUp6KMDc8011sAYW5Y/5d1bORtx+ptSdFDkF8gYciBdl/tGupfG0JrzRIpPXG17sopwCZ37t97bIs/XdIrZnITm88WrZjJQ4jLpQcpsTGsZuAB+pLyDIx2Ixc3vRkiJNSIzBsdSNkcaWq0nciaSlsTJC9RqZwXKuLhCqbP7ZT/yzgx7wVRkROaLRrm41bp+Sr9bX6PNi0h4uEjgGddYVbaDOrQINruvrOb/XmGXF8mdyBfvfq1L++ETNN3MiuwKoBKDz+3SleK4dhy+CmW14OYtA+dMv5GfctoTN3+ZtTO5/EH1ngy4HXkrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(366004)(346002)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(6666004)(31696002)(478600001)(86362001)(8676002)(5660300002)(38100700002)(6512007)(36756003)(53546011)(4326008)(2616005)(26005)(31686004)(44832011)(8936002)(41300700001)(66476007)(6506007)(316002)(6486002)(2906002)(4744005)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFVpRlhqWHR5bkJya1pjTE05a2tRK0FmNHNmSkY2UzBiYlQwc2hoTnhzRHdh?=
 =?utf-8?B?NkpkU0ZoSGRGWmNhZ1V0Vm4yQllPSG9XSnNMNDVwbWJuWGMyOUF6K1dkUkx3?=
 =?utf-8?B?K0dQZURGcTNpQ1Mya2pDdEl2L1FvbDdVUm1LRmJpRVhmU2JiOUpOYzRpN2hP?=
 =?utf-8?B?bFBBTjQ5eEUwU0ZxdUYxUDRXbXhRMEFKWWk3Z09MR2svZ3l6UXJhYnFGaUpw?=
 =?utf-8?B?a1Z3ZUF2YkFjeEs4cWtjNk9HejNwcDF6dWlLZktJNStXYXFrUS9tc0RZc1hz?=
 =?utf-8?B?c0U2OW9SYmFRNjQzQ0ErY1RpTnBnV1pSTHJ5NUNvUVJoQzdtM3pFYzZTdzdT?=
 =?utf-8?B?Y0M5NExMQnU4UmhSaTcyK3lVdHlCZjBQcWF5clZKSmJ1RlgyaHpoaWRnbFVn?=
 =?utf-8?B?RnAveFBKVCsyN2lIR0tQY2ttN09rZExWaWpNbDJHSU0zTmVHMFhGNXl0L2RU?=
 =?utf-8?B?MzF1ak9XdWZUT0dhMktWQ0FTbXlTMTRZMGdQVUJnTE11UEJtTFdMcVV4ajl6?=
 =?utf-8?B?RmRJTDdDUnRNN1hpQTdrSmJDZklGWHZ3R05heUYvMFlZd3RGWnUzV0w0T3dD?=
 =?utf-8?B?a2NBUDdmTlRhOUhsa2RROGtCYk9EamUyTWdCVEo0cFRKSkFROVdXa1ZWWjE0?=
 =?utf-8?B?NlRvbENXejhYbzVVelRYbzhFV3QvdEFFZDZsRXhSQ0tRakhHdy9ibzF2N09L?=
 =?utf-8?B?azRqUnB6dGprOSttd3I1K3lBOFJubU1DaExUUDJXVHg5UTl3OGtadVkxZTRC?=
 =?utf-8?B?emlmVEVhanhvNGVQVmpPdW5NSCtLdFBFTDZVcUMzQ25YZVIrQ2p1czB5SUlB?=
 =?utf-8?B?anNCUVdGY1lXNWhSUThMV3ZGMTIxQWRqSDdzWDRYS3VFN2lWNk1zdFVtVExi?=
 =?utf-8?B?UnQ3NWJHdjRNcXFXUVNaWnpEdmVMaUR2T0dWM0hKZEtOc29HU2FiTUgya2tE?=
 =?utf-8?B?SWJ6WFNQUmxiR0h5R01oVHhxUndyNGVEV1lQTXhiVjJlNWE2dUVJTU9LOFNr?=
 =?utf-8?B?d015Y1E2d1RvT3FsYXgvM0k1KzJ1Wk9QOWdzMitaT0VJUFU5Z0s1ZGxjS2pv?=
 =?utf-8?B?cGxiTUQ0WGY4NUYyQkZBLzQ4MWw1bGpoUy9lT2d3V2wxM1AyYlErMVBlWk9x?=
 =?utf-8?B?dTRVT3NFQzBaUitsTGhmYWdhT2dnTUJpQWdJbGdoV1pSTGE3TWlaTGJiT1h2?=
 =?utf-8?B?UmZQdG54Slc5ZWNjNGxXeTFFR3dlZy9HQnpaZWppUEJXKzFtYmN1QW9oWVlh?=
 =?utf-8?B?WVc3Mk5wcXlCL1hJUGE2UkVpK1pmWkZiclE5Q1c4eDRCV2E5Y0w4RkdQV01Y?=
 =?utf-8?B?OFNMQkNXb0pUL0FTMTdnelFCTEw4TFNURGF3dEtlV0xMRlZCV0hGZVAwYzhW?=
 =?utf-8?B?Z3VSVkFYZW5uc09vWU0raWppbGRnbkh5SXVUWHNEYkxYUlgxN2pEcm1COGM5?=
 =?utf-8?B?UTh2d2E1cFhoN2wzbngvU1JtSW5CWmowV3lrcldEVFcwR1ZTMHN4bFVEanpr?=
 =?utf-8?B?VkhGTjNnbjRTQ2FlQmZPVWxyRm9hdEVjSjlMYlUzSlZPTVhTWE1PWkg1VUpG?=
 =?utf-8?B?WHh4Y1VQTUdmeHF3UEw1WStwUXlFNUY3bWltb3B4SzE3YUZ1VTFZVzdMWFAv?=
 =?utf-8?B?dlI4U2RyQTNpbkcvc0dobld3T0o4cHpXd215Q2VBN3NDNXBqSWwvYmdHcGxw?=
 =?utf-8?B?aDc4UFIwZGFUSFJENXVGVytyMGVrQ1gvWi9JOE5uTGRzazdOd3JuYUdxVEVy?=
 =?utf-8?B?RlZack5DenI1dURhZTRPQW5QMmRRMXliNms1STAxQ2JnVDdJTVlPV1hvdDJ0?=
 =?utf-8?B?ZFhlY2lkcTNERDlhL0g0ZW41MDk3MXk4NlpiTkRsQUc5Nms2NVlQMWFyNFQr?=
 =?utf-8?B?SW9rcnFiejRtcVJoSUJmdDB4T0RPTS9QNDlpbU82N2s0Q2dBUnJxWlowRjgx?=
 =?utf-8?B?NWlicWpvRXlNNnY4Mm5hSUkvNWozLzMyQXFwUXBadEF1MUV4bkxxUC9vR1g3?=
 =?utf-8?B?Q2g1Tm9ISEwvUnF4RW5XbVdGdlhrSURydFB5czBwZmhmdFc2WFBobG1nVGJ4?=
 =?utf-8?B?eEg4OGU1djVDSFNqZUF3elJTTk90SmRtQzZJQmxaMHA3eWZ3VzViWThWVnVj?=
 =?utf-8?Q?nltDMH0DDkdc/EPFMt8iTO7Az?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HLySTeNFhN3Zj+RkPnL1DSMFDBCEkBy7R0B6+ouYi04Gdml155Fus6198SGuLkeDHcykKSWT78y4jCDYlqgPMn+6RIyzg4A82ic/AG6fu+fJAATWkxufl43yXymNE12HRDf640Jm7KJuiIbjZBTZInwU8Ol4f9GAaFwlfxJHo7my2any0UpBdDJarJoi93ZdGq8cbrPVpyoYJssrSHb1lBgxa//bZ8wxvBk3Zgt7ePnD6CW7gXb5qrMcmGPUm1epHTYo4fVfjxYGVjwhdgmyzFguA8oylGwaAjPEv69JgJdpjLX4qUrZ3FenZ4bsyM1KCJ9k/epvRSSDS62BASAOeDAIqm/1nP1xSy9qCb3goxxbCox1bRHPJc/GESOxzEbcIC0UNG8BPCJR8QN2kHYtK25x/tykM1rToRCBcs3eR182N/KefHJVgRVo4uHcZ2qcoqrAMDIGrcPWBcS0DKeKatkeMVMeOLK0oKxqhXKIOEJpx72HmHLf5CA28qz2mzccJZVcbfQ3CN3wAAUwXsZCvXopCTr+Zk44cG1XIeP6zveY6uNH2wefAyOvo+7j/hUKNsExtmeOMNdfaunRqGcb481vRyqSdK2AGKwmv6cuObH2Ydhy01uXz4N6K8g7sMlzp6QwAD8m9GeP2KNWNTyEQZwawEhZtWMgj3ZkF7gX8Myoj3/a0dAtIwgDUeGluWLfsyLg/0CSAktR4vblYEOxfw0ouIvSC2oPue7mR6VIr8gFKDrpHpO6lSr1STb/BuqZp/NCtTBrm78ZNcmBZfcDaqJHF88phWtmqpBJyZG+2gz3Ve+waIH0vvhZc8k2K8QJVSFh72gD0XHe36azJ1jFhg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2baec4e6-a516-47c6-45a6-08dbda1b984a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 14:13:46.0353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /NOCjpjmTZlHAdWVWW0G3p8+avb4HhoYchb8ApSthGvZI0j0oDCnjWp+z+Mml61UYJP5mNd4RGKPtWqnJmxTug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4442
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-31_01,2023-10-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2310310112
X-Proofpoint-GUID: xCBU9QQEPa-k-KvyqbqiKt7xPa_sLwcZ
X-Proofpoint-ORIG-GUID: xCBU9QQEPa-k-KvyqbqiKt7xPa_sLwcZ
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
> btrfs will have different inode and data nonces, so we need to be
> specific about which nonce each use needs. For now, there is no
> difference in the two functions.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
Looks good.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

And, as Eric pointed out, the naming can be more intuitive. Keywords 
such as 'inode' and 'extent' will make them more intuitive, rather than 
'file' and 'data,' IMO.

Thanks, Anand

