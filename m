Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9987DCF05
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Oct 2023 15:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbjJaOPs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Oct 2023 10:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235656AbjJaOPl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Oct 2023 10:15:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9300E113;
        Tue, 31 Oct 2023 07:15:38 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39VCnfTW032647;
        Tue, 31 Oct 2023 14:15:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=F0hhEulDbGqQFa9kPD8ikmGivI5mtotEHUNAl6M2rDg=;
 b=Ru2BADeMdhnsDpGaxxa6SGcQ2J7ppXPoGhJFXxGotdjkEWXdhOGzZCjTelsgiNNZ/Jvr
 57EsWH+9Tb+foMVDQCOOAUF5hkGINBD0T1+qRKOEdNC+O6vdeTtw4k8J4nGehDK81yt6
 EMPT+R/mHPyJMzWdKSK+XeL2zEVOHRRY+u/pP22GUnNVDAXMNeR5psDRSvl0ribuDecw
 tGZjewzy3SfySUQMeGLDFj2lL/k7cNtCRGNX4hhZxFaPu5M6LJTAHixcmbPVfC0+GFyZ
 oPvHdPatL3ViSqVXcb/rfycUqvBfmVhIOVWTVZuoxE4SMNz4KZqli/2uZ2nofgtaSlg5 nA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0rqdw755-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:15:36 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39VDQIix020069;
        Tue, 31 Oct 2023 14:15:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rr5shfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:15:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbTnvt2mv5tONLs6todkHfVTWjiA8rcuYJMav0IArQ0KOsiRt7AQdsqpYBloeziN+tAvYhTgjfUWm7MK8yW2xmm3rVp/yFEu+qmVZElh7FgKukm4YwCEdfAWVLHj6Iz11sNpmbiqyZDr5vJloGBePLQsOi09dB+sid3JwZbMfCMnN1upmfUFamJo6e6dj7pg5leU9GeYHX65Sy6zuVlIjdTFtL8cLGyws/NEGcAHsltzRCsLkhTqxHtASmAJRX0JMKIzqbfkmbJGqdw3YjrCnvC2i2pUwHcYPyPeXB7dnt9VLwW9A1HEsjk0zHnXD266yjyc86nrf6uRF7J6D1+aqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0hhEulDbGqQFa9kPD8ikmGivI5mtotEHUNAl6M2rDg=;
 b=Iq7jJCAsJ6M63FVnLed7PWhYCkjJUQ50a/CrWUuvipyp7lg3hRVbLBJSajonb55+NLv981nrk04f3LVi+oOjfclKH9MsQ3ooBJaTsjzH4XqqlWFMGgfxfRwKd2uHkvG8NtIIu9OUHEyDR4cx/AIkVAD8u6PE+e2o/dBjck6oEYePFptGQe4uHaAlROskZOudV+PgpEATWtvfySDsDK6PMHOm2XPms+cIZ4sG+2AN72aF1AhBseBxosJLbsteC3+Z6CuaXhT/nuq1RyACUUAZvjYk58veBeFKMHABXP40jxJVV3/ku0HpvzmszJcVo4P116TgfiZ8g7EKxJSOdGVaoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0hhEulDbGqQFa9kPD8ikmGivI5mtotEHUNAl6M2rDg=;
 b=moB1e/mw84dtKJNugzkWfmbW1JnSanEM07CIK36KDNnCYuO2FXPyZB56wK1iacGRFsCMOJMUJmDEvJaWwbTwE2QlClKNmVX1zFfNzX58j/q6Y1sWkSUWx0RRa6aQP/QgLLTG5lwkVdHn0YknSBd8zLCbxY5K4zgvNMunrIcS/50=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by SA2PR10MB4442.namprd10.prod.outlook.com (2603:10b6:806:11a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.23; Tue, 31 Oct
 2023 14:15:33 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb%4]) with mapi id 15.20.6933.029; Tue, 31 Oct 2023
 14:15:33 +0000
Message-ID: <1fc56fd3-bbc4-11d9-8ca5-2d241be350df@oracle.com>
Date:   Tue, 31 Oct 2023 22:15:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 02/12] common/encrypt: add btrfs to get_encryption_*nonce
Content-Language: en-US
To:     Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <cover.1696969376.git.josef@toxicpanda.com>
 <f751b02bf76ffb24a126016c089dbf04d2e80823.1696969376.git.josef@toxicpanda.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <f751b02bf76ffb24a126016c089dbf04d2e80823.1696969376.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::36)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|SA2PR10MB4442:EE_
X-MS-Office365-Filtering-Correlation-Id: 27bb1310-f8bc-455b-2427-08dbda1bd7fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PxfQOQzWP2Angy2lXpdTe+AhNhsa4GZlDtOYnlH9Tf3o9+NcK+Lbs0U3JTBBShhlwbAvHkSAjIge8Rt+UEcfnnq4HaP9TsimpO1Uo1XQIxE190pj2go17hxwO4/fjaITmGxy4tF6uyLRAoS1yYAQ/tU9e60o/O23N43BcKSpe2h/7AqTqBaL77qgVw7IoTYPkEsK7P0xLwhh3sc6um8Vp4QrjsuZvdB/46bItrfRKzBMcd2asSJ0kfDGmudw40Pevg022IuTraltkVBB9WBmBxTjnX06oIL0rgO3rECsZhkTbwNAhf+009a6Bk2SaH8EZP06tDcV+TZbC2WX4MthQ9d3f22sXLfafIhzAOTBoj4WI0CUfQ0wHkYEv8uOVvD3mahNisKo8T3ltvcYZp19zywySYcGad+SX851alhoEWIMev3bR2mZUOBEOePkR0eAWJ4WEUnPoeHw2xX8jj8pdtsaV7cNQ33EFYVWzjpEraJTZudxOdL5JYbqRhYZEBEo8GFMwIAsrK76EeTdjx8sgpc7eL/5CZzaO+sPMPSwL4ugRq5r+F4zmrknDHRNanhr449h6jd1Nq2CE2LMKv2tSGZ9p77IX4kPDA6n6qH23FbKCSmfUXXBSyZh4+ezBK3zT3Ozo7KVCFS/G7sCM0k23A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(366004)(346002)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(6666004)(31696002)(478600001)(86362001)(8676002)(5660300002)(38100700002)(6512007)(36756003)(53546011)(4326008)(2616005)(26005)(31686004)(44832011)(8936002)(41300700001)(66476007)(6506007)(316002)(6486002)(2906002)(4744005)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjNPbk1PU2M5ZytENEoxRGVKeGJoU3hIZ3QrSDAybUhQVzhwNWpmZ0dFU0ZW?=
 =?utf-8?B?YkF6WXRsRnN2cmxKaERoVkNIaUxzckJGTXdDOXVWajJuRUd4VEVaNFY1Vkdm?=
 =?utf-8?B?K2F0czEvRnlyQUxxYU5lWm55VEpxbHBpWkpiTzRRNXZNRStFR0xSTjFiWHZG?=
 =?utf-8?B?LzhGS1JteFBZMVhMblBFWTJqMDhlRWlrWEc1VUZ5MjJVL21jak5qbG93U2Mx?=
 =?utf-8?B?SHRHT3JyeE54SzMrc2hoUi9NUkJZUkxLbWo0cVRKTm9oM0k3MG9kcXVlekcv?=
 =?utf-8?B?YW92Wm9aOFFvaHJtOFQ4eVBtWlhlUkZRUkpZWkVkc2JWSTlZempFMXRtbVl6?=
 =?utf-8?B?bEpsN0QrdFNkVHRPV2VtSW5TeVJvbERRV2t4VTk3Rkl4L0hwc2VaZENGWVM5?=
 =?utf-8?B?NVRWWHh4S05XSjNZamdNRmZXVVFYdDhyeVhETzRXMnU4ZkR3dHRSMWxpUE9j?=
 =?utf-8?B?UUsvTkVoWFBxendkNndLVVo5RUVIN2ZCVjVDUklwYlBtNDJscVJyY2ZrMnpv?=
 =?utf-8?B?TGhjendZbjNlVnpOamVVdkRoaVJkTjNLOHhYTHRlNkRKZUJwM1ZwbHptU2J1?=
 =?utf-8?B?MFlsTFhnRzk0WTcxZzAydURqcmJFdHk0ZkFQRUhFWjlFOUZhVDIxZUh1QUpH?=
 =?utf-8?B?cy9VMGF0MnNiT1VSNzlmb1lMUCtHODE1czBBRFhnUVZBSlI5dGtUMllKTC9u?=
 =?utf-8?B?UXhBdm0xZjQ1K3l4M3RrMTVlYWRzb1o5ZWhWUG02ZjBrSHFOZXI3VDFNN2lV?=
 =?utf-8?B?S0M3WkhNTG41M3RuNmlNNlhzSEwvRllnN01URkUwM2l6N2dFOElNNGZOd01m?=
 =?utf-8?B?T1RhVkZTemV5bTFPeWxwb3gzSEZSSmRrTngxbCtwZDRBN21RekE3ZTkzR3pE?=
 =?utf-8?B?S2dnbjRYMGlUbk81TGNlSUk0MXpURG9ObEJ1VDdzdjBrZXdKZ09CcWNUbUFa?=
 =?utf-8?B?L0dyYUsrTUlNUnhmbXZhR0JZVVBqMzgwbEZuNkE5T1BXWDFPMi9INC9VZzFW?=
 =?utf-8?B?OTk5dmQ3MEFSbGtJRllXb2lZRW4wT0c2aUhMZmR3b1NkbUg4Rlg4WG5ZRFBX?=
 =?utf-8?B?RnhrQkdvTTE5NFZ2Y0FEdmdlMFRYbjNZQkQ5amtLU09tVzlyWXp2N3ZmU0Q4?=
 =?utf-8?B?TzBOSDdleUVISGIwRFcvN3lKY3hZbG90TTRYcHpzMWEvV3V6RTRlUGlsMjlQ?=
 =?utf-8?B?V2dJcHBPNWl3TVRsU0lxWUk2S0Yya0gvL01TTlBvSStoN1poV2lvRXVYZ2FK?=
 =?utf-8?B?MWVHb1hSZTEzNngvdjJHcnpkL3BCNWhDbmd2RmtkVGZSV09FcytLOGhJYUZD?=
 =?utf-8?B?U1d4Y2lGcUZCWWNlTnN6MTMrcUJUd2ZJSWFnNlJKUFJOdmNnTmowaWdVZlc3?=
 =?utf-8?B?NHBNUnI1cnJkbnUvYzRwVVdUNVNkcmdkRnE4dE1NUFc3WVJpb1ZGWFFKeHR5?=
 =?utf-8?B?UEJ4dVhDbHdMcGhVdTNVVXNKbmZFeGZCeHR6dUFac0NTY3QrazBjNVBWN2Na?=
 =?utf-8?B?RExHUTA2REZPdGlJU09ybWg4eHhmTTNkNVVWV2xJM1BtVUdNU1hUZTRTZExX?=
 =?utf-8?B?M3ZjSVYzekJhY28ybHloMG1OUk5FZ1RQUHFhVHBlQ0t4NVVFRklrbmppbzNv?=
 =?utf-8?B?aStVckl6bHJDYTVJbHQxajBmTHNxWFhGY3BLV2xyRGpSYU9penFuWjZNd3E3?=
 =?utf-8?B?Z1NlMmlhVm1iQVVNcFdYNTRRcjhHM3RyQ1RkOHBTSHBvc2Jpa3VyVXNVdGRV?=
 =?utf-8?B?SHRtU2FNL3g1ZnJBSmZ2V09KMUZwRjQxbHNaWVNoRW5JbFJ2VWtRVExZMWNL?=
 =?utf-8?B?UG1XZTBPNUZOZUlxK2I1cVV4cEtHL3RYVkp1aUg3b3FUOElmTDh5WjB1ZHdl?=
 =?utf-8?B?clorREhyYStrWnlGYzFPVzhEOTRoUzllWmlkNlAxRUtpY1l1S3kxdnduM09P?=
 =?utf-8?B?L1BvS0VZc21uYVR4Z1NCekJJSEgzL0lDcEl4Mmt5TGhDSmdocEdzRStZMnlu?=
 =?utf-8?B?MmZ3V0xwR3MwVDl1Z0JxcjdHK0hwVkt4VFI4Mk5HKzhuUXVvSFEzaHM4VXF2?=
 =?utf-8?B?ZlFqV2JNL29aTHdsSm4yT2xBeVdWK1NZUzVaaXVuL1FHQlFkaUNyQ2hXWFEw?=
 =?utf-8?Q?97ZPIcSoxIBP3ojSk/rXzZdeB?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bducLFeNIzd++FuozLN6Pdof5JCr51lYqHGHfzAp4jQj6P4bSummgIoPHR9D3Wb6eDh81/9/MZlRDAu26jzCQbKpr9zJIxaehmXQwsuEwqtQvMEzfJM8s7sRC6wr3J2tIylo+6oRGe3F7i1r4dgzsMy4pfZi3eHVseGimkUQDrbmLcSzkxQUXcdTyxhBF4JsCEzBpxe7g/sDWfdDxHAFHgBU8UyDsU+HlzD9ts7MQfgdgJkViPzp6dGt7HhHuzKBPvhJw+BknFjPzVmPqCbqOcxRfX19AqzGmFPGXApid2RmMkTHceusHvGLFA0codrfPXJnydY/M7nBKvCghXxOkZVu23nRu/TZMoGbRJ/JUnJ663m3aunp4ByLgMIRCXltgpIZ30zUXHXyckgb6HgZAHI/bnrLYA9fuGUjN/umzvEK0Z3iWGDpYbGNn26+nQwP9ELzKOf6V2VQRRWxpWVvKlqSrVtxMX6Jz5xTLhb9wysR2qyoD3AZWdJaiVrLmxaa5t11wySusrxvqT0VAp2tl3pldhyXcJNviDyXbucGROhcFIVHz7Htse0iQfduXhGzTSgo0/eTdd+fBOo+jgOryy6BsBIERirOUkEBBaw3Ij+knVT0jK4WEFmTIUJnQTkRtIe5L47fe+56oEdL0qPSXNE2R4oQN29jBtIVTn9KVHsKVQypqaoaLz33bE7hjC6fFL47libKvx7r5ueXw5I3X7MGFsj5MnQl69rzbf11UD7PFqiLiUbrZVy6H2pSbO+nfd+Vio7VFSNBtiv36pCpXMFrbEccH3PGFXYjAgLePi5rh/dnBp/3wm8FknKZ2PCsmgHZw4BeJQkBU08/hEZq4A==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27bb1310-f8bc-455b-2427-08dbda1bd7fe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 14:15:32.9144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uN9Ne7PgVdLMtNNQ5KW8LczDsANJslD+B4QLSFq3GRD7uNad64asrxkXiSwRFx9wYnp7fomdJ8RQb3wXO4oBBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4442
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-31_01,2023-10-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2310310112
X-Proofpoint-ORIG-GUID: aB_Q-4foaTOgRhNTszHenTL0-74yjqp2
X-Proofpoint-GUID: aB_Q-4foaTOgRhNTszHenTL0-74yjqp2
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
> Add the modes of getting the encryption nonces, either inode or extent,
> to the various get_encryption_nonce functions. For now, no encrypt test
> makes a file with more than one extent, so we can just grab the first
> extent's nonce for the data nonce; when we write a bigger file test,
> we'll need to change that.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand
