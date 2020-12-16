Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273102DC725
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Dec 2020 20:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388773AbgLPTdG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Dec 2020 14:33:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388756AbgLPTdE (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Dec 2020 14:33:04 -0500
Date:   Wed, 16 Dec 2020 10:44:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608144295;
        bh=5zzO+y5GgJDILr0PR+PATltqhaeVV8o0C5voIlYZ8lY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=grZpRWG767i9zaaiUdWFfoPlQHKCY7bimlhL8OHgziRfnUall17Dr9m2Ane74u6SQ
         v0irxkdGK1boETsjiNfOFYrAT9S3sjsk8ekddDNLs2dm/KSfBOS+8pyR35NbXVKudu
         XnkH1kJZ7/MPUSagPUH/45MvlPBhu0dw3sq4BBvka28nNS6I7rTavHMq5t36RZOE03
         lbqkQZGPMklkn9iMbNUZDkWSwFRX8wJ1XCv8ceS6h+fFkSmbCJjrwcMt7oZWVxcUyX
         QGaEjOM7GZY/B55aJcNefh9hSR8r7zVPptQi5R2BNEHtRA0ss/cCQwO9H0mJVLCgCd
         DzhY7RGrnyVUQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH 1/2] Remove unneeded includes
Message-ID: <X9pVpVC2Y/nGq4MG@sol.localdomain>
References: <20201216172719.540610-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216172719.540610-1-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Dec 16, 2020 at 05:27:18PM +0000, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@microsoft.com>
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> ---
>  common/fsverity_uapi.h | 1 -
>  programs/cmd_enable.c  | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/common/fsverity_uapi.h b/common/fsverity_uapi.h
> index 33f4415..0006c35 100644
> --- a/common/fsverity_uapi.h
> +++ b/common/fsverity_uapi.h
> @@ -10,7 +10,6 @@
>  #ifndef _UAPI_LINUX_FSVERITY_H
>  #define _UAPI_LINUX_FSVERITY_H
>  
> -#include <linux/ioctl.h>
>  #include <linux/types.h>

fsverity_uapi.h is supposed to be kept in sync with
include/uapi/linux/fsverity.h in the kernel source tree.

There's a reason why it includes <linux/ioctl.h>.  <linux/ioctl.h> provides the
_IOW() and _IOWR() macros to expand the values of FS_IOC_ENABLE_VERITY and
FS_IOC_MEASURE_VERITY.  Usually people referring to FS_IOC_* will include
<sys/ioctl.h> in order to actually call ioctl() too.  However it's not
guaranteed, so technically the header needs to include <linux/ioctl.h>.

Wrapping this include with '#ifdef _WIN32' would be better than removing it, as
then it would be clear that it's a Windows-specific modification.

However I think an even better approach would be to add empty files
win32-headers/linux/{types,ioctl.h} and add -Iwin32-headers to CPPFLAGS, so that
these headers can still be included in the Windows build without having to
modify the source files.

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

This part looks fine though, as cmd_enable.c no longer directly uses an ioctl.

- Eric
