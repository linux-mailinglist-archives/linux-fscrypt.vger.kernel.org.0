Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033E51DA878
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 05:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgETDGz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 May 2020 23:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgETDGz (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 May 2020 23:06:55 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5573E20578;
        Wed, 20 May 2020 03:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589944014;
        bh=0Iy9vn31cVVQhqg3Gq+d2PO0qYskZ30rMo8FxEtRAqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rw3Z1YOu88ihQhkTRC+t/QpY7fBw65+1aJ2WhUBPMq9yOc1aBBUlwxDcUfBBZ+bIv
         k31Iple/c8B4gsXpIRSw0XnSY8zDHE5/dE2fIBSh6zs4hVVB8rv+mak3PyW4Q45aW5
         QgtTv8E4hikCq5nSOQCDomZ1W5dxOeuj9dGayKl0=
Date:   Tue, 19 May 2020 20:06:52 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-fscrypt@vger.kernel.org,
        Jes Sorensen <jes.sorensen@gmail.com>, jsorensen@fb.com,
        kernel-team@fb.com
Subject: Re: [PATCH 0/3] fsverity-utils: introduce libfsverity
Message-ID: <20200520030652.GC3510@sol.localdomain>
References: <20200515041042.267966-1-ebiggers@kernel.org>
 <6fd1ea1f-d6e6-c423-4a52-c987f172bb50@trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fd1ea1f-d6e6-c423-4a52-c987f172bb50@trained-monkey.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 15, 2020 at 04:50:49PM -0400, Jes Sorensen wrote:
> On 5/15/20 12:10 AM, Eric Biggers wrote:
> > From the 'fsverity' program, split out a library 'libfsverity'.
> > Currently it supports computing file measurements ("digests"), and
> > signing those file measurements for use with the fs-verity builtin
> > signature verification feature.
> > 
> > Rewritten from patches by Jes Sorensen <jsorensen@fb.com>.
> > I made a lot of improvements; see patch 2 for details.
> > 
> > Jes, can you let me know whether this works for you?  Especially take a
> > close look at the API in libfsverity.h.
> 
> Hi Eric,
> 
> Thanks for looking at this. I have gone through this and managed to get
> my RPM code to work with it. I will push the updated code to my rpm
> github repo shortly. I have two fixes for the Makefile I will send to
> you in a separate email.
> 
> One comment I have is that you changed the size of version and
> hash_algorithm to 32 bit in struct libfsverity_merkle_tree_params, but
> the kernel API only takes 8 bit values anyway. I had them at 16 bit to
> handle the struct padding, but if anything it seems to make more sense
> to make them 8 bit and pad the struct?
> 
> struct libfsverity_merkle_tree_params {
>         uint32_t version;
>         uint32_t hash_algorithm;
> 
> That said, not a big deal.
> 

Well, they're 32-bit in 'struct fsverity_enable_arg' (the argument to
FS_IOC_ENABLE_VERITY), but 8-bit in 'struct fsverity_descriptor'.
The reason for the difference is that 'struct fsverity_enable_arg' is just an
in-memory structure for the ioctl, so there was no reason not to use larger
fields.  But fsverity_descriptor is stored on-disk and hashed, and it has to
have a specific byte order, so just using 8-bit fields for it seemed best.

'struct libfsverity_merkle_tree_params' is just an in-memory structure too, so I
think going with the 32-bits convention makes sense.

- Eric
