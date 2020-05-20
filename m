Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF101DB4E7
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 15:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgETN0g (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 09:26:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39534 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726436AbgETN0g (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 09:26:36 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KDKYbU006473;
        Wed, 20 May 2020 06:26:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4IDslgLD8qSnMDY5Fn7YjKO0NVWtZQw+qvRVqHAvWUk=;
 b=pr0L+OoNGD8bP4Qfl+Pa1PadTaNs8EJrpjXywaUkvhs0h/ykTjhAwn7AYkp6yIUaUxdm
 aHPPkKG+9/0M2q2cAj4ZEAXAm/7SnZPEAHxdmDJ60Qi81m4J2dVd8iOuL1B1gH5wtJtS
 0XgSuj+EAWLqXGClq5JGW9qXz6Z89UUHgUY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 312yvdfvkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 20 May 2020 06:26:30 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 20 May 2020 06:26:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7MGM0wWon6CaGXmsp2tvWY0o40WIZltYgDffsu7RZ5S9bLoFpYnSgbnnUJjLVIWDHmaY73C6Emk3Jpmw9yGC4p7JmujVeLiiweAPRxBya9QTpguYrLJ4H9rH6f5ltW1IdaP9vTb90oKcjwuhIpNYXwObgyju+RlcSAcluQc77n6qOC1SFIOnSohDYTXCBBWSFzrqPio7tOjcjqkBK12qDdYj22VbQje1dMORjf+8ryQLm5vBLlr97Wv0hyy0o1H3QLV/QTyWFGnEe7nx+a4u9EjVmxxvc2gt/3Vhkl9Pn3445/GWEMbvXdWGFHMdxNwnM+/aeVeXICYV6SJhacxsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4IDslgLD8qSnMDY5Fn7YjKO0NVWtZQw+qvRVqHAvWUk=;
 b=bkI7hxRrwnDgNDfUUUN7m7fNLbt8wA/DbApf1D5Brce25Zq16sEfn1zyA2mjOrij/iqky//Tp4j9tqQZ88uSkk9G0+LI3EIs+ovV7yht3E0kqUepgYLL17NMsBU7s1Bk2oRLAlsK6R+9qJxgrlXS0mvDOdQjpDesygZn9eJifbZ8M1B1ben6eSEJX7HGZepPVn/m3vtlDACw70tPuTXUTIrKWKv+CmFElGotHwuyLHZ1jpEmIoDeKRb74pJ8yrDyx6ft2MUa1Groi4JfOQbpCSej6K3uh3Qt49hmUyh6FhbFg4x+uVa68sPp9r0khdpLescKeKeJ/g1+FUK0XJlwnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4IDslgLD8qSnMDY5Fn7YjKO0NVWtZQw+qvRVqHAvWUk=;
 b=d87r9hBesZi5H+5fPNsP7D/29dFuHm5ZW5E1DHwNabYkvAgVHBHxCcbf1cwg4OVQae4qYSy7h8lPvxnc6fj928lNl0OwoSyiS3meC9JkkT93epAvghoz6EjTl8huiy1z3SLdcA50TOJtV0SVcwX+aBc6ujLPjrqxqQpmqwrQPuY=
Received: from DM6PR15MB3276.namprd15.prod.outlook.com (2603:10b6:5:169::30)
 by DM6PR15MB3989.namprd15.prod.outlook.com (2603:10b6:5:294::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 20 May
 2020 13:26:28 +0000
Received: from DM6PR15MB3276.namprd15.prod.outlook.com
 ([fe80::40f3:1cdf:454a:48d1]) by DM6PR15MB3276.namprd15.prod.outlook.com
 ([fe80::40f3:1cdf:454a:48d1%6]) with mapi id 15.20.3021.020; Wed, 20 May 2020
 13:26:28 +0000
Subject: Re: [PATCH 0/3] fsverity-utils: introduce libfsverity
To:     Eric Biggers <ebiggers@kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>
CC:     <linux-fscrypt@vger.kernel.org>,
        Jes Sorensen <jes.sorensen@gmail.com>, <kernel-team@fb.com>
References: <20200515041042.267966-1-ebiggers@kernel.org>
 <6fd1ea1f-d6e6-c423-4a52-c987f172bb50@trained-monkey.org>
 <20200520030652.GC3510@sol.localdomain>
From:   Jes Sorensen <jsorensen@fb.com>
Message-ID: <38c855ed-042c-2440-bf73-3b5a34feb931@fb.com>
Date:   Wed, 20 May 2020 09:26:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200520030652.GC3510@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR19CA0036.namprd19.prod.outlook.com
 (2603:10b6:208:178::49) To DM6PR15MB3276.namprd15.prod.outlook.com
 (2603:10b6:5:169::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11d9::10af] (2620:10d:c091:480::1:2725) by MN2PR19CA0036.namprd19.prod.outlook.com (2603:10b6:208:178::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Wed, 20 May 2020 13:26:27 +0000
X-Originating-IP: [2620:10d:c091:480::1:2725]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03678268-cbb3-4fc3-6269-08d7fcc166c0
X-MS-TrafficTypeDiagnostic: DM6PR15MB3989:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB3989E61F660B44765D3BFB30C6B60@DM6PR15MB3989.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MTFu5eJ968VJim3zs9/bWgKujp0Y4yyxxh5dK5I46FX1w+MhdiX8Ft30jhyl6TySHme/2F8e780+pOeRiWny0ZN322zMUEpuYMCsO+w7yXKtMiF2dZkJIhsm8CNOY/3ELqWJjhLiY5E6i5vQW5xCv0jC76Xfq1/DaZPbHUWhgGJikBApVzIAq3WL/UERDCJp4/qVErjjYdxPccgHi+cHJs6yVOD16uB1p25A7uoRBWGF2GA/sN99Jc6qMP0FVlk8UHDPAGaTxR9VQVQXGWTH2UHMx8HMWcQ8RNp2EktutICigZ+Qqri3AjNq9kcT12EZSHkdzQYxjuY8zDBHIoedMBxZKLFCxcIArAYovtFeYTGZXfbtyRU6emRtdXBpSrOw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3276.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(39860400002)(376002)(396003)(136003)(66476007)(6486002)(52116002)(2616005)(110136005)(4326008)(66556008)(316002)(36756003)(31696002)(2906002)(478600001)(86362001)(5660300002)(186003)(66946007)(53546011)(16526019)(31686004)(8936002)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: dT9mJBsswC6AHFV5FTMBp8986GWnPM5uCXiZ7u0gdfo6sh6QQ9yQWUks1u56cXfs7K7MejYpv1iroZQ5AW3wteko/s+o0EjOn1K2tbIlUopCxPxYOPbbo2rXqN6XPtf5Sxk0DGMzU+wXp0VZyEf16e/OjPodXU3U9x3r0qtMnnuz7fjG3c34zv1dAPshkDsZndPS1tUIxpd8Dp9WO1v4pSvr8F6yldIC5ueF2tLFgVGjF14xFJdUfylL+GaoT0k6cRt0ku8XAt6u8UZmlauIKJLtq3J0plsX3qKGu3Xi2lrkYJvZR7QqN48c4u1DniTF2zD/WeuJqxKM1dQl4h/qMEmnsaUKbt68GJOQWGxnLD8uKRq6STJVPguK/DuUFBnmAKIZoUfHr6haG0fRvUu+N06NHEv/lgnKC/KpBpfFtIAJvY1pZxlWaCvmNbtCleWCcTMONxlKT+Om8C4nlbm5ZtZAf2Q7E/nKTEF5G+ubUGgB8rxc5JzSmrl0S5vMHlVPA6+cF5N3fC2jKaQGWITlrw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 03678268-cbb3-4fc3-6269-08d7fcc166c0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 13:26:28.1364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jG6Pdbo3OYR/h560ErCpiLfu+Twz7W1uMEf55sC95LmJFFR5E8G+UkgIupAwidc7uCR9s480WrjMlg+MAc5pmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3989
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-20_09:2020-05-19,2020-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 clxscore=1011 priorityscore=1501
 cotscore=-2147483648 phishscore=0 mlxlogscore=907 bulkscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200116
X-FB-Internal: deliver
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 5/19/20 11:06 PM, Eric Biggers wrote:
> On Fri, May 15, 2020 at 04:50:49PM -0400, Jes Sorensen wrote:
>> On 5/15/20 12:10 AM, Eric Biggers wrote:
>>> From the 'fsverity' program, split out a library 'libfsverity'.
>>> Currently it supports computing file measurements ("digests"), and
>>> signing those file measurements for use with the fs-verity builtin
>>> signature verification feature.
>>>
>>> Rewritten from patches by Jes Sorensen <jsorensen@fb.com>.
>>> I made a lot of improvements; see patch 2 for details.
>>>
>>> Jes, can you let me know whether this works for you?  Especially take a
>>> close look at the API in libfsverity.h.
>>
>> Hi Eric,
>>
>> Thanks for looking at this. I have gone through this and managed to get
>> my RPM code to work with it. I will push the updated code to my rpm
>> github repo shortly. I have two fixes for the Makefile I will send to
>> you in a separate email.
>>
>> One comment I have is that you changed the size of version and
>> hash_algorithm to 32 bit in struct libfsverity_merkle_tree_params, but
>> the kernel API only takes 8 bit values anyway. I had them at 16 bit to
>> handle the struct padding, but if anything it seems to make more sense
>> to make them 8 bit and pad the struct?
>>
>> struct libfsverity_merkle_tree_params {
>>         uint32_t version;
>>         uint32_t hash_algorithm;
>>
>> That said, not a big deal.
>>
> 
> Well, they're 32-bit in 'struct fsverity_enable_arg' (the argument to
> FS_IOC_ENABLE_VERITY), but 8-bit in 'struct fsverity_descriptor'.
> The reason for the difference is that 'struct fsverity_enable_arg' is just an
> in-memory structure for the ioctl, so there was no reason not to use larger
> fields.  But fsverity_descriptor is stored on-disk and hashed, and it has to
> have a specific byte order, so just using 8-bit fields for it seemed best.
> 
> 'struct libfsverity_merkle_tree_params' is just an in-memory structure too, so I
> think going with the 32-bits convention makes sense.

OK, thanks for the explanation, it's not a big deal going one way or the
other.

Cheers,
Jes

