Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F471DA862
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 05:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgETDAO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 May 2020 23:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728129AbgETDAO (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 May 2020 23:00:14 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3473B2083E;
        Wed, 20 May 2020 02:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589943287;
        bh=X1bcXiM6cSxyYh5vLFf78vjsufzNCDnge0uauVR2tJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q8d5Rt2MjxtLIRHTl9KkxRC3d7PqW/0D5S6p9mcyWrS69JhxoIYYT5DSYaAAmyMjT
         vAKa6zYpkq4+BU0lvHbyhspwOKV6ZNI6wdkbIHa21QFB4EBwnnXiHISAdeV7OJrfOZ
         9UJhCO28g/Jq2RpMr0p5tPVxLIrPBkgCtko6yL/k=
Date:   Tue, 19 May 2020 19:54:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH 2/2] Let package manager override CFLAGS and CPPFLAGS
Message-ID: <20200520025445.GB3510@sol.localdomain>
References: <20200515205649.1670512-1-Jes.Sorensen@gmail.com>
 <20200515205649.1670512-3-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515205649.1670512-3-Jes.Sorensen@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 15, 2020 at 04:56:49PM -0400, Jes Sorensen wrote:
> From: Jes Sorensen <jsorensen@fb.com>
> 
> Package managers such as RPM wants to build everything with their
> preferred flags, and we shouldn't hard override flags.
> 
> Signed-off-by: Jes Sorensen <jsorensen@fb.com>
> ---
>  Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index c5f46f4..0c2a621 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -32,7 +32,7 @@ cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
>  #### Common compiler flags.  You can add additional flags by defining CFLAGS
>  #### and/or CPPFLAGS in the environment or on the 'make' command line.

The above comment needs to be updated.

>  
> -override CFLAGS := -O2 -Wall -Wundef				\
> +CFLAGS := -O2 -Wall -Wundef				\
>  	$(call cc-option,-Wdeclaration-after-statement)		\
>  	$(call cc-option,-Wmissing-prototypes)			\
>  	$(call cc-option,-Wstrict-prototypes)			\
> @@ -40,7 +40,7 @@ override CFLAGS := -O2 -Wall -Wundef				\
>  	$(call cc-option,-Wimplicit-fallthrough)		\
>  	$(CFLAGS)

The user's $(CFLAGS) is already added at the end, so the -O2 can already be
overridden, e.g. with -O0.  Is your concern just that this is bad practice?

Also, did you intentionally leave $(CFLAGS) at the end, rather than remove it as
might be expected?

> -override CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
> +CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)

-D_FILE_OFFSET_BITS=64 is required for correctness.
So I think this part is good as-is.

- Eric
