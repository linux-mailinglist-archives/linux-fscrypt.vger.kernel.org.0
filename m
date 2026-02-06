Return-Path: <linux-fscrypt+bounces-1102-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Oe2BZk1hmlrLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1102-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:40:25 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 793E61021B5
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:40:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B24D306D87B
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CC242882D;
	Fri,  6 Feb 2026 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VR2/SUri";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VR2/SUri"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942AD42848E
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402289; cv=none; b=NTzwAYXBhuDdmC1WvUcIgOUXA1v++YY+YmteiRGtretuNtv0/f2HAnM2AzuF44E7MYNc1vXY9Bm+R4ZhOjjXSvQ/XVt9V1ULf6h2kWa0Y++KfqXDV9Jteci/H1RipQGbJOHm+Zv7KUgIquWqLa716xCn1eawTUnUl0vp5wGIzDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402289; c=relaxed/simple;
	bh=eKEMXMgvwbEHaLDnuSziobkSPY1jAcWctjgqwLL2RHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JA0R4i80tU3/Kafpezac/AptSQiGedLg0/DEecQ5YpxnHAQ+Z18sXh/wYq+VmiRIrzBCdvJGUNOQXjemCz/1oZd6BiuqwD6u42UH5nnuQDnTML59pv3G2BS0twilTyZ/nSdMJmted/4Xf4PkQbm2V/SSOUvneFQz4A22WD7We4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VR2/SUri; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VR2/SUri; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C70505BD04;
	Fri,  6 Feb 2026 18:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T09jMFM1tmsRBBdjulk6aVd+RtanVhjVM/1FNw+dLLY=;
	b=VR2/SUri3Xy7havY1dhm0wpyffcmALF5c0cVXIqS5LP46++Rz34dVsX8sPMg45Rf7MyFi7
	cZ6qiguUbrJsXhIExfxoX1lqepkl3Iz3Vj6gQdYYTPKc6z7S4UBybZui0hDgbfMsZXPMZy
	PT72vMqCqZsJtXSAhcs5zDN3SRFFPGs=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T09jMFM1tmsRBBdjulk6aVd+RtanVhjVM/1FNw+dLLY=;
	b=VR2/SUri3Xy7havY1dhm0wpyffcmALF5c0cVXIqS5LP46++Rz34dVsX8sPMg45Rf7MyFi7
	cZ6qiguUbrJsXhIExfxoX1lqepkl3Iz3Vj6gQdYYTPKc6z7S4UBybZui0hDgbfMsZXPMZy
	PT72vMqCqZsJtXSAhcs5zDN3SRFFPGs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9764F3EA63;
	Fri,  6 Feb 2026 18:24:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +CZ2JMcxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:07 +0000
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
Subject: [PATCH v6 21/43] btrfs: plumb through setting the fscrypt_info for ordered extents
Date: Fri,  6 Feb 2026 19:22:53 +0100
Message-ID: <20260206182336.1397715-22-neelx@suse.com>
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
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
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
	TAGGED_FROM(0.00)[bounces-1102-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: 793E61021B5
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

v5: https://lore.kernel.org/linux-btrfs/80c5dabfe190b84e31a95160021da64ebcf7ecf7.1706116485.git.josef@toxicpanda.com/
 * Added fscrypt_info to file_extent structure to clean up and simplify
   the code following upstream changes since.
 * Squashed in https://lore.kernel.org/linux-btrfs/f2b402eac1963296b6b8db3cb59cdf24a8121b97.1706116485.git.josef@toxicpanda.com/
   ("btrfs: plumb the fscrypt extent context through create_io_em").
 * Moved fscrypt_info to be the last argument of alloc_ordered_extent().
---
 fs/btrfs/direct-io.c    |  1 +
 fs/btrfs/inode.c        |  3 +++
 fs/btrfs/ordered-data.c | 18 ++++++++++++------
 fs/btrfs/ordered-data.h |  1 +
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 9a63200d7a53..f3efc451d9a5 100644
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
index b425047f77c7..aef95d6e02bf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1183,6 +1183,7 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 	file_extent.num_bytes = async_extent->ram_size;
 	file_extent.offset = 0;
 	file_extent.compression = async_extent->compress_type;
+	file_extent.fscrypt_info = NULL;
 
 	em = btrfs_create_io_em(inode, start, &file_extent, BTRFS_ORDERED_COMPRESSED);
 	if (IS_ERR(em)) {
@@ -1319,6 +1320,7 @@ static int cow_one_range(struct btrfs_inode *inode, struct folio *locked_folio,
 	file_extent.ram_bytes = ins->offset;
 	file_extent.offset = 0;
 	file_extent.compression = BTRFS_COMPRESS_NONE;
+	file_extent.fscrypt_info = NULL;
 
 	/*
 	 * Locked range will be released either during error clean up (inside
@@ -10117,6 +10119,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	file_extent.ram_bytes = ram_bytes;
 	file_extent.offset = encoded->unencoded_offset;
 	file_extent.compression = compression;
+	file_extent.fscrypt_info = NULL;
 	em = btrfs_create_io_em(inode, start, &file_extent, BTRFS_ORDERED_COMPRESSED);
 	if (IS_ERR(em)) {
 		ret = PTR_ERR(em);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 7a5701937184..1b4d20a2f983 100644
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
@@ -192,10 +193,12 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
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
 	INIT_LIST_HEAD(&entry->list);
@@ -272,6 +275,7 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
  * @offset:          Offset into unencoded data where file data starts.
  * @flags:           Flags specifying type of extent (1U << BTRFS_ORDERED_*).
  * @compress_type:   Compression algorithm used for data.
+ * @fscrypt_info:    The fscrypt_extent_info for this extent, if necessary.
  *
  * Most of these parameters correspond to &struct btrfs_file_extent_item. The
  * tree is given a single reference on the ordered extent that was inserted, and
@@ -305,7 +309,8 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 					     file_extent->num_bytes,
 					     file_extent->disk_bytenr + file_extent->offset,
 					     file_extent->num_bytes, 0, flags,
-					     file_extent->compression);
+					     file_extent->compression,
+					     file_extent->fscrypt_info);
 	else
 		entry = alloc_ordered_extent(inode, file_offset,
 					     file_extent->num_bytes,
@@ -313,7 +318,8 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 					     file_extent->disk_bytenr,
 					     file_extent->disk_num_bytes,
 					     file_extent->offset, flags,
-					     file_extent->compression);
+					     file_extent->compression,
+					     file_extent->fscrypt_info);
 	if (!IS_ERR(entry))
 		insert_ordered_extent(entry);
 	return entry;
@@ -1271,8 +1277,8 @@ struct btrfs_ordered_extent *btrfs_split_ordered_extent(
 	if (WARN_ON_ONCE(ordered->disk_num_bytes != ordered->num_bytes))
 		return ERR_PTR(-EINVAL);
 
-	new = alloc_ordered_extent(inode, file_offset, len, len, disk_bytenr,
-				   len, 0, flags, ordered->compress_type);
+	new = alloc_ordered_extent(inode, file_offset, len, len, disk_bytenr, len, 0,
+				   flags, ordered->compress_type, ordered->fscrypt_info);
 	if (IS_ERR(new))
 		return new;
 
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index ce19198e7f84..51c795865fe6 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -188,6 +188,7 @@ struct btrfs_file_extent {
 	u64 num_bytes;
 	u64 ram_bytes;
 	u64 offset;
+	struct fscrypt_extent_info *fscrypt_info;
 	u8 compression;
 };
 
-- 
2.51.0


