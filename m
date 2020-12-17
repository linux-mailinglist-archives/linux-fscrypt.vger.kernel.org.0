Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FFB2DD910
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 20:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgLQTGF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 14:06:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729839AbgLQTGF (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 14:06:05 -0500
Date:   Thu, 17 Dec 2020 11:05:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608231924;
        bh=pGVygK88iFWoQaA8ME4XG/MrBgO5ldQ2hIxf2ps2lNo=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=FlUG55bCbGZW9llo2BQHnL9nSKL+s7CqUapkX7u86kXITYBZnopQipYwWa17ovxMM
         UyBEyHMyMOa9bjkR2HtI4nweV6gIvh6lcjJPGoI3R3uqmcNFwhWyrpr3FagDHpAnKj
         79mGfYEc0k4tBtBJROy9+q3VRqEJJDIwInZtLNg4bOOClwdtossTDOfNMJ422tr8u5
         5HrRjIMJ2RDsBNaqyVRgI6m42lRikdVceM1Vskg8J5Ps2JVIW49PWe0PqcPRhmFgoW
         Lg7FxJpTCKyGIuj+0FcbXLFKUAzMuke+rwLTP4sjgv5sw1zDcRarsQBi1hIprjOpcE
         L0d9UCPPigp+w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <luca.boccassi@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH v2 2/2] Allow to build and run sign/digest
 on Windows
Message-ID: <X9ur8imAGcnv7Xx6@sol.localdomain>
References: <20201217144749.647533-1-luca.boccassi@gmail.com>
 <20201217144749.647533-2-luca.boccassi@gmail.com>
 <X9ukTy5iKB4FfFqc@sol.localdomain>
 <695452fd56e71621a612dcdce8d203964bb64d0f.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <695452fd56e71621a612dcdce8d203964bb64d0f.camel@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 17, 2020 at 06:44:38PM +0000, Luca Boccassi wrote:
> On Thu, 2020-12-17 at 10:32 -0800, Eric Biggers wrote:
> > On Thu, Dec 17, 2020 at 02:47:49PM +0000, luca.boccassi@gmail.com wrote:
> > > From: Luca Boccassi <luca.boccassi@microsoft.com>
> > > 
> > > Add some minimal compat type defs, and stub out the enable/measure
> > > sources. Also add a way to handle the fact that mingw adds a
> > > .exe extension automatically in the Makefile install rules, and
> > > that there is not pkg-config and the libcrypto linker flag is
> > > different.
> > > 
> > > Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> > > ---
> > > v2: rework the stubbing out to detect mingw in the Makefile and remove
> > >     sources from compilation, instead of ifdefs.
> > >     add a new common/win32_defs.h for the compat definitions.
> > >     define strerror_r using strerror_s.
> > > 
> > >     To compile with mingw:
> > >       make CC=x86_64-w64-mingw32-gcc-8.3-win32
> > >     note that the openssl headers and a win32 libcrypto.dll need
> > >     to be available in the default search paths, and otherwise have
> > >     to be specified as expected via CPPFLAGS/LDFLAGS
> > > 
> > 
> > I got some warnings and an error when compiling:
> > 
> > $ make CC=x86_64-w64-mingw32-gcc
> >   CC       lib/compute_digest.o
> >   CC       lib/hash_algs.o
> >   CC       lib/sign_digest.o
> >   CC       lib/utils.o
> > lib/utils.c: In function ‘xmalloc’:
> > lib/utils.c:25:25: warning: unknown conversion type character ‘l’ in format [-Wformat=]
> >    25 |   libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " bytes)",
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > In file included from lib/../common/win32_defs.h:24,
> >                  from lib/../common/common_defs.h:18,
> >                  from lib/lib_private.h:15,
> >                  from lib/utils.c:14:
> > /usr/x86_64-w64-mingw32/include/inttypes.h:36:18: note: format string is defined here
> >    36 | #define PRIu64 "llu"
> >       |                  ^
> > lib/utils.c:25:25: warning: too many arguments for format [-Wformat-extra-args]
> >    25 |   libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " bytes)",
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   AR       libfsverity.a
> >   CC       lib/compute_digest.shlib.o
> >   CC       lib/hash_algs.shlib.o
> >   CC       lib/sign_digest.shlib.o
> >   CC       lib/utils.shlib.o
> > lib/utils.c: In function ‘xmalloc’:
> > lib/utils.c:25:25: warning: unknown conversion type character ‘l’ in format [-Wformat=]
> >    25 |   libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " bytes)",
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > In file included from lib/../common/win32_defs.h:24,
> >                  from lib/../common/common_defs.h:18,
> >                  from lib/lib_private.h:15,
> >                  from lib/utils.c:14:
> > /usr/x86_64-w64-mingw32/include/inttypes.h:36:18: note: format string is defined here
> >    36 | #define PRIu64 "llu"
> >       |                  ^
> > lib/utils.c:25:25: warning: too many arguments for format [-Wformat-extra-args]
> >    25 |   libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " bytes)",
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   CCLD     libfsverity.so.0
> > /usr/lib/gcc/x86_64-w64-mingw32/10.2.0/../../../../x86_64-w64-mingw32/bin/ld: cannot find -l:libcrypto.dll
> > collect2: error: ld returned 1 exit status
> > make: *** [Makefile:137: libfsverity.so.0] Error 1
> > 
> > 
> > 
> > This is on Arch Linux with mingw-w64-gcc and mingw-w64-openssl installed.
> > 
> > So there's something wrong with the SIZET_PF format string, and also
> > -l:libcrypto.dll isn't correct; it should be just -lcrypto like it is on Linux.
> > (MinGW knows to look for a .dll file.)
> > 
> > - Eric
> 
> Mmh I don't get any warnings on Debian - gcc-mingw-w64-x86-64 8.3.0-
> 6+21.3~deb10u1 - any idea how to fix it?
> 
> And on -lcrypto, it didn't use to work before the refactor - but now it
> does. I have no clue what was happening. Will change it back in v3.
> 

Apparently the definition of _GNU_SOURCE in lib/utils.c changes the printf
implementation that is used from Microsoft's to MinGW's, but the use of
__attribute__((format(printf))) is generating warnings assuming that Microsoft's
printf implementation is used.  Always defining _GNU_SOURCE and then using
__attribute__((format(gnu_printf))) might be the way to go:

diff --git a/Makefile b/Makefile
index cc62818..44aee92 100644
--- a/Makefile
+++ b/Makefile
@@ -52,7 +52,7 @@ override CFLAGS := -Wall -Wundef				\
 	$(call cc-option,-Wvla)					\
 	$(CFLAGS)
 
-override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
+override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE $(CPPFLAGS)
 
 ifneq ($(V),1)
 QUIET_CC        = @echo '  CC      ' $@;
diff --git a/common/win32_defs.h b/common/win32_defs.h
index e13938a..4edb17f 100644
--- a/common/win32_defs.h
+++ b/common/win32_defs.h
@@ -37,6 +37,11 @@
 #  define __cold
 #endif
 
+#ifndef __printf
+#  define __printf(fmt_idx, vargs_idx) \
+	__attribute__((format(gnu_printf, fmt_idx, vargs_idx)))
+#endif
+
 typedef __signed__ char __s8;
 typedef unsigned char __u8;
 typedef __signed__ short __s16;
diff --git a/lib/utils.c b/lib/utils.c
index 8bb4413..55a4045 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -9,8 +9,6 @@
  * https://opensource.org/licenses/MIT.
  */
 
-#define _GNU_SOURCE /* for asprintf() and strerror_r() */
-
 #include "lib_private.h"
 
 #include <stdio.h>
