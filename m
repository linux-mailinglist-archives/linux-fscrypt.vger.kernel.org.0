Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885FF89760
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 08:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfHLGyz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 02:54:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39352 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfHLGyz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 02:54:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so13472057wra.6
        for <linux-fscrypt@vger.kernel.org>; Sun, 11 Aug 2019 23:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ei5+JkViRRRvGnhnLSSk/w3F6iDWCFzFq2bHWTHDj4Q=;
        b=l/UHyvHuPOy0RmjyzYqXC66MlXYLRPd7Mz3PWXStgqevP0+3gtPn8lS98SoU6t78I9
         jv8WL4jZa6S6GOEJwYlMqZK4uwQLRAr/B1GQWjoqu2xMrFsdBZByTY6tPY6TuQGn1vtV
         W8fZXloorn5YC0WAwV44dSrRjOCvO/wtqExPM5NbD5yB+aGlikWqaEMlYmyF9GBj4KZ6
         hdp9z7WJUSWl/31SwwiwjyS/IgW7fX7VTYOGgdBceklFaG67UeZRFbMyElUd0AOd2UtA
         zVTUBwOvgZ5mhRUg3Mw/H4DqoB/fKv7hdx3d3FKD2zGiNUcB/Tw3D/ClQ2dn53i8S+sA
         pPBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ei5+JkViRRRvGnhnLSSk/w3F6iDWCFzFq2bHWTHDj4Q=;
        b=N8OaiLekGvHGhjeke9nfh4OYuEtIPTkZJBNtuhePI++RTZKm5QMGJGNEsrlHtaSGCe
         JYWwoFLSAkyrIw69GXPCSZuHvr5y+SneBPUBfeUpVHh6j/Qjzy0bE5vBwEFPZiaLxsLh
         EKSpAtSSUrgD7k2/Wm6j3EnMKcPLNemcAJqbMpqM/OQM7YTjJ/3qEEXJ0S1nJ/+Sy5Th
         OG3jIeFF52hYXC9vyCjl7q8Jk4+ulGSSwUjFqiZXQlWq+iZ9dfbfCutMoib7ur1gEaOR
         VB2pfwOJ2kuOc1k5mkJrhdkjOSLGb8oMmwurZhRMWUGNIgAY/QCnilM35x42SF+JjMHJ
         ppDQ==
X-Gm-Message-State: APjAAAXvDmFMsU7j8ukp/6C3d2/GNe2+QqBzjNe/bA67tYd2q1uvMVS8
        oSWjqKpoYegYzm1DM3enARevGdJGpthxtwXIbX8vlA==
X-Google-Smtp-Source: APXvYqwARCYRYmmX74oKU/J/K18AUPhYy1m1sdeU9FQdVJEds7qCcC3mpjJK8N5OurmTPSC9PdLS6KIxtowC7Ruhuqk=
X-Received: by 2002:a5d:6b07:: with SMTP id v7mr28314323wrw.169.1565592892776;
 Sun, 11 Aug 2019 23:54:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190810094053.7423-1-ard.biesheuvel@linaro.org>
 <20190810094053.7423-4-ard.biesheuvel@linaro.org> <8679d2f5-b005-cd89-957e-d79440b78086@gmail.com>
In-Reply-To: <8679d2f5-b005-cd89-957e-d79440b78086@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 12 Aug 2019 09:54:41 +0300
Message-ID: <CAKv+Gu-ZPPR5xQSR6T4o+8yJvsHY2a3xXZ5zsM_aGS3frVChgQ@mail.gmail.com>
Subject: Re: [PATCH v9 3/7] md: dm-crypt: switch to ESSIV crypto API template
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

On Mon, 12 Aug 2019 at 09:33, Milan Broz <gmazyland@gmail.com> wrote:
>
> Hi,
>
> On 10/08/2019 11:40, Ard Biesheuvel wrote:
> > Replace the explicit ESSIV handling in the dm-crypt driver with calls
> > into the crypto API, which now possesses the capability to perform
> > this processing within the crypto subsystem.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  drivers/md/Kconfig    |   1 +
> >  drivers/md/dm-crypt.c | 194 ++++----------------
> >  2 files changed, 33 insertions(+), 162 deletions(-)
> >
> > diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> > index 3834332f4963..b727e8f15264 100644
> > --- a/drivers/md/Kconfig
> > +++ b/drivers/md/Kconfig
> ...
> > @@ -2493,6 +2339,20 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
> >       if (*ivmode && !strcmp(*ivmode, "lmk"))
> >               cc->tfms_count = 64;
> >
> > +     if (*ivmode && !strcmp(*ivmode, "essiv")) {
> > +             if (!*ivopts) {
> > +                     ti->error = "Digest algorithm missing for ESSIV mode";
> > +                     return -EINVAL;
> > +             }
> > +             ret = snprintf(buf, CRYPTO_MAX_ALG_NAME, "essiv(%s,%s)",
> > +                            cipher_api, *ivopts);
>
> This is wrong. It works only in length-preserving modes, not in AEAD modes.
>
> Try for example
> # cryptsetup luksFormat /dev/sdc -c aes-cbc-essiv:sha256 --integrity hmac-sha256 -q -i1
>
> It should produce Crypto API string
>   authenc(hmac(sha256),essiv(cbc(aes),sha256))
> while it produces
>   essiv(authenc(hmac(sha256),cbc(aes)),sha256)
> (and fails).
>

No. I don't know why it fails, but the latter is actually the correct
string. The essiv template is instantiated either as a skcipher or as
an aead, and it encapsulates the entire transformation. (This is
necessary considering that the IV is passed via the AAD and so the
ESSIV handling needs to touch that as well)

This code worked fine in my testing: I could instantiate

essiv(authenc(hmac(sha256),cbc(aes)),sha256)
essiv(authenc(hmac(sha1),cbc(aes)),sha256)

where the former worked as expected (including fuzz testing of the
arm64 implementation), and the second got instantiated as well, but
with a complaint about a missing test case.

So I'm not sure why this is failing, I will try to check once I have
access to my ordinary development environment.


> You can run "luks2-integrity-test" from cryptsetup test suite to detect it.
>
> Just the test does not fail, it prints N/A for ESSIV use cases - we need to deal with older kernels...
> I can probable change it to fail unconditionally though.
>
> ...
> > @@ -2579,9 +2439,19 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
> >       if (!cipher_api)
> >               goto bad_mem;
> >
> > -     ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
> > -                    "%s(%s)", chainmode, cipher);
> > -     if (ret < 0) {
> > +     if (*ivmode && !strcmp(*ivmode, "essiv")) {
> > +             if (!*ivopts) {
> > +                     ti->error = "Digest algorithm missing for ESSIV mode";
> > +                     kfree(cipher_api);
> > +                     return -EINVAL;
> > +             }
> > +             ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
> > +                            "essiv(%s(%s),%s)", chainmode, cipher, *ivopts);
>
> I guess here it is ok, because old forma cannot use AEAD.
>
> Thanks,
> Milan
