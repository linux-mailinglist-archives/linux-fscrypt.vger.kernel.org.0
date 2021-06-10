Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211453A280F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jun 2021 11:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFJJS7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Jun 2021 05:18:59 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:43853 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhFJJS6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Jun 2021 05:18:58 -0400
Received: by mail-wm1-f45.google.com with SMTP id 3-20020a05600c0243b029019f2f9b2b8aso5960667wmj.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 10 Jun 2021 02:16:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=Rfof69iWMEWHpQq1qhIshqahOhnclysZe0zDw5eDzZk=;
        b=qKOEA7m/1mgQ/JTIeDRIlXlz6tjcBMS3COVnDzM2nMweP5UskQglLZQ//L5UnzQRfm
         WGVzt5LBYB+zrZzMQFIfedV5slNbNBE5ZRakxz9gDvjYEO6WJzuFtIXdWZ9Xo8KnuXDJ
         uDT0R+m4tiptUVSEtMTnQGWYExZh8L4Euj5lr9tuwO5W1LCJnKrWUWHOBFzikvwS283n
         C/S9e20Eh4ftjwnVyaWaaA4l0nPBqijEHDiy1Fe8oEkuT3vscVyFtj4+DKJr0OlTgr5L
         KzrYF/8paCRHecLhI6mzDjRynHKwsFQnJNZpaAlJ2oKfdsBkcTeyevwfhZxoIT4of1+X
         oG3g==
X-Gm-Message-State: AOAM530G+vx1yKrAYJ/IJqeIWVGxCrwHP/05kZeoYNTYHEzjLXrW5dD+
        f5AJdf9fJnOt/dVF4XFxNTY=
X-Google-Smtp-Source: ABdhPJxlLK8yZRtaIZTbYZXfCnKRJShTgrqnURj1/Uot5u0Tzz2u5+UWLjoFtenDnvPyzkTvE/x9zg==
X-Received: by 2002:a05:600c:4ba1:: with SMTP id e33mr14365356wmp.39.1623316611735;
        Thu, 10 Jun 2021 02:16:51 -0700 (PDT)
Received: from localhost ([137.220.125.106])
        by smtp.gmail.com with ESMTPSA id r6sm2756536wrt.21.2021.06.10.02.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 02:16:50 -0700 (PDT)
Message-ID: <16705faf32f4ce2b9bce37b0bea2bdbea3ad848e.camel@debian.org>
Subject: Re: [fsverity-utils PATCH] Add man page for fsverity
From:   Luca Boccassi <bluca@debian.org>
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>,
        Jes Sorensen <jes.sorensen@gmail.com>
Date:   Thu, 10 Jun 2021 10:16:49 +0100
In-Reply-To: <20210610072056.35190-1-ebiggers@kernel.org>
References: <20210610072056.35190-1-ebiggers@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-JOEL952AYn4dO2ri2f9T"
User-Agent: Evolution 3.30.5-1.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--=-JOEL952AYn4dO2ri2f9T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-06-10 at 00:20 -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> Add a manual page for the fsverity utility, documenting all subcommands
> and options.
>=20
> The page is written in Markdown and is translated to groff using pandoc.
> It can be installed by 'make install-man'.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  .gitignore            |   1 +
>  Makefile              |  32 ++++++-
>  README.md             |  14 +++-
>  man/fsverity.1.md     | 191 ++++++++++++++++++++++++++++++++++++++++++
>  scripts/do-release.sh |   6 ++
>  scripts/run-tests.sh  |   2 +-
>  6 files changed, 239 insertions(+), 7 deletions(-)
>  create mode 100644 man/fsverity.1.md

Acked-by: Luca Boccassi <bluca@debian.org>

--=20
Kind regards,
Luca Boccassi

--=-JOEL952AYn4dO2ri2f9T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCSqx93EIPGOymuRKGv37813JB4FAmDB2IEACgkQKGv37813
JB4rvBAAycmaV9K6vSthYIjakF/oswjdGCmXkvr7Bv/tLMFEpzmtlxSFgdQXe4G2
4c8I31JeeBoszdbBSii3H96t8LjWugY01uyeqUX80iNREqMC5uGaTTR18haNEejc
bLfPyWRGYgyA0QGNbGtsxpWLEi3gO/GW5qeUVBNNG76u6O2FfEvNZvQAXw47THlx
vckxBrAoGuoLd5khFqhErWsBhnt4vBFpM2ol7SeRUyOh3Oo6TeFizLkxl7WoCLJ3
76qySduARr9ADTOh0Z16Is1HAn69VsqaiaOBuFxHNmQzw+D/9LHw9hNZvYwLVa7z
Y8ipsGU/SsKcjJ7bTLEKgmS2SSwveDYhbvdFy7h39o8ZdOdR84bHjis7ym6+QCal
Y9X6lrLjZW8bS4f7uzCYxKizRAZbtjkAhtZYWk8qsEICzTl5Rj7eqS74CYhwQErZ
q6KfBSHQcxi4IZkyhyeRvHiAmmsNa1E94/YRvQMFc+GwzTkdKYha8Nxn/FSoTdJU
t6NBalYfiIy1gbhJNURZkJefbGIWwtHd32zKXl9dUgKG+9AEkK6OYKlO5FlGGmoJ
RYYtT4mUKBIRZyHK9rBk1uQuaXiCDOXku3qE6Xiw6FvxcbU+bSK5P9jk/Ho8AgtQ
iLl5AQzMcFT5qEazcTHyfeEzJLnTeBBxpXm3LNHjnGRMRMBFMf0=
=EEOm
-----END PGP SIGNATURE-----

--=-JOEL952AYn4dO2ri2f9T--
