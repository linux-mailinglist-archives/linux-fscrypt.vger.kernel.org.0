Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2572ECB1F
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Jan 2021 08:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbhAGHws (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 Jan 2021 02:52:48 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:24605 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbhAGHws (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 Jan 2021 02:52:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1610005794;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
        Subject:Sender;
        bh=xQth024iRUdWUjPOE1PAw3zt550NobjVi9s6F2FEW0w=;
        b=VYdnv1FSaht67Gk7feM40vJHAhn82s3av5Qr891ieIRgnrrEJa5lMp53kf3EKpwey1
        ugmxQcWagh0AlJYjt9/IV1zpVcuQNopa9/4fl1yuuSOs/0Rhxga4MBTPEgjT8rD6Ih4S
        Vsuf0JiLc8vp1g6Jsq7oZcNTcFf0/kOF2uetP5qIWGAwwIB0r1dm0w+wvOcvROSNKsDN
        5xdmkUGr+y9NLQYMja5OGEyGc0VVs/ojIFNZ69RoBcHTI1WPr7Bc9GfOrD4Oh10fh5i4
        vPSA3jhMUIZiWXvbqrgFTuLVSR5mBTd2NeWNXSR9bdQKB8NjHNhSQCUK87vXV7Y4/aOf
        JpPA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJShPkMRYMkE="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id Z04c46x077nqCXA
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 7 Jan 2021 08:49:52 +0100 (CET)
Message-ID: <a32b424e18672300ed4a72cade1dbbfd0d5bd6a5.camel@chronox.de>
Subject: Re: [PATCH 5/5] fs: use HKDF implementation from kernel crypto API
From:   Stephan Mueller <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, mathew.j.martineau@linux.intel.com,
        dhowells@redhat.com, linux-crypto@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
Date:   Thu, 07 Jan 2021 08:49:52 +0100
In-Reply-To: <X/a18yALjUcrvXDC@sol.localdomain>
References: <4616980.31r3eYUQgx@positron.chronox.de>
         <7857050.T7Z3S40VBb@positron.chronox.de> <X/a18yALjUcrvXDC@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Am Mittwoch, dem 06.01.2021 um 23:19 -0800 schrieb Eric Biggers:
> On Mon, Jan 04, 2021 at 10:50:49PM +0100, Stephan Müller wrote:
> > As the kernel crypto API implements HKDF, replace the
> > file-system-specific HKDF implementation with the generic HKDF
> > implementation.
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > ---
> >  fs/crypto/Kconfig           |   2 +-
> >  fs/crypto/fscrypt_private.h |   4 +-
> >  fs/crypto/hkdf.c            | 108 +++++++++---------------------------
> >  3 files changed, 30 insertions(+), 84 deletions(-)
> > 
> > diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> > index a5f5c30368a2..9450e958f1d1 100644
> > --- a/fs/crypto/Kconfig
> > +++ b/fs/crypto/Kconfig
> > @@ -2,7 +2,7 @@
> >  config FS_ENCRYPTION
> >         bool "FS Encryption (Per-file encryption)"
> >         select CRYPTO
> > -       select CRYPTO_HASH
> > +       select CRYPTO_HKDF
> >         select CRYPTO_SKCIPHER
> >         select CRYPTO_LIB_SHA256
> >         select KEYS
> > diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> > index 3fa965eb3336..0d6871838099 100644
> > --- a/fs/crypto/fscrypt_private.h
> > +++ b/fs/crypto/fscrypt_private.h
> > @@ -304,7 +304,7 @@ struct fscrypt_hkdf {
> >         struct crypto_shash *hmac_tfm;
> >  };
> >  
> > -int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
> > +int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, u8 *master_key,
> >                       unsigned int master_key_size);
> 
> It shouldn't be necessary to remove const here.

Unfortunately it is when adding the pointer to struct kvec
> 
> >  
> >  /*
> > @@ -323,7 +323,7 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const
> > u8 *master_key,
> >  #define HKDF_CONTEXT_INODE_HASH_KEY    7 /* info=<empty>               */
> >  
> >  int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
> > -                       const u8 *info, unsigned int infolen,
> > +                       u8 *info, unsigned int infolen,
> >                         u8 *okm, unsigned int okmlen);
> 
> Likewise.  In fact some callers rely on 'info' not being modified.

Same here.
> 
> > -/*
> > + *
> >   * Compute HKDF-Extract using the given master key as the input keying
> > material,
> >   * and prepare an HMAC transform object keyed by the resulting
> > pseudorandom key.
> >   *
> >   * Afterwards, the keyed HMAC transform object can be used for HKDF-
> > Expand many
> >   * times without having to recompute HKDF-Extract each time.
> >   */
> > -int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
> > +int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, u8 *master_key,
> >                       unsigned int master_key_size)
> >  {
> > +       /* HKDF-Extract (RFC 5869 section 2.2), unsalted */
> > +       const struct kvec seed[] = { {
> > +               .iov_base = NULL,
> > +               .iov_len = 0
> > +       }, {
> > +               .iov_base = master_key,
> > +               .iov_len = master_key_size
> > +       } };
> >         struct crypto_shash *hmac_tfm;
> > -       u8 prk[HKDF_HASHLEN];
> >         int err;
> >  
> >         hmac_tfm = crypto_alloc_shash(HKDF_HMAC_ALG, 0, 0);
> > @@ -74,16 +65,12 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const
> > u8 *master_key,
> >                 return PTR_ERR(hmac_tfm);
> >         }
> >  
> > -       if (WARN_ON(crypto_shash_digestsize(hmac_tfm) != sizeof(prk))) {
> > +       if (WARN_ON(crypto_shash_digestsize(hmac_tfm) != HKDF_HASHLEN)) {
> >                 err = -EINVAL;
> >                 goto err_free_tfm;
> >         }
> >  
> > -       err = hkdf_extract(hmac_tfm, master_key, master_key_size, prk);
> > -       if (err)
> > -               goto err_free_tfm;
> > -
> > -       err = crypto_shash_setkey(hmac_tfm, prk, sizeof(prk));
> > +       err = crypto_hkdf_setkey(hmac_tfm, seed, ARRAY_SIZE(seed));
> >         if (err)
> >                 goto err_free_tfm;
> 
> It's weird that the salt and key have to be passed in a kvec.
> Why not just have normal function parameters like:
> 
>         int crypto_hkdf_setkey(struct crypto_shash *hmac_tfm,
>                                const u8 *key, size_t keysize,
>                                const u8 *salt, size_t saltsize);

I wanted to have an identical interface for all types of KDFs to allow turning
them into a template eventually. For example, SP800-108 KDFs only have one
parameter. Hence the use of a kvec.

> 
> >  int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
> > -                       const u8 *info, unsigned int infolen,
> > +                       u8 *info, unsigned int infolen,
> >                         u8 *okm, unsigned int okmlen)
> >  {
> > -       SHASH_DESC_ON_STACK(desc, hkdf->hmac_tfm);
> > -       u8 prefix[9];
> > -       unsigned int i;
> > -       int err;
> > -       const u8 *prev = NULL;
> > -       u8 counter = 1;
> > -       u8 tmp[HKDF_HASHLEN];
> > -
> > -       if (WARN_ON(okmlen > 255 * HKDF_HASHLEN))
> > -               return -EINVAL;
> > -
> > -       desc->tfm = hkdf->hmac_tfm;
> > -
> > -       memcpy(prefix, "fscrypt\0", 8);
> > -       prefix[8] = context;
> > -
> > -       for (i = 0; i < okmlen; i += HKDF_HASHLEN) {
> > +       const struct kvec info_iov[] = { {
> > +               .iov_base = "fscrypt\0",
> > +               .iov_len = 8,
> > +       }, {
> > +               .iov_base = &context,
> > +               .iov_len = 1,
> > +       }, {
> > +               .iov_base = info,
> > +               .iov_len = infolen,
> > +       } };
> > +       int err = crypto_hkdf_generate(hkdf->hmac_tfm,
> > +                                      info_iov, ARRAY_SIZE(info_iov),
> > +                                      okm, okmlen);
> >  
> > -               err = crypto_shash_init(desc);
> > -               if (err)
> > -                       goto out;
> > -
> > -               if (prev) {
> > -                       err = crypto_shash_update(desc, prev,
> > HKDF_HASHLEN);
> > -                       if (err)
> > -                               goto out;
> > -               }
> > -
> > -               err = crypto_shash_update(desc, prefix, sizeof(prefix));
> > -               if (err)
> > -                       goto out;
> > -
> > -               err = crypto_shash_update(desc, info, infolen);
> > -               if (err)
> > -                       goto out;
> > -
> > -               BUILD_BUG_ON(sizeof(counter) != 1);
> > -               if (okmlen - i < HKDF_HASHLEN) {
> > -                       err = crypto_shash_finup(desc, &counter, 1, tmp);
> > -                       if (err)
> > -                               goto out;
> > -                       memcpy(&okm[i], tmp, okmlen - i);
> > -                       memzero_explicit(tmp, sizeof(tmp));
> > -               } else {
> > -                       err = crypto_shash_finup(desc, &counter, 1,
> > &okm[i]);
> > -                       if (err)
> > -                               goto out;
> > -               }
> > -               counter++;
> > -               prev = &okm[i];
> > -       }
> > -       err = 0;
> > -out:
> >         if (unlikely(err))
> >                 memzero_explicit(okm, okmlen); /* so caller doesn't need
> > to */
> > -       shash_desc_zero(desc);
> 
> Shouldn't crypto_hkdf_generate() handle the above memzero_explicit() of the
> output buffer on error, so that all callers don't need to do it?

Yes, I will move it to HKDF (and the SP800-108 KDF as well).

Thanks for the review
Stephan
> 
> - Eric


