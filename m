Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E101C8D71
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 May 2020 16:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgEGOEC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 May 2020 10:04:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56676 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727946AbgEGOEA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 May 2020 10:04:00 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 047E3mwu002187;
        Thu, 7 May 2020 07:03:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Cc8ItZAjFMPekqUhwwXDSK/IbhM1+H37NWTu4SbfoJU=;
 b=S9Q7qzuawC9rVb3t0+4faMT8d5cqmLloP+R5lqdZLJqlIihwSiDeGwToUtjS90DoKOTO
 n/pqf7VVMKoCFQZR5cbEQo3INzNhi/Ow1slhVvnFszeNJ82zGsv3aQ5GevzW0Ow2x6pA
 qZkJVEIS4fHB3l7lBnMxWzeRPg89M3ZydJU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30v0hp5gag-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 May 2020 07:03:53 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 7 May 2020 07:03:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayMdXB/8CbJOlmk4+4/DhtfziFpnXOS5y5T93d6uXLYDPpYXov43MvXzIhULBX3FmZiQ3tI807JPbvlzT3BESgBQxzOpzStUVLZhdWIFV66j1PbiXgE5+tLZukSu5kMRhdjVI5RxghbkNIVDgNCDbZyVID4Q9TX/mHKtUHYIB7RUy9spasw/8tZlxYLuZzUltrLyMtRALxsMtPu5bNjhyy4QaABWV65DsqZkSJmgJN0yrLoi0bMgARh0abYnOejxceXDlZLyVX7f5U08q7nOSKDH/++FRx3QrgUswToAzvM0uPXuFezxWjNJwNnhXdkJO9pxbkoYYqO4+0wxbGXa7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cc8ItZAjFMPekqUhwwXDSK/IbhM1+H37NWTu4SbfoJU=;
 b=U2wBUi0vOKIwjE0zEMf7zyRIX1vEw1tBwkYDPu0Yebs38M9gyOHqhfeZofnHzPgdU2l+QptHwIKl1T2jTh6T27vbqiSfAqUIZrFxx+FcD2kz+61+Y41JH88cne/KVrJx2jg43Gv1loto3c26wvV1nVi4578j5br2Dj0ICj1CBx678Usas4tdNQ3Zm73LPmddzjA1nCzZob6DL5e9Yb07tNJpoHQE2169OJ6tfSD3zX0Tm6mgjQif2O8dSIs+havieNQVLlzaQ9b/4G8nbjDCKD+TkAzjHNxfgz25ddfGe7At63jgWCkrDl3+kh8DHL8yDtKAnHJ41nLrBV/tfh6jHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cc8ItZAjFMPekqUhwwXDSK/IbhM1+H37NWTu4SbfoJU=;
 b=Jvejq9rmmPSgscJmYHvOgiZslXbbJh4qAXyuJ0QS/PwjVSavq1CSUpM6L/oXb4O1vVKpjj6U/XWu/vbOxZJD+KHp6zZbbual7YSDulMJL0vFDklFGwKAgZ/ZOCrlq/Sv4rfhhO80+IQ3xgyk84XwzHW62sPB7K0/dkfhP5N+PxM=
Received: from DM6PR15MB3276.namprd15.prod.outlook.com (2603:10b6:5:169::30)
 by DM6PR15MB3611.namprd15.prod.outlook.com (2603:10b6:5:1fa::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Thu, 7 May
 2020 14:03:49 +0000
Received: from DM6PR15MB3276.namprd15.prod.outlook.com
 ([fe80::40f3:1cdf:454a:48d1]) by DM6PR15MB3276.namprd15.prod.outlook.com
 ([fe80::40f3:1cdf:454a:48d1%6]) with mapi id 15.20.2979.028; Thu, 7 May 2020
 14:03:49 +0000
Subject: Re: [PATCH v4 00/20] Split fsverity-utils into a shared library
To:     <ebiggers@google.com>
CC:     Jes Sorensen <jes.sorensen@gmail.com>,
        <linux-fscrypt@vger.kernel.org>, <kernel-team@fb.com>
References: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
From:   Jes Sorensen <jsorensen@fb.com>
Message-ID: <81e0cd1f-620e-5ac1-4de5-1d9bbafde8cb@fb.com>
Date:   Thu, 7 May 2020 10:03:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0042.namprd16.prod.outlook.com
 (2603:10b6:208:234::11) To DM6PR15MB3276.namprd15.prod.outlook.com
 (2603:10b6:5:169::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11d9::1100] (2620:10d:c091:480::1:d1f) by MN2PR16CA0042.namprd16.prod.outlook.com (2603:10b6:208:234::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Thu, 7 May 2020 14:03:49 +0000
X-Originating-IP: [2620:10d:c091:480::1:d1f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8212f32-ca2e-411d-5521-08d7f28f7774
X-MS-TrafficTypeDiagnostic: DM6PR15MB3611:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB3611884094F428CC6227A79EC6A50@DM6PR15MB3611.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h16US3WI1+lkorW63p/WjXIC7I0c61RRNlsd8XTO7ehTfso2ucHeBncFayzYSID3Xyje7tkfnH1JCFvbRNI/XQqzKmBo7Obr9bm6G5r/6XLCOsNI7cITq4kPrvKXEDgPloIlK+H3NYQbVcV0y5reCKqPTg+65X3aRuPSmCLp3SWVDuxnLbHw6hXdsSPyoccT/0VNX12RPoIOgLeaNnb5f8W1f9TW8E2T4h9ZugckOL6e4XOVZ31eVohIJJLBzO3ZjBPE+V87rIfHdG/lZrtTPwuuamcJbVWdrQmSlyu/X5BlmCLLDkCHZ6ZM3kXOxg+LEWezm2KYbdDqs2QBaga21brm8Cara/vRCon32G8+JtpqKZlnEODRDCKSEcgpo01/mdpZdr4G0ytgmpwLS3ObvODMKU3JBUF83PxQS8wv9u6nNAblLBd8G5PR5AaniiQJZL0XGflTgyZEzvKycFyZPATvHvMpKpMyDQ+PFeyAjM60LOGb+4VpS5BRHEmg9RcvCbGgfIyjEG41qrYhzK1NezZ2NLBLtq+Afcna7pcTPE8DJ+bIz9RAgzG0VVMbkEtELUjHJm5FC6WAidpI3ME3plQSVyEq4f0SFgwhl9spV6kA3ZX7fyZToy7/w8/qI7K+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3276.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(33430700001)(6916009)(4326008)(966005)(316002)(36756003)(83300400001)(5660300002)(86362001)(53546011)(2906002)(83320400001)(83280400001)(83310400001)(83290400001)(186003)(16526019)(66946007)(8676002)(66556008)(31686004)(478600001)(8936002)(33440700001)(66476007)(31696002)(6486002)(52116002)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 2KstA1tV9QlFqyiTefvUv4BvlHqgFmoppxFzv2qfATTJgoC1ZtiCVaahQ9Qi3nKO3gpEwLv97iFLcYJ75F5JN9le3VVoaWm2KiTLcRCmoJex21HSFtv5xDzYN6DMIqDurwJpTc6cV4lJ9EMuKUSIb+OZpJkCDUuxXtmyCXPWwVovDyRBdfMsP1ftdgzUFSJRTcv3hMFxUNBVn9MEHt6CQCweJmSNlkbWdiFreOj+RhNSq7EBeSa7URRO2MWaCq6qwygZpUVxNHrbpr7knGxESy7l8sWQdCYcjIU3oQ+uVvRG9VaefQaEw2JQIMvk1qqoc4Dq52q0f3DnwA1wdzAXQ+uJEgP2abyegQcrYsmyEq3VuKv79Z7C9pyuUSH2p6NfuZYEBZ1aoVdl+/F2KSighwUa2zSamzzVzdxCmupcZbIhVSRHMikaRltfkGBu5ZX72phT2xswgLibOTY4axPwn+Oz0fYN9ogNlEHeGhSkMOXhfpt8eC6LfJ3wsf2rwMKcmnkifPLPE2Zo5oBvoCad3FZm5yd15AahidHHXlbxWPPBLvLY258xC2tg38p/zCJexQ4rQUNfq4eC5eWDV0cWzd3/707Bgb0XRaWFvK9YyfxEs/ceKjExC5dbZN7Qql0AI5Up9ZzyD7mYh5G+Vq2ht3W91k4g/LYmwoGCldDh/RiFZTxmyBAZ2/bxwP6/gfLuc7nMwWuMngNO/3yZA9WVBuYC0EAgXpg6E2hpWbHYyWRzmvEYV9MukuP67emycbhAOgw6Wim2ueT3t17Jeo//6XQgEi/UrC9cXkT1r4VLJWCBWtl6EC8U4tnLHO1DnJUi2HnqoROIsYYQKzB3YSRRRg==
X-MS-Exchange-CrossTenant-Network-Message-Id: b8212f32-ca2e-411d-5521-08d7f28f7774
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 14:03:49.6401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: De+3CWX7RZozCRoiV7733/gnSegm11E0f3epTKywPcUYGu8t1tADq5ZZDnhsBzVQ77enXNIgkHpCS/lrw6FGIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3611
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_09:2020-05-07,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 clxscore=1011 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070114
X-FB-Internal: deliver
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 4/24/20 4:54 PM, Jes Sorensen wrote:
> From: Jes Sorensen <jsorensen@fb.com>
> 
> Hi
> 
> This is an update to the libfsverity patches I posted about a month
> ago, which I believe address all the issues in the feedback I received.

Hi Eric,

Wanted to check in and hear if you had a chance to look at this?

Thanks,
Jes


> I have a version of rpm that requires this library which is able to
> sign files and a plugin which will install fsverity signatures when
> the rpm is installed. The code for rpm can be found on github - note
> that I do rebase the repo as I fix bugs:
> https://github.com/jessorensen/rpm/tree/rpm-fsverity
> 
> A git tree with these patches can also be found here:
> https://git.kernel.org/pub/scm/linux/kernel/git/jes/fsverity-utils.git
> 
> This update changes a number of issues:
> - Change the API for libfsverity_compute_digest() to take a callback
>   read function, which is needed to deal with the internal cpio
>   processing of rpm.
> - Provides the option to build fsverity linked statically against
>   libfsverity
> - Makefile support to install libfsverity.so, libfsverity.h and sets
>   the soname
> - Make struct fsverity_descriptor and struct fsverity_hash_alg
>   internal to the library
> - Improved documentation of the API in libfsverity.h
> 
> I have a .spec file for it that packages this into an rpm for Fedora,
> as well as a packaged version of rpm with fsverity support in it,
> which I am happy to share.
> 
> Let me know what you think!
> 
> Thanks,
> Jes
> 
> 
> Jes Sorensen (20):
>   Build basic shared library framework
>   Change compute_file_measurement() to take a file descriptor as
>     argument
>   Move fsverity_descriptor definition to libfsverity.h
>   Move hash algorithm code to shared library
>   Create libfsverity_compute_digest() and adapt cmd_sign to use it
>   Introduce libfsverity_sign_digest()
>   Validate input arguments to libfsverity_compute_digest()
>   Validate input parameters for libfsverity_sign_digest()
>   Document API of libfsverity
>   Change libfsverity_compute_digest() to take a read function
>   Make full_{read,write}() return proper error codes instead of bool
>   libfsverity: Remove dependencies on util.c
>   Update Makefile to install libfsverity and fsverity.h
>   Change libfsverity_find_hash_alg_by_name() to return the alg number
>   Make libfsverity_find_hash_alg_by_name() private to the shared library
>   libfsverity_sign_digest() use ARRAY_SIZE()
>   fsverity_cmd_sign() use sizeof() input argument instead of struct
>   fsverity_cmd_sign() don't exit on error without closing file
>     descriptor
>   Improve documentation of libfsverity.h API
>   Fixup Makefile
> 
>  Makefile              |  49 +++-
>  cmd_enable.c          |  19 +-
>  cmd_measure.c         |  19 +-
>  cmd_sign.c            | 565 +++++------------------------------------
>  fsverity.c            |  17 +-
>  hash_algs.c           |  95 ++++---
>  hash_algs.h           |  36 +--
>  helpers.h             |  43 ++++
>  libfsverity.h         | 138 ++++++++++
>  libfsverity_private.h |  52 ++++
>  libverity.c           | 572 ++++++++++++++++++++++++++++++++++++++++++
>  util.c                |  15 +-
>  util.h                |  62 +----
>  13 files changed, 1029 insertions(+), 653 deletions(-)
>  create mode 100644 helpers.h
>  create mode 100644 libfsverity.h
>  create mode 100644 libfsverity_private.h
>  create mode 100644 libverity.c
> 

