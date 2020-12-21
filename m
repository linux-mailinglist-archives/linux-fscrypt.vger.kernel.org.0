Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538B22E02C8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 00:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgLUXER (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 18:04:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgLUXER (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 18:04:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2F90229CA;
        Mon, 21 Dec 2020 23:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608591816;
        bh=E2vKh/SOOLEB2fdOfcYVkhSitH8T67gNU1vvlycn2Qg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L7/F8MCqAolcxiQ8OPRNDt8EJVBPFzm90m6Wk2E28jW3k8vmoB20otorntb7Ch9PQ
         3JR/4VLT4Th+rS1578Hup0ksPXIhVCc0jCj6qYl+I3f1Sr9o5MSfN7A8rRYPSo5Njf
         lrzGdrjeda2oRdUybnYR2g0LNcFHJV2MJgdnScWQJt7mJCgQd4SLQDFOj8x+AxPNDb
         xkQxV7bhxlTWOgmTaiYxiVlYLKDIBApnYNmDkGYOWCs6I/cDs3jQKXMeIeDRUZ1DNN
         J5gcwoeaRKOHE0Rc5if3F32m8l0UZ4tgEn8WD4RZjJHoMlTJrPu21go5hd772p6t+x
         8sgh+s3ljBHIA==
Date:   Mon, 21 Dec 2020 15:03:35 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     linux-fscrypt@vger.kernel.org,
        Luca Boccassi <luca.boccassi@microsoft.com>
Subject: Re: [PATCH v5] Allow to build and run sign/digest on Windows
Message-ID: <X+Epx7K/IIp08b7L@sol.localdomain>
References: <20201217192516.3683371-2-luca.boccassi@gmail.com>
 <20201221221953.256059-1-bluca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221221953.256059-1-bluca@debian.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 21, 2020 at 10:19:53PM +0000, Luca Boccassi wrote:
> From: Luca Boccassi <luca.boccassi@microsoft.com>
> 
> stub out the enable/measure sources.

That's not the case anymore, right?  Now those files are just omitted.

> diff --git a/Makefile b/Makefile
> index bfe83c4..d850ae3 100644
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

It would be helpful if this comment mentioned that libfsverity isn't built as a
proper Windows library.  At the moment it is not very clear.

Also, a note in the README about the Windows support would be helpful.

> -override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
> +override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE $(CPPFLAGS)

The _GNU_SOURCE change should go in a separate patch.

>  # Rebuild if a user-specified setting that affects the build changed.
>  .build-config: FORCE
> @@ -87,9 +97,9 @@ CFLAGS          += $(shell "$(PKGCONF)" libcrypto --cflags 2>/dev/null || echo)
>  # If we are dynamically linking, when running tests we need to override
>  # LD_LIBRARY_PATH as no RPATH is set
>  ifdef USE_SHARED_LIB
> -RUN_FSVERITY    = LD_LIBRARY_PATH=./ ./fsverity
> +RUN_FSVERITY    = LD_LIBRARY_PATH=./ $(TEST_WRAPPER_PROG) ./fsverity$(EXEEXT)
>  else
> -RUN_FSVERITY    = ./fsverity
> +RUN_FSVERITY    = $(TEST_WRAPPER_PROG) ./fsverity$(EXEEXT)
>  endif

Adding $(TEST_WRAPPER_PROG) here should go in a separate patch too.  It also
affects valgrind testing on Linux.

>  # Link the fsverity program
>  ifdef USE_SHARED_LIB
> -fsverity: $(FSVERITY_PROG_OBJ) libfsverity.so
> +fsverity$(EXEEXT): $(FSVERITY_PROG_OBJ) libfsverity.so

It would be easier to read if there was a variable $(FSVERITY) that had the
value of fsverity$(EXEEXT).

>  # Link the test programs
>  $(TEST_PROGRAMS): %: programs/%.o $(PROG_COMMON_OBJ) libfsverity.a
> @@ -184,25 +200,25 @@ test_programs:$(TEST_PROGRAMS)

This still doesn't actually add the .exe extension to the test programs.
Try 'make CC=x86_64-w64-mingw32-gcc help'; the targets to build the test
programs don't have the .exe extension.

- Eric
