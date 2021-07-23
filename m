Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E463A3D4237
	for <lists+linux-fscrypt@lfdr.de>; Fri, 23 Jul 2021 23:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhGWUwb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 23 Jul 2021 16:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231350AbhGWUwb (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 23 Jul 2021 16:52:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2201D60E95;
        Fri, 23 Jul 2021 21:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627075984;
        bh=eDyfTJkhAEqBNLOKOQEdjUlMWFhdZsosN6wkEEjmDxk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mpggqgv1U3DixYp5XcaYXBa21ZWRnY9mhiXBpGHEXXnlBVTVVQtjbI1XFIRjgq/3X
         J37lop3q4dq4yBeJl3GiuuL9Po+2k3Sx2yIeJo4NZYyXYTHCD2TDUXpjQCimJe1o2m
         vbSIQ4s1xdCv3hBTNP7vO567ZFhgjGqFzvDsaA6hXoTzqgsNFhunGUDTNb6mSWq/zM
         BaBteXbMxznNr0Csf/drNvX4o5A/KD24q8VrKeyH8fI/bOvZSsjnOPi2U0qCtu4npa
         aEtm+ZIU6GQ5sLA1JoXFE23vNBkLhgm5kgsKYESIMHpDDpfoljjoBM/GP18fSuicUF
         mN9xdY2W4of4A==
Date:   Fri, 23 Jul 2021 14:33:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v9 5/9] block: Make bio_iov_iter_get_pages() respect
 bio_required_sector_alignment()
Message-ID: <YPs1jlAsvXLomSJJ@gmail.com>
References: <20210604210908.2105870-1-satyat@google.com>
 <20210604210908.2105870-6-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604210908.2105870-6-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jun 04, 2021 at 09:09:04PM +0000, Satya Tangirala wrote:
> Previously, bio_iov_iter_get_pages() wasn't used with bios that could have
> an encryption context. However, direct I/O support using blk-crypto
> introduces this possibility, so this function must now respect
> bio_required_sector_alignment() (otherwise, xfstests like generic/465 with
> ext4 will fail).

Can you be more clear that the fscrypt direct I/O support only requires this in
order to support I/O segments that aren't fs-block aligned?

I do still wonder if we should just not support that...  Dave is the only person
who has asked for it, and it's a lot of trouble to support.

I also noticed that f2fs has always only supported direct I/O that is *fully*
fs-block aligned (including the I/O segments) anyway.  So presumably that
limitation is not really that important after all...

Does anyone else have thoughts on this?

One more comment on this patch below:

> 
> Signed-off-by: Satya Tangirala <satyat@google.com>
> ---
>  block/bio.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 32f75f31bb5c..99c510f706e2 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1099,7 +1099,8 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
>   * The function tries, but does not guarantee, to pin as many pages as
>   * fit into the bio, or are requested in @iter, whatever is smaller. If
>   * MM encounters an error pinning the requested pages, it stops. Error
> - * is returned only if 0 pages could be pinned.
> + * is returned only if 0 pages could be pinned. It also ensures that the number
> + * of sectors added to the bio is aligned to bio_required_sector_alignment().
>   *
>   * It's intended for direct IO, so doesn't do PSI tracking, the caller is
>   * responsible for setting BIO_WORKINGSET if necessary.
> @@ -1107,6 +1108,7 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
>  int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>  {
>  	int ret = 0;
> +	unsigned int aligned_sectors;
>  
>  	if (iov_iter_is_bvec(iter)) {
>  		if (bio_op(bio) == REQ_OP_ZONE_APPEND)
> @@ -1121,6 +1123,15 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>  			ret = __bio_iov_iter_get_pages(bio, iter);
>  	} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
>  
> +	/*
> +	 * Ensure that number of sectors in bio is aligned to
> +	 * bio_required_sector_align()
> +	 */
> +	aligned_sectors = round_down(bio_sectors(bio),
> +				     bio_required_sector_alignment(bio));
> +	iov_iter_revert(iter, (bio_sectors(bio) - aligned_sectors) << SECTOR_SHIFT);
> +	bio_truncate(bio, aligned_sectors << SECTOR_SHIFT);
> +
>  	/* don't account direct I/O as memory stall */
>  	bio_clear_flag(bio, BIO_WORKINGSET);
>  	return bio->bi_vcnt ? 0 : ret;

Doesn't this need to return an error if the bio's size gets rounded down to 0?
For example if logical_block_size=512 and data_unit_size=4096, and the iov_iter
points to 4096 bytes in 8 512-byte segments but the last one isn't mapped, then
7 pages would be pinned and the last one would fail.  This would then truncate
the bio's size to 0, but bio->bi_vcnt would be 7, so this would still return 0.
It would also be necessary to release the pages before returning an error.

- Eric
