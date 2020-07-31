Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126DB234A73
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 Jul 2020 19:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732973AbgGaRsA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 31 Jul 2020 13:48:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729018AbgGaRsA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 31 Jul 2020 13:48:00 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06VHiifQ018358;
        Fri, 31 Jul 2020 10:47:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=30qccE/Aw+SUCD7sJSm2Z8t0hTwj4OycRJghr/HnrmM=;
 b=QBR5kxWDvkGlh1Zl1ZfcTKcqJFPUmoKsXL8l4Y9bt+fsoK/k6U2k8LiSQE3YMweWYTi/
 AiyARhoLw3LQXXbCCPic9IFSjXqtaO5CVH+R2/IzElajkQFvX/Q5nCDuIy9hOkh/UZ3o
 zU75cd+0KZkM9tuQmgQnqUJYlkSjCHpl2zk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 32kgmst5d8-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 31 Jul 2020 10:47:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 10:47:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQmWKgtHIPO8bANN1QP8Xjk+0H08Fsmm3YoJEEWy+LI186p+12WlOwGWJs9Nz10ADV2YgEYIVp5WCzh1o7Ki6gamZie8kQhxddP4d+AeFDtuHtPQAwJMzvLNTx0SPZzcETFmrRPHbZQ94QOO6jIsA7vNY5CXbnED/KV+UVjqdxK+vto7UHEGjj4twtNxD1Gd3cvo1f6tFwXKwudo8OSHC8DLybxVl94HE+RaOl3khl0VcIXig9GahtN8KcieATVAnKYPKSRoLg5tUv5BrSg7AicFvUdtMTVWS9dpgv6V2qq6no83iTx38E560HKLSX8g6yiFADloGvqSTzcmMfqD2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30qccE/Aw+SUCD7sJSm2Z8t0hTwj4OycRJghr/HnrmM=;
 b=nDARu43+s7t3I+SkkFXpbtPPpjds4kApMT2o7/+wTKkwtWRAWMpRWEGsotrSCNwlivwylZvIdieg7w7oKHO3J2PrDKe58UUO0VD1zRW38ll0RxpInJKl6mNW3OXY/V5HPe4jn4qBsVjlyCJGsWjj2aYu0c8W6NU4fhlkSRZxgemmkXoqDnSKc2OSsPb3V59J68YOdAXIuLV3OXB24DXcA28LMU+4L/3a1KFYLZMhnLIqBmemmNllUykSSeI09hgAYmHzQPRVSJmJ/1vqT5xY4k/bit6eLsgj8VcxP9nGzWwUST6BT8VAT0VbNr5ntEPcwErsJleH/oG4csiiDfrz+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30qccE/Aw+SUCD7sJSm2Z8t0hTwj4OycRJghr/HnrmM=;
 b=JuI1c+rJdThi5JvwIyaWyVqH5K2XGr3ZzIEmGuWu7Bf9+OeC/yA6HPlUGGW88yMQNmzsWVqYt3YcDDZn7n9ht8dd4nALerXzX1hZxhPoTN7oJT6N16ZQ6zPV2HdRYT6wCnrDtETrPVnz7MPy+AQDLHK/IkdVMH2IMwMM0ZSOch4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from MN2PR15MB3582.namprd15.prod.outlook.com (2603:10b6:208:1b5::23)
 by MN2PR15MB3584.namprd15.prod.outlook.com (2603:10b6:208:1b7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Fri, 31 Jul
 2020 17:47:38 +0000
Received: from MN2PR15MB3582.namprd15.prod.outlook.com
 ([fe80::e9ef:ba4c:dd70:b372]) by MN2PR15MB3582.namprd15.prod.outlook.com
 ([fe80::e9ef:ba4c:dd70:b372%5]) with mapi id 15.20.3216.034; Fri, 31 Jul 2020
 17:47:38 +0000
From:   "Chris Mason" <clm@fb.com>
To:     Jes Sorensen <jes.sorensen@gmail.com>
CC:     Eric Biggers <ebiggers@kernel.org>,
        Jes Sorensen <jsorensen@fb.com>,
        <linux-fscrypt@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [PATCH 0/7] Split fsverity-utils into a shared library
Date:   Fri, 31 Jul 2020 13:47:36 -0400
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <6CCA1B7E-63A2-4E8C-BD9D-A7F34E6F488D@fb.com>
In-Reply-To: <0d5c5b1d-2170-025e-2cc1-75169bb33008@gmail.com>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
 <20200211192209.GA870@sol.localdomain>
 <b49b4367-51e7-f62a-6209-b46a6880824b@gmail.com>
 <20200211231454.GB870@sol.localdomain>
 <c39f57d5-c9a4-5fbb-3ce3-cd21e90ef921@gmail.com>
 <20200214203510.GA1985@gmail.com>
 <479b0fff-6af2-32e6-a645-03fcfc65ad59@gmail.com>
 <20200730175252.GA1074@sol.localdomain>
 <0d5c5b1d-2170-025e-2cc1-75169bb33008@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR07CA0026.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::36) To MN2PR15MB3582.namprd15.prod.outlook.com
 (2603:10b6:208:1b5::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.232] (172.101.208.204) by MN2PR07CA0026.namprd07.prod.outlook.com (2603:10b6:208:1a0::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 17:47:37 +0000
X-Mailer: MailMate (1.13.1r5671)
X-Originating-IP: [172.101.208.204]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84a809b7-40fd-4f18-8e9d-08d83579d0ad
X-MS-TrafficTypeDiagnostic: MN2PR15MB3584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR15MB35847689FDFD10191430F740D34E0@MN2PR15MB3584.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: la/JkrPLd6EEL/zTpEcFFjv+QeeHYHGvxEii35UljP/WJ4zZYXtUB8OX3yLtSDB4OSlU3nMoOAbTw9OD0T5QAO+eBfFcWBUK2/pPo53zfBJfqVzdLTL+XNyBD2iuMTQYibl021gkMDGuorKkx7knZ2OY0pMX6mNwqx0wb6kxxdL5MsWx6DhFhENOtUsf/gU7idz6Wr34/ouooo6HUTVwHfETazSM9+jromUxnu4ETC+W0gZsgy3xO8/BsgpdJ/wEUvaJVYnr+5ZnV5ttnXbLpoDXP047d8bDD9oHux3iAdcNl1rYx2wx+Z3gZb3BZ7+b318isOPFeK63RDYpmyGvFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR15MB3582.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(366004)(39860400002)(396003)(136003)(316002)(16526019)(53546011)(33656002)(186003)(16576012)(4326008)(26005)(52116002)(6916009)(66556008)(66476007)(66946007)(36756003)(2906002)(478600001)(54906003)(5660300002)(2616005)(8936002)(86362001)(8676002)(6486002)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: tA2dZsx4QdgfD+OB5Q2mR7zX72K9FvZCYdVs4iovEZOuJj+pCI2ouiIEzxc8tvRAsBTTcduUfoFzsDOZc+bqR3Ri6x9bXznBVDplN8CEMTXQFLxX69plX4FTOyziUR6NbpXLNv2I5xL6yka5lhlv6O+igX8QrJODNhEUqZeEgfD1CGpoc9BdKMhQs8mvas9XtGy2Qf/Xm9TqoZhX9A1TlxKqjgu+DBJaA9D5qhPhtUAxhV404ell46W2CwQp3s+rQRWQoQmkIBicOqyBePa7jTVab1185dZoTUu4IjT14WeH5b7HHJAalQd3hfcVGebMilSnttUqZiVi2h34BDJXBXE5llcxD0MDn/DgGoaLKtWeUOcswl1exb4zgXoNWUtWxqPLL8tnBHz5v6MrAs93DMzOthFgI8lhazTAKhfmNuHOIhIZOsZUafBnjQYa7Lo4O6LNKSGd4TqzKFfj4LkNAxGbFqPiyCRjiK9M1p/EQUUuBzYT2l5OuCpVa/6sRZ7G
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a809b7-40fd-4f18-8e9d-08d83579d0ad
X-MS-Exchange-CrossTenant-AuthSource: MN2PR15MB3582.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 17:47:38.3863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+pTkgp6SVFY/AdMCowcyfS1LaAZKmXrKnvCTcZW2/PBsV+VD+aqnSKVUoq3pTM+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3584
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_07:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 bulkscore=0 clxscore=1011 mlxscore=0
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007310134
X-FB-Internal: deliver
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 31 Jul 2020, at 13:40, Jes Sorensen wrote:

> On 7/30/20 1:52 PM, Eric Biggers wrote:
>> On Wed, Feb 19, 2020 at 06:49:07PM -0500, Jes Sorensen wrote:
>>>> We'd also need to follow shared library best practices like 
>>>> compiling with
>>>> -fvisibility=hidden and marking the API functions explicitly with
>>>> __attribute__((visibility("default"))), and setting the 'soname' 
>>>> like
>>>> -Wl,-soname=libfsverity.so.0.
>>>>
>>>> Also, is the GPLv2+ license okay for the use case?
>>>
>>> Personally I only care about linking it into rpm, which is GPL v2, 
>>> so
>>> from my perspective, that is sufficient. I am also fine making it 
>>> LGPL,
>>> but given it's your code I am stealing, I cannot make that call.
>>>
>>
>> Hi Jes, I'd like to revisit this, as I'm concerned about future use 
>> cases where
>> software under other licenses (e.g. LGPL, MIT, or Apache 2.0) might 
>> want to use
>> libfsverity -- especially if libfsverity grows more functionality.
>>
>> Also, fsverity-utils links to OpenSSL, which some people (e.g. 
>> Debian) consider
>> to be incompatible with GPLv2.
>>
>> We think the MIT license would offer the
>> most flexibility.  Are you okay with changing the license of 
>> fsverity-utils to
>> MIT?  If so, I'll send a patch and you can give an Acked-by on it.
>>
>> Thanks!
>>
>> - Eric
>
> Hi Eric,
>
> I went back through my patches to make sure I didn't reuse code from
> other GPL projects. I don't see anything that looks like it was reused
> except from fsverity-utils itself, so it should be fine.
>
> I think it's fair to relax the license so other projects can link to 
> it.
> I would prefer we use the LGPL rather than the MIT license though?
>
> CC'ing Chris Mason as well, since he has the auth to ack it on behalf 
> of
> the company.

MIT, BSD, LGPL are Signed-off-by: Chris Mason <clm@fb.com>

We’re flexible, the goal is just to fit into the rest of fsverity 
overall.

-chris
