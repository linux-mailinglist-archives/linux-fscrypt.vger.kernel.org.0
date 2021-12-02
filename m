Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFBD466064
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 10:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356466AbhLBJdZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-fscrypt@lfdr.de>); Thu, 2 Dec 2021 04:33:25 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4190 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356461AbhLBJdS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 04:33:18 -0500
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4J4Vtg2HNKz67YrM;
        Thu,  2 Dec 2021 17:25:47 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 10:29:52 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.020;
 Thu, 2 Dec 2021 10:29:52 +0100
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
Thread-Index: AQHX5tHI6VSZDPA0J0GM0KIP7fuaeKweu+CAgAAaFvD///01gIAAEg9Q
Date:   Thu, 2 Dec 2021 09:29:52 +0000
Message-ID: <b4bf4a384b334cdab1522b3b082bd088@huawei.com>
References: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
 <20211201163708.3578176-1-roberto.sassu@huawei.com>
 <Yahz1SYRG1CQIh0z@infradead.org>
 <e57d2d23ec7845febb79ca4476c73fcb@huawei.com>
 <YaiHX+dWNUlmsNac@infradead.org>
In-Reply-To: <YaiHX+dWNUlmsNac@infradead.org>
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
> Sent: Thursday, December 2, 2021 9:44 AM
> On Thu, Dec 02, 2021 at 07:59:38AM +0000, Roberto Sassu wrote:
> > ok, I will send it together with a patch for a not yet accepted
> > software, Integrity Policy Enforcement (IPE), that will be
> > the primary user of the introduced functionality.
> >
> > Regarding the patch itself, could you please provide a more
> > detailed explanation?
> 
> We don't build things into the kernel just as hooks.  So in doubt you
> need to restructured the code.  And that a security module pokes into
> a random block driver is a big hint that whatever you're trying to do is
> completely broken.

I will add more context to the discussion.

The problem being solved is how to grant access to files
which satisfy a property defined in the policy.

For example, a policy enforced by IPE could be:

policy_name="AllowDMVerityKmodules" policy_version=0.0.1
DEFAULT action=ALLOW
DEFAULT op=KMODULE action=DENY
op=KMODULE dmverity_roothash=3c64aae64ae5e8ca781df4d1fbff7c02cb78c4f18a79198263db192cc7f7ba11 action=ALLOW

This would require IPE to obtain somehow this property.

So far, there are two different approaches. The first one,
proposed by the IPE authors was to define a new LSM hook
for block devices, to append a security blob for those devices,
and to store the dm-verity root digest as soon as this information
can be determined. IPE will then access the security blob at
run-time and will match the blob content with the property
value in the policy.

The second one I'm proposing is to directly retrieve the
information at run-time, when files are accessed, and to
possibly cache the result of the evaluation per filesystem.
This would avoid to the introduction of a new LSM hook
and to append a security blob for the purpose of passing
information from the device mapper driver to IPE.

Security blobs are usually used to store LSM-specific
information such as a label (or a reference of it). Sometimes,
when the label must be stored persistently, the subsystem
responsible for this task, such as the VFS, uses subsystem-defined
methods to retrieve the label from the storage and copy it to
the security blob.

In this case, it is not an LSM-specific information but rather
an existing property of another subsystem IPE is interested in.
Since LSMs need anyway to inspect the object before making
the security decision, they could directly retrieve the information
that is already available, instead of making it redundant.

Even if I would prefer the second option, it would be fine for
me if the first is adopted.

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua
