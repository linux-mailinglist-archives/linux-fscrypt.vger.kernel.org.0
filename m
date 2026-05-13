Return-Path: <linux-fscrypt+bounces-1579-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YM14E88+BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1579-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:05:19 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BCEC0530315
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:05:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EBF9D31686C2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E603FF8A7;
	Wed, 13 May 2026 08:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="U4lZV6Hl";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="U4lZV6Hl"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834113E5A37
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662538; cv=none; b=MsOVuczefG2PViBVHgPfBY9dazw9ox88QAmLwfX+pwKqhpqMiIgkWMYRmwmUe24kuu1sZPinI13HwxNI+PECw/Il/V8l1PZbyFzSTGDekoMn/5RyphUuEaf8Ly9NxleFWjP8X+4jLsm0/XEKdacvktlfhQ7BziCUko6y3xGOCxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662538; c=relaxed/simple;
	bh=2bFzjyIpLs1czlZsJGIN1bQbxHgnl1nHDt1MSKTacM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ko6RwMZX22xzUcgyDIhBFtVq/f8k7NANTM97jBnZFFMcBWqhAZnRZnd2wpD89Y9BEPaqeKIgNJnlS+BPpgXDCeUbpUjG58q47aOUNPjcPdfw2zfG3z3q5MR5a0z5KNgVNfZMIZBFbvWL3Z7GwXlO/aMbfTXEP2qsdb99F/VbkJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=U4lZV6Hl; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=U4lZV6Hl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DF861625BD;
	Wed, 13 May 2026 08:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EAHcmaI3b0lUgU5jKCIt9tfO+ErWCeBLErpSomOMXgs=;
	b=U4lZV6Hll7qzzZlTSC2UwjSvUIhhtZTIqusGpd4SiwDn03puwicGxvh+eroaOlj912sVGm
	5sOjZsVPk+M3z4jX6BGYkQr8k2Gj1Hqf1A8n0jHpCW8GClJltlMW9rmoNgwm8JZD6oTZt5
	Hiq//wRM7sgDcjiYi3M9T4G1PX4hOdw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EAHcmaI3b0lUgU5jKCIt9tfO+ErWCeBLErpSomOMXgs=;
	b=U4lZV6Hll7qzzZlTSC2UwjSvUIhhtZTIqusGpd4SiwDn03puwicGxvh+eroaOlj912sVGm
	5sOjZsVPk+M3z4jX6BGYkQr8k2Gj1Hqf1A8n0jHpCW8GClJltlMW9rmoNgwm8JZD6oTZt5
	Hiq//wRM7sgDcjiYi3M9T4G1PX4hOdw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9FB1593A9;
	Wed, 13 May 2026 08:54:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UPGRLEg8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:32 +0000
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
Subject: [PATCH v7 21/43] btrfs: plumb through setting the fscrypt_info for ordered extents
Date: Wed, 13 May 2026 10:52:55 +0200
Message-ID: <20260513085340.3673127-22-neelx@suse.com>
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
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Rspamd-Queue-Id: BCEC0530315
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1579-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,suse.com:mid,suse.com:dkim]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

We're going to be getting fscrypt_info from the extent maps.  Pass the
fscrypt_info to helpers using the file_extent structure and use that
to set the encryption type on the ordered extent.

For prealloc extents we create an em, since we already have the context
loaded from the original prealloc extent creation we need to pre-
populate the extent map fscrypt info so it can be read properly later
if the pages are evicted.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

No changes in v7.
v6 changes:
 * Added fscrypt_info to file_extent structure to clean up and simplify
   the code following upstream changes since.
 * Squashed in https://lore.kernel.org/linux-btrfs/f2b402eac1963296b6b8db3cb59cdf24a8121b97.1706116485.git.josef@toxicpanda.com/
   ("btrfs: plumb the fscrypt extent context through create_io_em").
 * Moved fscrypt_info to be the last argument of alloc_ordered_extent().
v5: https://lore.kernel.org/linux-btrfs/80c5dabfe190b84e31a95160021da64ebcf7ecf7.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/direct-io.c    |  1 +
 fs/btrfs/inode.c        |  3 +++
 fs/btrfs/ordered-data.c | 18 ++++++++++++------
 fs/btrfs/ordered-data.h |  1 +
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 57167d56dc72..5a53739e9445 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -202,6 +202,7 @@ static struct extent_map *btrfs_new_extent_direct(struct btrfs_inode *inode,
 	file_extent.ram_bytes = ins.offset;
 	file_extent.offset = 0;
 	file_extent.compression = BTRFS_COMPRESS_NONE;
+	file_extent.fscrypt_info = NULL;
 	em = btrfs_create_dio_extent(inode, dio_data, start, &file_extent,
 				     BTRFS_ORDERED_REGULAR);
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17e2c77c584a..c6c8ae05e471 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1112,6 +1112,7 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 	file_extent.num_bytes = async_extent->ram_size;
 	file_extent.offset = 0;
 	file_extent.compression = async_extent->cb->compress_type;
+	file_extent.fscrypt_info = NULL;
 
 	async_extent->cb->bbio.bio.bi_iter.bi_sector = ins.objectid >> SECTOR_SHIFT;
 
@@ -1249,6 +1250,7 @@ static int cow_one_range(struct btrfs_inode *inode, struct folio *locked_folio,
 	file_extent.ram_bytes = ins->offset;
 	file_extent.offset = 0;
 	file_extent.compression = BTRFS_COMPRESS_NONE;
+	file_extent.fscrypt_info = NULL;
 
 	/*
 	 * Locked range will be released either during error clean up (inside
@@ -10201,6 +10203,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	file_extent.ram_bytes = ram_bytes;
 	file_extent.offset = encoded->unencoded_offset;
 	file_extent.compression = compression;
+	file_extent.fscrypt_info = NULL;
 	em = btrfs_create_io_em(inode, start, &file_extent, BTRFS_ORDERED_COMPRESSED);
 	if (IS_ERR(em)) {
 		ret = PTR_ERR(em);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index ac302fb7484b..5a9bb0e8a18c 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -148,7 +148,8 @@ static inline struct rb_node *ordered_tree_search(struct btrfs_inode *inode,
 static struct btrfs_ordered_extent *alloc_ordered_extent(
 			struct btrfs_inode *inode, u64 file_offset, u64 num_bytes,
 			u64 ram_bytes, u64 disk_bytenr, u64 disk_num_bytes,
-			u64 offset, unsigned long flags, int compress_type)
+			u64 offset, unsigned long flags, int compress_type,
+			struct fscrypt_extent_info *fscrypt_info)
 {
 	struct btrfs_ordered_extent *entry;
 	int ret;
@@ -205,10 +206,12 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	}
 	entry->inode = inode;
 	entry->compress_type = compress_type;
-	entry->encryption_type = BTRFS_ENCRYPTION_NONE;
 	entry->truncated_len = (u64)-1;
 	entry->qgroup_rsv = qgroup_rsv;
 	entry->flags = flags;
+	entry->fscrypt_info = fscrypt_get_extent_info(fscrypt_info);
+	entry->encryption_type = entry->fscrypt_info ?
+		BTRFS_ENCRYPTION_FSCRYPT : BTRFS_ENCRYPTION_NONE;
 	refcount_set(&entry->refs, 1);
 	init_waitqueue_head(&entry->wait);
 	INIT_LIST_HEAD(&entry->csum_list);
@@ -290,6 +293,7 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
  * @offset:          Offset into unencoded data where file data starts.
  * @flags:           Flags specifying type of extent (1U << BTRFS_ORDERED_*).
  * @compress_type:   Compression algorithm used for data.
+ * @fscrypt_info:    The fscrypt_extent_info for this extent, if necessary.
  *
  * Most of these parameters correspond to &struct btrfs_file_extent_item. The
  * tree is given a single reference on the ordered extent that was inserted, and
@@ -323,7 +327,8 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 					     file_extent->num_bytes,
 					     file_extent->disk_bytenr + file_extent->offset,
 					     file_extent->num_bytes, 0, flags,
-					     file_extent->compression);
+					     file_extent->compression,
+					     file_extent->fscrypt_info);
 	else
 		entry = alloc_ordered_extent(inode, file_offset,
 					     file_extent->num_bytes,
@@ -331,7 +336,8 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 					     file_extent->disk_bytenr,
 					     file_extent->disk_num_bytes,
 					     file_extent->offset, flags,
-					     file_extent->compression);
+					     file_extent->compression,
+					     file_extent->fscrypt_info);
 	if (!IS_ERR(entry))
 		insert_ordered_extent(entry);
 	return entry;
@@ -1270,8 +1276,8 @@ struct btrfs_ordered_extent *btrfs_split_ordered_extent(
 	if (WARN_ON_ONCE(ordered->disk_num_bytes != ordered->num_bytes))
 		return ERR_PTR(-EINVAL);
 
-	new = alloc_ordered_extent(inode, file_offset, len, len, disk_bytenr,
-				   len, 0, flags, ordered->compress_type);
+	new = alloc_ordered_extent(inode, file_offset, len, len, disk_bytenr, len, 0,
+				   flags, ordered->compress_type, ordered->fscrypt_info);
 	if (IS_ERR(new))
 		return new;
 
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 9b288c3908f9..a3514a4d9ea1 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -192,6 +192,7 @@ struct btrfs_file_extent {
 	u64 num_bytes;
 	u64 ram_bytes;
 	u64 offset;
+	struct fscrypt_extent_info *fscrypt_info;
 	u8 compression;
 };
 
-- 
2.53.0


