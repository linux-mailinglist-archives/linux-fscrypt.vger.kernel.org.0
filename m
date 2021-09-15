Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3620440D015
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Sep 2021 01:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhIOXQW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Sep 2021 19:16:22 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:47239 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232882AbhIOXQU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Sep 2021 19:16:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id B47383200A52;
        Wed, 15 Sep 2021 19:14:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Sep 2021 19:15:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Wm4+CBAe4/4e6Yuyg/7NJvRDspi
        yrShVFWj4jSF8rMs=; b=NRmtLSxnlEDn8mTb2rSdPXgsgwg2wldVfpp9/xJC8eZ
        JVUvQIudKmDj4BV5W4nGAkAsYXI6Cd2H+v0EwiyEK3iObDE5wRtrjM6Tr/SfTfqt
        pRInYIOLa4Zx5UeDP2iZV+cOp+I7RILrPahTlgTXG7SCx0Q4p2prQAhKRJ2jU4sv
        E49ymNaJuGaUaEhRkBKpfOJAf0CrJRY2lUZY7wl4pR2ifo/Nu2m1UHl6rPSW9oj8
        FP5OvuoonJ7cT0pecX8JBzORQNCs/xx4TxQFk/7x0R2F1ak3iOlB2DjPvsxPe/Cb
        rX/vaHtUJ7cKpEZdQvBxDPOszNHm+xQToaqSmvWyj6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Wm4+CB
        Ae4/4e6Yuyg/7NJvRDspiyrShVFWj4jSF8rMs=; b=Ldki4FhnkD2fowUgR8/mkf
        LqbIhrLVemvr4EHIsu9KopAoHhvARzcM30h5Vv4l9ydItdFX6IPF05qwYa213s8O
        6+w9U+jYRCXeZoxEXjas39OwXaVVBYSrpdy5X+4q7PN/hWt3fbmgb20kisiuN8u9
        Oo178/gCj1rqXHvOniCQep4KfHuQcL4GYh9LF0o+sX07rM1AcBArnbVsmGizMMnd
        3JUBmRa9ytriVUnSjDjzFTAtNN6ka8yY7cHe1m5VSkHd8Hsfcg/72nZ3kmQTf1ek
        O7f663cDCpeCcMwO80gbGUmTWXYWrhsTeAMLdy1zGEb/G1y7KUV4kzuMP2rvd5LQ
        ==
X-ME-Sender: <xms:c35CYb_LmaME6HEi3r22BT586wodc40LDhxEGbKJ__S681M15A6koQ>
    <xme:c35CYXt2k5PyYCjFz0cdNLIQn1qITobpGkK3DcjToXkoU2eMvjLcM9JYP-bhM2qnz
    5Oc_sAR5KG39VQjpoQ>
X-ME-Received: <xmr:c35CYZBMAC181UmZM1JJ_mvwmokxP4NXUBdKWo62as2EWXFLT1SuGirDLRGzcEel7YI5lYX6yY6AcTa_Y9LQARYX0I_WRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehfedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhephe
    duveelkeeiteelveeiuefhudehtdeigfehkeeffeegledvueevgefgudeuveefnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihho
X-ME-Proxy: <xmx:c35CYXdljSfB67XA4fePk2aFN67NeXk_G2oNErPlEvEv2FFpw7R_oQ>
    <xmx:c35CYQPiVNiOaWnShoKmclAof97oUH7BiKFaq_u5dSHAD7_1bZ1uBQ>
    <xmx:c35CYZmJ3dQGn_UYNHp31AbxLYusp2_OCjirj1kxDMbjk9hysHt4JQ>
    <xmx:c35CYZYMi99cZE5oG_ZQX-FDxkI3cD1KobHwHtE1NExEbcMST_X9Jw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 19:14:58 -0400 (EDT)
Date:   Wed, 15 Sep 2021 16:14:57 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v6 2/3] btrfs: initial fsverity support
Message-ID: <YUJ+cVfWUXefucJ/@zen>
References: <cover.1625083099.git.boris@bur.io>
 <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
 <YUDcy73zXVPneImG@sol.localdomain>
 <YUDgmgq1Q5l5e/K4@zen>
 <YUDiTFvaVZ4INJOO@sol.localdomain>
 <YUDrNR+72WMno10q@zen>
 <YUJbYyVZr543cfg0@sol.localdomain>
 <YUJfCbek5zy9f8YV@zen>
 <YUJhxbRGLAQa5LIW@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUJhxbRGLAQa5LIW@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Sep 15, 2021 at 02:12:37PM -0700, Eric Biggers wrote:
> On Wed, Sep 15, 2021 at 02:01:12PM -0700, Boris Burkov wrote:
> > On Wed, Sep 15, 2021 at 01:45:23PM -0700, Eric Biggers wrote:
> > > On Tue, Sep 14, 2021 at 11:34:29AM -0700, Boris Burkov wrote:
> > > > > Okay, so it is used.  (Due to the macro, it didn't show up when grepping.)
> > > > > 
> > > > > Doesn't it defeat the purpose of a ro_compat inode flag if the whole filesystem
> > > > > is marked with a ro_compat feature flag, though?  I thought that the point of
> > > > > the ro_compat inode flag is to allow old kernels to mount the filesystem
> > > > > read-write, with only verity files being forced to read-only.  That would be
> > > > > more flexible than ext4's implementation of fs-verity which forces the whole
> > > > > filesystem to read-only.  But it seems you're forcing the whole filesystem to
> > > > > read-only anyway?
> > > > > 
> > > > > - Eric
> > > > 
> > > > I was thinking of it in terms of "RO compat is the goal" and having new
> > > > inode flags totally broke that and was treated as a corruption of the
> > > > inode regardless of the fs being ro/rw. I think a check on a live fs
> > > > would just flip the fs ro, which was the goal anyway, but a check that
> > > > happened during mount would fail the mount, even for a read-only fs. 
> > > > 
> > > > Making it fully per file would be pretty cool! The only thing
> > > > really missing as far as I can tell is a way to mark a file read only
> > > > with the same semantics fsverity uses from within btrfs.
> > > 
> > > I don't understand.  Why are you bothering with the ro_compat inode flag at all
> > > if it doesn't actually work?
> > > 
> > > - Eric
> > 
> > Sorry I explained that really badly.
> > 
> > My first try was ro-compat bit only, that failed because btrfs couldn't
> > add an inode flag in a ro-compat way before my changes, as it could
> > fail to mount.
> > 
> > To fix that, I had to work on the inode flag compatibility, which
> > evolved into this notion of inode ro-compat flags, which does work as
> > expected: if you see a file with an unknown ro-compat flag it's an error
> > if you aren't read-only. Read-only mount will never fail.
> > 
> > I think changing the semantics of the ro-compat inodes from:
> > "an unknown ro inode flag -> fs ro" to
> > "an unknown ro inode flag -> file ro"
> > could be a big win. I don't think there is a rush to do that, though?
> 
> If you're forcing the filesystem to read-only anyway, why not just rely on the
> filesystem-wide ro_compat flag, which you already implemented and which already
> does that?  What benefit does the per-file ro_compat flag have, if it doesn't
> actually make just the file read-only (which would be the expected behavior)?
> You might as well just use a "regular" inode flag in that case.
> 
> - Eric

I couldn't use a regular inode flag because the btrfs tree checker will
call it an error when it sees a flag it doesn't recognize, regardless of
compat bits or fs read-only status. This is extra painful if the inode
with verity enabled is in a leaf that gets read in at mount time and
gets checked then.

a fake example of what was happening:

mkfs.btrfs dev
mount dev mnt
touch /mnt/foo
fsverity enable /mnt/foo
<reboot to old kernel>
mount dev mnt
!!!FAIL!!!
mount -o ro dev mnt
!!!FAIL!!!

To get around this, I added a new flag field that wasn't checked as
aggressively -- and didn't call it an error on ro mount.

There is more excruciating detail, that I won't poorly re-create here,
in the commit message of:
"btrfs: add ro compat flags to inodes"

However, I really do agree that having done the work to add the new
class of flags, it makes sense to try to take advantage of it the way
you suggest, since per-file ro compat sounds a lot cooler than fs ro
compat. I was just trying to do what I could to make the fs compat bit
work at all.
