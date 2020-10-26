Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C09299959
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 23:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392170AbgJZWKW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 18:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392164AbgJZWKV (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 18:10:21 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22A3120874;
        Mon, 26 Oct 2020 22:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603750221;
        bh=EgPR4f+YZyPy4qomT0xc/lVRvlXSVCXMUECCxzGQ1JE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WMiaKIqdST3DhtG1mI9p/7r2qUAulAJtStzfuaniCOMALg1SvxK6HbPK80MnXQC/L
         f9B5WcxSYIrrEXP8uLcenoRr9wpZILL5Z8QgT+NieYepp0FhaCFuHYQhmruq7GlSOy
         5tWEdKCncVfwxeBDzNJVObG+5754lj3Kgq2W6gyg=
Date:   Mon, 26 Oct 2020 15:10:19 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com, Jes Sorensen <Jes.Sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH] override CFLAGS too
Message-ID: <20201026221019.GB185792@sol.localdomain>
References: <20201026204831.3337360-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026204831.3337360-1-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[+Jes Sorensen]

On Mon, Oct 26, 2020 at 08:48:31PM +0000, luca.boccassi@gmail.com wrote:
> From: Romain Perier <romain.perier@gmail.com>
> 
> Currently, CFLAGS are defined by default. It has to effect to define its
> c-compiler options only when the variable is not defined on the cmdline
> by the user, it is not possible to merge or mix both, while it could
> be interesting for using the app warning cflags or the pkg-config
> cflags, while using the distributor flags. Most distributions packages
> use their own compilation flags, typically for hardening purpose but not
> only. This fixes the issue by using the override keyword.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
> Currently used in Debian, were we want to append context-specific
> compiler flags (eg: for compiler hardening options) without
> removing the default flags
> 
>  Makefile | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 6c6c8c9..5020cac 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -35,14 +35,15 @@
>  cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
>  	      then echo $(1); fi)
>  
> -CFLAGS ?= -O2 -Wall -Wundef					\
> +override CFLAGS := -O2 -Wall -Wundef				\
>  	$(call cc-option,-Wdeclaration-after-statement)		\
>  	$(call cc-option,-Wimplicit-fallthrough)		\
>  	$(call cc-option,-Wmissing-field-initializers)		\
>  	$(call cc-option,-Wmissing-prototypes)			\
>  	$(call cc-option,-Wstrict-prototypes)			\
>  	$(call cc-option,-Wunused-parameter)			\
> -	$(call cc-option,-Wvla)
> +	$(call cc-option,-Wvla)					\
> +	$(CFLAGS)
>  
>  override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)

I had it like this originally, but Jes requested that it be changed to the
current way for rpm packaging.  See the thread:
https://lkml.kernel.org/linux-fscrypt/20200515205649.1670512-3-Jes.Sorensen@gmail.com/T/#u

Can we come to an agreement on one way to do it?

To me, the approach with 'override' makes more sense.  The only non-warning
option is -O2, and if someone doesn't want that, they can just specify
CFLAGS=-O0 and it will override -O2 (since the last option "wins").

Jes, can you explain why that way doesn't work with rpm?

- Eric
