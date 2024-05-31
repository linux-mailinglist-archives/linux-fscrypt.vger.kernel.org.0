Return-Path: <linux-fscrypt+bounces-294-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 486E38D5905
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 05:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B5401C2236C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 03:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E112F17C64;
	Fri, 31 May 2024 03:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e7TPyZul"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA8117BD3;
	Fri, 31 May 2024 03:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717126450; cv=none; b=jiXCeex6GZqaISmj9LY1x090GMyL5PsldaYyzs7ZSnJaFBJ+tP75+LKO8+mPawbBOGqO4vjYszaJyLj9ZYQARSxr4IltSO2x+GP4uTY7t86NeR5egDa5KQzRhUABvmwaH7YAWOTiZuLxVmzcskUOrMTuuPm+nIqIm2HAZhljYv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717126450; c=relaxed/simple;
	bh=3u7nFs7d4HvLaGyX2AAa6u8ILfNeeM5SXxP7Y7fcTw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oPd9E5zdh/86ynK1+Ge/rWfAc3AJhCBgNJkY1lMT3Fbh+u6VULayJcyukJ0k2Tna8f1nbgDYn0FDMgtwqzVJmN9+uOyRli9ntibIs4rMsGSrs8ld/BDiimqWUXtt/bI8PziPrcG7mcYk5u2E4TVkBEXGKlG5nRZLOzGhghchJS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e7TPyZul; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CF5C116B1;
	Fri, 31 May 2024 03:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717126450;
	bh=3u7nFs7d4HvLaGyX2AAa6u8ILfNeeM5SXxP7Y7fcTw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e7TPyZulQF68qu2kcbiKP3Omea5+jtlpR9n0mHJDi04iWSEKdtKcBCajANyVJ2mNK
	 37VZJpYPbzSez15JeHPHQwQpdUZeeTGsDpw8MskX/B9wZYTOqk3DAos459wFZtGWvQ
	 yIjkujAv2BLWLfbVConC0x83t4IVfKu5okXxr0h+tT0h7ENieOgKr61UidWWuchuk0
	 BJyba+harshSeaNvbV9XIR11yTau6Aefb4TN51ZHsgKHnBbtwqDUmqYw1D0sz/4fsX
	 6osORXhEUPpFJYx3i3PeChv0jNnTUY25tFH/wMyr6EZpImcvCFlgc276i2ZuRM6iMd
	 4I/oZE1lnE3rg==
Date: Thu, 30 May 2024 20:34:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
	jaegeuk@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH V2] ext4: add casefolded feature check before setup
 encrypted info
Message-ID: <20240531033407.GB6505@sol.localdomain>
References: <20240531010513.GA9629@sol.localdomain>
 <20240531033044.1335098-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531033044.1335098-1-lizhi.xu@windriver.com>

On Fri, May 31, 2024 at 11:30:44AM +0800, 'Lizhi Xu' via syzkaller-bugs wrote:
> On Thu, 30 May 2024 20:11:33 -0700, Eric Biggers wrote:
> > > Due to the current file system not supporting the casefolded feature, only 
> > > i_crypt_info was initialized when creating encrypted information, without actually
> > > setting the sighash. Therefore, when creating an inode, if the system does not 
> > > support the casefolded feature, encrypted information will not be created.
> > > 
> > > Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
> > > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> > > ---
> > >  fs/ext4/ialloc.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> > > index e9bbb1da2d0a..47b75589fdf4 100644
> > > --- a/fs/ext4/ialloc.c
> > > +++ b/fs/ext4/ialloc.c
> > > @@ -983,7 +983,8 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
> > >  		ei->i_projid = make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
> > >  
> > >  	if (!(i_flags & EXT4_EA_INODE_FL)) {
> > > -		err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
> > > +		if (ext4_has_feature_casefold(inode->i_sb))
> > > +			err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
> > >  		if (err)
> > >  			goto out;
> > 
> > No, this is not correct at all.  This just disables encryption on filesystems
> > with the casefold feature.
> If filesystems not support casefold feature, Why do I need to setup encrypted
> information when creating a directory? Can encrypted information not include *hash?

Encryption is a separate feature.  It is supported both with and without
casefold.

- Eric

