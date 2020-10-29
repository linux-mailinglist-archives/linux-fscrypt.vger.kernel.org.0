Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E06D29F05D
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Oct 2020 16:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgJ2Pq2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Oct 2020 11:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbgJ2Pq2 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Oct 2020 11:46:28 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 053F4207DE;
        Thu, 29 Oct 2020 15:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603986388;
        bh=ZZgcwu3qoHfzyWwL++nPL6yyRKbuVveXMBJAJncmlHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EykLKBY9jsiGKIYIGGV9kqHbT4EsWkNuMylVoTo2dGJKrH0/uR/LBOg4PGgoISJUn
         dNhF+n5/qnz3V66FKurZh1ZY4bdnA8TPdEdZYkFVAJ+TSvAExtgeVOaru0KEBZNspu
         vBUjuQQ0/9XUirOMaVLB+tVTzC+qG29xNa/Ra2vk=
Date:   Thu, 29 Oct 2020 08:46:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH] Restore installation of public header via
 make install
Message-ID: <20201029154626.GA849@sol.localdomain>
References: <20201029091828.3680106-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029091828.3680106-1-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 29, 2020 at 09:18:27AM +0000, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@microsoft.com>
> 
> Fixes: 5ca4c55e3382 ("Makefile: generate libfsverity.pc during 'make install'")
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> ---
> I think this was removed by mistake? After the linked commit make install
> does not install the header anymore
> 
>  Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Makefile b/Makefile
> index a898ed4..bfe83c4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -206,6 +206,7 @@ install:all
>  	install -m644 libfsverity.a $(DESTDIR)$(LIBDIR)
>  	install -m755 libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)
>  	ln -sf libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)/libfsverity.so
> +	install -m644 include/libfsverity.h $(DESTDIR)$(INCDIR)
>  	sed -e "s|@PREFIX@|$(PREFIX)|" \
>  		-e "s|@LIBDIR@|$(LIBDIR)|" \
>  		-e "s|@INCDIR@|$(INCDIR)|" \

Applied, thanks.  Sorry about that.

- Eric
