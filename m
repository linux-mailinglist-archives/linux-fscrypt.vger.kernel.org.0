Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77698AEA6
	for <lists+linux-fscrypt@lfdr.de>; Tue, 13 Aug 2019 07:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbfHMFSK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 13 Aug 2019 01:18:10 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36625 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfHMFSK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 13 Aug 2019 01:18:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so12787805wrt.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 12 Aug 2019 22:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=vjknMuAeSc0x7oeuMDtq2tLSIl2orQ+1iduGgKWbGiw=;
        b=w5qmuoq9X3Ml79Oe1T1zepUjvQjsv5b3F4f3sRbDxivdoqN+9fmOkhtVxNVieqI/V0
         1UwDPWvUG7SLBcRYLtyKb5wdQ6jb2GAkmuCqCks4MLYK/Nht/6Yxrqzr5ugKIz7Jk2X0
         J3H8XX512BzYf9tbFQhBoOz1DxSRardaf5QQPj3bYPEd6Q8q28AV24jQy+Th02Mt4Hb5
         oSBrKROm9BjZy1kuqABp6BKAHYiQWwZSwCb2ERMycX5krB8CBagv6coSo2nB6bAJKlJc
         UxY6mxBtdJdWdgBWzIbiy51QIrnyTWxqrXwrmrzenSgkfWTlRJ5guihgG8C5I2lfnSeA
         JuBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=vjknMuAeSc0x7oeuMDtq2tLSIl2orQ+1iduGgKWbGiw=;
        b=NWSnZsHFtD+YLyweXqhZpQcar4Yxx7EeWseRKhFtTdu5qH8cn8Zo2l5a7FgaIAGHeE
         JmbFZAkDTmeajz0OvljoUWmDC93VqRtQiZuYUlRfWcEH2NQLh5qByP8WydhLoxAcKhaM
         W2ie0tuyCP85K5RSoqwUmMo41jNEbZ8ZUQp5cDVn+LJ1xnbb1ZqFuGGJNiZ+kyG688v2
         GMSSfEWkRpCUONZ1Y1EiphF/CWB0DrA/3OdZeHGdiACMpinYSJCeqQ8WnKd9qbPl/+h6
         WdM0DNCGog9+q5AA1ihYGWG28hk7qVWnHpgqkkuLkGjNcmsYoo4kU2KHpAn0onNGF/xh
         9ifA==
X-Gm-Message-State: APjAAAXvadXZNOIvvnSxmHNAcezu1n5JdaZG1CzPZSB4kUwMJDxDGoaL
        uQPKYgBVyGHG2KIRRHgWbJo6Bzta6Xn7oDNNeIj3dg==
X-Google-Smtp-Source: APXvYqyT1D3REzaL959a3ymyuxK4owGKfnAIBTa58BY2l3RptzUHdepEU1bThGxSjSVPCPLqjkiSL+3E6lYeF4pkbOM=
X-Received: by 2002:a5d:6b07:: with SMTP id v7mr33607676wrw.169.1565673487792;
 Mon, 12 Aug 2019 22:18:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190812145324.27090-1-ard.biesheuvel@linaro.org>
 <20190812145324.27090-2-ard.biesheuvel@linaro.org> <20190812193849.GA131059@gmail.com>
In-Reply-To: <20190812193849.GA131059@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 13 Aug 2019 08:17:56 +0300
Message-ID: <CAKv+Gu-Nk0tMST32d3cwuiwGmZmXgKRDd2h9BuW-iPeoqSN5tA@mail.gmail.com>
Subject: Re: [PATCH v10 1/7] crypto: essiv - create wrapper template for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
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

On Mon, 12 Aug 2019 at 22:38, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Aug 12, 2019 at 05:53:18PM +0300, Ard Biesheuvel wrote:
> > +     switch (type) {
> > +     case CRYPTO_ALG_TYPE_BLKCIPHER:
> > +             skcipher_inst = kzalloc(sizeof(*skcipher_inst) +
> > +                                     sizeof(*ictx), GFP_KERNEL);
> > +             if (!skcipher_inst)
> > +                     return -ENOMEM;
> > +             inst = skcipher_crypto_instance(skcipher_inst);
> > +             base = &skcipher_inst->alg.base;
> > +             ictx = crypto_instance_ctx(inst);
> > +
> > +             /* Block cipher, e.g. "cbc(aes)" */
> > +             crypto_set_skcipher_spawn(&ictx->u.skcipher_spawn, inst);
> > +             err = crypto_grab_skcipher(&ictx->u.skcipher_spawn,
> > +                                        inner_cipher_name, 0,
> > +                                        crypto_requires_sync(algt->type,
> > +                                                             algt->mask));
> > +             if (err)
> > +                     goto out_free_inst;
>
> This should say "Symmetric cipher", not "Block cipher".
>
> > +
> > +     if (!parse_cipher_name(essiv_cipher_name, block_base->cra_name)) {
> > +             pr_warn("Failed to parse ESSIV cipher name from skcipher cra_name\n");
> > +             goto out_drop_skcipher;
> > +     }
>
> This is missing:
>
>                 err = -EINVAL;
>
> > +     if (type == CRYPTO_ALG_TYPE_BLKCIPHER) {
> > +             skcipher_inst->alg.setkey       = essiv_skcipher_setkey;
> > +             skcipher_inst->alg.encrypt      = essiv_skcipher_encrypt;
> > +             skcipher_inst->alg.decrypt      = essiv_skcipher_decrypt;
> > +             skcipher_inst->alg.init         = essiv_skcipher_init_tfm;
> > +             skcipher_inst->alg.exit         = essiv_skcipher_exit_tfm;
> > +
> > +             skcipher_inst->alg.min_keysize  = crypto_skcipher_alg_min_keysize(skcipher_alg);
> > +             skcipher_inst->alg.max_keysize  = crypto_skcipher_alg_max_keysize(skcipher_alg);
> > +             skcipher_inst->alg.ivsize       = crypto_skcipher_alg_ivsize(skcipher_alg);
> > +             skcipher_inst->alg.chunksize    = crypto_skcipher_alg_chunksize(skcipher_alg);
> > +             skcipher_inst->alg.walksize     = crypto_skcipher_alg_walksize(skcipher_alg);
> > +
> > +             skcipher_inst->free             = essiv_skcipher_free_instance;
> > +
> > +             err = skcipher_register_instance(tmpl, skcipher_inst);
> > +     } else {
> > +             aead_inst->alg.setkey           = essiv_aead_setkey;
> > +             aead_inst->alg.setauthsize      = essiv_aead_setauthsize;
> > +             aead_inst->alg.encrypt          = essiv_aead_encrypt;
> > +             aead_inst->alg.decrypt          = essiv_aead_decrypt;
> > +             aead_inst->alg.init             = essiv_aead_init_tfm;
> > +             aead_inst->alg.exit             = essiv_aead_exit_tfm;
> > +
> > +             aead_inst->alg.ivsize           = crypto_aead_alg_ivsize(aead_alg);
> > +             aead_inst->alg.maxauthsize      = crypto_aead_alg_maxauthsize(aead_alg);
> > +             aead_inst->alg.chunksize        = crypto_aead_alg_chunksize(aead_alg);
> > +
> > +             aead_inst->free                 = essiv_aead_free_instance;
> > +
> > +             err = aead_register_instance(tmpl, aead_inst);
> > +     }
>
> 'ivsize' is already in a variable, so could use
>
>                 skcipher_inst->alg.ivsize       = ivsize;
>
>         and
>                 aead_inst->alg.ivsize           = ivsize;
>

Thanks Eric. These will all be fixed in the next respin.
