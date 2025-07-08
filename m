Return-Path: <linux-fscrypt+bounces-693-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB66DAFD670
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Jul 2025 20:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7B501C271ED
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Jul 2025 18:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03FC32EBDDA;
	Tue,  8 Jul 2025 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NG63G2nE"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD8F2EBDCE;
	Tue,  8 Jul 2025 18:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751998851; cv=none; b=R/PfCMkfuPadBSo6UtZ5/z+FsXLcco0JwXUA9TK6Dho6avl7VN2l44X9SKXS6w2djT+7mxqonYRBRbD6o3/zuZxjnqSo4O4AjigQB0R5RqIIz2isV+ZQ6qGN9XeirdsOsNhRTycKBsK1b5WIWEPyYatSbyGUgrrvt9wLnY+Tsio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751998851; c=relaxed/simple;
	bh=x43xMa/FOzE06hyOr7AC8Qnb2MUYOv7J4K+cekDKbDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qPNjTGM2jqiW2pian8E5jxpfXGS9YoH4KTWmgbZcRRE0/kEyVNcyzbf1HN0yysv46AeTd6kqQ4AeMyuwd57JuYHcwUjmhsRspm2lc51Hcoub4MQ/EcBXW/CV+5gzREv+Bg3Cf5+MFqgbZS3mV75lm7UmKYb4HYfNwi+2hBqDvsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NG63G2nE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FA3C4CEED;
	Tue,  8 Jul 2025 18:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751998851;
	bh=x43xMa/FOzE06hyOr7AC8Qnb2MUYOv7J4K+cekDKbDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NG63G2nEfveKE59nKPI9OwTLgYnn5Z+kYZojIYyBfF+2cZX5K+YOkNb0mB/1sQzOn
	 IUd/X4rBGQHhHTCj/RA7Z0ocVTceNXWxnwM2xdiwzVAZ2ehc/ub3AE1rHs2nESfnGU
	 kj8GcbpvLOsn8DtAab0NZ42ALnYW5VJJsoOd0xkn6g4SeJN52Kbz8PlbQC/nzMSGkD
	 JwX1yoLyJLRFF7WBjuJA/VLYj+krAX9Q/1UvuwUwu45UpRrHOyRMKeJ9mOvN4yyszG
	 +6UIaSj6ZoULZuYpJV6OngYTSzaA0afJGgpTAmY9mlHp97we6vqfbR7WP3TXXRwoWd
	 JeJGwmGalpp/A==
Date: Tue, 8 Jul 2025 11:20:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au, jaegeuk@kernel.org,
	linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH v2] fscrypt: improve filename encryption and decryption
 performance
Message-ID: <20250708182007.GB1255@sol>
References: <20250704051441.GA4199@sol>
 <tencent_8F6BAFE88DDB6EFCC8D5E81C3BCFEAEBB105@qq.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_8F6BAFE88DDB6EFCC8D5E81C3BCFEAEBB105@qq.com>

On Tue, Jul 08, 2025 at 03:33:34PM +0800, Yuwen Chen wrote:
> On Thu, 3 Jul 2025 22:14:41 -0700, Eric Biggers wrote:
> > I'm guessing you have some debugging options enabled in your kconfig.  Usually
> > the allocations aren't quite *that* expensive.  That being said, it's always
> > been really annoying that they have to be there.
> 
> Turn off most of the debugging options and merge these two patches
> for memory allocation. The performance test results are as follows:
> Before this submission was merged, when creating 10000 files,
> the performance test results are as follows:
> $ time /data/file_creater 10000
> 0m10.90s real     0m00.00s user     0m10.69s system
> 
> After merge these two patches, the performance is as follows:
> $ time /data/file_creater 10000
> 0m05.32s real     0m00.00s user     0m05.28s system
> 
> > Unfortunately, as far as I know, you actually can't just allocate the
> > skcipher_request on the stack like that, since the legacy crypto API assumes
> > that the request memory is DMA-able.  On-stack requests also might not be
> > properly aligned (see
> > https://lore.kernel.org/all/CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com/
> > -- may be outdated, but I haven't heard otherwise).
> 
> Thank you for the reminder. This should be a problem here.
> Just, why can SYNC_SKCIPHER_REQUEST_ON_STACK be allocated on
> the stack? Is it possible to use ALIGN to achieve alignment?

I suppose that in practice the request alignment only matters for the
off-CPU offloads, and that's how SYNC_SKCIPHER_REQUEST_ON_STACK gets
away with maybe not aligning the request reliably.  If you look at e.g.
the software AES-XTS code, it doesn't even use the request context at
all, which makes the entire exercise a bit pointless.

I'm thinking we should just go ahead and use sync_skcipher and
SYNC_SKCIPHER_REQUEST_ON_STACK for now.  Previously this was impossible
because the x86 accelerated AES-XTS algorithms had CRYPTO_ALG_ASYNC set,
but now it is possible.

Can you review and test the following patchset:
https://lore.kernel.org/linux-fscrypt/20250708181313.66961-1-ebiggers@kernel.org/ ?

- Eric

