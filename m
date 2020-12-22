Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327142E0350
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 01:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgLVAMQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 19:12:16 -0500
Received: from mail-lf1-f46.google.com ([209.85.167.46]:35158 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgLVAMQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 19:12:16 -0500
Received: by mail-lf1-f46.google.com with SMTP id h22so18347345lfu.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 16:11:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rejQrtbwF6EjNP6IjovgIbHCtCSocl644+WLcgfhOtA=;
        b=iio1MyV/B3mguCoY4UHqdHhx6EFLzje4jofxWEM+qjfh1PCh22visXfeJaHynrGsSP
         D1Hdn3hwWracDIPMMP1OoRpzXr/3DBGwmyLEvLtVbipM4cCuP+EVgwTFt7Flx12NH6Y+
         EKL6LYX5CXLI4SS9Ns1N5myRdsnyMaxLCE4UOaAyGGbzLI/Oi3o/XFPAG6KUa82KrF/0
         Fl8cbLE0vRBsCNasL/FOYrdRWMOeywNOK3i852kHZQ0Tbz/hp7hNfda+95a8cqcyXEfo
         XpMBF4ik6uUULoEr5itlI2BUKBa6/EvjnHA3HRZ2QF76txw+V0ETTPTssSt+oAaWjImI
         TKYw==
X-Gm-Message-State: AOAM532HBcxtuALvNS3o5eJ7nlCzQeYO3p6LoGfnZTNP6PwYGMaHhTST
        PDeuA8jJVCJyPTsG2fe9O0qlWxsIgJHG4w==
X-Google-Smtp-Source: ABdhPJzZniXZw0m6MrkiGo5bkuKIhfJF3/2te8fONMseXcgYOdGqYpitKA2WCog17uzJPXyij7pYPw==
X-Received: by 2002:a05:6512:693:: with SMTP id t19mr8149060lfe.22.1608595893054;
        Mon, 21 Dec 2020 16:11:33 -0800 (PST)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id i19sm2485250ljj.26.2020.12.21.16.11.32
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 16:11:32 -0800 (PST)
Received: by mail-lf1-f52.google.com with SMTP id 23so27816659lfg.10
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 16:11:32 -0800 (PST)
X-Received: by 2002:a19:10:: with SMTP id 16mr7507742lfa.334.1608595892123;
 Mon, 21 Dec 2020 16:11:32 -0800 (PST)
MIME-Version: 1.0
References: <20201221221953.256059-1-bluca@debian.org> <20201221232428.298710-1-bluca@debian.org>
 <20201221232428.298710-3-bluca@debian.org> <X+E1a5jRbkZzS3j4@sol.localdomain>
 <CAMw=ZnTm7TOWg=yBeYr6tnpLux_pU7QXH3OtfPW3Rd1reuAtgA@mail.gmail.com> <X+E3wa/sdzGDHf7I@sol.localdomain>
In-Reply-To: <X+E3wa/sdzGDHf7I@sol.localdomain>
From:   Luca Boccassi <bluca@debian.org>
Date:   Tue, 22 Dec 2020 00:11:20 +0000
X-Gmail-Original-Message-ID: <CAMw=ZnR0=eJA+_bvxU-Da09jmJ0okQ4k71AfpOVmgM_PknucCg@mail.gmail.com>
Message-ID: <CAMw=ZnR0=eJA+_bvxU-Da09jmJ0okQ4k71AfpOVmgM_PknucCg@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] Allow to build and run sign/digest on Windows
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org,
        Luca Boccassi <luca.boccassi@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 22 Dec 2020 at 00:03, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Dec 21, 2020 at 11:57:41PM +0000, Luca Boccassi wrote:
> > On Mon, 21 Dec 2020 at 23:53, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Mon, Dec 21, 2020 at 11:24:28PM +0000, Luca Boccassi wrote:
> > > > +### Building on Windows
> > > > +
> > > > +There is minimal support for building Windows executables using MinGW.
> > > > +```bash
> > > > +    make CC=x86_64-w64-mingw32-gcc-win32
> > > > +```
> > > > +
> > > > +`fsverity.exe` will be built, and it supports the `digest` and `sign` commands.
> > > > +
> > > > +A Windows build of OpenSSL/libcrypto needs to be available.
> > >
> > > For me "CC=x86_64-w64-mingw32-gcc-win32" doesn't work; I need
> > > "x86_64-w64-mingw32-gcc" instead.  Is this difference intentional?
> > >
> > > - Eric
> >
> > It's a distro setup difference I think, on Debian
> > x86_64-w64-mingw32-gcc is a symlink to x86_64-w64-mingw32-gcc-win32:
> >
> > $ ls -l /usr/bin/x86_64-w64-mingw32-gcc-win32
> > -rwxr-xr-x 2 root root 1160320 Nov 27 05:57
> > /usr/bin/x86_64-w64-mingw32-gcc-win32
> > $ ls -l /usr/bin/x86_64-w64-mingw32-gcc
> > lrwxrwxrwx 1 root root 40 Sep 27 18:41 /usr/bin/x86_64-w64-mingw32-gcc
> > -> /etc/alternatives/x86_64-w64-mingw32-gcc
> > $ ls -l /etc/alternatives/x86_64-w64-mingw32-gcc
> > lrwxrwxrwx 1 root root 37 Sep 27 18:44
> > /etc/alternatives/x86_64-w64-mingw32-gcc ->
> > /usr/bin/x86_64-w64-mingw32-gcc-win32
>
> Okay, it would be better to document the one that works on all distros.
>
> - Eric

Adjusted in v7.

Kind regards,
Luca Boccassi
