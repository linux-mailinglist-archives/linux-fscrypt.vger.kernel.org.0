Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715D62DD951
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 20:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgLQT0u (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 14:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgLQT0u (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 14:26:50 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F29BC0617A7
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 11:26:09 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id m5so27697449wrx.9
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 11:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=+t2SQJS4yOiq2+SYnYOHtL3moiWpoaDPBnQEVhLP7yo=;
        b=kWZj4saVnYxjy1A7FCFCQnogsU1Dc0tFCmztNEGak7Fiy7aNtxtv8WYwnRkFqyofRR
         nt5VhlkvUIJ3cfV9DQLhuJgfyKbdvOwHi4pmM9CQurPrzFXnM3p+nm7FPBL7MaivO1M6
         Tv/+fRnj6xIXKOQCsI4xQM433jdauyrXaMVfWoBc3nYMqgW9U6D6KltpFK9NBYJVkrnW
         AmQrH5h9At2THG2vQj5TsdoNsbLS4T85nl8Nr0N/09TJCeSeAmelAX6Uz1/TO90pJ8E0
         4f+kcWcJW1DdRCk7vJ3Wowy4aW+Tzby7+J+jfPAIm1t4FIc7/qo5fgY9v246MOemq+qB
         1DXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=+t2SQJS4yOiq2+SYnYOHtL3moiWpoaDPBnQEVhLP7yo=;
        b=jY3ab0mOirAN8h5Tv5WD6i4pbk15uWKGy1W0CL5epLkyqJS8yxvvZAWQNqWNOqgvNQ
         U9D9Fa7wZh1p1ct1dC4A7cFFMUo7r+OBeEE2aftqVm0k6UVNraz+HbW8mYmUkrnngsVl
         OFzWLMWPA7qkjWE/WcVdrwpa8QpsVVvCzZmW7xRgbLYSfHGpSEjJ4RajfTP9nPYgBt7+
         95YUIGj4ICx8TaSq+TMsgHw4qEPU/yXPJBqfqcZo5SRxPNIcgjhOeUSnuIcWYSIlTYkN
         Hqx6MVErZ7zDQ/wEcmK8xexw/QqFMPEFs0wV28iv+k5hZcVIBPzkclKqa6UoqDcpf+O0
         ZORQ==
X-Gm-Message-State: AOAM5335sWXjZTxsnN+R9w8cpVOt7L3OaYObdIVwgsc1fi4J2ytEIIh3
        AjBqmEV+4c67X6i6vBomSeTq/hVBUiuGUw==
X-Google-Smtp-Source: ABdhPJwu58m3bYEx/ey7ykyPVKUsrUFcyEsMohVs0zLnSYWsc0uI6qxXmn5ceCf2Cy4P+RW6U2UoAg==
X-Received: by 2002:adf:8b0d:: with SMTP id n13mr338222wra.57.1608233168408;
        Thu, 17 Dec 2020 11:26:08 -0800 (PST)
Received: from bluca-lenovo ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id a62sm11482018wmh.40.2020.12.17.11.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 11:26:07 -0800 (PST)
Message-ID: <296198ac09755fca1a306f3cf35971d3b6fbc613.camel@gmail.com>
Subject: Re: [fsverity-utils PATCH v2 2/2] Allow to build and run
 sign/digest on Windows
From:   Luca Boccassi <luca.boccassi@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Date:   Thu, 17 Dec 2020 19:26:06 +0000
In-Reply-To: <X9uvac1VKpuvZ68B@sol.localdomain>
References: <20201217144749.647533-1-luca.boccassi@gmail.com>
         <20201217144749.647533-2-luca.boccassi@gmail.com>
         <X9ukTy5iKB4FfFqc@sol.localdomain>
         <695452fd56e71621a612dcdce8d203964bb64d0f.camel@gmail.com>
         <X9ur8imAGcnv7Xx6@sol.localdomain>
         <73c70f8bcb6632ab3e161d9b0263bc1563e96b34.camel@gmail.com>
         <X9uvac1VKpuvZ68B@sol.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-VO+HMvyvaOOxj1xLt0II"
User-Agent: Evolution 3.30.5-1.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--=-VO+HMvyvaOOxj1xLt0II
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-12-17 at 11:20 -0800, Eric Biggers wrote:
> On Thu, Dec 17, 2020 at 07:12:06PM +0000, Luca Boccassi wrote:
> > I get the following warning with the mingw build now:
> >=20
> > lib/utils.c: In function =E2=80=98xmalloc=E2=80=99:
> > lib/utils.c:23:25: warning: format =E2=80=98%u=E2=80=99 expects argumen=
t of type =E2=80=98unsigned int=E2=80=99, but argument 2 has type =E2=80=98=
size_t=E2=80=99 {aka =E2=80=98long long unsigned int=E2=80=99} [-Wformat=3D=
]
> >    libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF =
" bytes)",
> >                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >            size);
> >            ~~~~          =20
> > In file included from lib/../common/win32_defs.h:24,
> >                  from lib/../common/common_defs.h:18,
> >                  from lib/lib_private.h:15,
> >                  from lib/utils.c:12:
> > /usr/share/mingw-w64/include/inttypes.h:94:20: note: format string is d=
efined here
> >  #define PRIu64 "I64u"
> >   AR       libfsverity.a
> >   CC       lib/sign_digest.shlib.o
> >   CC       lib/compute_digest.shlib.o
> >   CC       lib/hash_algs.shlib.o
> >   CC       lib/utils.shlib.o
> > lib/utils.c: In function =E2=80=98xmalloc=E2=80=99:
> > lib/utils.c:23:25: warning: format =E2=80=98%u=E2=80=99 expects argumen=
t of type =E2=80=98unsigned int=E2=80=99, but argument 2 has type =E2=80=98=
size_t=E2=80=99 {aka =E2=80=98long long unsigned int=E2=80=99} [-Wformat=3D=
]
> >    libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF =
" bytes)",
> >                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >            size);
> >            ~~~~          =20
> > In file included from lib/../common/win32_defs.h:24,
> >                  from lib/../common/common_defs.h:18,
> >                  from lib/lib_private.h:15,
> >                  from lib/utils.c:12:
> > /usr/share/mingw-w64/include/inttypes.h:94:20: note: format string is d=
efined here
> >  #define PRIu64 "I64u"
> >=20
> >=20
> > But, honestly, it seems harmless to me. If someone on Windows is trying
> > to get a digest and don't have memory to do it, they'll have bigger
> > problems to worry about than knowing how much it was requested. I'll
> > send a v3 with your suggested changes. As far as I can read online,
> > handling %zu in a cross compatible way is like the number one
> > annoyance.
> >=20
>=20
> It needs to compile without warnings, otherwise new warnings won't be not=
iced.
>=20
> I think that if the MinGW printf is used (by defining _GNU_SOURCE), then =
%zu
> would just work as-is.  That's what I do in another project.  Try:
>=20
> diff --git a/Makefile b/Makefile
> index cc62818..44aee92 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -52,7 +52,7 @@ override CFLAGS :=3D -Wall -Wundef				\
>  	$(call cc-option,-Wvla)					\
>  	$(CFLAGS)
> =20
> -override CPPFLAGS :=3D -Iinclude -D_FILE_OFFSET_BITS=3D64 $(CPPFLAGS)
> +override CPPFLAGS :=3D -Iinclude -D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE =
$(CPPFLAGS)
> =20
>  ifneq ($(V),1)
>  QUIET_CC        =3D @echo '  CC      ' $@;
> diff --git a/common/win32_defs.h b/common/win32_defs.h
> index e13938a..3b0d908 100644
> --- a/common/win32_defs.h
> +++ b/common/win32_defs.h
> @@ -23,12 +23,6 @@
>  #include <stdint.h>
>  #include <inttypes.h>
> =20
> -#ifdef _WIN64
> -#  define SIZET_PF PRIu64
> -#else
> -#  define SIZET_PF PRIu32
> -#endif
> -
>  #ifndef ENOPKG
>  #   define ENOPKG 65
>  #endif
> @@ -37,6 +31,11 @@
>  #  define __cold
>  #endif
> =20
> +#ifndef __printf
> +#  define __printf(fmt_idx, vargs_idx) \
> +	__attribute__((format(gnu_printf, fmt_idx, vargs_idx)))
> +#endif
> +
>  typedef __signed__ char __s8;
>  typedef unsigned char __u8;
>  typedef __signed__ short __s16;
> @@ -52,10 +51,6 @@ typedef __u32 __be32;
>  typedef __u64 __le64;
>  typedef __u64 __be64;
> =20
> -#else
> -
> -#define SIZET_PF "zu"
> -
>  #endif /* _WIN32 */
> =20
>  #endif /* COMMON_WIN32_DEFS_H */
> diff --git a/lib/utils.c b/lib/utils.c
> index 8bb4413..036dd60 100644
> --- a/lib/utils.c
> +++ b/lib/utils.c
> @@ -9,8 +9,6 @@
>   * https://opensource.org/licenses/MIT.
>   */
> =20
> -#define _GNU_SOURCE /* for asprintf() and strerror_r() */
> -
>  #include "lib_private.h"
> =20
>  #include <stdio.h>
> @@ -22,7 +20,7 @@ static void *xmalloc(size_t size)
>  	void *p =3D malloc(size);
> =20
>  	if (!p)
> -		libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " =
bytes)",
> +		libfsverity_error_msg("out of memory (tried to allocate %zu bytes)",
>  				      size);
>  	return p;
>  }

That works, no more warnings, nice! Thank you! Sent v4.

--=20
Kind regards,
Luca Boccassi

--=-VO+HMvyvaOOxj1xLt0II
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl/bsM4ACgkQSylmgFB4
UWKZkQf/fe/XoW+msuVtQE+yryDrEVQvdm7vL9OUchf1JTD3LaJYspvpchlwGVmB
5mwdzqBWhNjCRCN24S3lGMwzSyK5z40UmgRBB0HvLqbQ0TKiPoeLe9g3fA9venSU
rXFPkCsxerFEQRwGyhelUltoEAYjLIwMO26Xe3REZL86cjNvF1HiDAOvOTAlANu3
jUV7ZEctXy84t7QWwY83Xvpq0HUc5oG8otrMuDG8NlMNFGoWELnZmUX6BGjZiFMo
EwAXEdBDPANzcLWXS/yurNxZ2JgsYnhEt3aXeVQOOfyM2RFxXg6r6llr2+b/kxk/
B0W0NCWUI+VaoQofYh3d+LdRYB6YJg==
=pYjX
-----END PGP SIGNATURE-----

--=-VO+HMvyvaOOxj1xLt0II--

