Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8F224E42F
	for <lists+linux-fscrypt@lfdr.de>; Sat, 22 Aug 2020 02:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHVAiX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 20:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgHVAiU (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 20:38:20 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2971A2072D;
        Sat, 22 Aug 2020 00:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598056700;
        bh=Py0h0yJmL7XNxB/8xKWl5V4WVSzec+lach9VW5QkJpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jB015uLzZXCX/NwFYL8PwRTc+CXo+1TfxtRspX9uUthp++SOPH0Pc1bqFLB4AV0Xn
         Z+pWZxBmOYUo8fLi/5J6hKxgQZmcjpAFihalh+fExB4v5KII/hjxo/it+BWqtb37B0
         J8YJfZTySN6/1bASMsU+u3S3BYR0Uv9BfkkGopc4=
Date:   Fri, 21 Aug 2020 17:38:18 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [RFC PATCH 05/14] lib: lift fscrypt base64 conversion into lib/
Message-ID: <20200822003818.GB834@sol.localdomain>
References: <20200821182813.52570-1-jlayton@kernel.org>
 <20200821182813.52570-6-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821182813.52570-6-jlayton@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Aug 21, 2020 at 02:28:04PM -0400, Jeff Layton wrote:
> Once we allow encrypted filenames we'll end up with names that may have
> illegal characters in them (embedded '\0' or '/'), or characters that
> aren't printable.
> 
> It'll be safer to use strings that are printable. It turns out that the
> MDS doesn't really care about the length of filenames, so we can just
> base64 encode and decode filenames before writing and reading them.
> 
> Lift the base64 implementation that's in fscrypt into lib/. Make fscrypt
> select it when it's enabled.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/crypto/Kconfig      |  1 +
>  fs/crypto/fname.c      | 59 +----------------------------------
>  include/linux/base64.h | 11 +++++++
>  lib/Kconfig            |  3 ++
>  lib/Makefile           |  1 +
>  lib/base64.c           | 71 ++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 88 insertions(+), 58 deletions(-)
>  create mode 100644 include/linux/base64.h
>  create mode 100644 lib/base64.c

You need to be careful here because there are many subtly different variants of
base64.  The Wikipedia article is a good reference for this:
https://en.wikipedia.org/wiki/Base64

For example, most versions of base64 use [A-Za-z0-9+/].  However that's *not*
what fs/crypto/fname.c uses, since it needs the encoded strings to be valid
filenames, and '/' isn't a valid character in filenames.  Therefore,
fs/crypto/fname.c uses ',' instead of '/'.

It happens that's probably what ceph needs too.  However, other kernel
developers who come across a very generic-sounding "lib/base64.c" might expect
it to implement a more common version of base64.

Also, some versions of base64 pad the encoded string with "=" whereas others
don't.  The fs/crypto/fname.c implementation doesn't use padding.

So if you're going to make a generic base64 library, you at least need to be
very clear about exactly what version of base64 is meant.

(FWIW, the existing use of base64 in fs/crypto/fname.c isn't part of a stable
API.  So it can still be changed to something else, as long as the encoding
doesn't use the '/' or '\0' characters.)

- Eric
