Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EBC239DA0
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Aug 2020 05:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgHCDKJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-fscrypt@lfdr.de>); Sun, 2 Aug 2020 23:10:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45999 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgHCDKI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 2 Aug 2020 23:10:08 -0400
Received: from mail-lf1-f71.google.com ([209.85.167.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1k2QrW-00074P-AC
        for linux-fscrypt@vger.kernel.org; Mon, 03 Aug 2020 03:10:06 +0000
Received: by mail-lf1-f71.google.com with SMTP id q16so8503306lfm.2
        for <linux-fscrypt@vger.kernel.org>; Sun, 02 Aug 2020 20:10:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G5KTPSOnuprkIkEnRptcXiXviXnObXo/m58IMsPu9Jk=;
        b=fUNsIPX/fMUAbIVpDFs2hdyDTgbyLYCAfL6qokqJHswF19XPwh/l5YtXGbKhSJ/LJH
         h8Uy/MEXFllx+gFx3PbIU43Xvfck5Vwv3cvmJ047aSB2FjYLDEo6FBTWVR+VIKTfFXPm
         lYgZq48xaK6kly/sxwGFP8rLtJd5gybyQUSX7eRXXLoeWeMhNszwhgQ+Vgbniez8yMzb
         KF3wnGu2n3xTgCm6TUnLMiUxZVzyM7+w1nsdfgzUa4xAzetzA12QbrOkTiE35YEiY4F6
         gPi6Am7vJlXMPQu7/zx+x+prjHVMF9kwDugVIWoJO+jD0/PMRe0ELbV/tAIAY7H4oDE3
         sb1Q==
X-Gm-Message-State: AOAM5305iDO+gvSgXJe1Xjlt6sItHGPxhX7+wMMecuhiBSvoZSZD0p2u
        xc3BKEaUCgZOTIvsfVICDf2IIGqGkVilehZPn/WSoINeQEGMqt+bp5zcq+Q3qqAr5kjwHJMGX89
        SFq8FH2QqeIFrnwZqKq/hY8pxgt6qitD4WMwFi1+ykefBcTx8TIciLF6Miw==
X-Received: by 2002:ac2:4542:: with SMTP id j2mr7335525lfm.110.1596424205539;
        Sun, 02 Aug 2020 20:10:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4Q8orev+/bYIraZmSWDl/7CmZLydcWYsDjhlQbUWaNpCrPF5Xbw3gT7hlghkXutcjtSK46ZMxAl0Wv5NMzIE=
X-Received: by 2002:ac2:4542:: with SMTP id j2mr7335519lfm.110.1596424205305;
 Sun, 02 Aug 2020 20:10:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200730093520.26905-1-po-hsu.lin@canonical.com>
 <CAMy_GT-JNP0aTM3wC2mniMrREGkHGHuc2G=4Wmj99AFXULa6hQ@mail.gmail.com> <20200801181200.GB14666@sol.localdomain>
In-Reply-To: <20200801181200.GB14666@sol.localdomain>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Mon, 3 Aug 2020 11:09:54 +0800
Message-ID: <CAMy_GT-3j6S-DpOmbrckpE0dFi_Ja3Wz+kZFZLPdEfs_WRv__w@mail.gmail.com>
Subject: Re: [PATCH] Makefile: improve the cc-option compatibility
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

OK no problem,
I will send another one to add this subject format suggestion to the
Contributing section in README.md.

Thank you.
PHLin

On Sun, Aug 2, 2020 at 2:12 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jul 30, 2020 at 09:21:38PM +0800, Po-Hsu Lin wrote:
> > BTW this is for fsverity-utils.
> >
> > I should put a [fsverity-utils] in the title, sorry about this.
> > I can resubmit one if you need.
> >
> > Thank you
> > PHLin
> >
> > On Thu, Jul 30, 2020 at 5:35 PM Po-Hsu Lin <po-hsu.lin@canonical.com> wrote:
> > >
> > > The build on Ubuntu Xenial with GCC 5.4.0 will fail with:
> > >     cc: error: unrecognized command line option ‘-Wimplicit-fallthrough’
> > >
> > > This unsupported flag is not skipped as expected.
> > >
> > > It is because of the /bin/sh shell on Ubuntu, DASH, which does not
> > > support this &> redirection. Use 2>&1 to solve this problem.
> > >
> > > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> > > ---
> > >  Makefile | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/Makefile b/Makefile
> > > index 7d7247c..a4ce55a 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -27,7 +27,7 @@
> > >  #
> > >  ##############################################################################
> > >
> > > -cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
> > > +cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
> > >               then echo $(1); fi)
> > >
> > >  CFLAGS ?= -O2 -Wall -Wundef                                    \
> > > --
>
> Looks good, thanks!  I'll also want to add a test for building with dash to
> scripts/run-tests.sh, but I can do that.
>
> Note that we've just changed the license of fsverity-utils to the MIT license.
> Can you rebase onto the latest master branch (commit ab794fd56511) and resend to
> indicate that you agree?  And yes, I suggest "[fsverity-utils PATCH]", as this
> mailing list is mostly used for kernel patches.  Thanks!
>
> - Eric
