Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F6411E242
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2019 11:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfLMKq1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Dec 2019 05:46:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:57768 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725945AbfLMKq1 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Dec 2019 05:46:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B1A65AD77;
        Fri, 13 Dec 2019 10:46:25 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 883CE1E0CAF; Fri, 13 Dec 2019 11:46:25 +0100 (CET)
Date:   Fri, 13 Dec 2019 11:46:25 +0100
From:   Jan Kara <jack@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] ext4: remove unnecessary ifdefs in
 htree_dirblock_to_tree()
Message-ID: <20191213104625.GC15474@quack2.suse.cz>
References: <20191209213225.18477-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209213225.18477-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon 09-12-19 13:32:25, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The ifdefs for CONFIG_FS_ENCRYPTION in htree_dirblock_to_tree() are
> unnecessary, as the called functions are already stubbed out when
> !CONFIG_FS_ENCRYPTION.  Remove them.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/namei.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index a856997d87b54..d4c2cc73fe71d 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1002,7 +1002,6 @@ static int htree_dirblock_to_tree(struct file *dir_file,
>  	top = (struct ext4_dir_entry_2 *) ((char *) de +
>  					   dir->i_sb->s_blocksize -
>  					   EXT4_DIR_REC_LEN(0));
> -#ifdef CONFIG_FS_ENCRYPTION
>  	/* Check if the directory is encrypted */
>  	if (IS_ENCRYPTED(dir)) {
>  		err = fscrypt_get_encryption_info(dir);
> @@ -1017,7 +1016,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
>  			return err;
>  		}
>  	}
> -#endif
> +
>  	for (; de < top; de = ext4_next_entry(de, dir->i_sb->s_blocksize)) {
>  		if (ext4_check_dir_entry(dir, NULL, de, bh,
>  				bh->b_data, bh->b_size,
> @@ -1065,9 +1064,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
>  	}
>  errout:
>  	brelse(bh);
> -#ifdef CONFIG_FS_ENCRYPTION
>  	fscrypt_fname_free_buffer(&fname_crypto_str);
> -#endif
>  	return count;
>  }
>  
> -- 
> 2.24.0.393.g34dc348eaf-goog
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
