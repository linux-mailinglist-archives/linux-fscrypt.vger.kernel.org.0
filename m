Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2102ED6F2
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Jan 2021 19:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbhAGSsj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 Jan 2021 13:48:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbhAGSsj (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 Jan 2021 13:48:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29F39233CE;
        Thu,  7 Jan 2021 18:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610045278;
        bh=Dnauzd/8RJuh5QaFRYr7mEILCMaqsqRUKGBdFMzDwv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dUvdi0wlNkC5hZlyXy931h1uxopbnv1wF6VFHnS/+O+umfX5xfD+Ofgq1PP4fB6A8
         laK/wOB91ab9pv1+wX9qDEczk8/L+D/LU3YzNFAFQapcbHIuNuonuAlt2qNFzEYnew
         jYnNmYgM6xPNkFGBxQKKOn0MxuvFJqk1D8nt/6tEjHSrgPoNcb+sMo2zVSlHk5oomC
         qW3EnjUAfGUJhqfYgDBI3jRZ7kGVMGeEBaQHZNl1Euq6HkZpXsFOm8+7XTf5t5dxBN
         5v6crdhPpXVhUAEXOyrxikOb641z0LW5FndkDvbp9ZOYIJmp5KXXcJA5S6M3k/Buzj
         fIVXR/knnx86w==
Date:   Thu, 7 Jan 2021 10:47:56 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, mathew.j.martineau@linux.intel.com,
        dhowells@redhat.com, linux-crypto@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: [PATCH 5/5] fs: use HKDF implementation from kernel crypto API
Message-ID: <X/dXXEThAgankGIG@gmail.com>
References: <4616980.31r3eYUQgx@positron.chronox.de>
 <7857050.T7Z3S40VBb@positron.chronox.de>
 <X/a18yALjUcrvXDC@sol.localdomain>
 <a32b424e18672300ed4a72cade1dbbfd0d5bd6a5.camel@chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a32b424e18672300ed4a72cade1dbbfd0d5bd6a5.camel@chronox.de>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jan 07, 2021 at 08:49:52AM +0100, Stephan Mueller wrote:
> > > -int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
> > > +int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, u8 *master_key,
> > >                       unsigned int master_key_size);
> > 
> > It shouldn't be necessary to remove const here.
> 
> Unfortunately it is when adding the pointer to struct kvec
> > 
> > >  
> > >  /*
> > > @@ -323,7 +323,7 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const
> > > u8 *master_key,
> > >  #define HKDF_CONTEXT_INODE_HASH_KEY    7 /* info=<empty>               */
> > >  
> > >  int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
> > > -                       const u8 *info, unsigned int infolen,
> > > +                       u8 *info, unsigned int infolen,
> > >                         u8 *okm, unsigned int okmlen);
> > 
> > Likewise.  In fact some callers rely on 'info' not being modified.
> 
> Same here.

If the HKDF API will have a quirk like this, it's better not to "leak" it into
the prototypes of these fscrypt functions.  Just add the needed casts in
fscrypt_init_hkdf() and fscrypt_hkdf_expand().

> > > -       err = crypto_shash_setkey(hmac_tfm, prk, sizeof(prk));
> > > +       err = crypto_hkdf_setkey(hmac_tfm, seed, ARRAY_SIZE(seed));
> > >         if (err)
> > >                 goto err_free_tfm;
> > 
> > It's weird that the salt and key have to be passed in a kvec.
> > Why not just have normal function parameters like:
> > 
> >         int crypto_hkdf_setkey(struct crypto_shash *hmac_tfm,
> >                                const u8 *key, size_t keysize,
> >                                const u8 *salt, size_t saltsize);
> 
> I wanted to have an identical interface for all types of KDFs to allow turning
> them into a template eventually. For example, SP800-108 KDFs only have one
> parameter. Hence the use of a kvec.

But the API being provided is a library function specifically for HKDF.
So there's no need to make it conform to some other API.

- Eric
