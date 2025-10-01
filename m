Return-Path: <linux-fscrypt+bounces-855-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FE8BAEDA9
	for <lists+linux-fscrypt@lfdr.de>; Wed, 01 Oct 2025 02:11:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED19B194449B
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Oct 2025 00:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AFDE3C33;
	Wed,  1 Oct 2025 00:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Vcih7bHQ"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950474C83
	for <linux-fscrypt@vger.kernel.org>; Wed,  1 Oct 2025 00:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759277486; cv=none; b=OI3gMbB5w5gbs1Jy4pxHju0koeYf3TghN+9Bezt8oA5wAm1SyRYO8Bcsd/+UeenID2RKr/rdqVycPUvD289SFoOmFwM6z+wBQn31qjOtaXu1tMt0KJow/rK8oSh//M61u8vedRxJ0OTZByy7q3rJTG0CFYXBHtvNUleUo8hcKBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759277486; c=relaxed/simple;
	bh=qqbs3iPe0XOer+lM3og6iPt6OwIdfi4M4GbyCfUy+ls=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=udgwHfgaXRCvp4yVVlLw/geoS+iBseI8q/uqpZofd89a5MTdMpQek/djsbH2CxBsq80U9uxJi1n7FxG3bkRDFZi99Kku449hL64mRnCvD2wGlCl8fKRqIZVK64rRRKDMGRkAUSm0hi+umPnXpgAE77+tqfvYObO7Ah6g3kOliZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Vcih7bHQ; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-33257e0fb88so754452a91.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 30 Sep 2025 17:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1759277484; x=1759882284; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DSU3acyqxN1lYkbp2Gqvkb9p2L/gX/8eplXEY/yyd0=;
        b=Vcih7bHQSEOB9w0EQ9SbZR2xazMJSJq8EVKwEhkjfRSQgzxh5F+fymTXCgCzlGVJ6c
         FokmRyLqw6G948FR5pd2yrNE+8KXYcUCnXqAX2fdS9sAk2B26/nmmJu5vzWAV20LqKql
         tuedib0MQUWASP53Yj06BAmcvaXPra5FlD+gNmLKWpoqwu9fJJ9AZGF37PV5uVP47O/g
         XryKyPnXxl11ovXCN0nkDSPg3MVSLlyski7tCCXXw0snQXr1CjRhOv6IFk1Q3sKzYzOt
         eYzXurcP1SDdzluhd868/MuuGHavGSqn6J1zHlX9dnQnloEr2FD4ooQhB28GHoe/Lzr7
         mI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759277484; x=1759882284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4DSU3acyqxN1lYkbp2Gqvkb9p2L/gX/8eplXEY/yyd0=;
        b=Dp0bCLq3DLYyXU/webFEtTTho/WC9XiYTXWH+3Jfmk3pgVrkdEE/xvJOLxclthoh90
         7rQBAszeSgIoknAnm2rEFBmxCcrL9x9uGIrOPll2gSr1uPJdhdP1h5lGu3Vm4oypDhk6
         ON0x9bUUGED+ckq2PHdqapME7/zesH+63TP9i0yifval9A+8gDP8NJqqLA6reVT2Sk5G
         JWYa+X+9yVA1vJogB6MNN7tUlYy0tHoOuc2FgSwnLLsKTCzu+kpnRZwXynSBY0cATcMT
         OOTwKb0JWJMwqBMuvBamktxqCHEjCC7lwxVoqC+uTT90OzL/zHFBMKg0GgIx/4KrFvsq
         EhjQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6zkbVhLRYo5qvc/QMoTAFE91Qn8mHdwcSkJZpZn5ZRArRAHymyXcnn1kuWl/wpcfAQvBlvB3PhhAbZdPe@vger.kernel.org
X-Gm-Message-State: AOJu0YwKW21NahrdZ//HPtBD3oTBWGagZJXMh77/3oof5Og3QCzuNvCU
	JLQo93JSzRz+eFH6qmn3OAm6ddPpWqb7jhPLvnhphvEt0j2TE1qt5Ga6riJGNGqasTss1J53iJI
	NiVr+p4IlBYMxHRrHjsO0LMF2RPgFLGsWmtUHYo/Lsw==
X-Gm-Gg: ASbGncvEI4W9fhPoAWomRWGWJRnwC+VPLPHZiWMeCoyi/pUkfP9xE5oSuqAdGFHxhOe
	lhV+J90V1BMTULPAtYVvtALsowi4mjaMkno0MNCSolJDJRK5cVNqT20TRakZm0iKPBk5/HwP/YG
	E+7hgC2TiU/sms883OHADnOVm676tEcG4vCCMMNVnph2cmNhi2oUPVYaMkhIQW1KzyrsikxWbVF
	rCzXcvcLuVlRySrxi2F8aHpVDg8Ls5tCSTeKblRtIPJPFRBoj7S3vOd7W32pTvX
X-Google-Smtp-Source: AGHT+IH3GE/DZ3MSHAOXxAHWgBR+LMCCV37xzgvUOEqpCJDrI3crv9C/h9WRhJLTqZyHasjKOWfldDQut/rNgNRPZ0k=
X-Received: by 2002:a17:902:d4cb:b0:25c:b66e:9c2a with SMTP id
 d9443c01a7336-28e7f2fa9b7mr11054465ad.6.1759277483763; Tue, 30 Sep 2025
 17:11:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw> <20250926065617.14361-1-409411716@gms.tku.edu.tw>
In-Reply-To: <20250926065617.14361-1-409411716@gms.tku.edu.tw>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 30 Sep 2025 17:11:12 -0700
X-Gm-Features: AS18NWBvBb_ZPhcEO5KRhrM9SZABPhK814Z1fs3a4G2IOurdkxPcQ3z475xIaJo
Message-ID: <CADUfDZpu=rK4WwSmhNgxHQd2zeNvn8a7TmKCYuTL5T7dZ0x_4A@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] lib/base64: rework encode/decode for speed and
 stricter validation
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org, 
	ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com, 
	jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2025 at 12:01=E2=80=AFAM Guan-Chun Wu <409411716@gms.tku.ed=
u.tw> wrote:
>
> The old base64 implementation relied on a bit-accumulator loop, which was
> slow for larger inputs and too permissive in validation. It would accept
> extra '=3D', missing '=3D', or even '=3D' appearing in the middle of the =
input,
> allowing malformed strings to pass. This patch reworks the internals to
> improve performance and enforce stricter validation.
>
> Changes:
>  - Encoder:
>    * Process input in 3-byte blocks, mapping 24 bits into four 6-bit
>      symbols, avoiding bit-by-bit shifting and reducing loop iterations.
>    * Handle the final 1-2 leftover bytes explicitly and emit '=3D' only w=
hen
>      requested.
>  - Decoder:
>    * Based on the reverse lookup tables from the previous patch, decode
>      input in 4-character groups.
>    * Each group is looked up directly, converted into numeric values, and
>      combined into 3 output bytes.
>    * Explicitly handle padded and unpadded forms:
>       - With padding: input length must be a multiple of 4, and '=3D' is
>         allowed only in the last two positions. Reject stray or early '=
=3D'.
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
>   64B  ~1530ns  -> ~64ns   (~23.9x)
>   1KB ~27726ns  -> ~982ns  (~28.3x)
>
> Co-developed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Co-developed-by: Yu-Sheng Huang <home7438072@gmail.com>
> Signed-off-by: Yu-Sheng Huang <home7438072@gmail.com>
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> ---
>  lib/base64.c | 150 +++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 110 insertions(+), 40 deletions(-)
>
> diff --git a/lib/base64.c b/lib/base64.c
> index b20fdf168..fd1db4611 100644
> --- a/lib/base64.c
> +++ b/lib/base64.c
> @@ -93,26 +93,43 @@ static const s8 base64_rev_tables[][256] =3D {
>  int base64_encode(const u8 *src, int srclen, char *dst, bool padding, en=
um base64_variant variant)
>  {
>         u32 ac =3D 0;
> -       int bits =3D 0;
> -       int i;
>         char *cp =3D dst;
>         const char *base64_table =3D base64_tables[variant];
>
> -       for (i =3D 0; i < srclen; i++) {
> -               ac =3D (ac << 8) | src[i];
> -               bits +=3D 8;
> -               do {
> -                       bits -=3D 6;
> -                       *cp++ =3D base64_table[(ac >> bits) & 0x3f];
> -               } while (bits >=3D 6);
> -       }
> -       if (bits) {
> -               *cp++ =3D base64_table[(ac << (6 - bits)) & 0x3f];
> -               bits -=3D 6;
> +       while (srclen >=3D 3) {
> +               ac =3D ((u32)src[0] << 16) |
> +                        ((u32)src[1] << 8) |
> +                        (u32)src[2];
> +
> +               *cp++ =3D base64_table[ac >> 18];
> +               *cp++ =3D base64_table[(ac >> 12) & 0x3f];
> +               *cp++ =3D base64_table[(ac >> 6) & 0x3f];
> +               *cp++ =3D base64_table[ac & 0x3f];
> +
> +               src +=3D 3;
> +               srclen -=3D 3;
>         }
> -       while (bits < 0) {
> -               *cp++ =3D '=3D';
> -               bits +=3D 2;
> +
> +       switch (srclen) {
> +       case 2:
> +               ac =3D ((u32)src[0] << 16) |
> +                    ((u32)src[1] << 8);
> +
> +               *cp++ =3D base64_table[ac >> 18];
> +               *cp++ =3D base64_table[(ac >> 12) & 0x3f];
> +               *cp++ =3D base64_table[(ac >> 6) & 0x3f];
> +               if (padding)
> +                       *cp++ =3D '=3D';
> +               break;
> +       case 1:
> +               ac =3D ((u32)src[0] << 16);
> +               *cp++ =3D base64_table[ac >> 18];
> +               *cp++ =3D base64_table[(ac >> 12) & 0x3f];
> +               if (padding) {
> +                       *cp++ =3D '=3D';
> +                       *cp++ =3D '=3D';
> +               }
> +               break;
>         }
>         return cp - dst;
>  }
> @@ -128,39 +145,92 @@ EXPORT_SYMBOL_GPL(base64_encode);
>   *
>   * Decodes a string using the selected Base64 variant.
>   *
> - * This implementation hasn't been optimized for performance.
> - *
>   * Return: the length of the resulting decoded binary data in bytes,
>   *        or -1 if the string isn't a valid Base64 string.
>   */
>  int base64_decode(const char *src, int srclen, u8 *dst, bool padding, en=
um base64_variant variant)
>  {
> -       u32 ac =3D 0;
> -       int bits =3D 0;
> -       int i;
>         u8 *bp =3D dst;
> -       s8 ch;
> -
> -       for (i =3D 0; i < srclen; i++) {
> -               if (src[i] =3D=3D '=3D') {
> -                       ac =3D (ac << 6);
> -                       bits +=3D 6;
> -                       if (bits >=3D 8)
> -                               bits -=3D 8;
> -                       continue;
> -               }
> -               ch =3D base64_rev_tables[variant][(u8)src[i]];
> -               if (ch =3D=3D -1)
> +       s8 input1, input2, input3, input4;
> +       u32 val;
> +
> +       if (srclen =3D=3D 0)
> +               return 0;

Doesn't look like this special case is necessary; all the if and while
conditions below are false if srclen =3D=3D 0, so the function will just
end up returning 0 in that case anyways. It would be nice to avoid
this branch, especially as it seems like an uncommon case.

> +
> +       /* Validate the input length for padding */
> +       if (unlikely(padding && (srclen & 0x03) !=3D 0))
> +               return -1;
> +
> +       while (srclen >=3D 4) {
> +               /* Decode the next 4 characters */
> +               input1 =3D base64_rev_tables[variant][(u8)src[0]];
> +               input2 =3D base64_rev_tables[variant][(u8)src[1]];
> +               input3 =3D base64_rev_tables[variant][(u8)src[2]];
> +               input4 =3D base64_rev_tables[variant][(u8)src[3]];
> +
> +               /* Return error if any Base64 character is invalid */
> +               if (unlikely(input1 < 0 || input2 < 0 || (!padding && (in=
put3 < 0 || input4 < 0))))
> +                       return -1;
> +
> +               /* Handle padding */
> +               if (unlikely(padding && ((input3 < 0 && input4 >=3D 0) ||
> +                                        (input3 < 0 && src[2] !=3D '=3D'=
) ||
> +                                        (input4 < 0 && src[3] !=3D '=3D'=
) ||
> +                                        (srclen > 4 && (input3 < 0 || in=
put4 < 0)))))

Would be preferable to check and strip the padding (i.e. decrease
srclen) before this main loop. That way we could avoid several
branches in this hot loop that are only necessary to handle the
padding chars.

> +                       return -1;
> +               val =3D ((u32)input1 << 18) |
> +                     ((u32)input2 << 12) |
> +                     ((u32)((input3 < 0) ? 0 : input3) << 6) |
> +                     (u32)((input4 < 0) ? 0 : input4);
> +
> +               *bp++ =3D (u8)(val >> 16);
> +
> +               if (input3 >=3D 0)
> +                       *bp++ =3D (u8)(val >> 8);
> +               if (input4 >=3D 0)
> +                       *bp++ =3D (u8)val;
> +
> +               src +=3D 4;
> +               srclen -=3D 4;
> +       }
> +
> +       /* Handle leftover characters when padding is not used */
> +       if (!padding && srclen > 0) {
> +               switch (srclen) {
> +               case 2:
> +                       input1 =3D base64_rev_tables[variant][(u8)src[0]]=
;
> +                       input2 =3D base64_rev_tables[variant][(u8)src[1]]=
;
> +                       if (unlikely(input1 < 0 || input2 < 0))
> +                               return -1;
> +
> +                       val =3D ((u32)input1 << 6) | (u32)input2; /* 12 b=
its */
> +                       if (unlikely(val & 0x0F))
> +                               return -1; /* low 4 bits must be zero */
> +
> +                       *bp++ =3D (u8)(val >> 4);
> +                       break;
> +               case 3:
> +                       input1 =3D base64_rev_tables[variant][(u8)src[0]]=
;
> +                       input2 =3D base64_rev_tables[variant][(u8)src[1]]=
;
> +                       input3 =3D base64_rev_tables[variant][(u8)src[2]]=
;
> +                       if (unlikely(input1 < 0 || input2 < 0 || input3 <=
 0))
> +                               return -1;
> +
> +                       val =3D ((u32)input1 << 12) |
> +                             ((u32)input2 << 6) |
> +                             (u32)input3; /* 18 bits */
> +
> +                       if (unlikely(val & 0x03))
> +                               return -1; /* low 2 bits must be zero */
> +
> +                       *bp++ =3D (u8)(val >> 10);
> +                       *bp++ =3D (u8)((val >> 2) & 0xFF);

"& 0xFF" is redundant with the cast to u8.

Best,
Caleb

> +                       break;
> +               default:
>                         return -1;
> -               ac =3D (ac << 6) | ch;
> -               bits +=3D 6;
> -               if (bits >=3D 8) {
> -                       bits -=3D 8;
> -                       *bp++ =3D (u8)(ac >> bits);
>                 }
>         }
> -       if (ac & ((1 << bits) - 1))
> -               return -1;
> +
>         return bp - dst;
>  }
>  EXPORT_SYMBOL_GPL(base64_decode);
> --
> 2.34.1
>
>

