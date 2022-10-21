Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A510C60806B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Oct 2022 22:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiJUU6f (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Oct 2022 16:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiJUU6d (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Oct 2022 16:58:33 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7642A3880
        for <linux-fscrypt@vger.kernel.org>; Fri, 21 Oct 2022 13:58:32 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id l9so306151qkk.11
        for <linux-fscrypt@vger.kernel.org>; Fri, 21 Oct 2022 13:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7+L3FGsQz5DlkZcXpDRveYfFBNXOZg8MRlHgTwPz7kY=;
        b=BovOz8Ppv7IQoe5z14TN5shX7nyQpTPLYt0kWCMAXrlyuH2L0vRCkHI3eSVXkxH+EN
         WHlwn8kUUpjES6gcNu2+gL+U6ET/ktZwvOtSuWabifIssuaR9/jfQxR/XP4hMTHC44Vy
         bPCRlUgMV+thmRUqMf+TZQxcHyHJGwd9CQvD7elTMZpiWhfBnyzTavRGxa6pwTYCNsGR
         Dc3H/wlEC7KQZ8SYIday+oGSuWzSN/6MVUvqyawMZxHa2gg/eRrDFiJqPnsF/VBvGvFu
         mC/Bmq5uXtIJSWHU0ZgGiajWJ5I9fl5p6cUUOthaLlY6gRIMRi5XUfM6iTeYmA18vq2W
         AiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+L3FGsQz5DlkZcXpDRveYfFBNXOZg8MRlHgTwPz7kY=;
        b=UPhI/Tz8/H+SSuTHGrOFHPqre5IquEFcZJ2Mfszdm+0OR38DNPmPwtdpg0gBTXtnKE
         cxUKvdMJj7sZJiHvvnBnyahbqv9AZrplZ+fasjzsGF2+gUeQtyJKl5/Gcz54dVu7YH3H
         PyJk28fIg60htnJxIalGm5+sLjavPci+byFZH1gL6izIVGWsD09K+69U89VZPUwPSYE7
         PDDz7izp9JO8dBlK4AN/ZqO/BMfyt5UuZY0R8gdEV0fwIcKvtToxgqLNYp7DFrsvBSdr
         ZxtM1HLSIv6qwCM6ADZvLjZ1xrcOZ0/JhsNaL6jO49j1fh3x08QdThFYfviFrEpCVBcb
         J5Jw==
X-Gm-Message-State: ACrzQf2AdB+tfGGdL5qrMZbIY2SK4myY5rrRb/wQAN61LEfp6y5YpVWr
        2duYM/nzImguCnh39bH1jb53SICEBYWbSA==
X-Google-Smtp-Source: AMsMyM4h1cqyFUqJoVguSb4/PwijZJ9E7mnuKHWih9OQvkoKgPYS/+oKtsUG0jpgqBrs2RCzgS7PVQ==
X-Received: by 2002:a05:620a:b10:b0:6ec:1601:bc75 with SMTP id t16-20020a05620a0b1000b006ec1601bc75mr16052349qkg.730.1666385911516;
        Fri, 21 Oct 2022 13:58:31 -0700 (PDT)
Received: from localhost (cpe-174-109-170-245.nc.res.rr.com. [174.109.170.245])
        by smtp.gmail.com with ESMTPSA id g8-20020ac87f48000000b0035cf31005e2sm8904797qtk.73.2022.10.21.13.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 13:58:30 -0700 (PDT)
Date:   Fri, 21 Oct 2022 16:58:29 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v3 15/22] btrfs: encrypt normal file extent data if
 appropriate
Message-ID: <Y1MH9VopVhJWWufS@localhost.localdomain>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
 <cfb16a33dd7f56c9f2d13a5645e670de8df93d96.1666281277.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfb16a33dd7f56c9f2d13a5645e670de8df93d96.1666281277.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 20, 2022 at 12:58:34PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> Add in the necessary calls to encrypt and decrypt data to achieve
> encryption of normal data.
> 
> Since these are all page cache pages being encrypted, we can't encrypt
> them in place and must encrypt/decrypt into a new page. fscrypt provides a pool
> of pages for this purpose, which it calls bounce pages. For IO of
> encrypted data, we use a bounce page for the actual IO, and
> encrypt/decrypt from/to the actual page cache page on either side of the
> IO.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/extent_io.c    | 56 ++++++++++++++++++++++++++++++++++++-----
>  fs/btrfs/file-item.c    |  9 +++++--
>  fs/btrfs/fscrypt.c      | 32 ++++++++++++++++++++++-
>  fs/btrfs/tree-checker.c | 11 +++++---
>  4 files changed, 96 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 4e4f28387ace..94d0636aafd0 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -113,6 +113,7 @@ static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
>  {
>  	struct bio *bio;
>  	struct bio_vec *bv;
> +	struct page *first_page;
>  	struct inode *inode;
>  	int mirror_num;
>  
> @@ -121,13 +122,17 @@ static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
>  
>  	bio = bio_ctrl->bio;
>  	bv = bio_first_bvec_all(bio);
> -	inode = bv->bv_page->mapping->host;
> +	first_page = bio_first_page_all(bio);
> +	if (fscrypt_is_bounce_page(first_page))
> +		inode = fscrypt_pagecache_page(first_page)->mapping->host;
> +	else
> +		inode = first_page->mapping->host;
>  	mirror_num = bio_ctrl->mirror_num;
>  
>  	/* Caller should ensure the bio has at least some range added */
>  	ASSERT(bio->bi_iter.bi_size);
>  
> -	btrfs_bio(bio)->file_offset = page_offset(bv->bv_page) + bv->bv_offset;
> +	btrfs_bio(bio)->file_offset = page_offset(first_page) + bv->bv_offset;
>  
>  	if (!is_data_inode(inode))
>  		btrfs_submit_metadata_bio(inode, bio, mirror_num);
> @@ -1014,9 +1019,19 @@ static void end_bio_extent_writepage(struct btrfs_bio *bbio)
>  	ASSERT(!bio_flagged(bio, BIO_CLONED));
>  	bio_for_each_segment_all(bvec, bio, iter_all) {
>  		struct page *page = bvec->bv_page;
> -		struct inode *inode = page->mapping->host;
> -		struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> -		const u32 sectorsize = fs_info->sectorsize;
> +		struct inode *inode;
> +		struct btrfs_fs_info *fs_info;
> +		u32 sectorsize;
> +		struct page *bounce_page = NULL;
> +
> +		if (fscrypt_is_bounce_page(page)) {
> +			bounce_page = page;
> +			page = fscrypt_pagecache_page(bounce_page);
> +		}
> +
> +		inode = page->mapping->host;
> +		fs_info = btrfs_sb(inode->i_sb);
> +		sectorsize = fs_info->sectorsize;
>  
>  		/* Our read/write should always be sector aligned. */
>  		if (!IS_ALIGNED(bvec->bv_offset, sectorsize))
> @@ -1037,7 +1052,7 @@ static void end_bio_extent_writepage(struct btrfs_bio *bbio)
>  		}
>  
>  		end_extent_writepage(page, error, start, end);
> -
> +		fscrypt_free_bounce_page(bounce_page);
>  		btrfs_page_clear_writeback(fs_info, page, start, bvec->bv_len);
>  	}
>  
> @@ -1229,6 +1244,17 @@ static void end_bio_extent_readpage(struct btrfs_bio *bbio)
>  			}
>  		}
>  
> +		if (likely(uptodate)) {
> +			if (fscrypt_inode_uses_fs_layer_crypto(inode)) {
> +				int ret = fscrypt_decrypt_pagecache_blocks(page,
> +									   bvec->bv_len,
> +									   bvec->bv_offset);
> +				if (ret) {
> +					error_bitmap = (unsigned int) -1;
> +					uptodate = false;
> +					}

Messed up indenting.

> +			}
> +		}
>  		if (likely(uptodate)) {
>  			loff_t i_size = i_size_read(inode);
>  			pgoff_t end_index = i_size >> PAGE_SHIFT;
> @@ -1563,11 +1589,29 @@ static int submit_extent_page(blk_opf_t opf,
>  			      bool force_bio_submit)
>  {
>  	int ret = 0;
> +	struct page *bounce_page = NULL;
>  	struct btrfs_inode *inode = BTRFS_I(page->mapping->host);
>  	unsigned int cur = pg_offset;
>  
>  	ASSERT(bio_ctrl);
>  
> +	if ((opf & REQ_OP_MASK) == REQ_OP_WRITE &&
> +	    fscrypt_inode_uses_fs_layer_crypto(&inode->vfs_inode)) {
> +		gfp_t gfp_flags = GFP_NOFS;
> +
> +		if (bio_ctrl->bio)
> +			gfp_flags = GFP_NOWAIT | __GFP_NOWARN;
> +		else
> +			gfp_flags = GFP_NOFS;
> +		bounce_page = fscrypt_encrypt_pagecache_blocks(page, size,
> +							       pg_offset,
> +							       gfp_flags);
> +		if (IS_ERR(bounce_page))
> +			return PTR_ERR(bounce_page);
> +		page = bounce_page;
> +		pg_offset = 0;
> +	}
> +
>  	ASSERT(pg_offset < PAGE_SIZE && size <= PAGE_SIZE &&
>  	       pg_offset + size <= PAGE_SIZE);
>  
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 598dff14078f..e4ec6a97a85c 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -676,8 +676,13 @@ blk_status_t btrfs_csum_one_bio(struct btrfs_inode *inode, struct bio *bio,
>  	shash->tfm = fs_info->csum_shash;
>  
>  	bio_for_each_segment(bvec, bio, iter) {
> -		if (use_page_offsets)
> -			offset = page_offset(bvec.bv_page) + bvec.bv_offset;
> +		if (use_page_offsets) {
> +			struct page *page = bvec.bv_page;
> +
> +			if (fscrypt_is_bounce_page(page))
> +				page = fscrypt_pagecache_page(page);
> +			offset = page_offset(page) + bvec.bv_offset;
> +		}
>  
>  		if (!ordered) {
>  			ordered = btrfs_lookup_ordered_extent(inode, offset);
> diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> index 717a9c244306..324436cba989 100644
> --- a/fs/btrfs/fscrypt.c
> +++ b/fs/btrfs/fscrypt.c
> @@ -175,7 +175,37 @@ static int btrfs_fscrypt_get_extent_context(const struct inode *inode,
>  					    size_t *extent_offset,
>  					    size_t *extent_length)
>  {
> -	return len;
> +	u64 offset = lblk_num << inode->i_blkbits;
> +	struct extent_map *em;
> +
> +	/* Since IO must be in progress on this extent, this must succeed */
> +	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, PAGE_SIZE);

If the bulk of the code is in the normal case, you need to invert the condition.
So instead

if (!em)
	return -EINVAL

// the rest of hte code at a normal indentation.

Thanks,

Josef
