Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA95C75680D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 17:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjGQPbu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 11:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjGQPbu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 11:31:50 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F82110E7
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 08:31:20 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id af79cd13be357-76714caf466so439530085a.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 08:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689607837; x=1692199837;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f5yafjSVbEX8NnW/GBKF8Aq89onhwd6TER/M9lnZNeo=;
        b=ftzRk/CuPmuiVa/OlPd6L8msn3JMAz2rtS04GF9tj5zr+IHzDnljzlIMKOXR3wWWs+
         Jf0y44fMTIkGnXi+WlQIO4aK6IhEUpY3JOBhoiuYPEA4XdDIglpKRHInPsh6VOQOeM47
         VFH1zD8tU2P3Zl39fXqO45nUqyQgWkCc7BtXCSa09uc09wLtd4dBGniOUil278CZa4w0
         +Ncin5B+A27I417pjsR4S4ef1MJ122/Tb7WiDOi25O1AKsC/7vBiHcbuEGXSsQCRRY3o
         OYrzfFI4eYOaEdg0BuafcSCEC0aehjBYrgmAQGhOPr+DEWTwaZBRQIjN/SgFfAfAGQ7F
         9+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607837; x=1692199837;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f5yafjSVbEX8NnW/GBKF8Aq89onhwd6TER/M9lnZNeo=;
        b=NndJN+wRGKvn3W/6FvIPreq5RseYZNEc5mSG0+3nkvSo7kq0IfWaSSg2EAIVJZu7/U
         qL4WdJuRepfEYn3MHPzh/sTlp2KqizTYAE96AGk+paWyeREwXH/k9X1ieNv1W86A/JrB
         BJYz57K5Hn2Co0/vQeA67c1ozHd8JBMKsXrd8TeMfBvi+1Lxb8TNMjj1AtRe0u37KAxY
         9GGo+O7AIdhoTOE1Bd8LRWR9TH+GuKo+GrkfwcczZnud3/etdQz7uR7tBo1N2z7hGuPv
         AjzZQcKx/y01xwvyTGE3iPLW04N6VIBKcGg+QcuXeFIIfZs+0qmxa4LbN0ujWzEpUzKk
         QBFQ==
X-Gm-Message-State: ABy/qLaObu+x/4F0tKt9jYAybkVSJaEv+xbM528UYbhRjLMzHN5ia6hm
        9BKQOZaqzbUuRPiAYWZvKrlAnA==
X-Google-Smtp-Source: APBJJlFqJnsPqc+ZnVD1cRgaxXoR6mvSit2iaE6ttQjsvzINeK15Zr+/J5jOX6vq2LILS0w4/sc4eg==
X-Received: by 2002:a05:620a:8399:b0:768:1418:8999 with SMTP id pb25-20020a05620a839900b0076814188999mr6180291qkn.52.1689607836964;
        Mon, 17 Jul 2023 08:30:36 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id g18-20020a05620a13d200b00767cd2dbd82sm6170116qkl.15.2023.07.17.08.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 08:30:36 -0700 (PDT)
Date:   Mon, 17 Jul 2023 11:30:35 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 16/17] btrfs: explicitly track file extent length and
 encryption
Message-ID: <20230717153035.GH691303@perftesting>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
 <85b570f5b467dab2da4e125166283e3d3d1aada2.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85b570f5b467dab2da4e125166283e3d3d1aada2.1689564024.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 16, 2023 at 11:52:47PM -0400, Sweet Tea Dorminy wrote:
> With the advent of storing fscrypt contexts with each encrypted extent,
> extents will have a variable length depending on encryption status.
> Add accessors for the encryption field, and update all the checks for
> file extents.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/ctree.h                | 2 ++
>  fs/btrfs/file.c                 | 4 ++--
>  fs/btrfs/inode.c                | 9 +++++++--
>  fs/btrfs/reflink.c              | 1 +
>  fs/btrfs/tree-log.c             | 2 +-
>  include/uapi/linux/btrfs_tree.h | 5 +++++
>  6 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index f2d2b313bde5..b1afcfc62f75 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -364,6 +364,8 @@ struct btrfs_replace_extent_info {
>  	u64 file_offset;
>  	/* Pointer to a file extent item of type regular or prealloc. */
>  	char *extent_buf;
> +	/* The length of @extent_buf */
> +	u32 extent_buf_size;
>  	/*
>  	 * Set to true when attempting to replace a file range with a new extent
>  	 * described by this structure, set to false when attempting to clone an
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 73038908876a..4988c9317234 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2246,14 +2246,14 @@ static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
>  	key.type = BTRFS_EXTENT_DATA_KEY;
>  	key.offset = extent_info->file_offset;
>  	ret = btrfs_insert_empty_item(trans, root, path, &key,
> -				      sizeof(struct btrfs_file_extent_item));
> +				      extent_info->extent_buf_size);
>  	if (ret)
>  		return ret;
>  	leaf = path->nodes[0];
>  	slot = path->slots[0];
>  	write_extent_buffer(leaf, extent_info->extent_buf,
>  			    btrfs_item_ptr_offset(leaf, slot),
> -			    sizeof(struct btrfs_file_extent_item));
> +			    extent_info->extent_buf_size);
>  	extent = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
>  	ASSERT(btrfs_file_extent_type(leaf, extent) != BTRFS_FILE_EXTENT_INLINE);
>  	btrfs_set_file_extent_offset(leaf, extent, extent_info->data_offset);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index f68d74dec5ed..83098779dad2 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3036,6 +3036,9 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>  	u64 num_bytes = btrfs_stack_file_extent_num_bytes(stack_fi);
>  	u64 ram_bytes = btrfs_stack_file_extent_ram_bytes(stack_fi);
>  	struct btrfs_drop_extents_args drop_args = { 0 };
> +	size_t fscrypt_context_size =
> +		btrfs_stack_file_extent_encryption(stack_fi) ?
> +			FSCRYPT_SET_CONTEXT_MAX_SIZE : 0;
>  	int ret;
>  
>  	path = btrfs_alloc_path();
> @@ -3055,7 +3058,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>  	drop_args.start = file_pos;
>  	drop_args.end = file_pos + num_bytes;
>  	drop_args.replace_extent = true;
> -	drop_args.extent_item_size = sizeof(*stack_fi);
> +	drop_args.extent_item_size = sizeof(*stack_fi) + fscrypt_context_size;
>  	ret = btrfs_drop_extents(trans, root, inode, &drop_args);
>  	if (ret)
>  		goto out;
> @@ -3066,7 +3069,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>  		ins.type = BTRFS_EXTENT_DATA_KEY;
>  
>  		ret = btrfs_insert_empty_item(trans, root, path, &ins,
> -					      sizeof(*stack_fi));
> +					      sizeof(*stack_fi) + fscrypt_context_size);
>  		if (ret)
>  			goto out;
>  	}
> @@ -9770,6 +9773,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
>  	u64 len = ins->offset;
>  	int qgroup_released;
>  	int ret;
> +	size_t fscrypt_context_size = 0;
>  
>  	memset(&stack_fi, 0, sizeof(stack_fi));
>  
> @@ -9802,6 +9806,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
>  	extent_info.data_len = len;
>  	extent_info.file_offset = file_offset;
>  	extent_info.extent_buf = (char *)&stack_fi;
> +	extent_info.extent_buf_size = sizeof(stack_fi) + fscrypt_context_size;
>  	extent_info.is_new_extent = true;
>  	extent_info.update_times = true;
>  	extent_info.qgroup_reserved = qgroup_released;
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index ad722f495c9b..9f3b5748f39b 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -502,6 +502,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>  			clone_info.data_len = datal;
>  			clone_info.file_offset = new_key.offset;
>  			clone_info.extent_buf = buf;
> +			clone_info.extent_buf_size = size;
>  			clone_info.is_new_extent = false;
>  			clone_info.update_times = !no_time_update;
>  			ret = btrfs_replace_file_extents(BTRFS_I(inode), path,
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index a49a05cfbac4..82c91097672b 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -4689,7 +4689,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
>  		key.offset = em->start;
>  
>  		ret = btrfs_insert_empty_item(trans, log, path, &key,
> -					      sizeof(fi));
> +					      sizeof(fi) + fscrypt_context_size);

This bit fails to compile, it compiles after the next patch, you'll want to fix
this up.  Thanks,

Josef
