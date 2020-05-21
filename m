Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B761DD195
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 May 2020 17:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730360AbgEUPYk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 May 2020 11:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730345AbgEUPYi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 May 2020 11:24:38 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF39C061A0F
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 May 2020 08:24:38 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id y22so7594924qki.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 May 2020 08:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kZ7G2y8/K7TvY0Nc6cqQK/KBDtKC5mdXXfGFyP4D5uE=;
        b=vYrX2pnIMtb5KOXTLsCzghiA5bFanhc49OCGd7GfxClWLMYwDu5jG0+qihJ1aLuEWJ
         K2vlXGh2Fb0pjCUifsIiVXvqv6lRUQt53y6FvgcKN+UQukBx2+Lh6GUMDzlzY2WkMwho
         Ezrsk6TKu60FRkORPBvfmwKMtN7hurvW47CKIQz4c8hlQ9FzrQ11BX3ZqLChcpGPYyZo
         YDU2Uzfbi3C9fMMXCcFyERuxxRaqWPtqbkxyqXwWqKMZixrXICcT5aVL0d0oyhWVnyND
         LHv+ql8C79RbH/2fJidTDrtCfizHEdCQyCI6hxUzklnjHg08+WbsQ20cVMrLXoeRrVtD
         dTaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kZ7G2y8/K7TvY0Nc6cqQK/KBDtKC5mdXXfGFyP4D5uE=;
        b=UGknVmfIsMNPs/hHKekWeIIbO0E2rGpoks1nW5LOr4jngx48gKn7d3MKAsK20/kFTk
         Vq4ZFC+ayLyVtTRsUrlpqxxYDsRQ7Ki1Yf8lYHH64Xi4N+54zWwd02oSTQKHa1CucfrU
         27mAtwik7MW5PZMN9RLwAfnVGp58m1JmlpLEcvd3Wwt6iId7QqUbgwBBCzDQxinO6pZS
         J8MEOjxdZEkmpRw2M1MzWLzo4mlBztt3u/IYyAOdbcZLqovhPv66qgiZL9TgM5nK6bKd
         rrD5to1F3VF79J4ELMk2vOxvfrwf/DViXaM0MVpZz54s4vgMOBockBBn+7349re25qPd
         1Bug==
X-Gm-Message-State: AOAM531kej8dis6dP3/NE5ww/gXMXfAJ6O7NT+7RImiAiPgLDRFwQ6lO
        lWORmO0dzHIhP2CrNgxW53E35ZUo
X-Google-Smtp-Source: ABdhPJwUqQfsn7SU0dKe76ru2/3CmGnrzzKe2l2LSg7V5iljXQYId+EeHBDYCp5CsS+8Efl6q4m1kQ==
X-Received: by 2002:a05:620a:a12:: with SMTP id i18mr9690005qka.316.1590074676984;
        Thu, 21 May 2020 08:24:36 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d9::10af? ([2620:10d:c091:480::1:2725])
        by smtp.gmail.com with ESMTPSA id m14sm5194691qtq.11.2020.05.21.08.24.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 08:24:35 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 2/3] Introduce libfsverity
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc:     jsorensen@fb.com, kernel-team@fb.com
References: <20200515041042.267966-1-ebiggers@kernel.org>
 <20200515041042.267966-3-ebiggers@kernel.org>
Message-ID: <5818763c-f8e0-f5d3-d054-4818f3c4b2b3@gmail.com>
Date:   Thu, 21 May 2020 11:24:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200515041042.267966-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 5/15/20 12:10 AM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> From the 'fsverity' program, split out a library 'libfsverity'.
> Currently it supports computing file measurements ("digests"), and
> signing those file measurements for use with the fs-verity builtin
> signature verification feature.
> 
> Rewritten from patches by Jes Sorensen <jsorensen@fb.com>.
> I made a lot of improvements, e.g.:
> 
> - Separated library and program source into different directories.
> - Drastically improved the Makefile.
> - Added 'make check' target and rules to build test programs.
> - In the shared lib, only export the functions intended to be public.
> - Prefixed global functions with "libfsverity_" so that they don't cause
>   conflicts when the library is built as a static library.
> - Made library error messages be sent to a user-specified callback
>   rather than always be printed to stderr.
> - Keep showing OpenSSL error messages.
> - Stopped abort()ing in library code, when possible.
> - Made libfsverity_digest use native endianness.
> - Moved file_size into the merkle_tree_params.
> - Made libfsverity_hash_name() just return the static strings.
> - Made some variables in the API uint32_t instead of uint16_t.
> - Shared parse_hash_alg_option() between cmd_enable and cmd_sign.
> - Lots of fixes.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Eric,

Here is a more detailed review. The code as we have it seems to work for
me, but there are some issues that I think would be right to address:

I appreciate that you improved the error return values from the original
true/false/assert handling.

As much as I hate typedefs, I also like the introduction of
libfsverity_read_fn_t as function pointers are somewhat annoying to deal
with.

My biggest objection is the export of kernel datatypes to userland and I
really don't think using u32/u16/u8 internally in the library adds any
value. I had explicitly converted it to uint32_t/uint16_t/uint8_t in my
version.

max() defined in common/utils.h is not used by anything, so lets get rid
of it.

I also wonder if we should introduce an
libfsverity_get_digest_size(alg_nr) function? It would be useful for a
caller trying to allocate buffers to store them in, to be able to do
this prior to calculating the first digest.

> diff --git a/lib/compute_digest.c b/lib/compute_digest.c
> index b279d63..13998bb 100644
> --- a/lib/compute_digest.c
> +++ b/lib/compute_digest.c
> @@ -1,13 +1,13 @@
... snip ...
> -const struct fsverity_hash_alg *find_hash_alg_by_name(const char *name)
> +LIBEXPORT u32
> +libfsverity_find_hash_alg_by_name(const char *name)

This export of u32 here is problematic.

> diff --git a/lib/sign_digest.c b/lib/sign_digest.c
> index d2b0d53..d856392 100644
> --- a/lib/sign_digest.c
> +++ b/lib/sign_digest.c
> @@ -1,45 +1,68 @@
>  // SPDX-License-Identifier: GPL-2.0+
>  /*
> - * sign_digest.c
> + * Implementation of libfsverity_sign_digest().
>   *
>   * Copyright (C) 2018 Google LLC
> + * Copyright (C) 2020 Facebook
>   */
>  
> -#include "hash_algs.h"
> -#include "sign.h"
> +#include "lib_private.h"
>  
>  #include <limits.h>
>  #include <openssl/bio.h>
>  #include <openssl/err.h>
>  #include <openssl/pem.h>
>  #include <openssl/pkcs7.h>
> +#include <string.h>
> +
> +/*
> + * Format in which verity file measurements are signed.  This is the same as
> + * 'struct fsverity_digest', except here some magic bytes are prepended to
> + * provide some context about what is being signed in case the same key is used
> + * for non-fsverity purposes, and here the fields have fixed endianness.
> + */
> +struct fsverity_signed_digest {
> +	char magic[8];			/* must be "FSVerity" */
> +	__le16 digest_algorithm;
> +	__le16 digest_size;
> +	__u8 digest[];
> +};

I don't really understand why you prefer to manage two versions of the
digest, ie. libfsverity_digest and libfsverity_signed_digest, but it's
not a big deal.

> diff --git a/lib/utils.c b/lib/utils.c
> new file mode 100644
> index 0000000..0684526
> --- /dev/null
> +++ b/lib/utils.c
> @@ -0,0 +1,107 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Utility functions for libfsverity
> + *
> + * Copyright 2020 Google LLC
> + */
> +
> +#define _GNU_SOURCE /* for asprintf() */
> +
> +#include "lib_private.h"
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +static void *xmalloc(size_t size)
> +{
> +	void *p = malloc(size);
> +
> +	if (!p)
> +		libfsverity_error_msg("out of memory");
> +	return p;
> +}
> +
> +void *libfsverity_zalloc(size_t size)
> +{
> +	void *p = xmalloc(size);
> +
> +	if (!p)
> +		return NULL;
> +	return memset(p, 0, size);
> +}

I suggest we get rid of xmalloc() and libfsverity_zalloc(). libc
provides perfectly good malloc() and calloc() functions, and printing an
out of memory error in a generic location doesn't tell us where the
error happened. If anything those error messages should be printed by
the calling function IMO.

Reviewed-by: Jes Sorensen <jsorensen@fb.com>

Cheers,
Jes
