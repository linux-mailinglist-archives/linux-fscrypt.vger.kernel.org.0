Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7712CC548
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Dec 2020 19:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730985AbgLBSep (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Dec 2020 13:34:45 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47410 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730986AbgLBSeo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Dec 2020 13:34:44 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0B2IRZfA001063;
        Wed, 2 Dec 2020 10:33:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=hPtJhogUuQ8gqLWu6F0CQdEJMzRDK5kaeaQSO8wsOsU=;
 b=RDIaHvUmPUjAe37z3iyTSgj1Ty4eu/6lHfB378DUC/P5xib6J9iHAKfBm8FQYMOwvc95
 sW0g3XXF7aSFpFLg3/toM8wkZBehNaGKAbREGK2p5lL/NOXC3sMDkJrKniW5YZyT03ER
 FCEn/myTKEGyxR6TnfdOVQwAYu10cssTDgI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3562m9vkc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 02 Dec 2020 10:33:59 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Dec 2020 10:33:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5d0xJr3IXvE5xa+flnxcUNTt860XTU0CEFZbd2BkK0k7iUukMjuKQ+X6xinBMVhQzA4lyKOiM67zwgvirMXs8jsCatqIV5uodIep1uNrBRurFeNdU48Bdz6KA+GUpW1fdFmfYMVptWlw/XXC/BSYLZ0tH5GdhJqLGN5uJnrZzExczl+Xd8DcGxftnk7sKVTZ0EKai72W8igYDynzq4rVawPbcnOjNFcgwFLld4BKe8jax0ZRm7mDy7eBs3zYdjfyd7IiEiyaEMmUsT1BUl9jzNex83CLT+RfFAyXHuH/DK08lus3s9ZceXN/B6OkLKMuIxInuj86BatjKPi+8S+Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hPtJhogUuQ8gqLWu6F0CQdEJMzRDK5kaeaQSO8wsOsU=;
 b=lUKGWcCECSO3hhWLB9nv+KF5BtNEaJHn6zAc8RhRfmXuqfldpDb7BzKW7keY1Ssl7OySnYEXG7CyhiE8CNCOWPZNLwOfaaw32pJaD4FzkCjjpDnSg4q7bM/+6Coq60VtUvWVkNMn8ub7KlnwTsxiYbh7hugpQ2Odo88vKXkElyBEfl6v34CmcZ2ivUGvY4z7F8FS3a9QnSLMWTPkk7olvpTpZKTVz92bCqWKMhFcl929Qvl3rw8W8HP/p398aFDumHNicz7CvSFKScgFkuEbvcZANyj4SA8cSBZeNTOBtv8URUHpSVwVxjalWzYC40EJF08VZM+GrlBSYK7jgiu/Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hPtJhogUuQ8gqLWu6F0CQdEJMzRDK5kaeaQSO8wsOsU=;
 b=c62bHX6b42hYS7ak7foPg57IBYKcCp/fDU++oHIKEIsnJybYQv3KJiI0GkCXeLv1rMED5yF3aoF/Go5jLbPwcWcvSCy/6pG2Od9XRWIcchdo1/BsN8wiVuf6madexhQ7hsx+TqptdntIbyuL9PjRRfwIyrz3Se7DPS5eSHIQeJ4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BLAPR15MB3826.namprd15.prod.outlook.com (2603:10b6:208:272::19)
 by BLAPR15MB3796.namprd15.prod.outlook.com (2603:10b6:208:254::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Wed, 2 Dec
 2020 18:33:56 +0000
Received: from BLAPR15MB3826.namprd15.prod.outlook.com
 ([fe80::b099:3c6e:2854:e3dc]) by BLAPR15MB3826.namprd15.prod.outlook.com
 ([fe80::b099:3c6e:2854:e3dc%8]) with mapi id 15.20.3632.019; Wed, 2 Dec 2020
 18:33:56 +0000
From:   "Chris Mason" <clm@fb.com>
To:     Eric Biggers <ebiggers@kernel.org>, Boris Burkov <borisb@fb.com>
CC:     <linux-fscrypt@vger.kernel.org>
Subject: Re: max fsverity descriptor size?
Date:   Wed, 02 Dec 2020 13:33:54 -0500
X-Mailer: MailMate (1.13.2r5673)
Message-ID: <1618E915-F81F-4175-8830-6FFD7B3B9F6C@fb.com>
In-Reply-To: <X8fZI93Agr4f4Lwh@sol.localdomain>
References: <7F52BBF2-46A8-4854-9B68-1DC3EFA12EF0@fb.com>
 <X8fZI93Agr4f4Lwh@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c091:480::1:9a91]
X-ClientProxiedBy: BL0PR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:207:3c::31) To BLAPR15MB3826.namprd15.prod.outlook.com
 (2603:10b6:208:272::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [100.109.108.204] (2620:10d:c091:480::1:9a91) by BL0PR02CA0018.namprd02.prod.outlook.com (2603:10b6:207:3c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Wed, 2 Dec 2020 18:33:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8dc5dbc8-f68d-4fea-08b2-08d896f0d3cd
X-MS-TrafficTypeDiagnostic: BLAPR15MB3796:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR15MB37967FCD7E936DC8F0DD779DD3F30@BLAPR15MB3796.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L2fTugf1Rw4FB784l9WK+uGFykIIIPYm4VtZr+7d8ntxdXb3VXQtmnyta4xVt+s1D43ef5GXe37c9j7iMamp6rZBvYEEjbcNmNDYi/S2NTH+UwQyyW0y4cSU/1a5fvfBVURgRjWPTYGt9J89KR9AdcVtjMIk4uydrp9GQv/Oes2+6v2bMrD0VM3NdXM3F0JOEXYsjircQVTr1h+Gvm/+T6u9syRrjpMnJDy3K0OxcdmXcDg13oWva8xXlH8p8/ljB3oaoBDQ0MOftTJoiJRGxSwt8505Hkm0kwwln5kF5ASr6kFqRW1ySIdOde5FQBRJ7IIFrouYPej5oBPbxrwnSrXKT35vvi6wbHvzCp8j2ctjYbjIu/uKEcZ7uXZgY0XYjccvLL1kBifnF1qYeB0T7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3826.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(346002)(39860400002)(8936002)(8676002)(3480700007)(16526019)(186003)(956004)(53546011)(2616005)(6636002)(52116002)(6486002)(83380400001)(2906002)(33656002)(86362001)(316002)(110136005)(4326008)(5660300002)(478600001)(36756003)(66946007)(66556008)(66476007)(78286007)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T1lvRjd5RzdNczBRUjB3U2tFcDRQR05MZGNsY0N4ZWlyb2t6RUtKZEE1aVMv?=
 =?utf-8?B?U0h3SnBkUCtUY1Boa2pCZWZONmgzTDhDNVF6ZzBON0hINlFudWJXOXRiQW8r?=
 =?utf-8?B?UFJycXFLNTRkMW53elJFd2F3SHpnb3kyekdXSHE3VjR5cmxCdmRIUmZoczkx?=
 =?utf-8?B?d1lnK1lEZXlXcGkzZ2E2eWhyUkw0NHJXTytIcHpBTVVLdTA0bVI1bHBTRlps?=
 =?utf-8?B?emJvQTVGUEFSTUU3N1JrYzUvUkNiOExnSURuVGNYaXFVRElrTCtSVTVCVkpW?=
 =?utf-8?B?dE12ZWJlS0xPcmdMSFN4YzN1VHQvamxkUWdqRmlmRXRmTWRWL0xueFlwQ1ph?=
 =?utf-8?B?RHdoY3lVcXdjZ0xLbW5pWUJZdXNlRm9ha2txL0VyZnhhZlorNkViM0hrcEdZ?=
 =?utf-8?B?U24yYUpUNFVhV28rdStwWkxtS1B0ZnZYQjEyRTQ0QmRkK3FRdld5RXU3QzQx?=
 =?utf-8?B?WHZid1I4VXZib2laYmlvclhRODdFdzZmaTQ0eU9qQUpjKzRQWDdRcGgyb3Fz?=
 =?utf-8?B?bWN3OEUrTnMzTHVlS2UrVmhTOHB1R2ZlbjlSN2Y0UUl2UTRiN1I2Z2NjM2wr?=
 =?utf-8?B?SUdHenRqdURBTk4rL2wxeDZuTDFtYUF2aDhPL0c1TkZjN1M5VkJIMGRZYm5z?=
 =?utf-8?B?dzZaN04wZkJXQ0NnUmc5UFBwZTVxNTZDMERxSVYxSm9xanJHOEJOYnV2K1ln?=
 =?utf-8?B?aXd6cWhhVFNlMmNJMnBZQk1GT25WWjZGSGc5ZjUvSFhvZThvRlBUaUxqR05L?=
 =?utf-8?B?czN3KzhWUS9QZ200dDZBV2o2em51WUFvdEx6cUdudlBoMTdrVjl0QlJSUTJh?=
 =?utf-8?B?V2JXL09McG1tVktmQXExUnNpRnlnUFZlR3l2U1Q5NDhySE5rK1JUNUgwOXpW?=
 =?utf-8?B?d3N4Q0FtcWxXYlMrMjQwVlNVSWcyNjc2dmtlbll2Y3JtRFZsTjRtL3J0UHE3?=
 =?utf-8?B?WTJXeFVWdk1xOGFSSmhYaUc0YjFleDRmSWJhbTN4UEh5NlRJbXg5Wk84Wk5Z?=
 =?utf-8?B?UFg5azVjVDM3SHp0VG1BaHA2V04wVUxhUEZOSUUvTFRlVFFTOStHeStqMTFJ?=
 =?utf-8?B?R2RJWjhCbzFzeUN4UERPTks0dzdLSXVjYVp3R3RTWDFtSVk1MmY3RVd6SFZ5?=
 =?utf-8?B?Z016TDc4bFQvZ3U3djVrR2trVVNOWC9ycWpUWTY0Q1VPSDMzT1h5ZFFQVTZx?=
 =?utf-8?B?TS8ycXIweDFCaEtpVnB1V3ZRQVpTMi9IcXJWcFdJTVpyZkhOL2JwdzJEcCtF?=
 =?utf-8?B?NlZnODRSNTBpRGc5S2VEbndSbzVsNHBuZERZSHViSWJQZW80RlR4RVpNUk9l?=
 =?utf-8?B?MlA1dXdhUno1OGsrM3V3eG5KbVgrRmJDU1M0Y2w1VUZ4S1RBSlczbVhhVlA3?=
 =?utf-8?B?Q2diNjNjaU4yY2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dc5dbc8-f68d-4fea-08b2-08d896f0d3cd
X-MS-Exchange-CrossTenant-AuthSource: BLAPR15MB3826.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 18:33:56.4404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PMdmk4vPTs/Le7RywrYd8bQKcAZTXQRcWnnXl9P0tYHGvkwaATeeYhyiat1ctBHY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3796
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_10:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 mlxlogscore=790 bulkscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020109
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 2 Dec 2020, at 13:12, Eric Biggers wrote:

> +linux-fscrypt
>
> On Wed, Dec 02, 2020 at 09:01:52AM -0500, Chris Mason wrote:
>> Hi Eric,
>>
>> I’m working on fsverity support in btrfs and wanted to check on the 
>> max size
>> of the descriptor.  I can go up to any size, just wanted to make sure 
>> I had
>> things correct in the disk format.
>>
>> -chris
>
> The implementations of fs-verity in ext4 and f2fs store the built-in 
> signature
> (if there is one) appended to the 'struct fsverity_descriptor', and 
> limit the
> total size of those two things combined to 16384 bytes.  See
> FS_VERITY_MAX_DESCRIPTOR_SIZE in fs/verity/fsverity_private.h.
>
> Note that there's nothing special about this particular number; it's 
> just an
> implementation limit to prevent userspace doing weird things with 
> megabytes
> "signatures".
>
> If btrfs will be storing built-in signatures in the same way, it 
> probably should
> use the same limit.  Preferably it would be done in a way such that 
> it's
> possible to increase the limit later if it's ever needed.
>

+Boris

Thanks Eric, the current btrfs code is just putting it in the btree, but 
I’ve got it setup so we won’t run into trouble if it spans multiple 
btree blocks.

Looks like the fs/verity/*.c are in charge of validating against the max 
size?  I’m not finding specific checks in ext4.

-chris
