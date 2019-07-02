Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7B15CB70
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2019 10:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfGBINS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 2 Jul 2019 04:13:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44203 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728316AbfGBIHp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 2 Jul 2019 04:07:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id e3so7090292wrs.11
        for <linux-fscrypt@vger.kernel.org>; Tue, 02 Jul 2019 01:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fVYsMgjvlhzbh/TqKhi7d4SFK7B/Ukhib20YGwD2OlM=;
        b=q9ZilC05a2m+mrPUNO5+3iadDkIlMvNCFVYKl5FwLDPma2TRWE2R0chNTM9iMMEJrH
         ln26Gtv3kLxEQ7ulT1DkTflxRzOwddrLnWXMwiWJwKlsKAnIi7J33WBU5V1Quqvbc72s
         dd52JvuRxilYVEeEFwthTvCbMFJTWKlEdApwk2O4qdpjwKuR8kZiIU2pFTfsAa23aVMb
         8FwY1p93XrB1ewOEpLAGY23N5AibhbXyLd4QbBrI/O8VD+2yiqIzRtZrmonKEEpGn9wS
         WRwgd95Nut+jEnE6ytQXprbCcr0g9xR14lMdywhfUMDKpnS6rB3KHbxwPdR0YL1tJpfH
         RWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fVYsMgjvlhzbh/TqKhi7d4SFK7B/Ukhib20YGwD2OlM=;
        b=XTM0Z2CLvWe8g19loMZfbECdnRcF8lUhu77W632mjyxkKS8mfMp1C+e1CFowhxwGrG
         JizGkLVSgjOoNwZQvk5kLfv2CU8g+jIhGhw9TU3ohBpmid2JAEb7G4TrQ/sRTzEOQ6cC
         qPF0kMrFHcUyVzIcjY/Mv9Xw1r18JhTCr0adFtHehhSV3FUqAtaDG9k0eke+8u/PXIkY
         LLm1+E0UNb0txcWr9GU1rjK4PSdYnWtqL5Zc9EMzNwUAyKBiUXuhqoVcBDcHokJDCJIs
         MEtm+h006neb0svLQVibAEd3lu1xwuwR+1FubhigVggJpnJkOK4K0IPB3PUWhE3MWSjf
         dlMA==
X-Gm-Message-State: APjAAAUer2U0qQNI6XdyfJkaQmjmpNwQEOIq79pRBbBf4mHP2E0Cbm2Y
        Z6syIsFpXAhtSKChstdDI+XudIdXp5wMevbdeRzMHg==
X-Google-Smtp-Source: APXvYqxFTr09aEUjlKJBTyUb2A6Ysfnih9bFlGYN09LsP6ZlqtItJRPDuv1wBv6XO4bEEeoL2GdtXHtohvv80mpjsQ8=
X-Received: by 2002:a5d:6b07:: with SMTP id v7mr7958887wrw.169.1562054863371;
 Tue, 02 Jul 2019 01:07:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190628152112.914-1-ard.biesheuvel@linaro.org>
 <20190628152112.914-5-ard.biesheuvel@linaro.org> <f068888f-1a13-babf-0144-07939a79d9d9@gmail.com>
In-Reply-To: <f068888f-1a13-babf-0144-07939a79d9d9@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 2 Jul 2019 10:07:32 +0200
Message-ID: <CAKv+Gu-gnKk2EQ4Asq2evghhyTFYVq9SRQ8tu_p4VCA1dSJfHQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/7] md: dm-crypt: switch to ESSIV crypto API template
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 1 Jul 2019 at 10:59, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 28/06/2019 17:21, Ard Biesheuvel wrote:
> > Replace the explicit ESSIV handling in the dm-crypt driver with calls
> > into the crypto API, which now possesses the capability to perform
> > this processing within the crypto subsystem.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> >  drivers/md/dm-crypt.c | 200 ++++----------------
>
> ...
>
> > -/* Wipe salt and reset key derived from volume key */
> > -static int crypt_iv_essiv_wipe(struct crypt_config *cc)
>
> Do I understand it correctly, that this is now called inside the whole cipher
> set key in wipe command (in crypt_wipe_key())?
>
> (Wipe message is meant to suspend the device and wipe all key material
> from memory without actually destroying the device.)
>

Yes, setting the random key in wipe() triggers the SHA256 operation as
normal, which is slightly wasteful but not a big deal imo.

> > -{
> > -     struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
> > -     unsigned salt_size = crypto_shash_digestsize(essiv->hash_tfm);
> > -     struct crypto_cipher *essiv_tfm;
> > -     int r, err = 0;
> > -
> > -     memset(essiv->salt, 0, salt_size);
> > -
> > -     essiv_tfm = cc->iv_private;
> > -     r = crypto_cipher_setkey(essiv_tfm, essiv->salt, salt_size);
> > -     if (r)
> > -             err = r;
> > -
> > -     return err;
> > -}
>
> ...
>
> > @@ -2435,9 +2281,19 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
> >       }
> >
> >       ret = crypt_ctr_blkdev_cipher(cc, cipher_api);
> > -     if (ret < 0) {
> > -             ti->error = "Cannot allocate cipher string";
> > -             return -ENOMEM;
> > +     if (ret < 0)
> > +             goto bad_mem;
> > +
> > +     if (*ivmode && !strcmp(*ivmode, "essiv")) {
> > +             if (!*ivopts) {
> > +                     ti->error = "Digest algorithm missing for ESSIV mode";
> > +                     return -EINVAL;
> > +             }
> > +             ret = snprintf(buf, CRYPTO_MAX_ALG_NAME, "essiv(%s,%s,%s)",
> > +                            cipher_api, cc->cipher, *ivopts);
> > +             if (ret < 0 || ret >= CRYPTO_MAX_ALG_NAME)
> > +                     goto bad_mem;
>
> Hm, nitpicking, but goto from only one place while we have another -ENOMEM above...
>
> Just place this here without goto?
>

OK

> > +     ti->error = "Cannot allocate cipher string";
> > +     return -ENOMEM;
>
> Otherwise
>
> Reviewed-by: Milan Broz <gmazyland@gmail.com>
>
> Thanks,
> Milan
