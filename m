Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE07B39BBC4
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Jun 2021 17:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhFDP0t (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Jun 2021 11:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhFDP0t (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Jun 2021 11:26:49 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F71C061767
        for <linux-fscrypt@vger.kernel.org>; Fri,  4 Jun 2021 08:25:03 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id i17so9170741ilj.11
        for <linux-fscrypt@vger.kernel.org>; Fri, 04 Jun 2021 08:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OfpAC9VzJiunNS6rytVw6+uXCS75zqkMqLsNMK5XtGo=;
        b=gG4HPO5SGx6S5ClGlqpWTL4aU2L5AYT76rP6n8sPKLnLBODcURNjbEWes8hVPzC9Tm
         /cCN66iU1Tr7I0EmQ28o2KTmlexNHuY56rVr9Nvjhlk8+kg+8FYUxKmIWdIbmFvWp+rD
         QqWN+yjW7VTCplOnwennE/LDli3zwWRAe05za/zPIKuWxQbONDqGO8E+qNfX4psqzVoF
         kCWvKeq6swG28Dv1mq1rRgEibC3JAfnEaOqMJX1/WCRIl2RxNoTYVgIeJDV5bNe5UrV1
         pC8V92HvR5DgnjfpeU+3ZmK8V0jbWp6+tGGQYLknJvNfACxOHL9twdK+G2oRQkkQ6/+h
         iFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OfpAC9VzJiunNS6rytVw6+uXCS75zqkMqLsNMK5XtGo=;
        b=mo7jCmu7hiMF06CX/iinQlWihixHdku3fnwvZl4PvjI5x0Sgwpfxtw4qWOsxwEEYHZ
         uylV4pVLyOatfJS1QBEw5Ju45VQRrR3xEeb/uZbaKWJ0EzEIOS8obL321RZNYmT4Fg9K
         WT7UXEyprhjymBvrGEBO0hSQxBbFtCdpSviiVabLVa+Zl885TiFVYopVjL2KMZX2nODW
         HQRVhD4zG1pTsyKrxbBObk2+8o5bEgWAGX0WTxJIid9d52v/qfypn/FT5yjxJZPEamXA
         ndRqPdU4tAgUWYra0mWuID69AhFaOilLCXrB5u4wWxlE7s6R2jAk7mongKnmzK6/z+Ab
         8Jpw==
X-Gm-Message-State: AOAM533JwFohjdu1+4ywPR/a1UqCOSuq18eJ6XvcNrQsEaGUP7gqU+lg
        P4Gh3DEacvIQ+YAqNgmmYRVbUSvttWfMwuecDTGy32iEcDhHhQ==
X-Google-Smtp-Source: ABdhPJxNqBKNPKSktYyIzatdEPYTu5Fl1+mOgxpaqrZegwhHqjlciZg845XKTXn44tNU8Ee5Nw50vlcS3HjvJxpU5bw=
X-Received: by 2002:a92:cbcc:: with SMTP id s12mr4409028ilq.229.1622820302093;
 Fri, 04 Jun 2021 08:25:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210603195812.50838-1-ebiggers@kernel.org> <20210603195812.50838-4-ebiggers@kernel.org>
 <CAFCauYO9Hrg-jjNzfMwruU4BQTOD5dFbPnASJXPRKdCQH5tETw@mail.gmail.com> <YLl6l0MKaWGR08Tv@sol.localdomain>
In-Reply-To: <YLl6l0MKaWGR08Tv@sol.localdomain>
From:   Victor Hsieh <victorhsieh@google.com>
Date:   Fri, 4 Jun 2021 08:24:50 -0700
Message-ID: <CAFCauYNPvC=otUWXD5ytqM5rvoaMBLXXfdGHTUcCvWwFG4PEmw@mail.gmail.com>
Subject: Re: [fsverity-utils PATCH 3/4] programs/utils: add full_pwrite() and preallocate_file()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 3, 2021 at 5:58 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jun 03, 2021 at 05:33:18PM -0700, Victor Hsieh wrote:
> > > +
> > > +bool full_pwrite(struct filedes *file, const void *buf, size_t count,
> > > +                u64 offset)
> > > +{
> > > +       while (count) {
> > > +               int n = raw_pwrite(file->fd, buf, min(count, INT_MAX), offset);
> > > +
> > > +               if (n < 0) {
> > > +                       error_msg_errno("writing to '%s'", file->name);
> > > +                       return false;
> > > +               }
> > > +               buf += n;
> > I think this pointer arithmetic is not portable?  Consider changing
> > the type of buf to "const char*".
> >
>
> fsverity-utils is already using void pointer arithmetic elsewhere, for example
> in full_read() and full_write().
>
> I am allowing the use of some gcc/clang extensions which are widely used,
> including in the Linux kernel (which fsverity-utils is generally trying to
> follow the coding style of), and are annoying to do without.  Void pointer
> arithmetic is one of these.
>
> If we really needed to support someone compiling fsverity-utils with e.g.
> Visual Studio, we could add -Wpedantic to the compiler flags and get rid of all
> the gcc/clang extensions.  But I don't see a reason to do that now.

Yeah, that's what I was thinking since the code has #ifdef _WIN32.
I'd think the
"host" side program should be more portable than the kernel itself.
But if this is
already used elsewhere, no objection to keeping assuming so.

Reviewed-by: Victor Hsieh <victorhsieh@google.com>

>
> - Eric
