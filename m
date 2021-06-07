Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2CD39E92E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  7 Jun 2021 23:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhFGVsL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Jun 2021 17:48:11 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46606 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhFGVsL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Jun 2021 17:48:11 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 79B341FD2D;
        Mon,  7 Jun 2021 21:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623102378;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T9KR/CaQBLmFkmWLty/5BG+6PviPXTRDua/BArJt1wA=;
        b=WK2w1uIr4HO3IFPNxIdWBy+d2GwqG8ansZZSkjn1yQkWDZCH5vqVbDYR2yC1ApM2Oi6KZw
        SePnevi795xWKFjNxGyOI3h30JkydCMPNPgIgarBrNGvfQZUNz/u1lwdHyypBGpJq2/C8Q
        L2Tty4sp+koKHSibE+fZ8bJIlQa1XOs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623102378;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T9KR/CaQBLmFkmWLty/5BG+6PviPXTRDua/BArJt1wA=;
        b=KewOfAotuIoXJvRbRe0twkGFrroxZzKiiHrdogk1px+mRlpA5VJOdEiQCj3eVS/rnmK+Ti
        XgbfbjjZB0ie/dBw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 55584A3BE8;
        Mon,  7 Jun 2021 21:46:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 48D1EDB228; Mon,  7 Jun 2021 23:43:35 +0200 (CEST)
Date:   Mon, 7 Jun 2021 23:43:35 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 1/5] btrfs: add compat_flags to btrfs_inode_item
Message-ID: <20210607214335.GO31483@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1620240133.git.boris@bur.io>
 <6ed83a27f88e18f295f7d661e9c87e7ec7d33428.1620241221.git.boris@bur.io>
 <20210511191108.GL7604@twin.jikos.cz>
 <20210517214859.GS7604@twin.jikos.cz>
 <YKWG86j7MpECAo+s@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKWG86j7MpECAo+s@zen>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

sorry I did not notice you replied some time ago.

On Wed, May 19, 2021 at 02:45:23PM -0700, Boris Burkov wrote:
> On Mon, May 17, 2021 at 11:48:59PM +0200, David Sterba wrote:
> > On Tue, May 11, 2021 at 09:11:08PM +0200, David Sterba wrote:
> > > On Wed, May 05, 2021 at 12:20:39PM -0700, Boris Burkov wrote:
> > > > --- a/fs/btrfs/btrfs_inode.h
> > > > +++ b/fs/btrfs/btrfs_inode.h
> > > > @@ -191,6 +191,7 @@ struct btrfs_inode {
> > > >  
> > > >  	/* flags field from the on disk inode */
> > > >  	u32 flags;
> > > > +	u64 compat_flags;
> > > 
> > > This got me curious, u32 flags is for the in-memory inode, but the
> > > on-disk inode_item::flags is u64
> > > 
> > > >  BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
> > >                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > 
> > > > +BTRFS_SETGET_FUNCS(inode_compat_flags, struct btrfs_inode_item, compat_flags, 64);
> > > 
> > > >  	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
> > > 
> > > Which means we currently use only 32 bits and half of the on-disk
> > > inode_item::flags is always zero. So the idea is to repurpose this for
> > > the incompat bits (say upper 16 bits). With a minimal patch to tree
> > > checker we can make old kernels accept a verity-enabled kernel.
> > > 
> > > It could be tricky, but for backport only additional bitmask would be
> > > added to BTRFS_INODE_FLAG_MASK to ignore bits 48-63.
> > > 
> > > For proper support the inode_item::flags can be simply used as one space
> > > where the split would be just logical, and IMO manageable.
> > 
> > To demonstrate the idea, here's a compile-tested patch, based on
> > current misc-next but the verity bits are easy to match to your
> > patchset:
> 
> Thanks for taking the time to prove this idea out. However, I'd still
> like to discuss the pros/cons of this approach for this application.
> 
> As far as I can tell, the two issues at hand are ensuring compatibility
> and using fewer of the reserved bits. Your proposal uses 0 reserved
> bits, which is great, but is still quite a headache for compatibility,
> as an administrator would have to backport the compat patch on any kernel
> they wanted to roll back to before the one this went out on.

The compatibility problems are there for any new feature and usually
it's strict no mount, while here we can do a read-only compat mode at
least. Deploying a new feature should always take the fallback mount
into account, so it's advisable to wait a few releases eg. up to the
next stable release.

Luckily in that case we can backport the compatibility to the older
stable trees so the fallback would work after a minor release.

> This is especially painful for less well-loved things like
> dracut/systemd mounting the root filesystem and doing a pivot_root during
> boot. You would have to make sure that any machine using fsverity btrfs
> files has an updated initramfs kernel or it won't be able to boot.

So I hope this would get covered by the backports, as discussed, to 5.4
and 5.10.

> Alternatively, we could have our cake and eat it too if we separate the
> idea of unlocking the top 32 bits of the inode flags from adding compat
> flags.
> 
> If we:
> 1. take a u16 or a u32 out of reserved and make it compat flags (my
> patch, but shrinking from u64)
> 2. implement something similar to your patch, but don't use those 32
> bits just yet
> 
> Then we are setup to more conveniently use the freed-up 32 bits in the
> future, as the application which wants reserved bytes then will have a
> buffer of kernel versions to trivially roll back into, which may cover
> most practical rollbacks.
> 
> For what it's worth, I do like that your proposal stuffs inode flags and
> inode compat flags together, which is certainly neater than turning the
> upper 32 of inode flags into general reserved bits. But I'm just not
> sure that the aesthetic benefit is worth the real pain now.

My motivation is not aesthetic, rather I'm very conservative when
on-disk structures get changed, and inode is the core structure.
Curiously, you can thank Josef who switched the per-inode compat flags
to whole-filesystem only in f2b636e80d8206dd40 "Btrfs: add support for
compat flags to btrfs". But that was in 2008 and was a hard incompatible
change that lead to the last major format change (the _BHRfS_M
signature).

If the incompat change can be squeezed into existing structure, it
leaves the reserved fileds untouched. Right now we have 4x u64. Any
other change requires increasing the item size which is ultimately
possible but brings other problems. So if there's a possibily not to go
to the next level, I'll pursue it. Right now the major objection is the
problem with deployment and fallback mount, but I think this is solved.

Until now I haven't found any problem with the ro compat flags merged to
normal flags on itself, so as agreed offline, we're going to do that.
