Return-Path: <linux-fscrypt+bounces-968-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CA6ACC61278
	for <lists+linux-fscrypt@lfdr.de>; Sun, 16 Nov 2025 11:29:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 84DE04E3673
	for <lists+linux-fscrypt@lfdr.de>; Sun, 16 Nov 2025 10:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7411C242935;
	Sun, 16 Nov 2025 10:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="diGzonbL"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD71F17D2
	for <linux-fscrypt@vger.kernel.org>; Sun, 16 Nov 2025 10:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763288938; cv=none; b=U49490ZE2fGQMUGW+4eQbwPIe/7F2T4lMxD2tpyMMU9lbc2ELdrs+EPgsH92muY/lUMCfembRbSRhsKJHMf/qdWq13gaVw7MW3XeQdCs8JfAecgOy9a6YMb6QSZr8mv9ZCj5EKzFwjeF8lNYwRwPVsdN1EvPoAxupNc56hLqceE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763288938; c=relaxed/simple;
	bh=6f1VXJgPcTe2fjyzE9KBLwf9UmHUXkRuwQmfUQF2VpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdDDLn75xFSOvuL0tAz61Cv9mkhrDZVkk3t8BifNVFJ6RgBKAqTL9jHaEkOLM/JS6YAtRe/KgqTrcGiXXrG/JiWzJityf/RbpdFei/AgEJhEWzYbQ+98fE8oCqxfKO1TCk9TEFPjuCl2jqokQT0MBiccywPJtcEActQPGz8yKBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=diGzonbL; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2981f9ce15cso41408125ad.1
        for <linux-fscrypt@vger.kernel.org>; Sun, 16 Nov 2025 02:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1763288934; x=1763893734; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JSW7JgNcs7DWh1nW7rtjeN1ASDGAXAC868BibcndNtw=;
        b=diGzonbLldtgCia/IgRQUEFlniO7cVfe9Xb/6gboGJfTmwKLTtfrCxGPnkBbqzFTuB
         CSbn5j2EnzzYYBcv8Y4a+5u1DXZy0kW2UDG96wlykweOjZSpeauvNJHBdz/DK+VFKcb8
         N0kp/KBE44/jk4H4xTHx7erdKFcEpxZ1KyFXM73kTVvVw73O4vNm58C3hhxRLg0xIa3Z
         TUbJwB/DT/zpQai5Aes4PcGkn6vw4HfA4jgkRiD5jS5UP2hxacC6me289rHjl2JzjNsP
         EfS7VEiClvbuzvQi2gOopDSw+bXGqrSPSonCbwH+APzR5GP9umXIDb1od2E23WvchhgI
         Cm9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763288934; x=1763893734;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JSW7JgNcs7DWh1nW7rtjeN1ASDGAXAC868BibcndNtw=;
        b=M3NZFgVphDm+ajZMYUDyVX26WA7h4u4WYyHO1bTz1bT8Y9yxWYxJ0ALgtiY8BMOzHu
         cTXcS0qjgcifdNLxA4bvUTwRkqq7ymQyhB+2w+9Zo/7/2lB+a9A3LWeF6Kb6oN8Sxiu+
         0iVm+57bnLvPF6jONopjcjlU0u/fSNAhsmTmeqOwEPHQRq/ldFd/VIvJLCozIvAdrcUN
         bzwgByidIek0miNilJ7wdeRsJgzkgoJA0+al5I8ugNbxChNMYeDF8NpvP/Yzbzfg9pLE
         hRwHwCx6KBgnOi51S3cDL1BwmWBjsbtk9+5WP+PmxJ1bi6oa3eI6UFY4E0okltHX4DFW
         odWg==
X-Forwarded-Encrypted: i=1; AJvYcCX4aLn9luiM5LZWt57nfRGtHwRqWm2nsLvWcvFiR7wPn2pdebSUAeAd/9WaBcu/YxYutxBQfUi0CQ8L2vD/@vger.kernel.org
X-Gm-Message-State: AOJu0YwQqk2r/RePpilHR7AOs1Z4/PkpriiqADGLmTzZpBdPf0JoWntI
	Gs+7GZbO3Lo+wl4ul0CIf20aDwx+mrA9BjwVMWrbBSSeoOzTZhaLsztKJ8FoFZuRnpl7Gp/fhbu
	5nfyG
X-Gm-Gg: ASbGncsdtd/fulA6Awqr9jQUuOtcHkJOMX+usqRaeuT+wymPwDZoA6J7NzwVg7PCdXx
	i/eLUR+H/uOGyK4GGEdzzxljXmE8nbi2XUptX31KBWdVWmGDp6myyPSGunLw0293xIBxs9qHR20
	7PGO3BMWOxVe0dvB3IANeZguXFMGnp1CA2LPE0Mfk8ftZb0+Yzr+LL0AL5Eo1ahToSLY6RBMjMa
	e3PgkjuYcISfWUTXt2ez1CagG2C7MMOAglH9oqn5LK03NNhz+2fs6gBaVE8/diaozsNQ/5+UASL
	uEkB1BEWUjUaNLmSYSlL7uBCMMiOOAhOwohDQCXMer178shjBoq25qDTL/mLdVVG5HUVXkP5zi5
	TRd4KI0paZpC4g5yghRm6aLUEklRBsVrdYNW/plXRVaOmBkK6FLdL07PrdqKov4D+QpCgeZ55rs
	SYZA72jtcccDSInDY0S77LFQKuzmwptkdR
X-Google-Smtp-Source: AGHT+IHFG6QmWK1KpFn85ysEfm+psI5j9KN7/n/1T01x4vQCppnzXtL7aRATTWAaGCFS+DPVbWd8+Q==
X-Received: by 2002:a17:903:1211:b0:28d:18d3:46cb with SMTP id d9443c01a7336-2986a6bf9a7mr103443295ad.20.1763288934185;
        Sun, 16 Nov 2025 02:28:54 -0800 (PST)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:22b3:6dbf:5b14:3737])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2c0fe8sm106790585ad.80.2025.11.16.02.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 02:28:53 -0800 (PST)
Date: Sun, 16 Nov 2025 18:28:49 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: David Laight <david.laight.linux@gmail.com>
Cc: akpm@linux-foundation.org, andriy.shevchenko@intel.com, axboe@kernel.dk,
	ceph-devel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
	kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com,
	xiubli@redhat.com
Subject: Re: [PATCH v5 3/6] lib/base64: rework encode/decode for speed and
 stricter validation
Message-ID: <aRmnYTHmfPi1lyix@wu-Pro-E500-G6-WS720T>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
 <20251114060132.89279-1-409411716@gms.tku.edu.tw>
 <20251114091830.5325eed3@pumpkin>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251114091830.5325eed3@pumpkin>

On Fri, Nov 14, 2025 at 09:18:30AM +0000, David Laight wrote:
> On Fri, 14 Nov 2025 14:01:32 +0800
> Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> 
> > The old base64 implementation relied on a bit-accumulator loop, which was
> > slow for larger inputs and too permissive in validation. It would accept
> > extra '=', missing '=', or even '=' appearing in the middle of the input,
> > allowing malformed strings to pass. This patch reworks the internals to
> > improve performance and enforce stricter validation.
> > 
> > Changes:
> >  - Encoder:
> >    * Process input in 3-byte blocks, mapping 24 bits into four 6-bit
> >      symbols, avoiding bit-by-bit shifting and reducing loop iterations.
> >    * Handle the final 1-2 leftover bytes explicitly and emit '=' only when
> >      requested.
> >  - Decoder:
> >    * Based on the reverse lookup tables from the previous patch, decode
> >      input in 4-character groups.
> >    * Each group is looked up directly, converted into numeric values, and
> >      combined into 3 output bytes.
> >    * Explicitly handle padded and unpadded forms:
> >       - With padding: input length must be a multiple of 4, and '=' is
> >         allowed only in the last two positions. Reject stray or early '='.
> >       - Without padding: validate tail lengths (2 or 3 chars) and require
> >         unused low bits to be zero.
> >    * Removed the bit-accumulator style loop to reduce loop iterations.
> > 
> > Performance (x86_64, Intel Core i7-10700 @ 2.90GHz, avg over 1000 runs,
> > KUnit):
> > 
> > Encode:
> >   64B   ~90ns   -> ~32ns   (~2.8x)
> >   1KB  ~1332ns  -> ~510ns  (~2.6x)
> > 
> > Decode:
> >   64B  ~1530ns  -> ~35ns   (~43.7x)
> >   1KB ~27726ns  -> ~530ns  (~52.3x)
> > 
> > Co-developed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Co-developed-by: Yu-Sheng Huang <home7438072@gmail.com>
> > Signed-off-by: Yu-Sheng Huang <home7438072@gmail.com>
> > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> 
> Reviewed-by: David Laight <david.laight.linux@gmail.com>
> 
> But see minor nit below.

Hi David,

Thanks for the review and for pointing this out.

Andrew, would it be possible for you to fold this small change 
(removing the redundant casts) directly when updating the patch?
If that’s not convenient, I can resend an updated version of the
series instead. 

Best regards,
Guan-Chun

> > ---
> >  lib/base64.c | 109 ++++++++++++++++++++++++++++++++-------------------
> >  1 file changed, 68 insertions(+), 41 deletions(-)
> > 
> > diff --git a/lib/base64.c b/lib/base64.c
> > index 9d1074bb821c..1a6d8fe37eda 100644
> > --- a/lib/base64.c
> > +++ b/lib/base64.c
> > @@ -79,28 +79,38 @@ static const s8 base64_rev_maps[][256] = {
> >  int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
> >  {
> >  	u32 ac = 0;
> > -	int bits = 0;
> > -	int i;
> >  	char *cp = dst;
> >  	const char *base64_table = base64_tables[variant];
> >  
> > -	for (i = 0; i < srclen; i++) {
> > -		ac = (ac << 8) | src[i];
> > -		bits += 8;
> > -		do {
> > -			bits -= 6;
> > -			*cp++ = base64_table[(ac >> bits) & 0x3f];
> > -		} while (bits >= 6);
> > -	}
> > -	if (bits) {
> > -		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
> > -		bits -= 6;
> > +	while (srclen >= 3) {
> > +		ac = (u32)src[0] << 16 | (u32)src[1] << 8 | (u32)src[2];
> 
> There is no need for the (u32) casts.
> All char/short values are promoted to 'int' prior to any maths.
> 
> > +		*cp++ = base64_table[ac >> 18];
> > +		*cp++ = base64_table[(ac >> 12) & 0x3f];
> > +		*cp++ = base64_table[(ac >> 6) & 0x3f];
> > +		*cp++ = base64_table[ac & 0x3f];
> > +
> > +		src += 3;
> > +		srclen -= 3;
> >  	}
> > -	if (padding) {
> > -		while (bits < 0) {
> > +
> > +	switch (srclen) {
> > +	case 2:
> > +		ac = (u32)src[0] << 16 | (u32)src[1] << 8;
> > +		*cp++ = base64_table[ac >> 18];
> > +		*cp++ = base64_table[(ac >> 12) & 0x3f];
> > +		*cp++ = base64_table[(ac >> 6) & 0x3f];
> > +		if (padding)
> > +			*cp++ = '=';
> > +		break;
> > +	case 1:
> > +		ac = (u32)src[0] << 16;
> > +		*cp++ = base64_table[ac >> 18];
> > +		*cp++ = base64_table[(ac >> 12) & 0x3f];
> > +		if (padding) {
> > +			*cp++ = '=';
> >  			*cp++ = '=';
> > -			bits += 2;
> >  		}
> > +		break;
> >  	}
> >  	return cp - dst;
> >  }
> > @@ -116,41 +126,58 @@ EXPORT_SYMBOL_GPL(base64_encode);
> >   *
> >   * Decodes a string using the selected Base64 variant.
> >   *
> > - * This implementation hasn't been optimized for performance.
> > - *
> >   * Return: the length of the resulting decoded binary data in bytes,
> >   *	   or -1 if the string isn't a valid Base64 string.
> >   */
> >  int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base64_variant variant)
> >  {
> > -	u32 ac = 0;
> > -	int bits = 0;
> > -	int i;
> >  	u8 *bp = dst;
> > -	s8 ch;
> > +	s8 input[4];
> > +	s32 val;
> > +	const u8 *s = (const u8 *)src;
> > +	const s8 *base64_rev_tables = base64_rev_maps[variant];
> >  
> > -	for (i = 0; i < srclen; i++) {
> > -		if (padding) {
> > -			if (src[i] == '=') {
> > -				ac = (ac << 6);
> > -				bits += 6;
> > -				if (bits >= 8)
> > -					bits -= 8;
> > -				continue;
> > -			}
> > -		}
> > -		ch = base64_rev_maps[variant][(u8)src[i]];
> > -		if (ch == -1)
> > -			return -1;
> > -		ac = (ac << 6) | ch;
> > -		bits += 6;
> > -		if (bits >= 8) {
> > -			bits -= 8;
> > -			*bp++ = (u8)(ac >> bits);
> > +	while (srclen >= 4) {
> > +		input[0] = base64_rev_tables[s[0]];
> > +		input[1] = base64_rev_tables[s[1]];
> > +		input[2] = base64_rev_tables[s[2]];
> > +		input[3] = base64_rev_tables[s[3]];
> > +
> > +		val = input[0] << 18 | input[1] << 12 | input[2] << 6 | input[3];
> > +
> > +		if (unlikely(val < 0)) {
> > +			if (!padding || srclen != 4 || s[3] != '=')
> > +				return -1;
> > +			padding = 0;
> > +			srclen = s[2] == '=' ? 2 : 3;
> > +			break;
> >  		}
> > +
> > +		*bp++ = val >> 16;
> > +		*bp++ = val >> 8;
> > +		*bp++ = val;
> > +
> > +		s += 4;
> > +		srclen -= 4;
> >  	}
> > -	if (ac & ((1 << bits) - 1))
> > +
> > +	if (likely(!srclen))
> > +		return bp - dst;
> > +	if (padding || srclen == 1)
> >  		return -1;
> > +
> > +	val = (base64_rev_tables[s[0]] << 12) | (base64_rev_tables[s[1]] << 6);
> > +	*bp++ = val >> 10;
> > +
> > +	if (srclen == 2) {
> > +		if (val & 0x800003ff)
> > +			return -1;
> > +	} else {
> > +		val |= base64_rev_tables[s[2]];
> > +		if (val & 0x80000003)
> > +			return -1;
> > +		*bp++ = val >> 2;
> > +	}
> >  	return bp - dst;
> >  }
> >  EXPORT_SYMBOL_GPL(base64_decode);
> 

