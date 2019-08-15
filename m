Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37358E2B8
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 04:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfHOCbL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Aug 2019 22:31:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56984 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbfHOCbL (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Aug 2019 22:31:11 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hy5XW-0003By-W8; Thu, 15 Aug 2019 12:30:59 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hy5XV-0006DV-2C; Thu, 15 Aug 2019 12:30:57 +1000
Date:   Thu, 15 Aug 2019 12:30:57 +1000
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
Message-ID: <20190815023056.GA23782@gondor.apana.org.au>
References: <20190704183017.31570-2-ard.biesheuvel@linaro.org>
 <20190726043117.GA654@gondor.apana.org.au>
 <CAKv+Gu_Pir7uU4h6GQfh2my2Fu-j2AGPLWNZKzc9_iG6n4xJNA@mail.gmail.com>
 <20190802035515.GA15758@gondor.apana.org.au>
 <CAKv+Gu_a-tpc4+b4aopGZxHizkOgnqkFMCTzeF0uFo5iXXf24Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_a-tpc4+b4aopGZxHizkOgnqkFMCTzeF0uFo5iXXf24Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Aug 03, 2019 at 10:36:44AM +0300, Ard Biesheuvel wrote:
> 
> To use your GCM analogy: gcm_base(ctr-ppc-spe, ghash-generic) is a
> supported aead identifier, but  there is nothing in the name that
> identifies the skcipher as one that encapsulates AES.

I would've thought that you would first grab (literally :) ahold
of ctr-ppc-spe, at which point you could query its cra_name and then
derive AES from that.  Is that going to be a problem?

> > So I would envisage something similar for essiv where essiv just has
> > U, X and Y (as you said that U and X are independent) while you can
> > then have an essiv_base that spells everything out in detail.
> >
> 
> That might be a useful enhancement by itself, but it does not fix the
> issue above. The only way to instantiate the same cipher as the one
> encapsulated by "cbc-ppc-spe" is to instantiate the latter, parse the
> cipher name and pass it to crypto_alloc_cipher()

That's pretty much what I'm suggesting.  Except that I would point
out that you don't need to instantiate it (i.e., allocate a tfm),
you just need to grab ahold of the algorithm object.

The actual allocation of the AES cipher can be done in the cra_init
function.

We only need to grab algorithms that form a core part of the
resultant instance.  IOW, if the underlying algorithm is replaced,
you would always recreate the instance on top of it.  This is not
the case with AES here, since it's just used for a very small part
in the instance and we don't really care about recreating the essiv
intance when the block AES algorithm changes.

> > Also, do we allow anything other than HMAC for X? If not then that
> > should be encoded either into the name by dropping the hmac in the
> > algorithm name and adding it through the driver name, or by checking
> > for it in the template creation function.
> >
> > What I'd like to achieve is a state where we support only what is
> > currently supported and no more.
> >
> 
> Yeah, that makes sense. But we have h/w drivers that instantiate
> authenc(X,Y) in its entirety, and passing those driver names is
> something that is supported today, so we can't just remove that.

Sure, we only need to impose a restriction on the cra_name, not
on the driver name.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
