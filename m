Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C403647810
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Dec 2022 22:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiLHVhm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Dec 2022 16:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLHVhl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Dec 2022 16:37:41 -0500
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB64100B;
        Thu,  8 Dec 2022 13:37:36 -0800 (PST)
Received: by mail-wm1-f45.google.com with SMTP id 125-20020a1c0283000000b003d1e906ca23so1984952wmc.3;
        Thu, 08 Dec 2022 13:37:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:references:in-reply-to:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=340tc5XTj/tmM1n+qDMnmmmik52R5+3MsEQGdlc6KIw=;
        b=r2lOQ2cDwFZKtC1ACEkn0ETJ13RB6qIAdbdUwMJ7P1aetfUgo00ZeZ33gjqXU8UiRe
         q9zoCTmsagfiDaCR6s8/09BY0rBp+j/fyZNflv3plBt+YKsBOzt5w/C405e+J1uhKh3S
         nYbs8u00dbrXhSM+Gpda9ApINJc90KKT1576qxhUqyO3M6dQUyNyrJGY2h8w7EMhXOcC
         s7Lkg0trj5U1wDXTFY3szRzW5QZScVjqMLDEg0RxdJctG14YR52sGbDU44hx2PHcRWQC
         yrmMtkS9xjcO1M0UM13OjFBzaGe/PcnPN8ueYUKt0ecs4crvYAOJrBaA/oF9ttm1BPUp
         vTJw==
X-Gm-Message-State: ANoB5plcs7sepDafB5Px9TTBjeSeKkbpy8R5j/9a7pWRgetsGjwEJejn
        JuawLabMsqkfIQ4d/Z4veqA=
X-Google-Smtp-Source: AA0mqf7N3/4kcu0eElbBDpjFgq4CiI/u5DBiqtQCf7SFoHD9mGEfMY0XQv5HETvUSTZi2IkPwTYPpA==
X-Received: by 2002:a05:600c:4f14:b0:3cf:e91d:f263 with SMTP id l20-20020a05600c4f1400b003cfe91df263mr2929849wmq.4.1670535454549;
        Thu, 08 Dec 2022 13:37:34 -0800 (PST)
Received: from localhost ([2a01:4b00:d307:1000:6f15:7230:d519:3286])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d5111000000b0022584c82c80sm23089645wrt.19.2022.12.08.13.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 13:37:33 -0800 (PST)
Message-ID: <00c7b6b0e2533b2bf007311c2ede64cb92a130db.camel@debian.org>
Subject: Re: [PATCH] fsverity: mark builtin signatures as deprecated
From:   Luca Boccassi <bluca@debian.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-integrity@vger.kernel.org,
        Jes Sorensen <jsorensen@meta.com>,
        Victor Hsieh <victorhsieh@google.com>
Date:   Thu, 08 Dec 2022 21:37:29 +0000
In-Reply-To: <Y5JPRW+9dt28JpZ7@sol.localdomain>
References: <20221208033548.122704-1-ebiggers@kernel.org>
         <eea9b4dc9314da2de39b4181a4dac59fda8b0754.camel@debian.org>
         <Y5JPRW+9dt28JpZ7@sol.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-pKUUQcX5xKiGrhc7aouB"
User-Agent: Evolution 3.46.1-1 
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


--=-pKUUQcX5xKiGrhc7aouB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-12-08 at 12:55 -0800, Eric Biggers wrote:
> On Thu, Dec 08, 2022 at 10:43:01AM +0000, Luca Boccassi wrote:
> > On Wed, 2022-12-07 at 19:35 -0800, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > >=20
> > > fsverity builtin signatures, at least as currently implemented,
> > > are a
> > > mistake and should not be used.=C2=A0 They mix the authentication
> > > policy
> > > between the kernel and userspace, which is not a clean design and
> > > causes
> > > confusion.=C2=A0 For builtin signatures to actually provide any
> > > security
> > > benefit, userspace still has to enforce that specific files have
> > > fsverity enabled.=C2=A0 Since userspace needs to do this, a better
> > > design is
> > > to have that same userspace code do the signature check too.
> > >=20
> > > That allows better signature formats and algorithms to be used,
> > > avoiding
> > > in-kernel parsing of the notoriously bad PKCS#7 format.=C2=A0 It is
> > > also
> > > needed anyway when different keys need to be trusted for
> > > different
> > > files, or when it's desired to use fsverity for integrity-only or
> > > auditing on some files and for authenticity on other files.=C2=A0
> > > Basically,
> > > the builtin signatures don't work for any nontrivial use case.
> > >=20
> > > (IMA appraisal is another alternative.=C2=A0 It goes in the opposite
> > > direction -- the full policy is moved into the kernel.)
> > >=20
> > > For these reasons, the master branch of AOSP no longer uses
> > > builtin
> > > signatures.=C2=A0 It still uses fsverity for some files, but
> > > signatures are
> > > verified in userspace when needed.
> > >=20
> > > None of the public uses of builtin signatures outside Android
> > > seem to
> > > have gotten going, either.=C2=A0 Support for builtin signatures was
> > > added to
> > > RPM.=C2=A0 However,
> > > https://fedoraproject.org/wiki/Changes/FsVerityRPM=C2=A0was
> > > subsequently rejected from Fedora and seems to have been
> > > abandoned.
> > > There is also https://github.com/ostreedev/ostree/pull/2269,
> > > which was
> > > never merged.=C2=A0 Neither proposal mentioned a plan to set
> > > fs.verity.require_signatures=3D1 and enforce that files have fs-
> > > verity
> > > enabled -- so, they would have had no security benefit on their
> > > own.
> > >=20
> > > I'd be glad to hear about any other users of builtin signatures
> > > that may
> > > exist, and help with the details of what should be used instead.
> > >=20
> > > Anyway, the feature can't simply be removed, due to the need to
> > > maintain
> > > backwards compatibility.=C2=A0 But let's at least make it clear that
> > > it's
> > > deprecated.=C2=A0 Update the documentation accordingly, and rename th=
e
> > > kconfig option to CONFIG_FS_VERITY_DEPRECATED_BUILTINSIG.=C2=A0 Also
> > > remove
> > > the kconfig option from the s390 defconfigs, as it's unneeded
> > > there.
> >=20
> > Hi,
> >=20
> > Thanks for starting this discussion, it's an interesting topic.
> >=20
> > At MSFT we use fsverity in production, with signatures enforced by
> > the
> > kernel (and policy enforced by the IPE LSM). It's just too easy to
> > fool
> > userspace with well-timed swaps and who knows what else. This is
> > not
> > any different from dm-verity from our POV, it complements it. I
> > very
> > much want the kernel to be in charge of verification and
> > validation, at
> > the time of use.
>=20
> Well, IPE is not upstream, and it duplicates functionality that
> already exists
> upstream (IMA appraisal).=C2=A0 So from an upstream perspective it doesn'=
t
> really
> matter currently.=C2=A0 That's interesting that you've already deployed
> IPE in
> production anyway.=C2=A0 To re-iterate my question at
> https://lore.kernel.org/r/YqKGcdM3t5gjqBpq@sol.localdomain=C2=A0which was
> ignored,
> can you elaborate on why IPE should exist when IMA appraisal already
> exists (and
> already supports fsverity), and why IPE uses the fsverity builtin
> signatures?

Yes, IPE has been in production for years, it used in the feature
described in the couple of minutes of Ignite starting at:
https://www.youtube.com/watch?v=3DPO5ijv6WDv0&t=3D608s

But I am not in the team that works on IPE, so I am not the best person
to answer the first question, I do not have a good enough understanding
of the implementation details of IPE/IMA to be able to say. I believe a
new revision will be submitted soon, the submitter is the right person
to ask that question.

The second question is easy: because the kernel is the right place for
our use case to do this verification and enforcement, exactly like dm-
verity does. Userspace is largely untrusted, or much lower trust
anyway.

> And are you sure that X.509 and PKCS#7 should be used in a new
> system?=C2=A0 These
> days, if you go through any sort of crypto or security review, you
> will be told
> not to use those formats since they are overly complex and prone to
> bugs.

Yes. We need to use the same mechanism as dm-verity, and in fact many
more systems, already make use of.

--=20
Kind regards,
Luca Boccassi

--=-pKUUQcX5xKiGrhc7aouB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCSqx93EIPGOymuRKGv37813JB4FAmOSWRkACgkQKGv37813
JB6kmxAAqAK1wgzQjMQHQaWFHrNHUknq7XPZPSt5pSZlnbnksHWUFSTX462ZgwtW
6C2P+5JUMqcCcT1ZmsQRQfVfAWvfXYirrHrmwEXGWE9enwqfLOQ50MuYPXWoP886
4WP5l3lbm3IVREfIrXXDX6w/FZa+ixu0fVOdHGOEqxScPiAiPSnrzX4eMR3PGiAw
EqR3zAEi6X9vGLbfztsmIMnzgX6pn6CXB9MZi/VILFmNG/0n0A6jjU6lSaIx2oiE
nxSpflRbD4Fm5mYYy8pAxTY0mAVX5ms8qpSlMlr01RLtYQ9lqzqc2LLDVTQvcRYU
RAR1g/9aQxFIbIEA8FvOwShxPj/dA/kL4O6V9gVEW5pk8KsH44+PpiL4zCjPqZra
Wvw6BzAbytvTji1K3Hn0XmF5FlMgi6V6zZoEWAHLbhsY/plb9yOAZDX7m+PLUA64
JkYFODamz0PrXsZjiyF38fBqEnspsZD38F0y1Yq7m6VCirv0IHnuxwI6Zqg93szE
MeVX0r26PS7pD0/dP8VBY0ir+MF77eRt8S98pkc4hF8q+rt9qtM0df6pjkQYWTnW
vxI6z+NES4eMgzDp3womWFlajMK5wmgONKQHLIcUgt6ye5IO+OgSGkw4AOhUKv4e
4D3vwY54ybr7m0I560Y2TFAH+YRJNUQ5Aj01fHGurMWvYN5Usjw=
=+bFf
-----END PGP SIGNATURE-----

--=-pKUUQcX5xKiGrhc7aouB--
