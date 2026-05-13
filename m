Return-Path: <linux-fscrypt+bounces-1584-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iPDpFRg/BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1584-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:06:32 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E4C3F530396
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 324B83118BD3
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528DF3E5EDA;
	Wed, 13 May 2026 08:55:55 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C7240758B
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662555; cv=none; b=dr4gt0Tcs918aVdRWt1jNvs1JEp9xzqp7/r+7jC1qiw1KmwPL78HppoRgRkDHXN6iPQuST3ZjSHYvbZyZdIUM9ero+HZTVdzEEzSmnEsXplmvoqYkfPxuuVruI7EDGA5FFVgEAqKjX99vThkkIa2RHHijZhdozWzYPjWZ1405tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662555; c=relaxed/simple;
	bh=LoS7YHoAFW/usKm4yX9l3Fb7XUmfVNqSE1Z0mZx4M3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mz9c65yjyBIb+nxhqRwrng2diw5t3SxGzGH3oaFRaxGjfyiz5qEHgPe8l5wjriJZGBB+1hwhkcfSWVMvhw/0ca6RanyMUwMf/rdZN0ge4R4FcDZlHq9SqoAefdwJACwWHHzUKvDt+5A456a9w1+EBu3p1dgV80xMhV/cUhGzs0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 619777666C;
	Wed, 13 May 2026 08:54:39 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 40EDA593AC;
	Wed, 13 May 2026 08:54:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UKhmD088BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:39 +0000
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
Subject: [PATCH v7 30/43] btrfs: add a bio argument to btrfs_csum_one_bio
Date: Wed, 13 May 2026 10:53:04 +0200
Message-ID: <20260513085340.3673127-31-neelx@suse.com>
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
X-Rspamd-Queue-Id: E4C3F530396
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
	TAGGED_FROM(0.00)[bounces-1584-lists,linux-fscrypt=lfdr.de];
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

We only ever needed the bbio in btrfs_csum_one_bio, since that has the
bio embedded in it.  However with encryption we'll have a different bio
with the encrypted data in it, and the original bbio.  Update
btrfs_csum_one_bio to take the bio we're going to csum as an argument,
which will allow us to csum the encrypted bio and stuff the csums into
the corresponding bbio to be used later when the IO completes.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

No changes in v7.
v6 changes:
 * Adapted for async csums.  For writes we have to stick with sync
   csums.  Otherwise fscrypt would have to hand us the bounced bio
   instead of releasing it.  Though that is not implemented yet.
v5: https://lore.kernel.org/linux-btrfs/595a2e46dae3d18bceb5dfa60ac3ae23760fc800.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/bio.c       |  4 ++--
 fs/btrfs/bio.h       |  1 +
 fs/btrfs/file-item.c | 13 ++++++-------
 fs/btrfs/file-item.h |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 689cc41409e5..b79fc467445d 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -600,9 +600,9 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
 	if (bbio->bio.bi_opf & REQ_META)
 		return btree_csum_one_bio(bbio);
 #ifdef CONFIG_BTRFS_EXPERIMENTAL
-	return btrfs_csum_one_bio(bbio, true);
+	return btrfs_csum_one_bio(bbio, &bbio->bio, true);
 #else
-	return btrfs_csum_one_bio(bbio, false);
+	return btrfs_csum_one_bio(bbio, &bbio->bio, false);
 #endif
 }
 
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index 303ed6c7103d..43f7544029ac 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -59,6 +59,7 @@ struct btrfs_bio {
 			struct btrfs_ordered_sum *sums;
 			struct work_struct csum_work;
 			struct completion csum_done;
+			struct bio *csum_bio;
 			struct bvec_iter csum_saved_iter;
 			u64 orig_physical;
 			u64 orig_logical;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 020d30709770..986914078708 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -771,11 +771,10 @@ int btrfs_lookup_csums_bitmap(struct btrfs_root *root, struct btrfs_path *path,
 	return ret;
 }
 
-static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *src)
+static void csum_one_bio(struct btrfs_bio *bbio, struct bio *bio, struct bvec_iter *src)
 {
 	struct btrfs_inode *inode = bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct bio *bio = &bbio->bio;
 	struct btrfs_ordered_sum *sums = bbio->sums;
 	struct bvec_iter iter = *src;
 	phys_addr_t paddr;
@@ -803,19 +802,18 @@ static void csum_one_bio_work(struct work_struct *work)
 
 	ASSERT(btrfs_op(&bbio->bio) == BTRFS_MAP_WRITE);
 	ASSERT(bbio->async_csum == true);
-	csum_one_bio(bbio, &bbio->csum_saved_iter);
+	csum_one_bio(bbio, bbio->csum_bio, &bbio->csum_saved_iter);
 	complete(&bbio->csum_done);
 }
 
 /*
  * Calculate checksums of the data contained inside a bio.
  */
-int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
+int btrfs_csum_one_bio(struct btrfs_bio *bbio, struct bio *bio, bool async)
 {
 	struct btrfs_ordered_extent *ordered = bbio->ordered;
 	struct btrfs_inode *inode = bbio->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct bio *bio = &bbio->bio;
 	struct btrfs_ordered_sum *sums;
 	unsigned nofs_flag;
 
@@ -834,12 +832,13 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
 	btrfs_add_ordered_sum(ordered, sums);
 
 	if (!async) {
-		csum_one_bio(bbio, &bbio->bio.bi_iter);
+		csum_one_bio(bbio, bio, &bio->bi_iter);
 		return 0;
 	}
 	init_completion(&bbio->csum_done);
 	bbio->async_csum = true;
-	bbio->csum_saved_iter = bbio->bio.bi_iter;
+	bbio->csum_bio = bio;
+	bbio->csum_saved_iter = bio->bi_iter;
 	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
 	schedule_work(&bbio->csum_work);
 	return 0;
diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
index 6c678787c770..e170bac310ac 100644
--- a/fs/btrfs/file-item.h
+++ b/fs/btrfs/file-item.h
@@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
 			    struct btrfs_ordered_sum *sums);
-int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
+int btrfs_csum_one_bio(struct btrfs_bio *bbio, struct bio *bio, bool async);
 int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit,
-- 
2.53.0


