Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EB740CE7F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Sep 2021 23:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhIOVCf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Sep 2021 17:02:35 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:41301 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231935AbhIOVCe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Sep 2021 17:02:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 6B258320016F;
        Wed, 15 Sep 2021 17:01:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 15 Sep 2021 17:01:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=B9hNQyyzxdceIBauQTozeJhwUy+
        7txOmGUWJI6Gsinw=; b=iRoPrmToV+oPT+KhO4FYOosWGHWu11HWs9njuqiHh1p
        NkydpYPUsrS9NGeafu3jPhcIU913nU1m6rTqG3sUSHH1ZEPp46gvzqyCRbrDa7gj
        97cUPk5BAeCDah2YUzSltTnCjvEeUtii8RQfLd1BVfg972Jrwla18yScJ/qZxsR9
        4B5Nu7TyoiMmTsfDCMQNMJMO5iMVqYnIhqsz293nSC3Wl19pc23B7ir+KnLpDAu1
        NTBRro1BJmw2Tski3nJ34jjuA8eKxWH3iy7AuhweRXKUJ/roGBOKfQy9XVDJ+Sb6
        UalWtgnxfHNKxL1TjVhY3o9imvNWGwKXVeaInqnaopg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=B9hNQy
        yzxdceIBauQTozeJhwUy+7txOmGUWJI6Gsinw=; b=W/ToAJDkgUg9mBIulMdoT2
        Frt1fDO/Zo6gqDF/jJLEQV59SDhLpHBsfpyPfkiYMI+K7scPQDZE38jjLkl4RsvL
        2TrSoLZwYMeXaTa8GxFobB4Y1UB8ry4r10G0ONPs49EsMruQ7tMuIwJs26KGWj3n
        GpvXR0rYAF314xbX1l3qgwvEk7xpNc5GhnJtZGdBAd5UMI3yAAiYItbRuJ81JUDs
        VZCFmwm5L67wIkIkMuMr4YA+QuAYwoZzMGN9R86LBovKgFXlO9V4ddGkhnqQg3+d
        ve9dx8QrtObT5Aqxs52eJrboGNL5V/mMt5rka7s/0g9/6NqTWuMvsevPpiGs6T2w
        ==
X-ME-Sender: <xms:GV9CYXCI8_B8oec2Go66N3F0pg0voPCKfUHA981TuuS7Zamh-uDnog>
    <xme:GV9CYdjTe5PEfRKeCng6d5gMEb2Ri0mPAnxzUrsmt1pSZ4hMM3N4-zZf1qY-SMuHT
    Xz9aG9DoC_UMbx_LUU>
X-ME-Received: <xmr:GV9CYSmbjZ67-bsqEF85vlKyoeNHf7pZ6NR-OrFEZ7wAI9Zfm1zMBcAl6RWtdP4sFCuArmqWuUtMTESM6sYbz05PV_ZzxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehvddgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhephe
    duveelkeeiteelveeiuefhudehtdeigfehkeeffeegledvueevgefgudeuveefnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihho
X-ME-Proxy: <xmx:GV9CYZxSYZjzxJVkuYaCHH1pgT2ugTTmZ5PVmsi5X5L6s0MtvQPC_w>
    <xmx:GV9CYcQYvP0sbUDzRvbOuxGFzp3lo8raL8p6O6ZFTCZ9vF-2-jnwiQ>
    <xmx:GV9CYcY_7VRSerPCkg-AWka7SNXDIJdhrANK0nTnuV19NDqB02nX-A>
    <xmx:Gl9CYXf6v5XBBRdnIALSAYC00L3Z7UEgICjIGyrFX-18qh6iIDUtbQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 17:01:13 -0400 (EDT)
Date:   Wed, 15 Sep 2021 14:01:12 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v6 2/3] btrfs: initial fsverity support
Message-ID: <YUJfCbek5zy9f8YV@zen>
References: <cover.1625083099.git.boris@bur.io>
 <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
 <YUDcy73zXVPneImG@sol.localdomain>
 <YUDgmgq1Q5l5e/K4@zen>
 <YUDiTFvaVZ4INJOO@sol.localdomain>
 <YUDrNR+72WMno10q@zen>
 <YUJbYyVZr543cfg0@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUJbYyVZr543cfg0@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Sep 15, 2021 at 01:45:23PM -0700, Eric Biggers wrote:
> On Tue, Sep 14, 2021 at 11:34:29AM -0700, Boris Burkov wrote:
> > > Okay, so it is used.  (Due to the macro, it didn't show up when grepping.)
> > > 
> > > Doesn't it defeat the purpose of a ro_compat inode flag if the whole filesystem
> > > is marked with a ro_compat feature flag, though?  I thought that the point of
> > > the ro_compat inode flag is to allow old kernels to mount the filesystem
> > > read-write, with only verity files being forced to read-only.  That would be
> > > more flexible than ext4's implementation of fs-verity which forces the whole
> > > filesystem to read-only.  But it seems you're forcing the whole filesystem to
> > > read-only anyway?
> > > 
> > > - Eric
> > 
> > I was thinking of it in terms of "RO compat is the goal" and having new
> > inode flags totally broke that and was treated as a corruption of the
> > inode regardless of the fs being ro/rw. I think a check on a live fs
> > would just flip the fs ro, which was the goal anyway, but a check that
> > happened during mount would fail the mount, even for a read-only fs. 
> > 
> > Making it fully per file would be pretty cool! The only thing
> > really missing as far as I can tell is a way to mark a file read only
> > with the same semantics fsverity uses from within btrfs.
> 
> I don't understand.  Why are you bothering with the ro_compat inode flag at all
> if it doesn't actually work?
> 
> - Eric

Sorry I explained that really badly.

My first try was ro-compat bit only, that failed because btrfs couldn't
add an inode flag in a ro-compat way before my changes, as it could
fail to mount.

To fix that, I had to work on the inode flag compatibility, which
evolved into this notion of inode ro-compat flags, which does work as
expected: if you see a file with an unknown ro-compat flag it's an error
if you aren't read-only. Read-only mount will never fail.

I think changing the semantics of the ro-compat inodes from:
"an unknown ro inode flag -> fs ro" to
"an unknown ro inode flag -> file ro"
could be a big win. I don't think there is a rush to do that, though? If
I add it now, on top of the existing code, then you might go back to a
kernel that can only mount the fs read-only or you might go back to one
which is clever enough to only force the file read-only.

Hope I'm making a bit more sense, now.
