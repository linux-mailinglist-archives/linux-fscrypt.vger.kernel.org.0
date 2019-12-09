Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E669F11794C
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 23:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfLIW23 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 17:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbfLIW23 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 17:28:29 -0500
Received: from localhost (unknown [104.132.0.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C887220637;
        Mon,  9 Dec 2019 22:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575930508;
        bh=P0iEsLxI1uweiGSusdApFJh0pwecHJrFeTNlNQl9mUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VFfW2H5I8LgDzPwwvAI+t7g4kiU8Q7z47aLRBiKlqqwtyluFQJyMx+DobL4WxYQAz
         GFxqp+VcU5MPg/ApgL9Uq+ZPnWymht9ZQLhvTHJ7XpGgw0XtFIgDbSll6zQcbWX9Jr
         mTe5gEVXG5YzLSQarjOE7x4FDdE5CyvD2rqK39UM=
Date:   Mon, 9 Dec 2019 14:28:28 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] f2fs: don't keep META_MAPPING pages used for moving
 verity file blocks
Message-ID: <20191209222828.GA798@jaegeuk-macbookpro.roam.corp.google.com>
References: <20191209200055.204040-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209200055.204040-1-ebiggers@kernel.org>
User-Agent: Mutt/1.8.2 (2017-04-18)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 12/09, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> META_MAPPING is used to move blocks for both encrypted and verity files.
> So the META_MAPPING invalidation condition in do_checkpoint() should
> consider verity too, not just encrypt.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/f2fs/checkpoint.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index ffdaba0c55d29..44e84ac5c9411 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -1509,10 +1509,10 @@ static int do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
>  	f2fs_wait_on_all_pages_writeback(sbi);
>  
>  	/*
> -	 * invalidate intermediate page cache borrowed from meta inode
> -	 * which are used for migration of encrypted inode's blocks.
> +	 * invalidate intermediate page cache borrowed from meta inode which are
> +	 * used for migration of encrypted or verity inode's blocks.
>  	 */
> -	if (f2fs_sb_has_encrypt(sbi))
> +	if (f2fs_sb_has_encrypt(sbi) || f2fs_sb_has_verity(sbi))

Do we need f2fs_post_read_required() aligned to the condition of
move_data_block()?

>  		invalidate_mapping_pages(META_MAPPING(sbi),
>  				MAIN_BLKADDR(sbi), MAX_BLKADDR(sbi) - 1);
>  
> -- 
> 2.24.0.393.g34dc348eaf-goog
