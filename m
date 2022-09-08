Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31B85B2769
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Sep 2022 22:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiIHUGh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Sep 2022 16:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiIHUGf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Sep 2022 16:06:35 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57658E127B
        for <linux-fscrypt@vger.kernel.org>; Thu,  8 Sep 2022 13:06:34 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id cb8so13846378qtb.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 08 Sep 2022 13:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=aeBDLJzzAdnCQIFfJiVJN1bXnjtQptQZl3DABMNxrwg=;
        b=OTEphyLwCkp5aIZyCrbQUGrjzCk1TbMS/eXwatOB5zdObOQnixElpkzyzU6UkNa5v9
         fmbLor2tF9EvWchBW3AuS0zP3p6eocIMDXCshtW7lRuzjXC+SOZBwMWgDlkOHLWUClMC
         rSK31/k9kKQ02YhlzbvqB6h4tJKyRInMUdsSNTDPyp/I2AudtcznpZR5vUGcE/i1nC96
         QfJu/S5iGOx5v/BAZ4GAcAlAcsCXTA5r/w8RVy8d3IuhnqRvZmZhSicGBOJmMApPtCha
         cEKuqvAFtJiGEtuyGPcWSD6QxKk3/KgAXFlnBcDnPzbzWIRB5StORsgaD+HPN3jKIfXo
         L4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=aeBDLJzzAdnCQIFfJiVJN1bXnjtQptQZl3DABMNxrwg=;
        b=vxv6ouzTvMh0mzxg4EEaoX1d1HhQGK7ZRCrd49xJhfysobR9bGz1UBDYeOzFO+S7DX
         47+apmugmGrVJZLM+fPgA8582gm9TPPlmg8AvBpRlFX9RY0yN3YGeA5bswO/3Q6XQ9bo
         vrYtF55IwqaNG8eNM2uvfj9EvNZRPf91ghFOcpKJzJr19sn21o6aFFsSkBRcQS6tNlv3
         XhePvCh7KaRGVVeokPtHvztOWB+sp0h+1VZ7tKR4mO27n321EVw0gXW9+176K8oZdg+H
         GBYK5uTrm045LudaWOzOYQWA224UIqaUdfT4Q5tyt7zgb2+ZiU56bkFDxsKCcYzxJ2zi
         wBpA==
X-Gm-Message-State: ACgBeo1TP1oA94/4bPfd4twQKSLSv0Ig1BQUuoXBGfLlgvoqLvfDrKTx
        0kcg/1iBlE3jP/iQHGMwD1Jbsg==
X-Google-Smtp-Source: AA6agR7Z2H8bBeqkk1quG+6VSURFSWfhMwurFK+sPBz38Um1CLy09LFfdLBAvPpbzGVTXsWxIzqy/A==
X-Received: by 2002:a05:622a:1181:b0:344:7bad:cfc7 with SMTP id m1-20020a05622a118100b003447badcfc7mr9544467qtk.462.1662667593252;
        Thu, 08 Sep 2022 13:06:33 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id az15-20020a05620a170f00b006bb208bd889sm18294223qkb.120.2022.09.08.13.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 13:06:32 -0700 (PDT)
Date:   Thu, 8 Sep 2022 16:06:31 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 13/20] btrfs: add fscrypt_context items.
Message-ID: <YxpLR1+7PyZ9cBB9@localhost.localdomain>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <827a00815cb4a9a91ff3977d71f40ff765728f04.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <827a00815cb4a9a91ff3977d71f40ff765728f04.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:28PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> In order to store per-inode information such as the inode nonce and the
> key identifier, fscrypt stores a context item with each encrypted inode.
> This can be implemented as a new item type, as fscrypt provides an
> arbitrary blob for the filesystem to store.
> 
> This also provides a good place to implement full-subvolume encryption:
> a subvolume flag permits setting one context for the whole subvolume.
> However, since an unencrypted subvolume would be unable to read
> encrypted data, encrypted subvolumes should only be snapshottable to
> other encrypted subvolumes.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/ctree.h                |   3 +
>  fs/btrfs/fscrypt.c              | 167 ++++++++++++++++++++++++++++++++
>  fs/btrfs/inode.c                |  38 ++++++++
>  fs/btrfs/ioctl.c                |  10 +-
>  fs/btrfs/tree-checker.c         |   1 +
>  include/uapi/linux/btrfs_tree.h |  10 ++
>  6 files changed, 228 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 2b9ba8d77861..f0a16c32110d 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -33,6 +33,7 @@
>  #include "extent-io-tree.h"
>  #include "extent_io.h"
>  #include "extent_map.h"
> +#include "fscrypt.h"
>  #include "async-thread.h"
>  #include "block-rsv.h"
>  #include "locking.h"
> @@ -1667,6 +1668,7 @@ do {                                                                   \
>  #define BTRFS_INODE_NOATIME		(1U << 9)
>  #define BTRFS_INODE_DIRSYNC		(1U << 10)
>  #define BTRFS_INODE_COMPRESS		(1U << 11)
> +#define BTRFS_INODE_FSCRYPT_CONTEXT	(1U << 12)
>  
>  #define BTRFS_INODE_ROOT_ITEM_INIT	(1U << 31)
>  
> @@ -1683,6 +1685,7 @@ do {                                                                   \
>  	 BTRFS_INODE_NOATIME |						\
>  	 BTRFS_INODE_DIRSYNC |						\
>  	 BTRFS_INODE_COMPRESS |						\
> +	 BTRFS_INODE_FSCRYPT_CONTEXT |					\
>  	 BTRFS_INODE_ROOT_ITEM_INIT)
>  
>  #define BTRFS_INODE_RO_VERITY		(1U << 0)
> diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> index 9829d280a6bc..b824bbd964bc 100644
> --- a/fs/btrfs/fscrypt.c
> +++ b/fs/btrfs/fscrypt.c
> @@ -3,8 +3,13 @@
>   * Copyright (C) 2020 Facebook
>   */
>  
> +#include <linux/iversion.h>
>  #include "ctree.h"
> +#include "btrfs_inode.h"
> +#include "disk-io.h"
>  #include "fscrypt.h"
> +#include "transaction.h"
> +#include "xattr.h"
>  
>  /* fscrypt_match_name() but for an extent_buffer. */
>  bool btrfs_fscrypt_match_name(const struct fscrypt_name *fname,
> @@ -31,5 +36,167 @@ bool btrfs_fscrypt_match_name(const struct fscrypt_name *fname,
>  	return !memcmp(digest, nokey_name->sha256, sizeof(digest));
>  }
>  
> +static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
> +{
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct inode *put_inode = NULL;
> +	struct btrfs_key key;
> +	struct btrfs_path *path;
> +	struct extent_buffer *leaf;
> +	unsigned long ptr;
> +	int ret;
> +
> +	if (btrfs_root_flags(&root->root_item) & BTRFS_ROOT_SUBVOL_FSCRYPT) {
> +		inode = btrfs_iget(inode->i_sb, BTRFS_FIRST_FREE_OBJECTID,
> +				   root);
> +		if (IS_ERR(inode))
> +			return PTR_ERR(inode);
> +		put_inode = inode;
> +	}
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	key = (struct btrfs_key) {
> +		.objectid = btrfs_ino(BTRFS_I(inode)),
> +		.type = BTRFS_FSCRYPT_CTXT_ITEM_KEY,
> +		.offset = 0,
> +	};
> +
> +	ret = btrfs_search_slot(NULL, BTRFS_I(inode)->root, &key, path, 0, 0);
> +	if (ret) {
> +		len = -EINVAL;
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
> +	iput(put_inode);
> +	return len;
> +}
> +
> +static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
> +				     size_t len, void *fs_data)
> +{
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_trans_handle *trans;
> +	int is_subvolume = inode->i_ino == BTRFS_FIRST_FREE_OBJECTID;
> +	int ret;
> +	struct btrfs_path *path;
> +	struct btrfs_key key = {
> +		.objectid = btrfs_ino(BTRFS_I(inode)),
> +		.type = BTRFS_FSCRYPT_CTXT_ITEM_KEY,
> +		.offset = 0,
> +	};
> +
> +	/*
> +	 * If the whole subvolume is encrypted, we expect that all children
> +	 * have the same policy.
> +	 */
> +	if (btrfs_root_flags(&root->root_item) & BTRFS_ROOT_SUBVOL_FSCRYPT) {
> +		bool same_policy;
> +		struct inode *root_inode = NULL;

Newline.

> +		root_inode = btrfs_iget(inode->i_sb, BTRFS_FIRST_FREE_OBJECTID,
> +				   root);
> +		if (IS_ERR(inode))
> +			return PTR_ERR(inode);
> +		same_policy = fscrypt_have_same_policy(inode, root_inode);
> +		iput(root_inode);
> +		if (same_policy)
> +			return 0;
> +	}
> +
> +	if (fs_data) {
> +		/*
> +		 * We are setting the context as part of an existing
> +		 * transaction. This happens when we are inheriting the context
> +		 * for a new inode.
> +		 */
> +		trans = fs_data;
> +	} else {
> +		/*
> +		 * 1 for the inode item
> +		 * 1 for the fscrypt item
> +		 * 1 for the root item if the inode is a subvolume
> +		 */
> +		trans = btrfs_start_transaction(root, 2 + is_subvolume);
> +		if (IS_ERR(trans))
> +			return PTR_ERR(trans);
> +	}
> +
> +	path = btrfs_alloc_path();
> +	if (!path)

Gotta end the transaction here.

> +		return -ENOMEM;

Newline.

> +	ret = btrfs_search_slot(trans, BTRFS_I(inode)->root, &key, path, 0, 1);
> +	if (ret == 0) {
> +		struct extent_buffer *leaf = path->nodes[0];
> +		unsigned long ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +		len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
> +		write_extent_buffer(leaf, ctx, ptr, len);
> +		btrfs_mark_buffer_dirty(leaf);
> +		btrfs_free_path(path);
> +		goto out;
> +	} else if (ret < 0) {
> +		goto out;
> +	}

I prefer the

> +	btrfs_free_path(path);
> +
> +	ret = btrfs_insert_item(trans, BTRFS_I(inode)->root, &key, (void *) ctx, len);
> +	if (ret)
> +		goto out;

Use btrfs_release_path, and then use btrfs_insert_empty_item() so you don't have
to re-allocate another path.  In fact this whole thing can be done like this

ret = search;
if (ret < 0) {
	goto out;
} else if (ret == 1) {
	btrfs_release_path(path);
	ret = btrfs_insert_empty_item();
	if (ret < 0)
		goto out;
}

leaf = path->nodes[0];
ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
write_extent_buffer(leaf, ctx, ptr, len);
btrfs_mark_buffer_dirty(leaf);
btrfs_release_path(path);

because the bit below still needs to happen, the iversion needs to change and
such even if we already have the context because we changed the context of the
inode.

> +
> +	BTRFS_I(inode)->flags |= BTRFS_INODE_FSCRYPT_CONTEXT;
> +	btrfs_sync_inode_flags_to_i_flags(inode);
> +	inode_inc_iversion(inode);
> +	inode->i_ctime = current_time(inode);
> +	ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
> +	if (ret)
> +		goto out;
> +
> +	/*
> +	 * For new subvolumes, the root item is already initialized with
> +	 * the BTRFS_ROOT_SUBVOL_FSCRYPT flag.
> +	 */
> +	if (!fs_data && is_subvolume) {
> +		u64 root_flags = btrfs_root_flags(&root->root_item);
> +
> +		btrfs_set_root_flags(&root->root_item,
> +				     root_flags |
> +				     BTRFS_ROOT_SUBVOL_FSCRYPT);
> +		ret = btrfs_update_root(trans, root->fs_info->tree_root,
> +					&root->root_key,
> +					&root->root_item);
> +	}
> +out:

Put

if (ret)
	btrfs_abort_transaction(trans, ret);

here because we'll need to abort the transaction if there was an error at this
point.  The error handling needs to be completely reworked, because we really
only need to abort if we have an error after we've inserted the context, any of
the errors before we do that are recoverable so we don't need to abort for that.

> +	if (fs_data)
> +		return ret;
> +
> +	if (ret)
> +		btrfs_abort_transaction(trans, ret);
> +	else
> +		btrfs_end_transaction(trans);

Additionally we always end the transaction.  The abort just aborts, it doesn't
end the transaction.

> +	return ret;
> +}
> +
> +static bool btrfs_fscrypt_empty_dir(struct inode *inode)
> +{
> +	/*
> +	 * We don't care about turning on encryption on a non-empty directory
> +	 * so we always return true.
> +	 */
> +	return true;
> +}
> +
>  const struct fscrypt_operations btrfs_fscrypt_ops = {
> +	.key_prefix = "btrfs:",
> +	.get_context = btrfs_fscrypt_get_context,
> +	.set_context = btrfs_fscrypt_set_context,
> +	.empty_dir = btrfs_fscrypt_empty_dir,
>  };
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index eb42e4bf55b9..007abdf6de93 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6278,6 +6278,34 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
>  	struct inode *inode = args->inode;
>  	int ret;
>  
> +	if (fscrypt_is_nokey_name(args->dentry))
> +		return -ENOKEY;
> +
> +	if (IS_ENCRYPTED(dir) &&
> +	    !(BTRFS_I(dir)->flags & BTRFS_INODE_FSCRYPT_CONTEXT)) {
> +		struct inode *root_inode;
> +		bool encrypt;
> +
> +		root_inode = btrfs_iget(inode->i_sb, BTRFS_FIRST_FREE_OBJECTID,
> +					BTRFS_I(dir)->root);
> +		if (IS_ERR(root_inode))
> +			return PTR_ERR(root_inode);
> +		/*
> +		 * TODO: perhaps instead of faking making a new dir to get a
> +		 * new context, it would be better to expose
> +		 * fscrypt_setup_encryption_info() for our use.
> +		 */
> +		ret = fscrypt_prepare_new_inode(root_inode, dir, &encrypt);
> +		if (!ret) {
> +			ret = fscrypt_set_context(dir, NULL);
> +			if (ret)
> +				fscrypt_put_encryption_info(dir);
> +		}
> +		iput(root_inode);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	if (!args->orphan) {
>  		ret = fscrypt_setup_filename(dir, &args->dentry->d_name, 0,
>  					     &args->fname);
> @@ -6311,6 +6339,8 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
>  	if (dir->i_security)
>  		(*trans_num_items)++;
>  #endif
> +	if (args->encrypt)
> +		(*trans_num_items)++; /* 1 to add fscrypt item */
>  	if (args->orphan) {
>  		/* 1 to add orphan item */
>  		(*trans_num_items)++;
> @@ -6564,6 +6594,14 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
>  		}
>  	}
>  
> +	if (args->encrypt) {
> +		ret = fscrypt_set_context(inode, trans);
> +		if (ret) {
> +			btrfs_abort_transaction(trans, ret);
> +			goto discard;
> +		}
> +	}
> +

Ok never mind the bit above about aborting the transaction if (fs_data) since
your'e doing it here.  Thanks,

Josef
