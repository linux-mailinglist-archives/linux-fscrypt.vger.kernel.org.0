Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224D9EC85B
	for <lists+linux-fscrypt@lfdr.de>; Fri,  1 Nov 2019 19:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfKASSA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 1 Nov 2019 14:18:00 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:44647 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfKASSA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 1 Nov 2019 14:18:00 -0400
Received: by mail-yb1-f196.google.com with SMTP id g38so3900247ybe.11
        for <linux-fscrypt@vger.kernel.org>; Fri, 01 Nov 2019 11:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K1dOhbDvlz+VXkT92swPjrnBtSngUC8vWTfrXwwNhyY=;
        b=CLO5Qm/PlPPjpWrndTxBcyLtDMn89fyBXHpnWCS+nH1k4WHVUnqU8ZK4hXdXEUA+fe
         yzFHMHp8geEjZm/iQfH5Vx4Vyavb1HFA8BIQDZkPCodULlTm1UR7qPd2F3P02uahDFGM
         lRC1/Fg0B2tWwvqbhgJdzUJ6CqGyqBjPKZG0WUq31dRZ+Cf2GRNn9d5StDnhkVkHXORk
         Im3rlB1ClPvVVALs0auqckzKgNds0CIZZC49294cGrDtsrMm8DVIVcJu59EeUCCC1TDK
         POBWVCuhJp13dxhIGFRSJdyJE8u7aErOjlx3iXWcff0MMRyph0H3cnDyP0DzVyshrIty
         JJJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K1dOhbDvlz+VXkT92swPjrnBtSngUC8vWTfrXwwNhyY=;
        b=qwzL9YN8chyVY4XZHEN+EM9W2lRfnQGYUr/c25z18Vd1S6jtEgjobQIgK0pdO+F3kU
         cOR6EkwsvvOdGumr/zdT/X6Vi0dRgtzKDj4vqcQw5CihI/CY+aR9kv2s0/p1y8aeSJ2y
         2kIZ7JgYRZZjDimyowE9rVCxOus7Dz2woPovBZVPgvmW3zWcRctxFGvbVmeWb6lY+LZR
         7Z2YRm6F0ngiw/GODKXB+BVo2CqnfjgmBZfDKIJVZCOiGpFF9IS/jsH8joif6ycnePQu
         FfzGFMOcn1qeaCLjwPsURvxZnIR3M9ozdF0jcHbgHp3NpvC85pyhCiyiDWXNmVHkOgEE
         qBmw==
X-Gm-Message-State: APjAAAUZlUNr9DRJVagqv/RHFCMKE97bbfDDjxesOWSWYHSFK/HfoN/Y
        wtUlar5Zzc05CrUNGQm9Mn/JJSeeiFYg3cx2jbttTQ==
X-Google-Smtp-Source: APXvYqxo0mSU502NSpYWvdOeGh//uDeakjnxwpfotuR+Ml3IAbrPchH2s+feB5U1ZnKWNyEMuck/yacSnujP2IInM5w=
X-Received: by 2002:a25:cf8c:: with SMTP id f134mr10567617ybg.45.1572632278924;
 Fri, 01 Nov 2019 11:17:58 -0700 (PDT)
MIME-Version: 1.0
References: <20191030100618.1.Ibf7a996e4a58e84f11eec910938cfc3f9159c5de@changeid>
 <20191030173758.GC693@sol.localdomain> <CAD=FV=Uzma+eSGG1S1Aq6s3QdMNh4J-c=g-5uhB=0XBtkAawcA@mail.gmail.com>
 <20191030190226.GD693@sol.localdomain> <20191030205745.GA216218@sol.localdomain>
 <CAD=FV=X6Q3QZaND-tfYr9mf-KYMeKFmJDca3ee-i9roWj+GHsQ@mail.gmail.com>
 <CAD=FV=URZX4t-TB2Ne8y5ZfeBGoyhsPZhcncQ0yPe3cRXi=1gw@mail.gmail.com> <20191101043620.GA703@sol.localdomain>
In-Reply-To: <20191101043620.GA703@sol.localdomain>
From:   Guenter Roeck <groeck@google.com>
Date:   Fri, 1 Nov 2019 11:17:47 -0700
Message-ID: <CABXOdTddU2Kn8hJyofAC9eofZHAA4ddBhjNXc8GwC5dm3beMZA@mail.gmail.com>
Subject: Re: [PATCH] Revert "ext4 crypto: fix to check feature status before
 get policy"
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Doug Anderson <dianders@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        Chao Yu <chao@kernel.org>,
        Ryo Hashimoto <hashimoto@chromium.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        Guenter Roeck <groeck@chromium.org>,
        Andrey Pronin <apronin@chromium.org>,
        linux-doc@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 31, 2019 at 9:36 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Oct 31, 2019 at 10:52:19AM -0700, Doug Anderson wrote:
> > Hi,
> >
> > On Wed, Oct 30, 2019 at 2:59 PM Doug Anderson <dianders@chromium.org> wrote:
> > >
> > > Hi,
> > >
> > > On Wed, Oct 30, 2019 at 1:57 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > FWIW, from reading the Chrome OS code, I think the code you linked to isn't
> > > > where the breakage actually is.  I think it's actually at
> > > > https://chromium.googlesource.com/chromiumos/platform2/+/refs/heads/master/chromeos-common-script/share/chromeos-common.sh#375
> > > > ... where an init script is using the error message printed by 'e4crypt
> > > > get_policy' to decide whether to add -O encrypt to the filesystem or not.
> > > >
> > > > It really should check instead:
> > > >
> > > >         [ -e /sys/fs/ext4/features/encryption ]
> > >
> > > OK, I filed <https://crbug.com/1019939> and CCed all the people listed
> > > in the cryptohome "OWNERS" file.  Hopefully one of them can pick this
> > > up as a general cleanup.  Thanks!
> >
> > Just to follow-up: I did a quick test here to see if I could fix
> > "chromeos-common.sh" as you suggested.  Then I got rid of the Revert
> > and tried to login.  No joy.
> >
> > Digging a little deeper, the ext4_dir_encryption_supported() function
> > is called in two places:
> > * chromeos-install
> > * chromeos_startup
> >
> > In my test case I had a machine that I'd already logged into (on a
> > previous kernel version) and I was trying to log into it a second
> > time.  Thus there's no way that chromeos-install could be involved.
> > Looking at chromeos_startup:
> >
> > https://chromium.googlesource.com/chromiumos/platform2/+/refs/heads/master/init/chromeos_startup
> >
> > ...the function is only used for setting up the "encrypted stateful"
> > partition.  That wasn't where my failure was.  My failure was with
> > logging in AKA with cryptohome.  Thus I think it's plausible that my
> > original commit message pointing at cryptohome may have been correct.
> > It's possible that there were _also_ problems with encrypted stateful
> > that I wasn't noticing, but if so they were not the only problems.
> >
> > It still may be wise to make Chrome OS use different tests, but it
> > might not be quite as simple as hoped...
> >
>
> Ah, I think I found it:
>
> https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/2cbdedd5eca0a57d9596671a99da5fab8e60722b/sys-apps/upstart/files/upstart-1.2-dircrypto.patch
>
> The init process does EXT4_IOC_GET_ENCRYPTION_POLICY on /, and if the error is
> EOPNOTSUPP, it skips creating the "dircrypto" keyring.  So then cryptohome can't
> add keys later.  (Note the error message you got, "Error adding dircrypto key".)
>
> So it looks like the kernel patch broke both that and
> ext4_dir_encryption_supported().
>

ext4_dir_encryption_supported() was already changed to use the sysfs
file, and changing the upstart code to check the sysfs file does
indeed fix the problem for good. I'll do some more tests and push the
necessary changes into our code base if I don't hit some other issue.

> I don't see how it could have broken cryptohome by itself, since AFAICS
> cryptohome only uses EXT4_IOC_GET_ENCRYPTION_POLICY on the partition which is
> supposed to have the 'encrypt' feature set.
>
Yes, indeed it seems as if that is unrelated.

Guenter
