Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2959518E674
	for <lists+linux-fscrypt@lfdr.de>; Sun, 22 Mar 2020 06:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgCVFFK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 22 Mar 2020 01:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgCVFFK (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 22 Mar 2020 01:05:10 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DBB120724;
        Sun, 22 Mar 2020 05:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584853509;
        bh=M0ZjdhiyjiwfvpxYGCCKSNdcBiseiK7ZSgaHsNjy+rA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MsblOohv3scNVN+J3jBVzeZEXwiZURyaBJKb4MY3nMyhm9ZiMvPqnJiAPSB3LDRvF
         b87C54bPyNB+h0EfopSAMSps1LyZR/oUIb7oPv0COBwmlODi/I4vM8We/mbYXp5+eo
         7GDzxQhmEsmt+HpznO5ayEIs3QfWnaKKHiEr3qhs=
Date:   Sat, 21 Mar 2020 22:05:07 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH v3 0/9]  Split fsverity-utils into a shared library
Message-ID: <20200322050507.GD111151@sol.localdomain>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 12, 2020 at 05:47:49PM -0400, Jes Sorensen wrote:
> From: Jes Sorensen <jsorensen@fb.com>
> 
> Hi,
> 
> This is an updated version of my patches to split fsverity-utils into
> a shared library. This version addresses most of the comments I
> received in the last version:
> 
> 1) Document the API
> 2) Verified ran xfstest against the build
> 3) Make struct fsverity_descriptor private
> 4) Reviewed (and documented) error codes
> 5) Improved validation of input parameters, and return error if any
>    reserved field is not zero.
> 
> I left struct fsverity_hash_alg in the public API, because it adds
> useful information to the user, in particular providing the digest
> size, and allows the caller to walk the list to obtain the supported
> algorithms. The alternative is to introduce a
> libverity_get_digest_size() call.
> 
> I still need to add some self-tests to the build and deal with the
> soname stuff.
> 
> Next up is rpm support.
> 
> Cheers,
> Jes
> 
> 
> Jes Sorensen (9):
>   Build basic shared library framework
>   Change compute_file_measurement() to take a file descriptor as
>     argument
>   Move fsverity_descriptor definition to libfsverity.h
>   Move hash algorithm code to shared library
>   Create libfsverity_compute_digest() and adapt cmd_sign to use it
>   Introduce libfsverity_sign_digest()
>   Validate input arguments to libfsverity_compute_digest()
>   Validate input parameters for libfsverity_sign_digest()
>   Document API of libfsverity
> 
>  Makefile              |  18 +-
>  cmd_enable.c          |  11 +-
>  cmd_measure.c         |   4 +-
>  cmd_sign.c            | 526 +++------------------------------------
>  fsverity.c            |  16 +-
>  hash_algs.c           |  26 +-
>  hash_algs.h           |  27 --
>  libfsverity.h         | 127 ++++++++++
>  libfsverity_private.h |  33 +++
>  libverity.c           | 559 ++++++++++++++++++++++++++++++++++++++++++
>  util.h                |   2 +
>  11 files changed, 801 insertions(+), 548 deletions(-)
>  create mode 100644 libfsverity.h
>  create mode 100644 libfsverity_private.h
>  create mode 100644 libverity.c

Have you tried using the library?  It doesn't work for me because it uses
functions from util.c which aren't compiled in:

test.c:

	#include "libfsverity.h"

	int main() { }

$ gcc test.c -L. -lfsverity

/usr/bin/ld: ./libfsverity.so: undefined reference to `do_error_msg'
/usr/bin/ld: ./libfsverity.so: undefined reference to `error_msg_errno'
/usr/bin/ld: ./libfsverity.so: undefined reference to `error_msg'
/usr/bin/ld: ./libfsverity.so: undefined reference to `fatal_error'
/usr/bin/ld: ./libfsverity.so: undefined reference to `assertion_failed'
/usr/bin/ld: ./libfsverity.so: undefined reference to `xmalloc'
/usr/bin/ld: ./libfsverity.so: undefined reference to `xzalloc'
/usr/bin/ld: ./libfsverity.so: undefined reference to `xmemdup'

- Eric
