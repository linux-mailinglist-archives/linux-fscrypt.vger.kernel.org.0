Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C287465F09
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 08:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355935AbhLBIDE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-fscrypt@lfdr.de>); Thu, 2 Dec 2021 03:03:04 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4189 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbhLBIDD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 03:03:03 -0500
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4J4StZ1WDLz67x6V;
        Thu,  2 Dec 2021 15:55:34 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 08:59:39 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.020;
 Thu, 2 Dec 2021 08:59:39 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     "deven.desai@linux.microsoft.com" <deven.desai@linux.microsoft.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "jannh@google.com" <jannh@google.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "tusharsu@linux.microsoft.com" <tusharsu@linux.microsoft.com>
Subject: RE: [RFC][PATCH] device mapper: Add builtin function dm_get_status()
Thread-Topic: [RFC][PATCH] device mapper: Add builtin function dm_get_status()
Thread-Index: AQHX5tHI6VSZDPA0J0GM0KIP7fuaeKweu+CAgAAaFvA=
Date:   Thu, 2 Dec 2021 07:59:38 +0000
Message-ID: <e57d2d23ec7845febb79ca4476c73fcb@huawei.com>
References: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
 <20211201163708.3578176-1-roberto.sassu@huawei.com>
 <Yahz1SYRG1CQIh0z@infradead.org>
In-Reply-To: <Yahz1SYRG1CQIh0z@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, December 2, 2021 8:21 AM
> On Wed, Dec 01, 2021 at 05:37:08PM +0100, Roberto Sassu wrote:
> > Users of the device mapper driver might want to obtain a device status,
> > with status types defined in the status_type_t enumerator.
> 
> The patch looks really odd.  And without the corresponding user of your
> new functionality it is entirely unreviewable anyway.

Hi Christoph

ok, I will send it together with a patch for a not yet accepted
software, Integrity Policy Enforcement (IPE), that will be
the primary user of the introduced functionality.

Regarding the patch itself, could you please provide a more
detailed explanation?

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua
