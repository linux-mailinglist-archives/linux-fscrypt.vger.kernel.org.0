Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EA474BA0F
	for <lists+linux-fscrypt@lfdr.de>; Sat,  8 Jul 2023 01:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjGGXeL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 7 Jul 2023 19:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGGXeL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 7 Jul 2023 19:34:11 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98762107;
        Fri,  7 Jul 2023 16:34:08 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0EDA85C00F8;
        Fri,  7 Jul 2023 19:34:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 07 Jul 2023 19:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1688772846; x=1688859246; bh=m9
        uYD1aJCqNyFy6nkG2DjeE9IE8VL6W/E0B1B72ww14=; b=I84BuYyvNJMnrQn9/f
        +BbqwQJauX/23CJsE54E/yH1VPLjvjYx/4+ysNLNVeV4nNqgHAr8IHVqCNp0VPk/
        dU7iarP3plNMLVJrhR5V55F9Kbu55EW7nN3fnMVIglPdqOQKTvPdweqvX4Dx2mko
        JEmDV+S2NxHG07lqMllI3EptwstBXqYuk+DbHu0b0zLPXb5CgU/J/7wBt4kUnC7t
        cK/G++l484XYI50ZS+CuDEBk6eqe8wOHesQeluIC7dx+TFXioeCLtEeuU71rOFQ/
        mvKegvfMtZ3ml5H9lsFiIupGvb+Y9oCLi1dfUn84WmuEtBhru6o+T57d+7eKZZvc
        EZYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1688772846; x=1688859246; bh=m9uYD1aJCqNyF
        y6nkG2DjeE9IE8VL6W/E0B1B72ww14=; b=IvpN4VB328A/yyZdH70Iv5W9obh4X
        KAifzqcVq+yhYtyrXt+OGfc7Se32by/+e90N29tWbqWNhcLHrstQ3t3PJFtmvXOK
        zHt6SGT0CYrLWWPc87AOBwRQbV/cfK4a1Ok0iwmpWWUMEiIpRPTBudjV5uUGlU4y
        WufRZr11npnH3kXzpVYRNRHwoRf+z6OiFfYfHQxHgb/oQvqTi4VzhYZGP8AB4zr7
        GxaDHC4tf7ACRmXwS02PZd19w6KhSI9i2ouVwZsY1nXXMxRsVO6m0gdTapQELkDl
        KdYKOLj47e8mEQwimUeQx4iSomP9qeQcRA6B2vBj0QkO3A4irmhx5migQ==
X-ME-Sender: <xms:7aCoZAzL1ozoe4zI6PZvxAHurAO6hiXtRExJF_GZGUlQJP9KSiCOeg>
    <xme:7aCoZERY59CqTnAhi5pJ8dZelT35l0fqCHT6pSjmTd7cpDT92JWIqr_laCf_zhOOb
    GCA0Rbu8b2C6JfRa6E>
X-ME-Received: <xmr:7aCoZCUF3hkC57Eftxh8Zie59hcHp20y1l0IFDF0XLwYSO5que6nd7VXci5JLN4XHFuriwZZY5QlfGRmUS4_AtcWy4E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrvddvgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepke
    dvkeffjeellefhveehvdejudfhjedthfdvveeiieeiudfguefgtdejgfefleejnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihho
X-ME-Proxy: <xmx:7aCoZOjaJpUjRcDAczJnFrr8_WHm5v3RbqNgFjIaDKfJWWQxWdOWVA>
    <xmx:7aCoZCBpW6Ttzuog2VIFue_LesCL0CqQhI1TEarDpe64qEn-_r0sNw>
    <xmx:7aCoZPIexUW-ftweCrN83GCEF5dsPnhfUqT8STc565xame4ZL5-2pA>
    <xmx:7qCoZKuFyHocAM8YjPdI3n5z3SKbsP0VpSsfKuAKMbgAPkYvi-db3Q>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Jul 2023 19:34:05 -0400 (EDT)
Date:   Fri, 7 Jul 2023 16:32:56 -0700
From:   Boris Burkov <boris@bur.io>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v1 05/17] btrfs: add inode encryption contexts
Message-ID: <20230707233256.GA2579580@zen>
References: <cover.1687988380.git.sweettea-kernel@dorminy.me>
 <a4e0968259ca4843e0684f7801fd5359ed74f7c6.1687988380.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4e0968259ca4843e0684f7801fd5359ed74f7c6.1687988380.git.sweettea-kernel@dorminy.me>
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

On Wed, Jun 28, 2023 at 08:35:28PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> In order to store encryption information for directories, symlinks,
> etc., fscrypt stores a context item with each encrypted non-regular
> inode. fscrypt provides an arbitrary blob for the filesystem to store,
> and it does not clearly fit into an existing structure, so this goes in
> a new item type.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/fscrypt.c              | 116 ++++++++++++++++++++++++++++++++
>  fs/btrfs/fscrypt.h              |   2 +
>  fs/btrfs/inode.c                |  19 ++++++
>  fs/btrfs/ioctl.c                |   8 ++-
>  include/uapi/linux/btrfs_tree.h |  10 +++
>  5 files changed, 153 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> index 3a53dc59c1e4..235f65e43d96 100644
> --- a/fs/btrfs/fscrypt.c
> +++ b/fs/btrfs/fscrypt.c
> @@ -1,8 +1,124 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
> +#include <linux/iversion.h>
>  #include "ctree.h"
> +#include "accessors.h"
> +#include "btrfs_inode.h"
> +#include "disk-io.h"
> +#include "fs.h"
>  #include "fscrypt.h"
> +#include "ioctl.h"
> +#include "messages.h"
> +#include "transaction.h"
> +#include "xattr.h"
> +
> +static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
> +{
> +	struct btrfs_key key = {
> +		.objectid = btrfs_ino(BTRFS_I(inode)),
> +		.type = BTRFS_FSCRYPT_CTXT_ITEM_KEY,
> +		.offset = 0,
> +	};
> +	struct btrfs_path *path;
> +	struct extent_buffer *leaf;
> +	unsigned long ptr;
> +	int ret;
> +
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	ret = btrfs_search_slot(NULL, BTRFS_I(inode)->root, &key, path, 0, 0);
> +	if (ret) {
> +		len = -EINVAL;

I'm a little wary about squishing the errors down like this. It could
be some error, in which case it might be interesting to get the real errno
or it could be ret > 1, in which case I think ENOENT is more useful than
EINVAL.

Also, having a ret variable and mashing that into len feels kinda weird.
Maybe that's the neatest way to write this logic, though.

> +		goto out;
> +	}
> +
> +	leaf = path->nodes[0];
> +	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +	/* fscrypt provides max context length, but it could be less */
> +	len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
> +	read_extent_buffer(leaf, ctx, ptr, len);
> +
> +out:
> +	btrfs_free_path(path);
> +	return len;
> +}
> +
> +static void btrfs_fscrypt_update_context(struct btrfs_path *path,
> +					 const void *ctx, size_t len)
> +{
> +	struct extent_buffer *leaf = path->nodes[0];
> +	unsigned long ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +
> +	len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
> +	write_extent_buffer(leaf, ctx, ptr, len);
> +	btrfs_mark_buffer_dirty(leaf);
> +}
> +
> +static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
> +				     size_t len, void *fs_data)
> +{
> +	struct btrfs_path *path;
> +	int ret;
> +	struct btrfs_trans_handle *trans = fs_data;
> +	struct btrfs_key key = {
> +		.objectid = btrfs_ino(BTRFS_I(inode)),
> +		.type = BTRFS_FSCRYPT_CTXT_ITEM_KEY,
> +		.offset = 0,
> +	};
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	if (!trans)
> +		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 1);
> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
> +
> +	ret = btrfs_search_slot(trans, BTRFS_I(inode)->root, &key, path, 0, 1);
> +	if (ret == 0) {
> +		btrfs_fscrypt_update_context(path, ctx, len);
> +		btrfs_free_path(path);
> +		return ret;
> +	}
> +
> +	btrfs_free_path(path);
> +	if (ret < 0) {
> +		btrfs_abort_transaction(trans, ret);
> +		return ret;
> +	}
> +
> +	ret = btrfs_insert_item(trans, BTRFS_I(inode)->root, &key, (void *) ctx, len);
> +	if (ret) {
> +		btrfs_abort_transaction(trans, ret);
> +		return ret;
> +	}
> +
> +	BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
> +	btrfs_sync_inode_flags_to_i_flags(inode);
> +	inode_inc_iversion(inode);
> +	inode->i_ctime = current_time(inode);
> +	ret = btrfs_update_inode(trans, BTRFS_I(inode)->root, BTRFS_I(inode));
> +	if (!ret) {
> +		if (!fs_data)
> +			btrfs_end_transaction(trans);
> +		return ret;
> +	}
> +
> +	btrfs_abort_transaction(trans, ret);
> +	return ret;
> +}
> +
> +static bool btrfs_fscrypt_empty_dir(struct inode *inode)
> +{
> +	return inode->i_size == BTRFS_EMPTY_DIR_SIZE;
> +}
>  
>  const struct fscrypt_operations btrfs_fscrypt_ops = {
> +	.get_context = btrfs_fscrypt_get_context,
> +	.set_context = btrfs_fscrypt_set_context,
> +	.empty_dir = btrfs_fscrypt_empty_dir,
>  	.key_prefix = "btrfs:"
>  };
> diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
> index 7f4e6888bd43..80adb7e56826 100644
> --- a/fs/btrfs/fscrypt.h
> +++ b/fs/btrfs/fscrypt.h
> @@ -5,6 +5,8 @@
>  
>  #include <linux/fscrypt.h>
>  
> +#include "fs.h"
> +
>  extern const struct fscrypt_operations btrfs_fscrypt_ops;
>  
>  #endif /* BTRFS_FSCRYPT_H */
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 5ce167cfa1dc..9dc47f769641 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -62,6 +62,7 @@
>  #include "defrag.h"
>  #include "dir-item.h"
>  #include "file-item.h"
> +#include "fscrypt.h"
>  #include "uuid-tree.h"
>  #include "ioctl.h"
>  #include "file.h"
> @@ -6179,6 +6180,9 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
>  	struct inode *inode = args->inode;
>  	int ret;
>  
> +	if (fscrypt_is_nokey_name(args->dentry))
> +		return -ENOKEY;
> +
>  	if (!args->orphan) {
>  		ret = fscrypt_setup_filename(dir, &args->dentry->d_name, 0,
>  					     &args->fname);
> @@ -6212,6 +6216,9 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
>  	if (dir->i_security)
>  		(*trans_num_items)++;
>  #endif
> +	/* 1 to add fscrypt item, but only for encrypted non-regular files */
> +	if (args->encrypt && !S_ISREG(inode->i_mode))
> +		(*trans_num_items)++;
>  	if (args->orphan) {
>  		/* 1 to add orphan item */
>  		(*trans_num_items)++;
> @@ -6390,6 +6397,11 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
>  	inode->i_ctime = inode->i_mtime;
>  	BTRFS_I(inode)->i_otime = inode->i_mtime;
>  
> +	if (args->encrypt) {
> +		BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
> +		btrfs_sync_inode_flags_to_i_flags(inode);
> +	}
> +
>  	/*
>  	 * We're going to fill the inode item now, so at this point the inode
>  	 * must be fully initialized.
> @@ -6464,6 +6476,13 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
>  			goto discard;
>  		}
>  	}
> +	if (args->encrypt && !S_ISREG(inode->i_mode)) {
> +		ret = fscrypt_set_context(inode, trans);
> +		if (ret) {
> +			btrfs_abort_transaction(trans, ret);
> +			goto discard;
> +		}
> +	}
>  
>  	inode_tree_add(BTRFS_I(inode));
>  
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index edbbd5cf23fc..11564e48d736 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -156,6 +156,8 @@ static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
>  		iflags |= FS_DIRSYNC_FL;
>  	if (flags & BTRFS_INODE_NODATACOW)
>  		iflags |= FS_NOCOW_FL;
> +	if (flags & BTRFS_INODE_ENCRYPT)
> +		iflags |= FS_ENCRYPT_FL;
>  	if (ro_flags & BTRFS_INODE_RO_VERITY)
>  		iflags |= FS_VERITY_FL;
>  
> @@ -185,12 +187,14 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
>  		new_fl |= S_NOATIME;
>  	if (binode->flags & BTRFS_INODE_DIRSYNC)
>  		new_fl |= S_DIRSYNC;
> +	if (binode->flags & BTRFS_INODE_ENCRYPT)
> +		new_fl |= S_ENCRYPTED;
>  	if (binode->ro_flags & BTRFS_INODE_RO_VERITY)
>  		new_fl |= S_VERITY;
>  
>  	set_mask_bits(&inode->i_flags,
>  		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC |
> -		      S_VERITY, new_fl);
> +		      S_VERITY | S_ENCRYPTED, new_fl);
>  }
>  
>  /*
> @@ -203,7 +207,7 @@ static int check_fsflags(unsigned int old_flags, unsigned int flags)
>  		      FS_NOATIME_FL | FS_NODUMP_FL | \
>  		      FS_SYNC_FL | FS_DIRSYNC_FL | \
>  		      FS_NOCOMP_FL | FS_COMPR_FL |
> -		      FS_NOCOW_FL))
> +		      FS_NOCOW_FL | FS_ENCRYPT_FL))
>  		return -EOPNOTSUPP;
>  
>  	/* COMPR and NOCOMP on new/old are valid */
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> index ab38d0f411fa..ea88dd69957f 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -161,6 +161,8 @@
>  #define BTRFS_VERITY_DESC_ITEM_KEY	36
>  #define BTRFS_VERITY_MERKLE_ITEM_KEY	37
>  
> +#define BTRFS_FSCRYPT_CTXT_ITEM_KEY	41
> +

Since the variables usually go by ctx, I lightly prefer CTX_ITEM_KEY.
Obviously not a big deal.

>  #define BTRFS_ORPHAN_ITEM_KEY		48
>  /* reserve 2-15 close to the inode for later flexibility */
>  
> @@ -399,6 +401,7 @@ static inline __u8 btrfs_dir_flags_to_ftype(__u8 flags)
>  #define BTRFS_INODE_NOATIME		(1U << 9)
>  #define BTRFS_INODE_DIRSYNC		(1U << 10)
>  #define BTRFS_INODE_COMPRESS		(1U << 11)
> +#define BTRFS_INODE_ENCRYPT	(1U << 12)
>  
>  #define BTRFS_INODE_ROOT_ITEM_INIT	(1U << 31)
>  
> @@ -415,6 +418,7 @@ static inline __u8 btrfs_dir_flags_to_ftype(__u8 flags)
>  	 BTRFS_INODE_NOATIME |						\
>  	 BTRFS_INODE_DIRSYNC |						\
>  	 BTRFS_INODE_COMPRESS |						\
> +	 BTRFS_INODE_ENCRYPT |						\
>  	 BTRFS_INODE_ROOT_ITEM_INIT)
>  
>  #define BTRFS_INODE_RO_VERITY		(1U << 0)
> @@ -1016,6 +1020,12 @@ enum {
>  	BTRFS_NR_FILE_EXTENT_TYPES = 3,
>  };
>  
> +enum {
> +	BTRFS_ENCRYPTION_NONE,
> +	BTRFS_ENCRYPTION_FSCRYPT,
> +	BTRFS_NR_ENCRYPTION_TYPES,
> +};
> +
>  struct btrfs_file_extent_item {
>  	/*
>  	 * transaction id that created this extent
> -- 
> 2.40.1
> 
