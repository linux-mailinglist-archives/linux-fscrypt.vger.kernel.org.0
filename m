Return-Path: <linux-fscrypt+bounces-1015-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 95970CB7E90
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Dec 2025 06:16:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 19B7A3039773
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Dec 2025 05:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2B023EA93;
	Fri, 12 Dec 2025 05:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fsqAifHt"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4B23B8D67;
	Fri, 12 Dec 2025 05:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765516577; cv=none; b=jQUoTOuRHbi1yh0kSUkkJBdCAqfPmaIAhD5c9iXN2QzrYJj739VVXyfoPqMZbnFFwqfUp9MuToWT10mev+kl0Ee2CMjGo7abqmXSsDeqYDQlc+KwQ5HzRliU8S/p+tmyAy2GZXaXndBOmaVnnghFhI0YvezrxeYieY4YjDpadxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765516577; c=relaxed/simple;
	bh=Q6E1/e/8ZkTKJNYKc2gfQbgcOGWsdJSVktsVdR9oAA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZ5Q/iz9n4gvkI+dDTz2HbJKlkCrlgFYiQ5/ll8r8BLa4FN2t5/P3XEHMh0XPpMk44jrEHXQPCbfX5wbHK6xSE9AsFnxV0MM6Ibzaf7i+Byj921Y1DTmODiAv5Rp81lSWAkQ2a2IopfQUwdM8GkDLCYRNgF8MXWEMX/Sfl2cw7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fsqAifHt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Q6E1/e/8ZkTKJNYKc2gfQbgcOGWsdJSVktsVdR9oAA8=; b=fsqAifHtakDw5cRi0bRYrbV2Yp
	B1Wwvhp4H+xWSeO7rafWvgAbPZXNWR7IWeTQJ3TcI2kLYwdU6w5UnlsAssy9AFKCJ4XZX5zt0fhyS
	Pq4xWsNIF2k4lyDg8Ok2hNXHAjnonc78F6rWC0qV4hysDIMsTO7rprRfyuvPVuguLnqLpA3oqzs7V
	Ul2+jTklj3CoCQgEP05vuT/D028O/PIUSc/6NFwL9CtN+1bUDMroVp6jFjyl40CjcMoQ04DuZLvHY
	gsR10RJVeLRYKhPcL2Z0LZjMveeKyk/QyD+3qxhN9SyTpjtwcJqJCckhVCzYGelcw7ZS8zTt2Q2Fj
	3hYV1aGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTvVZ-000000006O2-2wOu;
	Fri, 12 Dec 2025 05:16:01 +0000
Date: Thu, 11 Dec 2025 21:16:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	syzbot <syzbot+7add5c56bc2a14145d20@syzkaller.appspotmail.com>,
	davem@davemloft.net, herbert@gondor.apana.org.au,
	jaegeuk@kernel.org, linux-crypto@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	tytso@mit.edu, Neal Gompa <neal@gompa.dev>
Subject: Re: [syzbot] [ext4] [fscrypt] KMSAN: uninit-value in
 fscrypt_crypt_data_unit
Message-ID: <aTulEbvkOf0Tsztf@infradead.org>
References: <68ee633c.050a0220.1186a4.002a.GAE@google.com>
 <69380321.050a0220.1ff09b.0000.GAE@google.com>
 <20251210022202.GB4128@sol>
 <20251211185215.GM94594@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211185215.GM94594@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 11, 2025 at 10:52:15AM -0800, Darrick J. Wong wrote:
> Hey waitaminute, are you planning to withdraw fscrypt from ext4?

No really, just forcing to use one of the two current implementations
of the I/O path.

> (I might just not know enough about what blk-crypto is)

block/blk-crypto*


