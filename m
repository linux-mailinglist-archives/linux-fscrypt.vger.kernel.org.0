Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C55049F5E6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 28 Jan 2022 10:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237515AbiA1JFE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 28 Jan 2022 04:05:04 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4537 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiA1JFE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 28 Jan 2022 04:05:04 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JlWfJ32hPz67tnp;
        Fri, 28 Jan 2022 17:01:28 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 28 Jan 2022 10:05:01 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Fri, 28 Jan 2022 10:05:01 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "stefanb@linux.ibm.com" <stefanb@linux.ibm.com>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC][PATCH v3a 00/11] ima: support fs-verity digests and
 signatures (alternative)
Thread-Topic: [RFC][PATCH v3a 00/11] ima: support fs-verity digests and
 signatures (alternative)
Thread-Index: AQHYE64xQMi+Kgkov0iDDqwbxhwgiax3MeAAgAABPQCAAOKyQA==
Date:   Fri, 28 Jan 2022 09:05:01 +0000
Message-ID: <d122893c426f44aa95d5168773b60b9d@huawei.com>
References: <20220127184614.2837938-1-roberto.sassu@huawei.com>
 <YfLz8NftvbZtKvLT@sol.localdomain> <YfL0+q/ekv4H8lZg@sol.localdomain>
In-Reply-To: <YfL0+q/ekv4H8lZg@sol.localdomain>
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

> From: Eric Biggers [mailto:ebiggers@kernel.org]
> Sent: Thursday, January 27, 2022 8:40 PM
> On Thu, Jan 27, 2022 at 11:35:12AM -0800, Eric Biggers wrote:
> > On Thu, Jan 27, 2022 at 07:46:09PM +0100, Roberto Sassu wrote:
> > > I wanted to propose a different approach for handling fsverity digests and
> > > signatures, compared to:
> > >
> > > https://lore.kernel.org/linux-integrity/20220126000658.138345-1-
> zohar@linux.ibm.com/
> > >
> > > In the original proposal, a new signature version has been introduced (v3)
> > > to allow the possibility of signing the digest of a more flexible data
> > > structure, ima_file_id, which could also include the fsverity file digest.
> > >
> > > While the new signature type would be sufficient to handle fsverity file
> > > digests, the problem is that its format would not be compatible with the
> > > signature format supported by the built-in verification module in fsverity.
> > > The rpm package manager already has an extension to include fsverity
> > > signatures, with the existing format, in the RPM header.
> > >
> > > Given that the fsverity signature is in the PKCS#7 format, IMA has already
> > > the capability of handling it with the existing code, more specifically the
> > > modsig code. It would be sufficient to provide to modsig the correct data
> > > to avoid introducing a new signature format.
> >
> > I think it would be best to get people moved off of the fs-verity built-in
> > signatures, rather than further extend the use of it.  PKCS#7 is a pretty
> > terrible signature format.  The IMA one is better, though it's unfortunate that
> > IMA still relies on X.509 for keys.
> 
> Note, the only reason that support for fs-verity built-in signatures was added
> to RPM is that people didn't want to use IMA:
> https://lore.kernel.org/linux-fscrypt/b49b4367-51e7-f62a-6209-
> b46a6880824b@gmail.com
> 
> If people are going to use IMA anyway, then there would be no point.

Hi Eric

I thought that the solution I came with could satisfy multiple needs.

For people that don't want to use IMA, they could still continue
to use the existing signature format, and wait for an LSM that
satisfy their needs. They also have the option to migrate to the
new signature format you are defining. But will those people be
willing to switch to something IMA-specific?

For people that use IMA, they could benefit from the effort
of people creating packages with the original fsverity signature.

For people that are skeptical about IMA, they could be interested
in trying the full solution, which would probably be more easily
available if the efforts from both sides converge.

If, as you say, you have concerns about the existing signature
format, wouldn't it be better that you address them from the
fsverity side, so that all users of fsverity can benefit from it?

Currently, fsverity hashes the formatted digest whose format
is FSVerity<digest algo><digest size><digest>. Couldn't IMA
hash the same data as well?

An idea could be to always sign the formatted digest, and have
a selector for the signature format: IMA, PKCS#7 or PGP.

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua
