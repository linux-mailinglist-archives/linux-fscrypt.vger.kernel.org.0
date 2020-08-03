Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD1723AA89
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Aug 2020 18:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgHCQeg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 3 Aug 2020 12:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgHCQeg (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 3 Aug 2020 12:34:36 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB75820775;
        Mon,  3 Aug 2020 16:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596472475;
        bh=Kvx8RkrT/KT5zfWfiLUGRKA45SPhUNBLpZiIFidTslA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e/l6S3IeOlkWf9OgBGFaLOCp2L7ZUFERAcv5MmY0bBC5tPqUO6z+S3KRZ/dDJ+EW5
         S3GAg86UcW3BxJmMzaYy6gg1CPzkiw2k1jAW3DmlUscnhQdzYHRXTh0x1zOanvffR6
         KSvEM5rXdu2nlXqvwqHrD8bdAxNp5aKJdPlnAJlY=
Date:   Mon, 3 Aug 2020 09:34:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCHv2] Makefile: improve the cc-option
 compatibility
Message-ID: <20200803163434.GA1057@sol.localdomain>
References: <20200803030736.6364-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200803030736.6364-1-po-hsu.lin@canonical.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 03, 2020 at 11:07:36AM +0800, Po-Hsu Lin wrote:
> The build on Ubuntu Xenial with GCC 5.4.0 will fail with:
>     cc: error: unrecognized command line option ‘-Wimplicit-fallthrough’
> 
> This unsupported flag is not skipped as expected.
> 
> It is because of the /bin/sh shell on Ubuntu, DASH, which does not
> support this &> redirection. Use 2>&1 to solve this problem.
> 
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index e0a3938..ec23ed6 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -32,7 +32,7 @@
>  #
>  ##############################################################################
>  
> -cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
> +cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
>  	      then echo $(1); fi)
>  
>  CFLAGS ?= -O2 -Wall -Wundef					\
> -- 
> 2.17.1
> 

Thanks, applied.

- Eric
