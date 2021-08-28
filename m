Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7AE3FA2BA
	for <lists+linux-fscrypt@lfdr.de>; Sat, 28 Aug 2021 03:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhH1BNd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 27 Aug 2021 21:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232763AbhH1BNd (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 27 Aug 2021 21:13:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 944C360F4C;
        Sat, 28 Aug 2021 01:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630113163;
        bh=RzK+HmlCOuEVg3msc8RNYz5fYhd3IExOCrZeB5q8WX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GHFtlYy0fDrCUrAvID+Dq0HOLadj5yaunIlBPQiA2vcPol9lllBpLrSv0p7JYHvSX
         NnrmuQl+YmpNZEevVMMsrgd8aaoQLEeV14yg+pPO/CsbJzKLNIo6A+Q/zbx2jUHHmU
         QhEZVjl7cMOz6MxHygJMojxugM9VzJWIrfyutxz7Q1pmj8vE1zoOahS8mX81GTC4sK
         MpU0j7pn2wcolBPlS/MCGob0FqGssWVDMId1lclLsPND7fUmfkoHwVyI2qhNHcB5CZ
         j95jkQiaiL6u12uq0QU3hjgcxi+EisQ92q2mpRvAiJgyrc60hLz3ozniTGtfqXBbGI
         sYMDTYi3Aq+/Q==
Date:   Fri, 27 Aug 2021 18:12:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Aleksander Adamowski <olo@fb.com>
Cc:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [PATCH] Implement PKCS#11 opaque keys support through OpenSSL
 pkcs11 engine
Message-ID: <YSmNireyel2hCKwy@sol.localdomain>
References: <20210826001346.1899149-1-olo@fb.com>
 <YSfncv8Agfam4P2m@sol.localdomain>
 <CO1PR15MB48272C3F89D0B6789DC82AC9DDC99@CO1PR15MB4827.namprd15.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR15MB48272C3F89D0B6789DC82AC9DDC99@CO1PR15MB4827.namprd15.prod.outlook.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Aug 28, 2021 at 01:03:10AM +0000, Aleksander Adamowski wrote:
> Hi Eric!
> > I'm not particularly familiar with the OpenSSL PKCS#11 engine, but this patch
> > looks reasonable at a high level (assuming that you really want to use the
> > kernel's built-in fs-verity signature verification support -- I've been trying
> > to encourage people to do userspace signature verification instead).
> 
> We are currently going forward with in-kernel sig verification (and btrfs), but
> I'd love to hear more about the userspace support you mention.
> 

Well, there isn't much to explain about it.  Userspace could just store whatever
signature it wants to in a separate file or in an xattr, and verify it at the
same time it checks the fs-verity bit which it must already be doing.  Then
there's no need for PKCS#7 or RSA in the kernel, and any signature algorithms
could be used -- not just the ones the kernel supports.  Also no need for
PKCS#7; something simpler could be used.

In retrospect I probably shouldn't have implemented the in-kernel signature
verification at all, as now everyone wants to use it even though it's a bad
design and was just meant as a proof of concept.  They see it and think "I want
signatures, so I'll use it", without considering better ways to do signatures.

- Eric
