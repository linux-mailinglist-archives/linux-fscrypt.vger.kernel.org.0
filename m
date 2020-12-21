Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303F92E0319
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 00:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgLUXx5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 18:53:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgLUXx5 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 18:53:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1474720760;
        Mon, 21 Dec 2020 23:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608594797;
        bh=5W/mRqsHV/Rh+tJYsII8C8hvhCotAP7ZF58hQoXddoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nwituihyCehQLH++8tWUPslVq+ZTkGRGhK9xOdQPoZ/xwxmeyqKZdXtWZuMPrtQUw
         Lxdcga5vBVk8hy7ggJQuqPgap5PLuAp1rpFBy5CSZ9JAiIx+ppgBcXrTn1LUI/O27K
         +cKYiPfCcQagKFw0KW+g6HT1Ex8QlboZ0gOqBTR/WELEWz3M0QV033Oq6kDjG7cgUm
         E6xzyCScdZ5sUQt7UnGHlJrJ7rRF/7oAxc0BeMYHBEnfbe6oCxerdoZlXkeOLulqMr
         M4midznYTIvLYuO9jqhqFrxuNyW+Mjx+Vh8eliBHYavKbD8+pBX14/1r/uXD39ZKkK
         5AvoheGWIaU4A==
Date:   Mon, 21 Dec 2020 15:53:15 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     linux-fscrypt@vger.kernel.org,
        Luca Boccassi <luca.boccassi@microsoft.com>
Subject: Re: [PATCH v6 3/3] Allow to build and run sign/digest on Windows
Message-ID: <X+E1a5jRbkZzS3j4@sol.localdomain>
References: <20201221221953.256059-1-bluca@debian.org>
 <20201221232428.298710-1-bluca@debian.org>
 <20201221232428.298710-3-bluca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221232428.298710-3-bluca@debian.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 21, 2020 at 11:24:28PM +0000, Luca Boccassi wrote:
> +### Building on Windows
> +
> +There is minimal support for building Windows executables using MinGW.
> +```bash
> +    make CC=x86_64-w64-mingw32-gcc-win32
> +```
> +
> +`fsverity.exe` will be built, and it supports the `digest` and `sign` commands.
> +
> +A Windows build of OpenSSL/libcrypto needs to be available.

For me "CC=x86_64-w64-mingw32-gcc-win32" doesn't work; I need
"x86_64-w64-mingw32-gcc" instead.  Is this difference intentional?

- Eric
