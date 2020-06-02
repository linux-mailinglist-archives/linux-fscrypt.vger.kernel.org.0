Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2321EBF5A
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jun 2020 17:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgFBPtu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 2 Jun 2020 11:49:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26420 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726000AbgFBPtt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 2 Jun 2020 11:49:49 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 052Fjrrt000643;
        Tue, 2 Jun 2020 08:49:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jJq7EBe2noW3jx0sak+vcFxW//u37rLoZDs6m8gXrac=;
 b=KqLzMWAdUETRWR/yh+uPfUJVyMuqlphBoCxaJcMAi9X490xjE9oCoT6BnNoSTfXkfSQV
 4C4Cw3DDBD/m5I9pRetHYG0FLVpuJfdbxxBfDRKpg5tDTNrAr56ZUFZxoVnyxJzkGoqU
 4VBbakQg/EIPFQH9ZJkJnS8AV7mP1qFoStA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31c7rvfv1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Jun 2020 08:49:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 2 Jun 2020 08:49:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CST7MIN5jLqpkPIQt4uW4uBSYO6pSb/h2JuQXaPIGlEn+GUjfA2QbsT1tfhYoz+5WsZ5deNAd9GSKMCcEvjSo1AzaG+IL7oImY+NgeGLD0Ifdp5P7O77QfIdQU1vZsZCM5DteaKJC0Id6/vxsL25kK/hF38dsnY+48i2TBwOvoHmDp8DYEcmp2++nittkVnXGHMInuDSytCcChphQ2yARm8nnquwfBqpJa7x9EMR8+zRt7B8EV1CwZECsY/QDB9QFqjuECRg0TRQV7qFEse7he5c7MHWJXIfMqu5TCqGqjSIB728XhIJam3V5AixLr1hRhmMfGjHPDCeT1REALllKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJq7EBe2noW3jx0sak+vcFxW//u37rLoZDs6m8gXrac=;
 b=iDNdaE7KH4599tfyAR1442SAwKNkzXy9Dxi+tWcgEI/1nSzK3sZO8StBVmEysx1JECXE4trhsnB2UreB95QYssIX18UK308e+IkldXyfaBj/FxgyS81xQu9g7MHGDBwd6yOgjkStPkOmDqYQeULjV9400NuMXu5ROZy9eBZmVNwxBZ7vzKqdbcv3RBAgcLncffcs1DePqu/e5S9w/I7B4TrEaF+gPoAkIPrMn6F/XGZgH8fMRQO0n3VKCMoHLB1Qnpz3AtToKOfaiZZgKQ/QUPjLcbDrT0Oxlp1jFAtixWxzCeZcYzbfYrRD2OltkM7g2gVEBVxSLGelqFI2ED7YWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJq7EBe2noW3jx0sak+vcFxW//u37rLoZDs6m8gXrac=;
 b=de4pH3DWB67TgdzEHJBijMImA8Wuwi0J8LZXHiUUgmug0SckhKxoGs6az+xbxez/Z/ktqgJPDhg+LpeFeW3gQ+OssVwiUFyn9dop1n2xYiI2s9UWvrRVnC7xH3RiUZSnKjQ6oiMjlSdtuPIX/2cfeKReW3QAaWJo6Keh7ks3erA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3608.namprd15.prod.outlook.com (2603:10b6:610:12::11)
 by CH2PR15MB3542.namprd15.prod.outlook.com (2603:10b6:610:7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Tue, 2 Jun
 2020 15:49:38 +0000
Received: from CH2PR15MB3608.namprd15.prod.outlook.com
 ([fe80::5800:a4ef:d5b3:4dd1]) by CH2PR15MB3608.namprd15.prod.outlook.com
 ([fe80::5800:a4ef:d5b3:4dd1%5]) with mapi id 15.20.3045.022; Tue, 2 Jun 2020
 15:49:38 +0000
From:   "Chris Mason" <clm@fb.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Jes Sorensen <jes@trained-monkey.org>,
        <linux-fscrypt@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
Subject: Re: fsverity PAGE_SIZE constraints
Date:   Tue, 02 Jun 2020 11:49:36 -0400
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <628EC883-AD9E-4E4D-A219-C94979C51B98@fb.com>
In-Reply-To: <20200601203647.GB168749@gmail.com>
References: <69713333-8072-adf0-a6bb-8f73b3c390d0@trained-monkey.org>
 <20200601203647.GB168749@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR10CA0019.namprd10.prod.outlook.com
 (2603:10b6:610:4c::29) To CH2PR15MB3608.namprd15.prod.outlook.com
 (2603:10b6:610:12::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.129] (172.101.208.204) by CH2PR10CA0019.namprd10.prod.outlook.com (2603:10b6:610:4c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21 via Frontend Transport; Tue, 2 Jun 2020 15:49:37 +0000
X-Mailer: MailMate (1.13.1r5671)
X-Originating-IP: [172.101.208.204]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 615210b7-c7b6-4898-4fb9-08d8070c8e51
X-MS-TrafficTypeDiagnostic: CH2PR15MB3542:
X-Microsoft-Antispam-PRVS: <CH2PR15MB35429E5992AC12B1F944E218D38B0@CH2PR15MB3542.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kXQoPyTXCajXuuxGEAzboY5mLBfzOoOsGVwDF/+Ix9Qc8wTkM+wpT/gz3zqRF372q1MwTIHbT3hwYCaXXwoo8UP23Ib0hSXYB9rTgnQ9vFBqfbK0MbvHkFsst5U6SVmUS8mRII+BS/fiR6mlt+QNuF8Kb6xmP6xkZ/d3tC6DE1VOMLlRLXXcnFSLWSsPorRDXhReiIK3s8lKucMZ2z+M8KWGfIRxEswj3GhA822jif8VHcnQ5ZeNd9wY1h5YlSTA1kivVA+a3X9SxNPpYSa73K0eAPNPboFHx56NLEoqFOGjUvia50OMi8asEZO7aDsrk9UyZ9VX325CyGFFrZaRzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3608.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(376002)(396003)(346002)(39860400002)(33656002)(4326008)(52116002)(16526019)(53546011)(186003)(26005)(478600001)(2906002)(6916009)(8676002)(5660300002)(66476007)(66556008)(8936002)(316002)(54906003)(7116003)(86362001)(36756003)(2616005)(83380400001)(16576012)(66946007)(6486002)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ouXNLZ4KMVujJ1KCE5YkgywRICwhAj6kCM5et6ee0aLqMwj2sFtroy4OmarifkJNHyIOLbf+HaM5u7DE6QNjY4MuDlmsgLBrzv/AqJC+LodWpdlP7nZ9YVPXqdP5oDit9dTNfZXJa6hSRlLyca/2SId2tBXfRj6CEtjXadZ+qoo5b4lWeOYrOpw3Vhq53s7j2aka5KyUdSfTJJuXgaiJ95+rLYjR+1L8aVU0vWn1KzTEZeCj+rkgdvuwMyKEhl1ftC2DLG2GTc8JFFlGMrXxyDaHgm5ky/oZnWo2/ZHLYthMyG3WXkyVWPdCGJpznVhRgihaguMZ6BXTg5o65SVeaCWFqDOfdsl1f5u/s3NgvVXfZ4PelXyV+3bx032byOGbHvcVCWJlVrutTsMDcnmGZxHz57WzcfSAQIGuRExCSPu8sd0V/Zd4RU6EDA7yY8BT9bh5NOOEfTDvOEcLyuA6jwPMkGHvO6ix1Zqi1XEXE0izk1qn64fvYH9nrBkEtca9
X-MS-Exchange-CrossTenant-Network-Message-Id: 615210b7-c7b6-4898-4fb9-08d8070c8e51
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 15:49:38.4968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X3IyRahegvpT6c4JTEQiAIxzyuS51veiQFAyHIsGD+/CykQMiJ2u6ir4Ut0O3trZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3542
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-02_13:2020-06-02,2020-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 cotscore=-2147483648 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 clxscore=1011 priorityscore=1501 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020113
X-FB-Internal: deliver
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 1 Jun 2020, at 16:36, Eric Biggers wrote:

> On Mon, Jun 01, 2020 at 04:13:45PM -0400, Jes Sorensen wrote:
>> Hi,
>>
>> I am working on adding fsverity support to RPM and I am hitting a 
>> tricky
>> problem. I am see this with RPM, but it really isn't specific to RPM,
>> and will apply to any method for distribution signatures.
>>
>> fsverity is currently hard-wiring the Merkle tree block size to
>> PAGE_SIZE. This is problematic for a number of reasons, in particular 
>> on
>> architectures that can be configured with different page sizes, such 
>> as
>> ARM, as well as the case where someone generates a shared 'common'
>> package to be used cross architectures (noarch package in RPM terms).
>>
>> For a package manager to be able to create a generic package with
>> signatures, it basically has to build a signature for every supported
>> page size of the target architecture.
>>
>> Chris Mason is working on adding fsverity support to btrfs, and I
>> understand he is supporting 4K as the default Merkle tree block size,
>> independent of the PAGE_SIZE.
>>
>> Would it be feasible to make ext4 and other file systems support 4K 
>> for
>> non 4K page sized systems and make that a general recommendation 
>> going
>> forward?
>>
>
> It's possible, but it will be a little difficult.  We made a similar
> simplification for ext4 encryption initially, and it took a long time 
> to remove
> it.  (ext4 encryption was first supported in Linux v4.1.  ext4 
> encryption didn't
> support block_size != PAGE_SIZE until Linux v5.5, following work by
> Chandan Rajendra and myself.)
>
> Fixing this would require a number of different changes:
>
> - Updating fscrypt_verify_bio() and fsverity_verity_page() to iterate 
> through
>   all data blocks in each page, and to handle sub-page Merkle tree 
> blocks
>
> - Defining a mechanism other than PageChecked to mark Merkle tree 
> blocks as
>   verified.  E.g., allocating an in-memory bitmap as part of the 
> struct
>   fsverity_info.  This should also be optional, in the sense that we 
> shouldn't
>   use the memory for it when it's not needed.
>
> - Supporting fs-verity in block_read_full_page() in fs/buffer.c.
>
> There may be other changes needed too; those are just the obvious 
> ones.
>
> Is this something that you or Chris is interested in working on?

On the btrfs side, I’m storing the fsverity data in the btree, so 
I’m merkle block size agnostic.  Since our rollout is going to be x86, 
we’ll end up using the 4k size internally for the current code base.

My recommendation to simplify the merkle tree code would be to just put 
it in slab objects instead pages and leverage recent MM changes to make 
reclaim work well.  There’s probably still more to do on that front, 
but it’s a long standing todo item for Josef to shift the btrfs 
metadata out of the page cache, where we have exactly the same problems 
for exactly the same reasons.

-chris
