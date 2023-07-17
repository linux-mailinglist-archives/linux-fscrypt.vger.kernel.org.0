Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09267756B13
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 19:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjGQR6E (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 13:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjGQR6E (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 13:58:04 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259D78E
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 10:58:03 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-765942d497fso450036785a.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 10:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689616682; x=1692208682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mnKxjdp9vNeEbBPWgCXbgEL+zZKvzVg81yS+adzFLTo=;
        b=ajdTpQhhMKWMfWInJ6n7a//mf4hAVJ0stb2MkFHZ2KRBaP8XRYM1GNwPQveC9cGYZ4
         gM7/6f3bf3dqOk8KOinsrH0vSUtsg+6TOpyCHyq9l/ds9OJQzUboPYZaGuI3Ifxe2rGW
         G6Mwsnpm0tQAYrIHLwmVfEMmpQCsyJ6Xrh/0/fGLgGmkbahX2xofnykFG9JFbU6zNYU6
         V49GWnN5IZAkF/xtncZHhywXN2uFj4VfyipXW8zt3sUIMiheGP07N1LwdwXuGX7l6P39
         I83f7UstXWl7FiIl3GZ3X2YYcFejOmhNvF0r6j0jh+VreEaBL76ZBvg5yzQ1ghWqwYBW
         Hq8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689616682; x=1692208682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mnKxjdp9vNeEbBPWgCXbgEL+zZKvzVg81yS+adzFLTo=;
        b=ZVY3aboqjrj4bfxPEFv/zaYOYkNrj75GdplqPqpM9efT/Q5pBJiI4ZA8oFZ9jT4SPr
         MRmk+7s+DNH27UGAA1eX/KE3zmGZrvaS48Pt5/QhsLVGndD37Tq0Fy/pXYTPcoYS2buy
         z9AZdjA7pZSUMMOztdK4ooRw/FhERuH/fGPUwQb0JaoPVhDwXmsZxdgb6zHIWkwRruUf
         xoRJNK1MEqq9CUVQMvmkdQIBdXUSjb8kZFKHVSPjNJEgurAL3WLlL2Tixf+n7uDYjmPf
         7oBSC8wgz5UjM/myaDlJ7SNdEWjrRrUrjl52x/9PTARLxYLKu7xMOeGsxzkwG9jWwSTo
         cpRw==
X-Gm-Message-State: ABy/qLaucC8fRiiD2ktAoReNYjataj7NpkIgIKMjLLrwQr7UZ0tJD4ta
        /l8NCliyEZBtgFDmdE3crb7G7g==
X-Google-Smtp-Source: APBJJlFs0LHrJo/wHVOPuAHBKkDCGV5EwMImys+qVjcw0Y2wkexGorZJaZIIJW7zO9bCmytqO3/Mug==
X-Received: by 2002:a37:5881:0:b0:768:2472:d4ac with SMTP id m123-20020a375881000000b007682472d4acmr1862302qkb.4.1689616682135;
        Mon, 17 Jul 2023 10:58:02 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id f23-20020a05620a15b700b007682697dcb0sm374844qkk.76.2023.07.17.10.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 10:58:01 -0700 (PDT)
Date:   Mon, 17 Jul 2023 13:58:00 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 14/17] btrfs: create and free extent fscrypt_infos
Message-ID: <20230717175800.GN691303@perftesting>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
 <fe6e2a2a1fb1c7e3942c83a496aed1694ccb5b44.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe6e2a2a1fb1c7e3942c83a496aed1694ccb5b44.1689564024.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 16, 2023 at 11:52:45PM -0400, Sweet Tea Dorminy wrote:
> Each extent_map will end up with a pointer to its associated
> fscrypt_info if any, which should have the same lifetime as the
> extent_map. Add creation of fscrypt_infos for new extent_maps, and
> freeing as appropriate.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/extent_map.c | 8 ++++++++
>  fs/btrfs/extent_map.h | 3 +++
>  fs/btrfs/inode.c      | 8 ++++++++
>  3 files changed, 19 insertions(+)
> 
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 0cdb3e86f29b..4fa5f97559da 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -65,6 +65,8 @@ void free_extent_map(struct extent_map *em)
>  	if (!em)
>  		return;
>  	if (refcount_dec_and_test(&em->refs)) {
> +		if (em->fscrypt_info)
> +			fscrypt_free_extent_info(&em->fscrypt_info);
>  		WARN_ON(extent_map_in_tree(em));
>  		WARN_ON(!list_empty(&em->list));
>  		if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
> @@ -207,6 +209,12 @@ static int mergable_maps(struct extent_map *prev, struct extent_map *next)
>  	if (!list_empty(&prev->list) || !list_empty(&next->list))
>  		return 0;
>  
> +	/*
> +	 * Don't merge adjacent encrypted maps.
> +	 */
> +	if (prev->fscrypt_info || next->fscrypt_info)
> +		return 0;
> +
>  	ASSERT(next->block_start != EXTENT_MAP_DELALLOC &&
>  	       prev->block_start != EXTENT_MAP_DELALLOC);
>  
> diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
> index 35d27c756e08..3a1b66b1cedf 100644
> --- a/fs/btrfs/extent_map.h
> +++ b/fs/btrfs/extent_map.h
> @@ -27,6 +27,8 @@ enum {
>  	EXTENT_FLAG_FS_MAPPING,
>  	/* This em is merged from two or more physically adjacent ems */
>  	EXTENT_FLAG_MERGED,
> +	/* This em has a fscrypt info */
> +	EXTENT_FLAG_ENCRYPTED,
>  };
>  
>  struct extent_map {
> @@ -50,6 +52,7 @@ struct extent_map {
>  	 */
>  	u64 generation;
>  	unsigned long flags;
> +	struct fscrypt_info *fscrypt_info;
>  	/* Used for chunk mappings, flag EXTENT_FLAG_FS_MAPPING must be set */
>  	struct map_lookup *map_lookup;
>  	refcount_t refs;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 40c2ec328730..b43fc253ecd1 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7460,6 +7460,14 @@ static struct extent_map *create_io_em(struct btrfs_inode *inode, u64 start,
>  		em->compress_type = compress_type;
>  	}
>  
> +	ret = fscrypt_prepare_new_extent(&inode->vfs_inode, &em->fscrypt_info);
> +	if (ret < 0) {
> +		free_extent_map(em);
> +		return ERR_PTR(ret);
> +	}
> +	if (em->fscrypt_info)
> +		set_bit(EXTENT_FLAG_ENCRYPTED, &em->flags);

We don't check this flag anywhere, you can drop it.  Thanks,

Josef
