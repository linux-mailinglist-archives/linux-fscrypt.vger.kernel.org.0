Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFB374BA12
	for <lists+linux-fscrypt@lfdr.de>; Sat,  8 Jul 2023 01:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjGGXhQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 7 Jul 2023 19:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGGXhP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 7 Jul 2023 19:37:15 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB3A210B;
        Fri,  7 Jul 2023 16:37:14 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 53AC75C0092;
        Fri,  7 Jul 2023 19:37:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 07 Jul 2023 19:37:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1688773034; x=1688859434; bh=QF
        KkZ42Oa0NCInHkVTSfJ7m2sKCTgrV9e/fb7epwRDE=; b=SY12sPDICkuBHYMNoi
        RTTNO67APMrsD8pWiyrfjBzaBDzGoVoRUDiIdCwd7TrziOyGBFDvlvO9AkSZ1nLT
        SA3EMdQ5R72dkfTAYOpwHaJ3XX6nJkwFYrQzKiNRFqmIqxpXZLglK8Y38R+u0wsB
        uWr0nM29m09wxb91qXPnSqEnR6lrDxQOFkXLKJj831Yq98MNmMxBcL9ed+FxxJKv
        XM13DtH+9ap2tjQJvHBrW9a6I4heCR/Tv6FBddF+H+BwuNIl1qshmrCbBUODtXr3
        whpCOTqzylHxAEcX82MN6a1oyb8VFhUH7qzTLkakDKGvJovdIrItouuONZ0G6iO8
        aU4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1688773034; x=1688859434; bh=QFKkZ42Oa0NCI
        nHkVTSfJ7m2sKCTgrV9e/fb7epwRDE=; b=Y+kPQCKJWa5Xgo+DeVO6QO43CqVn9
        EDvdATyAe8eO36OIgctUp10nDQxh+Z+At1824Qy6XFtDyeqK0fQqYeWBGG1zraAt
        81D8g272vwQMKRn3V+tbTMCVI+gDSkmVRjn3VC5qIPbLwO8J7gU4sQoyeV2D3IPb
        S2ps3yxExBuWZMWFJ4+qk2ISgpUvWTYuBUQxTXsfaWr/W1pySFsl2Grpq7JL3Liq
        KAY8puNOohZ6zcZn4++3UVXPUJgU03fV+AKQDtuCTFZ5qSq/3yYBqJ6SqxrDvGgA
        /3lvnTo6W+RzkexGY3xMMq6068s7wMXsh6EuXuBrbIVvHoFlCMfjjpJig==
X-ME-Sender: <xms:qqGoZI9hz1wCQWdMK_OecxugsRiBRGds8KnUylbqxNXrGv1mGT0JlQ>
    <xme:qqGoZAsgvQ_bG_ShSWKTnDY34yn86u3R28l3sqC4fcP7rS52_gwpBsM80VSYMmYwt
    COZAuOO7959S3pXWnw>
X-ME-Received: <xmr:qqGoZODe1Kk26K--3AhC_rfLKfyGxyNAfoDjHCPrvxeVsglEpFcIITL07Z-ZhaP7TzKixoQjrWjKBY0pMUwhnOvX61s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrvddvgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepke
    dvkeffjeellefhveehvdejudfhjedthfdvveeiieeiudfguefgtdejgfefleejnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihho
X-ME-Proxy: <xmx:qqGoZIeRQ4ugkfyFCt56x03xBBuKOKGbQOCceTxMwu4G15q5GzfOeA>
    <xmx:qqGoZNMEPHc9xxM68ccwK5VbsJLJX6mmknmva_mv5ZO6qUxz0FPh6Q>
    <xmx:qqGoZCk8Tp5e6uGBBhQGnIZs5579mESg17XoGURJDtUE8_s87AC3ow>
    <xmx:qqGoZAoijJEeq0829sI6dXQj0cKHE4mwmvymcd-V6DaNDkRHE5HHfQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Jul 2023 19:37:13 -0400 (EDT)
Date:   Fri, 7 Jul 2023 16:36:05 -0700
From:   Boris Burkov <boris@bur.io>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v1 01/17] btrfs: disable various operations on encrypted
 inodes
Message-ID: <20230707233605.GB2579580@zen>
References: <cover.1687988380.git.sweettea-kernel@dorminy.me>
 <e7785ffe237e581a7ba7e45d2724fca4d8fa1470.1687988380.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7785ffe237e581a7ba7e45d2724fca4d8fa1470.1687988380.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 28, 2023 at 08:35:24PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> Initially, only normal data extents, using the normal (non-direct) IO
> path, will be encrypted. This change forbids various other bits:
> - allows reflinking only if both inodes have the same encryption status
> - disables direct IO on encrypted inodes
> - disable inline data on encrypted inodes
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/file.c    | 4 ++--
>  fs/btrfs/inode.c   | 3 ++-
>  fs/btrfs/reflink.c | 7 +++++++
>  3 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 392bc7d512a0..354962a7dd72 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1502,7 +1502,7 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  		goto relock;
>  	}
>  
> -	if (check_direct_IO(fs_info, from, pos)) {
> +	if (IS_ENCRYPTED(inode) || check_direct_IO(fs_info, from, pos)) {
>  		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
>  		goto buffered;
>  	}
> @@ -3741,7 +3741,7 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
>  	ssize_t read = 0;
>  	ssize_t ret;
>  
> -	if (fsverity_active(inode))
> +	if (IS_ENCRYPTED(inode) || fsverity_active(inode))

What's different about fscrypt vs fsverity that makes the inode flag a
good check for encryption while verity relies on the presence of the
extra context metadata?

Is the enable model not subject to the same race where S_VERITY gets set
ahead of actually storing the verity info/item?

I think it's fine for these "skip" cases, but I imagine if we have cases
of "I want a fully ready encrypted file" the verity-style check could be
better?

>  		return 0;
>  
>  	if (check_direct_read(btrfs_sb(inode->i_sb), to, iocb->ki_pos))
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index dbbb67293e34..48eadc4f187f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -630,7 +630,8 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
>  	 * compressed) data fits in a leaf and the configured maximum inline
>  	 * size.
>  	 */
> -	if (size < i_size_read(&inode->vfs_inode) ||
> +	if (IS_ENCRYPTED(&inode->vfs_inode) ||
> +	    size < i_size_read(&inode->vfs_inode) ||
>  	    size > fs_info->sectorsize ||
>  	    data_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info) ||
>  	    data_len > fs_info->max_inline)
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index 0474bbe39da7..ad722f495c9b 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
>  #include <linux/blkdev.h>
> +#include <linux/fscrypt.h>
>  #include <linux/iversion.h>
>  #include "ctree.h"
>  #include "fs.h"
> @@ -811,6 +812,12 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  		ASSERT(inode_in->i_sb == inode_out->i_sb);
>  	}
>  
> +	/*
> +	 * Can only reflink encrypted files if both files are encrypted.
> +	 */
> +	if (IS_ENCRYPTED(inode_in) != IS_ENCRYPTED(inode_out))
> +		return -EINVAL;
> +
>  	/* Don't make the dst file partly checksummed */
>  	if ((BTRFS_I(inode_in)->flags & BTRFS_INODE_NODATASUM) !=
>  	    (BTRFS_I(inode_out)->flags & BTRFS_INODE_NODATASUM)) {
> -- 
> 2.40.1
> 
