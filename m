Return-Path: <linux-fscrypt+bounces-992-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CF6DC8B4FD
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Nov 2025 18:47:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3E2B835C723
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Nov 2025 17:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84285314A74;
	Wed, 26 Nov 2025 17:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9Jd/e9p"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ED1312825;
	Wed, 26 Nov 2025 17:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764178921; cv=none; b=KWh+NloztGNxe/d66BrjgkDMasVBqRyVyk/0tCR2mz8oNmksFrxiCz5j909doyH2IkJFmzjCQ20TMjImudYlhZHsJs+c3p7H7MeRb0FGMNFP4xoKNUMc6r0qut4ZNyOEf/aPAqfIHcluxiCuL9iZ7XxY8HOqnV+6hAE0MAH36Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764178921; c=relaxed/simple;
	bh=TX6k6Yf6liaw7yzmZFSijsiZgH86BeEKWEAlto4QA9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QpzCposSfQG4o4UCi1ou38/ntDxsBz+PjcgQ3SmR+zxdJI5oiRj1WZtHGu7KtcHvgwxSVy9lIUls/Jco6v38tqb0Yhfh+lQTihiuZtFnWmnfpnxPpEXLLQh9TUTVAfAmtgujTXG6vbT3XMM1NzKdHWj2DHaOcED9YdNEW9EPnl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9Jd/e9p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BEEC4CEF7;
	Wed, 26 Nov 2025 17:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764178920;
	bh=TX6k6Yf6liaw7yzmZFSijsiZgH86BeEKWEAlto4QA9Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z9Jd/e9pYg0p3uRk+fZb1LIFYe64vJD5T8nA2j4HoxMG2b7DJ2SpZc3BGqtSx7oG/
	 pLTxK1F57QNt0Ir0biddPpsfy5lZRD8RusfrdQCITo19ii71KZGD+c2pnuolvPYR37
	 h3ipwnjWtIXQyi2cE4Elr6VeBsoDxSiQRjEwPlZY65huhup0Fzk3WIdZkOQaWzTSSk
	 eX0I1viXHRtlXim6PVKcoftIrH0tHSuoxXiXZ8NMQ6RDzUH+nEpj6J6oiYrRdIeP5O
	 6eHs02gfq7o1a57ghFfLQuAGjNlYbbY5MZRouuGp7ELJU1pOU0H3oodLCq0jPa5ifm
	 QpbxhF/UYC3hA==
Date: Wed, 26 Nov 2025 09:41:58 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Li Tian <litian@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH RFC] crypto/hkdf: Fix salt length short issue in FIPS mode
Message-ID: <20251126174158.GA71370@quark>
References: <20251126134222.22083-1-litian@redhat.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126134222.22083-1-litian@redhat.com>

On Wed, Nov 26, 2025 at 09:42:22PM +0800, Li Tian wrote:
> Under FIPS mode, the hkdf test fails because salt is required
> to be at least 32 bytes long. Pad salt with 0's.
> 
> Signed-off-by: Li Tian <litian@redhat.com>
> ---
>  crypto/hkdf.c         | 11 ++++++++++-
>  fs/crypto/hkdf.c      | 13 -------------
>  include/crypto/hkdf.h | 13 +++++++++++++
>  3 files changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/crypto/hkdf.c b/crypto/hkdf.c
> index 82d1b32ca6ce..9af0ef4dfb35 100644
> --- a/crypto/hkdf.c
> +++ b/crypto/hkdf.c
> @@ -46,6 +46,15 @@ int hkdf_extract(struct crypto_shash *hmac_tfm, const u8 *ikm,
>  		 u8 *prk)
>  {
>  	int err;
> +	u8 tmp_salt[HKDF_HASHLEN];
> +
> +	if (saltlen < HKDF_HASHLEN) {
> +		/* Copy salt and pad with zeros to HashLen */
> +		memcpy(tmp_salt, salt, saltlen);
> +		memset(tmp_salt + saltlen, 0, HKDF_HASHLEN - saltlen);
> +		salt = tmp_salt;
> +		saltlen = HKDF_HASHLEN;
> +	}
>  
>  	err = crypto_shash_setkey(hmac_tfm, salt, saltlen);
>  	if (!err)
> @@ -151,7 +160,7 @@ struct hkdf_testvec {
>   */
>  static const struct hkdf_testvec hkdf_sha256_tv[] = {
>  	{
> -		.test = "basic hdkf test",
> +		.test = "basic hkdf test",
>  		.ikm  = "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
>  			"\x0b\x0b\x0b\x0b\x0b\x0b",
>  		.ikm_size = 22,
> diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
> index 706f56d0076e..5e4844c1d3d7 100644
> --- a/fs/crypto/hkdf.c
> +++ b/fs/crypto/hkdf.c
> @@ -13,19 +13,6 @@
>  
>  #include "fscrypt_private.h"
>  
> -/*
> - * HKDF supports any unkeyed cryptographic hash algorithm, but fscrypt uses
> - * SHA-512 because it is well-established, secure, and reasonably efficient.
> - *
> - * HKDF-SHA256 was also considered, as its 256-bit security strength would be
> - * sufficient here.  A 512-bit security strength is "nice to have", though.
> - * Also, on 64-bit CPUs, SHA-512 is usually just as fast as SHA-256.  In the
> - * common case of deriving an AES-256-XTS key (512 bits), that can result in
> - * HKDF-SHA512 being much faster than HKDF-SHA256, as the longer digest size of
> - * SHA-512 causes HKDF-Expand to only need to do one iteration rather than two.
> - */
> -#define HKDF_HASHLEN		SHA512_DIGEST_SIZE
> -
>  /*
>   * HKDF consists of two steps:
>   *
> diff --git a/include/crypto/hkdf.h b/include/crypto/hkdf.h
> index 6a9678f508f5..7ef55ce875e2 100644
> --- a/include/crypto/hkdf.h
> +++ b/include/crypto/hkdf.h
> @@ -11,6 +11,19 @@
>  
>  #include <crypto/hash.h>
>  
> +/*
> + * HKDF supports any unkeyed cryptographic hash algorithm, but fscrypt uses
> + * SHA-512 because it is well-established, secure, and reasonably efficient.
> + *
> + * HKDF-SHA256 was also considered, as its 256-bit security strength would be
> + * sufficient here.  A 512-bit security strength is "nice to have", though.
> + * Also, on 64-bit CPUs, SHA-512 is usually just as fast as SHA-256.  In the
> + * common case of deriving an AES-256-XTS key (512 bits), that can result in
> + * HKDF-SHA512 being much faster than HKDF-SHA256, as the longer digest size of
> + * SHA-512 causes HKDF-Expand to only need to do one iteration rather than two.
> + */
> +#define HKDF_HASHLEN            SHA512_DIGEST_SIZE
> +
>  int hkdf_extract(struct crypto_shash *hmac_tfm, const u8 *ikm,
>  		 unsigned int ikmlen, const u8 *salt, unsigned int saltlen,
>  		 u8 *prk);

It seems you're trying to pad all the salts to 64 bytes?  That doesn't
make sense.  Just skip the salt_size == 0 test vector when fips_enabled.  

And either way, no need to mess with the code in fs/crypto/.

- Eric

