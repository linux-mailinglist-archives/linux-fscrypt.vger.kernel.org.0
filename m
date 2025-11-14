Return-Path: <linux-fscrypt+bounces-966-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A6770C5C424
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 10:27:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4F4B93604A7
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 09:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71B1D2DCBF8;
	Fri, 14 Nov 2025 09:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KK7T0X7E"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E33D302157
	for <linux-fscrypt@vger.kernel.org>; Fri, 14 Nov 2025 09:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763111916; cv=none; b=FVjafOFr6Mq6ea29ItFAbKCsLcPwCLu+MzzDyR46YyEKsjwjWBrR205ScUqc7FcNXmb7MbZiA30mNMR5oIfLV97oKxfIvJkZlqv5HHmIpRCaqm7wxneccQaYRLkSgrexe++lC0JFlL/CpOwBTndflXiRoQOO7d7T7WNz8hQFtBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763111916; c=relaxed/simple;
	bh=8YnwUZklD9E2jYY8EPNrGgrfjz07mBqvigjB2gUbmfE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dIqKvAezn4suRaAXgbqTYPCJa0T/uYap41ytvbZAcIvw47ANdd6aUvxmU9ts1OzzZJQh+d7siETpSLujE+XrIxTkw9sGM1/7NKwQuC1JT4p8aQumF+ToTU8ZRw2k18TEYQdJ0yEDR1qCoc52VKIVBylaqE2rMOwiMWCUPv6LspM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KK7T0X7E; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47775fb6cb4so12707565e9.0
        for <linux-fscrypt@vger.kernel.org>; Fri, 14 Nov 2025 01:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763111913; x=1763716713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fh8oH+7LCYbzfqHAKBW6hW6g41lmP/2iEuUwxvcptu4=;
        b=KK7T0X7EoESKeimwcUvLUkx0Rg9vEUJ8pgJWY4IxFD3dHsVJxYOP0XWtFknVx6onPM
         a22DijWBfiuNkc47eqnJ5GBFVdvwW6DZBaG3DPcyds/RWG7Gff4zdB7FM77U+nFkevS3
         Py9u8NUt8l1e3IF5KAxrGD361xt+FaKkwKHFh3EQrTJBLgJW3l/oGqUF0S6QZzg2YZVG
         LdPhrFMiIvaSCWFbM8eaQ+I1dLRhs/dVgfEqnLSm4Yk2FD9OWmyadw6pxjLdGuGvLda+
         Hrh4dsZnDxmV8WTQhSF41bt+CeXI01UvKvSqf6tKE+qVooaRv+RdINp3VEGDGNBC6WfL
         1F2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763111913; x=1763716713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fh8oH+7LCYbzfqHAKBW6hW6g41lmP/2iEuUwxvcptu4=;
        b=Vu/nYzMZFEKoSk7ifZt8/byw75TAwbBBvyup8T14xjVhDLhTUirY8yujBUT6jHGMVB
         2OvyT4DVFlZwjg2bMuzvKlTmoJbGz7Fwe1Zefa03Oy/u0i/tDpjNeYckBHopwm7s6fnO
         rkUlEu7+ueccqLzSy+KRqa29SZIpA00q3Kz+s1TtCuN49pMaimVFvbtvgT2pDYzymdZA
         RsR6lypfeM3IDL4+h8ErrpSIsu8N9BzQhfta+hRjqW3bOVOXU2luOEvOF9brpJUvdRVf
         LXmB1DPAAZX5ZLCec3LTOvoMZshhFpmCEwtHfYtpqdkRBVUmIxgdKX1rJNFkLMUFxwXt
         /cig==
X-Forwarded-Encrypted: i=1; AJvYcCXl6wuZNtUNoa7Aq4RFNZ+vVmmArjiTKZv0FXWJjWwnFmJE5p10+LC9EZuLFO1Q+MO7SdHgHyxuRJaGuZnh@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6uCRsHRoC7AomrRPOHAbMaaZlwZoAgPujtrb3p0h0dDtRqME1
	gfWXodb7tZKnC3zV6DoJ92mVuG1rl62ZSE/CuQ7lDmk9IFlewQtj00YRXYo18g==
X-Gm-Gg: ASbGncvx6VdvLkcJIqO5Tdd80jPRb9S12Ovd4BF88r+wxMJb3O8vsqURX0iYRbtSXfM
	vy0N7pkXPgHcP3ZHHA3anPOgN4+hnM/4rDtcchjMs6ejdVDBUp7gao7diRrivL6ErjYFJr5zl9a
	EL2hcPTG03krSFMcCzBDQjd/sRh6MUYgLrDjhRgs12/fShu2Jky+NoqI+/ZL9+xirxxxAGcT4Yr
	d/vt1P/P9/FRQThko/+ZYBOc7NsWiYJEWxY6/9t8X0J+eyCC0UELZwrTp9enUA6nVxG0DvZjk2I
	TtgE8MOdJx/V3ZcN1MyrFcQ7LzDpLEA07+QhxBT4TXeN60RHSz/Q4TMdZSp5d2U4sGPpJppLzXb
	vQC6R4fG2KB8lsg9z6HmjpQKsvzqKnDN88CVPbr/BVM+Lk0XbzvryOE+pLRmSG++imifY/JKGm6
	QFwsMm5UBcgeG63+66pezBIV2HDvs7QG4//BCATyhEyGYZuhX/zInS
X-Google-Smtp-Source: AGHT+IHO9mXMvHyXvx42yMjsmcUbusK0R/9wGsfDIWs8A9ZbddaK/fnTOOmm5FKcI48o9dbS+Wkhjw==
X-Received: by 2002:a05:600c:4fc9:b0:477:55de:8b22 with SMTP id 5b1f17b1804b1-4778fe620a4mr21039125e9.16.1763111912900;
        Fri, 14 Nov 2025 01:18:32 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e7ae5bsm8785202f8f.8.2025.11.14.01.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 01:18:32 -0800 (PST)
Date: Fri, 14 Nov 2025 09:18:30 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, andriy.shevchenko@intel.com, axboe@kernel.dk,
 ceph-devel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
 home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
 kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v5 3/6] lib/base64: rework encode/decode for speed and
 stricter validation
Message-ID: <20251114091830.5325eed3@pumpkin>
In-Reply-To: <20251114060132.89279-1-409411716@gms.tku.edu.tw>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
	<20251114060132.89279-1-409411716@gms.tku.edu.tw>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Nov 2025 14:01:32 +0800
Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

> The old base64 implementation relied on a bit-accumulator loop, which was
> slow for larger inputs and too permissive in validation. It would accept
> extra '=', missing '=', or even '=' appearing in the middle of the input,
> allowing malformed strings to pass. This patch reworks the internals to
> improve performance and enforce stricter validation.
> 
> Changes:
>  - Encoder:
>    * Process input in 3-byte blocks, mapping 24 bits into four 6-bit
>      symbols, avoiding bit-by-bit shifting and reducing loop iterations.
>    * Handle the final 1-2 leftover bytes explicitly and emit '=' only when
>      requested.
>  - Decoder:
>    * Based on the reverse lookup tables from the previous patch, decode
>      input in 4-character groups.
>    * Each group is looked up directly, converted into numeric values, and
>      combined into 3 output bytes.
>    * Explicitly handle padded and unpadded forms:
>       - With padding: input length must be a multiple of 4, and '=' is
>         allowed only in the last two positions. Reject stray or early '='.
>       - Without padding: validate tail lengths (2 or 3 chars) and require
>         unused low bits to be zero.
>    * Removed the bit-accumulator style loop to reduce loop iterations.
> 
> Performance (x86_64, Intel Core i7-10700 @ 2.90GHz, avg over 1000 runs,
> KUnit):
> 
> Encode:
>   64B   ~90ns   -> ~32ns   (~2.8x)
>   1KB  ~1332ns  -> ~510ns  (~2.6x)
> 
> Decode:
>   64B  ~1530ns  -> ~35ns   (~43.7x)
>   1KB ~27726ns  -> ~530ns  (~52.3x)
> 
> Co-developed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Co-developed-by: Yu-Sheng Huang <home7438072@gmail.com>
> Signed-off-by: Yu-Sheng Huang <home7438072@gmail.com>
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>

Reviewed-by: David Laight <david.laight.linux@gmail.com>

But see minor nit below.
> ---
>  lib/base64.c | 109 ++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 68 insertions(+), 41 deletions(-)
> 
> diff --git a/lib/base64.c b/lib/base64.c
> index 9d1074bb821c..1a6d8fe37eda 100644
> --- a/lib/base64.c
> +++ b/lib/base64.c
> @@ -79,28 +79,38 @@ static const s8 base64_rev_maps[][256] = {
>  int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
>  {
>  	u32 ac = 0;
> -	int bits = 0;
> -	int i;
>  	char *cp = dst;
>  	const char *base64_table = base64_tables[variant];
>  
> -	for (i = 0; i < srclen; i++) {
> -		ac = (ac << 8) | src[i];
> -		bits += 8;
> -		do {
> -			bits -= 6;
> -			*cp++ = base64_table[(ac >> bits) & 0x3f];
> -		} while (bits >= 6);
> -	}
> -	if (bits) {
> -		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
> -		bits -= 6;
> +	while (srclen >= 3) {
> +		ac = (u32)src[0] << 16 | (u32)src[1] << 8 | (u32)src[2];

There is no need for the (u32) casts.
All char/short values are promoted to 'int' prior to any maths.

> +		*cp++ = base64_table[ac >> 18];
> +		*cp++ = base64_table[(ac >> 12) & 0x3f];
> +		*cp++ = base64_table[(ac >> 6) & 0x3f];
> +		*cp++ = base64_table[ac & 0x3f];
> +
> +		src += 3;
> +		srclen -= 3;
>  	}
> -	if (padding) {
> -		while (bits < 0) {
> +
> +	switch (srclen) {
> +	case 2:
> +		ac = (u32)src[0] << 16 | (u32)src[1] << 8;
> +		*cp++ = base64_table[ac >> 18];
> +		*cp++ = base64_table[(ac >> 12) & 0x3f];
> +		*cp++ = base64_table[(ac >> 6) & 0x3f];
> +		if (padding)
> +			*cp++ = '=';
> +		break;
> +	case 1:
> +		ac = (u32)src[0] << 16;
> +		*cp++ = base64_table[ac >> 18];
> +		*cp++ = base64_table[(ac >> 12) & 0x3f];
> +		if (padding) {
> +			*cp++ = '=';
>  			*cp++ = '=';
> -			bits += 2;
>  		}
> +		break;
>  	}
>  	return cp - dst;
>  }
> @@ -116,41 +126,58 @@ EXPORT_SYMBOL_GPL(base64_encode);
>   *
>   * Decodes a string using the selected Base64 variant.
>   *
> - * This implementation hasn't been optimized for performance.
> - *
>   * Return: the length of the resulting decoded binary data in bytes,
>   *	   or -1 if the string isn't a valid Base64 string.
>   */
>  int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base64_variant variant)
>  {
> -	u32 ac = 0;
> -	int bits = 0;
> -	int i;
>  	u8 *bp = dst;
> -	s8 ch;
> +	s8 input[4];
> +	s32 val;
> +	const u8 *s = (const u8 *)src;
> +	const s8 *base64_rev_tables = base64_rev_maps[variant];
>  
> -	for (i = 0; i < srclen; i++) {
> -		if (padding) {
> -			if (src[i] == '=') {
> -				ac = (ac << 6);
> -				bits += 6;
> -				if (bits >= 8)
> -					bits -= 8;
> -				continue;
> -			}
> -		}
> -		ch = base64_rev_maps[variant][(u8)src[i]];
> -		if (ch == -1)
> -			return -1;
> -		ac = (ac << 6) | ch;
> -		bits += 6;
> -		if (bits >= 8) {
> -			bits -= 8;
> -			*bp++ = (u8)(ac >> bits);
> +	while (srclen >= 4) {
> +		input[0] = base64_rev_tables[s[0]];
> +		input[1] = base64_rev_tables[s[1]];
> +		input[2] = base64_rev_tables[s[2]];
> +		input[3] = base64_rev_tables[s[3]];
> +
> +		val = input[0] << 18 | input[1] << 12 | input[2] << 6 | input[3];
> +
> +		if (unlikely(val < 0)) {
> +			if (!padding || srclen != 4 || s[3] != '=')
> +				return -1;
> +			padding = 0;
> +			srclen = s[2] == '=' ? 2 : 3;
> +			break;
>  		}
> +
> +		*bp++ = val >> 16;
> +		*bp++ = val >> 8;
> +		*bp++ = val;
> +
> +		s += 4;
> +		srclen -= 4;
>  	}
> -	if (ac & ((1 << bits) - 1))
> +
> +	if (likely(!srclen))
> +		return bp - dst;
> +	if (padding || srclen == 1)
>  		return -1;
> +
> +	val = (base64_rev_tables[s[0]] << 12) | (base64_rev_tables[s[1]] << 6);
> +	*bp++ = val >> 10;
> +
> +	if (srclen == 2) {
> +		if (val & 0x800003ff)
> +			return -1;
> +	} else {
> +		val |= base64_rev_tables[s[2]];
> +		if (val & 0x80000003)
> +			return -1;
> +		*bp++ = val >> 2;
> +	}
>  	return bp - dst;
>  }
>  EXPORT_SYMBOL_GPL(base64_decode);


