Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74328EB663
	for <lists+linux-fscrypt@lfdr.de>; Thu, 31 Oct 2019 18:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbfJaRwg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 31 Oct 2019 13:52:36 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37699 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729143AbfJaRwf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 31 Oct 2019 13:52:35 -0400
Received: by mail-io1-f65.google.com with SMTP id 1so7735249iou.4
        for <linux-fscrypt@vger.kernel.org>; Thu, 31 Oct 2019 10:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mxV+2q76TOXqdkYGmWgrFX3noerT+2XT5stD2pDGxy4=;
        b=D6C1yVuRrDhf4QkrhECxb4poSSgofQd6d8y3lwuDnDDo8D10nO6Ax5FRjL4ps/cBH2
         kibSwzCfBDl1f7CMhlXY1kciz6oFkW7LsIrytUSfdoT6ANPyz6PU14U40ImfzEl2fu5d
         06UoCcfFhGpPMpgbOenFHbl2nIwNSPRnbySfc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mxV+2q76TOXqdkYGmWgrFX3noerT+2XT5stD2pDGxy4=;
        b=HUScpWNVEAtkv6xt+KwAcbGfprtZaABNHQLjxHWgjuxyDhc0OCl2Uu3LdlGOQU6pst
         t3aR6sE3wImxxrh2pby4BXk4wWXIOq2Em1j21Sd+UGQvvbY9nxdYUBlt537ckY9gHNNa
         KjSk6xu8JekBX/MZ39+dxIYxKnWgFvlDtzr1+wr6zfSHmX0Vh+dSZahT9tu3SquxSTVC
         vq0BMo9mUrv1aU/q6SgBT/Sx3hLd7bWsFg9Tinf2aruP8wcTR33J1MNp9YzuJXTChACw
         FT2Ghwem1mi0m+q/pFhZ9hYBrCx73CNKU5nkA/70rSe0s3kiHLo7rCVtwgIbKzXlsfoc
         Jn+w==
X-Gm-Message-State: APjAAAVH7G9ADghX/veWTzXWtCEvQq/qPDAwaejjFyHW9/L/ulZvzdnv
        6ppaaQLOF/EzXw5KkWmKvInVWEtxXB8=
X-Google-Smtp-Source: APXvYqwKvwxCXBuJWasQxbIhZ7d7Nv9Pkr+YLNxEE/xLR2NBG6tFtMjGafltqlk10ICkYNDkQhuoUQ==
X-Received: by 2002:a6b:8bcc:: with SMTP id n195mr6006620iod.135.1572544354588;
        Thu, 31 Oct 2019 10:52:34 -0700 (PDT)
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com. [209.85.166.181])
        by smtp.gmail.com with ESMTPSA id v28sm662002ill.74.2019.10.31.10.52.32
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 10:52:33 -0700 (PDT)
Received: by mail-il1-f181.google.com with SMTP id s75so6177472ilc.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 31 Oct 2019 10:52:32 -0700 (PDT)
X-Received: by 2002:a92:ba1b:: with SMTP id o27mr7815343ili.269.1572544351933;
 Thu, 31 Oct 2019 10:52:31 -0700 (PDT)
MIME-Version: 1.0
References: <20191030100618.1.Ibf7a996e4a58e84f11eec910938cfc3f9159c5de@changeid>
 <20191030173758.GC693@sol.localdomain> <CAD=FV=Uzma+eSGG1S1Aq6s3QdMNh4J-c=g-5uhB=0XBtkAawcA@mail.gmail.com>
 <20191030190226.GD693@sol.localdomain> <20191030205745.GA216218@sol.localdomain>
 <CAD=FV=X6Q3QZaND-tfYr9mf-KYMeKFmJDca3ee-i9roWj+GHsQ@mail.gmail.com>
In-Reply-To: <CAD=FV=X6Q3QZaND-tfYr9mf-KYMeKFmJDca3ee-i9roWj+GHsQ@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 31 Oct 2019 10:52:19 -0700
X-Gmail-Original-Message-ID: <CAD=FV=URZX4t-TB2Ne8y5ZfeBGoyhsPZhcncQ0yPe3cRXi=1gw@mail.gmail.com>
Message-ID: <CAD=FV=URZX4t-TB2Ne8y5ZfeBGoyhsPZhcncQ0yPe3cRXi=1gw@mail.gmail.com>
Subject: Re: [PATCH] Revert "ext4 crypto: fix to check feature status before
 get policy"
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Gwendal Grignou <gwendal@chromium.org>, Chao Yu <chao@kernel.org>,
        Ryo Hashimoto <hashimoto@chromium.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        Guenter Roeck <groeck@chromium.org>, apronin@chromium.org,
        linux-doc@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

On Wed, Oct 30, 2019 at 2:59 PM Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Wed, Oct 30, 2019 at 1:57 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > FWIW, from reading the Chrome OS code, I think the code you linked to isn't
> > where the breakage actually is.  I think it's actually at
> > https://chromium.googlesource.com/chromiumos/platform2/+/refs/heads/master/chromeos-common-script/share/chromeos-common.sh#375
> > ... where an init script is using the error message printed by 'e4crypt
> > get_policy' to decide whether to add -O encrypt to the filesystem or not.
> >
> > It really should check instead:
> >
> >         [ -e /sys/fs/ext4/features/encryption ]
>
> OK, I filed <https://crbug.com/1019939> and CCed all the people listed
> in the cryptohome "OWNERS" file.  Hopefully one of them can pick this
> up as a general cleanup.  Thanks!

Just to follow-up: I did a quick test here to see if I could fix
"chromeos-common.sh" as you suggested.  Then I got rid of the Revert
and tried to login.  No joy.

Digging a little deeper, the ext4_dir_encryption_supported() function
is called in two places:
* chromeos-install
* chromeos_startup

In my test case I had a machine that I'd already logged into (on a
previous kernel version) and I was trying to log into it a second
time.  Thus there's no way that chromeos-install could be involved.
Looking at chromeos_startup:

https://chromium.googlesource.com/chromiumos/platform2/+/refs/heads/master/init/chromeos_startup

...the function is only used for setting up the "encrypted stateful"
partition.  That wasn't where my failure was.  My failure was with
logging in AKA with cryptohome.  Thus I think it's plausible that my
original commit message pointing at cryptohome may have been correct.
It's possible that there were _also_ problems with encrypted stateful
that I wasn't noticing, but if so they were not the only problems.

It still may be wise to make Chrome OS use different tests, but it
might not be quite as simple as hoped...

-Doug
