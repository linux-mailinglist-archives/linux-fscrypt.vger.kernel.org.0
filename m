Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D1E74CC23
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Jul 2023 07:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbjGJFWk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Jul 2023 01:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjGJFWP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Jul 2023 01:22:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D062E66;
        Sun,  9 Jul 2023 22:21:14 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36A3pm4B005686;
        Mon, 10 Jul 2023 05:20:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=+qpEMrGigkjTY6hhF3Yu0BH6t1gwPgLxgdRhQU97z4Q=;
 b=2fPe237v9DYyQlM5CIEmtJ4JFzGAx3NgRs/6r0cE6As7Pq5D2Jx9frcn4FX71CQMwaYN
 0TGmBFmJIIRaQ6PSyW66V+Ivf2J87oCokD+y65dk028ZL6BwqQuioolrMHF9cPU3aR7t
 Mlj7V3bzCRvpX462ZOZcBg2zfyx7Ht7CehlfjgPlAgkMhm2AQnrMz0MFWSzZU2sWeDSp
 ChpUQS/Ii3ku8oK1X3U3hBAv9fnsAt5WGfzt7hmR8YJ21BzhtKYaySvpvmhb7qcS/RKI
 rJ5rN+GrXOQKHV6h5iUrQKCJLl/qiYssnnoQs9P+2/n+uP+0z2aRIQLfufQnBetMbmWI hg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpyud1s7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 05:20:49 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36A5AXXs008862;
        Mon, 10 Jul 2023 05:20:48 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx830awm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 05:20:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfB002L108nApWSxZjoPnic5ZMT/O47khbl4xuPEW8T8SE8PTKetoyih8j+ewtZnINgVMID0B5Jt1CpMw1HYkAuuIskyEwxGJgf9KMq4+49nsnQnBUrxDK2BZtaMK/qUd3pcuNAd8rcg10DJyAFZu1N7LFjIOr2tugNN4rgpcZ4l+ctOzncXheWGSaTqkJT+0KmqYIE/6HnF9RBEpndbyVJZoNQGHWtCyLntIg72PJHx1FObHFwjH04Uq/u53mO+5Z/5JM4fSGotMd3Dze6XZtaJ9rQunjTmJweqCwvwx7v6QIS8SpJIzHOxnYzLkZH5K2/jO/fVri9DnyHWgEnr4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+qpEMrGigkjTY6hhF3Yu0BH6t1gwPgLxgdRhQU97z4Q=;
 b=We8qdvmbhSMxYxC2tceZWJXg2mhdHocNHuLeqgAq+a/f+apidG1L25zpOlDNhws5fD9I4FBpnf1GWFFtb6K3EdLrJBVTZoHClYUIp3jEpefgxEBxu1XY2UZAZd6eYu7d7SW1tXx5xOWbjRVgn6GjQq7f5B5eE6q6S3O3h1YE0zQ8uipWRLv1vuah+ilg0QCluHMe/IRViMkuuzAd9VMJcIWP+UXYJE1GuJ/lBDAnEBPYb1QT3fTBn7H2PDalBceNAurbVbRZHvGBq1eJBSp4DNlUlEqafcaPF7YWU1ruN8MisbdvlRrKczRsGpI2kUHVJeMmkBBKb9G2ZW8LxUSctA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qpEMrGigkjTY6hhF3Yu0BH6t1gwPgLxgdRhQU97z4Q=;
 b=qy0RS9H3k3rg++F63zdvFm2w5jtENQvNNvM4Bg3b3VHxg3oMkFEXbLRlT6QxDTckRGQ2Y8WOz2NCwvzt/x0VVo2SYNinNThbcQoR3jhTNPLkykQJmlq+8uWGAjrbAzzvAQwpIZCNbeqgPsoyV3Ut8gDRXyu7P26QZpgVN0c/3aA=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Mon, 10 Jul
 2023 05:20:46 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::a42d:1dc1:64e1:f814]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::a42d:1dc1:64e1:f814%4]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 05:20:46 +0000
Message-ID: <c53ba709-8fc8-3039-66d9-f42c8b2698f4@oracle.com>
Date:   Mon, 10 Jul 2023 13:20:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [RFC PATCH v2 1/8] common/encrypt: separate data and inode nonces
Content-Language: en-US
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, fdmanana@suse.com,
        linux-fscrypt@vger.kernel.org, fsverity@lists.linux.dev,
        zlang@kernel.org
References: <cover.1688929294.git.sweettea-kernel@dorminy.me>
 <bc535e5b948a5f494f4ac84fb8706d827dcf2cc6.1688929294.git.sweettea-kernel@dorminy.me>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <bc535e5b948a5f494f4ac84fb8706d827dcf2cc6.1688929294.git.sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::16) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|SJ0PR10MB4653:EE_
X-MS-Office365-Filtering-Correlation-Id: 9816a892-7e12-4f1e-dc05-08db810569f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nuI/7W+yGuTKBqyyaK24xBcCgimtKsN04ihPIY11WP1sKifwWmNYCBL/6y3y7MWLRyNn7b4co63YfgeV0dgIjrv8xV90Bftug/oTU+W2+dIT4l7vxMQkoD8ZhjPFJRqqNG/0xoma3KmyFRT9vfGcMOBBQrU+x6oq1aPt98FKbpv1e/I3yPeuoOpzt92okuKoFK3EWwF9qxkgXrJXQiV4q4/ePr8KiVnMYQNkjHktoS7zjfXN9DJP0KgUD3TejnkWLW4N4fBkRx1LUsMSRHreZWGYp8hs6ID1Z2zHdZgGUsgGFjoaoPDcHMtQVShjSi1TIa6ff59noH3NO87tEdH9L+GArZwcoPDqYV2GLa3WC0iHcLbkwbpb3Ag0VBOkNZNh0p9AxD8FGGfRUP+jBeYVejurApuE0/rtgi+mJ1D4CSZlsu+WhZit0U7ubjgSDBKm8ZtBUV3j8Qp/oVBbbOR7bpkIvLW1SNpLnZEBUdlj23WrdXpELdrJR/kyDO53YhOPA7lL16YwDdGvkjDR78rrGjXROiMgX4t9XohxaxCbtvIJd5VyLRMIOuEQO1qcIdkTewHbJykJNxrx0Cnzr+8GEHIPyx8ayIEgMXNnn3zjA/B5/9h1OEpeU4Kf1myAHElzObmJdNVByCNTWH7PAWxnSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199021)(4744005)(2906002)(41300700001)(8676002)(8936002)(44832011)(36756003)(2616005)(26005)(186003)(31696002)(31686004)(6506007)(478600001)(5660300002)(6666004)(6512007)(86362001)(6486002)(316002)(66556008)(66476007)(38100700002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2JKNWFiU2xOdzJVSkVmMmlOTmIyeUxpSG5rNjFrdTgxaDNFSC9tRjJtYmEv?=
 =?utf-8?B?WGtRcGRkdkNuRmF1a21Uemc2N2YwTkVOWm9TYXNYVnZSb1FsdHM3cHZuQSt6?=
 =?utf-8?B?aFJHTkdFdlNTZ3NEcjVmMDVhTmY2Mkswd0pGU2hhQTZ1R20ycGNCQytHOUJI?=
 =?utf-8?B?MmVYYzlPenJxMmc2eG0ycFJEdnNtT1FKNUgvNER4ckd6V0lEUk9OWjBzMEhu?=
 =?utf-8?B?MFZNTG1lSHBJandDRzdrNC90OVNKYmd3MWdJVHd2djdUWGh1azFwcEd5WUZG?=
 =?utf-8?B?VUdlQjlzZk1EYUJFS0YxektlTmEzUUowTHk5UkhzaFVYVGc2UWJJdDlScVFC?=
 =?utf-8?B?cEZoUWtHSkpVMXlJM3M1bE9qc1VoRzhmVVRzOU9pSVBTb3dzQnd0eExyRE50?=
 =?utf-8?B?c0lKaW1wM1cvWkU4ZHJlcHlSd3dPNC9JcU5sbmt0MU5TR080ZXBaQ1VxSklS?=
 =?utf-8?B?QWRCWmovTTJJZFpMbTdiQzJxYzFwWUF6ckFEd0lPSWhXd05pdlZwOTd3dUtZ?=
 =?utf-8?B?V1JPd0ExdGtCRW9VWjlkYnoxcWZ0YTFFOTErbFVseTNJcFVwNHJBT29MV0wx?=
 =?utf-8?B?d0tYUE5pNU9BL2VBOW9HZ1FUb1F6QStFTmhmdWpCaUxEYmRnL0lJZi84cUhJ?=
 =?utf-8?B?enFaOWFiZ3NmNVY2bE4wOXZDblpVZ1pueGxPNENrUkZRcnhhd2JRYjlvamFX?=
 =?utf-8?B?dlV2ZVptMmd6NDRBdk56S21nOWt2b01Db0pPZDFROGVjLzY0UXo0eWI1SkU0?=
 =?utf-8?B?b0dnUTYwdk5odUNJL2NMb2tRVnhCKzZIWXFLOER2MUhNc2dEbnNFWWN1VGYx?=
 =?utf-8?B?YXJhOGdtWitoTXhXcVlLSWVWQmJLNU4wdEpCNU83WTVlekNvRVhHZ3Z5TUxC?=
 =?utf-8?B?V0cvNzRoTC9jT094amE4SGg2REd2UVBHazJRdWQ5bnA1Q2pWdEFZTmlKZjlO?=
 =?utf-8?B?SS94ZW52YWxCMElyK1U2dUJON1A3bGhxelBOeE5UNE9KSVg0bWZvNGU2bEJn?=
 =?utf-8?B?ZDJvM0Zqcnhqb2RoZ2F6azgrWUZzbGZTc0k2TTVRYmltRzVuOUdKVDlia1VD?=
 =?utf-8?B?YWZRRGxEM3JpalNTNWNrUW5TSWtOVXBPZG0waFVHd2hqTTd2ZzY5aXRXY3RK?=
 =?utf-8?B?VFh0RUg5RXFtcWZNSmFWdzN3MnE1aE1Zc3liNklHZHFHRTBhb1dsaGZDclhF?=
 =?utf-8?B?RUlTY0JvTkMzY2RhZ2wvWnZZTEpBNitwRFNneE1TOWhJTjdRUTVwWHVTbWtn?=
 =?utf-8?B?cGFSbDBiQm4wdHM0VERZRDFDa3hZcGx3VS9OeWdBRnVjdFdYRDVDNkFyNFdZ?=
 =?utf-8?B?eFNYSi8xY2pzRGpRYk5NaENhUWYwTURPUzZZKzQ4S2w3ZjN5UWMyNXloanNm?=
 =?utf-8?B?QVFYUktWQ2t6MWVIRTNJOGltTklHWDVOWWdJQTBlbnNZMHowMEJoaE1QaTBl?=
 =?utf-8?B?UllTY2tObGQ1RytSc251ZEQzelU4NmVvZDRSMDVEaW5Pb1QvZ2ZBclZ6Wmxt?=
 =?utf-8?B?S3RReXRkdDlnMXAyaEFYSmozNXgxYURxUGVlaDBEdUI1T2loTXlGeFZRcE53?=
 =?utf-8?B?emlnc2hPcmd3V2JyQmFmblF6YjJLTVVyN0thckoxUTRWYXNCdmZvM3pqWHlM?=
 =?utf-8?B?dEthQi9QZFQzNXJOcHFQbFIxZEJrQUl3ODIwbFBEKzN0K0lxekZ3bmJhN1Zr?=
 =?utf-8?B?a3lVazNmUzluNThvWVd5QktqSzcwU0NJTy9sM2ZuMkltMXdNRmJlUmxWb1Iv?=
 =?utf-8?B?Y2tIZVVxVTJNS2lMTlF3ajdqMzQ4aW5ncWUxdXF6d2lDMjd4UXFlUWFYVCtk?=
 =?utf-8?B?WWlDdVgxanp4aHVqMDQ0Ymx0VTJ0SmxFR3VzeHRWQWthdHBaTjJkTVV4VWFD?=
 =?utf-8?B?b2RvWlNydjVmdmI0OEdDTE1kWkNjUHBTbTVMNWhENjZPTmFiaWorVmZhOTMr?=
 =?utf-8?B?aUI2STlmZ2hDV205a1VWOUJTUkVIbHJOem5KbXgzQmlMSVdSUCtIZ0VwVTlH?=
 =?utf-8?B?Nmlsdmk5NDloTkpHSUV4cldITEFaenRlQnU3WFR6KzB4dlYzVERHbm5TdjNG?=
 =?utf-8?B?bkdzUnBpQi9obTBhTkltRFZwRURzaUhCVWFSVlUwVWdwV3RlQkJNVk5EMjdG?=
 =?utf-8?Q?fY96rKaB2sHiYVbHY4AnGrgre?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?V0NHbXlvWDZJaUpkVm95MHoxZ3JLd3phTjJPSWZNVko3SThxZzY5L0t5cWtv?=
 =?utf-8?B?UlYvdTBYZWRPb0FaZmdhQ2dxOXA4d0N6c3dVME1PNWxGdkYrMzNwZWllemtB?=
 =?utf-8?B?b2ZKZU82OTRjaDY0Zi9RcmNHNW1xTHN5em1RTjViaUVNbkMxRzZOUVQrdHc4?=
 =?utf-8?B?bmJmQWJsNzZTMWs5WHdnVkNpeFVWWllYWngyWm5EcEliRmdJMGxCd3NkTmtr?=
 =?utf-8?B?Q29lYnJQM0pZcVJjd21sYzRibEh3N3NtdFZVNUc3cnB6Z1UxZzFWdmgweHJr?=
 =?utf-8?B?ejhWMStESkYra0ZjakpCOHREMXV2TzcxcmdQMW9VM0lDNVltbXVqWXpVV1VC?=
 =?utf-8?B?Wkp4TC9kMURtNlVTZ2tDU2xZckduT0tlWTROdnBtbUNtZW52ZjJjT3Z5Qi9q?=
 =?utf-8?B?cHhzQkVFTnVtVGZyVDY5QWhwdlkyNDNMbm5oQ0l1ZXA0YVM2UngwWVJlbXdZ?=
 =?utf-8?B?bmh6NG1xcnhKbUcwNHk3ZUg4bEZGSlduMkF1akQxWmRTQVNZMFRVWUxURHBT?=
 =?utf-8?B?cTBKMkc5dlhHak9NeS9MeXozSlFRTTZYZ0JPSWV2Q2x6VWVIY29PbGtINXht?=
 =?utf-8?B?aXZWdlh1V1oyd0ZvaW5EN29ob3AvWHg1dG9MUGdNWGFrY2FlblZ0V0xYZm9V?=
 =?utf-8?B?UkVLSE5FRXFBVGxmcDdiWFhIWFRCYWM4N3pWK05JU2l1NGJvcVpHSktTWUt1?=
 =?utf-8?B?TUlRTzRnQ3lWZWNLRnU3cDZWRWVpa24wMHhtSTVpdkVsVi9EdjJqcEIzYmtJ?=
 =?utf-8?B?U05OajRoMHVwQkszNnRmT3RmNWRoUmhoNVZSblg4M1orVjJPZE5TOE5ZN1k2?=
 =?utf-8?B?ck5WVTNLUnNiQ1hVT3Z3UTlxTE5RaDgvRXQwVU1Oa0JPQVArYkpaSFdyL1NQ?=
 =?utf-8?B?bnlZREMrcjVqell0TGdleVhkQVFjeENaVnhnaXlCN1FMQXk2SndWNC90dEIr?=
 =?utf-8?B?WktaWkNkSkdzYjBPNnI5WER6a2FSa0tPYmN2QTdqUVFiZWxKaFNxYk9hVjcx?=
 =?utf-8?B?cmNoOElkalQ1ekMrTW5jdkpacUVqVmJDeVkxSFZQMWVoKzRJV3ZFSHM2VlFK?=
 =?utf-8?B?MkRQZWFaUm5jU1RIWDRnQlZ1STdNVUR3TG1qbXNCUkRYNkl1UVBkSEk3MFBk?=
 =?utf-8?B?SWVOQ2Jmc29QWWZhVlBFYmZ1WFFsNWdHZW5Lemg1Z3JTYkRmdkdueVN2dEgw?=
 =?utf-8?B?ZkNjNm9hazVTRjhpWXhCZTFRNlo5NDR0ZlVITGhuL3FSSmUxUTN6cE03ZktN?=
 =?utf-8?Q?XwWQkchCkNcCWx4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9816a892-7e12-4f1e-dc05-08db810569f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 05:20:45.9932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HFmlcrbRgDLAw7MhkGy5Vwa6qyksgXrUUqjyHlAyw9SouNU0eg6pDmhiP5bj+0j+XRjW0FqjH1Js/Kfe2OKCYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_04,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307100048
X-Proofpoint-ORIG-GUID: eLLuXFhucO1z0DSF91GSS1TGuX1kyB9R
X-Proofpoint-GUID: eLLuXFhucO1z0DSF91GSS1TGuX1kyB9R
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


> diff --git a/tests/generic/613 b/tests/generic/613
> index 4cf5ccc6..47c60e9c 100755
> --- a/tests/generic/613
> +++ b/tests/generic/613
> @@ -68,10 +68,10 @@ echo -e "\n# Getting encryption nonces from inodes"
>   echo -n > $tmp.nonces_hex
>   echo -n > $tmp.nonces_bin

>   for inode in "${inodes[@]}"; do
> -	nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
> +	nonce=$(_get_encryption_data_nonce $SCRATCH_DEV $inode)

>   	if (( ${#nonce} != 32 )) || [ -n "$(echo "$nonce" | tr -d 0-9a-fA-F)" ]
>   	then
> -		_fail "Expected nonce to be 16 bytes (32 hex characters), but got \"$nonce\""
> +		_fail "Expected nonce for inode $inode to be 16 bytes (32 hex characters), but got \"$nonce\""
>   	fi
>   	echo $nonce >> $tmp.nonces_hex
>   	echo -ne "$(echo $nonce | sed 's/[0-9a-fA-F]\{2\}/\\x\0/g')" \


Also, the test case f2fs/002 refers to _get_encryption_nonce().

   nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)

Thanks, Anand

