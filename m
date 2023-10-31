Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8AF57DCF77
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Oct 2023 15:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbjJaOkz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Oct 2023 10:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjJaOkx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Oct 2023 10:40:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FFDDB;
        Tue, 31 Oct 2023 07:40:49 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39VCnpSg000626;
        Tue, 31 Oct 2023 14:40:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=hEIyd76LkvoaJTFFsyT4F6STuAHPpPJFRZQapDn1qNY=;
 b=IV4htCSP9DQ1CnRNSc4P6cAeELkdoxuAf3Eh8b7z4Ou0gBCBc4wXWlcF1CcUUEbHS1sJ
 C2d/NOXeKhTff0fAPBotaul3SeylZ76iBijjp83SjsouMgZcTKqWqhklIMY3OVkBmA4Z
 eFJgnaiHPVFMTM4XBYRA1E9/Synx4+vTVtUYs/s3+uJV3sMVbbVdpy0P270HjL0TY13U
 Jc4CzwjoTdtQy16vZXAioEQZ759YNuwR2oENiJbxchj19Xh+OExgbr1fyaAV6WCdWKM2
 jrBSNN01C9sFpuwLTnTGwQJ8e8Eaf87qC0f+oCTwn58LHdSNWpS/s+Vj7eKJxdRq6apT hA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0swtn6t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:40:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39VEbLqj020271;
        Tue, 31 Oct 2023 14:40:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rrc074n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Oct 2023 14:40:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HL2GqTVkmvC/XMRsMbAwtsAUrgiQIatwjqE4GevGAf18Zk33q6650qsSDvdwoIFCgvc91YDAxipCDdz3olVFHwOE6yvPEZNqUGOMCP1Jhc6hfB00dKgDWl+Q80DOD7m7k5XszA5TtPvFSjWShL48fkObEdx0SPNwjlYyOaxbRehdYvv2aZTUBywX8zuy0Mxv/ET95tP2L2b15mWv849W/yvzgTTvqGZwZh0zZOvQSjoS+aCDS5ytY3mlNBjkwnS9aXucsBBR4fCSYhfGjuQHhw2vlSgL4xwMjZgDzpdh+Rgo+YRMHGmYfHoTvcVUnZxh5D6UtRCllfHiJGj5bpKuMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEIyd76LkvoaJTFFsyT4F6STuAHPpPJFRZQapDn1qNY=;
 b=bhAth+WxqcbFg41e1Bpn0hmC6I6d7GcZVo0IpAUfW9qYbxHXUk2K40sYBCfIbjQkv18Dm+3MOr7z0UVk1NgH3cH3s9KTSKG/zEtO9oR05K2qju/7/afXRjGyUqDEnoDaMQltBGMmu26kCpq/RGSeRdGM51N/Duoxc58rPPQzEdxzSlVy5r1/io9tYPheVLrQpWHzGtGE9oajBPbQLxviPYvTflH8SDDbY7ANvbLJrOrmEQvC+N48G6aIm3SvukQgczCFPrUTc46JXUyAhlEjs0AQgyiNvcN9DQQgO8X+fk1rMD5w+Ssw7kEFu00daon2chiC/JFi8Nb7UyZqQ8sVqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEIyd76LkvoaJTFFsyT4F6STuAHPpPJFRZQapDn1qNY=;
 b=UqCB3jSfocN9nDXddUfLeivhZpWxbPuK7J/R2RgYEe1mOk0g6+HRqw1dZDJ1B4VZthzShlhkXir9mVAdIBsndxcls3Xexa9YIEEVTadU84d5Qgqq8ZLu84H7Kso475IKuPfskoK3RntZ/5QLuq4HZuo+G5KK/nbiaED3xzo2Vwc=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM4PR10MB6183.namprd10.prod.outlook.com (2603:10b6:8:8b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Tue, 31 Oct
 2023 14:40:45 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb%4]) with mapi id 15.20.6933.029; Tue, 31 Oct 2023
 14:40:45 +0000
Message-ID: <6f36c434-01be-30e4-3e01-4fd6b19a66d9@oracle.com>
Date:   Tue, 31 Oct 2023 22:40:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 07/12] btrfs: test snapshotting encrypted subvol
Content-Language: en-US
To:     Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <cover.1696969376.git.josef@toxicpanda.com>
 <9a17afb133849c2321bb98c07c48cff2aaf1d87a.1696969376.git.josef@toxicpanda.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <9a17afb133849c2321bb98c07c48cff2aaf1d87a.1696969376.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0016.apcprd06.prod.outlook.com
 (2603:1096:4:186::22) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|DM4PR10MB6183:EE_
X-MS-Office365-Filtering-Correlation-Id: c2274c75-4dbd-4aed-c4ad-08dbda1f5d3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+WOD+cyK3MGbqU6+J0T9Uuzs/+Poi14RVHHlcZr13Fv4kAZw5RjhKcOFkuGSi8QG31NUiM+eM7dghe4EF9EGeuTRdE0Os8AytuPwdsnVEr/8EsDN58w7ZyHUHt+nxuQOlAKLPDhGfWY48TKHgGmwkP9ihHH7lX9vaXD0TXM03IAs9jjvVnvrtlkVGnmDTLy9eIkAPiEZLhah8TSEjcdKaTYmHWi959Te1CO6v4cjlwDZVgbqUTZn+iBm+0xeX5KYrK0vxrWG3bJmloZv5m42KSy0Ig8T3qgNy2UpYiSoOGe1SQW+gh9b0HvVKWR6JzB2rNtdKovJm4s/Od1vJKBUfetrl1k/U68ajAbKjd6Gy2ptNkSwDNXaV9wZjfrmFFn5vBJb5rHo5Qg/FPbNHsboXSMNO98Rqku4DhpYaNeYED83Z7MCBMNA0czAHRteH0KAYUbnbtUdh9xJCcAsV6E0DlgR7pmHRrB6zddtWTek4shEK929K8y5/I+u3AeVSS7F6XyOHuNpJfOkuVDQ38rcIMevGuLtdK9554AzwtGhANZwpmuqA7u1GCtpMsrLvR1ihBly6yK/pE5wHogT/StKWk4OphFudYolNmVi47rhTE1UGMHxGrvincC3xmVi9E7QWheWLHeqPa0GGtFBaTKtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(366004)(39860400002)(396003)(346002)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(5660300002)(4744005)(41300700001)(2906002)(44832011)(66476007)(66946007)(66556008)(6486002)(8676002)(8936002)(4326008)(316002)(478600001)(38100700002)(53546011)(86362001)(31696002)(36756003)(31686004)(6506007)(6512007)(6666004)(26005)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTJsWEUzWjRUcW5FU3RrYUlxS1FnMVYwZklGVXE2K3Zqd3ZzRTBvY0J5MVp5?=
 =?utf-8?B?VDZZTGZmMktnVEhJS0tjNnZxVjg5OEYvd1IyWlliYWZCQUUvcW00ZjJFbVJ1?=
 =?utf-8?B?cUEveC96L0FwdHZkcVZpTXp4anFXQ0ZDU2pvMlh6ODF3TGY2OXhiQ0ZkZEFE?=
 =?utf-8?B?QUwwa2pTTDJOOENSZUJtMEo5SDhndHpOVmk0eTh2U1U2QXlmZFE5ZTEvRkZN?=
 =?utf-8?B?L1lmc1pZZU1Bb1FhNG1Udlp3enhZMHJSYlE1K2R0YUlmbk94S1pzN3FUM3Rr?=
 =?utf-8?B?MVUwQjBPZ0VCVWhrMkpycWVSMWpZb0xPSkt2N092OVZJUXp4VnM5dlNRaEl2?=
 =?utf-8?B?NHo4ZE9icXhENmNKYzFya0NvYjRVdGxtamJIUDZOY1JwTnliOG1ieHpsZEFq?=
 =?utf-8?B?c0s0YmtqNkZJaG9UM0l0bTIxKzFkVmdwWlBVMkpZZm42NkNlY1g2KzdUeEFX?=
 =?utf-8?B?ZmkxZ2tabHVhanZQc2IxMmZodVFwdHE5NEEwMkhnK3l3a3gxbkxRV1Z4NlhM?=
 =?utf-8?B?ZkpKNUNDOWJTb1hDeEM1bnpBbWVQUW5qVnRqeTlBMTlsYU5EQkxvZ3JWcGl4?=
 =?utf-8?B?ZEpNYXA2cStKQUw4RDNEeStEWll1eUkxcjVuTWRKd2FHZXZSZFJwdGxRQWN4?=
 =?utf-8?B?TTlQcHJINEtUSDRmNlMvODRhQ09mNzQ4R2ZMUHhEc0pLOUdqVkZYZXNQc2J6?=
 =?utf-8?B?MTBSR0d1bitScnB2djc0bUtYMGk0V2VHRU4zOXRqVytuY0JRN0F1QTRldjhQ?=
 =?utf-8?B?d0I3am1YWm0vbWV6U0xaY0EyNXNqZnN4amFFZm1kTjJ5VjJBK3MrazE1WSsw?=
 =?utf-8?B?VjJWL21kaHpoMFpDWjBsOS92VTZZM0xlcHc0VFdUYWpTdmFyUFpzQWoxS3Ir?=
 =?utf-8?B?ajNpcjdnT0hPNyt3K1ZhQytBcHg4Nk1vUEJGOVdCMWJ5dWRXbFQ3L2xKOXZk?=
 =?utf-8?B?ZGJKM21ENVRCQktMSjlpUHB6b1JzYTFkeFk0YXlFTFlvQlJ4d2pKUEZTQnN5?=
 =?utf-8?B?ay82dTdDM3RKOXJMRk5wZ1JxVzJxUjFHQktGWUFiMk1yMmRHSEJ0c0JBQ1Ba?=
 =?utf-8?B?eUZRTnBkalV3UGFnaGdrbHNYVU5zSEp1c0xGTDUzQkhDK2xXWnFoUVpJeWJ3?=
 =?utf-8?B?MXpHc2x2aFZlczNSNDljSmJuR1RlR2VkSmlBejEzVmNDZCtwOWNDSFdCTSt6?=
 =?utf-8?B?ZVhuaVA1eGROb0NTcnI1cEJOSk1iWjdrS0h5Z0FaYW9VQTFjdHhoVU8zekhv?=
 =?utf-8?B?Rld3N1p3MFJTTWlpL0JLQ1Jickx0WFN0TTdzdEVYTXhadTAvWXJJZXdCMVgz?=
 =?utf-8?B?NEJQcW1qQXkxNXJLK2o2QWUvS3VYZmQ2NFUwbUhLVy9rRFBhVUhjeGpLd0VB?=
 =?utf-8?B?TmhiTUcyeXVLQU9KakdCVzVHL0NwSjNLL3gvR0Y2d0VKMUxibXdSbE8zY3Zq?=
 =?utf-8?B?ejQrMTdycWlGeFJlS245QXd4UnRidWhIRWk0YkZtNkUyd3NrdVRERzdUb0sv?=
 =?utf-8?B?V2FOQ05CRjRtV2J3NjFDOHFtS2pUNS9kbXpUVFpuMS9jdEFqTm9VWFljb0lB?=
 =?utf-8?B?YVBaNTROUnAvT3NpemlDSExUaURmWnhBcTlWT3JiWHAvVlBCUFp0bTZ2SStO?=
 =?utf-8?B?M3J1dDMvNUJIajBqZWtHN1JoQlY4dlpEd2EySTR1WVROcWVCT2xDR2g4UHkz?=
 =?utf-8?B?S3VHamhvRnJTN0ZTUnRLaUN2RVlFL0RhVk1jNG9EdVRubTM5cE1NWEJRTlc3?=
 =?utf-8?B?Y0gwQjdEU01WbElGajdCMDBiL2lEbysxdkF0RDU4aC9zSGFub0RQTis5VlVM?=
 =?utf-8?B?L2pvek1nRVNHNEdBc2NxM0lDSDZFVDV3blBNcU1PNW5XWUlYRjZwa0V3N3FZ?=
 =?utf-8?B?dE9OdmY5OU9WTzFSbUs2ekwyU0E2SjNsTk1vOGQwVFhCVW9lMmhPd3hVZldz?=
 =?utf-8?B?dFpZNmpWSFlGQ1gva2FOeUVXUThnUWxyS05lZVBZWE04QTJVdzFGcGdYZ09j?=
 =?utf-8?B?S09OQTNjYi9XazhJWSt2emExTlhPL2xXSlVmTWtOenp4QkozK0NtMGtrN1d1?=
 =?utf-8?B?azdadFBCQjFRSE5xRmcrY1lEMzRYaW1VSVhwUmQ4akNHVkVPa09pYlpGWE4r?=
 =?utf-8?B?S09WaVZjTkY4SDEyZnRlblNvTHloTjRiK3lybEdoeDZORmFnUk42NjB2SkNk?=
 =?utf-8?B?Q1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZayizW48eTwbR0fDmcL4A+tX39OLO3DH0Ov9i/SWwyl86r943qe1WNGStzBpy114gcdp1jnGnHJ490to1BwZOsTiFiG4kf1M/m0cP2RHYYItzaN0uizvzphwlUANRjx2pL7n6npEIu9/4cFK8p/+5xL5XS7gB9C2IkTRSUlA7alvprAL9vVT6LzdOBmi9F0dS1YqIlTBg0bTCuMPQdOiGxF4oZzquZK0MKDY3/riZrb5v8hbs0iMX9GXUBEGl3C7ZW3AYIqJGki+FsDbl5P3dQmfOq/jKbhM8xUyxPeOAXWus3wblk5SLRbaSGYJeQGgN19CyAWfoQ3WWuRGVMZWjOj21KAbRGSUpZTAeMT3CdhsnPTSgVJH0WnZ+NS9YAN3KilqNs4haR3W67Yigrm4WF51Qxz5bORZE+Rg7Cuqjms0FoWMc+jWVfF49Lw0aND3mmDmKrwwqcHE/Mo6z9iaZ+dXn55gBQept/0lbNMY9FN3Xskyi794braY5BYsWyYuf9CinmSaLUHkHWN4qUrR/wE0loQPXW75WPp1meHf11vcZvHDUDV2ouLr5g3PQ3gwqP9d1b1U7HF4wIukCh/54IL3hhAvQ4Se+XwPx9s27s6L7Nsy9jjeVdMyzMXgNue/47zrAtrIvOzl98gU22/sLQAAlFYhedSEY1I4fm5v/Jw3P5EMhRspZfgSfEVLV0IcDIlqbPpL1Tr9rDL4LVjBj4dLd55+yM3QX6fyzsZsKG0l2Fblpd2LUNMCN1IJaKDfwpOsQ3s5peTio7fQXqnZkEYqaarHW4WQVr5JXRbzINuzsz5aCdDNF0RsqgpMmlwtBwkBE6Q2Pn05wL5qUSNaDw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2274c75-4dbd-4aed-c4ad-08dbda1f5d3e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 14:40:45.0332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hjsXICDV38+SC+1bDUL6pRNAZgCZ3UPDWgF49Dq9iG2NZXaKEpZKm0hWWe/tGvrl2REiGbtS8X2GEbplHts23w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6183
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-31_01,2023-10-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2310310116
X-Proofpoint-ORIG-GUID: U_9hqu-0MQMIwXjXvk1GO0vdcHJ9sizh
X-Proofpoint-GUID: U_9hqu-0MQMIwXjXvk1GO0vdcHJ9sizh
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

On 11/10/2023 04:26, Josef Bacik wrote:
> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> 
> Make sure that snapshots of encrypted data are readable and writeable.
> 
> Test deliberately high-numbered to not conflict.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Looks good to me.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

