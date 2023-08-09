Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8DA776A5F
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Aug 2023 22:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbjHIUjh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Aug 2023 16:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbjHIUjV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Aug 2023 16:39:21 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B54F2D7D
        for <linux-fscrypt@vger.kernel.org>; Wed,  9 Aug 2023 13:38:58 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id 006d021491bc7-56c7eb17945so198981eaf.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 09 Aug 2023 13:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1691613523; x=1692218323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RfjDRN4vbo35v9KOKF3cnLdcoAX2oPb2xLABT0K6CWY=;
        b=Hl3xW6dleDiSacM/c0QD9hgAuOn/ZEFih8UD50mpIa1r5XxNSNLgyU0GEh37rtBfZf
         cOl2gt/CBB6pYerTNKz+0ad9AvRT0CoqhdZXHJvT6EI+G1h93kmwuOqnzxEXyFsrvQxj
         5C0kgGG8aMCVdQkMjI0T8VCMKoGtr2le8BYtESNcE/stmA3nS8FqhTGof5RQSeRB0wkH
         uoAowzyD+9x/siZDjY8R/Z7DQAvKDptX5kfNQnJfYXa8kcGKmDStRv/jEWdm4PxmOHgh
         uBOv+VPD3SolYo0w0U2WBD9kpWem1w/jB5wqpsbexvI9Y+S47D5EA1gaeBF7MRXPCFtc
         wmoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691613523; x=1692218323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RfjDRN4vbo35v9KOKF3cnLdcoAX2oPb2xLABT0K6CWY=;
        b=j/rlGWBuTi/IfDPkmTFKoGx1WSxj8VJkOfTn9wpb8ICt6VcodWVv8q3qTARyKvRncP
         0IZtn+jT0t03CzXZOscPAGjMosyXOo0UsVGAj4p8v1E303Ecne4MmnHr65petKTx7LTf
         POa0RJ7GGt7qKn2O6qbrEqqWf+9YGEfd1+yOypK/Fj9FvXcq7HSuwF1BYlaSc16pyM5A
         nVnMSKYBBaWcCU6RjZxnVrtucCSt/kX8rWbhQEcjQvA6bTV3JRH2sf6pYHCdsRCeoTdg
         N9YsNQgIxAPLNaXVussvZUOcQqSUSR9l3bOpVaBE9EzUHqfJiSntPZzdnmosEjK6fD2+
         tZkw==
X-Gm-Message-State: AOJu0YwHIXd+GaBZwMsVOYNRvOoH74J0RiPEQksHQaho4bXU9Etc8I9Q
        uDWPhEEEgTTAGGrElK+VWhvzkg==
X-Google-Smtp-Source: AGHT+IGvVuuu9KkzcifyALv28qCjkO2TdjQJ7cmHS9BoYlz0bTkLntYYg7woiFO5IZLHuP6dCfSzLw==
X-Received: by 2002:a05:6808:1283:b0:3a7:4802:c50 with SMTP id a3-20020a056808128300b003a748020c50mr702383oiw.10.1691613522989;
        Wed, 09 Aug 2023 13:38:42 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id a14-20020a0ce38e000000b00637873ff0f3sm4714144qvl.15.2023.08.09.13.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 13:38:42 -0700 (PDT)
Date:   Wed, 9 Aug 2023 16:38:41 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v3 17/17] btrfs: save and load fscrypt extent contexts
Message-ID: <20230809203841.GD2561679@perftesting>
References: <cover.1691510179.git.sweettea-kernel@dorminy.me>
 <3fee78c12452ab3176900d082cb5401dd0ca5b53.1691510179.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fee78c12452ab3176900d082cb5401dd0ca5b53.1691510179.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:12:19PM -0400, Sweet Tea Dorminy wrote:
> This change actually saves and loads the extent contexts created and
> freed by the last change.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/file-item.c |   7 +++
>  fs/btrfs/fscrypt.c   | 108 ++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/fscrypt.h   |  35 ++++++++++++++
>  fs/btrfs/inode.c     |  37 +++++++++++++--
>  fs/btrfs/tree-log.c  |  14 +++++-
>  5 files changed, 194 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index f83f7020ed89..880fb7810152 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -1299,6 +1299,13 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
>  
>  		ctxsize = btrfs_file_extent_ctxsize_from_item(leaf, path);
>  		ASSERT(ctxsize == btrfs_file_extent_encryption_ctxsize(leaf, fi));
> +
> +		if (ctxsize) {
> +			unsigned long ptr = (unsigned long)fi->encryption_context;
> +			int res = btrfs_fscrypt_load_extent_info(inode, leaf, ptr,
> +								 ctxsize, &em->fscrypt_info);
> +			ASSERT(res == 0);
> +		}
>  	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
>  		em->block_start = EXTENT_MAP_INLINE;
>  		em->start = extent_start;
> diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> index 5508cbc6bccb..7324375af0ac 100644
> --- a/fs/btrfs/fscrypt.c
> +++ b/fs/btrfs/fscrypt.c
> @@ -75,6 +75,65 @@ bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
>  	return !memcmp(digest, nokey_name->sha256, sizeof(digest));
>  }
>  
> +int btrfs_fscrypt_fill_extent_context(struct btrfs_inode *inode,
> +				      struct fscrypt_info *info,
> +				      u8 *context_buffer, size_t *context_len)
> +{
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	int ret;
> +
> +	if (!IS_ENCRYPTED(&inode->vfs_inode))
> +		return 0;
> +
> +
> +	ret = fscrypt_set_extent_context(info, context_buffer + sizeof(u32),
> +					 FSCRYPT_SET_CONTEXT_MAX_SIZE);
> +	if (ret < 0) {
> +		btrfs_err(fs_info, "fscrypt context could not be saved");
> +		return ret;
> +	}
> +
> +	/* the return value, if nonnegative, is the fscrypt context size */
> +	ret += sizeof(u32);
> +
> +	put_unaligned_le32(ret, context_buffer);
> +
> +	*context_len = ret;
> +	return 0;
> +}
> +
> +int btrfs_fscrypt_load_extent_info(struct btrfs_inode *inode,
> +				  struct extent_buffer *leaf,
> +				  unsigned long ptr,
> +				  u8 ctxsize,
> +				  struct fscrypt_info **info_ptr)
> +{
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	u8 context[BTRFS_FSCRYPT_EXTENT_CONTEXT_MAX_SIZE];
> +	int res;
> +	unsigned int nofs_flags;
> +	u32 len;
> +
> +	read_extent_buffer(leaf, context, ptr, ctxsize);
> +
> +	nofs_flags = memalloc_nofs_save();
> +	res = fscrypt_load_extent_info(&inode->vfs_inode,
> +				       context + sizeof(u32),
> +				       ctxsize - sizeof(u32), info_ptr);
> +	memalloc_nofs_restore(nofs_flags);
> +
> +	if (res)
> +		btrfs_err(fs_info, "Unable to load fscrypt info: %d", res);

We are we not returning an error here?  Seems like we could end up with garbage
in context and then we'd just turn the error into -EINVAL below.

> +
> +	len = get_unaligned_le32(context);
> +	if (len != ctxsize) {
> +		res = -EINVAL;
> +		btrfs_err(fs_info, "fscrypt info size mismatches");
> +	}
> +
> +	return res;
> +}
> +
>  static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
>  {
>  	struct btrfs_key key = {
> @@ -138,11 +197,14 @@ static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
>  
>  	if (!trans)
>  		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 1);
> -	if (IS_ERR(trans))
> +	if (IS_ERR(trans)) {
> +		btrfs_free_path(path);
>  		return PTR_ERR(trans);
> +	}
>  
>  	ret = btrfs_search_slot(trans, BTRFS_I(inode)->root, &key, path, 0, 1);
>  	if (ret < 0) {
> +		btrfs_free_path(path);
>  		btrfs_abort_transaction(trans, ret);
>  		return ret;
>  	}
> @@ -151,12 +213,13 @@ static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
>  		btrfs_release_path(path);
>  		ret = btrfs_insert_empty_item(trans, BTRFS_I(inode)->root, path, &key, len);
>  		if (ret) {
> +			btrfs_free_path(path);
>  			btrfs_abort_transaction(trans, ret);
>  			return ret;
>  		}
>  	}
> -
>  	btrfs_fscrypt_update_context(path, ctx, len);
> +	btrfs_free_path(path);
>  

These are unrelated changes, but my earlier comment was about re-working this
function, so I assume this will go away once you implement the changes I asked
for.  Thanks,

Josef
