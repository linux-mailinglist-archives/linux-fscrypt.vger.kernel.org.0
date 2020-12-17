Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91D42DD930
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 20:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgLQTMv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 14:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgLQTMu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 14:12:50 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D624C0617B0
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 11:12:10 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id k10so6508121wmi.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 11:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=UZdruXXtVNIF6bIVU0quqnFu+xIzAgNftaDhLkdNw9Y=;
        b=CSVZJz2kMr3hUi5y/PW2Io9il0PfzKaQDKht7Z567YV3teBGvfAOuvlgEfH0gq3DS4
         KzaPw3fm3T8+kq40We6VxRrEaETzfBsjut7tXKEK+I/uLqUsixnw4TyGQhek+mPc8bKf
         oqc9VMSjwrcOwuh3gd3bu5hJoag9vqjNdndLTMor9g/rLaNmG20JQSn82yi9zUxiUiRj
         klOM5lid4THRZ7mHh8Ehs2vV/apFfR5kpyj4jaOZfnt1OFP74e1rbNxWO5slwFjdQzxp
         DwMwGxvXrwpKaR0gm/p3SXdu1t+94pcM3kKcqgIAhuhAko2GyS/ooQwiz/RR6pKmxxei
         H2OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=UZdruXXtVNIF6bIVU0quqnFu+xIzAgNftaDhLkdNw9Y=;
        b=ZIjAoRovsgZPtG1oaiKOUzZVVdrRtB2VUOwHXlPDuXoHbgterIlasuWcMa9VfD/b5i
         EMZs/qu5hZ6nIIZCiXccUo7eX6bkDAT6auIN7wGRQsqVjU99+gIbreKpho3o5qnFJsr+
         jNB20TWn4JRAwY/7K77FJ9gLuLyTWt58xRrOe4rg0Pm/25N+FqU3n4o8fUnQYg+Z4Zl+
         s2Y2cEmV6ud93J1Yrf4JlvdXmusPEYE+26+jqqOmZ2b9NwOUjuBYjqnT4n2duMEe/EnO
         zCHS0xzIO3g3tJ43299X8wYgQmqMQaWRnOVgoFn0BbdVSYbu6SKrku8ntDZrkjUPIfqV
         Z0+A==
X-Gm-Message-State: AOAM5334AG7iNtmoyinNN4AheJjL0KMSVTSfgy8wsJ8GA/gldIiKCYUE
        nTxPcxbSehjiY2t5MgRDJ/M=
X-Google-Smtp-Source: ABdhPJztY5R6rFcsL6eDjlqcO/37+9Eo0RGAnwFGFBvJZ24zz0iqQERbaYVECaqOR304PvNPue0JHA==
X-Received: by 2002:a1c:9ccd:: with SMTP id f196mr815212wme.82.1608232328712;
        Thu, 17 Dec 2020 11:12:08 -0800 (PST)
Received: from bluca-lenovo ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id a65sm9241812wmc.35.2020.12.17.11.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 11:12:07 -0800 (PST)
Message-ID: <73c70f8bcb6632ab3e161d9b0263bc1563e96b34.camel@gmail.com>
Subject: Re: [fsverity-utils PATCH v2 2/2] Allow to build and run
 sign/digest on Windows
From:   Luca Boccassi <luca.boccassi@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Date:   Thu, 17 Dec 2020 19:12:06 +0000
In-Reply-To: <X9ur8imAGcnv7Xx6@sol.localdomain>
References: <20201217144749.647533-1-luca.boccassi@gmail.com>
         <20201217144749.647533-2-luca.boccassi@gmail.com>
         <X9ukTy5iKB4FfFqc@sol.localdomain>
         <695452fd56e71621a612dcdce8d203964bb64d0f.camel@gmail.com>
         <X9ur8imAGcnv7Xx6@sol.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-LU+6qOabVOP94wuyhkZ1"
User-Agent: Evolution 3.30.5-1.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--=-LU+6qOabVOP94wuyhkZ1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-12-17 at 11:05 -0800, Eric Biggers wrote:
> On Thu, Dec 17, 2020 at 06:44:38PM +0000, Luca Boccassi wrote:
> > On Thu, 2020-12-17 at 10:32 -0800, Eric Biggers wrote:
> > > On Thu, Dec 17, 2020 at 02:47:49PM +0000, luca.boccassi@gmail.com wro=
te:
> > > > From: Luca Boccassi <luca.boccassi@microsoft.com>
> > > >=20
> > > > Add some minimal compat type defs, and stub out the enable/measure
> > > > sources. Also add a way to handle the fact that mingw adds a
> > > > .exe extension automatically in the Makefile install rules, and
> > > > that there is not pkg-config and the libcrypto linker flag is
> > > > different.
> > > >=20
> > > > Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> > > > ---
> > > > v2: rework the stubbing out to detect mingw in the Makefile and rem=
ove
> > > >     sources from compilation, instead of ifdefs.
> > > >     add a new common/win32_defs.h for the compat definitions.
> > > >     define strerror_r using strerror_s.
> > > >=20
> > > >     To compile with mingw:
> > > >       make CC=3Dx86_64-w64-mingw32-gcc-8.3-win32
> > > >     note that the openssl headers and a win32 libcrypto.dll need
> > > >     to be available in the default search paths, and otherwise have
> > > >     to be specified as expected via CPPFLAGS/LDFLAGS
> > > >=20
> > >=20
> > > I got some warnings and an error when compiling:
> > >=20
> > > $ make CC=3Dx86_64-w64-mingw32-gcc
> > >   CC       lib/compute_digest.o
> > >   CC       lib/hash_algs.o
> > >   CC       lib/sign_digest.o
> > >   CC       lib/utils.o
> > > lib/utils.c: In function =E2=80=98xmalloc=E2=80=99:
> > > lib/utils.c:25:25: warning: unknown conversion type character =E2=80=
=98l=E2=80=99 in format [-Wformat=3D]
> > >    25 |   libfsverity_error_msg("out of memory (tried to allocate %" =
SIZET_PF " bytes)",
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > In file included from lib/../common/win32_defs.h:24,
> > >                  from lib/../common/common_defs.h:18,
> > >                  from lib/lib_private.h:15,
> > >                  from lib/utils.c:14:
> > > /usr/x86_64-w64-mingw32/include/inttypes.h:36:18: note: format string=
 is defined here
> > >    36 | #define PRIu64 "llu"
> > >       |                  ^
> > > lib/utils.c:25:25: warning: too many arguments for format [-Wformat-e=
xtra-args]
> > >    25 |   libfsverity_error_msg("out of memory (tried to allocate %" =
SIZET_PF " bytes)",
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >   AR       libfsverity.a
> > >   CC       lib/compute_digest.shlib.o
> > >   CC       lib/hash_algs.shlib.o
> > >   CC       lib/sign_digest.shlib.o
> > >   CC       lib/utils.shlib.o
> > > lib/utils.c: In function =E2=80=98xmalloc=E2=80=99:
> > > lib/utils.c:25:25: warning: unknown conversion type character =E2=80=
=98l=E2=80=99 in format [-Wformat=3D]
> > >    25 |   libfsverity_error_msg("out of memory (tried to allocate %" =
SIZET_PF " bytes)",
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > In file included from lib/../common/win32_defs.h:24,
> > >                  from lib/../common/common_defs.h:18,
> > >                  from lib/lib_private.h:15,
> > >                  from lib/utils.c:14:
> > > /usr/x86_64-w64-mingw32/include/inttypes.h:36:18: note: format string=
 is defined here
> > >    36 | #define PRIu64 "llu"
> > >       |                  ^
> > > lib/utils.c:25:25: warning: too many arguments for format [-Wformat-e=
xtra-args]
> > >    25 |   libfsverity_error_msg("out of memory (tried to allocate %" =
SIZET_PF " bytes)",
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >   CCLD     libfsverity.so.0
> > > /usr/lib/gcc/x86_64-w64-mingw32/10.2.0/../../../../x86_64-w64-mingw32=
/bin/ld: cannot find -l:libcrypto.dll
> > > collect2: error: ld returned 1 exit status
> > > make: *** [Makefile:137: libfsverity.so.0] Error 1
> > >=20
> > >=20
> > >=20
> > > This is on Arch Linux with mingw-w64-gcc and mingw-w64-openssl instal=
led.
> > >=20
> > > So there's something wrong with the SIZET_PF format string, and also
> > > -l:libcrypto.dll isn't correct; it should be just -lcrypto like it is=
 on Linux.
> > > (MinGW knows to look for a .dll file.)
> > >=20
> > > - Eric
> >=20
> > Mmh I don't get any warnings on Debian - gcc-mingw-w64-x86-64 8.3.0-
> > 6+21.3~deb10u1 - any idea how to fix it?
> >=20
> > And on -lcrypto, it didn't use to work before the refactor - but now it
> > does. I have no clue what was happening. Will change it back in v3.
> >=20
>=20
> Apparently the definition of _GNU_SOURCE in lib/utils.c changes the print=
f
> implementation that is used from Microsoft's to MinGW's, but the use of
> __attribute__((format(printf))) is generating warnings assuming that Micr=
osoft's
> printf implementation is used.  Always defining _GNU_SOURCE and then usin=
g
> __attribute__((format(gnu_printf))) might be the way to go:
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
> index e13938a..4edb17f 100644
> --- a/common/win32_defs.h
> +++ b/common/win32_defs.h
> @@ -37,6 +37,11 @@
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
> diff --git a/lib/utils.c b/lib/utils.c
> index 8bb4413..55a4045 100644
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

I get the following warning with the mingw build now:

lib/utils.c: In function =E2=80=98xmalloc=E2=80=99:
lib/utils.c:23:25: warning: format =E2=80=98%u=E2=80=99 expects argument of=
 type =E2=80=98unsigned int=E2=80=99, but argument 2 has type =E2=80=98size=
_t=E2=80=99 {aka =E2=80=98long long unsigned int=E2=80=99} [-Wformat=3D]
   libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " by=
tes)",
                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           size);
           ~~~~          =20
In file included from lib/../common/win32_defs.h:24,
                 from lib/../common/common_defs.h:18,
                 from lib/lib_private.h:15,
                 from lib/utils.c:12:
/usr/share/mingw-w64/include/inttypes.h:94:20: note: format string is defin=
ed here
 #define PRIu64 "I64u"
  AR       libfsverity.a
  CC       lib/sign_digest.shlib.o
  CC       lib/compute_digest.shlib.o
  CC       lib/hash_algs.shlib.o
  CC       lib/utils.shlib.o
lib/utils.c: In function =E2=80=98xmalloc=E2=80=99:
lib/utils.c:23:25: warning: format =E2=80=98%u=E2=80=99 expects argument of=
 type =E2=80=98unsigned int=E2=80=99, but argument 2 has type =E2=80=98size=
_t=E2=80=99 {aka =E2=80=98long long unsigned int=E2=80=99} [-Wformat=3D]
   libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " by=
tes)",
                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           size);
           ~~~~          =20
In file included from lib/../common/win32_defs.h:24,
                 from lib/../common/common_defs.h:18,
                 from lib/lib_private.h:15,
                 from lib/utils.c:12:
/usr/share/mingw-w64/include/inttypes.h:94:20: note: format string is defin=
ed here
 #define PRIu64 "I64u"


But, honestly, it seems harmless to me. If someone on Windows is trying
to get a digest and don't have memory to do it, they'll have bigger
problems to worry about than knowing how much it was requested. I'll
send a v3 with your suggested changes. As far as I can read online,
handling %zu in a cross compatible way is like the number one
annoyance.

--=20
Kind regards,
Luca Boccassi

--=-LU+6qOabVOP94wuyhkZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl/brYYACgkQSylmgFB4
UWJ61Qf9E6E4UKD5UJz9b2c6+Usfvd2E9JAGb9O9l3CEdoXSLlzGB6Sm0UrhtcMb
oDP9M9VxZ2RZB86FzFlHMscgzeHNojdoeiRkGsBz86ITGQ6sEWIinsLZ0FlnRcA6
QVKhexEB1dVVI3w3yPIaCT+Gb8GDcCw3G0c53jF8EJkXQSI04mWcK/RZfC8+x5fx
nK1og4sfMGYv1PY5MTPIA+V99VlRdvcOte435pzRM7rhAwW+t82cD8HjyH7FwD7I
Nb+YIhriXsKnU898qIUVKpJHkBlIwCd1R0aJohN+N8O2GD2wl1cKkXdpjbeRqbpR
45tMw9Vtst74dlOBjgwrJN8tU0sYIw==
=6fsl
-----END PGP SIGNATURE-----

--=-LU+6qOabVOP94wuyhkZ1--

