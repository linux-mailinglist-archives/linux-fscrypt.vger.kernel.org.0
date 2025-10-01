Return-Path: <linux-fscrypt+bounces-856-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F10BAFE54
	for <lists+linux-fscrypt@lfdr.de>; Wed, 01 Oct 2025 11:39:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 509803B3BD9
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Oct 2025 09:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B883E2D9EE3;
	Wed,  1 Oct 2025 09:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="kBWZpQ+1"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0741E9B35
	for <linux-fscrypt@vger.kernel.org>; Wed,  1 Oct 2025 09:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759311581; cv=none; b=rLSEUbyyf/Go4wCRLdFpI77J10zDCBVDw4SSzRsKkspVP26a7aWf6rVV4bWV0lZ+VrQL+D1Ohf24e+KCzrwC6tMse+JaAliJRfdkuLgFn4igAJeFwwOahbO7rX6z/TJeqt+pJJeY+PaZA+JHWJGjzBEYQAdqo/adMskPgJlmxsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759311581; c=relaxed/simple;
	bh=5+wGHsVSJp7aKjRngTofvGA41Xc/E576jMkkIXQuvME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PEkkEV1imTPIL5wKocwY/YUt+OYjGUTnZo0AVP6AbrXIf4gfgBQtIxChb8jw/mIIyXb9Bzr+OkrJc77+6dgnKVhGXLbHjg5ZUz5Ez70yfd92wB0xC7wHZUB6CkbV4vihKUsWm/Ip2Fd7eMGAV7t8RRDKlO9cbC1CIoikGZnBzDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=kBWZpQ+1; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-28a5b8b12a1so33363755ad.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Oct 2025 02:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1759311578; x=1759916378; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RH313CpCuD+wJMMeahL+bTyK0565gpLKQ1q2sfI6Vmc=;
        b=kBWZpQ+1i3g+cSVjLuEn1DBhsv9unXvgyyLB8nFUSB3nQY5UUqQfuPtloEwWTusuTy
         3lDZ8jgeLzoFB0qe4tk3/QnD4B8fHkFOAt8UVGcfGtqoNYTj8q1szTC2N6BMgXJRk5wk
         PyHiE/ExF9osz3IL7hqRxi3B0uG29yy5yqauZv/2e7RyYqnGnArbib1hAK9Sn9oNpcCM
         V41wYvrVdV9/eW54OzvIKpaAo9wUM1ix+9TuHHvbjxFsVI6S1lBNS/s8iLRMjE/pawVT
         i8sdytC3aXk7VMrJTFf5RnQWGJFZfgPD9SxA0Y4qW9+bfH/PHQigTxni4+IeRM9V2nZN
         0Obg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759311578; x=1759916378;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RH313CpCuD+wJMMeahL+bTyK0565gpLKQ1q2sfI6Vmc=;
        b=XreyRN5UnLoz79V1aBialiLdNke1FtU1ftD06JxxAkTBq6613dlrkwTuztyGlRjDc9
         UbngzHwfBcONuqrB6CZy2DXUpPib/tjjxiXnApiYC56hPDDkQsCgPQJDjJ2a4qxTFDG+
         5TycNNCBqUFlhdksq21hydX7mtkF+Ov+9x0b48E8JGZbtZXhj/hquVnlN8KcrrriPH88
         xi8RU0sapzRmLbw4ZMBUHAwohDprvQUiEs2TlcYfR887JNCj/8VZmhA2L11by84/hAje
         TSWerTA8ro1Z2ROV968ebsLZRTGN7l9rjD+mJZFV7DpNtofTdkbV0tyw2fFz4Z2guI/J
         7tbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXamZSL0wY92m7utgAYUm1u+TnJIhPY/YNeOGVcnfWeWdv7TfaUBbWTByBeU6Jt8u2lKsQNdJ/rIKL6Mng@vger.kernel.org
X-Gm-Message-State: AOJu0YzdTnTLeB6XVVc9yL7yGiKz15k6ghOYWK/+hTGgp6ck+Ptvareq
	YpsFpa/wJFBHNBqCarucRS9ivYTbhZQML6cO7oMkOFOlVKBS52Tvw6PH4j+zjiJLEwI=
X-Gm-Gg: ASbGncud9xCrz0wDWXw+21EsEuDtE71JQk9l+AMpgaAEPssWxoivbMPTaX9js7lvxKK
	9VZ0WS8HkLCJI95y7JlbgPl3bS8tKi64D6qHpioD5SEkalCkzTKx9ODQnsT631DtWOxp21SabNG
	JThABraF5Lte+gAOnezENEkKPHxnz247U9wGfcN0O34qsJVPmgA1yvOTexDhJOEjtf3kd18GFZ4
	IqF4Q8ttJkmLFituDdWrO+c0vGkTgeVxpQxtchjvSFWUqCXFEqr8iBqTFiyAy3UPi7Hi6uIy2gy
	n2rqG9bAF4EBxrSbEM1o3WYWvOnJqpyg1n7KEu2XbTIsMwwb3t7dTrt9I0JDKzmEUHN0uS4aHfk
	tUnms2OzaauJ4m+SUh0YQhVG2S1ZNogDs8DvyvRjR/rUkzLeMhwqFTXscQo1mAKCpdQ3r
X-Google-Smtp-Source: AGHT+IHIKEU4rxPOObS/Le2ktFYtqmbdApte52qFqx6+kR+L7RpESjWLOH63jfrQI2d4Q3vboZI/SQ==
X-Received: by 2002:a17:903:46c3:b0:277:9193:f2ca with SMTP id d9443c01a7336-28e7f27db30mr32030255ad.9.1759311577816;
        Wed, 01 Oct 2025 02:39:37 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:6af7:94e4:3a78:e342])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6700ccdsm179957265ad.37.2025.10.01.02.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 02:39:36 -0700 (PDT)
Date: Wed, 1 Oct 2025 17:39:32 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
	ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com,
	idryomov@gmail.com, jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v3 3/6] lib/base64: rework encode/decode for speed and
 stricter validation
Message-ID: <aNz21InCM4Pa93TL@wu-Pro-E500-G6-WS720T>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
 <20250926065617.14361-1-409411716@gms.tku.edu.tw>
 <CADUfDZpu=rK4WwSmhNgxHQd2zeNvn8a7TmKCYuTL5T7dZ0x_4A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZpu=rK4WwSmhNgxHQd2zeNvn8a7TmKCYuTL5T7dZ0x_4A@mail.gmail.com>

On Tue, Sep 30, 2025 at 05:11:12PM -0700, Caleb Sander Mateos wrote:
> On Fri, Sep 26, 2025 at 12:01 AM Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> >
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
> >   64B  ~1530ns  -> ~64ns   (~23.9x)
> >   1KB ~27726ns  -> ~982ns  (~28.3x)
> >
> > Co-developed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Co-developed-by: Yu-Sheng Huang <home7438072@gmail.com>
> > Signed-off-by: Yu-Sheng Huang <home7438072@gmail.com>
> > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > ---
> >  lib/base64.c | 150 +++++++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 110 insertions(+), 40 deletions(-)
> >
> > diff --git a/lib/base64.c b/lib/base64.c
> > index b20fdf168..fd1db4611 100644
> > --- a/lib/base64.c
> > +++ b/lib/base64.c
> > @@ -93,26 +93,43 @@ static const s8 base64_rev_tables[][256] = {
> >  int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
> >  {
> >         u32 ac = 0;
> > -       int bits = 0;
> > -       int i;
> >         char *cp = dst;
> >         const char *base64_table = base64_tables[variant];
> >
> > -       for (i = 0; i < srclen; i++) {
> > -               ac = (ac << 8) | src[i];
> > -               bits += 8;
> > -               do {
> > -                       bits -= 6;
> > -                       *cp++ = base64_table[(ac >> bits) & 0x3f];
> > -               } while (bits >= 6);
> > -       }
> > -       if (bits) {
> > -               *cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
> > -               bits -= 6;
> > +       while (srclen >= 3) {
> > +               ac = ((u32)src[0] << 16) |
> > +                        ((u32)src[1] << 8) |
> > +                        (u32)src[2];
> > +
> > +               *cp++ = base64_table[ac >> 18];
> > +               *cp++ = base64_table[(ac >> 12) & 0x3f];
> > +               *cp++ = base64_table[(ac >> 6) & 0x3f];
> > +               *cp++ = base64_table[ac & 0x3f];
> > +
> > +               src += 3;
> > +               srclen -= 3;
> >         }
> > -       while (bits < 0) {
> > -               *cp++ = '=';
> > -               bits += 2;
> > +
> > +       switch (srclen) {
> > +       case 2:
> > +               ac = ((u32)src[0] << 16) |
> > +                    ((u32)src[1] << 8);
> > +
> > +               *cp++ = base64_table[ac >> 18];
> > +               *cp++ = base64_table[(ac >> 12) & 0x3f];
> > +               *cp++ = base64_table[(ac >> 6) & 0x3f];
> > +               if (padding)
> > +                       *cp++ = '=';
> > +               break;
> > +       case 1:
> > +               ac = ((u32)src[0] << 16);
> > +               *cp++ = base64_table[ac >> 18];
> > +               *cp++ = base64_table[(ac >> 12) & 0x3f];
> > +               if (padding) {
> > +                       *cp++ = '=';
> > +                       *cp++ = '=';
> > +               }
> > +               break;
> >         }
> >         return cp - dst;
> >  }
> > @@ -128,39 +145,92 @@ EXPORT_SYMBOL_GPL(base64_encode);
> >   *
> >   * Decodes a string using the selected Base64 variant.
> >   *
> > - * This implementation hasn't been optimized for performance.
> > - *
> >   * Return: the length of the resulting decoded binary data in bytes,
> >   *        or -1 if the string isn't a valid Base64 string.
> >   */
> >  int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base64_variant variant)
> >  {
> > -       u32 ac = 0;
> > -       int bits = 0;
> > -       int i;
> >         u8 *bp = dst;
> > -       s8 ch;
> > -
> > -       for (i = 0; i < srclen; i++) {
> > -               if (src[i] == '=') {
> > -                       ac = (ac << 6);
> > -                       bits += 6;
> > -                       if (bits >= 8)
> > -                               bits -= 8;
> > -                       continue;
> > -               }
> > -               ch = base64_rev_tables[variant][(u8)src[i]];
> > -               if (ch == -1)
> > +       s8 input1, input2, input3, input4;
> > +       u32 val;
> > +
> > +       if (srclen == 0)
> > +               return 0;
> 
> Doesn't look like this special case is necessary; all the if and while
> conditions below are false if srclen == 0, so the function will just
> end up returning 0 in that case anyways. It would be nice to avoid
> this branch, especially as it seems like an uncommon case.
>

You're right. I'll remove it. Thanks.

> > +
> > +       /* Validate the input length for padding */
> > +       if (unlikely(padding && (srclen & 0x03) != 0))
> > +               return -1;
> > +
> > +       while (srclen >= 4) {
> > +               /* Decode the next 4 characters */
> > +               input1 = base64_rev_tables[variant][(u8)src[0]];
> > +               input2 = base64_rev_tables[variant][(u8)src[1]];
> > +               input3 = base64_rev_tables[variant][(u8)src[2]];
> > +               input4 = base64_rev_tables[variant][(u8)src[3]];
> > +
> > +               /* Return error if any Base64 character is invalid */
> > +               if (unlikely(input1 < 0 || input2 < 0 || (!padding && (input3 < 0 || input4 < 0))))
> > +                       return -1;
> > +
> > +               /* Handle padding */
> > +               if (unlikely(padding && ((input3 < 0 && input4 >= 0) ||
> > +                                        (input3 < 0 && src[2] != '=') ||
> > +                                        (input4 < 0 && src[3] != '=') ||
> > +                                        (srclen > 4 && (input3 < 0 || input4 < 0)))))
> 
> Would be preferable to check and strip the padding (i.e. decrease
> srclen) before this main loop. That way we could avoid several
> branches in this hot loop that are only necessary to handle the
> padding chars.
> 

You're right. As long as we check and strip the padding first, the
behavior with or without padding can be the same, and it could also
reduce some unnecessary branches. I'll make the change.

Best regards,
Guan-Chun

> > +                       return -1;
> > +               val = ((u32)input1 << 18) |
> > +                     ((u32)input2 << 12) |
> > +                     ((u32)((input3 < 0) ? 0 : input3) << 6) |
> > +                     (u32)((input4 < 0) ? 0 : input4);
> > +
> > +               *bp++ = (u8)(val >> 16);
> > +
> > +               if (input3 >= 0)
> > +                       *bp++ = (u8)(val >> 8);
> > +               if (input4 >= 0)
> > +                       *bp++ = (u8)val;
> > +
> > +               src += 4;
> > +               srclen -= 4;
> > +       }
> > +
> > +       /* Handle leftover characters when padding is not used */
> > +       if (!padding && srclen > 0) {
> > +               switch (srclen) {
> > +               case 2:
> > +                       input1 = base64_rev_tables[variant][(u8)src[0]];
> > +                       input2 = base64_rev_tables[variant][(u8)src[1]];
> > +                       if (unlikely(input1 < 0 || input2 < 0))
> > +                               return -1;
> > +
> > +                       val = ((u32)input1 << 6) | (u32)input2; /* 12 bits */
> > +                       if (unlikely(val & 0x0F))
> > +                               return -1; /* low 4 bits must be zero */
> > +
> > +                       *bp++ = (u8)(val >> 4);
> > +                       break;
> > +               case 3:
> > +                       input1 = base64_rev_tables[variant][(u8)src[0]];
> > +                       input2 = base64_rev_tables[variant][(u8)src[1]];
> > +                       input3 = base64_rev_tables[variant][(u8)src[2]];
> > +                       if (unlikely(input1 < 0 || input2 < 0 || input3 < 0))
> > +                               return -1;
> > +
> > +                       val = ((u32)input1 << 12) |
> > +                             ((u32)input2 << 6) |
> > +                             (u32)input3; /* 18 bits */
> > +
> > +                       if (unlikely(val & 0x03))
> > +                               return -1; /* low 2 bits must be zero */
> > +
> > +                       *bp++ = (u8)(val >> 10);
> > +                       *bp++ = (u8)((val >> 2) & 0xFF);
> 
> "& 0xFF" is redundant with the cast to u8.
> 
> Best,
> Caleb
> 
> > +                       break;
> > +               default:
> >                         return -1;
> > -               ac = (ac << 6) | ch;
> > -               bits += 6;
> > -               if (bits >= 8) {
> > -                       bits -= 8;
> > -                       *bp++ = (u8)(ac >> bits);
> >                 }
> >         }
> > -       if (ac & ((1 << bits) - 1))
> > -               return -1;
> > +
> >         return bp - dst;
> >  }
> >  EXPORT_SYMBOL_GPL(base64_decode);
> > --
> > 2.34.1
> >
> >

