Return-Path: <linux-fscrypt+bounces-610-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A22FCA38B7D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Feb 2025 19:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF74C3AA7E6
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Feb 2025 18:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F2E235BFF;
	Mon, 17 Feb 2025 18:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cY4c2KC2"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537D022A1E6;
	Mon, 17 Feb 2025 18:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739818202; cv=none; b=D83weKJ3hFgTyTWZyoxM2XDLXtAl9EVkWgPNxnZvO+1r7ao3S5i1F9P20+EPFyra0Yxd50bfvTnVHQCxF8gLl4atAta9oRmbEzYPeXOeN7wc9TTKW5v0bAd2bxuHtBG0GhJ+soOXNv/9nrWQGf2TgdHDBlmZM5YGcx1njDf/FWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739818202; c=relaxed/simple;
	bh=bSkaPVIT6VfRE0JIpCa1oHUI1xXQj1fjU7es/My1gRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EjQDnEEJiVnj49vYG+iof/QxY4p9zf2NnQWXrdcTE4Oe0WEvlMsSAPAfP+lSIRYOKgjAjA5HKz6gCgb8+yufBN5yvqH6azAAqCve9NF9K+EvyEEEhLgmpsc2xYYBpIw/wAAUCkmQ8zpuBKlN6tvDN7V4atlwM8+6ftLzwyzK5wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cY4c2KC2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870CCC4CED1;
	Mon, 17 Feb 2025 18:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739818201;
	bh=bSkaPVIT6VfRE0JIpCa1oHUI1xXQj1fjU7es/My1gRM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cY4c2KC24HnubKXjrX0Oxg25o0kMezl+Yqkk1suSt1BWnLHdJxZM5w8PjZRm12lak
	 DVCAMefgBVLG3tNaqjG8wJFCZZtc37AsAsTXSabdrhFjKa/ULzyLolFhkR3HcFzyVT
	 7QZjOeN0Uh3kvvqTO5rCzZ1jSla1YRc5R70ydCJ/C0Sv8YwTsVv2f6hfC3l7zyXrIV
	 Vocghvvv5K9EWGO6dEoLjQ0fJrGmD4wRMNusQI6ePZvFBYM2kdC0E1lFBH9XvsYF0r
	 71sV0zD4FjCp8K0blysR2qUTSfB/mOkbT6Nw5jpXc8EZ3HFSVeFDKzh+THvF/46hc0
	 U5MGuq+iNeQFQ==
Date: Mon, 17 Feb 2025 10:50:00 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Lucas Tanure <tanure@linux.com>
Cc: kernelnewbies <kernelnewbies@kernelnewbies.org>,
	linux-fscrypt@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"krzysztof.opasiak@neat.no" <krzysztof.opasiak@neat.no>,
	"lucas.tanure@neat.no" <lucas.tanure@neat.no>
Subject: Re: crypto: fscrypt: crypto_create_tfm_node memory leak
Message-ID: <20250217185000.GC1258@sol.localdomain>
References: <CAJX_Q+24svAcoyxqcUu4z2g08bJeRFEmzYtVK1paoZ0xBX_uTA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJX_Q+24svAcoyxqcUu4z2g08bJeRFEmzYtVK1paoZ0xBX_uTA@mail.gmail.com>

On Mon, Feb 17, 2025 at 06:43:15PM +0000, Lucas Tanure wrote:
> Hi,
> 
> I am working with Android 13 and V5.15 kernel. During our development,
> I found a memory leak using kmemleak.
> 
> Steps I did to find the memleak:
> mount -t debugfs debugfs /sys/kernel/debug
> echo scan=5 > /sys/kernel/debug/kmemleak
> cat /sys/kernel/debug/kmemleak
> 
> Stack I got (hundreds of them):
> unreferenced object 0xffffff8101d31000 (size 1024):
>   comm "binder:1357_2", pid 1357, jiffies 4294899464 (age 394.468s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffd327cac060>] crypto_create_tfm_node+0x64/0x228
>     [<ffffffd3279f8c4c>] fscrypt_prepare_key+0xbc/0x230
>     [<ffffffd3279f9758>] fscrypt_setup_v1_file_key+0x48c/0x510
>     [<ffffffd3279f8394>] fscrypt_setup_encryption_info+0x210/0x43c
>     [<ffffffd3279f8108>] fscrypt_prepare_new_inode+0x128/0x1a4
>     [<ffffffd327bcc878>] f2fs_new_inode+0x27c/0x89c
>     [<ffffffd327bce7c4>] f2fs_mkdir+0x78/0x278
>     [<ffffffd32796a3bc>] vfs_mkdir+0x138/0x204
>     [<ffffffd32796a108>] do_mkdirat+0x88/0x204
>     [<ffffffd32796a068>] __arm64_sys_mkdirat+0x40/0x58
>     [<ffffffd3274be5d4>] invoke_syscall+0x60/0x150
>     [<ffffffd3274be528>] el0_svc_common+0xc8/0x114
>     [<ffffffd3274be3f0>] do_el0_svc+0x28/0x98
>     [<ffffffd328abcf88>] el0_svc+0x28/0x90
>     [<ffffffd328abcefc>] el0t_64_sync_handler+0x88/0xec
>     [<ffffffd32741164c>] el0t_64_sync+0x1b8/0x1bc
> 
> After checking upstream, I came up with the following:
> cff805b1518f  fscrypt: fix keyring memory leak on mount failure
> 
> But my kernel has this patch. So I continued to dig around this and
> saw the function fscrypt_prepare_key in fs/crypto/keysetup.c for
> V5.15.
> I can't see the pointer tfm being used anywhere or saved, and
> smp_store_release doesn't kfree it.
> Is smp_store_release doing something with that pointer that makes this
> memory leak a false positive?
> 
> Any help with this issue would be much appreciated.
> Thanks

The pointer to the crypto_skcipher 'tfm' is stored in the fscrypt_inode_info
(previously fscrypt_info) which is stored in inode::i_crypt_info.  It gets freed
when the inode is evicted.  I don't know why you're getting a kmemleak warning.
Perhaps f2fs in that version of the kernel has a bug that is leaking inodes.

smp_store_release is just a fancy way of doing a store that includes a memory
barrier.

- Eric

