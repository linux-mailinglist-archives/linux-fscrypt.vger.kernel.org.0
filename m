Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981A01DC0EA
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 23:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgETVGY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 17:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgETVGX (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 17:06:23 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69E3620829;
        Wed, 20 May 2020 21:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590008783;
        bh=LisjjTnOv9BWoC3uRRbgr2ORDVKDbwdObu6c9CCKaRU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sFMtsI4JK736U2TaZfns8ftbxWnzOGC54iNh7qIyn9uykm2PlgcDZzNFlSOc3vpcc
         FKqJXCeY2Gi7lxSl74lRPgqWM/pZUMNF4Eoay9z/kVSCM4HNGdVr5QZmHWCXfXfe0w
         kffJ7hC9TOwYTOyYMxSK/qf2azO0vBUe/5T0VF74=
Date:   Wed, 20 May 2020 14:06:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH 2/2] Let package manager override CFLAGS and CPPFLAGS
Message-ID: <20200520210622.GB218475@gmail.com>
References: <20200520200811.257542-1-Jes.Sorensen@gmail.com>
 <20200520200811.257542-3-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520200811.257542-3-Jes.Sorensen@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 20, 2020 at 04:08:11PM -0400, Jes Sorensen wrote:
> From: Jes Sorensen <jsorensen@fb.com>
> 
> Package managers such as RPM wants to build everything with their
> preferred flags, and we shouldn't hard override flags.
> 
> Signed-off-by: Jes Sorensen <jsorensen@fb.com>
> ---
>  Makefile | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index e7fb5cf..7bcd5e4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -32,15 +32,14 @@ cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
>  #### Common compiler flags.  You can add additional flags by defining CFLAGS
>  #### and/or CPPFLAGS in the environment or on the 'make' command line.

The above comment is still being made outdated.  IMO, just remove it.

>  
> -override CFLAGS := -O2 -Wall -Wundef				\
> +CFLAGS := -O2 -Wall -Wundef				\
>  	$(call cc-option,-Wdeclaration-after-statement)		\
>  	$(call cc-option,-Wmissing-prototypes)			\
>  	$(call cc-option,-Wstrict-prototypes)			\
>  	$(call cc-option,-Wvla)					\
> -	$(call cc-option,-Wimplicit-fallthrough)		\
> -	$(CFLAGS)
> +	$(call cc-option,-Wimplicit-fallthrough)
>  
> -override CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
> +CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)

On the other thread you ageed that CPPFLAGS should be left as-is, but here you
removed 'override'.  I think always using -D_FILE_OFFSET_BITS=64 is what we
want, since it avoids incorrect builds on 32-bit platforms.  Right?

- Eric
