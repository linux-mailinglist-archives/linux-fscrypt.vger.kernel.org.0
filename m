Return-Path: <linux-fscrypt+bounces-1606-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AMLrC18gEGqjTwYAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1606-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 May 2026 11:22:39 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A60A5B1128
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 May 2026 11:22:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1BB3E3016814
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 May 2026 09:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E65F3AFB0B;
	Fri, 22 May 2026 09:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D2NBrePQ"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D8E38423B;
	Fri, 22 May 2026 09:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779441583; cv=none; b=l66ouJRjoDb7bauP/LykjCpHIoIpc5p0PjwCIyg+gddzDW2Fl4yvv801F5kf5orbByOagHBkgyF08bjRGXOnhuVX1yNZci8guQWk4da4F1tDVdrKi6tMwhx7ZqO64YYFepCaMU5g/la74iLK9CK25L4iu9Q4q/C2q+TXtNJAfo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779441583; c=relaxed/simple;
	bh=KHspHbjSJILbZEtc8+pBuJUp9cMlORp1Z37IAhD7LCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uK79LZI/JS8EYOYtPNO5uVMM49nrLd3R/B1Xk8J4otpO6eUtBcLUgowEvtuGSnTFB51+4pJnRT4JwsrgS727YxYNdBIKGUggxSQ7CEu1GF5NMexI3lJpNtzVrzaPEx1dXS51lfHPaB4a7/LRdRxh37+XV5mOLHw0AJUxPPPikWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D2NBrePQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2n1xSP/5cGJvn9+BBg47IJkWoOhGbcIWf3YqZLh9XX4=; b=D2NBrePQJxJ0kWJEc9y6l7vEo3
	Yd51Vf+Mjr9Rajpk1+wfJ/hUC+lOB+8aukhC4SGLLckJgD3pcJyG2kAlC5AIe64efq68sFnEj/46S
	J32AQCKvK+ytN9JBhPRretjeiB7AhzO+lgUBe7Z0Z16RSyEAjX6iDcVsXVYaezZodJKLHKCMhxzeX
	QRVim2LzvIe4ZyO9rq5GT2CH6mNlu57Wmtsy6HXlCX9obmNj2o8TAVDCuPxYKlDJ6Eqox5RJU2aR3
	Vsbm9A1+1JQ02zsz2SBdsvTf0e4MMPBSrvJCGG/fV/n9w6aeQbQM8KoXwGTrV4SR8zMRA0wXc/mav
	b2V6geQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQM2V-0000000AJ9p-3oPS;
	Fri, 22 May 2026 09:19:31 +0000
Date: Fri, 22 May 2026 02:19:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 32/43] btrfs: implement process_bio cb for fscrypt
Message-ID: <ahAfo4DzvH_ob1hv@infradead.org>
References: <20260513085340.3673127-1-neelx@suse.com>
 <20260513085340.3673127-33-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085340.3673127-33-neelx@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1606-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[infradead.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,infradead.org:mid,infradead.org:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,toxicpanda.com:email]
X-Rspamd-Queue-Id: 8A60A5B1128
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 13, 2026 at 10:53:06AM +0200, Daniel Vacek wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> We are going to be checksumming the encrypted data, so we have to
> implement the ->process_bio fscrypt callback.  This will provide us with
> the original bio and the encrypted bio to do work on.  For WRITE's this
> will happen after the encrypted bio has been encrypted.  For READ's this
> will happen after the read has completed and before the decryption step
> is done.
> 
> For write's this is straightforward, we can just pass in the encrypted
> bio to btrfs_csum_one_bio and then the csums will be added to the bbio
> as normal.
> 
> For read's this is relatively straightforward, but requires some care.
> We assume (because that's how it works currently) that the encrypted bio
> match the original bio, this is important because we save the iter of
> the bio before we submit.  If this changes in the future we'll need a
> hook to give us the bi_iter of the decryption bio before it's submitted.
> We check the csums before decryption.  If it doesn't match we simply
> error out and we let the normal path handle the repair work.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
> 
> v7 changes:
>  * Fixed array overflow stack corruption for bios > max blocksize (>64KiB)
>    as reported by Chris' AI review.
> v6 changes:
>  * Adapt to btrfs_data_csum_ok() changes for bs > ps.  Mostly follow
>    what was done in 052fd7a5cace ("btrfs: make read verification
>    handle bs > ps cases without large folios").
>  * Rename bbio::csum_done to csum_ok due to name collision.
>    With upstream, member name csum_done was used for async csums.
> v5: https://lore.kernel.org/linux-btrfs/ca32684b01ff8c252be515509137e0a4a0e5db7a.1706116485.git.josef@toxicpanda.com/
> ---
>  fs/btrfs/bio.c       | 44 +++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/bio.h       |  3 +++
>  fs/btrfs/file-item.c | 14 ++++++++++++--
>  fs/btrfs/fscrypt.c   | 29 +++++++++++++++++++++++++++++
>  4 files changed, 87 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 3e2ee19aab50..729c5aff5c3d 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -301,6 +301,40 @@ static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
>  	return fbio;
>  }
>  
> +blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio, struct bio *enc_bio)
> +{
> +	struct btrfs_inode *inode = bbio->inode;
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct bvec_iter iter = bbio->saved_iter;
> +	struct btrfs_device *dev = bbio->bio.bi_private;
> +	const u32 blocksize = fs_info->sectorsize;
> +	const u32 step = min(blocksize, PAGE_SIZE);
> +	const u32 nr_steps = iter.bi_size / step;
> +	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
> +	phys_addr_t paddr;
> +	unsigned int slot = 0;
> +	u32 offset = 0;
> +
> +	/*
> +	 * We have to use a copy of iter in case there's an error,
> +	 * btrfs_check_read_bio will handle submitting the repair bios.
> +	 */
> +	btrfs_bio_for_each_block(paddr, enc_bio, &iter, step) {
> +		ASSERT(slot < nr_steps);
> +		paddrs[slot] = paddr;
> +		slot++;
> +		offset += step;
> +		if (IS_ALIGNED(offset, blocksize)) {
> +			if (!btrfs_data_csum_ok(bbio, dev, offset - blocksize, paddrs))
> +				return BLK_STS_IOERR;
> +			slot = 0;
> +		}
> +	}
> +
> +	bbio->csum_ok = true;
> +	return BLK_STS_OK;
> +}
> +
>  static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *dev)
>  {
>  	struct btrfs_inode *inode = bbio->inode;
> @@ -330,6 +364,10 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
>  	/* Clear the I/O error. A failed repair will reset it. */
>  	bbio->bio.bi_status = BLK_STS_OK;
>  
> +	/* This was an encrypted bio and we've already done the csum check. */
> +	if (status == BLK_STS_OK && bbio->csum_ok)
> +		goto out;
> +
>  	btrfs_bio_for_each_block(paddr, &bbio->bio, iter, step) {
>  		paddrs[(offset / step) % nr_steps] = paddr;
>  		offset += step;
> @@ -341,6 +379,7 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
>  							 paddrs, fbio);
>  		}
>  	}
> +out:
>  	if (bbio->csum != bbio->csum_inline)
>  		kvfree(bbio->csum);
>  
> @@ -859,10 +898,13 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
>  		/*
>  		 * Csum items for reloc roots have already been cloned at this
>  		 * point, so they are handled as part of the no-checksum case.
> +		 *
> +		 * Encrypted inodes are csum'ed via the ->process_bio callback.
>  		 */
>  		if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
>  		    !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state) &&
> -		    !btrfs_is_data_reloc_root(inode->root) && !bbio->is_remap) {
> +		    !btrfs_is_data_reloc_root(inode->root) && !bbio->is_remap &&
> +		    !IS_ENCRYPTED(&inode->vfs_inode)) {
>  			if (should_async_write(bbio) &&
>  			    btrfs_wq_submit_bio(bbio, bioc, &smap, mirror_num))
>  				goto done;
> diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
> index 43f7544029ac..456d32db9e9e 100644
> --- a/fs/btrfs/bio.h
> +++ b/fs/btrfs/bio.h
> @@ -43,6 +43,7 @@ struct btrfs_bio {
>  		struct {
>  			u8 *csum;
>  			u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
> +			bool csum_ok;
>  			struct bvec_iter saved_iter;
>  		};
>  
> @@ -130,5 +131,7 @@ void btrfs_submit_repair_write(struct btrfs_bio *bbio, int mirror_num, bool dev_
>  int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
>  			    u32 length, u64 logical, const phys_addr_t paddrs[],
>  			    unsigned int step, int mirror_num);
> +blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio,
> +					    struct bio *enc_bio);
>  
>  #endif
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 986914078708..72d9d3243460 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -338,6 +338,14 @@ static int search_csum_tree(struct btrfs_fs_info *fs_info,
>  	return ret;
>  }
>  
> +static inline bool inode_skip_csum(struct btrfs_inode *inode)
> +{
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +
> +	return (inode->flags & BTRFS_INODE_NODATASUM) ||
> +		test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state);
> +}
> +
>  /*
>   * Lookup the checksum for the read bio in csum tree.
>   *
> @@ -357,8 +365,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
>  	int ret = 0;
>  	u32 bio_offset = 0;
>  
> -	if ((inode->flags & BTRFS_INODE_NODATASUM) ||
> -	    test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state))
> +	if (inode_skip_csum(inode))
>  		return 0;
>  
>  	/*
> @@ -817,6 +824,9 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, struct bio *bio, bool async)
>  	struct btrfs_ordered_sum *sums;
>  	unsigned nofs_flag;
>  
> +	if (inode_skip_csum(inode))
> +		return 0;
> +
>  	nofs_flag = memalloc_nofs_save();
>  	sums = kvzalloc(btrfs_ordered_sum_size(fs_info, bio->bi_iter.bi_size),
>  		       GFP_KERNEL);
> diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> index 5d34a8b94da5..924ee3df7f32 100644
> --- a/fs/btrfs/fscrypt.c
> +++ b/fs/btrfs/fscrypt.c
> @@ -16,6 +16,7 @@
>  #include "transaction.h"
>  #include "volumes.h"
>  #include "xattr.h"
> +#include "file-item.h"
>  
>  /*
>   * From a given location in a leaf, read a name into a qstr (usually a
> @@ -212,6 +213,33 @@ static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
>  	return devs;
>  }
>  
> +static blk_status_t btrfs_process_encrypted_bio(struct bio *orig_bio,
> +						struct bio *enc_bio)
> +{
> +	struct btrfs_bio *bbio;
> +
> +	/*
> +	 * If our bio is from the normal fs_bio_set then we know this is a
> +	 * mirror split and we can skip it, we'll get the real bio on the last
> +	 * mirror and we can process that one.
> +	 */
> +	if (orig_bio->bi_pool == &fs_bio_set)
> +		return BLK_STS_OK;
> +
> +	bbio = btrfs_bio(orig_bio);
> +
> +	if (bio_op(orig_bio) == REQ_OP_READ) {
> +		/*
> +		 * We have ->saved_iter based on the orig_bio, so if the block
> +		 * layer changes we need to notice this asap so we can update
> +		 * our code to handle the new world order.
> +		 */
> +		ASSERT(orig_bio == enc_bio);
> +		return btrfs_check_encrypted_read_bio(bbio, enc_bio);
> +	}
> +	return btrfs_csum_one_bio(bbio, enc_bio, false);

Honestly, all this shows that the architecture of the I/O path in this
series is pretty broken.  It needs all this magic detection, and the
passing of arguments that mixes the bbio for state and the lower
encrypted bio without the btrfs context shows something doesn't work
well.

So let's take a step back, if we think of the I/O pipeline, it should do
things in this order for writes:

 - encrypt data
 - generate checksums
 - do mirroring/striping/parity

and reverse for reads.

All this suggest that the btrfs_bio needs to exist for the encrypted
data.  So I think you'll need to and refactor this, preferably with the
really annoying two-level callbacks that this really hard to follow (or
implement).  Your caller is in the file system, and it should be able to
call fscrypt as helpers instead of going two layers down using direct
calls and then two layers back up using indirect calls.  The recent
refactoring that moves the fscrypt fallback above the block layer
instead of calling it from the bottom should help a lot with that.


