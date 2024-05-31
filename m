Return-Path: <linux-fscrypt+bounces-298-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 373D08D6943
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 20:55:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E41A22831FC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 18:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F7497E78E;
	Fri, 31 May 2024 18:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pdFtuEiW"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385E57E563;
	Fri, 31 May 2024 18:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717181722; cv=none; b=MLbKcALVr+E961c9UexKbAVYW/Bo5LoFjaZTXsrZ7DF6diJCs2UAlqdWYBiYoFpRUsR68MCWhfh+iaSSs86Lfa0OQAggGk1e/NOBICoo6gR+T6EPiwvgg/m2aVrBpl0TfsQUNf3Tqi+uvtEBsuAxVQMNQ1LqNr3Dlz5EpO3fTxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717181722; c=relaxed/simple;
	bh=WuHvG2oalIqTM1m9wO4kdurTHHM8QmXjw2z7bpGaImo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ojhUmt/DmMfJgn0pgIWhKXHAVONnAcMt3yT8Np7nlpeMxDPBx29PdUO6UEMcbrOeQ0fE/XChLiBZbCZ4VxURGTWZb75bJjWfByW5kLcCJ6nT+vX6P/aLpUyqUiXO6rF9w0mEZNppOwXe7UP8gGtdX6xUFE5nIhYv3bustnUyGIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pdFtuEiW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C0CC116B1;
	Fri, 31 May 2024 18:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717181721;
	bh=WuHvG2oalIqTM1m9wO4kdurTHHM8QmXjw2z7bpGaImo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pdFtuEiWRBKlfEt/Jm+TBEnM6gGoF36pGUFRi4tb9EVzO6olRyIFpl0O69mkQTL3f
	 0+hZ8ujtQuNzH60tS+YF63MfwgBlzTzHKhSnx8BW3d9zP8ZSbe/itTaaFRN17sPTJa
	 nmvPQhPnVJ5DPQw/+VU2Cy4a2nisulJAuX2/odWcPUCmAhQuXvz4sm+eGhJS11l4Dm
	 AYonGo0podM6AOrSbned+4JgEE8qDwUByNsSr2sumJT+9yB8tXTFmjd/9VLcy9+cbC
	 B++2BZCQm8he9i6zMtEcC+rzqdnwpiaFxdmyNikGzBoC2HRVszGzD7l/T93snXwgon
	 dNQu5mmzQ1izQ==
Date: Fri, 31 May 2024 11:55:19 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: lkp@intel.com, coreteam@netfilter.org, davem@davemloft.net,
	fw@strlen.de, jaegeuk@kernel.org, kadlec@netfilter.org,
	kuba@kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev, pablo@netfilter.org,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Subject: Re: [PATCH V4] ext4: check hash version and filesystem casefolded
 consistent
Message-ID: <20240531185519.GB1153@sol.localdomain>
References: <202405311607.yQR7dozp-lkp@intel.com>
 <20240531090611.2972737-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531090611.2972737-1-lizhi.xu@windriver.com>

On Fri, May 31, 2024 at 05:06:11PM +0800, 'Lizhi Xu' via syzkaller-bugs wrote:
> When mounting the ext4 filesystem, if the hash version and casefolded are not
> consistent, exit the mounting.
> 
> Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
>  fs/ext4/super.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index c682fb927b64..0ad326504c50 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5262,6 +5262,11 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  		goto failed_mount;
>  
>  	ext4_hash_info_init(sb);
> +	if (es->s_def_hash_version == DX_HASH_SIPHASH && 
> +	    !ext4_has_feature_casefold(sb)) {
> +		err = -EINVAL;
> +		goto failed_mount;
> +	}

For the third time: you need to use the correct mailing lists.
Please follow Documentation/process/submitting-patches.rst.

- Eric

