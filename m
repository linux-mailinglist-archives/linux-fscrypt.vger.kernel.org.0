Return-Path: <linux-fscrypt+bounces-1592-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SMwtMatBBGokGQIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1592-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:17:31 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B86835307D1
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:17:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CD9033104509
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 09:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0DA3E5A08;
	Wed, 13 May 2026 08:56:21 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BF63EF0CE
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662581; cv=none; b=FO2UD0ulTvgX6CUncIDQF6sYbSAtlLi+cTxEN4bEbgxdLVMN0y99IXV/pPTAgizICrLABf5eOsyc6Qmvtv3g16LlD8uPijJCkdRTBVEA9X6hUL03rIQALQbCNPEArhBnmRzxVJTIkzO34Mu5oPBjjjEqzcWqDA7yTra2uSxvGls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662581; c=relaxed/simple;
	bh=Y6sHGvRDJoOsosMXONsfbKapiaJC10RMBV8sC/N7Pwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3MEjvfh0juUSunU0165Ny746bWrkEkykooii8r4XdmJ+DwM8L90dpWux+CB/OittNsZojAAopNXMC3qVge3Osa7ioKoC92A/vn184qegPaB0BVd6aV5IG+AXgBoumEE1KvwvjDe+dcNUhHWEW9AvR8MwDeZoINWeMxKveoY6I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4F94D7665D;
	Wed, 13 May 2026 08:54:41 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B3CD8593A9;
	Wed, 13 May 2026 08:54:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sN1uK1A8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:40 +0000
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
Subject: [PATCH v7 32/43] btrfs: implement process_bio cb for fscrypt
Date: Wed, 13 May 2026 10:53:06 +0200
Message-ID: <20260513085340.3673127-33-neelx@suse.com>
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
X-Rspamd-Queue-Id: B86835307D1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[suse.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1592-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,toxicpanda.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

We are going to be checksumming the encrypted data, so we have to
implement the ->process_bio fscrypt callback.  This will provide us with
the original bio and the encrypted bio to do work on.  For WRITE's this
will happen after the encrypted bio has been encrypted.  For READ's this
will happen after the read has completed and before the decryption step
is done.

For write's this is straightforward, we can just pass in the encrypted
bio to btrfs_csum_one_bio and then the csums will be added to the bbio
as normal.

For read's this is relatively straightforward, but requires some care.
We assume (because that's how it works currently) that the encrypted bio
match the original bio, this is important because we save the iter of
the bio before we submit.  If this changes in the future we'll need a
hook to give us the bi_iter of the decryption bio before it's submitted.
We check the csums before decryption.  If it doesn't match we simply
error out and we let the normal path handle the repair work.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v7 changes:
 * Fixed array overflow stack corruption for bios > max blocksize (>64KiB)
   as reported by Chris' AI review.
v6 changes:
 * Adapt to btrfs_data_csum_ok() changes for bs > ps.  Mostly follow
   what was done in 052fd7a5cace ("btrfs: make read verification
   handle bs > ps cases without large folios").
 * Rename bbio::csum_done to csum_ok due to name collision.
   With upstream, member name csum_done was used for async csums.
v5: https://lore.kernel.org/linux-btrfs/ca32684b01ff8c252be515509137e0a4a0e5db7a.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/bio.c       | 44 +++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/bio.h       |  3 +++
 fs/btrfs/file-item.c | 14 ++++++++++++--
 fs/btrfs/fscrypt.c   | 29 +++++++++++++++++++++++++++++
 4 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 3e2ee19aab50..729c5aff5c3d 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -301,6 +301,40 @@ static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
 	return fbio;
 }
 
+blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio, struct bio *enc_bio)
+{
+	struct btrfs_inode *inode = bbio->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct bvec_iter iter = bbio->saved_iter;
+	struct btrfs_device *dev = bbio->bio.bi_private;
+	const u32 blocksize = fs_info->sectorsize;
+	const u32 step = min(blocksize, PAGE_SIZE);
+	const u32 nr_steps = iter.bi_size / step;
+	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
+	phys_addr_t paddr;
+	unsigned int slot = 0;
+	u32 offset = 0;
+
+	/*
+	 * We have to use a copy of iter in case there's an error,
+	 * btrfs_check_read_bio will handle submitting the repair bios.
+	 */
+	btrfs_bio_for_each_block(paddr, enc_bio, &iter, step) {
+		ASSERT(slot < nr_steps);
+		paddrs[slot] = paddr;
+		slot++;
+		offset += step;
+		if (IS_ALIGNED(offset, blocksize)) {
+			if (!btrfs_data_csum_ok(bbio, dev, offset - blocksize, paddrs))
+				return BLK_STS_IOERR;
+			slot = 0;
+		}
+	}
+
+	bbio->csum_ok = true;
+	return BLK_STS_OK;
+}
+
 static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *dev)
 {
 	struct btrfs_inode *inode = bbio->inode;
@@ -330,6 +364,10 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
 	/* Clear the I/O error. A failed repair will reset it. */
 	bbio->bio.bi_status = BLK_STS_OK;
 
+	/* This was an encrypted bio and we've already done the csum check. */
+	if (status == BLK_STS_OK && bbio->csum_ok)
+		goto out;
+
 	btrfs_bio_for_each_block(paddr, &bbio->bio, iter, step) {
 		paddrs[(offset / step) % nr_steps] = paddr;
 		offset += step;
@@ -341,6 +379,7 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
 							 paddrs, fbio);
 		}
 	}
+out:
 	if (bbio->csum != bbio->csum_inline)
 		kvfree(bbio->csum);
 
@@ -859,10 +898,13 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 		/*
 		 * Csum items for reloc roots have already been cloned at this
 		 * point, so they are handled as part of the no-checksum case.
+		 *
+		 * Encrypted inodes are csum'ed via the ->process_bio callback.
 		 */
 		if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
 		    !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state) &&
-		    !btrfs_is_data_reloc_root(inode->root) && !bbio->is_remap) {
+		    !btrfs_is_data_reloc_root(inode->root) && !bbio->is_remap &&
+		    !IS_ENCRYPTED(&inode->vfs_inode)) {
 			if (should_async_write(bbio) &&
 			    btrfs_wq_submit_bio(bbio, bioc, &smap, mirror_num))
 				goto done;
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index 43f7544029ac..456d32db9e9e 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -43,6 +43,7 @@ struct btrfs_bio {
 		struct {
 			u8 *csum;
 			u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
+			bool csum_ok;
 			struct bvec_iter saved_iter;
 		};
 
@@ -130,5 +131,7 @@ void btrfs_submit_repair_write(struct btrfs_bio *bbio, int mirror_num, bool dev_
 int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
 			    u32 length, u64 logical, const phys_addr_t paddrs[],
 			    unsigned int step, int mirror_num);
+blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio,
+					    struct bio *enc_bio);
 
 #endif
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 986914078708..72d9d3243460 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -338,6 +338,14 @@ static int search_csum_tree(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static inline bool inode_skip_csum(struct btrfs_inode *inode)
+{
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+
+	return (inode->flags & BTRFS_INODE_NODATASUM) ||
+		test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state);
+}
+
 /*
  * Lookup the checksum for the read bio in csum tree.
  *
@@ -357,8 +365,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 	int ret = 0;
 	u32 bio_offset = 0;
 
-	if ((inode->flags & BTRFS_INODE_NODATASUM) ||
-	    test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state))
+	if (inode_skip_csum(inode))
 		return 0;
 
 	/*
@@ -817,6 +824,9 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, struct bio *bio, bool async)
 	struct btrfs_ordered_sum *sums;
 	unsigned nofs_flag;
 
+	if (inode_skip_csum(inode))
+		return 0;
+
 	nofs_flag = memalloc_nofs_save();
 	sums = kvzalloc(btrfs_ordered_sum_size(fs_info, bio->bi_iter.bi_size),
 		       GFP_KERNEL);
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 5d34a8b94da5..924ee3df7f32 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -16,6 +16,7 @@
 #include "transaction.h"
 #include "volumes.h"
 #include "xattr.h"
+#include "file-item.h"
 
 /*
  * From a given location in a leaf, read a name into a qstr (usually a
@@ -212,6 +213,33 @@ static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
 	return devs;
 }
 
+static blk_status_t btrfs_process_encrypted_bio(struct bio *orig_bio,
+						struct bio *enc_bio)
+{
+	struct btrfs_bio *bbio;
+
+	/*
+	 * If our bio is from the normal fs_bio_set then we know this is a
+	 * mirror split and we can skip it, we'll get the real bio on the last
+	 * mirror and we can process that one.
+	 */
+	if (orig_bio->bi_pool == &fs_bio_set)
+		return BLK_STS_OK;
+
+	bbio = btrfs_bio(orig_bio);
+
+	if (bio_op(orig_bio) == REQ_OP_READ) {
+		/*
+		 * We have ->saved_iter based on the orig_bio, so if the block
+		 * layer changes we need to notice this asap so we can update
+		 * our code to handle the new world order.
+		 */
+		ASSERT(orig_bio == enc_bio);
+		return btrfs_check_encrypted_read_bio(bbio, enc_bio);
+	}
+	return btrfs_csum_one_bio(bbio, enc_bio, false);
+}
+
 int btrfs_fscrypt_load_extent_info(struct btrfs_inode *inode,
 				   struct btrfs_path *path,
 				   struct btrfs_key *key,
@@ -327,4 +355,5 @@ const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.set_context = btrfs_fscrypt_set_context,
 	.empty_dir = btrfs_fscrypt_empty_dir,
 	.get_devices = btrfs_fscrypt_get_devices,
+	.process_bio = btrfs_process_encrypted_bio,
 };
-- 
2.53.0


