Return-Path: <linux-fscrypt+bounces-861-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A75D3BBF657
	for <lists+linux-fscrypt@lfdr.de>; Mon, 06 Oct 2025 22:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76308189A328
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Oct 2025 20:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F7C257836;
	Mon,  6 Oct 2025 20:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XRsExcMr"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347362566F7
	for <linux-fscrypt@vger.kernel.org>; Mon,  6 Oct 2025 20:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759783938; cv=none; b=G8B9uPt+kslKEjf9A8xkOcXXsBT5mtc43hWEV7jJcOCXuo2OrUF4Qxj+sfo3/kePwKabIhc5FraWE57EONxWdWZyNPOFNcPxxgWTUuEHuLT+32Kd3RV6HmI8RQVVPMfP7IE/0Cbzuo2z33LCKaAezimqJdLYzBQM2zyc+wk48HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759783938; c=relaxed/simple;
	bh=SgZdgLfYa2RybFEsMrSySIU2QHr0Ijto9bld1Lp134Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MkB/kpnniEVN+4Xh6YbBry815sosOxFiiCpLahTKvL17MvD1QVA7iZZlPjTEEsN3vdeOoQlwNMUm570d37Yqwz0HYcno8Bh6C1xyTl6StwC0/GBFQHbII53ZbLH1jsjCv4Iy76SwJJuRBlggO1x80jKObGeQd1sfcNDxfpZMfZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XRsExcMr; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e2e6a708fso35990895e9.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 06 Oct 2025 13:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759783934; x=1760388734; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZhEGqG5f02SA+cxa1EF4uynlEuBc23Gw/Zg/k7vIsQ=;
        b=XRsExcMrubVkblxbtUw/rBmjTkRf6ORc3zWQLdycIMKz3PYSavyBRXFKzEqpQNTrc2
         Uqy21nJqBtj3Z76JFbZSAQKmUT0i4Q2n+XtzciIgOm9YAB3nqrnFx5+WQW6RmCb3KoSS
         d7/afsWg3LCqwYNrGsiEKDcV/jOwdHMmi07ePokVC+RVSUdO7A/7ALTSp6THQLd0Iba/
         Cb3WLtIw8amznnpMu18GpgDFv8aGoRmVCU3Pry+R3CM/RuyUR38ErYIMdFul/kfVurGX
         PBna8TyDHD3adPmDG6glLy2I4YcsVYA9YbNCNR9+kNKTsSl/4MXhfDbqGJZU5lPnQ2gA
         kHmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759783934; x=1760388734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sZhEGqG5f02SA+cxa1EF4uynlEuBc23Gw/Zg/k7vIsQ=;
        b=THzhpsPAu+1FigfkVRDpBpE51wxf6KFWzwMouxsHfYu97TJ7rDHvedwIokcJZ4ni0u
         Col/71mUex0UYiCnbjDy5b7xlpe4B7vnI2rlu/TWDe+0o4McQHT5kdfOjTGID5eJi2hu
         mmRKHED/0N5q7axpTqel/4LvvkYgmIyuzlQkfi9/xyvaO24gKsQnz/BNX2WHr/Ax6ewa
         E0dM78Ul+BqRrJ/XyMgCVPKk3IGupcz6csgn2wf8NW5uUM7LsIe1NHWm9+FfuPXYskYL
         Yzg2hO4T4xTmLcpcE76Gftsdi3JqUruJdpAyG04ds9ZObj7qRV+TvjJm27kM398/Jz8u
         E3VA==
X-Forwarded-Encrypted: i=1; AJvYcCXZhGiYKNV/9UvStyJpnQWBYR5fl19ZUf4C8Hhl9VMD8ckant72m46o2/Pn4dk0FGX13TrBQyPcfHN3MUbE@vger.kernel.org
X-Gm-Message-State: AOJu0YwLrOPj4lealsFj0ZxoE7+5uFeH92pm/CVb78oyGnzBGfWSzwi+
	3JC6fu+BdDxvtfotOvkW0sFQcrOzSizVi6+lPvWNiRVk6VeZSCPaeF+C
X-Gm-Gg: ASbGncvoWx4KViduR6yxfNXCZxiO9tqZ0lg5mdLckJHbxKdHRlP75QfcF+awrXWh1H4
	vF4/Ljptj1RgRGwkrUlWECKIgsG86ZRhstT/E3hTzMM3j4nMwckQtkm1HrtmNLYTc4G+GK3UcZo
	TNqk6PfwHq3TNFMOTeEdhHHkP3YtYSSqe4MO/Bm9CesU0KJDCgw8Dndbq+bgncAyieYN7XBQi51
	+F9JC/lN1TC+KFxuefdd70AJGKsDr21i/2GmchrYx5PjQsKJ/h63yYnuhi/OAOBigPdxxJdO65P
	2xmk7GeYgCuEASBqaFDCAkoDBRvjoRoBCk71XuQ9LxaUAfv3RqzMIpxu7C22lxcIZ+pOv814d5c
	UYhoz/THUT0px+PxAR+bTUuGyx1pBJYzQ8Mj7eFHiV+sTX6w76mGsFKKrqb0Yf6OLPzNGtss1ZQ
	2cQl2hgkjK7T6Lu/Or4k7rhiM=
X-Google-Smtp-Source: AGHT+IFRLlb8uWC1dqxKo8J55feiaCNAhabM0Ub7mobnG4dCUMmuEgByLy76YakZhK1VJ6qhsA7FmQ==
X-Received: by 2002:a05:600c:8b6e:b0:46e:3d50:362a with SMTP id 5b1f17b1804b1-46e710ffff6mr85930215e9.4.1759783934211;
        Mon, 06 Oct 2025 13:52:14 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e723624b3sm171254835e9.17.2025.10.06.13.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 13:52:13 -0700 (PDT)
Date: Mon, 6 Oct 2025 21:52:12 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
 ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
 jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v3 3/6] lib/base64: rework encode/decode for speed and
 stricter validation
Message-ID: <20251006215212.2920d571@pumpkin>
In-Reply-To: <aNz21InCM4Pa93TL@wu-Pro-E500-G6-WS720T>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
	<20250926065617.14361-1-409411716@gms.tku.edu.tw>
	<CADUfDZpu=rK4WwSmhNgxHQd2zeNvn8a7TmKCYuTL5T7dZ0x_4A@mail.gmail.com>
	<aNz21InCM4Pa93TL@wu-Pro-E500-G6-WS720T>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Oct 2025 17:39:32 +0800
Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

> On Tue, Sep 30, 2025 at 05:11:12PM -0700, Caleb Sander Mateos wrote:
> > On Fri, Sep 26, 2025 at 12:01=E2=80=AFAM Guan-Chun Wu <409411716@gms.tk=
u.edu.tw> wrote: =20
> > >
> > > The old base64 implementation relied on a bit-accumulator loop, which=
 was
> > > slow for larger inputs and too permissive in validation. It would acc=
ept
> > > extra '=3D', missing '=3D', or even '=3D' appearing in the middle of =
the input,
> > > allowing malformed strings to pass. This patch reworks the internals =
to
> > > improve performance and enforce stricter validation.
> > >
> > > Changes:
> > >  - Encoder:
> > >    * Process input in 3-byte blocks, mapping 24 bits into four 6-bit
> > >      symbols, avoiding bit-by-bit shifting and reducing loop iteratio=
ns.
> > >    * Handle the final 1-2 leftover bytes explicitly and emit '=3D' on=
ly when
> > >      requested.
> > >  - Decoder:
> > >    * Based on the reverse lookup tables from the previous patch, deco=
de
> > >      input in 4-character groups.
> > >    * Each group is looked up directly, converted into numeric values,=
 and
> > >      combined into 3 output bytes.
> > >    * Explicitly handle padded and unpadded forms:
> > >       - With padding: input length must be a multiple of 4, and '=3D'=
 is
> > >         allowed only in the last two positions. Reject stray or early=
 '=3D'.
> > >       - Without padding: validate tail lengths (2 or 3 chars) and req=
uire
> > >         unused low bits to be zero.
> > >    * Removed the bit-accumulator style loop to reduce loop iterations.
> > >
> > > Performance (x86_64, Intel Core i7-10700 @ 2.90GHz, avg over 1000 run=
s,
> > > KUnit):
> > >
> > > Encode:
> > >   64B   ~90ns   -> ~32ns   (~2.8x)
> > >   1KB  ~1332ns  -> ~510ns  (~2.6x)
> > >
> > > Decode:
> > >   64B  ~1530ns  -> ~64ns   (~23.9x)
> > >   1KB ~27726ns  -> ~982ns  (~28.3x)
> > >
> > > Co-developed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > Co-developed-by: Yu-Sheng Huang <home7438072@gmail.com>
> > > Signed-off-by: Yu-Sheng Huang <home7438072@gmail.com>
> > > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > ---
> > >  lib/base64.c | 150 +++++++++++++++++++++++++++++++++++++------------=
--
> > >  1 file changed, 110 insertions(+), 40 deletions(-)
> > >
> > > diff --git a/lib/base64.c b/lib/base64.c
> > > index b20fdf168..fd1db4611 100644
> > > --- a/lib/base64.c
> > > +++ b/lib/base64.c
> > > @@ -93,26 +93,43 @@ static const s8 base64_rev_tables[][256] =3D {
> > >  int base64_encode(const u8 *src, int srclen, char *dst, bool padding=
, enum base64_variant variant)
> > >  {
> > >         u32 ac =3D 0;
> > > -       int bits =3D 0;
> > > -       int i;
> > >         char *cp =3D dst;
> > >         const char *base64_table =3D base64_tables[variant];
> > >
> > > -       for (i =3D 0; i < srclen; i++) {
> > > -               ac =3D (ac << 8) | src[i];
> > > -               bits +=3D 8;
> > > -               do {
> > > -                       bits -=3D 6;
> > > -                       *cp++ =3D base64_table[(ac >> bits) & 0x3f];
> > > -               } while (bits >=3D 6);
> > > -       }
> > > -       if (bits) {
> > > -               *cp++ =3D base64_table[(ac << (6 - bits)) & 0x3f];
> > > -               bits -=3D 6;
> > > +       while (srclen >=3D 3) {
> > > +               ac =3D ((u32)src[0] << 16) |
> > > +                        ((u32)src[1] << 8) |
> > > +                        (u32)src[2];
> > > +
> > > +               *cp++ =3D base64_table[ac >> 18];
> > > +               *cp++ =3D base64_table[(ac >> 12) & 0x3f];
> > > +               *cp++ =3D base64_table[(ac >> 6) & 0x3f];
> > > +               *cp++ =3D base64_table[ac & 0x3f];
> > > +
> > > +               src +=3D 3;
> > > +               srclen -=3D 3;
> > >         }
> > > -       while (bits < 0) {
> > > -               *cp++ =3D '=3D';
> > > -               bits +=3D 2;
> > > +
> > > +       switch (srclen) {
> > > +       case 2:
> > > +               ac =3D ((u32)src[0] << 16) |
> > > +                    ((u32)src[1] << 8);
> > > +
> > > +               *cp++ =3D base64_table[ac >> 18];
> > > +               *cp++ =3D base64_table[(ac >> 12) & 0x3f];
> > > +               *cp++ =3D base64_table[(ac >> 6) & 0x3f];
> > > +               if (padding)
> > > +                       *cp++ =3D '=3D';
> > > +               break;
> > > +       case 1:
> > > +               ac =3D ((u32)src[0] << 16);
> > > +               *cp++ =3D base64_table[ac >> 18];
> > > +               *cp++ =3D base64_table[(ac >> 12) & 0x3f];
> > > +               if (padding) {
> > > +                       *cp++ =3D '=3D';
> > > +                       *cp++ =3D '=3D';
> > > +               }
> > > +               break;
> > >         }
> > >         return cp - dst;
> > >  }
> > > @@ -128,39 +145,92 @@ EXPORT_SYMBOL_GPL(base64_encode);
> > >   *
> > >   * Decodes a string using the selected Base64 variant.
> > >   *
> > > - * This implementation hasn't been optimized for performance.
> > > - *
> > >   * Return: the length of the resulting decoded binary data in bytes,
> > >   *        or -1 if the string isn't a valid Base64 string.
> > >   */
> > >  int base64_decode(const char *src, int srclen, u8 *dst, bool padding=
, enum base64_variant variant)
> > >  {
> > > -       u32 ac =3D 0;
> > > -       int bits =3D 0;
> > > -       int i;
> > >         u8 *bp =3D dst;
> > > -       s8 ch;
> > > -
> > > -       for (i =3D 0; i < srclen; i++) {
> > > -               if (src[i] =3D=3D '=3D') {
> > > -                       ac =3D (ac << 6);
> > > -                       bits +=3D 6;
> > > -                       if (bits >=3D 8)
> > > -                               bits -=3D 8;
> > > -                       continue;
> > > -               }
> > > -               ch =3D base64_rev_tables[variant][(u8)src[i]];
> > > -               if (ch =3D=3D -1)
> > > +       s8 input1, input2, input3, input4;
> > > +       u32 val;
> > > +
> > > +       if (srclen =3D=3D 0)
> > > +               return 0; =20
> >=20
> > Doesn't look like this special case is necessary; all the if and while
> > conditions below are false if srclen =3D=3D 0, so the function will just
> > end up returning 0 in that case anyways. It would be nice to avoid
> > this branch, especially as it seems like an uncommon case.
> > =20
>=20
> You're right. I'll remove it. Thanks.
>=20
> > > +
> > > +       /* Validate the input length for padding */
> > > +       if (unlikely(padding && (srclen & 0x03) !=3D 0))
> > > +               return -1;
> > > +
> > > +       while (srclen >=3D 4) {
> > > +               /* Decode the next 4 characters */
> > > +               input1 =3D base64_rev_tables[variant][(u8)src[0]];
> > > +               input2 =3D base64_rev_tables[variant][(u8)src[1]];
> > > +               input3 =3D base64_rev_tables[variant][(u8)src[2]];
> > > +               input4 =3D base64_rev_tables[variant][(u8)src[3]];
> > > +
> > > +               /* Return error if any Base64 character is invalid */
> > > +               if (unlikely(input1 < 0 || input2 < 0 || (!padding &&=
 (input3 < 0 || input4 < 0))))
> > > +                       return -1;
> > > +
> > > +               /* Handle padding */
> > > +               if (unlikely(padding && ((input3 < 0 && input4 >=3D 0=
) ||
> > > +                                        (input3 < 0 && src[2] !=3D '=
=3D') ||
> > > +                                        (input4 < 0 && src[3] !=3D '=
=3D') ||
> > > +                                        (srclen > 4 && (input3 < 0 |=
| input4 < 0))))) =20
> >=20
> > Would be preferable to check and strip the padding (i.e. decrease
> > srclen) before this main loop. That way we could avoid several
> > branches in this hot loop that are only necessary to handle the
> > padding chars.
> >  =20
>=20
> You're right. As long as we check and strip the padding first, the
> behavior with or without padding can be the same, and it could also
> reduce some unnecessary branches. I'll make the change.

As I said earlier.
Calculate 'val' first using signed arithmetic.
If it is non-negative there are three bytes to write.
If negative then check for src[2] and src[3] being '=3D' (etc) before error=
ing out.

That way there is only one check in the normal path.

	David

>=20
> Best regards,
> Guan-Chun
>=20
> > > +                       return -1;
> > > +               val =3D ((u32)input1 << 18) |
> > > +                     ((u32)input2 << 12) |
> > > +                     ((u32)((input3 < 0) ? 0 : input3) << 6) |
> > > +                     (u32)((input4 < 0) ? 0 : input4);
> > > +
> > > +               *bp++ =3D (u8)(val >> 16);
> > > +
> > > +               if (input3 >=3D 0)
> > > +                       *bp++ =3D (u8)(val >> 8);
> > > +               if (input4 >=3D 0)
> > > +                       *bp++ =3D (u8)val;
> > > +
> > > +               src +=3D 4;
> > > +               srclen -=3D 4;
> > > +       }
> > > +
> > > +       /* Handle leftover characters when padding is not used */
> > > +       if (!padding && srclen > 0) {
> > > +               switch (srclen) {
> > > +               case 2:
> > > +                       input1 =3D base64_rev_tables[variant][(u8)src=
[0]];
> > > +                       input2 =3D base64_rev_tables[variant][(u8)src=
[1]];
> > > +                       if (unlikely(input1 < 0 || input2 < 0))
> > > +                               return -1;
> > > +
> > > +                       val =3D ((u32)input1 << 6) | (u32)input2; /* =
12 bits */
> > > +                       if (unlikely(val & 0x0F))
> > > +                               return -1; /* low 4 bits must be zero=
 */
> > > +
> > > +                       *bp++ =3D (u8)(val >> 4);
> > > +                       break;
> > > +               case 3:
> > > +                       input1 =3D base64_rev_tables[variant][(u8)src=
[0]];
> > > +                       input2 =3D base64_rev_tables[variant][(u8)src=
[1]];
> > > +                       input3 =3D base64_rev_tables[variant][(u8)src=
[2]];
> > > +                       if (unlikely(input1 < 0 || input2 < 0 || inpu=
t3 < 0))
> > > +                               return -1;
> > > +
> > > +                       val =3D ((u32)input1 << 12) |
> > > +                             ((u32)input2 << 6) |
> > > +                             (u32)input3; /* 18 bits */
> > > +
> > > +                       if (unlikely(val & 0x03))
> > > +                               return -1; /* low 2 bits must be zero=
 */
> > > +
> > > +                       *bp++ =3D (u8)(val >> 10);
> > > +                       *bp++ =3D (u8)((val >> 2) & 0xFF); =20
> >=20
> > "& 0xFF" is redundant with the cast to u8.
> >=20
> > Best,
> > Caleb
> >  =20
> > > +                       break;
> > > +               default:
> > >                         return -1;
> > > -               ac =3D (ac << 6) | ch;
> > > -               bits +=3D 6;
> > > -               if (bits >=3D 8) {
> > > -                       bits -=3D 8;
> > > -                       *bp++ =3D (u8)(ac >> bits);
> > >                 }
> > >         }
> > > -       if (ac & ((1 << bits) - 1))
> > > -               return -1;
> > > +
> > >         return bp - dst;
> > >  }
> > >  EXPORT_SYMBOL_GPL(base64_decode);
> > > --
> > > 2.34.1
> > >
> > > =20
>=20


