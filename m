Return-Path: <linux-fscrypt+bounces-800-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AD4CB2134A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Aug 2025 19:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27C7E6272F8
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Aug 2025 17:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392A32D238F;
	Mon, 11 Aug 2025 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RqJYdiQR"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113872C21CB;
	Mon, 11 Aug 2025 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933525; cv=none; b=CQz1es5xC4W0vYr1kcAxHR5HP4PEzzl3r1P4SYiHKwJh/6dNydvf+z8Warhx6BaECwH15XFgfdSuji9GpCI8wr7CusfoceEgPY7B62U/I/tBBAwNL124wm4Yjrr83SjlljRUBsKRuIbpemkV3VgDB2HHcgQgK3hgadJkwd2pPUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933525; c=relaxed/simple;
	bh=3SXwtl2OtaQFXcCQM1wIwDc4Vz/l1VygIiHIWJrC0bI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KNaPQx4Ug3oU4WOEzpFqfJl0oF9bPXyo5b54TWa1v6HNKqlnFw1uyzpG+MukLYAo6+mwbzkJicP/feWT5YwcchCzGGl7/AUOhlq7RGzBmigiA+zIqgMOvx2YLvD4+jFi1V6prPBVLYuwkrlVaZ9jn3Qtewn7+jzy01wLU4WLpmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RqJYdiQR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667EDC4CEF4;
	Mon, 11 Aug 2025 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754933524;
	bh=3SXwtl2OtaQFXcCQM1wIwDc4Vz/l1VygIiHIWJrC0bI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RqJYdiQRFtKoGiCNGtK4TOcFiHp0KRS4YArjbK/swfNhsg43KcF1AF/hL+KlrTa4W
	 XBHwqdCN77C2VwTbU5ygOGQDQJnAdAvzS3usxsjXuS5VeaARKSQxUgESIV+MnyVRwZ
	 uSwlZYSYvLDBKn0JnfDA1rN4xY5gKlXbkn42s6uf18xEXNSmvdUIZDvYySEfL1Lr88
	 YFrm4mok/PzO6PC6E1UOwUaQEcdRzKFZ599YmwaNYjyhnmywyCOom7BAu8a+RgLK9Q
	 FFmNx+E8767CcEIgNhholxL0xlqAw6LCJ0nvvCd1f/HXskL3GIuFFLMJoJdLKDeH3j
	 G3YxOH5M6wAKA==
Date: Mon, 11 Aug 2025 10:31:03 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	"open list:FSCRYPT: FILE SYSTEM LEVEL ENCRYPTION SUPPORT" <linux-fscrypt@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>, willy@infradead.org
Subject: Re: [PATCH 2/4] fscrypto: Remove redundant __GFP_NOWARN
Message-ID: <20250811173103.GC1268@sol>
References: <20250803102243.623705-1-rongqianfeng@vivo.com>
 <20250803102243.623705-3-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250803102243.623705-3-rongqianfeng@vivo.com>

On Sun, Aug 03, 2025 at 06:22:40PM +0800, Qianfeng Rong wrote:
> GFP_NOWAIT already includes __GFP_NOWARN, so let's remove
> the redundant __GFP_NOWARN.
> 
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> ---
>  fs/crypto/bio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
> index 486fcb2ecf13..e92967e20e2a 100644
> --- a/fs/crypto/bio.c
> +++ b/fs/crypto/bio.c
> @@ -148,7 +148,7 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
>  	 */
>  	for (i = 0; i < nr_pages; i++) {
>  		pages[i] = fscrypt_alloc_bounce_page(i == 0 ? GFP_NOFS :
> -						     GFP_NOWAIT | __GFP_NOWARN);
> +						     GFP_NOWAIT);
>  		if (!pages[i])
>  			break;
>  	}
> -- 
> 2.34.1
> 

Applied to https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=for-next

Thanks!

- Eric

