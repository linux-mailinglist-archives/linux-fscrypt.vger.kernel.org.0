Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A745B39B8
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Sep 2022 15:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiIINm4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 9 Sep 2022 09:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiIINmk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 9 Sep 2022 09:42:40 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A60A2631;
        Fri,  9 Sep 2022 06:42:19 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2899AqHY016856;
        Fri, 9 Sep 2022 06:41:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=B0kDHCrDmXhCbfFmQcZHKqbdsrpbFRvN3Sum0W+MoJk=;
 b=RBGnTjTSKHGBZGxzItDs+po0UMxvW4v4wGa4863eimAHiYb9CsioSyDTVWemHs9jSg8H
 xXN6V82dW1HacVkpjBgRMR3WHSB346QGENcgxnf9nAwahB+CIQZ8608R+8Rwpp4INK+b
 7tCPdwxRJ66o1w/LT6SwN1YteMY60ZjQGmI= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by m0089730.ppops.net (PPS) with ESMTPS id 3jg2m5sb6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 06:41:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMOe0blZCZjvHwqkUViM9gniuCBskV2pUokBK1+kLiCKne5NojSWSVdedFX2Sgt3KU1ckkOo/W3iazJtr2zpFbj89KmMQ25QPtofrYYWBuSqLsQQE7KoYKpezudRLkzLC3B9AfmcHZ8xwta82MOJcbN/e8Oix6nAOE5299/WK0THcdNbIsbfe7qKXdYzPrws2xzr1htEwY+EFe1a738INcIv6MAwi5rbFNq6BTs/4FVSnfitK6OAKpU7wx6XM45ZI47IAK8a8knNjmE0Yg47l+OURJXo25TUcdzI9umGT/S9rHkHaNwkH8mOQtGd6e+dcjaSPa0znaPvm61aNKiaDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0kDHCrDmXhCbfFmQcZHKqbdsrpbFRvN3Sum0W+MoJk=;
 b=CGgySRRcZ8VVerajIU+KCQwn8lOFm3fjkFWrwpCecySOFDZtq3P8YzRxo9hZ/rXOlfGpk7YbKv0p/wjJeCHykTizkTLCmm3SKmzoaHVG0OAQc0h6DzE3WbBA7kCfku73w5ZAXQlCoxPlO3cwhgHDTid15fKRCqNyfYbgGfnHbhj2FVsUjYsmc0NsP2JOwPu5NZeGUj6xpt8xKZsi6a6xnPedIDs6F7FAueOJj9hMh2yndY6MTA/HeuUACiIN4c40g2+NuwijACcLScKqIG6bfyak5IOlW27GvFAFQGHqd+/s89zhSaPUDnxLaneS5WkqvyAwtLhZnIcO59oPd/UNyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MN2PR15MB4287.namprd15.prod.outlook.com (2603:10b6:208:1b6::13)
 by BN6PR15MB1314.namprd15.prod.outlook.com (2603:10b6:404:e9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Fri, 9 Sep
 2022 13:41:47 +0000
Received: from MN2PR15MB4287.namprd15.prod.outlook.com
 ([fe80::700a:e1d7:b866:f3bc]) by MN2PR15MB4287.namprd15.prod.outlook.com
 ([fe80::700a:e1d7:b866:f3bc%4]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 13:41:47 +0000
Message-ID: <99b8fc6f-9e22-a4a2-676b-3e661482f093@fb.com>
Date:   Fri, 9 Sep 2022 09:41:42 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH v2 10/20] btrfs: factor a fscrypt_name matching method
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        David Sterba <dsterba@suse.cz>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>, linux-spdx@vger.kernel.org
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <685c8abce7bdb110bc306752314b4fb0e7867290.1662420176.git.sweettea-kernel@dorminy.me>
 <20220909101521.GS32411@twin.jikos.cz> <Yxs43SlMqqJ4Fa2h@infradead.org>
From:   Chris Mason <clm@fb.com>
In-Reply-To: <Yxs43SlMqqJ4Fa2h@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BL1P223CA0008.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::13) To MN2PR15MB4287.namprd15.prod.outlook.com
 (2603:10b6:208:1b6::13)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR15MB4287:EE_|BN6PR15MB1314:EE_
X-MS-Office365-Filtering-Correlation-Id: af91d445-98be-4cd9-519e-08da92690a3a
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M6Th4k/5qU/7cWMdwoY2+DoXj0iBH9eo/Ri/D7nutuDhpY7IVppRIFpyFoe+WPo7PO7q4rfEaYuJR80kp4afvpNiPa7bw4p/FKFJAf2NkSZ3YkxAkemZr10mefTGAldwvyvxCe+3JkwWKgPpKazFp3NHnc1X+vYxeSWGzRe50P3MgAHPfMiXowyJdId7cLdC9aJSV1kOKnBfpsqKjC3eS53ya4WjzW95nV6wTfx6yJJK/yoHwzpyIT988YzskQKQJRydwZzzine0u1ozi9pRINcFY+luV0Zxr/kXAcDN+t9LE9wzVTtCAu/OCcSxPajQZMZaRJ6bmyOE/vuxkq4cuPafaTAIUbGmtRocwapDRz4dt6NdVaPx6ln6sqaPOPF+qE8GKXakAOghAa8L2S1fpv+Wqpi8tdgULtXEU+QCpYfagc3WPRUH1XnUw8iPdiuwZ1fKwCfIcdCqcP/YSei6Qr7xb6dEQUktint0sauc1g0j+pqO+mb+8POAYgD82dfpp5NpXCvutzgK3EdDnMPJ02aTfgq4uxrWnsZQjrxmpsWOBx95AXYqXr4fsnT9OqgQzroaoFOjs5ypa4iTHKaB90O2k6A0P6kT51Hu7l7xA0hTNMZyyDFuxtRgbySKq/2YGgCNCD1zgA3CARBNaUUzkIZMZz6b3toxNCNNz3eN72kBROB9II24wgTUZrZH7Yqoobju3pNRy/uLvUs+OYD+EY47wMT2fim30z19Q2zGjHiQDI8MzpF3SVDlQQraoFb3RX3kAXdnkQ5JH76VEPeJ2t8cngZdT2gV9EhdWp6YmkbwavYDu0lTUUGDMuGQvwh4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR15MB4287.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(8936002)(66556008)(5660300002)(66946007)(66476007)(36756003)(8676002)(110136005)(54906003)(7416002)(6512007)(4326008)(966005)(6486002)(53546011)(478600001)(6506007)(6666004)(31686004)(41300700001)(16799955002)(2616005)(2906002)(186003)(83380400001)(316002)(31696002)(86362001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUZwcENHeGlJb3YxcGJZZ3JjbWJFVk9wQm55akhwK3llNk1MY1dJeDFlV2c0?=
 =?utf-8?B?OFVNUzB5WEw5UExReTRIOXZNcHRoVlBwRjlCaWpzaHhqNndjSHUwcjBBa3Rt?=
 =?utf-8?B?MWZYdGZPSnRNK0NFMTVqeE1ZemIvcUNjdzZjYW1DQkJrelkwd3BaeDhNNlhU?=
 =?utf-8?B?TEcxNTZiTVdyd200cERpK294UjN4RFl0aUdzcWxRTHVpODQ3N0xXY0VmSzV5?=
 =?utf-8?B?WTFyZzluQ2RWK2NIM2l3Z2oxZkNBcHBySHBJdXZsRGxXY2x3TjFRNnJTa2xt?=
 =?utf-8?B?bzlOM1dUYXhGK1MremZQbC9Ob2plVWJJaUlPYjQwRVJ0SlVpYjk1clBXYlJl?=
 =?utf-8?B?ZVFhZ2FXMThkNlhjQUZNRW1BS2psbEJ2SzhldmhqdHRONmhrR1l6TmttY0RD?=
 =?utf-8?B?SzhXUVRNWlpESUVtVEJMVHF5bXZxMFNSL2x5YlhCUWl5SVdlbEtGTUU2MmNB?=
 =?utf-8?B?a0VxMzhoczZVSzIyWVlNbkZsT1NuQUV0RlZndXpWYUQ4bGFFaDcrTjFLK1NZ?=
 =?utf-8?B?bmVFcnlVbkZSN0lsazZJRHR0UU1BK1BTZGgvQmh6TEsybTRUWWp1YWdxaGo2?=
 =?utf-8?B?ZjBDeUdoY1ZqS0ZVckZ0MHIrNjhUS2JkNEFEZzRvcFNVSUdvMmEwQ2diZ1BN?=
 =?utf-8?B?VlhtNzJ6L3ZOSFhFd0MvcFh0NjdBNzhwdjkza0NQSDc1TUFOTEpudlRIR29B?=
 =?utf-8?B?cW1BQWpydWw0ME5yZnJlUlNCemRrZmlFNGxNTDdZQXFWUFdBVW5hSHNGa0tk?=
 =?utf-8?B?aFFaaGhIQ0E1R0J6Wlppam1Mbk1KUVUrcWU3OTRIRDdmZWw4MUR1RnQ2NnNG?=
 =?utf-8?B?L1dOZnZsN0Z1VEdTQW1ScGJOOTNhMi9pdWNOTEJVRnM5VjFhQ0pSZzljWnRK?=
 =?utf-8?B?Z0VsVGp5dFZIRldQbUk0dERac3VoTDE0eTZXWXpjTGlMNThWeUFIVUFjeWF4?=
 =?utf-8?B?MmFFeCtGUzkzVitsM3Z3TVkvZk5rNGNWQi9PWkxVVjdkUkNrRENyZjZWTHRW?=
 =?utf-8?B?QWN2Rjg5d1FmMnNOS284NWFMQk42MGFmekQzZ2tmTVoySm9MK0t2L1Jkc0cw?=
 =?utf-8?B?WUlsMDZoZjZoVHcyQTBsQmtWZitvTElCNjVzVEEwaElYZXczU2QyMGQzRFpW?=
 =?utf-8?B?T2tXTnF6bEpSZmx0NitFQy9FVmd1Y1IvS2J0b2pnMnR2Ui8wSS8vUlBYUkV2?=
 =?utf-8?B?eFRiVHRENTdzM0dyRFJOZjRGQXNIQ25uMTlJcTBCMEU5VzVTWm1kVDJnYU56?=
 =?utf-8?B?UkZ2aHFJZWVLTWtmS3ZmelJGRkE0M1hMUkV3N29jcUpjbkZxM0xIYmlRUlRp?=
 =?utf-8?B?K1lVVit0MURwRVd3dWJGaDg4bVJKK1pHOG5ObmRFRHBsZmlqc0RrdHFiTTht?=
 =?utf-8?B?cWpkamk2aGkvVkVjc2VQZkN5WldJR014ZlpaWFNYSGxDaENDWFlpUXVaTm9j?=
 =?utf-8?B?TStsUVoybFRJbTYyUE9CVEtFUXhLdEIvaHZYSEhIazBhR05oVTY4QzA4RDgw?=
 =?utf-8?B?Z1gwTDlDc1QwWUhDWTJBUU56RU50OW5WMzVCbDBOLzVmcGVGT0NpNlFHSXFH?=
 =?utf-8?B?aitDbERPSThUYW02NFY5VDFiejM0WjBzdlZNaTV4U2h2aGhuZmtKQlIvMFVO?=
 =?utf-8?B?Q2wrZXBIZG0vM200aENWdjNoS0h5QnlUeHJhWTREQ2YyT3FYWXdOMHRRMVlT?=
 =?utf-8?B?YmhJL1VFekdLZDIyUWJDemFpU1R6UjFmR01IenQrcmVSRnZtcnlKTXZRZHRC?=
 =?utf-8?B?V0NrK0U3eCsxVkpEUW5VaUxyU3h1T1hBNUt4VGNXTEgxeHE4Z1d5TFUxVXV3?=
 =?utf-8?B?VXJ2ckdVSXo4RG1CL0RjQWFoT1F5disxSURQVDJFVzBYakJvVkx2eGdvL2dz?=
 =?utf-8?B?SEpkK1ZFWTV1S2FEc3R3TXZ3KzQ2czc4cVgybGFTTkwwUURDQ1F5MHliblJm?=
 =?utf-8?B?c1FVUW9nMVVRZXVOY0RrNTQvL0JBQ0h0dmszVTcwYXdxdysvTE0wSC95ajB0?=
 =?utf-8?B?Z3pqU3FEaXRaQ1NHbXVhME1jR245L1FqM1Jka0JpRkdJYSs0N0xnQ1pYVU5z?=
 =?utf-8?B?SzVjcTRtRTdGdnhhRXdpbFZGdzY1bUZsdVZWckU2SnA3S3FqZ1dsd29rYVdL?=
 =?utf-8?Q?V/7HdlD4ME1dcvBxq4Wk2DRlU?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af91d445-98be-4cd9-519e-08da92690a3a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR15MB4287.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 13:41:46.9505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: veBCYhyvzY3MitkQZ6MRay1HFl2nnz2p4U/sVb5mgvi2Jtw6x7n3phezVrJx2BlS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1314
X-Proofpoint-ORIG-GUID: 7uwb70qLB6q-HOmwhhpgtWHVp5_xw4Ay
X-Proofpoint-GUID: 7uwb70qLB6q-HOmwhhpgtWHVp5_xw4Ay
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_08,2022-09-09_01,2022-06-22_01
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 9/9/22 9:00 AM, Christoph Hellwig wrote:
> On Fri, Sep 09, 2022 at 12:15:21PM +0200, David Sterba wrote:
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Copyright (C) 2020 Facebook
>>> + */
>>
>> Please use only SPDX in new files
>>
>> https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Copyright_notices_in_files.2C_SPDX
> 
> The wiki is incorrect.  The SPDX tag deals with the licensing tags
> only.  It is not a replacement for the copyright notice in any way, and
> having been involved with Copyright enforcement I can tell you that
> at least in some jurisdictions Copytight notices absolutely do matter.

I agree, SPDX != copyright, and they should probably be in different 
paragraphs in the wiki because it's misleading as it stands.

Signed-off-by is targeted at declaring that you have permission to put 
this code into this project, which is somewhat different from copyright.

For Meta code, I'm happy to use the git history method.  But, I'm not 
completely comfortable with enforcing that on other companies or 
individuals unless it's common practice elsewhere in the kernel.

-chris
