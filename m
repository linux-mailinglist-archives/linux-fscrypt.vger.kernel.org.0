Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3B058897
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Jun 2019 19:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfF0Rg4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Jun 2019 13:36:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbfF0Rgu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Jun 2019 13:36:50 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69EAB2064A;
        Thu, 27 Jun 2019 17:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561657009;
        bh=VMwebPDCTF99U5fpGbQC2WDHoUqQ6b9IFPo7dXr2M+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dUwdbtzopMKEiParbcR3YQtRhya0WULc3ze+ETK5HWxBsfzsU8LoVolAMfT8A9r9o
         QPYEQbLZtBTPwMZfkAe0zojCd9pcM/CoMfdOeeUwFaA6nmDomC/P5iBMVl+E5QXbzu
         YXIVZaLgHIZSOPSHmlsNlV63FdU7kKDewfZIcpC0=
Date:   Thu, 27 Jun 2019 10:36:47 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] fscrypt: remove selection of CONFIG_CRYPTO_SHA256
Message-ID: <20190627173647.GG686@sol.localdomain>
References: <20190620181505.225232-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620181505.225232-1-ebiggers@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 20, 2019 at 11:15:05AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> fscrypt only uses SHA-256 for AES-128-CBC-ESSIV, which isn't the default
> and is only recommended on platforms that have hardware accelerated
> AES-CBC but not AES-XTS.  There's no link-time dependency, since SHA-256
> is requested via the crypto API on first use.
> 
> To reduce bloat, we should limit FS_ENCRYPTION to selecting the default
> algorithms only.  SHA-256 by itself isn't that much bloat, but it's
> being discussed to move ESSIV into a crypto API template, which would
> incidentally bring in other things like "authenc" support, which would
> all end up being built-in since FS_ENCRYPTION is now a bool.
> 
> For Adiantum encryption we already just document that users who want to
> use it have to enable CONFIG_CRYPTO_ADIANTUM themselves.  So, let's do
> the same for AES-128-CBC-ESSIV and CONFIG_CRYPTO_SHA256.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Documentation/filesystems/fscrypt.rst | 4 +++-
>  fs/crypto/Kconfig                     | 1 -
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 08c23b60e01647..87d4e266ffc86d 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -191,7 +191,9 @@ Currently, the following pairs of encryption modes are supported:
>  If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
>  
>  AES-128-CBC was added only for low-powered embedded devices with
> -crypto accelerators such as CAAM or CESA that do not support XTS.
> +crypto accelerators such as CAAM or CESA that do not support XTS.  To
> +use AES-128-CBC, CONFIG_CRYPTO_SHA256 (or another SHA-256
> +implementation) must be enabled so that ESSIV can be used.
>  
>  Adiantum is a (primarily) stream cipher-based mode that is fast even
>  on CPUs without dedicated crypto instructions.  It's also a true
> diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> index 24ed99e2eca0b2..5fdf24877c1785 100644
> --- a/fs/crypto/Kconfig
> +++ b/fs/crypto/Kconfig
> @@ -7,7 +7,6 @@ config FS_ENCRYPTION
>  	select CRYPTO_ECB
>  	select CRYPTO_XTS
>  	select CRYPTO_CTS
> -	select CRYPTO_SHA256
>  	select KEYS
>  	help
>  	  Enable encryption of files and directories.  This
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 

Applied to fscrypt.git for v5.3.

- Eric
