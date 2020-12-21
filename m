Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118A52E0277
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Dec 2020 23:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgLUWX7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 17:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgLUWX7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 17:23:59 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB194C0613D3
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 14:23:18 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id o13so27407434lfr.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 14:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SSU+YCmsGO3AgezGp5ufpgVhzvKi+Tm7KDTu6HYflf4=;
        b=FXsapjefxtFdSQyJ7vEWTecy3fgcajyiCdZaoQlEuTFbcoThK9ZuAKDS/eULfpeWsU
         Mt2rYF2lsAr4dfr6QbqLO8zb/OhVeqzQYUDRnujPSEs2VzUU5o3Wo8f6m+6BmKIVBxvz
         5IsG13wXeTYMOXGmD3Y+lVQtX8qoPPV3wLTa5LAh8lGs+SWNLFm5MsJAFyRbLM62qLBu
         ciI9u9yEPPHrjtqdSGlFoCPUPn0Ln9Ry5aMWK6CAvvQWzBWjdJ4OBWGz6jGeeb22Ecxr
         wZoNMbWPXpgCmFVBJxIjmAXpJx2rh4ynYV9GlNfpTD1exBJKYT7rbseHIkqbQJKSYRA2
         AVxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SSU+YCmsGO3AgezGp5ufpgVhzvKi+Tm7KDTu6HYflf4=;
        b=Tx3nEghkV6UcX7teEvAc3VDvRejyGf5AWqf/1pKNr8IvJkmwvubX+DEX6wfKwszkln
         qepnnY3GN80PUce6+deHGxQ7bfCU0O1wMBv5yv25zQCljhkXgTUrhel+G2qxE2dN16ad
         btxKws70FexKoGB5ZHvyrG2/6E3V512OyFR+f0QzIgGhlxvQ3rsDWtIk3G5BTnI//cCT
         rtwyd9UN/LLFLJC9mSWhWYMQdsOl1AMavVFdBgEwbUybkzNrxepN1/4b6PTFy626RnYO
         jDcD8S0RiPBH8axuzDjMUr97Z+s1AG1RxObT99ndCsKCCgof7TkpM0hr0uDvfS9x3HZa
         ruew==
X-Gm-Message-State: AOAM532GWRhm08gUvP4X8uslrZqRxai+4aCze4r2qN5ffv6ykuKleUGi
        H5T7pQjXDogrk82q8Z5oTd0kh/9dxOzkJM+KDHcQu7PPqrzZQA==
X-Google-Smtp-Source: ABdhPJwOkjMePJL90YywFOZwT89RsEKCtr7KFLUGBHU54nZxCM5L3NLj7wEfeAJ1U/If2Nl+VWYYdhPeK8orTvxAM14=
X-Received: by 2002:a2e:bc16:: with SMTP id b22mr8894680ljf.166.1608589397383;
 Mon, 21 Dec 2020 14:23:17 -0800 (PST)
MIME-Version: 1.0
References: <20201217144749.647533-1-luca.boccassi@gmail.com>
 <20201217192516.3683371-1-luca.boccassi@gmail.com> <20201217192516.3683371-2-luca.boccassi@gmail.com>
 <X+EWW4QIOtXtJpEU@sol.localdomain>
In-Reply-To: <X+EWW4QIOtXtJpEU@sol.localdomain>
From:   Luca Boccassi <luca.boccassi@gmail.com>
Date:   Mon, 21 Dec 2020 22:23:06 +0000
Message-ID: <CAMw=ZnQmyCbdwfROSmZB-hZjzz=n_rH-fvykyU0vnVp4CGA=mA@mail.gmail.com>
Subject: Re: [fsverity-utils PATCH v4 2/2] Allow to build and run sign/digest
 on Windows
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 21 Dec 2020 at 21:40, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Dec 17, 2020 at 07:25:16PM +0000, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <luca.boccassi@microsoft.com>
> >
> > Add some minimal compat type defs, and stub out the enable/measure
> > sources. Also add a way to handle the fact that mingw adds a
> > .exe extension automatically in the Makefile install rules, and
> > that there is not pkg-config and the libcrypto linker flag is
> > different.
> >
> > Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
>
> This commit message is outdated; can you update it?

Fixed in v5.

> > diff --git a/Makefile b/Makefile
> > index bfe83c4..a5aa900 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -35,6 +35,11 @@
> >  cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
> >             then echo $(1); fi)
> >
> > +# Support building with MinGW for minimal Windows fsverity.exe
> > +ifneq ($(findstring -mingw,$(shell $(CC) -dumpmachine 2>/dev/null)),)
> > +MINGW = 1
> > +endif
> > +
> >  CFLAGS ?= -O2
> >
> >  override CFLAGS := -Wall -Wundef                             \
> > @@ -47,7 +52,7 @@ override CFLAGS := -Wall -Wundef                            \
> >       $(call cc-option,-Wvla)                                 \
> >       $(CFLAGS)
> >
> > -override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
> > +override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE $(CPPFLAGS)
> >
> >  ifneq ($(V),1)
> >  QUIET_CC        = @echo '  CC      ' $@;
> > @@ -62,7 +67,12 @@ BINDIR          ?= $(PREFIX)/bin
> >  INCDIR          ?= $(PREFIX)/include
> >  LIBDIR          ?= $(PREFIX)/lib
> >  DESTDIR         ?=
> > +ifneq ($(MINGW),1)
> >  PKGCONF         ?= pkg-config
> > +else
> > +PKGCONF         := false
> > +EXEEXT          := .exe
> > +endif
> >
> >  # Rebuild if a user-specified setting that affects the build changed.
> >  .build-config: FORCE
> > @@ -87,9 +97,9 @@ CFLAGS          += $(shell "$(PKGCONF)" libcrypto --cflags 2>/dev/null || echo)
> >  # If we are dynamically linking, when running tests we need to override
> >  # LD_LIBRARY_PATH as no RPATH is set
> >  ifdef USE_SHARED_LIB
> > -RUN_FSVERITY    = LD_LIBRARY_PATH=./ ./fsverity
> > +RUN_FSVERITY    = LD_LIBRARY_PATH=./ ./fsverity$(EXEEXT)
> >  else
> > -RUN_FSVERITY    = ./fsverity
> > +RUN_FSVERITY    = ./fsverity$(EXEEXT)
> >  endif
> >
> >  ##############################################################################
> > @@ -99,6 +109,9 @@ endif
> >  SOVERSION       := 0
> >  LIB_CFLAGS      := $(CFLAGS) -fvisibility=hidden
> >  LIB_SRC         := $(wildcard lib/*.c)
> > +ifeq ($(MINGW),1)
> > +LIB_SRC         := $(filter-out lib/enable.c,${LIB_SRC})
> > +endif
> >  LIB_HEADERS     := $(wildcard lib/*.h) $(COMMON_HEADERS)
> >  STATIC_LIB_OBJ  := $(LIB_SRC:.c=.o)
> >  SHARED_LIB_OBJ  := $(LIB_SRC:.c=.shlib.o)
> > @@ -141,10 +154,13 @@ PROG_COMMON_SRC   := programs/utils.c
> >  PROG_COMMON_OBJ   := $(PROG_COMMON_SRC:.c=.o)
> >  FSVERITY_PROG_OBJ := $(PROG_COMMON_OBJ)              \
> >                    programs/cmd_digest.o      \
> > -                  programs/cmd_enable.o      \
> > -                  programs/cmd_measure.o     \
> >                    programs/cmd_sign.o        \
> >                    programs/fsverity.o
> > +ifneq ($(MINGW),1)
> > +FSVERITY_PROG_OBJ += \
> > +                  programs/cmd_enable.o      \
> > +                  programs/cmd_measure.o
> > +endif
> >  TEST_PROG_SRC     := $(wildcard programs/test_*.c)
> >  TEST_PROGRAMS     := $(TEST_PROG_SRC:programs/%.c=%)
> >
>
> The Makefile target to build the binary is still "fsverity", but for Windows it
> actually builds "fsverity.exe".  I think that when the .exe extension is added,
> the name of the Makefile target should change too.  Makefile targets should be
> either a filename target *or* a special target, not conditionally either one.

Ok, updated in v5.

> > @@ -186,7 +202,7 @@ test_programs:$(TEST_PROGRAMS)
> >  # want to run the full tests.
> >  check:fsverity test_programs
> >       for prog in $(TEST_PROGRAMS); do \
> > -             $(TEST_WRAPPER_PROG) ./$$prog || exit 1; \
> > +             $(TEST_WRAPPER_PROG) ./$$prog$(EXEEXT) || exit 1; \
> >       done
>
> The .exe extension isn't being added to the test programs when they are built.
> Did you intend for building the test programs for Windows (and running them on
> Windows) to be supported?

Yes it probably should. Made further updates, and at least with
mingw/wine make check works.

Kind regards,
Luca Boccassi
