Return-Path: <linux-fscrypt+bounces-1489-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KCL2GbyFp2m5iAAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1489-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 04 Mar 2026 02:07:08 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C21A21F9117
	for <lists+linux-fscrypt@lfdr.de>; Wed, 04 Mar 2026 02:07:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 45BF8305F7F2
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Mar 2026 01:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF6D52F5321;
	Wed,  4 Mar 2026 01:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7YeMaT4"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0B429408;
	Wed,  4 Mar 2026 01:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772586425; cv=none; b=Z5I8HNQ960lzM85kOpb5uL0/Vdp+j5HPsHjRwpIoyI+CPm+4s3RV1qbQfLyt1PZy+2ivHkgJ7ZzyU1765EHKfSVYh+PJwhwPnNX4WFxPhClH6oZpU7VqbBcOwYJ0SFk2sBfltpgUaKuRVCtFtJtC5R/yMgIszrziV61Ggcg2eaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772586425; c=relaxed/simple;
	bh=ELrq2BQCywlvcGrbaKftMUplevHelhmFZ+Jko/AEX6E=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rmJM5K4McatGDrPKbfeuX2PsMzqbds/5i954yejcQccwL1DeK5bRt9KhQRCxsKXE10jvugUSgWr0ZrMCDYWn8uS4HjAtM7968693ZN2VaVDdNWHrn6nIYrqFooMoQ6eBNC1ae9B9BsEI9d1G4UVmBn0l478hUKcMy6uCD3vyQN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7YeMaT4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66941C116C6;
	Wed,  4 Mar 2026 01:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772586425;
	bh=ELrq2BQCywlvcGrbaKftMUplevHelhmFZ+Jko/AEX6E=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=N7YeMaT4nRxQOIu6IBYPyPmvVJ2lzkfFJFrH0my+04SnPhr/uC1veAOQtY534KOHc
	 OY5SrMiJqzSd83NmYEAKuxxnD1KGLXyUVXyGHDPPMz4xTvk38md/SXgVZLHlgJ3lDF
	 xCXDHLEWa7th12Zeodp/RG2BeANVh42wgheZodRB6uTNSTJgXEINZknpOxWRdTImI5
	 QMWSQyAl4+ulcp5FgyFzriON3BXsaYy9Vs+T7OWFT6c3GCusNeWdnJARJbzwx0UOFe
	 4y/T3wsv6ylGM2hpDjywhR1fko/EC98Ot39CV7GML+zZ/mvHAPful7rF5ZZL9EZMAS
	 g6DdhJu+4jVWw==
Message-ID: <3f2fa6be-5000-4d36-998e-cfbe500cdb01@kernel.org>
Date: Wed, 4 Mar 2026 09:06:59 +0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, jaegeuk@kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Subject: Re: [syzbot] [fscrypt?] [f2fs?] memory leak in fscrypt_setup_filename
To: Eric Biggers <ebiggers@kernel.org>,
 syzbot <syzbot+cf7946ab25b21abc4b66@syzkaller.appspotmail.com>
References: <69a75fe1.a70a0220.b118c.0014.GAE@google.com>
 <20260304003551.GC57956@quark>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260304003551.GC57956@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C21A21F9117
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1489-lists,linux-fscrypt=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao@kernel.org,linux-fscrypt@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt,cf7946ab25b21abc4b66];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Action: no action

On 2026/3/4 08:35, Eric Biggers wrote:
> On Tue, Mar 03, 2026 at 02:25:37PM -0800, syzbot wrote:
>> BUG: memory leak
>> unreferenced object 0xffff888127f70830 (size 16):
>>    comm "syz.0.23", pid 6144, jiffies 4294943712
>>    hex dump (first 16 bytes):
>>      3c af 57 72 5b e6 8f ad 6e 8e fd 33 42 39 03 ff  <.Wr[...n..3B9..
>>    backtrace (crc 925f8a80):
>>      kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
>>      slab_post_alloc_hook mm/slub.c:4520 [inline]
>>      slab_alloc_node mm/slub.c:4844 [inline]
>>      __do_kmalloc_node mm/slub.c:5237 [inline]
>>      __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5250
>>      kmalloc_noprof include/linux/slab.h:954 [inline]
>>      fscrypt_setup_filename+0x15e/0x3b0 fs/crypto/fname.c:364
>>      f2fs_setup_filename+0x52/0xb0 fs/f2fs/dir.c:143
>>      f2fs_rename+0x159/0xca0 fs/f2fs/namei.c:961
>>      f2fs_rename2+0xd5/0xf20 fs/f2fs/namei.c:1308
> 
> The following commit added a call to f2fs_setup_filename() without a
> matching call to f2fs_free_filename():
> 
>      commit 40b2d55e045222dd6de2a54a299f682e0f954b03
>      Author: Chao Yu <chao@kernel.org>
>      Date:   Wed Feb 7 15:05:48 2024 +0800
> 
>          f2fs: fix to create selinux label during whiteout initialization
> 
> Chao, do you want to handle fixing this?

Oh, my bad, let me fix this ASAP.

Thanks Eric for the reminder.

Thanks,

> 
> - Eric


