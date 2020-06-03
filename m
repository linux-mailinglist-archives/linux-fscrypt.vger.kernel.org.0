Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB551ED18E
	for <lists+linux-fscrypt@lfdr.de>; Wed,  3 Jun 2020 15:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgFCN50 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 3 Jun 2020 09:57:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15078 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725833AbgFCN5Z (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 3 Jun 2020 09:57:25 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 053DsRvp031938;
        Wed, 3 Jun 2020 06:57:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zqEZi8f92AS6WjFYfQbtnHKn+B/4eh1ClyibJhNUvVY=;
 b=bo+8FukGroMzsY9D+VLH384l3QaNdrnK8bXabij8L3wviJZPei8/ywGrRlOTYhrQQ9W0
 ocjoqZXYQIZuskukvNnj4bAeo1ubtfaFIitEtf54NvLwR/YBO5NCR7IZHpijRiiNwsZy
 IPpxL+/+LIly06Xkk4i5CCL5LuG8U7g0pVE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31bn7q8cus-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 03 Jun 2020 06:57:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 3 Jun 2020 06:57:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5FW3n3N58eYSkrhgWfqZmdB4a45/w+p0y/QmRMoY63XZo9dJkg7Hm08dDd+92oGtfDoEqJ8r51GxXp7fWJ2WowGepTmqe6TY5MkeXklMerZhedNeN6MLyjrqE7L6oqhldCVRyCw1fq90TjjpAlHauMUufiupB48bM4UFhLWxMVrciPu4xhvlUkVvNsd6FRt0cDAl4eibqp2FvKqVg5wpqYlRw93e110E4WAatt4UTPn4W8p8wCQItj6/jCM8DriyLj59l5l0mqknOilvzGrwGrkY6tocTIAG3buFLjyCG9n9mmO1XdZYsAp5LUTHn/36j5TYChzURmBA42dW0U9bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqEZi8f92AS6WjFYfQbtnHKn+B/4eh1ClyibJhNUvVY=;
 b=WDeAYybmgfP8M6b/nmjUgjtwbY1zQSm2G8YtkcxkVynZKto8XoXyErK32Xf0lNoWRmd/34IwhWK1GHfTThV2vZQMWi2d/HihpMArLO4VRdkZWe9tfahxxDAXOv57S9iEjoKdIPcdSQCnwh+KKBVozT/eYkCqTM5UP3B2w/7Ugu2/wJEDsKIWwQprLDAjFZWIXWPTpqlev1YXFslju4vbQD7VCQSQgx1YJMdSlasuJvpLgijeVWsS9yiD0NdLXzYesN0UEZ4WkqD9gc+RppeEB+NprZ57X8AlQZcwCWCqXP5augWjfldjhyAdHuPlqi8BiXf+VE1HxlJn65e5RiP/jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqEZi8f92AS6WjFYfQbtnHKn+B/4eh1ClyibJhNUvVY=;
 b=UuHHwYxX3Dwal0dRPd14j3M5cYHENAiG8Z0zweGLN5UC+aMXWD0G0FHIUL56t2LPjxWJuOJsRwB80D3M9qJQtlTadtP3U/SlPjvvNAnfZFt7OfcNqJKrYVgyONiasJFxOMm+fktUDXRLLTL1OeMng+IW+mOuerdS5ZBNzPhG6GE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3608.namprd15.prod.outlook.com (2603:10b6:610:12::11)
 by CH2PR15MB3704.namprd15.prod.outlook.com (2603:10b6:610:c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Wed, 3 Jun
 2020 13:57:15 +0000
Received: from CH2PR15MB3608.namprd15.prod.outlook.com
 ([fe80::5800:a4ef:d5b3:4dd1]) by CH2PR15MB3608.namprd15.prod.outlook.com
 ([fe80::5800:a4ef:d5b3:4dd1%5]) with mapi id 15.20.3066.018; Wed, 3 Jun 2020
 13:57:15 +0000
From:   "Chris Mason" <clm@fb.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Jes Sorensen <jes@trained-monkey.org>,
        <linux-fscrypt@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
Subject: Re: fsverity PAGE_SIZE constraints
Date:   Wed, 03 Jun 2020 09:57:12 -0400
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <6AC8982D-797B-4FC1-9A08-72271CF0AAE0@fb.com>
In-Reply-To: <20200602215021.GB229073@gmail.com>
References: <69713333-8072-adf0-a6bb-8f73b3c390d0@trained-monkey.org>
 <20200601203647.GB168749@gmail.com>
 <628EC883-AD9E-4E4D-A219-C94979C51B98@fb.com>
 <20200602215021.GB229073@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR19CA0037.namprd19.prod.outlook.com
 (2603:10b6:208:19b::14) To CH2PR15MB3608.namprd15.prod.outlook.com
 (2603:10b6:610:12::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [100.109.101.153] (2620:10d:c091:480::1:49fb) by MN2PR19CA0037.namprd19.prod.outlook.com (2603:10b6:208:19b::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.22 via Frontend Transport; Wed, 3 Jun 2020 13:57:14 +0000
X-Mailer: MailMate (1.13.1r5671)
X-Originating-IP: [2620:10d:c091:480::1:49fb]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae8a3bcd-4b44-44f3-c64d-08d807c605a1
X-MS-TrafficTypeDiagnostic: CH2PR15MB3704:
X-Microsoft-Antispam-PRVS: <CH2PR15MB37043614D888B56EEFD46BFED3880@CH2PR15MB3704.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04238CD941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UL1eb6C/qoTdZv93xjbdqYHgRJqOMyFMW39nVmGlhCcGptN2KNynbIvimx27De5KVI4cVuzUQ/uC2yxioUjLkjjBv9PAakGoRsaylRE8kR77mwt22IzacwwqtB3lsgoC2z1cCrJl8MXQh2e0X2IAeXYwKYkSlRcBigMDUu280QrbFa6IGq4ha+Xk15LFVyO0y3TKPJ6jgp3NRVFpjs7UxwpLkovw9o4QzuT2MpdxMRjg8letlqMG51czJvIhRHeGEEh6s7jGcNLdEFwMmOr8qN0wVeWL8XNAuCf1rA9WKoQ8cT6Q604/g370lASERNmUy1hyz/TRUEMHUOQd43wHIKCg+UXF5+720L5CczMYyx+HrQFb8/yzOKVe4t6kdIAO/oqGnuEDmfkTsHJm//hYmQhPUVhKCDBSjqNQUlkGqcM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3608.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(366004)(39860400002)(396003)(136003)(86362001)(52116002)(66946007)(478600001)(5660300002)(66556008)(4326008)(53546011)(6916009)(2906002)(66476007)(8676002)(2616005)(956004)(8936002)(33656002)(186003)(83380400001)(54906003)(316002)(16526019)(6486002)(7116003)(36756003)(78286006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ZRhKXf2Udwol2Vp9zvfypKNX3kWcawd0TQm0QFJJ47MHCGZyssOPhQGL5qVS7bEQsVN8AwxW9so02Xedi8ZagGVaMIOrnWgkJq8qIoFkl8Q+MKGh5HaxqUouRlg9RP6tUdFWeq3y7i522Taig/q/zkOX7SBIATP5Z38XSfQq/7VQhBKb/xObmXtBzeuaFLKrFBaW5K1zr3cwrgC27w6vTO/o8B3dJizLx1cbFt7mOfb9nlXaJ4+7GYXkYVC2JwU/2tv4owu/oChwwbWUv9Jk2EuT2l9O+icj551/6Vi64kUex/k9SUqGWN6115zAa6x3vtm587Sixh/lDYoVPP6OC6i5V+N4zLxn74/eZ49IbKLm1MuuPtbZ9I6bzEQ1Ft77vTTmAql993HOpabtxZZz5XOxFfyfVIeGwTSbxzJ6wSSm0G3wlLnccy0uK6ye/OBiwMYZL8JANyaCkNbLX7vaYIk2EHDH0oVND5gHSvt5CpfIZHm7n4QMtzXCHp3Kbh5xOgFsAqRR7VhZi0/7cGNXZw==
X-MS-Exchange-CrossTenant-Network-Message-Id: ae8a3bcd-4b44-44f3-c64d-08d807c605a1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2020 13:57:15.4241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5/eEYPAZRtrI08Q2hRCqKNT7kXwdzCJog6jxtQmul+fuU+8z9Pno4fcnjZDKFMnZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3704
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-03_12:2020-06-02,2020-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=652 mlxscore=0
 cotscore=-2147483648 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006030111
X-FB-Internal: deliver
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2 Jun 2020, at 17:50, Eric Biggers wrote:

> On Tue, Jun 02, 2020 at 11:49:36AM -0400, Chris Mason wrote:
>> On the btrfs side, I’m storing the fsverity data in the btree, so 
>> I’m merkle
>> block size agnostic.  Since our rollout is going to be x86, we’ll 
>> end up
>> using the 4k size internally for the current code base.
>>
>> My recommendation to simplify the merkle tree code would be to just 
>> put it
>> in slab objects instead pages and leverage recent MM changes to make 
>> reclaim
>> work well.  There’s probably still more to do on that front, but 
>> it’s a long
>> standing todo item for Josef to shift the btrfs metadata out of the 
>> page
>> cache, where we have exactly the same problems for exactly the same 
>> reasons.
>
> Do you have an idea for how to do that without introducing much extra 
> overhead
> to ext4 and f2fs with Merkle tree block size == PAGE_SIZE?  Currently 
> they just
> cache the Merkle tree pages in the inode's page cache.  We don't 
> *have* to do it
> that way, but anything that adds additional overhead (e.g. reading 
> data into
> pagecache, then copying it into slab allocations, then freeing the 
> pagecache
> pages) would be undesirable.  We need to keep the overhead minimal.

You can do the IO directly into the slab pages, so there won’t be 
extra copies, but there would be some extra code for ext4/f2fs because 
you’ve been reusing the existing readpages machinery.  I’d start 
with the copies into slab just because all the complexity is in reclaim, 
and adding FS helpers for file IO into specific pages is pretty well 
understood.

Slab reclaim is a little clunky in comparison to the page cache.  But, 
it does give you the chance to do merkle aware reclaim, pitching the 
blocks that are the least expensive to reread from an CPU/IO POV.  It 
also gives you the chance to strongly prefer not pitching any merkle 
pages at all, which might be useful to help limit the cost of thrashing 
in low memory situations.

-chris
