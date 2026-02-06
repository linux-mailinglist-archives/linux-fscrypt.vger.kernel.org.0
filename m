Return-Path: <linux-fscrypt+bounces-1107-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kFtrJs40hmlrLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1107-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:37:02 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DC9C4102068
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:37:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3DCD53085B3D
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E95A436366;
	Fri,  6 Feb 2026 18:25:01 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4D843635D
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402301; cv=none; b=OjhN40umMyb1qj4CkmJyFaSf9GcgiYeIl6Yvi9EH7xxlxu03AbyOW6CipQliS6bJKIMrqh3Qgqh2R5u5AIFMlBKXcQBwSw4rgSo5wCb+z04smFKvzHzwRwahBN9mHMgqCLKXjHcEwRIRuYu9beAk8rQFhpuK+ifOlhjCh2vCA+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402301; c=relaxed/simple;
	bh=qffIPQg1d8ufVNyNSiBteACKOtofx3HUKppGtoXGvFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fW6IGMRqbqxy9VfopR/TSGAjqbJCVORqXTlv+4nhRsHkqCELgyT5KS5fn/CnRhTBHMM5VJxQ8aGbVYoSPwSd4BrEoEKE134fJAP/lx6QWwHRiYBG7aH0ijk5in7ychlJmk5tEsfL1TmkJ25F6TNv/0gWReJWyQywFmoHzqy7gkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E7D913E759;
	Fri,  6 Feb 2026 18:24:12 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BAEC33EA63;
	Fri,  6 Feb 2026 18:24:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kHonLcwxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:12 +0000
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
Subject: [PATCH v6 29/43] btrfs: set the bio fscrypt context when applicable
Date: Fri,  6 Feb 2026 19:23:01 +0100
Message-ID: <20260206182336.1397715-30-neelx@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260206182336.1397715-1-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com>
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
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[suse.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1107-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.993];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,toxicpanda.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DC9C4102068
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

v5: https://lore.kernel.org/linux-btrfs/9ca883acc746b5aba980d1d19317168a7491aba6.1706116485.git.josef@toxicpanda.com/
 * The dio-related changes in inode.c were moved to direct-io.c
   as upstream refactored in the meantime.
 * Open-code orig_start to start - offset.
 * Get the inode from bbio instead of from page mapping
   as we no longer have the page in btrfs_bio_is_contig().
 * Directly use the file_offset passed to btrfs_bio_is_contig(), no need
   to compute it locally.  We even no longer have the page and offset.
---
 fs/btrfs/compression.c |  4 +++
 fs/btrfs/direct-io.c   | 10 ++++++
 fs/btrfs/extent_io.c   | 72 +++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/fscrypt.c     | 33 +++++++++++++++++++
 fs/btrfs/fscrypt.h     | 22 +++++++++++++
 5 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 4c6298cf01b2..cd7b245bedb8 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -33,6 +33,7 @@
 #include "subpage.h"
 #include "messages.h"
 #include "super.h"
+#include "fscrypt.h"
 
 static struct bio_set btrfs_compressed_bioset;
 
@@ -391,6 +392,8 @@ void btrfs_submit_compressed_write(struct btrfs_ordered_extent *ordered,
 	cb->bbio.ordered = ordered;
 	btrfs_add_compressed_bio_folios(cb);
 
+	btrfs_set_bio_crypt_ctx_from_extent(&cb->bbio.bio, inode, ordered->fscrypt_info, 0);
+
 	btrfs_submit_bbio(&cb->bbio, 0);
 }
 
@@ -604,6 +607,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	cb->orig_bbio = bbio;
 	cb->bbio.csum_search_commit_root = bbio->csum_search_commit_root;
 
+	btrfs_set_bio_crypt_ctx_from_extent(&cb->bbio.bio, inode, em->fscrypt_info, 0);
 	btrfs_free_extent_map(em);
 
 	cb->nr_folios = DIV_ROUND_UP(compressed_len, btrfs_min_folio_size(fs_info));
diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 2d89ac05b1b3..d20a5b99bdde 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -12,6 +12,7 @@
 #include "volumes.h"
 #include "bio.h"
 #include "ordered-data.h"
+#include "fscrypt.h"
 
 struct btrfs_dio_data {
 	ssize_t submitted;
@@ -728,6 +729,8 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 	struct btrfs_dio_private *dip =
 		container_of(bbio, struct btrfs_dio_private, bbio);
 	struct btrfs_dio_data *dio_data = iter->private;
+	struct fscrypt_extent_info *fscrypt_info = NULL;
+	u64 offset = 0;
 
 	btrfs_bio_init(bbio, BTRFS_I(iter->inode), file_offset,
 		       btrfs_dio_end_io, bio->bi_private);
@@ -747,6 +750,9 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 	if (iter->flags & IOMAP_WRITE) {
 		int ret;
 
+		offset = file_offset - dio_data->ordered->orig_offset;
+		fscrypt_info = dio_data->ordered->fscrypt_info;
+
 		ret = btrfs_extract_ordered_extent(bbio, dio_data->ordered);
 		if (ret) {
 			btrfs_finish_ordered_extent(dio_data->ordered, NULL,
@@ -756,8 +762,12 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 			iomap_dio_bio_end_io(bio);
 			return;
 		}
+	} else {
+		fscrypt_info = dio_data->fscrypt_info;
+		offset = file_offset - dio_data->orig_start;
 	}
 
+	btrfs_set_bio_crypt_ctx_from_extent(&bbio->bio, bbio->inode, fscrypt_info, offset);
 	btrfs_submit_bbio(bbio, 0);
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a440cc550ece..3273b7e3b4b0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -34,6 +34,7 @@
 #include "dev-replace.h"
 #include "super.h"
 #include "transaction.h"
+#include "fscrypt.h"
 
 static struct kmem_cache *extent_buffer_cache;
 
@@ -149,6 +150,10 @@ struct btrfs_bio_ctrl {
 	 * inside the same inode.
 	 */
 	u64 last_em_start;
+
+	/* This is set for reads and we have encryption. */
+	struct fscrypt_extent_info *fscrypt_info;
+	u64 orig_start;
 };
 
 /*
@@ -711,9 +716,28 @@ static int alloc_eb_folio_array(struct extent_buffer *eb, bool nofail)
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
+			offset = file_offset - bio_ctrl->orig_start;
+			fscrypt_info = bio_ctrl->fscrypt_info;
+		} else if (bbio->ordered) {
+			fscrypt_info = bbio->ordered->fscrypt_info;
+			offset = file_offset - bbio->ordered->orig_offset;
+		}
+
+		if (!btrfs_mergeable_encrypted_bio(bio, inode, fscrypt_info, offset))
+			return false;
+	}
+
 	if (bio_ctrl->compress_type != BTRFS_COMPRESS_NONE) {
 		/*
 		 * For compression, all IO should have its logical bytenr set
@@ -736,6 +760,8 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_bio *bbio;
+	struct fscrypt_extent_info *fscrypt_info = NULL;
+	u64 offset = 0;
 
 	bbio = btrfs_bio_alloc(BIO_MAX_VECS, bio_ctrl->opf, inode,
 			       file_offset, bio_ctrl->end_io_func, NULL);
@@ -755,6 +781,8 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 					ordered->file_offset +
 					ordered->disk_num_bytes - file_offset);
 			bbio->ordered = ordered;
+			fscrypt_info = ordered->fscrypt_info;
+			offset = file_offset - ordered->orig_offset;
 		}
 
 		/*
@@ -765,7 +793,12 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 		 */
 		bio_set_dev(&bbio->bio, fs_info->fs_devices->latest_dev->bdev);
 		wbc_init_bio(bio_ctrl->wbc, &bbio->bio);
+	} else {
+		fscrypt_info = bio_ctrl->fscrypt_info;
+		offset = file_offset - bio_ctrl->orig_start;
 	}
+
+	btrfs_set_bio_crypt_ctx_from_extent(&bbio->bio, inode, fscrypt_info, offset);
 }
 
 /*
@@ -811,6 +844,19 @@ static void submit_extent_folio(struct btrfs_bio_ctrl *bio_ctrl,
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
 			end_folio_read(folio, true, cur, blocksize);
+
+			/* This shouldn't be set, but clear it just in case. */
+			fscrypt_put_extent_info(bio_ctrl->fscrypt_info);
 			continue;
 		}
 		/* the get_extent function already copied into the folio */
 		if (block_start == EXTENT_MAP_INLINE) {
 			end_folio_read(folio, true, cur, blocksize);
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
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 26060f3e50de..f4d6979a581b 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -295,6 +295,39 @@ ssize_t btrfs_fscrypt_context_for_new_extent(struct btrfs_inode *inode,
 	return ret;
 }
 
+void btrfs_set_bio_crypt_ctx_from_extent(struct bio *bio,
+					 struct btrfs_inode *inode,
+					 struct fscrypt_extent_info *fi,
+					 u64 logical_offset)
+{
+	if (!fi)
+		return;
+
+	/*
+	 * fscrypt uses bytes >> s_blocksize_bits for the block numbers, so we
+	 * have to adjust everything based on our sectorsize so that the DUN
+	 * calculations are correct.
+	 */
+	logical_offset = div64_u64(logical_offset, inode->root->fs_info->sectorsize);
+	fscrypt_set_bio_crypt_ctx_from_extent(bio, fi, logical_offset, GFP_NOFS);
+}
+
+bool btrfs_mergeable_encrypted_bio(struct bio *bio, struct inode *inode,
+				   struct fscrypt_extent_info *fi,
+				   u64 logical_offset)
+{
+	if (!fi)
+		return true;
+
+	/*
+	 * fscrypt uses bytes >> s_blocksize_bits for the block numbers, so we
+	 * have to adjust everything based on our sectorsize so that the DUN
+	 * calculations are correct.
+	 */
+	logical_offset = div64_u64(logical_offset, BTRFS_I(inode)->root->fs_info->sectorsize);
+	return fscrypt_mergeable_extent_bio(bio, fi, logical_offset);
+}
+
 const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.inode_info_offs = (int)offsetof(struct btrfs_inode, i_crypt_info) -
 			   (int)offsetof(struct btrfs_inode, vfs_inode),
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 68eab4606935..1a2a4ffee383 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -24,6 +24,13 @@ void btrfs_fscrypt_save_extent_info(struct btrfs_path *path, u8 *ctx, unsigned l
 ssize_t btrfs_fscrypt_context_for_new_extent(struct btrfs_inode *inode,
 					     struct fscrypt_extent_info *info,
 					     u8 *ctx);
+void btrfs_set_bio_crypt_ctx_from_extent(struct bio *bio,
+					 struct btrfs_inode *inode,
+					 struct fscrypt_extent_info *fi,
+					 u64 logical_offset);
+bool btrfs_mergeable_encrypted_bio(struct bio *bio, struct inode *inode,
+				   struct fscrypt_extent_info *fi,
+				   u64 logical_offset);
 
 #else
 static inline void btrfs_fscrypt_save_extent_info(struct btrfs_path *path,
@@ -63,6 +70,21 @@ static inline ssize_t btrfs_fscrypt_context_for_new_extent(struct btrfs_inode *i
 	return -EINVAL;
 }
 
+static inline void btrfs_set_bio_crypt_ctx_from_extent(struct bio *bio,
+						       struct btrfs_inode *inode,
+						       struct fscrypt_extent_info *fi,
+						       u64 logical_offset)
+{
+}
+
+static inline bool btrfs_mergeable_encrypted_bio(struct bio *bio,
+						 struct inode *inode,
+						 struct fscrypt_extent_info *fi,
+						 u64 logical_offset)
+{
+	return true;
+}
+
 #endif /* CONFIG_FS_ENCRYPTION */
 
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
-- 
2.51.0


