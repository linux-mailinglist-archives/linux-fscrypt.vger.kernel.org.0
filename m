Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CF423AA8E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Aug 2020 18:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgHCQeu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 3 Aug 2020 12:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgHCQeu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 3 Aug 2020 12:34:50 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E74D020775;
        Mon,  3 Aug 2020 16:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596472489;
        bh=uUxkIFZW7Gq4byjSYZlJicYwwogI/kDli6Qmvg/mfMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U1SM2IyVl4+qIpS17lh7keDFo+ycNRLgN7TQPbF1rjaxsvCFMH/BGa+cbSsbHres4
         oBM4tdoZMhaQ6qR/JDBnwV2w8MymBUQUyvW8acRgOL+FcXhII6EZOsur3Tk7iBdkyq
         UOXxR0erciMx7bvsEjSCrbBhWDN7/xg7YgyvMqxE=
Date:   Mon, 3 Aug 2020 09:34:48 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH] README.md: add subject tag to
 Contributing section
Message-ID: <20200803163448.GB1057@sol.localdomain>
References: <20200803040803.10529-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803040803.10529-1-po-hsu.lin@canonical.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 03, 2020 at 12:08:03PM +0800, Po-Hsu Lin wrote:
> Add subject tag suggestion [fsverity-utils PATCH] to the Contributing
> section, so that developer can follow this.
> 
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> ---
>  README.md | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/README.md b/README.md
> index b11f6d5..5a76247 100644
> --- a/README.md
> +++ b/README.md
> @@ -136,11 +136,12 @@ Send questions and bug reports to linux-fscrypt@vger.kernel.org.
>  
>  ## Contributing
>  
> -Send patches to linux-fscrypt@vger.kernel.org.  Patches should follow
> -the Linux kernel's coding style.  A `.clang-format` file is provided
> -to approximate this coding style; consider using `git clang-format`.
> -Additionally, like the Linux kernel itself, patches require the
> -following "sign-off" procedure:
> +Send patches to linux-fscrypt@vger.kernel.org with the additional tag
> +'fsverity-utils' in the subject, i.e. [fsverity-utils PATCH].  Patches
> +should follow the Linux kernel's coding style.  A `.clang-format` file
> +is provided to approximate this coding style; consider using
> + `git clang-format`.  Additionally, like the Linux kernel itself,
> +patches require the following "sign-off" procedure:
>  
>  The sign-off is a simple line at the end of the explanation for the
>  patch, which certifies that you wrote it or otherwise have the right
> -- 
> 2.17.1
> 

Thanks, applied.

- Eric
