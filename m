Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6DF4A5023
	for <lists+linux-fscrypt@lfdr.de>; Mon, 31 Jan 2022 21:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiAaUbP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 31 Jan 2022 15:31:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49912 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiAaUbM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 31 Jan 2022 15:31:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C8B1B82AD8;
        Mon, 31 Jan 2022 20:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9C2C340E8;
        Mon, 31 Jan 2022 20:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643661069;
        bh=mzzdra74ur9eVXlCW1Uz95SUmxm4bd57lUeVLJ28rQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QmXTWETrZCVHmaIjT4Nb8HYAzWEbwCAQSUlszwL6oRCNdlNyZWbjcC+9aMlN6Auev
         Y5JbS4ucrTM2ceHpjHgSfuDgJwCDzvbLFYUjMKydKMj3A7Cx9lXtfz342d9+1pTdtQ
         hfm9RbyvQ4iecW7TJc5AmUghaHvZJbCM0pzhTfbplxXuRtqAZK4otlhtjhz61dU9WT
         DoyDVemzdW/+srNEpwGcq/XNCBfKJR1CACePMuHkL1ToU3GD+gaMw8PvPpj8JH1QH9
         4NyvLWKksKI9CREx7WUXGzWUN21o6KCYL3zrCV5TKtKONt0lqny+EA6BHME1vFHHoP
         LqSYMamv74OLw==
Date:   Mon, 31 Jan 2022 20:31:08 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "stefanb@linux.ibm.com" <stefanb@linux.ibm.com>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v3a 00/11] ima: support fs-verity digests and
 signatures (alternative)
Message-ID: <YfhHDBdtW6uyiN/j@gmail.com>
References: <20220127184614.2837938-1-roberto.sassu@huawei.com>
 <YfLz8NftvbZtKvLT@sol.localdomain>
 <YfL0+q/ekv4H8lZg@sol.localdomain>
 <d122893c426f44aa95d5168773b60b9d@huawei.com>
 <YfRRUBZpQv2Hi1sL@sol.localdomain>
 <9af14af14beb46a28f57559e4b1dc1a7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9af14af14beb46a28f57559e4b1dc1a7@huawei.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 31, 2022 at 03:12:42PM +0000, Roberto Sassu wrote:
> > From: Eric Biggers [mailto:ebiggers@kernel.org]
> > Sent: Friday, January 28, 2022 9:26 PM
> > On Fri, Jan 28, 2022 at 09:05:01AM +0000, Roberto Sassu wrote:
> > > > From: Eric Biggers [mailto:ebiggers@kernel.org]
> > > > Sent: Thursday, January 27, 2022 8:40 PM
> > > > On Thu, Jan 27, 2022 at 11:35:12AM -0800, Eric Biggers wrote:
> > > > > On Thu, Jan 27, 2022 at 07:46:09PM +0100, Roberto Sassu wrote:
> > > > > > I wanted to propose a different approach for handling fsverity digests
> > and
> > > > > > signatures, compared to:
> > > > > >
> > > > > > https://lore.kernel.org/linux-integrity/20220126000658.138345-1-
> > > > zohar@linux.ibm.com/
> > > > > >
> > > > > > In the original proposal, a new signature version has been introduced (v3)
> > > > > > to allow the possibility of signing the digest of a more flexible data
> > > > > > structure, ima_file_id, which could also include the fsverity file digest.
> > > > > >
> > > > > > While the new signature type would be sufficient to handle fsverity file
> > > > > > digests, the problem is that its format would not be compatible with the
> > > > > > signature format supported by the built-in verification module in fsverity.
> > > > > > The rpm package manager already has an extension to include fsverity
> > > > > > signatures, with the existing format, in the RPM header.
> > > > > >
> > > > > > Given that the fsverity signature is in the PKCS#7 format, IMA has already
> > > > > > the capability of handling it with the existing code, more specifically the
> > > > > > modsig code. It would be sufficient to provide to modsig the correct data
> > > > > > to avoid introducing a new signature format.
> > > > >
> > > > > I think it would be best to get people moved off of the fs-verity built-in
> > > > > signatures, rather than further extend the use of it.  PKCS#7 is a pretty
> > > > > terrible signature format.  The IMA one is better, though it's unfortunate
> > that
> > > > > IMA still relies on X.509 for keys.
> > > >
> > > > Note, the only reason that support for fs-verity built-in signatures was added
> > > > to RPM is that people didn't want to use IMA:
> > > > https://lore.kernel.org/linux-fscrypt/b49b4367-51e7-f62a-6209-
> > > > b46a6880824b@gmail.com
> > > >
> > > > If people are going to use IMA anyway, then there would be no point.
> > >
> > > Hi Eric
> > >
> > > I thought that the solution I came with could satisfy multiple needs.
> > >
> > > For people that don't want to use IMA, they could still continue
> > > to use the existing signature format, and wait for an LSM that
> > > satisfy their needs. They also have the option to migrate to the
> > > new signature format you are defining. But will those people be
> > > willing to switch to something IMA-specific?
> > >
> > > For people that use IMA, they could benefit from the effort
> > > of people creating packages with the original fsverity signature.
> > >
> > > For people that are skeptical about IMA, they could be interested
> > > in trying the full solution, which would probably be more easily
> > > available if the efforts from both sides converge.
> > >
> > > If, as you say, you have concerns about the existing signature
> > > format, wouldn't it be better that you address them from the
> > > fsverity side, so that all users of fsverity can benefit from it?
> > >
> > > Currently, fsverity hashes the formatted digest whose format
> > > is FSVerity<digest algo><digest size><digest>. Couldn't IMA
> > > hash the same data as well?
> > >
> > > An idea could be to always sign the formatted digest, and have
> > > a selector for the signature format: IMA, PKCS#7 or PGP.
> > 
> > Adding support for the new IMA signature format to fsverity_verify_signature()
> > *might* make sense.  (When I added this code, my understanding was that it
> > was
> > just verifying signatures the way the kernel usually verifies signatures.  I
> 
> Ok. Do we need something more to sign other than the fsverity
> formatted digest? If not, this could be the same for any method
> we support.
> 
> > don't think I realized there was a more direct, PKCS#7-less way to do it and
> > that IMA used that way.)  However, it would be better to use this as an
> > opportunity to move people off of the built-in signatures entirely, either by
> > switching to a full userspace solution or by switching to IMA.
> 
> If what we sign remains the same, then we could support multiple
> methods and use a selector to let fsverity_verify_signature() know
> how it should verify the signature. I don't know what would be a
> proper place for the selector.
> 
> PKCS#7 seems ok, as it is used for kernel modules. IMA would be
> also ok, as it can verify the signature more directly. I would also
> be interested in supporting PGP, to avoid the requirement for
> Linux distributions to manage a secondary key. I have a small
> extension for rpmsign, that I would like to test in the Fedora
> infrastructure.
> 
> Both the PKCS#7 and the PGP methods don't require additional
> support from outside, the functions verify_pkcs7_signature()
> and verify_pgp_signature() (proposed, not yet in the upstream
> kernel) would be sufficient.
> 
> The IMA method instead would require the signature_v2_hdr
> structure to be exported to user space, so that rpm could
> produce a blob that can be interpreted by the kernel (this
> work could also be done by evmctl). Also, IMA should pass
> its .ima keyring to fsverity for signature verification, or should
> simply get the signature and do the verification internally.
> 
> Given that fsverity has already the capability of managing the
> signature blob, it would make sense to still keep it. Adding it
> in an xattr could be possible, but it would introduce more
> constraints (requiring the filesystem to support xattrs). And,
> an user of fsverity willing to use the IMA method would have
> to look at security.ima.
> 
> To summarize: I would prefer a method that relies on an
> existing signature verification mechanism (PKCS#7) or that
> has an equivalent API and simplify support for Linux distributions
> (PGP). If we add the IMA method, available outside IMA, we
> need to also add support for user space so that it can produces
> the signature in the desired format, and preferably should use
> the fsverity way of getting the signature. If the IMA method
> would be used by IMA only, then IMA could store the signature
> in its xattr and do the verification independently.
> 
> Roberto
> 

I think you are conflating the signatures themselves from where they are stored.
The fs-verity built-in signatures feature could be extended to support the same
signatures as IMA, while still storing the signature in the same way the
fs-verity built-in signatures are currently stored (which doesn't use xattrs).

But as I said, I don't think it makes sense to continue building on the
fs-verity built-in signatures feature, as opposed to guiding users towards a
full userspace solution or to IMA instead.

- Eric
