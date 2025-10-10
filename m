Return-Path: <linux-fscrypt+bounces-868-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 684F0BCC704
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Oct 2025 11:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7163719E6985
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Oct 2025 09:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 886732C326B;
	Fri, 10 Oct 2025 09:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YU0Ny0HD"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B15226C399
	for <linux-fscrypt@vger.kernel.org>; Fri, 10 Oct 2025 09:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760089907; cv=none; b=iPp3ISluHvNqxHUyaNI0SHc66wdHrbUpSLiH57g4RLKHLgHtcafoxVv1gk++1ukhyTCiTlakErrlvuwAiamiPyxu+CHlwAI5vt+O58IRzbApY/A1f/SZtQCn/fZD6H8yHsWrDPGX0LPA22DqKVxNBJW0F3QLCR98ABNVoAAErO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760089907; c=relaxed/simple;
	bh=0gpFLDbwtlyVkGYGGMoUWd2mlJVVmwWM/n+HgLvMV+U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BMYzFMh49B0iwTaDXUAk/CbgGqXS90zMVflOraxdvjHEKoXWWBSgdOllR8v2XQ35Y7ATWIS93H3TkQ6Luz8Tl0eRGSWpsxMMMm6pGnZs1AWzPhXyu4FPqR3IvmDFr55SXjibmrg9AS3wqrs+KtqWOWrKRVqi3Cil2tLMRaAFLPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YU0Ny0HD; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46e2c3b6d4cso13308795e9.3
        for <linux-fscrypt@vger.kernel.org>; Fri, 10 Oct 2025 02:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760089904; x=1760694704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eV0VkyvZwjNec7z9vbdRZ7vdRavcOqLYA4ozWnex1xw=;
        b=YU0Ny0HDH31cOZUgDkKteUlHTCWyIiusJtOAfkapl1o2AwMGd1reGGslLpSjwVa3Zh
         j4JZggt41K3ZroaZ4+zdSaKgRlRGqQnE6gXFsiqlhHj208ffPHToYRUlBaOiOHkizkfT
         T2HJTTdrn3LQvCPXk1A26MlM5L/SPjNrA6ivBzI0YwfFUEyQuHpb9s8KDUV8NBfOOZIc
         ZjUKpKra7YNc5TFmhwmtDHJsUiMBp9rYviraibsv1fjdMW29cDqavKIdbBwQzI+RKEPe
         Y/udO4bQCK4mTj23ZrGO9lix2gHkr6sEr4sNKW73j/+l8IW+C/Tc8TGvJzI+7EA7r2Ez
         8GWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760089904; x=1760694704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eV0VkyvZwjNec7z9vbdRZ7vdRavcOqLYA4ozWnex1xw=;
        b=A7EqsUNEiebokXykJoDDLPdxqF+OFJhe9kCMQqAkR4grXCPnKzivU4nVGYxKwHq9sb
         NojhGGA5EtMt9G1DJo3usTjvp08T3QHmQ229BpfECVM84iaHdwYH/rjzQsGEwIVTiXsO
         XZ1hWcYPtP9dL8061TaIJTcuqdGP/FUG9FSg679uo5EGRQlhzT43hPWRqGz9cmym716E
         VG8Da0wdjv76gf/MtT573cOsg/atQ83LbBBGw5hXakY/DvO/nr+QRlA/Iee3M+jbLuSS
         /6+9Nrlfx8QRuW/Xgd5rdRb0SysZ3PonyOiWHBk/ZY2wmHWlng0fKoNMEF+a5YecMuNi
         HLrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGjgLifFjEvWUdNF9E1i9aduVOJONRt8wuKYngFjV6VcwM2t2AjrMUcpZsJlFC7jaN2mpjBHmhPlF8RCjr@vger.kernel.org
X-Gm-Message-State: AOJu0YwzXcajUVRdx3R5RJ2jT9IJjGN6BvVB48DahzFpNgTBciwvhnLV
	mXFifqv9ytjdrUHp2Vk0FfDtb/4izXWfhZ8Fm4YZZZKMAFCDZ85GAKa+
X-Gm-Gg: ASbGncsuwkJOrxH5zusbxaXCNKLl+o7fe+k2rBK1e8Rrihnpkc8u5bLzG9h+ZHIQ9k1
	AyLX7hsVYUqlMoEsWDvzLKUWDd44Ya2CH8d24dZmrWHyRCE5HzZPKAFkj9OGLCAAiAJ0egO53zR
	F7B7TORj4Di+V8b3J7lvVyrhgabChk4R6iu7XCMBZ7Z19uVLqIvJVPSN41zP75uNGLMJUzJsSGK
	N6n3HQkLkbJuXsTg0KRvNN1PJmxB7Sg8nrnHiOA47nvwdghI49g9HrVkpKnniRGjE0R9DmN6uJ6
	W4SJ3gJNvY6e+qD6ueEEUoR/GnkAUg1m/VpZ2H+ZcoGGYENGVvWcRJ8JzVJSihRQaRp3hNoqGL+
	R09UzgGD093g/1dKmt5F5h02C5dGZSgn+h3Mi3fLYHS73cGsMgqwPDgqiDBVo28k90QytVlVbfu
	5519OdTNI=
X-Google-Smtp-Source: AGHT+IEA2a9V9moY9Q0X8l4fa8n2FoyS2Xm8feyo+zRRNYARtth7YTtorp1JP7E6mAtA18UXC+S7bw==
X-Received: by 2002:a05:6000:603:b0:401:41a9:524f with SMTP id ffacd0b85a97d-4266e7d452bmr7539955f8f.29.1760089903522;
        Fri, 10 Oct 2025 02:51:43 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e83e1sm3392578f8f.51.2025.10.10.02.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 02:51:43 -0700 (PDT)
Date: Fri, 10 Oct 2025 10:51:38 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
 ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
 jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with
 reverse lookup tables
Message-ID: <20251010105138.0356ad75@pumpkin>
In-Reply-To: <aOeprat4/97oSWE0@wu-Pro-E500-G6-WS720T>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
	<20250926065556.14250-1-409411716@gms.tku.edu.tw>
	<CADUfDZruZWyrsjRCs_Y5gjsbfU7dz_ALGG61pQ8qCM7K2_DjmA@mail.gmail.com>
	<aNz/+xLDnc2mKsKo@wu-Pro-E500-G6-WS720T>
	<CADUfDZq4c3dRgWpevv3+29frvd6L8G9RRdoVFpFnyRsF3Eve1Q@mail.gmail.com>
	<20251005181803.0ba6aee4@pumpkin>
	<aOTPMGQbUBfgdX4u@wu-Pro-E500-G6-WS720T>
	<CADUfDZp6TA_S72+JDJRmObJgmovPgit=-Zf+-oC+r0wUsyg9Jg@mail.gmail.com>
	<20251007192327.57f00588@pumpkin>
	<aOeprat4/97oSWE0@wu-Pro-E500-G6-WS720T>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 9 Oct 2025 20:25:17 +0800
Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

...
> As Eric mentioned, the decoder in fs/crypto/ needs to reject invalid inpu=
t.

(to avoid two different input buffers giving the same output)

Which is annoyingly reasonable.

> One possible solution I came up with is to first create a shared
> base64_rev_common lookup table as the base for all Base64 variants.
> Then, depending on the variant (e.g., BASE64_STD, BASE64_URLSAFE, etc.), =
we
> can dynamically adjust the character mappings for position 62 and positio=
n 63
> at runtime, based on the variant.
>=20
> Here are the changes to the code:
>=20
> static const s8 base64_rev_common[256] =3D {
> 	[0 ... 255] =3D -1,
> 	['A'] =3D  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12,
> 		13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
> 	['a'] =3D 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
> 		39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51,
> 	['0'] =3D 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
> };
>=20
> static const struct {
> 	char char62, char63;
> } base64_symbols[] =3D {
> 	[BASE64_STD] =3D { '+', '/' },
> 	[BASE64_URLSAFE] =3D { '-', '_' },
> 	[BASE64_IMAP] =3D { '+', ',' },
> };
>=20
> int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enu=
m base64_variant variant)
> {
> 	u8 *bp =3D dst;
> 	u8 pad_cnt =3D 0;
> 	s8 input1, input2, input3, input4;
> 	u32 val;
> 	s8 base64_rev_tables[256];
>=20
> 	/* Validate the input length for padding */
> 	if (unlikely(padding && (srclen & 0x03) !=3D 0))
> 		return -1;

There is no need for an early check.
Pick it up after the loop when 'srclen !=3D 0'.

>=20
> 	memcpy(base64_rev_tables, base64_rev_common, sizeof(base64_rev_common));

Ugg - having a memcpy() here is not a good idea.
It really is better to have 3 arrays, but use a 'mostly common' initialiser.
Perhaps:
#define BASE64_REV_INIT(ch_62, ch_63) =3D { \
	[0 ... 255] =3D -1, \
	['A'] =3D  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, \
		13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, \
	['a'] =3D 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, \
		39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, \
	['0'] =3D 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
	[ch_62] =3D 62, [ch_63] =3D 63, \
}

static const s8 base64_rev_maps[][256] =3D {
	[BASE64_STD] =3D BASE64_REV_INIT('+', '/'),
	[BASE64_URLSAFE] =3D BASE64_REV_INIT('-', '_'),
	[BASE64_IMAP] =3D BASE64_REV_INIT('+', ',')
};

Then (after validating variant):
	const s8 *map =3D base64_rev_maps[variant];

>=20
> 	if (variant < BASE64_STD || variant > BASE64_IMAP)
> 		return -1;
>=20
> 	base64_rev_tables[base64_symbols[variant].char62] =3D 62;
> 	base64_rev_tables[base64_symbols[variant].char63] =3D 63;
>=20
> 	while (padding && srclen > 0 && src[srclen - 1] =3D=3D '=3D') {
> 		pad_cnt++;
> 		srclen--;
> 		if (pad_cnt > 2)
> 			return -1;
> 	}

I'm not sure I'd to that there.
You are (in some sense) optimising for padding.
=46rom what I remember, "abcd" gives 24 bits, "abc=3D" 16 and "ab=3D=3D" 8.

>=20
> 	while (srclen >=3D 4) {
> 		/* Decode the next 4 characters */
> 		input1 =3D base64_rev_tables[(u8)src[0]];
> 		input2 =3D base64_rev_tables[(u8)src[1]];
> 		input3 =3D base64_rev_tables[(u8)src[2]];
> 		input4 =3D base64_rev_tables[(u8)src[3]];

I'd be tempted to make src[] unsigned - probably be assigning the parameter
to a local at the top of the function.

Also you have input3 =3D ... src[2]...
Perhaps they should be input[0..3] instead.

>=20
> 		val =3D (input1 << 18) |
> 		      (input2 << 12) |
> 		      (input3 << 6) |
> 		      input4;

Four lines is excessive, C doesn't require the () and I'm not sure the
compilers complain about << and |.

>=20
> 		if (unlikely((s32)val < 0))
> 			return -1;

Make 'val' signed - then you don't need the cast.
You can pick up the padding check here, something like:
			val =3D input1 << 18 | input2 << 12;
			if (!padding || val < 0 || src[3] !=3D '=3D')
				return -1;
			*bp++ =3D val >> 16;
			if (src[2] =3D=3D '=3D')
				return bp - dst;
			if (input3 < 0)
				return -1;
			val |=3D input3 << 6;
			*bp++ =3D val >> 8;
			return bp - dst;

Or, if you really want to use the code below the loop:
			if (!padding || src[3] !=3D '=3D')
				return -1;
			padding =3D 0;
			srclen -=3D 1 + (src[2] =3D=3D '=3D');
			break;


>=20
> 		*bp++ =3D (u8)(val >> 16);
> 		*bp++ =3D (u8)(val >> 8);
> 		*bp++ =3D (u8)val;

You don't need those casts.

>=20
> 		src +=3D 4;
> 		srclen -=3D 4;
> 	}
>=20
> 	/* Handle leftover characters when padding is not used */

You are coming here with padding.
I'm not sure what should happen without padding.
For a multi-line file decode I suspect the characters need adding to
the start of the next line (ie lines aren't required to contain
multiples of 4 characters - even though they almost always will).

> 	if (srclen > 0) {
> 		switch (srclen) {

You don't need an 'if' and a 'switch'.
srclen is likely to be zero, but perhaps write as:
	if (likely(!srclen))
		return bp - dst;
	if (padding || srclen =3D=3D 1)
		return -1;

	val =3D base64_rev_tables[(u8)src[0]] << 12 | base64_rev_tables[(u8)src[1]=
] << 6;
	*bp++ =3D val >> 10;
	if (srclen =3D=3D 1) {
		if (val & 0x800003ff)
			return -1;
	} else {
		val |=3D base64_rev_tables[(u8)src[2]];
		if (val & 0x80000003)
			return -1;
		*bp++ =3D val >> 2;
	}
	return bp - dst;
}

	David

> 		case 2:
> 			input1 =3D base64_rev_tables[(u8)src[0]];
> 			input2 =3D base64_rev_tables[(u8)src[1]];
> 			val =3D (input1 << 6) | input2; /* 12 bits */
> 			if (unlikely((s32)val < 0 || val & 0x0F))
> 				return -1;
>=20
> 			*bp++ =3D (u8)(val >> 4);
> 			break;
> 		case 3:
> 			input1 =3D base64_rev_tables[(u8)src[0]];
> 			input2 =3D base64_rev_tables[(u8)src[1]];
> 			input3 =3D base64_rev_tables[(u8)src[2]];
>=20
> 			val =3D (input1 << 12) |
> 			      (input2 << 6) |
> 			      input3; /* 18 bits */
> 			if (unlikely((s32)val < 0 || val & 0x03))
> 				return -1;
>=20
> 			*bp++ =3D (u8)(val >> 10);
> 			*bp++ =3D (u8)(val >> 2);
> 			break;
> 		default:
> 			return -1;
> 		}
> 	}
>=20
> 	return bp - dst;
> }
> Based on KUnit testing, the performance results are as follows:
> 	base64_performance_tests: [64B] decode run : 40ns
> 	base64_performance_tests: [1KB] decode run : 463ns
>=20
> However, this approach introduces an issue. It uses 256 bytes of memory
> on the stack for base64_rev_tables, which might not be ideal. Does anyone
> have any thoughts or alternative suggestions to solve this issue, or is it
> not really a concern?
>=20
> Best regards,
> Guan-Chun
>=20
> > >=20
> > > Best,
> > > Caleb =20
> >  =20


