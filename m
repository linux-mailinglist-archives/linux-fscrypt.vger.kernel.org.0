Return-Path: <linux-fscrypt+bounces-124-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 87EE382C8B6
	for <lists+linux-fscrypt@lfdr.de>; Sat, 13 Jan 2024 02:28:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2ABAEB2284E
	for <lists+linux-fscrypt@lfdr.de>; Sat, 13 Jan 2024 01:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BDA818AF1;
	Sat, 13 Jan 2024 01:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1WMRQqK"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F88D1865A
	for <linux-fscrypt@vger.kernel.org>; Sat, 13 Jan 2024 01:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0BFC433C7;
	Sat, 13 Jan 2024 01:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705109312;
	bh=SGE0qROC2eANojk01AHCid9ZzrWcrsXBwB3H/XejRT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F1WMRQqK2LK08NPGtpm5xkCmp5k3ABCWCdYWrmK7C6KEqf5psragMFvsWOXOVjdoR
	 rFzeCcyZQbKGxOqobTJBPdZJ7Q7LYDBW2hYAJ6Ks/eNoPiGy0oYHnRf9IBqSymDUYr
	 gIDpL482iIs3Zeaso9exXhk5ViSnHJnHlUqfUWHUb/lHfz7Gchtvl4Q5Ag1TUVWg7/
	 FBZ/xgTV+3RXAF736EiSJXLcpp2PwqrPehvk8m2laHdlXugCUedIIAytrlzUPBIlzZ
	 JWMz2vDEyn6AHWbCyYpPYDcMvL9v3sMKaznGV+3uXEaJjXgrovkBMbODnAgZCabmVh
	 X49DWrqaiNQ8Q==
Date: Fri, 12 Jan 2024 17:28:31 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org,
	syzbot+8f477ac014ff5b32d81f@syzkaller.appspotmail.com
Subject: Re: [PATCH] f2fs: fix double free of f2fs_sb_info
Message-ID: <ZaHnPyZeJPtsJQKF@google.com>
References: <20240113005031.GA1147@sol.localdomain>
 <20240113005747.38887-1-ebiggers@kernel.org>
 <20240113010118.GB1147@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240113010118.GB1147@sol.localdomain>

On 01/12, Eric Biggers wrote:
> On Fri, Jan 12, 2024 at 04:57:47PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > kill_f2fs_super() is called even if f2fs_fill_super() fails.
> > f2fs_fill_super() frees the struct f2fs_sb_info, so it must set
> > sb->s_fs_info to NULL to prevent it from being freed again.
> > 
> > Fixes: 275dca4630c1 ("f2fs: move release of block devices to after kill_block_super()")
> > Reported-by: syzbot+8f477ac014ff5b32d81f@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/r/0000000000006cb174060ec34502@google.com
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Jaegeuk, I'd be glad to take this through the fscrypt tree since that's where my

Ok, are you heading to push this in -rc1?

> broken commit came from.  But let me know if you want to just take this through
> the f2fs tree.
> 
> - Eric

