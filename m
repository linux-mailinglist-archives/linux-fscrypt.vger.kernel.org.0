Return-Path: <linux-fscrypt+bounces-871-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 20BEFBD25FA
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Oct 2025 11:51:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 69F2534A06D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Oct 2025 09:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7768D2FE049;
	Mon, 13 Oct 2025 09:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="l3vhrcEO"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C481A3154
	for <linux-fscrypt@vger.kernel.org>; Mon, 13 Oct 2025 09:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760349007; cv=none; b=fIy7iFEnQ6hTMEUv8SgQBeBslLvhC57Ut2GXnknaSS9Ay+kxkl9+KftuisLrpG9fuOrL0eBCaBmnWrdTivGjazZihhvEzBFT66FngaM7p0iN84NKBp/7xJdQDJt78GQsCfRnq9TIBa5MwcaeZNRzU5pHgwFP26bZzYNaV5xfjrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760349007; c=relaxed/simple;
	bh=BAnwDZOovV8WGEHznvS0ASUsl81ftZ3UHqcj056/iWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cwev6ABLvrjNjYZ0QRHgnJ4W9+tFmNC4YlvUaWSbbOkOy4VNXANXqIwHbhX/umZoCHCLQfMBZgZZm0RrFKWSiTUWf+4uwmTQycKrVNTX6pMjEJjeaichwNlUH2wkrWzDinW7TXC8nBWdZ1vJK0U1R/il1iW4kqrwoaKk9GJJMGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=l3vhrcEO; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b679450ecb6so1763370a12.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 13 Oct 2025 02:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1760349003; x=1760953803; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bp51fhwIp2TxChiApwV+E+DXmQ/uPeFWu0ZwqX85B3w=;
        b=l3vhrcEOa++eozTx3XRR/r6yWBqLpeicG9EnXayMJUGW24c7j3XmsP1xcyQ4AnPgUz
         x9InSweMCR49LENaGfJ73g7IuvBm66NnLY/WSL93rY90oHdcoDeI9RsjKwPYEvt5DwBb
         tMFMfQnpw+9VWAPTWx7JHRK+tG/FOycvBgXA5m7OHKc6sK3NaGZM02tAyLXF6/Wv505d
         HgOWeo7HLE2j/PwkFQauEcSmnScd+LbM5XbMMDpvJTJKRsBp8Y/s74gYMjHZTeD5zShc
         K3nMXTmLlgLMem4khXKAvCgHlfqWZvPWMN+kPydVzAwUMW4Blhs/NthIeOYyqZe79PiN
         CAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760349003; x=1760953803;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bp51fhwIp2TxChiApwV+E+DXmQ/uPeFWu0ZwqX85B3w=;
        b=FHAqOglrZgqpG+/WesT2EKCgusxucK2MBtmLuFNxNen1bZBTD54kT0tfmCe4saTOAr
         7rbQWIdQZW++By/dWFTWL+x/QM6CyZ2vGX9urBnP5GB+OD1YkDYUizO3Csb1UXKjmffw
         BjkT5AQNe5sEfYzWIcnYRAKdk17kj1zueZ7sjKIE5f1OlopvMML6Xg5c+vW9DUhTg/gz
         4xmt6D1g91NThCEOgzrjKGfd+qeg4cnBnlKXCfl+xfeY8zANgBBj/6y89AANAFY1sxg2
         eqcSYyzBYazWEHfWCDVG3a4XgSRy/ZR8ENtWcmO9eK+faword3wTRFFlV/5+BEiJuC2C
         d7sg==
X-Forwarded-Encrypted: i=1; AJvYcCUEUgfBQN0TdmTqKMrwZuMNuiA6TD3vJY9tkQdd150EdfsjzaCSle4tppmMueQTWpm+GpWvlQ/XP5B2SPG2@vger.kernel.org
X-Gm-Message-State: AOJu0YzYhocbM7KwuIKWDm2UhTXryMytxU9MV6fOULpcE2wMN6ggEA/M
	uWa3bLJTxY1dh2CricLTAumkxFfpADhX6WZU+iqIz2xnGwLyCWGtlEF2PXw5oxXtOW0=
X-Gm-Gg: ASbGncsQCe9OFfgbx62Dzj3QsJkjPKh5yiQHkYPQi9wtDFA9hB5ZtB+hFd9UlXPBKGe
	0VZc/HMFCN8PhZxJb/h8whYhbDurmEt/RQgR841o+Or6hn6vZeSyq+Bn3IFPhUHFuTDkBohaQMc
	sqYmKTS+mQvhpovApMGmRFTMynagcf5ealbmqE5oju1QnLTRbMt0C/8jrPdiYjVyEkbTVy7lSCL
	/lGyoN1nK5VtwOJvv89e1hdmwjHEflyB1GfTdWOMTZro0chSK65+a2HDsFvw7OhJVoviRf+6tXY
	FN50hOuG/aQdwjQQ91BcR0BhqVNT8lHjxmhzmnKUdCk+0oio6PbHtv4x43T6wyjIuX7ERDnGYlx
	LeTS6uQ4O4GUhY/skRm5kaExbXG+GatW5CDWEtQek9weTrVUs+gOf01jpI1fM03n0HaW9jfgbNA
	==
X-Google-Smtp-Source: AGHT+IG1JzQQHQjMT21Ythm1gXAqTXhkL84Z5ZHyVJBm9N9Dh0WoFdsAzPwZjCutcgln/HrN3DWkBQ==
X-Received: by 2002:a17:902:f60d:b0:26a:b9b4:8342 with SMTP id d9443c01a7336-2902726259dmr238303985ad.25.1760349003313;
        Mon, 13 Oct 2025 02:50:03 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:b0a8:f639:5bec:40e9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f06c82sm129052355ad.81.2025.10.13.02.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 02:50:02 -0700 (PDT)
Date: Mon, 13 Oct 2025 17:49:55 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: David Laight <david.laight.linux@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	akpm@linux-foundation.org, axboe@kernel.dk,
	ceph-devel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
	kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com,
	xiubli@redhat.com
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with reverse
 lookup tables
Message-ID: <aOzLQ2KSqGn1eYrm@wu-Pro-E500-G6-WS720T>
References: <20250926065556.14250-1-409411716@gms.tku.edu.tw>
 <CADUfDZruZWyrsjRCs_Y5gjsbfU7dz_ALGG61pQ8qCM7K2_DjmA@mail.gmail.com>
 <aNz/+xLDnc2mKsKo@wu-Pro-E500-G6-WS720T>
 <CADUfDZq4c3dRgWpevv3+29frvd6L8G9RRdoVFpFnyRsF3Eve1Q@mail.gmail.com>
 <20251005181803.0ba6aee4@pumpkin>
 <aOTPMGQbUBfgdX4u@wu-Pro-E500-G6-WS720T>
 <CADUfDZp6TA_S72+JDJRmObJgmovPgit=-Zf+-oC+r0wUsyg9Jg@mail.gmail.com>
 <20251007192327.57f00588@pumpkin>
 <aOeprat4/97oSWE0@wu-Pro-E500-G6-WS720T>
 <20251010105138.0356ad75@pumpkin>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010105138.0356ad75@pumpkin>

On Fri, Oct 10, 2025 at 10:51:38AM +0100, David Laight wrote:
> On Thu, 9 Oct 2025 20:25:17 +0800
> Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> 
> ...
> > As Eric mentioned, the decoder in fs/crypto/ needs to reject invalid input.
> 
> (to avoid two different input buffers giving the same output)
> 
> Which is annoyingly reasonable.
> 
> > One possible solution I came up with is to first create a shared
> > base64_rev_common lookup table as the base for all Base64 variants.
> > Then, depending on the variant (e.g., BASE64_STD, BASE64_URLSAFE, etc.), we
> > can dynamically adjust the character mappings for position 62 and position 63
> > at runtime, based on the variant.
> > 
> > Here are the changes to the code:
> > 
> > static const s8 base64_rev_common[256] = {
> > 	[0 ... 255] = -1,
> > 	['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12,
> > 		13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
> > 	['a'] = 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
> > 		39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51,
> > 	['0'] = 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
> > };
> > 
> > static const struct {
> > 	char char62, char63;
> > } base64_symbols[] = {
> > 	[BASE64_STD] = { '+', '/' },
> > 	[BASE64_URLSAFE] = { '-', '_' },
> > 	[BASE64_IMAP] = { '+', ',' },
> > };
> > 
> > int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base64_variant variant)
> > {
> > 	u8 *bp = dst;
> > 	u8 pad_cnt = 0;
> > 	s8 input1, input2, input3, input4;
> > 	u32 val;
> > 	s8 base64_rev_tables[256];
> > 
> > 	/* Validate the input length for padding */
> > 	if (unlikely(padding && (srclen & 0x03) != 0))
> > 		return -1;
> 
> There is no need for an early check.
> Pick it up after the loop when 'srclen != 0'.
>

I think the early check is still needed, since I'm removing the
padding '=' first.
This makes the handling logic consistent for both padded and unpadded
inputs, and avoids extra if conditions for padding inside the hot loop.

> > 
> > 	memcpy(base64_rev_tables, base64_rev_common, sizeof(base64_rev_common));
> 
> Ugg - having a memcpy() here is not a good idea.
> It really is better to have 3 arrays, but use a 'mostly common' initialiser.
> Perhaps:
> #define BASE64_REV_INIT(ch_62, ch_63) = { \
> 	[0 ... 255] = -1, \
> 	['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, \
> 		13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, \
> 	['a'] = 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, \
> 		39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, \
> 	['0'] = 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
> 	[ch_62] = 62, [ch_63] = 63, \
> }
> 
> static const s8 base64_rev_maps[][256] = {
> 	[BASE64_STD] = BASE64_REV_INIT('+', '/'),
> 	[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),
> 	[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
> };
> 
> Then (after validating variant):
> 	const s8 *map = base64_rev_maps[variant];
>

Got it. I'll switch to using three static tables with a common initializer
as you suggested.

> > 
> > 	if (variant < BASE64_STD || variant > BASE64_IMAP)
> > 		return -1;
> > 
> > 	base64_rev_tables[base64_symbols[variant].char62] = 62;
> > 	base64_rev_tables[base64_symbols[variant].char63] = 63;
> > 
> > 	while (padding && srclen > 0 && src[srclen - 1] == '=') {
> > 		pad_cnt++;
> > 		srclen--;
> > 		if (pad_cnt > 2)
> > 			return -1;
> > 	}
> 
> I'm not sure I'd to that there.
> You are (in some sense) optimising for padding.
> From what I remember, "abcd" gives 24 bits, "abc=" 16 and "ab==" 8.
> 
> > 
> > 	while (srclen >= 4) {
> > 		/* Decode the next 4 characters */
> > 		input1 = base64_rev_tables[(u8)src[0]];
> > 		input2 = base64_rev_tables[(u8)src[1]];
> > 		input3 = base64_rev_tables[(u8)src[2]];
> > 		input4 = base64_rev_tables[(u8)src[3]];
> 
> I'd be tempted to make src[] unsigned - probably be assigning the parameter
> to a local at the top of the function.
> 
> Also you have input3 = ... src[2]...
> Perhaps they should be input[0..3] instead.
>

OK, I'll make the changes.

> > 
> > 		val = (input1 << 18) |
> > 		      (input2 << 12) |
> > 		      (input3 << 6) |
> > 		      input4;
> 
> Four lines is excessive, C doesn't require the () and I'm not sure the
> compilers complain about << and |.
> 

OK, I'll make the changes.

> > 
> > 		if (unlikely((s32)val < 0))
> > 			return -1;
> 
> Make 'val' signed - then you don't need the cast.
> You can pick up the padding check here, something like:
> 			val = input1 << 18 | input2 << 12;
> 			if (!padding || val < 0 || src[3] != '=')
> 				return -1;
> 			*bp++ = val >> 16;
> 			if (src[2] == '=')
> 				return bp - dst;
> 			if (input3 < 0)
> 				return -1;
> 			val |= input3 << 6;
> 			*bp++ = val >> 8;
> 			return bp - dst;
> 
> Or, if you really want to use the code below the loop:
> 			if (!padding || src[3] != '=')
> 				return -1;
> 			padding = 0;
> 			srclen -= 1 + (src[2] == '=');
> 			break;
> 
> 
> > 
> > 		*bp++ = (u8)(val >> 16);
> > 		*bp++ = (u8)(val >> 8);
> > 		*bp++ = (u8)val;
> 
> You don't need those casts.
>

OK, I'll make the changes.

> > 
> > 		src += 4;
> > 		srclen -= 4;
> > 	}
> > 
> > 	/* Handle leftover characters when padding is not used */
> 
> You are coming here with padding.
> I'm not sure what should happen without padding.
> For a multi-line file decode I suspect the characters need adding to
> the start of the next line (ie lines aren't required to contain
> multiples of 4 characters - even though they almost always will).
> 

Ah, my mistake. I forgot to remove that comment.
Based on my observation, base64_decode() should process the entire input
buffer in a single call, so I believe it does not need to handle
multi-line input.

Best regards,
Guan-Chun

> > 	if (srclen > 0) {
> > 		switch (srclen) {
> 
> You don't need an 'if' and a 'switch'.
> srclen is likely to be zero, but perhaps write as:
> 	if (likely(!srclen))
> 		return bp - dst;
> 	if (padding || srclen == 1)
> 		return -1;
> 
> 	val = base64_rev_tables[(u8)src[0]] << 12 | base64_rev_tables[(u8)src[1]] << 6;
> 	*bp++ = val >> 10;
> 	if (srclen == 1) {
> 		if (val & 0x800003ff)
> 			return -1;
> 	} else {
> 		val |= base64_rev_tables[(u8)src[2]];
> 		if (val & 0x80000003)
> 			return -1;
> 		*bp++ = val >> 2;
> 	}
> 	return bp - dst;
> }
> 
> 	David
> 
> > 		case 2:
> > 			input1 = base64_rev_tables[(u8)src[0]];
> > 			input2 = base64_rev_tables[(u8)src[1]];
> > 			val = (input1 << 6) | input2; /* 12 bits */
> > 			if (unlikely((s32)val < 0 || val & 0x0F))
> > 				return -1;
> > 
> > 			*bp++ = (u8)(val >> 4);
> > 			break;
> > 		case 3:
> > 			input1 = base64_rev_tables[(u8)src[0]];
> > 			input2 = base64_rev_tables[(u8)src[1]];
> > 			input3 = base64_rev_tables[(u8)src[2]];
> > 
> > 			val = (input1 << 12) |
> > 			      (input2 << 6) |
> > 			      input3; /* 18 bits */
> > 			if (unlikely((s32)val < 0 || val & 0x03))
> > 				return -1;
> > 
> > 			*bp++ = (u8)(val >> 10);
> > 			*bp++ = (u8)(val >> 2);
> > 			break;
> > 		default:
> > 			return -1;
> > 		}
> > 	}
> > 
> > 	return bp - dst;
> > }
> > Based on KUnit testing, the performance results are as follows:
> > 	base64_performance_tests: [64B] decode run : 40ns
> > 	base64_performance_tests: [1KB] decode run : 463ns
> > 
> > However, this approach introduces an issue. It uses 256 bytes of memory
> > on the stack for base64_rev_tables, which might not be ideal. Does anyone
> > have any thoughts or alternative suggestions to solve this issue, or is it
> > not really a concern?
> > 
> > Best regards,
> > Guan-Chun
> > 
> > > > 
> > > > Best,
> > > > Caleb  
> > >   
> 

