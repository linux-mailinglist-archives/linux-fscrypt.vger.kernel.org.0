Return-Path: <linux-fscrypt+bounces-1585-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qEDdJdpABGokGQIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1585-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:14:02 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D881530623
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:14:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 20438318484B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C4240B6D1;
	Wed, 13 May 2026 08:55:57 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA62740628B
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662557; cv=none; b=GznGQlAcj4isdsw0kZBPy/qMpqnrQhdbIl9Jg8f9dmKqb34nQFj3RZnzBCknRLo+ZD7xkrzWh7CedJ7QYt6VMwcs1IeIDSBLdPv+N/sLJ+U2Sxe9txdu7h3PhFud/L4UYU5TKVJSmeazdmzOAtkzTgl2V08Gfn0oi/cnvQL5rZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662557; c=relaxed/simple;
	bh=8RcPoqHemc6SPw9YDRAqCvr/EdSf6BwFbH52B5eLgAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDB/iiF08rhV3hEQ0GKHy/9vORGsJrXUWTErnOLJV0y72EyhIuX6y6YfQkCnqRn6kJQ41KYqqe7JrduqMSHhyOIj641ZZx9KAuwh6UZClmdwEThKWtrB8xcXx5iDa3R3ZNL2gP5i/KPa22+UwonniU5ns+zvZm0OOjhyaoEeSr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A28896BB4F;
	Wed, 13 May 2026 08:54:38 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 67CD0593AC;
	Wed, 13 May 2026 08:54:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yOvdGE48BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:38 +0000
From: Daniel Vacek <neelx@suse.com>
To: Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>
Cc: linux-block@vger.kernel.org,
	Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 29/43] btrfs: set the bio fscrypt context when applicable
Date: Wed, 13 May 2026 10:53:03 +0200
Message-ID: <20260513085340.3673127-30-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260513085340.3673127-1-neelx@suse.com>
References: <20260513085340.3673127-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 3D881530623
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[suse.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1585-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,suse.com:mid]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

Now that we have the fscrypt_info plumbed through everywhere, add the
code to setup the bio encryption context from the extent context.

We use the per-extent fscrypt_extent_info for encryption/decryption.
We use the offset into the extent as the lblk for fscrypt.  So the start
of the extent has the lblk of 0, 4k into the extent has the lblk of 4k,
etc.  This is done to allow things like relocation to continue to work
properly.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v7 changes:
 * s/\<submit_bio(/blk_crypto_\0/ in btrfs_submit_dev_bio() due to commit
   bb8e2019ad613 ("blk-crypto: handle the fallback above the block layer")
 * Follow upstream fscrypt cleanup and use byte offsets instead of
   logical block numbers in the new api.  As a result remove the
   btrfs_set_bio_crypt_ctx_from_extent() and btrfs_mergeable_encrypted_bio()
   helpers and directly use fscrypt_set_bio_crypt_ctx_from_extent()
   and fscrypt_mergeable_extent_bio().
v6 changes:
 * The dio-related changes in inode.c were moved to direct-io.c
   as upstream refactored in the meantime.
 * Open-code orig_start to start - offset.
 * Get the inode from bbio instead of from page mapping
   as we no longer have the page in btrfs_bio_is_contig().
 * Directly use the file_offset passed to btrfs_bio_is_contig(), no need
   to compute it locally.  We even no longer have the page and offset.
v5: https://lore.kernel.org/linux-btrfs/9ca883acc746b5aba980d1d19317168a7491aba6.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/bio.c         |  2 +-
 fs/btrfs/compression.c |  4 +++
 fs/btrfs/direct-io.c   | 10 ++++++
 fs/btrfs/extent_io.c   | 72 +++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index cc0bd03048ba..689cc41409e5 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -535,7 +535,7 @@ static void btrfs_submit_dev_bio(struct btrfs_device *dev, struct bio *bio)
 	if (bio->bi_opf & REQ_BTRFS_CGROUP_PUNT)
 		blkcg_punt_bio_submit(bio);
 	else
-		submit_bio(bio);
+		blk_crypto_submit_bio(bio);
 }
 
 static void btrfs_submit_mirrored_bio(struct btrfs_io_context *bioc, int dev_nr)
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b2393a48a8fe..e235a2ac5838 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -33,6 +33,7 @@
 #include "subpage.h"
 #include "messages.h"
 #include "super.h"
+#include "fscrypt.h"
 
 static struct bio_set btrfs_compressed_bioset;
 
@@ -333,6 +334,8 @@ void btrfs_submit_compressed_write(struct btrfs_ordered_extent *ordered,
 	cb->bbio.bio.bi_iter.bi_sector = ordered->disk_bytenr >> SECTOR_SHIFT;
 	cb->bbio.ordered = ordered;
 
+	fscrypt_set_bio_crypt_ctx_from_extent(&cb->bbio.bio, ordered->fscrypt_info, 0, GFP_NOFS);
+
 	btrfs_submit_bbio(&cb->bbio, 0);
 }
 
@@ -590,6 +593,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	cb->orig_bbio = bbio;
 	cb->bbio.csum_search_commit_root = bbio->csum_search_commit_root;
 
+	fscrypt_set_bio_crypt_ctx_from_extent(&cb->bbio.bio, em->fscrypt_info, 0, GFP_NOFS);
 	btrfs_free_extent_map(em);
 
 	for (int i = 0; i * min_folio_size < compressed_len; i++) {
diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index e8b1ce4a3a11..4891bf233536 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -12,6 +12,7 @@
 #include "volumes.h"
 #include "bio.h"
 #include "ordered-data.h"
+#include "fscrypt.h"
 
 struct btrfs_dio_data {
 	ssize_t submitted;
@@ -727,6 +728,8 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 	struct btrfs_dio_private *dip =
 		container_of(bbio, struct btrfs_dio_private, bbio);
 	struct btrfs_dio_data *dio_data = iter->private;
+	struct fscrypt_extent_info *fscrypt_info = NULL;
+	u64 offset = 0;
 
 	btrfs_bio_init(bbio, BTRFS_I(iter->inode), file_offset,
 		       btrfs_dio_end_io, bio->bi_private);
@@ -746,6 +749,9 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 	if (iter->flags & IOMAP_WRITE) {
 		int ret;
 
+		fscrypt_info = dio_data->ordered->fscrypt_info;
+		offset = file_offset - dio_data->ordered->orig_offset;
+
 		ret = btrfs_extract_ordered_extent(bbio, dio_data->ordered);
 		if (ret) {
 			btrfs_finish_ordered_extent(dio_data->ordered,
@@ -755,8 +761,12 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 			iomap_dio_bio_end_io(bio);
 			return;
 		}
+	} else {
+		fscrypt_info = dio_data->fscrypt_info;
+		offset = file_offset - dio_data->orig_start;
 	}
 
+	fscrypt_set_bio_crypt_ctx_from_extent(&bbio->bio, fscrypt_info, offset, GFP_NOFS);
 	btrfs_submit_bbio(bbio, 0);
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2819989f895f..5e9cdcdc996a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -35,6 +35,7 @@
 #include "dev-replace.h"
 #include "super.h"
 #include "transaction.h"
+#include "fscrypt.h"
 
 static struct kmem_cache *extent_buffer_cache;
 
@@ -150,6 +151,10 @@ struct btrfs_bio_ctrl {
 	 * inside the same inode.
 	 */
 	u64 last_em_start;
+
+	/* This is set for reads and we have encryption. */
+	struct fscrypt_extent_info *fscrypt_info;
+	u64 orig_start;
 };
 
 /*
@@ -710,9 +715,28 @@ static int alloc_eb_folio_array(struct extent_buffer *eb, bool nofail)
 static bool btrfs_bio_is_contig(struct btrfs_bio_ctrl *bio_ctrl,
 				u64 disk_bytenr, loff_t file_offset)
 {
-	struct bio *bio = &bio_ctrl->bbio->bio;
+	struct btrfs_bio *bbio = bio_ctrl->bbio;
+	struct bio *bio = &bbio->bio;
+	struct inode *inode = &bbio->inode->vfs_inode;
 	const sector_t sector = disk_bytenr >> SECTOR_SHIFT;
 
+	if (IS_ENCRYPTED(inode)) {
+		u64 offset = 0;
+		struct fscrypt_extent_info *fscrypt_info = NULL;
+
+		/* bio_ctrl->fscrypt_info is only set in the READ case. */
+		if (bio_ctrl->fscrypt_info) {
+			fscrypt_info = bio_ctrl->fscrypt_info;
+			offset = file_offset - bio_ctrl->orig_start;
+		} else if (bbio->ordered) {
+			fscrypt_info = bbio->ordered->fscrypt_info;
+			offset = file_offset - bbio->ordered->orig_offset;
+		}
+
+		if (!fscrypt_mergeable_extent_bio(bio, fscrypt_info, offset))
+			return false;
+	}
+
 	if (bio_ctrl->compress_type != BTRFS_COMPRESS_NONE) {
 		/*
 		 * For compression, all IO should have its logical bytenr set
@@ -735,6 +759,8 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_bio *bbio;
+	struct fscrypt_extent_info *fscrypt_info = NULL;
+	u64 offset = 0;
 
 	bbio = btrfs_bio_alloc(BIO_MAX_VECS, bio_ctrl->opf, inode,
 			       file_offset, bio_ctrl->end_io_func, NULL);
@@ -754,6 +780,8 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 					ordered->file_offset +
 					ordered->disk_num_bytes - file_offset);
 			bbio->ordered = ordered;
+			fscrypt_info = ordered->fscrypt_info;
+			offset = file_offset - ordered->orig_offset;
 		}
 
 		/*
@@ -764,7 +792,12 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 		 */
 		bio_set_dev(&bbio->bio, fs_info->fs_devices->latest_dev->bdev);
 		wbc_init_bio(bio_ctrl->wbc, &bbio->bio);
+	} else {
+		fscrypt_info = bio_ctrl->fscrypt_info;
+		offset = file_offset - bio_ctrl->orig_start;
 	}
+
+	fscrypt_set_bio_crypt_ctx_from_extent(&bbio->bio, fscrypt_info, offset, GFP_NOFS);
 }
 
 /*
@@ -810,6 +843,19 @@ static void submit_extent_folio(struct btrfs_bio_ctrl *bio_ctrl,
 			len = bio_ctrl->len_to_oe_boundary;
 		}
 
+		/*
+		 * Encryption has to allocate bounce buffers to encrypt the bio,
+		 * and we need to make sure that it doesn't split the bio so we
+		 * retain all of our special info in the btrfs_bio, so submit
+		 * any bio that gets up to BIO_MAX_VECS worth of segments.
+		 */
+		if (IS_ENCRYPTED(&inode->vfs_inode) &&
+		    bio_data_dir(&bio_ctrl->bbio->bio) == WRITE &&
+		    bio_segments(&bio_ctrl->bbio->bio) == BIO_MAX_VECS) {
+			submit_one_bio(bio_ctrl);
+			continue;
+		}
+
 		if (!bio_add_folio(&bio_ctrl->bbio->bio, folio, len, pg_offset)) {
 			/* bio full: move on to a new one */
 			submit_one_bio(bio_ctrl);
@@ -1031,6 +1077,8 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 		u64 block_start;
 		u64 em_gen;
 
+		bio_ctrl->fscrypt_info = NULL;
+
 		ASSERT(IS_ALIGNED(cur, fs_info->sectorsize));
 		if (cur >= last_byte) {
 			folio_zero_range(folio, pg_offset, end - cur + 1);
@@ -1120,6 +1168,21 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 
 		bio_ctrl->last_em_start = em->start;
 
+		/*
+		 * We use the extent offset for the IV when decrypting the page,
+		 * so we have to set the extent_offset based on the orig_start
+		 * for this extent.  Also save the fscrypt_info so the bio ctx
+		 * can be set properly.  If this inode isn't encrypted this
+		 * won't do anything.
+		 *
+		 * If we're compressed we'll handle all of this in
+		 * btrfs_submit_compressed_read.
+		 */
+		if (compress_type == BTRFS_COMPRESS_NONE) {
+			bio_ctrl->orig_start = em->start - em->offset;
+			bio_ctrl->fscrypt_info = fscrypt_get_extent_info(em->fscrypt_info);
+		}
+
 		em_gen = em->generation;
 		btrfs_free_extent_map(em);
 		em = NULL;
@@ -1128,11 +1191,17 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 		if (block_start == EXTENT_MAP_HOLE) {
 			folio_zero_range(folio, pg_offset, blocksize);
 			end_folio_read(vi, folio, true, cur, blocksize);
+
+			/* This shouldn't be set, but clear it just in case. */
+			fscrypt_put_extent_info(bio_ctrl->fscrypt_info);
 			continue;
 		}
 		/* the get_extent function already copied into the folio */
 		if (block_start == EXTENT_MAP_INLINE) {
 			end_folio_read(vi, folio, true, cur, blocksize);
+
+			/* This shouldn't be set, but clear it just in case. */
+			fscrypt_put_extent_info(bio_ctrl->fscrypt_info);
 			continue;
 		}
 
@@ -1145,6 +1214,7 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 			submit_one_bio(bio_ctrl);
 		submit_extent_folio(bio_ctrl, disk_bytenr, folio, blocksize,
 				    pg_offset, em_gen);
+		fscrypt_put_extent_info(bio_ctrl->fscrypt_info);
 	}
 	return 0;
 }
-- 
2.53.0


