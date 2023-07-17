Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198CC756BA4
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 20:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjGQSQ2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 14:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbjGQSQ1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 14:16:27 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E086719B1
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 11:16:01 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 6a1803df08f44-635dbfa710dso24505226d6.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 11:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689617727; x=1692209727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y7ZEW/qRr/ByqzTO3guAxRbpShL1xhzFa0e7F/HD/BE=;
        b=wB9tbU9sMRiYH6+KoN4+euzY5P81TfNCy480NlcFrdjxW/FWkRiZeeNJb+tut9qazS
         WUAr8fbF0hPazDIQzS/SQ5kdbgIIkNq+mE1ab1+i1DH3vZ76NuQ/jefsXgylbQlkN/Z4
         wLrPl3KPinoVU2++7lCyfew9IVgpCZ4m+8VWyuK9wak0GstE7Ne7LqmxoFMToMcwYMn/
         yiwKZ76r+gXdm0gVJBM9YNMHCJ5TF3PePVBiZl/GK4WdOS69tyz63tWRsYh12iWD4uGw
         2mp6f/cr8giWqhlSUsbY59ylDFzsqWQ606h8hQ0IHSOEHq8VmapuICirYUEW8uhzlKFp
         QX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689617727; x=1692209727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y7ZEW/qRr/ByqzTO3guAxRbpShL1xhzFa0e7F/HD/BE=;
        b=APxHO6TbbVuR+Nbr9lfBKXt4IJez/reO7QW4vMKfGab1On+Ip+XD2lV6j/+qWRfPrK
         r3wIWMA6teKoQtobN3A0cDpIW7GJznh7CMN2t+EWeshoOGdV/woWYdIqp30f9s1nqgai
         R+kKGdWXi92DY/aYWZJmwtsUd0BiQn1gQ2zt1nWYEW9sPafmsTFrh2dOw7GWXtKMwIV8
         4QKec2VuG1vrv+hJraUtGBX44GO2+V4nXU/HlqN+bdtjyFkv66N/JTv1kTLj6RI5/F2Y
         ODjqljIXJAWOA3SnFKDRpStADPTUW/CpbeTkJMY+oWTJ0PNxDgkSG1N4qxZqIv564RN0
         sQkw==
X-Gm-Message-State: ABy/qLZ29OAEg5xfIdpD6/P1T3oa9YTximalnnQikRZbcWAonijkxMsI
        GzGlfqRXob/I19oKlsWbIIr7DQ==
X-Google-Smtp-Source: APBJJlG8lR6V1ipakmcCY7FZXnw6VbOluS5K3G1gmUA2/JEq+lVjCfxxtK5XvZetorDVLDuFJ2B54Q==
X-Received: by 2002:a0c:b2c8:0:b0:635:84a1:7d5a with SMTP id d8-20020a0cb2c8000000b0063584a17d5amr9562351qvf.11.1689617726716;
        Mon, 17 Jul 2023 11:15:26 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id p3-20020a0c9a03000000b006263a9e7c63sm78233qvd.104.2023.07.17.11.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 11:15:26 -0700 (PDT)
Date:   Mon, 17 Jul 2023 14:15:25 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 17/17] btrfs: save and load fscrypt extent contexts
Message-ID: <20230717181525.GQ691303@perftesting>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
 <d3849d039673b6583291c29c5d36140357e1f1dc.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3849d039673b6583291c29c5d36140357e1f1dc.1689564024.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 16, 2023 at 11:52:48PM -0400, Sweet Tea Dorminy wrote:
> This change actually saves and loads the extent contexts created and
> freed by the last change.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/file-item.c            | 21 ++++++++++++++++
>  fs/btrfs/fscrypt.c              | 36 +++++++++++++++++++++++++++
>  fs/btrfs/fscrypt.h              |  6 +++++
>  fs/btrfs/inode.c                | 44 ++++++++++++++++++++++++++++++---
>  fs/btrfs/tree-log.c             | 24 ++++++++++++++++--
>  include/uapi/linux/btrfs_tree.h |  5 ++++
>  6 files changed, 130 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 8095fc2e7ca1..ccc2d12faba3 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -1302,6 +1302,27 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
>  
>  		ctxsize = btrfs_file_extent_ctxsize_from_item(leaf, path);
>  		ASSERT(ctxsize == btrfs_file_extent_encryption_ctxsize(leaf, fi));
> +
> +#ifdef CONFIG_FS_ENCRYPTION
> +		if (ctxsize) {
> +			u8 context[FSCRYPT_SET_CONTEXT_MAX_SIZE];
> +			int res;
> +			unsigned int nofs_flag;
> +
> +			read_extent_buffer(leaf, context,
> +					   (unsigned long)fi->fscrypt_context,
> +					   ctxsize);
> +			nofs_flag = memalloc_nofs_save();
> +			res = fscrypt_load_extent_info(&inode->vfs_inode,
> +						       context, ctxsize,
> +						       &em->fscrypt_info);
> +			memalloc_nofs_restore(nofs_flag);
> +			if (res)
> +				btrfs_err(fs_info,
> +					  "Unable to load fscrypt info: %d",
> +					   res);
> +		}
> +#endif /* CONFIG_FS_ENCRYPTION */
>  	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
>  		em->block_start = EXTENT_MAP_INLINE;
>  		em->start = extent_start;
> diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> index 6875108f4363..30dab7d06589 100644
> --- a/fs/btrfs/fscrypt.c
> +++ b/fs/btrfs/fscrypt.c
> @@ -166,6 +166,41 @@ static bool btrfs_fscrypt_empty_dir(struct inode *inode)
>  	return inode->i_size == BTRFS_EMPTY_DIR_SIZE;
>  }
>  
> +int btrfs_fscrypt_get_extent_info(const struct inode *inode,
> +				  u64 lblk_num,
> +				  struct fscrypt_info **info_ptr,
> +				  u64 *extent_offset,
> +				  u64 *extent_length)
> +{
> +	u64 offset = lblk_num << inode->i_blkbits;
> +	struct extent_map *em;
> +
> +	/* Since IO must be in progress on this extent, this must succeed */
> +	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, PAGE_SIZE);
> +	if (!em)
> +		return -EINVAL;
> +
> +	if (em->block_start == EXTENT_MAP_HOLE) {
> +		btrfs_info(BTRFS_I(inode)->root->fs_info,
> +			   "extent context requested for block %llu of inode %lu without an extent",
> +			   lblk_num, inode->i_ino);
> +		free_extent_map(em);
> +		return -ENOENT;
> +	}
> +
> +	*info_ptr = em->fscrypt_info;
> +
> +	if (extent_offset)
> +		*extent_offset
> +			 = (offset - em->start) >> inode->i_blkbits;
> +
> +	if (extent_length)
> +		*extent_length = em->len >> inode->i_blkbits;
> +
> +	free_extent_map(em);
> +	return 0;
> +}
> +
>  static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
>  						       unsigned int *num_devs)
>  {
> @@ -206,6 +241,7 @@ const struct fscrypt_operations btrfs_fscrypt_ops = {
>  	.get_context = btrfs_fscrypt_get_context,
>  	.set_context = btrfs_fscrypt_set_context,
>  	.empty_dir = btrfs_fscrypt_empty_dir,
> +	.get_extent_info = btrfs_fscrypt_get_extent_info,
>  	.get_devices = btrfs_fscrypt_get_devices,
>  	.key_prefix = "btrfs:"
>  };
> diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
> index 2d405d54cbc7..1cab721a64e5 100644
> --- a/fs/btrfs/fscrypt.h
> +++ b/fs/btrfs/fscrypt.h
> @@ -50,6 +50,12 @@ static inline bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
>  }
>  #endif /* CONFIG_FS_ENCRYPTION */
>  
> +int btrfs_fscrypt_get_extent_info(const struct inode *inode,
> +				  u64 lblk_num,
> +				  struct fscrypt_info **info_ptr,
> +				  u64 *extent_offset,
> +				  u64 *extent_length);
> +
>  extern const struct fscrypt_operations btrfs_fscrypt_ops;
>  
>  #endif /* BTRFS_FSCRYPT_H */
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 83098779dad2..92a193785a21 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3036,17 +3036,46 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>  	u64 num_bytes = btrfs_stack_file_extent_num_bytes(stack_fi);
>  	u64 ram_bytes = btrfs_stack_file_extent_ram_bytes(stack_fi);
>  	struct btrfs_drop_extents_args drop_args = { 0 };
> -	size_t fscrypt_context_size =
> -		btrfs_stack_file_extent_encryption(stack_fi) ?
> -			FSCRYPT_SET_CONTEXT_MAX_SIZE : 0;
> +	size_t fscrypt_context_size = 0;
> +#ifdef CONFIG_FS_ENCRYPTION
> +	u8 context[FSCRYPT_SET_CONTEXT_MAX_SIZE];
> +#endif /* CONFIG_FS_ENCRYPTION */
> +
>  	int ret;
>  
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		return -ENOMEM;
>  
> +#ifdef CONFIG_FS_ENCRYPTION
> +	if (IS_ENCRYPTED(&inode->vfs_inode)) {
> +		u8 encryption;
> +		struct fscrypt_info *fscrypt_info;
> +		u64 lblk_num = file_pos >> root->fs_info->sectorsize_bits;
> +
> +		ret = btrfs_fscrypt_get_extent_info(&inode->vfs_inode,
> +						    lblk_num, &fscrypt_info,
> +						    NULL, NULL);
> +		if (ret) {
> +			btrfs_err(root->fs_info, "No fscrypt context found");
> +			goto out;
> +		}
> +
> +		fscrypt_context_size =
> +			fscrypt_set_extent_context(fscrypt_info, context,
> +						   FSCRYPT_SET_CONTEXT_MAX_SIZE);
> +		if (fscrypt_context_size < 0) {
> +			ret = fscrypt_context_size;
> +			goto out;
> +		}
> +		encryption = btrfs_pack_encryption(BTRFS_ENCRYPTION_FSCRYPT,
> +						   fscrypt_context_size);
> +		btrfs_set_stack_file_extent_encryption(stack_fi, encryption);
> +	}
> +#endif /* CONFIG_FS_ENCRYPTION */

Make this into a helper so we're not cluttering the normal code path with the
ifdefs.

> +
>  	/*
> -	 * we may be replacing one extent in the tree with another.
> +	 * We may be replacing one extent in the tree with another.
>  	 * The new extent is pinned in the extent map, and we don't want
>  	 * to drop it from the cache until it is completely in the btree.
>  	 *
> @@ -3079,6 +3108,13 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>  			btrfs_item_ptr_offset(leaf, path->slots[0]),
>  			sizeof(struct btrfs_file_extent_item));
>  
> +#ifdef CONFIG_FS_ENCRYPTION
> +	write_extent_buffer(leaf, context,
> +			    btrfs_item_ptr_offset(leaf, path->slots[0]) +
> +			    sizeof(struct btrfs_file_extent_item),
> +			    fscrypt_context_size);
> +#endif /* CONFIG_FS_ENCRYPTION */
> +
>  	btrfs_mark_buffer_dirty(leaf);
>  	btrfs_release_path(path);
>  
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 82c91097672b..f0ad281170c5 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -4634,8 +4634,22 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
>  	u64 extent_offset = em->start - em->orig_start;
>  	u64 block_len;
>  	int ret;
> -	u8 encryption = btrfs_pack_encryption(IS_ENCRYPTED(&inode->vfs_inode) ?
> -					      BTRFS_ENCRYPTION_FSCRYPT : 0, 0);
> +	u8 encryption = 0;
> +	size_t fscrypt_context_size = 0;
> +#ifdef CONFIG_FS_ENCRYPTION
> +	u8 context[FSCRYPT_SET_CONTEXT_MAX_SIZE];
> +
> +	if (em->fscrypt_info) {
> +		fscrypt_context_size =
> +			fscrypt_set_extent_context(em->fscrypt_info, context,
> +						   FSCRYPT_SET_CONTEXT_MAX_SIZE);
> +		if (fscrypt_context_size < 0)
> +			return fscrypt_context_size;
> +
> +		encryption = btrfs_pack_encryption(BTRFS_ENCRYPTION_FSCRYPT,
> +						   fscrypt_context_size);
> +	}

Same here, looks like this can be it's own helper, and the code above can use
this helper and do the other thing it needs to.  Thanks,

Josef
