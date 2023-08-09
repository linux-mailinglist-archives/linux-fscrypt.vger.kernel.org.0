Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52557769C1
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Aug 2023 22:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbjHIUUh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Aug 2023 16:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234183AbjHIUUg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Aug 2023 16:20:36 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BFC10E9
        for <linux-fscrypt@vger.kernel.org>; Wed,  9 Aug 2023 13:20:36 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id 6a1803df08f44-63cf28db24cso1249356d6.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 09 Aug 2023 13:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1691612435; x=1692217235;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XWQZubJy5fe4HJfD+KBmH7rfaJgDj7qEiL71kxy2zOM=;
        b=P/0YE9sIIbQzLApSCmu+WVi3M9QwrUejABjNw7RnpUU58u0Su8RhWnYPXqz9jVlVqq
         GUL8xW0Qi1hqWG10JCiDdfAO7dXDzt3TwQ8ZBIT/qXAh2QSQS5M8ZIFo5IpNKR+OKpzc
         pck8dGVo26en6EzONN6RopjXt2Aic2TA9bVd5Ra3TJsrzaWWpAK05mhqRmm2FdV5YSEw
         PJFkLKVGKMP7Xd619R+z4cQYOHcPWmLAUcTFlyD2F9FSHMwfM3hR5J8CZtjZtgUajTTb
         9ow0EdyJG0SLU0wZBwMV+BI3KQAliH9efgIoaT6Fni2kbapO/97Mjy+vIbvUS5iczdmv
         oC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691612435; x=1692217235;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWQZubJy5fe4HJfD+KBmH7rfaJgDj7qEiL71kxy2zOM=;
        b=glUKrwpiwDur6ACAlZn/IotWZn4x1MbMoz4fLcrF2dam16ubZdN5l7yAWxZcrR1c2f
         3Bdcr+t9olnw/trQfEQsoNHV8YCQ2VdX0aZJWATJXPepLzpaLnmrDD0mrCtaIAJnCJoj
         8sAMPWQv84AzRAHzbK3aX41ocdSjNPZJQ7jj1pr5zoO4qrFkcbHzUnh0/ZAKiXV944k5
         o8Yo3l83FNzAZcDuQpIBNBRQpTtgId3O5O93SUtk0fxzJPVKxih7zD7oWbWaP62ws0o6
         o49ol2KadW6OQlx+rMelBoPcIRnuYdWbQeGaz7+nO66AZGc+t0wLJbUiDahKZfYPqaZc
         PkUg==
X-Gm-Message-State: AOJu0Yy6YoM/Rv4rrheqKT9BtthIaQaJ1JkP0Sp6XDx27e8i0IYzFIMU
        hJxoqdPHisKQffE9/vdaUmHPhg==
X-Google-Smtp-Source: AGHT+IE9S98DbL9assJLZ0xl/GHNdzgEgG3j2gSJZJ11zssDKzagigOly5yH+vkZ0LcmWOk36/veuA==
X-Received: by 2002:ad4:4191:0:b0:63d:281d:d9cf with SMTP id e17-20020ad44191000000b0063d281dd9cfmr272891qvp.64.1691612435419;
        Wed, 09 Aug 2023 13:20:35 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id i18-20020a0cf392000000b006166d870243sm4706396qvk.43.2023.08.09.13.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 13:20:35 -0700 (PDT)
Date:   Wed, 9 Aug 2023 16:20:34 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v3 05/17] btrfs: add inode encryption contexts
Message-ID: <20230809202034.GB2561679@perftesting>
References: <cover.1691510179.git.sweettea-kernel@dorminy.me>
 <e23d5dd675fe80c1be78d77284b8529d38a6ad3a.1691510179.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e23d5dd675fe80c1be78d77284b8529d38a6ad3a.1691510179.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:12:07PM -0400, Sweet Tea Dorminy wrote:
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
> index 3a53dc59c1e4..d09d42210f37 100644
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
> +	struct btrfs_trans_handle *trans = fs_data;
> +	struct btrfs_key key = {
> +		.objectid = btrfs_ino(BTRFS_I(inode)),
> +		.type = BTRFS_FSCRYPT_CTX_ITEM_KEY,
> +		.offset = 0,
> +	};
> +	struct btrfs_path *path;
> +	int ret;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	if (!trans)
> +		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 1);

This doesn't appear to be called without a trans, so this whole !trans case can
be eliminated.

Additionally it doesn't appear the inode context will exist ever, so you can
just unconditionally insert the empty item and update it.  Thanks,

Josef
