Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6C875682F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 17:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjGQPlQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 11:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjGQPlQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 11:41:16 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13299E1
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 08:41:15 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6b73c2b6dcfso2520200a34.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 08:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689608474; x=1692200474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eW/WSa+S0NeisYmQflPhqI5HK8U7MusU3ZnPZsJ2sdg=;
        b=xXIyAD37TFQdtNbVqVHEA1KGA5L4y7+7GR9FcUykDPsGft6BY2i5Uw7GvnSDxGEygr
         kv70oxUsDQoUXjXCcShGJkeYiburKrUQTKnbSmJBpvXsreTOPouRBHF75wDw/hgFLiyd
         aEdF9z6R2RS+jCpTkwDnBx+99KC7iMZIRfThSfDYD8NAWpTQyb9nFc+o6Cfhl7E7sZcY
         xmjmoS7SJeG9Rv03YUJGEITDodKpiEoQZ1SG7kOqHPmLNzuRUOHUdUcO2NOeoZzJey9i
         W9KbeACpCWRMyn1KGP5I9xRslXvloO0lXbuCKg28oN6kWi+LwAU4aKV+GOqR4b+yw9Gq
         QSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689608474; x=1692200474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eW/WSa+S0NeisYmQflPhqI5HK8U7MusU3ZnPZsJ2sdg=;
        b=EmTdjpbR8THXoTE0wOcX0GZ56IGNjHQrstsA/ZVngP8o0iKTaUiSJqL7spKHSxv/C6
         yxwtlotsLQNRCsNND0aJPPNBiYGRb5D4iJUOqIUXkocjmZoETqh6DpCzZ+9pyYqBm3U9
         pGlrFiEx4dxqCevOIblNlLU8gvqfpxledcfls+UtTqWn/Wzd+ge9g/Vqq1lfUOofiVD5
         EARPMWa6C+ynCFe+zN+ksKP2dB0Im5nc4Md0iBefEF8ZgnV+T+eY0IFdth0OEUKTBJpD
         ZHzG/pH4VHBope2hnQwyMJ7rf1+ztERtfAbliKjWdYrWNoQ+5jTkC+0ZA1CMGtZbZYtF
         IN1w==
X-Gm-Message-State: ABy/qLZaCGDjUUWa7SLWH3/5h7NGkguwpq9lraiRVm9tlBWdhqDn/aMb
        0Md1ghV39LzwteBoofrgi8Xm2g==
X-Google-Smtp-Source: APBJJlEqqrSTsZvMbxLTxeMf8C72fE35fpuqvvnX8UQjCvWSoiXFyourGayxw2mJPvqUS3vsIVS6Yw==
X-Received: by 2002:a05:6830:139a:b0:6b4:1486:73da with SMTP id d26-20020a056830139a00b006b4148673damr9398378otq.26.1689608474241;
        Mon, 17 Jul 2023 08:41:14 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id o2-20020a0ce402000000b00623839cba8csm6494940qvl.44.2023.07.17.08.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 08:41:13 -0700 (PDT)
Date:   Mon, 17 Jul 2023 11:41:12 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 05/17] btrfs: add inode encryption contexts
Message-ID: <20230717154112.GI691303@perftesting>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
 <0e56221de4fcded2c5150b77657e225a1a733047.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e56221de4fcded2c5150b77657e225a1a733047.1689564024.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 16, 2023 at 11:52:36PM -0400, Sweet Tea Dorminy wrote:
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
>  fs/btrfs/fscrypt.c              | 118 ++++++++++++++++++++++++++++++++
>  fs/btrfs/fscrypt.h              |   2 +
>  fs/btrfs/inode.c                |  19 +++++
>  fs/btrfs/ioctl.c                |   8 ++-
>  include/uapi/linux/btrfs_tree.h |  10 +++
>  5 files changed, 155 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> index 3a53dc59c1e4..1dfddf827cf8 100644
> --- a/fs/btrfs/fscrypt.c
> +++ b/fs/btrfs/fscrypt.c
> @@ -1,8 +1,126 @@
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
> +		.type = BTRFS_FSCRYPT_CTX_ITEM_KEY,
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
> +		len = -ENOENT;
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
> +		.type = BTRFS_FSCRYPT_CTX_ITEM_KEY,
> +		.offset = 0,
> +	};
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +

Reorder the declarations above to make it cleaner, add a newline between the
variables and allocating path.

> +	if (!trans)
> +		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 1);
> +	if (IS_ERR(trans))
> +		return PTR_ERR(trans);
> +
> +	ret = btrfs_search_slot(trans, BTRFS_I(inode)->root, &key, path, 0, 1);
> +	if (ret == 0) {
> +		btrfs_fscrypt_update_context(path, ctx, len);
> +		btrfs_free_path(path);

What do we do with the transaction if we started it above?  Are we responsible
for stopping the transaction if it was provided via fsdata?

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

We already have the path here, we can do

btrfs_release_path(path);
ret = btrfs_insert_empty_item(trans, BTRFS_I(inode)->root, &key, len);
if (ret) {
	btrfs_abort_transaction(trans, ret);
	btrfs_end_transaction(trans);
	return ret;
}

ptr = btrfs_item_ptr_offset(path->nodes[0], path->slots[0]);
write_extent_buffer(path->nodes[0], ctx, ptr, len);
btrfs_mark_buffer_dirty(path->nodes[0]);
btrfs_free_path(path);

> +	if (ret) {
> +		btrfs_abort_transaction(trans, ret);
> +		return ret;
> +	}
> +
> +	if (fs_data)
> +		return ret;
> +
> +	BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
> +	btrfs_sync_inode_flags_to_i_flags(inode);
> +	inode_inc_iversion(inode);
> +	inode->i_ctime = current_time(inode);
> +	ret = btrfs_update_inode(trans, BTRFS_I(inode)->root, BTRFS_I(inode));
> +	if (!ret) {
> +		btrfs_end_transaction(trans);
> +		return ret;
> +	}
> +
> +	btrfs_abort_transaction(trans, ret);

Still need to call end_transaction if we abort if we started it.  Thanks,

Josef
