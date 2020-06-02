Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAFD1EC497
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jun 2020 23:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgFBVuX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 2 Jun 2020 17:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgFBVuW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 2 Jun 2020 17:50:22 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65D97206C3;
        Tue,  2 Jun 2020 21:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591134622;
        bh=lurGolYU6q586PjUd4Y+yIHXlwXbt3uxWJVS5PF37Os=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WMdlxPNUy4EX0heeXmTdqiKSGZXgAdQflslf6eMYZt8lslBIxdZiRjLX3tkqFVqkg
         522J7yGOboWyqrhDQCesR9Gg3m+tLWi4Rp060x8zIVK1C6aBvU67hkmctkCC0MG3+Q
         rx9cwSq8PFlfph4KvmUJEArdyM9ZFawT7JHdn4Vg=
Date:   Tue, 2 Jun 2020 14:50:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chris Mason <clm@fb.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Subject: Re: fsverity PAGE_SIZE constraints
Message-ID: <20200602215021.GB229073@gmail.com>
References: <69713333-8072-adf0-a6bb-8f73b3c390d0@trained-monkey.org>
 <20200601203647.GB168749@gmail.com>
 <628EC883-AD9E-4E4D-A219-C94979C51B98@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <628EC883-AD9E-4E4D-A219-C94979C51B98@fb.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jun 02, 2020 at 11:49:36AM -0400, Chris Mason wrote:
> On the btrfs side, I’m storing the fsverity data in the btree, so I’m merkle
> block size agnostic.  Since our rollout is going to be x86, we’ll end up
> using the 4k size internally for the current code base.
> 
> My recommendation to simplify the merkle tree code would be to just put it
> in slab objects instead pages and leverage recent MM changes to make reclaim
> work well.  There’s probably still more to do on that front, but it’s a long
> standing todo item for Josef to shift the btrfs metadata out of the page
> cache, where we have exactly the same problems for exactly the same reasons.

Do you have an idea for how to do that without introducing much extra overhead
to ext4 and f2fs with Merkle tree block size == PAGE_SIZE?  Currently they just
cache the Merkle tree pages in the inode's page cache.  We don't *have* to do it
that way, but anything that adds additional overhead (e.g. reading data into
pagecache, then copying it into slab allocations, then freeing the pagecache
pages) would be undesirable.  We need to keep the overhead minimal.

- Eric
