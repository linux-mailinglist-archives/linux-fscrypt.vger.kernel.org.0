Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B316C2DD340
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 15:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgLQOur (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 09:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgLQOuq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 09:50:46 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48052C061794
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 06:50:06 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id e25so5991320wme.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 06:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=6UlwN2ynYVUlWfKM7O4NfXmr+IzUWV2njAAqbxrz8Rs=;
        b=VUqmveeOzMdl3AFEs46TIlaeV4Uvcl09+R432PEdMYdteMmowL/rzIfN9Ud5G58tHU
         FZQvdn4W4e7qUeQ7gShKPhnYwqaznCb5L0/P0TWiOrP0mzvuoL/BM2/Jfkbf+Bd9oG2U
         81sTXkfa7hEzZG1WF/6CcIxnBAgM2A8xKwCS7rYH++Uhvl3FSBoaHTtzh3u4LsnmBZMK
         dCrBTsPGFIoOnAauGatG7qTOfLb/bWsx3mJ9jLZ4i3fA65z+v7NYwcxLFfofNO1qOxZD
         4HOZ5VmqU5mZhdgZzpfycrdRynkDO5MoKCCpYZe0wFGkdzRaKfAwUtPfLdJyy0I6SFNF
         aFEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=6UlwN2ynYVUlWfKM7O4NfXmr+IzUWV2njAAqbxrz8Rs=;
        b=s/0t4u3mNy/XWYvb5NqY8bZPTmWD6jtYEFS/E+gBwg8i5Lq0vUqdlXe7hCGL2j0X48
         nKiqeu+vtKv3Ps0NqJ/U5DyTvqhc4XB/EKtoaVlSItsKTt+4WZjli9WP9degKeGMAgA+
         DuSZEAiAue/BqUCglfKlW4HeT3IXfCTpN+MSGLyqYngNoc7b+FNdlF2eETbEsYnwfvSx
         qz0FvM+D89YpjdyufBlVa5b2ikTh+TvLAd9KQ653GEadolvXnoJu2hNv9WMthnChIC+t
         y2HKanecwC41daabYTmZ8mjR9hn8pdDs/bi5Qmw8yEvKpHIHq6zTCjd9spaR8We5Gjn5
         DIeQ==
X-Gm-Message-State: AOAM531L7WGJ7hQRMrVpgjFtOL/PzVmW/zZdS2WPX9SNxsKV1MxsM4EV
        O+iSjk7lDcknA7uAU07Br6ObSEYaB5A4eQ==
X-Google-Smtp-Source: ABdhPJxWjHgVBdfEwfZeDTyAr2+jN/9TNICEV3B1hQSlpoGL7JdbHWd2foGoBEZgk+OXSePOkJculg==
X-Received: by 2002:a1c:7703:: with SMTP id t3mr8954065wmi.47.1608216605041;
        Thu, 17 Dec 2020 06:50:05 -0800 (PST)
Received: from bluca-lenovo ([2a01:4b00:f419:6f00:7a8e:ed70:5c52:ea3])
        by smtp.gmail.com with ESMTPSA id a25sm3696941wmb.25.2020.12.17.06.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 06:50:03 -0800 (PST)
Message-ID: <7e6e34dbfe9e599ff108e5a80e62a1de7f869b4f.camel@gmail.com>
Subject: Re: [fsverity-utils PATCH 1/2] Remove unneeded includes
From:   Luca Boccassi <luca.boccassi@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Date:   Thu, 17 Dec 2020 14:50:02 +0000
In-Reply-To: <X9pVpVC2Y/nGq4MG@sol.localdomain>
References: <20201216172719.540610-1-luca.boccassi@gmail.com>
         <X9pVpVC2Y/nGq4MG@sol.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-SL+rqYEuCm6AIf1uVUH+"
User-Agent: Evolution 3.30.5-1.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--=-SL+rqYEuCm6AIf1uVUH+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-12-16 at 10:44 -0800, Eric Biggers wrote:
> On Wed, Dec 16, 2020 at 05:27:18PM +0000, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <luca.boccassi@microsoft.com>
> >=20
> > Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> > ---
> >  common/fsverity_uapi.h | 1 -
> >  programs/cmd_enable.c  | 1 -
> >  2 files changed, 2 deletions(-)
> >=20
> > diff --git a/common/fsverity_uapi.h b/common/fsverity_uapi.h
> > index 33f4415..0006c35 100644
> > --- a/common/fsverity_uapi.h
> > +++ b/common/fsverity_uapi.h
> > @@ -10,7 +10,6 @@
> >  #ifndef _UAPI_LINUX_FSVERITY_H
> >  #define _UAPI_LINUX_FSVERITY_H
> > =20
> > -#include <linux/ioctl.h>
> >  #include <linux/types.h>
>=20
> fsverity_uapi.h is supposed to be kept in sync with
> include/uapi/linux/fsverity.h in the kernel source tree.
>=20
> There's a reason why it includes <linux/ioctl.h>.  <linux/ioctl.h> provid=
es the
> _IOW() and _IOWR() macros to expand the values of FS_IOC_ENABLE_VERITY an=
d
> FS_IOC_MEASURE_VERITY.  Usually people referring to FS_IOC_* will include
> <sys/ioctl.h> in order to actually call ioctl() too.  However it's not
> guaranteed, so technically the header needs to include <linux/ioctl.h>.
>=20
> Wrapping this include with '#ifdef _WIN32' would be better than removing =
it, as
> then it would be clear that it's a Windows-specific modification.
>=20
> However I think an even better approach would be to add empty files
> win32-headers/linux/{types,ioctl.h} and add -Iwin32-headers to CPPFLAGS, =
so that
> these headers can still be included in the Windows build without having t=
o
> modify the source files.

I took the first approach in v2, as it's a bit simpler. If you feel
strongly about it I can do the latter.

> > diff --git a/programs/cmd_enable.c b/programs/cmd_enable.c
> > index fdf26c7..14c3c17 100644
> > --- a/programs/cmd_enable.c
> > +++ b/programs/cmd_enable.c
> > @@ -14,7 +14,6 @@
> >  #include <fcntl.h>
> >  #include <getopt.h>
> >  #include <limits.h>
> > -#include <sys/ioctl.h>
> > =20
>=20
> This part looks fine though, as cmd_enable.c no longer directly uses an i=
octl.
>=20
> - Eric


--=-SL+rqYEuCm6AIf1uVUH+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl/bcBoACgkQSylmgFB4
UWJxVwf/aioz5abYnwuSwXKe2hHwwRmq4gYliLvIapPHT0Uen4PLMpAV5yDFixlb
WzYDNY+3M5mwD6s9eiGy/J9yPc6nFIEc9z8BFYM3XLt9UwLV1heD/GLwpo/5L3jm
X24KBNaxq2DdQCDBeeyD433hIkjcJGoUphC2NjO9FJkNcZ0uuqoam/D2gazPo8Ub
eWY6m5AGSzWwfvYawViOgfjCEnJzLjvQOXCuyIShSXm6GL11urnct9E6TrI5BJWx
fobATBSKDdFBKHs2v14BKZJeMOvyoBJzuYwtArHnq3uFAJdQzRGqwi4zvpIonfIY
dQBNxVtBcFN4Nt/dVXiDA8kDUy6jng==
=bUu7
-----END PGP SIGNATURE-----

--=-SL+rqYEuCm6AIf1uVUH+--

