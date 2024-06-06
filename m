Return-Path: <linux-fscrypt+bounces-307-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 535F48FDEAF
	for <lists+linux-fscrypt@lfdr.de>; Thu,  6 Jun 2024 08:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF04F285C00
	for <lists+linux-fscrypt@lfdr.de>; Thu,  6 Jun 2024 06:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E18486D1B9;
	Thu,  6 Jun 2024 06:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMAxBSoY"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD0D2E3E5;
	Thu,  6 Jun 2024 06:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717655225; cv=none; b=M2F7O0duzuxWRUZSHKSr5xeURBOnQ4v1DZWuWLqtXHkKaGjxw46PNxpzSQnBKOJL80Wt0hb23b3aj1xap+E3NYUvA9fhJ6+Q8y5zJX0BOXNyOs5JAnKdg0ymae642HrE+jRngz++JTmsZEXpU41RBzPvxR+BdAH0vChHE+zHznQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717655225; c=relaxed/simple;
	bh=8sTAUFN6ttVGBTSIkP0SK1wk1W07q2GV6zvcwY4KfEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hk+d+yd8PSr6Nu+wIs/iU8loloFlKwiANLUyN90K23/HW1N/qKR8g44rssy/jY2Eu9LBwpqaMMwBbbYHlbbpMdF8Qh2WdIbStIJMZQ4ZU7Ea9DVW4H4Jioj2vh2GCRNuI/Dc+6LcepoyxSugm9u7Ema1C/RJtJPN/brJ4i7tI1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMAxBSoY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C0CC3277B;
	Thu,  6 Jun 2024 06:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717655225;
	bh=8sTAUFN6ttVGBTSIkP0SK1wk1W07q2GV6zvcwY4KfEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hMAxBSoYXBBoBY0kVL+6E1ZIwPc9R2E8g8BsWNAew0O67OH1Vdfh0MAJKtvwQwKuY
	 nwJODBJ9IxbpJEQr0wK6EIyTyWnwCTxRpVcdqylsNxRCpLIfGH7StnLAJIqnYYZDzB
	 MBgLOBBcKP4SjkHeLLJ2pvLXMrLzkUVR+Qu1kvpSVLjUZFxhsISQ/DfQS/Q2VOG0fd
	 PjKalyhJ2coX1fOqJ7WIOV6BDMC0RjA8XZrCBSAraTf7amjb6RUHNqHUGxV48bGDCd
	 TRj5iBRl8H0L69Et80wLxSWBzJZuROt3WysTC9Ek7qo83gVulHqKHzvKxaOLjbnZWB
	 VT7gFRRky73QA==
Date: Wed, 5 Jun 2024 23:27:02 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: Lizhi Xu <lizhi.xu@windriver.com>, adilger.kernel@dilger.ca,
	coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
	jaegeuk@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, lkp@intel.com, llvm@lists.linux.dev,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev, pablo@netfilter.org,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Subject: Re: [PATCH V5] ext4: check hash version and filesystem casefolded
 consistent
Message-ID: <20240606062702.GB324380@sol.localdomain>
References: <87plsym65w.fsf@mailhost.krisman.be>
 <20240604011718.3360272-1-lizhi.xu@windriver.com>
 <87le3kle87.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87le3kle87.fsf@mailhost.krisman.be>

On Tue, Jun 04, 2024 at 03:06:32PM -0400, Gabriel Krisman Bertazi wrote:
> Lizhi Xu <lizhi.xu@windriver.com> writes:
> 
> > On Mon, 03 Jun 2024 10:50:51 -0400, Gabriel Krisman Bertazi wrote:
> >> > When mounting the ext4 filesystem, if the hash version and casefolded are not
> >> > consistent, exit the mounting.
> >> >
> >> > Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
> >> > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> >> > ---
> >> >  fs/ext4/super.c | 5 +++++
> >> >  1 file changed, 5 insertions(+)
> >> >
> >> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> >> > index c682fb927b64..0ad326504c50 100644
> >> > --- a/fs/ext4/super.c
> >> > +++ b/fs/ext4/super.c
> >> > @@ -5262,6 +5262,11 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
> >> >  		goto failed_mount;
> >> >  
> >> >  	ext4_hash_info_init(sb);
> >> > +	if (es->s_def_hash_version == DX_HASH_SIPHASH && 
> >> > +	    !ext4_has_feature_casefold(sb)) {
> >> 
> >> Can we ever have DX_HASH_SIPHASH set up in the super block?  I thought
> >> it was used solely for directories where ext4_hash_in_dirent(inode) is
> >> true.
> > The value of s'def_hash_version is obtained by reading the super block from the
> > buffer cache of the block device in ext4_load_super().
> 
> Yes, I know.  My point is whether this check should just be:
> 
> if (es->s_def_hash_version == DX_HASH_SIPHASH)
> 	goto failed_mount;
> 
> Since, IIUC, DX_HASH_SIPHASH is done per-directory and not written to
> the sb.
> 

That seems right to me.  SipHash can never be the default because it's only used
on directories that are both encrypted and casefolded.

- Eric

