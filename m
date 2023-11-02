Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B657DF178
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Nov 2023 12:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345771AbjKBLnX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Nov 2023 07:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344733AbjKBLnV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Nov 2023 07:43:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A715218E;
        Thu,  2 Nov 2023 04:43:03 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A2832Gr026621;
        Thu, 2 Nov 2023 11:43:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ppcY7qREdBsuvWNS+fz7lTAM+p5rfJ0b+UncqugTFdo=;
 b=3mQvjN/QCepOsXt6f3Oq4fGy6TXxDXdwBPqT2j+PgALkG7ugyDuy5FvwheDRBGu5igQt
 x/ViIYlzlT+sLQI4H6Az6IsFDur6UFpfIhLE3lZ54CgbudCLChEQ8ye35G7Cj479Nz4F
 vINY7e3W4jXK50zTF32MFrHaBQ3HqL3TJkZS1H4D7m9dl0pfu0gGb9TLnZWfMBMLAjEL
 W3JnWCts9U7hFCWc4MzASMC8gm6NWeobmFT3/KPsNH1go1UkQtNafh8sPJUUjd5hxh7q
 XtEtFFZ35ZMHWO2Xlv7u76vhpzMpouDT2sWWNVO7nhjlndbHLiPxwBk1DCzGI40VKTpe 8Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0tuuhd3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Nov 2023 11:43:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A2A0vJ6020068;
        Thu, 2 Nov 2023 11:43:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rr8fj66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Nov 2023 11:43:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2LX8By2TZzcTpfzbvT1JmDsNpGIZ9LemmuA/B7gdE46nPiuUdQbZs/2ysyErExHTLRmDO5/I0+HN8TzFJpOyjhl3Q3KR+/MOSs0LATad62ejq0G0dosbwyy4eVGbL4JgPmEB7xuZN66+88Vi/m4jQvyFQMP/NOxw/p/55/UscQuGRRd4HNJGgWWSHkxWLfOLs7PwM8P6F7JawD4j3wmQ9pz854kNq2WVb4HR7hZuUuIReD6TRhfBoC8TB2O/T+TVjrCmDUklwV0fV42Kqv67JCKQLp122INntDZjLAYMux94Wk5oc069HLErvqzdK0oDl1jSe8J+24aNMPbXQpglA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ppcY7qREdBsuvWNS+fz7lTAM+p5rfJ0b+UncqugTFdo=;
 b=TSufLNFZNl/msf324JYRMmqlL3S/ka7GAq8i0/xzI+S7bfU+AXaq/nLpXXdgcBRCADP4H/UhyE6sVOmAWhpspcLhO2jv/Kl2l0lkHXpMq7MVJZXVrqCJvpYnTg1/c+VLju4hxlkQbci7JB3QHWKN2rbGOax8x1aVRDlHCjqBceyIRvV2kT0X1bDMOAqxiUAHVZcJDXn7bUgngXz4XVgBTGlZ2ZPEuRRZS5f7d5PbO8ftFEuZwHE2lbj/5O+QiPfx5RvNc17Q6tqAIKWN56PoFRQPoqWfRH+/nlrQLcNVEISnso+hY6R8kvJhwWKSpMXHR0BGZ/xi1RujVjwdFOWX5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppcY7qREdBsuvWNS+fz7lTAM+p5rfJ0b+UncqugTFdo=;
 b=L72ECu/OtEy43Sqi20QNazG06RaxcO/RothChfgYgdUJxZfk4wWGRLm5dSY+I00iwL8NTiEp+KEGEQmPwnL1j/xGYr3mSQvNht3pYGJP5YSj/FIwJ4sPukUrC4exok7O7fVGN62JhAoigDTA/iEtA0S33u+gLF3nVXWs/6QAYGQ=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN0PR10MB4839.namprd10.prod.outlook.com (2603:10b6:408:126::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.21; Thu, 2 Nov
 2023 11:42:59 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::8732:b8be:e262:1fb%4]) with mapi id 15.20.6954.021; Thu, 2 Nov 2023
 11:42:59 +0000
Message-ID: <7cba2927-5636-4039-9e76-f01a5b86c108@oracle.com>
Date:   Thu, 2 Nov 2023 19:42:50 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/12] fstests: split generic/580 into two tests
Content-Language: en-US
To:     Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1696969376.git.josef@toxicpanda.com>
 <ecf95cca70aa11c64455893ea823ec8de0249cf5.1696969376.git.josef@toxicpanda.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <ecf95cca70aa11c64455893ea823ec8de0249cf5.1696969376.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0039.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::16) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|BN0PR10MB4839:EE_
X-MS-Office365-Filtering-Correlation-Id: bc89d327-3cbb-4aad-ad24-08dbdb98dcc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ifLBLpdc0rp71956wsFXH5XCPtQQE1q7SgsiwuynRMPlacVKmdGXlIW5uHdAW1W4vcTLXqmzcswoZjF6YwaIdvtKf1wSwHOUpz2m+TzZkXkmPDhEyeSw4zclUPyRGnGUCA4ozpopfyDolwsmQk3G+vV/a1/HeMvb0O/lzZVc6M/RyyObA2Lp1NPcomw4Hs9RkuRo0Y10AyXR2XnHn8KM4yAeS6AhYjaDnOhlwzOJdLYM+F5Z+6qhUMiBaND+eyRxOVOIS4pUVEumdO2gFqMQrOT1INNcIrIAhBcA+1YefQMs/JMrHbbBBr8rhjmZWFnIzQyvRQ3b/G9yCS0R28t+aAmx8CXsfyyFW7NzSLbQPWFlfIxyDA1rEL6aXPy6s7Qt/4OMvCXsXpo3VCW6yHdLeperftYcgp/+iXzWvQmreSKH00n0oKpwdZV/Ep9O5g94B4KoC66mx9PjRr/qbHpR7WsLClUrI93vIzZNXNECRWnnFJC8TX7bN0ZLFz0th46IUusDN5jP9JRaq9BKNcl15OToSAMSyJsmoKUUAJNT5xHAxW/73yiXF9BKAuZeSHQXqvVNl2xWQ1nyHAbo9YKQbgFkxrkK95cpCwQLDh5ErZgy/cZDHooJZKfLPAFjEFtI+F2TjU+qdQuFNjpWn+TvXPN8O1ABTwZcu1fQH+SIAvo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(39860400002)(396003)(376002)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(66946007)(66556008)(66476007)(6666004)(31696002)(86362001)(6512007)(6506007)(53546011)(2906002)(6486002)(478600001)(36756003)(4744005)(38100700002)(41300700001)(26005)(2616005)(5660300002)(8936002)(44832011)(316002)(31686004)(8676002)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGFEWWFhQS9DY3I1eE1NWmp5NFpBU3FEMk5LL0F3SjUrMXNwMDc1dTZ6RzFE?=
 =?utf-8?B?ank2QkFrYjd2cEdNc1V0Ulh4dVNuVXBJbi9wNzI3cFc3UW5NSGNNOVhYaHBr?=
 =?utf-8?B?OW9tS0QrTEsyZkFSMDRZRmEwL0JINlVoTHUwdFlVR2dudlg4Y0UreWNlM1lH?=
 =?utf-8?B?ZGcycUVFcXpmckJBSU9YTW5WZGlLNXlYNFFVbk9Na0JyRHRXc1N3aEV4dVlB?=
 =?utf-8?B?VnBNcDFaS3pGVFJTQ1R4WE1JUklCMkU4eTk0VEhUN1ZkeSsyM2xQVXQ0MGta?=
 =?utf-8?B?Njd2cU92eFlBbytianl3d3VsTGhVZ2ZYcmZ1WGxiODFmSDFUeGZvMVcrZVNt?=
 =?utf-8?B?ODkrWVA0SVJOSzBkZG9mcEV2TDI1ZUU5WEJCTTNRSkhLT0FHOWpseStHcmRv?=
 =?utf-8?B?Qm5FT2hhSnBFbzdxTnpPQSsyZWE5UTJnVmJlaGZ5Tm5TODduMGlURGxib0th?=
 =?utf-8?B?elV6TVR4K1JtSHJkUkFFWElzZm1raXNFRTBzaEgyUFlVMllpQ2NPSWVrS2lD?=
 =?utf-8?B?Zkt0clFQMHZlRlpJdkxzM1ZCVWh5UHdCcEVOSUxVL2dKdzU5djZjZ0VCR0RZ?=
 =?utf-8?B?aTJoVWRaR3Y0blIwZlR2dlQzU2JoNkljdjBNRE9CRnBCWXFEZ2xVeDIxVEhL?=
 =?utf-8?B?YlFMNzN3Zm50emxUMlBtUFBjdmp1b0tId2ZWUW1CS2toZDBFNTQxUTdVRWd2?=
 =?utf-8?B?UUlKWHdXaG9Nbi9Rd1pYTUlVSUtaU01OS3luMHJudm93R1NETnhoNVdtUE9l?=
 =?utf-8?B?T2FVVXN3bFJaSUZ1L0h0NGFTUU14NkdNSTNlcXQ4eUFaTVo5ZWhnL0pmRHM1?=
 =?utf-8?B?VndsMDRyLzJqcFJwOTBlY0szSVF5TmFRYmFwWGpKV0lHa3lUdEZGMVpBbnhh?=
 =?utf-8?B?OGpwTWVxNXljRk1aRGg4TnVLby9UU1NCaWR3N3AxTGFZZTZsdHBiK0VrdlY2?=
 =?utf-8?B?Szl6L0hISkJrcW9wWFBDTjF6ZnRUSnNvTGUyemhXclhpd3M3WkRmaDJzZndz?=
 =?utf-8?B?RHZOc3JheUszdW90RkNDMFY1VkRVQjhmWFNPRmowZ1Q4VUxNZks1T0FQeEpm?=
 =?utf-8?B?c3BabUE0OVlBeFhSWmFFMXpPQi9UdUFVZFp4TTZNWFhTS2JtSXU2NXd6bHcw?=
 =?utf-8?B?M3M0SDEyYTJwQVFzQ3JzUWxPQ1E2bkc4bSs4dTdlYnZROVRLWWJkdlkxbWND?=
 =?utf-8?B?SXdPYU1vWjc4UWdhYWwrT1dXTERvS0tVcGx6ZEI0dU1HK0ZoZ3JKNmZGSlZG?=
 =?utf-8?B?OE40NDJ1d3FqWlM3SDhGNDNuK0Q5M2VWR0VIVTNOY0E5d2lpdlZZaDJNd3BZ?=
 =?utf-8?B?VndrZXB4dDZnUC9jeVAralFjcUpXZitJVUw0TFlncmlxclFFcUwybEpaM0Zq?=
 =?utf-8?B?OUk0ZmhYNWF3Uzk2OWdmZkxCd0hRT1dLdVlaWnhaNjc4NVNkY1NIbHRNT3V1?=
 =?utf-8?B?clhQMjNudU1IZklqbEE1RXIyOXNiWDVlalJKMmpPbE02WUxGR1BZTjUyRWwz?=
 =?utf-8?B?YU5IZHFlRzBnby9hcEMyRlB4M0tvRXNTNEcrTWpjbmR2c3c4QmEzVVRJUmty?=
 =?utf-8?B?SEY1cEM0eFcyVFErYzZWeFBVM21yMGRjUUNlUmNYVElIbHl2M1g3QmFQdW1l?=
 =?utf-8?B?R2cvK0ZZV282OXZsUXJBSllQaENEdFRPc1Z3OE1yVGMwaEZRMzRGZ1RWS0x1?=
 =?utf-8?B?WFN3azdDQ1BGWGZha1gvK3FKU0pUbGRlQUtmTFNDSTVZVEpwWWJIcVFpb1Fx?=
 =?utf-8?B?M01zQmgzVVp1THRKUFNXRHpTN1AwTEtkMTBqZndnUEN3VlEvOUNUT0Z6Q1JC?=
 =?utf-8?B?TU5hZWlsM1YvbjFjRkdiRmtyMUVIMXdqUkFiRFVKZlRqcXQ5UU1IczFJOWlG?=
 =?utf-8?B?MjNtcFhtK09TVFVnUDRWWTNaREtmbWNUdEFZcUdSTUlHc0pteThiSEl6TjFG?=
 =?utf-8?B?Yyt4RDYwQjFnaUtCVXpEWFZwODJ1R2RjczNhdlFLelJUTFp5VDV2aWFGaGJD?=
 =?utf-8?B?cGRidnltYXRhMFg4WFRoOFZLK1RPTE54QlFhbkF3ZE5BOHhYOEkyUkNrTFNh?=
 =?utf-8?B?QnVEU3ZPSVp0RTVIZzlvb2VJdEx0Y044aDBTSmIwVGV6NDNTRWwxVlV2RlB3?=
 =?utf-8?Q?lUgDzTSMicMO1URie5/bqhmQ2?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: igOAINdzbXXrUcu67XJVB/zgGM/05K+dtS6yvN7Yi8zErJMW13dKuyL4LtC46u5UuS3dQN8DQPAc9V+V8kL4wYm+OYjlkKR9kmbal6paUN6E83tbBaxcchWkFNXmyW3/NSEI/vAwQ+cgk5fSU+ITvkznSFAv4Zt+DNdeU/EM/vcijfs7sRPx7Ng7qFHjc5REJX4UUdQcFqbLT7PaN4KkD4CMeSmvQlcB0Yp58nFldSZy3SCVwyXwzQzwuphyrl70u63+BX15lU8w6zOhxVBg5uFd2dLO78TLbdxavoc7dA12ohC3s177Y93aND3K8UpEMAucu+S+K+Vi0Dl5ZnZYs1MGnI1b+7o5Y6v4GbyF4gh8wxR9JbLxr0MekY/8WYclCO9dOoa9UMsmHpDWYzsW5bwbav8ZfGvRCm2UKGgGeXXsPHhlwUs62Fyex1FMbCVNpB3MS9305aVCikd91V9Dq59Ol3pKIAHImHN0fO/qoFno/ix7EU8XrsAmThjJU7pzl+5CISqIILuH7fzdVZYxIVQs3Knm/57if9FJEnv5bxGmvESuBihHZeoI33ZOMprQYu4kON/dJPV7Wg8AUUdK+xUdPExH0ES/3T1tzQoynKDG6LENtMY8ZOVMWxu6Ssrblxwf9WtRQXvcOxFDThWabvr20P2OZCvHWJOpQ6lZThXT/ILyEJgYhYD7o0gdIiHGv0Yd9U0RgJLYHDG6QNVFrhJ/6U1MeIHUHTcRxs6fEeRjLylQMi8gTagtanGAVllQPr0JPaBqddhO2paWJH9DxRb5h43h92+AX+N6JtTG2Cbv9qnGPvr+ovEBSZgbi0OF
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc89d327-3cbb-4aad-ad24-08dbdb98dcc9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 11:42:59.1850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WAbVMZl5Uzyb1Yw6dx6l55roxk0FLyXOQzxJh6RC5bcWEmGC2s8ReI78oRLHqQ/7x4VWCN5h0aX4HOKfC1E17w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-02_01,2023-11-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311020093
X-Proofpoint-GUID: MFrWml85eDESnTyRK_rTEppQjSygxxE1
X-Proofpoint-ORIG-GUID: MFrWml85eDESnTyRK_rTEppQjSygxxE1
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
> generic/580 tests both v1 and v2 encryption policies, however btrfs only
> supports v2 policies.  Split this into two tests so that we can get the
> v2 coverage for btrfs.

Instead of duplicating the test cases for v1 and v2 encryption policies,
can we check the supported version and run them accordingly within a
single test case?

The same applies 10 and 11/12 patches as well.

Thanks, Anand
