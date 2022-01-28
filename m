Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD394A01CC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 28 Jan 2022 21:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbiA1UZ5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 28 Jan 2022 15:25:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58708 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiA1UZ4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 28 Jan 2022 15:25:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FAD0B825E4;
        Fri, 28 Jan 2022 20:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D38DC340E7;
        Fri, 28 Jan 2022 20:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643401554;
        bh=Ph1OyR1ecXlZ+Bdc35dZNoDYirpUuMYM5Ao7nVsb3XM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ly2c+WcC64vuUxS2yM7Ja9KzeZG3/gUJ1Me66weZMQ9tFKcHzxHs7/lLFpT77b8do
         Ir05XW4W+FHR3B1mQY7Gd8MxBksc1AJAX+tvMO4CasGVPWPXsY5GWvzZ2ilV5abDN/
         iuuNU3qDhYhTQhPH3AxCcGFSF3qNyNSGQe2Rk2PiRzvxmTeVzSEUCBVoZNtAYF/wGW
         qG2q0AJWQJgSZbZA3ohuhCyltyY/t9lzl13gDj300WdUwZLDNW7ByoQi88vLJHCbrO
         qUjnD+wlaAR4+lSUktSgQ7tAwfdPOqjJODrv0cW+KT9AFqOsPy/25wtcl6nF9Fu1z1
         qaH2bknZ/h+8g==
Date:   Fri, 28 Jan 2022 12:25:52 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "stefanb@linux.ibm.com" <stefanb@linux.ibm.com>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v3a 00/11] ima: support fs-verity digests and
 signatures (alternative)
Message-ID: <YfRRUBZpQv2Hi1sL@sol.localdomain>
References: <20220127184614.2837938-1-roberto.sassu@huawei.com>
 <YfLz8NftvbZtKvLT@sol.localdomain>
 <YfL0+q/ekv4H8lZg@sol.localdomain>
 <d122893c426f44aa95d5168773b60b9d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d122893c426f44aa95d5168773b60b9d@huawei.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jan 28, 2022 at 09:05:01AM +0000, Roberto Sassu wrote:
> > From: Eric Biggers [mailto:ebiggers@kernel.org]
> > Sent: Thursday, January 27, 2022 8:40 PM
> > On Thu, Jan 27, 2022 at 11:35:12AM -0800, Eric Biggers wrote:
> > > On Thu, Jan 27, 2022 at 07:46:09PM +0100, Roberto Sassu wrote:
> > > > I wanted to propose a different approach for handling fsverity digests and
> > > > signatures, compared to:
> > > >
> > > > https://lore.kernel.org/linux-integrity/20220126000658.138345-1-
> > zohar@linux.ibm.com/
> > > >
> > > > In the original proposal, a new signature version has been introduced (v3)
> > > > to allow the possibility of signing the digest of a more flexible data
> > > > structure, ima_file_id, which could also include the fsverity file digest.
> > > >
> > > > While the new signature type would be sufficient to handle fsverity file
> > > > digests, the problem is that its format would not be compatible with the
> > > > signature format supported by the built-in verification module in fsverity.
> > > > The rpm package manager already has an extension to include fsverity
> > > > signatures, with the existing format, in the RPM header.
> > > >
> > > > Given that the fsverity signature is in the PKCS#7 format, IMA has already
> > > > the capability of handling it with the existing code, more specifically the
> > > > modsig code. It would be sufficient to provide to modsig the correct data
> > > > to avoid introducing a new signature format.
> > >
> > > I think it would be best to get people moved off of the fs-verity built-in
> > > signatures, rather than further extend the use of it.  PKCS#7 is a pretty
> > > terrible signature format.  The IMA one is better, though it's unfortunate that
> > > IMA still relies on X.509 for keys.
> > 
> > Note, the only reason that support for fs-verity built-in signatures was added
> > to RPM is that people didn't want to use IMA:
> > https://lore.kernel.org/linux-fscrypt/b49b4367-51e7-f62a-6209-
> > b46a6880824b@gmail.com
> > 
> > If people are going to use IMA anyway, then there would be no point.
> 
> Hi Eric
> 
> I thought that the solution I came with could satisfy multiple needs.
> 
> For people that don't want to use IMA, they could still continue
> to use the existing signature format, and wait for an LSM that
> satisfy their needs. They also have the option to migrate to the
> new signature format you are defining. But will those people be
> willing to switch to something IMA-specific?
> 
> For people that use IMA, they could benefit from the effort
> of people creating packages with the original fsverity signature.
> 
> For people that are skeptical about IMA, they could be interested
> in trying the full solution, which would probably be more easily
> available if the efforts from both sides converge.
> 
> If, as you say, you have concerns about the existing signature
> format, wouldn't it be better that you address them from the
> fsverity side, so that all users of fsverity can benefit from it?
> 
> Currently, fsverity hashes the formatted digest whose format
> is FSVerity<digest algo><digest size><digest>. Couldn't IMA
> hash the same data as well?
> 
> An idea could be to always sign the formatted digest, and have
> a selector for the signature format: IMA, PKCS#7 or PGP.

Adding support for the new IMA signature format to fsverity_verify_signature()
*might* make sense.  (When I added this code, my understanding was that it was
just verifying signatures the way the kernel usually verifies signatures.  I
don't think I realized there was a more direct, PKCS#7-less way to do it and
that IMA used that way.)  However, it would be better to use this as an
opportunity to move people off of the built-in signatures entirely, either by
switching to a full userspace solution or by switching to IMA.

Part of the problem with IMA is that no one wants to use it because it has
terrible documentation.  It sounds like it's really complicated, and tied to
specific TCG standards and to TPMs.  I think if it was documented better, people
would find it more attractive and wouldn't be trying to avoid it at all costs.

- Eric
