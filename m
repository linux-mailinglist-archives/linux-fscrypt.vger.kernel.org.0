Return-Path: <linux-fscrypt+bounces-288-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D988D578C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 03:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E78F91C242E4
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 01:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460F2EEAE;
	Fri, 31 May 2024 01:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6UDd489"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D6EEAE7;
	Fri, 31 May 2024 01:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717117516; cv=none; b=ONVVox5SsVP/Mm3kRBEq+H3OROQOT8KaCY7ciukGi76H0ERpSmeh8UHvnPgc/yeK+2KlfbJGI/Hlnvj8KtdWIe6iTH+JO24quOEAseiu5VH8VYVFSW93Qz06RX/2oYrUVQoP9EDYjWzex0SVQ8d2kEcI3pbPcWJSCNwKV5e0ijA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717117516; c=relaxed/simple;
	bh=lPLWeAPfBQ6oxpEs16VAr4Cg6Rl9aRzpSeyPTv3ueiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jtml2AVyHk0ISehnOw9dmwgw2ogy4kz6h48q8b/gAtl/E4z9US0tbzXCS/0D6sFFnMasQInaatwtpuxUFEoeNg2cCOpSk6upOe4+Oyq693xfozEWZ970cziHZvntXMwcRaRY3bIS8sQRaqvg0ZB45Lm+oL2RQCgukN1UcF4fSW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6UDd489; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA03C4AF09;
	Fri, 31 May 2024 01:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717117515;
	bh=lPLWeAPfBQ6oxpEs16VAr4Cg6Rl9aRzpSeyPTv3ueiA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P6UDd489pzVxW7MTo4FlgeeEiIjBKfuMvB5tC0smqSZyq8AucFhhj5Gl+H2Y8DD+w
	 WEgjlurXYQAfk8QTT+Aknoiad8cORfCXSKTPHXSvJWkqIb4AAqllLGXTmT7zs/p2JB
	 lBOUEv7y1oeAxgb8smS27Fl0Cwx/y9OP346waPsIyakOfNUTn3bPVG4glOEoUS7J8c
	 OxeUwK06EZKZuXUJrLG9iENe/t+MJC3mQd8NfjMUMcr0SNfxFLM5aFetDZlS78Ads0
	 PN7D9tF73Ac6UMSPTGzPOEZWYrGcV3l39Is8MYyY+Y2PADm/PZuQzIclm1Tt8kj+PT
	 qlUZEUn0yzpJA==
Date: Thu, 30 May 2024 18:05:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
	jaegeuk@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Subject: Re: [PATCH] ext4: add casefolded file check
Message-ID: <20240531010513.GA9629@sol.localdomain>
References: <000000000000cb987006199dc574@google.com>
 <20240530074150.4192102-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530074150.4192102-1-lizhi.xu@windriver.com>

On Thu, May 30, 2024 at 03:41:50PM +0800, 'Lizhi Xu' via syzkaller-bugs wrote:
> The file name that needs to calculate the siphash must have both flags casefolded
> and dir at the same time, so before calculating it, confirm that the flag meets
> the conditions.
> 
> Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
>  fs/ext4/hash.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
> index deabe29da7fb..c8840cfc01dd 100644
> --- a/fs/ext4/hash.c
> +++ b/fs/ext4/hash.c
> @@ -265,6 +265,10 @@ static int __ext4fs_dirhash(const struct inode *dir, const char *name, int len,
>  		__u64	combined_hash;
>  
>  		if (fscrypt_has_encryption_key(dir)) {
> +			if (!IS_CASEFOLDED(dir)) {
> +				ext4_warning_inode(dir, "Siphash requires Casefolded file");
> +				return -2;
> +			}
>  			combined_hash = fscrypt_fname_siphash(dir, &qname);
>  		} else {
>  			ext4_warning_inode(dir, "Siphash requires key");

First, this needs to be sent to the ext4 mailing list (and not to irrelevant
mailing lists such as netdev).  Please use ./scripts/get_maintainer.pl, as is
recommended by Documentation/process/submitting-patches.rst.

Second, ext4 already checks for the directory being casefolded before allowing
siphash.  This is done by dx_probe().  Evidently syzbot found some way around
that, so what needs to be done is figure out why that happened and what is the
best fix to prevent it.  This is not necessarily the patch you've proposed, as
the real issue might actually be a missing check at some earlier time like when
reading the inode from disk or when mounting the filesystem.

- Eric

