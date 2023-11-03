Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E825B7E0B2D
	for <lists+linux-fscrypt@lfdr.de>; Fri,  3 Nov 2023 23:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbjKCWaX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 3 Nov 2023 18:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjKCWaW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 3 Nov 2023 18:30:22 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028F9D64
        for <linux-fscrypt@vger.kernel.org>; Fri,  3 Nov 2023 15:30:18 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-5a7b3d33663so31011347b3.3
        for <linux-fscrypt@vger.kernel.org>; Fri, 03 Nov 2023 15:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1699050617; x=1699655417; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OOhQ+4ppHia6X5vZEThJt6hjspNBijG8E4l1rtJpvmc=;
        b=Fb+t+TGVFWJo9Lt7NqbDpiCp5KTiTLq3qWK2F8FUuNtUM5WTuaxGb0+z1NVnqotvW1
         2qZn6RS+Srkmk93yyT+/Ms2J3a7yxlyceX7Ft6kBLCx2jcS7lEJy9zgxUQXVHzj4blHS
         fyr7qxkrJU2HwS9ru50vk3tZdpJzSWKa2JEcflHAIVzuA7GESxwEJtB/bI3b70A9QUXa
         doEEoLqOl5hoHhMwCKdm/XfcW/zcTZPHZcjWSio+N81QNCrj++ZcVtYVoo53MGlrHnkn
         WkerntN/joI4lYf51rws1n6PycdZxbZwUR8MePbvYxSxCedAqTx+o/U0M0YpVs5udBPf
         IO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699050617; x=1699655417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOhQ+4ppHia6X5vZEThJt6hjspNBijG8E4l1rtJpvmc=;
        b=MWOGJLSAoiHQGb24kqhet5N/xkxxkIxklW7qxsUUSZbezC0fTpa5/UnV7RMDZpUUdI
         F5gJykFdNHZbE/nDJKR6A5x83PvEW1lfsjoAEnQER+eeQW+iRBAvJvLeW98XIJ9mEaq4
         1Vu7bdDbgStQX44PGCizPIhc3L2RNhrc3CcV8YAhO+eutiReAitTK5AELHG0evLN3BI/
         NWPLtQ9u12rIjXyRR0HZrOuhJ4iKP/apKZ/p0zSh9JXjPDz825i0YWhGJ3ZlVGH6MvPD
         G4AYZHnEj5RDwxm5xcWye+i5Qsa1cMqV7asNNI/l3g73JBAEoyIAB5ceVH5QtZ+1varU
         1Ggg==
X-Gm-Message-State: AOJu0YzvREWTF/kwtRNFjb2no8kaKwjqfFbooAbG8xv/sNQ149PRSsdM
        uTzwtaHYufgzOaj2o0GfsDDieYUhxQrNYDSCJ0DR
X-Google-Smtp-Source: AGHT+IGnpRgvInClOyTeRts44EfuCsVIf/oEzDvkRyvT0ioHtkFzmAn/jixwPJXsOyu5FJvaQ36V6EmrXY08ildtF/Y=
X-Received: by 2002:a25:8590:0:b0:da0:cf4b:c504 with SMTP id
 x16-20020a258590000000b00da0cf4bc504mr23753840ybk.8.1699050616923; Fri, 03
 Nov 2023 15:30:16 -0700 (PDT)
MIME-Version: 1.0
References: <1696457386-3010-6-git-send-email-wufan@linux.microsoft.com>
 <c53599e9d278fc55be30e3bac9411328.paul@paul-moore.com> <616a6fd7-47b1-4b46-af23-46f9b1a3eedf@linux.microsoft.com>
 <CAHC9VhScdtqJeUTTUQVk4D70tTLz4TgU_aRTMRnHa0OARyubaw@mail.gmail.com>
 <c40cd6a6-5c32-4e72-8831-f87ee0a09324@linux.microsoft.com> <CAHC9VhR9scT7V7dvN5zhAYdExORB9arWaR7Gbix1AUtAMDPHcg@mail.gmail.com>
In-Reply-To: <CAHC9VhR9scT7V7dvN5zhAYdExORB9arWaR7Gbix1AUtAMDPHcg@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 3 Nov 2023 18:30:16 -0400
Message-ID: <CAHC9VhQLbgvg6syOB2_GYFK+zpWbyx6zrDoM1aBnA18u_Qjj4g@mail.gmail.com>
Subject: Re: [PATCH RFC v11 5/19] ipe: introduce 'boot_verified' as a trust provider
To:     Fan Wu <wufan@linux.microsoft.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 3, 2023 at 6:15=E2=80=AFPM Paul Moore <paul@paul-moore.com> wro=
te:
> On Thu, Nov 2, 2023 at 6:46=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com>=
 wrote:
> > On 10/26/2023 3:12 PM, Paul Moore wrote:
> > > On Thu, Oct 26, 2023 at 5:33=E2=80=AFPM Fan Wu <wufan@linux.microsoft=
.com> wrote:
> > >> On 10/23/2023 8:52 PM, Paul Moore wrote:
> > >>> On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > >>>>
> > >>>> IPE is designed to provide system level trust guarantees, this usu=
ally
> > >>>> implies that trust starts from bootup with a hardware root of trus=
t,
> > >>>> which validates the bootloader. After this, the bootloader verifie=
s the
> > >>>> kernel and the initramfs.
> > >>>>
> > >>>> As there's no currently supported integrity method for initramfs, =
and
> > >>>> it's typically already verified by the bootloader, introduce a pro=
perty
> > >>>> that causes the first superblock to have an execution to be "pinne=
d",
> > >>>> which is typically initramfs.
> > >>>>
> > >>>> When the "pinned" device is unmounted, it will be "unpinned" and
> > >>>> `boot_verified` property will always evaluate to false afterward.
> > >>>>
> > >>>> We use a pointer with a spin_lock to "pin" the device instead of r=
cu
> > >>>> because rcu synchronization may sleep, which is not allowed when
> > >>>> unmounting a device.
> > >>>>
> > >>>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > >>>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > >> ...
> > >>>> ---
> > >>>>    security/ipe/eval.c          | 72 +++++++++++++++++++++++++++++=
++++++-
> > >>>>    security/ipe/eval.h          |  2 +
> > >>>>    security/ipe/hooks.c         | 12 ++++++
> > >>>>    security/ipe/hooks.h         |  2 +
> > >>>>    security/ipe/ipe.c           |  1 +
> > >>>>    security/ipe/policy.h        |  2 +
> > >>>>    security/ipe/policy_parser.c | 35 +++++++++++++++++-
> > >>>>    7 files changed, 124 insertions(+), 2 deletions(-)
>
> ...
>
> > >>>> +/**
> > >>>> + * from_pinned - Determine whether @sb is the pinned super_block.
> > >>>> + * @sb: Supplies a super_block to check against the pinned super_=
block.
> > >>>> + *
> > >>>> + * Return:
> > >>>> + * * true   - @sb is the pinned super_block
> > >>>> + * * false  - @sb is not the pinned super_block
> > >>>> + */
> > >>>> +static bool from_pinned(const struct super_block *sb)
> > >>>> +{
> > >>>> +    bool rv;
> > >>>> +
> > >>>> +    if (!sb)
> > >>>> +            return false;
> > >>>> +    spin_lock(&pin_lock);
> > >>>> +    rv =3D !IS_ERR_OR_NULL(pinned_sb) && pinned_sb =3D=3D sb;
> > >>>> +    spin_unlock(&pin_lock);
> > >>>
> > >>> It's okay for an initial version, but I still think you need to get
> > >>> away from this spinlock in from_pinned() as quickly as possible.
> > >>> Maybe I'm wrong, but this looks like a major source of lock content=
ion.
> > >>>
> > >>> I understand the issue around RCU and the potential for matching on
> > >>> a reused buffer/address, but if you modified IPE to have its own LS=
M
> > >>> security blob in super_block::security you could mark the superbloc=
k
> > >>> when it was mounted and do a lockless lookup here in from_pinned().
> > >>
> > >> Thank you for the suggestion. After some testing, I discovered that
> > >> switching to RCU to pin the super block and using a security blob to
> > >> mark a pinned super block works. This approach do avoid many spinloc=
k
> > >> operations. I'll incorporate these changes in the next version of th=
e patch.
> > >
> > > I probably wasn't as clear as I should have been, I was thinking of
> > > doing away with the @pinned_sb global variable entirely, as well as
> > > its associated lock problems and simply marking the initramfs/initrd
> > > superblock when it was mounted.  I will admit that I haven't fully
> > > thought about all the implementation details, but I think you could
> > > leverage the security_sb_mount() hook to set a flag in IPE's
> > > superblock metadata when the initramfs was mounted.
> >
> > I wasn't able to find a way to let LSM pin initramfs/initrd during moun=
t
> > time ...
>
> I haven't had to look at the kernel init code in a while, and I don't
> recall ever looking at the initramfs code, but I spent some time
> digging through the code and I wonder if it would be possible to mark
> the initramfs superblock in wait_for_initramfs() via a new LSM hook
> using @current->fs->root.mnt->mnt_sb?  Although I'm not completely
> sure that it's populated.  Have you already looked at an approach like
> this?

Thinking about this more, the current IPE approach of treating the
first file access as being present in the initramfs is not correct
(one could build a system without an initramfs).  I think we need to
do something like the above where the initramfs is explicitly marked
in the initramfs code.

> > But I think we could replace the global variable with a flag
> > variable ipe_sb_state so we could use atomic operation to only mark one
> > drive as pinned without any lock. The code will be like:
> >
> > static void pin_sb(const struct super_block *sb)
> > {
> >         if (!sb)
> >                 return;
> >
> >         if (!test_and_set_bit_lock(IPE_SB_PINNED, &ipe_sb_state)) {
> >                 ipe_sb(sb)->pinned =3D true;
> >         }
> > }
> >
> > Would this sound better?

--=20
paul-moore.com
