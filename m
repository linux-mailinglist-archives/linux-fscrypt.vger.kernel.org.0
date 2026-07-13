Return-Path: <linux-fscrypt+bounces-1767-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Ag77CQ5RVGpZkgMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1767-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 04:44:30 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 77C87746C0A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 04:44:29 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QC3kkXhq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1767-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1767-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5BDFF304547A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 02:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C2E37646C;
	Mon, 13 Jul 2026 02:39:50 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0673749EE;
	Mon, 13 Jul 2026 02:39:47 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910390; cv=none; b=UojknJ+rv6Q9N6mX1rMC18wve1g+SuR56bT4+oaDDRkTUan7SPaxBxKzvrivD+uLucvTir1UQCW09GGkug0smIJzFWeGS9eRQGPlxn82l30H6r6OF51F6WV8wRZ3ZRSkQyVXRTtYfZ8zej46Fxu4Zta3C/7Or7IwM5E+x+lXl7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910390; c=relaxed/simple;
	bh=aSatRmITZlKvgy+XD6wbeaCfyEes6r+/vSNA6tcIVy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwN5BEm7J/KL3kDpWM17XU+bHTQg/62ISzrMHCm6clSbPWhAQiKlkVU3ZLt/m3Z27lH2QLTNtv4AsmY2JlOL3RLm2IFCsAf8V8x+3IU/qUCKr77VfySxvSwEEWNP5YQ1AIDuMKkpLoaFxt16xKPXHHsZ9EnhP2An1W+ft45jt/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QC3kkXhq; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824D21F00A3D;
	Mon, 13 Jul 2026 02:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783910387;
	bh=8SaTQMxAS+yBjwu+96JKJc2Q/oDt077eHVlD4bqYrlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QC3kkXhqCy4w6IBOgpDbp2kbs8ZLFrYNlwb2XkQn/BJlYOARnx/8Ix4DYwuiooIk2
	 GrrK6TzIkLCcj2z4GSEZs1iL//QF8pALs4er0VbLwZQqKClIaCQVtBF5r9NPGeZAY2
	 8CHroA+WGBi7RHufX8TSl4Db16dl95a4bA0AnviCIxp/IiZfTMUw0hyGgOlnYELvZM
	 oxK+7kZ/t5lFxC57Esbmb27X1Kr5w368KdtUMCmsZ9vfm4exjUN+3zx+QtaxVmncWv
	 7TRlK9Z/tZb9JOtcYT5XgWarGHonn/CIkp64AmEzTk5O+6XR8Qo3ygzcuxCsCpmOiK
	 9+k0bqIBnakrw==
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
Subject: [PATCH v3 10/17] f2fs: Remove fs-layer file contents en/decryption code
Date: Sun, 12 Jul 2026 22:37:01 -0400
Message-ID: <20260713023708.9245-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260713023708.9245-1-ebiggers@kernel.org>
References: <20260713023708.9245-1-ebiggers@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1767-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp,fio.page:url]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 77C87746C0A

Now that fscrypt's file contents en/decryption is always implemented
using blk-crypto when the filesystem is block-based, the fs-layer
en/decryption code in f2fs is unused code.  Remove it.

Note that the struct f2fs_io_info field encrypted_page is kept because
it is still used by the garbage collection path to relocate encrypted
blocks using raw meta pages from META_MAPPING.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/f2fs/compress.c | 31 ++--------------
 fs/f2fs/data.c     | 93 +++++-----------------------------------------
 fs/f2fs/f2fs.h     |  2 -
 fs/f2fs/segment.c  |  2 -
 fs/f2fs/super.c    |  1 -
 5 files changed, 12 insertions(+), 117 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 91855d91bbdd..ce88092d9ce2 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1286,8 +1286,6 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 		.compressed_page = NULL,
 		.io_type = io_type,
 		.io_wbc = wbc,
-		.encrypted = fscrypt_inode_uses_fs_layer_crypto(cc->inode) ?
-									1 : 0,
 	};
 	struct folio *folio;
 	struct dnode_of_data dn;
@@ -1361,14 +1359,6 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 
 		/* wait for GCed page writeback via META_MAPPING */
 		f2fs_wait_on_block_writeback(inode, fio.old_blkaddr);
-
-		if (fio.encrypted) {
-			fio.page = cc->rpages[i + 1];
-			err = f2fs_encrypt_one_page(&fio);
-			if (err)
-				goto out_destroy_crypt;
-			cc->cpages[i] = fio.encrypted_page;
-		}
 	}
 
 	set_cluster_writeback(cc);
@@ -1406,21 +1396,15 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 
 		f2fs_bug_on(fio.sbi, blkaddr == NULL_ADDR);
 
-		if (fio.encrypted)
-			fio.encrypted_page = cc->cpages[i - 1];
-		else
-			fio.compressed_page = cc->cpages[i - 1];
+		fio.compressed_page = cc->cpages[i - 1];
 
 		cc->cpages[i - 1] = NULL;
 		fio.submitted = 0;
 		f2fs_outplace_write_data(&dn, &fio);
 		if (unlikely(!fio.submitted)) {
 			cancel_cluster_writeback(cc, cic, i);
-
-			/* To call fscrypt_finalize_bounce_page */
-			i = cc->valid_nr_cpages;
 			*submitted = 0;
-			goto out_destroy_crypt;
+			goto out_free_page_array;
 		}
 		(*submitted)++;
 unlock_continue:
@@ -1452,17 +1436,8 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 	f2fs_destroy_compress_ctx(cc, false);
 	return 0;
 
-out_destroy_crypt:
+out_free_page_array:
 	page_array_free(sbi, cic->rpages, cc->cluster_size);
-
-	if (!fio.encrypted)
-		goto out_put_cic;
-
-	for (--i; i >= 0; i--) {
-		if (!cc->cpages[i])
-			continue;
-		fscrypt_finalize_bounce_page(&cc->cpages[i]);
-	}
 out_put_cic:
 	kmem_cache_free(cic_entry_slab, cic);
 out_put_dnode:
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a765fda71536..65117dd2e123 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -65,9 +65,6 @@ bool f2fs_is_cp_guaranteed(const struct folio *folio)
 	struct inode *inode;
 	struct f2fs_sb_info *sbi;
 
-	if (fscrypt_is_bounce_folio(folio))
-		return folio_test_f2fs_gcing(fscrypt_pagecache_folio(folio));
-
 	inode = mapping->host;
 	sbi = F2FS_I_SB(inode);
 
@@ -101,11 +98,6 @@ static enum count_type __read_io_type(struct folio *folio)
 
 /* postprocessing steps for read bios */
 enum bio_post_read_step {
-#ifdef CONFIG_FS_ENCRYPTION
-	STEP_DECRYPT	= BIT(0),
-#else
-	STEP_DECRYPT	= 0,	/* compile out the decryption-related code */
-#endif
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 	STEP_DECOMPRESS	= BIT(1),
 #else
@@ -301,11 +293,6 @@ static void f2fs_post_read_work(struct work_struct *work)
 		container_of(work, struct bio_post_read_ctx, work);
 	struct bio *bio = ctx->bio;
 
-	if ((ctx->enabled_steps & STEP_DECRYPT) && !fscrypt_decrypt_bio(bio)) {
-		f2fs_finish_read_bio(bio, true);
-		return;
-	}
-
 	if (ctx->enabled_steps & STEP_DECOMPRESS)
 		f2fs_handle_step_decompress(ctx, true);
 
@@ -329,18 +316,11 @@ static void f2fs_read_end_io(struct bio *bio)
 		return;
 	}
 
-	if (ctx) {
-		unsigned int enabled_steps = ctx->enabled_steps &
-					(STEP_DECRYPT | STEP_DECOMPRESS);
-
-		/*
-		 * If we have only decompression step between decompression and
-		 * decrypt, we don't need post processing for this.
-		 */
-		if (enabled_steps == STEP_DECOMPRESS &&
-				!f2fs_low_mem_mode(sbi)) {
+	if (ctx && (ctx->enabled_steps & STEP_DECOMPRESS)) {
+		if (!f2fs_low_mem_mode(sbi)) {
+			/* Decompress inline. */
 			f2fs_handle_step_decompress(ctx, intask);
-		} else if (enabled_steps) {
+		} else {
 			INIT_WORK(&ctx->work, f2fs_post_read_work);
 			queue_work(ctx->sbi->wq, &ctx->work);
 			return;
@@ -362,13 +342,6 @@ static void f2fs_write_end_bio(struct bio *bio)
 		struct folio *folio = fi.folio;
 		enum count_type type;
 
-		if (fscrypt_is_bounce_folio(folio)) {
-			struct folio *io_folio = folio;
-
-			folio = fscrypt_pagecache_folio(io_folio);
-			fscrypt_free_bounce_page(&io_folio->page);
-		}
-
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 		if (f2fs_is_compressed_page(folio)) {
 			f2fs_compress_write_end_io(bio, folio);
@@ -614,11 +587,6 @@ static bool __has_merged_page(struct bio *bio, struct inode *inode,
 	bio_for_each_folio_all(fi, bio) {
 		struct folio *target = fi.folio;
 
-		if (fscrypt_is_bounce_folio(target)) {
-			target = fscrypt_pagecache_folio(target);
-			if (IS_ERR(target))
-				continue;
-		}
 		if (f2fs_is_compressed_page(target)) {
 			target = f2fs_compress_control_folio(target);
 			if (IS_ERR(target))
@@ -1161,9 +1129,6 @@ static struct bio *f2fs_grab_read_bio(struct inode *inode,
 	f2fs_set_bio_crypt_ctx(bio, inode, first_idx, NULL, GFP_NOFS);
 	bio->bi_end_io = f2fs_read_end_io;
 
-	if (fscrypt_inode_uses_fs_layer_crypto(inode))
-		post_read_steps |= STEP_DECRYPT;
-
 	if (vi)
 		post_read_steps |= STEP_VERITY;
 
@@ -2852,35 +2817,6 @@ static void f2fs_readahead(struct readahead_control *rac)
 	f2fs_mpage_readpages(inode, vi, rac, NULL);
 }
 
-int f2fs_encrypt_one_page(struct f2fs_io_info *fio)
-{
-	struct inode *inode = fio_inode(fio);
-	struct folio *mfolio;
-	struct page *page;
-
-	if (!f2fs_encrypted_file(inode))
-		return 0;
-
-	page = fio->compressed_page ? fio->compressed_page : fio->page;
-
-	if (fscrypt_inode_uses_inline_crypto(inode))
-		return 0;
-
-	fio->encrypted_page = fscrypt_encrypt_pagecache_blocks(page_folio(page),
-					PAGE_SIZE, 0, GFP_NOFS);
-	if (IS_ERR(fio->encrypted_page))
-		return PTR_ERR(fio->encrypted_page);
-
-	mfolio = filemap_lock_folio(META_MAPPING(fio->sbi), fio->old_blkaddr);
-	if (!IS_ERR(mfolio)) {
-		if (folio_test_uptodate(mfolio))
-			memcpy(folio_address(mfolio),
-				page_address(fio->encrypted_page), PAGE_SIZE);
-		f2fs_folio_put(mfolio, true);
-	}
-	return 0;
-}
-
 static inline bool check_inplace_update_policy(struct inode *inode,
 				struct f2fs_io_info *fio)
 {
@@ -3053,22 +2989,15 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio)
 	if (ipu_force ||
 		(__is_valid_data_blkaddr(fio->old_blkaddr) &&
 					need_inplace_update(fio))) {
-		err = f2fs_encrypt_one_page(fio);
-		if (err)
-			goto out_writepage;
-
 		folio_start_writeback(folio);
 		f2fs_put_dnode(&dn);
 		if (fio->need_lock == LOCK_REQ)
 			f2fs_unlock_op(fio->sbi, &lc);
 		err = f2fs_inplace_write_data(fio);
-		if (err) {
-			if (fscrypt_inode_uses_fs_layer_crypto(inode))
-				fscrypt_finalize_bounce_page(&fio->encrypted_page);
+		if (err)
 			folio_end_writeback(folio);
-		} else {
+		else
 			set_inode_flag(inode, FI_UPDATE_WRITE);
-		}
 		trace_f2fs_do_write_data_page(folio, IPU);
 		return err;
 	}
@@ -3087,10 +3016,6 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio)
 
 	fio->version = ni.version;
 
-	err = f2fs_encrypt_one_page(fio);
-	if (err)
-		goto out_writepage;
-
 	folio_start_writeback(folio);
 
 	if (fio->compr_blocks && fio->old_blkaddr == COMPRESS_ADDR)
@@ -4602,9 +4527,9 @@ static int f2fs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	iomap->offset = F2FS_BLK_TO_BYTES(map.m_lblk);
 
 	/*
-	 * When inline encryption is enabled, sometimes I/O to an encrypted file
-	 * has to be broken up to guarantee DUN contiguity.  Handle this by
-	 * limiting the length of the mapping returned.
+	 * Sometimes I/O to an encrypted file has to be broken up to guarantee
+	 * DUN contiguity.  Handle this by limiting the length of the mapping
+	 * returned.
 	 */
 	map.m_len = fscrypt_limit_io_blocks(inode, map.m_lblk, map.m_len);
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 8f3e632f315c..8376bbe58ee3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1364,7 +1364,6 @@ struct f2fs_io_info {
 	unsigned int submitted:1;	/* indicate IO submission */
 	unsigned int in_list:1;		/* indicate fio is in io_list */
 	unsigned int is_por:1;		/* indicate IO is from recovery or not */
-	unsigned int encrypted:1;	/* indicate file is encrypted */
 	unsigned int meta_gc:1;		/* require meta inode GC */
 	enum iostat_type io_type;	/* io type */
 	struct writeback_control *io_wbc; /* writeback control */
@@ -4199,7 +4198,6 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio);
 int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map, int flag);
 int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			u64 start, u64 len);
-int f2fs_encrypt_one_page(struct f2fs_io_info *fio);
 bool f2fs_should_update_inplace(struct inode *inode, struct f2fs_io_info *fio);
 bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio);
 int f2fs_write_single_data_page(struct folio *folio, int *submitted,
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index d71ddb3ee918..642668a1847c 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3986,8 +3986,6 @@ static void do_write_page(struct f2fs_summary *sum, struct f2fs_io_info *fio)
 			"%s Failed to allocate data block, ino:%u, index:%lu, type:%d, old_blkaddr:0x%x, new_blkaddr:0x%x, err:%d",
 			__func__, fio->ino, folio->index, type,
 			fio->old_blkaddr, fio->new_blkaddr, err);
-		if (fscrypt_inode_uses_fs_layer_crypto(folio->mapping->host))
-			fscrypt_finalize_bounce_page(&fio->encrypted_page);
 		folio_end_writeback(folio);
 		if (f2fs_in_warm_node_list(folio))
 			f2fs_del_fsync_node_entry(fio->sbi, folio);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index c04d5d7c9820..5c20acee6dc7 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3773,7 +3773,6 @@ static const struct fscrypt_operations f2fs_cryptops = {
 	.inode_info_offs	= (int)offsetof(struct f2fs_inode_info, i_crypt_info) -
 				  (int)offsetof(struct f2fs_inode_info, vfs_inode),
 	.is_block_based		= 1,
-	.needs_bounce_pages	= 1,
 	.has_32bit_inodes	= 1,
 	.supports_subblock_data_units = 1,
 	.legacy_key_prefix	= "f2fs:",
-- 
2.55.0


