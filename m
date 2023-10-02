Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93417B5116
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 Oct 2023 13:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbjJBLWu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Oct 2023 07:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236626AbjJBLWs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Oct 2023 07:22:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE94A83;
        Mon,  2 Oct 2023 04:22:45 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3928Xs3U021688;
        Mon, 2 Oct 2023 11:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=vBecZvQ1If/5QyHCAVL/0Tkg7IV/nYsHdqGjoiNIS8g=;
 b=N6CAQTJ+1eVmhzxsTmS5g6IfneIPr2sBNZUJWH+GqEt8bcOGCGHfGcty/RyBPXvWElJu
 fO4yH0l1dopUZpJHMeTxlWLkMosb3hsV1eUGtkf77ccHNoxtMmvu5JVR5UNFlkaWpJ/I
 c4CYZUoO5CBaAy9S2tLFZFVHS+VZ9yX46opBybGsAydf/pJfjkxi3jSLoDCLhfC6r3nV
 KOSrbXO/zL9vw0WLgrPj2Xg3fZdUFhIzM/BHpfe3klhzqgDL+BeF+RSFtkiacVoJaPnX
 /7xVEfAd7jiMXsY42qkHQgIAkiRlxkund+NTl/c5vwjdC+AKhZQso24mj58VCcz+2EzC 7A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3teakca9bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Oct 2023 11:22:21 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 392AWWMP000378;
        Mon, 2 Oct 2023 11:22:19 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea44dybw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Oct 2023 11:22:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1q8c+p4SGxaQnASLsPtrz45B1CQDocx+Tgc01ZE4udrpQMFlipF2KT+gpu+c4u9Gqht7JgL05aUv6nCc9y8Y7fGekJoOcMMZXnxfCjSLQSBgD0Nd1wCPFr2igCLYpMadN2WWoGzU2pVTXf+I45c37LOYTQ+gxIp/Szo62LOyJcX3sPsPR5mFRi+B2BpFoMuOxFKibZkX+mb0Oo9BCmHWw9RuKrsV/BL5xtK3t454Ip9NhW0hthdwTpH0IEr6dbXQ6SB7TMdGkiKMwf0kDEd93KrR4x9QZC95n/7E7gojmk99UzClwey+tu5Ylqq56EV23EyvoKrlFkV+OR+HLmyjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vBecZvQ1If/5QyHCAVL/0Tkg7IV/nYsHdqGjoiNIS8g=;
 b=RJhHk3NGgk/kLIipBlxWKCvDPN9ScSi3MhB/bl+xx6E7SZFAATyoeoHWgXg/eoU06g+1x/q5FfyZDETliZwRA7ueZfiOsjhlEHpJwwaB6erUDhKhMLwvezl3bDvxmmVeO2wBqT/DFthFgTKt4OVJUlFqQ1rkOpzHdrIhsw5kTFcDbNfGE15TsvzThHGkKE/uFMaOecd5YApKH9Cu69ZaL+QbK4BbSiwkeZ083641UHh2H40/GXnCF28R1eSSdfq9AY+YDUxuJpwU8XuKnIJ3AvgSqBvGP3v2ep/dhLOyR1p4oxwUV8BSYHg4zhtXyibqCJtUVodHwl4T6ju0DQECxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vBecZvQ1If/5QyHCAVL/0Tkg7IV/nYsHdqGjoiNIS8g=;
 b=CUnbD49WiGwKfkKYAAxfVo3L2P1YtH+3Wz/wArO/i1GjMd52ZwyuLX57QnLxN0+0ZiawsYTam9CME1rhOAwTWAWgXgSNb6wF6cZKxn18EFdODH08uvqQ3/329LFy6FbxLfAhd6gKLpOgnlEjDynCrlJ4gikbpLKX7x1Yf8FG/6g=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by PH7PR10MB7056.namprd10.prod.outlook.com (2603:10b6:510:275::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.29; Mon, 2 Oct
 2023 11:22:18 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::2bbc:60da:ba6c:f685]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::2bbc:60da:ba6c:f685%2]) with mapi id 15.20.6813.017; Mon, 2 Oct 2023
 11:22:18 +0000
Message-ID: <af816e3b-305c-d6a1-ab65-e5f9be5f0902@oracle.com>
Date:   Mon, 2 Oct 2023 19:22:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH v3 2/9] common/encrypt: add btrfs to
 get_encryption_*nonce
Content-Language: en-US
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, fdmanana@suse.com,
        linux-fscrypt@vger.kernel.org, fsverity@lists.linux.dev,
        zlang@kernel.org
References: <cover.1691530000.git.sweettea-kernel@dorminy.me>
 <dd7c1bbeb443fbb6d0836fe2b5be394c991dc4d0.1691530000.git.sweettea-kernel@dorminy.me>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <dd7c1bbeb443fbb6d0836fe2b5be394c991dc4d0.1691530000.git.sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0012.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::8) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|PH7PR10MB7056:EE_
X-MS-Office365-Filtering-Correlation-Id: cc35d42d-b25e-4604-f71b-08dbc339d667
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8KRuKUvK6Mw57UPnMdfLZ0oTIgKksAp2UClSsE29DWsu5q083cUr0sNoiLlP4F6pQ7RYtZIZvfdOruvL+IwcivnTGSAiEQ+CPWaCBdMPoCfN0iglTdoHvUYjhR0KKcYilJduPl6lfuDpIxvVgQi3UXHZqq4FULzLJi5wy2YEwF6QrtQCZDjntwNsBhiGGtDKpeFnnFyXbk+OY48ts9rfIUCtWLBr/MR2Cd8SU7BscZMU6EAMPbKPH4xQ6nvVXCRJLFgP7sNg29LiNHVWU0pm/zTPuU7ZXhxx6dPod/6HBqb9kEWZ7t7E11eIVcuP7DzOzXGql+8Kp+mi06qIxe/AdmluOqczt077/rmF19b/DdwWYYB7A3L6+4PsVzRVDgg1OTbupSyHPJYXo3u3daQBmOGbNGaL3GG8zK+ObqvRKsUK4uVp7GNwxbDszehJtYEuDuFYxv9/J6MrWZwLdEdAgnwGSF9tbOv45ygCg5w/4idmrvG0q6YYeiyLaGvltdbitpA2JDjTcDp5nLIuHBwM8enqeR4kl+XUalrAyot+8ZPbvqnj8Ntt/j4DYjQ0TQ0+T6RUjl4VnMepQvYzcXj5ATCgeQuWGMSwZ6aO+P+cwU5tqDAUuy5L0eI3WQxygzDN3h+SiL3Ctz3aXv8qD0urw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(346002)(396003)(376002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(316002)(66946007)(8936002)(31686004)(26005)(8676002)(66556008)(41300700001)(66476007)(44832011)(5660300002)(36756003)(2616005)(6486002)(478600001)(53546011)(6666004)(31696002)(6512007)(38100700002)(6506007)(86362001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UStacFlWaTBTZE1QcmFHT2gzMHZKRGMxdHhKaHUyQ1ExSitZS3JRUC9kYVEw?=
 =?utf-8?B?dTU2Ky9keHJiTWNXbXZIOFU1Sy9KR2w3NHdRUHVxYjRGdFNwdElPeWlOdkx1?=
 =?utf-8?B?NUhTUnUvYng3bTUxaDRtbDA0ZXJQMVVpbXN1MWxNTHNTYVNEclJnUFFwdDh6?=
 =?utf-8?B?U1J1RVEwYjk3Z1l4TG1yVytuYStkZzhIK3BtdmlBYnFWYXJvTkRUaHNZNTZ3?=
 =?utf-8?B?RUNWQ2c4VHBrRjVBbGlZUjZQZXhiWGNGbjJOb0lKa3M2UmVOaVo3SGlnYVow?=
 =?utf-8?B?OWRFODJHUm53QXpjOVJDVkpOWDlLR2Y5VCs4bmxPRVh5cEdPbDdzdGxuTy9Y?=
 =?utf-8?B?SnpkQ2xneVMzRXg0cm5zaXJiTEtGTXlzYWhzbTR1Q2NiRnA3Q2tTeDJ2ZGps?=
 =?utf-8?B?ZVIwZzl3dDU0SnFuUWVCLzJ5a05OZ0RaT1dsenJ2empSeDZNZHFUWDBYYmlS?=
 =?utf-8?B?bUE4Snh3b0V0bTlidWRTSmU1NFpDRUZmRDVkSnhIRytiT0NDcFkrbm1wTk1Q?=
 =?utf-8?B?UU5Qa3VoMjVQQ3JaZ2JWVlNnRldqNy9ReFZuR21SSXYxOUxVVG92MVJBZnlD?=
 =?utf-8?B?NVg2dWJlMXBhVVk3cHpwRWNZWTBsT0hDL0x5aTJQZjAwdE1uZ1BSd1NwNk0z?=
 =?utf-8?B?bVd0SDVPMHRSNHZUcXUzcWUrYnc0T3QvOWpibkRnanQ3SXVHdWlEbXUzY2x3?=
 =?utf-8?B?djRjU1kvb3dkcHZjSThwaWgrVmlBVDJ3Sk9pbkJBSlRZZ1VVUytCZEtIQ2tT?=
 =?utf-8?B?TXFWb1VJbFhsVXFieFExODZ3dzRyRjhWcUJTRlRuSndFbk1GZCtPQnFmbzdC?=
 =?utf-8?B?VWFqT3dPTk9ncFdmRGJmcTNyanB6V0tibWhrOVJTbURNcW1pNkJOWFJ2NVBW?=
 =?utf-8?B?UmZ5SlVManFhT0RURG5XVGhvQnNFbXhJK1BKaEE2a3pCTytIbHJFOW5XZmJx?=
 =?utf-8?B?ZklmWCtXYk5zekMwOXBKK0lFZ3BGUUxMREkvbHA5c1M1c005YkFFT0JaQmJq?=
 =?utf-8?B?Ulh1N0o2YVRmdFptcjVUQzhDT2hIODZVT3Q4eE0rRzZRRkRtcmhlRGJZSTd4?=
 =?utf-8?B?RlViNU1ZUG51M2JhME1mMkxFcDI4NDVHam1LNlJDK203T3hSVjVqSG9yNGd2?=
 =?utf-8?B?VmNFWkxqenNpcm9odGp6NDlxSmkxTXRacTgyZzJOY0xycEtSSHlScU5MUU12?=
 =?utf-8?B?QTZFMUoraVN4am9sdUVFWHlRZGp5a0htUkhIMTNCRWVtQm9URjZiZW1rQkxU?=
 =?utf-8?B?OEU2MEJyTXNTNW1VTW5UUjN0WmpJYy9mQ1d5NGQ2L0xEajJDcW4zZkdpU1Jn?=
 =?utf-8?B?OC9RVDlSMlcrbEFnWjNKTnpERGhPU1kwaTM2Smh4cHVFdmgwY3MrMjFpQmtR?=
 =?utf-8?B?ZGZNT1hyWkdBYXVPRVRvTHMrOUdwMWErN0FxZkZGL0xpdE91d21nUlFGZmNO?=
 =?utf-8?B?a1o5eDNscGMzZ0kwMGFPWGwybTZSYVV3SzNrdi9HcW5JTk1jUVBPTllBWmgx?=
 =?utf-8?B?bFg4OEhIYytxSFExRnZSNDZQcE42UmhMRjk5NUtKRHRkb09jY2tuWk84MGY3?=
 =?utf-8?B?T1JNdVoxbWs5Z0t1OEhiekxCbXc2QlJGekFsbUZkU3hDVmdydHpZbGw0NjU5?=
 =?utf-8?B?SXRzWUFpQVdqbGZYUkxRV0lTeXF2TnZtOGVtMUc4WmNWNkdmakJDUWZaMW1r?=
 =?utf-8?B?ZUZudVlLcHdEK0tWOEN0Wk94TnMzSXIvUE9pYmE1c3dMb3lXY1Y5Q2hYS3dI?=
 =?utf-8?B?L2JEaHJEVDFYVWlhQUNmV2hKVkVDWFY2RkJHeVZoM09iRm1Hb2JQS29YbmIv?=
 =?utf-8?B?WktRUDRHOEhrczNOS0MrVnBLYk9wZHJUUVJLQ3FVbnBLRFZtbERzVG00UkRI?=
 =?utf-8?B?c0lzdFFzN1RZVWtjNCtzdHduU1ljSTl4U3FDYUVuRVZyUCtwWFA3T1dSTVJ1?=
 =?utf-8?B?VzJwaklMQ2ZEdlZHd0RzZnZEVXdkZnBSbmpkSjY3QnI2SG5raUVrRVFHNWxj?=
 =?utf-8?B?Mk5NWm1yRE5TdWs0bUFUbzlYdzJONmFUc1Q1UmF1M3FZeHdGei9TcTQvNk81?=
 =?utf-8?B?RW1UbTl0QnpGMzRlN1h5cGFaejZhYXJFTHN0YUpOVlFmbUp4MXprWDlwMmIv?=
 =?utf-8?B?Smk3Wm13ZHBmSjRZMnpHLy9weHcwZ0pTVGxaQVp0cnlFLy8zdTdqWlc0a2VG?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cWpiRnRMbmppZ1Y5UDJnNWR3dmgyaFErR3duZWJ4MGUzeWtLUGM1T2h5V3RZ?=
 =?utf-8?B?T1EwNnc3Q2xKamxkQ0lPd213K3lldHUxcy93YmxxdFo1Qkt3R045NVNPaHdL?=
 =?utf-8?B?RFg4TE53RHRwcnFBNC9aNFFiSmJGSC9pRXAyR0FrQTlLODJoTW5DK3JEWEhw?=
 =?utf-8?B?dWd4dDJ6Q1pCZElGK1BYdjkvOXhMajc5ZFlhT0dRK3NyU08rQUJsNFo5MXNu?=
 =?utf-8?B?VnFybVRRam9oeDAzZy9uOVFxUjdSVmk4T3hVMzdoMSsya0RTeHJjcVdnd05T?=
 =?utf-8?B?YS83UWQxRmFPSEhZY1FIRzV1eG9EM29pbWlhZlVXeXpIamtqVU40dHByVng5?=
 =?utf-8?B?Vll2ay9yK2EwcFd6TVhpMW1vTkNwQjNObTV6eGxRMnNxOVh1bk9HMVdlNFBz?=
 =?utf-8?B?eDkxRzlYbGE4YTJYT0hsS1FWa2RvdUc0NUZDOCsrY2dTUDM0YVBCKzExcklY?=
 =?utf-8?B?ZjJtSkR6R0FxWDNvV2NLVWtUZUlhdlVxVlNxTy9USzh1WWx4Q2trVkZ2ek85?=
 =?utf-8?B?SU0wazZKUXEyN09DTVhoakloWUJFcmJFejFjUTlSNWZJWk50ME5PbTBQVlJL?=
 =?utf-8?B?d2dmYVpQSWo5c1RxUTJjb3BsTnZRVllaeWhMNHU1eHhKbWJqVXNGQ0tvektT?=
 =?utf-8?B?VFZySkhiWGdrTG9PMHNjUEtFTmdkTVViNis4Z1d5V0tOYUJqRWMrTGN2d0da?=
 =?utf-8?B?djFQVVF5eG9hTkhvZFVjakJvbi90d01DRFlpUWFRcFBwR1dmTUNZQW1sR2Rr?=
 =?utf-8?B?R3lsZkk4cFdra2hmK245RDJnWFMvQ1B6cFpLOFIyT1Z5UFNzbmFDeHgwSlpZ?=
 =?utf-8?B?aGJaRGxUVXNIQnp0Wk5HWUh0UG5iV0czVmpwS0R0TjIyMUNDYzNFNitXSVJ4?=
 =?utf-8?B?cWFkVDkzQzNZV2szZnRlQlFqN0J2bGRFQWhMWHl1WUc5b0lFR05FN1VUN0Rs?=
 =?utf-8?B?WFZ4V0VXeVpFMkF3QmlUSE9Fc2JzS0dGRUxXRTlPbjNIMzdWckN0K2VHc0lN?=
 =?utf-8?B?OTZmNEdoODhIbEdRcDVMTXl1cGlXcHV2TXVST0JpdG1nT1p0TjVrU1cxbWs3?=
 =?utf-8?B?N3RRbm9JRjFzZkJMYXVyRnhwVWpFbll6UmdNNzFYeFpEaXJNMHFMVEs2bjRj?=
 =?utf-8?B?Q2R0RVF2Zjg3bzRwaXFqczhTQmNVbS9GWnpBSlAxYWJ3QVR2U2JvMjJ2SFM5?=
 =?utf-8?B?VUwzOHJWYUVrZFB0cFBHL3J3K2IxZHJVWng0emlIeXIxZjRBa053bDhCRkdB?=
 =?utf-8?Q?l/nJ/5oUp1lU85h?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc35d42d-b25e-4604-f71b-08dbc339d667
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2023 11:22:18.1807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ilv+qP8muEEa2AR7tqeub9gxFUB3+boyotHLgbZDaehEcYtC+sdrDZRP0ofuFgKQxEbtTA1HgiYeXlhBXpQd4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7056
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-02_04,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310020084
X-Proofpoint-GUID: nmSM2Qy-FxUE8CxFp0oPWNnj4wVcePSR
X-Proofpoint-ORIG-GUID: nmSM2Qy-FxUE8CxFp0oPWNnj4wVcePSR
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 09/08/2023 01:21, Sweet Tea Dorminy wrote:
> Add the modes of getting the encryption nonces, either inode or extent,
> to the various get_encryption_nonce functions. For now, no encrypt test
> makes a file with more than one extent, so we can just grab the first
> extent's nonce for the data nonce; when we write a bigger file test,
> we'll need to change that.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>   common/encrypt    | 31 +++++++++++++++++++++++++++++++
>   tests/generic/613 |  4 ++++
>   2 files changed, 35 insertions(+)
> 
> diff --git a/common/encrypt b/common/encrypt
> index 04b6e5ac..fc1c8cc7 100644
> --- a/common/encrypt
> +++ b/common/encrypt
> @@ -531,6 +531,17 @@ _get_encryption_file_nonce()
>   				found = 0;
>   			}'
>   		;;
> +	btrfs)
> +		# Retrieve the fscrypt context for an inode as a hex string.
> +		# btrfs prints these like:
> +		#        item 14 key ($inode FSCRYPT_CTXT_ITEM 0) itemoff 15491 itemsize 40
> +		#                value: 02010400000000008fabf3dd745d41856e812458cd765bf0140f41d62853f4c0351837daff4dcc8f
> +
> +		$BTRFS_UTIL_PROG inspect-internal dump-tree $device | \
> +			grep -A 1 "key ($inode FSCRYPT_CTXT_ITEM 0)" | \
> +			grep --only-matching 'value: [[:xdigit:]]\+' | \
> +			tr -d ' \n' | tail -c 32
> +		;;
>   	*)
>   		_fail "_get_encryption_file_nonce() isn't implemented on $FSTYP"
>   		;;
> @@ -550,6 +561,23 @@ _get_encryption_data_nonce()
>   	ext4|f2fs)
>   		_get_encryption_file_nonce $device $inode
>   		;;
> +	btrfs)
> +		# Retrieve the encryption IV of the first file extent in an inode as a hex
> +		# string. btrfs prints the file extents (for simple unshared
> +		# inodes) like:
> +		#         item 21 key ($inode EXTENT_DATA 0) itemoff 2534 itemsize 69
> +		#                generation 7 type 1 (regular)
> +                #		 extent data disk byte 5304320 nr 1048576
> +                #		 extent data offset 0 nr 1048576 ram 1048576
> +                #		 extent compression 0 (none)
> +                #		 extent encryption 161 ((1, 40: context 0201040200000000116a77667261d7422a4b1ed8c427e685edb7a0d370d0c9d40030333033333330))

   Mixed indentation.

  another nit to consider fixing if sending a reroll.

Thanks, Anand

> +
> +
> +		$BTRFS_UTIL_PROG inspect-internal dump-tree $device | \
> +			grep -A 5 "key ($inode EXTENT_DATA 0)" | \
> +			grep --only-matching 'context [[:xdigit:]]\+' | \
> +			tr -d ' \n' | tail -c 32
> +		;;
>   	*)
>   		_fail "_get_encryption_data_nonce() isn't implemented on $FSTYP"
>   		;;
> @@ -572,6 +600,9 @@ _require_get_encryption_nonce_support()
>   		# Otherwise the xattr is incorrectly parsed as v1.  But just let
>   		# the test fail in that case, as it was an f2fs-tools bug...
>   		;;
> +	btrfs)
> +		_require_command "$BTRFS_UTIL_PROG" btrfs
> +		;;
>   	*)
>   		_notrun "_get_encryption_*nonce() isn't implemented on $FSTYP"
>   		;;
> diff --git a/tests/generic/613 b/tests/generic/613
> index 47c60e9c..279b1bfb 100755
> --- a/tests/generic/613
> +++ b/tests/generic/613
> @@ -69,6 +69,10 @@ echo -n > $tmp.nonces_hex
>   echo -n > $tmp.nonces_bin
>   for inode in "${inodes[@]}"; do
>   	nonce=$(_get_encryption_data_nonce $SCRATCH_DEV $inode)
> +	if [ "$FSTYP" == "btrfs" ] && [ "$nonce" == "" ]
> +	then
> +		nonce=$(_get_encryption_file_nonce $SCRATCH_DEV $inode)
> +	fi
>   	if (( ${#nonce} != 32 )) || [ -n "$(echo "$nonce" | tr -d 0-9a-fA-F)" ]
>   	then
>   		_fail "Expected nonce for inode $inode to be 16 bytes (32 hex characters), but got \"$nonce\""

