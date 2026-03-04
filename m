Return-Path: <linux-fscrypt+bounces-1488-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id csjKMXZ+p2kjiAAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1488-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 04 Mar 2026 01:36:06 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 389A21F8ED4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 04 Mar 2026 01:36:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EEE13301BA58
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Mar 2026 00:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7EB256C61;
	Wed,  4 Mar 2026 00:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qxATxzS5"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9A933688A;
	Wed,  4 Mar 2026 00:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772584564; cv=none; b=cqOeO4FEPlCcnHx04LLCgZTEdYujG6VAWNwRyKo0LQwkrn5Mz6/2BUnwLK5iWgRBfnGSg2xtIPr75fxkw/vOtCYiEXWX/6m4r1LZmvqDjxKckTBOew1GEUT82UQCCdW1iR+k72dXhcMaPMQ8UZmbtpiCpAPqtx7mm9dW082+SNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772584564; c=relaxed/simple;
	bh=H1uhE52l0NdlL0DzS2ZP5duN1wYKtufIOeOTS6Cnn3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJA9q6I6ZtvLpDeIiOb95+hzfQbw5YkdU/wSoAUb5DKJirAcHiULnSHfVV74Q9BR1Ulw+Z1cLGZxVP6k9MkcBaoKBNmaxz6oTcUoLyHq10PKT+4AmW1bXU4IJyOmKIsMAMVy4pEx+DiFBp+YZVM48WCu7WDv2HuIpHxYNhxnfwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qxATxzS5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F783C116C6;
	Wed,  4 Mar 2026 00:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772584563;
	bh=H1uhE52l0NdlL0DzS2ZP5duN1wYKtufIOeOTS6Cnn3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qxATxzS5oROKJjTc7CQVBJnZDo2wXAgy1wDXg3dXdyR76rIx/HcT0IWfJcpAmfbgs
	 LTi0B9xKRnaa1GbnuGDSB43jzBDFKqbsR7vn6QkKF7L0Dilpatbb+VOMbsvT85frkx
	 3g0gvBzgxpRGUyTI+cBMzqsWdnu8HRv4W5mfmtlFvzANfIjluLl12Zqo8lJykBU3xx
	 cLtH4ILUVEeiWDEJMVRGiN6eg7cbtiAWnNzVevXfcRgPVdHDq3Urnad4GmKwU+cQpV
	 HTL7bRZ68C9FYBo47lhp3rj6015TCyxg48HTdUBd+23DAJNJlgiJQYpxW5LvbPYySp
	 /UBFhO58VMmTQ==
Date: Tue, 3 Mar 2026 16:35:51 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: syzbot <syzbot+cf7946ab25b21abc4b66@syzkaller.appspotmail.com>,
	chao@kernel.org
Cc: jaegeuk@kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Subject: Re: [syzbot] [fscrypt?] [f2fs?] memory leak in fscrypt_setup_filename
Message-ID: <20260304003551.GC57956@quark>
References: <69a75fe1.a70a0220.b118c.0014.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69a75fe1.a70a0220.b118c.0014.GAE@google.com>
X-Rspamd-Queue-Id: 389A21F8ED4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1488-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt,cf7946ab25b21abc4b66];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 02:25:37PM -0800, syzbot wrote:
> BUG: memory leak
> unreferenced object 0xffff888127f70830 (size 16):
>   comm "syz.0.23", pid 6144, jiffies 4294943712
>   hex dump (first 16 bytes):
>     3c af 57 72 5b e6 8f ad 6e 8e fd 33 42 39 03 ff  <.Wr[...n..3B9..
>   backtrace (crc 925f8a80):
>     kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
>     slab_post_alloc_hook mm/slub.c:4520 [inline]
>     slab_alloc_node mm/slub.c:4844 [inline]
>     __do_kmalloc_node mm/slub.c:5237 [inline]
>     __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5250
>     kmalloc_noprof include/linux/slab.h:954 [inline]
>     fscrypt_setup_filename+0x15e/0x3b0 fs/crypto/fname.c:364
>     f2fs_setup_filename+0x52/0xb0 fs/f2fs/dir.c:143
>     f2fs_rename+0x159/0xca0 fs/f2fs/namei.c:961
>     f2fs_rename2+0xd5/0xf20 fs/f2fs/namei.c:1308

The following commit added a call to f2fs_setup_filename() without a
matching call to f2fs_free_filename():

    commit 40b2d55e045222dd6de2a54a299f682e0f954b03
    Author: Chao Yu <chao@kernel.org>
    Date:   Wed Feb 7 15:05:48 2024 +0800

        f2fs: fix to create selinux label during whiteout initialization

Chao, do you want to handle fixing this?

- Eric

