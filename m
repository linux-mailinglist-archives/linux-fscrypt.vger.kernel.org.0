Return-Path: <linux-fscrypt+bounces-849-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B69BA563A
	for <lists+linux-fscrypt@lfdr.de>; Sat, 27 Sep 2025 01:33:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D2337BA800
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Sep 2025 23:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B187228BAB1;
	Fri, 26 Sep 2025 23:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="cYpos5U5"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86E32BDC00
	for <linux-fscrypt@vger.kernel.org>; Fri, 26 Sep 2025 23:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758929606; cv=none; b=scXkU1sB2xkJb+9vpoFbEELZdpqHG8mWB5y5Dq8OihQ0kESJXlxvsyGvxcXsHUBfogwoojNtkllwCmG2vpPFWQ2/fJ5LIxXXVcB/oQNVnZcWtTbyL3Xt0s7llBGqJi5AZM1PpBq9faiqYa9dpaJ8O1va40aEtAfTi4N9U9x0htU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758929606; c=relaxed/simple;
	bh=NQC8XNXnjygLJqox0g7Xz5VWBXH+Z35TTJ2KFtxLMJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EtW6sUD7Fypqd7+we/DtiFBbDvDlmB7idqaIDkMfK2+ZhNo78JX6MAS/C3T/YwonfzuafANlS1UmgSKQ+4zfyCk2TyooeEWJx4R7m5Lyob3zjqvCaJxIygNeJ1eig0CDT4KivnipqcQ/pJEe9lGrj3sGi2g0wVsKqxp7rFpZIKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=cYpos5U5; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-269640c2d4bso5558385ad.2
        for <linux-fscrypt@vger.kernel.org>; Fri, 26 Sep 2025 16:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1758929604; x=1759534404; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTw+KZvrDjb5UTFpK7FAxk2eU7ODCJYc2yTxNUcpgiw=;
        b=cYpos5U5v+7SxlNiHlQwlbMry9yxmtLOOPiakEIbAbcNTlgXKkmDdiNMl+3+YSIuJR
         iLVKbEkvUBe41NmmPEIduUku0tosrO+/Li8h/Gitm3pJgKrykWHBGs/YX/YUceZR8SiZ
         s42+gzQ/QfR8lxvmEOxoB3OUgTxF9omBSRdFquMJYTmb2arYVhO3bBz8Fb1JuyAaF/p9
         nAhhxDJUOmrkPucShxr8cV1wZJNQIoPkqu6t5LUYIEalQBTRYmpRbAesdqoqxENzOFoz
         sngXUD97ScodJFfX9fitiy12PoquukW71A/SCa8opdqyuCWBmMz0L90kyzkeTDUPfwXz
         hbDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758929604; x=1759534404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MTw+KZvrDjb5UTFpK7FAxk2eU7ODCJYc2yTxNUcpgiw=;
        b=ju5dG/4ogVmBWXn2YewhyUCcud5998EVHuCVaS6kHSiXVFX82V6ZcXbofiOFWV4jPO
         +sVNrDrRROwPt+ax8JBi35A1GnR4EexT7rCBrQRa9zoluL4+FWqA/0Q7EPjxrRGtigyo
         virCKUXygD7Hg/C+dy6LVgX/5F5V4eInWdIpzZq64duNjGLoQWOjD/GonKXMgNYqaKgl
         q0YNTwMlGR9RuQEUhqzqkAzsjefi5jWjgHUyJcbBciBGcnvHDqLgr4GNwRLx3zW+5CNt
         kASJVFrcpwbSW6Kjibw4idadMoAbYW9lDsbB0DvbrI/pX4cnlGlhT/Bs1y7QjcOEimUX
         1uLQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+pZY866Q4fUdh9klO2axqPlq2LSldpUEnBRDlvGCO0wxzOueWG0O8d3W9raOCkf+zI1Mvz2VE7NEQiKUz@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/NRiDooqVS/M5EyQPZPIhRCiGR5uPbJduPUHfKsAFy97D1JYH
	hLBywY1futmL8nnc6m0waFFpJppg78+3nMN0ynHK/0d/UAe8u4Nofwon1KvFigb+RzHhAQGvMQf
	0UwVtTm6Z0vAdEJ6wHc2IY7vr9zij9fyCHLbFaPRn2w==
X-Gm-Gg: ASbGnct3uczjIJ/ucqlj/dMdCZCSXBOXfep6rxHHXjCIsSGzocMK5ymaUjBZxM7v2EU
	gEzWo8RJHw8gp1uesnH7nd9IhCuGZZ8jSILL9TqI5PvB8fFHIAPtHJxyPAxbkBhyh5XS5C/7St3
	podqXfgCRMHL9QRL7r2/8jvV/L9XMg8sQh7alxTgvHMeUf36FvPqhZi5Sp3Yoio6N7rFccAMcjG
	0HY/VoB1xwO6BHep2rLuzNIg9laNQtMfHz+0GBm
X-Google-Smtp-Source: AGHT+IEmwasV917F/ENXUuMXNw6qnyku7SdrL3S46yOq+ltmtsWNtQZ4LiJG30MWacaYm9zGnPUEEk+jqqdkXCd8/H0=
X-Received: by 2002:a17:903:32cf:b0:269:80e2:c5a8 with SMTP id
 d9443c01a7336-27ed4a36556mr59261245ad.7.1758929603929; Fri, 26 Sep 2025
 16:33:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw> <20250926065556.14250-1-409411716@gms.tku.edu.tw>
In-Reply-To: <20250926065556.14250-1-409411716@gms.tku.edu.tw>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 26 Sep 2025 16:33:12 -0700
X-Gm-Features: AS18NWDAPU1wF1fnKK0roMsQSKKSRQQvsh9BWc75x2xsf5jzdJWlHk7wuynVlkw
Message-ID: <CADUfDZruZWyrsjRCs_Y5gjsbfU7dz_ALGG61pQ8qCM7K2_DjmA@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with reverse
 lookup tables
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org, 
	ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com, 
	jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2025 at 11:59=E2=80=AFPM Guan-Chun Wu <409411716@gms.tku.ed=
u.tw> wrote:
>
> From: Kuan-Wei Chiu <visitorckw@gmail.com>
>
> Replace the use of strchr() in base64_decode() with precomputed reverse
> lookup tables for each variant. This avoids repeated string scans and
> improves performance. Use -1 in the tables to mark invalid characters.
>
> Decode:
>   64B   ~1530ns  ->  ~75ns    (~20.4x)
>   1KB  ~27726ns  -> ~1165ns   (~23.8x)
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> ---
>  lib/base64.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 61 insertions(+), 5 deletions(-)
>
> diff --git a/lib/base64.c b/lib/base64.c
> index 1af557785..b20fdf168 100644
> --- a/lib/base64.c
> +++ b/lib/base64.c
> @@ -21,6 +21,63 @@ static const char base64_tables[][65] =3D {
>         [BASE64_IMAP] =3D "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrst=
uvwxyz0123456789+,",
>  };
>
> +static const s8 base64_rev_tables[][256] =3D {
> +       [BASE64_STD] =3D {
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1, =
 -1,  -1,  63,
> +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11, =
 12,  13,  14,
> +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37, =
 38,  39,  40,
> +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +       },
> +       [BASE64_URLSAFE] =3D {
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 62,  -1,  -1,
> +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11, =
 12,  13,  14,
> +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1, =
 -1,  -1,  63,
> +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37, =
 38,  39,  40,
> +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +       },
> +       [BASE64_IMAP] =3D {
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  63, =
 -1,  -1,  -1,
> +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11, =
 12,  13,  14,
> +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37, =
 38,  39,  40,
> +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1, =
 -1,  -1,  -1,
> +       },

Do we actually need 3 separate lookup tables? It looks like all 3
variants agree on the value of any characters they have in common. So
we could combine them into a single lookup table that would work for a
valid base64 string of any variant. The only downside I can see is
that base64 strings which are invalid in some variants might no longer
be rejected by base64_decode().

> +};
> +
>  /**
>   * base64_encode() - Base64-encode some binary data
>   * @src: the binary data to encode
> @@ -82,11 +139,9 @@ int base64_decode(const char *src, int srclen, u8 *ds=
t, bool padding, enum base6
>         int bits =3D 0;
>         int i;
>         u8 *bp =3D dst;
> -       const char *base64_table =3D base64_tables[variant];
> +       s8 ch;
>
>         for (i =3D 0; i < srclen; i++) {
> -               const char *p =3D strchr(base64_table, src[i]);
> -
>                 if (src[i] =3D=3D '=3D') {
>                         ac =3D (ac << 6);
>                         bits +=3D 6;
> @@ -94,9 +149,10 @@ int base64_decode(const char *src, int srclen, u8 *ds=
t, bool padding, enum base6
>                                 bits -=3D 8;
>                         continue;
>                 }
> -               if (p =3D=3D NULL || src[i] =3D=3D 0)
> +               ch =3D base64_rev_tables[variant][(u8)src[i]];
> +               if (ch =3D=3D -1)

Checking for < 0 can save an additional comparison here.

Best,
Caleb

>                         return -1;
> -               ac =3D (ac << 6) | (p - base64_table);
> +               ac =3D (ac << 6) | ch;
>                 bits +=3D 6;
>                 if (bits >=3D 8) {
>                         bits -=3D 8;
> --
> 2.34.1
>
>

