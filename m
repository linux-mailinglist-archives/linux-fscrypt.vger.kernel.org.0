Return-Path: <linux-fscrypt+bounces-613-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A94A38C2D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Feb 2025 20:16:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AF51164BFB
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Feb 2025 19:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6053187858;
	Mon, 17 Feb 2025 19:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D7xI2Q6r"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C02970814;
	Mon, 17 Feb 2025 19:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739819783; cv=none; b=nOstCRkAF200Q1QW3zchKr/39QPudWIQnYOGY66sMkZSJRB69gYCD3mF+QZa6KisByz8FTsOqcctGhGVEOuq6IYZjuha1V/kxwAD5/UeNnqyQQFve6FzOeh+6peHSLwUiS5+eYu6QDKMUQLIVIq/rzfSlSus5drdz7QO77OulD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739819783; c=relaxed/simple;
	bh=Cd56Fu43aM7iWILzjVOUheZiTIWLTyEFJBli98GCfZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Di+uE87Y6AIt94nnxFtaRCXvHHVznfX4k2koSSWFa7r6BEC4xru6i+x/aAFxycLGMRDCU58hrlhPGsBVKeY1Nk6JkbhRrh8zoapMsjY4XH/9O8m9aSb2h0YMVbKzE5M0eN8jz3HIWYTQ9U6xynQinZxtpagtY+oAuBquISQRSmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D7xI2Q6r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC83C4AF0B;
	Mon, 17 Feb 2025 19:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739819783;
	bh=Cd56Fu43aM7iWILzjVOUheZiTIWLTyEFJBli98GCfZ0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=D7xI2Q6rNsK3GuZU9F3uUPkD9VCejukcCPYd6gq85NwAP3RLoOl3a9nhzEdm3gyW6
	 UWVBC7bwIRNpD3XS6hki4MYIof86D7CB1d6tBq77TyvbiLdSEoVskMRJ4T3lJOj15d
	 FNMU92AXNB5uWU1UxN8knQJcllIv4QqFnwdDmOlec4xbGo1quv4+Ca6FqpY/dbUpN1
	 LqHaF0wieT0TGD87KEyBeHroz0BEo9MKAijjSvKKAfEtptWWgCotxO04TFiLZoeLbh
	 2eB7rAQTTMb3RcuTjVBLMaH9dEi9l1J3bW1T+ohRVk/ePOF6SDbgKRdhD7LpO6J4Q7
	 UhP2bfhm/CbIA==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5461b5281bcso1621031e87.3;
        Mon, 17 Feb 2025 11:16:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVJJR6aDRquHIpW+Cukl1e+LQBsRsAv3lflIeWPxvy94OkMigDDp7qkrgXHr0+Q3fauheX0u0piF/asO2w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwU+ikTkrpEe/ja+E7Px0xgPtu7Zde3AhWWsyiLZJoXLq00yy40
	DmpcASgvoudp3w5VyGHZH+5NOHy0WNhAor2kkbsvkKVL0GQAay+eT5s1FUyM+bzo04E7yGFFDbj
	eZAjKF6eKdFlSMvNAiBdJabYq5Js=
X-Google-Smtp-Source: AGHT+IELa3qzxAwC03Hxq0Gl1BSJ7IzfdAmlY/onMbQW/9s2+m6iUXdlY50n/qEu4dE/CO6YgUuI0rxirb8uCKY+HKs=
X-Received: by 2002:a05:6512:ea5:b0:545:6cf:6f3e with SMTP id
 2adb3069b0e04-5452fea6e3fmr3076627e87.49.1739819781489; Mon, 17 Feb 2025
 11:16:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250217185314.27345-1-ebiggers@kernel.org>
In-Reply-To: <20250217185314.27345-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 17 Feb 2025 20:16:10 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHS_cpaCmeaGFU+uaf0E0+XXi=12-5tFzkKEBLwNHMhrg@mail.gmail.com>
X-Gm-Features: AWEUYZmWuYklZfeAnIdrqFWdWUweg059oicOf1lBrCerXeN4c4Dl4iwAHwtFs3A
Message-ID: <CAMj1kXHS_cpaCmeaGFU+uaf0E0+XXi=12-5tFzkKEBLwNHMhrg@mail.gmail.com>
Subject: Re: [PATCH] Revert "fscrypt: relax Kconfig dependencies for crypto
 API algorithms"
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"

On Mon, 17 Feb 2025 at 19:53, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> This mostly reverts commit a0fc20333ee4bac1147c4cf75dea098c26671a2f.
> Keep the relevant parts of the comment added by that commit.
>
> The problem with that commit is that it allowed people to create broken
> configurations that enabled FS_ENCRYPTION but not the mandatory
> algorithms.  An example of this can be found here:
> https://lore.kernel.org/r/1207325.1737387826@warthog.procyon.org.uk/
>
> The commit did allow people to disable specific generic algorithm
> implementations that aren't needed.  But that at best allowed saving a
> bit of code.  In the real world people are unlikely to intentionally and
> correctly make such a tweak anyway, as they tend to just be confused by
> what all the different crypto kconfig options mean.
>
> Of course we really need the crypto API to enable the correct
> implementations automatically, but that's for a later fix.
>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/Kconfig | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> index 5aff5934baa12..332d828fe6fa5 100644
> --- a/fs/crypto/Kconfig
> +++ b/fs/crypto/Kconfig
> @@ -22,24 +22,20 @@ config FS_ENCRYPTION
>  # as Adiantum encryption, then those other modes need to be explicitly enabled
>  # in the crypto API; see Documentation/filesystems/fscrypt.rst for details.
>  #
>  # Also note that this option only pulls in the generic implementations of the
>  # algorithms, not any per-architecture optimized implementations.  It is
> -# strongly recommended to enable optimized implementations too.  It is safe to
> -# disable these generic implementations if corresponding optimized
> -# implementations will always be available too; for this reason, these are soft
> -# dependencies ('imply' rather than 'select').  Only disable these generic
> -# implementations if you're sure they will never be needed, though.
> +# strongly recommended to enable optimized implementations too.
>  config FS_ENCRYPTION_ALGS
>         tristate
> -       imply CRYPTO_AES
> -       imply CRYPTO_CBC
> -       imply CRYPTO_CTS
> -       imply CRYPTO_ECB
> -       imply CRYPTO_HMAC
> -       imply CRYPTO_SHA512
> -       imply CRYPTO_XTS
> +       select CRYPTO_AES
> +       select CRYPTO_CBC
> +       select CRYPTO_CTS
> +       select CRYPTO_ECB
> +       select CRYPTO_HMAC
> +       select CRYPTO_SHA512
> +       select CRYPTO_XTS
>
>  config FS_ENCRYPTION_INLINE_CRYPT
>         bool "Enable fscrypt to use inline crypto"
>         depends on FS_ENCRYPTION && BLK_INLINE_ENCRYPTION
>         help
>
> base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
> --
> 2.48.1
>
>

