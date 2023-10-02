Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7907B5112
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 Oct 2023 13:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbjJBLVe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Oct 2023 07:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjJBLVd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Oct 2023 07:21:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D8783;
        Mon,  2 Oct 2023 04:21:29 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3928XS0r027203;
        Mon, 2 Oct 2023 11:21:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=dd37BmDQgCf4bqr2TuLgKtinIycZ27TJhv2TxXjYYjk=;
 b=IZFPSSuL1lgxdIUqOZ+ly6TFCd7esNLiENzu9mgdrwt4geXE87b5asW737br89C/eZjg
 xktS8gJRRREFhccpPSMSw0ISEiSNYDEUht3HyO13dP4G+qiwhuxCNYU/J99GnmSIuqve
 6fOCJBw+kZGh7V+m9wje/3X3Tp3D/zfXQXg8YI1LqeMhsYUBPLda7oUzA+DKaRZ0V9DO
 9VAg/UmlqKBvMpCAxvWPMr0f9QoB2KhYZfh0mdh8aD8+exKla00j2ruBn1Z0SgNG9AAx
 4Uv3Eds+pNWXHmCtXl3kYVEuedS4we8CL2HzNkBrMwgvibVTCF82qfn+GbN13rQ5I6SU sA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea3ea9yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Oct 2023 11:21:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 392AWOLp025752;
        Mon, 2 Oct 2023 11:21:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4aw0tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Oct 2023 11:21:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvPhYALBixjuLgvuQ2rFFKwU/KkcsEX7RcNM1h2NQ52L9lM7zq+hGn5RLO/tecWPOtV8k2p2IIV3LPOSohOZ+1iXd3JZ3EDYEtGebrpwL+u3KfEguozXLlXIFJaQks1oO5wf3YRkANktPYKqT/hrfNQJYhFteBJDOHFfjEMG6Gf5eiYzgLcTDLj+XZrpBmdtJdgkN38zJsuxVxF/i1cVMGnQynBu/mmXJwmMLgeolT/efKYc4SamG+4n4Vk4usPXMG3uV6Tcfk1B20sKBfQygHBVY2+AhW41DNQH7fkZdRO+FNN4k5F8suGtdzZVhd7zL/qGXJGplJTfq2lj2ztR/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dd37BmDQgCf4bqr2TuLgKtinIycZ27TJhv2TxXjYYjk=;
 b=kSaECrOzKgd+Za5xS8mJoc7U6D95ZJwq69edScn68LCGkX5jbeQXUuqozN582mBbWwN38/LltYsF3bD3rZIppevXc9MIcJd03Ft4AQuhSp8vz0AcVUXmqvyBmXhsbHeH51lMrTfFN+3cj76VDJ/GtHUQpWCHEEUeyraIpDaCNMaaVNUgA/CDI0dwTNOaDf15cYVeUaobPmKmKxcOtbm8s+vi2grjfjT7ka4Zmvg9nU9JBiFFpWuUoVbWvLW04AlYcZb3nwJ9+tMZBiHReSlsKroVXaS3qitvBFbGkPMRydaRE9O7AWosFQHTFQsEx+m7WfsgylatwZZvMR3aJDJnUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dd37BmDQgCf4bqr2TuLgKtinIycZ27TJhv2TxXjYYjk=;
 b=LTiUtyN12mCwV62KKPKt+HlD0h2RCpNn8HwHrzCukdvvEJ+d/se+KBFbY2hbm9e7yar/DyQBrZGoU6HBniFtA4iANy3iEp8nCAnsYoYxu+55At0MZnoYbCpi2cNwn5R7Mx+LG73hxFz9xBWLMwB/6UWEpl5ti0dUjpMXXIQiR80=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by SJ0PR10MB6429.namprd10.prod.outlook.com (2603:10b6:a03:486::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.27; Mon, 2 Oct
 2023 11:21:07 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::2bbc:60da:ba6c:f685]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::2bbc:60da:ba6c:f685%2]) with mapi id 15.20.6813.017; Mon, 2 Oct 2023
 11:21:06 +0000
Message-ID: <a8634ac9-cadb-0aca-d079-6b6bac77935d@oracle.com>
Date:   Mon, 2 Oct 2023 19:20:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH v3 6/9] tests: adjust generic/429 for extent
 encryption
Content-Language: en-US
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, fdmanana@suse.com,
        linux-fscrypt@vger.kernel.org, fsverity@lists.linux.dev,
        zlang@kernel.org
References: <cover.1691530000.git.sweettea-kernel@dorminy.me>
 <0952e60c8e73a41a0448e3ada8172744a6882550.1691530000.git.sweettea-kernel@dorminy.me>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <0952e60c8e73a41a0448e3ada8172744a6882550.1691530000.git.sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0013.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::9) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|SJ0PR10MB6429:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d34e598-7c6b-4d89-5a2b-08dbc339a015
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uvzfu4ZzKY94DtZgiKshr8cp8wiykVwF7uLsbWHPg8N6z1lSevNOQ67WIKxpx5XJYV8QFRTzhSKeHHoZglTUOwnn2zzGwZEk8IZY8UQzR35lizr8V9GyknOCXNCFSj0JunP+wwxWAIsmK9TxcXrlmDcd26KomFD+kzaGFXWILneGdsNkVr27s6A8GRj79fGOdcKzMrRODdrtEXXyNli1wvGNIAzMN5T180mGkXi29c6o8ltHXA+mT0UvDQ8/tLakw61YR8NqycmFVdMs/UAyCIAo3kKgYCQf8I+9icsUP7yqxuDM7rCzU/DkKDbBU+DdfYzGBQtl669Lu/0YFEaKYltKLiaHMhtrCAEIUpf8UI9QNNQuF2e1WSZSO44y5uSXn7BHzdx6BKPpnjC0zI4cu05It4YYAQL0b7k1x7HF0ZiAfKkrueiFh3eu4Oee+k+snPgsIWqlbqGrP8aP/QjdsT2XrbDhCRmDeDlTYRD/XINCb/pTo86s7sYk04vE7VUaTbgTxLQyKM9Iu0GZk3NXaxUc9Qp5yv5nXHUD2paZgkjPvcs3We4uC4PAuBLJSr2U1B3oFlxjnx+ehZYgF8CPxjnaoI7oAzO+Cfg91UUAI9446p0+zBqzG/hHd96wLWkqY4/ydcdKVSkHqlbhDW1dww8ZOL8PL6UiOD7DHWWpp7s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(376002)(366004)(39860400002)(396003)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(316002)(5660300002)(44832011)(41300700001)(8936002)(8676002)(31686004)(66556008)(66476007)(66946007)(2906002)(6512007)(6506007)(6486002)(2616005)(53546011)(86362001)(478600001)(38100700002)(31696002)(26005)(6666004)(36756003)(83380400001)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a08zNnRmUHFUN29WcGd5UForbXpTWDlQd2R5NmpZcjdPWXk1bktCSGtpRUJY?=
 =?utf-8?B?Tm5OM3JaVisyRVh5b3o1RzQ2YUtQYU9uL1JLWks2Yjk0UmQvSlVxZ1VOaGZZ?=
 =?utf-8?B?YTBESzNOYlpGUlEzY3dHaldvNDRVN29CalNwVyt1VTFQQ3F2aU9pTFZpeWN2?=
 =?utf-8?B?VktkdVR6VS96VitSa3RVTFM1MGoyOGhhem1NS05WbW1IV1dzVHFWVkh6TTgy?=
 =?utf-8?B?QUMyMm1vY2hZdm5tMy9aUzluQ1k1cGpIV3JkR2hyTys1Yi9GNXd2dWdZRDVM?=
 =?utf-8?B?VGd5V29MenJFTTRlaWpIMzlBbmo4dUlXSUJrZVp6UG0yZlNiZTZkWWVrYzNJ?=
 =?utf-8?B?bkxjakRyTHJBeEZKMThXWDcwMDRtUksxcG0yanhFbTNTTEl3YVh1ZHNFaVc5?=
 =?utf-8?B?ejQ4eCtwemVWRHAvNFJqMXNYS2FQZzE1NVY2aCtWb1RKSmVLTDJXbXdzQVZK?=
 =?utf-8?B?WkRwMUpGd0hnbjZUSCtlQ1RzUldRS0VrWEpjbzhBMmpYdnc1UUFLTWF3Q1ZC?=
 =?utf-8?B?Tk80QitnVzNUZkx5dDNlTU4vakgzOGJXU0RpMGpCSHg5V3Nwc0JCZU1rRFp4?=
 =?utf-8?B?WWU2b0dvNHdpam1PTkt4aXRaTzhMYzVxVDZvY0IvTll6VG5WN1dBZjhKdUJw?=
 =?utf-8?B?UkpIam9xajJPRzdhK0NiOWdOczRyZjlOM2plRzB3UVo4Q3VLdjUweW0rQXB4?=
 =?utf-8?B?aWRPYjl2c1A5KzBzNjh1bGFaSFRkd1pTdjBNUmtMazBKNnE4ZEJlcU5hdkFY?=
 =?utf-8?B?NUdORnNxR25UMW1zanUreTV4YTFzVGNmVmtaWUFYME5SbmMvRVVJT3JZR0dq?=
 =?utf-8?B?QjMxL1lONjJPUysrMW8vQURrTGdKMVBCelpzeS9CM1dDUUMyVWEzbE9IUU40?=
 =?utf-8?B?M05Lc1NmWHFGYStudWtTL3BKTlR5aTF4d3RBN3VBZWdNTEt5VExWNzA4bkJM?=
 =?utf-8?B?dEppaGZKZnZHSzlUNjM5NFI0Q0ZMT0swRlBaZDR4Z2JnNHJyVzN2MFpjZW4r?=
 =?utf-8?B?b1dMRWV5dVlFRDNFUEdmWVovcHdENUFsaG5Lc0ZFLzU0dEd2SXdsTmthU1NT?=
 =?utf-8?B?TjFTTkdkYkVUcnVqSzk4c09HL3MwYXNtZHdMREZmclU4VmhDOUJhOURnRUN2?=
 =?utf-8?B?QkttNEVoL3k4a2ZiZjlaemY3cU45R2tLamQyMW9kS01QblZidnIvb0hKb1lZ?=
 =?utf-8?B?akVVTkVYOU1JdjhDUUVueE1VSXA0UUI3NXIzY0hteUNsUURYVU16eSs1dmZ1?=
 =?utf-8?B?M0NacTBmd092emFWNFZwdEZGMnY1RmdJeVFLQjRkVmFuVzBFV3dURk9tUFR4?=
 =?utf-8?B?WWZsb0o4VWNTRXJVVVgvOTUxUEJqeTJYMEM1UTNxZWZOOGFha1p3M1ZYQWhB?=
 =?utf-8?B?YWJxRGhVT01BQ3l4S3NQaUd0Zk56NGhXMDVITTlsb3Y2K3FDNUNWWEhGQWhI?=
 =?utf-8?B?S3dNR3pIdWhybmc3RWF5ME53QmtkKy9ML3ZRSFJMTW1zaVR5TWxJdmVPcXQv?=
 =?utf-8?B?bUVTakthbXN5MTlBbHhScEZYc091L0RNUU95ejRuYzd6N1hlYWEwc2hLa1Rr?=
 =?utf-8?B?NE1nZWl0emh1UmVQVEJCdCtRR0NsR29sUjlFeGZGVXhHUGp3L0RWTVA0b3Q0?=
 =?utf-8?B?eDVvS3pQVWNXd0hzRTI5bjZZZlJYR3FkS1cwMy9EYVVFMEN1SldFYTdoUDZj?=
 =?utf-8?B?Z2s3cmFPYjNSaW8yeExma014RzdqTkxwUU1mVGZzOFpCeVQ1SmEyOEpoeGQx?=
 =?utf-8?B?VitidDg5MEpEbGlqeXpydVlvN1NQQ1lybUlmazludVJrYUoreWdwdUhydlFS?=
 =?utf-8?B?dGpoNHpmcTBHUnJCUjlORk0zNnM2V3VuaTVyWWhYVk54LzNwRFl3K0FiZnFE?=
 =?utf-8?B?N2doeVpsQVk0Rk04Z3dtak5pSVNuUnliSFp4elQ5REZpRkxsTk10ckxMRDZo?=
 =?utf-8?B?M0tPcWYrWDhGSXFrTGRWTm4zUGhobUxiR0VCRWhZYkY5U1drTTBQMGpuc2JV?=
 =?utf-8?B?bU9GY1oxOGJzMC9CbEN3R3o2Q2ppbVJLNHkwUXNlTXpVNzgwSTZxcHdXTy8z?=
 =?utf-8?B?R3FURFhhMSttR0UxQ1V6YVc5ZG9RSWprZHQwa1FzMnVmL0pJOWI1azhVVXBi?=
 =?utf-8?Q?z56u7Hq80/dZrH6u+n5JP6hvZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?a1hrNEh3ZG1yb3N6VU9KUXV1aStmRFUvei83cmdJVjB0RVRVMnRMdEoyR2hY?=
 =?utf-8?B?bVlZcCt3ampWR1psMDJ0OEF0RUlDMTQ2V0tBZlZQZWp2VTlPMFRKKzZ2Snhh?=
 =?utf-8?B?Q3Q5emdjaW5wKzBOY3k5aSs4dFovczdmdFJOYWN5Vk9PdnJrQk1mb3JpV1pw?=
 =?utf-8?B?dHZnb3ZYRHlUTmxPR2hCRXZUK2NUd1grQlkwTnl6REttYmdEWHo2TVN6Smxl?=
 =?utf-8?B?bnllRU9ONTc3L1ZQQjJuMXphN1AvNDA3ZEFrSG1rZUFWNXZnNUtZYSt6NTQv?=
 =?utf-8?B?YnpsU1YwcWtIWTArNy8yVTBDaWRiM2xpR3ErdERFS01SSWJOWkZzYmJrNG9t?=
 =?utf-8?B?Sk8yMTduaUx6cENucDg5TnMvZWtvRzdISEJxUHhUakRnVndFQlZpNVF6Vzhy?=
 =?utf-8?B?RDhTaUdDT1hadXFidDFET2pIWFJxR3hYZm9UMDQxVDIwWms0d1dsNit2dFlX?=
 =?utf-8?B?SCtBY3hyQkZTYUFraXhFN1FBVFhMT2MyZ1JiZEw3RUR4NTg1UDlRQThjWVRO?=
 =?utf-8?B?UlIxaVpYdDN5WG9QaDZrcS9YaW9TS1dLUkxOMjAxVCtjcEIyTXJMU0k0NVU1?=
 =?utf-8?B?Ynd4VTE4bGkzaEs2WWhvMGNuNTk3MUJVOTlMMlBFZ29pNWtRVlR0TVNtZTBY?=
 =?utf-8?B?ZHZWb2t6aVFhZkVnUUFtMWRFVm5ERmM1Rm5jU2JKajNzMWxGbktkbEpFVlMx?=
 =?utf-8?B?SnpjcXlicGtkQnBBem1zeHByNzlFMjlhUGNxdlJ1dHhZRnkvUWZJaTZmanZH?=
 =?utf-8?B?cWlSaUw1SE82UUFLQ3Bwbk1FcHc3NVoyOXJFY1dydUxZYVRodDk0c3NRekV4?=
 =?utf-8?B?UGlYZmJEZDkzT0FKZHVlRHpxaEZUM3hGdDdFZ2ZuaHFWQTNHTFBiSzVSZWJw?=
 =?utf-8?B?N1ozSFNUWEloNEl6U3Y2WVJpSUt3UVN2N0piNVFvSHpVU3Q5ck5zR2tVaTY0?=
 =?utf-8?B?NzJnK1prQklOaDJNQ1dQTDY1K0ZycEpLb2FlRjY1SFl6dEkxUzMrQWNPRjgz?=
 =?utf-8?B?TlFTTFJnNFBsc3UyRTNFU3FHQTdKZHlteTB2dmJqb0ZNN2dKSTFBanI1M0JC?=
 =?utf-8?B?NzNiZ0ZxTmpYWEhvUW5UREFLWEJ1M1IzbnVNTER1YlRJSWFiT1h4aXNhYlI2?=
 =?utf-8?B?bC9IWG1rejdWRFR4Z3Q3OElEd3hNWnM1VmlGRExzbThQQkRoNis1UlRLSitQ?=
 =?utf-8?B?eHhoc0Z0Y0d0aGhVS0xvOXlwSktxK1drUXUzdE9ua1BzSUcrMHpvRTkvV0tT?=
 =?utf-8?Q?w57F8PA+uUo8GHc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d34e598-7c6b-4d89-5a2b-08dbc339a015
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2023 11:21:06.4289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OSxBmO1VBwSVbqI1P7d7bGARsVNhDhOnB/TVz+U8C12EHnQsskxjawkdoHls31jP7Bg9G1k8OyNsF5PrVEDsTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6429
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-02_04,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310020084
X-Proofpoint-ORIG-GUID: Z0kN4ma1bve8wzLuhjF0temoyaJlbgXB
X-Proofpoint-GUID: Z0kN4ma1bve8wzLuhjF0temoyaJlbgXB
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
> Extent encryption is different from the existing inode-based encryption
> insofar as it only generates encryption keys for data encryption at the
> moment at which the data is written. This means that when a session key is
> removed, even if there's an open file using it, that file immediately
> becomes unreadable and unwritable.
> 
> This isn't an issue for non-session keys, which are soft deleted by
> fscrypt and stick around until there are no more open files with extent
> encryption using them. But for session keys, which are managed by the
> kernel keyring directly instead of through fscrypt, when they're removed
> they're removed.
> 
> generic/429 uses session keys and expects to use the written data after
> key removal; while it's not quite what the test means for other
> filesystems, most of the test is still meaningful if we push the dirty
> data into the filesystem with a sync before dropping the key.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>   tests/generic/429 | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/tests/generic/429 b/tests/generic/429
> index 2cf12316..1d26deda 100755
> --- a/tests/generic/429
> +++ b/tests/generic/429
> @@ -68,6 +68,12 @@ show_directory_with_key()
>   	show_file_contents
>   }
>   
> +# btrfs needs to have dirty data pushed into it before session keyring

> +# is unlinked, as it doesn't set up the data encryption key until then.	


  A whitespace error in this line.



> +if [ "$FSTYP" = "btrfs" ]; then
> +	sync
> +fi
> +
>   # View the directory without the encryption key.  The plaintext names shouldn't
>   # exist, but 'cat' each to verify this, which also should create negative
>   # dentries.  The no-key names are unpredictable by design, but verify that the

