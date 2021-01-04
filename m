Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132842E9219
	for <lists+linux-fscrypt@lfdr.de>; Mon,  4 Jan 2021 09:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbhADIou (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 4 Jan 2021 03:44:50 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:10381 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbhADIou (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 4 Jan 2021 03:44:50 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D8Tfj1ttpz7Q6Y;
        Mon,  4 Jan 2021 16:43:09 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.205) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 4 Jan 2021
 16:43:57 +0800
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: clean up post-read processing
To:     Eric Biggers <ebiggers@kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
CC:     <linux-fscrypt@vger.kernel.org>
References: <20201228232612.45538-1-ebiggers@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <0f488de1-ec9d-b1f1-641c-d624fecbb12d@huawei.com>
Date:   Mon, 4 Jan 2021 16:43:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20201228232612.45538-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On 2021/1/4 11:45, Eric Biggers wrote:
 > That's already handled; I made it so that STEP_DECOMPRESS is only enabled when
 > it's actually needed.

Yup, now I see.

Some comments as below.

On 2020/12/29 7:26, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Rework the post-read processing logic to be much easier to understand.
> 
> At least one bug is fixed by this: if an I/O error occurred when reading
> from disk, decryption and verity would be performed on the uninitialized
> data, causing misleading messages in the kernel log.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> v2: rebased onto v5.11-rc1.
> 
>   fs/f2fs/compress.c          | 159 +++++++++++-----
>   fs/f2fs/data.c              | 349 ++++++++++++++----------------------
>   fs/f2fs/f2fs.h              |  31 +++-
>   include/trace/events/f2fs.h |   4 +-
>   4 files changed, 271 insertions(+), 272 deletions(-)
> 
> diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
> index 4bcbacfe33259..66888b108f400 100644
> --- a/fs/f2fs/compress.c
> +++ b/fs/f2fs/compress.c
> @@ -721,38 +721,28 @@ static int f2fs_compress_pages(struct compress_ctx *cc)
>   	return ret;
>   }
>   
> -void f2fs_decompress_pages(struct bio *bio, struct page *page, bool verity)
> +static void f2fs_decompress_cluster(struct decompress_io_ctx *dic)
>   {
> -	struct decompress_io_ctx *dic =
> -			(struct decompress_io_ctx *)page_private(page);
>   	struct f2fs_sb_info *sbi = F2FS_I_SB(dic->inode);
> -	struct f2fs_inode_info *fi= F2FS_I(dic->inode);
> +	struct f2fs_inode_info *fi = F2FS_I(dic->inode);
>   	const struct f2fs_compress_ops *cops =
>   			f2fs_cops[fi->i_compress_algorithm];
>   	int ret;
>   	int i;
>   
> -	dec_page_count(sbi, F2FS_RD_DATA);
> -
> -	if (bio->bi_status || PageError(page))
> -		dic->failed = true;
> -
> -	if (atomic_dec_return(&dic->pending_pages))
> -		return;
> -
> -	trace_f2fs_decompress_pages_start(dic->inode, dic->cluster_idx,
> -				dic->cluster_size, fi->i_compress_algorithm);
> +	trace_f2fs_decompress_cluster_start(dic->inode, dic->cluster_idx,
> +					    dic->cluster_size,
> +					    fi->i_compress_algorithm);
>   
> -	/* submit partial compressed pages */
>   	if (dic->failed) {
>   		ret = -EIO;
> -		goto out_free_dic;
> +		goto out_end_io;
>   	}
>   
>   	dic->tpages = page_array_alloc(dic->inode, dic->cluster_size);
>   	if (!dic->tpages) {
>   		ret = -ENOMEM;
> -		goto out_free_dic;
> +		goto out_end_io;
>   	}
>   
>   	for (i = 0; i < dic->cluster_size; i++) {
> @@ -764,20 +754,20 @@ void f2fs_decompress_pages(struct bio *bio, struct page *page, bool verity)
>   		dic->tpages[i] = f2fs_compress_alloc_page();
>   		if (!dic->tpages[i]) {
>   			ret = -ENOMEM;
> -			goto out_free_dic;
> +			goto out_end_io;
>   		}
>   	}
>   
>   	if (cops->init_decompress_ctx) {
>   		ret = cops->init_decompress_ctx(dic);
>   		if (ret)
> -			goto out_free_dic;
> +			goto out_end_io;
>   	}
>   
>   	dic->rbuf = f2fs_vmap(dic->tpages, dic->cluster_size);
>   	if (!dic->rbuf) {
>   		ret = -ENOMEM;
> -		goto destroy_decompress_ctx;
> +		goto out_destroy_decompress_ctx;
>   	}
>   
>   	dic->cbuf = f2fs_vmap(dic->cpages, dic->nr_cpages);
> @@ -816,18 +806,34 @@ void f2fs_decompress_pages(struct bio *bio, struct page *page, bool verity)
>   	vm_unmap_ram(dic->cbuf, dic->nr_cpages);
>   out_vunmap_rbuf:
>   	vm_unmap_ram(dic->rbuf, dic->cluster_size);
> -destroy_decompress_ctx:
> +out_destroy_decompress_ctx:
>   	if (cops->destroy_decompress_ctx)
>   		cops->destroy_decompress_ctx(dic);
> -out_free_dic:
> -	if (!verity)
> -		f2fs_decompress_end_io(dic->rpages, dic->cluster_size,
> -								ret, false);
> -
> -	trace_f2fs_decompress_pages_end(dic->inode, dic->cluster_idx,
> -							dic->clen, ret);
> -	if (!verity)
> -		f2fs_free_dic(dic);
> +out_end_io:
> +	trace_f2fs_decompress_cluster_end(dic->inode, dic->cluster_idx,
> +					  dic->clen, ret);
> +	f2fs_decompress_end_io(dic, ret);
> +}
> +
> +/*
> + * This is called when a page of a compressed cluster has been read from disk
> + * (or failed to be read from disk).  It checks whether this page was the last
> + * page being waited on in the cluster, and if so, it decompresses the cluster
> + * (or in the case of a failure, cleans up without actually decompressing).
> + */
> +void f2fs_end_read_compressed_page(struct page *page, bool failed)
> +{
> +	struct decompress_io_ctx *dic =
> +			(struct decompress_io_ctx *)page_private(page);
> +	struct f2fs_sb_info *sbi = F2FS_I_SB(dic->inode);
> +
> +	dec_page_count(sbi, F2FS_RD_DATA);
> +
> +	if (failed)
> +		WRITE_ONCE(dic->failed, true);
> +
> +	if (atomic_dec_and_test(&dic->remaining_pages))
> +		f2fs_decompress_cluster(dic);
>   }
>   
>   static bool is_page_in_cluster(struct compress_ctx *cc, pgoff_t index)
> @@ -1494,6 +1500,8 @@ int f2fs_write_multi_pages(struct compress_ctx *cc,
>   	return err;
>   }
>   
> +static void f2fs_free_dic(struct decompress_io_ctx *dic);
> +
>   struct decompress_io_ctx *f2fs_alloc_dic(struct compress_ctx *cc)
>   {
>   	struct decompress_io_ctx *dic;
> @@ -1512,12 +1520,14 @@ struct decompress_io_ctx *f2fs_alloc_dic(struct compress_ctx *cc)
>   
>   	dic->magic = F2FS_COMPRESSED_PAGE_MAGIC;
>   	dic->inode = cc->inode;
> -	atomic_set(&dic->pending_pages, cc->nr_cpages);
> +	atomic_set(&dic->remaining_pages, cc->nr_cpages);
>   	dic->cluster_idx = cc->cluster_idx;
>   	dic->cluster_size = cc->cluster_size;
>   	dic->log_cluster_size = cc->log_cluster_size;
>   	dic->nr_cpages = cc->nr_cpages;
> +	refcount_set(&dic->refcnt, 1);
>   	dic->failed = false;
> +	dic->need_verity = f2fs_need_verity(cc->inode, start_idx);
>   
>   	for (i = 0; i < dic->cluster_size; i++)
>   		dic->rpages[i] = cc->rpages[i];
> @@ -1546,7 +1556,7 @@ struct decompress_io_ctx *f2fs_alloc_dic(struct compress_ctx *cc)
>   	return ERR_PTR(-ENOMEM);
>   }
>   
> -void f2fs_free_dic(struct decompress_io_ctx *dic)
> +static void f2fs_free_dic(struct decompress_io_ctx *dic)
>   {
>   	int i;
>   
> @@ -1574,30 +1584,89 @@ void f2fs_free_dic(struct decompress_io_ctx *dic)
>   	kmem_cache_free(dic_entry_slab, dic);
>   }
>   
> -void f2fs_decompress_end_io(struct page **rpages,
> -			unsigned int cluster_size, bool err, bool verity)
> +static void f2fs_put_dic(struct decompress_io_ctx *dic)
> +{
> +	if (refcount_dec_and_test(&dic->refcnt))
> +		f2fs_free_dic(dic);
> +}
> +
> +/*
> + * Update and unlock the cluster's decompressed pagecache pages, and release the
> + * reference to the decompress_io_ctx that was taken for decompression itself.
> + */
> +static void __f2fs_decompress_end_io(struct decompress_io_ctx *dic, bool failed)
>   {
>   	int i;
>   
> -	for (i = 0; i < cluster_size; i++) {
> -		struct page *rpage = rpages[i];
> +	for (i = 0; i < dic->cluster_size; i++) {
> +		struct page *rpage = dic->rpages[i];
>   
>   		if (!rpage)
>   			continue;
>   
> -		if (err || PageError(rpage))
> -			goto clear_uptodate;
> -
> -		if (!verity || fsverity_verify_page(rpage)) {
> +		/* PG_error was set if verity failed. */
> +		if (failed || PageError(rpage)) {
> +			ClearPageUptodate(rpage);
> +			/* will re-read again later */
> +			ClearPageError(rpage);
> +		} else {
>   			SetPageUptodate(rpage);
> -			goto unlock;
>   		}
> -clear_uptodate:
> -		ClearPageUptodate(rpage);
> -		ClearPageError(rpage);
> -unlock:
>   		unlock_page(rpage);
>   	}
> +
> +	f2fs_put_dic(dic);
> +}
> +
> +static void f2fs_verify_cluster(struct work_struct *work)
> +{
> +	struct decompress_io_ctx *dic =
> +		container_of(work, struct decompress_io_ctx, verity_work);
> +	int i;
> +
> +	/* Verify the cluster's decompressed pages with fs-verity. */
> +	for (i = 0; i < dic->cluster_size; i++) {
> +		struct page *rpage = dic->rpages[i];
> +
> +		if (rpage && !fsverity_verify_page(rpage))
> +			SetPageError(rpage);
> +	}
> +
> +	__f2fs_decompress_end_io(dic, false);
> +}
> +
> +/*
> + * This is called when a compressed cluster has been decompressed
> + * (or failed to be read and/or decompressed).
> + */
> +void f2fs_decompress_end_io(struct decompress_io_ctx *dic, bool failed)
> +{
> +	if (!failed && dic->need_verity) {
> +		/*
> +		 * Note that to avoid deadlocks, the verity work can't be done
> +		 * on the decompression workqueue.  This is because verifying
> +		 * the data pages can involve reading metadata pages from the
> +		 * file, and these metadata pages may be compressed.
> +		 */
> +		INIT_WORK(&dic->verity_work, f2fs_verify_cluster);
> +		fsverity_enqueue_verify_work(&dic->verity_work);
> +	} else {
> +		__f2fs_decompress_end_io(dic, failed);
> +	}
> +}
> +
> +/*
> + * Put a reference to the decompression context held by a compressed page in a
> + * bio.  We needed this reference in order to keep the compressed pages around
> + * until the bio(s) that contain them have been freed; sometimes that doesn't
> + * happen until after the decompression has finished.
> + */
> +void f2fs_put_page_decompress_io_ctx(struct page *page)
> +{
> +	struct decompress_io_ctx *dic =
> +			(struct decompress_io_ctx *)page_private(page);
> +
> +	f2fs_put_dic(dic);
>   }
>   
>   int f2fs_init_page_array_cache(struct f2fs_sb_info *sbi)
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index aa34d620bec98..d4e86639707f4 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -115,10 +115,21 @@ static enum count_type __read_io_type(struct page *page)
>   
>   /* postprocessing steps for read bios */
>   enum bio_post_read_step {
> -	STEP_DECRYPT,
> -	STEP_DECOMPRESS_NOWQ,		/* handle normal cluster data inplace */
> -	STEP_DECOMPRESS,		/* handle compressed cluster data in workqueue */
> -	STEP_VERITY,
> +#ifdef CONFIG_FS_ENCRYPTION
> +	STEP_DECRYPT	= 1 << 0,
> +#else
> +	STEP_DECRYPT	= 0,	/* compile out the decryption-related code */
> +#endif
> +#ifdef CONFIG_F2FS_FS_COMPRESSION
> +	STEP_DECOMPRESS	= 1 << 1,
> +#else
> +	STEP_DECOMPRESS	= 0,	/* compile out the decompression-related code */
> +#endif
> +#ifdef CONFIG_FS_VERITY
> +	STEP_VERITY	= 1 << 2,
> +#else
> +	STEP_VERITY	= 0,	/* compile out the verity-related code */
> +#endif
>   };
>   
>   struct bio_post_read_ctx {
> @@ -128,25 +139,26 @@ struct bio_post_read_ctx {
>   	unsigned int enabled_steps;
>   };
>   
> -static void __read_end_io(struct bio *bio, bool compr, bool verity)
> +static void f2fs_finish_read_bio(struct bio *bio)
>   {
> -	struct page *page;
>   	struct bio_vec *bv;
>   	struct bvec_iter_all iter_all;
>   
> +	/*
> +	 * Update and unlock the bio's pagecache pages, and put the
> +	 * decompression context for any compressed pages.
> +	 */
>   	bio_for_each_segment_all(bv, bio, iter_all) {
> -		page = bv->bv_page;
> +		struct page *page = bv->bv_page;
>   
> -#ifdef CONFIG_F2FS_FS_COMPRESSION
> -		if (compr && f2fs_is_compressed_page(page)) {
> -			f2fs_decompress_pages(bio, page, verity);
> +		if (f2fs_is_compressed_page(page)) {
> +			if (bio->bi_status)
> +				f2fs_end_read_compressed_page(page, true);
> +			f2fs_put_page_decompress_io_ctx(page);
>   			continue;
>   		}
> -		if (verity)
> -			continue;
> -#endif
>   
> -		/* PG_error was set if any post_read step failed */
> +		/* PG_error was set if decryption or verity failed. */
>   		if (bio->bi_status || PageError(page)) {
>   			ClearPageUptodate(page);
>   			/* will re-read again later */
> @@ -157,181 +169,129 @@ static void __read_end_io(struct bio *bio, bool compr, bool verity)
>   		dec_page_count(F2FS_P_SB(page), __read_io_type(page));
>   		unlock_page(page);
>   	}
> -}
> -
> -static void f2fs_release_read_bio(struct bio *bio);
> -static void __f2fs_read_end_io(struct bio *bio, bool compr, bool verity)
> -{
> -	if (!compr)
> -		__read_end_io(bio, false, verity);
> -	f2fs_release_read_bio(bio);
> -}
> -
> -static void f2fs_decompress_bio(struct bio *bio, bool verity)
> -{
> -	__read_end_io(bio, true, verity);
> -}
> -
> -static void bio_post_read_processing(struct bio_post_read_ctx *ctx);
> -
> -static void f2fs_decrypt_work(struct bio_post_read_ctx *ctx)
> -{
> -	fscrypt_decrypt_bio(ctx->bio);
> -}
> -
> -static void f2fs_decompress_work(struct bio_post_read_ctx *ctx)
> -{
> -	f2fs_decompress_bio(ctx->bio, ctx->enabled_steps & (1 << STEP_VERITY));
> -}
> -
> -#ifdef CONFIG_F2FS_FS_COMPRESSION
> -static void f2fs_verify_pages(struct page **rpages, unsigned int cluster_size)
> -{
> -	f2fs_decompress_end_io(rpages, cluster_size, false, true);
> -}
> -
> -static void f2fs_verify_bio(struct bio *bio)
> -{
> -	struct bio_vec *bv;
> -	struct bvec_iter_all iter_all;
>   
> -	bio_for_each_segment_all(bv, bio, iter_all) {
> -		struct page *page = bv->bv_page;
> -		struct decompress_io_ctx *dic;
> -
> -		dic = (struct decompress_io_ctx *)page_private(page);
> -
> -		if (dic) {
> -			if (atomic_dec_return(&dic->verity_pages))
> -				continue;
> -			f2fs_verify_pages(dic->rpages,
> -						dic->cluster_size);
> -			f2fs_free_dic(dic);
> -			continue;
> -		}
> -
> -		if (bio->bi_status || PageError(page))
> -			goto clear_uptodate;
> -
> -		if (fsverity_verify_page(page)) {
> -			SetPageUptodate(page);
> -			goto unlock;
> -		}
> -clear_uptodate:
> -		ClearPageUptodate(page);
> -		ClearPageError(page);
> -unlock:
> -		dec_page_count(F2FS_P_SB(page), __read_io_type(page));
> -		unlock_page(page);
> -	}
> +	if (bio->bi_private)
> +		mempool_free(bio->bi_private, bio_post_read_ctx_pool);
> +	bio_put(bio);
>   }
> -#endif
>   
> -static void f2fs_verity_work(struct work_struct *work)
> +static void f2fs_verify_bio(struct work_struct *work)
>   {
>   	struct bio_post_read_ctx *ctx =
>   		container_of(work, struct bio_post_read_ctx, work);
>   	struct bio *bio = ctx->bio;
> -#ifdef CONFIG_F2FS_FS_COMPRESSION
> -	unsigned int enabled_steps = ctx->enabled_steps;
> -#endif
> +	bool may_have_compressed_pages = (ctx->enabled_steps & STEP_DECOMPRESS);
>   
>   	/*
>   	 * fsverity_verify_bio() may call readpages() again, and while verity
> -	 * will be disabled for this, decryption may still be needed, resulting
> -	 * in another bio_post_read_ctx being allocated.  So to prevent
> -	 * deadlocks we need to release the current ctx to the mempool first.
> -	 * This assumes that verity is the last post-read step.
> +	 * will be disabled for this, decryption and/or decompression may still
> +	 * be needed, resulting in another bio_post_read_ctx being allocated.
> +	 * So to prevent deadlocks we need to release the current ctx to the
> +	 * mempool first.  This assumes that verity is the last post-read step.
>   	 */
>   	mempool_free(ctx, bio_post_read_ctx_pool);
>   	bio->bi_private = NULL;
>   
> -#ifdef CONFIG_F2FS_FS_COMPRESSION
> -	/* previous step is decompression */
> -	if (enabled_steps & (1 << STEP_DECOMPRESS)) {
> -		f2fs_verify_bio(bio);
> -		f2fs_release_read_bio(bio);
> -		return;
> +	/*
> +	 * Verify the bio's pages with fs-verity.  Exclude compressed pages,
> +	 * as those were handled separately by f2fs_end_read_compressed_page().
> +	 */
> +	if (may_have_compressed_pages) {
> +		struct bio_vec *bv;
> +		struct bvec_iter_all iter_all;
> +
> +		bio_for_each_segment_all(bv, bio, iter_all) {
> +			struct page *page = bv->bv_page;
> +
> +			if (!f2fs_is_compressed_page(page) &&
> +			    !PageError(page) && !fsverity_verify_page(page))
> +				SetPageError(page);
> +		}
> +	} else {
> +		fsverity_verify_bio(bio);
>   	}
> -#endif
>   
> -	fsverity_verify_bio(bio);
> -	__f2fs_read_end_io(bio, false, false);
> +	f2fs_finish_read_bio(bio);
>   }
>   
> -static void f2fs_post_read_work(struct work_struct *work)
> +/*
> + * If the bio's data needs to be verified with fs-verity, then enqueue the
> + * verity work for the bio.  Otherwise finish the bio now.
> + *
> + * Note that to avoid deadlocks, the verity work can't be done on the
> + * decryption/decompression workqueue.  This is because verifying the data pages
> + * can involve reading verity metadata pages from the file, and these verity
> + * metadata pages may be encrypted and/or compressed.
> + */
> +static void f2fs_verify_and_finish_bio(struct bio *bio)
>   {
> -	struct bio_post_read_ctx *ctx =
> -		container_of(work, struct bio_post_read_ctx, work);
> -
> -	if (ctx->enabled_steps & (1 << STEP_DECRYPT))
> -		f2fs_decrypt_work(ctx);
> +	struct bio_post_read_ctx *ctx = bio->bi_private;
>   
> -	if (ctx->enabled_steps & (1 << STEP_DECOMPRESS))
> -		f2fs_decompress_work(ctx);
> -
> -	if (ctx->enabled_steps & (1 << STEP_VERITY)) {
> -		INIT_WORK(&ctx->work, f2fs_verity_work);
> +	if (ctx && (ctx->enabled_steps & STEP_VERITY)) {
> +		INIT_WORK(&ctx->work, f2fs_verify_bio);
>   		fsverity_enqueue_verify_work(&ctx->work);
> -		return;
> +	} else {
> +		f2fs_finish_read_bio(bio);
>   	}
> -
> -	__f2fs_read_end_io(ctx->bio,
> -		ctx->enabled_steps & (1 << STEP_DECOMPRESS), false);
>   }
>   
> -static void f2fs_enqueue_post_read_work(struct f2fs_sb_info *sbi,
> -						struct work_struct *work)
> +static void f2fs_post_read_work(struct work_struct *work)
>   {
> -	queue_work(sbi->post_read_wq, work);
> -}
> +	struct bio_post_read_ctx *ctx =
> +		container_of(work, struct bio_post_read_ctx, work);
> +	struct bio *bio = ctx->bio;
>   
> -static void bio_post_read_processing(struct bio_post_read_ctx *ctx)
> -{
> -	/*
> -	 * We use different work queues for decryption and for verity because
> -	 * verity may require reading metadata pages that need decryption, and
> -	 * we shouldn't recurse to the same workqueue.
> -	 */
> +	if (ctx->enabled_steps & STEP_DECRYPT)
> +		fscrypt_decrypt_bio(bio);
>   
> -	if (ctx->enabled_steps & (1 << STEP_DECRYPT) ||
> -		ctx->enabled_steps & (1 << STEP_DECOMPRESS)) {
> -		INIT_WORK(&ctx->work, f2fs_post_read_work);
> -		f2fs_enqueue_post_read_work(ctx->sbi, &ctx->work);
> -		return;
> -	}
> +	if (ctx->enabled_steps & STEP_DECOMPRESS) {
> +		struct bio_vec *bv;
> +		struct bvec_iter_all iter_all;
> +		bool all_compressed = true;
>   
> -	if (ctx->enabled_steps & (1 << STEP_VERITY)) {
> -		INIT_WORK(&ctx->work, f2fs_verity_work);
> -		fsverity_enqueue_verify_work(&ctx->work);
> -		return;
> -	}
> +		bio_for_each_segment_all(bv, bio, iter_all) {
> +			struct page *page = bv->bv_page;
> +			/* PG_error will be set if decryption failed. */
> +			bool failed = PageError(page);
>   
> -	__f2fs_read_end_io(ctx->bio, false, false);
> -}
> +			if (f2fs_is_compressed_page(page))
> +				f2fs_end_read_compressed_page(page, failed);
> +			else
> +				all_compressed = false;
> +		}
> +		/*
> +		 * Optimization: if all the bio's pages are compressed, then
> +		 * scheduling the per-bio verity work is unnecessary, as verity
> +		 * will be fully handled at the compression cluster level.
> +		 */
> +		if (all_compressed)
> +			ctx->enabled_steps &= ~STEP_VERITY;
> +	}

Can we wrap above logic into a function for cleanup?

>   
> -static bool f2fs_bio_post_read_required(struct bio *bio)
> -{
> -	return bio->bi_private;
> +	f2fs_verify_and_finish_bio(bio);
>   }
>   
>   static void f2fs_read_end_io(struct bio *bio)
>   {
>   	struct f2fs_sb_info *sbi = F2FS_P_SB(bio_first_page_all(bio));
> +	struct bio_post_read_ctx *ctx = bio->bi_private;
>   
>   	if (time_to_inject(sbi, FAULT_READ_IO)) {
>   		f2fs_show_injection_info(sbi, FAULT_READ_IO);
>   		bio->bi_status = BLK_STS_IOERR;
>   	}
>   
> -	if (f2fs_bio_post_read_required(bio)) {
> -		struct bio_post_read_ctx *ctx = bio->bi_private;
> -
> -		bio_post_read_processing(ctx);
> +	if (bio->bi_status) {
> +		f2fs_finish_read_bio(bio);
>   		return;
>   	}
>   
> -	__f2fs_read_end_io(bio, false, false);
> +	if (ctx && (ctx->enabled_steps & (STEP_DECRYPT | STEP_DECOMPRESS))) {
> +		INIT_WORK(&ctx->work, f2fs_post_read_work);
> +		queue_work(ctx->sbi->post_read_wq, &ctx->work);
> +	} else {
> +		f2fs_verify_and_finish_bio(bio);
> +	}
>   }
>   
>   static void f2fs_write_end_io(struct bio *bio)
> @@ -1022,16 +982,9 @@ void f2fs_submit_page_write(struct f2fs_io_info *fio)
>   	up_write(&io->io_rwsem);
>   }
>   
> -static inline bool f2fs_need_verity(const struct inode *inode, pgoff_t idx)
> -{
> -	return fsverity_active(inode) &&
> -	       idx < DIV_ROUND_UP(inode->i_size, PAGE_SIZE);
> -}
> -
>   static struct bio *f2fs_grab_read_bio(struct inode *inode, block_t blkaddr,
>   				      unsigned nr_pages, unsigned op_flag,
> -				      pgoff_t first_idx, bool for_write,
> -				      bool for_verity)
> +				      pgoff_t first_idx, bool for_write)
>   {
>   	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
>   	struct bio *bio;
> @@ -1050,13 +1003,19 @@ static struct bio *f2fs_grab_read_bio(struct inode *inode, block_t blkaddr,
>   	bio_set_op_attrs(bio, REQ_OP_READ, op_flag);
>   
>   	if (fscrypt_inode_uses_fs_layer_crypto(inode))
> -		post_read_steps |= 1 << STEP_DECRYPT;
> -	if (f2fs_compressed_file(inode))
> -		post_read_steps |= 1 << STEP_DECOMPRESS_NOWQ;
> -	if (for_verity && f2fs_need_verity(inode, first_idx))
> -		post_read_steps |= 1 << STEP_VERITY;
> +		post_read_steps |= STEP_DECRYPT;
> +
> +	if (f2fs_need_verity(inode, first_idx))
> +		post_read_steps |= STEP_VERITY;
>   
> -	if (post_read_steps) {
> +	/*
> +	 * STEP_DECOMPRESS is handled specially, since a compressed file might
> +	 * contain both compressed and uncompressed clusters.  We'll allocate a
> +	 * bio_post_read_ctx if the file is compressed, but the caller is
> +	 * responsible for enabling STEP_DECOMPRESS if it's actually needed.
> +	 */
> +
> +	if (post_read_steps || f2fs_compressed_file(inode)) {
>   		/* Due to the mempool, this never fails. */
>   		ctx = mempool_alloc(bio_post_read_ctx_pool, GFP_NOFS);
>   		ctx->bio = bio;
> @@ -1068,13 +1027,6 @@ static struct bio *f2fs_grab_read_bio(struct inode *inode, block_t blkaddr,
>   	return bio;
>   }
>   
> -static void f2fs_release_read_bio(struct bio *bio)
> -{
> -	if (bio->bi_private)
> -		mempool_free(bio->bi_private, bio_post_read_ctx_pool);
> -	bio_put(bio);
> -}
> -
>   /* This can handle encryption stuffs */
>   static int f2fs_submit_page_read(struct inode *inode, struct page *page,
>   				 block_t blkaddr, int op_flags, bool for_write)
> @@ -1083,7 +1035,7 @@ static int f2fs_submit_page_read(struct inode *inode, struct page *page,
>   	struct bio *bio;
>   
>   	bio = f2fs_grab_read_bio(inode, blkaddr, 1, op_flags,
> -					page->index, for_write, true);
> +					page->index, for_write);
>   	if (IS_ERR(bio))
>   		return PTR_ERR(bio);
>   
> @@ -2121,7 +2073,7 @@ static int f2fs_read_single_page(struct inode *inode, struct page *page,
>   	if (bio == NULL) {
>   		bio = f2fs_grab_read_bio(inode, block_nr, nr_pages,
>   				is_readahead ? REQ_RAHEAD : 0, page->index,
> -				false, true);
> +				false);
>   		if (IS_ERR(bio)) {
>   			ret = PTR_ERR(bio);
>   			bio = NULL;
> @@ -2167,8 +2119,6 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
>   	sector_t last_block_in_file;
>   	const unsigned blocksize = blks_to_bytes(inode, 1);
>   	struct decompress_io_ctx *dic = NULL;
> -	struct bio_post_read_ctx *ctx;
> -	bool for_verity = false;
>   	int i;
>   	int ret = 0;
>   
> @@ -2234,29 +2184,10 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
>   		goto out_put_dnode;
>   	}
>   
> -	/*
> -	 * It's possible to enable fsverity on the fly when handling a cluster,
> -	 * which requires complicated error handling. Instead of adding more
> -	 * complexity, let's give a rule where end_io post-processes fsverity
> -	 * per cluster. In order to do that, we need to submit bio, if previous
> -	 * bio sets a different post-process policy.
> -	 */
> -	if (fsverity_active(cc->inode)) {
> -		atomic_set(&dic->verity_pages, cc->nr_cpages);
> -		for_verity = true;
> -
> -		if (bio) {
> -			ctx = bio->bi_private;
> -			if (!(ctx->enabled_steps & (1 << STEP_VERITY))) {
> -				__submit_bio(sbi, bio, DATA);
> -				bio = NULL;
> -			}
> -		}
> -	}
> -
>   	for (i = 0; i < dic->nr_cpages; i++) {
>   		struct page *page = dic->cpages[i];
>   		block_t blkaddr;
> +		struct bio_post_read_ctx *ctx;
>   
>   		blkaddr = data_blkaddr(dn.inode, dn.node_page,
>   						dn.ofs_in_node + i + 1);
> @@ -2272,31 +2203,10 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
>   		if (!bio) {
>   			bio = f2fs_grab_read_bio(inode, blkaddr, nr_pages,
>   					is_readahead ? REQ_RAHEAD : 0,
> -					page->index, for_write, for_verity);
> +					page->index, for_write);
>   			if (IS_ERR(bio)) {
> -				unsigned int remained = dic->nr_cpages - i;
> -				bool release = false;
> -
>   				ret = PTR_ERR(bio);
> -				dic->failed = true;
> -
> -				if (for_verity) {
> -					if (!atomic_sub_return(remained,
> -						&dic->verity_pages))
> -						release = true;
> -				} else {
> -					if (!atomic_sub_return(remained,
> -						&dic->pending_pages))
> -						release = true;
> -				}
> -
> -				if (release) {
> -					f2fs_decompress_end_io(dic->rpages,
> -						cc->cluster_size, true,
> -						false);
> -					f2fs_free_dic(dic);
> -				}
> -
> +				f2fs_decompress_end_io(dic, ret);
>   				f2fs_put_dnode(&dn);
>   				*bio_ret = NULL;
>   				return ret;
> @@ -2308,10 +2218,9 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
>   		if (bio_add_page(bio, page, blocksize, 0) < blocksize)
>   			goto submit_and_realloc;
>   
> -		/* tag STEP_DECOMPRESS to handle IO in wq */
>   		ctx = bio->bi_private;
> -		if (!(ctx->enabled_steps & (1 << STEP_DECOMPRESS)))
> -			ctx->enabled_steps |= 1 << STEP_DECOMPRESS;
> +		ctx->enabled_steps |= STEP_DECOMPRESS;
> +		refcount_inc(&dic->refcnt);
>   
>   		inc_page_count(sbi, F2FS_RD_DATA);
>   		f2fs_update_iostat(sbi, FS_DATA_READ_IO, F2FS_BLKSIZE);
> @@ -2328,7 +2237,13 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
>   out_put_dnode:
>   	f2fs_put_dnode(&dn);
>   out:
> -	f2fs_decompress_end_io(cc->rpages, cc->cluster_size, true, false);
> +	for (i = 0; i < cc->cluster_size; i++) {
> +		if (cc->rpages[i]) {
> +			ClearPageUptodate(cc->rpages[i]);
> +			ClearPageError(cc->rpages[i]);
> +			unlock_page(cc->rpages[i]);
> +		}
> +	}
>   	*bio_ret = bio;
>   	return ret;
>   }
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index bb11759191dcc..ed2ce437357c2 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1337,7 +1337,7 @@ struct compress_io_ctx {
>   	atomic_t pending_pages;		/* in-flight compressed page count */
>   };
>   
> -/* decompress io context for read IO path */
> +/* Context for decompressing one cluster on the read IO path */
>   struct decompress_io_ctx {
>   	u32 magic;			/* magic number to indicate page is compressed */
>   	struct inode *inode;		/* inode the context belong to */
> @@ -1353,11 +1353,13 @@ struct decompress_io_ctx {
>   	struct compress_data *cbuf;	/* virtual mapped address on cpages */
>   	size_t rlen;			/* valid data length in rbuf */
>   	size_t clen;			/* valid data length in cbuf */
> -	atomic_t pending_pages;		/* in-flight compressed page count */
> -	atomic_t verity_pages;		/* in-flight page count for verity */
> -	bool failed;			/* indicate IO error during decompression */
> +	atomic_t remaining_pages;	/* number of compressed pages remaining to be read */
> +	refcount_t refcnt;		/* 1 for decompression and 1 for each page still in a bio */

Now, we use .remaining_pages to control to trigger cluster decompression;
and .refcnt to control to release dic structure.

How about adding a bit more description about above info for better
readability?

> +	bool failed;			/* IO error occurred before decompression? */
> +	bool need_verity;		/* need fs-verity verification after decompression? */
>   	void *private;			/* payload buffer for specified decompression algorithm */
>   	void *private2;			/* extra payload buffer */
> +	struct work_struct verity_work;	/* work to verify the decompressed pages */
>   };
>   
>   #define NULL_CLUSTER			((unsigned int)(~0))
> @@ -3876,7 +3878,7 @@ void f2fs_compress_write_end_io(struct bio *bio, struct page *page);
>   bool f2fs_is_compress_backend_ready(struct inode *inode);
>   int f2fs_init_compress_mempool(void);
>   void f2fs_destroy_compress_mempool(void);
> -void f2fs_decompress_pages(struct bio *bio, struct page *page, bool verity);
> +void f2fs_end_read_compressed_page(struct page *page, bool failed);
>   bool f2fs_cluster_is_empty(struct compress_ctx *cc);
>   bool f2fs_cluster_can_merge_page(struct compress_ctx *cc, pgoff_t index);
>   void f2fs_compress_ctx_add_page(struct compress_ctx *cc, struct page *page);
> @@ -3889,9 +3891,8 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
>   				unsigned nr_pages, sector_t *last_block_in_bio,
>   				bool is_readahead, bool for_write);
>   struct decompress_io_ctx *f2fs_alloc_dic(struct compress_ctx *cc);
> -void f2fs_free_dic(struct decompress_io_ctx *dic);
> -void f2fs_decompress_end_io(struct page **rpages,
> -			unsigned int cluster_size, bool err, bool verity);
> +void f2fs_decompress_end_io(struct decompress_io_ctx *dic, bool failed);
> +void f2fs_put_page_decompress_io_ctx(struct page *page);
>   int f2fs_init_compress_ctx(struct compress_ctx *cc);
>   void f2fs_destroy_compress_ctx(struct compress_ctx *cc);
>   void f2fs_init_compress_info(struct f2fs_sb_info *sbi);
> @@ -3915,6 +3916,14 @@ static inline struct page *f2fs_compress_control_page(struct page *page)
>   }
>   static inline int f2fs_init_compress_mempool(void) { return 0; }
>   static inline void f2fs_destroy_compress_mempool(void) { }
> +static inline void f2fs_end_read_compressed_page(struct page *page, bool failed)
> +{
> +	WARN_ON_ONCE(1);
> +}
> +static inline void f2fs_put_page_decompress_io_ctx(struct page *page)

f2fs_put_page_in_dic() or f2fs_put_dic_page()?

> +{
> +	WARN_ON_ONCE(1);
> +}
>   static inline int f2fs_init_page_array_cache(struct f2fs_sb_info *sbi) { return 0; }
>   static inline void f2fs_destroy_page_array_cache(struct f2fs_sb_info *sbi) { }
>   static inline int __init f2fs_init_compress_cache(void) { return 0; }
> @@ -4114,6 +4123,12 @@ static inline bool f2fs_force_buffered_io(struct inode *inode,
>   	return false;
>   }
>   
> +static inline bool f2fs_need_verity(const struct inode *inode, pgoff_t idx)
> +{
> +	return fsverity_active(inode) &&
> +	       idx < DIV_ROUND_UP(inode->i_size, PAGE_SIZE);
> +}
> +
>   #ifdef CONFIG_F2FS_FAULT_INJECTION
>   extern void f2fs_build_fault_attr(struct f2fs_sb_info *sbi, unsigned int rate,
>   							unsigned int type);
> diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
> index 56b113e3cd6aa..9e2981733ea4a 100644
> --- a/include/trace/events/f2fs.h
> +++ b/include/trace/events/f2fs.h
> @@ -1794,7 +1794,7 @@ DEFINE_EVENT(f2fs_zip_start, f2fs_compress_pages_start,
>   	TP_ARGS(inode, cluster_idx, cluster_size, algtype)
>   );
>   
> -DEFINE_EVENT(f2fs_zip_start, f2fs_decompress_pages_start,
> +DEFINE_EVENT(f2fs_zip_start, f2fs_decompress_cluster_start,

I suggest keeping original tracepoint name, it can avoid breaking userspace
binary or script.

Thanks,

>   
>   	TP_PROTO(struct inode *inode, pgoff_t cluster_idx,
>   		unsigned int cluster_size, unsigned char algtype),
> @@ -1810,7 +1810,7 @@ DEFINE_EVENT(f2fs_zip_end, f2fs_compress_pages_end,
>   	TP_ARGS(inode, cluster_idx, compressed_size, ret)
>   );
>   
> -DEFINE_EVENT(f2fs_zip_end, f2fs_decompress_pages_end,
> +DEFINE_EVENT(f2fs_zip_end, f2fs_decompress_cluster_end,
>   
>   	TP_PROTO(struct inode *inode, pgoff_t cluster_idx,
>   			unsigned int compressed_size, int ret),
> 
