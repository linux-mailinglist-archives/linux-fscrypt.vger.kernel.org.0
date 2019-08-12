Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D03D8A77D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 21:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfHLTru (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 15:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbfHLTru (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 15:47:50 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B68CF20673;
        Mon, 12 Aug 2019 19:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565639270;
        bh=Zgcv9Y+g56/ZxetdBFWjYeuHHvXTFUfMebwhbWEKpuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R36a4/a+uKT4oeMzzX/A5Vq6DXEIF9CDlf5YcRM8XN4mVGC/QNVGiqkrRgihb00Eh
         tWE8R2cuph5e80yr6EMTd1Ft23diFJeocaahe/2GObNzU7CLWE19dAdFdtWbV931dY
         WQUdf7XQ63EnnR1wT53YJvnYGAn15fBThZnphx/8=
Date:   Mon, 12 Aug 2019 12:47:48 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v10 2/7] fs: crypto: invoke crypto API for ESSIV handling
Message-ID: <20190812194747.GB131059@gmail.com>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
References: <20190812145324.27090-1-ard.biesheuvel@linaro.org>
 <20190812145324.27090-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812145324.27090-3-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 12, 2019 at 05:53:19PM +0300, Ard Biesheuvel wrote:
> Instead of open coding the calculations for ESSIV handling, use a
> ESSIV skcipher which does all of this under the hood.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This looks fine (except for one comment below), but this heavily conflicts with
the fscrypt patches planned for v5.4.  So I suggest moving this to the end of
the series and having Herbert take only 1-6, and I'll apply this one to the
fscrypt tree later.

Thanks!

> ---
>  fs/crypto/Kconfig           |  1 +
>  fs/crypto/crypto.c          |  5 --
>  fs/crypto/fscrypt_private.h |  9 --
>  fs/crypto/keyinfo.c         | 92 +-------------------
>  4 files changed, 4 insertions(+), 103 deletions(-)
> 
> diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> index 5fdf24877c17..6f3d59b880b7 100644
> --- a/fs/crypto/Kconfig
> +++ b/fs/crypto/Kconfig
> @@ -5,6 +5,7 @@ config FS_ENCRYPTION
>  	select CRYPTO_AES
>  	select CRYPTO_CBC
>  	select CRYPTO_ECB
> +	select CRYPTO_ESSIV
>  	select CRYPTO_XTS
>  	select CRYPTO_CTS
>  	select KEYS

In v5.3 I removed the 'select CRYPTO_SHA256', so now ESSIV shouldn't be selected
here either.  Instead we should just update the documentation:

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 82efa41b0e6c02..a1e2ab12a99943 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -193,7 +193,8 @@ If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
 AES-128-CBC was added only for low-powered embedded devices with
 crypto accelerators such as CAAM or CESA that do not support XTS.  To
 use AES-128-CBC, CONFIG_CRYPTO_SHA256 (or another SHA-256
-implementation) must be enabled so that ESSIV can be used.
+implementation) and CONFIG_CRYPTO_ESSIV must be enabled so that ESSIV
+can be used.
 
 Adiantum is a (primarily) stream cipher-based mode that is fast even
 on CPUs without dedicated crypto instructions.  It's also a true
