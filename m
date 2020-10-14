Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B6F28DA51
	for <lists+linux-fscrypt@lfdr.de>; Wed, 14 Oct 2020 09:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgJNHMr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Oct 2020 03:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbgJNHMr (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Oct 2020 03:12:47 -0400
Received: from coco.lan (ip5f5ad5dc.dynamic.kabel-deutschland.de [95.90.213.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 435A62076D;
        Wed, 14 Oct 2020 07:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602659566;
        bh=M3YwoIBXEQPDsVpyNH3dqIUzl/U0avmiCdaQgNjKTho=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uJTbrB7T4Bi2wZ+4cyoQoHRMy+Ui2+rdB/sg2OlxNLuE4yQF3S+fk92IyI+o9j20G
         krTMHzFCv3J+0as4qow32bvWzQSWQxx4paHWgdq2JnNSCN3IUBfwSxCyQ2ZsuiFrv7
         v4wBRv7kxmX6lMHcIcgowb2ITKIfKkKPTriu/OHk=
Date:   Wed, 14 Oct 2020 09:12:40 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 35/52] docs: fs: fscrypt.rst: get rid of :c:type:
 tags
Message-ID: <20201014091240.78ba3425@coco.lan>
In-Reply-To: <20201006191953.GA3598358@gmail.com>
References: <cover.1601992016.git.mchehab+huawei@kernel.org>
        <81cd5da550e06de8e85dcadef4909ff5f1d23319.1601992016.git.mchehab+huawei@kernel.org>
        <20201006191953.GA3598358@gmail.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Em Tue, 6 Oct 2020 12:19:53 -0700
Eric Biggers <ebiggers@kernel.org> escreveu:

> On Tue, Oct 06, 2020 at 04:03:32PM +0200, Mauro Carvalho Chehab wrote:
> > The :c:type: tag has problems with Sphinx 3.x, as structs
> > there should be declared with c:struct.
> >=20
> > So, remove them, relying at automarkup.py extension to
> > convert them into cross-references. =20
>=20
> I tried 'make htmldocs' before and after your patchset ("sphinx3-fixes-v5=
").
> Before, all the struct fscrypt_* are rendered in code font.  After, they =
are
> rendered in the regular text font.  Is that really working as intended?

It is up to automarkup.py to change from "struct foo" into:
	:c:type:`struct foo` (Sphinx 2.x)
or:
	:c:struct:`foo` (Sphinx 3.x)

At v5, the automarkup.py extension was disabled, as it was broken
with Sphinx > 2.x. At v6, I added a patch from N=C3=ADcolas addressing
it.

It should be said that, currently, if there's no documentation for=20
"foo", automarkup will just keep using the regular text font,
keeping the text untouched.

>=20
> >=20
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > ---
> >  Documentation/filesystems/fscrypt.rst | 51 ++++++++++++---------------
> >  1 file changed, 23 insertions(+), 28 deletions(-)
> >  =20
>=20
> Why are the changes to fscrypt.rst split between two patches,
>=20
> 	docs: get rid of :c:type explicit declarations for structs
>=20
> and
>=20
> 	docs: fs: fscrypt.rst: get rid of :c:type: tags
>=20
> ?  They're the same type of changes.  The first just removes half the :c:=
type:
> tags, and the second removes the rest.  Shouldn't it be one patch?
>=20

The reason is just because it was easier this way.=20

On the first patch, I used sed to replace structs on a=20
semi-automated way, checking the results.

at the second one, I addressed the remaining symbols manually.

Anyway, at the new version, I just placed everything related
to fscript.rst at the same patch, to make easier to review.

> > diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/file=
systems/fscrypt.rst
> > index 4f858b38a412..46a9d1bd2ab5 100644
> > --- a/Documentation/filesystems/fscrypt.rst
> > +++ b/Documentation/filesystems/fscrypt.rst
> > @@ -437,8 +437,7 @@ FS_IOC_SET_ENCRYPTION_POLICY
> >  The FS_IOC_SET_ENCRYPTION_POLICY ioctl sets an encryption policy on an
> >  empty directory or verifies that a directory or regular file already
> >  has the specified encryption policy.  It takes in a pointer to a
> > -struct fscrypt_policy_v1 or a :c:type:`struct
> > -fscrypt_policy_v2`, defined as follows::
> > +struct fscrypt_policy_v1 or a struct fscrypt_policy_v2, defined as fol=
lows:: =20
> [...]
> >  If the file is not yet encrypted, then FS_IOC_SET_ENCRYPTION_POLICY
> >  verifies that the file is an empty directory.  If so, the specified
> > @@ -637,9 +634,8 @@ The FS_IOC_GET_ENCRYPTION_POLICY ioctl can also ret=
rieve the
> >  encryption policy, if any, for a directory or regular file.  However,
> >  unlike `FS_IOC_GET_ENCRYPTION_POLICY_EX`_,
> >  FS_IOC_GET_ENCRYPTION_POLICY only supports the original policy
> > -version.  It takes in a pointer directly to a :c:type:`struct
> > -fscrypt_policy_v1` rather than a :c:type:`struct
> > -fscrypt_get_policy_ex_arg`.
> > +version.  It takes in a pointer directly to struct fscrypt_policy_v1
> > +rather than struct fscrypt_get_policy_ex_arg. =20
>=20
> In some cases you deleted the "a" in "a struct" but in other cases you di=
dn't.
> Intentional?  It seems the file should consistently use one style or the =
other.

Yes, it was intentional. On almost all other docs documents I reviewed or
converted, they say "struct" instead of "a struct".

At the second version, I did the replacement on a consistent way.

>=20
> Also please use textwidth=3D70 for consistency with the rest of the file.

Done. At the new patch I posted, none of the lines touched by the
patch uses more than 70 columns.

You may notice that I opted to keep "struct foo" at the same line.
This is not a mandatory requirement for automarkup.py to work, but
I would recommend keeping them at the same line, as, if someone tries to
do something like:

	$ git grep "struct foo" Documentation/

It would be able to find them.


Thanks,
Mauro
