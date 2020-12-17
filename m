Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1D52DD942
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 20:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgLQTUw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 14:20:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgLQTUw (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 14:20:52 -0500
Date:   Thu, 17 Dec 2020 11:20:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608232811;
        bh=vzc9sBUeZDxQNag2aFyA8oDuSeERydUnrxuA8Rh4aIo=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=GPTpcvITCqZAMVABpkenn6DHzJEsnP3O+P9QIEVE60gX8/+tCyTWkr5mj30N+fPrU
         6BOFRV8nUZeAHR5EzhYv/er/G49qMdlJ2LYh1sde++2f3lkhP2kbAsGjvEQA6czggk
         2efS9pFUsrgEDMJ7Ae48WWeu7aVIQeaqwqD/Cbg85xmRMsv2qxahcRyBxtHDaMwqza
         SHBxfVpCtoQsEXDZHuff9s7e8yQ9qcK5/LWn8r5zcDTAKzSvSZRZug1FjE5i5+nzHQ
         MPMume0pUii0l6617lj0fEbuJlKKOfnM9JFegAvuRphmQAtnS2r+9bJLm1aue7vCB9
         IHdQ1CbbbX3OA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <luca.boccassi@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH v2 2/2] Allow to build and run sign/digest
 on Windows
Message-ID: <X9uvac1VKpuvZ68B@sol.localdomain>
References: <20201217144749.647533-1-luca.boccassi@gmail.com>
 <20201217144749.647533-2-luca.boccassi@gmail.com>
 <X9ukTy5iKB4FfFqc@sol.localdomain>
 <695452fd56e71621a612dcdce8d203964bb64d0f.camel@gmail.com>
 <X9ur8imAGcnv7Xx6@sol.localdomain>
 <73c70f8bcb6632ab3e161d9b0263bc1563e96b34.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <73c70f8bcb6632ab3e161d9b0263bc1563e96b34.camel@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 17, 2020 at 07:12:06PM +0000, Luca Boccassi wrote:
> 
> I get the following warning with the mingw build now:
> 
> lib/utils.c: In function ‘xmalloc’:
> lib/utils.c:23:25: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 2 has type ‘size_t’ {aka ‘long long unsigned int’} [-Wformat=]
>    libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " bytes)",
>                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>            size);
>            ~~~~           
> In file included from lib/../common/win32_defs.h:24,
>                  from lib/../common/common_defs.h:18,
>                  from lib/lib_private.h:15,
>                  from lib/utils.c:12:
> /usr/share/mingw-w64/include/inttypes.h:94:20: note: format string is defined here
>  #define PRIu64 "I64u"
>   AR       libfsverity.a
>   CC       lib/sign_digest.shlib.o
>   CC       lib/compute_digest.shlib.o
>   CC       lib/hash_algs.shlib.o
>   CC       lib/utils.shlib.o
> lib/utils.c: In function ‘xmalloc’:
> lib/utils.c:23:25: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 2 has type ‘size_t’ {aka ‘long long unsigned int’} [-Wformat=]
>    libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " bytes)",
>                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>            size);
>            ~~~~           
> In file included from lib/../common/win32_defs.h:24,
>                  from lib/../common/common_defs.h:18,
>                  from lib/lib_private.h:15,
>                  from lib/utils.c:12:
> /usr/share/mingw-w64/include/inttypes.h:94:20: note: format string is defined here
>  #define PRIu64 "I64u"
> 
> 
> But, honestly, it seems harmless to me. If someone on Windows is trying
> to get a digest and don't have memory to do it, they'll have bigger
> problems to worry about than knowing how much it was requested. I'll
> send a v3 with your suggested changes. As far as I can read online,
> handling %zu in a cross compatible way is like the number one
> annoyance.
> 

It needs to compile without warnings, otherwise new warnings won't be noticed.

I think that if the MinGW printf is used (by defining _GNU_SOURCE), then %zu
would just work as-is.  That's what I do in another project.  Try:

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
index e13938a..3b0d908 100644
--- a/common/win32_defs.h
+++ b/common/win32_defs.h
@@ -23,12 +23,6 @@
 #include <stdint.h>
 #include <inttypes.h>
 
-#ifdef _WIN64
-#  define SIZET_PF PRIu64
-#else
-#  define SIZET_PF PRIu32
-#endif
-
 #ifndef ENOPKG
 #   define ENOPKG 65
 #endif
@@ -37,6 +31,11 @@
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
@@ -52,10 +51,6 @@ typedef __u32 __be32;
 typedef __u64 __le64;
 typedef __u64 __be64;
 
-#else
-
-#define SIZET_PF "zu"
-
 #endif /* _WIN32 */
 
 #endif /* COMMON_WIN32_DEFS_H */
diff --git a/lib/utils.c b/lib/utils.c
index 8bb4413..036dd60 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -9,8 +9,6 @@
  * https://opensource.org/licenses/MIT.
  */
 
-#define _GNU_SOURCE /* for asprintf() and strerror_r() */
-
 #include "lib_private.h"
 
 #include <stdio.h>
@@ -22,7 +20,7 @@ static void *xmalloc(size_t size)
 	void *p = malloc(size);
 
 	if (!p)
-		libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " bytes)",
+		libfsverity_error_msg("out of memory (tried to allocate %zu bytes)",
 				      size);
 	return p;
 }

- Eric
