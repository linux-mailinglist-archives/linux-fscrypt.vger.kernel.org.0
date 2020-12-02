Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68E62CC9F8
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Dec 2020 23:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgLBWxh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Dec 2020 17:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgLBWxh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Dec 2020 17:53:37 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE275C061A4A
        for <linux-fscrypt@vger.kernel.org>; Wed,  2 Dec 2020 14:52:56 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id x15so53773pll.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 02 Dec 2020 14:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w13vKkQO9QCP0aR5R9Nv4FOw9sZU+DjLBFqmX3t26s8=;
        b=rxIMvrsLz416YTkoh8oP0XwIZGWM+lG9YJHHqWJFZPAJfdeUMvP8RjKlfZq98Rtmoj
         51XR5TMkAuVUmfbpRWeUYX2kReToKwMJxeCDaQAD4wb5BBQ0YDsOsp2MZViotWu9SI0X
         WYaing/GdzvYBEdsc7YEhc1/eVjqn58Lq2HNaKlwDFLykzFGKRaBJifz1RKFCWORX67N
         QqpxoNgr1sMlhz0EOwRyFVFgilPv7b58VK8xZ9L1w6ZREg/iO+rECdVjZ+SPYpk3mtv5
         n5AWnXd9VZw9D/DC4Ps2r8qIYENdVpJpYlEEmCS8ymJK3QZlqa5Q0FD0/c2TZbobCLnq
         GdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w13vKkQO9QCP0aR5R9Nv4FOw9sZU+DjLBFqmX3t26s8=;
        b=VKbUPDOkFjoGPIH9frKjACmjDZ+PWWlryb0LLmk64HxGaw7NeC+BCkb9xj/xm1wEpp
         aVJZ5BuBfxLCh774B1DrNZwoJboO++jyHF+8oIENtlX5rj8erZhuA5lWHSO0/FxhwjMN
         a54V6FHN8AmR+RJFooXGzm5VimTW2+haMTlB+/lfsNuk2vR2DgPN/6MjdDLwP8rrOygQ
         RakJhXnd9UIuSgliEzQbitooGZPOU0ErSiqE+xqJeSj54AZSkm4CZlUjl/Ldu4SZC5h2
         RmDBpWD3yPpzd4HCQvO4R7t7C4HGW12eXU6bpgMjVP6bDGYf3dnofyePPH+FnJQCPQUB
         eGiw==
X-Gm-Message-State: AOAM530mMX6iyM9aRoQIRHiWCHPOC4tAPGhNqGj6yA+rRYiN1UxX2g33
        u265S9Lo2L7RmXhUWA7+WbFgyA==
X-Google-Smtp-Source: ABdhPJxMYQCCb1zJfnzSpLJeB756gwkPBF5cUE4tVCqByyJoHNiQ65qHwLsKgJXa31l+PERlBN+Reg==
X-Received: by 2002:a17:902:9307:b029:d9:d097:fd6c with SMTP id bc7-20020a1709029307b02900d9d097fd6cmr302473plb.10.1606949576165;
        Wed, 02 Dec 2020 14:52:56 -0800 (PST)
Received: from google.com (154.137.233.35.bc.googleusercontent.com. [35.233.137.154])
        by smtp.gmail.com with ESMTPSA id z22sm119458pfn.153.2020.12.02.14.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:52:55 -0800 (PST)
Date:   Wed, 2 Dec 2020 22:52:51 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v7 1/8] block: ensure bios are not split in middle of
 crypto data unit
Message-ID: <X8gaw4ouQQFd9unN@google.com>
References: <20201117140708.1068688-1-satyat@google.com>
 <20201117140708.1068688-2-satyat@google.com>
 <X7RdS2cINwFkl/MN@sol.localdomain>
 <20201118003815.GA1155188@google.com>
 <X77W05O8Pl8t0gPi@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X77W05O8Pl8t0gPi@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 25, 2020 at 02:12:35PM -0800, Eric Biggers wrote:
> On Wed, Nov 18, 2020 at 12:38:15AM +0000, Satya Tangirala wrote:
> > > > +/**
> > > > + * update_aligned_sectors_and_segs() - Ensures that *@aligned_sectors is aligned
> > > > + *				       to @bio_sectors_alignment, and that
> > > > + *				       *@aligned_segs is the value of nsegs
> > > > + *				       when sectors reached/first exceeded that
> > > > + *				       value of *@aligned_sectors.
> > > > + *
> > > > + * @nsegs: [in] The current number of segs
> > > > + * @sectors: [in] The current number of sectors
> > > > + * @aligned_segs: [in,out] The number of segments that make up @aligned_sectors
> > > > + * @aligned_sectors: [in,out] The largest number of sectors <= @sectors that is
> > > > + *		     aligned to @sectors
> > > > + * @bio_sectors_alignment: [in] The alignment requirement for the number of
> > > > + *			  sectors
> > > > + *
> > > > + * Updates *@aligned_sectors to the largest number <= @sectors that is also a
> > > > + * multiple of @bio_sectors_alignment. This is done by updating *@aligned_sectors
> > > > + * whenever @sectors is at least @bio_sectors_alignment more than
> > > > + * *@aligned_sectors, since that means we can increment *@aligned_sectors while
> > > > + * still keeping it aligned to @bio_sectors_alignment and also keeping it <=
> > > > + * @sectors. *@aligned_segs is updated to the value of nsegs when @sectors first
> > > > + * reaches/exceeds any value that causes *@aligned_sectors to be updated.
> > > > + */
> > > > +static inline void update_aligned_sectors_and_segs(const unsigned int nsegs,
> > > > +						   const unsigned int sectors,
> > > > +						   unsigned int *aligned_segs,
> > > > +				unsigned int *aligned_sectors,
> > > > +				const unsigned int bio_sectors_alignment)
> > > > +{
> > > > +	if (sectors - *aligned_sectors < bio_sectors_alignment)
> > > > +		return;
> > > > +	*aligned_sectors = round_down(sectors, bio_sectors_alignment);
> > > > +	*aligned_segs = nsegs;
> > > > +}
> > > > +
> > > >  /**
> > > >   * bvec_split_segs - verify whether or not a bvec should be split in the middle
> > > >   * @q:        [in] request queue associated with the bio associated with @bv
> > > > @@ -195,9 +232,12 @@ static inline unsigned get_max_segment_size(const struct request_queue *q,
> > > >   * the block driver.
> > > >   */
> > > >  static bool bvec_split_segs(const struct request_queue *q,
> > > > -			    const struct bio_vec *bv, unsigned *nsegs,
> > > > -			    unsigned *sectors, unsigned max_segs,
> > > > -			    unsigned max_sectors)
> > > > +			    const struct bio_vec *bv, unsigned int *nsegs,
> > > > +			    unsigned int *sectors, unsigned int *aligned_segs,
> > > > +			    unsigned int *aligned_sectors,
> > > > +			    unsigned int bio_sectors_alignment,
> > > > +			    unsigned int max_segs,
> > > > +			    unsigned int max_sectors)
> > > >  {
> > > >  	unsigned max_len = (min(max_sectors, UINT_MAX >> 9) - *sectors) << 9;
> > > >  	unsigned len = min(bv->bv_len, max_len);
> > > > @@ -211,6 +251,11 @@ static bool bvec_split_segs(const struct request_queue *q,
> > > >  
> > > >  		(*nsegs)++;
> > > >  		total_len += seg_size;
> > > > +		update_aligned_sectors_and_segs(*nsegs,
> > > > +						*sectors + (total_len >> 9),
> > > > +						aligned_segs,
> > > > +						aligned_sectors,
> > > > +						bio_sectors_alignment);
> > > >  		len -= seg_size;
> > > >  
> > > >  		if ((bv->bv_offset + total_len) & queue_virt_boundary(q))
> > > > @@ -235,6 +280,8 @@ static bool bvec_split_segs(const struct request_queue *q,
> > > >   * following is guaranteed for the cloned bio:
> > > >   * - That it has at most get_max_io_size(@q, @bio) sectors.
> > > >   * - That it has at most queue_max_segments(@q) segments.
> > > > + * - That the number of sectors in the returned bio is aligned to
> > > > + *   blk_crypto_bio_sectors_alignment(@bio)
> > > >   *
> > > >   * Except for discard requests the cloned bio will point at the bi_io_vec of
> > > >   * the original bio. It is the responsibility of the caller to ensure that the
> > > > @@ -252,6 +299,9 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
> > > >  	unsigned nsegs = 0, sectors = 0;
> > > >  	const unsigned max_sectors = get_max_io_size(q, bio);
> > > >  	const unsigned max_segs = queue_max_segments(q);
> > > > +	const unsigned int bio_sectors_alignment =
> > > > +					blk_crypto_bio_sectors_alignment(bio);
> > > > +	unsigned int aligned_segs = 0, aligned_sectors = 0;
> > > >  
> > > >  	bio_for_each_bvec(bv, bio, iter) {
> > > >  		/*
> > > > @@ -266,8 +316,14 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
> > > >  		    bv.bv_offset + bv.bv_len <= PAGE_SIZE) {
> > > >  			nsegs++;
> > > >  			sectors += bv.bv_len >> 9;
> > > > -		} else if (bvec_split_segs(q, &bv, &nsegs, &sectors, max_segs,
> > > > -					 max_sectors)) {
> > > > +			update_aligned_sectors_and_segs(nsegs, sectors,
> > > > +							&aligned_segs,
> > > > +							&aligned_sectors,
> > > > +							bio_sectors_alignment);
> > > > +		} else if (bvec_split_segs(q, &bv, &nsegs, &sectors,
> > > > +					   &aligned_segs, &aligned_sectors,
> > > > +					   bio_sectors_alignment, max_segs,
> > > > +					   max_sectors)) {
> > > >  			goto split;
> > > >  		}
> > > >  
> > > > @@ -275,11 +331,24 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
> > > >  		bvprvp = &bvprv;
> > > >  	}
> > > >  
> > > > +	/*
> > > > +	 * The input bio's number of sectors is assumed to be aligned to
> > > > +	 * bio_sectors_alignment. If that's the case, then this function should
> > > > +	 * ensure that aligned_segs == nsegs and aligned_sectors == sectors if
> > > > +	 * the bio is not going to be split.
> > > > +	 */
> > > > +	WARN_ON(aligned_segs != nsegs || aligned_sectors != sectors);
> > > >  	*segs = nsegs;
> > > >  	return NULL;
> > > >  split:
> > > > -	*segs = nsegs;
> > > > -	return bio_split(bio, sectors, GFP_NOIO, bs);
> > > > +	*segs = aligned_segs;
> > > > +	if (WARN_ON(aligned_sectors == 0))
> > > > +		goto err;
> > > > +	return bio_split(bio, aligned_sectors, GFP_NOIO, bs);
> > > > +err:
> > > > +	bio->bi_status = BLK_STS_IOERR;
> > > > +	bio_endio(bio);
> > > > +	return bio;
> > > >  }
> > > 
> > > This part is pretty complex.  Are you sure it's needed?  How was alignment to
> > > logical_block_size ensured before?
> > > 
> > Afaict, alignment to logical_block_size (lbs) is done by assuming that
> > bv->bv_len is always lbs aligned (among other things). Is that not the
> > case?
> 
> I believe that's the case; bvecs are logical_block_size aligned.
> 
> So the new thing (with data_unit_size > logical_block_size) is that
> bvec boundaries aren't necessarily valid split points anymore.
> 
> > 
> > If it is the case, that's what we're trying to avoid with this patch (we
> > want to be able to submit bios that have 2 bvecs that together make up a
> > single crypto data unit, for example). And this is complex because
> > multiple segments could "add up" to make up a single crypto data unit,
> > but this function's job is to limit both the number of segments *and*
> > the number of sectors - so when ensuring that the number of sectors is
> > aligned to crypto data unit size, we also want the smallest number of
> > segments that can make up that aligned number of sectors.
> 
> Does the number of physical segments that is calculated have to be exact, or
> could it be a slight overestimate?  If the purpose of the calculation is just to
> size scatterlists and to avoid exceeding the hardware limit on the number of
> physical segments (and at a quick glance that seems to be the purpose, though I
> didn't look at everything), it seems that a slight overestimate would be okay.
> 
> If so, couldn't the number of sectors could simply be rounded down to
> blk_crypto_bio_sectors_alignment(bio) when blk_bio_segment_split() actually
> calls bio_split()?  That would be much simpler; why doesn't that work?
> 
I was assuming we'd prefer the better bound, but yeah it would be much
simpler if an overestimate was alright.

I'll look through the users of that estimate to try to gauge better
whether overestimating is ok to do (although if someone can already
authoritatively say that it's ok/not ok to overestimate, that would be
awesome too :)).
> - Eric
