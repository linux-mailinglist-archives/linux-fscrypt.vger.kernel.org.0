Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D972C4AB5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Nov 2020 23:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732613AbgKYWPI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 Nov 2020 17:15:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730465AbgKYWPG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 Nov 2020 17:15:06 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 676AD206D9;
        Wed, 25 Nov 2020 22:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606342505;
        bh=//mTbDz2JjRGYIh1GwXxXW8kmqk4YvkDaY1/++XJIn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VY5RPIIyvrFY4c/vetEDGaxUA9jOSaakmSVQw0Q1OasRAiZUBJ/F7aSPHVJNJV4i6
         t408rVBospirzyiG4A0Bz0x10gjsY8A9wASMrrtC8rHc++m/VZ5sLatmlHd/f6CjyS
         /z2CHKSoNg4dCcDvPeFPMis8mAMTCtEVPIDia/1Q=
Date:   Wed, 25 Nov 2020 14:15:03 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v7 1/8] block: ensure bios are not split in middle of
 crypto data unit
Message-ID: <X77XZ/WVIuw9aCHb@sol.localdomain>
References: <20201117140708.1068688-1-satyat@google.com>
 <20201117140708.1068688-2-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117140708.1068688-2-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Nov 17, 2020 at 02:07:01PM +0000, Satya Tangirala wrote:
> @@ -275,11 +331,24 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>  		bvprvp = &bvprv;
>  	}
>  
> +	/*
> +	 * The input bio's number of sectors is assumed to be aligned to
> +	 * bio_sectors_alignment. If that's the case, then this function should
> +	 * ensure that aligned_segs == nsegs and aligned_sectors == sectors if
> +	 * the bio is not going to be split.
> +	 */
> +	WARN_ON(aligned_segs != nsegs || aligned_sectors != sectors);
>  	*segs = nsegs;
>  	return NULL;
>  split:
> -	*segs = nsegs;
> -	return bio_split(bio, sectors, GFP_NOIO, bs);
> +	*segs = aligned_segs;
> +	if (WARN_ON(aligned_sectors == 0))
> +		goto err;
> +	return bio_split(bio, aligned_sectors, GFP_NOIO, bs);
> +err:
> +	bio->bi_status = BLK_STS_IOERR;
> +	bio_endio(bio);
> +	return bio;
>  }
[...]
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 55bcee5dc032..de5c97ab8e5a 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2161,6 +2161,9 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
>  	blk_queue_bounce(q, &bio);
>  	__blk_queue_split(&bio, &nr_segs);
>  
> +	if (bio->bi_status != BLK_STS_OK)
> +		goto queue_exit;
> +

Note that as soon as bio_endio() is called, the bio may be freed.

So accessing the bio after that is not correct.

- Eric
