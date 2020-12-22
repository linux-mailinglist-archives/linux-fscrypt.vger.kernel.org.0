Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD23A2E0328
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 01:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgLVAD5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 19:03:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgLVADz (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 19:03:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28CCB22512;
        Tue, 22 Dec 2020 00:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608595395;
        bh=Ei7b3vjDOcPp7t4/54ffi+aD7JNklC4g9+4fVne9tIY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bNHnG283+mFS/yX9mtAjvVGOQUMTWabVisIvplYupvLAXSyK3O5me4DvCSlpDAhSD
         kyWvSiexnO9LqMkVqzL3NNFSUTFPL6oJwYgeFIe6PQNFdFJkjpCLLQVMXP9y7f7KK6
         M8zLym6AthX4Nvsz/ngEQe08Bs2aKCtzJhq7slw7MDnaxdMlYN39bBznyGylnYmZC5
         bFXQqYUmf381mUno6Oq/WV62Er2vV7LCEoFSOGJIR6H2/yzrkUbpnr4lR2QhE0jqPz
         aEZ7Pi7kVxT9XDvQXVcuwDUzVq4R/ML5yrBYrIXxioOcyZgFp2PBKZArf9fk+jZjxG
         QtPnwGtJ09d5g==
Date:   Mon, 21 Dec 2020 16:03:13 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     linux-fscrypt@vger.kernel.org,
        Luca Boccassi <luca.boccassi@microsoft.com>
Subject: Re: [PATCH v6 3/3] Allow to build and run sign/digest on Windows
Message-ID: <X+E3wa/sdzGDHf7I@sol.localdomain>
References: <20201221221953.256059-1-bluca@debian.org>
 <20201221232428.298710-1-bluca@debian.org>
 <20201221232428.298710-3-bluca@debian.org>
 <X+E1a5jRbkZzS3j4@sol.localdomain>
 <CAMw=ZnTm7TOWg=yBeYr6tnpLux_pU7QXH3OtfPW3Rd1reuAtgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMw=ZnTm7TOWg=yBeYr6tnpLux_pU7QXH3OtfPW3Rd1reuAtgA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 21, 2020 at 11:57:41PM +0000, Luca Boccassi wrote:
> On Mon, 21 Dec 2020 at 23:53, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Mon, Dec 21, 2020 at 11:24:28PM +0000, Luca Boccassi wrote:
> > > +### Building on Windows
> > > +
> > > +There is minimal support for building Windows executables using MinGW.
> > > +```bash
> > > +    make CC=x86_64-w64-mingw32-gcc-win32
> > > +```
> > > +
> > > +`fsverity.exe` will be built, and it supports the `digest` and `sign` commands.
> > > +
> > > +A Windows build of OpenSSL/libcrypto needs to be available.
> >
> > For me "CC=x86_64-w64-mingw32-gcc-win32" doesn't work; I need
> > "x86_64-w64-mingw32-gcc" instead.  Is this difference intentional?
> >
> > - Eric
> 
> It's a distro setup difference I think, on Debian
> x86_64-w64-mingw32-gcc is a symlink to x86_64-w64-mingw32-gcc-win32:
> 
> $ ls -l /usr/bin/x86_64-w64-mingw32-gcc-win32
> -rwxr-xr-x 2 root root 1160320 Nov 27 05:57
> /usr/bin/x86_64-w64-mingw32-gcc-win32
> $ ls -l /usr/bin/x86_64-w64-mingw32-gcc
> lrwxrwxrwx 1 root root 40 Sep 27 18:41 /usr/bin/x86_64-w64-mingw32-gcc
> -> /etc/alternatives/x86_64-w64-mingw32-gcc
> $ ls -l /etc/alternatives/x86_64-w64-mingw32-gcc
> lrwxrwxrwx 1 root root 37 Sep 27 18:44
> /etc/alternatives/x86_64-w64-mingw32-gcc ->
> /usr/bin/x86_64-w64-mingw32-gcc-win32

Okay, it would be better to document the one that works on all distros.

- Eric
