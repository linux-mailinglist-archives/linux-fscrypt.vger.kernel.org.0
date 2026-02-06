Return-Path: <linux-fscrypt+bounces-1109-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wNqCFCU1hmlrLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1109-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:38:29 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C071020CA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0C3F930F71CE
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56EE4418E8;
	Fri,  6 Feb 2026 18:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dgnhT86q";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dgnhT86q"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9354D4418E3
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402305; cv=none; b=FqBt0/lD8N4EzXpG7XMBtklMDpowSJ1146b4YRvzCSXI9gs1iC9ySotE1wbqu3gtuYWQeljqRTgmm7T9FZQEcnEdO93Vg7ZyzexUm4v2mIj0hwMDc8mxovS9CWqzw0uou9pVQhcGC4itZ7faIP9tycYQLhFUvFiJuTHEkMTzQvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402305; c=relaxed/simple;
	bh=FBy99Pni9ZqUQJCWFn5hJAPFNmk7nOaxxWnDwn8nPjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mo5b8tW6FvSTMRo43YGQMELlsCC0m3Kb+UreRySc8+bCJq0922VAzCP7OK+Qx/jENJTbrxaa/l8Nm/GC30qFGyXnFOADGlEiMVJc03PE4fJtEwmR5tu+terx4wG/JM8C9PeXwx2D5jMbvuBJYBBHElhxpytdC5txQfPiMnZgq78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dgnhT86q; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dgnhT86q; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 95C6C3E74C;
	Fri,  6 Feb 2026 18:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HiR3m+n+8ALmEnGsv/bKdMO09KbAjSFNZ63G9sqGBN0=;
	b=dgnhT86qpk1BBbJ6q5dy6D/4ZkkJHYXxV3PLkgBqWX4UmuDUlm2DpPFzNGcax/QzCwibmV
	dRNlHH5U34MGyGsm4n0aj+soJxXwdxqjki6oMot27IsaBYyIYCYPyKd6FHYVlyyYe8kBiy
	Xob5nXnLwfMXiMjS1tnVP+R/vR5VYZQ=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HiR3m+n+8ALmEnGsv/bKdMO09KbAjSFNZ63G9sqGBN0=;
	b=dgnhT86qpk1BBbJ6q5dy6D/4ZkkJHYXxV3PLkgBqWX4UmuDUlm2DpPFzNGcax/QzCwibmV
	dRNlHH5U34MGyGsm4n0aj+soJxXwdxqjki6oMot27IsaBYyIYCYPyKd6FHYVlyyYe8kBiy
	Xob5nXnLwfMXiMjS1tnVP+R/vR5VYZQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6B23C3EA63;
	Fri,  6 Feb 2026 18:24:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +N+uGc0xhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:13 +0000
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
Subject: [PATCH v6 30/43] btrfs: add a bio argument to btrfs_csum_one_bio
Date: Fri,  6 Feb 2026 19:23:02 +0100
Message-ID: <20260206182336.1397715-31-neelx@suse.com>
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
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1109-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,toxicpanda.com:email,suse.com:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: 74C071020CA
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

v5: https://lore.kernel.org/linux-btrfs/595a2e46dae3d18bceb5dfa60ac3ae23760fc800.1706116485.git.josef@toxicpanda.com/
 * Adapted for async csums.  For writes we have to stick with sync
   csums.  Otherwise fscrypt would have to hand us the bounced bio
   instead of releasing it.  Though that is not implemented yet.
---
 fs/btrfs/bio.c       |  4 ++--
 fs/btrfs/bio.h       |  1 +
 fs/btrfs/file-item.c | 13 ++++++-------
 fs/btrfs/file-item.h |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 0a69e09bfe28..487dd9267fd7 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -592,9 +592,9 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
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
index 08dc78295707..ef0b6faf3de0 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -764,11 +764,10 @@ int btrfs_lookup_csums_bitmap(struct btrfs_root *root, struct btrfs_path *path,
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
@@ -796,19 +795,18 @@ static void csum_one_bio_work(struct work_struct *work)
 
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
 
@@ -827,12 +825,13 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
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
index 5645c5e3abdb..d16fd2144552 100644
--- a/fs/btrfs/file-item.h
+++ b/fs/btrfs/file-item.h
@@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct btrfs_ordered_sum *sums);
-int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
+int btrfs_csum_one_bio(struct btrfs_bio *bbio, struct bio *bio, bool async);
 int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit,
-- 
2.51.0


