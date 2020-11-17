Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55352B72AA
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Nov 2020 00:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgKQXvb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Nov 2020 18:51:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgKQXva (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Nov 2020 18:51:30 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1656520707;
        Tue, 17 Nov 2020 23:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605657089;
        bh=6oD4Vlgq7Wd1NXyfD+kSPMdBxHmOX6ZkXGlIFmIH4BQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gly9nQ6TM/lHuVl02OETZV37z3djuNsAQ3+chLTTbWFUAzmh4Hz9hSSVpcnUuaPCI
         ypbLiCuYb2OCXHUVPGvHX18xS7udPgpuSaV6/QyWWkm34z8GatbTe5xDcnoNiZkSOi
         MUgjwIhBjNgFypCqtT9ZM10BsoC8acFL07TG4DAc=
Date:   Tue, 17 Nov 2020 15:51:27 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v7 2/8] blk-crypto: don't require user buffer alignment
Message-ID: <X7Rh/5ADHVywDtpq@sol.localdomain>
References: <20201117140708.1068688-1-satyat@google.com>
 <20201117140708.1068688-3-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117140708.1068688-3-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Nov 17, 2020 at 02:07:02PM +0000, Satya Tangirala wrote:
> Previously, blk-crypto-fallback required the offset and length of each bvec
> in a bio to be aligned to the crypto data unit size. This patch enables
> blk-crypto-fallback to work even if that's not the case - the requirement
> now is only that the total length of the data in the bio is aligned to
> the crypto data unit size.
> 
> Now that blk-crypto-fallback can handle bvecs not aligned to crypto data
> units, and we've ensured that bios are not split in the middle of a
> crypto data unit, we can relax the alignment check done by blk-crypto.

I think the blk-crypto.c and blk-crypto-fallback.c changes belong in different
patches.

There should also be a brief explanation of why this is needed (make the
alignment requirements on direct I/O to encrypted files somewhat more similar to
standard unencrypted files, right)?.

Also, how were the blk-crypto-fallback changes tested?

> @@ -305,45 +374,57 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
>  	}
>  
>  	memcpy(curr_dun, bc->bc_dun, sizeof(curr_dun));
> -	sg_init_table(&src, 1);
> -	sg_init_table(&dst, 1);
>  
> -	skcipher_request_set_crypt(ciph_req, &src, &dst, data_unit_size,
> +	skcipher_request_set_crypt(ciph_req, src, dst, data_unit_size,
>  				   iv.bytes);
>  
> -	/* Encrypt each page in the bounce bio */
> +	/*
> +	 * Encrypt each data unit in the bounce bio.
> +	 *
> +	 * Take care to handle the case where a data unit spans bio segments.
> +	 * This can happen when data_unit_size > logical_block_size.
> +	 */
>  	for (i = 0; i < enc_bio->bi_vcnt; i++) {
> -		struct bio_vec *enc_bvec = &enc_bio->bi_io_vec[i];
> -		struct page *plaintext_page = enc_bvec->bv_page;
> +		struct bio_vec *bv = &enc_bio->bi_io_vec[i];
> +		struct page *plaintext_page = bv->bv_page;
>  		struct page *ciphertext_page =
>  			mempool_alloc(blk_crypto_bounce_page_pool, GFP_NOIO);
> +		unsigned int offset_in_bv = 0;
>  
> -		enc_bvec->bv_page = ciphertext_page;
> +		bv->bv_page = ciphertext_page;
>  
>  		if (!ciphertext_page) {
>  			src_bio->bi_status = BLK_STS_RESOURCE;
>  			goto out_free_bounce_pages;
>  		}
>  
> -		sg_set_page(&src, plaintext_page, data_unit_size,
> -			    enc_bvec->bv_offset);
> -		sg_set_page(&dst, ciphertext_page, data_unit_size,
> -			    enc_bvec->bv_offset);
> -
> -		/* Encrypt each data unit in this page */
> -		for (j = 0; j < enc_bvec->bv_len; j += data_unit_size) {
> -			blk_crypto_dun_to_iv(curr_dun, &iv);
> -			if (crypto_wait_req(crypto_skcipher_encrypt(ciph_req),
> -					    &wait)) {
> -				i++;
> -				src_bio->bi_status = BLK_STS_IOERR;
> -				goto out_free_bounce_pages;
> +		while (offset_in_bv < bv->bv_len) {
> +			unsigned int n = min(bv->bv_len - offset_in_bv,
> +					     data_unit_size - du_filled);
> +			sg_set_page(&src[sg_idx], plaintext_page, n,
> +				    bv->bv_offset + offset_in_bv);
> +			sg_set_page(&dst[sg_idx], ciphertext_page, n,
> +				    bv->bv_offset + offset_in_bv);
> +			sg_idx++;
> +			offset_in_bv += n;
> +			du_filled += n;
> +			if (du_filled == data_unit_size) {
> +				blk_crypto_dun_to_iv(curr_dun, &iv);
> +				if (crypto_wait_req(crypto_skcipher_encrypt(ciph_req),
> +						    &wait)) {
> +					src_bio->bi_status = BLK_STS_IOERR;
> +					goto out_free_bounce_pages;
> +				}
> +				bio_crypt_dun_increment(curr_dun, 1);
> +				sg_idx = 0;
> +				du_filled = 0;

This is leaking a bounce page if crypto_skcipher_encrypt() fails.  This can be
fixed either by keeping the 'i++' that was on the error path before, or by
moving the i++ in the for statement to just below to where the bounce page was
successfully allocated.

- Eric
