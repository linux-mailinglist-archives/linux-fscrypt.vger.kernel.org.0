Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6502E031E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 00:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgLUX6g (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 18:58:36 -0500
Received: from mail-lf1-f53.google.com ([209.85.167.53]:45897 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUX6f (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 18:58:35 -0500
Received: by mail-lf1-f53.google.com with SMTP id x20so27737260lfe.12
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 15:58:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XQtTdpZ7jPhA4Ygu61wiXgHkI7j3/OTph6DGNgrxro8=;
        b=sup6UZMQCD5sgksGol5mC3IPlYCOpDJp49Z59/u9DKkpC7tdOUwWeJxVjVrL/ZxxJJ
         pyo65/R5MwkBPyKzi0P8MUjfKjJnwjpVF3PSlKl9rl9zIPcUrOqpEThWm+kGSXF5RV1N
         4sPQnSOIInmXgCU+aKUlk66OqYC0nEQFu7k600LOOBcJh7RzCtVXsHCeYPR3cFpANZDT
         dTqi+zbNFY+hLLyIXl2KKDeKwxmbynFvL7gcGF05uHd8F9HcdC17gvQM0nxJJRqkENiW
         Jn2vVTlAfZqtwdUD2K52rq4kOAAa3UmXctPOluxO85sAjHbpGE6uMC8cgNI3Q7Ck6lkE
         R0TQ==
X-Gm-Message-State: AOAM533ZdRDBwbMHSOb0Ol3nihePsJ0KkiBEVPoNh1JvRpajDChm9JjM
        aZx4mgWShJmRtEx9ifoxdfvkisoFqz4hKA==
X-Google-Smtp-Source: ABdhPJyjPrGTD61yaEo/KFvXHDtxTkpndLP+hJkJ5IGWXAGiEdD7BHCJ78IoX2baJGjp90pMl9K79A==
X-Received: by 2002:a2e:5047:: with SMTP id v7mr8216225ljd.242.1608595073328;
        Mon, 21 Dec 2020 15:57:53 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id 13sm2292749lfy.286.2020.12.21.15.57.53
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 15:57:53 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id m25so27736760lfc.11
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 15:57:53 -0800 (PST)
X-Received: by 2002:a05:6512:10d3:: with SMTP id k19mr8002367lfg.362.1608595073020;
 Mon, 21 Dec 2020 15:57:53 -0800 (PST)
MIME-Version: 1.0
References: <20201221221953.256059-1-bluca@debian.org> <20201221232428.298710-1-bluca@debian.org>
 <20201221232428.298710-3-bluca@debian.org> <X+E1a5jRbkZzS3j4@sol.localdomain>
In-Reply-To: <X+E1a5jRbkZzS3j4@sol.localdomain>
From:   Luca Boccassi <bluca@debian.org>
Date:   Mon, 21 Dec 2020 23:57:41 +0000
X-Gmail-Original-Message-ID: <CAMw=ZnTm7TOWg=yBeYr6tnpLux_pU7QXH3OtfPW3Rd1reuAtgA@mail.gmail.com>
Message-ID: <CAMw=ZnTm7TOWg=yBeYr6tnpLux_pU7QXH3OtfPW3Rd1reuAtgA@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] Allow to build and run sign/digest on Windows
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org,
        Luca Boccassi <luca.boccassi@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 21 Dec 2020 at 23:53, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Dec 21, 2020 at 11:24:28PM +0000, Luca Boccassi wrote:
> > +### Building on Windows
> > +
> > +There is minimal support for building Windows executables using MinGW.
> > +```bash
> > +    make CC=x86_64-w64-mingw32-gcc-win32
> > +```
> > +
> > +`fsverity.exe` will be built, and it supports the `digest` and `sign` commands.
> > +
> > +A Windows build of OpenSSL/libcrypto needs to be available.
>
> For me "CC=x86_64-w64-mingw32-gcc-win32" doesn't work; I need
> "x86_64-w64-mingw32-gcc" instead.  Is this difference intentional?
>
> - Eric

It's a distro setup difference I think, on Debian
x86_64-w64-mingw32-gcc is a symlink to x86_64-w64-mingw32-gcc-win32:

$ ls -l /usr/bin/x86_64-w64-mingw32-gcc-win32
-rwxr-xr-x 2 root root 1160320 Nov 27 05:57
/usr/bin/x86_64-w64-mingw32-gcc-win32
$ ls -l /usr/bin/x86_64-w64-mingw32-gcc
lrwxrwxrwx 1 root root 40 Sep 27 18:41 /usr/bin/x86_64-w64-mingw32-gcc
-> /etc/alternatives/x86_64-w64-mingw32-gcc
$ ls -l /etc/alternatives/x86_64-w64-mingw32-gcc
lrwxrwxrwx 1 root root 37 Sep 27 18:44
/etc/alternatives/x86_64-w64-mingw32-gcc ->
/usr/bin/x86_64-w64-mingw32-gcc-win32

Kind regards,
Luca Boccassi
