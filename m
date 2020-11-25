Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918082C4AB1
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Nov 2020 23:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbgKYWMj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 Nov 2020 17:12:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730419AbgKYWMi (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 Nov 2020 17:12:38 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A1D4206D9;
        Wed, 25 Nov 2020 22:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606342357;
        bh=hK66DldNXXhim1OiuxkthjACLYkiH5SpObayEzgimgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WpO8/XdMGuHG0glw2anwNiim1Q6U5cI8zOmRIJjfTYS4+lSmC+AzkhIE0njfKXT8K
         Xfarz8UqxGBZIj9cJJGU6q63zM9ZLYZT9zOzLsO5G0Ok9LEdDzOn0nSSlEf3w+XhwL
         7yes19czCDgEEPNkeZRU4o34fdEfI9pUWTiPzUeU=
Date:   Wed, 25 Nov 2020 14:12:35 -0800
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
Message-ID: <X77W05O8Pl8t0gPi@sol.localdomain>
References: <20201117140708.1068688-1-satyat@google.com>
 <20201117140708.1068688-2-satyat@google.com>
 <X7RdS2cINwFkl/MN@sol.localdomain>
 <20201118003815.GA1155188@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118003815.GA1155188@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 18, 2020 at 12:38:15AM +0000, Satya Tangirala wrote:
> > > +/**
> > > + * update_aligned_sectors_and_segs() - Ensures that *@aligned_sectors is aligned
> > > + *				       to @bio_sectors_alignment, and that
> > > + *				       *@aligned_segs is the value of nsegs
> > > + *				       when sectors reached/first exceeded that
> > > + *				       value of *@aligned_sectors.
> > > + *
> > > + * @nsegs: [in] The current number of segs
> > > + * @sectors: [in] The current number of sectors
> > > + * @aligned_segs: [in,out] The number of segments that make up @aligned_sectors
> > > + * @aligned_sectors: [in,out] The largest number of sectors <= @sectors that is
> > > + *		     aligned to @sectors
> > > + * @bio_sectors_alignment: [in] The alignment requirement for the number of
> > > + *			  sectors
> > > + *
> > > + * Updates *@aligned_sectors to the largest number <= @sectors that is also a
> > > + * multiple of @bio_sectors_alignment. This is done by updating *@aligned_sectors
> > > + * whenever @sectors is at least @bio_sectors_alignment more than
> > > + * *@aligned_sectors, since that means we can increment *@aligned_sectors while
> > > + * still keeping it aligned to @bio_sectors_alignment and also keeping it <=
> > > + * @sectors. *@aligned_segs is updated to the value of nsegs when @sectors first
> > > + * reaches/exceeds any value that causes *@aligned_sectors to be updated.
> > > + */
> > > +static inline void update_aligned_sectors_and_segs(const unsigned int nsegs,
> > > +						   const unsigned int sectors,
> > > +						   unsigned int *aligned_segs,
> > > +				unsigned int *aligned_sectors,
> > > +				const unsigned int bio_sectors_alignment)
> > > +{
> > > +	if (sectors - *aligned_sectors < bio_sectors_alignment)
> > > +		return;
> > > +	*aligned_sectors = round_down(sectors, bio_sectors_alignment);
> > > +	*aligned_segs = nsegs;
> > > +}
> > > +
> > >  /**
> > >   * bvec_split_segs - verify whether or not a bvec should be split in the middle
> > >   * @q:        [in] request queue associated with the bio associated with @bv
> > > @@ -195,9 +232,12 @@ static inline unsigned get_max_segment_size(const struct request_queue *q,
> > >   * the block driver.
> > >   */
> > >  static bool bvec_split_segs(const struct request_queue *q,
> > > -			    const struct bio_vec *bv, unsigned *nsegs,
> > > -			    unsigned *sectors, unsigned max_segs,
> > > -			    unsigned max_sectors)
> > > +			    const struct bio_vec *bv, unsigned int *nsegs,
> > > +			    unsigned int *sectors, unsigned int *aligned_segs,
> > > +			    unsigned int *aligned_sectors,
> > > +			    unsigned int bio_sectors_alignment,
> > > +			    unsigned int max_segs,
> > > +			    unsigned int max_sectors)
> > >  {
> > >  	unsigned max_len = (min(max_sectors, UINT_MAX >> 9) - *sectors) << 9;
> > >  	unsigned len = min(bv->bv_len, max_len);
> > > @@ -211,6 +251,11 @@ static bool bvec_split_segs(const struct request_queue *q,
> > >  
> > >  		(*nsegs)++;
> > >  		total_len += seg_size;
> > > +		update_aligned_sectors_and_segs(*nsegs,
> > > +						*sectors + (total_len >> 9),
> > > +						aligned_segs,
> > > +						aligned_sectors,
> > > +						bio_sectors_alignment);
> > >  		len -= seg_size;
> > >  
> > >  		if ((bv->bv_offset + total_len) & queue_virt_boundary(q))
> > > @@ -235,6 +280,8 @@ static bool bvec_split_segs(const struct request_queue *q,
> > >   * following is guaranteed for the cloned bio:
> > >   * - That it has at most get_max_io_size(@q, @bio) sectors.
> > >   * - That it has at most queue_max_segments(@q) segments.
> > > + * - That the number of sectors in the returned bio is aligned to
> > > + *   blk_crypto_bio_sectors_alignment(@bio)
> > >   *
> > >   * Except for discard requests the cloned bio will point at the bi_io_vec of
> > >   * the original bio. It is the responsibility of the caller to ensure that the
> > > @@ -252,6 +299,9 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
> > >  	unsigned nsegs = 0, sectors = 0;
> > >  	const unsigned max_sectors = get_max_io_size(q, bio);
> > >  	const unsigned max_segs = queue_max_segments(q);
> > > +	const unsigned int bio_sectors_alignment =
> > > +					blk_crypto_bio_sectors_alignment(bio);
> > > +	unsigned int aligned_segs = 0, aligned_sectors = 0;
> > >  
> > >  	bio_for_each_bvec(bv, bio, iter) {
> > >  		/*
> > > @@ -266,8 +316,14 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
> > >  		    bv.bv_offset + bv.bv_len <= PAGE_SIZE) {
> > >  			nsegs++;
> > >  			sectors += bv.bv_len >> 9;
> > > -		} else if (bvec_split_segs(q, &bv, &nsegs, &sectors, max_segs,
> > > -					 max_sectors)) {
> > > +			update_aligned_sectors_and_segs(nsegs, sectors,
> > > +							&aligned_segs,
> > > +							&aligned_sectors,
> > > +							bio_sectors_alignment);
> > > +		} else if (bvec_split_segs(q, &bv, &nsegs, &sectors,
> > > +					   &aligned_segs, &aligned_sectors,
> > > +					   bio_sectors_alignment, max_segs,
> > > +					   max_sectors)) {
> > >  			goto split;
> > >  		}
> > >  
> > > @@ -275,11 +331,24 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
> > >  		bvprvp = &bvprv;
> > >  	}
> > >  
> > > +	/*
> > > +	 * The input bio's number of sectors is assumed to be aligned to
> > > +	 * bio_sectors_alignment. If that's the case, then this function should
> > > +	 * ensure that aligned_segs == nsegs and aligned_sectors == sectors if
> > > +	 * the bio is not going to be split.
> > > +	 */
> > > +	WARN_ON(aligned_segs != nsegs || aligned_sectors != sectors);
> > >  	*segs = nsegs;
> > >  	return NULL;
> > >  split:
> > > -	*segs = nsegs;
> > > -	return bio_split(bio, sectors, GFP_NOIO, bs);
> > > +	*segs = aligned_segs;
> > > +	if (WARN_ON(aligned_sectors == 0))
> > > +		goto err;
> > > +	return bio_split(bio, aligned_sectors, GFP_NOIO, bs);
> > > +err:
> > > +	bio->bi_status = BLK_STS_IOERR;
> > > +	bio_endio(bio);
> > > +	return bio;
> > >  }
> > 
> > This part is pretty complex.  Are you sure it's needed?  How was alignment to
> > logical_block_size ensured before?
> > 
> Afaict, alignment to logical_block_size (lbs) is done by assuming that
> bv->bv_len is always lbs aligned (among other things). Is that not the
> case?

I believe that's the case; bvecs are logical_block_size aligned.

So the new thing (with data_unit_size > logical_block_size) is that
bvec boundaries aren't necessarily valid split points anymore.

> 
> If it is the case, that's what we're trying to avoid with this patch (we
> want to be able to submit bios that have 2 bvecs that together make up a
> single crypto data unit, for example). And this is complex because
> multiple segments could "add up" to make up a single crypto data unit,
> but this function's job is to limit both the number of segments *and*
> the number of sectors - so when ensuring that the number of sectors is
> aligned to crypto data unit size, we also want the smallest number of
> segments that can make up that aligned number of sectors.

Does the number of physical segments that is calculated have to be exact, or
could it be a slight overestimate?  If the purpose of the calculation is just to
size scatterlists and to avoid exceeding the hardware limit on the number of
physical segments (and at a quick glance that seems to be the purpose, though I
didn't look at everything), it seems that a slight overestimate would be okay.

If so, couldn't the number of sectors could simply be rounded down to
blk_crypto_bio_sectors_alignment(bio) when blk_bio_segment_split() actually
calls bio_split()?  That would be much simpler; why doesn't that work?

- Eric
