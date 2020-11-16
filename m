Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6392B42B8
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 12:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbgKPLV6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 06:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729753AbgKPLV6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 06:21:58 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D52DC0613CF;
        Mon, 16 Nov 2020 03:21:58 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id s13so23259671wmh.4;
        Mon, 16 Nov 2020 03:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=J7ScDOniI6ueo/p9HfsL+zg2fBIjV81sU+60JEsADlk=;
        b=hknLKPNYaPRKyCOK0Ou84CRJw/CoHcjF9RFZkZNhZY8pw4ly1bbFgHCjqlojVAVCWp
         E3wm0dnKZv6eDoT+CihxQ6tOJpnfFTRp02ciF1Uh1SLwEVNgQvIeF2iMrMHa6wlz8dWn
         wLcJdPQ8ovfJu+oLah/P/nCa2WHwNiVkH78/UsP/OZgv33sGm6FaxH/l5ucfbe4xL+QL
         DQcu9tIOrMKyZhd3nPtAoAYV7gL2ImLbKsxS5gYBXTEwS3/yP0bJQ5lgMoiwoxFm7Mcu
         6cyB9fNtuMpfK0lUifVGtVC6QTGy7qHJZCiPHVojfgk/Rtju8WkEqkSSbyyl6V1zp3of
         LtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=J7ScDOniI6ueo/p9HfsL+zg2fBIjV81sU+60JEsADlk=;
        b=kzX6CQs4CM/Q+H58tiWmNhq0rGtKYv4mqChR4/Z6NBtcO6XAhj0827gniaXSDf50Lk
         3Rer9Dl2COmvBw5PEAMZYTENrGZEKkRqnwlR7OqDtf0r4XcuTogsq67Ui62hnQlPGAMB
         X5Nd0ZMu8HDrj9vrDFZnw2tP/mgekOhq2IYjt4thzSV8kytYZJOE+7jMLIuIJyjHNZlv
         +UvdsXq0Onpv86mhuknqYzQ2FfH6q9SVg7ZCTXjyI7jK4SJldiiFPlhIJlSc/R8Q0toG
         2LlvFdFcK+BA7xk4Y0Q9WAgHG3T6W2t7oPdux+jLv4VLwZqwI/NLTXPE0ZuklgTCmozL
         Crpw==
X-Gm-Message-State: AOAM531EsgEOFPDL6NkuC7LELFtI0ICtAVlTwID677MKGXeeN1SJPSfS
        RtvZbJgNh8AFZDecHWkWgdU=
X-Google-Smtp-Source: ABdhPJzdFXZhX8863tJ82vBI5jKfOPGsU5vzGcnGTkhPSQTYm2hCoHZUkRbpKCnV5KEa9DXsqNd3cA==
X-Received: by 2002:a05:600c:4147:: with SMTP id h7mr14745931wmm.186.1605525716706;
        Mon, 16 Nov 2020 03:21:56 -0800 (PST)
Received: from bluca-lenovo ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id m20sm2601050wrg.79.2020.11.16.03.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 03:21:55 -0800 (PST)
Message-ID: <31b3978b6f082b849d7546c6e3e94c12594c97ee.camel@gmail.com>
Subject: Re: [PATCH 3/4] fs-verity: rename "file measurement" to "file
 digest"
From:   Luca Boccassi <luca.boccassi@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Victor Hsieh <victorhsieh@google.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Martijn Coenen <maco@android.com>,
        Paul Lawrence <paullawrence@google.com>
Date:   Mon, 16 Nov 2020 11:21:54 +0000
In-Reply-To: <20201113211918.71883-4-ebiggers@kernel.org>
References: <20201113211918.71883-1-ebiggers@kernel.org>
         <20201113211918.71883-4-ebiggers@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-L1z57FiKm//lzPi0Om2j"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--=-L1z57FiKm//lzPi0Om2j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-11-13 at 13:19 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> I originally chose the name "file measurement" to refer to the fs-verity
> file digest to avoid confusion with traditional full-file digests or
> with the bare root hash of the Merkle tree.
>=20
> But the name "file measurement" hasn't caught on, and usually people are
> calling it something else, usually the "file digest".  E.g. see
> "struct fsverity_digest" and "struct fsverity_formatted_digest", the
> libfsverity_compute_digest() and libfsverity_sign_digest() functions in
> libfsverity, and the "fsverity digest" command.
>=20
> Having multiple names for the same thing is always confusing.
>=20
> So to hopefully avoid confusion in the future, rename
> "fs-verity file measurement" to "fs-verity file digest".
>=20
> This leaves FS_IOC_MEASURE_VERITY as the only reference to "measure" in
> the kernel, which makes some amount of sense since the ioctl is actively
> "measuring" the file.
>=20
> I'll be renaming this in fsverity-utils too (though similarly the
> 'fsverity measure' command, which is a wrapper for
> FS_IOC_MEASURE_VERITY, will stay).
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Documentation/filesystems/fsverity.rst | 60 +++++++++++++-------------
>  fs/verity/enable.c                     |  6 +--
>  fs/verity/fsverity_private.h           | 12 +++---
>  fs/verity/measure.c                    | 12 +++---
>  fs/verity/open.c                       | 22 +++++-----
>  fs/verity/signature.c                  | 10 ++---
>  6 files changed, 61 insertions(+), 61 deletions(-)

Acked-by: Luca Boccassi <luca.boccassi@microsoft.com>

--=20
Kind regards,
Luca Boccassi

--=-L1z57FiKm//lzPi0Om2j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+yYNIACgkQSylmgFB4
UWJ5bQgAnqljL6uf5gWiDnPlKCsmVvJ2oBYh1a/LoLVmbU5EvGaNuWyqI2YYU2R7
cKSeAMIIMiWnK76pgRJh0DAxooHbrsTcXXCutVXVE3yLfev6+RY9f9e8D7CP12KK
MxZCeFxK9/peABvNKeFwDKYi4A/9gF6sknoSARO8nxurrUIUjud3TB7YtLaMvB5S
N/yHhJpVeColCpxYWSCvoeQGQOFWmm2CKxXX0SIa2HDqKFcZSTvPkSzNId8Aee+o
fZc7UVU9qlu38v/0ELoAxWDtspTwr4VVk7h4NIFh4bSBfCAPeposCJ+kjAChDZQm
mKtDqyrZqpiYtF+WvZw4Io+smxjkQQ==
=xCC3
-----END PGP SIGNATURE-----

--=-L1z57FiKm//lzPi0Om2j--

