Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 489984C7DE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 09:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbfFTHIK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 03:08:10 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:38412 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfFTHIK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 03:08:10 -0400
Received: by mail-vk1-f193.google.com with SMTP id f68so365328vkf.5
        for <linux-fscrypt@vger.kernel.org>; Thu, 20 Jun 2019 00:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q/om+71JNDD3JBQpnjSSKL2z2kEsK8+9coO279bnyEo=;
        b=d3EG1zAoY9QepdPNBMwRdvli5sa3q+t7TrjivVr5U2xwpz7HSj3iy4fL6s9HAqG9F1
         mE33El0J+x8/s4A1YIwtTVOyeIxwzaV5Xk2Z70aU7qQ/euZ5WXGOwTKVjYgMd39Rtlz4
         4eeopFCQONJPvozHkt/VfLqjU8vBwvPh3rOoetwodn6PAZuHb63R+soEIqEAAU2RptnU
         c0OB3Gay14s6Xmeuyy8JTsXBxjaB1Mywz7tSskKq/AP5ISxAg/Ry6QkK7lLbjYde2AGa
         p9OEZjrHhdCdrquV5DgT1pzMA2VhlCLj0uw+ecSJkWkZT+NCcNC7n9g1wLg9duhOE/2c
         1RuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q/om+71JNDD3JBQpnjSSKL2z2kEsK8+9coO279bnyEo=;
        b=bj+xwQNE1etT3Yna/XzzHvZ6/O+QQ/JES9xsJRMVFg5YG+T5b8iN3hnNNL2uBqCzrj
         TzVayhUbiOtvr74DEA8Zdti44koCCwp6mMFsULGwtYK201FimUhWyHTGfHbh/6u+FVcA
         GP9W9j78T9Y/R6pupK/kCDS5XaCC2cLDduJvHtWx5euAn1+v47cGw/T5FRQKz/cvdzo1
         dBfDOWodzsRBBM7gWd0ktQhIQ9FfQSqGdR6NTAlb0/AYAcmg3sKK923h15IMPC34CD3y
         A+NzAgVKdcbfVv2V2mlR9lOzQiOr6EssMj/K737D+ne6s4nrHASzYAvet6I0uexPFQ6j
         VkXA==
X-Gm-Message-State: APjAAAWqK7sNfItEPdleIb/Hu2Zn7lqch0fmidwZpwbrnrFJHr4oKXJK
        /j5uBjTH7ACBDJ9QRKor3qRrtdUN5HVKIMGy1bG2gw==
X-Google-Smtp-Source: APXvYqypwyVP5mceH1L7RcgVsjBUMco5nm+IpbFYBDiFn+6Cqv/1dXa5oRNxgzHMg6Do3AUxnc61OPOl4g0CdNxFCHo=
X-Received: by 2002:a1f:8c7:: with SMTP id 190mr3978438vki.18.1561014489490;
 Thu, 20 Jun 2019 00:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Thu, 20 Jun 2019 10:07:57 +0300
Message-ID: <CAOtvUMc0J3ufp3QyPwERdkRKfKzB_avPBoXSNWiCDS03jkNUzg@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] crypto: switch to crypto API for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org, Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 19, 2019 at 7:29 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> This series creates an ESSIV template that produces a skcipher or AEAD
> transform based on a tuple of the form '<skcipher>,<cipher>,<shash>'
> (or '<aead>,<cipher>,<shash>' for the AEAD case). It exposes the
> encapsulated sync or async skcipher/aead by passing through all operation=
s,
> while using the cipher/shash pair to transform the input IV into an ESSIV
> output IV.
>
> This matches what both users of ESSIV in the kernel do, and so it is prop=
osed
> as a replacement for those, in patches #2 and #4.
>
> This code has been tested using the fscrypt test suggested by Eric
> (generic/549), as well as the mode-test script suggested by Milan for
> the dm-crypt case. I also tested the aead case in a virtual machine,
> but it definitely needs some wider testing from the dm-crypt experts.
>
> Changes since v2:
> - fixed a couple of bugs that snuck in after I'd done the bulk of my
>   testing
> - some cosmetic tweaks to the ESSIV template skcipher setkey function
>   to align it with the aead one
> - add a test case for essiv(cbc(aes),aes,sha256)
> - add an accelerated implementation for arm64 that combines the IV
>   derivation and the actual en/decryption in a single asm routine
>
> Scroll down for tcrypt speed test result comparing the essiv template
> with the asm implementation. Bare cbc(aes) tests included for reference
> as well. Taken on a 2GHz Cortex-A57 (AMD Seattle)
>
> Code can be found here
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=3De=
ssiv-v3


Thank you Ard for this work. It is very useful. I am testing this now
with the essiv implementation inside CryptoCell.

One possible future optimization this opens the door for is having the
template auto-increment the sector number.

This will allow the device manager or fscrypt code to ask for crypto
services on buffer spanning over a single sector size
and have the crypto code automatically increment the sector number
when processing the buffer.

This may potentially shave a few cycles because it can potentially
turn multiple calls into the crypto API in one, giving
the crypto code a larger buffer to work on.

This is actually supported by CryptoCell hardware and to the best of
my knowledge also by a similar HW from Qualcomm
via out-of-tree patches found in the Android tree.

If this makes sense to you perhaps it is a good idea to have the
template format be:

<skcipher>,<cipher>,<shash>, <sector size>

Where for now we will only support a sector size of '0' (i.e. do not
auto-increment) and later extend or am I over engineering? :-)

Thanks,
Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
