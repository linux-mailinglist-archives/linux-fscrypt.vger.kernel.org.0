Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC482ECAE4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Jan 2021 08:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbhAGHT7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 Jan 2021 02:19:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbhAGHT6 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 Jan 2021 02:19:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53EE023100;
        Thu,  7 Jan 2021 07:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610003957;
        bh=guVgHVTP3Gev8lgSGqIAoa1rHgyY3KDR+7Zxa0APlGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F70azlfau1NVNnHzTMaGDTQ3TrMVyfyOcKjATGlspkmCue1orQ4DtuvA3MaLIu3TB
         A8TtdY1SyMQjmz7nwTUcqM7vORwOyNkr0PaglhnouYxFC8mgJ4qO8SHh2aG2xIh71L
         dNiOKZGU3iI4eQD2FzKrNwCHQRFjiO0hWZulCpg9qoyhRg62W066ozQjaV84Hhks+P
         XlS1VEsQJ9E+W9GdWIamUpkB/7KLHjF8nfvLj6awFlN+hjKphomWJpW0xeaVgi50sD
         1OIeoCVCK+mIx/pG/hp9YL1n2GmST2rrHa+rUcJJ7pSvWDBWIIk6MnG+rTtH/ClALu
         zSlRc37l4Zr1w==
Date:   Wed, 6 Jan 2021 23:19:15 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, mathew.j.martineau@linux.intel.com,
        dhowells@redhat.com, linux-crypto@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: [PATCH 5/5] fs: use HKDF implementation from kernel crypto API
Message-ID: <X/a18yALjUcrvXDC@sol.localdomain>
References: <4616980.31r3eYUQgx@positron.chronox.de>
 <7857050.T7Z3S40VBb@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7857050.T7Z3S40VBb@positron.chronox.de>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 04, 2021 at 10:50:49PM +0100, Stephan Müller wrote:
> As the kernel crypto API implements HKDF, replace the
> file-system-specific HKDF implementation with the generic HKDF
> implementation.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  fs/crypto/Kconfig           |   2 +-
>  fs/crypto/fscrypt_private.h |   4 +-
>  fs/crypto/hkdf.c            | 108 +++++++++---------------------------
>  3 files changed, 30 insertions(+), 84 deletions(-)
> 
> diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> index a5f5c30368a2..9450e958f1d1 100644
> --- a/fs/crypto/Kconfig
> +++ b/fs/crypto/Kconfig
> @@ -2,7 +2,7 @@
>  config FS_ENCRYPTION
>  	bool "FS Encryption (Per-file encryption)"
>  	select CRYPTO
> -	select CRYPTO_HASH
> +	select CRYPTO_HKDF
>  	select CRYPTO_SKCIPHER
>  	select CRYPTO_LIB_SHA256
>  	select KEYS
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 3fa965eb3336..0d6871838099 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -304,7 +304,7 @@ struct fscrypt_hkdf {
>  	struct crypto_shash *hmac_tfm;
>  };
>  
> -int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
> +int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, u8 *master_key,
>  		      unsigned int master_key_size);

It shouldn't be necessary to remove const here.

>  
>  /*
> @@ -323,7 +323,7 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
>  #define HKDF_CONTEXT_INODE_HASH_KEY	7 /* info=<empty>		*/
>  
>  int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
> -			const u8 *info, unsigned int infolen,
> +			u8 *info, unsigned int infolen,
>  			u8 *okm, unsigned int okmlen);

Likewise.  In fact some callers rely on 'info' not being modified.

> -/*
> + *
>   * Compute HKDF-Extract using the given master key as the input keying material,
>   * and prepare an HMAC transform object keyed by the resulting pseudorandom key.
>   *
>   * Afterwards, the keyed HMAC transform object can be used for HKDF-Expand many
>   * times without having to recompute HKDF-Extract each time.
>   */
> -int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
> +int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, u8 *master_key,
>  		      unsigned int master_key_size)
>  {
> +	/* HKDF-Extract (RFC 5869 section 2.2), unsalted */
> +	const struct kvec seed[] = { {
> +		.iov_base = NULL,
> +		.iov_len = 0
> +	}, {
> +		.iov_base = master_key,
> +		.iov_len = master_key_size
> +	} };
>  	struct crypto_shash *hmac_tfm;
> -	u8 prk[HKDF_HASHLEN];
>  	int err;
>  
>  	hmac_tfm = crypto_alloc_shash(HKDF_HMAC_ALG, 0, 0);
> @@ -74,16 +65,12 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
>  		return PTR_ERR(hmac_tfm);
>  	}
>  
> -	if (WARN_ON(crypto_shash_digestsize(hmac_tfm) != sizeof(prk))) {
> +	if (WARN_ON(crypto_shash_digestsize(hmac_tfm) != HKDF_HASHLEN)) {
>  		err = -EINVAL;
>  		goto err_free_tfm;
>  	}
>  
> -	err = hkdf_extract(hmac_tfm, master_key, master_key_size, prk);
> -	if (err)
> -		goto err_free_tfm;
> -
> -	err = crypto_shash_setkey(hmac_tfm, prk, sizeof(prk));
> +	err = crypto_hkdf_setkey(hmac_tfm, seed, ARRAY_SIZE(seed));
>  	if (err)
>  		goto err_free_tfm;

It's weird that the salt and key have to be passed in a kvec.
Why not just have normal function parameters like:

	int crypto_hkdf_setkey(struct crypto_shash *hmac_tfm,
			       const u8 *key, size_t keysize,
			       const u8 *salt, size_t saltsize);

>  int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
> -			const u8 *info, unsigned int infolen,
> +			u8 *info, unsigned int infolen,
>  			u8 *okm, unsigned int okmlen)
>  {
> -	SHASH_DESC_ON_STACK(desc, hkdf->hmac_tfm);
> -	u8 prefix[9];
> -	unsigned int i;
> -	int err;
> -	const u8 *prev = NULL;
> -	u8 counter = 1;
> -	u8 tmp[HKDF_HASHLEN];
> -
> -	if (WARN_ON(okmlen > 255 * HKDF_HASHLEN))
> -		return -EINVAL;
> -
> -	desc->tfm = hkdf->hmac_tfm;
> -
> -	memcpy(prefix, "fscrypt\0", 8);
> -	prefix[8] = context;
> -
> -	for (i = 0; i < okmlen; i += HKDF_HASHLEN) {
> +	const struct kvec info_iov[] = { {
> +		.iov_base = "fscrypt\0",
> +		.iov_len = 8,
> +	}, {
> +		.iov_base = &context,
> +		.iov_len = 1,
> +	}, {
> +		.iov_base = info,
> +		.iov_len = infolen,
> +	} };
> +	int err = crypto_hkdf_generate(hkdf->hmac_tfm,
> +				       info_iov, ARRAY_SIZE(info_iov),
> +				       okm, okmlen);
>  
> -		err = crypto_shash_init(desc);
> -		if (err)
> -			goto out;
> -
> -		if (prev) {
> -			err = crypto_shash_update(desc, prev, HKDF_HASHLEN);
> -			if (err)
> -				goto out;
> -		}
> -
> -		err = crypto_shash_update(desc, prefix, sizeof(prefix));
> -		if (err)
> -			goto out;
> -
> -		err = crypto_shash_update(desc, info, infolen);
> -		if (err)
> -			goto out;
> -
> -		BUILD_BUG_ON(sizeof(counter) != 1);
> -		if (okmlen - i < HKDF_HASHLEN) {
> -			err = crypto_shash_finup(desc, &counter, 1, tmp);
> -			if (err)
> -				goto out;
> -			memcpy(&okm[i], tmp, okmlen - i);
> -			memzero_explicit(tmp, sizeof(tmp));
> -		} else {
> -			err = crypto_shash_finup(desc, &counter, 1, &okm[i]);
> -			if (err)
> -				goto out;
> -		}
> -		counter++;
> -		prev = &okm[i];
> -	}
> -	err = 0;
> -out:
>  	if (unlikely(err))
>  		memzero_explicit(okm, okmlen); /* so caller doesn't need to */
> -	shash_desc_zero(desc);

Shouldn't crypto_hkdf_generate() handle the above memzero_explicit() of the
output buffer on error, so that all callers don't need to do it?

- Eric
