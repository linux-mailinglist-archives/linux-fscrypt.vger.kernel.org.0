Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9338415F7C7
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Feb 2020 21:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbgBNUfN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 14 Feb 2020 15:35:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730163AbgBNUfN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 14 Feb 2020 15:35:13 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98879222C4;
        Fri, 14 Feb 2020 20:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581712512;
        bh=s2PfDDVsS2Jcc6jj65NRqa7l04dU/6FNW60qI02Wa5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ykxcooURmYIqAyeiWVRhLNEFwLH8iXxlNCdR1q14ylt/GYPb7BHHgbwFtw+rkCcrm
         BVefdSi98G4h4r6o7mma0DRnb93S65VvPmcyzStPpC4DUV8xst1Lh8VcmQEuzc53ca
         JEyGYIwwutHTH/d721mcKbdlEoTMjaCJUcwqVAr0=
Date:   Fri, 14 Feb 2020 12:35:11 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH 0/7] Split fsverity-utils into a shared library
Message-ID: <20200214203510.GA1985@gmail.com>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
 <20200211192209.GA870@sol.localdomain>
 <b49b4367-51e7-f62a-6209-b46a6880824b@gmail.com>
 <20200211231454.GB870@sol.localdomain>
 <c39f57d5-c9a4-5fbb-3ce3-cd21e90ef921@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c39f57d5-c9a4-5fbb-3ce3-cd21e90ef921@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Jes,

On Tue, Feb 11, 2020 at 06:35:45PM -0500, Jes Sorensen wrote:
> On 2/11/20 6:14 PM, Eric Biggers wrote:
> > On Tue, Feb 11, 2020 at 05:09:22PM -0500, Jes Sorensen wrote:
> >> On 2/11/20 2:22 PM, Eric Biggers wrote:
> >>> Hi Jes,
> >> So I basically want to be able to carry verity signatures in RPM as RPM
> >> internal data, similar to how it supports IMA signatures. I want to be
> >> able to install those without relying on post-install scripts and
> >> signature files being distributed as actual files that gets installed,
> >> just to have to remove them. This is how IMA support is integrated into
> >> RPM as well.
> >>
> >> Right now the RPM approach for signatures involves two steps, a build
> >> digest phase, and a sign the digest phase.
> >>
> >> The reason I included enable and measure was for completeness. I don't
> >> care wildly about those.
> > 
> > So the signing happens when the RPM is built, not when it's installed?  Are you
> > sure you actually need a library and not just 'fsverity sign' called from a
> > build script?
> 
> So the way RPM is handling these is to calculate the digest in one
> place, and sign it in another. Basically the signing is a second step,
> post build, using the rpmsign command. Shelling out is not a good fit
> for this model.
> 
> >>> Separately, before you start building something around fs-verity's builtin
> >>> signature verification support, have you also considered adding support for
> >>> fs-verity to IMA?  I.e., using the fs-verity hashing mechanism with the IMA
> >>> signature mechanism.  The IMA maintainer has been expressed interested in that.
> >>> If rpm already supports IMA signatures, maybe that way would be a better fit?
> >>
> >> I looked at IMA and it is overly complex. It is not obvious to me how
> >> you would get around that without the full complexity of IMA? The beauty
> >> of fsverity's approach is the simplicity of relying on just the kernel
> >> keyring for validation of the signature. If you have explicit
> >> suggestions, I am certainly happy to look at it.
> > 
> > fs-verity's builtin signature verification feature is simple, but does it
> > actually do what you need?  Note that unlike IMA, it doesn't provide an
> > in-kernel policy about which files have to have signatures and which don't.
> > I.e., to get any authenticity guarantee, before using any files that are
> > supposed to be protected by fs-verity, userspace has to manually check whether
> > the fs-verity bit is actually set.  Is that part of your design?
> 
> Totally aware of this, and it fits the model I am looking at.
> 

Well, this might be a legitimate use case then.  We need to define the library
interface as simply as possible, though, so that we can maintain this code in
the future without breaking users.  I suggest starting with something along the
lines of:

#ifndef _LIBFSVERITY_H
#define _LIBFSVERITY_H

#include <stddef.h>
#include <stdint.h>

#define FS_VERITY_HASH_ALG_SHA256       1
#define FS_VERITY_HASH_ALG_SHA512       2

struct libfsverity_merkle_tree_params {
	uint32_t version;
	uint32_t hash_algorithm;
	uint32_t block_size;
	uint32_t salt_size;
	const uint8_t *salt;
	size_t reserved[11];
};

struct libfsverity_digest {
	uint16_t digest_algorithm;
	uint16_t digest_size;
	uint8_t digest[];
};

struct libfsverity_signature_params {
	const char *keyfile;
	const char *certfile;
	size_t reserved[11];
};

int libfsverity_compute_digest(int fd,
			       const struct libfsverity_merkle_tree_params *params,
			       struct libfsverity_digest **digest_ret);

int libfsverity_sign_digest(const struct libfsverity_digest *digest,
			    const struct libfsverity_signature_params *sig_params,
			    void **sig_ret, size_t *sig_size_ret);

#endif /* _LIBFSVERITY_H */



I.e.:

- The stuff in util.h and hash_algs.h isn't exposed to library users.
- Then names of all library functions and structs are appropriately prefixed
  and avoid collisions with the kernel header.
- Only signing functionality is included.
- There are reserved fields, so we can add more parameters later.

Before committing to any stable API, it would also be helpful to see the RPM
patches to see what it actually does.

We'd also need to follow shared library best practices like compiling with
-fvisibility=hidden and marking the API functions explicitly with
__attribute__((visibility("default"))), and setting the 'soname' like
-Wl,-soname=libfsverity.so.0.

Also, is the GPLv2+ license okay for the use case?

- Eric
