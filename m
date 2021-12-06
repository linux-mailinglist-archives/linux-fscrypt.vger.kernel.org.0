Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E214146948B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Dec 2021 11:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241983AbhLFLBR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-fscrypt@lfdr.de>); Mon, 6 Dec 2021 06:01:17 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4201 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241972AbhLFLBN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Dec 2021 06:01:13 -0500
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4J70hy1Svhz67wK2;
        Mon,  6 Dec 2021 18:56:02 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 11:57:41 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.020;
 Mon, 6 Dec 2021 11:57:41 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        Christoph Hellwig <hch@infradead.org>
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
Thread-Index: AQHX5tHI6VSZDPA0J0GM0KIP7fuaeKweu+CAgAAaFvD///01gIAAEg9QgAFg9oCAAC4FMIAE3cYA
Date:   Mon, 6 Dec 2021 10:57:41 +0000
Message-ID: <e38392762299459890eee792a3a7cb09@huawei.com>
References: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
 <20211201163708.3578176-1-roberto.sassu@huawei.com>
 <Yahz1SYRG1CQIh0z@infradead.org>
 <e57d2d23ec7845febb79ca4476c73fcb@huawei.com>
 <YaiHX+dWNUlmsNac@infradead.org>
 <b4bf4a384b334cdab1522b3b082bd088@huawei.com>
 <Yam+m9eiLxIamGXm@infradead.org>
 <28208b7f142f4295ac5c857af5cffe07@huawei.com>
In-Reply-To: <28208b7f142f4295ac5c857af5cffe07@huawei.com>
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

> From: Roberto Sassu [mailto:roberto.sassu@huawei.com]
> Sent: Friday, December 3, 2021 11:20 AM
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Friday, December 3, 2021 7:52 AM
> > On Thu, Dec 02, 2021 at 09:29:52AM +0000, Roberto Sassu wrote:
> > > The problem being solved is how to grant access to files
> > > which satisfy a property defined in the policy.
> >
> > If you have want to enforce access to files in the block layer using
> > a specific stacking block driver you don't just have one layering
> > violation but a bunch of them.  Please go back to the drawing board.
> 
> Ok. I write my thoughts here, so that it is easier to align.
> 
> dm-verity provides block-level integrity, which means that
> the block layer itself is responsible to not pass data to the
> upper layer, the filesystem, if a block is found corrupted.
> 
> The dm-verity root digest represents the immutable state
> of the block device. dm-verity is still responsible to enforce
> accesses to the block device according to the root digest
> passed at device setup time. Nothing changes, the block
> layer still detects data corruption against the passed
> reference value.
> 
> The task of the security layer is to decide whether or not
> the root digest passed at device setup time is acceptable,
> e.g. it represents a device containing genuine files coming
> from a software vendor.
> 
> The mandatory policy can be enforced at different layers,
> depending on whether the security controls are placed.
> A possibility would be to deny mounting block devices that
> don't satisfy the mandatory policy.
> 
> However, if the mandatory policy wants only to restrict
> execution of approved files and allowing the rest, making
> the decision at the block layer is too coarse and restrictive.
> It would force the user to mount only approved block
> devices. The security layer must operate on files to enforce
> this policy.
> 
> Now probably there is the part where there is no agreement.
> 
> The integrity property of a block device applies also to the
> files on the filesystem mounted from that device. User space
> programs cannot access files in that filesystem coming from a
> device with a different dm-verity root digest, or files stored
> in a corrupted block device.
> 
> If what I wrote is correct, that the integrity property is preserved
> across the layers, this would give enough flexibility to enforce
> policies at a higher layer, although that property is guaranteed
> by a lower layer.

Hi Christoph

did I address your concerns? If yes, I could send the new patch
set, including the patch that uses the new functionality.

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua
