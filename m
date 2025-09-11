Return-Path: <linux-fscrypt+bounces-825-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE88B53B6A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 20:29:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45C035A85C0
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 18:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F1B369996;
	Thu, 11 Sep 2025 18:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="REcPMWr1"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB19369988;
	Thu, 11 Sep 2025 18:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757615344; cv=none; b=kAY9QbNAp3YA7e3LyKPeLx9/hwtSdyNgj1UsWugnCSUO2av6vftyjp86kIY1eDPGm+3auQW4+z6bwOtq6GSsX6MtfuYlqkCj0+hz/EyWRRpPtplWHBieTEYU5WfZNDtv9AKG6qioV795Z4EqGhY6ItfjjCQpTancqrzm5Wsk4iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757615344; c=relaxed/simple;
	bh=pvWEsT93uVIOWz2M4Vho/D8Off0suykMzN0eQwwe1cQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VlOXk6tVRS7ooSTbxsfRJ3U27sEtVWIX7lRD0ZjsEgQLsinKqC9JjThBCxKz8W68b3O3UFadPfVgZMuhqps42WxIpMFf3uGFHaFOeC2378RiX4q0AhVQtD/4Eu6sB/ePYWJ2CwZ5tiNXRRovsLgXCp80C8doI/OutDQfCaLGubM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=REcPMWr1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3559C4CEF0;
	Thu, 11 Sep 2025 18:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757615344;
	bh=pvWEsT93uVIOWz2M4Vho/D8Off0suykMzN0eQwwe1cQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=REcPMWr12hkWlU47vLOp+4JNrEdwFzNsGScSmWVAnToIcCLLlhDQiuKTuTqKNUQem
	 Ocv0pa7kLZfhwH87URlPGO/+meOMec9lm0MCoaUkNuXdQMT4HLpDBmsPnKsgLWLL/6
	 y1I7y4iCX4GvruS/NveJh+l5kAG5WA/17rNfLjdGI5QvASUyOxxXNmxucFrWzX0K0R
	 ipgslH02B3b+9iyixNlQurXzn/3rqhpigEcftdN90RRtxfRDt8x5bOJqTqiMpDFIKs
	 vddMSornGj9xVKzeB3fhOqzps0gNC21jqSVWrQy0tPXp7A6RUzTPzTA4MR75V+fGFT
	 edMpfdGsma8Gw==
Date: Thu, 11 Sep 2025 11:27:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
	hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
	jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 2/5] lib/base64: rework encoder/decoder with
 customizable support and update nvme-auth
Message-ID: <20250911182742.GC1376@sol>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911074159.656943-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911074159.656943-1-409411716@gms.tku.edu.tw>

On Thu, Sep 11, 2025 at 03:41:59PM +0800, Guan-Chun Wu wrote:
> Rework base64_encode() and base64_decode() with extended interfaces
> that support custom 64-character tables and optional '=' padding.
> This makes them flexible enough to cover both standard RFC4648 Base64
> and non-standard variants such as base64url.

RFC4648 specifies both base64 and base64url.

> The encoder is redesigned to process input in 3-byte blocks, each
> mapped directly into 4 output symbols. Base64 naturally encodes
> 24 bits of input as four 6-bit values, so operating on aligned
> 3-byte chunks matches the algorithm's structure. This block-based
> approach eliminates the need for bit-by-bit streaming, reduces shifts,
> masks, and loop iterations, and removes data-dependent branches from
> the main loop.

There already weren't any data-dependent branches in the encoder.

> The decoder replaces strchr()-based lookups with direct table-indexed
> mapping. It processes input in 4-character groups and supports both
> padded and non-padded forms. Validation has been strengthened: illegal
> characters and misplaced '=' padding now cause errors, preventing
> silent data corruption.

The decoder already detected invalid inputs.

> While this is a mechanical update following the lib/base64 rework,
> nvme-auth also benefits from the performance improvements in the new
> encoder/decoder, achieving faster encode/decode without altering the
> output format.
> 
> The reworked encoder and decoder unify Base64 handling across the kernel
> with higher performance, stricter correctness, and flexibility to support
> subsystem-specific variants.

Which part is more strictly correct?

> diff --git a/lib/base64.c b/lib/base64.c
> index 9416bded2..b2bd5dab5 100644
> --- a/lib/base64.c
> +++ b/lib/base64.c
> @@ -15,104 +15,236 @@
>  #include <linux/string.h>
>  #include <linux/base64.h>
>  
> -static const char base64_table[65] =
> -	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
> +#define BASE64_6BIT_MASK      0x3f /* Mask to extract lowest 6 bits */
> +#define BASE64_BITS_PER_BYTE  8
> +#define BASE64_CHUNK_BITS     6
> +
> +/* Output-char-indexed shifts: for output chars 0,1,2,3 respectively */
> +#define BASE64_SHIFT_OUT0	(BASE64_CHUNK_BITS * 3) /* 18 */
> +#define BASE64_SHIFT_OUT1	(BASE64_CHUNK_BITS * 2) /* 12 */
> +#define BASE64_SHIFT_OUT2	(BASE64_CHUNK_BITS * 1) /* 6  */
> +/* OUT3 uses 0 shift and just masks with BASE64_6BIT_MASK */
> +
> +/* For extracting bytes from the 24-bit value (decode main loop) */
> +#define BASE64_SHIFT_BYTE0        (BASE64_BITS_PER_BYTE * 2) /* 16 */
> +#define BASE64_SHIFT_BYTE1        (BASE64_BITS_PER_BYTE * 1) /* 8  */
> +
> +/* Tail (no padding) shifts to extract bytes */
> +#define BASE64_TAIL2_BYTE0_SHIFT  ((BASE64_CHUNK_BITS * 2) - BASE64_BITS_PER_BYTE)       /* 4  */
> +#define BASE64_TAIL3_BYTE0_SHIFT  ((BASE64_CHUNK_BITS * 3) - BASE64_BITS_PER_BYTE)       /* 10 */
> +#define BASE64_TAIL3_BYTE1_SHIFT  ((BASE64_CHUNK_BITS * 3) - (BASE64_BITS_PER_BYTE * 2)) /* 2  */
> +
> +/* Extra: masks for leftover validation (no padding) */
> +#define BASE64_MASK(n) ({        \
> +	unsigned int __n = (n);  \
> +	__n ? ((1U << __n) - 1U) : 0U; \
> +})
> +#define BASE64_TAIL2_UNUSED_BITS  (BASE64_CHUNK_BITS * 2 - BASE64_BITS_PER_BYTE)     /* 4 */
> +#define BASE64_TAIL3_UNUSED_BITS  (BASE64_CHUNK_BITS * 3 - BASE64_BITS_PER_BYTE * 2) /* 2 */

These #defines make the code unnecessarily hard to read.  Most of them
should just be replaced with the integer literals.

>   * This implementation hasn't been optimized for performance.

But the commit message claims performance improvements.

>   *
>   * Return: the length of the resulting decoded binary data in bytes,
>   *	   or -1 if the string isn't a valid base64 string.

base64 => Base64, since multiple variants are supported now.  Refer to
the terminology used by RFC4686.  Base64 is the general term, and
"base64" and "base64url" specific variants of Base64.

- Eric

