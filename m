Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD1092638
	for <lists+linux-fscrypt@lfdr.de>; Mon, 19 Aug 2019 16:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfHSOO3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 19 Aug 2019 10:14:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35275 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfHSOO2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 19 Aug 2019 10:14:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id k2so8899694wrq.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 19 Aug 2019 07:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wac/8K0PlB5YqvgpI9XB84WnEjzGgiNR49Px3uNmKW4=;
        b=XFkdapvjB9ydQEoU7RWQdtlXojOwik5hizdLU9r2m8gd/IMDBuB1WcWbX6GxKduW06
         eqfg/JzDDnFlhRAb3Zjg1PMHT/2+lIZDLxwtPzakUBcxeeih7FVPqv2b2dSq1hwIJ2qk
         IBMbtHQ4TCDt1a8B6opSINSLFpvToXarInaeq3ntBbVSmSMmAw+jz0Z1J6Q8opDqmOn2
         JCYj4LcgzpcebgU4w4n//XHtfjKUV/DwL+rFvZ/6La2TcOVHb59BvhcNvgMqWiiuLS7S
         bCUN0+cxlt5dQ+AP15mSrdAbsMRm9m3tpLEZCnAsihJhYy6R6f4XotpJfNYDS1d1ZHkI
         oICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wac/8K0PlB5YqvgpI9XB84WnEjzGgiNR49Px3uNmKW4=;
        b=l7jpM2FWBVKCkVSi5+Wg+AAYFzGtuptVT5SrLIgea4f5TMvFMfwC4rwf3F0xnuVA0P
         Gy+sOrfwGrg7i4bgFKxbyEHfdNNTxSmUpzEayGfZjZ7IvwckFU938ezwhdc6oZF8yRWp
         oNcCLrvPKOdXD3XlD0HExGkiFaEOGe2NbtCqHyjfMfAaRZ+NjkeyheWO8LXtZR2uQKvE
         rdWwTOtQsXCCpyNATR7mhCETGR2O5Ce8JTgbgALhJ5tgAzf/azRJNtFrYVp9rPs3IOjo
         cKBJUOKVhVCgli6zcQtBK8puKykmeRmQdqE2eRlVLfJNkB8X5tRRv2dZymaJYlW14kBE
         2CAA==
X-Gm-Message-State: APjAAAV6pvGNl9ZuPXZOr1g63dRYNiR9BpQdYiYyUgNDEuFO+C08kdUf
        k7Z6qx8zUn/XWc7dhi8ayl+4sps04wxqnxk0tX7hyg==
X-Google-Smtp-Source: APXvYqyBE/UN01L8CYsSaZNoiACjd0jezpOPjy9k/djrhLklovSa5FgtQ4n+jR3Kahaa/J3jbjg98BO3QOEQVhK/O3w=
X-Received: by 2002:a5d:5450:: with SMTP id w16mr14907929wrv.174.1566224066287;
 Mon, 19 Aug 2019 07:14:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
 <20190815192858.28125-2-ard.biesheuvel@linaro.org> <20190819063218.GA31821@gondor.apana.org.au>
In-Reply-To: <20190819063218.GA31821@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 19 Aug 2019 17:14:25 +0300
Message-ID: <CAKv+Gu9Zcaq5gygGtgmf5f4L6U6sBDd0CVAzrBydjiLDenyrag@mail.gmail.com>
Subject: Re: [PATCH v12 1/4] crypto: essiv - create wrapper template for ESSIV generation
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

On Mon, 19 Aug 2019 at 09:32, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 15, 2019 at 10:28:55PM +0300, Ard Biesheuvel wrote:
> >
> > +     /* Synchronous hash, e.g., "sha256" */
> > +     ictx->hash = crypto_alloc_shash(shash_name, 0, 0);
> > +     if (IS_ERR(ictx->hash)) {
> > +             err = PTR_ERR(ictx->hash);
> > +             goto out_drop_skcipher;
> > +     }
>
> Holding a reference to this algorithm for the life-time of the
> instance is not nice.  How about just doing a lookup as you were
> doing before with crypto_alg_mod_lookup and getting the cra_name
> from that?
>

OK, but it should be the cra_driver_name not the cra_name. Otherwise,
allocating essiv(cbc(aes),sha256-generic) may end up using a different
implementation of sha256, which would be bad.
