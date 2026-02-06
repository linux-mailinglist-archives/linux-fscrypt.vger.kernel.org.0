Return-Path: <linux-fscrypt+bounces-1108-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0E81CuA1hmlrLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1108-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:41:36 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AE598102219
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:41:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 415F3316D88B
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E351D43CED6;
	Fri,  6 Feb 2026 18:25:03 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD7A43C05E
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402303; cv=none; b=TmOy3Qt16qVPR4n02jPndgDW3TIQausJFnKS3v0HIJ+H5kIB4bcJTg6aZyIutelglvTbHiPZQhD8UzKSWVlxvgAfKIOc4pON3Q1J/BnpBFi9p/sEcPm8hdQFZYxq/NBc5OxZQfcZloGkcSaxgs0FdBmMr/y/+LMtAH+9Eo1pbHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402303; c=relaxed/simple;
	bh=blFKUpi3xvJKZR3+nYjzSJqvyUo+6IFCcloG9ZycAU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJ4iubZ2V9fReOIMDle1WfG4rowHj8gk7agQ+bFYcV6t4Hmivkh6sOjMxse+6GzXT6q1o1ffbHkZ9ZlHL/wPRL0+WlDqPXQMKwWKy0HHHLtQP1KzVuCWd2SdE/PZFZMosqKOvY0EM7NAbHXgyeccdtzfjP88Ew9BTRSZWiTC0uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1FD0F5BD2C;
	Fri,  6 Feb 2026 18:24:12 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E74633EA63;
	Fri,  6 Feb 2026 18:24:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WBf+N8sxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:11 +0000
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
Subject: [PATCH v6 28/43] btrfs: populate ordered_extent with the orig offset
Date: Fri,  6 Feb 2026 19:23:00 +0100
Message-ID: <20260206182336.1397715-29-neelx@suse.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1108-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.993];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,suse.com:mid,suse.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AE598102219
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

For extent encryption we have to use a logical block nr as input for the
IV.  For btrfs we're using the offset into the extent we're operating
on.  For most ordered extents this is the same as the file_offset,
however for prealloc and NOCOW we have to use the original offset.

Add this as an argument and plumb it through everywhere, this will be
used when setting up the bio.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/fe06053fe2973c424dd539fecfee8cc171bdd22d.1706116485.git.josef@toxicpanda.com/
 * Splitted the dio-related hunks from inode.c to direct-io.c as upstream
   refactored in the meantime.
 * Open-code orig_start to start - offset.
---
 fs/btrfs/direct-io.c    |  1 +
 fs/btrfs/inode.c        |  5 +++++
 fs/btrfs/ordered-data.c | 21 ++++++++++++++++++---
 fs/btrfs/ordered-data.h |  7 +++++++
 4 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index d3789109ca85..2d89ac05b1b3 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -155,6 +155,7 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 		file_extent->fscrypt_info = em->fscrypt_info;
 	}
 
+	file_extent->orig_offset = start - file_extent->offset;
 	ordered = btrfs_alloc_ordered_extent(inode, start, file_extent,
 					     (1U << type) |
 					     (1U << BTRFS_ORDERED_DIRECT));
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index de1989edffc1..b28e1b7497b8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1192,6 +1192,7 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 	}
 
 	file_extent.fscrypt_info = em->fscrypt_info;
+	file_extent.orig_offset = start;
 	ordered = btrfs_alloc_ordered_extent(inode, start, &file_extent,
 					     1U << BTRFS_ORDERED_COMPRESSED);
 	btrfs_free_extent_map(em);
@@ -1336,6 +1337,7 @@ static int cow_one_range(struct btrfs_inode *inode, struct folio *locked_folio,
 	}
 
 	file_extent.fscrypt_info = em->fscrypt_info;
+	file_extent.orig_offset = file_offset;
 	ordered = btrfs_alloc_ordered_extent(inode, file_offset, &file_extent,
 					     1U << BTRFS_ORDERED_REGULAR);
 	btrfs_free_extent_map(em);
@@ -2281,6 +2283,8 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 			cow_start = (u64)-1;
 		}
 
+		nocow_args.file_extent.orig_offset =
+			found_key.offset - nocow_args.file_extent.offset;
 		ret = nocow_one_range(inode, locked_folio, &cached_state,
 				      &nocow_args, cur_offset,
 				      extent_type == BTRFS_FILE_EXTENT_PREALLOC);
@@ -10218,6 +10222,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	}
 
 	file_extent.fscrypt_info = em->fscrypt_info;
+	file_extent.orig_offset = start - encoded->unencoded_offset;
 	ordered = btrfs_alloc_ordered_extent(inode, start, &file_extent,
 				       (1U << BTRFS_ORDERED_ENCODED) |
 				       (1U << BTRFS_ORDERED_COMPRESSED));
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 1b4d20a2f983..bb5477ce58db 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -146,7 +146,8 @@ static inline struct rb_node *ordered_tree_search(struct btrfs_inode *inode,
 }
 
 static struct btrfs_ordered_extent *alloc_ordered_extent(
-			struct btrfs_inode *inode, u64 file_offset, u64 num_bytes,
+			struct btrfs_inode *inode,
+			u64 file_offset, u64 orig_offset, u64 num_bytes,
 			u64 ram_bytes, u64 disk_bytenr, u64 disk_num_bytes,
 			u64 offset, unsigned long flags, int compress_type,
 			struct fscrypt_extent_info *fscrypt_info)
@@ -180,6 +181,7 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	}
 
 	entry->file_offset = file_offset;
+	entry->orig_offset = orig_offset;
 	entry->num_bytes = num_bytes;
 	entry->ram_bytes = ram_bytes;
 	entry->disk_bytenr = disk_bytenr;
@@ -268,6 +270,7 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
  *
  * @inode:           Inode that this extent is for.
  * @file_offset:     Logical offset in file where the extent starts.
+ * @orig_offset:     Logical offset of the original extent (PREALLOC or NOCOW)
  * @num_bytes:       Logical length of extent in file.
  * @ram_bytes:       Full length of unencoded data.
  * @disk_bytenr:     Offset of extent on disk.
@@ -305,6 +308,7 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 	 */
 	if (flags & ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC)))
 		entry = alloc_ordered_extent(inode, file_offset,
+					     file_extent->orig_offset,
 					     file_extent->num_bytes,
 					     file_extent->num_bytes,
 					     file_extent->disk_bytenr + file_extent->offset,
@@ -313,6 +317,7 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 					     file_extent->fscrypt_info);
 	else
 		entry = alloc_ordered_extent(inode, file_offset,
+					     file_extent->orig_offset,
 					     file_extent->num_bytes,
 					     file_extent->ram_bytes,
 					     file_extent->disk_bytenr,
@@ -1277,8 +1282,8 @@ struct btrfs_ordered_extent *btrfs_split_ordered_extent(
 	if (WARN_ON_ONCE(ordered->disk_num_bytes != ordered->num_bytes))
 		return ERR_PTR(-EINVAL);
 
-	new = alloc_ordered_extent(inode, file_offset, len, len, disk_bytenr, len, 0,
-				   flags, ordered->compress_type, ordered->fscrypt_info);
+	new = alloc_ordered_extent(inode, file_offset, ordered->orig_offset, len, len, disk_bytenr,
+				   len, 0, flags, ordered->compress_type, ordered->fscrypt_info);
 	if (IS_ERR(new))
 		return new;
 
@@ -1315,6 +1320,16 @@ struct btrfs_ordered_extent *btrfs_split_ordered_extent(
 	ordered->disk_num_bytes -= len;
 	ordered->ram_bytes -= len;
 
+	/*
+	 * ->orig_offset is the original offset of the original extent, which
+	 * for PREALLOC or NOCOW stays the same, but if we're a regular extent
+	 * that means this is a new extent and thus ->orig_offset must equal
+	 * ->file_offset.  This is only important for encryption as we only use
+	 * it for setting the offset for the bio encryption context.
+	 */
+	if (test_bit(BTRFS_ORDERED_REGULAR, &ordered->flags))
+		ordered->orig_offset = ordered->file_offset;
+
 	if (test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags)) {
 		ASSERT(ordered->bytes_left == 0);
 		new->bytes_left = 0;
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 51c795865fe6..58cc1713eb4d 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -99,6 +99,12 @@ struct btrfs_ordered_extent {
 	/* logical offset in the file */
 	u64 file_offset;
 
+	/*
+	 * The original logical offset of the extent, this is for NOCOW and
+	 * PREALLOC extents, otherwise it'll be the same as file_offset.
+	 */
+	u64 orig_offset;
+
 	/*
 	 * These fields directly correspond to the same fields in
 	 * btrfs_file_extent_item.
@@ -188,6 +194,7 @@ struct btrfs_file_extent {
 	u64 num_bytes;
 	u64 ram_bytes;
 	u64 offset;
+	u64 orig_offset;
 	struct fscrypt_extent_info *fscrypt_info;
 	u8 compression;
 };
-- 
2.51.0


