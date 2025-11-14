Return-Path: <linux-fscrypt+bounces-965-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CBC4CC5C3BB
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 10:23:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 04BC935D233
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 09:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6359E303A02;
	Fri, 14 Nov 2025 09:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e4oLwIsy"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426E8302767
	for <linux-fscrypt@vger.kernel.org>; Fri, 14 Nov 2025 09:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763111700; cv=none; b=e90h1cF3kSBwt9WrOiTcTgyYPGpkrES9nCS4l8Evjb0w1WrooyKq2r2THjj5/5508BxSugaqU9alYEGnfTRIsj4yiWTxMwas3sHWmQNqB7w06NDqRweWGbNcRgitmgIEzc6twQZGlx3lkcCPf18VnR6Z0bdTuHdBxUWcrkped7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763111700; c=relaxed/simple;
	bh=2E/wk4ll31VAFKwMa9GhOn8TIMH7sn15E5LQUU4V2ho=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fSeXudXzZJiT94rH81blauo9wkWknTfJr1vdpq+bU+tgjgnJ0xLlDNhnRnFsAkhgGUbulcnN8FH8zCsL3ImLgX0PMDmDrN3/hydKz3p9JB303URFgyi7LPVqbo3RCReMaQAKnbtOlAWNLaMIDhnSUAANt0KC4FhN32o7oBzdcU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e4oLwIsy; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42b32a5494dso973150f8f.2
        for <linux-fscrypt@vger.kernel.org>; Fri, 14 Nov 2025 01:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763111696; x=1763716496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RmGL71As4NC9Ari9wD9SqERFZR+6bEtc3Jb/BauBhYM=;
        b=e4oLwIsyIxIifQNdUiFTGWaCnu0ZzKbY5Hve7EfEs9fj3xNm+r6WBVeAlJJ4cp4Rfd
         x41d4jMiUfKKGuq0HwmobjPJbH/yS8R5EjNbf9OjQoFIAEfu2KFfE5NN90KCBrsRQCjD
         QB8mQ+XtVkL9Sw6QyBJ9ABlyLKtsbHn1KulRYtMlvuuT0gFlCp1C40NoKQIlffA7xK9f
         x3IFmt+4wmeDv72S/Xj8JVmpk9M7r9L964Fm/2c5LLoplvDWVzQFg50Y2WdoGFnI9qec
         KJDH49N+4E8mz9jGO1SV4w8VBCR/+JTq5hEKf6/A5ldUyMM9k654riRUUFVklF7p9YAG
         q/4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763111696; x=1763716496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RmGL71As4NC9Ari9wD9SqERFZR+6bEtc3Jb/BauBhYM=;
        b=PsPvw4o5zsXPVePQlIWSkwTN18BeaAlpM4YEWcF8q3JJcl3y1hVImjl/ixejR/shU9
         v959rCPhhCgkr1muHYSrazDyWcvk+ffLUTZo/MPb3qu1ViyLIvqyW8krf37VTqVYcn3Y
         JAqwKkYwjFrs4MdvUMTcO0lscWP6fnF7CAgtnkWUebE+62UefT6EU5Kc7lyigJ8FXr1a
         bkNgucwpU87fhRzPUBAuE3vooo71+YZ97ExKIRu6JwL7t8FrWa0iLbhGNHSFp/QZH3HC
         A8JxG/Wf499vb2r2gkhbSYG2wnNLvmFBWm01GX+1bttahxfGGECcBULSgJqfdU7G4xZv
         p6xQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdF3dC+g0xuHKbac6gQCm3S+AY/oT204pvW7eo9fFfFrqFvwqCPGDyyCsU6GxtsgSbR8yGINaifWbUun+p@vger.kernel.org
X-Gm-Message-State: AOJu0YyJLz6ptDwkxf7daCVjaecHlOK8UAUWnC5uixr4ogd7Bw1f5xPT
	lt3Xz7i7+fPQVit6qgBNzhxWheUZWC1BR50Gecu99yHxAhGlNw9JdrfL
X-Gm-Gg: ASbGncsQDSC+DSIVm2/Pl0nbNkdKKzVxHYU0d7oNxqL6qeyYRxRwe9hc5nBvD7W08B/
	ren1iQ7y+Z6KFO8IDPF/MRhG/Pl293AEkyp4Gksf+ZSa1e9LD6MxWdOaZWrqhNHeA9P5AW7HFFB
	ICjOHxBCVFUqem1MN/38PMDdYrctEKc4znYHC8JUuXaUY7qX0CCklJGkr7LU4U2nffRfzIlY8ho
	AU/yQdA/I0YHtNBtJEzvuPBQeLoUjboKIfysAqzc10FdnwUflY+p5HARkNQJk5eArpyQAgDVxi6
	mTMlbVGqDrGTTiPUeXFFJu3a3KC3x7f/RiVuYf4HaKSqsW10OACf+Ed+jkFJWPa8HG5C61aGVt/
	atmz2BOS33hPbvu9g1jL13h8zr0tg4mkGZwfm61t+80PA7oz9Ko5MtAOHRUeVs+fACF5THvkpA5
	4OjmcTfQ2PfvBZSaAY/o1AS+2q2h9Pe+YqGBx1ZuoUGIytYaKkkKbZ
X-Google-Smtp-Source: AGHT+IG6vU2bsOEFY2Pt3/YgVdDI6hItqo1MmD515aomBXXZ72CDnKNh3ehpPfNQLQSjE0uqgfo72w==
X-Received: by 2002:a05:6000:1a8d:b0:42b:3746:3b86 with SMTP id ffacd0b85a97d-42b5938aab5mr2239624f8f.54.1763111696455;
        Fri, 14 Nov 2025 01:14:56 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f0b8d6sm9102852f8f.28.2025.11.14.01.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 01:14:56 -0800 (PST)
Date: Fri, 14 Nov 2025 09:14:54 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, andriy.shevchenko@intel.com, axboe@kernel.dk,
 ceph-devel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
 home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
 kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v5 2/6] lib/base64: Optimize base64_decode() with
 reverse lookup tables
Message-ID: <20251114091454.5a5dbfc7@pumpkin>
In-Reply-To: <20251114060107.89026-1-409411716@gms.tku.edu.tw>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
	<20251114060107.89026-1-409411716@gms.tku.edu.tw>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Nov 2025 14:01:07 +0800
Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

> From: Kuan-Wei Chiu <visitorckw@gmail.com>
> 
> Replace the use of strchr() in base64_decode() with precomputed reverse
> lookup tables for each variant. This avoids repeated string scans and
> improves performance. Use -1 in the tables to mark invalid characters.
> 
> Decode:
>   64B   ~1530ns  ->  ~80ns    (~19.1x)
>   1KB  ~27726ns  -> ~1239ns   (~22.4x)
> 
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>

Reviewed-by: David Laight <david.laight.linux@gmail.com>

> ---
>  lib/base64.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/base64.c b/lib/base64.c
> index a7c20a8e8e98..9d1074bb821c 100644
> --- a/lib/base64.c
> +++ b/lib/base64.c
> @@ -21,6 +21,49 @@ static const char base64_tables[][65] = {
>  	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
>  };
>  
> +/**
> + * Initialize the base64 reverse mapping for a single character
> + * This macro maps a character to its corresponding base64 value,
> + * returning -1 if the character is invalid.
> + * char 'A'-'Z' maps to 0-25, 'a'-'z' maps to 26-51, '0'-'9' maps to 52-61,
> + * ch_62 maps to 62, ch_63 maps to 63, and other characters return -1
> + */
> +#define INIT_1(v, ch_62, ch_63) \
> +	[v] = (v) >= 'A' && (v) <= 'Z' ? (v) - 'A' \
> +		: (v) >= 'a' && (v) <= 'z' ? (v) - 'a' + 26 \
> +		: (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
> +		: (v) == (ch_62) ? 62 : (v) == (ch_63) ? 63 : -1
> +/**
> + * Recursive macros to generate multiple Base64 reverse mapping table entries.
> + * Each macro generates a sequence of entries in the lookup table:
> + * INIT_2 generates 2 entries, INIT_4 generates 4, INIT_8 generates 8, and so on up to INIT_32.
> + */
> +#define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
> +#define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
> +#define INIT_8(v, ...) INIT_4(v, __VA_ARGS__), INIT_4((v) + 4, __VA_ARGS__)
> +#define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
> +#define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
> +
> +#define BASE64_REV_INIT(ch_62, ch_63) { \
> +	[0 ... 0x1f] = -1, \
> +	INIT_32(0x20, ch_62, ch_63), \
> +	INIT_32(0x40, ch_62, ch_63), \
> +	INIT_32(0x60, ch_62, ch_63), \
> +	[0x80 ... 0xff] = -1 }
> +
> +static const s8 base64_rev_maps[][256] = {
> +	[BASE64_STD] = BASE64_REV_INIT('+', '/'),
> +	[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),
> +	[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
> +};
> +
> +#undef BASE64_REV_INIT
> +#undef INIT_32
> +#undef INIT_16
> +#undef INIT_8
> +#undef INIT_4
> +#undef INIT_2
> +#undef INIT_1
>  /**
>   * base64_encode() - Base64-encode some binary data
>   * @src: the binary data to encode
> @@ -84,10 +127,9 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
>  	int bits = 0;
>  	int i;
>  	u8 *bp = dst;
> -	const char *base64_table = base64_tables[variant];
> +	s8 ch;
>  
>  	for (i = 0; i < srclen; i++) {
> -		const char *p = strchr(base64_table, src[i]);
>  		if (padding) {
>  			if (src[i] == '=') {
>  				ac = (ac << 6);
> @@ -97,9 +139,10 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
>  				continue;
>  			}
>  		}
> -		if (p == NULL || src[i] == 0)
> +		ch = base64_rev_maps[variant][(u8)src[i]];
> +		if (ch == -1)
>  			return -1;
> -		ac = (ac << 6) | (p - base64_table);
> +		ac = (ac << 6) | ch;
>  		bits += 6;
>  		if (bits >= 8) {
>  			bits -= 8;


