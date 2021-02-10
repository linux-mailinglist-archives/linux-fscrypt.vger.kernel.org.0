Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DB03170E8
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Feb 2021 21:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbhBJUIs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 10 Feb 2021 15:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbhBJUIn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 10 Feb 2021 15:08:43 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA423C061574
        for <linux-fscrypt@vger.kernel.org>; Wed, 10 Feb 2021 12:08:03 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id m6so2020599pfk.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 10 Feb 2021 12:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2yRrcSKsOtC1XZbY2o8cEC7UMHBxY87BwK9iZzMwK1Q=;
        b=MHgqbdfeiCYO8L9LAcJsTTovv+bJV+RlIDvmrotvvB2d/Vyn/hV/HWxtu6jkQGOk0H
         5IQ9OsOy+zfYEs0Tk1ojlC/+NsDWtMgxPW31mPqV3SbuqI7ahuxcyif6+gm+uFd4fjUU
         xnng+M1kY4AEfGC9bYuOhq7ckgP8KMk56CEmsjWa+2I6ZeJSD4QxVwaYzBKdwAL0Tvd1
         DefFmhxdXSqrwbIthE2XFU4/v1h5oUP4TYwcmujqXat9s7ukR4sAl+N+VgI4Z3QNAApq
         V3PSRGZ1O+bU4nxh3SHPgHtf/emWKqqtrzcq1Ma1MA1a+ocG8XcHjoPWCS0FYLWd0qai
         xmiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2yRrcSKsOtC1XZbY2o8cEC7UMHBxY87BwK9iZzMwK1Q=;
        b=hnWOHID1r8mabb/LnniXS8as/7UYSAyHKEOWwFVban+WT6e1fQWNKdFWaiYc/SkS62
         OSjC470kqVgacvtNXHXVff8FFLvE/Yhld0LlCHs8j2IhBxoeZ0m7m2HxDEzfsiSxxI2f
         bGRVK0YS3zgPhZ7gA0wwXjbUF74txX35aO/E9LPtyehs30WUwAun/i1z+qzDhFt02Uqh
         +ftVODI1H85sb8xzttWVr4uGcnTPz+ennLVt/XGQB15eMAyNAg1KPcCT/AYujbWMUOdN
         ZP2QQBJMgJWwzepKSIl2QXpoGqm46gCLG/G6iAQk2Znp0oGmYVV/AJCMbGZCFyFeSH9K
         AgMQ==
X-Gm-Message-State: AOAM533qcoagOh/mdIQLhs9r+2mtaXdZddUY0eadPQ7RubMvi33NfNRe
        9jne5ePoFZEcggsP3m32XWiQTFVpVMjyW0JMM0xEvdohvJQ=
X-Google-Smtp-Source: ABdhPJxvGvxwBFniBCFX1vHS6vEEM5L19g5HShu6X1njvHIMGROqMYFgTpaLthYrjTJNPHDoS8vYBBdB9LbkBed0908=
X-Received: by 2002:a63:4a1a:: with SMTP id x26mr4811634pga.260.1612987683244;
 Wed, 10 Feb 2021 12:08:03 -0800 (PST)
MIME-Version: 1.0
References: <c311c77131d0b146f00ab000104bd38e6fbc6b94.camel@redhat.com>
 <YCQcj0jQ5/sywDgT@sol.localdomain> <7fa8fc3ac6e15015df1ce5f3213e9901d98ffedd.camel@redhat.com>
In-Reply-To: <7fa8fc3ac6e15015df1ce5f3213e9901d98ffedd.camel@redhat.com>
From:   Thibaud Ecarot <thibaud.ecarot@gmail.com>
Date:   Wed, 10 Feb 2021 15:07:52 -0500
Message-ID: <CA+XEK3nU1jPHJ=FsJf+0rZ=KkNuuGZvo7WeBSpXUu3ytuFQEvw@mail.gmail.com>
Subject: Re: fscrypt and FIPS
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, Simo Sorce <ssorce@redhat.com>,
        linux-fscrypt <linux-fscrypt@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi folks,

HKDF is widely used in various HSM so this is necessarily compliant
with FIPS 140-3 or 140-2. I have in mind Thales Luna HSM. I am curious
why this statement was made on your side.

Thanks Jeff.

Thibaud


Le mer. 10 f=C3=A9vr. 2021, =C3=A0 14 h 30, Jeff Layton <jlayton@redhat.com=
> a =C3=A9crit :
>
> On Wed, 2021-02-10 at 09:49 -0800, Eric Biggers wrote:
> > On Wed, Feb 10, 2021 at 08:14:08AM -0500, Jeff Layton wrote:
> > > Hi Eric,
> > >
> > > I'm still working on the ceph+fscrypt patches (it's been slow going, =
but
> > > I am making progress). Eventually RH would like to ship this as a
> > > feature, but there is one potential snag that  -- a lot of our custom=
ers
> > > need their boxes to be FIPS-enabled [1].
> > >
> > > Most of the algorithms and implementations that fscrypt use are OK, b=
ut
> > > HKDF is not approved outside of TLS 1.3. The quote from our lab folks
> > > is:
> > >
> > > "HKDF is not approved as a general-purpose KDF, but only for SP800-56=
C
> > > rev2 compliant use. That means that HKDF is only to be used to derive=
 a
> > > key from a ECDH/DH or RSA-wrapped shared secret. This includes TLS 1.=
3."
> > >
> > > Would you be amenable to allowing the KDF to be pluggable in some
> > > fashion, like the filename and content encryption algorithms are? It
> > > would be nice if we didn't have to disable this feature on FIPS-enabl=
ed
> > > boxes.
> > >
> > > [1]: https://www.nist.gov/itl/fips-general-information
> > >
> > > Thanks!
> > > --
> > > Jeff Layton <jlayton@redhat.com>
> >
> > Can you elaborate on why you think that HKDF isn't FIPS approved?  It's=
 been
> > recommended by NIST 800-56C since 2011, and almost any cryptographic ap=
plication
> > developed within the last 10 years is likely to be using HKDF, if it ne=
eds a
> > non-passphrase based KDF.
> >
> > In fact one of the reasons for switching from the weird AES-ECB-based K=
DF used
> > in v1 encryption policies to HKDF-SHA512 is that HKDF is much more stan=
dard.
> >
> > Are you sure you're looking at the latest version of FIPS?
> >
> > And if HKDF isn't approved, what *is* approved, exactly?
> >
> > As far as supporting a new KDF if it were necessary, one of the reserve=
d fields
> > in fscrypt_add_key_arg, fscrypt_policy_v2, fscrypt_context_v2, and
> > fscrypt_provisioning_key_payload could be used to specify the KDF.  Thi=
s would
> > the first time someone has done so, so there would also be work require=
d to add
> > a '--kdf' parameter to the userspace tools, and make the kernel keep tr=
ack of
> > the keys for each KDF version separately.  Plus maybe some other things=
 too.
> >
> > I did figure that a new KDF might have to be supported eventually, but =
not to
> > replace the HKDF construction (which is provably secure), but rather if=
 someone
> > wants to use something other than SHA-512 (which isn't provably secure)=
.  I'm
> > not too enthusiastic about adding another KDF that uses the same underl=
ying hash
> > function, as there would be no technical reason for this.
> >
> > Note that the fscrypt userspace tool (https://github.com/google/fscrypt=
) also
> > uses HKDF for a key derivation step in userspace, separately from the k=
ernel.
> > I suppose you'd want to change that too?
> >
> >
>
> Bah, I meant to cc Simo on this since he's the one who brought it up. I
> know just enough to be dangerous.
>
> Simo, can you answer Eric's questions, or loop in someone who can?
>
> Thanks,
> --
> Jeff Layton <jlayton@redhat.com>
>


--=20
Thibaud ECAROT
