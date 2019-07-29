Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAFDD78488
	for <lists+linux-fscrypt@lfdr.de>; Mon, 29 Jul 2019 07:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfG2FpG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Jul 2019 01:45:06 -0400
Received: from ozlabs.org ([203.11.71.1]:57713 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbfG2FpG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Jul 2019 01:45:06 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45xpYW5HDSz9s3l;
        Mon, 29 Jul 2019 15:45:03 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1564379104;
        bh=OjBusjBmTh3FC4xRu9En+9wxMY50HFlVLJk9zi826S4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W0TtNsAfdUakVjiM74Pczb6qE3AsCA0cEovBZfUuRobtddOZgA2Gj6EjoHLX3ykNn
         D7vwk/Z380Xs30VsSEiNJ0hOnb93FSic7iHJtBeTrph+PQpVEABb9nW/6riMOgJJ3s
         lQvs3WSZAyK/3mlwZNFIwa2a7ESffhfqqgM7EOTaio+NoIlb97rlbfsczGg4VPUxAs
         9GQLl63BsXe7huyGckksi2aLaTqm8v6D5bUXtJ36fHvvrM/+3n8wDd8CQsMvhfE5Zw
         CI8hjYC+m1YtS/R21G1qSdo93snh6cpaLRVDLk/lZnQ3DpyFMXT3JD64VD5P+fsLvA
         1MfSwEGpYvTMg==
Date:   Mon, 29 Jul 2019 15:45:03 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-next@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Add fsverity tree to linux-next
Message-ID: <20190729154503.13aed678@canb.auug.org.au>
In-Reply-To: <20190729031226.GA2252@sol.localdomain>
References: <20190729031226.GA2252@sol.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/o/A/oFcwBKxzLJmh1WMQYp.";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--Sig_/o/A/oFcwBKxzLJmh1WMQYp.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Sun, 28 Jul 2019 20:12:26 -0700 Eric Biggers <ebiggers@kernel.org> wrote:
>
> Can you please add the fsverity tree to linux-next?
>=20
>         https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git#fsverity
>=20
> This branch contains the latest fs-verity patches
> (https://lore.kernel.org/linux-fsdevel/20190722165101.12840-1-ebiggers@ke=
rnel.org/T/#u).
> We are planning a pull request for 5.4.
>=20
> Please use as contacts:
>=20
>         Eric Biggers <ebiggers@kernel.org>
>         Theodore Y. Ts'o <tytso@mit.edu>

Added from tomorrow.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgement of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/o/A/oFcwBKxzLJmh1WMQYp.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0+h98ACgkQAVBC80lX
0GzVDgf/d55c2rZLDeEKeui7XemWo7U4YCJZVQsO2Ye1k4OURh8KuPB4OHFAxnrm
FXjilOcrXCqrXaNyoo4xaRfy2oZesdGslLLxjZL8Jnf6DLm5sxbA/JbxR+95wMkH
O4MxF5R7r5SbzzTt7j1DGlfn5SGW7xkNHmOPhurdtyyqq0J5ag6rk+U/nNn2TpAM
eZ9C+mJrmjIage8ogA2P8XGWZOU6nNJs+4nQ1pB79MiJyK9IkPJBH+dpC+TG9Rpy
Z6Z49aJa1DSBlM+FX2kRCpRlkBwsVg5yBDzYjyk6J5ODYInzCpdHsCXTjM2nvmST
+qr2gMk47+PWDhcI9yomBWndRIdLwg==
=p76q
-----END PGP SIGNATURE-----

--Sig_/o/A/oFcwBKxzLJmh1WMQYp.--
