Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561232E02E8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 00:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgLUX1P (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 18:27:15 -0500
Received: from mail-lf1-f50.google.com ([209.85.167.50]:41907 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbgLUX1O (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 18:27:14 -0500
Received: by mail-lf1-f50.google.com with SMTP id s26so27633164lfc.8
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 15:26:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2QDcKBl2ucmjDqGTN+c4dAkEPMuE/+/MmHwiRWsKgt0=;
        b=Jg07Fvts36s1Wlw1MYNHwa0ClIZVnfpmjVn0/2SVjNxsfLJb5/QNw+XCwFZWt7PwhE
         MYtx4EpXPtJ+Mt1gEtpJeyAPcZx6LyqWInQfT4PWGbTwsGFaaBOVLstapsCDrMC/rYWx
         qT8+h9ddH73eeh7LutJOr+saT6osVUuu9vRCUraHC9K5T1CBDaNeNIOvfhr0jHyFc4FL
         EyU+YY5uHUPXMc26NezSt5bJd8pGdBi1OwBagLS8iMPa1LPwBN+F6ljuj6SriP0W2zig
         MLMvhgzc/GOst8FnyEkGKZd1P2VIJKAy4K4vmeAp9gohZqarpOFovnSOvUZH227nst+h
         ZkhQ==
X-Gm-Message-State: AOAM531l2pvsvOdBKeutLhJpa3fJ2e9PGA1Osy6waQZ7M3NzACvy7WKY
        8x54TgjLRYIsMyTqPjShTyzpaJbvtee7bA==
X-Google-Smtp-Source: ABdhPJxiZkF1EaxWASw7FwgZ48eUYoWiSnrQGNlop/zNBpD7c8FM96SNToSU3ZB/Su1rcCjOf1GlKg==
X-Received: by 2002:ac2:4d44:: with SMTP id 4mr7505908lfp.627.1608593192389;
        Mon, 21 Dec 2020 15:26:32 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id h23sm2473586ljh.115.2020.12.21.15.26.32
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 15:26:32 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id m12so27682795lfo.7
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 15:26:32 -0800 (PST)
X-Received: by 2002:a19:10:: with SMTP id 16mr7448015lfa.334.1608593192012;
 Mon, 21 Dec 2020 15:26:32 -0800 (PST)
MIME-Version: 1.0
References: <20201217192516.3683371-2-luca.boccassi@gmail.com>
 <20201221221953.256059-1-bluca@debian.org> <X+Epx7K/IIp08b7L@sol.localdomain>
In-Reply-To: <X+Epx7K/IIp08b7L@sol.localdomain>
From:   Luca Boccassi <bluca@debian.org>
Date:   Mon, 21 Dec 2020 23:26:20 +0000
X-Gmail-Original-Message-ID: <CAMw=ZnTUfHVxjdztnFrS5ZT4PxprwQzEP+3KdQAHDVOE-4A_CQ@mail.gmail.com>
Message-ID: <CAMw=ZnTUfHVxjdztnFrS5ZT4PxprwQzEP+3KdQAHDVOE-4A_CQ@mail.gmail.com>
Subject: Re: [PATCH v5] Allow to build and run sign/digest on Windows
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org,
        Luca Boccassi <luca.boccassi@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 21 Dec 2020 at 23:03, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Dec 21, 2020 at 10:19:53PM +0000, Luca Boccassi wrote:
> > From: Luca Boccassi <luca.boccassi@microsoft.com>
> >
> > stub out the enable/measure sources.
>
> That's not the case anymore, right?  Now those files are just omitted.

Clarified in v6

> > diff --git a/Makefile b/Makefile
> > index bfe83c4..d850ae3 100644
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
>
> It would be helpful if this comment mentioned that libfsverity isn't built as a
> proper Windows library.  At the moment it is not very clear.
>
> Also, a note in the README about the Windows support would be helpful.

Done both in v6

> > -override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
> > +override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE $(CPPFLAGS)
>
> The _GNU_SOURCE change should go in a separate patch.

Split out in v6

> >  # Rebuild if a user-specified setting that affects the build changed.
> >  .build-config: FORCE
> > @@ -87,9 +97,9 @@ CFLAGS          += $(shell "$(PKGCONF)" libcrypto --cflags 2>/dev/null || echo)
> >  # If we are dynamically linking, when running tests we need to override
> >  # LD_LIBRARY_PATH as no RPATH is set
> >  ifdef USE_SHARED_LIB
> > -RUN_FSVERITY    = LD_LIBRARY_PATH=./ ./fsverity
> > +RUN_FSVERITY    = LD_LIBRARY_PATH=./ $(TEST_WRAPPER_PROG) ./fsverity$(EXEEXT)
> >  else
> > -RUN_FSVERITY    = ./fsverity
> > +RUN_FSVERITY    = $(TEST_WRAPPER_PROG) ./fsverity$(EXEEXT)
> >  endif
>
> Adding $(TEST_WRAPPER_PROG) here should go in a separate patch too.  It also
> affects valgrind testing on Linux.

Split out in v6

> >  # Link the fsverity program
> >  ifdef USE_SHARED_LIB
> > -fsverity: $(FSVERITY_PROG_OBJ) libfsverity.so
> > +fsverity$(EXEEXT): $(FSVERITY_PROG_OBJ) libfsverity.so
>
> It would be easier to read if there was a variable $(FSVERITY) that had the
> value of fsverity$(EXEEXT).

Done in v6

> >  # Link the test programs
> >  $(TEST_PROGRAMS): %: programs/%.o $(PROG_COMMON_OBJ) libfsverity.a
> > @@ -184,25 +200,25 @@ test_programs:$(TEST_PROGRAMS)
>
> This still doesn't actually add the .exe extension to the test programs.
> Try 'make CC=x86_64-w64-mingw32-gcc help'; the targets to build the test
> programs don't have the .exe extension.

Yeah it didn't show in the target - although the binaries do have the
extension. Should be all fixed now in v6.

Kind regards,
Luca Boccassi
