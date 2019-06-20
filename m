Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F8F4C4BD
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 03:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbfFTBEV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jun 2019 21:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731015AbfFTBEV (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jun 2019 21:04:21 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4CF5214AF;
        Thu, 20 Jun 2019 01:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560992659;
        bh=WF2aq9h8ptFGQpBZq8pPG4ryZ2Aaz+Ltf1A01Ir984Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PPSEP/ELHIOQEWRochDSBkUT9TX9Of740yyrr9wC/8yiL4JAAtT/82yKXvwOjqIwr
         SPmtS+0vJIAhyNzNtwMnGUYVxG9D674achYNrrYXnVYuV/Vfv/wI/H/0cSkXu5zwgx
         IFEie2QZccEG9QWZOdhfNId2XO3+WJv2fP1h7uyc=
Date:   Wed, 19 Jun 2019 18:04:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v3 1/6] crypto: essiv - create wrapper template for ESSIV
 generation
Message-ID: <20190620010417.GA722@sol.localdomain>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-2-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619162921.12509-2-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 19, 2019 at 06:29:16PM +0200, Ard Biesheuvel wrote:
> diff --git a/crypto/essiv.c b/crypto/essiv.c
> new file mode 100644
> index 000000000000..45e9d10b8614
> --- /dev/null
> +++ b/crypto/essiv.c
> @@ -0,0 +1,630 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * ESSIV skcipher template for block encryption

skcipher and aead

A few sentences summary of what this file is for might also be useful to future
readers.

> + *
> + * Copyright (c) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
> + *
> + * Heavily based on:
> + * adiantum length-preserving encryption mode
> + *
> + * Copyright 2018 Google LLC
> + */
> +
> +#include <crypto/authenc.h>
> +#include <crypto/internal/aead.h>
> +#include <crypto/internal/hash.h>
> +#include <crypto/internal/skcipher.h>
> +#include <crypto/scatterwalk.h>
> +#include <linux/module.h>
> +
> +#include "internal.h"
> +
> +#define ESSIV_IV_SIZE		sizeof(u64)	// IV size of the outer algo
> +#define MAX_INNER_IV_SIZE	16		// max IV size of inner algo

Why does the outer algorithm declare a smaller IV size?  Shouldn't it just be
the same as the inner algorithm's?

> +struct essiv_instance_ctx {
> +	union {
> +		struct crypto_skcipher_spawn	blockcipher_spawn;
> +		struct crypto_aead_spawn	aead_spawn;
> +	} u;
> +	struct crypto_spawn			essiv_cipher_spawn;
> +	struct crypto_shash_spawn		hash_spawn;
> +};
> +
> +struct essiv_tfm_ctx {
> +	union {
> +		struct crypto_skcipher	*blockcipher;
> +		struct crypto_aead	*aead;
> +	} u;
> +	struct crypto_cipher		*essiv_cipher;
> +	struct crypto_shash		*hash;
> +};

Can you fix the naming: 'blockcipher' => 'skcipher' everywhere?

> +static int essiv_skcipher_setkey(struct crypto_skcipher *tfm,
> +				 const u8 *key, unsigned int keylen)
> +{
> +	struct essiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
> +	SHASH_DESC_ON_STACK(desc, tctx->hash);
> +	unsigned int saltsize;
> +	u8 *salt;
> +	int err;
> +
> +	crypto_skcipher_clear_flags(tctx->u.blockcipher, CRYPTO_TFM_REQ_MASK);
> +	crypto_skcipher_set_flags(tctx->u.blockcipher,
> +				  crypto_skcipher_get_flags(tfm) &
> +				  CRYPTO_TFM_REQ_MASK);
> +	err = crypto_skcipher_setkey(tctx->u.blockcipher, key, keylen);
> +	crypto_skcipher_set_flags(tfm,
> +				  crypto_skcipher_get_flags(tctx->u.blockcipher) &
> +				  CRYPTO_TFM_RES_MASK);
> +	if (err)
> +		return err;
> +
> +	saltsize = crypto_shash_digestsize(tctx->hash);
> +	salt = kmalloc(saltsize, GFP_KERNEL);
> +	if (!salt)
> +		return -ENOMEM;

This could be a stack buffer of length HASH_MAX_DIGESTSIZE (64 bytes).
Same in essiv_aead_setkey().

> +
> +	desc->tfm = tctx->hash;
> +	crypto_shash_digest(desc, key, keylen, salt);

Need to check for error from crypto_shash_digest().

Similarly in essiv_aead_setkey().

> +static int essiv_skcipher_init_tfm(struct crypto_skcipher *tfm)
> +{
> +	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
> +	struct essiv_instance_ctx *ictx = skcipher_instance_ctx(inst);
> +	struct essiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
> +	struct crypto_skcipher *blockcipher;
> +	unsigned int subreq_size;
> +	int err;
> +
> +	BUILD_BUG_ON(offsetofend(struct essiv_skcipher_request_ctx,
> +				 blockcipher_req) !=
> +		     sizeof(struct essiv_skcipher_request_ctx));
> +
> +	blockcipher = crypto_spawn_skcipher(&ictx->u.blockcipher_spawn);
> +	if (IS_ERR(blockcipher))
> +		return PTR_ERR(blockcipher);
> +
> +	subreq_size = FIELD_SIZEOF(struct essiv_skcipher_request_ctx,
> +				   blockcipher_req) +
> +		      crypto_skcipher_reqsize(blockcipher);
> +
> +	crypto_skcipher_set_reqsize(tfm, offsetof(struct essiv_skcipher_request_ctx,
> +						  blockcipher_req) + subreq_size);
> +
> +	err = essiv_init_tfm(ictx, tctx);
> +	if (err)
> +		crypto_free_skcipher(blockcipher);

Should return in this error case, rather than going ahead and setting
tctx->u.blockcipher.

> +
> +	tctx->u.blockcipher = blockcipher;
> +	return err;
> +}
> +
> +static int essiv_aead_init_tfm(struct crypto_aead *tfm)
> +{
> +	struct aead_instance *inst = aead_alg_instance(tfm);
> +	struct essiv_instance_ctx *ictx = aead_instance_ctx(inst);
> +	struct essiv_tfm_ctx *tctx = crypto_aead_ctx(tfm);
> +	struct crypto_aead *aead;
> +	unsigned int subreq_size;
> +	int err;
> +
> +	BUILD_BUG_ON(offsetofend(struct essiv_aead_request_ctx, aead_req) !=
> +		     sizeof(struct essiv_aead_request_ctx));
> +
> +	aead = crypto_spawn_aead(&ictx->u.aead_spawn);
> +	if (IS_ERR(aead))
> +		return PTR_ERR(aead);
> +
> +	subreq_size = FIELD_SIZEOF(struct essiv_aead_request_ctx, aead_req) +
> +		      crypto_aead_reqsize(aead);
> +
> +	crypto_aead_set_reqsize(tfm, offsetof(struct essiv_aead_request_ctx,
> +					      aead_req) + subreq_size);
> +
> +	err = essiv_init_tfm(ictx, tctx);
> +	if (err)
> +		crypto_free_aead(aead);

Same here.

> +static bool essiv_supported_algorithms(struct crypto_alg *essiv_cipher_alg,
> +				       struct shash_alg *hash_alg,
> +				       int ivsize)
> +{
> +	if (hash_alg->digestsize < essiv_cipher_alg->cra_cipher.cia_min_keysize ||
> +	    hash_alg->digestsize > essiv_cipher_alg->cra_cipher.cia_max_keysize)
> +		return false;
> +
> +	if (ivsize != essiv_cipher_alg->cra_blocksize)
> +		return false;
> +
> +	if (ivsize > MAX_INNER_IV_SIZE)
> +		return false;
> +
> +	return true;
> +}

Also check that the hash algorithm is unkeyed?

> +
> +static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
> +{
> +	struct crypto_attr_type *algt;
> +	const char *blockcipher_name;
> +	const char *essiv_cipher_name;
> +	const char *shash_name;
> +	struct skcipher_instance *skcipher_inst = NULL;
> +	struct aead_instance *aead_inst = NULL;
> +	struct crypto_instance *inst;
> +	struct crypto_alg *base, *block_base;
> +	struct essiv_instance_ctx *ictx;
> +	struct skcipher_alg *blockcipher_alg = NULL;
> +	struct aead_alg *aead_alg = NULL;
> +	struct crypto_alg *essiv_cipher_alg;
> +	struct crypto_alg *_hash_alg;
> +	struct shash_alg *hash_alg;
> +	int ivsize;
> +	u32 type;
> +	int err;
> +
> +	algt = crypto_get_attr_type(tb);
> +	if (IS_ERR(algt))
> +		return PTR_ERR(algt);
> +
> +	blockcipher_name = crypto_attr_alg_name(tb[1]);
> +	if (IS_ERR(blockcipher_name))
> +		return PTR_ERR(blockcipher_name);
> +
> +	essiv_cipher_name = crypto_attr_alg_name(tb[2]);
> +	if (IS_ERR(essiv_cipher_name))
> +		return PTR_ERR(essiv_cipher_name);
> +
> +	shash_name = crypto_attr_alg_name(tb[3]);
> +	if (IS_ERR(shash_name))
> +		return PTR_ERR(shash_name);
> +
> +	type = algt->type & algt->mask;
> +
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
> +		crypto_set_skcipher_spawn(&ictx->u.blockcipher_spawn, inst);
> +		err = crypto_grab_skcipher(&ictx->u.blockcipher_spawn,
> +					   blockcipher_name, 0,
> +					   crypto_requires_sync(algt->type,
> +								algt->mask));
> +		if (err)
> +			goto out_free_inst;
> +		blockcipher_alg = crypto_spawn_skcipher_alg(&ictx->u.blockcipher_spawn);
> +		block_base = &blockcipher_alg->base;
> +		ivsize = blockcipher_alg->ivsize;

This may need to be crypto_skcipher_alg_ivsize(), since the "skcipher" algorithm
could actually be a "blkcipher" or "ablkcipher".

> +out_drop_blockcipher:
> +	if (type == CRYPTO_ALG_TYPE_BLKCIPHER) {
> +		crypto_drop_skcipher(&ictx->u.blockcipher_spawn);
> +	} else {
> +		crypto_drop_aead(&ictx->u.aead_spawn);
> +	}

Unnecessary braces.

Thanks,

- Eric
