Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA5B756B5E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 20:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjGQSL1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 14:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjGQSL1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 14:11:27 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D681FE4C
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 11:11:25 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id 6a1803df08f44-635f48814b4so21060166d6.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 11:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689617485; x=1692209485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=coaDh+EGqhV6xlyKxrn+z04ZkJRom+HPCqf7pstptvk=;
        b=3P68sMOIn7w0ntcDoRDkCPd20V/0AU25LrujPb3jNPv2+NSKzBt9kRFx3S3LHgJuJF
         rod6kBgYTQtFyWvEtmYDQMCBV1nUDKHpVZPQ0BItpknJB+OuTeAGGc6VIANdqnt15C4N
         aqSJkhr9uxcBCNB5mvEXjqfpF2V2BVpojG2bWkE9DVePexrpV2TPAfvWFfHs4WzEntrb
         aDAWwparQemQcBQTbjWOsuT5Mh5/palhCoJf9sFIYIeO4gOQUyeVrqOiVFvQvkTAwnaI
         Tz3KMW+UeLio9fUnAV0DST8nUC72lSZQOHy7EyIndGtyV82xmA/+eqMdbU48WIsKqzRl
         yqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689617485; x=1692209485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=coaDh+EGqhV6xlyKxrn+z04ZkJRom+HPCqf7pstptvk=;
        b=jhet/v9Ew/lNsGXKF80hrgN7dCPCd3Mt8HRikluEVKU37KLJ+3y6pNKdnEX6bfKRpm
         dnJDKq9KCg52zRfuKYbkGFE1oqiMRex3FbniYnnQjOD9D2GLQkHLJHhaL02TvASBLD7T
         pVeJDSjAfsfv6ZQw6CAYEtuNjbhJb4lG/4gp7UMs7nNwpNqPAePSzngZdEQ75CBXv/Ko
         uKxbiF2mEWZyyZXqmt3Vr/FHirsBcJO8tywFaHHRrQjR1vRfJc8GJNxOCvpVJNHVAEW7
         UUeCI71N2Elr7XEltQT3XYzilOVS6AtE92/X6WjaFFtZmOns7rBuZom8mZBLL4TSp/xF
         /XdA==
X-Gm-Message-State: ABy/qLbaN4KtsGgQwJPsr+5/ZiYEd9Cz8/5wPlO0MxsutZOaybD2gZ4U
        k8Bgpk/TXZ3YTi15T7ALorTr3w==
X-Google-Smtp-Source: APBJJlFpVGos28HoiF3FwoVbzH7N7R3XlbSoFcqHgVDKu20TO9C5SPuKSda3CwRi5MoJdo6yYmpiJQ==
X-Received: by 2002:a0c:9c42:0:b0:635:dfe1:c1f1 with SMTP id w2-20020a0c9c42000000b00635dfe1c1f1mr10059182qve.26.1689617484752;
        Mon, 17 Jul 2023 11:11:24 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id u17-20020a0cf1d1000000b0062de51d8a12sm91507qvl.26.2023.07.17.11.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 11:11:24 -0700 (PDT)
Date:   Mon, 17 Jul 2023 14:11:23 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 15/17] btrfs: start tracking extent encryption context
 info
Message-ID: <20230717181123.GO691303@perftesting>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
 <dc1087224f6a330acd8ae80e7c81c70a0cd8ad30.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc1087224f6a330acd8ae80e7c81c70a0cd8ad30.1689564024.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 16, 2023 at 11:52:46PM -0400, Sweet Tea Dorminy wrote:
> This puts the long-preserved 1-byte encryption field to work, storing
> whether the extent is encrypted and the length of its fscrypt_context.
> Since there is no way for a btrfs inode to be encrypted right now, we
> set context length to be 0 in all locations. We then update all the
> locations which check the size of an extent item to expect the size to
> agree with the context length.
> 
> The 1-byte field packs the encryption type and context length together,
> to avoid a format change. Right now we don't anticipate very many
> encryption policies, so 2 bits should be ample; similarly right now we
> can't imagine a context larger than fscrypt's current contexts, which
> are 40 bytes, so 6 bits is ample to store the context's size; and
> therefore we can pack these together into the one-byte encryption field
> without touching other space reserved for future use.
> 

I don't like this design, I think it doesn't give us enough flexibility.

I think I'd rather use the whole u8 to have the encryption policy, and then the
first u32 of the extent context is the size.  So something like

struct btrfs_encryption_context {
	__le32 len;
	__u8 context[0];
};

struct btrfs_file_extent {
	struct btrfs_encryption_context fscrypt_context[0];
};

It takes up a little more space but is more flexible and enables us more
flexibility in the future.

> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/accessors.h    | 31 +++++++++++++++++++++++++++++++
>  fs/btrfs/file-item.c    |  8 ++++++++
>  fs/btrfs/fscrypt.h      | 24 ++++++++++++++++++++++++
>  fs/btrfs/inode.c        | 26 ++++++++++++++++++++++----
>  fs/btrfs/tree-checker.c | 37 +++++++++++++++++++++++++++++--------
>  fs/btrfs/tree-log.c     |  3 +++
>  6 files changed, 117 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
> index ceadfc5d6c66..fbee45b9d9c2 100644
> --- a/fs/btrfs/accessors.h
> +++ b/fs/btrfs/accessors.h
> @@ -3,6 +3,8 @@
>  #ifndef BTRFS_ACCESSORS_H
>  #define BTRFS_ACCESSORS_H
>  
> +#include "fscrypt.h"
> +

I don't want to pull other dependencies into accessors.h, I want to make syncing
*something* into btrfs-progs easy.

>  struct btrfs_map_token {
>  	struct extent_buffer *eb;
>  	char *kaddr;
> @@ -936,6 +938,16 @@ BTRFS_SETGET_STACK_FUNCS(stack_file_extent_disk_num_bytes,
>  			 struct btrfs_file_extent_item, disk_num_bytes, 64);
>  BTRFS_SETGET_STACK_FUNCS(stack_file_extent_compression,
>  			 struct btrfs_file_extent_item, compression, 8);
> +BTRFS_SETGET_STACK_FUNCS(stack_file_extent_encryption,
> +			 struct btrfs_file_extent_item, encryption, 8);
> +static inline u8 btrfs_stack_file_extent_encryption_ctxsize(
> +	struct btrfs_file_extent_item *e)
> +{
> +	u8 ctxsize;
> +
> +	btrfs_unpack_encryption(e->encryption, NULL, &ctxsize);
> +	return ctxsize;
> +}

This helper can go into fscrypt with the other related helpers.

>  
>  
>  BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
> @@ -958,6 +970,25 @@ BTRFS_SETGET_FUNCS(file_extent_encryption, struct btrfs_file_extent_item,
>  BTRFS_SETGET_FUNCS(file_extent_other_encoding, struct btrfs_file_extent_item,
>  		   other_encoding, 16);
>  
> +static inline u8
> +btrfs_file_extent_encryption_ctxsize(const struct extent_buffer *eb,
> +				     struct btrfs_file_extent_item *e)
> +{
> +	u8 ctxsize;
> +
> +	btrfs_unpack_encryption(btrfs_file_extent_encryption(eb, e),
> +				NULL, &ctxsize);
> +	return ctxsize;
> +}

Same for this one.  Thanks,

Josef
