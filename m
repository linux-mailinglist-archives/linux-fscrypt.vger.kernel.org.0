Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8DDA2EAF
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Aug 2019 06:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbfH3E6h (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 30 Aug 2019 00:58:37 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59506 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbfH3E6h (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 30 Aug 2019 00:58:37 -0400
Received: from [192.168.0.7] (helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i3YzR-0007ro-7D; Fri, 30 Aug 2019 14:58:26 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2019 14:58:23 +1000
Date:   Fri, 30 Aug 2019 14:58:23 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        dm-devel@redhat.com, linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v13 1/6] crypto: essiv - create wrapper template for
 ESSIV generation
Message-ID: <20190830045822.GA17901@gondor.apana.org.au>
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
 <20190819141738.1231-2-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819141738.1231-2-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 19, 2019 at 05:17:33PM +0300, Ard Biesheuvel wrote:
> Implement a template that wraps a (skcipher,shash) or (aead,shash) tuple
> so that we can consolidate the ESSIV handling in fscrypt and dm-crypt and
> move it into the crypto API. This will result in better test coverage, and
> will allow future changes to make the bare cipher interface internal to the
> crypto subsystem, in order to increase robustness of the API against misuse.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/Kconfig  |  28 +
>  crypto/Makefile |   1 +
>  crypto/essiv.c  | 663 ++++++++++++++++++++
>  3 files changed, 692 insertions(+)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
