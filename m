Return-Path: <linux-fscrypt+bounces-1045-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C5BDCD7461
	for <lists+linux-fscrypt@lfdr.de>; Mon, 22 Dec 2025 23:22:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AFEC330A9314
	for <lists+linux-fscrypt@lfdr.de>; Mon, 22 Dec 2025 22:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA82C31A07B;
	Mon, 22 Dec 2025 22:18:46 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50AE331A6E;
	Mon, 22 Dec 2025 22:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766441926; cv=none; b=WtlLEvTBl9T2GQWECdPGE2hHAiw5q+eu+pN5Br1wgGfvYt7lufJUq4+w2TvDy65FURhbffCmCMCvpe39VFiB6bTdfG/B08qaGXKFnrHWHsjNbTE1qnMewO40+WxCTbh1koL3a+nzbjJUzbDZnblgvYwOJXHlkh8dU2g1jhyu4zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766441926; c=relaxed/simple;
	bh=QEINBGSaQP05cflS8K/NHlo/zaf2/l/Lz+ngYMghjaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p3ew5iKyD5i8BZA+7wCdNZ8wOgI+dUJofszzcURIBZOj8DQETFew9eDHORtBkzdW+Qt+po8bSoQQhRjciFLnlZlU1lMiNbTTMYqxEMSVlrkBECjOtWAckLWcEi3GnB5DE6CdVmFuEuEzWrMBcHhIQJE23XDbiWL8yL8J+CYjOgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1B9CA68B05; Mon, 22 Dec 2025 23:18:41 +0100 (CET)
Date: Mon, 22 Dec 2025 23:18:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 7/9] blk-crypto: use mempool_alloc_bulk for encrypted
 bio page allocation
Message-ID: <20251222221840.GA17565@lst.de>
References: <20251217060740.923397-1-hch@lst.de> <20251217060740.923397-8-hch@lst.de> <20251219200244.GE1602@sol>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219200244.GE1602@sol>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 19, 2025 at 12:02:44PM -0800, Eric Biggers wrote:
> The error handling at out_free_enc_bio is still broken, I'm afraid.
> It's not taking into account that some of the pages may have been moved
> into bvecs and some have not.
> 
> I think it needs something like the following:

That will now leak the pages that were successfully added to the bio.

I end up with a version that just adds the pages to the bio even
on failure.  I've pushed the branch here:

https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/blk-crypto-fallback

but I plan to come up with error injection to actually test this
patch given the amount of trouble it caused.


