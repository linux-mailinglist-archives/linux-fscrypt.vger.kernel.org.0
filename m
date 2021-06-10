Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35423A2F44
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jun 2021 17:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhFJP3H (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Jun 2021 11:29:07 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:40707 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhFJP3E (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Jun 2021 11:29:04 -0400
Received: by mail-io1-f42.google.com with SMTP id l64so5804985ioa.7
        for <linux-fscrypt@vger.kernel.org>; Thu, 10 Jun 2021 08:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=11h+r3/bhQyBQndy6e+IuW8KIeHYr1zfr4i+ugm12/w=;
        b=QMWsFj2r2igFSAN+MxoigyCYwkddKq5lbErVy/n4gXafTb4UIuOFMkhWLlJPH3BRMy
         GYUXcKm2TY7iJb0x+tMkLruIE3Kane9kgKFnWf2TzMa5El8hckGVXeva/6WKpc6yAvNC
         ZI47cbC9qms9vz/Aeblcz1on9AP7bvzNkRRzvEInm0V9T06td6AGPP0QqrF/hJml9KKD
         nJmE2E9+YItx298qREotECyA9TNfcte5yWzPEI1GC94rUjwqWjn/xGMnKSMKwi9srOZc
         3qG5KZwNLdhBKk3573hEPNXk0IRlX3tfKsNRTKsGTsxVKllmDA8nV4qUwW6/XdGIsk14
         SkLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=11h+r3/bhQyBQndy6e+IuW8KIeHYr1zfr4i+ugm12/w=;
        b=Z376pl+roFkkoxYHUCp208RKHS906CgDu9NGz+QOrJIIaObr+dohE1XZ0WA/lVU3sh
         jC9vo3zW4iwHQgI3Vl3G2EsgLvf0wBxcpAEYF0zz97QsSCZbOQtQoNrxVT3THktzohDa
         Op6ntFRD09C/LtnTrDre4gmfUwe4O7pluMMbEANt65W9d/0jEOJBBnaCVgxydc1KhsEL
         gQ3cwHLA6qWl5DahqWeztn2leRbB0CI/tNfBUWcqorn+4buBaDl+oCZRhGOY0xdB83Fw
         CpixY9pDxmHTlQ9Je+hNgvS0zTyPplrlnIEJAeBrdrAzBLDWv33RrU8kmA7lUV5m0ajl
         Nh1g==
X-Gm-Message-State: AOAM5311XCJzTrLiuHKN81jWxxjbh7fsrQzHIn+FRDaUSrCzwl6CgaFo
        bJMlgHfwCW0meWrpVCWJqESytLl+fL06FQtYlQtgPQ==
X-Google-Smtp-Source: ABdhPJwvKMY4mo0ensmWZzz5Uw0l0l485cxU2Q6liYdIBrbcWFzj/i/37Uol9TSr358CmJ/fk/DR8iuBY+upMj7eK8E=
X-Received: by 2002:a05:6638:e81:: with SMTP id p1mr5273824jas.84.1623338750775;
 Thu, 10 Jun 2021 08:25:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210610072056.35190-1-ebiggers@kernel.org>
In-Reply-To: <20210610072056.35190-1-ebiggers@kernel.org>
From:   Victor Hsieh <victorhsieh@google.com>
Date:   Thu, 10 Jun 2021 08:25:38 -0700
Message-ID: <CAFCauYM-iH161rOKhjQNya5xPXtGWVic75O-QLraij_ttg8dCw@mail.gmail.com>
Subject: Re: [fsverity-utils PATCH] Add man page for fsverity
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, Luca Boccassi <bluca@debian.org>,
        Jes Sorensen <jes.sorensen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 10, 2021 at 12:22 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add a manual page for the fsverity utility, documenting all subcommands
> and options.
>
> The page is written in Markdown and is translated to groff using pandoc.
> It can be installed by 'make install-man'.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  .gitignore            |   1 +
>  Makefile              |  32 ++++++-
>  README.md             |  14 +++-
>  man/fsverity.1.md     | 191 ++++++++++++++++++++++++++++++++++++++++++
>  scripts/do-release.sh |   6 ++
>  scripts/run-tests.sh  |   2 +-
>  6 files changed, 239 insertions(+), 7 deletions(-)
>  create mode 100644 man/fsverity.1.md

Reviewed-by: Victor Hsieh <victorhsieh@google.com>
