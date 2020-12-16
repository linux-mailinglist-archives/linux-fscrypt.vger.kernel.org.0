Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2BB2DC72E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Dec 2020 20:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388787AbgLPTdI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Dec 2020 14:33:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388761AbgLPTdI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Dec 2020 14:33:08 -0500
Date:   Wed, 16 Dec 2020 11:08:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608145731;
        bh=kQeDoyRRVKpBiuCPMgG8qIeeuMzg98u/RM2TwCjjwXk=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=bdVSOoOJ72VY6iORIvcdhM2rwPikHnW1LSIhPYLjJG5Ji0rhH5qs5PHhrXVhqiGyV
         PWAnyNnwOrzgYoa44sdkGuE17mVacZnegamgQenBEFj4SdSuI585c6Z79KjDL0OYaq
         4k3HvJD77uyYgwfV+u0BXqFH/l7EFLVrjEp2PxFSHn6QyLMASm92dXWpMDCYESs8FR
         O3LUITubyjiUVkLMSA1qZI4u/rz/BC/6WdHRt2VgcYGHtdaAqSBwXKZyj/DbOn0IhJ
         E38xwqsAJjNbGzAqi+Z3sJbzmrV1jZFgKHwZOCP31Yu1Wvw8wTv9rBCF0BB/l2Cwzp
         CUe3rOGm6LlDA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH 2/2] Allow to build and run sign/digest on
 Windows
Message-ID: <X9pbQjFDwr/Vd0/O@sol.localdomain>
References: <20201216172719.540610-1-luca.boccassi@gmail.com>
 <20201216172719.540610-2-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216172719.540610-2-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Dec 16, 2020 at 05:27:19PM +0000, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@microsoft.com>
> 
> Add some minimal compat type defs, and stub out the enable/measure
> functions. Also add a way to handle the fact that mingw adds a
> .exe extension automatically in the Makefile install rules.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> ---
> So this is proably going to look strange, and believe me the feeling is shared.
> It's actually the first time _ever_ I had to compile and run something on
> Windows, which is ironic in itself - the O_BINARY stuff is probably WIN32-101 and
> it took me an hour to find out.
> Anyway, I've got some groups building their payloads on Windows, so we need to
> provide native tooling. Among these are fsverity tools to get the digest and
> sign files.
> This patch stubs out and returns EOPNOTSUPP from the measure/enable functions,
> since they are linux-host only, and adds some (hopefully) minimal and unintrusive
> compat ifdefs for the rest. There's also a change in the makefile, since the
> build toolchain (yocto + mingw) for some reason automatically names executables
> as .exe. Biggest chunk is the types definitions I guess. The ugliest is the
> print stuff.
> 
> Note that with this I do not ask you in any way, shape or form to be responsible
> for the correct functioning or even compiling on WIN32 of these utilities - if
> anything ever breaks, we'll find out and take care of it. I could keep all of this
> out of tree, but I figured I'd try to see if you are amenable to merge at least
> some part of it.
> 
> I've tested that both Linux and WIN32 builds of digest and sign commands return
> the exact same output for the same input.

On Linux, can you make it easily cross-compile for Windows using
'make CC=x86_64-w64-mingw32-gcc'?  That would be ideal, so that that command can
be added to scripts/run-tests.sh, so that I can make sure it stays building.

I probably won't actually test *running* it on Windows, as that would be more
work.  But building should be easy.

> diff --git a/Makefile b/Makefile
> index bfe83c4..fe89e18 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -63,6 +63,7 @@ INCDIR          ?= $(PREFIX)/include
>  LIBDIR          ?= $(PREFIX)/lib
>  DESTDIR         ?=
>  PKGCONF         ?= pkg-config
> +EXEEXT          ?=

It looks like you're requiring the caller to manually specify EXEEXT.  You could
use something like the following to automatically detect when CC is MinGW and
set EXEEXT and AR appropriately:

# Compiling for Windows with MinGW?
ifneq ($(findstring -mingw,$(shell $(CC) -dumpmachine 2>/dev/null)),)
	EXEEXT := .exe
	# Derive $(AR) from $(CC).
	AR := $(shell echo $(CC) | \
                sed -E 's/g?cc(-?[0-9]+(\.[0-9]+)*)?(\.exe)?$$/ar\3/')
endif

>  # Rebuild if a user-specified setting that affects the build changed.
>  .build-config: FORCE
> @@ -87,9 +88,9 @@ CFLAGS          += $(shell "$(PKGCONF)" libcrypto --cflags 2>/dev/null || echo)
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
> @@ -186,7 +187,7 @@ test_programs:$(TEST_PROGRAMS)
>  # want to run the full tests.
>  check:fsverity test_programs
>  	for prog in $(TEST_PROGRAMS); do \
> -		$(TEST_WRAPPER_PROG) ./$$prog || exit 1; \
> +		$(TEST_WRAPPER_PROG) ./$$prog$(EXEEXT) || exit 1; \
>  	done
>  	$(RUN_FSVERITY) --help > /dev/null
>  	$(RUN_FSVERITY) --version > /dev/null
> @@ -202,7 +203,7 @@ check:fsverity test_programs
>  
>  install:all
>  	install -d $(DESTDIR)$(LIBDIR)/pkgconfig $(DESTDIR)$(INCDIR) $(DESTDIR)$(BINDIR)
> -	install -m755 fsverity $(DESTDIR)$(BINDIR)
> +	install -m755 fsverity$(EXEEXT) $(DESTDIR)$(BINDIR)
>  	install -m644 libfsverity.a $(DESTDIR)$(LIBDIR)
>  	install -m755 libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)
>  	ln -sf libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)/libfsverity.so
> @@ -215,7 +216,7 @@ install:all
>  	chmod 644 $(DESTDIR)$(LIBDIR)/pkgconfig/libfsverity.pc
>  
>  uninstall:
> -	rm -f $(DESTDIR)$(BINDIR)/fsverity
> +	rm -f $(DESTDIR)$(BINDIR)/fsverity$(EXEEXT)
>  	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.a
>  	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so.$(SOVERSION)
>  	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so
> @@ -232,4 +233,4 @@ help:
>  
>  clean:
>  	rm -f $(DEFAULT_TARGETS) $(TEST_PROGRAMS) \
> -		lib/*.o programs/*.o .build-config fsverity.sig
> +		fsverity$(EXEEXT) lib/*.o programs/*.o .build-config fsverity.sig

Do you need libfsverity to be built properly for Windows (producing .dll, .lib,
and .def files), or are you just looking to build the fsverity binary?  At the
moment you're just doing the latter.  There are a bunch of differences between
libraries on Windows and Linux, so hopefully you don't need the library built
properly for Windows, but it would be possible.

> diff --git a/common/common_defs.h b/common/common_defs.h
> index 279385a..a869532 100644
> --- a/common/common_defs.h
> +++ b/common/common_defs.h
> @@ -15,6 +15,30 @@
>  #include <stddef.h>
>  #include <stdint.h>
>  
> +#ifdef _WIN32
> +/* Some minimal definitions to allow the digest/sign commands to run under Windows */
> +#  ifndef ENOPKG
> +#    define ENOPKG 65
> +#  endif
> +#  ifndef __cold
> +#    define __cold
> +#  endif
> +typedef __signed__ char __s8;
> +typedef unsigned char __u8;
> +typedef __signed__ short __s16;
> +typedef unsigned short __u16;
> +typedef __signed__ int __s32;
> +typedef unsigned int __u32;
> +typedef __signed__ long long  __s64;
> +typedef unsigned long long  __u64;
> +typedef __u16 __le16;
> +typedef __u16 __be16;
> +typedef __u32 __le32;
> +typedef __u32 __be32;
> +typedef __u64 __le64;
> +typedef __u64 __be64;
> +#endif /* _WIN32 */
> +
>  typedef uint8_t u8;
>  typedef uint16_t u16;
>  typedef uint32_t u32;

Could you put most of the Windows compatibility definitions in a single new
header so that they don't clutter things up too much?

Including for things you put in other places, like O_BINARY.

> diff --git a/lib/enable.c b/lib/enable.c
> index 2478077..b49ba26 100644
> --- a/lib/enable.c
> +++ b/lib/enable.c
> @@ -11,14 +11,10 @@
>  
>  #include "lib_private.h"
>  
> +#ifndef _WIN32
> +

Could you just have the Makefile exclude files from the build instead?

	lib/enable.c
	programs/cmd_measure.c
	programs/cmd_enable.c

Then in programs/fsverity.c, ifdef out the 'measure' and 'enable' commands in
fsverity_commands[].

I think that would be easier.  Plus users won't get weird errors if they try to
use unsupported commands on Windows; the commands just won't be available.

> +#ifndef _WIN32
>  		if (asprintf(&msg2, "%s: %s", msg,
>  			     strerror_r(err, errbuf, sizeof(errbuf))) < 0)
> +#else
> +		strerror_s(errbuf, sizeof(errbuf), err);
> +		if (asprintf(&msg2, "%s: %s", msg, errbuf) < 0)
> +#endif
>  			goto out2;

Instead of doing this, could you provide a strerror_r() implementation in
programs/utils.c for _WIN32?

- Eric
