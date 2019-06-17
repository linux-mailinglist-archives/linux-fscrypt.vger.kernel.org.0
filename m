Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2DD847DA0
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jun 2019 10:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfFQIwE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jun 2019 04:52:04 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:33672 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfFQIwE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jun 2019 04:52:04 -0400
Received: by mail-ua1-f65.google.com with SMTP id f20so3207552ual.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jun 2019 01:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JUqP3OKeD9bPLmSeCNOPOKYOA3EuQZNFNBZVHYzC5g4=;
        b=XtlskwgAxUNAXyFcXU16C6KAhEpQNCyyXjj/AqlIJZIPfIDfe9DP0YJEN8hUAybdZS
         GeF4UKONeKyJ16gBgPsvAi2PpvkgnDWRV530xC5Fhd1QqHmm2yPAXv+70RA+rKE5rEBj
         9OvPRoBYneEwIjZyfG6ds0OZ8k7zGP7BsfwJJ3yCeYjfJPQC1a+hovGdIfMsNX8aeChl
         2EoDLFZy79Y8Ra7HxUSdwkf/HAQt3tsb9ll/BlDyQe1ajUGFXwuqRHfAyqy5PzculMNI
         BR8xoqtihnK7YQd9hRUtQuxdNnjLEKq5dBY7QGM/mt/Ss2hnCRiW8IALIkwW2pQDXOKr
         I9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JUqP3OKeD9bPLmSeCNOPOKYOA3EuQZNFNBZVHYzC5g4=;
        b=npf2Au95W0sinny+MwW7ukxUU7aBlJOw8VEVwTFFIQCbhqdgnyc8NcpvoLwV06rkbD
         gGcf6+IgGa3BdHFtwQy/1iMd1lWrIG+vSsHSFIOyb9QAy9quqinF9wPAyhCz/HdFqjGD
         XaKhlqa2H8FrPct/wb6orjvjR9C3N24z0RUeGNg/S/JZnNvy6w0J3Kp3d0udAQ86EA0X
         MHmhkajpvE4pX6o1c3L8KP+g1buzghxAZPQwL/drFE6AAjArcDp1DP4IX12fTiCVaZQ0
         G1W8/A51qfGWhfDt7Ve0nWRcqGF8nD5vA8r8GKoKyOn02uNZUzExhcxpby+65el3pTs9
         HpCA==
X-Gm-Message-State: APjAAAWF+ihHPaBGvlP2+1EiLYflgKMrMT1feG7r11pjg2lSp+KLNspT
        v65PeDPlP1GLZxH7HHYTeiXGLRMMye05Qbk398ZmJw==
X-Google-Smtp-Source: APXvYqxUsRrEeCO+S9+Ink2+fjaOAiIAOcXiVQUU81FYi7df7idYsDJ/kS+jTivSSuU+OpV27+CqsbxLSOqSeurMJ9U=
X-Received: by 2002:ab0:208c:: with SMTP id r12mr41428470uak.27.1560761523133;
 Mon, 17 Jun 2019 01:52:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org> <20190616204419.GE923@sol.localdomain>
In-Reply-To: <20190616204419.GE923@sol.localdomain>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 17 Jun 2019 11:51:52 +0300
Message-ID: <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jun 16, 2019 at 11:44 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> [+Cc dm-devel and linux-fscrypt]
>
> On Fri, Jun 14, 2019 at 10:34:01AM +0200, Ard Biesheuvel wrote:
> > This series is presented as an RFC for a couple of reasons:
> > - it is only build tested
> > - it is unclear whether this is the right way to move away from the use=
 of
> >   bare ciphers in non-crypto code
> > - we haven't really discussed whether moving away from the use of bare =
ciphers
> >   in non-crypto code is a goal we agree on
> >
> > This series creates an ESSIV shash template that takes a (cipher,hash) =
tuple,
> > where the digest size of the hash must be a valid key length for the ci=
pher.
> > The setkey() operation takes the hash of the input key, and sets into t=
he
> > cipher as the encryption key. Digest operations accept input up to the
> > block size of the cipher, and perform a single block encryption operati=
on to
> > produce the ESSIV output.
...
> I agree that moving away from bare block ciphers is generally a good idea=
.  For
> fscrypt I'm fine with moving ESSIV into the crypto API, though I'm not su=
re a
> shash template is the best approach.  Did you also consider making it a s=
kcipher
> template so that users can do e.g. "essiv(cbc(aes),sha256,aes)"?  That wo=
uld
> simplify things much more on the fscrypt side, since then all the ESSIV-r=
elated
> code would go away entirely except for changing the string "cbc(aes)" to
> "essiv(cbc(aes),sha256,aes)".

I will also add that going the skcipher route rather than shash will
allow hardware tfm providers like CryptoCell that can do the ESSIV
part in hardware implement that as a single API call and/or hardware
invocation flow.
For those system that benefit from hardware providers this can be beneficia=
l.

Thanks,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
