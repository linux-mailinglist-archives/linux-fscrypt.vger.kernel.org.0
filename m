Return-Path: <linux-fscrypt+bounces-1594-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SO52FmNBBGokGQIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1594-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:16:19 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD4B530756
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B003A31B474C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 09:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A5E3F0761;
	Wed, 13 May 2026 08:56:27 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C943E5EE1
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662587; cv=none; b=Wj2FgkHwyHjlL1xZllZfmlJgOvzGpN3uIw/nH1hiAgvUOrq/xLCd3ZV/M308o+YTqlBnIq3LOudFl/AJIOHOzCtfNVsyR9KxaHYy1PGYWtI7m20Iltvh4paKY1shyhob0N2rFc/lC1EEmgF8efokgXQy0E7tMG+2i0EioqsSvMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662587; c=relaxed/simple;
	bh=I7iO4BmQo38BToOEua6C/olmLwBr2k8kSLaPJRbOE5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lp7aJVNRXD2s0x4GZEC/BZcu2yehO1BYQrQWk25O3hyHIgyM9UHXTUDFWz/2V/StKdjxZKl+cqrFxAGtk/808iqDbFWzIwhoz1lVilxsZB7g+tPbAWIr3ntVAMPNt8C0Sm3uKD6bjDuf6IYIMkqevdx0c484gqVgNGdWIWlgmQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 38B707664F;
	Wed, 13 May 2026 08:54:42 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1281F593A9;
	Wed, 13 May 2026 08:54:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SG8SBFI8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:42 +0000
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
Subject: [PATCH v7 33/43] btrfs: implement read repair for encryption
Date: Wed, 13 May 2026 10:53:07 +0200
Message-ID: <20260513085340.3673127-34-neelx@suse.com>
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
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 6FD4B530756
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
	TAGGED_FROM(0.00)[bounces-1594-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,toxicpanda.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

In order to do read repair we will allocate sectorsize bio's and read
them one at a time, repairing any sectors that don't match their csum.
In order to do this we re-submit the IO's after it's failed, and at this
point we still need the fscrypt_extent_info for these new bio's.

Add the fscrypt_extent_info to the read part of the union in the
btrfs_bio, and then pass this through all the places where we do reads.
Additionally add the orig_start, because we need to be able to put the
correct extent offset for the encryption context.

With these in place we can utilize the normal read repair path.  The
only exception is that the actual repair of the bad copies has to be
triggered from the ->process_bio callback, because this is the encrypted
data.  If we waited until the end_io we would have the decrypted data
and we don't want to write that to the disk.  This is the only change to
the normal read repair path, we trigger the fixup of the broken sectors
in ->process_bio, and then we skip that part if we successfully repair
the sector in ->process_bio once we get to the endio.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v7 changes:
 * Follow upstream fscrypt cleanup and use byte offsets instead of
   logical block numbers in the new api.  As a result remove the
   btrfs_set_bio_crypt_ctx_from_extent() and btrfs_mergeable_encrypted_bio()
   helpers and directly use fscrypt_set_bio_crypt_ctx_from_extent()
   and fscrypt_mergeable_extent_bio().
v6 changes:
 * Fixed UAF bug with !ordered case doing bbio->end_io(bbio) >>>
   fscrypt_put_extent_info(bbio->fscrypt_info).
   - We can simply put the fscrypt_info first and then end the bio.
   - Also no need to clear the bbio->fscrypt_info pointer as bbio is
     just going to be freed.  That cleans up the code a bit.
 * Adapted to bs > ps changes.
 * Updated and re-wrap the comments.
 * Moved the dio-related changes from inode.c to direct-io.c
   as upstream refactored in the meantime.
v5: https://lore.kernel.org/linux-btrfs/310c0ebdc78613b6f379595e160206013f75b6dc.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/bio.c         | 76 +++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/bio.h         | 10 +++++-
 fs/btrfs/compression.c |  2 ++
 fs/btrfs/direct-io.c   |  2 ++
 fs/btrfs/extent_io.c   |  2 ++
 5 files changed, 83 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 729c5aff5c3d..3a8f32c5157f 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -98,6 +98,9 @@ static struct btrfs_bio *btrfs_split_bio(struct btrfs_fs_info *fs_info,
 		bbio->ordered = orig_bbio->ordered;
 		bbio->orig_logical = orig_bbio->orig_logical;
 		orig_bbio->orig_logical += map_length;
+	} else if (is_data_bbio(bbio)) {
+		bbio->fscrypt_info = fscrypt_get_extent_info(orig_bbio->fscrypt_info);
+		bbio->orig_start = orig_bbio->orig_start;
 	}
 
 	bbio->csum_search_commit_root = orig_bbio->csum_search_commit_root;
@@ -125,6 +128,8 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
 		/* Free bio that was never submitted to the underlying device. */
 		if (bbio_has_ordered_extent(bbio))
 			btrfs_put_ordered_extent(bbio->ordered);
+		else if (is_data_bbio(bbio))
+			fscrypt_put_extent_info(bbio->fscrypt_info);
 		bio_put(&bbio->bio);
 
 		bbio = orig_bbio;
@@ -148,6 +153,8 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
 			bbio->end_io(bbio);
 			btrfs_put_ordered_extent(ordered);
 		} else {
+			if (is_data_bbio(bbio))
+				fscrypt_put_extent_info(bbio->fscrypt_info);
 			bbio->end_io(bbio);
 		}
 	}
@@ -175,6 +182,23 @@ static void btrfs_repair_done(struct btrfs_failed_bio *fbio)
 	}
 }
 
+static void handle_repair(struct btrfs_bio *repair_bbio, phys_addr_t *paddrs)
+{
+	struct btrfs_failed_bio *fbio = repair_bbio->private;
+	struct btrfs_inode *inode = repair_bbio->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
+	const u64 logical = repair_bbio->saved_iter.bi_sector << SECTOR_SHIFT;
+	int mirror = repair_bbio->mirror_num;
+
+	do {
+		mirror = prev_repair_mirror(fbio, mirror);
+		btrfs_repair_io_failure(fs_info, btrfs_ino(inode),
+				  repair_bbio->file_offset, fs_info->sectorsize,
+				  logical, paddrs, step, mirror);
+	} while (mirror != fbio->bbio->mirror_num);
+}
+
 static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
 				 struct btrfs_device *dev)
 {
@@ -187,7 +211,6 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
 	 */
 	struct bvec_iter saved_iter = repair_bbio->saved_iter;
 	const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
-	const u64 logical = repair_bbio->saved_iter.bi_sector << SECTOR_SHIFT;
 	const u32 nr_steps = repair_bbio->saved_iter.bi_size / step;
 	int mirror = repair_bbio->mirror_num;
 	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
@@ -197,6 +220,13 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
 	/* Repair bbio should be eaxctly one block sized. */
 	ASSERT(repair_bbio->saved_iter.bi_size == fs_info->sectorsize);
 
+	/*
+	 * If we got here from the encrypted path with ->csum_ok set then
+	 * we've already csumed and repaired this sector, we're all done.
+	 */
+	if (repair_bbio->csum_ok)
+		goto done;
+
 	btrfs_bio_for_each_block(paddr, &repair_bbio->bio, &saved_iter, step) {
 		ASSERT(slot < nr_steps);
 		paddrs[slot] = paddr;
@@ -215,17 +245,17 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
 			goto done;
 		}
 
+		fscrypt_set_bio_crypt_ctx_from_extent(&repair_bbio->bio,
+						       repair_bbio->fscrypt_info,
+						       repair_bbio->file_offset -
+						       repair_bbio->orig_start,
+						       GFP_NOFS);
+
 		btrfs_submit_bbio(repair_bbio, mirror);
 		return;
 	}
 
-	do {
-		mirror = prev_repair_mirror(fbio, mirror);
-		btrfs_repair_io_failure(fs_info, btrfs_ino(inode),
-				  repair_bbio->file_offset, fs_info->sectorsize,
-				  logical, paddrs, step, mirror);
-	} while (mirror != fbio->bbio->mirror_num);
-
+	handle_repair(repair_bbio, paddrs);
 done:
 	btrfs_repair_done(fbio);
 	bio_put(&repair_bbio->bio);
@@ -294,6 +324,14 @@ static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
 	repair_bbio = btrfs_bio(repair_bio);
 	btrfs_bio_init(repair_bbio, failed_bbio->inode, failed_bbio->file_offset + bio_offset,
 		       NULL, fbio);
+	repair_bbio->fscrypt_info = fscrypt_get_extent_info(failed_bbio->fscrypt_info);
+	repair_bbio->orig_start = failed_bbio->orig_start;
+
+	fscrypt_set_bio_crypt_ctx_from_extent(repair_bio,
+					      failed_bbio->fscrypt_info,
+					      repair_bbio->file_offset -
+					      failed_bbio->orig_start,
+					      GFP_NOFS);
 
 	mirror = next_repair_mirror(fbio, failed_bbio->mirror_num);
 	btrfs_debug(fs_info, "submitting repair read to mirror %d", mirror);
@@ -331,7 +369,29 @@ blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio, struct bio *
 		}
 	}
 
+	/*
+	 * Read repair is slightly different for encrypted bio's.  This
+	 * callback is before we decrypt the bio in the block crypto layer,
+	 * we're not actually in the endio handler.
+	 *
+	 * We don't trigger the repair process here either, that is handled
+	 * in the actual endio path because we don't want to create another
+	 * pseudo endio path through this callback.  This is because when we
+	 * call btrfs_repair_done() we want to call the endio for the original
+	 * bbio. Short circuiting that for the encrypted case would be ugly.
+	 * We really want to the repair case to be handled generically.
+	 *
+	 * However for the actual repair part we need to use this page
+	 * pre-decrypted, which is why we call the btrfs_repair_io_failure()
+	 * code from this path.  The repair path is synchronous so we are
+	 * safe there.  Then we simply mark the repair bbio as completed so
+	 * the actual btrfs_end_repair_bio() code can skip the repair part.
+	 */
+	if (bbio->bio.bi_pool == &btrfs_repair_bioset)
+		handle_repair(bbio, paddrs);
 	bbio->csum_ok = true;
+	fscrypt_put_extent_info(bbio->fscrypt_info);
+	bbio->fscrypt_info = NULL;
 	return BLK_STS_OK;
 }
 
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index 456d32db9e9e..7a8ff4378cba 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -15,6 +15,7 @@
 struct btrfs_bio;
 struct btrfs_fs_info;
 struct btrfs_inode;
+struct fscrypt_extent_info;
 
 #define BTRFS_BIO_INLINE_CSUM_SIZE	64
 
@@ -38,13 +39,20 @@ struct btrfs_bio {
 	union {
 		/*
 		 * For data reads: checksumming and original I/O information.
-		 * (for internal use in the btrfs_submit_bbio() machinery only)
+		 * (for internal use in the btrfs_submit_bbio() machinery only).
+		 *
+		 * The fscrypt context is used for read repair, this is the
+		 * only thing not internal to btrfs_submit_bbio() machinery.
 		 */
 		struct {
 			u8 *csum;
 			u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
 			bool csum_ok;
 			struct bvec_iter saved_iter;
+
+			/* Used for read repair. */
+			struct fscrypt_extent_info *fscrypt_info;
+			u64 orig_start;
 		};
 
 		/*
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e235a2ac5838..8269258d0dc4 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -592,6 +592,8 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	cb->compress_type = btrfs_extent_map_compression(em);
 	cb->orig_bbio = bbio;
 	cb->bbio.csum_search_commit_root = bbio->csum_search_commit_root;
+	cb->bbio.fscrypt_info = fscrypt_get_extent_info(em->fscrypt_info);
+	cb->bbio.orig_start = 0;
 
 	fscrypt_set_bio_crypt_ctx_from_extent(&cb->bbio.bio, em->fscrypt_info, 0, GFP_NOFS);
 	btrfs_free_extent_map(em);
diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 4891bf233536..bef4e2f953e4 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -764,6 +764,8 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 	} else {
 		fscrypt_info = dio_data->fscrypt_info;
 		offset = file_offset - dio_data->orig_start;
+		bbio->fscrypt_info = fscrypt_get_extent_info(fscrypt_info);
+		bbio->orig_start = dio_data->orig_start;
 	}
 
 	fscrypt_set_bio_crypt_ctx_from_extent(&bbio->bio, fscrypt_info, offset, GFP_NOFS);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5e9cdcdc996a..32e39837294b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -795,6 +795,8 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 	} else {
 		fscrypt_info = bio_ctrl->fscrypt_info;
 		offset = file_offset - bio_ctrl->orig_start;
+		bbio->fscrypt_info = fscrypt_get_extent_info(fscrypt_info);
+		bbio->orig_start = bio_ctrl->orig_start;
 	}
 
 	fscrypt_set_bio_crypt_ctx_from_extent(&bbio->bio, fscrypt_info, offset, GFP_NOFS);
-- 
2.53.0


