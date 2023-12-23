Return-Path: <linux-fscrypt+bounces-98-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 866B681D4E3
	for <lists+linux-fscrypt@lfdr.de>; Sat, 23 Dec 2023 16:36:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E0A328324C
	for <lists+linux-fscrypt@lfdr.de>; Sat, 23 Dec 2023 15:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BBADF5C;
	Sat, 23 Dec 2023 15:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NsOv68yv"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272B3DF43
	for <linux-fscrypt@vger.kernel.org>; Sat, 23 Dec 2023 15:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDA3C433C7;
	Sat, 23 Dec 2023 15:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703345790;
	bh=Ho1EszqwI0wE1B1/PMEe80cbefmCuK5iTTKpuBzHd0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NsOv68yv+cb3ou8kcwnUxC8c0MA2UhlsYmJxQdQa7xEJLYP/aTWReGaXvlfYHyTFA
	 GMbpoTp5Hdmv2X43KDuzCFFeYpgaX7VocsElUwZwdD355df38wsWpAQtQBbJdjrt7+
	 T4fXwNWYOnNkAEhc1hhTRBvQycFlvHS09VDi8DCSpeyB8aQbnH/X4o/QKxeWoh7d86
	 1R+5AKjE7RrCj7hrK0VELBSv9MnLWVffjmEmZjxlbAZeeSyT/K/ZzJrN/yboOpsvhz
	 +0+ktFxWt/iz1PH2fCvs+iWjL8zmDpj/Jf5vmGkzZ50LY0JDNLky6GepnoxRV46Tu4
	 o1uDUr2dFeMSw==
Date: Sat, 23 Dec 2023 09:36:25 -0600
From: Eric Biggers <ebiggers@kernel.org>
To: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: richard@nod.at, terrelln@fb.com, linux-fscrypt@vger.kernel.org,
	linux-mtd@lists.infradead.org
Subject: Re: [PATCH v2 2/2] ubifs: ubifs_symlink: Fix memleak of
 inode->i_link in error path
Message-ID: <20231223153625.GC901@quark.localdomain>
References: <20231222085446.781838-1-chengzhihao1@huawei.com>
 <20231222085446.781838-3-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231222085446.781838-3-chengzhihao1@huawei.com>

On Fri, Dec 22, 2023 at 04:54:46PM +0800, Zhihao Cheng wrote:
> For error handling path in ubifs_symlink(), inode will be marked as
> bad first, then iput() is invoked. If inode->i_link is initialized by
> fscrypt_encrypt_symlink() in encryption scenario, inode->i_link won't
> be freed by callchain ubifs_free_inode -> fscrypt_free_inode in error
> handling path, because make_bad_inode() has changed 'inode->i_mode' as
> 'S_IFREG'.
> Following kmemleak is easy to be reproduced by injecting error in
> ubifs_jnl_update() when doing symlink in encryption scenario:
>  unreferenced object 0xffff888103da3d98 (size 8):
>   comm "ln", pid 1692, jiffies 4294914701 (age 12.045s)
>   backtrace:
>    kmemdup+0x32/0x70
>    __fscrypt_encrypt_symlink+0xed/0x1c0
>    ubifs_symlink+0x210/0x300 [ubifs]
>    vfs_symlink+0x216/0x360
>    do_symlinkat+0x11a/0x190
>    do_syscall_64+0x3b/0xe0
> There are two ways fixing it:
>  1. Remove make_bad_inode() in error handling path. We can do that
>     because ubifs_evict_inode() will do same processes for good
>     symlink inode and bad symlink inode, for inode->i_nlink checking
>     is before is_bad_inode().
>  2. Free inode->i_link before marking inode bad.
> Method 2 is picked, it has less influence, personally, I think.
> 
> Cc: stable@vger.kernel.org
> Fixes: 2c58d548f570 ("fscrypt: cache decrypted symlink target in ->i_link")
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  fs/ubifs/dir.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
> index 3b13c648d490..e413a9cf8ee3 100644
> --- a/fs/ubifs/dir.c
> +++ b/fs/ubifs/dir.c
> @@ -1234,6 +1234,8 @@ static int ubifs_symlink(struct mnt_idmap *idmap, struct inode *dir,
>  	dir_ui->ui_size = dir->i_size;
>  	mutex_unlock(&dir_ui->ui_mutex);
>  out_inode:
> +	/* Free inode->i_link before inode is marked as bad. */
> +	fscrypt_free_inode(inode);
>  	make_bad_inode(inode);
>  	iput(inode);
>  out_fname:

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric

