Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B132A9B3B
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Nov 2020 18:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgKFRwI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 6 Nov 2020 12:52:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbgKFRwI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 6 Nov 2020 12:52:08 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C12C206F4;
        Fri,  6 Nov 2020 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604685127;
        bh=+rTplTiRHCg1rSJZZILvtbrGwQkXqYXlY1s1r0lYRj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F+nspiyMoaHUdjgkHdvyFN7TjbEJuDH6E5/gsmZuQpTJ6Mks2/ZX4fEULddQILtyV
         C7jt0GUYyptvY1wCY7opIUGuK05/rWJKZ2Nq2AKh4tIxtV2snaP7LPmb7Zl/GVdo80
         PcEgKyh7Eeuuc2cdyoVGCZzROsapb3faNVR4/9Wg=
Date:   Fri, 6 Nov 2020 09:52:05 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] fs/inode.c: make inode_init_always() initialize i_ino to
 0
Message-ID: <20201106175205.GE845@sol.localdomain>
References: <20201031004420.87678-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031004420.87678-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Oct 30, 2020 at 05:44:20PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Currently inode_init_always() doesn't initialize i_ino to 0.  This is
> unexpected because unlike the other inode fields that aren't initialized
> by inode_init_always(), i_ino isn't guaranteed to end up back at its
> initial value after the inode is freed.  Only one filesystem (XFS)
> actually sets set i_ino back to 0 when freeing its inodes.
> 
> So, callers of new_inode() see some random previous i_ino.  Normally
> that's fine, since normally i_ino isn't accessed before being set.
> There can be edge cases where that isn't necessarily true, though.
> 
> The one I've run into is that on ext4, when creating an encrypted file,
> the new file's encryption key has to be set up prior to the jbd2
> transaction, and thus prior to i_ino being set.  If something goes
> wrong, fs/crypto/ may log warning or error messages, which normally
> include i_ino.  So it needs to know whether it is valid to include i_ino
> yet or not.  Also, on some files i_ino needs to be hashed for use in the
> crypto, so fs/crypto/ needs to know whether that can be done yet or not.
> 
> There are ways this could be worked around, either in fs/crypto/ or in
> fs/ext4/.  But, it seems there's no reason not to just fix
> inode_init_always() to do the expected thing and initialize i_ino to 0.
> 
> So, do that, and also remove the initialization in jfs_fill_super() that
> becomes redundant.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/inode.c     | 1 +
>  fs/jfs/super.c | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 9d78c37b00b81..eb001129f157c 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -142,6 +142,7 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
>  	atomic_set(&inode->i_count, 1);
>  	inode->i_op = &empty_iops;
>  	inode->i_fop = &no_open_fops;
> +	inode->i_ino = 0;
>  	inode->__i_nlink = 1;
>  	inode->i_opflags = 0;
>  	if (sb->s_xattr)
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index b2dc4d1f9dcc5..1f0ffabbde566 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -551,7 +551,6 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
>  		ret = -ENOMEM;
>  		goto out_unload;
>  	}
> -	inode->i_ino = 0;
>  	inode->i_size = i_size_read(sb->s_bdev->bd_inode);
>  	inode->i_mapping->a_ops = &jfs_metapage_aops;
>  	inode_fake_hash(inode);
> 

Al, any thoughts on this?

- Eric
