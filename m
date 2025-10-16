Return-Path: <linux-fscrypt+bounces-874-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B2ADFBE2A93
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Oct 2025 12:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 37240350012
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Oct 2025 10:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE16B31AF33;
	Thu, 16 Oct 2025 10:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="2azKSV/L"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5DE31D754
	for <linux-fscrypt@vger.kernel.org>; Thu, 16 Oct 2025 10:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760609230; cv=none; b=GNamIr4e4i/Ys9EGi0k9uyogl/y4XiTG7ewp3OiDNf4Lr7mcaQtWwwF4PftPYSVw656/7icTse9diupkZws1EU2IyQCqUfnhQHf3QJWOXzmeukPtuIyxSHTW+KGxn68SP3BLHvy2852w1bV1typB+/Wxmrp1vfntelHl2J+zP+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760609230; c=relaxed/simple;
	bh=wo/Ya1/qS4gmb5ns1qZf/PbPtAozVGLxnCxAaNcd6IY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o2JqbQsnBW8kxpE2XHvsUcoNINCC3+coK3rqiDl94poVSxM2hAdVhyArhIlkJ+t36Lo1X8dN5BAXuWzYT9MOxXiZFkYmyP5/Pe191GrjnAnwlDfhXjPqTYnf2NcK2GLwU5jX+9215bkR6d9tfQi3qn4fpVJBsZHSwRAjKnrT8cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=2azKSV/L; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-27eed7bdfeeso6897275ad.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Oct 2025 03:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1760609226; x=1761214026; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rJ4V0WDk+Fmgl27pDuIUO845Eexs2tBhWb+HgzxSkGw=;
        b=2azKSV/LJlYLD9kHtl3N3D1Oej3nQerp/NmrZYimh5syH1FHulEheQKuayi9ueD06m
         4Dk/pj0GBAQOis22XCJzMtD0xL3vqHO/esdi/Wku9//Df2bOve3e7umEJRlfqdR/arVf
         7ThqDB11nGkSaZGMBmITwSJq/Dqj+8Tl14eLpXSLRHtZd7xhaxCmHIOPFZ0lzS8wQKCG
         uTMpkTwquu7YstepC1DHdk6RpQBnbTHhh5xk1zYEFfkS07L4OVx04B16FnwcC+A/6t6D
         7KOSymXghX5yasz0tuxEXsAc0f8yZzFlwIgvR9+V8bi93qSz6KIwpxJBn+lQOfEV5vt+
         R4dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760609226; x=1761214026;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rJ4V0WDk+Fmgl27pDuIUO845Eexs2tBhWb+HgzxSkGw=;
        b=AOxiYLJaauDDJnCcplqwnuOgIByK+INwjtdp4Yo/tiDt/MDZ34YDvRsB0YkrcYQdIf
         TY7OULjDSBjZ3UP3FGaFQsDXncv9H3Z/1mHAOmyolZZEFM6V9lNbumO+L5wq/NRsAFCR
         pbtPro97JHmjj9wO1han+s+8vHi+H+/oO1QATcZyZON7rLND2+xy0NC1gVRQTfHGv7pb
         cS33jbdDwyDlntzHkFzoo/xOj8QJFS1hYp5wCV8FW79ybEhxV1PfvQVg6/Zuzvmhk/XL
         LdNhRDsG4qUMNHm/uT+83U4tqId2FuWrUo59hLTv2WOghTFkhiHDdFRZQgW5Ym4oGE8v
         mfXw==
X-Forwarded-Encrypted: i=1; AJvYcCUAXglwD6r1QX0vMdUBXpJLpIhck8WwG2VY+VztOH3Fpti6r+bcnbKJC6WpWouZeNFp3PcRI0NsrNRADuUr@vger.kernel.org
X-Gm-Message-State: AOJu0YwwKZIqLI4Cyh8lW+MTT9a9VDmQ3qdVe3/TWYfs8cPyOG/cHznD
	olIwRpHdCrF/e5Df4KIFcRkp9G4YYC+aPfWJz27IIUaCOAGS19YqPRj9bPWM+3WtOaQ=
X-Gm-Gg: ASbGncs+XZPytleaMR4dKa9yh4Oz+NJz8PbcMHUQxAsiJRoPk0Ge6z5a5BCwRGM8pAe
	+lt5Bk6B4YHgyCdQiRm4KsD/NEr/NMwJHOBx/ZE7sK4Bu4hcFERTNpfWJoPJpz5WxNw5DMwurfy
	aaHPrHtlP5LYbYkb7IPCFTTWHEC0U5q81MtotztbhcyWsnlTi9Vz056CR9h721UJsvfmgcwxyiO
	lKLzgsLRupJ5Zk8LksDYorhN76RsGCGN+23TbN0q31USsZn9qj1k82IV3eDeO8bJgwKr6csSRYo
	HLQuvuE3x5/mU/32tC/ihQOsVFZZZ4aBu5o3OtlYqSjBzvydcjTbP0Ftchty6pHGN6U+ePvMN5M
	PfdOEf0umDDR396SSRrGI0gj9ejUz6smeBwkeQi2iRQo6Pwk5eeiuZRbIOT1zz4xMK5xNEEo2m4
	BN5kEPQ1MyNQCMKp/kGdvO
X-Google-Smtp-Source: AGHT+IGke+4JqtDfjsb4VQIaIJ/VTkox7Sn1ZBEWyV9e2LxX0qBRZQ/9OBuguQWM1BsPb4D7ktTbDQ==
X-Received: by 2002:a17:903:41c6:b0:24c:db7c:bc34 with SMTP id d9443c01a7336-29091b02a61mr44434505ad.13.1760609225745;
        Thu, 16 Oct 2025 03:07:05 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:9edb:1072:a6d:3ebf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099a7c255sm24626915ad.70.2025.10.16.03.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 03:07:05 -0700 (PDT)
Date: Thu, 16 Oct 2025 18:07:00 +0800
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
Message-ID: <aPDDxEGon1Q82pIJ@wu-Pro-E500-G6-WS720T>
References: <aNz/+xLDnc2mKsKo@wu-Pro-E500-G6-WS720T>
 <CADUfDZq4c3dRgWpevv3+29frvd6L8G9RRdoVFpFnyRsF3Eve1Q@mail.gmail.com>
 <20251005181803.0ba6aee4@pumpkin>
 <aOTPMGQbUBfgdX4u@wu-Pro-E500-G6-WS720T>
 <CADUfDZp6TA_S72+JDJRmObJgmovPgit=-Zf+-oC+r0wUsyg9Jg@mail.gmail.com>
 <20251007192327.57f00588@pumpkin>
 <aOeprat4/97oSWE0@wu-Pro-E500-G6-WS720T>
 <20251010105138.0356ad75@pumpkin>
 <aOzLQ2KSqGn1eYrm@wu-Pro-E500-G6-WS720T>
 <20251014091420.173dfc9c@pumpkin>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014091420.173dfc9c@pumpkin>

On Tue, Oct 14, 2025 at 09:14:20AM +0100, David Laight wrote:
> On Mon, 13 Oct 2025 17:49:55 +0800
> Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> 
> > On Fri, Oct 10, 2025 at 10:51:38AM +0100, David Laight wrote:
> > > On Thu, 9 Oct 2025 20:25:17 +0800
> > > Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> > > 
> > > ...  
> > > > As Eric mentioned, the decoder in fs/crypto/ needs to reject invalid input.  
> > > 
> > > (to avoid two different input buffers giving the same output)
> > > 
> > > Which is annoyingly reasonable.
> > >   
> > > > One possible solution I came up with is to first create a shared
> > > > base64_rev_common lookup table as the base for all Base64 variants.
> > > > Then, depending on the variant (e.g., BASE64_STD, BASE64_URLSAFE, etc.), we
> > > > can dynamically adjust the character mappings for position 62 and position 63
> > > > at runtime, based on the variant.
> > > > 
> > > > Here are the changes to the code:
> > > > 
> > > > static const s8 base64_rev_common[256] = {
> > > > 	[0 ... 255] = -1,
> > > > 	['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12,
> > > > 		13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
> > > > 	['a'] = 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
> > > > 		39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51,
> > > > 	['0'] = 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
> > > > };
> > > > 
> > > > static const struct {
> > > > 	char char62, char63;
> > > > } base64_symbols[] = {
> > > > 	[BASE64_STD] = { '+', '/' },
> > > > 	[BASE64_URLSAFE] = { '-', '_' },
> > > > 	[BASE64_IMAP] = { '+', ',' },
> > > > };
> > > > 
> > > > int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base64_variant variant)
> > > > {
> > > > 	u8 *bp = dst;
> > > > 	u8 pad_cnt = 0;
> > > > 	s8 input1, input2, input3, input4;
> > > > 	u32 val;
> > > > 	s8 base64_rev_tables[256];
> > > > 
> > > > 	/* Validate the input length for padding */
> > > > 	if (unlikely(padding && (srclen & 0x03) != 0))
> > > > 		return -1;  
> > > 
> > > There is no need for an early check.
> > > Pick it up after the loop when 'srclen != 0'.
> > >  
> > 
> > I think the early check is still needed, since I'm removing the
> > padding '=' first.
> > This makes the handling logic consistent for both padded and unpadded
> > inputs, and avoids extra if conditions for padding inside the hot loop.
> 
> The 'invalid input' check will detect the padding.
> Then you don't get an extra check if there is no padding (probably normal).
> I realised I didn't get it quite right - updated below.
> 
> > 
> > > > 
> > > > 	memcpy(base64_rev_tables, base64_rev_common, sizeof(base64_rev_common));  
> > > 
> > > Ugg - having a memcpy() here is not a good idea.
> > > It really is better to have 3 arrays, but use a 'mostly common' initialiser.
> > > Perhaps:
> > > #define BASE64_REV_INIT(ch_62, ch_63) = { \
> > > 	[0 ... 255] = -1, \
> > > 	['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, \
> > > 		13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, \
> > > 	['a'] = 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, \
> > > 		39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, \
> > > 	['0'] = 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
> > > 	[ch_62] = 62, [ch_63] = 63, \
> > > }
> > > 
> > > static const s8 base64_rev_maps[][256] = {
> > > 	[BASE64_STD] = BASE64_REV_INIT('+', '/'),
> > > 	[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),
> > > 	[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
> > > };
> > > 
> > > Then (after validating variant):
> > > 	const s8 *map = base64_rev_maps[variant];
> > >  
> > 
> > Got it. I'll switch to using three static tables with a common initializer
> > as you suggested.
> > 
> > > > 
> > > > 	if (variant < BASE64_STD || variant > BASE64_IMAP)
> > > > 		return -1;
> > > > 
> > > > 	base64_rev_tables[base64_symbols[variant].char62] = 62;
> > > > 	base64_rev_tables[base64_symbols[variant].char63] = 63;
> > > > 
> > > > 	while (padding && srclen > 0 && src[srclen - 1] == '=') {
> > > > 		pad_cnt++;
> > > > 		srclen--;
> > > > 		if (pad_cnt > 2)
> > > > 			return -1;
> > > > 	}  
> > > 
> > > I'm not sure I'd to that there.
> > > You are (in some sense) optimising for padding.
> > > From what I remember, "abcd" gives 24 bits, "abc=" 16 and "ab==" 8.
> > >   
> > > > 
> > > > 	while (srclen >= 4) {
> > > > 		/* Decode the next 4 characters */
> > > > 		input1 = base64_rev_tables[(u8)src[0]];
> > > > 		input2 = base64_rev_tables[(u8)src[1]];
> > > > 		input3 = base64_rev_tables[(u8)src[2]];
> > > > 		input4 = base64_rev_tables[(u8)src[3]];  
> > > 
> > > I'd be tempted to make src[] unsigned - probably be assigning the parameter
> > > to a local at the top of the function.
> > > 
> > > Also you have input3 = ... src[2]...
> > > Perhaps they should be input[0..3] instead.
> > >  
> > 
> > OK, I'll make the changes.
> > 
> > > > 
> > > > 		val = (input1 << 18) |
> > > > 		      (input2 << 12) |
> > > > 		      (input3 << 6) |
> > > > 		      input4;  
> > > 
> > > Four lines is excessive, C doesn't require the () and I'm not sure the
> > > compilers complain about << and |.
> > >   
> > 
> > OK, I'll make the changes.
> > 
> > > > 
> > > > 		if (unlikely((s32)val < 0))
> > > > 			return -1;  
> > > 
> > > Make 'val' signed - then you don't need the cast.
> ...
> > > Or, if you really want to use the code below the loop:
> > > 			if (!padding || src[3] != '=')
> > > 				return -1;
> > > 			padding = 0;
> > > 			srclen -= 1 + (src[2] == '=');
> > > 			break;
> 
> That is missing a test...
> Change to:
> 			if (!padding || srclen != 4 || src[3] != '=')
> 				return -1;
> 			padding = 0;
> 			srclen = src[2] == '=' ? 2 : 3;
> 			break;
> 
> The compiler will then optimise away the first checks after the
> loop because it knows they can't happen.
> 
> > > 
> > >   
> > > > 
> > > > 		*bp++ = (u8)(val >> 16);
> > > > 		*bp++ = (u8)(val >> 8);
> > > > 		*bp++ = (u8)val;  
> > > 
> > > You don't need those casts.
> > >  
> > 
> > OK, I'll make the changes.
> > 
> > > > 
> > > > 		src += 4;
> > > > 		srclen -= 4;
> > > > 	}
> > > > 
> > > > 	/* Handle leftover characters when padding is not used */  
> > > 
> > > You are coming here with padding.
> > > I'm not sure what should happen without padding.
> > > For a multi-line file decode I suspect the characters need adding to
> > > the start of the next line (ie lines aren't required to contain
> > > multiples of 4 characters - even though they almost always will).
> > >   
> > 
> > Ah, my mistake. I forgot to remove that comment.
> > Based on my observation, base64_decode() should process the entire input
> > buffer in a single call, so I believe it does not need to handle
> > multi-line input.
> 
> I was thinking of the the case where it is processing the output of
> something like base64encode.
> The caller will have separated out the lines, but I don't know whether
> every line has to contain a multiple of 4 characters - or whether the
> lines can be arbitrarily split after being encoded (I know that won't
> normally happen - but you never know). 
>

I believe the splitting should be aligned to multiples of 4,
since Base64 encoding operates on 4-character blocks that represent 3 bytes
of data.
If it's split arbitrarily, the decoded result may differ from the original
data or even become invalid.

Best regards,
Guan-Chun

> > 
> > Best regards,
> > Guan-Chun
> > 
> > > > 	if (srclen > 0) {
> > > > 		switch (srclen) {  
> > > 
> > > You don't need an 'if' and a 'switch'.
> > > srclen is likely to be zero, but perhaps write as:
> > > 	if (likely(!srclen))
> > > 		return bp - dst;
> > > 	if (padding || srclen == 1)
> > > 		return -1;
> > > 
> > > 	val = base64_rev_tables[(u8)src[0]] << 12 | base64_rev_tables[(u8)src[1]] << 6;
> > > 	*bp++ = val >> 10;
> > > 	if (srclen == 1) {
> Obviously should be (srclen == 2)
> > > 		if (val & 0x800003ff)
> > > 			return -1;
> > > 	} else {
> > > 		val |= base64_rev_tables[(u8)src[2]];
> > > 		if (val & 0x80000003)
> > > 			return -1;
> > > 		*bp++ = val >> 2;
> > > 	}
> > > 	return bp - dst;
> > > }
> > > 
> > > 	David
> 
> 	David
> 
> > >   
> > > > 		case 2:
> > > > 			input1 = base64_rev_tables[(u8)src[0]];
> > > > 			input2 = base64_rev_tables[(u8)src[1]];
> > > > 			val = (input1 << 6) | input2; /* 12 bits */
> > > > 			if (unlikely((s32)val < 0 || val & 0x0F))
> > > > 				return -1;
> > > > 
> > > > 			*bp++ = (u8)(val >> 4);
> > > > 			break;
> > > > 		case 3:
> > > > 			input1 = base64_rev_tables[(u8)src[0]];
> > > > 			input2 = base64_rev_tables[(u8)src[1]];
> > > > 			input3 = base64_rev_tables[(u8)src[2]];
> > > > 
> > > > 			val = (input1 << 12) |
> > > > 			      (input2 << 6) |
> > > > 			      input3; /* 18 bits */
> > > > 			if (unlikely((s32)val < 0 || val & 0x03))
> > > > 				return -1;
> > > > 
> > > > 			*bp++ = (u8)(val >> 10);
> > > > 			*bp++ = (u8)(val >> 2);
> > > > 			break;
> > > > 		default:
> > > > 			return -1;
> > > > 		}
> > > > 	}
> > > > 
> > > > 	return bp - dst;
> > > > }
> > > > Based on KUnit testing, the performance results are as follows:
> > > > 	base64_performance_tests: [64B] decode run : 40ns
> > > > 	base64_performance_tests: [1KB] decode run : 463ns
> > > > 
> > > > However, this approach introduces an issue. It uses 256 bytes of memory
> > > > on the stack for base64_rev_tables, which might not be ideal. Does anyone
> > > > have any thoughts or alternative suggestions to solve this issue, or is it
> > > > not really a concern?
> > > > 
> > > > Best regards,
> > > > Guan-Chun
> > > >   
> > > > > > 
> > > > > > Best,
> > > > > > Caleb    
> > > > >     
> > >   
> 

