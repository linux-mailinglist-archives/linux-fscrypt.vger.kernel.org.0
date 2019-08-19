Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E01C91D22
	for <lists+linux-fscrypt@lfdr.de>; Mon, 19 Aug 2019 08:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbfHSGcc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 19 Aug 2019 02:32:32 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57698 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbfHSGcb (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 19 Aug 2019 02:32:31 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hzbDI-0007E9-Fk; Mon, 19 Aug 2019 16:32:20 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hzbDG-0008Jt-7T; Mon, 19 Aug 2019 16:32:18 +1000
Date:   Mon, 19 Aug 2019 16:32:18 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        dm-devel@redhat.com, linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v12 1/4] crypto: essiv - create wrapper template for
 ESSIV generation
Message-ID: <20190819063218.GA31821@gondor.apana.org.au>
References: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
 <20190815192858.28125-2-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815192858.28125-2-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Aug 15, 2019 at 10:28:55PM +0300, Ard Biesheuvel wrote:
>
> +	/* Synchronous hash, e.g., "sha256" */
> +	ictx->hash = crypto_alloc_shash(shash_name, 0, 0);
> +	if (IS_ERR(ictx->hash)) {
> +		err = PTR_ERR(ictx->hash);
> +		goto out_drop_skcipher;
> +	}

Holding a reference to this algorithm for the life-time of the
instance is not nice.  How about just doing a lookup as you were
doing before with crypto_alg_mod_lookup and getting the cra_name
from that?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
