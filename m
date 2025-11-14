Return-Path: <linux-fscrypt+bounces-964-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D0142C5C3A7
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 10:22:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 544D14F75FB
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 09:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 610023019B2;
	Fri, 14 Nov 2025 09:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZekZKoQm"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBC2301704
	for <linux-fscrypt@vger.kernel.org>; Fri, 14 Nov 2025 09:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763111634; cv=none; b=b59qS6J7HCqdAE3DTRrzkMKT/5NuIHdlAS1S2sGv9kRHKij7lNdKuqx8LRHhdydZpsO3485b6W4RXQeta4IeecOeqIPp4857p3tfIeK6YGGWN1elGPITHuhKTxG3GIROEJkngUVkknu1PAvG4YlTure78ZzLbL8YJvH9/JW62kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763111634; c=relaxed/simple;
	bh=iVCqvgePU/wGPR47XXf3xAOZdNtH1UKmpeopkRAb5Ws=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=drAgPPDVe/2kMzjY8wPXLAm9QdyPda95cnI9oM24XkrSTAIAt5aX5XUJKILWin5Q1tH38fooMJ86CP98Wrs2SBYAX58wM9BZEGKC0RVsj6gQv7XmYzfZ91Y9pEbvrkNS9Lo3KrELU0VT7ULokAd9sUMrCU2GiN1LgdqSLbUGsZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZekZKoQm; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42b32a5494dso972246f8f.2
        for <linux-fscrypt@vger.kernel.org>; Fri, 14 Nov 2025 01:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763111631; x=1763716431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XDbO6elBelp1xcMzvhbE4h1VYLIpO20wVUv2aHOqtRg=;
        b=ZekZKoQm/rpKD5kLLxMWmetk021KFV6R7H4aBDqEzArISi0ZhfYttx5aqSq2ewolh8
         VQADOzk2wOHbXxPR3Z/YFw7PwuZsfe4YozEioqaPcQy5/iEsbSjybMQTw6dGox1vsuXG
         OC8RUOec2Dh6HwN/UZJ/K5qN1TjFIfNe8lP5aGiBveDvoG08TQ1CcyM1QjMI/h0htRu7
         J7gC5NEdlbfdDGXxnqCDjXo8z0ySSLZEiKAdGsU4z8i+azeN97TpzkuhqJHCQKPUKLM9
         GGYEqEg8lgoIdov2qbIZ2ZukEpP14OomsFjRs1NvB/4XFa59kNaWedUX3mfblifacuQ8
         SS+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763111631; x=1763716431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XDbO6elBelp1xcMzvhbE4h1VYLIpO20wVUv2aHOqtRg=;
        b=KHXjt+SpG02DnMtQHFn/7kHW8b+dh7xneFiz6gdDfisw5FIIaxM7gFMnJCHISdAp08
         xdFaUZPFt0H+kZhqygPKiGz9/qjSmvVreN/MA3a3qlFiG8JLdaW3SOF+dmP6uuOYfbg7
         KqIvgPeDEJsWlYCSlrp9maqrP9R1LaVdUGIDlRa8F18+8NlQCG87eJj4fR3k4slsJHQo
         +9tf40Dkg84mRv5k97Zsa7IfVaJZSHYfjeKzMEdOkvezPEkU9FZKUSwLySS2ApyQV4zp
         B1Mg82fQr0EJLhv+pKNYDUsG4F771vnYSkCNiKUtf32Ueob9aKV1aQstu5zbTFBN8EUY
         xoiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWAkOynjsz98fLNr639E7KJCeqDVmwg804h+kO0vCUKiKfeXakVHVhcpXxr/Ayl9jW5MxikWBm5CtMwdy9@vger.kernel.org
X-Gm-Message-State: AOJu0YxdsIcdUiE1MI0Fa8MYhMBr0WLUrqB6Lle3kzq/Qzg800wk95+v
	x97sJDW+vOzbdDIzPei7JrRLiPlI6kQcLhQ+Jfx3bDM922VqH1AQ+YZv
X-Gm-Gg: ASbGnctYNKwvNSAZiQEvpJd+KypJYu0ylhi9g4NGZsu4ulRQXXwF/6IurMnu7ZmQhWX
	t5OhwKdGp2q86iXf19UpUDoT5WctzD4guZMtJhK71hxY+ypYfwV9B0OrW+zrsPgr6Y6KlMDHd1l
	C4mXjFVJWOtCMDPGcS4SaTzr8JnDWqBYSKA5WTmVXsa4copjLV0GA3EQkqc983XdA3fgpw5T2iK
	rEAYrLHe5ZU31lDnnHh8005KIgcvdXLp/QWwyPRbNmwdCTDnU3Tet/MCV+fzlmD/Dsp35wUMzVt
	hE07ZHs5qhllts62xjP8nWPts1i9cuauXSiGRzCZIIgVMcxsLmnCWvagNyVoADpIPopRJ8Qn+qC
	FObTtNKOihPDJSZD2m46LWCHv8qN0FDC1XKHQ2g0k3M5BiCb+VXwsSTcn5ZXctvkH4KuPyWZyPW
	G+dwHPP6QjJVcKqiCKG9omarYPbyM3cPUEb7dpcTb8RhRoNxUi0tQKGTxhdfQSeTI=
X-Google-Smtp-Source: AGHT+IHbVSvNUwD21hr+V01d6xNdOdYhkl3Gm087EM2lU14638PysIjp1BDXseK+rppV65oO+BHNwg==
X-Received: by 2002:a05:6000:1842:b0:42b:2eb3:c910 with SMTP id ffacd0b85a97d-42b593246b5mr2399008f8f.3.1763111630406;
        Fri, 14 Nov 2025 01:13:50 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f0b8a0sm8843496f8f.25.2025.11.14.01.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 01:13:50 -0800 (PST)
Date: Fri, 14 Nov 2025 09:13:48 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, andriy.shevchenko@intel.com, axboe@kernel.dk,
 ceph-devel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
 home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
 kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v5 1/6] lib/base64: Add support for multiple variants
Message-ID: <20251114091348.562c5965@pumpkin>
In-Reply-To: <20251114060045.88792-1-409411716@gms.tku.edu.tw>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
	<20251114060045.88792-1-409411716@gms.tku.edu.tw>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Nov 2025 14:00:45 +0800
Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

> From: Kuan-Wei Chiu <visitorckw@gmail.com>
> 
> Extend the base64 API to support multiple variants (standard, URL-safe,
> and IMAP) as defined in RFC 4648 and RFC 3501. The API now takes a
> variant parameter and an option to control padding. Update NVMe auth
> code to use the new interface with BASE64_STD.
> 
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>

Reviewed-by: David Laight <david.laight.linux@gmail.com>

> ---
>  drivers/nvme/common/auth.c |  4 +--
>  include/linux/base64.h     | 10 ++++--
>  lib/base64.c               | 62 ++++++++++++++++++++++----------------
>  3 files changed, 46 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
> index 1f51fbebd9fa..e07e7d4bf8b6 100644
> --- a/drivers/nvme/common/auth.c
> +++ b/drivers/nvme/common/auth.c
> @@ -178,7 +178,7 @@ struct nvme_dhchap_key *nvme_auth_extract_key(unsigned char *secret,
>  	if (!key)
>  		return ERR_PTR(-ENOMEM);
>  
> -	key_len = base64_decode(secret, allocated_len, key->key);
> +	key_len = base64_decode(secret, allocated_len, key->key, true, BASE64_STD);
>  	if (key_len < 0) {
>  		pr_debug("base64 key decoding error %d\n",
>  			 key_len);
> @@ -663,7 +663,7 @@ int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, size_t psk_len,
>  	if (ret)
>  		goto out_free_digest;
>  
> -	ret = base64_encode(digest, digest_len, enc);
> +	ret = base64_encode(digest, digest_len, enc, true, BASE64_STD);
>  	if (ret < hmac_len) {
>  		ret = -ENOKEY;
>  		goto out_free_digest;
> diff --git a/include/linux/base64.h b/include/linux/base64.h
> index 660d4cb1ef31..a2c6c9222da3 100644
> --- a/include/linux/base64.h
> +++ b/include/linux/base64.h
> @@ -8,9 +8,15 @@
>  
>  #include <linux/types.h>
>  
> +enum base64_variant {
> +	BASE64_STD,       /* RFC 4648 (standard) */
> +	BASE64_URLSAFE,   /* RFC 4648 (base64url) */
> +	BASE64_IMAP,      /* RFC 3501 */
> +};
> +
>  #define BASE64_CHARS(nbytes)   DIV_ROUND_UP((nbytes) * 4, 3)
>  
> -int base64_encode(const u8 *src, int len, char *dst);
> -int base64_decode(const char *src, int len, u8 *dst);
> +int base64_encode(const u8 *src, int len, char *dst, bool padding, enum base64_variant variant);
> +int base64_decode(const char *src, int len, u8 *dst, bool padding, enum base64_variant variant);
>  
>  #endif /* _LINUX_BASE64_H */
> diff --git a/lib/base64.c b/lib/base64.c
> index b736a7a431c5..a7c20a8e8e98 100644
> --- a/lib/base64.c
> +++ b/lib/base64.c
> @@ -1,12 +1,12 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * base64.c - RFC4648-compliant base64 encoding
> + * base64.c - Base64 with support for multiple variants
>   *
>   * Copyright (c) 2020 Hannes Reinecke, SUSE
>   *
>   * Based on the base64url routines from fs/crypto/fname.c
> - * (which are using the URL-safe base64 encoding),
> - * modified to use the standard coding table from RFC4648 section 4.
> + * (which are using the URL-safe Base64 encoding),
> + * modified to support multiple Base64 variants.
>   */
>  
>  #include <linux/kernel.h>
> @@ -15,26 +15,31 @@
>  #include <linux/string.h>
>  #include <linux/base64.h>
>  
> -static const char base64_table[65] =
> -	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
> +static const char base64_tables[][65] = {
> +	[BASE64_STD] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
> +	[BASE64_URLSAFE] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_",
> +	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
> +};
>  
>  /**
> - * base64_encode() - base64-encode some binary data
> + * base64_encode() - Base64-encode some binary data
>   * @src: the binary data to encode
>   * @srclen: the length of @src in bytes
> - * @dst: (output) the base64-encoded string.  Not NUL-terminated.
> + * @dst: (output) the Base64-encoded string.  Not NUL-terminated.
> + * @padding: whether to append '=' padding characters
> + * @variant: which base64 variant to use
>   *
> - * Encodes data using base64 encoding, i.e. the "Base 64 Encoding" specified
> - * by RFC 4648, including the  '='-padding.
> + * Encodes data using the selected Base64 variant.
>   *
> - * Return: the length of the resulting base64-encoded string in bytes.
> + * Return: the length of the resulting Base64-encoded string in bytes.
>   */
> -int base64_encode(const u8 *src, int srclen, char *dst)
> +int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
>  {
>  	u32 ac = 0;
>  	int bits = 0;
>  	int i;
>  	char *cp = dst;
> +	const char *base64_table = base64_tables[variant];
>  
>  	for (i = 0; i < srclen; i++) {
>  		ac = (ac << 8) | src[i];
> @@ -48,44 +53,49 @@ int base64_encode(const u8 *src, int srclen, char *dst)
>  		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
>  		bits -= 6;
>  	}
> -	while (bits < 0) {
> -		*cp++ = '=';
> -		bits += 2;
> +	if (padding) {
> +		while (bits < 0) {
> +			*cp++ = '=';
> +			bits += 2;
> +		}
>  	}
>  	return cp - dst;
>  }
>  EXPORT_SYMBOL_GPL(base64_encode);
>  
>  /**
> - * base64_decode() - base64-decode a string
> + * base64_decode() - Base64-decode a string
>   * @src: the string to decode.  Doesn't need to be NUL-terminated.
>   * @srclen: the length of @src in bytes
>   * @dst: (output) the decoded binary data
> + * @padding: whether to append '=' padding characters
> + * @variant: which base64 variant to use
>   *
> - * Decodes a string using base64 encoding, i.e. the "Base 64 Encoding"
> - * specified by RFC 4648, including the  '='-padding.
> + * Decodes a string using the selected Base64 variant.
>   *
>   * This implementation hasn't been optimized for performance.
>   *
>   * Return: the length of the resulting decoded binary data in bytes,
> - *	   or -1 if the string isn't a valid base64 string.
> + *	   or -1 if the string isn't a valid Base64 string.
>   */
> -int base64_decode(const char *src, int srclen, u8 *dst)
> +int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base64_variant variant)
>  {
>  	u32 ac = 0;
>  	int bits = 0;
>  	int i;
>  	u8 *bp = dst;
> +	const char *base64_table = base64_tables[variant];
>  
>  	for (i = 0; i < srclen; i++) {
>  		const char *p = strchr(base64_table, src[i]);
> -
> -		if (src[i] == '=') {
> -			ac = (ac << 6);
> -			bits += 6;
> -			if (bits >= 8)
> -				bits -= 8;
> -			continue;
> +		if (padding) {
> +			if (src[i] == '=') {
> +				ac = (ac << 6);
> +				bits += 6;
> +				if (bits >= 8)
> +					bits -= 8;
> +				continue;
> +			}
>  		}
>  		if (p == NULL || src[i] == 0)
>  			return -1;


