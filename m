Return-Path: <linux-fscrypt+bounces-1113-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UHVMNPs0hmlrLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1113-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:37:47 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50A691020A4
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:37:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3CB9630830F2
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E2C43D4E9;
	Fri,  6 Feb 2026 18:25:16 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C447143D4EA
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402316; cv=none; b=flOX5ly3mP7tbU9OVnaRWTedQNl785+45k/UgkrGh1QkK1Q2JjBMb8brgJf8GfROmY94hJ0goz1FOZi2oWMYdwftfO5XxbGyngBNkte8Bao/JCUSwP26FMGpTSbHFR4G8bUq2Ws8K2zwCF5A94Ur4r/6asYR5t3SO/uXNdv096k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402316; c=relaxed/simple;
	bh=sn0axnhEpIJaP96cuQggy2tofkrcxgC82ZQ/5vn9dQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlB8sZhibCjVPCSpE1bpUVDIb/j53r/W2gH8ER83HW5Rr4OhH4pk0mMYubFTLrxIjXGuHfQt5QgYPHtrXNUmtIbsRyATH3STrNbTEqMAPrB6KnTfWFB/2SpoOdLViknBE21OshNzuNW5d7SzT1knLXbhpOJcUIfV72Px7j4pg70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AB4AB3E75A;
	Fri,  6 Feb 2026 18:24:15 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B54A3EA63;
	Fri,  6 Feb 2026 18:24:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GNqkHc8xhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:15 +0000
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
Subject: [PATCH v6 33/43] btrfs: implement read repair for encryption
Date: Fri,  6 Feb 2026 19:23:05 +0100
Message-ID: <20260206182336.1397715-34-neelx@suse.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1113-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.993];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.com:mid,suse.com:email,toxicpanda.com:email]
X-Rspamd-Queue-Id: 50A691020A4
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

v5: https://lore.kernel.org/linux-btrfs/310c0ebdc78613b6f379595e160206013f75b6dc.1706116485.git.josef@toxicpanda.com/
 * Fixed UAF bug with !ordered case doing bbio->end_io(bbio) >>>
   fscrypt_put_extent_info(bbio->fscrypt_info).
   - We can simply put the fscrypt_info first and then end the bio.
   - Also no need to clear the bbio->fscrypt_info pointer as bbio is
     just going to be freed.  That cleans up the code a bit.
 * Adapted to bs > ps changes.
 * Updated and re-wrap the comments.
 * Moved the dio-related changes from inode.c to direct-io.c
   as upstream refactored in the meantime.
---
 fs/btrfs/bio.c         | 75 +++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/bio.h         | 10 +++++-
 fs/btrfs/compression.c |  2 ++
 fs/btrfs/direct-io.c   |  2 ++
 fs/btrfs/extent_io.c   |  2 ++
 5 files changed, 82 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 69dc32cb4ed6..a89f49dac0f2 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -97,6 +97,9 @@ static struct btrfs_bio *btrfs_split_bio(struct btrfs_fs_info *fs_info,
 		bbio->ordered = orig_bbio->ordered;
 		bbio->orig_logical = orig_bbio->orig_logical;
 		orig_bbio->orig_logical += map_length;
+	} else if (is_data_bbio(bbio)) {
+		bbio->fscrypt_info = fscrypt_get_extent_info(orig_bbio->fscrypt_info);
+		bbio->orig_start = orig_bbio->orig_start;
 	}
 
 	bbio->csum_search_commit_root = orig_bbio->csum_search_commit_root;
@@ -124,6 +127,8 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
 		/* Free bio that was never submitted to the underlying device. */
 		if (bbio_has_ordered_extent(bbio))
 			btrfs_put_ordered_extent(bbio->ordered);
+		else if (is_data_bbio(bbio))
+			fscrypt_put_extent_info(bbio->fscrypt_info);
 		bio_put(&bbio->bio);
 
 		bbio = orig_bbio;
@@ -147,6 +152,8 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
 			bbio->end_io(bbio);
 			btrfs_put_ordered_extent(ordered);
 		} else {
+			if (is_data_bbio(bbio))
+				fscrypt_put_extent_info(bbio->fscrypt_info);
 			bbio->end_io(bbio);
 		}
 	}
@@ -174,6 +181,23 @@ static void btrfs_repair_done(struct btrfs_failed_bio *fbio)
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
@@ -186,7 +210,6 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
 	 */
 	struct bvec_iter saved_iter = repair_bbio->saved_iter;
 	const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
-	const u64 logical = repair_bbio->saved_iter.bi_sector << SECTOR_SHIFT;
 	const u32 nr_steps = repair_bbio->saved_iter.bi_size / step;
 	int mirror = repair_bbio->mirror_num;
 	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
@@ -202,6 +225,13 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
 		slot++;
 	}
 
+	/*
+	 * If we got here from the encrypted path with ->csum_ok set then
+	 * we've already csumed and repaired this sector, we're all done.
+	 */
+	if (repair_bbio->csum_ok)
+		goto done;
+
 	if (repair_bbio->bio.bi_status ||
 	    !btrfs_data_csum_ok(repair_bbio, dev, 0, paddrs)) {
 		bio_reset(&repair_bbio->bio, NULL, REQ_OP_READ);
@@ -214,17 +244,17 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
 			goto done;
 		}
 
+		btrfs_set_bio_crypt_ctx_from_extent(&repair_bbio->bio,
+						    repair_bbio->inode,
+						    repair_bbio->fscrypt_info,
+						    repair_bbio->file_offset -
+						    repair_bbio->orig_start);
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
@@ -293,6 +323,13 @@ static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
 	repair_bbio = btrfs_bio(repair_bio);
 	btrfs_bio_init(repair_bbio, failed_bbio->inode, failed_bbio->file_offset + bio_offset,
 		       NULL, fbio);
+	repair_bbio->fscrypt_info = fscrypt_get_extent_info(failed_bbio->fscrypt_info);
+	repair_bbio->orig_start = failed_bbio->orig_start;
+
+	btrfs_set_bio_crypt_ctx_from_extent(repair_bio, repair_bbio->inode,
+					    failed_bbio->fscrypt_info,
+					    repair_bbio->file_offset -
+					    failed_bbio->orig_start);
 
 	mirror = next_repair_mirror(fbio, failed_bbio->mirror_num);
 	btrfs_debug(fs_info, "submitting repair read to mirror %d", mirror);
@@ -324,7 +361,29 @@ blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio, struct bio *
 	if (!btrfs_data_csum_ok(bbio, dev, 0, paddrs))
 			return BLK_STS_IOERR;
 
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
index cd7b245bedb8..15bf03be3fd5 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -606,6 +606,8 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	cb->compress_type = btrfs_extent_map_compression(em);
 	cb->orig_bbio = bbio;
 	cb->bbio.csum_search_commit_root = bbio->csum_search_commit_root;
+	cb->bbio.fscrypt_info = fscrypt_get_extent_info(em->fscrypt_info);
+	cb->bbio.orig_start = 0;
 
 	btrfs_set_bio_crypt_ctx_from_extent(&cb->bbio.bio, inode, em->fscrypt_info, 0);
 	btrfs_free_extent_map(em);
diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index d20a5b99bdde..c59e13fce764 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -765,6 +765,8 @@ static void btrfs_dio_submit_io(const struct iomap_iter *iter, struct bio *bio,
 	} else {
 		fscrypt_info = dio_data->fscrypt_info;
 		offset = file_offset - dio_data->orig_start;
+		bbio->fscrypt_info = fscrypt_get_extent_info(fscrypt_info);
+		bbio->orig_start = dio_data->orig_start;
 	}
 
 	btrfs_set_bio_crypt_ctx_from_extent(&bbio->bio, bbio->inode, fscrypt_info, offset);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3273b7e3b4b0..094855b77768 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -796,6 +796,8 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 	} else {
 		fscrypt_info = bio_ctrl->fscrypt_info;
 		offset = file_offset - bio_ctrl->orig_start;
+		bbio->fscrypt_info = fscrypt_get_extent_info(fscrypt_info);
+		bbio->orig_start = bio_ctrl->orig_start;
 	}
 
 	btrfs_set_bio_crypt_ctx_from_extent(&bbio->bio, inode, fscrypt_info, offset);
-- 
2.51.0


