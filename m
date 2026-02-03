Return-Path: <linux-fscrypt+bounces-1078-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oCsZAkt+gmnAVQMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1078-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 04 Feb 2026 00:01:31 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AC88DF7FB
	for <lists+linux-fscrypt@lfdr.de>; Wed, 04 Feb 2026 00:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B5E0303AF06
	for <lists+linux-fscrypt@lfdr.de>; Tue,  3 Feb 2026 23:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F29772D191C;
	Tue,  3 Feb 2026 23:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5yZ+41L"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE55929DB65;
	Tue,  3 Feb 2026 23:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770159686; cv=none; b=kUYz3HmE88oKOgxFHCzFimDAK9dz29ufR5r9dnJ1T+KJ6B6Rehg0HGvHUUI9F6qciRlCxf8TzdMGek92EP8Z7K/KMeTLHv415wFFk0SIdDjhz/1/ynqxPhrW3RxI7VPZz6hQKtQRZc6pw7QkevNSk+B9XTg5l1hiztWUOEM8b+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770159686; c=relaxed/simple;
	bh=6+OC8xqFJ8Ra/JiM0dVaFvJDlj+ZOH9NPyD2sp5CHvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c3H6lPhrigYj8fhw5XJ4uht6Txe20PeX8NvANU1f/ngIkgLT9ouaDVZpk6u4IBOZu25uk5Ls67Azh/BSSEebX0PEr+MnucePyeWnhxnu8JcR3lVV2wEUAk+l2m4hxW5jS74+LlF3whDsfIB739tD18CtTKD2mtQrT+L21DVuT2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5yZ+41L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03C7C2BC86;
	Tue,  3 Feb 2026 23:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770159686;
	bh=6+OC8xqFJ8Ra/JiM0dVaFvJDlj+ZOH9NPyD2sp5CHvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L5yZ+41Lkhu4k67GeeWfmbzf7Bese7xS9DR+H7NtUWfk91m1eJVADLP2RVyzrG+Ct
	 rgh1e0VvKFsqLRGyjoYNtTZFT7YqajHJ0wSLMJcfhM5ZPrSHdzGFxnyc4B0PaU6kW9
	 rJy05Vubc9PFZSKul5Xp55uXRpbD2FSJXhZEnL2RCcqWCSURqndssF/HGVX2B1XJmf
	 8U17Twn+xWoR4ftCuLkx+aEvjAjfWHNPaYD6hPOXSpPwVfs+QwPXjiwrxEHVhfHe1Y
	 kaG1r7vgEzvrEjWXW1Lm8XwAsdwwRTcPpbQMVWvxRWMYfQFuHmjXOpJjPj9wpxjX/l
	 EMOw47C5+xn5Q==
Date: Tue, 3 Feb 2026 23:01:24 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Harry Yoo <harry.yoo@oracle.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	=?utf-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>,
	syzkaller@googlegroups.com, akpm@linux-foundation.org,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	"Theodore Y. Ts'o" <tytso@mit.edu>, linux-fscrypt@vger.kernel.org
Subject: Re: [Kernel Bug] WARNING in mempool_alloc_noprof
Message-ID: <20260203230124.GA1161785@google.com>
References: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
 <aYBiza9L1hmhmXbb@hyeyoo>
 <fwutwpejyptpo6gqv75zanqciv3fmxvillomwcjvtz4auebbc2@vazub2ct7pa2>
 <aYHFZ5OxfL4j-_ze@hyeyoo>
 <aYIh1wPm7BrId9dk@infradead.org>
 <6f5881df-0e0b-4278-808b-7c0cffa12a30@suse.cz>
 <aYIpVq-jTKyTQE8G@infradead.org>
 <d9dc2ee1-283d-4467-ad36-a6a4aa557589@suse.cz>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9dc2ee1-283d-4467-ad36-a6a4aa557589@suse.cz>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1078-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,oracle.com,gmail.com,googlegroups.com,linux-foundation.org,gentwo.org,google.com,linux.dev,kvack.org,vger.kernel.org,kernel.org,lists.sourceforge.net,mit.edu];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9AC88DF7FB
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 07:30:07PM +0100, Vlastimil Babka wrote:
> On 2/3/26 17:59, Christoph Hellwig wrote:
> > On Tue, Feb 03, 2026 at 05:55:27PM +0100, Vlastimil Babka wrote:
> >> On 2/3/26 17:27, Christoph Hellwig wrote:
> >> > On Tue, Feb 03, 2026 at 06:52:39PM +0900, Harry Yoo wrote:
> >> >> Maybe the changelog could be rephrased a bit,
> >> >> but overall LGTM, thanks!
> >> > 
> >> > 
> >> > No, that does not make sense.  If mempool is used with __GFP_RECLAIM in
> >> > the flags it won't fail, and if it isn't, GFP_NOFAIL can't work.
> >> 
> >> So that means as long as there's __GFP_RECLAIM, __GFP_NOFAIL isn't wrong,
> >> just redundant.
> > 
> > Given how picky the rest of the mm is about __GFP_NOFAIL, silently
> > accepting it where it has no (or a weird and unexpected) effect
> > seems like a disservice to the users.
> 
> OK then. But I don't think we need to add checks to the mempool hot paths.
> If somebody uses __GFP_NOFAIL, eventually it will trickle to the existing
> warning that triggered here. If it's using slab then eventually that will
> reach the page allocator too. Maybe not with some custom alloc functions,
> but meh.
> 
> This f2fs_encrypt_one_page() case is weird though (and the relevant parts
> seem to be identical in current mainline).
> It uses GFP_NOFS, so __GFP_RECLAIM is there. It only adds __GFP_NOFAIL in
> case fscrypt_encrypt_pagecache_blocks() already failed with -ENOMEM.
> 
> That means fscrypt_alloc_bounce_page() returns NULL, which is either the
> WARN_ON_ONCE(!fscrypt_bounce_page_pool) case (but the report doesn't include
> such a warning), or mempool_alloc() failed - but that shouldn't happen with
> GFP_NOFS?
> 
> (Also the !fscrypt_bounce_page_pool is therefore an infinite retry loop,
> isn't it? Which would be truly a bug, unless I'm missing something.)
> 
> Ah but fscrypt_encrypt_pagecache_blocks() can also return -ENOMEM due to
> fscrypt_crypt_data_unit() returning it.
> 
> And there theoretically in v6.12.11 skcipher_request_alloc() could return
> -ENOMEM. In practice I assume this report was achieved by fault injection.
> But that possibility is gone with mainline commit 52e7e0d88933 ("fscrypt:
> Switch to sync_skcipher and on-stack requests") anyway.
> 
> I think the whole "goto retry_encrypt;" loop in f2fs_encrypt_one_page()
> should just be removed.

Indeed, fscrypt_encrypt_pagecache_blocks() (or the older code it was
derived from) used to do multiple memory allocations.  Now it only
allocates the bounce page itself.

Also, the intended usage is what ext4 does: use GFP_NOFS for the first
page in the bio for a guaranteed allocation from the mempool, then
GFP_NOWAIT for any subsequent pages.  If any of the subsequent
allocations fails, ext4 submits the bio early and starts a new one.

f2fs does it differently and just always uses GFP_NOFS.  Yes, that
doesn't make sense.  I guess ideally it would be changed to properly do
opportunistic allocations in the same way as ext4.  But until then, just
removing the retry loop sounds good.

- Eric

