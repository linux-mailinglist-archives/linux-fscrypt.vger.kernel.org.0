Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2E4297A94
	for <lists+linux-fscrypt@lfdr.de>; Sat, 24 Oct 2020 05:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759458AbgJXD4r (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 23 Oct 2020 23:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759457AbgJXD4r (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 23 Oct 2020 23:56:47 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD39221D43;
        Sat, 24 Oct 2020 03:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603511806;
        bh=JK0z6jzmDm9r+jhBXdaoMr0fbsoFelZqRCiX0Uf5398=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F0SJXOxGN52rpot1foWKdnDKhJut978VkKRf1gErJ8k4OyYPzfyeAgeyZEyRSmK2M
         HFKzG8k+CFRMf3Tg03v4FynWgnMTcW8K02HeWMSRarmRovlzW7XlVpM1YohuajrA4p
         H4kfqrVyjWxdrNmGc6Vgbn0RVi0zHYnI+51oJg2w=
Date:   Fri, 23 Oct 2020 20:56:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH 2/2] Generate and install libfsverity.pc
Message-ID: <20201024035645.GA83494@sol.localdomain>
References: <20201022175934.2999543-1-luca.boccassi@gmail.com>
 <20201022175934.2999543-2-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022175934.2999543-2-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 22, 2020 at 06:59:34PM +0100, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@microsoft.com>
> 
> pkg-config is commonly used by libraries to convey information about
> compiler flags and dependencies.
> As packagers, we heavily rely on it so that all our tools do the right
> thing by default regardless of the environment.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> ---
>  Makefile              | 13 ++++++++++++-
>  lib/libfsverity.pc.in | 10 ++++++++++
>  scripts/do-release.sh |  2 ++
>  3 files changed, 24 insertions(+), 1 deletion(-)
>  create mode 100644 lib/libfsverity.pc.in
> 
> diff --git a/Makefile b/Makefile
> index 122c0a2..07b828f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -119,6 +119,15 @@ libfsverity.so:libfsverity.so.$(SOVERSION)
>  
>  DEFAULT_TARGETS += libfsverity.so
>  
> +# Create the pkg-config file
> +libfsverity.pc:

The dependency on lib/libfsverity.pc.in should be listed here.

Also, this depends on $(PREFIX), $(LIBDIR), and $(INCDIR).  Can you also add
those and $(BINDIR) to the string that gets written to .build-config, then add a
dependency on .build-config?

> +	sed -e "s|@PREFIX@|$(PREFIX)|" \
> +		-e "s|@LIBDIR@|$(LIBDIR)|" \
> +		-e "s|@INCDIR@|$(INCDIR)|" \
> +		lib/libfsverity.pc.in > $@
> +

This looks messy in the build output:

	$ make
	  CC       lib/compute_digest.o
	  CC       lib/hash_algs.o
	  CC       lib/sign_digest.o
	  CC       lib/utils.o
	  AR       libfsverity.a
	  CC       lib/compute_digest.shlib.o
	  CC       lib/hash_algs.shlib.o
	  CC       lib/sign_digest.shlib.o
	  CC       lib/utils.shlib.o
	  CCLD     libfsverity.so.0
	  LN       libfsverity.so
	sed -e "s|@PREFIX@|/usr/local|" \
		-e "s|@LIBDIR@|/usr/local/lib|" \
		-e "s|@INCDIR@|/usr/local/include|" \
		lib/libfsverity.pc.in > libfsverity.pc
	  CC       programs/utils.o
	  CC       programs/cmd_enable.o
	  CC       programs/cmd_measure.o
	  CC       programs/cmd_sign.o
	  CC       programs/fsverity.o
	  CCLD     fsverity

Below QUIET_LN, can you add:

	QUIET_GEN       = @echo '  GEN     ' $@;

Then prefix the sed command with $(QUIET_GEN) so the output looks nice.

Also, $< can be used instead of lib/libfsverity.pc.in, once the dependency is
added.

> +DEFAULT_TARGETS += libfsverity.pc
> +
>  ##############################################################################
>  
>  #### Programs
> @@ -190,11 +199,12 @@ check:fsverity test_programs
>  	@echo "All tests passed!"
>  
>  install:all
> -	install -d $(DESTDIR)$(LIBDIR) $(DESTDIR)$(INCDIR) $(DESTDIR)$(BINDIR)
> +	install -d $(DESTDIR)$(LIBDIR)/pkgconfig $(DESTDIR)$(INCDIR) $(DESTDIR)$(BINDIR)
>  	install -m755 fsverity $(DESTDIR)$(BINDIR)
>  	install -m644 libfsverity.a $(DESTDIR)$(LIBDIR)
>  	install -m755 libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)
>  	ln -sf libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)/libfsverity.so
> +	install -m644 libfsverity.pc $(DESTDIR)$(LIBDIR)/pkgconfig
>  	install -m644 include/libfsverity.h $(DESTDIR)$(INCDIR)
>  
>  uninstall:
> @@ -202,6 +212,7 @@ uninstall:
>  	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.a
>  	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so.$(SOVERSION)
>  	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so
> +	rm -f $(DESTDIR)$(LIBDIR)/pkgconfig/libfsverity.pc
>  	rm -f $(DESTDIR)$(INCDIR)/libfsverity.h

'make clean' should remove libfsverity.pc as well.

Also, libfsverity.pc should be listed in .gitignore.

- Eric
