Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3645B0DEB
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 22:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiIGURA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Sep 2022 16:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiIGURA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Sep 2022 16:17:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DF286C03;
        Wed,  7 Sep 2022 13:16:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 874AD2079C;
        Wed,  7 Sep 2022 20:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662581817;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LkLr9uB185Oh2efuA3ed8exqMA+ygv5Np/T9uZScqxA=;
        b=mNmBrt7xE5RRDmij3fmraTnJfxfPptPte6PZixUd5DF/PGsgxZ0qfM/mD+IL/77hzAjzn4
        JE2ig8OhHXSxJh9XifPQWTMcmwl1E2CXkrHDryw1lEcpPsiNB5vL7W1jo5j55Xk4fmtRDk
        r1XQ2bTsUqvoNRrkzCGpJ62Xpzx5Ouw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662581817;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LkLr9uB185Oh2efuA3ed8exqMA+ygv5Np/T9uZScqxA=;
        b=Mt9x8l1PsJkWpVtYNqqrtbamuKk97WAQk0zphHPZL14N/gty5TD1BlsNh8puuf5vMszwdY
        +bsnZNnHh+0r7mBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4832913486;
        Wed,  7 Sep 2022 20:16:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yGutEDn8GGOnPgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 07 Sep 2022 20:16:57 +0000
Date:   Wed, 7 Sep 2022 22:11:34 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 11/20] btrfs: disable various operations on encrypted
 inodes
Message-ID: <20220907201133.GJ32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <927dbeab576537ac0e4c954a8c3d13b148cd6a26.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <927dbeab576537ac0e4c954a8c3d13b148cd6a26.1662420176.git.sweettea-kernel@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:26PM -0400, Sweet Tea Dorminy wrote:
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1895,7 +1895,7 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  		goto relock;
>  	}
>  
> -	if (check_direct_IO(fs_info, from, pos)) {
> +	if (IS_ENCRYPTED(inode) || check_direct_IO(fs_info, from, pos)) {

I'm not sure if we want the IS_ENCRYPTED as an explicit check or put it
to check_direct_IO, but probably to make it obvious that direct io does
not work with it a separate check is ok.

>  		btrfs_inode_unlock(inode, ilock_flags);
>  		goto buffered;
>  	}
> @@ -3729,7 +3729,7 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
>  	ssize_t read = 0;
>  	ssize_t ret;
>  
> -	if (fsverity_active(inode))
> +	if (IS_ENCRYPTED(inode) || fsverity_active(inode))

Yeah as we have something similar for verity.

>  		return 0;
>  
>  	if (check_direct_read(btrfs_sb(inode->i_sb), to, iocb->ki_pos))
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 482c5b3d9e70..fea48c12a33a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -409,7 +409,8 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
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
> index 9acf47b11fe6..d22086e1cbc8 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -805,6 +805,13 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  		ASSERT(inode_in->i_sb == inode_out->i_sb);
>  	}
>  
> +	/*
> +	 * Can only reflink encrypted files if both files are encrypted.
> +	 */

The comment fits on one line (and slight 80 chars overflow is ok).

> +	if (!fscrypt_have_same_policy(inode_in, inode_out)) {
> +		return -EINVAL;

Single statements don't need the { }

> +	}
> +
