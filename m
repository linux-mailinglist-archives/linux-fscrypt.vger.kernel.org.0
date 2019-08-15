Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 835B98E2CA
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 04:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbfHOChq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Aug 2019 22:37:46 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56994 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbfHOChq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Aug 2019 22:37:46 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hy5dv-0003Gw-Je; Thu, 15 Aug 2019 12:37:35 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hy5du-0006Fp-QT; Thu, 15 Aug 2019 12:37:34 +1000
Date:   Thu, 15 Aug 2019 12:37:34 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        dm-devel@redhat.com, linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v11 1/4] crypto: essiv - create wrapper template for
 ESSIV generation
Message-ID: <20190815023734.GB23782@gondor.apana.org.au>
References: <20190814163746.3525-1-ard.biesheuvel@linaro.org>
 <20190814163746.3525-2-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814163746.3525-2-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 14, 2019 at 07:37:43PM +0300, Ard Biesheuvel wrote:
>
> +	/* Block cipher, e.g., "aes" */
> +	crypto_set_spawn(&ictx->essiv_cipher_spawn, inst);
> +	err = crypto_grab_spawn(&ictx->essiv_cipher_spawn, essiv_cipher_name,
> +				CRYPTO_ALG_TYPE_CIPHER, CRYPTO_ALG_TYPE_MASK);
> +	if (err)
> +		goto out_drop_skcipher;
> +	essiv_cipher_alg = ictx->essiv_cipher_spawn.alg;
> +
> +	/* Synchronous hash, e.g., "sha256" */
> +	_hash_alg = crypto_alg_mod_lookup(shash_name,
> +					  CRYPTO_ALG_TYPE_SHASH,
> +					  CRYPTO_ALG_TYPE_MASK);
> +	if (IS_ERR(_hash_alg)) {
> +		err = PTR_ERR(_hash_alg);
> +		goto out_drop_essiv_cipher;
> +	}
> +	hash_alg = __crypto_shash_alg(_hash_alg);
> +	err = crypto_init_shash_spawn(&ictx->hash_spawn, hash_alg, inst);
> +	if (err)
> +		goto out_put_hash;

I wouldn't use spawns for these two algorithms.  The point of
spawns is mainly to serve as a notification channel so we can
tear down the top-level instance when a better underlying spawn
implementation is added to the system.

For these two algorithms, we don't really care about their performance
to do such a tear-down since they only operate on small pieces of
data.

Therefore just keep things simple and allocate them in the tfm
init function.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
