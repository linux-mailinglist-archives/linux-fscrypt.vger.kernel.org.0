Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869B6159D0D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Feb 2020 00:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgBKXO4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Feb 2020 18:14:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbgBKXO4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Feb 2020 18:14:56 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0388B206DB;
        Tue, 11 Feb 2020 23:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581462896;
        bh=hU6hvT0rJdShTfpvhGbUhx1jki5aFM2Gf5ro7UMQweQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RJwW5hAKzel2OHcsVp2cSvdU0X/MLBkmYpB99uoZoA/nvfabB+QKYYHIgWs45U/Tj
         vRS31QRjmy00a15xCgpSzQgcuIb5obYS0vqiXS5am09CrStrqvTowJGJSCrQDrHCDB
         +el2sdq1Df9bTSlisOdV7/FT2FX5aTJozZBZJmfc=
Date:   Tue, 11 Feb 2020 15:14:54 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH 0/7] Split fsverity-utils into a shared library
Message-ID: <20200211231454.GB870@sol.localdomain>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
 <20200211192209.GA870@sol.localdomain>
 <b49b4367-51e7-f62a-6209-b46a6880824b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b49b4367-51e7-f62a-6209-b46a6880824b@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Feb 11, 2020 at 05:09:22PM -0500, Jes Sorensen wrote:
> On 2/11/20 2:22 PM, Eric Biggers wrote:
> > Hi Jes,
> > 
> > On Mon, Feb 10, 2020 at 07:00:30PM -0500, Jes Sorensen wrote:
> >> From: Jes Sorensen <jsorensen@fb.com>
> >> If we can agree on the approach, then I am happy to deal with the full
> >> libtoolification etc.
> > 
> > Before we do all this work, can you take a step back and explain the use case so
> > that we can be sure it's really worthwhile?
> > 
> > fsverity_cmd_enable() and fsverity_cmd_measure() would just be trivial wrappers
> > around the FS_IOC_ENABLE_VERITY and FS_IOC_MEASURE_VERITY ioctls, so they don't
> > need a library.  [Aside: I'd suggest calling these fsverity_enable() and
> > fsverity_measure(), and leaving "cmd" for the command-line wrappers.] 
> > 
> > That leaves signing as the only real point of the library.  But do you actually
> > need to be able to *sign* the files via the rpm binary, or do you just need to
> > be able to install already-created signatures?  I.e., can the signatures instead
> > just be created with 'fsverity sign' when building the RPMs?
> 
> So I basically want to be able to carry verity signatures in RPM as RPM
> internal data, similar to how it supports IMA signatures. I want to be
> able to install those without relying on post-install scripts and
> signature files being distributed as actual files that gets installed,
> just to have to remove them. This is how IMA support is integrated into
> RPM as well.
> 
> Right now the RPM approach for signatures involves two steps, a build
> digest phase, and a sign the digest phase.
> 
> The reason I included enable and measure was for completeness. I don't
> care wildly about those.

So the signing happens when the RPM is built, not when it's installed?  Are you
sure you actually need a library and not just 'fsverity sign' called from a
build script?

> 
> > Separately, before you start building something around fs-verity's builtin
> > signature verification support, have you also considered adding support for
> > fs-verity to IMA?  I.e., using the fs-verity hashing mechanism with the IMA
> > signature mechanism.  The IMA maintainer has been expressed interested in that.
> > If rpm already supports IMA signatures, maybe that way would be a better fit?
> 
> I looked at IMA and it is overly complex. It is not obvious to me how
> you would get around that without the full complexity of IMA? The beauty
> of fsverity's approach is the simplicity of relying on just the kernel
> keyring for validation of the signature. If you have explicit
> suggestions, I am certainly happy to look at it.

fs-verity's builtin signature verification feature is simple, but does it
actually do what you need?  Note that unlike IMA, it doesn't provide an
in-kernel policy about which files have to have signatures and which don't.
I.e., to get any authenticity guarantee, before using any files that are
supposed to be protected by fs-verity, userspace has to manually check whether
the fs-verity bit is actually set.  Is that part of your design?

- Eric
