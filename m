Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538FC8E447
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 06:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfHOE7r (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Aug 2019 00:59:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51986 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfHOE7r (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Aug 2019 00:59:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so259930wma.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 14 Aug 2019 21:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y7r3GrsKm+2UK/xPfP/njs6YmgftMt6txBYE2dN+ouo=;
        b=biAYEOQhtytUlyJpOiXnvcSnR1/7WJ1nuhw+ACmwN7VWYcOabJ+0N6FwIk+o7Z3R3v
         /TEYgrwFC18O2PnT7sb7CH0ANCHfPu3fyUT4Xc/N7V4dugNfHi64+T6++WE5I/kizwdG
         hcbcqWE06u9C2S34QcPjTlULJhF8uf1GDy5a6x3OhpYWTAofcZDvl+6Y827E3vgb6gJL
         kchw4gC/kygPZNUJCJyTrwH+VJn0bVBQfnpgWxaDGoEThwbVXHyqyRNZbtc7sO2g3ToK
         QZzuyIjJJO4VgggVBgCnSTJEqhFD2LF5lE37dhFxSioDmydW/euBlOLxgFQrzdmsyLy9
         QfXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y7r3GrsKm+2UK/xPfP/njs6YmgftMt6txBYE2dN+ouo=;
        b=ZKDMO+U7QqrmLxozWALFzyXPU0Zd7PugPJcaJoYvofJBD0jezuS++n1T5YO3D4HAv5
         QOY+Wb3gInfXiyMwvEQ6vTmWe1Q38nE5TPFjJlAgJa9fhB0gGUCvsesUC6rtnppmAtwe
         G3ztZM0JzQY2Qhgr3oMfCLSD2QkTHxH6LsOsvYirInr0Wifd5hRaQi1mVhuHXoNU6E3Q
         BBy+5l9hyzwa2P4cliKj/jbRWe8tApIRPt86xQnHei6oVVeBhfE59/xSDIRoht1vY3w4
         GtHdQhKNLX1A8c9EyzGH/rkeQTGwOJ6/5TrdO6+/mvSXmbZkVnGEa1PCQO0dEQBQyuLA
         kSqw==
X-Gm-Message-State: APjAAAWM04knydsKvGqDK5I1M+nX2JdMUDtjVZ6zPBS9Yqps7eHdCMj+
        Xco78GMTOHIiiks7E59b22llJB/ohRNaz5su+0rqbg==
X-Google-Smtp-Source: APXvYqxGcPdaMer0ONFG2I2gsJ4PSUhsr7GYEUw376kmI/NVQmX1WUdUJmFOqfEcyjlzXmrI51RmTQ21n7xDGi0W5Z4=
X-Received: by 2002:a7b:c21a:: with SMTP id x26mr635593wmi.61.1565845185178;
 Wed, 14 Aug 2019 21:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190814163746.3525-1-ard.biesheuvel@linaro.org>
 <20190814163746.3525-2-ard.biesheuvel@linaro.org> <20190815023734.GB23782@gondor.apana.org.au>
In-Reply-To: <20190815023734.GB23782@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 15 Aug 2019 07:59:34 +0300
Message-ID: <CAKv+Gu_maif=kZk-HRMx7pP=ths1vuTgcu4kFpzz0tCkO2+DFA@mail.gmail.com>
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

On Thu, 15 Aug 2019 at 05:37, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Aug 14, 2019 at 07:37:43PM +0300, Ard Biesheuvel wrote:
> >
> > +     /* Block cipher, e.g., "aes" */
> > +     crypto_set_spawn(&ictx->essiv_cipher_spawn, inst);
> > +     err = crypto_grab_spawn(&ictx->essiv_cipher_spawn, essiv_cipher_name,
> > +                             CRYPTO_ALG_TYPE_CIPHER, CRYPTO_ALG_TYPE_MASK);
> > +     if (err)
> > +             goto out_drop_skcipher;
> > +     essiv_cipher_alg = ictx->essiv_cipher_spawn.alg;
> > +
> > +     /* Synchronous hash, e.g., "sha256" */
> > +     _hash_alg = crypto_alg_mod_lookup(shash_name,
> > +                                       CRYPTO_ALG_TYPE_SHASH,
> > +                                       CRYPTO_ALG_TYPE_MASK);
> > +     if (IS_ERR(_hash_alg)) {
> > +             err = PTR_ERR(_hash_alg);
> > +             goto out_drop_essiv_cipher;
> > +     }
> > +     hash_alg = __crypto_shash_alg(_hash_alg);
> > +     err = crypto_init_shash_spawn(&ictx->hash_spawn, hash_alg, inst);
> > +     if (err)
> > +             goto out_put_hash;
>
> I wouldn't use spawns for these two algorithms.  The point of
> spawns is mainly to serve as a notification channel so we can
> tear down the top-level instance when a better underlying spawn
> implementation is added to the system.
>
> For these two algorithms, we don't really care about their performance
> to do such a tear-down since they only operate on small pieces of
> data.
>
> Therefore just keep things simple and allocate them in the tfm
> init function.
>

So how do I ensure that the cipher and shash are actually loaded at
create() time, and that they are still loaded at TFM init time?
