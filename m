Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D661DC0DC
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 23:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgETVFG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 17:05:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46884 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727067AbgETVFF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 17:05:05 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KKtg8h027656;
        Wed, 20 May 2020 14:05:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=DxHe6vUtOStc3FD8pBXYlap1eW05rYHPurz4S+rxL08=;
 b=Jimh3ePkZ/Ys3dgzKf0rGcq4JUAORROhR93JyKegY220ZurEGCWQKmLKaXgf4dGYDX2V
 1ZfBT7Mb+GLhP9tOOuWbL36Gy2jzyz7RNJlnAaonm2eq3K8bza/Fy3WOpA+JzWvWfyGW
 TQdS3eNEnLlO84xfAC2tZABu69QSecpM6vU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 312yvdkwyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 20 May 2020 14:05:02 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 20 May 2020 14:05:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnrkQiUgAp/dWQzF2zBhaFb+v8JKqDxsFeeN/YRUGRW8rIXKtbfa96NKS3mWfAowzjkdxreMbbSvorF70FEbT+Mx762SZQnZMRHMaQvOlDF6YFzA5X+qZJKpOwKSe6mLon01bdzNm3cW5gcr4kdWnwrwA5leyzdCjRAV9OMkBnylUv1v5rqrTpT2YQkAUptkJVbJxfjzaux1DIJhW/Ka28hMARCPSlP20JAIC2klN3IYJ0bteFY1PU2yq7HFkSFb+4/tmuYwOVM4GOfsRnAYZgO0sKgXl58Lu4T6HVAUkf5dsyEOCGcf3EfsWI2FJ/QjqzSCng4ZKDN//Y+U7Odvew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxHe6vUtOStc3FD8pBXYlap1eW05rYHPurz4S+rxL08=;
 b=ao45K7IpnSK6008qgJn7OgKp3/Rb9AD9GN7KVPq/3eUp8VN1Xy2NbDy3BAAHGhqQKaHJLg2iNvYwl2Q/ZY1uVQpWGYj4JaVPYYTxS2XCS92CsskyFpibXgpoXfB1fyckScT3iTpMqhLGw7/BZotEQUjQyq8J+isbojkqiUARcoug+FDDksHAOA0c8/5UjUE4zMawATXpdSKPh8MOxlGhTUJ78xCm2uyeza5oeQllm1cGSwtyIt8yTojMtrQCfMSAmCwfyJTBlvQUQbcnE5BZyLtXhhCIHcFpD8gElsTOa0scQb20GSxWOCMyOs3VWGPNC4+f7pj2X5KJkcUaIYDAiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxHe6vUtOStc3FD8pBXYlap1eW05rYHPurz4S+rxL08=;
 b=XQ5xiAb/bz6crVbaebX/daJ0Db31/aR5N501kyRuUYyLJTIo7BtXoMOl1zqPWKROgEAyNtTf4jDFv5Ocd4Vq1v9HnjvqwUr5FgV32ueL4D9o99bxyhv0a5LgIO9aE37t7+0VLPt6jJMY23r6+dKAEbBUV9uoawZz75w3GF3pL6o=
Received: from DM6PR15MB3276.namprd15.prod.outlook.com (2603:10b6:5:169::30)
 by DM6PR15MB2890.namprd15.prod.outlook.com (2603:10b6:5:146::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Wed, 20 May
 2020 21:05:00 +0000
Received: from DM6PR15MB3276.namprd15.prod.outlook.com
 ([fe80::40f3:1cdf:454a:48d1]) by DM6PR15MB3276.namprd15.prod.outlook.com
 ([fe80::40f3:1cdf:454a:48d1%6]) with mapi id 15.20.3021.020; Wed, 20 May 2020
 21:05:00 +0000
Subject: Re: [PATCH v2 0/2] fsverity-utils Makefile fixes
To:     Eric Biggers <ebiggers@kernel.org>,
        Jes Sorensen <jes.sorensen@gmail.com>
CC:     <linux-fscrypt@vger.kernel.org>, <kernel-team@fb.com>
References: <20200520200811.257542-1-Jes.Sorensen@gmail.com>
 <20200520210335.GA218475@gmail.com>
From:   Jes Sorensen <jsorensen@fb.com>
Message-ID: <4417919f-01f4-4d4f-1a10-7dc24ba166b1@fb.com>
Date:   Wed, 20 May 2020 17:04:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200520210335.GA218475@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0004.namprd11.prod.outlook.com
 (2603:10b6:208:23b::9) To DM6PR15MB3276.namprd15.prod.outlook.com
 (2603:10b6:5:169::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11d9::10af] (2620:10d:c091:480::1:2725) by MN2PR11CA0004.namprd11.prod.outlook.com (2603:10b6:208:23b::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Wed, 20 May 2020 21:04:59 +0000
X-Originating-IP: [2620:10d:c091:480::1:2725]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3eaf348-3401-4b25-91df-08d7fd01751b
X-MS-TrafficTypeDiagnostic: DM6PR15MB2890:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB2890DB172C710BECE96AC88EC6B60@DM6PR15MB2890.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J5aE6ROB6KqI1FUmXNKi8jj3jUj4N4IVTcIPhc7jXQawcEAl5vsWubNeog2hrtWME9a4SkzCB6HU8bGVIgEgxukz+p7NmaC/9BHXnMUlKW2zWTBABPUL2uOZOpiE/6r3l+gTzXfsYaR+UCYJz8UuwDa3cQ4xLYOMasxZu6jB+u8oBOpnMPCrEIoOd/nbPXHmm50eRGKUqfTbJFbggJoX3nGws08lPjHeLpjO6eGo7i57VV18iS5Wu0oLhxUyIr/v/er+dbvfUJMrKrMy2MIlhA+3X+SHYzkLplWKgvxG7+1q2K9rBlWEHztlFv746BjB/LHOKbBFflKj7GnbFVFVKaTkejkvZ3jXjmiibzGeR3N7ygagO7/9SZZowhbkXH3T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3276.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(366004)(376002)(136003)(39860400002)(110136005)(316002)(66476007)(2906002)(66556008)(66946007)(5660300002)(4744005)(52116002)(53546011)(16526019)(31686004)(4326008)(186003)(36756003)(2616005)(8936002)(478600001)(8676002)(6486002)(31696002)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cmRCsHrEm+ZvE1o5jUKmgdJel0wB328uGLWSNDuS8TwmN0qMRPazbrE1TvDnqGDrWVeIWmXvnZydmOAyCxFAYBZiuuBojtRmW+ewWsuFNo9khjdmK9mX5AlQ3e0T+aUgj8c1ysJWuWQefRefcARSEeEGFV5WT/ECx8g2F/RsQ8MXj/S/deeuW2OxxG3FFiLoZ7nlWSUtseXO6jWwRC3Wi/hLspfRCdJMySgRq7BzQurMxKXxZMh4qlzvIoaL7VU4f85M0mnffOrMLIEHZT6+HDpMpVCrNYKmhM958I/iBjP813nuYRP97zt+UWqhXmh6/Cd3y8jjfgkdVp+v2BCypKEv8WZOYnfcKawIzKl71K9jjRtO1eqrdoQ0TRYyvONLy7zFek9E1iWZRtzpVeJhmirbuDpPsUKWK3VDlebHy9AI83GMABCDjFzm8ycXXsj4QbtoqfsXY5wu3rarHtpDLChAxzwKfFtyCNDhjRJo5p1G0/wVE+gfbdw8q3k2KzhnpAMlVazb67dUA66+nBDxIw==
X-MS-Exchange-CrossTenant-Network-Message-Id: b3eaf348-3401-4b25-91df-08d7fd01751b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 21:04:59.9629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /HsoOjXsdZIeI2AiFV2a9FLuOe0i2zPhauYliFR0RBkCYPTf31xD4eEs9rHHex+WAUpe5LpxwQkYhRmHThQN2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2890
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-20_16:2020-05-20,2020-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 cotscore=-2147483648 phishscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200167
X-FB-Internal: deliver
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 5/20/20 5:03 PM, Eric Biggers wrote:
> On Wed, May 20, 2020 at 04:08:09PM -0400, Jes Sorensen wrote:
>> From: Jes Sorensen <jsorensen@fb.com>
>>
>> Hi
>>
>> This addresses the comments to the previous version of these Makefile
>> changes.
>>
>> Let me know if you have any additional issues with it?
>>
>> I'd really love to see an official release soon that includes these
>> changes, which I can point to when submitting the RPM patches. Any
>> chance of doing 1.1 or something like that?
>>
>> Cheers,
>> Jes
> 
> I'll release v1.1 after I merge the libfsverity patches, but I need to look over
> everything again first before committing to a stable API.  I'll try to get to it
> this weekend; I'm also busy with a lot of other things.
> 
> Also, could you look over my patches and leave your Reviewed-by?  I expected
> that you'd have a few more comments.

Sounds good, I'll go over them again and add the Reviewed-by lines once
I'm through.

Cheers,
Jes
