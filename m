Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0460A40CEA5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Sep 2021 23:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhIOVOS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Sep 2021 17:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232828AbhIOVN6 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Sep 2021 17:13:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23D4D60F8F;
        Wed, 15 Sep 2021 21:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631740359;
        bh=YNcxMRFOgZ9mAzLCRcBF1cwPKsTiCDe0hFTBZlODcAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CvREfN8OABPz+edeyulpG8f6E3ytL+F0jUgvbPZw7XPxv86xcufpjXzE7vrgemdpO
         a/W/UYHXEKIAiydeGBKIN3V3WUBjeKOEgiVT0OIC2k+siYihB27zjAlcuiFYWqsBkL
         ID3yBFWeAc29+qWv0ZM4TKsPoLeD7yW/o/LNa7f0edTRiIe8C7iQho36F04sbUXlxc
         Ar9/n1v2BpVsH4FPK8T++Xe+vEaJZE1sEc+OGAxiysaLLNgWB+kB0ONIUpn61JQmiU
         uIesitATzkg9PuMM8ma2IxVdBET35XATBSXLeHgY5TMmpcr3ZUjXcm3xxcs4XbfIiM
         OSumOrkxi+LNA==
Date:   Wed, 15 Sep 2021 14:12:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v6 2/3] btrfs: initial fsverity support
Message-ID: <YUJhxbRGLAQa5LIW@sol.localdomain>
References: <cover.1625083099.git.boris@bur.io>
 <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
 <YUDcy73zXVPneImG@sol.localdomain>
 <YUDgmgq1Q5l5e/K4@zen>
 <YUDiTFvaVZ4INJOO@sol.localdomain>
 <YUDrNR+72WMno10q@zen>
 <YUJbYyVZr543cfg0@sol.localdomain>
 <YUJfCbek5zy9f8YV@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUJfCbek5zy9f8YV@zen>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Sep 15, 2021 at 02:01:12PM -0700, Boris Burkov wrote:
> On Wed, Sep 15, 2021 at 01:45:23PM -0700, Eric Biggers wrote:
> > On Tue, Sep 14, 2021 at 11:34:29AM -0700, Boris Burkov wrote:
> > > > Okay, so it is used.  (Due to the macro, it didn't show up when grepping.)
> > > > 
> > > > Doesn't it defeat the purpose of a ro_compat inode flag if the whole filesystem
> > > > is marked with a ro_compat feature flag, though?  I thought that the point of
> > > > the ro_compat inode flag is to allow old kernels to mount the filesystem
> > > > read-write, with only verity files being forced to read-only.  That would be
> > > > more flexible than ext4's implementation of fs-verity which forces the whole
> > > > filesystem to read-only.  But it seems you're forcing the whole filesystem to
> > > > read-only anyway?
> > > > 
> > > > - Eric
> > > 
> > > I was thinking of it in terms of "RO compat is the goal" and having new
> > > inode flags totally broke that and was treated as a corruption of the
> > > inode regardless of the fs being ro/rw. I think a check on a live fs
> > > would just flip the fs ro, which was the goal anyway, but a check that
> > > happened during mount would fail the mount, even for a read-only fs. 
> > > 
> > > Making it fully per file would be pretty cool! The only thing
> > > really missing as far as I can tell is a way to mark a file read only
> > > with the same semantics fsverity uses from within btrfs.
> > 
> > I don't understand.  Why are you bothering with the ro_compat inode flag at all
> > if it doesn't actually work?
> > 
> > - Eric
> 
> Sorry I explained that really badly.
> 
> My first try was ro-compat bit only, that failed because btrfs couldn't
> add an inode flag in a ro-compat way before my changes, as it could
> fail to mount.
> 
> To fix that, I had to work on the inode flag compatibility, which
> evolved into this notion of inode ro-compat flags, which does work as
> expected: if you see a file with an unknown ro-compat flag it's an error
> if you aren't read-only. Read-only mount will never fail.
> 
> I think changing the semantics of the ro-compat inodes from:
> "an unknown ro inode flag -> fs ro" to
> "an unknown ro inode flag -> file ro"
> could be a big win. I don't think there is a rush to do that, though?

If you're forcing the filesystem to read-only anyway, why not just rely on the
filesystem-wide ro_compat flag, which you already implemented and which already
does that?  What benefit does the per-file ro_compat flag have, if it doesn't
actually make just the file read-only (which would be the expected behavior)?
You might as well just use a "regular" inode flag in that case.

- Eric
