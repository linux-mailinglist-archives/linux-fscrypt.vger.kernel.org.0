Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1564E2B500A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 19:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgKPSmK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 13:42:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727520AbgKPSmK (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 13:42:10 -0500
Received: from gmail.com (unknown [104.132.1.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1059D20867;
        Mon, 16 Nov 2020 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605552129;
        bh=XzFQvyg51/JSKnidcVjtNWfYfRpU081h1fMifm5xn2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X3CeiuRHgpNefu8T2Hyc2DsmTbl3hrEq6wyXJ/cyTJnJJf8LPsZnD2oVHGaV7XN9L
         0H2Gn0l5Zq7QMfY/nKJ+aE6Rqdf5XctLyLZcLSR6KFBb3hk6loj594DcDW2O5YUzp/
         +Y207aSZYK5AZ7Goudo7qVz4ef071HYa+/J7hlHU=
Date:   Mon, 16 Nov 2020 10:42:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <Luca.Boccassi@microsoft.com>
Cc:     "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils PATCH 1/2] lib: add libfsverity_enable() and
 libfsverity_enable_with_sig()
Message-ID: <20201116184207.GA1750990@gmail.com>
References: <20201114001529.185751-1-ebiggers@kernel.org>
 <20201114001529.185751-2-ebiggers@kernel.org>
 <cf3b4508c2fa79381b3c0f7fb6406b55f1f50e33.camel@microsoft.com>
 <X7K5zkDbDRobY6ux@sol.localdomain>
 <58b4959a8e836a6a3127ac48370ee8bd15f137c8.camel@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58b4959a8e836a6a3127ac48370ee8bd15f137c8.camel@microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 16, 2020 at 05:50:45PM +0000, Luca Boccassi wrote:
> On Mon, 2020-11-16 at 09:41 -0800, Eric Biggers wrote:
> > On Mon, Nov 16, 2020 at 11:52:57AM +0000, Luca Boccassi wrote:
> > > On Fri, 2020-11-13 at 16:15 -0800, Eric Biggers wrote:
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > Add convenience functions that wrap FS_IOC_ENABLE_VERITY but take a
> > > > 'struct libfsverity_merkle_tree_params' instead of
> > > > 'struct fsverity_enable_arg'.  This is useful because it allows
> > > > libfsverity users to deal with one common struct.
> > > > 
> > > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > > ---
> > > >  include/libfsverity.h | 36 ++++++++++++++++++++++++++++++++++
> > > >  lib/enable.c          | 45 +++++++++++++++++++++++++++++++++++++++++++
> > > >  programs/cmd_enable.c | 28 +++++++++++++++------------
> > > >  3 files changed, 97 insertions(+), 12 deletions(-)
> > > >  create mode 100644 lib/enable.c
> > > > 
> > > > diff --git a/include/libfsverity.h b/include/libfsverity.h
> > > > index 8f78a13..a8aecaf 100644
> > > > --- a/include/libfsverity.h
> > > > +++ b/include/libfsverity.h
> > > > @@ -112,6 +112,42 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
> > > >  			const struct libfsverity_signature_params *sig_params,
> > > >  			uint8_t **sig_ret, size_t *sig_size_ret);
> > > >  
> > > > +/**
> > > > + * libfsverity_enable() - Enable fs-verity on a file
> > > > + * @fd: read-only file descriptor to the file
> > > > + * @params: pointer to the Merkle tree parameters
> > > > + *
> > > > + * This is a simple wrapper around the FS_IOC_ENABLE_VERITY ioctl.
> > > > + *
> > > > + * Return: 0 on success, -EINVAL for invalid arguments, or a negative errno
> > > > + *	   value from the FS_IOC_ENABLE_VERITY ioctl.  See
> > > > + *	   Documentation/filesystems/fsverity.rst in the kernel source tree for
> > > > + *	   the possible error codes from FS_IOC_ENABLE_VERITY.
> > > > + */
> > > > +int
> > > > +libfsverity_enable(int fd, const struct libfsverity_merkle_tree_params *params);
> > > > +
> > > > +/**
> > > > + * libfsverity_enable_with_sig() - Enable fs-verity on a file, with a signature
> > > > + * @fd: read-only file descriptor to the file
> > > > + * @params: pointer to the Merkle tree parameters
> > > > + * @sig: pointer to the file's signature
> > > > + * @sig_size: size of the file's signature in bytes
> > > > + *
> > > > + * Like libfsverity_enable(), but allows specifying a built-in signature (i.e. a
> > > > + * singature created with libfsverity_sign_digest()) to associate with the file.
> > > > + * This is only needed if the in-kernel signature verification support is being
> > > > + * used; it is not needed if signatures are being verified in userspace.
> > > > + *
> > > > + * If @sig is NULL and @sig_size is 0, this is the same as libfsverity_enable().
> > > > + *
> > > > + * Return: See libfsverity_enable().
> > > > + */
> > > > +int
> > > > +libfsverity_enable_with_sig(int fd,
> > > > +			    const struct libfsverity_merkle_tree_params *params,
> > > > +			    const uint8_t *sig, size_t sig_size);
> > > > +
> > > 
> > > I don't have a strong preference either way, but any specific reason
> > > for a separate function rather than treating sig == NULL and sig_size
> > > == 0 as a signature-less enable? For clients deploying files, it would
> > > appear easier to me to just use empty parameters to choose between
> > > signed/not signed, without having to also change which API to call. But
> > > maybe there's some use case I'm missing where it's better to be
> > > explicit.
> > 
> > libfsverity_enable_with_sig() works since that; it allows sig == NULL and
> > sig_size == 0.
> > 
> > The reason I don't want the regular libfsverity_enable() to take the signature
> > parameters is that I'd like to encourage people to do userspace signature
> > verification instead.  I want to avoid implying that the in-kernel signature
> > verification is something that everyone should use.  Same reason I didn't want
> > 'fsverity digest' to output fsverity_formatted_digest by default.
> 
> Ok, I understand - makes sense to me, thanks.
> 
> Maybe it's worth documenting in the the header description of the API
> that empty/null values are accepted and will result in enabling without
> signature check?
> 

It's already there:

 * If @sig is NULL and @sig_size is 0, this is the same as libfsverity_enable().
