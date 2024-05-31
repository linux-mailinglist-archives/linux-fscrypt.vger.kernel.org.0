Return-Path: <linux-fscrypt+bounces-292-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB2808D58E6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 05:11:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2410D1C20A5D
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 03:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFD21F947;
	Fri, 31 May 2024 03:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otUMLrqj"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB7518C3D;
	Fri, 31 May 2024 03:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717125096; cv=none; b=bwuwij2O3Tz2QJEbWWr2T8596bzhnydN8e7JF0h4K0XLFg6EbjddHDuGgnGoJEte741lJWqQ1Fv0SwT8aM6IhcDT9L7cRpwgRzBaMCHrIZKSIEV0fTElq1+khv83YpAlBUARX+vj/+MOftBRa6wtUbjVcF71JeVi34GPItaQ5ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717125096; c=relaxed/simple;
	bh=Y3rDHfj4ytNr0Yy5PJyPY1YbT/xtcVqs+Z5VurpLPFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K0d0nsdK3JWaRYUQGPe3wGhyUJpJnJkrOIoMnlvANxKWi1vZ8Qy1fWXFHn1oBWtBuLfz1RimNkdXljJ9b+nkJBADVjIJBgnFIT8hZAoLl1xfS7Bi7vI++mHOa9LTizm9D77w8DL4h6IDlfwUqODoLAvmHR2aazOeC0T6OK8f+BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otUMLrqj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4E2C2BBFC;
	Fri, 31 May 2024 03:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717125096;
	bh=Y3rDHfj4ytNr0Yy5PJyPY1YbT/xtcVqs+Z5VurpLPFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=otUMLrqju/Q0IKp4lhcfvw0DSy6NYFVxKjvNs4reoBZnO9B7r2QgAOXvS7ktjLtQ2
	 UyKQD3xKhz/BapVupr5ivnEhShcEIossboou3rcDL01AvIMGQNXkQHr06NDhD4KnZ2
	 0aFibBZcv7974rAqpAOUkQgEGlmPkc9GZ2g4Tr5NXmDdJvqXKAPcGFo1cotumzri+t
	 vGlrnTFmyBZlIgLI8wL6QF9UUwHGxH4DMnsuWhExMVtCGzBMExk3hTkqYD91OFt0pY
	 JI/oyLEg3AJJPmYv8g4AwZQG2UYwdBMGrBUORgQlyf3yR9an45dQt4A0Q/uQuoQZbe
	 nTMzn8QSPGdnQ==
Date: Thu, 30 May 2024 20:11:33 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
	jaegeuk@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Subject: Re: [PATCH V2] ext4: add casefolded feature check before setup
 encrypted info
Message-ID: <20240531031133.GA6505@sol.localdomain>
References: <20240531010513.GA9629@sol.localdomain>
 <20240531030740.1024475-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531030740.1024475-1-lizhi.xu@windriver.com>

On Fri, May 31, 2024 at 11:07:40AM +0800, 'Lizhi Xu' via syzkaller-bugs wrote:
> Due to the current file system not supporting the casefolded feature, only 
> i_crypt_info was initialized when creating encrypted information, without actually
> setting the sighash. Therefore, when creating an inode, if the system does not 
> support the casefolded feature, encrypted information will not be created.
> 
> Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
>  fs/ext4/ialloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index e9bbb1da2d0a..47b75589fdf4 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -983,7 +983,8 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
>  		ei->i_projid = make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
>  
>  	if (!(i_flags & EXT4_EA_INODE_FL)) {
> -		err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
> +		if (ext4_has_feature_casefold(inode->i_sb))
> +			err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
>  		if (err)
>  			goto out;

No, this is not correct at all.  This just disables encryption on filesystems
with the casefold feature.

As I said before, please also use the correct mailing lists.

- Eric

