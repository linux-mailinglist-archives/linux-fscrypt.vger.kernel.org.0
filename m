Return-Path: <linux-fscrypt+bounces-1656-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id FKQfEz9mO2plXQgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1656-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 07:08:15 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A006BB655
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 07:08:14 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mJp1fqG+;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1656-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1656-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AD42630E69D8
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 05:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE1D3815C3;
	Wed, 24 Jun 2026 05:06:04 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93690380FF9;
	Wed, 24 Jun 2026 05:06:02 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782277564; cv=none; b=EdoytO0p98Fl40OHC3zobdA6CMEVoWPiX53Xlrwuix1HqTE/0ZVBUBUzcHs828B3kZKaOAzeGhNeSRYS80034GYfQZiczVcp22ZBTo3Qi9Fwt3J1454ltdZP4jxivctKxiWVgELzujrotxckogg3VpCR4scJLFnAN1mKO421xqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782277564; c=relaxed/simple;
	bh=aYs0h7k7EUn+a8Z8kg16xn9hZ1vfgbzDwbE6QiExth0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTHLtaQXDWH2OGlqKhMlfZC17RdEqjBB2I1ul+W1TFWsQLPRvn8ZOWFLDvCdaabSXk3HFOhWBkBifwu9aJjYk/Or2D25HhiH3MzPr83HQ4RmvMPc4tXoGqko1F+bLjja2BR5cWTpURLeYLrFeHgKPKIriN33REMJknBwJM8zI5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJp1fqG+; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BB61F00A3F;
	Wed, 24 Jun 2026 05:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782277562;
	bh=zHcMypoNh6FUAYJTXgnZTyd0K4ySEkTyYoTxs/MQzNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJp1fqG+rt2+NZJ66CgqMOKnyaKJa1RflnGpASavtDQeY9O3mJszdfzt9pbxtPIMe
	 fETjyEUvU0HCHmusyAalICvawF44n0ivQtvg5Td1cRQimzTVxrfBJETvCAXwEqJxh2
	 ib9P69+fTmkhF/cjvsDdiealGDs4rCljuHHBqwn93R+se5ChFVio6k6SHAam6SBK6B
	 fWbnTTPqA0zu5C9j7kdKSU10M8WCxu+ZOdIOuNyABy/GbWQV2EsFr5DOplCXPxZTJ1
	 ECakLEfE2VeB5GreSGbR3h0ZIxWFDwDYhcAwrmdBD9l2aPhDppQKSiM+X1j49I4VKL
	 4Wi0Syjz1bEEA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 06/16] ext4: Remove fs-layer file contents en/decryption code
Date: Tue, 23 Jun 2026 22:03:24 -0700
Message-ID: <20260624050334.124606-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624050334.124606-1-ebiggers@kernel.org>
References: <20260624050334.124606-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1656-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-block@vger.kernel.org,m:hch@lst.de,m:tytso@mit.edu,m:adilger.kernel@dilger.ca,m:libaokun@linux.alibaba.com,m:jack@suse.cz,m:ojaswin@linux.ibm.com,m:ritesh.list@gmail.com,m:yi.zhang@huawei.com,m:jaegeuk@kernel.org,m:chao@kernel.org,m:ebiggers@kernel.org,m:riteshlist@gmail.com,s:lists@lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.sourceforge.net,lst.de,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 96A006BB655

Now that fscrypt's file contents en/decryption is always implemented
using blk-crypto when the filesystem is block-based, the fs-layer
en/decryption code in ext4 is unused code.  Remove it.

Note that this makes possible some additional cleanups, but they're left
to later commits:

  - Making ext4_bio_write_folio() return void
  - Renaming bio_post_read_ctx to fsverity_ctx or similar, and
    allocating the pool only when fsverity support is needed

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/ext4/crypto.c   |  1 -
 fs/ext4/inode.c    | 28 ++--------------
 fs/ext4/page-io.c  | 68 ++-------------------------------------
 fs/ext4/readpage.c | 80 ++++------------------------------------------
 4 files changed, 13 insertions(+), 164 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 6b809ac80ef7..9265cfe62c83 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -235,11 +235,10 @@ static bool ext4_has_stable_inodes(struct super_block *sb)
 
 const struct fscrypt_operations ext4_cryptops = {
 	.inode_info_offs	= (int)offsetof(struct ext4_inode_info, i_crypt_info) -
 				  (int)offsetof(struct ext4_inode_info, vfs_inode),
 	.is_block_based		= 1,
-	.needs_bounce_pages	= 1,
 	.has_32bit_inodes	= 1,
 	.supports_subblock_data_units = 1,
 	.legacy_key_prefix	= "ext4:",
 	.get_context		= ext4_get_context,
 	.set_context		= ext4_set_context,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b..8eb2af481129 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1260,21 +1260,10 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
 		if (should_journal_data)
 			ext4_journalled_zero_new_buffers(handle, inode, folio,
 							 from, to);
 		else
 			folio_zero_new_buffers(folio, from, to);
-	} else if (fscrypt_inode_uses_fs_layer_crypto(inode)) {
-		for (i = 0; i < nr_wait; i++) {
-			int err2;
-
-			err2 = fscrypt_decrypt_pagecache_blocks(folio,
-						blocksize, bh_offset(wait[i]));
-			if (err2) {
-				clear_buffer_uptodate(wait[i]);
-				err = err2;
-			}
-		}
 	}
 
 	return err;
 }
 
@@ -3827,13 +3816,13 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	if (ret < 0)
 		return ret;
 out:
 	/*
-	 * When inline encryption is enabled, sometimes I/O to an encrypted file
-	 * has to be broken up to guarantee DUN contiguity.  Handle this by
-	 * limiting the length of the mapping returned.
+	 * Sometimes I/O to an encrypted file has to be broken up to guarantee
+	 * DUN contiguity.  Handle this by limiting the length of the mapping
+	 * returned.
 	 */
 	map.m_len = fscrypt_limit_io_blocks(inode, map.m_lblk, map.m_len);
 
 	/*
 	 * Before returning to iomap, let's ensure the allocated mapping
@@ -4079,21 +4068,10 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
 
 	if (!buffer_uptodate(bh)) {
 		err = ext4_read_bh_lock(bh, 0, true);
 		if (err)
 			goto unlock;
-		if (fscrypt_inode_uses_fs_layer_crypto(inode)) {
-			/* We expect the key to be set. */
-			BUG_ON(!fscrypt_has_encryption_key(inode));
-			err = fscrypt_decrypt_pagecache_blocks(folio,
-							       blocksize,
-							       bh_offset(bh));
-			if (err) {
-				clear_buffer_uptodate(bh);
-				goto unlock;
-			}
-		}
 	}
 	return bh;
 
 unlock:
 	folio_unlock(folio);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index bc674aa4a656..557f44178d87 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -101,22 +101,16 @@ static void ext4_finish_bio(struct bio *bio)
 {
 	struct folio_iter fi;
 
 	bio_for_each_folio_all(fi, bio) {
 		struct folio *folio = fi.folio;
-		struct folio *io_folio = NULL;
 		struct buffer_head *bh, *head;
 		size_t bio_start = fi.offset;
 		size_t bio_end = bio_start + fi.length;
 		unsigned under_io = 0;
 		unsigned long flags;
 
-		if (fscrypt_is_bounce_folio(folio)) {
-			io_folio = folio;
-			folio = fscrypt_pagecache_folio(folio);
-		}
-
 		if (bio->bi_status) {
 			int err = blk_status_to_errno(bio->bi_status);
 			mapping_set_error(folio->mapping, err);
 		}
 		bh = head = folio_buffers(folio);
@@ -137,14 +131,12 @@ static void ext4_finish_bio(struct bio *bio)
 				set_buffer_write_io_error(bh);
 				buffer_io_error(bh);
 			}
 		} while ((bh = bh->b_this_page) != head);
 		spin_unlock_irqrestore(&head->b_uptodate_lock, flags);
-		if (!under_io) {
-			fscrypt_free_bounce_page(&io_folio->page);
+		if (!under_io)
 			folio_end_writeback(folio);
-		}
 	}
 }
 
 static void ext4_release_io_end(ext4_io_end_t *io_end)
 {
@@ -451,33 +443,30 @@ static bool io_submit_need_new_bio(struct ext4_io_submit *io,
 }
 
 static void io_submit_add_bh(struct ext4_io_submit *io,
 			     struct inode *inode,
 			     struct folio *folio,
-			     struct folio *io_folio,
 			     struct buffer_head *bh)
 {
 	if (io->io_bio && io_submit_need_new_bio(io, inode, folio, bh)) {
 submit_and_retry:
 		ext4_io_submit(io);
 	}
 	if (io->io_bio == NULL)
 		io_submit_init_bio(io, inode, folio, bh);
-	if (!bio_add_folio(io->io_bio, io_folio, bh->b_size, bh_offset(bh)))
+	if (!bio_add_folio(io->io_bio, folio, bh->b_size, bh_offset(bh)))
 		goto submit_and_retry;
 	wbc_account_cgroup_owner(io->io_wbc, folio, bh->b_size);
 	io->io_next_block++;
 }
 
 int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
 		size_t len)
 {
-	struct folio *io_folio = folio;
 	struct inode *inode = folio->mapping->host;
 	unsigned block_start;
 	struct buffer_head *bh, *head;
-	int ret = 0;
 	int nr_to_submit = 0;
 	struct writeback_control *wbc = io->io_wbc;
 	bool keep_towrite = false;
 
 	BUG_ON(!folio_test_locked(folio));
@@ -547,67 +536,16 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
 		return 0;
 	}
 
 	bh = head = folio_buffers(folio);
 
-	/*
-	 * If any blocks are being written to an encrypted file, encrypt them
-	 * into a bounce page.  For simplicity, just encrypt until the last
-	 * block which might be needed.  This may cause some unneeded blocks
-	 * (e.g. holes) to be unnecessarily encrypted, but this is rare and
-	 * can't happen in the common case of blocksize == PAGE_SIZE.
-	 */
-	if (fscrypt_inode_uses_fs_layer_crypto(inode)) {
-		gfp_t gfp_flags = GFP_NOFS;
-		unsigned int enc_bytes = round_up(len, i_blocksize(inode));
-		struct page *bounce_page;
-
-		/*
-		 * Since bounce page allocation uses a mempool, we can only use
-		 * a waiting mask (i.e. request guaranteed allocation) on the
-		 * first page of the bio.  Otherwise it can deadlock.
-		 */
-		if (io->io_bio)
-			gfp_flags = GFP_NOWAIT;
-	retry_encrypt:
-		bounce_page = fscrypt_encrypt_pagecache_blocks(folio,
-					enc_bytes, 0, gfp_flags);
-		if (IS_ERR(bounce_page)) {
-			ret = PTR_ERR(bounce_page);
-			if (ret == -ENOMEM &&
-			    (io->io_bio || wbc->sync_mode == WB_SYNC_ALL)) {
-				gfp_t new_gfp_flags = GFP_NOFS;
-				if (io->io_bio)
-					ext4_io_submit(io);
-				else
-					new_gfp_flags |= __GFP_NOFAIL;
-				memalloc_retry_wait(gfp_flags);
-				gfp_flags = new_gfp_flags;
-				goto retry_encrypt;
-			}
-
-			printk_ratelimited(KERN_ERR "%s: ret = %d\n", __func__, ret);
-			folio_redirty_for_writepage(wbc, folio);
-			do {
-				if (buffer_async_write(bh)) {
-					clear_buffer_async_write(bh);
-					set_buffer_dirty(bh);
-				}
-				bh = bh->b_this_page;
-			} while (bh != head);
-
-			return ret;
-		}
-		io_folio = page_folio(bounce_page);
-	}
-
 	__folio_start_writeback(folio, keep_towrite);
 
 	/* Now submit buffers to write */
 	do {
 		if (!buffer_async_write(bh))
 			continue;
-		io_submit_add_bh(io, inode, folio, io_folio, bh);
+		io_submit_add_bh(io, inode, folio, bh);
 	} while ((bh = bh->b_this_page) != head);
 
 	return 0;
 }
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index dd3627c71732..8af183798a33 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -50,24 +50,14 @@
 #define NUM_PREALLOC_POST_READ_CTXS	128
 
 static struct kmem_cache *bio_post_read_ctx_cache;
 static mempool_t *bio_post_read_ctx_pool;
 
-/* postprocessing steps for read bios */
-enum bio_post_read_step {
-	STEP_INITIAL = 0,
-	STEP_DECRYPT,
-	STEP_VERITY,
-	STEP_MAX,
-};
-
 struct bio_post_read_ctx {
 	struct bio *bio;
 	struct fsverity_info *vi;
 	struct work_struct work;
-	unsigned int cur_step;
-	unsigned int enabled_steps;
 };
 
 static void __read_end_io(struct bio *bio)
 {
 	struct folio_iter fi;
@@ -77,80 +67,33 @@ static void __read_end_io(struct bio *bio)
 	if (bio->bi_private)
 		mempool_free(bio->bi_private, bio_post_read_ctx_pool);
 	bio_put(bio);
 }
 
-static void bio_post_read_processing(struct bio_post_read_ctx *ctx);
-
-static void decrypt_work(struct work_struct *work)
-{
-	struct bio_post_read_ctx *ctx =
-		container_of(work, struct bio_post_read_ctx, work);
-	struct bio *bio = ctx->bio;
-
-	if (fscrypt_decrypt_bio(bio))
-		bio_post_read_processing(ctx);
-	else
-		__read_end_io(bio);
-}
-
 static void verity_work(struct work_struct *work)
 {
 	struct bio_post_read_ctx *ctx =
 		container_of(work, struct bio_post_read_ctx, work);
 	struct bio *bio = ctx->bio;
 	struct fsverity_info *vi = ctx->vi;
 
 	/*
-	 * fsverity_verify_bio() may call readahead() again, and although verity
-	 * will be disabled for that, decryption may still be needed, causing
-	 * another bio_post_read_ctx to be allocated.  So to guarantee that
-	 * mempool_alloc() never deadlocks we must free the current ctx first.
-	 * This is safe because verity is the last post-read step.
+	 * Free the bio_post_read_ctx right away, since it's no longer needed.
+	 * This relieves the pressure on the mempool as much as possible.
 	 */
-	BUILD_BUG_ON(STEP_VERITY + 1 != STEP_MAX);
 	mempool_free(ctx, bio_post_read_ctx_pool);
 	bio->bi_private = NULL;
 
 	fsverity_verify_bio(vi, bio);
 
 	__read_end_io(bio);
 }
 
-static void bio_post_read_processing(struct bio_post_read_ctx *ctx)
-{
-	/*
-	 * We use different work queues for decryption and for verity because
-	 * verity may require reading metadata pages that need decryption, and
-	 * we shouldn't recurse to the same workqueue.
-	 */
-	switch (++ctx->cur_step) {
-	case STEP_DECRYPT:
-		if (ctx->enabled_steps & (1 << STEP_DECRYPT)) {
-			INIT_WORK(&ctx->work, decrypt_work);
-			fscrypt_enqueue_decrypt_work(&ctx->work);
-			return;
-		}
-		ctx->cur_step++;
-		fallthrough;
-	case STEP_VERITY:
-		if (IS_ENABLED(CONFIG_FS_VERITY) &&
-		    ctx->enabled_steps & (1 << STEP_VERITY)) {
-			INIT_WORK(&ctx->work, verity_work);
-			fsverity_enqueue_verify_work(&ctx->work);
-			return;
-		}
-		ctx->cur_step++;
-		fallthrough;
-	default:
-		__read_end_io(ctx->bio);
-	}
-}
-
 static bool bio_post_read_required(struct bio *bio)
 {
-	return bio->bi_private && !bio->bi_status;
+	return IS_ENABLED(CONFIG_FS_VERITY) && bio->bi_private &&
+	       !bio->bi_status;
 }
 
 /*
  * I/O completion handler for multipage BIOs.
  *
@@ -166,37 +109,28 @@ static bool bio_post_read_required(struct bio *bio)
 static void mpage_end_io(struct bio *bio)
 {
 	if (bio_post_read_required(bio)) {
 		struct bio_post_read_ctx *ctx = bio->bi_private;
 
-		ctx->cur_step = STEP_INITIAL;
-		bio_post_read_processing(ctx);
+		INIT_WORK(&ctx->work, verity_work);
+		fsverity_enqueue_verify_work(&ctx->work);
 		return;
 	}
 	__read_end_io(bio);
 }
 
 static void ext4_set_bio_post_read_ctx(struct bio *bio,
 				       const struct inode *inode,
 				       struct fsverity_info *vi)
 {
-	unsigned int post_read_steps = 0;
-
-	if (fscrypt_inode_uses_fs_layer_crypto(inode))
-		post_read_steps |= 1 << STEP_DECRYPT;
-
-	if (vi)
-		post_read_steps |= 1 << STEP_VERITY;
-
-	if (post_read_steps) {
+	if (vi) {
 		/* Due to the mempool, this never fails. */
 		struct bio_post_read_ctx *ctx =
 			mempool_alloc(bio_post_read_ctx_pool, GFP_NOFS);
 
 		ctx->bio = bio;
 		ctx->vi = vi;
-		ctx->enabled_steps = post_read_steps;
 		bio->bi_private = ctx;
 	}
 }
 
 static inline loff_t ext4_readpage_limit(struct inode *inode)
-- 
2.54.0


