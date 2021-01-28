Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F72A307F6A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 28 Jan 2021 21:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhA1UTs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 28 Jan 2021 15:19:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhA1USz (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 28 Jan 2021 15:18:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEF7364E01;
        Thu, 28 Jan 2021 20:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611865094;
        bh=tf8zGLnljkCRKGs4eAElVNeZDxD9yB+2IhOiwey7nNM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QJdCJ/F0rR9XucpltdUINHRLSbmiX5iqPf5dbBdx4vw1aiAv7ipxMWIzsESeuO27U
         JRqrO5tXHH7SFFbVZo0HoVNLgTmdu+7IrdLOouRFyZuRY6d0O0mbJOXun32KAeh9Io
         9PiPeCZ5inPVFcYX0uRDXXVgRpx+l3S76UMLIYhKZQZd14xS9MEsF+jfJfpod/EdAB
         XPEB7EknNm7DkDHbL9Za8/TbbW8pzijNUOtdt0vG/wRlZhioDugX6iiOiGdjBtNr0V
         Emg8XoYwJvELE/+gfJERLbULX2UU49XuejAxboXIrhRfa2uDBZXrQ4rY/kdZhxoZMV
         IDffJwTrtbi3w==
Date:   Thu, 28 Jan 2021 12:18:12 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, Jarkko Sakkinen <jarkko@kernel.org>,
        mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
        linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        simo@redhat.com
Subject: Re: [PATCH v2 6/7] fs: use HKDF implementation from kernel crypto API
Message-ID: <YBMcBPXrKswTyiMC@sol.localdomain>
References: <1772794.tdWV9SEqCh@positron.chronox.de>
 <3577027.kQq0lBPeGt@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3577027.kQq0lBPeGt@positron.chronox.de>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jan 24, 2021 at 03:04:31PM +0100, Stephan Müller wrote:
> @@ -74,16 +57,14 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
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
> +	/* HKDF-Extract (RFC 5869 section 2.2), unsalted */
> +	err = crypto_hkdf_extract(hmac_tfm, NULL, 0,
> +				  master_key, master_key_size);
>  	if (err)
>  		goto err_free_tfm;
>  
> @@ -93,7 +74,6 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
>  err_free_tfm:
>  	crypto_free_shash(hmac_tfm);
>  out:
> -	memzero_explicit(prk, sizeof(prk));
>  	return err;
>  }

The 'out' label isn't needed anymore.  'goto out' should be replaced with
'return 0'.

- Eric
