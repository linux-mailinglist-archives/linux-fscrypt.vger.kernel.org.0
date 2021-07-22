Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24FFD3D2C4A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 22 Jul 2021 21:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhGVSYP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 22 Jul 2021 14:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhGVSYP (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 22 Jul 2021 14:24:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9748D60EB9;
        Thu, 22 Jul 2021 19:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626980689;
        bh=oWDsz2mqAq9NcEEh1BJyznZQCPm+facoTqPnYlRRhJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QilYXNDAdzMfF+frM57wtEsK8q1xBhGM/Fw6ySzsoC5LukRf2pi9r343XIPOGGjhw
         inNMRBNKyr2+WCSrrUv7uZJuoNSJm64GbfIJc7Nquu2D6EMLTWmWw7Xcm69xxwN3em
         MyoZQsSMilN6DlmympazHrgl3V3HkOqFgjlkpozftLq0ixlYnwg7iEVqAdfLcbBwTk
         ZW76MEHP/kBQ047J1PXSwSXqVmaV5PZ0ohUOezoWPe17OJPGuQKeNSN8UQV9MkpcKg
         zqijpJkmcGOjHCLVgEUIRAlnaOnsquR9/cTWbypuBNqFkKdQ78gVo4VnpOSwqM3DnS
         zmr2Bt9gIvk1A==
Date:   Thu, 22 Jul 2021 12:04:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v9 6/9] iomap: support direct I/O with fscrypt using
 blk-crypto
Message-ID: <20210722190449.GH559212@magnolia>
References: <20210604210908.2105870-1-satyat@google.com>
 <20210604210908.2105870-7-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604210908.2105870-7-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jun 04, 2021 at 09:09:05PM +0000, Satya Tangirala wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Set bio crypt contexts on bios by calling into fscrypt when required.
> No DUN contiguity checks are done - callers are expected to set up the
> iomap correctly to ensure that each bio submitted by iomap will not have
> blocks with incontiguous DUNs by calling fscrypt_limit_io_blocks()
> appropriately.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Co-developed-by: Satya Tangirala <satyat@google.com>
> Signed-off-by: Satya Tangirala <satyat@google.com>

Looks like a straightforward conversion...

Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/direct-io.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 9398b8c31323..1c825deb36a9 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -6,6 +6,7 @@
>  #include <linux/module.h>
>  #include <linux/compiler.h>
>  #include <linux/fs.h>
> +#include <linux/fscrypt.h>
>  #include <linux/iomap.h>
>  #include <linux/backing-dev.h>
>  #include <linux/uio.h>
> @@ -185,11 +186,14 @@ static void
>  iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
>  		unsigned len)
>  {
> +	struct inode *inode = file_inode(dio->iocb->ki_filp);
>  	struct page *page = ZERO_PAGE(0);
>  	int flags = REQ_SYNC | REQ_IDLE;
>  	struct bio *bio;
>  
>  	bio = bio_alloc(GFP_KERNEL, 1);
> +	fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
> +				  GFP_KERNEL);
>  	bio_set_dev(bio, iomap->bdev);
>  	bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
>  	bio->bi_private = dio;
> @@ -306,6 +310,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
>  		}
>  
>  		bio = bio_alloc(GFP_KERNEL, nr_pages);
> +		fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
> +					  GFP_KERNEL);
>  		bio_set_dev(bio, iomap->bdev);
>  		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
>  		bio->bi_write_hint = dio->iocb->ki_hint;
> -- 
> 2.32.0.rc1.229.g3e70b5a671-goog
> 
