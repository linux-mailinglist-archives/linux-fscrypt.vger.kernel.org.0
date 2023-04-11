Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3BC6DE5C3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 22:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjDKUc5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Apr 2023 16:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDKUc4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Apr 2023 16:32:56 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73BD44B8
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 13:32:53 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id bv15so7803263ybb.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 13:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1681245173; x=1683837173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ikdi+6xxj2kvpls/7KRBOAg0lIkRgRoVXw8KwuRi4Nc=;
        b=IQ9zZGCNRzZwfZFuGDrY6qwE9SFscSfIixOwnA4rFQL16vvokxAcya+cMNiEJWF/lB
         jfUjEDfBjxQmhe/m3jewm7jJLjeF+tKcqSL03+AbqWymsVlf8EEP00s1SU0cxksL0zEq
         aELwAeeUCgGgh9NbZTSKlmYtsFMknlxQ5vc+LAgXie28umXXh7hhlP0K8oGds+yB5mEO
         vnwwKYtfeLTL9Ggt6AoI0LCSpTdf8MtVDWfJHa7h5gd+mCjLpYJP73Z+fFhKTpm6ehpS
         eULjph7vC73UZBatpFNnwz8A7xfnzCLiAhRTkuk93Tn1z4Nwff5SzQw+maLC17p1NBra
         luBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681245173; x=1683837173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ikdi+6xxj2kvpls/7KRBOAg0lIkRgRoVXw8KwuRi4Nc=;
        b=Rq9Afd+BgbcLbrqq2CNSI/FMZ8l2Z+B4iPIH+OFUR+8BDFCYX/oPuYUeYgGpp2DK88
         ih85WylYxBLNYDtBNMmebxQPajoRDIv9HL6ExZ4pWppreSL5qgVAFD56phbKtgTIITgE
         QU345WfCeXwB8UYpXIFTdHCB0BIRkn/L9vDy3BXWDchGSGu3GAtTRmAUBAuPGd9t1AUg
         n9YHxdfLKBlDQ71dZ8Nu3T8W8H1iPAi8445y7wxcAyap/ENOCETHYvtn16xWGiYoygvp
         nhFSJY9o5mxMVNoyBtvr3i7LaiJkmnYH7ShatsT4Xgoi8j0AR3ElbdNzid8CJF/OTzvQ
         H56A==
X-Gm-Message-State: AAQBX9eJ72ZkJNA3REwrTddrHkEV9dnM7cfS+MNZa8/edNyZxFcEiwDW
        DyBMHjrXkU+BOovbGi6fIitgOAHJX+t5chbIHO2N
X-Google-Smtp-Source: AKy350a8DI+fttqPGYGrYWlw3sZUgpf5kan6JSrYFZNA0OIQFLQ5A+goWX5p08tzzrk48yMapO6qwBhOBzk9Q/ypItw=
X-Received: by 2002:a25:d702:0:b0:b68:7a4a:5258 with SMTP id
 o2-20020a25d702000000b00b687a4a5258mr101812ybg.3.1681245172701; Tue, 11 Apr
 2023 13:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-4-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhS_EbT7ze4oSHwHfus91VWQfdgGagf=5O7_h+XJ2o79PA@mail.gmail.com> <20230410185334.GA18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230410185334.GA18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 11 Apr 2023 16:32:41 -0400
Message-ID: <CAHC9VhTRpDK74iL6A6wt2=--5LmrC7pHZY_BLnHDdfqboA2i1A@mail.gmail.com>
Subject: Re: [RFC PATCH v9 03/16] ipe: add evaluation loop and introduce
 'boot_verified' as a trust provider
To:     Fan Wu <wufan@linux.microsoft.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 10, 2023 at 2:53=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
> On Thu, Mar 02, 2023 at 02:03:11PM -0500, Paul Moore wrote:
> > On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft.com> wr=
ote:
> > >
> > > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > >
> > > IPE must have a centralized function to evaluate incoming callers
> > > against IPE's policy. This iteration of the policy against the rules
> > > for that specific caller is known as the evaluation loop.
> > >
> > > In addition, IPE is designed to provide system level trust guarantees=
,
> > > this usually implies that trust starts from bootup with a hardware ro=
ot
> > > of trust, which validates the bootloader. After this, the bootloader
> > > verifies the kernel and the initramfs.
> > >
> > > As there's no currently supported integrity method for initramfs, and
> > > it's typically already verified by the bootloader, introduce a proper=
ty
> > > that causes the first superblock to have an execution to be "pinned",
> > > which is typically initramfs.
> > >
> > > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> >
> > ...
> >
> > > ---
> > >  security/ipe/Makefile        |   1 +
> > >  security/ipe/eval.c          | 180 +++++++++++++++++++++++++++++++++=
++
> > >  security/ipe/eval.h          |  28 ++++++
> > >  security/ipe/hooks.c         |  25 +++++
> > >  security/ipe/hooks.h         |  14 +++
> > >  security/ipe/ipe.c           |   1 +
> > >  security/ipe/policy.c        |  20 ++++
> > >  security/ipe/policy.h        |   3 +
> > >  security/ipe/policy_parser.c |   8 +-
> > >  9 files changed, 279 insertions(+), 1 deletion(-)
> > >  create mode 100644 security/ipe/eval.c
> > >  create mode 100644 security/ipe/eval.h
> > >  create mode 100644 security/ipe/hooks.c
> > >  create mode 100644 security/ipe/hooks.h

...

> > > diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> > > new file mode 100644
> > > index 000000000000..48b5104a3463
> > > --- /dev/null
> > > +++ b/security/ipe/eval.c
> > > @@ -0,0 +1,180 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > > + */
> > > +
> > > +#include "ipe.h"
> > > +#include "eval.h"
> > > +#include "hooks.h"
> > > +#include "policy.h"
> > > +
> > > +#include <linux/fs.h>
> > > +#include <linux/types.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/file.h>
> > > +#include <linux/sched.h>
> > > +#include <linux/rcupdate.h>
> > > +#include <linux/spinlock.h>
> > > +
> > > +struct ipe_policy __rcu *ipe_active_policy;
> > > +
> > > +static struct super_block *pinned_sb;
> > > +static DEFINE_SPINLOCK(pin_lock);
> > > +#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
> > > +
> > > +/**
> > > + * pin_sb - Pin the underlying superblock of @f, marking it as trust=
ed.
> > > + * @f: Supplies a file structure to source the super_block from.
> > > + */
> > > +static void pin_sb(const struct file *f)
> > > +{
> > > +       if (!f)
> > > +               return;
> > > +       spin_lock(&pin_lock);
> > > +       if (pinned_sb)
> > > +               goto out;
> > > +       pinned_sb =3D FILE_SUPERBLOCK(f);
> > > +out:
> > > +       spin_unlock(&pin_lock);
> > > +}
> >
> > Since you don't actually use @f, just the super_block, you might
> > consider passing the super_block as the parameter and not the
> > associated file.
> >
> > I'd probably also flip the if-then to avoid the 'goto', for example:
> >
> >   static void pin_sb(const struct super_block *sb)
> >   {
> >     if (!sb)
> >       return;
> >     spin_lock(&pin_lock);
> >     if (!pinned_sb)
> >       pinned_sb =3D sb;
> >     spin_unlock(&pin_lock);
> >   }
> >
>
> Sure, I can change the code accordingly.
>
> > Also, do we need to worry about the initramfs' being unmounted and the
> > super_block going away?
>
> If initramfs is being unmounted, the boot_verified property will never be=
 TRUE,
> which is an expected behavior. In an actual use case, we can leverage thi=
s
> property to only enable files in initramfs during the booting stage, and =
later switch
> to another policy without the boot_verified property after unmounting the=
 initramfs.
> This approach helps keep the allowed set of files minimum at each stage.

I think I was worried about not catching when the fs was unmounted and
the superblock disappeared, but you've got a hook defined for that so
it should be okay.  I'm not sure what I was thinking here, sorry for
the noise ...

Regardless of the source of my confusion, your policy/boot_verified
description all sounds good to me.

--=20
paul-moore.com
