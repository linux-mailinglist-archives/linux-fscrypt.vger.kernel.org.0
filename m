Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76ABD4DAD2
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 21:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfFTT5O (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 15:57:14 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36228 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfFTT5N (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 15:57:13 -0400
Received: by mail-io1-f66.google.com with SMTP id h6so991255ioh.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 20 Jun 2019 12:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bZBE/7zbNKjrgccPgeQ2NlN2FSVmmv0iIVaVXtWq9Ko=;
        b=aVdWCB4zKkHtxQcwa1IBEAlJ/qAnPpbv8xInqEWHdh8UCgdAKbD1GXEf/V7E7ubYut
         26yciaqH5f6447xzlmO4ffDgUo61qHf5GH81zsUNiZasS3L866rFGKEElrSDuSPKoBDJ
         0cuy7n+YTOGS2WgDXSsGBYdGp4xRbQhiiBcHAnFq1jLe61YTsrr3EAPDPTVqU/Xw2ply
         TlJsc02atIr8Vz4J3kA1JwWSkTbEa43T4/TwEbQcnh8L2CH2rqwcfo6C0+VxzKd7ChcY
         VjWztzDpMTyCI97kX6Xt/tNGwPFsuBdojkvq2wxCPMhdSsid45awdcrkgaWzDAUZuVq/
         XwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bZBE/7zbNKjrgccPgeQ2NlN2FSVmmv0iIVaVXtWq9Ko=;
        b=TMO23+VWLs2J65OSVYeNUNKN5xqPYN9CBueW2pmosz9Md/b03StjiWZ29tdLVdIQ8E
         d4ZXzkiBUabli4ChRBnxg7w/+0DQU0xgt0HrXvVEeIy6Mp7GPPtgI0DUs6Q9UHFRBmS1
         0BSf51UI4lLU9+ZC/e7EW8IGmqbnYpVI1Uj/F0V+WOoDdRwaZldqEACKJDsYZvETIu7T
         szOsi4o6exoxKdH+h73uZkXIl+SBVk2qBAUpV/c1ph1SfdINL8A5u+m6cxjmLblJZSRj
         eD0VNyz20eW7lK4pcagIH45y8SkUWbzWOkmf1yUz/R/MZzdQYxvPa7KdaMRFRmlbqSMn
         dGjg==
X-Gm-Message-State: APjAAAVxcUqqxPVSrRPkT6a15QxHFYriORggNDl4Ti1KKK3yyF6DJxF/
        3AUAFDP8yaSan3M31vzgWxhTffWOjUISG7UuVVwO4Q==
X-Google-Smtp-Source: APXvYqxlpJiPVw9qHZ8D7sJwcBAgMvb87RHTzAypaYjWoAXudjuFU7E7FKU4bxoD6D40Ws1SqHWjr4SyOJdorylnnUY=
X-Received: by 2002:a5d:8794:: with SMTP id f20mr32338608ion.128.1561060632050;
 Thu, 20 Jun 2019 12:57:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190620181505.225232-1-ebiggers@kernel.org>
In-Reply-To: <20190620181505.225232-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 20 Jun 2019 21:56:58 +0200
Message-ID: <CAKv+Gu_D3hO1boyL3sYcZaUTCxw8fb+O6KTAEa2SmWRa-nOkew@mail.gmail.com>
Subject: Re: [PATCH] fscrypt: remove selection of CONFIG_CRYPTO_SHA256
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 20 Jun 2019 at 20:16, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> fscrypt only uses SHA-256 for AES-128-CBC-ESSIV, which isn't the default
> and is only recommended on platforms that have hardware accelerated
> AES-CBC but not AES-XTS.  There's no link-time dependency, since SHA-256
> is requested via the crypto API on first use.
>
> To reduce bloat, we should limit FS_ENCRYPTION to selecting the default
> algorithms only.  SHA-256 by itself isn't that much bloat, but it's
> being discussed to move ESSIV into a crypto API template, which would
> incidentally bring in other things like "authenc" support, which would
> all end up being built-in since FS_ENCRYPTION is now a bool.
>
> For Adiantum encryption we already just document that users who want to
> use it have to enable CONFIG_CRYPTO_ADIANTUM themselves.  So, let's do
> the same for AES-128-CBC-ESSIV and CONFIG_CRYPTO_SHA256.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  Documentation/filesystems/fscrypt.rst | 4 +++-
>  fs/crypto/Kconfig                     | 1 -
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 08c23b60e01647..87d4e266ffc86d 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -191,7 +191,9 @@ Currently, the following pairs of encryption modes are supported:
>  If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
>
>  AES-128-CBC was added only for low-powered embedded devices with
> -crypto accelerators such as CAAM or CESA that do not support XTS.
> +crypto accelerators such as CAAM or CESA that do not support XTS.  To
> +use AES-128-CBC, CONFIG_CRYPTO_SHA256 (or another SHA-256
> +implementation) must be enabled so that ESSIV can be used.
>
>  Adiantum is a (primarily) stream cipher-based mode that is fast even
>  on CPUs without dedicated crypto instructions.  It's also a true
> diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> index 24ed99e2eca0b2..5fdf24877c1785 100644
> --- a/fs/crypto/Kconfig
> +++ b/fs/crypto/Kconfig
> @@ -7,7 +7,6 @@ config FS_ENCRYPTION
>         select CRYPTO_ECB
>         select CRYPTO_XTS
>         select CRYPTO_CTS
> -       select CRYPTO_SHA256
>         select KEYS
>         help
>           Enable encryption of files and directories.  This
> --
> 2.22.0.410.gd8fdbe21b5-goog
>
