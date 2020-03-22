Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B71318E6B4
	for <lists+linux-fscrypt@lfdr.de>; Sun, 22 Mar 2020 06:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgCVFdv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 22 Mar 2020 01:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgCVFdv (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 22 Mar 2020 01:33:51 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C31452072E;
        Sun, 22 Mar 2020 05:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584855230;
        bh=Qj6bJDXchTF6owc5IOT6307F+5XGQasi+1XSaY3OE00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yl0uyfOUsvIj+HzR3TiGllETcVpLBjSQBB0S8RZYLWxTA7rgJnNPIoOgnW9/MFIHp
         I2uDS6fYegdhDcfTErUr1PDxdQNAx4Zzutvs3BAMZSuMuemRNHaLF9JEZVsiEzKHx6
         xV3/JStUtkHEWo1wxZSZYbN6/Ki1MM4x7uCv1M1k=
Date:   Sat, 21 Mar 2020 22:33:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH 1/9] Build basic shared library framework
Message-ID: <20200322053349.GG111151@sol.localdomain>
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

LIBDIR isn't used at all.  I assume you meant for it to be location where the
library gets installed?  The proper way to handle installation locations
(assuming we stay with a plain Makefile and not move to another build system)
would be:

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
INCDIR ?= $(PREFIX)/include
LIBDIR ?= $(PREFIX)/lib

then install binaries into $(DESTDIR)$(BINDIR), headers into
$(DESTDIR)$(INCDIR), and libraries into $(DESTDIR)$(LIBDIR).
This matches the conventions for autoconf.

- Eric
