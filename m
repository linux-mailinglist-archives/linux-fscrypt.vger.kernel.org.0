Return-Path: <linux-fscrypt+bounces-1100-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2KbdG5szhmneKQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1100-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:31:55 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CBA9101EA6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:31:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DAA753047922
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E05484418CA;
	Fri,  6 Feb 2026 18:24:44 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951644418CC
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402284; cv=none; b=bgSDQQsAXeILA85lXYURRtCt2S+9kJCW2yaBR9CPA/ij/TG94ABR20oabo7viD7jrMXVZcwznTda21Ynv2iLxKooVXukHO/xfw59PLlXIiPqyB1sCMT8DHlmxZlTO36iFAQcsKEDVLYg3MvLsdKWjHO3XfxzFX32KNBQM8a5HeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402284; c=relaxed/simple;
	bh=4gsIL/puGcm2Z7MT/G9xezZ4P8I3WruwNiNQf72J8HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXkyLla2YchLpG8SoVTR88NAoDqWSJFnFWo5RlFhxuFUtiisg62/THMPmSKg6GyXsq6JyDfBWf8LeP+3EqrZI2UofjE9UKFbEFqJtquA9ggy2d7PGRELzzLG1pp3H54pU0MEHFwC/3SuuIryKfIGHHj4y3rquh1ewkGt/N8U7PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 525F23E758;
	Fri,  6 Feb 2026 18:24:08 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 24AF53EA63;
	Fri,  6 Feb 2026 18:24:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IBhWCMgxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:08 +0000
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
Subject: [PATCH v6 22/43] btrfs: populate the ordered_extent with the fscrypt context
Date: Fri,  6 Feb 2026 19:22:54 +0100
Message-ID: <20260206182336.1397715-23-neelx@suse.com>
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
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Spam-Flag: NO
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
	TAGGED_FROM(0.00)[bounces-1100-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,toxicpanda.com:email,suse.com:mid,suse.com:email]
X-Rspamd-Queue-Id: 7CBA9101EA6
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

The fscrypt_extent_info will be tied to the extent_map lifetime, so it
will be created when we create the IO em, or it'll already exist in the
NOCOW case.  Use this fscrypt_info when creating the ordered extent to
make sure everything is passed through properly.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/33e650f3e91ed0318211301beb27fa613382f28e.1706116485.git.josef@toxicpanda.com/
 * Splitted the dio-related hunks from inode.c to direct-io.c as upstream
   refactored in the meantime.
 * Pass fscrypt_info using the file_extent structure to follow the
   upstream cleanup.
---
 fs/btrfs/direct-io.c |  4 +++-
 fs/btrfs/inode.c     | 36 ++++++++++++++++++++++++++++++------
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index f3efc451d9a5..c95b4e768043 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -140,7 +140,7 @@ static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
 static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 						  struct btrfs_dio_data *dio_data,
 						  const u64 start,
-						  const struct btrfs_file_extent *file_extent,
+						  struct btrfs_file_extent *file_extent,
 						  const int type)
 {
 	struct extent_map *em = NULL;
@@ -150,6 +150,7 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 		em = btrfs_create_io_em(inode, start, file_extent, type);
 		if (IS_ERR(em))
 			goto out;
+		file_extent->fscrypt_info = em->fscrypt_info;
 	}
 
 	ordered = btrfs_alloc_ordered_extent(inode, start, file_extent,
@@ -276,6 +277,7 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 		}
 		space_reserved = true;
 
+		file_extent.fscrypt_info = em->fscrypt_info;
 		em2 = btrfs_create_dio_extent(BTRFS_I(inode), dio_data, start,
 					      &file_extent, type);
 		btrfs_dec_nocow_writers(bg);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index aef95d6e02bf..f81bdb97b212 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1190,10 +1190,11 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 		ret = PTR_ERR(em);
 		goto out_free_reserve;
 	}
-	btrfs_free_extent_map(em);
 
+	file_extent.fscrypt_info = em->fscrypt_info;
 	ordered = btrfs_alloc_ordered_extent(inode, start, &file_extent,
 					     1U << BTRFS_ORDERED_COMPRESSED);
+	btrfs_free_extent_map(em);
 	if (IS_ERR(ordered)) {
 		btrfs_drop_extent_map_range(inode, start, end, false);
 		ret = PTR_ERR(ordered);
@@ -1333,10 +1334,11 @@ static int cow_one_range(struct btrfs_inode *inode, struct folio *locked_folio,
 		ret = PTR_ERR(em);
 		goto free_reserved;
 	}
-	btrfs_free_extent_map(em);
 
+	file_extent.fscrypt_info = em->fscrypt_info;
 	ordered = btrfs_alloc_ordered_extent(inode, file_offset, &file_extent,
 					     1U << BTRFS_ORDERED_REGULAR);
+	btrfs_free_extent_map(em);
 	if (IS_ERR(ordered)) {
 		btrfs_drop_extent_map_range(inode, file_offset, cur_end, false);
 		ret = PTR_ERR(ordered);
@@ -2006,18 +2008,32 @@ static int nocow_one_range(struct btrfs_inode *inode, struct folio *locked_folio
 			   u64 file_pos, bool is_prealloc)
 {
 	struct btrfs_ordered_extent *ordered;
+	struct extent_map *em;
 	const u64 len = nocow_args->file_extent.num_bytes;
 	const u64 end = file_pos + len - 1;
 	int ret = 0;
 
 	btrfs_lock_extent(&inode->io_tree, file_pos, end, cached);
 
-	if (is_prealloc) {
-		struct extent_map *em;
+	/*
+	 * We only want to do this lookup if we're encrypted, otherwise
+	 * fsrypt_info will be null and we can avoid this lookup.
+	 */
+	if (IS_ENCRYPTED(&inode->vfs_inode)) {
+		em = btrfs_get_extent(inode, NULL, file_pos, len);
+		if (IS_ERR(em)) {
+			btrfs_unlock_extent(&inode->io_tree, file_pos, end, cached);
+			return PTR_ERR(em);
+		}
+		nocow_args->file_extent.fscrypt_info = fscrypt_get_extent_info(em->fscrypt_info);
+		btrfs_free_extent_map(em);
+	}
 
+	if (is_prealloc) {
 		em = btrfs_create_io_em(inode, file_pos, &nocow_args->file_extent,
 					BTRFS_ORDERED_PREALLOC);
 		if (IS_ERR(em)) {
+			fscrypt_put_extent_info(nocow_args->file_extent.fscrypt_info);
 			ret = PTR_ERR(em);
 			goto error;
 		}
@@ -2028,6 +2044,7 @@ static int nocow_one_range(struct btrfs_inode *inode, struct folio *locked_folio
 					     is_prealloc
 					     ? (1U << BTRFS_ORDERED_PREALLOC)
 					     : (1U << BTRFS_ORDERED_NOCOW));
+	fscrypt_put_extent_info(nocow_args->file_extent.fscrypt_info);
 	if (IS_ERR(ordered)) {
 		if (is_prealloc)
 			btrfs_drop_extent_map_range(inode, file_pos, end, false);
@@ -7582,7 +7599,13 @@ struct extent_map *btrfs_create_io_em(struct btrfs_inode *inode, u64 start,
 	em->flags |= EXTENT_FLAG_PINNED;
 	if (type == BTRFS_ORDERED_COMPRESSED)
 		btrfs_extent_map_set_compression(em, file_extent->compression);
-	btrfs_extent_map_set_encryption(em, BTRFS_ENCRYPTION_NONE);
+
+	if (file_extent->fscrypt_info) {
+		btrfs_extent_map_set_encryption(em, BTRFS_ENCRYPTION_FSCRYPT);
+		em->fscrypt_info = fscrypt_get_extent_info(file_extent->fscrypt_info);
+	} else {
+		btrfs_extent_map_set_encryption(em, BTRFS_ENCRYPTION_NONE);
+	}
 
 	ret = btrfs_replace_extent_map_range(inode, em, true);
 	if (ret) {
@@ -10125,11 +10148,12 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 		ret = PTR_ERR(em);
 		goto out_free_reserved;
 	}
-	btrfs_free_extent_map(em);
 
+	file_extent.fscrypt_info = em->fscrypt_info;
 	ordered = btrfs_alloc_ordered_extent(inode, start, &file_extent,
 				       (1U << BTRFS_ORDERED_ENCODED) |
 				       (1U << BTRFS_ORDERED_COMPRESSED));
+	btrfs_free_extent_map(em);
 	if (IS_ERR(ordered)) {
 		btrfs_drop_extent_map_range(inode, start, end, false);
 		ret = PTR_ERR(ordered);
-- 
2.51.0


