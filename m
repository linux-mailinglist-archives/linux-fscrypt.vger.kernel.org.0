Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68B92EA2DA
	for <lists+linux-fscrypt@lfdr.de>; Tue,  5 Jan 2021 02:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbhAEB1l (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 4 Jan 2021 20:27:41 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9711 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbhAEB1l (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 4 Jan 2021 20:27:41 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D8vvd60ZQzl13c;
        Tue,  5 Jan 2021 09:25:49 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.212) with Microsoft SMTP Server (TLS) id 14.3.498.0; Tue, 5 Jan 2021
 09:26:55 +0800
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: clean up post-read processing
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-fscrypt@vger.kernel.org>
References: <20201228232612.45538-1-ebiggers@kernel.org>
 <0f488de1-ec9d-b1f1-641c-d624fecbb12d@huawei.com>
 <X/NfcslNOlB2mNHO@sol.localdomain>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <e29d64f5-f387-3feb-9f58-f3cc44e9124b@huawei.com>
Date:   Tue, 5 Jan 2021 09:26:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <X/NfcslNOlB2mNHO@sol.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2021/1/5 2:33, Eric Biggers wrote:
> On Mon, Jan 04, 2021 at 04:43:56PM +0800, Chao Yu wrote:
>> Hi Eric,
>>
>> On 2021/1/4 11:45, Eric Biggers wrote:
>>> That's already handled; I made it so that STEP_DECOMPRESS is only enabled when
>>> it's actually needed.
>>
>> Yup, now I see.
>>
>> Some comments as below.
>>
>> On 2020/12/29 7:26, Eric Biggers wrote:
>>> From: Eric Biggers <ebiggers@google.com>
>>>
>>> Rework the post-read processing logic to be much easier to understand.
>>>
>>> At least one bug is fixed by this: if an I/O error occurred when reading
>>> from disk, decryption and verity would be performed on the uninitialized
>>> data, causing misleading messages in the kernel log.
>>>
>>> Signed-off-by: Eric Biggers <ebiggers@google.com>
>>> ---
> 
> Please only quote the parts you're actually replying to.
> 
>>> +static void f2fs_post_read_work(struct work_struct *work)
>>>    {
>>> -	queue_work(sbi->post_read_wq, work);
>>> -}
>>> +	struct bio_post_read_ctx *ctx =
>>> +		container_of(work, struct bio_post_read_ctx, work);
>>> +	struct bio *bio = ctx->bio;
>>> -static void bio_post_read_processing(struct bio_post_read_ctx *ctx)
>>> -{
>>> -	/*
>>> -	 * We use different work queues for decryption and for verity because
>>> -	 * verity may require reading metadata pages that need decryption, and
>>> -	 * we shouldn't recurse to the same workqueue.
>>> -	 */
>>> +	if (ctx->enabled_steps & STEP_DECRYPT)
>>> +		fscrypt_decrypt_bio(bio);
>>> -	if (ctx->enabled_steps & (1 << STEP_DECRYPT) ||
>>> -		ctx->enabled_steps & (1 << STEP_DECOMPRESS)) {
>>> -		INIT_WORK(&ctx->work, f2fs_post_read_work);
>>> -		f2fs_enqueue_post_read_work(ctx->sbi, &ctx->work);
>>> -		return;
>>> -	}
>>> +	if (ctx->enabled_steps & STEP_DECOMPRESS) {
>>> +		struct bio_vec *bv;
>>> +		struct bvec_iter_all iter_all;
>>> +		bool all_compressed = true;
>>> -	if (ctx->enabled_steps & (1 << STEP_VERITY)) {
>>> -		INIT_WORK(&ctx->work, f2fs_verity_work);
>>> -		fsverity_enqueue_verify_work(&ctx->work);
>>> -		return;
>>> -	}
>>> +		bio_for_each_segment_all(bv, bio, iter_all) {
>>> +			struct page *page = bv->bv_page;
>>> +			/* PG_error will be set if decryption failed. */
>>> +			bool failed = PageError(page);
>>> -	__f2fs_read_end_io(ctx->bio, false, false);
>>> -}
>>> +			if (f2fs_is_compressed_page(page))
>>> +				f2fs_end_read_compressed_page(page, failed);
>>> +			else
>>> +				all_compressed = false;
>>> +		}
>>> +		/*
>>> +		 * Optimization: if all the bio's pages are compressed, then
>>> +		 * scheduling the per-bio verity work is unnecessary, as verity
>>> +		 * will be fully handled at the compression cluster level.
>>> +		 */
>>> +		if (all_compressed)
>>> +			ctx->enabled_steps &= ~STEP_VERITY;
>>> +	}
>>
>> Can we wrap above logic into a function for cleanup?
> 
> Are you saying you want the STEP_DECOMPRESS handling in a new function, e.g.

Yes, IMO, this will make bio_post_read_processing() more clean.

Something like:

	if (ctx->enabled_steps & STEP_DECOMPRESS) {
		f2fs_decompress_bio();

		/*
		 ...
		 */
		if (all_compressed)
			ctx->enabled_steps &= ~STEP_VERITY;
	}

> f2fs_handle_step_decompress()?  I could do that, though this new function would
> only be called from f2fs_post_read_work(), which isn't too long.  So I'm not

At least one more function name could explain a little bit more about what is doing
there.

> sure it would be better.
> 
>>> +/* Context for decompressing one cluster on the read IO path */
>>>    struct decompress_io_ctx {
>>>    	u32 magic;			/* magic number to indicate page is compressed */
>>>    	struct inode *inode;		/* inode the context belong to */
>>> @@ -1353,11 +1353,13 @@ struct decompress_io_ctx {
>>>    	struct compress_data *cbuf;	/* virtual mapped address on cpages */
>>>    	size_t rlen;			/* valid data length in rbuf */
>>>    	size_t clen;			/* valid data length in cbuf */
>>> -	atomic_t pending_pages;		/* in-flight compressed page count */
>>> -	atomic_t verity_pages;		/* in-flight page count for verity */
>>> -	bool failed;			/* indicate IO error during decompression */
>>> +	atomic_t remaining_pages;	/* number of compressed pages remaining to be read */
>>> +	refcount_t refcnt;		/* 1 for decompression and 1 for each page still in a bio */
>>
>> Now, we use .remaining_pages to control to trigger cluster decompression;
>> and .refcnt to control to release dic structure.
>>
>> How about adding a bit more description about above info for better
>> readability?
> 
> Would you like longer comments even though every other field in this struct has
> a 1-line comment?

Yes, it's fine to me, f2fs has many samples like this.

> 
>>> -void f2fs_free_dic(struct decompress_io_ctx *dic);
>>> -void f2fs_decompress_end_io(struct page **rpages,
>>> -			unsigned int cluster_size, bool err, bool verity);
>>> +void f2fs_decompress_end_io(struct decompress_io_ctx *dic, bool failed);
>>> +void f2fs_put_page_decompress_io_ctx(struct page *page);
>>>    int f2fs_init_compress_ctx(struct compress_ctx *cc);
>>>    void f2fs_destroy_compress_ctx(struct compress_ctx *cc);
>>>    void f2fs_init_compress_info(struct f2fs_sb_info *sbi);
>>> @@ -3915,6 +3916,14 @@ static inline struct page *f2fs_compress_control_page(struct page *page)
>>>    }
>>>    static inline int f2fs_init_compress_mempool(void) { return 0; }
>>>    static inline void f2fs_destroy_compress_mempool(void) { }
>>> +static inline void f2fs_end_read_compressed_page(struct page *page, bool failed)
>>> +{
>>> +	WARN_ON_ONCE(1);
>>> +}
>>> +static inline void f2fs_put_page_decompress_io_ctx(struct page *page)
>>
>> f2fs_put_page_in_dic() or f2fs_put_dic_page()?
> 
> It's putting the decompression context of the page, not the page itself.  So I
> feel the name I've proposed makes more sense.

Actually, my concern is the name looks a bit long, though it's not a big deal.

> 
>>> diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
>>> index 56b113e3cd6aa..9e2981733ea4a 100644
>>> --- a/include/trace/events/f2fs.h
>>> +++ b/include/trace/events/f2fs.h
>>> @@ -1794,7 +1794,7 @@ DEFINE_EVENT(f2fs_zip_start, f2fs_compress_pages_start,
>>>    	TP_ARGS(inode, cluster_idx, cluster_size, algtype)
>>>    );
>>> -DEFINE_EVENT(f2fs_zip_start, f2fs_decompress_pages_start,
>>> +DEFINE_EVENT(f2fs_zip_start, f2fs_decompress_cluster_start,
>>
>> I suggest keeping original tracepoint name, it can avoid breaking userspace
>> binary or script.
>>
> 
> Tracepoints aren't a stable UAPI, and the new name is more logical because it
> describes what is being decompressed rather than an implementation detail of
> where the data is located (in pages).

Both ..decompress_cluster.. or ..decompress_pages.. look fine to me, so I don't
think it's necessary for the name change, however after the change, developers/users
may suffer its side-effect that they have to change their script/binary to enable
the f2fs tracepoint according to kernel version.

Though tracepoint isn't a stable UAPI, I still don't want to break it.

Thanks,

> 
> - Eric
> .
> 
