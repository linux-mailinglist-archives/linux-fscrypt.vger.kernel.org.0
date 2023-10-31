Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080907DCF0C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Oct 2023 15:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbjJaOSv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Oct 2023 10:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbjJaOSu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Oct 2023 10:18:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EF8B7;
        Tue, 31 Oct 2023 07:18:48 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39VCnrsl004508;
        Tue, 31 Oct 2023 14:18:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=O862MKzihBcJAlRGpiTcPEVntwiWQEngJV9mSC5UHPY=;
 b=lpIYyFKlj2lscyxZv5AeWFkuJxKgRzq6P/RU3ezyHz8hEL4T7XsYDfGMgsCqiS6/w25B
 4UAaTwZ3tyZ7N4mWtEdzlTFoH9o9pYENB35R7Fs3nn+A2r5YOvYoNuzE0PLmzhRkb7IF
 dyRnm7WvUptX+4oiNSgBAv61uSewRYF1NkauiOjCswpiN/cdmk7EUVjmMczobX7ScrIJ
 JG+p/ByPDsv7qMAD6ekST0EyETrI8teqmjzhFMo+Ynas7/jAtRP5+AYjofR7LvSoBM6r
 VnAylIahyeTjyI4RcCV9E+YGQC1RMH/wTYfjnSwRzT1cBH8igm5JPxcew2ZJBAEC9SSG Kw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0t6b53a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:18:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39VD88eC022472;
        Tue, 31 Oct 2023 14:18:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rr5r0ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:18:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ectQBLi9ibRhX0s1ocV+wFt2TmPv6YrHPVuCAjLfSTxZFRvoFBAWrmsHMFr6vKs3/ZBkwXxBZDJPZzRowOkCM+IvHmhAU0Z0jaYk0j9g/iepWCBhnFdUY09vLgNhbZKGuJtZqMWuNiwSxpdLBTvnoWr75t975lsGsrkDvFPjf65iaGsTN3KuWcOOmgtIcCMkbnuRhkyAwypkcrcSBl2ihCfepjT4Xy77DSM8XPeIcHRrSoKwqgF87DXbvqEw3Dz6LHqRpznyrNIf5ILFot8pD/Kxh7Nx0VxNg3onWJNNHBZi2z2V3Tl0bGWYV+AS08bjBFIWx1Fhk1eUTsiG38rEiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O862MKzihBcJAlRGpiTcPEVntwiWQEngJV9mSC5UHPY=;
 b=doXsCy2KImFeYY1qW14zPFRnhx5BWp4l2xtvhM1rx1P9FdoNsaACtPa5ZeIfg6ynIqAPTBa9W2smcA5opAC0nH4WKqRJHLFegxCuJC2ZXmDGJexEIOufbdQHvStCs/6c88uIwVIwhmN5zNlmA+fW1sMmHFt1DFtugmfBQCWyHPXyNWiR5ablFc/VjJYgOTxNnCEnK6g7asP9s0PNqZ05QYzV6OcBRNIvtH3BpMpGVnQ23ZCwfjzAatr/Bfd4fTjt7/NDX3LbPHCHbg/GUqcOKFBYG/hxeYvpZFJ0amhGknuCsVv/cUhEpru/OxJK+ChRve3hhjYQNh8qx54yU2esNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O862MKzihBcJAlRGpiTcPEVntwiWQEngJV9mSC5UHPY=;
 b=b0j0+fJF76o+rNUPxH4ImtAUEtte6OdqNiffbVq0E9MdwzOvc1uMws7DyilscknVCYArimNJWztOA5+KSnkdwLHtG0V+hUqZXDMMdScXxbIwOPJtdVeNpHetqikP2+zO0IThVb5JNP4g0uOKyR0/Pss61+zH+E0djmUKkOEUUHk=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MW4PR10MB6605.namprd10.prod.outlook.com (2603:10b6:303:229::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29; Tue, 31 Oct
 2023 14:18:42 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb%4]) with mapi id 15.20.6933.029; Tue, 31 Oct 2023
 14:18:42 +0000
Message-ID: <278a09cd-66f1-9184-aa7a-bc18e80b67a8@oracle.com>
Date:   Tue, 31 Oct 2023 22:18:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 05/12] common/verity: explicitly don't allow btrfs
 encryption
Content-Language: en-US
To:     Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <cover.1696969376.git.josef@toxicpanda.com>
 <24a79bf71c105ebcff42868cdc7938022ca145d1.1696969376.git.josef@toxicpanda.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <24a79bf71c105ebcff42868cdc7938022ca145d1.1696969376.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0135.apcprd02.prod.outlook.com
 (2603:1096:4:188::23) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|MW4PR10MB6605:EE_
X-MS-Office365-Filtering-Correlation-Id: 9395b47d-2263-4709-d6ae-08dbda1c48ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9mc1/NIv4ODMsGFJpNHgGpqQsNdOFwL6ViD19s6q7kfrDn8e7zu9EgznKyf1EMUIcZ7v+Lyf2EfeVgxjdhqU7kmhqC5Yz8x9CJtLGy9MC3Vx37sc4/EvP07IFL/p/nJiO2il+XaaazJsM5A/kvm16CyUy53IFYROWQYvTLCQyU8lG2ZYVUWzDidKloGe8CVehVpMtgJgnU9PXVUjn5AHyY8GvsmOIQeenFW8xt+aqj7BTN81+gNrHCfi7CJ1uEJj/QTP7qDmTCHa/Otsl/YZLU+DMGhnE7gfUUqH75cxb40AdJ3Ms8UEd4Vwp+/n1CrHK2iMy2T3Q75DsHDZBD0NTM8GOhWd+SfbOIzlDEH+wFmkFrDWQ53DJ6xeP6hgTBNLEMBGkW650EjPYvIG7Ri7hZJBjIhfDJa4MJGXEHQeKeSD1UojTxUyO1qnOCov+0LoaMbW8oFbk9lnWlyY0Gu/4MiF/ZWW79xrqyc//8YfLkXC+a0LEiu16m4Bh84FEQ76byLN6zefSx9qDA3VQD75ysmzc5pT58w0d9khHob1Uwhq37jI7c81yOhZEpM9Wk2Vseh5iNV/PmCxrpqpUHSnwco/JY5K7YIThw8oUUwEhygtITKkZf5GFcmnhEj2X3MfutlPgVj3xSLP3hFHzM8TEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(346002)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(2616005)(26005)(6506007)(53546011)(6512007)(38100700002)(36756003)(31696002)(86362001)(83380400001)(66476007)(316002)(41300700001)(66946007)(5660300002)(66556008)(4744005)(8676002)(4326008)(8936002)(44832011)(31686004)(6666004)(478600001)(6486002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0VlaUFueTVQZXJLMDQxd1RLeXFnN3pzZkpUYi9XR01CWCtFcjh0c2k1UU5W?=
 =?utf-8?B?ZUFCVnpYOUNUZTd0YXFlTG41WXE4Uk9IUGNhb1VxYjFwSGFOdzlTM3cvUjRQ?=
 =?utf-8?B?YnUra0FTKy9tMjlGQThvTGJrZnk4WHd3NGlKRmRjZXA2TWduRCs5blIrZVow?=
 =?utf-8?B?TGw0WXVUYVR3THJqa3prdVdsSzEzMEFiVFNWZkc3ZzJHYWhlMkVodE5JbTh1?=
 =?utf-8?B?ZldSTGhhclg1SmlVNjZYNVdWSHpPdnJYNU5oSlVCeHljaWZueS91WGxRaW54?=
 =?utf-8?B?cGVaK2R1Q1o2U1ZHWUNpc3A2SXhlUFlpcEh3dTlDdWc0NWdWUEc3TVZPbFVW?=
 =?utf-8?B?TzA5ZXR0ZnM5bFlFa1VXQ0owaFFIdUc0MHBHY2FWY3hNbXl4cENlcW93dUdB?=
 =?utf-8?B?Z0VhczF4ak8zaWhqZXhudDFWSzlyUWhQdXpHWjBTL0tWS1dJK1F0S2JzNTZ5?=
 =?utf-8?B?dmdESjNMTEkyWXJCbnYxcUJwOTZTcmxEc0Y3S2dmaEo0eDJCT2ZXZXY0VFJ1?=
 =?utf-8?B?Tnp3b3FwNXZXZU9tbm9ndS9zVzFoZzZzNGN2NmQ2QW5UZU1zbC9RMnNtbnBW?=
 =?utf-8?B?Q0phakxLbjY2aURaNGtHRVFjdWtoMjRSdURIc3psRm9UTkMxd3Q1R3BUMGpR?=
 =?utf-8?B?RWJaZGVMY0F2L0M3NlJqVnk0YmNrQXlKbUFlVklDdUNTbk04dERTemlXaDVU?=
 =?utf-8?B?OG40QTE5R3FBY2RBUFg5TUdlS2UwSTZqV1pMUWhGTnBBaHBjQXlLSkF3d3ln?=
 =?utf-8?B?OG5LdnZsQUgxdTJsbUVBcXo3MHRQRUsycnJ2ZENXMjRsSldLVmRxUUh2ejk0?=
 =?utf-8?B?R1NuU1Z0N1dSUlRTYkt1UnNadXVNYXR5dUJrKzlQQm56RmpJZjFPYW1ISFpk?=
 =?utf-8?B?dkdRN0gxTmZJRnFqL1VHQzV4UklpR09KUzBTcC96cTEwQ1dQdFNiZTZTaFB0?=
 =?utf-8?B?L25BWFpVNG5jRzNyYUF3UUQ3dXdnSFZzOHpwZDQ2STBscVJXQWFCMmtFVWF4?=
 =?utf-8?B?ZWNPRWxJSUpFVGNWRmNrUGtESFlHTC8yUTd0TDZlVDZLR2wwdWh6N3VFTmdB?=
 =?utf-8?B?S09WZDBaN3Q3UlNDMVFsbWJySFR6dnlsVktxenp5T0V5NG9Cb2Q5dVBTclpj?=
 =?utf-8?B?VnoraDU1bmF2akFNZm5oVkhYOEhrY3E3S0k3YUJudnlLT2JjZnlLU3J2Y3Jt?=
 =?utf-8?B?NzVLYk8wUEJhK3ZnY2g0anRyQnNRNFoyUDJEZXlFY3d5NEpKc1NLeHczYUVw?=
 =?utf-8?B?anZUNWMyRC9LSjZlaDdxaUprOUk3ZG5MVDgrRDRqVWtEOWlyMmtkbXZZK2t2?=
 =?utf-8?B?OUpqRTErZVh6TjhvQUU3eFkvY2hzUU03QTJ1WEVuTmtjQ2RCQUZUdlpRa205?=
 =?utf-8?B?UFUxVnFmdWNLU0ZGdSt6S0lkTlZWTXJXQ2FNR0puOTk0Uk43cEtIbTZ0UG5a?=
 =?utf-8?B?U25WM011NXZiVTJOL2toOUVQZjRvMlAwSEhyTEhzSnQyOExrSVVJV2VNVkNk?=
 =?utf-8?B?Q2Fhc010N0YwcnZIemRNc0ZJQnNnVVIvZlR6OW5iY2tHR1pUMEhKa0tUSmRo?=
 =?utf-8?B?R0pHWFIxRzlpNEorUlZia3F1ZklQdlk4Y1VvNFVpV1V6dU53aE5uRHNucDJk?=
 =?utf-8?B?TnljM1ZTSkFBakhCMWppM1V2QkpvMTl3eU1XZ3lzcWNEcDNYbUk2c25WUEhN?=
 =?utf-8?B?bXVUNkFIcnFuOHNtWWhuWWY3Z3dKQmY2TC9FTk9hcEk0VzF3TFk3SVJKTnNZ?=
 =?utf-8?B?dHhzRzNEblV2cExwYzQ2NGtjRXVuaDkweC83NDZINXpxRmcxSysrSmlxNFls?=
 =?utf-8?B?ZWhDMXAzKzVjaXRoTmI5cHdDZXQ4WTQzVU54RWRBZ3pTVjdzZ3ZSTFducXpH?=
 =?utf-8?B?WnlCNWszaXpNeGNNUnBtQUVIb2Jhb3pOcG85VjhkczY2R1ZpMjh0aEtXWWNB?=
 =?utf-8?B?NzE2dUl5NU1xdjBVZ0h6Y3BPVjRwRGc3QU12eVRqNDdwT202U2JvL1ZuMnNu?=
 =?utf-8?B?K3JDOU1kbUI2b3hUKzh5TFc1VWsxUVNPQ0tDdkRmOE5VYWgyWU1oNEZKUFl4?=
 =?utf-8?B?YUJMZzZQTTFxS1pOZXZjSlZIMXJPM1JjMExicXNnZ2czR3U4SFdyQ0lxZGIx?=
 =?utf-8?B?UnVHVk5kYUg5MlIrQVBJKzU5RkxWdnNZWFVkK28vTUJ0NXQyb1RlZmlPcGhD?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zt7Xe1svejpnV1ZzSxwF747DIIVXr8HFjd5/zhE4EvfQ+HTHJ+P/5D53TV83VyAhnxsKY+00JMK2QY5SONhQijHuS70nthlDEQplCGXIRTsgb5AK0L89fL3tgz/4AxQHKuYChn53aBSVUbOP4Z9I2cYFewvLQSd2dzddEfCfSVZWmpUSH+3cajBNElW9Oes6E5FfPX2lthRCnrBG66xgbXghfjjBXII6c3JSbbF/yaSZPAqoz1FpQ3f8Rmn2p/A9FyD6NcF99jYGeoBb92X+QEAWF+tHL+LsP3Sbayzx6cpLnuxJYwzdehPMcfuXQ8f+ncNkXpyaRLZRBzxiWdPNGWFbpVoXyoi6E9Xi10CQnQQtdCpkd60Shbdc5MvACYEN0q32njukYRXmJpNTEs1/R5DlclMRWMI4GLwgtRXfN6WmZok+4W5VaWz0GI/1uohJmCFRGHhQ7GNjK1y41ddFbtHeZeW+Rda9Pnbq7MIZ9CD8ObTebss7kxSdJm9vBD0SnlRSIyn2fK3x3kflicjcDaSp8vQ6gkR0Gmsqw9L64JLAWMao6blDb7FxegynRYLm4o3rcOqZKkC8ijWLmjbaZhOLnVrW4uj9uDtdiOAhKxI0vF5aJa+nClyMUkK27WYKBvxrxmo7iiqMqGjyw7Vv1oEkNUeFRUBwaRYSAA2ZLGOG4G6RG3eXJ6df6dmI7uhHPTW3xAYLTGJemk2dKihQ/v3BzuXYZmyYur1BaMaznN/A8GhmzgkUoyGX+5+7t2rHjIKoxp37T13STvlG3qi9NiEjlOBXV/gnigFvVWWlOAV+rUFyD9mxEIoPp1rnSWoHODwzBEFvZTcoQcGW/RHEIw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9395b47d-2263-4709-d6ae-08dbda1c48ec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 14:18:42.4411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxvXg3uqfP4p2zkZa52u5tbzJKuNwmEJ5oM9+cIwghRkqqfCqfeWdh3zJwV1MdB8+NED6D0BmCs30arhZH0Q5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-31_01,2023-10-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310310113
X-Proofpoint-GUID: eJmBv5RcuMcuEX3BlUF_Wx-XAw2rHP8e
X-Proofpoint-ORIG-GUID: eJmBv5RcuMcuEX3BlUF_Wx-XAw2rHP8e
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
> Currently btrfs encryption doesn't support verity, but it is planned to
> one day. To be explicit about the lack of support, add a custom error
> message to the combination.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>


Looks Good.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand


