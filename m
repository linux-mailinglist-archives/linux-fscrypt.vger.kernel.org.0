Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E7B364D71
	for <lists+linux-fscrypt@lfdr.de>; Tue, 20 Apr 2021 00:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhDSWDk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 19 Apr 2021 18:03:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhDSWDk (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 19 Apr 2021 18:03:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C01DA613B4;
        Mon, 19 Apr 2021 22:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618869790;
        bh=rbbzhhZdZDrBJYE1hTnPbkp8I1WDQqqO6Ud1fwbJ1Gg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bq2PDhmNlt9la0ymY2s9e/kGNVt4vAUOFB0fQ1wqK62oRKfcvMOMqplX/LBfHr1Yw
         wziH+VLXh1f3sNlOhrimN8KcIHJo5Xhe+h401RFae0a8NSfgsyLGMuOlU7vbewIn7y
         3ajv997ivxmS8GKrcx+eRzrEQhcYETFl+NMxUyE70x/p+8UBIdrEgaLLiS4dMdq9Vi
         qaxQ6RdgZ9uJ3EaTsN7SJgseCtu6ez48zXJI76Qn3+2KuM3vSBJDbfVZegV2CFpt8e
         psctgGFWEsBL9XS3lrUXe5pjDWgdGjSf3q8PJ/3tFHdwZpsIQ0nKCccp0KrG5BIEPe
         tTfcM8HFsoM1g==
Date:   Mon, 19 Apr 2021 15:03:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 1/2] fscrypt: relax Kconfig dependencies for crypto API
 algorithms
Message-ID: <YH3+HBOyiLfa57Lw@gmail.com>
References: <20210416160642.85387-1-ardb@kernel.org>
 <20210416160642.85387-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416160642.85387-2-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 16, 2021 at 06:06:41PM +0200, Ard Biesheuvel wrote:
> Even if FS encryption has strict functional dependencies on various
> crypto algorithms and chaining modes. those dependencies could potentially
> be satisified by other implementations than the generic ones, and no link
> time dependency exists on the 'depends on' claused defined by
> CONFIG_FS_ENCRYPTION_ALGS.
> 
> So let's relax these clauses to 'imply', so that the default behavior
> is still to pull in those generic algorithms, but in a way that permits
> them to be disabled again in Kconfig.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  fs/crypto/Kconfig | 23 ++++++++++++++------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> index a5f5c30368a2..1e6c11de95c8 100644
> --- a/fs/crypto/Kconfig
> +++ b/fs/crypto/Kconfig
> @@ -17,13 +17,22 @@ config FS_ENCRYPTION
>  # allows the algorithms to be built as modules when all the filesystems are.
>  config FS_ENCRYPTION_ALGS
>  	tristate
> -	select CRYPTO_AES
> -	select CRYPTO_CBC
> -	select CRYPTO_CTS
> -	select CRYPTO_ECB
> -	select CRYPTO_HMAC
> -	select CRYPTO_SHA512
> -	select CRYPTO_XTS
> +	imply CRYPTO_AES
> +	imply CRYPTO_CBC
> +	imply CRYPTO_CTS
> +	imply CRYPTO_ECB
> +	imply CRYPTO_HMAC
> +	imply CRYPTO_SHA512
> +	imply CRYPTO_XTS
> +	help
> +	  This pulls in the generic implementations of the various
> +	  cryptographic algorithms and chaining modes that filesystem
> +	  encryption relies on. These are 'soft' dependencies only, as
> +	  architectures may supersede these generic implementations with
> +	  special, optimized ones.
> +
> +	  If unsure, keep the generic algorithms enabled, as they can
> +	  happily co-exist with per-architecture implementations.
>  

This seems reasonable to me.  It does have the disadvantage of allowing
misconfigurations where algorithms that are supposed to be available are not
actually made available.  But it's probably better to allow the flexibility to
disable the generic implementations.

I don't really like the help text, though.  First, the description of
FS_ENCRYPTION_ALGS should be either in a comment *or* in a 'help' block, not
split between both.  I think a comment would make more sense since
FS_ENCRYPTION_ALGS isn't a user-selectable symbol, so the 'help' would only be
seen by reading the Kconfig file anyway.

Second, "algorithms that filesystem encryption relies on" is too vague.  We
should clarify that only the "default" algorithms get automatically selected,
and the user may still need to explicitly select more.

Here's a suggested comment which I think would explain things a lot better:

# Filesystems supporting encryption must select this if FS_ENCRYPTION.  This
# allows the algorithms to be built as modules when all the filesystems are,
# whereas selecting them from FS_ENCRYPTION would force them to be built-in.
#
# Note: this option only pulls in the algorithms that filesystem encryption
# needs "by default".  If userspace will use "non-default" encryption modes such
# as Adiantum encryption, then those other modes need to be explicitly enabled
# in the crypto API; see Documentation/filesystems/fscrypt.rst for details.
#
# Also note that this option only pulls in the generic implementations of the
# algorithms, not any per-architecture optimized implementations.  It is
# strongly recommended to enable optimized implementations too.  It is safe to
# disable these generic implementations if corresponding optimized
# implementations will always be available too; for this reason, these are soft
# dependencies ('imply' rather than 'select').  Only disable these generic
# implementations if you're sure they will never be needed, though.
