Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3553359061
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Apr 2021 01:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbhDHXlQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 19:41:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37000 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbhDHXlQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 19:41:16 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 138Ndhsg077231;
        Thu, 8 Apr 2021 23:40:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=aOuUFDMQeGLZVclksyrkM6x1tmRZ3Q14+Zd+qfC0Dk0=;
 b=lbZT0bAF8DXN6pIPzCX3rA3iXEp7WKyQThl+qcS0XKv1l9ZbsTWJDNqpBQr/EM6qAod3
 0WWZQn/2mbVz94DDu/GfYTy7AalPxtgoTGvD0Qy8N9swxDDRKDJu2KGe5n849YYUizQR
 u/qtXgd3+dj5TZjdgErjqG06jWX8s3GaCWrr4ITNcFrGswQlvJjEb7dmnHZ5b7w08jcS
 np88i3XzGUtliEkF/nY9w/Gx/IWmamRqhXkk6I5WagMznCQ4ZVHYTGCM+nFW4izx5/dc
 cmmJuD9jlemDEHWMo8Uhr8vAlyCGW0oAD7rVChYmUnDkqc54G6oVoos3ZQ7fWW8LQhFt ZA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37rvaw7mng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Apr 2021 23:40:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 138NZNiN055732;
        Thu, 8 Apr 2021 23:40:58 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by aserp3020.oracle.com with ESMTP id 37rvb5wsya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Apr 2021 23:40:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7fm7huFYhLC+eozzp9WrCXCBbFGWl81HxAQD0mAnwfDYNIXFuXNKxB6cgY+QnjbXSa1G2G83EjfjGF7LB5UaWquDrPVjqo7tUPzr/HS60PaJNDK16aucmI3jq1pcBQPOlLsgLNFb3A28erTW69sw1/CN4G0BHYfy07e/UehriEE7qyCPLpfN+GFflV/KMNdU1l+cnoJzwPXApt9/CSdwLtOD5IsMtbHAZl08BqS8raWDNAcMDIZLUjm76RvXsU0xIitsGDU0QyFjgfEsnTBiucptgZQart53gcNJZtejVTpTSdQgFlzaVcMHzmHgZQynKuv69lK+UpkTnizfWZ30Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOuUFDMQeGLZVclksyrkM6x1tmRZ3Q14+Zd+qfC0Dk0=;
 b=bK44fvqckKcv1PNv+Bltl79hHAcUmt1kxJEmTfGt+Zz7doz58Mwcmy6PHsu7va50A2NOJlEw/E2jpX517rXbxSjcWBAwH7hB5g+FqbXLnmY3019c+1/FupKBgGX6jgNo00ErAgoHGMz1fiHmvzNFug9/NxbsZN5GiUL7PXaypnRFmr9LGQt6PKYWbt69M6d0As6bfsIgmQAQLNZw5VOvPp7BhXaGI8Erwz3PwubaFgbm/hiE1nzxyfxl1BFpqH3Z+UeEUN33wbLGKmsVr/WCP6p8ylqVX6Jd3XAEryqPCQi/knGwmrdXGUu56mDL9SoKCgJaCajsMEF7AWt0RpTLWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOuUFDMQeGLZVclksyrkM6x1tmRZ3Q14+Zd+qfC0Dk0=;
 b=mDxCXMnvMuVR4MyJVLaz8OGwUUK/03T5NFvwbrmftY70AGtIYZnRg53f7SkbFynFxu4mgpXeeJ8vVf/jjx5JZGtcnpjpv09TXrh/niCrNxVlapLUoZO+AWcGUQEPwjmtMrgA+5nav9EgaAq6SPJRHS1MlgSTiAUJwkkq9WUqeWU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB4175.namprd10.prod.outlook.com (2603:10b6:208:1d9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Thu, 8 Apr
 2021 23:40:56 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::9aa:6ac:8d40:c076]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::9aa:6ac:8d40:c076%6]) with mapi id 15.20.3977.033; Thu, 8 Apr 2021
 23:40:56 +0000
Subject: Re: [PATCH v3 1/5] btrfs: add compat_flags to btrfs_inode_item
To:     Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, linux-fscrypt@vger.kernel.org
References: <cover.1617900170.git.boris@bur.io>
 <7fd3068c977de9dd25eb98fa2b9d3cd928613138.1617900170.git.boris@bur.io>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <f0c82e93-6d21-740e-5ece-e3b5cc5a8677@oracle.com>
Date:   Fri, 9 Apr 2021 07:40:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <7fd3068c977de9dd25eb98fa2b9d3cd928613138.1617900170.git.boris@bur.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2406:3003:2006:2288:e4e2:c826:437f:ce6b]
X-ClientProxiedBy: SG2PR04CA0195.apcprd04.prod.outlook.com
 (2603:1096:4:14::33) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2406:3003:2006:2288:e4e2:c826:437f:ce6b] (2406:3003:2006:2288:e4e2:c826:437f:ce6b) by SG2PR04CA0195.apcprd04.prod.outlook.com (2603:1096:4:14::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Thu, 8 Apr 2021 23:40:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a55ca2a2-95f9-4ec0-7e2a-08d8fae7c0e1
X-MS-TrafficTypeDiagnostic: MN2PR10MB4175:
X-Microsoft-Antispam-PRVS: <MN2PR10MB4175807D5B8D98B26D52DF1DE5749@MN2PR10MB4175.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LRQA3aEMjtacYuS03g3ihk+Mcf45MeLl/jeevMX7/VveYa+acCA3TExsp7KwBGX2m8sXzM+zmEiCR77Dn48i1wjNFBHCQzYXSerpOh2hg2mPVb3BcMOl+ddzYxjs2/p6iLwGMOQ+uVgp3PvGYrerbu0cRu9FDkgvKwSIHKn86wjrISJYQl4em0YqNVMBlVW8sN2fAS9SzsmQELJdH7CxZlqIywyP6a8kaxLV4Hsbe4Ekgt2WW7dw6rsKUT0qe0095sveEi0p0B85j+P50Uz6fJqzmV14rfD/vkkHexIwHnzWfbFZ07+BdJoiSQkB3ZmQW24wKneraUDE2LnppnmKK1p5GrlR+px2qksM2RK+IWcOgqwyaIr5JL8mi6GUdFs7Ase3w6v9Q8Cw3Xk4+nE7gF0cdS2+WzeDIhBp1FT/Uy4bQAY9SBHw9aGqAKAejlm63aKP3RlOTMp04DKuNd9rtjZFwCdczL4AZKxpERFwjOruFKFenZmaCEEDJx/v8luBY7kG3LRwfiCeCz5WjhHCKieggtJAIC3twllUM8mOTaFQnrq2n/W2rVbovN00YSNsWBEYzPb599VvG2HJyYHA79e6f01G69QH3t4eDdsgvcapoQNakI/B7QfQlvXWWB/RLqrqDAPJMFGptiRmC3p48UItBm7L8BVlcWiUFFKxh89YVQrv04HfGY/NgmXWw5VWHb63KXbq+M+7iPSWFJjAYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(136003)(376002)(346002)(396003)(8676002)(36756003)(31686004)(6486002)(66946007)(31696002)(6666004)(478600001)(83380400001)(44832011)(53546011)(8936002)(86362001)(186003)(38100700001)(316002)(16526019)(66556008)(5660300002)(2906002)(2616005)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NUJCZ0p6NEN6N0dXQWpTcDdXV04xelZCVTU1Q2FadDVWckp2UnV2VWU2ODlE?=
 =?utf-8?B?NnR6am9JS053ZkhQOWM5d1VGTGhJY1pEOW5UaVdaVHd1U0QxbFdPdExrZUE5?=
 =?utf-8?B?aXQ1Zm9DSER2R2FONHBoUzRxVmxWWkdWT0g1MTZBdlM1VGdrWFI3VVNUNXBG?=
 =?utf-8?B?SXg2TkxlOGJvWjhEU2xnelVFOGd3aFdyMExxVkE5Q0h5ZnVsT2d0dHVjdEdp?=
 =?utf-8?B?TVArNmVkMUZjNXN0dnRRVmNYWDlPRTBLZ0JyOW1JOEtsQlJ3N2xWM2ttRnlU?=
 =?utf-8?B?UjlrQ1NKazB1YWg3SGF2TGh0WUhxdnBUTlQxOHdYSEVZVjJhZ3RPODB4aDF4?=
 =?utf-8?B?REFEbWE4UktFNHBCQnp2Z3AyUWFmQldWNlRlejhVSGFJb1JNSkowUW9uNkJl?=
 =?utf-8?B?QWsvWWhNQnU1dUEvK3NJNXNrSnM2ajNHNldsSXVoWlFaTE93cllHWFlJVEw1?=
 =?utf-8?B?dTNoY2QvcE1CeDlOcktZTmF4QjliR1NQZnNUZFV0WHJIS1lkVUIva3g3cXBP?=
 =?utf-8?B?UVRHWElMMFhLNStNNEhoOVd6NGNSN1FKVkRNdVloWHQ1dktERXd3b1o0S1dT?=
 =?utf-8?B?aCt3anlqRkJTNTFmampjQ0Q0RmhEM0p2MVBNUENTZzNKVzRtMlZyeGNtelJQ?=
 =?utf-8?B?MGFpc3E3NGgwVzhYcTF5WmdDVGd5dm1Kb2tyNEtGT3l0Szc1alFXUzJoN1g2?=
 =?utf-8?B?d2FxaERPRytOTnJhblhYalZ2WnpzZ3pLd1k1U01YT25nSE9rSDdNTEc5Yzhw?=
 =?utf-8?B?QTVhbUxsQWNISzBiVjRMaWFENlhuNzNBblhxSllPWWZ0T2RiWGhaTFltWFBV?=
 =?utf-8?B?dW1PY25qNlpJL0ljZ3FpNmpzUUNzRVRkNGVnYlp3eEpaY0ZoYjUzSEczcE05?=
 =?utf-8?B?Ti9WUXhJUDV5SkJDQ2pwdlBPVkQ5ME9nTGhxNFh2SHowL1AwTXczQnA2Q3gx?=
 =?utf-8?B?SG1xL296MXdvZ2ViNnQxc2JGQ045ZEVqalY5cURpNCt3R3gvQ3RlUHczL3hQ?=
 =?utf-8?B?UmNRSXl0SUprb1Q0NGRpQUF0a3dEMjhZM0JIRFJDRDRRUFkzZEhqU2l5MjR5?=
 =?utf-8?B?WldXWjVRTEYxM0NsTENBd0ROSUFHTDZaRVJJS3NrSHVwVEFDYmdqM0Fab0x6?=
 =?utf-8?B?aFhneTM3NS95THpWNFgvMmhoODkwcm5LTTcyZFRYMm9EWUlMWUhoYm1nL2Zq?=
 =?utf-8?B?RzlmZXlYdWd4TDFTUUYzd0tmSlNPZ04vaWsza0IrNUNKZUZGWGVzUXpJenJ5?=
 =?utf-8?B?TE1VVzRUMWEySGNCSmRQZmJBVE84R01rYWh1TFhsNTg1eDJ1SzlaUjNuUkNp?=
 =?utf-8?B?alV1UllvZWpybGJiVXNVTHVmdDIwcHFHVXJkeG9Ua0NMNzNrQ0NaMExEbU5h?=
 =?utf-8?B?dm85ZVd4NTdlNmdwVVRneHZyMGdETEwvaTB2MXE2aTRlaHJUVkswR0NHczNH?=
 =?utf-8?B?VGwyVEwyRjBMcCt2dys1Q1duVGNhTGZRWHJZY1FLc3crRnlWcWx6SjhTTFp5?=
 =?utf-8?B?U2dTS0lJMCtXNk9aRm5KYjVkbWRrc0o0MFBWdWo0WE1tb25lcnZaektDOHhL?=
 =?utf-8?B?Z2FiQTBrbEpOeUZUT0pXOWpoSW5JS1JjL2p3aVFsL0NOK0RXdDQ0OHkwSmkr?=
 =?utf-8?B?Tyt5dVlaYzZLM1dZbHRzVFNldmVDcTBZY3BrS0dyck5PZWxIWFM1QVErSGtt?=
 =?utf-8?B?ejNMYk1aaXNNeU1MTTdzcGRJUEFrNnZhSlh0OHJvV2lRblZBTHVTcmFPM3Fj?=
 =?utf-8?B?QjNxamlvcHJtb1VRbzc3VTNSTUVRSGpvdEFmaTgrek9RMk9PMngxd1Y5Lzdt?=
 =?utf-8?B?V2VMd2kxcG53WDNSQytibzBLcWx2R1FsbmxLYXMxTEpoTzk1NllzRXRoL2NB?=
 =?utf-8?Q?OzTVBFT2IdpII?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a55ca2a2-95f9-4ec0-7e2a-08d8fae7c0e1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 23:40:55.9321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c8cNERBMDwaU9MJYXEwyJzXs7Qsdhl4MSNuzGhkKRn8xmCGkoKQr2yjE3MnoL4UzF0DphGibYm5GBmg/Dp1vfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4175
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9948 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104080157
X-Proofpoint-ORIG-GUID: M1aFdr--4MUQZivRXsBnDodW1qMlDVVG
X-Proofpoint-GUID: M1aFdr--4MUQZivRXsBnDodW1qMlDVVG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9948 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104080158
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 09/04/2021 02:33, Boris Burkov wrote:
> The tree checker currently rejects unrecognized flags when it reads
> btrfs_inode_item. Practically, this means that adding a new flag makes
> the change backwards incompatible if the flag is ever set on a file.


> Take up one of the 4 reserved u64 fields in the btrfs_inode_item as a
> new "compat_flags". These flags are zero on inode creation in btrfs and
> mkfs and are ignored by an older kernel, so it should be safe to use
> them in this way.

I don't see an incompt flags check during mount, how does this patch 
will handle if you mount a disk with an older on-disk btrfs_inode_item 
data structure which has no compat_flags?

Why not update the tree checker (need to fix stable kernel as well) and 
inode flags, so that we spare u64 space in the btrfs_inode_item?

Also, I think we need the incompt flags to check during mount.

Thanks, Anand


> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>   fs/btrfs/btrfs_inode.h          | 1 +
>   fs/btrfs/ctree.h                | 2 ++
>   fs/btrfs/delayed-inode.c        | 2 ++
>   fs/btrfs/inode.c                | 3 +++
>   fs/btrfs/ioctl.c                | 7 ++++---
>   fs/btrfs/tree-log.c             | 1 +
>   include/uapi/linux/btrfs_tree.h | 7 ++++++-
>   7 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index c652e19ad74e..e8dbc8e848ce 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -191,6 +191,7 @@ struct btrfs_inode {
>   
>   	/* flags field from the on disk inode */
>   	u32 flags;
> +	u64 compat_flags;
>   
>   	/*
>   	 * Counters to keep track of the number of extent item's we may use due
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index f2fd73e58ee6..d633c563164b 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1754,6 +1754,7 @@ BTRFS_SETGET_FUNCS(inode_gid, struct btrfs_inode_item, gid, 32);
>   BTRFS_SETGET_FUNCS(inode_mode, struct btrfs_inode_item, mode, 32);
>   BTRFS_SETGET_FUNCS(inode_rdev, struct btrfs_inode_item, rdev, 64);
>   BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
> +BTRFS_SETGET_FUNCS(inode_compat_flags, struct btrfs_inode_item, compat_flags, 64);
>   BTRFS_SETGET_STACK_FUNCS(stack_inode_generation, struct btrfs_inode_item,
>   			 generation, 64);
>   BTRFS_SETGET_STACK_FUNCS(stack_inode_sequence, struct btrfs_inode_item,
> @@ -1771,6 +1772,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_inode_gid, struct btrfs_inode_item, gid, 32);
>   BTRFS_SETGET_STACK_FUNCS(stack_inode_mode, struct btrfs_inode_item, mode, 32);
>   BTRFS_SETGET_STACK_FUNCS(stack_inode_rdev, struct btrfs_inode_item, rdev, 64);
>   BTRFS_SETGET_STACK_FUNCS(stack_inode_flags, struct btrfs_inode_item, flags, 64);
> +BTRFS_SETGET_STACK_FUNCS(stack_inode_compat_flags, struct btrfs_inode_item, compat_flags, 64);
>   BTRFS_SETGET_FUNCS(timespec_sec, struct btrfs_timespec, sec, 64);
>   BTRFS_SETGET_FUNCS(timespec_nsec, struct btrfs_timespec, nsec, 32);
>   BTRFS_SETGET_STACK_FUNCS(stack_timespec_sec, struct btrfs_timespec, sec, 64);
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 1a88f6214ebc..ef4e0265dbe3 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1718,6 +1718,7 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
>   	btrfs_set_stack_inode_transid(inode_item, trans->transid);
>   	btrfs_set_stack_inode_rdev(inode_item, inode->i_rdev);
>   	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
> +	btrfs_set_stack_inode_compat_flags(inode_item, BTRFS_I(inode)->compat_flags);
>   	btrfs_set_stack_inode_block_group(inode_item, 0);
>   
>   	btrfs_set_stack_timespec_sec(&inode_item->atime,
> @@ -1776,6 +1777,7 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
>   	inode->i_rdev = 0;
>   	*rdev = btrfs_stack_inode_rdev(inode_item);
>   	BTRFS_I(inode)->flags = btrfs_stack_inode_flags(inode_item);
> +	BTRFS_I(inode)->compat_flags = btrfs_stack_inode_compat_flags(inode_item);
>   
>   	inode->i_atime.tv_sec = btrfs_stack_timespec_sec(&inode_item->atime);
>   	inode->i_atime.tv_nsec = btrfs_stack_timespec_nsec(&inode_item->atime);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 1e0e20ad25e4..3aa96ec27045 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3627,6 +3627,7 @@ static int btrfs_read_locked_inode(struct inode *inode,
>   
>   	BTRFS_I(inode)->index_cnt = (u64)-1;
>   	BTRFS_I(inode)->flags = btrfs_inode_flags(leaf, inode_item);
> +	BTRFS_I(inode)->compat_flags = btrfs_inode_compat_flags(leaf, inode_item);
>   
>   cache_index:
>   	/*
> @@ -3793,6 +3794,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
>   	btrfs_set_token_inode_transid(&token, item, trans->transid);
>   	btrfs_set_token_inode_rdev(&token, item, inode->i_rdev);
>   	btrfs_set_token_inode_flags(&token, item, BTRFS_I(inode)->flags);
> +	btrfs_set_token_inode_compat_flags(&token, item, BTRFS_I(inode)->compat_flags);
>   	btrfs_set_token_inode_block_group(&token, item, 0);
>   }
>   
> @@ -8859,6 +8861,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
>   	ei->defrag_bytes = 0;
>   	ei->disk_i_size = 0;
>   	ei->flags = 0;
> +	ei->compat_flags = 0;
>   	ei->csum_bytes = 0;
>   	ei->index_cnt = (u64)-1;
>   	ei->dir_index = 0;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 3415a9f06c81..2c9cbd2642b1 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -102,8 +102,9 @@ static unsigned int btrfs_mask_fsflags_for_type(struct inode *inode,
>    * Export internal inode flags to the format expected by the FS_IOC_GETFLAGS
>    * ioctl.
>    */
> -static unsigned int btrfs_inode_flags_to_fsflags(unsigned int flags)
> +static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
>   {
> +	unsigned int flags = binode->flags;
>   	unsigned int iflags = 0;
>   
>   	if (flags & BTRFS_INODE_SYNC)
> @@ -156,7 +157,7 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
>   static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
>   {
>   	struct btrfs_inode *binode = BTRFS_I(file_inode(file));
> -	unsigned int flags = btrfs_inode_flags_to_fsflags(binode->flags);
> +	unsigned int flags = btrfs_inode_flags_to_fsflags(binode);
>   
>   	if (copy_to_user(arg, &flags, sizeof(flags)))
>   		return -EFAULT;
> @@ -228,7 +229,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>   
>   	btrfs_inode_lock(inode, 0);
>   	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
> -	old_fsflags = btrfs_inode_flags_to_fsflags(binode->flags);
> +	old_fsflags = btrfs_inode_flags_to_fsflags(binode);
>   
>   	ret = vfs_ioc_setflags_prepare(inode, old_fsflags, fsflags);
>   	if (ret)
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 72c4b66ed516..fed638f995ba 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3944,6 +3944,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
>   	btrfs_set_token_inode_transid(&token, item, trans->transid);
>   	btrfs_set_token_inode_rdev(&token, item, inode->i_rdev);
>   	btrfs_set_token_inode_flags(&token, item, BTRFS_I(inode)->flags);
> +	btrfs_set_token_inode_compat_flags(&token, item, BTRFS_I(inode)->compat_flags);
>   	btrfs_set_token_inode_block_group(&token, item, 0);
>   }
>   
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> index 58d7cff9afb1..ae25280316bd 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -574,11 +574,16 @@ struct btrfs_inode_item {
>   	/* modification sequence number for NFS */
>   	__le64 sequence;
>   
> +	/*
> +	 * flags which aren't checked for corruption at mount
> +	 * and can be added in a backwards compatible way
> +	 */
> +	__le64 compat_flags;
>   	/*
>   	 * a little future expansion, for more than this we can
>   	 * just grow the inode item and version it
>   	 */
> -	__le64 reserved[4];
> +	__le64 reserved[3];
>   	struct btrfs_timespec atime;
>   	struct btrfs_timespec ctime;
>   	struct btrfs_timespec mtime;
> 

