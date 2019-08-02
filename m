Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5927EAD0
	for <lists+linux-fscrypt@lfdr.de>; Fri,  2 Aug 2019 05:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbfHBDzc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 1 Aug 2019 23:55:32 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48416 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729624AbfHBDzb (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 1 Aug 2019 23:55:31 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1htOez-00054h-1w; Fri, 02 Aug 2019 13:55:17 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1htOex-00047c-GU; Fri, 02 Aug 2019 13:55:15 +1000
Date:   Fri, 2 Aug 2019 13:55:15 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v8 1/7] crypto: essiv - create wrapper template for ESSIV
 generation
Message-ID: <20190802035515.GA15758@gondor.apana.org.au>
References: <20190704183017.31570-2-ard.biesheuvel@linaro.org>
 <20190726043117.GA654@gondor.apana.org.au>
 <CAKv+Gu_Pir7uU4h6GQfh2my2Fu-j2AGPLWNZKzc9_iG6n4xJNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_Pir7uU4h6GQfh2my2Fu-j2AGPLWNZKzc9_iG6n4xJNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 26, 2019 at 12:00:20PM +0300, Ard Biesheuvel wrote:
>
> For Y and Z, it is not straightforward either: since the crypto API
> permits the use of driver names in addition to the plain CRA names,
> we'd have to infer from the first parameter which cipher is being
> used.

We don't really permit that.  It might work but it is certainly not
guaranteed to work.  The only thing we guarantee is that the
algorithm name and the canonical driver name will work.  For example,
with gcm you can either say gcm(aes) or gcm_base(drv_name1, drv_name2).

Anything else is not supported.

So I would envisage something similar for essiv where essiv just has
U, X and Y (as you said that U and X are independent) while you can
then have an essiv_base that spells everything out in detail.

Also, do we allow anything other than HMAC for X? If not then that
should be encoded either into the name by dropping the hmac in the
algorithm name and adding it through the driver name, or by checking
for it in the template creation function.

What I'd like to achieve is a state where we support only what is
currently supported and no more.

> > Because this is legacy stuff, I don't want it to support any more
> > than what is currently being supported by dm-crypt.
> >
> > Similary for the skcipher case, given
> >
> >         essiv(cbc(X),Y,Z)
> >
> > is it ever possible for X != Y? If not then we should just make the
> > algorithm name essiv(X,Z).
> >
> 
> Same problem. We'd need to instantiate the skcipher and parse the cra_name.
> 
> Perhaps we should introduce a crypto API call that infers the cra_name
> from a cra_driver_name?

You don't need to do that.  Just copy whatever gcm does in its
creation function when you invoke it as gcm_base.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
