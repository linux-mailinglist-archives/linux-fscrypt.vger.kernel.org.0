Return-Path: <linux-fscrypt+bounces-854-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A18D4BAECF1
	for <lists+linux-fscrypt@lfdr.de>; Wed, 01 Oct 2025 01:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F212167390
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Sep 2025 23:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F159F2D24AE;
	Tue, 30 Sep 2025 23:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="NfWOf+S1"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAFC2EAE3
	for <linux-fscrypt@vger.kernel.org>; Tue, 30 Sep 2025 23:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759276591; cv=none; b=TMNX7SUQ0TjT6KzpaPEzwbm7UTIf0fApzIbmcTmBfnZFjVfPoDeyPp1d6gnnJ2NAGyZa0yzs376IqCaxvpdKgiN2yFhHbtbKB6ZHOeCoGSTewNDO8/2dwQUxs5x2L2AmNZtkuWJkTKnm/cc0vV0Fwej1tiEQkJL7T/doHfj99j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759276591; c=relaxed/simple;
	bh=VjwQu5t029EJUnvWftQxUO2Qo8SIfQ3NcDYijcOISpA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AtglmLBBeQOQBRO8xp7c/HP3oT3jiYcAkjpeCrKQt+nHI1V4c10RXtNTAP7jmTpn5smxGRk90XDA1ZB80DtFsM+D6Mxgy6LH4dW3skJKAnwGzmmsl3AwYf+IcG7J9ENuw/8CRpK0KKodtp62bFrjyaRyEcUyByRBTuuIG/pUEtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=NfWOf+S1; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-28d18e933a9so2487225ad.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 30 Sep 2025 16:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1759276589; x=1759881389; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KgDda9PZ/ZOIVHoxLqUI98Lhj+DhQRySzSwpHGi1nUs=;
        b=NfWOf+S1JoknBOd5Oe5HHgw0VUX8/dy7LV7FFlJgMakGXJ7jhQ/+rMyl8sGChAJmYf
         q8g3ougUavorrpH5I1HNj2z//nfYedVadgABiXhRo94S4JEcR83OarJRz3QpgJgTzQ5D
         qnGVLEXaxsCnj7uToYyr1V5XDcAFkbD1yoQKwSRlVVeXrM9KnKbWUeDU4aKMbaQRLBcd
         uwTJg/JVE12Kkk9AJFNzyVOZ/dU3BGhQeeXaInBuHFWS9K0QMN1gT/JyfbtYhZIx8U9i
         doC8m3mrFy3rbat0ARa7sep+iF8Pcj/UEydWcG7hB+Bgj7oK9/SQrqqPST+L8CZ/cyaC
         qb4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759276589; x=1759881389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KgDda9PZ/ZOIVHoxLqUI98Lhj+DhQRySzSwpHGi1nUs=;
        b=JJjrbnPCPvY39cyIHHzhhNInCOC6yW3avlgkPbaiCGCOrpKZzI0JTxBExjVHLUHXcg
         nNxdHOqGBtMVyKYQFo2IYrBRcLHEb8DaC77xGBUOfXBRyiQvah+zqDKnAxCu6nUkam6m
         I/NGdkTX0qfS+x6ENOSfaO/GdjUjWmbFheETt6i6aOnHTlCWlRXncQHkm9jPbcFujucZ
         lTjL14pSj7aHGriuNla5mj0nlqd5NMuz7u+GImN6HpHlaiZ5thJedgKtoZQPa0TbvgDk
         PXZf3eyaXV75MwkCz4Qmn3ULH1GAunmfTg15Jw7FJTL4h+S5V5Rv/ooYxH1q6nr4tc/B
         JU3A==
X-Forwarded-Encrypted: i=1; AJvYcCV8fS7GXVPNzAkBW9yUOZWWsZv1VD0Snba86KYRHCfF+EbHCZCN3WBFiwb2rkTQYb+YAIOO0cN6MMRKQZR5@vger.kernel.org
X-Gm-Message-State: AOJu0YxeyqJH4RGtbHnMjPJuBYC8c6s3flmui1+CpoAZxnMy9auffsct
	t27qXI3zwytCLoA6Cjgtee4jCu51ayQFRWXTf30o0/WYHRwhDv0o5pQGIE0y+8MKcLlkvVQugT2
	wdRBKoagz3V73WCoFr/P9OhcuemQRIb/loIb9pv8Kpg==
X-Gm-Gg: ASbGncv8WsAestLiZrMzU5KAv+yAHGphxQtt4YXt5Q4ktIWH2m43lERwYS34pfPhLhA
	luJRWn4A15uOD6OifSte7ssSKKXa4Xthi/xD4GfyfRekhBs+/CCcSVJdf6k1JnhYpyOunok9e0Z
	zubd+4NTQI8OyotLeb7kC0LegPfZWnWb17o2ac9vWfVQzIMfVeiV/YgDh8jQji0zkdBgv1X63WH
	2im7IxnAm9wIs7DTsZFHZp57AplVLn0gXXbtECzWsG224ySsPsE4cBjQOp0Uqp1
X-Google-Smtp-Source: AGHT+IEpxdka3fpY1RGSt22bA+AUtwMCp/hERU5iCKu9uk3PEWfxh8d2ZVgwfA2eMNx71KLt9vE6DliHzz7bVhBKN/c=
X-Received: by 2002:a17:902:ce8c:b0:27e:f07c:8429 with SMTP id
 d9443c01a7336-28e7f263d0fmr9971685ad.1.1759276588590; Tue, 30 Sep 2025
 16:56:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw> <20250926065512.13881-1-409411716@gms.tku.edu.tw>
In-Reply-To: <20250926065512.13881-1-409411716@gms.tku.edu.tw>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 30 Sep 2025 16:56:17 -0700
X-Gm-Features: AS18NWAZDkDjzHRxic_YNlGQtc5_abU1XjZFoUXfiVOKnVWiVuhgyXH0Q0cj-2w
Message-ID: <CADUfDZp6WeW9YQRRnxB7fFObtajatY_+f+x1D5dQOrNv626znA@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] lib/base64: Add support for multiple variants
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
> Extend the base64 API to support multiple variants (standard, URL-safe,
> and IMAP) as defined in RFC 4648 and RFC 3501. The API now takes a
> variant parameter and an option to control padding. Update NVMe auth
> code to use the new interface with BASE64_STD.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> ---
>  drivers/nvme/common/auth.c |  4 ++--
>  include/linux/base64.h     | 10 ++++++++--
>  lib/base64.c               | 39 ++++++++++++++++++++++----------------
>  3 files changed, 33 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
> index 91e273b89..5fecb53cb 100644
> --- a/drivers/nvme/common/auth.c
> +++ b/drivers/nvme/common/auth.c
> @@ -178,7 +178,7 @@ struct nvme_dhchap_key *nvme_auth_extract_key(unsigne=
d char *secret,
>         if (!key)
>                 return ERR_PTR(-ENOMEM);
>
> -       key_len =3D base64_decode(secret, allocated_len, key->key);
> +       key_len =3D base64_decode(secret, allocated_len, key->key, true, =
BASE64_STD);
>         if (key_len < 0) {
>                 pr_debug("base64 key decoding error %d\n",
>                          key_len);
> @@ -663,7 +663,7 @@ int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, si=
ze_t psk_len,
>         if (ret)
>                 goto out_free_digest;
>
> -       ret =3D base64_encode(digest, digest_len, enc);
> +       ret =3D base64_encode(digest, digest_len, enc, true, BASE64_STD);
>         if (ret < hmac_len) {
>                 ret =3D -ENOKEY;
>                 goto out_free_digest;
> diff --git a/include/linux/base64.h b/include/linux/base64.h
> index 660d4cb1e..a2c6c9222 100644
> --- a/include/linux/base64.h
> +++ b/include/linux/base64.h
> @@ -8,9 +8,15 @@
>
>  #include <linux/types.h>
>
> +enum base64_variant {
> +       BASE64_STD,       /* RFC 4648 (standard) */
> +       BASE64_URLSAFE,   /* RFC 4648 (base64url) */
> +       BASE64_IMAP,      /* RFC 3501 */
> +};
> +
>  #define BASE64_CHARS(nbytes)   DIV_ROUND_UP((nbytes) * 4, 3)
>
> -int base64_encode(const u8 *src, int len, char *dst);
> -int base64_decode(const char *src, int len, u8 *dst);
> +int base64_encode(const u8 *src, int len, char *dst, bool padding, enum =
base64_variant variant);
> +int base64_decode(const char *src, int len, u8 *dst, bool padding, enum =
base64_variant variant);
>
>  #endif /* _LINUX_BASE64_H */
> diff --git a/lib/base64.c b/lib/base64.c
> index b736a7a43..1af557785 100644
> --- a/lib/base64.c
> +++ b/lib/base64.c
> @@ -1,12 +1,12 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * base64.c - RFC4648-compliant base64 encoding
> + * base64.c - Base64 with support for multiple variants
>   *
>   * Copyright (c) 2020 Hannes Reinecke, SUSE
>   *
>   * Based on the base64url routines from fs/crypto/fname.c
> - * (which are using the URL-safe base64 encoding),
> - * modified to use the standard coding table from RFC4648 section 4.
> + * (which are using the URL-safe Base64 encoding),
> + * modified to support multiple Base64 variants.
>   */
>
>  #include <linux/kernel.h>
> @@ -15,26 +15,31 @@
>  #include <linux/string.h>
>  #include <linux/base64.h>
>
> -static const char base64_table[65] =3D
> -       "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=
";
> +static const char base64_tables[][65] =3D {
> +       [BASE64_STD] =3D "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstu=
vwxyz0123456789+/",
> +       [BASE64_URLSAFE] =3D "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopq=
rstuvwxyz0123456789-_",
> +       [BASE64_IMAP] =3D "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrst=
uvwxyz0123456789+,",
> +};
>
>  /**
> - * base64_encode() - base64-encode some binary data
> + * base64_encode() - Base64-encode some binary data
>   * @src: the binary data to encode
>   * @srclen: the length of @src in bytes
> - * @dst: (output) the base64-encoded string.  Not NUL-terminated.
> + * @dst: (output) the Base64-encoded string.  Not NUL-terminated.
> + * @padding: whether to append '=3D' padding characters
> + * @variant: which base64 variant to use
>   *
> - * Encodes data using base64 encoding, i.e. the "Base 64 Encoding" speci=
fied
> - * by RFC 4648, including the  '=3D'-padding.
> + * Encodes data using the selected Base64 variant.
>   *
> - * Return: the length of the resulting base64-encoded string in bytes.
> + * Return: the length of the resulting Base64-encoded string in bytes.
>   */
> -int base64_encode(const u8 *src, int srclen, char *dst)
> +int base64_encode(const u8 *src, int srclen, char *dst, bool padding, en=
um base64_variant variant)

Padding isn't actually implemented in this commit? That seems a bit
confusing. I think it would ideally be implemented in the same commit
that adds it. That could be before or after the commit that optimizes
the encode/decode implementations.

Best,
Caleb

>  {
>         u32 ac =3D 0;
>         int bits =3D 0;
>         int i;
>         char *cp =3D dst;
> +       const char *base64_table =3D base64_tables[variant];
>
>         for (i =3D 0; i < srclen; i++) {
>                 ac =3D (ac << 8) | src[i];
> @@ -57,25 +62,27 @@ int base64_encode(const u8 *src, int srclen, char *ds=
t)
>  EXPORT_SYMBOL_GPL(base64_encode);
>
>  /**
> - * base64_decode() - base64-decode a string
> + * base64_decode() - Base64-decode a string
>   * @src: the string to decode.  Doesn't need to be NUL-terminated.
>   * @srclen: the length of @src in bytes
>   * @dst: (output) the decoded binary data
> + * @padding: whether to append '=3D' padding characters
> + * @variant: which base64 variant to use
>   *
> - * Decodes a string using base64 encoding, i.e. the "Base 64 Encoding"
> - * specified by RFC 4648, including the  '=3D'-padding.
> + * Decodes a string using the selected Base64 variant.
>   *
>   * This implementation hasn't been optimized for performance.
>   *
>   * Return: the length of the resulting decoded binary data in bytes,
> - *        or -1 if the string isn't a valid base64 string.
> + *        or -1 if the string isn't a valid Base64 string.
>   */
> -int base64_decode(const char *src, int srclen, u8 *dst)
> +int base64_decode(const char *src, int srclen, u8 *dst, bool padding, en=
um base64_variant variant)
>  {
>         u32 ac =3D 0;
>         int bits =3D 0;
>         int i;
>         u8 *bp =3D dst;
> +       const char *base64_table =3D base64_tables[variant];
>
>         for (i =3D 0; i < srclen; i++) {
>                 const char *p =3D strchr(base64_table, src[i]);
> --
> 2.34.1
>
>

