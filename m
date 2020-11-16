Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10262B4E57
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 18:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387702AbgKPRom (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 12:44:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387700AbgKPRlg (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 12:41:36 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EFF2222EC;
        Mon, 16 Nov 2020 17:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605548496;
        bh=gMLymnbr18kpdjjbQiY+dPrKhu+v/1PRPkupuhi2kD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xY2oYSMELYfKwddubu9RUrCHxapUniZ6y5s4cpdQ8e5floQqVYe1EszmpqiIhpwDr
         gFmWFeCFTelxc3w9EWcwjHHpMp4cFuFNRVmw4Ncmz4vtnxkyTBQwQjXwPg/P03H6U3
         93jHl0DE8KbTpeVOyhMD6Z8+13YRvp7PFcFgVgwc=
Date:   Mon, 16 Nov 2020 09:41:34 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <Luca.Boccassi@microsoft.com>
Cc:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
Subject: Re: [fsverity-utils PATCH 1/2] lib: add libfsverity_enable() and
 libfsverity_enable_with_sig()
Message-ID: <X7K5zkDbDRobY6ux@sol.localdomain>
References: <20201114001529.185751-1-ebiggers@kernel.org>
 <20201114001529.185751-2-ebiggers@kernel.org>
 <cf3b4508c2fa79381b3c0f7fb6406b55f1f50e33.camel@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf3b4508c2fa79381b3c0f7fb6406b55f1f50e33.camel@microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 16, 2020 at 11:52:57AM +0000, Luca Boccassi wrote:
> On Fri, 2020-11-13 at 16:15 -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add convenience functions that wrap FS_IOC_ENABLE_VERITY but take a
> > 'struct libfsverity_merkle_tree_params' instead of
> > 'struct fsverity_enable_arg'.  This is useful because it allows
> > libfsverity users to deal with one common struct.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  include/libfsverity.h | 36 ++++++++++++++++++++++++++++++++++
> >  lib/enable.c          | 45 +++++++++++++++++++++++++++++++++++++++++++
> >  programs/cmd_enable.c | 28 +++++++++++++++------------
> >  3 files changed, 97 insertions(+), 12 deletions(-)
> >  create mode 100644 lib/enable.c
> > 
> > diff --git a/include/libfsverity.h b/include/libfsverity.h
> > index 8f78a13..a8aecaf 100644
> > --- a/include/libfsverity.h
> > +++ b/include/libfsverity.h
> > @@ -112,6 +112,42 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
> >  			const struct libfsverity_signature_params *sig_params,
> >  			uint8_t **sig_ret, size_t *sig_size_ret);
> >  
> > +/**
> > + * libfsverity_enable() - Enable fs-verity on a file
> > + * @fd: read-only file descriptor to the file
> > + * @params: pointer to the Merkle tree parameters
> > + *
> > + * This is a simple wrapper around the FS_IOC_ENABLE_VERITY ioctl.
> > + *
> > + * Return: 0 on success, -EINVAL for invalid arguments, or a negative errno
> > + *	   value from the FS_IOC_ENABLE_VERITY ioctl.  See
> > + *	   Documentation/filesystems/fsverity.rst in the kernel source tree for
> > + *	   the possible error codes from FS_IOC_ENABLE_VERITY.
> > + */
> > +int
> > +libfsverity_enable(int fd, const struct libfsverity_merkle_tree_params *params);
> > +
> > +/**
> > + * libfsverity_enable_with_sig() - Enable fs-verity on a file, with a signature
> > + * @fd: read-only file descriptor to the file
> > + * @params: pointer to the Merkle tree parameters
> > + * @sig: pointer to the file's signature
> > + * @sig_size: size of the file's signature in bytes
> > + *
> > + * Like libfsverity_enable(), but allows specifying a built-in signature (i.e. a
> > + * singature created with libfsverity_sign_digest()) to associate with the file.
> > + * This is only needed if the in-kernel signature verification support is being
> > + * used; it is not needed if signatures are being verified in userspace.
> > + *
> > + * If @sig is NULL and @sig_size is 0, this is the same as libfsverity_enable().
> > + *
> > + * Return: See libfsverity_enable().
> > + */
> > +int
> > +libfsverity_enable_with_sig(int fd,
> > +			    const struct libfsverity_merkle_tree_params *params,
> > +			    const uint8_t *sig, size_t sig_size);
> > +
> 
> I don't have a strong preference either way, but any specific reason
> for a separate function rather than treating sig == NULL and sig_size
> == 0 as a signature-less enable? For clients deploying files, it would
> appear easier to me to just use empty parameters to choose between
> signed/not signed, without having to also change which API to call. But
> maybe there's some use case I'm missing where it's better to be
> explicit.

libfsverity_enable_with_sig() works since that; it allows sig == NULL and
sig_size == 0.

The reason I don't want the regular libfsverity_enable() to take the signature
parameters is that I'd like to encourage people to do userspace signature
verification instead.  I want to avoid implying that the in-kernel signature
verification is something that everyone should use.  Same reason I didn't want
'fsverity digest' to output fsverity_formatted_digest by default.

> > +LIBEXPORT int
> > +libfsverity_enable_with_sig(int fd,
> > +			    const struct libfsverity_merkle_tree_params *params,
> > +			    const uint8_t *sig, size_t sig_size)
> > +{
> > +	struct fsverity_enable_arg arg = {};
> > +
> > +	if (!params) {
> > +		libfsverity_error_msg("missing required parameters for enable");
> > +		return -EINVAL;
> > +	}
> > +
> > +	arg.version = 1;
> > +	arg.hash_algorithm = params->hash_algorithm;
> > +	arg.block_size = params->block_size;
> > +	arg.salt_size = params->salt_size;
> > +	arg.salt_ptr = (uintptr_t)params->salt;
> > +	arg.sig_size = sig_size;
> > +	arg.sig_ptr = (uintptr_t)sig;
> > +
> > +	if (ioctl(fd, FS_IOC_ENABLE_VERITY, &arg) != 0)
> > +		return -errno;
> > +	return 0;
> > +}
> 
> I'm ok with leaving file handling to clients - after all, depending on
> infrastructure/bindings/helper libs/whatnot, file handling might vary
> wildly.
> 
> But could we at least provide a default for block size and hash algo,
> if none are specified?
> 
> While file handling is a generic concept and expected to be a solved
> problem for most programs, figuring out what the default block size
> should be or what hash algorithm to use is, are fs-verity specific
> concepts that most clients (at least those that I deal with) wouldn't
> care about in any way outside of this use, and would want it to "just
> work".
> 
> Apart from these 2 comments, I ran a quick test of the 2 new series,
> and everything works as expected. Thanks!

First, providing defaults in libfsverity_enable() doesn't make sense unless the
same defaults are provided in libfsverity_compute_digest() too.

Second, PAGE_SIZE is a bad default block size.  It really should be a fixed
value, like 4096, so that e.g. if you sign files on both x86 and PowerPC, or
sign on x86 and enable on PowerPC, you get the same results.

So at least we shouldn't provide defaults unless it's done right.

I suppose it's probably not too late to change the default for the fsverity
program, though.  I doubt anyone is using it with a non-4K PAGE_SIZE yet.

Would it work for you if both libfsverity_compute_digest() and
libfsverity_enable() defaulted to SHA-256 and 4096?

- Eric
