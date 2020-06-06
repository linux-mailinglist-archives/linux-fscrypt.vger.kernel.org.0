Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3731F040C
	for <lists+linux-fscrypt@lfdr.de>; Sat,  6 Jun 2020 02:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgFFAq4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 Jun 2020 20:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728506AbgFFAq4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 Jun 2020 20:46:56 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAD69206A2;
        Sat,  6 Jun 2020 00:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591404415;
        bh=vtIlr8cBQaumaJ5rweOU+CcoWc+hRYcXJnW1X0Ah8WM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EMiFbsc2ztW2Kc+LjAJQBLyi1RDfVoFeLpLMaVTgfXwR8IqVPmqvn4Unw+vYd8G2k
         gWN79cg7A4gMhQz3qh8OouHaZ1LbU/57ovDHezm1CeONV5THFk4A8ZFnGtb9/xvlbz
         asX+cayZwB5fb3NSeR1EFsgWpVc38nt0lSMh8XBU=
Date:   Fri, 5 Jun 2020 17:46:54 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-fscrypt@vger.kernel.org,
        Jes Sorensen <jes.sorensen@gmail.com>, jsorensen@fb.com,
        kernel-team@fb.com
Subject: Re: [PATCH v2 0/3] fsverity-utils: introduce libfsverity
Message-ID: <20200606004654.GN1373@sol.localdomain>
References: <20200525205432.310304-1-ebiggers@kernel.org>
 <20200527211544.GA14135@sol.localdomain>
 <6c829c1c-9197-122f-885c-20157b2b4c22@trained-monkey.org>
 <ad30cd43-3452-e6ba-7de0-19084acd23b5@trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad30cd43-3452-e6ba-7de0-19084acd23b5@trained-monkey.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jun 05, 2020 at 12:44:21PM -0400, Jes Sorensen wrote:
> On 5/28/20 9:22 AM, Jes Sorensen wrote:
> > On 5/27/20 5:15 PM, Eric Biggers wrote:
> >> On Mon, May 25, 2020 at 01:54:29PM -0700, Eric Biggers wrote:
> >>> From the 'fsverity' program, split out a library 'libfsverity'.
> >>> Currently it supports computing file measurements ("digests"), and
> >>> signing those file measurements for use with the fs-verity builtin
> >>> signature verification feature.
> >>>
> >>> Rewritten from patches by Jes Sorensen <jsorensen@fb.com>.
> >>> I made a lot of improvements; see patch 2 for details.
> >>>
> >>> This patchset can also be found at branch "libfsverity" of
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/
> >>>
> >>> Changes v1 => v2:
> >>>   - Fold in the Makefile fixes from Jes
> >>>   - Rename libfsverity_digest_size() and libfsverity_hash_name()
> >>>   - Improve the documentation slightly
> >>>   - If a memory allocation fails, print the allocation size
> >>>   - Use EBADMSG for invalid cert or keyfile, not EINVAL
> >>>   - Make libfsverity_find_hash_alg_by_name() handle NULL
> >>>   - Avoid introducing compiler warnings with AOSP's default cflags
> >>>   - Don't assume that BIO_new_file() sets errno
> >>>   - Other small cleanups
> >>>
> >>> Eric Biggers (3):
> >>>   Split up cmd_sign.c
> >>>   Introduce libfsverity
> >>>   Add some basic test programs for libfsverity
> >>>
> >>
> >> Applied and pushed out to the 'master' branch.
> > 
> > Awesome, any idea when you'll be able to tag a new official release?
> 
> Hi Eric,
> 
> Ping, anything holding up the release at this point?
> 
> Sorry for nagging, I would really like to push an updated version to
> Rawhide that can be distributed as a prerequisite for the RPM changes.
> 

I might do it this weekend, but I've been working on a test script and some
other improvements first.

Also, please feel free to contribute more test programs or extend the existing
ones.  We could use more test coverage of the library.

- Eric
