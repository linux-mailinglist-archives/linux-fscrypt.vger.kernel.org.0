Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B13840B64C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Sep 2021 19:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhINR5r (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Sep 2021 13:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229617AbhINR5r (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Sep 2021 13:57:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A002860FED;
        Tue, 14 Sep 2021 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631642189;
        bh=FUgtlBLWyFRID8ToWCNWzOoRplAIHq4T/+tM3YN4HX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H0YbxapIJl1IFk1UA9oHiymBBucKlTmg97i2ok/tT20btjWIgUYmCPoGGiMsl8S7Y
         +lBvC52luAAQgAbHrsUv9wNMGDJkvCyo4L9CwRthiKoCP24NFOJ/zIVwnAZy/KT3Sl
         c5/5WVaQiMFK9g+1BMegbZdkFWFQwWOCBCc886qUFHJCxCZRRNv5Le/fdd5eMrH/zR
         aSpAhHf62px6gxxIwN+z9SmLyEEyMB9hXIHsFHO8ZuFVY6TamIol8uAT5gLQ0QePfR
         ibokFf/qGJ4qpMuITHaPGYZqNA2C/39+P9Y9ghvqxSJD/ScaUVOgBSo6m2uHFr4616
         8XOveadKithtw==
Date:   Tue, 14 Sep 2021 10:56:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v6 2/3] btrfs: initial fsverity support
Message-ID: <YUDiTFvaVZ4INJOO@sol.localdomain>
References: <cover.1625083099.git.boris@bur.io>
 <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
 <YUDcy73zXVPneImG@sol.localdomain>
 <YUDgmgq1Q5l5e/K4@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUDgmgq1Q5l5e/K4@zen>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Sep 14, 2021 at 10:49:33AM -0700, Boris Burkov wrote:
> On Tue, Sep 14, 2021 at 10:32:59AM -0700, Eric Biggers wrote:
> > Hi Boris,
> > 
> > On Wed, Jun 30, 2021 at 01:01:49PM -0700, Boris Burkov wrote:
> > > Add support for fsverity in btrfs. To support the generic interface in
> > > fs/verity, we add two new item types in the fs tree for inodes with
> > > verity enabled. One stores the per-file verity descriptor and btrfs
> > > verity item and the other stores the Merkle tree data itself.
> > > 
> > > Verity checking is done in end_page_read just before a page is marked
> > > uptodate. This naturally handles a variety of edge cases like holes,
> > > preallocated extents, and inline extents. Some care needs to be taken to
> > > not try to verity pages past the end of the file, which are accessed by
> > > the generic buffered file reading code under some circumstances like
> > > reading to the end of the last page and trying to read again. Direct IO
> > > on a verity file falls back to buffered reads.
> > > 
> > > Verity relies on PageChecked for the Merkle tree data itself to avoid
> > > re-walking up shared paths in the tree. For this reason, we need to
> > > cache the Merkle tree data. Since the file is immutable after verity is
> > > turned on, we can cache it at an index past EOF.
> > > 
> > > Use the new inode ro_flags to store verity on the inode item, so that we
> > > can enable verity on a file, then rollback to an older kernel and still
> > > mount the file system and read the file. Since we can't safely write the
> > > file anymore without ruining the invariants of the Merkle tree, we mark
> > > a ro_compat flag on the file system when a file has verity enabled.
> > 
> > I want to mention the btrfs verity support in
> > Documentation/filesystems/fsverity.rst, and I have a couple questions:
> > 
> > 1. Is the ro_compat filesystem flag still a thing?  The commit message claims it
> >    is, and BTRFS_FEATURE_COMPAT_RO_VERITY is defined in the code, but it doesn't
> >    seem to actually be used.  It's not needed since you found a way to make the
> >    inode flags ro_compat instead, right?
> 
> I believe it is still being used, unless I messed up the patch I sent in
> the end. Taking a quick look, I think it's set at fs/btrfs/verity.c:558.
> 
> btrfs_set_fs_compat_ro(root->fs_info, VERITY);
> 
> I believe I still needed it because the tree checker doesn't scan every
> inode on the filesystem when you mount, so it would only freak out about
> a ro-compat inode later on if the inode didn't happen to be in a leaf
> that was being checked at mount time.
> 

Okay, so it is used.  (Due to the macro, it didn't show up when grepping.)

Doesn't it defeat the purpose of a ro_compat inode flag if the whole filesystem
is marked with a ro_compat feature flag, though?  I thought that the point of
the ro_compat inode flag is to allow old kernels to mount the filesystem
read-write, with only verity files being forced to read-only.  That would be
more flexible than ext4's implementation of fs-verity which forces the whole
filesystem to read-only.  But it seems you're forcing the whole filesystem to
read-only anyway?

- Eric
