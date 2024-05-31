Return-Path: <linux-fscrypt+bounces-290-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F13518D5894
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 04:20:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8CDFCB234CA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 02:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A640745FD;
	Fri, 31 May 2024 02:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AYC6kPFD"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0852A4C6D;
	Fri, 31 May 2024 02:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717122053; cv=none; b=qJN6LtxxE6xEde2u3fWcV4o+nC+y1UwXWReNiYSrJWfbh5C/if6yhVSk6f5qq1jmyeOe/gGLBlIF8ZOTXAndpgojI0tbcd0gxghHGow6srpyJT5M7Ndr9ncvSaaS1/6xwVuVYJR1bi9x33pClGOJd2EwYJ0INAxdIAxqbkN6Hzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717122053; c=relaxed/simple;
	bh=b5G/xzCKKv13+PNvSDpcSoc6cOLXomTBBZTbM3WNl+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BMzdU36xnguHz19KBSNUPL6f/7K0BugDCo/a57c27SOqc2ykg2dpQGfXjUKPMXC7OSUtBodwS5xf2CyMC6a7ZY5V0vRu+cSDCO6LLOvfPVQgioHW+/I9p75Fudj3gzUO8PlWqAcqCQwTQ38EkylQZLCLWY7LKbMweq1YrR/IMTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AYC6kPFD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028B2C2BBFC;
	Fri, 31 May 2024 02:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717122052;
	bh=b5G/xzCKKv13+PNvSDpcSoc6cOLXomTBBZTbM3WNl+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AYC6kPFDmbrWlFSPd9ew7nngeX7vNnr7ubo6m9b2OyqpSVvNr9Q8uOXF8czbmW329
	 hAMZAcC4V57o7n/GKhiLNhD6YeGftel6CgNbC9WQctIo0hrmBGfQuHjIWWzmsAmlvb
	 JnaxB7ChCJyWD8KJo6Wn7BnKMdiBznYh4hKn6gjWpyU7R9JYYwYQA3a6N4VRSZT268
	 wDAWVRGuUaqLVlfNCd9QEI/q0r/+8/3Xf23cYFxgVBkAxZUCUe/yue9txfFzQ/fr4K
	 hVFb4of589BAsJUL6hVkvmusxUoILUcdQYNjKrsziUWjldRgk0RMdSIjwVc3hG1bhe
	 U+MvwDYRDWjYg==
Date: Thu, 30 May 2024 19:20:50 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
	jaegeuk@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Subject: Re: [PATCH] ext4: add casefolded file check
Message-ID: <20240531022050.GB1502@sol.localdomain>
References: <20240531010513.GA9629@sol.localdomain>
 <20240531014747.1386219-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531014747.1386219-1-lizhi.xu@windriver.com>

On Fri, May 31, 2024 at 09:47:47AM +0800, 'Lizhi Xu' via syzkaller-bugs wrote:
> On Thu, 30 May 2024 18:05:13 -0700, Eric Biggers wrote:
> > > The file name that needs to calculate the siphash must have both flags casefolded
> > > and dir at the same time, so before calculating it, confirm that the flag meets
> > > the conditions.
> > >
> > > Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
> > > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> > > ---
> > >  fs/ext4/hash.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
> > > index deabe29da7fb..c8840cfc01dd 100644
> > > --- a/fs/ext4/hash.c
> > > +++ b/fs/ext4/hash.c
> > > @@ -265,6 +265,10 @@ static int __ext4fs_dirhash(const struct inode *dir, const char *name, int len,
> > >  		__u64	combined_hash;
> > >
> > >  		if (fscrypt_has_encryption_key(dir)) {
> > > +			if (!IS_CASEFOLDED(dir)) {
> > > +				ext4_warning_inode(dir, "Siphash requires Casefolded file");
> > > +				return -2;
> > > +			}
> > >  			combined_hash = fscrypt_fname_siphash(dir, &qname);
> > >  		} else {
> > >  			ext4_warning_inode(dir, "Siphash requires key");
> > 
> > First, this needs to be sent to the ext4 mailing list (and not to irrelevant
> > mailing lists such as netdev).  Please use ./scripts/get_maintainer.pl, as is
> > recommended by Documentation/process/submitting-patches.rst.
> > 
> > Second, ext4 already checks for the directory being casefolded before allowing
> > siphash.  This is done by dx_probe().  Evidently syzbot found some way around
> > that, so what needs to be done is figure out why that happened and what is the
> > best fix to prevent it.  This is not necessarily the patch you've proposed, as
> > the real issue might actually be a missing check at some earlier time like when
> > reading the inode from disk or when mounting the filesystem.
> I have confirmed that there is no casefolded feature when creating the directory.
> I agree with your statement that it should be checked for casefold features when
> mounting or reading from disk.
> 

I haven't looked at the syzbot reproducer, but I'm guessing that the
DX_HASH_SIPHASH is coming from s_def_hash_version in the filesystem superblock.
It's not valid to have DX_HASH_SIPHASH there, and it probably would make more
sense to validate that at mount time.

- Eric

