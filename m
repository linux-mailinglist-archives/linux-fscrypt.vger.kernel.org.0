Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3B42DD86F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 19:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgLQSd3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 13:33:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgLQSd3 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 13:33:29 -0500
Date:   Thu, 17 Dec 2020 10:32:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608229968;
        bh=9txPX8aooGF6zUzLtkG4bkBVIdi12IrnczwggD1oF90=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=bYzOF9Nf6Efls+ubttkfuMCo6q3KP1s7zlW1+qocOfFcNbPYAjoMmyPOssC9N2npE
         oSN2ocef9SQibUBoeaaPQzWAW3twDSr2ylJQ35Qnuk2NrDFgsxTgeGzD3z/QNJcDJI
         DVyNh7S+t0vtffjspfjabqg7gXrh4pZ8DNJRBGBYy6z6khlp5pmA2tgJrkir0O/5wj
         NkWATkMUTWIrzqh4LqQSnwVQHCRPZ6+D2Zky2jBvWbOm0B8lJNGdft1BYaQIJ26iLP
         nshmwM52AhOIe8MwSlRekrmAbzdhTLAhDLnTykcb6kQnVKUtg0Qa0pY+j+idV6Z/A2
         66i0k8qYiiuIw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH v2 2/2] Allow to build and run sign/digest
 on Windows
Message-ID: <X9ukTy5iKB4FfFqc@sol.localdomain>
References: <20201217144749.647533-1-luca.boccassi@gmail.com>
 <20201217144749.647533-2-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201217144749.647533-2-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 17, 2020 at 02:47:49PM +0000, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@microsoft.com>
> 
> Add some minimal compat type defs, and stub out the enable/measure
> sources. Also add a way to handle the fact that mingw adds a
> .exe extension automatically in the Makefile install rules, and
> that there is not pkg-config and the libcrypto linker flag is
> different.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> ---
> v2: rework the stubbing out to detect mingw in the Makefile and remove
>     sources from compilation, instead of ifdefs.
>     add a new common/win32_defs.h for the compat definitions.
>     define strerror_r using strerror_s.
> 
>     To compile with mingw:
>       make CC=x86_64-w64-mingw32-gcc-8.3-win32
>     note that the openssl headers and a win32 libcrypto.dll need
>     to be available in the default search paths, and otherwise have
>     to be specified as expected via CPPFLAGS/LDFLAGS
> 

I got some warnings and an error when compiling:

$ make CC=x86_64-w64-mingw32-gcc
  CC       lib/compute_digest.o
  CC       lib/hash_algs.o
  CC       lib/sign_digest.o
  CC       lib/utils.o
lib/utils.c: In function ‘xmalloc’:
lib/utils.c:25:25: warning: unknown conversion type character ‘l’ in format [-Wformat=]
   25 |   libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " bytes)",
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from lib/../common/win32_defs.h:24,
                 from lib/../common/common_defs.h:18,
                 from lib/lib_private.h:15,
                 from lib/utils.c:14:
/usr/x86_64-w64-mingw32/include/inttypes.h:36:18: note: format string is defined here
   36 | #define PRIu64 "llu"
      |                  ^
lib/utils.c:25:25: warning: too many arguments for format [-Wformat-extra-args]
   25 |   libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " bytes)",
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  AR       libfsverity.a
  CC       lib/compute_digest.shlib.o
  CC       lib/hash_algs.shlib.o
  CC       lib/sign_digest.shlib.o
  CC       lib/utils.shlib.o
lib/utils.c: In function ‘xmalloc’:
lib/utils.c:25:25: warning: unknown conversion type character ‘l’ in format [-Wformat=]
   25 |   libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " bytes)",
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from lib/../common/win32_defs.h:24,
                 from lib/../common/common_defs.h:18,
                 from lib/lib_private.h:15,
                 from lib/utils.c:14:
/usr/x86_64-w64-mingw32/include/inttypes.h:36:18: note: format string is defined here
   36 | #define PRIu64 "llu"
      |                  ^
lib/utils.c:25:25: warning: too many arguments for format [-Wformat-extra-args]
   25 |   libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " bytes)",
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  CCLD     libfsverity.so.0
/usr/lib/gcc/x86_64-w64-mingw32/10.2.0/../../../../x86_64-w64-mingw32/bin/ld: cannot find -l:libcrypto.dll
collect2: error: ld returned 1 exit status
make: *** [Makefile:137: libfsverity.so.0] Error 1



This is on Arch Linux with mingw-w64-gcc and mingw-w64-openssl installed.

So there's something wrong with the SIZET_PF format string, and also
-l:libcrypto.dll isn't correct; it should be just -lcrypto like it is on Linux.
(MinGW knows to look for a .dll file.)

- Eric
