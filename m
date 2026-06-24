Return-Path: <linux-fscrypt+bounces-1657-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id FzCAIMdlO2ocXQgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1657-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 07:06:15 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 49E506BB57A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 07:06:15 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h9lkcUK2;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1657-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1657-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 18C383047490
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 05:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D8AE382281;
	Wed, 24 Jun 2026 05:06:05 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCAF3812DA;
	Wed, 24 Jun 2026 05:06:03 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782277565; cv=none; b=J2GWCk5ovK5L1o1SXOE8iHI6nNTUH8tU7Os61h9MXvw7JqAkdrZ9yLLR9+Tmp5D2tlVWtSOA+0YuZehXpjTfb4WLa6Ru04a4Xf6nJVDZXh8PZp/D1TO7VW0NfjRfm1EqaU6S4f3B9THpss6bQ+hS/Bz5qAAOUnLo6rs5giv2hAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782277565; c=relaxed/simple;
	bh=Bbsy96EN+mK0YuI1ElF4oJasRWURIxJ4dXdURyUWuJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDJ+jn2E95oL4/vpgbjD/pPp/z/d9CqYIiyWZfsc0SMBrVMZJ54bLu07y8TYUzkYyD9KQyWQkTcw9+MzrvsfPAwOdrx2uyqi6uZKpDwRxT8nE+SOi0cSwx6hH45Q9oevUyX6AX0Vty1u0ii5PSnyFM5O1t33oEeMDt6q6dAK4Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9lkcUK2; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09661F00A3E;
	Wed, 24 Jun 2026 05:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782277563;
	bh=Nj2Af/j0EhHtcq1Ksqiq7SAcVvgpLtQbzFu58yJbnR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9lkcUK27+4wvHd3rKEG3WsCji9PlsuxWErNKhCQhV5KcPpFHTBs0PoBOg4AfWB3H
	 gTv819iXb6LI87ukWiZAg4NW3vOR7zv5ETm/AB9Lw61pVvx/o3EM2GJei4qREoRJPL
	 jmUaVKhC1MpQuqN4x5TOAzIX4nxnzFSUFlhegbHlHHav8blHo2VCJj8ZzW6RlaFsQx
	 vQhtas5uK/KDWbkNRxkr44Ysja9L6O1r8XUzXUauDBiS9NUrdvcUW8cJ++mhdXOb7K
	 kIO0lbE4CyfBopGy5DBMNIIev/KI2uu+hU8xFHik+LoGmBAB+Yp3dxnfW78mg+C4EB
	 vstHRmDaYkodA==
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
Subject: [PATCH 07/16] ext4: Make ext4_bio_write_folio() return void
Date: Tue, 23 Jun 2026 22:03:25 -0700
Message-ID: <20260624050334.124606-8-ebiggers@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1657-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 49E506BB57A

Since the fs-layer file contents encryption implementation was removed,
ext4_bio_write_folio() now always returns 0.  Change it to return void,
and likewise for its caller mpage_submit_folio().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/ext4/ext4.h    |  2 +-
 fs/ext4/inode.c   | 31 ++++++++-----------------------
 fs/ext4/page-io.c |  6 ++----
 3 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..920a8ec1b948 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3943,11 +3943,11 @@ extern int ext4_put_io_end(ext4_io_end_t *io_end);
 extern void ext4_put_io_end_defer(ext4_io_end_t *io_end);
 extern void ext4_io_submit_init(struct ext4_io_submit *io,
 				struct writeback_control *wbc);
 extern void ext4_end_io_rsv_work(struct work_struct *work);
 extern void ext4_io_submit(struct ext4_io_submit *io);
-int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *page,
+void ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *page,
 		size_t len);
 extern struct ext4_io_end_vec *ext4_alloc_io_end_vec(ext4_io_end_t *io_end);
 extern struct ext4_io_end_vec *ext4_last_io_end_vec(ext4_io_end_t *io_end);
 
 /* mmp.c */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8eb2af481129..c6faa7c751ca 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2062,15 +2062,14 @@ static void mpage_folio_done(struct mpage_da_data *mpd, struct folio *folio)
 	mpd->start_pos += folio_size(folio);
 	mpd->wbc->nr_to_write -= folio_nr_pages(folio);
 	folio_unlock(folio);
 }
 
-static int mpage_submit_folio(struct mpage_da_data *mpd, struct folio *folio)
+static void mpage_submit_folio(struct mpage_da_data *mpd, struct folio *folio)
 {
 	size_t len;
 	loff_t size;
-	int err;
 
 	WARN_ON_ONCE(folio_pos(folio) != mpd->start_pos);
 	folio_clear_dirty_for_io(folio);
 	/*
 	 * We have to be very careful here!  Nothing protects writeback path
@@ -2088,13 +2087,11 @@ static int mpage_submit_folio(struct mpage_da_data *mpd, struct folio *folio)
 	size = i_size_read(mpd->inode);
 	len = folio_size(folio);
 	if (folio_pos(folio) + len > size &&
 	    !ext4_verity_in_progress(mpd->inode))
 		len = size & (len - 1);
-	err = ext4_bio_write_folio(&mpd->io_submit, folio, len);
-
-	return err;
+	ext4_bio_write_folio(&mpd->io_submit, folio, len);
 }
 
 #define BH_FLAGS (BIT(BH_Unwritten) | BIT(BH_Delay))
 
 /*
@@ -2167,20 +2164,18 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
  * Walk through page buffers from @bh upto @head (exclusive) and either submit
  * the page for IO if all buffers in this page were mapped and there's no
  * accumulated extent of buffers to map or add buffers in the page to the
  * extent of buffers to map. The function returns 1 if the caller can continue
  * by processing the next page, 0 if it should stop adding buffers to the
- * extent to map because we cannot extend it anymore. It can also return value
- * < 0 in case of error during IO submission.
+ * extent to map because we cannot extend it anymore.
  */
 static int mpage_process_page_bufs(struct mpage_da_data *mpd,
 				   struct buffer_head *head,
 				   struct buffer_head *bh,
 				   ext4_lblk_t lblk)
 {
 	struct inode *inode = mpd->inode;
-	int err;
 	ext4_lblk_t blocks = (i_size_read(inode) + i_blocksize(inode) - 1)
 							>> inode->i_blkbits;
 
 	if (ext4_verity_in_progress(inode))
 		blocks = EXT_MAX_BLOCKS;
@@ -2199,13 +2194,11 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
 			break;
 		}
 	} while (lblk++, (bh = bh->b_this_page) != head);
 	/* So far everything mapped? Submit the page for IO. */
 	if (mpd->map.m_len == 0) {
-		err = mpage_submit_folio(mpd, head->b_folio);
-		if (err < 0)
-			return err;
+		mpage_submit_folio(mpd, head->b_folio);
 		mpage_folio_done(mpd, head->b_folio);
 	}
 	if (lblk >= blocks) {
 		mpd->scanned_until_end = 1;
 		return 0;
@@ -2331,13 +2324,11 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
 			 * So we return to call further extent mapping.
 			 */
 			if (err < 0 || map_bh)
 				goto out;
 			/* Page fully mapped - let IO run! */
-			err = mpage_submit_folio(mpd, folio);
-			if (err < 0)
-				goto out;
+			mpage_submit_folio(mpd, folio);
 			mpage_folio_done(mpd, folio);
 		}
 		folio_batch_release(&fbatch);
 	}
 	/* Extent fully mapped and matches with page boundary. We are done. */
@@ -2406,11 +2397,10 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
 static int mpage_submit_partial_folio(struct mpage_da_data *mpd)
 {
 	struct inode *inode = mpd->inode;
 	struct folio *folio;
 	loff_t pos;
-	int ret;
 
 	folio = filemap_get_folio(inode->i_mapping,
 				  mpd->start_pos >> PAGE_SHIFT);
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
@@ -2421,25 +2411,22 @@ static int mpage_submit_partial_folio(struct mpage_da_data *mpd)
 	pos = ((loff_t)mpd->map.m_lblk) << inode->i_blkbits;
 	if (WARN_ON_ONCE((folio_pos(folio) == pos) ||
 			 !folio_contains(folio, pos >> PAGE_SHIFT)))
 		return -EINVAL;
 
-	ret = mpage_submit_folio(mpd, folio);
-	if (ret)
-		goto out;
+	mpage_submit_folio(mpd, folio);
 	/*
 	 * Update start_pos to prevent this folio from being released in
 	 * mpage_release_unused_pages(), it will be reset to the aligned folio
 	 * pos when this folio is written again in the next round. Additionally,
 	 * do not update wbc->nr_to_write here, as it will be updated once the
 	 * entire folio has finished processing.
 	 */
 	mpd->start_pos = pos;
-out:
 	folio_unlock(folio);
 	folio_put(folio);
-	return ret;
+	return 0;
 }
 
 /*
  * mpage_map_and_submit_extent - map extent starting at mpd->lblk of length
  *				 mpd->len and submit pages underlying it for IO
@@ -2722,13 +2709,11 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			 * location before possibly journalling it again which
 			 * is desirable when the page is frequently dirtied
 			 * through a pin.
 			 */
 			if (!mpd->can_map) {
-				err = mpage_submit_folio(mpd, folio);
-				if (err < 0)
-					goto out;
+				mpage_submit_folio(mpd, folio);
 				/* Pending dirtying of journalled data? */
 				if (folio_test_checked(folio)) {
 					err = mpage_journal_page_buffers(handle,
 						mpd, folio);
 					if (err < 0)
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 557f44178d87..0236b6b9785a 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -457,11 +457,11 @@ static void io_submit_add_bh(struct ext4_io_submit *io,
 		goto submit_and_retry;
 	wbc_account_cgroup_owner(io->io_wbc, folio, bh->b_size);
 	io->io_next_block++;
 }
 
-int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
+void ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
 		size_t len)
 {
 	struct inode *inode = folio->mapping->host;
 	unsigned block_start;
 	struct buffer_head *bh, *head;
@@ -531,11 +531,11 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
 		 * We have nothing to submit. Just cycle the folio through
 		 * writeback state to properly update xarray tags.
 		 */
 		__folio_start_writeback(folio, keep_towrite);
 		folio_end_writeback(folio);
-		return 0;
+		return;
 	}
 
 	bh = head = folio_buffers(folio);
 
 	__folio_start_writeback(folio, keep_towrite);
@@ -544,8 +544,6 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
 	do {
 		if (!buffer_async_write(bh))
 			continue;
 		io_submit_add_bh(io, inode, folio, bh);
 	} while ((bh = bh->b_this_page) != head);
-
-	return 0;
 }
-- 
2.54.0


