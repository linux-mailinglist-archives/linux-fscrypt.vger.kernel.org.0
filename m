Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1838AE98
	for <lists+linux-fscrypt@lfdr.de>; Tue, 13 Aug 2019 07:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfHMFJy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 13 Aug 2019 01:09:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36410 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfHMFJy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 13 Aug 2019 01:09:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so261589wme.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 12 Aug 2019 22:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ZnFsdjJmeL4sHyht3BAAxUOXidvsHhILUUcniVeWojA=;
        b=uHejEa96zT80k3ajRLhA4BU+iT0qQ8fUJh8p50Rq4bAy8PIv1sU801kZmyDKqIDfFC
         +ov5ks5m/Js+C+og7ZP33zk9wv3lHMtjTc23VbhD/jEweDKfiEXbIiHHyiTsCUdgxW/6
         qJPaNwbdxIZkfeASrPxFLhm6Zrppy2WLaNoebYrHgoKmT8gMfTo2t9g3uokkg6LGSmR9
         xeNuGcnsgHOKSkFQOT51KBctHIh0szAY8NEKyiGtzFdSdfxMgnETf0MhoTzcYXeIgGBz
         VHWh3fKhqVM50xqbr2JpkRw9yceaamAeuVbr2qsVrM+i6aaal3CoOCgqSX3nbrk3s8t9
         /HSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ZnFsdjJmeL4sHyht3BAAxUOXidvsHhILUUcniVeWojA=;
        b=o4Crdn9UMWjgV5ADNuRAjZIlfmKsr3wclAqHGoJJmcjvZ67Dld+phIDV06bTryV/VA
         mzlja3VEJmp8tPyQJh4e/mGPjUP/0qIFlWAMsRvH3mxK/V1P3xcaPSoBI0GF6TpK6yOQ
         OH/NGl/lnSXwltfB/j9pjW4Lr6EhObvvb8yvQIWj9/80ON+0qhri2YyDznFv53d712e7
         LMvij5U9Pg51VJd0kpRrzpJ8pWbVEekGtnbymlS3HOYonAaxkPeAYDg/ti91gpQnbQke
         dG6oErwPMkshB3qlbG5A40B6sItuaoPKGIqlui/zhBUa3/PKnZyRroRNEEOoYeBdQiRI
         WMVQ==
X-Gm-Message-State: APjAAAU8rbxLXxK5kmP74TeO0SnBvcoB7+YvjEY9tMbN7+pkf3QZBU5S
        YB4sZ/ZbniTKbx3/9XIzC5kSb87dSbytQZlREhccFw==
X-Google-Smtp-Source: APXvYqwf7IjfSieinPs7ESCgDSduH5DW1k3a5XCnPYLPKw+bqOUKAY8U4nqBAvyr2mcYG875gSTrVGL3J/7ddOJRc/A=
X-Received: by 2002:a1c:f511:: with SMTP id t17mr744937wmh.53.1565672991566;
 Mon, 12 Aug 2019 22:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190812145324.27090-1-ard.biesheuvel@linaro.org>
 <20190812145324.27090-3-ard.biesheuvel@linaro.org> <20190812194747.GB131059@gmail.com>
In-Reply-To: <20190812194747.GB131059@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 13 Aug 2019 08:09:41 +0300
Message-ID: <CAKv+Gu-9aHY0op6MEmN8PfQhNa0kv=xNYB6rqtaCoiUdH4OASA@mail.gmail.com>
Subject: Re: [PATCH v10 2/7] fs: crypto: invoke crypto API for ESSIV handling
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

On Mon, 12 Aug 2019 at 22:47, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Aug 12, 2019 at 05:53:19PM +0300, Ard Biesheuvel wrote:
> > Instead of open coding the calculations for ESSIV handling, use a
> > ESSIV skcipher which does all of this under the hood.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> This looks fine (except for one comment below), but this heavily conflicts with
> the fscrypt patches planned for v5.4.  So I suggest moving this to the end of
> the series and having Herbert take only 1-6, and I'll apply this one to the
> fscrypt tree later.
>

I think the same applies to dm-crypt: at least patch #7 cannot be
applied until my eboiv patch is applied there as well, but [Milan
should confirm] I'd expect them to prefer taking those patches via the
dm tree anyway.

Herbert, what would you prefer:
- taking a pull request from a [signed] tag based on v4.3-rc1 that
contains patches #1, #4, #5 and #6, allowing Eric and Milan/Mike to
merge it as well, and apply the respective fscrypt and dm-crypt
changes on top
- just take patches #1, #4, #5 and #6 as usual, and let the fscrypt
and dm-crypt changes be reposted to the respective lists during the
next cycle


>
> > ---
> >  fs/crypto/Kconfig           |  1 +
> >  fs/crypto/crypto.c          |  5 --
> >  fs/crypto/fscrypt_private.h |  9 --
> >  fs/crypto/keyinfo.c         | 92 +-------------------
> >  4 files changed, 4 insertions(+), 103 deletions(-)
> >
> > diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> > index 5fdf24877c17..6f3d59b880b7 100644
> > --- a/fs/crypto/Kconfig
> > +++ b/fs/crypto/Kconfig
> > @@ -5,6 +5,7 @@ config FS_ENCRYPTION
> >       select CRYPTO_AES
> >       select CRYPTO_CBC
> >       select CRYPTO_ECB
> > +     select CRYPTO_ESSIV
> >       select CRYPTO_XTS
> >       select CRYPTO_CTS
> >       select KEYS
>
> In v5.3 I removed the 'select CRYPTO_SHA256', so now ESSIV shouldn't be selected
> here either.  Instead we should just update the documentation:
>
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 82efa41b0e6c02..a1e2ab12a99943 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -193,7 +193,8 @@ If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
>  AES-128-CBC was added only for low-powered embedded devices with
>  crypto accelerators such as CAAM or CESA that do not support XTS.  To
>  use AES-128-CBC, CONFIG_CRYPTO_SHA256 (or another SHA-256
> -implementation) must be enabled so that ESSIV can be used.
> +implementation) and CONFIG_CRYPTO_ESSIV must be enabled so that ESSIV
> +can be used.
>
>  Adiantum is a (primarily) stream cipher-based mode that is fast even
>  on CPUs without dedicated crypto instructions.  It's also a true
