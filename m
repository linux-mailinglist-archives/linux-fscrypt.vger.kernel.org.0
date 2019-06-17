Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923FB485B6
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jun 2019 16:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbfFQOj6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jun 2019 10:39:58 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46818 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfFQOj6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jun 2019 10:39:58 -0400
Received: by mail-io1-f67.google.com with SMTP id i10so21566130iol.13
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jun 2019 07:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sv6MBkFuxNWS4Y7/ODJd1UzhH6pb23qCRtVaIHF/q+c=;
        b=RlgzUmgfx9yyf3BBvyHR0xyyMh+HYVVEyb+v0qWRWjZWwRwnft22o6i6RXitzgYxpt
         bM3fzgoVGnCZ8/KJSEsW0Gb32WP2cPFqMtVMP331n/L/EKo0nYYh/D2K1UFOsgA1ZCj3
         dcPtlokzdrTzbMOKnwurcUwqmR62ByudM9TcOJ3gSEdPjTbgXJQCkazD6LjYutdh+i5o
         RijbGxrM4qHBvHSocR6sbHd4ijRbwAUsQen7gjUB3Uv7A+SRQBZhejgBTXY7r194EFd0
         LeelsBjgL34ouhUOLzNzdusfidDaYD9kyzjC5wwUw1DhNVgHCq5BGmnFMV/sDSxwYfSS
         q7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sv6MBkFuxNWS4Y7/ODJd1UzhH6pb23qCRtVaIHF/q+c=;
        b=pcRyBvasPxcZikf39gyshyAYrgWtmTyvGjoreNCTjRnKxHvo6GxcGokg8pwUUg1K2S
         UG3fgjWwqzCc5jszr53Cjh+0wWaVVCXV8LbkVIccYay72GOpOL/+IvF/cX8muXolGia5
         DQwcunourp8PbFnkrMX2rJ1dzSCaNq/aYOLIJIlZonmxPjLHkUV4rqplhDSwg9R48AIz
         NK/oM6xsp7CH8yWGY/21mrZ6iXYY0SIZPEWVwyXX1UAgoMq1HhHBkTmVRAiOR8+upSgK
         wWYVc9HE0dcZVEGycTsVlvaLK3meF3WPaUjyAY9BvGghsCSyccuihSXNOTOZRCBlM9Ue
         DZGA==
X-Gm-Message-State: APjAAAXPVTye2XNtoU/TVSgSZN1CVWuAuI8YuMHqHpPLx67BoIRKx4U7
        OVFtYISNR9qHMORC/u5fgUQw/pXqwDGLyvqS2PygIw==
X-Google-Smtp-Source: APXvYqyYa6j6Ch8HnyOd5iu7uBxGZ09vXQaTQDB4sfKP+VxQ9J+WjmYVU2uD8/bsKEKMsda+BAlZYfs5I2M96mF0JRs=
X-Received: by 2002:a5e:820a:: with SMTP id l10mr16879074iom.283.1560782397535;
 Mon, 17 Jun 2019 07:39:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <20190616204419.GE923@sol.localdomain> <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
 <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
 <8e58230a-cf0e-5a81-886b-6aa72a8e5265@gmail.com> <CAKv+Gu9sb0t6EC=MwVfqTw5TKtatK-c8k3ryNUhV8O0876NV7g@mail.gmail.com>
 <CAKv+Gu-LFShLW-Tt7hwBpni1vQRvv7k+L_bpP-wU86x88v+eRg@mail.gmail.com> <90214c3d-55ef-cc3a-3a04-f200d6f96cfd@gmail.com>
In-Reply-To: <90214c3d-55ef-cc3a-3a04-f200d6f96cfd@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 17 Jun 2019 16:39:45 +0200
Message-ID: <CAKv+Gu82BLPWrX1UzUBLf7UB+qJT6ZPtkvJ2Sa9t28OpXArhnw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 17 Jun 2019 at 16:35, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 17/06/2019 15:59, Ard Biesheuvel wrote:
> >
> > So my main question/showstopper at the moment is: which modes do we
> > need to support for ESSIV? Only CBC? Any skcipher? Or both skciphers
> > and AEADs?
>
> Support, or cover by internal test? I think you nee to support everything
> what dmcrypt currently allows, if you want to port dmcrypt to new API.
>
> I know of many systems that use aes-xts-essiv:sha256 (it does not make sense
> much but people just use it).
>
> Some people use serpent and twofish, but we allow any cipher that fits...
>

Sure,  that is all fine

> For the start, run this
> https://gitlab.com/cryptsetup/cryptsetup/blob/master/tests/mode-test
>
> In other words, if you add some additional limit, we are breaking backward compatibility.
> (Despite the configuration is "wrong" from the security point of view.)
>

Yes, but breaking backward compatibility only happens if you break
something that is actually being *used*. So sure,
xts(aes)-essiv:sha256 makes no sense but people use it anyway. But is
that also true for, say, gcm(aes)-essiv:sha256 ?
