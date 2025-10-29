Return-Path: <linux-fscrypt+bounces-886-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 099F8C1C626
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 Oct 2025 18:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD8963A88D7
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 Oct 2025 16:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8590C27F18F;
	Wed, 29 Oct 2025 16:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTbC4gtW"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BD01E2307
	for <linux-fscrypt@vger.kernel.org>; Wed, 29 Oct 2025 16:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761756588; cv=none; b=n46aHy/VNCh8C76KmVT4YiBaRrIUPYq/0divqG/8lmmfGYzntRAGXxR585lBE+PALoaqDbBP74DOuwh8z2+OQxkYqN5ICS+kIl5nMUCYK9ihfK5451P9vF0VRJIKEF1EQ5ZW0UHNzAn8+FbuEw2XXiyDzWD3vWWdOpavhoCYQ0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761756588; c=relaxed/simple;
	bh=Ly1GWOcTBi8u/bNxsCTEKc/WWTszHOhKqFWG70xMA/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvUqghSMy9K0nK0CJmY4Y8bUFv58OwaaYHJT5a3YMOnIM18vdPC27h9DG7lnB/WjvJTsYlKQjfGlEyJF2w5nNBT3Gl8xTKp370+s3Z4B78mgyBbD9ElvB3s7fn5qWEO/k4q7IcCMt5IYmgOy3nfUxzH1v9mywr44EeX8XlJ4h8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTbC4gtW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CE6C4CEF7;
	Wed, 29 Oct 2025 16:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761756587;
	bh=Ly1GWOcTBi8u/bNxsCTEKc/WWTszHOhKqFWG70xMA/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CTbC4gtWjcFpehFqKbgVdhDaVBNmHZdn+LtxSnXfypncIhxhQj1LxRbZUvPO35lSa
	 2ZqKJQPiNpdvS+8TzBARDeKcv3LnkiFGb2rs3o3e9BUhosY3cDLa59jH7XpgvY0b+7
	 Kx+DDu8Tr3hcFMd07n8cvXETo7B1+FqqnLD5+uVd8PmpQimEj7XDh3KObTLDY0ApyN
	 a1hY1widqB66u/BJUvH6b27G7uHqGub4QGcSXJSSGr0wTwJXExs8lw6eS4xdw4Xoq2
	 7LNUU9F3dMj3dGIPSdbB/8wEvM36EqN9BLDLvi6oVKq/SpzCe8husUWMMF0c+rhLHp
	 piKYsarHTt0IA==
Date: Wed, 29 Oct 2025 09:48:10 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Yongpeng Yang <yangyongpeng.storage@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	linux-fscrypt@vger.kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: Re: [PATCH] fscrypt: fix left shift underflow when inode->i_blkbits
 > PAGE_SHIFT
Message-ID: <20251029164810.GB1603@sol>
References: <20251029130608.331477-1-yangyongpeng.storage@gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029130608.331477-1-yangyongpeng.storage@gmail.com>

On Wed, Oct 29, 2025 at 09:06:08PM +0800, Yongpeng Yang wrote:
> From: Yongpeng Yang <yangyongpeng@xiaomi.com>
> 
> When simulating an nvme device on qemu with both logical_block_size and
> physical_block_size set to 8 KiB, a error trace appears during partition
> table reading at boot time. The issue is caused by inode->i_blkbits being
> larger than PAGE_SHIFT, which leads to a left shift of -1 and triggering a
> UBSAN warning.
> 
> [    2.697306] ------------[ cut here ]------------
> [    2.697309] UBSAN: shift-out-of-bounds in fs/crypto/inline_crypt.c:336:37
> [    2.697311] shift exponent -1 is negative
> [    2.697315] CPU: 3 UID: 0 PID: 274 Comm: (udev-worker) Not tainted 6.18.0-rc2+ #34 PREEMPT(voluntary)
> [    2.697317] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [    2.697320] Call Trace:
> [    2.697324]  <TASK>
> [    2.697325]  dump_stack_lvl+0x76/0xa0
> [    2.697340]  dump_stack+0x10/0x20
> [    2.697342]  __ubsan_handle_shift_out_of_bounds+0x1e3/0x390
> [    2.697351]  bh_get_inode_and_lblk_num.cold+0x12/0x94
> [    2.697359]  fscrypt_set_bio_crypt_ctx_bh+0x44/0x90
> [    2.697365]  submit_bh_wbc+0xb6/0x190
> [    2.697370]  block_read_full_folio+0x194/0x270
> [    2.697371]  ? __pfx_blkdev_get_block+0x10/0x10
> [    2.697375]  ? __pfx_blkdev_read_folio+0x10/0x10
> [    2.697377]  blkdev_read_folio+0x18/0x30
> [    2.697379]  filemap_read_folio+0x40/0xe0
> [    2.697382]  filemap_get_pages+0x5ef/0x7a0
> [    2.697385]  ? mmap_region+0x63/0xd0
> [    2.697389]  filemap_read+0x11d/0x520
> [    2.697392]  blkdev_read_iter+0x7c/0x180
> [    2.697393]  vfs_read+0x261/0x390
> [    2.697397]  ksys_read+0x71/0xf0
> [    2.697398]  __x64_sys_read+0x19/0x30
> [    2.697399]  x64_sys_call+0x1e88/0x26a0
> [    2.697405]  do_syscall_64+0x80/0x670
> [    2.697410]  ? __x64_sys_newfstat+0x15/0x20
> [    2.697414]  ? x64_sys_call+0x204a/0x26a0
> [    2.697415]  ? do_syscall_64+0xb8/0x670
> [    2.697417]  ? irqentry_exit_to_user_mode+0x2e/0x2a0
> [    2.697420]  ? irqentry_exit+0x43/0x50
> [    2.697421]  ? exc_page_fault+0x90/0x1b0
> [    2.697422]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [    2.697425] RIP: 0033:0x75054cba4a06
> [    2.697426] Code: 5d e8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 75 19 83 e2 39 83 fa 08 75 11 e8 26 ff ff ff 66 0f 1f 44 00 00 48 8b 45 10 0f 05 <48> 8b 5d f8 c9 c3 0f 1f 40 00 f3 0f 1e fa 55 48 89 e5 48 83 ec 08
> [    2.697427] RSP: 002b:00007fff973723a0 EFLAGS: 00000202 ORIG_RAX: 0000000000000000
> [    2.697430] RAX: ffffffffffffffda RBX: 00005ea9a2c02760 RCX: 000075054cba4a06
> [    2.697432] RDX: 0000000000002000 RSI: 000075054c190000 RDI: 000000000000001b
> [    2.697433] RBP: 00007fff973723c0 R08: 0000000000000000 R09: 0000000000000000
> [    2.697434] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
> [    2.697434] R13: 00005ea9a2c027c0 R14: 00005ea9a2be5608 R15: 00005ea9a2be55f0
> [    2.697436]  </TASK>
> [    2.697436] ---[ end trace ]---
> 
> Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
> ---
>  fs/crypto/inline_crypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
> index 5dee7c498bc8..6beb5f490612 100644
> --- a/fs/crypto/inline_crypt.c
> +++ b/fs/crypto/inline_crypt.c
> @@ -333,7 +333,7 @@ static bool bh_get_inode_and_lblk_num(const struct buffer_head *bh,
>  	inode = mapping->host;
>  
>  	*inode_ret = inode;
> -	*lblk_num_ret = ((u64)folio->index << (PAGE_SHIFT - inode->i_blkbits)) +
> +	*lblk_num_ret = (((u64)folio->index << PAGE_SHIFT) >> inode->i_blkbits) +
>  			(bh_offset(bh) >> inode->i_blkbits);
>  	return true;

Looks good, but could you clarify in the commit message that this issue
doesn't occur on an encrypted file but rather a block device inode?
fscrypt_set_bio_crypt_ctx_bh() runs the above code before checking
IS_ENCRYPTED(), so that's why it was reached.

Otherwise the patch seems surprising, since i_blkbits > PAGE_SHIFT isn't
a case that is supported on encrypted files yet at all.

- Eric

