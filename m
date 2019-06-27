Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B2D58742
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Jun 2019 18:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfF0Qjl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Jun 2019 12:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbfF0Qjl (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Jun 2019 12:39:41 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 690152146E;
        Thu, 27 Jun 2019 16:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561653580;
        bh=fnhL5XMcFhypArWy/fUX1Dvznt3/2i/Ai/n6WqTzdNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Za0iuVbFK6Fac/03nrT+yjWpU0UY61Yfwf6C0tkVzOV2o0ISWKoYUF3XJmYIqKCxv
         fQfybbnnIVGCWdi2pWYjKVB91K2Fg4WWS9kt/vnYeZX1PCYdTFrwbJ7F/1elpejVqR
         EnJouM6X811U7f29xeb6CTVRSjVPAygobnNcghdQ=
Date:   Thu, 27 Jun 2019 09:39:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v5 2/7] fs: crypto: invoke crypto API for ESSIV handling
Message-ID: <20190627163938.GD686@sol.localdomain>
References: <20190626204047.32131-1-ard.biesheuvel@linaro.org>
 <20190626204047.32131-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626204047.32131-3-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 26, 2019 at 10:40:42PM +0200, Ard Biesheuvel wrote:
> diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
> index dcd91a3fbe49..82c7eb86ca00 100644
> --- a/fs/crypto/keyinfo.c
> +++ b/fs/crypto/keyinfo.c
> @@ -19,8 +19,6 @@
>  #include <crypto/skcipher.h>
>  #include "fscrypt_private.h"

Can you remove the includes that become unused as a result of this patch?

#include <crypto/aes.h>
#include <crypto/sha.h>

> @@ -495,7 +412,6 @@ static void put_crypt_info(struct fscrypt_info *ci)
>  		put_master_key(ci->ci_master_key);
>  	} else {
>  		crypto_free_skcipher(ci->ci_ctfm);
> -		crypto_free_cipher(ci->ci_essiv_tfm);
>  	}
>  	kmem_cache_free(fscrypt_info_cachep, ci);

Nit: should remove the curly braces here.

- Eric
