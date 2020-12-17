Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FADC2DD898
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 19:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgLQSpX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 13:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729069AbgLQSpW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 13:45:22 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735CDC061794
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 10:44:42 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id y23so6588051wmi.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 10:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=ggtsij1YlY87WcfaYN/B2KxE9Qy8svdZ4qK+DH2wF0o=;
        b=gnbCUICdtBHUXq4UZu2ZlZtGt2ZNWzWRbsYenLnujf1F6gCzesnhM4c4Vko+qJE6RV
         pXMzgh8WNSpEFHj6LV34KFKrScm2db408DyOtbre+f3W17iT+s7K81IbmM5ltpqNf48K
         4SNkETUO3U1lxtKaPXNB1WXVIkUgh04bwQ+X+8CEZWYupIJyiAwVrL3qc868RDhx9z4T
         Cdfl3tWAa6MdJFvXMpFXQWF0btL70AZwirm5dDL2kFrzI8kCs4o1MyqslYp1k0vVFDNj
         8u5Ck0awhrbje7do6QeLSsF0eNM+ddogKraHghmhX75N5BTsyaTFVUZ8lUXwSX9YuySg
         Kh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=ggtsij1YlY87WcfaYN/B2KxE9Qy8svdZ4qK+DH2wF0o=;
        b=m/IMDJPWGt/G9HeMCDIokSOQUihUhBR1tSgDob0ADx6L9+4euoalaCdsC6sleQqEju
         838+18lspmJ5k30loyfmdo3fQzFJn8ffPRJrAqoq1tLcEEuOKLiYmpt9ZPTK57tZsqaI
         uAb05bIbOM+FCOkIB/HUB3wSE+EW+4zAvIhcsQPQrmE9Y9QTQfgrxboJLQETlyNGMNIU
         MjyeV4tgyVQxmKM5UT68oAxQyTwhL25XbjfgqaQ8vJHWJTA97jhHDRzmC+dzu1hTPRNA
         M41ajwCUq7GDY9T54tlFEvRlW9rb60TtZzixvpevKNKFo1kb3AUJUAsYk5Y50hcCs/vq
         7+pg==
X-Gm-Message-State: AOAM533RkNO9aJ7bytptK0Md5bVcyoYr5zWNfuUYtD+/9Oo81OIDNcFX
        21P0rfzkyYbV9xry7OOBrhc=
X-Google-Smtp-Source: ABdhPJxMywBMXETFsdxVDC0M0766vE2ioTjop1oXPlbkt4o2s4xbZviguVAbYUeUl5T8nAKHGF8KsA==
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr653873wmg.145.1608230681159;
        Thu, 17 Dec 2020 10:44:41 -0800 (PST)
Received: from bluca-lenovo ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id b200sm9347920wmb.10.2020.12.17.10.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 10:44:39 -0800 (PST)
Message-ID: <695452fd56e71621a612dcdce8d203964bb64d0f.camel@gmail.com>
Subject: Re: [fsverity-utils PATCH v2 2/2] Allow to build and run
 sign/digest on Windows
From:   Luca Boccassi <luca.boccassi@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Date:   Thu, 17 Dec 2020 18:44:38 +0000
In-Reply-To: <X9ukTy5iKB4FfFqc@sol.localdomain>
References: <20201217144749.647533-1-luca.boccassi@gmail.com>
         <20201217144749.647533-2-luca.boccassi@gmail.com>
         <X9ukTy5iKB4FfFqc@sol.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-AqEocCOkZQmKnZIPN681"
User-Agent: Evolution 3.30.5-1.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--=-AqEocCOkZQmKnZIPN681
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-12-17 at 10:32 -0800, Eric Biggers wrote:
> On Thu, Dec 17, 2020 at 02:47:49PM +0000, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <luca.boccassi@microsoft.com>
> >=20
> > Add some minimal compat type defs, and stub out the enable/measure
> > sources. Also add a way to handle the fact that mingw adds a
> > .exe extension automatically in the Makefile install rules, and
> > that there is not pkg-config and the libcrypto linker flag is
> > different.
> >=20
> > Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> > ---
> > v2: rework the stubbing out to detect mingw in the Makefile and remove
> >     sources from compilation, instead of ifdefs.
> >     add a new common/win32_defs.h for the compat definitions.
> >     define strerror_r using strerror_s.
> >=20
> >     To compile with mingw:
> >       make CC=3Dx86_64-w64-mingw32-gcc-8.3-win32
> >     note that the openssl headers and a win32 libcrypto.dll need
> >     to be available in the default search paths, and otherwise have
> >     to be specified as expected via CPPFLAGS/LDFLAGS
> >=20
>=20
> I got some warnings and an error when compiling:
>=20
> $ make CC=3Dx86_64-w64-mingw32-gcc
>   CC       lib/compute_digest.o
>   CC       lib/hash_algs.o
>   CC       lib/sign_digest.o
>   CC       lib/utils.o
> lib/utils.c: In function =E2=80=98xmalloc=E2=80=99:
> lib/utils.c:25:25: warning: unknown conversion type character =E2=80=98l=
=E2=80=99 in format [-Wformat=3D]
>    25 |   libfsverity_error_msg("out of memory (tried to allocate %" SIZE=
T_PF " bytes)",
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from lib/../common/win32_defs.h:24,
>                  from lib/../common/common_defs.h:18,
>                  from lib/lib_private.h:15,
>                  from lib/utils.c:14:
> /usr/x86_64-w64-mingw32/include/inttypes.h:36:18: note: format string is =
defined here
>    36 | #define PRIu64 "llu"
>       |                  ^
> lib/utils.c:25:25: warning: too many arguments for format [-Wformat-extra=
-args]
>    25 |   libfsverity_error_msg("out of memory (tried to allocate %" SIZE=
T_PF " bytes)",
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   AR       libfsverity.a
>   CC       lib/compute_digest.shlib.o
>   CC       lib/hash_algs.shlib.o
>   CC       lib/sign_digest.shlib.o
>   CC       lib/utils.shlib.o
> lib/utils.c: In function =E2=80=98xmalloc=E2=80=99:
> lib/utils.c:25:25: warning: unknown conversion type character =E2=80=98l=
=E2=80=99 in format [-Wformat=3D]
>    25 |   libfsverity_error_msg("out of memory (tried to allocate %" SIZE=
T_PF " bytes)",
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from lib/../common/win32_defs.h:24,
>                  from lib/../common/common_defs.h:18,
>                  from lib/lib_private.h:15,
>                  from lib/utils.c:14:
> /usr/x86_64-w64-mingw32/include/inttypes.h:36:18: note: format string is =
defined here
>    36 | #define PRIu64 "llu"
>       |                  ^
> lib/utils.c:25:25: warning: too many arguments for format [-Wformat-extra=
-args]
>    25 |   libfsverity_error_msg("out of memory (tried to allocate %" SIZE=
T_PF " bytes)",
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   CCLD     libfsverity.so.0
> /usr/lib/gcc/x86_64-w64-mingw32/10.2.0/../../../../x86_64-w64-mingw32/bin=
/ld: cannot find -l:libcrypto.dll
> collect2: error: ld returned 1 exit status
> make: *** [Makefile:137: libfsverity.so.0] Error 1
>=20
>=20
>=20
> This is on Arch Linux with mingw-w64-gcc and mingw-w64-openssl installed.
>=20
> So there's something wrong with the SIZET_PF format string, and also
> -l:libcrypto.dll isn't correct; it should be just -lcrypto like it is on =
Linux.
> (MinGW knows to look for a .dll file.)
>=20
> - Eric

Mmh I don't get any warnings on Debian - gcc-mingw-w64-x86-64 8.3.0-
6+21.3~deb10u1 - any idea how to fix it?

And on -lcrypto, it didn't use to work before the refactor - but now it
does. I have no clue what was happening. Will change it back in v3.

--=20
Kind regards,
Luca Boccassi

--=-AqEocCOkZQmKnZIPN681
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl/bpxYACgkQSylmgFB4
UWIoRQgAhoZ7KM7UX5VXKgBJDeOtJFe36xhftFkFmA4nvnPxSrXB1Q0uuck+WI8q
2zmD79niSXtAOeLIQBPIm7pHMR5GSkcdxhgG3T+t/WjcnuBXZPIrPtmJZy1O2ifr
AFfRGruN3e7gT5JfJwLQNBribUAVcqt3wur9RG0c5vEDnWVZ9VdavwFINWO496oq
lTDAkZkNQWijqTH1gigYShJ+0AqZQIMB10rfmxJJFPfnvjo1AtPKsxe01bWsMuml
f66OsEXK8PkIXjJijeSY9eoXH3n+r4fkvbeEy5Zedz1C4VXy7q+jgzrNO+PWHa4y
1l7R90KHOjS7e7wcEYeEOaqlBN3q8w==
=edZn
-----END PGP SIGNATURE-----

--=-AqEocCOkZQmKnZIPN681--

