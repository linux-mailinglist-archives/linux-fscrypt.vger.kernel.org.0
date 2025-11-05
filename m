Return-Path: <linux-fscrypt+bounces-918-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CD81C34F7D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 05 Nov 2025 10:51:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5A2A74FC9A6
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Nov 2025 09:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8808B3081A0;
	Wed,  5 Nov 2025 09:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eu9KieHv"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23262D6614
	for <linux-fscrypt@vger.kernel.org>; Wed,  5 Nov 2025 09:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762336114; cv=none; b=B1nS4/WSO5Fm420g5+vKWj0a7T0X9LAiGi/mB4xUKj2KNiPnxfkPXdjcheP41/p3bvAWv2Ic6b5JX0Y4lf+PIOJAqLeuolHqo2JtT5xJ63kry1Xvzty9xz9/qfArnzx4dSuBUpuUVeI0caOEYZbbzSdMU3Zz3iKXY6c43KgIXII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762336114; c=relaxed/simple;
	bh=WpbqLe6mspDexwSEWOmQtR2K4XKM/1s8lyFPl9hxm1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mPFqaLuRtaCk8s6sSbfR3Dpq/O9Cfp6Hv7/Oqilp0aNOWj5TBYEDPlS7uOs+bWT/fffdBdgRL8TWw87D5tFPiF2aV6xt2lhXOxx9eZiyuUDG+M4C1uxrPYsvBKH4FR7fknPjsosOJPLgIXOL3w1y/U9Ra7+TvfL+sX9r7jmYqb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eu9KieHv; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47118259fd8so47368465e9.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 05 Nov 2025 01:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762336111; x=1762940911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/eC1//SZtzXCJ9VDP38XGpX45I3TMA2WSmv1Cg2gDD4=;
        b=eu9KieHvQh2LWbiGCDvcFKC0+MN5LeKK52xOuS/N0C/zt6MAsxE5Yx+yKtKo4T3a8f
         y1qyCo/t28c/udWVXEoXXOuALau7vQQVbuOe9KY4w5BTK7fuPwdVcmDd2YqkA0XwRKl9
         1ju7wzLBP3RrN7SsG1Wu9e/adcYgbpkj4bNzEcU3tHTSPzYUPxUdClTEV+2gnPH5Tv3f
         pldpPeHkSB9CLbU+36p4w7MqZlGXjQ0MUuPtiWvfK5Sp4Ru/iRl6WPzncDmWDMGEvVa/
         ZLM6AgtlybWal1iBSbEiVJ2Z0kD0gZ/Kb8O8eHGDbwLIH0lPKZgwe0GLtkVvfZt8jwp3
         7iNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762336111; x=1762940911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/eC1//SZtzXCJ9VDP38XGpX45I3TMA2WSmv1Cg2gDD4=;
        b=BWig//nAEi4ecRRK4VikN+C1e2ndcOEWeldx2c5sMW0Bvc6ZN/R8ECoFc8twpu3DY3
         zFcOT+SO7QUMeaOMbDctzuieqdEfuSzpmeF2FX1RNM/Xh/CweXBMBkZvVpHsmIvQUTG3
         0Y2TAjSKmPosmZH129ahG30KBieWuo/sODpI/CU8k/dwxF7ruOUANlnt66pn5f5PW4mT
         3ibvJM9ZnImujh+CYQ5ugKihskk0KJDTIycsXtmFYkiedZvkl36jwteGsoIktSw8nbH1
         uzR7rXv7Yq1UAS4WkfnepBsKXfj3tX6D2abMMlEGzaOiU2ZSTAEe1PiFoVG5U3C6cZP8
         ASLg==
X-Forwarded-Encrypted: i=1; AJvYcCWn+TuUxoMl470wwmXnxSGZ6vkoVNmn9PbxXHK0z0ntUAanwPel1YiiDscjlWF1ySTD+BUhYd9qdIS5atBB@vger.kernel.org
X-Gm-Message-State: AOJu0YyTSbWqy4cYBmeeXKnAyghFowKQ3JpsW7Jwv4uD3VuKWzg3O4pr
	QMFj5dGLaqfMZWk4pxFh+RCi0RS0ZR3O18CifmuGqq4E+JXmI6CnjOgf
X-Gm-Gg: ASbGncsPt/JTOL50qBvJE6wkq6IHIzDqvUHQjwx1iKy5tzC8ailRpKV7fM/eg5nrfqN
	kkBfWOMHB9b9Ts1iq8+jKaz26U0b+KheYvqfUA0FC39F2ZyrMFNaZVjHH8zH2B+35RdkKaMuz2H
	/9E0vV2qsa1CmVxf408OH4KXWip6tV46rKw/8rLV6VUSAkXjKx/4kHDpuKPCdehL3XN+0MeZayU
	MBJksaZLPfVIBrz2Hc54kQoRiK3hRMtpKJy/ZDH/j3yM3FLq95lbbZ9WZpyDPdZtdqQTnLy+b7u
	1u40hgju+j/ZaHwdR/EpCwtZ3g3iIrO3dJt0mslx/ND2tM0de5QP+782xLELMGjQAZdoSujCisU
	uw2HpmEUo27LD9cJdJqzg/Z+mVNm4y+RwRL9GbJaclNJmXAyaxUtFy8StjfCBCsWWZOl/UFtxy/
	HDhAsisJqP/JmhJCHX/jfrBsbglT/XjkvRi0NdKhBGdg==
X-Google-Smtp-Source: AGHT+IEkpFxLVpMLxH+nTe91ZvHCIlFgTDwSuHknsPOjs1KqbNBabtxkQXZcHtDrGMnxK6gDuS+BvQ==
X-Received: by 2002:a05:600c:34d0:b0:471:6f4:601f with SMTP id 5b1f17b1804b1-4775cdf54aemr21466965e9.19.1762336110467;
        Wed, 05 Nov 2025 01:48:30 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775cdee965sm38069125e9.17.2025.11.05.01.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 01:48:29 -0800 (PST)
Date: Wed, 5 Nov 2025 09:48:27 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>, Guan-Chun Wu
 <409411716@gms.tku.edu.tw>, Andrew Morton <akpm@linux-foundation.org>,
 ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org, xiubli@redhat.com,
 idryomov@gmail.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 sagi@grimberg.me, home7438072@gmail.com, linux-nvme@lists.infradead.org,
 linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate
 users
Message-ID: <20251105094827.10e67b2d@pumpkin>
In-Reply-To: <aQnMCVYFNpdsd-mm@smile.fi.intel.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
	<20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
	<aQiC4zrtXobieAUm@black.igk.intel.com>
	<aQiM7OWWM0dXTT0J@google.com>
	<20251104090326.2040fa75@pumpkin>
	<aQnMCVYFNpdsd-mm@smile.fi.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 4 Nov 2025 11:48:57 +0200
Andy Shevchenko <andriy.shevchenko@intel.com> wrote:

> On Tue, Nov 04, 2025 at 09:03:26AM +0000, David Laight wrote:
> > On Mon, 3 Nov 2025 19:07:24 +0800
> > Kuan-Wei Chiu <visitorckw@gmail.com> wrote:  
> > > On Mon, Nov 03, 2025 at 11:24:35AM +0100, Andy Shevchenko wrote:  
> 
> ...
> 
> > > Since I believe many people test and care about W=1 builds, I think we
> > > need to find another way to avoid this warning? Perhaps we could
> > > consider what you suggested:
> > > 
> > > #define BASE64_REV_INIT(val_plus, val_comma, val_minus, val_slash, val_under) { \
> > > 	[ 0 ... '+'-1 ] = -1, \
> > > 	[ '+' ] = val_plus, val_comma, val_minus, -1, val_slash, \
> > > 	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
> > > 	[ '9'+1 ... 'A'-1 ] = -1, \
> > > 	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
> > > 		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
> > > 	[ 'Z'+1 ... '_'-1 ] = -1, \
> > > 	[ '_' ] = val_under, \
> > > 	[ '_'+1 ... 'a'-1 ] = -1, \
> > > 	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
> > > 		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
> > > 	[ 'z'+1 ... 255 ] = -1 \
> > > }  
> > 
> > I've a slightly better version:
> > 
> > #define INIT_62_63(ch, ch_62, ch_63) \
> > 	[ ch ] = ch == ch_62 ? 62 : ch == ch_63 ? 63 : -1
> > 
> > #define BASE64_REV_INIT(ch_62, ch_63) { \
> > 	[ 0 ... '0' - 6 ] = -1, \
> > 	INIT_62_63('+', ch_62, ch_63), \
> > 	INIT_62_63(',', ch_62, ch_63), \
> > 	INIT_62_63('-', ch_62, ch_63), \
> > 	INIT_62_63('.', ch_62, ch_63), \
> > 	INIT_62_63('/', ch_62, ch_63), \
> > 	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
> > 	[ '9' + 1 ... 'A' - 1 ] = -1, \
> > 	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
> > 		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
> > 	[ 'Z' + 1 ... '_' - 1 ] = -1, \
> > 	INIT_62_63('_', ch_62, ch_63), \
> > 	[ '_' + 1 ... 'a' - 1 ] = -1, \
> > 	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
> > 		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
> > 	[ 'z' + 1 ... 255 ] = -1 \
> > }
> > 
> > that only requires that INIT_62_63() be used for all the characters
> > that are used for 62 and 63 - it can be used for extra ones (eg '.').
> > If some code wants to use different characters; the -1 need replacing
> > with INIT_62_63() but nothing else has to be changed.
> > 
> > I used '0' - 6 (rather than '+' - 1 - or any other expression for 0x2a)
> > to (possibly) make the table obviously correct without referring to the
> > ascii code table.  
> 
> Still it's heavily depends on the values of '+,-./_' as an index that
> makes it not so flexible.

How about this one?
#define INIT_1(v, ch_lo, ch_hi, off, ch_62, ch_63) \
	[ v ] = ((v) >= ch_lo && (v) <= ch_hi) ? (v) - ch_lo + off \
		: (v) == ch_62 ? 62 : (v) == ch_63 ? 63 : -1
#define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
#define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
#define INIT_8(v, ...) INIT_4(v, __VA_ARGS__), INIT_4((v) + 4, __VA_ARGS__)
#define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
#define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)

#define BASE64_REV_INIT(ch_62, ch_63) { \
	[ 0 ... 0x1f ] = -1, \
	INIT_32(0x20, '0', '9', 0, ch_62, ch_63), \
	INIT_32(0x40, 'A', 'Z', 10, ch_62, ch_63), \
	INIT_32(0x60, 'a', 'z', 26, ch_62, ch_63), \
	[ 0x80 ... 0xff ] = -1 }

which gets the pre-processor to do all the work.
ch_62 and ch_63 can be any printable characters.

Note that the #define names are all in a .c file - so don't need any
kind of namespace protection.
They can also all be #undef after the initialiser.

> Moreover this table is basically a dup of the strings in the first array.
> Which already makes an unnecessary duplication.

That is what the self tests are for.

> That's why I prefer to
> see a script (one source of data) to generate the header or something like
> this to have the tables and strings robust against typos.

We have to differ on that one.
Especially in cases (like this) where generating that data is reasonably trivial.

	David

> 
> The above is simply an unreadable mess.
> 


