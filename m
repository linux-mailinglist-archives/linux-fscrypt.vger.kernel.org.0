Return-Path: <linux-fscrypt+bounces-819-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A827B5382D
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 17:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1749A560447
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 15:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B87834F46C;
	Thu, 11 Sep 2025 15:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="GU8Gyb7P"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AF8135A53
	for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 15:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757605826; cv=none; b=qMiWfG4An389EUTIJwcKLi6AAqSdlGy2Gw7S6YLgYW7x2F+Q8IvvWEk3dFSawArwI0YmYY8fybGCbjd/TUk0GjbtDkpTxLC6GRAQDwsvYMXQrsrwsu7xdzdPkkUGjl6BVARGTLw3mUIUf5pRM8em8Jk/5yHCFXCwaY7V62ep8UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757605826; c=relaxed/simple;
	bh=AVPIcj7/hHgkX+g4Z1sIxJH3Jfu6UUxYUve4DBl59+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GncnWmmOEVZR1tnzOK7xXlPU7VJuXxL6YbSJJC32EmCm6xupRJaRVEjHGgFb74VjHsg7+MqPuPCSayJcylyw1ionrZeiEHLVhNoroASVaHKkNrUfBi3pUNXot91+wJfXT+E8K7rMaa6IjC/i+fuSnYlUmuOPbf1JNmNsut9Kibg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=GU8Gyb7P; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24cda620e37so1461945ad.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 08:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757605824; x=1758210624; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sm39d5NFqL/jKxwzJUkYjs0RqtR2b1iX+TUT2ANp2Xo=;
        b=GU8Gyb7PrDLaehgpAqUSqvzvBo3t9iwxc4ecGstuKBv4mVEZsVIjsKCrZfSwad2YTU
         Mxwj973APa2QgIRKpc+4ucpFRksE48KBLleM/LA7u5xNM0l4AMuAcYxZ+usJnkDc/LrK
         ov9nEyJZSRLdsod4X+3HivOWkyf1P3BPfEYU+2/ia4HK+OGxCjp2O45fE7nM8c2BVEM/
         T+Pxmf8Nszw27pE7pNBzH++k1/H9PkRx8gC6sOqizJJYsL2zp/q5C5sXy58iiU/A1fGK
         XOxTJcSVTZISTaZiGVh0JuOjkVJmVA2vBxYQ6hRC1vY3tENCsnUcdqNSMHRxKORyIhug
         0fNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757605824; x=1758210624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sm39d5NFqL/jKxwzJUkYjs0RqtR2b1iX+TUT2ANp2Xo=;
        b=iz2owPSFbxe4SJzMdEI7g+oxnQsJ6nmK7NP3qiaeMc/4bWzIx7mrpZ4ryyr1uGI3r1
         DTVfdRssD6UVdEYRssYWCYlavQGJz2O87Lmk+kYZ0GBWP8WNGUZ3abX2wPuuLRtQfUqY
         GoxrYt52xm72QkRaWmrYvsEP9MXxfLPejPtp0RKlyBr1UMas0pNQi6lDjI9+Ycab50ft
         N29LsGJ15r4Ad5sQjYrZBmld5j+xzAS0VUf6K6FfHicMUU/gJgwiitjgLjwY4YD2jyq/
         eLREbb0ZasmzxlYeipbSmlgnuCyNOhU1HmBHWnwX9wXkLZNUJ3KGlHX34im5A/e3ilPo
         wqRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUVnAW+4R+XnQMk1oV8aXsbEv/2/fuiojAu+ifyZn7VLVLr/BKPwnbcDDIfz2RbYdPJgxYeop4F9xkZxa8@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr2whyzBQOEzCvgOw9Lpmapvww6rIy8PyTX3eiGbnKuChtvdTL
	om/HQyKAOohrzperacsOJbssvGKfTWRzgk7Sx3Abzi0hsrwsrNbRBGwQ2rqoN7MX3xZCI0QeAFD
	fB+O+y1S7f0wxdd9slqai40RgmxFK/1BTDuZJfZlndQ==
X-Gm-Gg: ASbGncvLngdg/yxtXVFGNAd0RJ28Pes9gb8D5X64Ij9K6F43RLjaI1XeDAC/gJnTQS1
	GYCGMUnp20A0RoBqzwGIMQRPr8DKqbq6k0wynlGD5PHvIxLok5v1+gLu8dn4zd3Xph9PILAeFlI
	asZenHPp12k5Mh1hwfIeobblSKqvSQr0bciUI7vsoiTN9E7LOXkZNiWx/JDGMy3SJ39Ugo/z74D
	VesEqma3jeyqh2uzhy64yV0JkoSKrddB/6LFLQ=
X-Google-Smtp-Source: AGHT+IHeD3ijdPFv6sWC+2qqn5ewuQ4r5M61SalEw+nEx55NKT7Qlty/iU0ChnsPVabDot6LaASoCZDlZs00KT1RgN0=
X-Received: by 2002:a17:902:ec8e:b0:24d:15b7:1fa4 with SMTP id
 d9443c01a7336-2517653b663mr140062445ad.10.1757605824176; Thu, 11 Sep 2025
 08:50:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw> <20250911073204.574742-1-409411716@gms.tku.edu.tw>
In-Reply-To: <20250911073204.574742-1-409411716@gms.tku.edu.tw>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 11 Sep 2025 08:50:12 -0700
X-Gm-Features: Ac12FXwoL045SNoj1J2Tk9bFEh24Fjp_N53zMjtCDhxT-Fzyr-6A0W4BpkqjnRk
Message-ID: <CADUfDZqe2x+xaqs6M_BZm3nR=Ahu-quKbFNmKCv2QFb39qAYXg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] lib/base64: Replace strchr() for better performance
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org, 
	ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com, 
	jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 12:33=E2=80=AFAM Guan-Chun Wu <409411716@gms.tku.ed=
u.tw> wrote:
>
> From: Kuan-Wei Chiu <visitorckw@gmail.com>
>
> The base64 decoder previously relied on strchr() to locate each
> character in the base64 table. In the worst case, this requires
> scanning all 64 entries, and even with bitwise tricks or word-sized
> comparisons, still needs up to 8 checks.
>
> Introduce a small helper function that maps input characters directly
> to their position in the base64 table. This reduces the maximum number
> of comparisons to 5, improving decoding efficiency while keeping the
> logic straightforward.
>
> Benchmarks on x86_64 (Intel Core i7-10700 @ 2.90GHz, averaged
> over 1000 runs, tested with KUnit):
>
> Decode:
>  - 64B input: avg ~1530ns -> ~126ns (~12x faster)
>  - 1KB input: avg ~27726ns -> ~2003ns (~14x faster)
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> ---
>  lib/base64.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/lib/base64.c b/lib/base64.c
> index b736a7a43..9416bded2 100644
> --- a/lib/base64.c
> +++ b/lib/base64.c
> @@ -18,6 +18,21 @@
>  static const char base64_table[65] =3D
>         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=
";

Does base64_table still need to be NUL-terminated?

>
> +static inline const char *find_chr(const char *base64_table, char ch)

Don't see a need to pass in base64_table, the function could just
access the global variable directly.

> +{
> +       if ('A' <=3D ch && ch <=3D 'Z')
> +               return base64_table + ch - 'A';
> +       if ('a' <=3D ch && ch <=3D 'z')
> +               return base64_table + 26 + ch - 'a';
> +       if ('0' <=3D ch && ch <=3D '9')
> +               return base64_table + 26 * 2 + ch - '0';
> +       if (ch =3D=3D base64_table[26 * 2 + 10])
> +               return base64_table + 26 * 2 + 10;
> +       if (ch =3D=3D base64_table[26 * 2 + 10 + 1])
> +               return base64_table + 26 * 2 + 10 + 1;
> +       return NULL;

This is still pretty branchy. One way to avoid the branches would be
to define a reverse lookup table mapping base64 chars to their values
(or a sentinel value for invalid chars). Have you benchmarked that
approach?

Best,
Caleb

> +}
> +
>  /**
>   * base64_encode() - base64-encode some binary data
>   * @src: the binary data to encode
> @@ -78,7 +93,7 @@ int base64_decode(const char *src, int srclen, u8 *dst)
>         u8 *bp =3D dst;
>
>         for (i =3D 0; i < srclen; i++) {
> -               const char *p =3D strchr(base64_table, src[i]);
> +               const char *p =3D find_chr(base64_table, src[i]);
>
>                 if (src[i] =3D=3D '=3D') {
>                         ac =3D (ac << 6);
> --
> 2.34.1
>
>

