Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C289E5A300
	for <lists+linux-fscrypt@lfdr.de>; Fri, 28 Jun 2019 20:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfF1SAl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 28 Jun 2019 14:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfF1SAl (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 28 Jun 2019 14:00:41 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02E782083B;
        Fri, 28 Jun 2019 18:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561744840;
        bh=zMbrJScFqvYyJzkDW2lrEXk0xjEy7/G9qum3AIR8LGI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eDSD6s0atcsZcpHu8qZ3VBRxOXB7XzOdnmdmzWDzH+lDu5zEFnrf4OY0nfJaCBf9C
         dS5HwVXaj8n6rqdZ+plvdqk0EU+Psyc47f67lW1Dr8DJmC5FPtsxcyiG25O/5TeCNb
         JdGTA0dGgVDTXuR3DuC3S866aFfMM37i5KFH3st0=
Date:   Fri, 28 Jun 2019 11:00:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v6 2/7] fs: crypto: invoke crypto API for ESSIV handling
Message-ID: <20190628180037.GC103946@gmail.com>
References: <20190628152112.914-1-ard.biesheuvel@linaro.org>
 <20190628152112.914-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628152112.914-3-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jun 28, 2019 at 05:21:07PM +0200, Ard Biesheuvel wrote:
> diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
> index dcd91a3fbe49..f39667d4316a 100644
> --- a/fs/crypto/keyinfo.c
> +++ b/fs/crypto/keyinfo.c
> @@ -13,14 +13,10 @@
>  #include <linux/hashtable.h>
>  #include <linux/scatterlist.h>
>  #include <linux/ratelimit.h>
> -#include <crypto/aes.h>
>  #include <crypto/algapi.h>
> -#include <crypto/sha.h>
>  #include <crypto/skcipher.h>
>  #include "fscrypt_private.h"
>  
> -static struct crypto_shash *essiv_hash_tfm;
> -
>  /* Table of keys referenced by FS_POLICY_FLAG_DIRECT_KEY policies */
>  static DEFINE_HASHTABLE(fscrypt_master_keys, 6); /* 6 bits = 64 buckets */
>  static DEFINE_SPINLOCK(fscrypt_master_keys_lock);
> @@ -144,10 +140,9 @@ static struct fscrypt_mode available_modes[] = {
>  	},
>  	[FS_ENCRYPTION_MODE_AES_128_CBC] = {
>  		.friendly_name = "AES-128-CBC",
> -		.cipher_str = "cbc(aes)",
> +		.cipher_str = "essiv(cbc(aes),aes,sha256)",
>  		.keysize = 16,
> -		.ivsize = 16,
> -		.needs_essiv = true,
> +		.ivsize = 8,
>  	},

Now that the essiv template takes the same size IV, the .ivsize here needs to be
left as 16.

- Eric
