Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD3A1DD2C4
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 May 2020 18:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbgEUQIH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 May 2020 12:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728774AbgEUQIG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 May 2020 12:08:06 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E02C220671;
        Thu, 21 May 2020 16:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590077286;
        bh=E+0gQUMfoJM+eFFib5tdgCP9MSzfO6t7IeWWKWS6xp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WBzE2cfT4MoDSUzmisvxB85XD7zsyGdCMNXlIr1/TvIGaK7twVWXIjLZB4MN/BACN
         P3K0ifDztJ3m1DWUx+2fb4LRgI60994JRExQIms//ToFh6zSZCdAK0oqTCf2HVvwas
         XW4YGdsLEa8HDh2Pk6UhEwZ4jwENodYBc+GiFX6U=
Date:   Thu, 21 May 2020 09:08:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, jsorensen@fb.com, kernel-team@fb.com
Subject: Re: [PATCH 2/3] Introduce libfsverity
Message-ID: <20200521160804.GA12790@gmail.com>
References: <20200515041042.267966-1-ebiggers@kernel.org>
 <20200515041042.267966-3-ebiggers@kernel.org>
 <5818763c-f8e0-f5d3-d054-4818f3c4b2b3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5818763c-f8e0-f5d3-d054-4818f3c4b2b3@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, May 21, 2020 at 11:24:34AM -0400, Jes Sorensen wrote:
> On 5/15/20 12:10 AM, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > From the 'fsverity' program, split out a library 'libfsverity'.
> > Currently it supports computing file measurements ("digests"), and
> > signing those file measurements for use with the fs-verity builtin
> > signature verification feature.
> > 
> > Rewritten from patches by Jes Sorensen <jsorensen@fb.com>.
> > I made a lot of improvements, e.g.:
> > 
> > - Separated library and program source into different directories.
> > - Drastically improved the Makefile.
> > - Added 'make check' target and rules to build test programs.
> > - In the shared lib, only export the functions intended to be public.
> > - Prefixed global functions with "libfsverity_" so that they don't cause
> >   conflicts when the library is built as a static library.
> > - Made library error messages be sent to a user-specified callback
> >   rather than always be printed to stderr.
> > - Keep showing OpenSSL error messages.
> > - Stopped abort()ing in library code, when possible.
> > - Made libfsverity_digest use native endianness.
> > - Moved file_size into the merkle_tree_params.
> > - Made libfsverity_hash_name() just return the static strings.
> > - Made some variables in the API uint32_t instead of uint16_t.
> > - Shared parse_hash_alg_option() between cmd_enable and cmd_sign.
> > - Lots of fixes.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Eric,
> 
> Here is a more detailed review. The code as we have it seems to work for
> me, but there are some issues that I think would be right to address:

Thanks for the feedback!

> 
> I appreciate that you improved the error return values from the original
> true/false/assert handling.
> 
> As much as I hate typedefs, I also like the introduction of
> libfsverity_read_fn_t as function pointers are somewhat annoying to deal
> with.
> 
> My biggest objection is the export of kernel datatypes to userland and I
> really don't think using u32/u16/u8 internally in the library adds any
> value. I had explicitly converted it to uint32_t/uint16_t/uint8_t in my
> version.

I prefer u64/u32/u16/u8 since they're shorter and easier to read, and it's the
same convention that is used in the kernel code (which is where the other half
of fs-verity is).

Note that these types aren't "exported" to or from anywhere but rather are just
typedefs in common/common_defs.h.  It's just a particular convention.

Also, fsverity-utils is already using this convention prior to this patchset.
If we did decide to change it, then we should change it in all the code, not
just in certain places.

> 
> max() defined in common/utils.h is not used by anything, so lets get rid
> of it.

Yes, I'll do that.

> 
> I also wonder if we should introduce an
> libfsverity_get_digest_size(alg_nr) function? It would be useful for a
> caller trying to allocate buffers to store them in, to be able to do
> this prior to calculating the first digest.

That already exists; it's called libfsverity_digest_size().

Would it be clearer if we renamed:

	libfsverity_digest_size() => libfsverity_get_digest_size()
	libfsverity_hash_name() => libfsverity_get_hash_name()

> > diff --git a/lib/compute_digest.c b/lib/compute_digest.c
> > index b279d63..13998bb 100644
> > --- a/lib/compute_digest.c
> > +++ b/lib/compute_digest.c
> > @@ -1,13 +1,13 @@
> ... snip ...
> > -const struct fsverity_hash_alg *find_hash_alg_by_name(const char *name)
> > +LIBEXPORT u32
> > +libfsverity_find_hash_alg_by_name(const char *name)
> 
> This export of u32 here is problematic.
> 

It's not "exported"; this is a .c file.  As long as we use the stdint.h name in
libfsverity.h (to avoid polluting the library user's namespace), it is okay.
u32 and uint32_t are compatible; they're just different names for the same type.

> > diff --git a/lib/sign_digest.c b/lib/sign_digest.c
> > index d2b0d53..d856392 100644
> > --- a/lib/sign_digest.c
> > +++ b/lib/sign_digest.c
> > @@ -1,45 +1,68 @@
> >  // SPDX-License-Identifier: GPL-2.0+
> >  /*
> > - * sign_digest.c
> > + * Implementation of libfsverity_sign_digest().
> >   *
> >   * Copyright (C) 2018 Google LLC
> > + * Copyright (C) 2020 Facebook
> >   */
> >  
> > -#include "hash_algs.h"
> > -#include "sign.h"
> > +#include "lib_private.h"
> >  
> >  #include <limits.h>
> >  #include <openssl/bio.h>
> >  #include <openssl/err.h>
> >  #include <openssl/pem.h>
> >  #include <openssl/pkcs7.h>
> > +#include <string.h>
> > +
> > +/*
> > + * Format in which verity file measurements are signed.  This is the same as
> > + * 'struct fsverity_digest', except here some magic bytes are prepended to
> > + * provide some context about what is being signed in case the same key is used
> > + * for non-fsverity purposes, and here the fields have fixed endianness.
> > + */
> > +struct fsverity_signed_digest {
> > +	char magic[8];			/* must be "FSVerity" */
> > +	__le16 digest_algorithm;
> > +	__le16 digest_size;
> > +	__u8 digest[];
> > +};
> 
> I don't really understand why you prefer to manage two versions of the
> digest, ie. libfsverity_digest and libfsverity_signed_digest, but it's
> not a big deal.

Because fsverity_signed_digest has a specific endianness, people will access the
fields directly and forget to do the needed endianness conventions -- thus
producing code that doesn't work on big endian systems.  Using a
native-endianness type for the intermediate struct avoids that pitfall.

I think keeping the byte order handling internal to the library is preferable.

> 
> > diff --git a/lib/utils.c b/lib/utils.c
> > new file mode 100644
> > index 0000000..0684526
> > --- /dev/null
> > +++ b/lib/utils.c
> > @@ -0,0 +1,107 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * Utility functions for libfsverity
> > + *
> > + * Copyright 2020 Google LLC
> > + */
> > +
> > +#define _GNU_SOURCE /* for asprintf() */
> > +
> > +#include "lib_private.h"
> > +
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +
> > +static void *xmalloc(size_t size)
> > +{
> > +	void *p = malloc(size);
> > +
> > +	if (!p)
> > +		libfsverity_error_msg("out of memory");
> > +	return p;
> > +}
> > +
> > +void *libfsverity_zalloc(size_t size)
> > +{
> > +	void *p = xmalloc(size);
> > +
> > +	if (!p)
> > +		return NULL;
> > +	return memset(p, 0, size);
> > +}
> 
> I suggest we get rid of xmalloc() and libfsverity_zalloc(). libc
> provides perfectly good malloc() and calloc() functions, and printing an
> out of memory error in a generic location doesn't tell us where the
> error happened. If anything those error messages should be printed by
> the calling function IMO.
> 

Maybe.  I'm not sure knowing the specific allocation sites would be useful
enough to make all the callers handle printing the error message (which is
easily forgotten about).  We could also add the allocation size that failed to
the message here.

- Eric
