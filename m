Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC3538A755
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 21:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfHLTiy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 15:38:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbfHLTiy (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 15:38:54 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61E8B20663;
        Mon, 12 Aug 2019 19:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565638732;
        bh=TeNAgou5xhC4DS9qCYvzkbTcsAXOHiXZsiyoVTGksr8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pT1/RiKjvjn9rcJ/uUe9r5Nl7U+g5vpswiAX3x9/aCYMQ8wVB66k98/H5VsWY0gbh
         9RXMGMNr2gYg7IARkB5t7trghqw9MuGqQQGB/TCfHhANdfV2izFzhKukuGZpNnhJ9I
         m9Qm1l+6GCeqQM0CcnTYjyhR4VUfSIqVoJPo/2XQ=
Date:   Mon, 12 Aug 2019 12:38:50 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v10 1/7] crypto: essiv - create wrapper template for
 ESSIV generation
Message-ID: <20190812193849.GA131059@gmail.com>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
References: <20190812145324.27090-1-ard.biesheuvel@linaro.org>
 <20190812145324.27090-2-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812145324.27090-2-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 12, 2019 at 05:53:18PM +0300, Ard Biesheuvel wrote:
> +	switch (type) {
> +	case CRYPTO_ALG_TYPE_BLKCIPHER:
> +		skcipher_inst = kzalloc(sizeof(*skcipher_inst) +
> +					sizeof(*ictx), GFP_KERNEL);
> +		if (!skcipher_inst)
> +			return -ENOMEM;
> +		inst = skcipher_crypto_instance(skcipher_inst);
> +		base = &skcipher_inst->alg.base;
> +		ictx = crypto_instance_ctx(inst);
> +
> +		/* Block cipher, e.g. "cbc(aes)" */
> +		crypto_set_skcipher_spawn(&ictx->u.skcipher_spawn, inst);
> +		err = crypto_grab_skcipher(&ictx->u.skcipher_spawn,
> +					   inner_cipher_name, 0,
> +					   crypto_requires_sync(algt->type,
> +								algt->mask));
> +		if (err)
> +			goto out_free_inst;

This should say "Symmetric cipher", not "Block cipher".

> +
> +	if (!parse_cipher_name(essiv_cipher_name, block_base->cra_name)) {
> +		pr_warn("Failed to parse ESSIV cipher name from skcipher cra_name\n");
> +		goto out_drop_skcipher;
> +	}

This is missing:
		
		err = -EINVAL;

> +	if (type == CRYPTO_ALG_TYPE_BLKCIPHER) {
> +		skcipher_inst->alg.setkey	= essiv_skcipher_setkey;
> +		skcipher_inst->alg.encrypt	= essiv_skcipher_encrypt;
> +		skcipher_inst->alg.decrypt	= essiv_skcipher_decrypt;
> +		skcipher_inst->alg.init		= essiv_skcipher_init_tfm;
> +		skcipher_inst->alg.exit		= essiv_skcipher_exit_tfm;
> +
> +		skcipher_inst->alg.min_keysize	= crypto_skcipher_alg_min_keysize(skcipher_alg);
> +		skcipher_inst->alg.max_keysize	= crypto_skcipher_alg_max_keysize(skcipher_alg);
> +		skcipher_inst->alg.ivsize	= crypto_skcipher_alg_ivsize(skcipher_alg);
> +		skcipher_inst->alg.chunksize	= crypto_skcipher_alg_chunksize(skcipher_alg);
> +		skcipher_inst->alg.walksize	= crypto_skcipher_alg_walksize(skcipher_alg);
> +
> +		skcipher_inst->free		= essiv_skcipher_free_instance;
> +
> +		err = skcipher_register_instance(tmpl, skcipher_inst);
> +	} else {
> +		aead_inst->alg.setkey		= essiv_aead_setkey;
> +		aead_inst->alg.setauthsize	= essiv_aead_setauthsize;
> +		aead_inst->alg.encrypt		= essiv_aead_encrypt;
> +		aead_inst->alg.decrypt		= essiv_aead_decrypt;
> +		aead_inst->alg.init		= essiv_aead_init_tfm;
> +		aead_inst->alg.exit		= essiv_aead_exit_tfm;
> +
> +		aead_inst->alg.ivsize		= crypto_aead_alg_ivsize(aead_alg);
> +		aead_inst->alg.maxauthsize	= crypto_aead_alg_maxauthsize(aead_alg);
> +		aead_inst->alg.chunksize	= crypto_aead_alg_chunksize(aead_alg);
> +
> +		aead_inst->free			= essiv_aead_free_instance;
> +
> +		err = aead_register_instance(tmpl, aead_inst);
> +	}

'ivsize' is already in a variable, so could use

		skcipher_inst->alg.ivsize       = ivsize;

	and
		aead_inst->alg.ivsize           = ivsize;
		
- Eric
