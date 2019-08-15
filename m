Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60B38F28C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 19:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbfHORqf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Aug 2019 13:46:35 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35343 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730248AbfHORqe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Aug 2019 13:46:34 -0400
Received: by mail-wr1-f67.google.com with SMTP id k2so2957720wrq.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 15 Aug 2019 10:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hYNKyNDEVZaSn3KKU5nVN59Ch0APFsTcvR6fvX99Bx4=;
        b=zSc8i1ypbaWLdawvBpPJamGyioGgXkw4qE2S4xlu//+y7XHfmkYpBAWMiqgxswdXnT
         2Kbfqp7macugCIm2p0D3m8IR1/f/Xo7txfxoxUzpPVH9s2sUfzUibBFsgUZa/cq+b++j
         IkGa7fJqNQFnokMj/UTRlUTDsC5o8OCJij7bpBFg1XajnkkC8Noym1U5oVmhRX+Fmz95
         kgYaqoi0zEc0LZFqbK6Xk8XLgBOD6IpQgBTNGllnJ1SW++MYBRikQDBjavNXifJJkFSh
         I7h/rPVxmsHPi992yiHoHK9t7r5H1urmjbDXNz1JRsxI77xKSGeO2h32kgPSvYx1XNzn
         vwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hYNKyNDEVZaSn3KKU5nVN59Ch0APFsTcvR6fvX99Bx4=;
        b=IYvUZLH0LPYFGQccxwl0+d2d1z5tyXDfsFg3s1QmZTFIB2fK8tCehGph9fdRxrinfY
         Mcnpjp7NQGQ55hvpqOJQi/51tLnCNoWXkw1Cs4JpSo5fPWOAAum2sJjmxXTpZUlE8VPz
         xopf0FdavQz7CS8W1HfuuTe/hdCklFgoZTgRKXdz7xxt/AfJJdfAzr3hyW1OOgvUXwbH
         lFeRlQpADhg5wiUXkXd7rmpNHL70KeslFt9NjF8pdje8Sp6UI6M0VK+gsR2gAky1GuPM
         0K7zHZnNUT/JsOd3FshSIprU1AF7DH/awojEPcpdSZqlf535WHfHOhSr3d9F2mgJEQ1I
         ALag==
X-Gm-Message-State: APjAAAXB/KnUrb+wKtMwU8xW519x8KrAKhlPzX5jiT8Km+DC3o+d3ob/
        ph++CA+Sedrwi5oxOsLMl7iSR1BrQ1PGit+uzqHtYw==
X-Google-Smtp-Source: APXvYqyQgpk/VC0fEjSazze6ItoFVCjI/DkEOxBShq9LIPJT1ACJ9jFU5KOvmph9m5hLW3UbL54QtU/RwDF2CkyQcVA=
X-Received: by 2002:adf:9e09:: with SMTP id u9mr6695965wre.169.1565891192633;
 Thu, 15 Aug 2019 10:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190814163746.3525-1-ard.biesheuvel@linaro.org>
 <20190814163746.3525-2-ard.biesheuvel@linaro.org> <20190815023734.GB23782@gondor.apana.org.au>
 <CAKv+Gu_maif=kZk-HRMx7pP=ths1vuTgcu4kFpzz0tCkO2+DFA@mail.gmail.com>
 <20190815051320.GA24982@gondor.apana.org.au> <CAKv+Gu_OVUfXW6t+j1RHA4_Uc43o50Sspke2KkVw9djbFDd04g@mail.gmail.com>
 <20190815113548.GA27723@gondor.apana.org.au>
In-Reply-To: <20190815113548.GA27723@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 15 Aug 2019 20:46:21 +0300
Message-ID: <CAKv+Gu9Yx3Jk_ikZC1GrR8rR1zV_5CzkXv5NntXnLYim2n+R9g@mail.gmail.com>
Subject: Re: [PATCH v11 1/4] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 15 Aug 2019 at 14:35, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 15, 2019 at 08:15:29AM +0300, Ard Biesheuvel wrote:
> >
> > So what about checking that the cipher key size matches the shash
> > digest size, or that the cipher block size matches the skcipher IV
> > size? This all moves to the TFM init function?
>
> I don't think you need to check those things.  If the shash produces
> an incorrect key size the setkey will just fail naturally.  As to
> the block size matching the IV size, in the kernel it's not actually
> possible to get an underlying cipher with different block size
> than the cbc mode that you used to derive it.
>

dm-crypt permits any skcipher to be used with ESSIV, so the template
does not enforce CBC to be used.

> The size checks that we have in general are to stop people from
> making crazy combinations such as lrw(des3_ede), it's not there
> to test the correctness of a given implementation.  That is,
> we assume that whoever provides "aes" will give it the correct
> geometry for it.
>
> Sure we haven't made it explicit (which we should at some point)
> but as it stands, it can only occur if we have a bug or someone
> loads a malicious kernel module in which case none of this matters.
>

OK.

> > Are there any existing templates that use this approach?
>
> I'm not sure of templates doing this but this is similar to fallbacks.
> In fact we don't check any gemoetry on the fallbacks at all.
>

OK, so one other thing: how should I populate the cra_name template
field if someone instantiates essiv(cbc(aes),sha256-ce)? We won't know
until TFM init time what cra_name allocating the sha256-ce shash
actually produces, so the only way to populate those names is to use
the bare string supplied by the caller, which could be bogus.

To me, it seems like retaining the spawn for the shash is more
idiomatic, and avoids strange issues like the one above. Dropping the
spawn for the encapsulated cipher (which is tightly coupled to the
skcipher/aead being encapsulated) does seem feasible, so I'll go with
that.
