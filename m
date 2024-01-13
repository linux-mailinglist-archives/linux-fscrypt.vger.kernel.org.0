Return-Path: <linux-fscrypt+bounces-125-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B59E82C8C7
	for <lists+linux-fscrypt@lfdr.de>; Sat, 13 Jan 2024 02:32:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F146EB21086
	for <lists+linux-fscrypt@lfdr.de>; Sat, 13 Jan 2024 01:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14D41A29C;
	Sat, 13 Jan 2024 01:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eppEFryA"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ADB1A28F
	for <linux-fscrypt@vger.kernel.org>; Sat, 13 Jan 2024 01:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E054DC433F1;
	Sat, 13 Jan 2024 01:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705109545;
	bh=zms05XbPtiWQSjgNbT4Hk4ahueRQsyvUh2ZMlMAK9bA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eppEFryAK7fJTRqr9kpAWdU67HJfntqiD6uQFgwgtiOP1qidtQdtkgzoAlyxiVr3e
	 xZWACLrS8JVCUEowEYOrDdJZyDwY6zpMbsbweTdaq1rsVbLfZCFbVJQ4n25LGQuegu
	 OP5RNYdZsw0aGUS/+K4cr7ia/4Cm6YOvY1iOvTDhoXcLlBpRzVVvdWGZSj1pxHEidp
	 mQR6f6+0DHigmwa5mraNaflqNjmqoqczfxijU50HDChgJ3rm6rQZxb+a9Yzk9PTNsW
	 8LFrzJ9Ieh8pH65wlFlojygfpTReNDMpoLPRHaUd3rL/j12ktT+DvCZoKkUSidF13T
	 G7AWn5cunNVCQ==
Date: Fri, 12 Jan 2024 17:32:23 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org,
	syzbot+8f477ac014ff5b32d81f@syzkaller.appspotmail.com
Subject: Re: [PATCH] f2fs: fix double free of f2fs_sb_info
Message-ID: <20240113013223.GA40156@sol.localdomain>
References: <20240113005031.GA1147@sol.localdomain>
 <20240113005747.38887-1-ebiggers@kernel.org>
 <20240113010118.GB1147@sol.localdomain>
 <ZaHnPyZeJPtsJQKF@google.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaHnPyZeJPtsJQKF@google.com>

On Fri, Jan 12, 2024 at 05:28:31PM -0800, Jaegeuk Kim wrote:
> On 01/12, Eric Biggers wrote:
> > On Fri, Jan 12, 2024 at 04:57:47PM -0800, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > kill_f2fs_super() is called even if f2fs_fill_super() fails.
> > > f2fs_fill_super() frees the struct f2fs_sb_info, so it must set
> > > sb->s_fs_info to NULL to prevent it from being freed again.
> > > 
> > > Fixes: 275dca4630c1 ("f2fs: move release of block devices to after kill_block_super()")
> > > Reported-by: syzbot+8f477ac014ff5b32d81f@syzkaller.appspotmail.com
> > > Closes: https://lore.kernel.org/r/0000000000006cb174060ec34502@google.com
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > 
> > Jaegeuk, I'd be glad to take this through the fscrypt tree since that's where my
> 
> Ok, are you heading to push this in -rc1?
> 
> > broken commit came from.  But let me know if you want to just take this through
> > the f2fs tree.
> > 

Yes, we should get this into -rc1.

- Eric

