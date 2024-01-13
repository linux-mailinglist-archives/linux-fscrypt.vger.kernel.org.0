Return-Path: <linux-fscrypt+bounces-122-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ADA9E82C888
	for <lists+linux-fscrypt@lfdr.de>; Sat, 13 Jan 2024 02:01:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 618301F22C55
	for <lists+linux-fscrypt@lfdr.de>; Sat, 13 Jan 2024 01:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F309F10797;
	Sat, 13 Jan 2024 01:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jqsswl9z"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D838110796
	for <linux-fscrypt@vger.kernel.org>; Sat, 13 Jan 2024 01:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315AAC433C7;
	Sat, 13 Jan 2024 01:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705107680;
	bh=+axu1UQ1Imh6/igfm1lDN70XKP8E1L63E0Njkf/6jd8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jqsswl9z2poabxiZG85CfxI0w6SBy1fHX1/INz3/sZd5qR0Rpd2HavlCN5QRfGZef
	 PFv71ASZlEX2RaG6lfknGUpafqZUxCF/vO3nvb8FJBRENa0MuxDApGr7lJbe5wEM9Y
	 uSE3R6YLPhGWxa0e3VDoM6/1vfc0sL0X/xE3qwfC/TuStcQ1SjSCG6ey0VLNJvrWyZ
	 Ee7jhghzm2kbGFMNEhzAjDakTIdpb/6cAw5yK45hH3Q8pbrmxweqx4Wo9maf7+iODQ
	 JvOIGuyebsBi5OaeqY+xSAmW8DWk6ZxXitW+vTipmLiBcT5vYD9I2FTO9Fbyz1nCrV
	 2IdJN2aXRRPLw==
Date: Fri, 12 Jan 2024 17:01:18 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-f2fs-devel@lists.sourceforge.net,
	Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-fscrypt@vger.kernel.org,
	syzbot+8f477ac014ff5b32d81f@syzkaller.appspotmail.com
Subject: Re: [PATCH] f2fs: fix double free of f2fs_sb_info
Message-ID: <20240113010118.GB1147@sol.localdomain>
References: <20240113005031.GA1147@sol.localdomain>
 <20240113005747.38887-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240113005747.38887-1-ebiggers@kernel.org>

On Fri, Jan 12, 2024 at 04:57:47PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> kill_f2fs_super() is called even if f2fs_fill_super() fails.
> f2fs_fill_super() frees the struct f2fs_sb_info, so it must set
> sb->s_fs_info to NULL to prevent it from being freed again.
> 
> Fixes: 275dca4630c1 ("f2fs: move release of block devices to after kill_block_super()")
> Reported-by: syzbot+8f477ac014ff5b32d81f@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/r/0000000000006cb174060ec34502@google.com
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Jaegeuk, I'd be glad to take this through the fscrypt tree since that's where my
broken commit came from.  But let me know if you want to just take this through
the f2fs tree.

- Eric

