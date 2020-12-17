Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F180F2DD355
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 15:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgLQOys (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 09:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbgLQOyr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 09:54:47 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733A6C061794
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 06:54:07 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id e25so6002590wme.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 06:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=Z/jjOajFSqbs11MApycflUqf4LdeC9afGuIozaXG3Qw=;
        b=tVOuP38q1ql1VfVKfxsjayVnmFsl4kcJ8XmSu/7MVeaS7ZYFOVEjFfWid3RGBAy3QM
         /qDL5tBEfiv6PjWxrnCF05RX9B32cly0EEEQAm4UEwcGGR/sWoo1OZEiTUcNzXYIkYz2
         7FGPtg/RjRgZ6BLZIs1kBdOoFLk5NHDuDiIWMukN54e2pNWCFM6vnBaj6SrejOu/89yD
         o8vS3ciz+6wIW2RYM0s0EvwDfXfwVfeIMekZrZ7yA6OWHmmoAE9jWllmQXxVx4XlTuW2
         9oE+oXkxM9qXB3X9hUl0najII+RPPjeFwUCR6Mu/kLte2OYZ9ZqeR+0JQb14khYzMdN6
         Xamw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=Z/jjOajFSqbs11MApycflUqf4LdeC9afGuIozaXG3Qw=;
        b=eufdjbkAP9E+LUZtRCnoR0Qa1na/r6pQ20q5lrSaSPoYPtjxknfgQY9zXHbwgNq3FX
         gLzJ77dvA6gZJoY/DDuN9LXdqQ3NqL0U57TGGhgspEMb+efjjqBd+WUFWgS6uwpZYkGk
         WQK8xpt0KsM/c4ZcK/sjJHZvhFSbrynpKhPqtVTti9ET1Slou5/omGMROmkGVuUAwH+C
         FqhUVW2Kv85Ky3Xkg4Mx/qNlljEbNWcmpj9A9EiSHuXuyfjZEN73c4ioeXSylKwsff2e
         KQat4JqwTsd8fSrbJBJxWzSyID7E7NyMgooEYNjYD3BFn8JV4vE5u3y/I/OwHLFTxYXI
         WnaA==
X-Gm-Message-State: AOAM531kpCNPg6ssl6q3nUqAriPasZ4bSJ5bonzob6qcxbiQgl2sJGzo
        8Jvu9avkeb+hmAXoxAz+YHE=
X-Google-Smtp-Source: ABdhPJwozBuaipVc2Njmntc5ZJ7vr1S3c6VrzNN41MDUA0mPl7EhU5Qr+yMf3YUE660FncosQsi1gg==
X-Received: by 2002:a1c:9e86:: with SMTP id h128mr9191099wme.171.1608216845982;
        Thu, 17 Dec 2020 06:54:05 -0800 (PST)
Received: from bluca-lenovo ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id y13sm4337995wrl.63.2020.12.17.06.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 06:54:04 -0800 (PST)
Message-ID: <5791213a622ab31d102845a0b0f412dafe064bab.camel@gmail.com>
Subject: Re: [fsverity-utils PATCH 2/2] Allow to build and run sign/digest
 on Windows
From:   Luca Boccassi <luca.boccassi@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Date:   Thu, 17 Dec 2020 14:54:03 +0000
In-Reply-To: <X9pbQjFDwr/Vd0/O@sol.localdomain>
References: <20201216172719.540610-1-luca.boccassi@gmail.com>
         <20201216172719.540610-2-luca.boccassi@gmail.com>
         <X9pbQjFDwr/Vd0/O@sol.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-G++X5AcVr6P6B/DWAlPU"
User-Agent: Evolution 3.30.5-1.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--=-G++X5AcVr6P6B/DWAlPU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-12-16 at 11:08 -0800, Eric Biggers wrote:
> On Wed, Dec 16, 2020 at 05:27:19PM +0000, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <luca.boccassi@microsoft.com>
> >=20
> > Add some minimal compat type defs, and stub out the enable/measure
> > functions. Also add a way to handle the fact that mingw adds a
> > .exe extension automatically in the Makefile install rules.
> >=20
> > Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> > ---
> > So this is proably going to look strange, and believe me the feeling is=
 shared.
> > It's actually the first time _ever_ I had to compile and run something =
on
> > Windows, which is ironic in itself - the O_BINARY stuff is probably WIN=
32-101 and
> > it took me an hour to find out.
> > Anyway, I've got some groups building their payloads on Windows, so we =
need to
> > provide native tooling. Among these are fsverity tools to get the diges=
t and
> > sign files.
> > This patch stubs out and returns EOPNOTSUPP from the measure/enable fun=
ctions,
> > since they are linux-host only, and adds some (hopefully) minimal and u=
nintrusive
> > compat ifdefs for the rest. There's also a change in the makefile, sinc=
e the
> > build toolchain (yocto + mingw) for some reason automatically names exe=
cutables
> > as .exe. Biggest chunk is the types definitions I guess. The ugliest is=
 the
> > print stuff.
> >=20
> > Note that with this I do not ask you in any way, shape or form to be re=
sponsible
> > for the correct functioning or even compiling on WIN32 of these utiliti=
es - if
> > anything ever breaks, we'll find out and take care of it. I could keep =
all of this
> > out of tree, but I figured I'd try to see if you are amenable to merge =
at least
> > some part of it.
> >=20
> > I've tested that both Linux and WIN32 builds of digest and sign command=
s return
> > the exact same output for the same input.
>=20
> On Linux, can you make it easily cross-compile for Windows using
> 'make CC=3Dx86_64-w64-mingw32-gcc'?  That would be ideal, so that that co=
mmand can
> be added to scripts/run-tests.sh, so that I can make sure it stays buildi=
ng.
>=20
> I probably won't actually test *running* it on Windows, as that would be =
more
> work.  But building should be easy.

Yes, that's how I've been compiling it - with the addition to find the
openssl library and headers, as it seems on Debian mingw32-gcc doesn't
define any system paths. Ie:

make CC=3Dx86_64-w64-mingw32-gcc-8.3-win32 CPPFLAGS=3D"-I /tmp/win" LDFLAGS=
=3D"-L/tmp/win"

If libcrypto.dll and include/openssl are visible to mingw32-gcc out of
the box, then CC is the only thing you should need.

> > diff --git a/Makefile b/Makefile
> > index bfe83c4..fe89e18 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -63,6 +63,7 @@ INCDIR          ?=3D $(PREFIX)/include
> >  LIBDIR          ?=3D $(PREFIX)/lib
> >  DESTDIR         ?=3D
> >  PKGCONF         ?=3D pkg-config
> > +EXEEXT          ?=3D
>=20
> It looks like you're requiring the caller to manually specify EXEEXT.  Yo=
u could
> use something like the following to automatically detect when CC is MinGW=
 and
> set EXEEXT and AR appropriately:
>=20
> # Compiling for Windows with MinGW?
> ifneq ($(findstring -mingw,$(shell $(CC) -dumpmachine 2>/dev/null)),)
> 	EXEEXT :=3D .exe
> 	# Derive $(AR) from $(CC).
> 	AR :=3D $(shell echo $(CC) | \
>                 sed -E 's/g?cc(-?[0-9]+(\.[0-9]+)*)?(\.exe)?$$/ar\3/')
> endif

Done in v2, without overriding AR - it seems to work as-is.

> >  # Rebuild if a user-specified setting that affects the build changed.
> >  .build-config: FORCE
> > @@ -87,9 +88,9 @@ CFLAGS          +=3D $(shell "$(PKGCONF)" libcrypto -=
-cflags 2>/dev/null || echo)
> >  # If we are dynamically linking, when running tests we need to overrid=
e
> >  # LD_LIBRARY_PATH as no RPATH is set
> >  ifdef USE_SHARED_LIB
> > -RUN_FSVERITY    =3D LD_LIBRARY_PATH=3D./ ./fsverity
> > +RUN_FSVERITY    =3D LD_LIBRARY_PATH=3D./ ./fsverity$(EXEEXT)
> >  else
> > -RUN_FSVERITY    =3D ./fsverity
> > +RUN_FSVERITY    =3D ./fsverity$(EXEEXT)
> >  endif
> > =20
> >  ######################################################################=
########
> > @@ -186,7 +187,7 @@ test_programs:$(TEST_PROGRAMS)
> >  # want to run the full tests.
> >  check:fsverity test_programs
> >  	for prog in $(TEST_PROGRAMS); do \
> > -		$(TEST_WRAPPER_PROG) ./$$prog || exit 1; \
> > +		$(TEST_WRAPPER_PROG) ./$$prog$(EXEEXT) || exit 1; \
> >  	done
> >  	$(RUN_FSVERITY) --help > /dev/null
> >  	$(RUN_FSVERITY) --version > /dev/null
> > @@ -202,7 +203,7 @@ check:fsverity test_programs
> > =20
> >  install:all
> >  	install -d $(DESTDIR)$(LIBDIR)/pkgconfig $(DESTDIR)$(INCDIR) $(DESTDI=
R)$(BINDIR)
> > -	install -m755 fsverity $(DESTDIR)$(BINDIR)
> > +	install -m755 fsverity$(EXEEXT) $(DESTDIR)$(BINDIR)
> >  	install -m644 libfsverity.a $(DESTDIR)$(LIBDIR)
> >  	install -m755 libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)
> >  	ln -sf libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)/libfsverity.so
> > @@ -215,7 +216,7 @@ install:all
> >  	chmod 644 $(DESTDIR)$(LIBDIR)/pkgconfig/libfsverity.pc
> > =20
> >  uninstall:
> > -	rm -f $(DESTDIR)$(BINDIR)/fsverity
> > +	rm -f $(DESTDIR)$(BINDIR)/fsverity$(EXEEXT)
> >  	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.a
> >  	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so.$(SOVERSION)
> >  	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so
> > @@ -232,4 +233,4 @@ help:
> > =20
> >  clean:
> >  	rm -f $(DEFAULT_TARGETS) $(TEST_PROGRAMS) \
> > -		lib/*.o programs/*.o .build-config fsverity.sig
> > +		fsverity$(EXEEXT) lib/*.o programs/*.o .build-config fsverity.sig
>=20
> Do you need libfsverity to be built properly for Windows (producing .dll,=
 .lib,
> and .def files), or are you just looking to build the fsverity binary?  A=
t the
> moment you're just doing the latter.  There are a bunch of differences be=
tween
> libraries on Windows and Linux, so hopefully you don't need the library b=
uilt
> properly for Windows, but it would be possible.

I do not need the library at the moment no, I just need the binary.

> > diff --git a/common/common_defs.h b/common/common_defs.h
> > index 279385a..a869532 100644
> > --- a/common/common_defs.h
> > +++ b/common/common_defs.h
> > @@ -15,6 +15,30 @@
> >  #include <stddef.h>
> >  #include <stdint.h>
> > =20
> > +#ifdef _WIN32
> > +/* Some minimal definitions to allow the digest/sign commands to run u=
nder Windows */
> > +#  ifndef ENOPKG
> > +#    define ENOPKG 65
> > +#  endif
> > +#  ifndef __cold
> > +#    define __cold
> > +#  endif
> > +typedef __signed__ char __s8;
> > +typedef unsigned char __u8;
> > +typedef __signed__ short __s16;
> > +typedef unsigned short __u16;
> > +typedef __signed__ int __s32;
> > +typedef unsigned int __u32;
> > +typedef __signed__ long long  __s64;
> > +typedef unsigned long long  __u64;
> > +typedef __u16 __le16;
> > +typedef __u16 __be16;
> > +typedef __u32 __le32;
> > +typedef __u32 __be32;
> > +typedef __u64 __le64;
> > +typedef __u64 __be64;
> > +#endif /* _WIN32 */
> > +
> >  typedef uint8_t u8;
> >  typedef uint16_t u16;
> >  typedef uint32_t u32;
>=20
> Could you put most of the Windows compatibility definitions in a single n=
ew
> header so that they don't clutter things up too much?
>=20
> Including for things you put in other places, like O_BINARY.

Added common/win32_defs.h in v2

> > diff --git a/lib/enable.c b/lib/enable.c
> > index 2478077..b49ba26 100644
> > --- a/lib/enable.c
> > +++ b/lib/enable.c
> > @@ -11,14 +11,10 @@
> > =20
> >  #include "lib_private.h"
> > =20
> > +#ifndef _WIN32
> > +
>=20
> Could you just have the Makefile exclude files from the build instead?
>=20
> 	lib/enable.c
> 	programs/cmd_measure.c
> 	programs/cmd_enable.c
>=20
> Then in programs/fsverity.c, ifdef out the 'measure' and 'enable' command=
s in
> fsverity_commands[].
>=20
> I think that would be easier.  Plus users won't get weird errors if they =
try to
> use unsupported commands on Windows; the commands just won't be available=
.

Done in v2

> > +#ifndef _WIN32
> >  		if (asprintf(&msg2, "%s: %s", msg,
> >  			     strerror_r(err, errbuf, sizeof(errbuf))) < 0)
> > +#else
> > +		strerror_s(errbuf, sizeof(errbuf), err);
> > +		if (asprintf(&msg2, "%s: %s", msg, errbuf) < 0)
> > +#endif
> >  			goto out2;
>=20
> Instead of doing this, could you provide a strerror_r() implementation in
> programs/utils.c for _WIN32?

Added in v2.

Thanks for the review!

--=20
Kind regards,
Luca Boccassi

--=-G++X5AcVr6P6B/DWAlPU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl/bcQsACgkQSylmgFB4
UWKhLAf7BNk+PCjjEhtC6PyUxBtF+UGVjBUePBAZ7kVbiliNaK8EeJYbFXnE/n/E
S2Gm5tKAeeu2LyISzblxgwm6i46pRzN9g7s0pdUXpxex/uXjfx6xO4S28sVQMXfN
0ByKPJgrCQDWZ6fcNkVUYm2EmOJC1264NAeFtwaklaxD/bwgafVXSWqF9B1UVol1
W41TE0Tzjyo3UX+z4OQ4mJrOANlkX/nn76mZ86Udh1DlwgR4TLRSAAhbEEIHq8j4
lewqK+NUCymFrURtUhrABvjiE6bYhwWhmvwQwO7/Jgw82lmi+TPb3xqWjwi+OtHY
CnVUhpZDqgRN5YZJvLN6nrLqM9sZvA==
=3K0F
-----END PGP SIGNATURE-----

--=-G++X5AcVr6P6B/DWAlPU--

