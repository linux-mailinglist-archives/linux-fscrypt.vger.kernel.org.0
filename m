Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609F21DD3A4
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 May 2020 19:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgEUQ7n (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 May 2020 12:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728632AbgEUQ7n (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 May 2020 12:59:43 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93BF1207F7;
        Thu, 21 May 2020 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590080382;
        bh=c14hLdEnZSVVPYedVLDV9mvrhjUVu5XwPUW1+wz7CM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YxCinC0Q8GCFfckQO3EN00+zDcxGs1xTUHxJUaJAzJ/Ku4vS3oF8B8x3LMRvaaRtB
         siX9BdMuymKOqk6WgsmRUcFAoAVxhW0WPpP966uqVzZaiEqX4BXPiboQehhqEnIWGi
         JO1OHoTR3kgHqUYuNWRZ3b6xMRzqV9pPc3IcyUww=
Date:   Thu, 21 May 2020 09:59:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, jsorensen@fb.com, kernel-team@fb.com
Subject: Re: [PATCH 2/3] Introduce libfsverity
Message-ID: <20200521165941.GB12790@gmail.com>
References: <20200515041042.267966-1-ebiggers@kernel.org>
 <20200515041042.267966-3-ebiggers@kernel.org>
 <5818763c-f8e0-f5d3-d054-4818f3c4b2b3@gmail.com>
 <20200521160804.GA12790@gmail.com>
 <2b2a2747-93e7-3a86-5d7f-86ec9fd5b207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b2a2747-93e7-3a86-5d7f-86ec9fd5b207@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, May 21, 2020 at 12:45:57PM -0400, Jes Sorensen wrote:
> >> My biggest objection is the export of kernel datatypes to userland and I
> >> really don't think using u32/u16/u8 internally in the library adds any
> >> value. I had explicitly converted it to uint32_t/uint16_t/uint8_t in my
> >> version.
> > 
> > I prefer u64/u32/u16/u8 since they're shorter and easier to read, and it's the
> > same convention that is used in the kernel code (which is where the other half
> > of fs-verity is).
> 
> I like them too, but I tend to live in kernel space.
> 
> > Note that these types aren't "exported" to or from anywhere but rather are just
> > typedefs in common/common_defs.h.  It's just a particular convention.
> > 
> > Also, fsverity-utils is already using this convention prior to this patchset.
> > If we did decide to change it, then we should change it in all the code, not
> > just in certain places.
> 
> I thought I did it everywhere in my patch set?

No, they were still left in various places.

> 
> >> I also wonder if we should introduce an
> >> libfsverity_get_digest_size(alg_nr) function? It would be useful for a
> >> caller trying to allocate buffers to store them in, to be able to do
> >> this prior to calculating the first digest.
> > 
> > That already exists; it's called libfsverity_digest_size().
> > 
> > Would it be clearer if we renamed:
> > 
> > 	libfsverity_digest_size() => libfsverity_get_digest_size()
> > 	libfsverity_hash_name() => libfsverity_get_hash_name()
> 
> Oh I missed you added that. Probably a good idea to rename them for
> consistency.

libfsverity_digest_size() was actually in your patchset too.

I'll add the "get" to the names so that all function names start with a verb.

> >>> +static void *xmalloc(size_t size)
> >>> +{
> >>> +	void *p = malloc(size);
> >>> +
> >>> +	if (!p)
> >>> +		libfsverity_error_msg("out of memory");
> >>> +	return p;
> >>> +}
> >>> +
> >>> +void *libfsverity_zalloc(size_t size)
> >>> +{
> >>> +	void *p = xmalloc(size);
> >>> +
> >>> +	if (!p)
> >>> +		return NULL;
> >>> +	return memset(p, 0, size);
> >>> +}
> >>
> >> I suggest we get rid of xmalloc() and libfsverity_zalloc(). libc
> >> provides perfectly good malloc() and calloc() functions, and printing an
> >> out of memory error in a generic location doesn't tell us where the
> >> error happened. If anything those error messages should be printed by
> >> the calling function IMO.
> >>
> > 
> > Maybe.  I'm not sure knowing the specific allocation sites would be useful
> > enough to make all the callers handle printing the error message (which is
> > easily forgotten about).  We could also add the allocation size that failed to
> > the message here.
> 
> My point is mostly at this point, this just adds code obfuscation rather
> than adding real value. I can see how it was useful during initial
> development.

It's helpful to eliminate the need for callers to print the error message.

We also still need libfsverity_memdup() anyway, unless we hard-code
malloc() + memcpy().

I also had in mind that we'd follow the (increasingly recommended) practice of
initializing all heap memory.  This can be done by only providing allocation
functions that initialize memory.

I'll think about it.

- Eric
