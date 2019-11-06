Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 819B6F1DB7
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Nov 2019 19:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfKFSne (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 6 Nov 2019 13:43:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:41744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfKFSne (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 6 Nov 2019 13:43:34 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EEA2217F4;
        Wed,  6 Nov 2019 18:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573065814;
        bh=ke8JGRHDbOZzUcdQbFDcBJrQ4vmk1ezt+ayq+wpvnS8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WsguCgvnEkD+OWNLq0HbslNmJPDLUmQEoba+6mPGu+BWqCNW/xfQZRJMZ2+1Tps2X
         f9cE7lMm+79NXSZqukicWL/LFvqM5OpQJ5t233C9zUKVAIumgux1oqMBNfnCtVWOtk
         jjDkHgfontJg/Svd8ZSDwbCRYjj4F0aH4wK71Qt0=
Date:   Wed, 6 Nov 2019 10:43:32 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Colin Walters <walters@verbum.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: version/tags for fsverity-utils
Message-ID: <20191106184332.GC2766@sol.localdomain>
Mail-Followup-To: Colin Walters <walters@verbum.org>,
        linux-fscrypt@vger.kernel.org
References: <3c1e9aca-2390-4350-a19d-baff6a065c6a@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c1e9aca-2390-4350-a19d-baff6a065c6a@www.fastmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 06, 2019 at 10:57:08AM -0500, Colin Walters wrote:
> Hi, I'm looking at fsverity for Fedora CoreOS (a bit more background in https://github.com/ostreedev/ostree/pull/1959 )
> I have a bunch of questions there (feel free to jump in), but just to start here: 
> 
> I'd like to get fsverity-utils as a Fedora package, but there don't seem to be any git tags on the repo https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/  - I could make up a datestamped version number, but I think it'd be better if there were upstream tags - it is useful to have releases with human-consumable version numbers for the usual reasons. And RPM/dpkg/etc really care about the version numbers of packages.
> 
> Other distributions/some packagers think "release" means tarballs, so someone may want to consider that too, personally 
> I use https://github.com/cgwalters/git-evtag for making git tags since I think it helps replace tarballs.

Yes, I think it's time for a formal release of fsverity-utils now that fs-verity
is in the upstream kernel.  I've tagged v1.0 and uploaded the tarball to here:
https://kernel.org/pub/linux/kernel/people/ebiggers/fsverity-utils/v1.0/

- Eric
