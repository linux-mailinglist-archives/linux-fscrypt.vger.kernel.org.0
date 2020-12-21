Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56742E0211
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Dec 2020 22:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgLUVdH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 16:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbgLUVdG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 16:33:06 -0500
Date:   Mon, 21 Dec 2020 13:32:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608586346;
        bh=Pv/xN6pa3SnKPRANfY1jXfzDSLSoc1A+zlgGMUEctKg=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=FpV2rj3SuYB6cZ2ooHkCZibcTZCGj0d1QnuQczGPmWpI6o33jTbB6JGk1WoXCtB1a
         LAX1BTFLa4vRKLx64lQwLcf+XSJkWV4oTrgp4BC+5PDe+R6SLRU7UFK0sPPFq8MJap
         Dpmt+iOh4r84Gl1ur2aKYUHLLPlFNLOlCxHd3FOJS6gCuHTe7U0nFI7ZZBnO5CO7+h
         jOCiyFfZuUpUNhUdXiGw3r2SK4RAeEtszs9xidFtgeML4WXviy1kJ0JkTxSxJDTYcb
         YnES7OR/xAGPoFetTQG/0E8cv6x3M/rQ3u9JrKqj2ZSNF8uU8DxKqZRbBPAim7NUWn
         QrU7pvQpwnL4Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH v4 1/2] Remove unneeded includes
Message-ID: <X+EUaFC88fnpw8aa@sol.localdomain>
References: <20201217144749.647533-1-luca.boccassi@gmail.com>
 <20201217192516.3683371-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217192516.3683371-1-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 17, 2020 at 07:25:15PM +0000, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@microsoft.com>
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> ---
> v2: do not remove includes from fsverity_uapi.h, actually needed
> 
>  programs/cmd_enable.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/programs/cmd_enable.c b/programs/cmd_enable.c
> index fdf26c7..14c3c17 100644
> --- a/programs/cmd_enable.c
> +++ b/programs/cmd_enable.c
> @@ -14,7 +14,6 @@
>  #include <fcntl.h>
>  #include <getopt.h>
>  #include <limits.h>
> -#include <sys/ioctl.h>
>  
>  static bool read_signature(const char *filename, u8 **sig_ret,
>  			   u32 *sig_size_ret)

Applied with s/includes/include/.

- Eric
