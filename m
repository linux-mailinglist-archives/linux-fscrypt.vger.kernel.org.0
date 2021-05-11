Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E73F37AF46
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 May 2021 21:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhEKTYS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 May 2021 15:24:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:36476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231981AbhEKTYR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 May 2021 15:24:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B7ACFB19F;
        Tue, 11 May 2021 19:23:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 50C7EDAF29; Tue, 11 May 2021 21:20:40 +0200 (CEST)
Date:   Tue, 11 May 2021 21:20:40 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v4 2/5] btrfs: initial fsverity support
Message-ID: <20210511192039.GM7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1620240133.git.boris@bur.io>
 <dd0cfc38c6de927de63f34f96499dc8f80398754.1620241221.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd0cfc38c6de927de63f34f96499dc8f80398754.1620241221.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 05, 2021 at 12:20:40PM -0700, Boris Burkov wrote:

> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d89000577f7f..1b1101369777 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9041,6 +9045,7 @@ static int btrfs_getattr(struct user_namespace *mnt_userns,
>  	struct inode *inode = d_inode(path->dentry);
>  	u32 blocksize = inode->i_sb->s_blocksize;
>  	u32 bi_flags = BTRFS_I(inode)->flags;
> +	u32 bi_compat_flags = BTRFS_I(inode)->compat_flags;

This is u64 -> u32, not a problem at the moment but the type width
should match.

>  
>  	stat->result_mask |= STATX_BTIME;
>  	stat->btime.tv_sec = BTRFS_I(inode)->i_otime.tv_sec;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ff335c192170..4b8f38fe4226 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -105,6 +106,7 @@ static unsigned int btrfs_mask_fsflags_for_type(struct inode *inode,
>  static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
>  {
>  	unsigned int flags = binode->flags;
> +	unsigned int compat_flags = binode->compat_flags;

And same here.

>  	unsigned int iflags = 0;
>  
>  	if (flags & BTRFS_INODE_SYNC)
