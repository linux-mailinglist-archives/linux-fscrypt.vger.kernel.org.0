Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D1B5B2795
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Sep 2022 22:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiIHUUB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Sep 2022 16:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiIHUUA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Sep 2022 16:20:00 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD015A817
        for <linux-fscrypt@vger.kernel.org>; Thu,  8 Sep 2022 13:19:59 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id s13so10958767qvq.10
        for <linux-fscrypt@vger.kernel.org>; Thu, 08 Sep 2022 13:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=H7GfvrNAVG1lQGUaaP60rsONyhN8fAcAeMvncfeh3Ew=;
        b=GQNicsRhKo8wAnVxfUfdSFiM9umQjY7WWmzpS3FtyBv/3Bh8UU0r9xB6xiDop3RgZi
         5pAs6VyinQiPRFJB+CFKLbto+RadsClDjMqdm8YF3ACteJPQvmh8Z1ATiInx7Deh5i1t
         jBynVD7NbsSkYrlfh+3Y5HxWmAKGEqsmLy+VITGlAk2Omp4r7PGfOS8AN7OsBotu95gz
         7R3RuTPAM0yjmHl+taQDNF5Srp76OnABsx3aRoCxJxmJ+IqF9A2BT4zpqrswRxJHF9OP
         q+G+p45nJl/3DrT7bk7EKuSq8TkObxM+8kYynROJ+yYmVycgguzxX2lcXGNrNElzkcAe
         Mjfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=H7GfvrNAVG1lQGUaaP60rsONyhN8fAcAeMvncfeh3Ew=;
        b=JOF1UPxUYSulF2STt+q4+bv3+6xqNtUkbK4qZ3S7EPDJcjBW6qUHZ1wRWAdoIQq+nN
         PKcOqI/W9V14B2a2qTjNA9QKYlMRQy/wGVKZ9aFvrbvICpsCYeTHiS53LmHUGQCD4Onl
         a5EEYD8eo6J9zbbR2VSIVyhmAoROmZaAokAOm7JobTSr2g9PthJwoQiTCVRzN/W5W/uY
         0v3Uh53Vfuk+223LFEqgpnogofbd2EYGnUjrm8mawy+f/W3LBYVY+ea9lWl12gw6WHdK
         yVd7m8G3X6yZH+UjOSKdNQWA2DMap32F9tI1DI+ElaKdkheBoVwAjifBHPaaW92ySbc8
         vb5w==
X-Gm-Message-State: ACgBeo1T5RvNrkhqW1fTA2qKpMDqqkLQh1PxD/LwtGDv4QpWilZ6+WI3
        lZt4/g9qynBBGaJHrJoPTiHeHA==
X-Google-Smtp-Source: AA6agR6GK6hwjESqUbHlNviXDBLqInCvNltc4szkNpTZ1nYmS+Ucwn25HPlLmtzIJ0Dx11d3UZ/8yA==
X-Received: by 2002:a05:6214:2301:b0:498:9f6f:28d with SMTP id gc1-20020a056214230100b004989f6f028dmr9100149qvb.5.1662668398528;
        Thu, 08 Sep 2022 13:19:58 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id f25-20020ac86ed9000000b003447ee0a6bfsm50991qtv.17.2022.09.08.13.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 13:19:58 -0700 (PDT)
Date:   Thu, 8 Sep 2022 16:19:57 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 19/20] btrfs: encrypt normal file extent data if
 appropriate
Message-ID: <YxpObXrY2WxYBGxb@localhost.localdomain>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <947e7f9899e2562063034587613c779ff3eac34a.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <947e7f9899e2562063034587613c779ff3eac34a.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:34PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> Add in the necessary calls to encrypt and decrypt data to achieve
> encryption of normal data.
>

A little more description of what these bounce pages are and what we're doing
with them.
 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/extent_io.c    | 56 ++++++++++++++++++++++++++++++++++++-----
>  fs/btrfs/file-item.c    |  9 +++++--
>  fs/btrfs/fscrypt.c      | 23 ++++++++++++++++-
>  fs/btrfs/tree-checker.c | 11 +++++---
>  4 files changed, 87 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index a467a7553bd9..8adcee599844 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -183,6 +183,7 @@ static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
>  {
>  	struct bio *bio;
>  	struct bio_vec *bv;
> +	struct page *first_page;
>  	struct inode *inode;
>  	int mirror_num;
>  
> @@ -191,13 +192,17 @@ static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
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
> @@ -2810,9 +2815,19 @@ static void end_bio_extent_writepage(struct btrfs_bio *bbio)
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
> @@ -2833,7 +2848,7 @@ static void end_bio_extent_writepage(struct btrfs_bio *bbio)
>  		}
>  
>  		end_extent_writepage(page, error, start, end);
> -
> +		fscrypt_free_bounce_page(bounce_page);
>  		btrfs_page_clear_writeback(fs_info, page, start, bvec->bv_len);
>  	}
>  
> @@ -3029,6 +3044,17 @@ static void end_bio_extent_readpage(struct btrfs_bio *bbio)
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

This thing.  Thanks,

Josef
