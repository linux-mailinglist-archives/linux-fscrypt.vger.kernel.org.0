Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155B2646D7D
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Dec 2022 11:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiLHKsX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Dec 2022 05:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiLHKrr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Dec 2022 05:47:47 -0500
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEAC83E9B;
        Thu,  8 Dec 2022 02:43:05 -0800 (PST)
Received: by mail-wr1-f50.google.com with SMTP id h11so1089887wrw.13;
        Thu, 08 Dec 2022 02:43:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:references:in-reply-to:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUo4kly/SxIUcC+vLycW1YJtMzv9qCSvF1SehegNZGU=;
        b=KS1wRje9DjDMcBCCt7/ZxE1IUY9zs5T0/iggKT1z+yo/ER6joa82Uze4K4G6emTtDH
         sW5J2vzyCOevhS+Qvity6qVIzu5l1cjeRS6IPAtJEceKKHC89SsjcKHml3rZ3f7x19WQ
         N2g52fjctqX/qgaf21ehWrwF4aTmvxwV5aWyw6JYEEoEilmfvksoQceYpLhQpAGx/Gts
         EiUESniYzElKUO+sJGMLtgMebXwWaMW4i4PUf2J/+fwVg3i85FofEXrPNYIRjPNfQfIV
         YueyqPNOtPSTBRhZHvN4hACGpBIfEWGjDGCy+CiabZnciejuYPDmmQ82+YjOh4OzSqbp
         vJLg==
X-Gm-Message-State: ANoB5pl5CF0j2t2owEvgeSLBgBrPD8+cue2QeVOGKVa6uVz6mz6yfbwF
        DW2aoESMm/Q/5eeMejbYdKCxx4exR4g=
X-Google-Smtp-Source: AA0mqf67rhW153rTSwtf3W+5CZ6U49VL0f7fl+HmWmcMJVmJPOpZVfz7rGANlqd26RCoM8ZRYS4oFw==
X-Received: by 2002:adf:e8c2:0:b0:242:832c:5524 with SMTP id k2-20020adfe8c2000000b00242832c5524mr2906021wrn.297.1670496183620;
        Thu, 08 Dec 2022 02:43:03 -0800 (PST)
Received: from localhost ([2a01:4b00:d307:1000:f1d3:eb5e:11f4:a7d9])
        by smtp.gmail.com with ESMTPSA id i1-20020adfaac1000000b002238ea5750csm27101005wrc.72.2022.12.08.02.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 02:43:03 -0800 (PST)
Message-ID: <eea9b4dc9314da2de39b4181a4dac59fda8b0754.camel@debian.org>
Subject: Re: [PATCH] fsverity: mark builtin signatures as deprecated
From:   Luca Boccassi <bluca@debian.org>
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-integrity@vger.kernel.org,
        Jes Sorensen <jsorensen@meta.com>,
        Victor Hsieh <victorhsieh@google.com>
Date:   Thu, 08 Dec 2022 10:43:01 +0000
In-Reply-To: <20221208033548.122704-1-ebiggers@kernel.org>
References: <20221208033548.122704-1-ebiggers@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-uyN2eFFU7heJKfazMuQe"
User-Agent: Evolution 3.38.3-1+plugin 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--=-uyN2eFFU7heJKfazMuQe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-12-07 at 19:35 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> fsverity builtin signatures, at least as currently implemented, are a
> mistake and should not be used.  They mix the authentication policy
> between the kernel and userspace, which is not a clean design and causes
> confusion.  For builtin signatures to actually provide any security
> benefit, userspace still has to enforce that specific files have
> fsverity enabled.  Since userspace needs to do this, a better design is
> to have that same userspace code do the signature check too.
>=20
> That allows better signature formats and algorithms to be used, avoiding
> in-kernel parsing of the notoriously bad PKCS#7 format.  It is also
> needed anyway when different keys need to be trusted for different
> files, or when it's desired to use fsverity for integrity-only or
> auditing on some files and for authenticity on other files.  Basically,
> the builtin signatures don't work for any nontrivial use case.
>=20
> (IMA appraisal is another alternative.  It goes in the opposite
> direction -- the full policy is moved into the kernel.)
>=20
> For these reasons, the master branch of AOSP no longer uses builtin
> signatures.  It still uses fsverity for some files, but signatures are
> verified in userspace when needed.
>=20
> None of the public uses of builtin signatures outside Android seem to
> have gotten going, either.  Support for builtin signatures was added to
> RPM.  However, https://fedoraproject.org/wiki/Changes/FsVerityRPM was
> subsequently rejected from Fedora and seems to have been abandoned.
> There is also https://github.com/ostreedev/ostree/pull/2269, which was
> never merged.  Neither proposal mentioned a plan to set
> fs.verity.require_signatures=3D1 and enforce that files have fs-verity
> enabled -- so, they would have had no security benefit on their own.
>=20
> I'd be glad to hear about any other users of builtin signatures that may
> exist, and help with the details of what should be used instead.
>=20
> Anyway, the feature can't simply be removed, due to the need to maintain
> backwards compatibility.  But let's at least make it clear that it's
> deprecated.  Update the documentation accordingly, and rename the
> kconfig option to CONFIG_FS_VERITY_DEPRECATED_BUILTINSIG.  Also remove
> the kconfig option from the s390 defconfigs, as it's unneeded there.

Hi,

Thanks for starting this discussion, it's an interesting topic.

At MSFT we use fsverity in production, with signatures enforced by the
kernel (and policy enforced by the IPE LSM). It's just too easy to fool
userspace with well-timed swaps and who knows what else. This is not
any different from dm-verity from our POV, it complements it. I very
much want the kernel to be in charge of verification and validation, at
the time of use.

In essence, I very strongly object to marking this as deprecated. It is
entirely ok if at Google you want to move everything out of the kernel,
you know your use case best so if that works better for you that's
absolutely fine (and thus your other patch looks good to me), but I
don't think it should be deprecated for everybody else too.


--=20
Kind regards,
Luca Boccassi

--=-uyN2eFFU7heJKfazMuQe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCSqx93EIPGOymuRKGv37813JB4FAmORv7UACgkQKGv37813
JB70dw//SWlwiv/J6POjog19YTaToZXYmwjH761/vs2IMCbmgNdI5sjj71XaPvTs
fP4i/zeqNnJM6jTW686c+N4xSdnSZR9Hx+mgkdAg/D7Ype2iutIfoQMO5zmjHY8z
eDaOLyK5Eya/yC+rOU1sBN6Itnda6bjcpx8bC02HtqFz07CcG18CBb5LVY8okv7L
5A45fGHo577vvCjxdRwGzfp4x2V1fg7xKSK6ghb7jZNLL6w1CAxgNDzqZuKZDR3J
eh/NuWe1cbrVlHVQInK5Vd3TU9BlPTweNmoXlO2zqTyhcefDPlBAJxoHTGh8QaPd
aL4pdoMdjEXvA2DlwLJvk1Vxbdiv/K3nuPwiUeq8Cleq6CKoOwnKd8hfY7pmHS7o
t/UrdeeclY+ASgLdjXK+ijIG6vO31MiISgOWwv3YZc5cP1Rqmsx0Kpd1AElKUMgf
3WaBIboamyfWZcGRnEZBjosdTjiEeufvNv1DpIjlUOOfTL6t3w76U6yfadGuGsKG
zxf+W7I+IBnZIn6lFR3w5vtZKjQUnpQoI0jnf95szfhScAQddNFjee7UtrX1gdWm
PlJnbmmzovfHjdK358uTXGNWXFpD8N1poGiRk/IoFPZvq6RH9btaY+inAn7BotE7
bl0Mi024mGiuiwqD09X0us+jOUdp3cZgDV/x7B/+en/p4OBL1H8=
=xrXs
-----END PGP SIGNATURE-----

--=-uyN2eFFU7heJKfazMuQe--
