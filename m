Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69D04A49E5
	for <lists+linux-fscrypt@lfdr.de>; Mon, 31 Jan 2022 16:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359534AbiAaPMq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 31 Jan 2022 10:12:46 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4567 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358836AbiAaPMo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 31 Jan 2022 10:12:44 -0500
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JnWfz7491z67PMg;
        Mon, 31 Jan 2022 23:08:59 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 31 Jan 2022 16:12:42 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Mon, 31 Jan 2022 16:12:42 +0100
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
Thread-Index: AQHYE64xQMi+Kgkov0iDDqwbxhwgiax3MeAAgAABPQCAAOKyQIAAvI4AgAQic5A=
Date:   Mon, 31 Jan 2022 15:12:42 +0000
Message-ID: <9af14af14beb46a28f57559e4b1dc1a7@huawei.com>
References: <20220127184614.2837938-1-roberto.sassu@huawei.com>
 <YfLz8NftvbZtKvLT@sol.localdomain> <YfL0+q/ekv4H8lZg@sol.localdomain>
 <d122893c426f44aa95d5168773b60b9d@huawei.com>
 <YfRRUBZpQv2Hi1sL@sol.localdomain>
In-Reply-To: <YfRRUBZpQv2Hi1sL@sol.localdomain>
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
> Sent: Friday, January 28, 2022 9:26 PM
> On Fri, Jan 28, 2022 at 09:05:01AM +0000, Roberto Sassu wrote:
> > > From: Eric Biggers [mailto:ebiggers@kernel.org]
> > > Sent: Thursday, January 27, 2022 8:40 PM
> > > On Thu, Jan 27, 2022 at 11:35:12AM -0800, Eric Biggers wrote:
> > > > On Thu, Jan 27, 2022 at 07:46:09PM +0100, Roberto Sassu wrote:
> > > > > I wanted to propose a different approach for handling fsverity digests
> and
> > > > > signatures, compared to:
> > > > >
> > > > > https://lore.kernel.org/linux-integrity/20220126000658.138345-1-
> > > zohar@linux.ibm.com/
> > > > >
> > > > > In the original proposal, a new signature version has been introduced (v3)
> > > > > to allow the possibility of signing the digest of a more flexible data
> > > > > structure, ima_file_id, which could also include the fsverity file digest.
> > > > >
> > > > > While the new signature type would be sufficient to handle fsverity file
> > > > > digests, the problem is that its format would not be compatible with the
> > > > > signature format supported by the built-in verification module in fsverity.
> > > > > The rpm package manager already has an extension to include fsverity
> > > > > signatures, with the existing format, in the RPM header.
> > > > >
> > > > > Given that the fsverity signature is in the PKCS#7 format, IMA has already
> > > > > the capability of handling it with the existing code, more specifically the
> > > > > modsig code. It would be sufficient to provide to modsig the correct data
> > > > > to avoid introducing a new signature format.
> > > >
> > > > I think it would be best to get people moved off of the fs-verity built-in
> > > > signatures, rather than further extend the use of it.  PKCS#7 is a pretty
> > > > terrible signature format.  The IMA one is better, though it's unfortunate
> that
> > > > IMA still relies on X.509 for keys.
> > >
> > > Note, the only reason that support for fs-verity built-in signatures was added
> > > to RPM is that people didn't want to use IMA:
> > > https://lore.kernel.org/linux-fscrypt/b49b4367-51e7-f62a-6209-
> > > b46a6880824b@gmail.com
> > >
> > > If people are going to use IMA anyway, then there would be no point.
> >
> > Hi Eric
> >
> > I thought that the solution I came with could satisfy multiple needs.
> >
> > For people that don't want to use IMA, they could still continue
> > to use the existing signature format, and wait for an LSM that
> > satisfy their needs. They also have the option to migrate to the
> > new signature format you are defining. But will those people be
> > willing to switch to something IMA-specific?
> >
> > For people that use IMA, they could benefit from the effort
> > of people creating packages with the original fsverity signature.
> >
> > For people that are skeptical about IMA, they could be interested
> > in trying the full solution, which would probably be more easily
> > available if the efforts from both sides converge.
> >
> > If, as you say, you have concerns about the existing signature
> > format, wouldn't it be better that you address them from the
> > fsverity side, so that all users of fsverity can benefit from it?
> >
> > Currently, fsverity hashes the formatted digest whose format
> > is FSVerity<digest algo><digest size><digest>. Couldn't IMA
> > hash the same data as well?
> >
> > An idea could be to always sign the formatted digest, and have
> > a selector for the signature format: IMA, PKCS#7 or PGP.
> 
> Adding support for the new IMA signature format to fsverity_verify_signature()
> *might* make sense.  (When I added this code, my understanding was that it
> was
> just verifying signatures the way the kernel usually verifies signatures.  I

Ok. Do we need something more to sign other than the fsverity
formatted digest? If not, this could be the same for any method
we support.

> don't think I realized there was a more direct, PKCS#7-less way to do it and
> that IMA used that way.)  However, it would be better to use this as an
> opportunity to move people off of the built-in signatures entirely, either by
> switching to a full userspace solution or by switching to IMA.

If what we sign remains the same, then we could support multiple
methods and use a selector to let fsverity_verify_signature() know
how it should verify the signature. I don't know what would be a
proper place for the selector.

PKCS#7 seems ok, as it is used for kernel modules. IMA would be
also ok, as it can verify the signature more directly. I would also
be interested in supporting PGP, to avoid the requirement for
Linux distributions to manage a secondary key. I have a small
extension for rpmsign, that I would like to test in the Fedora
infrastructure.

Both the PKCS#7 and the PGP methods don't require additional
support from outside, the functions verify_pkcs7_signature()
and verify_pgp_signature() (proposed, not yet in the upstream
kernel) would be sufficient.

The IMA method instead would require the signature_v2_hdr
structure to be exported to user space, so that rpm could
produce a blob that can be interpreted by the kernel (this
work could also be done by evmctl). Also, IMA should pass
its .ima keyring to fsverity for signature verification, or should
simply get the signature and do the verification internally.

Given that fsverity has already the capability of managing the
signature blob, it would make sense to still keep it. Adding it
in an xattr could be possible, but it would introduce more
constraints (requiring the filesystem to support xattrs). And,
an user of fsverity willing to use the IMA method would have
to look at security.ima.

To summarize: I would prefer a method that relies on an
existing signature verification mechanism (PKCS#7) or that
has an equivalent API and simplify support for Linux distributions
(PGP). If we add the IMA method, available outside IMA, we
need to also add support for user space so that it can produces
the signature in the desired format, and preferably should use
the fsverity way of getting the signature. If the IMA method
would be used by IMA only, then IMA could store the signature
in its xattr and do the verification independently.

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua

> Part of the problem with IMA is that no one wants to use it because it has
> terrible documentation.  It sounds like it's really complicated, and tied to
> specific TCG standards and to TPMs.  I think if it was documented better, people
> would find it more attractive and wouldn't be trying to avoid it at all costs.
> 
> - Eric
