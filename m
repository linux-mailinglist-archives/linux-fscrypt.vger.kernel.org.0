Return-Path: <linux-fscrypt+bounces-804-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27167B3CCEC
	for <lists+linux-fscrypt@lfdr.de>; Sat, 30 Aug 2025 18:24:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D1F27A74F8
	for <lists+linux-fscrypt@lfdr.de>; Sat, 30 Aug 2025 16:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46F2D2C08DB;
	Sat, 30 Aug 2025 16:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiOSgv5W"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5B47082D;
	Sat, 30 Aug 2025 16:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756571074; cv=none; b=QVpVkwslAn9NDaxeoeHlC1pTO+GV1ckhjbE18uuii9tNUvA9ZYdQONPOdC4tTDe2jLUSS4tMx0xUq4n/8b1BQadYZHhR6WhlW8vF8RskM7sUG4s8jVasNett36hR6Joq0XGS1AAugoy2egrZl5bs2KtVxUqFRHtQ04hnIw0acXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756571074; c=relaxed/simple;
	bh=Nya/TZ4X12n/fB0RU73CjBTHO4OoIX+2tqn1y7X8YME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tSSGv7zGQ6LlQldooBak+yt4u1NGME0N13dw6Cvb5v5MKCONLaPR5GDJXWVu4FYyPiHfwh8OlBzSNmCYPA0hGhzjxNH9rtJ28M9f7qmXYf4n3+GCYrtwTXCaqgSt5H3sQJUzU5uV32Clyq93/gZQD7ANFBaoOq3hHjrrPy52j1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiOSgv5W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9EEC4CEEB;
	Sat, 30 Aug 2025 16:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756571073;
	bh=Nya/TZ4X12n/fB0RU73CjBTHO4OoIX+2tqn1y7X8YME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oiOSgv5WZHUhHBHe11JOt2oy1i1TmC/3kx0r0SgP/PbVcmpmpiCQcSpSksRVcGWQv
	 mluS4fLKPtkqSrttxRrmlOGeC/KhK9tRtuktJVf2fLd3zC3xYgX/8dBi2vVyuCAcK/
	 bbInSfxuoNqNX774+LcUkQ0K9G+zuru4+9saqS6ajFJiQLxzWHb88gEMVMVT2eE9B5
	 zDrvhFFVUg5rhMB/kk5N8ZYVo78B/NaVIw4RYgc3vuIkm4deSazQfh6wvmJfpQu0k/
	 44amRKyKVVCEQYzDx5MYN4QViANr11OuSEugN9D9PVoEZAUNWvITcUDZNy5+ZJ4xAN
	 vCj4qcVTloEjw==
Date: Sat, 30 Aug 2025 09:24:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: tytso@mit.edu, jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: optimize fscrypt_base64url_encode() with block
 processing
Message-ID: <20250830162431.GA1431@quark>
References: <20250830132832.7911-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250830132832.7911-1-409411716@gms.tku.edu.tw>

On Sat, Aug 30, 2025 at 09:28:32PM +0800, Guan-Chun Wu wrote:
> Previously, fscrypt_base64url_encode() processed input one byte at a
> time, using a bitstream, accumulating bits and emitting characters when
> 6 bits were available. This was correct but added extra computation.
> 
> This patch processes input in 3-byte blocks, mapping directly to 4 output
> characters. Any remaining 1 or 2 bytes are handled according to Base64 URL
> rules. This reduces computation and improves performance.
> 
> Performance test (5 runs) for fscrypt_base64url_encode():
> 
> 64B input:
> -------------------------------------------------------
> | Old method | 131 | 108 | 114 | 122 | 123 | avg ~120 ns |
> -------------------------------------------------------
> | New method |  84 |  81 |  84 |  82 |  84 | avg ~83 ns  |
> -------------------------------------------------------
> 
> 1KB input:
> --------------------------------------------------------
> | Old method | 1152 | 1121 | 1142 | 1147 | 1148 | avg ~1142 ns |
> --------------------------------------------------------
> | New method |  767 |  752 |  765 |  771 |  776 | avg ~766 ns  |
> --------------------------------------------------------
> 
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>

Thanks!

> Tested on Linux 6.8.0-64-generic x86_64
> with Intel Core i7-10700 @ 2.90GHz
> 
> Test is executed in the form of kernel module.
> 
> Test script:

Is there any chance you'd be interested in creating an fscrypt KUnit
test (in a separate patch) which tests fscrypt_base64url_encode() and
fscrypt_base64url_decode()?

> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index 010f9c0a4c2f..adaa16905498 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -204,20 +204,31 @@ static const char base64url_table[65] =
>  static int fscrypt_base64url_encode(const u8 *src, int srclen, char *dst)
>  {
>  	u32 ac = 0;
> -	int bits = 0;
> -	int i;
> +	int i = 0;
>  	char *cp = dst;
>  
> -	for (i = 0; i < srclen; i++) {
> -		ac = (ac << 8) | src[i];
> -		bits += 8;
> -		do {
> -			bits -= 6;
> -			*cp++ = base64url_table[(ac >> bits) & 0x3f];
> -		} while (bits >= 6);
> +	while (i + 2 < srclen) {
> +		ac = ((u32)src[i] << 16) | ((u32)src[i + 1] << 8) | (u32)src[i + 2];
> +		*cp++ = base64url_table[(ac >> 18) & 0x3f];
> +		*cp++ = base64url_table[(ac >> 12) & 0x3f];
> +		*cp++ = base64url_table[(ac >> 6) & 0x3f];
> +		*cp++ = base64url_table[ac & 0x3f];
> +		i += 3;
> +	}

To make it a bit easier to understand, how about updating src and srclen
as we go along?

	while (srclen >= 3) {
		ac = ((u32)src[0] << 16) | ((u32)src[1] << 8) | (u32)src[2];
		*cp++ = base64url_table[ac >> 18];
		*cp++ = base64url_table[(ac >> 12) & 0x3f];
		*cp++ = base64url_table[(ac >> 6) & 0x3f];
		*cp++ = base64url_table[ac & 0x3f];
		src += 3;
		srclen -= 3;
	}

	switch (srclen) {
	case 2:
		ac = ((u32)src[0] << 16) | ((u32)src[1] << 8);
		*cp++ = base64url_table[ac >> 18];
		*cp++ = base64url_table[(ac >> 12) & 0x3f];
		*cp++ = base64url_table[(ac >> 6) & 0x3f];
		break;
	case 1:
		ac = ((u32)src[0] << 16);
		*cp++ = base64url_table[ac >> 18];
		*cp++ = base64url_table[(ac >> 12) & 0x3f];
		break;
	}

'srclen >= 3' is much more readable than 'i + 2 < srclen', IMO.

Also, instead of '(ac >> 18) & 0x3f', we can just use 'ac >> 18', since
'ac' is a 24-bit value.

- Eric

