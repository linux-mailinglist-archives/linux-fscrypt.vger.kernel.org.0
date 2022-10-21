Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA81E60805E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Oct 2022 22:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiJUUyc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Oct 2022 16:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiJUUya (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Oct 2022 16:54:30 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA49A186
        for <linux-fscrypt@vger.kernel.org>; Fri, 21 Oct 2022 13:54:22 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id c8so1948224qvn.10
        for <linux-fscrypt@vger.kernel.org>; Fri, 21 Oct 2022 13:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3y577BPV6+vpEshzZdAZIXWdgzTXtiLDG9YfVqSFOr8=;
        b=ivCoVPzuujWmhS628RxcAM97MUio7oVuZMiX3Gm6r0hGyyS/DNEVjrEOx+8D5IIWZB
         TamKNu63qVqFMyJWa9nlox17vDg7egJOV6IcyhxAokYP5QXjQgrOBnqoh2VtZZDC9RrY
         0hZb/ZDIAngwjTWvPdk3PDjyMkw+3gNlcInLg4pkK/5uh4+hzWVOzBlMLeheaKF+o++y
         IBGq11tJLvFrn6wCknJKqW3LM+fJcmB084f4YHnRbN/9Tf/CEhU2uQ0OiAQzZ38XNCb/
         HMdIb1F9Yivpqh937C51WTiiZThhjFRR/p+wtXvQy4Ana+UhrDbN0uT9xngQ3jjn/+MD
         Mw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3y577BPV6+vpEshzZdAZIXWdgzTXtiLDG9YfVqSFOr8=;
        b=2HCv9gTkAHLbQdGnuEDeOl6os1yW/g38162KPRanFoTEW70M2jBiWz6/ZEuxfS2Jy/
         37EA6/evJ+vFura4FR44AoyFxbg4tuasdEsyb+6R9mW5Xl5YsPOCf+JPya7vcaZvMxve
         kE+ZtR6v3ZzaZaEmsqD5BVy/sfby99R2PJNelp5mMtb3/nAfennqmK02ogdUY77hdtAY
         zaWeyK2AAt+FqI2NdTYQpD+ZD1UzeUu24jCVM8UzuukkI8R/6TKJdlv2qxMoY16vLohH
         AT8XFgXtL7MUIC/5jQWPj9c74KPI1TaTJh3C6scJkbtFjjI8ZAZXGHX4KHgZKho/INcj
         9D/g==
X-Gm-Message-State: ACrzQf0FcDYqkrO4PShQwKfFAEL0jO7edBxyqNKcwgiUMVxm6vHEc+ep
        IHcv2l8mvftb9Q4dNc2fvGICVg==
X-Google-Smtp-Source: AMsMyM5XXkJ6GzYikUI8sHmyrlkfPg00Yydr68nE5l/EJbaWKMP9SNIp1Z31X4QnX+1Yuj7NsNaL/g==
X-Received: by 2002:a05:6214:2aaa:b0:4b1:94e6:6788 with SMTP id js10-20020a0562142aaa00b004b194e66788mr18678205qvb.68.1666385661095;
        Fri, 21 Oct 2022 13:54:21 -0700 (PDT)
Received: from localhost (cpe-174-109-170-245.nc.res.rr.com. [174.109.170.245])
        by smtp.gmail.com with ESMTPSA id k11-20020a05620a0b8b00b006ed99931456sm10184492qkh.88.2022.10.21.13.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 13:54:20 -0700 (PDT)
Date:   Fri, 21 Oct 2022 16:54:18 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v3 12/22] btrfs: add fscrypt_context items
Message-ID: <Y1MG+lqVDjv/hLID@localhost.localdomain>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
 <ba5f11ca3b9072c2fad6255acdd42787fdb17d62.1666281277.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba5f11ca3b9072c2fad6255acdd42787fdb17d62.1666281277.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 20, 2022 at 12:58:31PM -0400, Sweet Tea Dorminy wrote:
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
>  fs/btrfs/ctree.h                |   1 +
>  fs/btrfs/fscrypt.c              | 170 ++++++++++++++++++++++++++++++++
>  fs/btrfs/inode.c                |  39 ++++++++
>  fs/btrfs/ioctl.c                |   7 +-
>  fs/btrfs/tree-checker.c         |   1 +
>  include/uapi/linux/btrfs_tree.h |  12 +++
>  6 files changed, 229 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 389c4e988318..eb5bbed90e2e 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -32,6 +32,7 @@
>  #include "extent-io-tree.h"
>  #include "extent_io.h"
>  #include "extent_map.h"
> +#include "fscrypt.h"
>  #include "async-thread.h"
>  #include "block-rsv.h"
>  #include "locking.h"
> diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> index 48ab99dfe48d..4533ef922d8b 100644
> --- a/fs/btrfs/fscrypt.c
> +++ b/fs/btrfs/fscrypt.c
> @@ -1,7 +1,177 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
> +#include <linux/iversion.h>
>  #include "ctree.h"
> +#include "btrfs_inode.h"
> +#include "disk-io.h"
>  #include "fscrypt.h"
> +#include "transaction.h"
> +#include "xattr.h"
> +
> +static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
> +{
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_key key = {
> +		.objectid = btrfs_ino(BTRFS_I(inode)),
> +		.type = BTRFS_FSCRYPT_CTXT_ITEM_KEY,
> +		.offset = 0,
> +	};
> +	struct inode *put_inode = NULL;
> +	struct btrfs_path *path;
> +	struct extent_buffer *leaf;
> +	unsigned long ptr;
> +	int ret;
> +
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
> +
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

I don't love this, instead lets have a 

__btrfs_set_fscrypt_context(trans, inode, whatever)

and in here you do

if (fs_data)
	return __btrfs_set_fscrypt_context(trans, inode, whatever);

trans = btrfs_start_transaction(root, 2 + is_subvolume);
ret = __btrfs_set_fscrypt_context(trans, inode, whatever);
btrfs_end_transaction(trans);
return ret;

That'll make this a bit cleaner, especially in the error handling.

> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +	ret = btrfs_search_slot(trans, BTRFS_I(inode)->root, &key, path, 0, 1);
> +	if (ret == 0) {
> +		struct extent_buffer *leaf = path->nodes[0];
> +		unsigned long ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +
> +		len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
> +		write_extent_buffer(leaf, ctx, ptr, len);
> +		btrfs_mark_buffer_dirty(leaf);
> +		btrfs_free_path(path);
> +		goto out;
> +	} else if (ret < 0) {
> +		goto out;

You're leaking the path in this case.  In fact I'd like to see this reworked
into a helper since you're only using this to shortcut adding the item if it
already exists.  Thanks,

Josef
