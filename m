Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197C740B5F5
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Sep 2021 19:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhINReT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Sep 2021 13:34:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231563AbhINReS (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Sep 2021 13:34:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E971F601FC;
        Tue, 14 Sep 2021 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631640781;
        bh=McmYy1tWBkVimwmUkRdoNXDfdLtu8xRcAKhaphQAII0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W4oeXVK3GoTP+dhXJ/Ky1O5X3kOa6BRhTFLvwbdrVMeqKWqQogplQPP6k2g/nB0Oo
         8nO8UKgSYgZ6oZZP2rEooy0TdUJ7BblPGeSW9hWHYYECVJXIvtnrlMUfFoc2u7oguc
         4CFYCDKin3ske+RTQlxzwxi3yTV4N+7wSwObHc+m6xW6mnO6R7/xuaNYLpYriWtitj
         roPfCir6xwwICZV6y/j+fQtjAN7Az8o3faESSE9Q27zES7BtDanG0lqotiHfIAquld
         e8GVLH0Slq7CCCJJL5P6ndaTQm18aw5JGwsXytTLUtoBjLK+8pkoXVJRlrbcOljlHm
         10EFOXhJDUT7Q==
Date:   Tue, 14 Sep 2021 10:32:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v6 2/3] btrfs: initial fsverity support
Message-ID: <YUDcy73zXVPneImG@sol.localdomain>
References: <cover.1625083099.git.boris@bur.io>
 <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Boris,

On Wed, Jun 30, 2021 at 01:01:49PM -0700, Boris Burkov wrote:
> Add support for fsverity in btrfs. To support the generic interface in
> fs/verity, we add two new item types in the fs tree for inodes with
> verity enabled. One stores the per-file verity descriptor and btrfs
> verity item and the other stores the Merkle tree data itself.
> 
> Verity checking is done in end_page_read just before a page is marked
> uptodate. This naturally handles a variety of edge cases like holes,
> preallocated extents, and inline extents. Some care needs to be taken to
> not try to verity pages past the end of the file, which are accessed by
> the generic buffered file reading code under some circumstances like
> reading to the end of the last page and trying to read again. Direct IO
> on a verity file falls back to buffered reads.
> 
> Verity relies on PageChecked for the Merkle tree data itself to avoid
> re-walking up shared paths in the tree. For this reason, we need to
> cache the Merkle tree data. Since the file is immutable after verity is
> turned on, we can cache it at an index past EOF.
> 
> Use the new inode ro_flags to store verity on the inode item, so that we
> can enable verity on a file, then rollback to an older kernel and still
> mount the file system and read the file. Since we can't safely write the
> file anymore without ruining the invariants of the Merkle tree, we mark
> a ro_compat flag on the file system when a file has verity enabled.

I want to mention the btrfs verity support in
Documentation/filesystems/fsverity.rst, and I have a couple questions:

1. Is the ro_compat filesystem flag still a thing?  The commit message claims it
   is, and BTRFS_FEATURE_COMPAT_RO_VERITY is defined in the code, but it doesn't
   seem to actually be used.  It's not needed since you found a way to make the
   inode flags ro_compat instead, right?

2. Is there a minimum version of btrfs-progs that is required to use btrfs
   verity?  With ext4 and f2fs, the fsck tools had to be updated, so there were
   minimum versions of the userspace tools required.

Thanks,

- Eric
