Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0BF2E9D1B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  4 Jan 2021 19:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbhADSeF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 4 Jan 2021 13:34:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbhADSeF (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 4 Jan 2021 13:34:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C26521D94;
        Mon,  4 Jan 2021 18:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609785204;
        bh=5RTQTTLvrWfSFS9I/7a2ALTxjPTFHXPskfaLm7jrlTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NY2/Wsv6KNsbneqkBwKFX+FDHKCx/vBNcP42+g+IL4O5MUNQjEPII27pcKFCY8ROE
         KAGiBrBkpr1dtDvTd0eaD7X41JvMdvZEeAflDSjJJHNYbKxUMY+pOgQMq7i+kgiJpX
         B7oBIkAlqvF3UFwSRVa3rwb/a19Ot9fBnPG8wA5GvBQTndYvvZDnBQDj+9EfFPdcX5
         oz8CnruRFST1H+nLLTCZa/8wO5ts4KJDNXDZlMcN1prOGrRAjjwb9UwdzBIyw4AbTK
         Go+1NosLv0tMNVo5N2NACqKnCAq1oWY1iSWwifTWarlFTbh2IUkeHVCEKF3iy3btNt
         eI5jT4RXNRClQ==
Date:   Mon, 4 Jan 2021 10:33:22 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: clean up post-read processing
Message-ID: <X/NfcslNOlB2mNHO@sol.localdomain>
References: <20201228232612.45538-1-ebiggers@kernel.org>
 <0f488de1-ec9d-b1f1-641c-d624fecbb12d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f488de1-ec9d-b1f1-641c-d624fecbb12d@huawei.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 04, 2021 at 04:43:56PM +0800, Chao Yu wrote:
> Hi Eric,
> 
> On 2021/1/4 11:45, Eric Biggers wrote:
> > That's already handled; I made it so that STEP_DECOMPRESS is only enabled when
> > it's actually needed.
> 
> Yup, now I see.
> 
> Some comments as below.
> 
> On 2020/12/29 7:26, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Rework the post-read processing logic to be much easier to understand.
> > 
> > At least one bug is fixed by this: if an I/O error occurred when reading
> > from disk, decryption and verity would be performed on the uninitialized
> > data, causing misleading messages in the kernel log.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---

Please only quote the parts you're actually replying to.

> > +static void f2fs_post_read_work(struct work_struct *work)
> >   {
> > -	queue_work(sbi->post_read_wq, work);
> > -}
> > +	struct bio_post_read_ctx *ctx =
> > +		container_of(work, struct bio_post_read_ctx, work);
> > +	struct bio *bio = ctx->bio;
> > -static void bio_post_read_processing(struct bio_post_read_ctx *ctx)
> > -{
> > -	/*
> > -	 * We use different work queues for decryption and for verity because
> > -	 * verity may require reading metadata pages that need decryption, and
> > -	 * we shouldn't recurse to the same workqueue.
> > -	 */
> > +	if (ctx->enabled_steps & STEP_DECRYPT)
> > +		fscrypt_decrypt_bio(bio);
> > -	if (ctx->enabled_steps & (1 << STEP_DECRYPT) ||
> > -		ctx->enabled_steps & (1 << STEP_DECOMPRESS)) {
> > -		INIT_WORK(&ctx->work, f2fs_post_read_work);
> > -		f2fs_enqueue_post_read_work(ctx->sbi, &ctx->work);
> > -		return;
> > -	}
> > +	if (ctx->enabled_steps & STEP_DECOMPRESS) {
> > +		struct bio_vec *bv;
> > +		struct bvec_iter_all iter_all;
> > +		bool all_compressed = true;
> > -	if (ctx->enabled_steps & (1 << STEP_VERITY)) {
> > -		INIT_WORK(&ctx->work, f2fs_verity_work);
> > -		fsverity_enqueue_verify_work(&ctx->work);
> > -		return;
> > -	}
> > +		bio_for_each_segment_all(bv, bio, iter_all) {
> > +			struct page *page = bv->bv_page;
> > +			/* PG_error will be set if decryption failed. */
> > +			bool failed = PageError(page);
> > -	__f2fs_read_end_io(ctx->bio, false, false);
> > -}
> > +			if (f2fs_is_compressed_page(page))
> > +				f2fs_end_read_compressed_page(page, failed);
> > +			else
> > +				all_compressed = false;
> > +		}
> > +		/*
> > +		 * Optimization: if all the bio's pages are compressed, then
> > +		 * scheduling the per-bio verity work is unnecessary, as verity
> > +		 * will be fully handled at the compression cluster level.
> > +		 */
> > +		if (all_compressed)
> > +			ctx->enabled_steps &= ~STEP_VERITY;
> > +	}
> 
> Can we wrap above logic into a function for cleanup?

Are you saying you want the STEP_DECOMPRESS handling in a new function, e.g.
f2fs_handle_step_decompress()?  I could do that, though this new function would
only be called from f2fs_post_read_work(), which isn't too long.  So I'm not
sure it would be better.

> > +/* Context for decompressing one cluster on the read IO path */
> >   struct decompress_io_ctx {
> >   	u32 magic;			/* magic number to indicate page is compressed */
> >   	struct inode *inode;		/* inode the context belong to */
> > @@ -1353,11 +1353,13 @@ struct decompress_io_ctx {
> >   	struct compress_data *cbuf;	/* virtual mapped address on cpages */
> >   	size_t rlen;			/* valid data length in rbuf */
> >   	size_t clen;			/* valid data length in cbuf */
> > -	atomic_t pending_pages;		/* in-flight compressed page count */
> > -	atomic_t verity_pages;		/* in-flight page count for verity */
> > -	bool failed;			/* indicate IO error during decompression */
> > +	atomic_t remaining_pages;	/* number of compressed pages remaining to be read */
> > +	refcount_t refcnt;		/* 1 for decompression and 1 for each page still in a bio */
> 
> Now, we use .remaining_pages to control to trigger cluster decompression;
> and .refcnt to control to release dic structure.
> 
> How about adding a bit more description about above info for better
> readability?

Would you like longer comments even though every other field in this struct has
a 1-line comment?

> > -void f2fs_free_dic(struct decompress_io_ctx *dic);
> > -void f2fs_decompress_end_io(struct page **rpages,
> > -			unsigned int cluster_size, bool err, bool verity);
> > +void f2fs_decompress_end_io(struct decompress_io_ctx *dic, bool failed);
> > +void f2fs_put_page_decompress_io_ctx(struct page *page);
> >   int f2fs_init_compress_ctx(struct compress_ctx *cc);
> >   void f2fs_destroy_compress_ctx(struct compress_ctx *cc);
> >   void f2fs_init_compress_info(struct f2fs_sb_info *sbi);
> > @@ -3915,6 +3916,14 @@ static inline struct page *f2fs_compress_control_page(struct page *page)
> >   }
> >   static inline int f2fs_init_compress_mempool(void) { return 0; }
> >   static inline void f2fs_destroy_compress_mempool(void) { }
> > +static inline void f2fs_end_read_compressed_page(struct page *page, bool failed)
> > +{
> > +	WARN_ON_ONCE(1);
> > +}
> > +static inline void f2fs_put_page_decompress_io_ctx(struct page *page)
> 
> f2fs_put_page_in_dic() or f2fs_put_dic_page()?

It's putting the decompression context of the page, not the page itself.  So I
feel the name I've proposed makes more sense.

> > diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
> > index 56b113e3cd6aa..9e2981733ea4a 100644
> > --- a/include/trace/events/f2fs.h
> > +++ b/include/trace/events/f2fs.h
> > @@ -1794,7 +1794,7 @@ DEFINE_EVENT(f2fs_zip_start, f2fs_compress_pages_start,
> >   	TP_ARGS(inode, cluster_idx, cluster_size, algtype)
> >   );
> > -DEFINE_EVENT(f2fs_zip_start, f2fs_decompress_pages_start,
> > +DEFINE_EVENT(f2fs_zip_start, f2fs_decompress_cluster_start,
> 
> I suggest keeping original tracepoint name, it can avoid breaking userspace
> binary or script.
> 

Tracepoints aren't a stable UAPI, and the new name is more logical because it
describes what is being decompressed rather than an implementation detail of
where the data is located (in pages).

- Eric
