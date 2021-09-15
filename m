Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8403140CE61
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Sep 2021 22:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhIOUqq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Sep 2021 16:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231703AbhIOUqq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Sep 2021 16:46:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3570260E08;
        Wed, 15 Sep 2021 20:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631738725;
        bh=Zp08hMDWhVy5cOJ2+ev8aGbNZ7wp41TNwsGBQ31uLLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qIei9DzJlY6WFaNfCfOXlbt4yNCLMVJfy6JnnPR85MRFmTh0qWvD2xNE9bddGHueI
         hHtDpqnkzf/+dE2uTllwjx3hT+nxMxjH4TWAhUeir2Vlzzpq0ugVW0QTY0Ze0eRAlm
         v31w1OmoMz5JkD2iy6fwyTmUbJZmxS1/kNPEXL/uJZHFuIciURSKqVflrEBj2/5lD1
         sJuphM/jcoAu7j1rvwtia7wy0daC427BEP1RHHXxgZgYVh6oarKZawf7sF/ytuzTj4
         uF3aOs0hyJjh6DCj+LcYq68Xl9M6eOmb5TLYsq0G/prOh9Fy/39fz5MDSsF1ZGzqSy
         y7kY9J/Ut1Q/Q==
Date:   Wed, 15 Sep 2021 13:45:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v6 2/3] btrfs: initial fsverity support
Message-ID: <YUJbYyVZr543cfg0@sol.localdomain>
References: <cover.1625083099.git.boris@bur.io>
 <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
 <YUDcy73zXVPneImG@sol.localdomain>
 <YUDgmgq1Q5l5e/K4@zen>
 <YUDiTFvaVZ4INJOO@sol.localdomain>
 <YUDrNR+72WMno10q@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUDrNR+72WMno10q@zen>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Sep 14, 2021 at 11:34:29AM -0700, Boris Burkov wrote:
> > Okay, so it is used.  (Due to the macro, it didn't show up when grepping.)
> > 
> > Doesn't it defeat the purpose of a ro_compat inode flag if the whole filesystem
> > is marked with a ro_compat feature flag, though?  I thought that the point of
> > the ro_compat inode flag is to allow old kernels to mount the filesystem
> > read-write, with only verity files being forced to read-only.  That would be
> > more flexible than ext4's implementation of fs-verity which forces the whole
> > filesystem to read-only.  But it seems you're forcing the whole filesystem to
> > read-only anyway?
> > 
> > - Eric
> 
> I was thinking of it in terms of "RO compat is the goal" and having new
> inode flags totally broke that and was treated as a corruption of the
> inode regardless of the fs being ro/rw. I think a check on a live fs
> would just flip the fs ro, which was the goal anyway, but a check that
> happened during mount would fail the mount, even for a read-only fs. 
> 
> Making it fully per file would be pretty cool! The only thing
> really missing as far as I can tell is a way to mark a file read only
> with the same semantics fsverity uses from within btrfs.

I don't understand.  Why are you bothering with the ro_compat inode flag at all
if it doesn't actually work?

- Eric
