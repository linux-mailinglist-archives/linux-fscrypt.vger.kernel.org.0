Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF6624E461
	for <lists+linux-fscrypt@lfdr.de>; Sat, 22 Aug 2020 03:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgHVBL4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 21:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgHVBL4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 21:11:56 -0400
Received: from vulkan.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34C46207CD;
        Sat, 22 Aug 2020 01:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598058715;
        bh=Ex8i7TuGfjhsnJtmMQiq+QoKO5Ye/DME9EKj0PHAVEs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oCclZ5wRvTJe0rv05qdq7U9/Ihi6215ZB75PfWmTEBkfWJzInPOlZtQvNJM//ScSI
         MC9UkMVlmQEKpkyGXvj2/wjTU0UXkOo8On1lzwkNLFzzpN5brqP0Q0vsrIPUO0VLvM
         LVq16vNGyHYBBRc9W7oe49YptP9vURrVpxhreXlY=
Message-ID: <3787ef6b2a6c7aefab07fc81d8b2c5da6ce12a13.camel@kernel.org>
Subject: Re: [RFC PATCH 05/14] lib: lift fscrypt base64 conversion into lib/
From:   Jeff Layton <jlayton@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Date:   Fri, 21 Aug 2020 21:11:53 -0400
In-Reply-To: <20200822003818.GB834@sol.localdomain>
References: <20200821182813.52570-1-jlayton@kernel.org>
         <20200821182813.52570-6-jlayton@kernel.org>
         <20200822003818.GB834@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 2020-08-21 at 17:38 -0700, Eric Biggers wrote:
> On Fri, Aug 21, 2020 at 02:28:04PM -0400, Jeff Layton wrote:
> > Once we allow encrypted filenames we'll end up with names that may have
> > illegal characters in them (embedded '\0' or '/'), or characters that
> > aren't printable.
> > 
> > It'll be safer to use strings that are printable. It turns out that the
> > MDS doesn't really care about the length of filenames, so we can just
> > base64 encode and decode filenames before writing and reading them.
> > 
> > Lift the base64 implementation that's in fscrypt into lib/. Make fscrypt
> > select it when it's enabled.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/crypto/Kconfig      |  1 +
> >  fs/crypto/fname.c      | 59 +----------------------------------
> >  include/linux/base64.h | 11 +++++++
> >  lib/Kconfig            |  3 ++
> >  lib/Makefile           |  1 +
> >  lib/base64.c           | 71 ++++++++++++++++++++++++++++++++++++++++++
> >  6 files changed, 88 insertions(+), 58 deletions(-)
> >  create mode 100644 include/linux/base64.h
> >  create mode 100644 lib/base64.c
> 
> You need to be careful here because there are many subtly different variants of
> base64.  The Wikipedia article is a good reference for this:
> https://en.wikipedia.org/wiki/Base64
> 
> For example, most versions of base64 use [A-Za-z0-9+/].  However that's *not*
> what fs/crypto/fname.c uses, since it needs the encoded strings to be valid
> filenames, and '/' isn't a valid character in filenames.  Therefore,
> fs/crypto/fname.c uses ',' instead of '/'.
> 
> It happens that's probably what ceph needs too.  However, other kernel
> developers who come across a very generic-sounding "lib/base64.c" might expect
> it to implement a more common version of base64.
> 
> Also, some versions of base64 pad the encoded string with "=" whereas others
> don't.  The fs/crypto/fname.c implementation doesn't use padding.
> 
> So if you're going to make a generic base64 library, you at least need to be
> very clear about exactly what version of base64 is meant.
> 
> (FWIW, the existing use of base64 in fs/crypto/fname.c isn't part of a stable
> API.  So it can still be changed to something else, as long as the encoding
> doesn't use the '/' or '\0' characters.)
> 
> - Eric

Ok, thanks -- that makes sense. We may need to rename this to something
less generic then. I'll plan to do that for the next set.

It may also make more sense to just create fscrypt functions that can
deal with base64-encoded strings instead of binary crypttext.
-- 
Jeff Layton <jlayton@kernel.org>

