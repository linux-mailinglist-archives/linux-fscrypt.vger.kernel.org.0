Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B132F5D9FF
	for <lists+linux-fscrypt@lfdr.de>; Wed,  3 Jul 2019 02:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfGCA7B (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 2 Jul 2019 20:59:01 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40209 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfGCA7A (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 2 Jul 2019 20:59:00 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so418983wmj.5
        for <linux-fscrypt@vger.kernel.org>; Tue, 02 Jul 2019 17:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BuJjnmsa16yGtmKm23b5SK8rLGuToUCsb0RcIjLnyYU=;
        b=XgqNz3DD88MTi6lB/EV9D4bVepBN++dm78f7u60dKhmfewGE95rngfKmODgiZKw2Ch
         hmvF5K1gEcOgC1tqKmy5RJF2MmmjiKOp5G1ODPdH+H6FDhah+kr7E31r8DLUJ03dypaA
         5R6/61yNVE5Ola60Xt4w9E9HwKzuerv8hHj6J3By3y76wxQ+5tHQQkloE6PdE3Ljdwq1
         cUS2GMytbM2CUOyt3CJPYg028cTZNQGNUV3U8HpKoVyGaJdF/g01fsnlKaee1UxbcM6L
         qeKAa13EpeLZWNLI/KxJnkhAL2SUf2Ruffnzz96GfCt/PXlYrRkGGp0YPh1jCvGtVId4
         hkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BuJjnmsa16yGtmKm23b5SK8rLGuToUCsb0RcIjLnyYU=;
        b=lIkxtdKzpoPWdZu0T5IYiXYBAYScgEli4X7lfR7sd7HAPAXyAXRNBJC+lH7btswrn2
         xQ394WNG0Mk/XYE6Xo0jQ+L0++v7Oxe8Z5SDLMejQMzVfIEW5F3EjfrECIPG2oliAlIQ
         l89z1qPVHLw9LFXhUeOJU4z73fg0X4DnjJTJr3JbSdODVBVqNw7d23i4OoG+2zT4V3Yp
         gRPBTowQ/nBqJYBzKDPbkVmHCOLJCGlBzH5Wd+0k6OEbXepVzJGwj9axOADsm8jRu+qa
         zLxJTjWVvn9b/OkeomhfIdJkEELjm4IF0waCvzkIFkZbGtHN9u1kRyduFzuHYsbjs8LR
         Ciuw==
X-Gm-Message-State: APjAAAW5wH3N1xvuaBdfwg3t3ULVkcO+z2VN+i+4yP/9WOGYxpcBF/6b
        wae7LJf7djs40xMvtbhIMNIj44Hv2kt0Hshu9TvTNeAP8O+asA==
X-Google-Smtp-Source: APXvYqzNRL6kfVI6JRBm+/aVjGrWSvVW8XEmwzmlDfnElYLBce73LMP87RvgXUPNwrF+SvTgKH6XZnh16uSANnqnlvw=
X-Received: by 2002:a05:600c:21d4:: with SMTP id x20mr4187565wmj.61.1562105213973;
 Tue, 02 Jul 2019 15:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190702164815.6341-1-ard.biesheuvel@linaro.org>
 <20190702164815.6341-3-ard.biesheuvel@linaro.org> <20190702215517.GA69157@gmail.com>
In-Reply-To: <20190702215517.GA69157@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 3 Jul 2019 00:06:43 +0200
Message-ID: <CAKv+Gu9qPPBpm7aocHCsid6yyL7HyX9Dk2M72A5W9OeHG58MZw@mail.gmail.com>
Subject: Re: [PATCH v7 2/7] fs: crypto: invoke crypto API for ESSIV handling
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 2 Jul 2019 at 23:55, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Hi Ard,
>
> On Tue, Jul 02, 2019 at 06:48:10PM +0200, Ard Biesheuvel wrote:
> > Instead of open coding the calculations for ESSIV handling, use a
> > ESSIV skcipher which does all of this under the hood.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  fs/crypto/Kconfig           |  1 +
> >  fs/crypto/crypto.c          |  5 --
> >  fs/crypto/fscrypt_private.h |  9 --
> >  fs/crypto/keyinfo.c         | 95 +-------------------
> >  4 files changed, 5 insertions(+), 105 deletions(-)
> >
> > diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> > index 24ed99e2eca0..b0292da8613c 100644
> > --- a/fs/crypto/Kconfig
> > +++ b/fs/crypto/Kconfig
> > @@ -5,6 +5,7 @@ config FS_ENCRYPTION
> >       select CRYPTO_AES
> >       select CRYPTO_CBC
> >       select CRYPTO_ECB
> > +     select CRYPTO_ESSIV
> >       select CRYPTO_XTS
> >       select CRYPTO_CTS
> >       select CRYPTO_SHA256
> > diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> > index 335a362ee446..c53ce262a06c 100644
> > --- a/fs/crypto/crypto.c
> > +++ b/fs/crypto/crypto.c
> > @@ -136,9 +136,6 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
> >
> >       if (ci->ci_flags & FS_POLICY_FLAG_DIRECT_KEY)
> >               memcpy(iv->nonce, ci->ci_nonce, FS_KEY_DERIVATION_NONCE_SIZE);
> > -
> > -     if (ci->ci_essiv_tfm != NULL)
> > -             crypto_cipher_encrypt_one(ci->ci_essiv_tfm, iv->raw, iv->raw);
> >  }
> >
> >  int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
> > @@ -492,8 +489,6 @@ static void __exit fscrypt_exit(void)
> >               destroy_workqueue(fscrypt_read_workqueue);
> >       kmem_cache_destroy(fscrypt_ctx_cachep);
> >       kmem_cache_destroy(fscrypt_info_cachep);
> > -
> > -     fscrypt_essiv_cleanup();
> >  }
> >  module_exit(fscrypt_exit);
> >
> > diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> > index 7da276159593..59d0cba9cfb9 100644
> > --- a/fs/crypto/fscrypt_private.h
> > +++ b/fs/crypto/fscrypt_private.h
> > @@ -61,12 +61,6 @@ struct fscrypt_info {
> >       /* The actual crypto transform used for encryption and decryption */
> >       struct crypto_skcipher *ci_ctfm;
> >
> > -     /*
> > -      * Cipher for ESSIV IV generation.  Only set for CBC contents
> > -      * encryption, otherwise is NULL.
> > -      */
> > -     struct crypto_cipher *ci_essiv_tfm;
> > -
> >       /*
> >        * Encryption mode used for this inode.  It corresponds to either
> >        * ci_data_mode or ci_filename_mode, depending on the inode type.
> > @@ -166,9 +160,6 @@ struct fscrypt_mode {
> >       int keysize;
> >       int ivsize;
> >       bool logged_impl_name;
> > -     bool needs_essiv;
> >  };
> >
> > -extern void __exit fscrypt_essiv_cleanup(void);
> > -
> >  #endif /* _FSCRYPT_PRIVATE_H */
> > diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
> > index dcd91a3fbe49..f39667d4316a 100644
> > --- a/fs/crypto/keyinfo.c
> > +++ b/fs/crypto/keyinfo.c
> > @@ -13,14 +13,10 @@
> >  #include <linux/hashtable.h>
> >  #include <linux/scatterlist.h>
> >  #include <linux/ratelimit.h>
> > -#include <crypto/aes.h>
> >  #include <crypto/algapi.h>
> > -#include <crypto/sha.h>
> >  #include <crypto/skcipher.h>
> >  #include "fscrypt_private.h"
> >
> > -static struct crypto_shash *essiv_hash_tfm;
> > -
> >  /* Table of keys referenced by FS_POLICY_FLAG_DIRECT_KEY policies */
> >  static DEFINE_HASHTABLE(fscrypt_master_keys, 6); /* 6 bits = 64 buckets */
> >  static DEFINE_SPINLOCK(fscrypt_master_keys_lock);
> > @@ -144,10 +140,9 @@ static struct fscrypt_mode available_modes[] = {
> >       },
> >       [FS_ENCRYPTION_MODE_AES_128_CBC] = {
> >               .friendly_name = "AES-128-CBC",
> > -             .cipher_str = "cbc(aes)",
> > +             .cipher_str = "essiv(cbc(aes),aes,sha256)",
> >               .keysize = 16,
> > -             .ivsize = 16,
> > -             .needs_essiv = true,
> > +             .ivsize = 8,
>
> As I said before, this needs to be kept as .ivsize = 16.
>
> This bug actually causes the generic/549 test to fail.
>

Ugh, yes, I intended to fix that. Apologies for the sloppiness, I have
been trying to wrap this up in time for my holidays, but the end
result is quite the opposite :-)

> Otherwise this patch looks good.  FYI: to avoid conflicts with planned fscrypt
> work I'd prefer to take this patch through the fscrypt.git tree after the ESSIV
> template is merged, rather than have Herbert take it through cryptodev.  (Unless
> he's going to apply this whole series for v5.3, in which case I'm fine with him
> taking the fscrypt patch too, though it seems too late for that.)
>

I agree that the fscrypt and dm-crypt changes should not be merged for v5.3

I know that Herbert typically prefers not to take any new code without
any of its users, but perhaps we can make an exception in this case,
and merge patches #1, #5, #6 and #7 now (which is mostly risk free
since no code uses essiv yet, and patch #5 is a straight-forward
refactor) and take the fscrypt and dm-crypt patches through their
respective trees for the next cycle.
