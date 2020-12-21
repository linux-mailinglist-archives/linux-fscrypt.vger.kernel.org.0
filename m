Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06AD2E0220
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Dec 2020 22:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgLUVl0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 16:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgLUVl0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 16:41:26 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26655224F9;
        Mon, 21 Dec 2020 21:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608586845;
        bh=6ZmC7xt2uNTShOl94ddvGbjORIahxkyzuU85UeMvOoM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F1hkRqWq8CCCFVswYeBsEuyISQNM7SLz8KylcQs3aWflyuBjd+j3oUHecW8rn2Vk5
         WxmyD6NPtsdXCbijC6P4S0qKTKbRojRbOmtrU89nYj/io7C0flMKGsidXOgdQEXc5n
         Yo24RtyW/47gf5XFYwhXihU/4AV76Wx8wdkMWxEzgfEzvQ5uDeoU2KWl/nISZRn7vL
         Dbi3/mHpjZ9PmiQMHNaaHr79nJ/kz/2X3V5kOeqMuRh+QopiAaPxYEgNyjnoaiAzfb
         bGayyIgxOxGRm4omR4Dr6PjZuW/e/Les99tfMzxI/60n1YNxsr2vJt+GC0XQJs59ex
         72Al3Qe9V3w7Q==
Date:   Mon, 21 Dec 2020 13:40:43 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH v4 2/2] Allow to build and run sign/digest
 on Windows
Message-ID: <X+EWW4QIOtXtJpEU@sol.localdomain>
References: <20201217144749.647533-1-luca.boccassi@gmail.com>
 <20201217192516.3683371-1-luca.boccassi@gmail.com>
 <20201217192516.3683371-2-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217192516.3683371-2-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 17, 2020 at 07:25:16PM +0000, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@microsoft.com>
> 
> Add some minimal compat type defs, and stub out the enable/measure
> sources. Also add a way to handle the fact that mingw adds a
> .exe extension automatically in the Makefile install rules, and
> that there is not pkg-config and the libcrypto linker flag is
> different.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>

This commit message is outdated; can you update it?

> diff --git a/Makefile b/Makefile
> index bfe83c4..a5aa900 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -35,6 +35,11 @@
>  cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
>  	      then echo $(1); fi)
>  
> +# Support building with MinGW for minimal Windows fsverity.exe
> +ifneq ($(findstring -mingw,$(shell $(CC) -dumpmachine 2>/dev/null)),)
> +MINGW = 1
> +endif
> +
>  CFLAGS ?= -O2
>  
>  override CFLAGS := -Wall -Wundef				\
> @@ -47,7 +52,7 @@ override CFLAGS := -Wall -Wundef				\
>  	$(call cc-option,-Wvla)					\
>  	$(CFLAGS)
>  
> -override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
> +override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE $(CPPFLAGS)
>  
>  ifneq ($(V),1)
>  QUIET_CC        = @echo '  CC      ' $@;
> @@ -62,7 +67,12 @@ BINDIR          ?= $(PREFIX)/bin
>  INCDIR          ?= $(PREFIX)/include
>  LIBDIR          ?= $(PREFIX)/lib
>  DESTDIR         ?=
> +ifneq ($(MINGW),1)
>  PKGCONF         ?= pkg-config
> +else
> +PKGCONF         := false
> +EXEEXT          := .exe
> +endif
>  
>  # Rebuild if a user-specified setting that affects the build changed.
>  .build-config: FORCE
> @@ -87,9 +97,9 @@ CFLAGS          += $(shell "$(PKGCONF)" libcrypto --cflags 2>/dev/null || echo)
>  # If we are dynamically linking, when running tests we need to override
>  # LD_LIBRARY_PATH as no RPATH is set
>  ifdef USE_SHARED_LIB
> -RUN_FSVERITY    = LD_LIBRARY_PATH=./ ./fsverity
> +RUN_FSVERITY    = LD_LIBRARY_PATH=./ ./fsverity$(EXEEXT)
>  else
> -RUN_FSVERITY    = ./fsverity
> +RUN_FSVERITY    = ./fsverity$(EXEEXT)
>  endif
>  
>  ##############################################################################
> @@ -99,6 +109,9 @@ endif
>  SOVERSION       := 0
>  LIB_CFLAGS      := $(CFLAGS) -fvisibility=hidden
>  LIB_SRC         := $(wildcard lib/*.c)
> +ifeq ($(MINGW),1)
> +LIB_SRC         := $(filter-out lib/enable.c,${LIB_SRC})
> +endif
>  LIB_HEADERS     := $(wildcard lib/*.h) $(COMMON_HEADERS)
>  STATIC_LIB_OBJ  := $(LIB_SRC:.c=.o)
>  SHARED_LIB_OBJ  := $(LIB_SRC:.c=.shlib.o)
> @@ -141,10 +154,13 @@ PROG_COMMON_SRC   := programs/utils.c
>  PROG_COMMON_OBJ   := $(PROG_COMMON_SRC:.c=.o)
>  FSVERITY_PROG_OBJ := $(PROG_COMMON_OBJ)		\
>  		     programs/cmd_digest.o	\
> -		     programs/cmd_enable.o	\
> -		     programs/cmd_measure.o	\
>  		     programs/cmd_sign.o	\
>  		     programs/fsverity.o
> +ifneq ($(MINGW),1)
> +FSVERITY_PROG_OBJ += \
> +		     programs/cmd_enable.o	\
> +		     programs/cmd_measure.o
> +endif
>  TEST_PROG_SRC     := $(wildcard programs/test_*.c)
>  TEST_PROGRAMS     := $(TEST_PROG_SRC:programs/%.c=%)
>  

The Makefile target to build the binary is still "fsverity", but for Windows it
actually builds "fsverity.exe".  I think that when the .exe extension is added,
the name of the Makefile target should change too.  Makefile targets should be
either a filename target *or* a special target, not conditionally either one.

> @@ -186,7 +202,7 @@ test_programs:$(TEST_PROGRAMS)
>  # want to run the full tests.
>  check:fsverity test_programs
>  	for prog in $(TEST_PROGRAMS); do \
> -		$(TEST_WRAPPER_PROG) ./$$prog || exit 1; \
> +		$(TEST_WRAPPER_PROG) ./$$prog$(EXEEXT) || exit 1; \
>  	done

The .exe extension isn't being added to the test programs when they are built.
Did you intend for building the test programs for Windows (and running them on
Windows) to be supported?

- Eric
