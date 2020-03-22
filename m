Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A74318E679
	for <lists+linux-fscrypt@lfdr.de>; Sun, 22 Mar 2020 06:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgCVFXp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 22 Mar 2020 01:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgCVFXp (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 22 Mar 2020 01:23:45 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E52020714;
        Sun, 22 Mar 2020 05:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584854625;
        bh=iEMwYNz+7z/cHdoPLuHcC7CnkaI5kbkT/7trPqDKLAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T5vbzCso0XdvxmcWOd0HPz0FiPW8xzG280XuXOHX7vVfDGHw8KIxPeKB3gRNvpzZr
         60U3cbdnDEnIfcWwRkBkARB2LCNQeIqMA4FtP10gU5lj2dNruPTfLLdedw7TWwOMIW
         BIC/UfSxixhRON1FA8t2lNaE9WxzL3UZiw7m+6xE=
Date:   Sat, 21 Mar 2020 22:23:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH 1/9] Build basic shared library framework
Message-ID: <20200322052343.GE111151@sol.localdomain>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
 <20200312214758.343212-2-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312214758.343212-2-Jes.Sorensen@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 12, 2020 at 05:47:50PM -0400, Jes Sorensen wrote:
> From: Jes Sorensen <jsorensen@fb.com>
> 
> This introduces a dummy shared library to start moving things into.
> 
> Signed-off-by: Jes Sorensen <jsorensen@fb.com>
> ---
>  Makefile    | 18 +++++++++++++++---
>  libverity.c | 10 ++++++++++
>  2 files changed, 25 insertions(+), 3 deletions(-)
>  create mode 100644 libverity.c
> 
> diff --git a/Makefile b/Makefile
> index b9c09b9..bb85896 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,20 +1,32 @@
>  EXE := fsverity
> +LIB := libfsverity.so
>  CFLAGS := -O2 -Wall
>  CPPFLAGS := -D_FILE_OFFSET_BITS=64
>  LDLIBS := -lcrypto
>  DESTDIR := /usr/local
> +LIBDIR := /usr/lib64
>  SRC := $(wildcard *.c)
> -OBJ := $(SRC:.c=.o)
> +OBJ := fsverity.o hash_algs.o cmd_enable.o cmd_measure.o cmd_sign.o util.o
> +SSRC := libverity.c
> +SOBJ := libverity.so
>  HDRS := $(wildcard *.h)
>  
>  all:$(EXE)
>  
> -$(EXE):$(OBJ)
> +$(EXE):$(OBJ) $(LIB)
> +	$(CC) -o $@ $(OBJ) $(LDLIBS) -L . -l fsverity
>  
>  $(OBJ): %.o: %.c $(HDRS)
> +	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@
> +
> +$(SOBJ): %.so: %.c $(HDRS)
> +	$(CC) -c -fPIC $(CFLAGS) $(CPPFLAGS) $< -o $@
> +
> +libfsverity.so: $(SOBJ)
> +	$(CC) $(LDLIBS) -shared -o libfsverity.so $(SOBJ)
>  
>  clean:
> -	rm -f $(EXE) $(OBJ)
> +	rm -f $(EXE) $(OBJ) $(SOBJ) $(LIB)
>  
>  install:all
>  	install -Dm755 -t $(DESTDIR)/bin $(EXE)
> diff --git a/libverity.c b/libverity.c
> new file mode 100644
> index 0000000..6821aa2
> --- /dev/null
> +++ b/libverity.c
> @@ -0,0 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * The 'fsverity library'
> + *
> + * Copyright (C) 2018 Google LLC
> + * Copyright (C) 2020 Facebook
> + *
> + * Written by Eric Biggers and Jes Sorensen.
> + */
> +

Could you preserve the option to build the 'fsverity' program as a statically
linked binary?  Having to deal with installing libfsverity.so in some
environments can be annoying.

We maybe should use proper build system that would handle things like this --
though, for small projects like this it's nice to just have a simple Makefile.
What I've done in another project that uses just a Makefile is support building
both a static library a shared library, where the static library is created from
.o files and the shared library is built from .shlib.o files.  Then the binaries
can be linked to either one based on a 'make' variable.

- Eric
