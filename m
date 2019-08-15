Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40D9A8EA6B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 13:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbfHOLgE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Aug 2019 07:36:04 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57148 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfHOLgD (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Aug 2019 07:36:03 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hyE2o-0002lm-65; Thu, 15 Aug 2019 21:35:50 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hyE2m-0007Es-JS; Thu, 15 Aug 2019 21:35:48 +1000
Date:   Thu, 15 Aug 2019 21:35:48 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v11 1/4] crypto: essiv - create wrapper template for
 ESSIV generation
Message-ID: <20190815113548.GA27723@gondor.apana.org.au>
References: <20190814163746.3525-1-ard.biesheuvel@linaro.org>
 <20190814163746.3525-2-ard.biesheuvel@linaro.org>
 <20190815023734.GB23782@gondor.apana.org.au>
 <CAKv+Gu_maif=kZk-HRMx7pP=ths1vuTgcu4kFpzz0tCkO2+DFA@mail.gmail.com>
 <20190815051320.GA24982@gondor.apana.org.au>
 <CAKv+Gu_OVUfXW6t+j1RHA4_Uc43o50Sspke2KkVw9djbFDd04g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_OVUfXW6t+j1RHA4_Uc43o50Sspke2KkVw9djbFDd04g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Aug 15, 2019 at 08:15:29AM +0300, Ard Biesheuvel wrote:
> 
> So what about checking that the cipher key size matches the shash
> digest size, or that the cipher block size matches the skcipher IV
> size? This all moves to the TFM init function?

I don't think you need to check those things.  If the shash produces
an incorrect key size the setkey will just fail naturally.  As to
the block size matching the IV size, in the kernel it's not actually
possible to get an underlying cipher with different block size
than the cbc mode that you used to derive it.

The size checks that we have in general are to stop people from
making crazy combinations such as lrw(des3_ede), it's not there
to test the correctness of a given implementation.  That is,
we assume that whoever provides "aes" will give it the correct
geometry for it.

Sure we haven't made it explicit (which we should at some point)
but as it stands, it can only occur if we have a bug or someone
loads a malicious kernel module in which case none of this matters.

> Are there any existing templates that use this approach?

I'm not sure of templates doing this but this is similar to fallbacks.
In fact we don't check any gemoetry on the fallbacks at all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
