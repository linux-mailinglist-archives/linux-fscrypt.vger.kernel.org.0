Return-Path: <linux-fscrypt+bounces-372-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A67A096E606
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Sep 2024 01:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F2A01F238E6
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Sep 2024 23:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFAE21AD9DD;
	Thu,  5 Sep 2024 23:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ivl1jJdY"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968EB199229;
	Thu,  5 Sep 2024 23:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725577342; cv=none; b=lp7xQK24HFgrqSZivfe37rQqShE8trZo1iO2KVP8xluKtYoo0MsS9wiCD2EZ+CRLxpQXcFWlMmiAuyXuW6XdB0sYUiuaF998uytVVg+qB82bDyWypY4q2x4y0jyosBGjGPrQR2chLW0A1W8ocuo/+dHQE3VL6VubbaABr2p529o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725577342; c=relaxed/simple;
	bh=NofaqeoRom0dHbUXnel/afTNRYESUn/WozUBe1MJ9Vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jEAMDqY7XNnCdyjzoTOgUBCHVdaAd8MGJXDwTcdA34+fKcslQw0u+Dyh7iltgG1Cf7yqyq1BDoD7orBGKaXAc7YsuEkYFrXndegWpe7R1jawLfTYUVI4tVB+qT5GlcUNNb/6WdCWIJlOIAmiX2PbKxYQq7eObK7km1VtHtRv0pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ivl1jJdY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2D0C4CEC3;
	Thu,  5 Sep 2024 23:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725577341;
	bh=NofaqeoRom0dHbUXnel/afTNRYESUn/WozUBe1MJ9Vo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ivl1jJdYhiMBDScp+ZqsnFDL7HdXk5cs4fzubg6/l83XregWP+B9w7N97c/DocVyh
	 tuAvTmPYJDoQ4NxyZspDsa43GSB5Dad/2/LC7vusw/KQbyQZSKqK9GP6knU99wTq8o
	 3pvXePfvDQkpF9UaeEUfC8no6zbN8Q05ni3/V8mkFS9gerhpO6Dj4e5vLqd/qbeCjx
	 IjlQCoFYvlPxZMrn3qEDDj/LjJHPQ8B/40IcB8nuCsk7JlL8NfaIpklinW57PLQBlt
	 /1khPbnlrXD0J2UDtQYvZlfOLkssDflgW2+AldPQFEk7CBz0ltF1mRoC/I2D0DiCHy
	 bToRg6dKlNvrA==
Date: Thu, 5 Sep 2024 16:02:19 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 06/18] fscrypt: Include <linux/prandom.h> instead of
 <linux/random.h>
Message-ID: <20240905230219.GB1512@sol.localdomain>
References: <20240905122020.872466-1-ubizjak@gmail.com>
 <20240905122020.872466-7-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240905122020.872466-7-ubizjak@gmail.com>

On Thu, Sep 05, 2024 at 02:17:14PM +0200, Uros Bizjak wrote:
> Usage of pseudo-random functions requires inclusion of
> <linux/prandom.h> header instead of <linux/random.h>.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: "Theodore Y. Ts'o" <tytso@mit.edu>
> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc. linux-fscrypt@vger.kernel.org
> ---
>  fs/crypto/keyring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
> index 6681a71625f0..e2c10b3b960b 100644
> --- a/fs/crypto/keyring.c
> +++ b/fs/crypto/keyring.c
> @@ -21,7 +21,7 @@
>  #include <asm/unaligned.h>
>  #include <crypto/skcipher.h>
>  #include <linux/key-type.h>
> -#include <linux/random.h>
> +#include <linux/prandom.h>
>  #include <linux/seq_file.h>
>  

1. linux-fscrypt wasn't actually Cc'ed on this patch, due to the typo of
   "Cc." instead of "Cc:".

2. Currently <linux/random.h> includes <linux/prandom.h>, so the issue described
   in the commit message does not exist.  I assume this in changing in a later
   patch that was not sent to me.  The commit message should be rephrased to
   clarify that this change is needed because of header refactoring, as
   otherwise it sounds like a bug fix.

3. The proposed change does not make sense, because fs/crypto/keyring.c does not
   use any "pseudo-random functions".  It does use get_random_once(), which is
   defined in <linux/once.h>.  Currently <linux/random.h> includes
   <linux/prandom.h> which includes <linux/once.h>.  If the inclusion of
   prandom.h by random.h is going away, then perhaps random.h should include
   once.h directly so that get_random_once() continues to work?  If not, then
   this file should include once.h.  Either way it should not include prandom.h.

- Eric

