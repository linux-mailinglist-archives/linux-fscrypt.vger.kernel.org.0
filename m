Return-Path: <linux-fscrypt+bounces-1590-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sGQzEm8/BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1590-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:07:59 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D67AF5303EF
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:07:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4E04A31A0D5B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 09:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3433D41B35A;
	Wed, 13 May 2026 08:56:14 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6076F413230
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662574; cv=none; b=Loe0ldCWclCUGWJZ8re82q5gW1bx8JS4nWDtKEJs72nZJb5CLf8ApOEhCEfSoujFy/0cRIivSrDQGBKbR4jDYU154k25jpUWw0ntVw+gmGcUVTLINMXxS/qHllxbwQF5kU+EiFfUFwkNA1r+cuMA9w3ypFnXHasoBYvqwyvpfaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662574; c=relaxed/simple;
	bh=FDHSS6CDvUObpNaUqXB2m/lypPYHQMWBEyjtO6g1yos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1676fympR4EQEPYBNfj1j60qymEyv7z6kXf3sE4ieVp7NR7GvtxZKPQAaCHz1tAnEv7zFqMsZbuB5e5Ip4S70kagUDiEH8Qs1HRVNNrErfu6DS1DTzd21MdGZHQ7lSg7gUrzSHv0fh5DuSU3p6yYb88ayPXLeOQDs4sQWB9tYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 133A176647;
	Wed, 13 May 2026 08:54:40 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E4898593A9;
	Wed, 13 May 2026 08:54:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8PRRN088BGpERwAAD6G6ig
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
Subject: [PATCH v7 31/43] btrfs: limit encrypted writes to 256 segments
Date: Wed, 13 May 2026 10:53:05 +0200
Message-ID: <20260513085340.3673127-32-neelx@suse.com>
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
X-Rspamd-Queue-Id: D67AF5303EF
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
	TAGGED_FROM(0.00)[bounces-1590-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,toxicpanda.com:email,suse.com:email,suse.com:mid]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

For the fallback encrypted writes it allocates a bounce buffer to
encrypt, and if the bio is larger than 256 segments it splits the bio we
send down.  This wreaks havoc on us because we need our actual original
bio to be passed into the process_cb callback in order to get at our
ordered extent.  With the split we'll get some cloned bio that has none
of our information.  Handle this by returning the length we need to be
truncated to and then splitting ourselves, which will handle giving us
the correct btrfs_bio that we need.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/1fc07b885453495bccea5a37e13d7d26333bd2af.1706116485.git.josef@toxicpanda.com/
 * No changes since.
---
 fs/btrfs/bio.c     | 29 ++++++++++++++++++++++++++++-
 fs/btrfs/fscrypt.c | 24 ++++++++++++++++++++++++
 fs/btrfs/fscrypt.h |  6 ++++++
 3 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index b79fc467445d..3e2ee19aab50 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -15,6 +15,7 @@
 #include "zoned.h"
 #include "file-item.h"
 #include "raid-stripe-tree.h"
+#include "fscrypt.h"
 
 static struct bio_set btrfs_bioset;
 static struct bio_set btrfs_clone_bioset;
@@ -759,6 +760,7 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	u64 logical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
 	u64 length = bio->bi_iter.bi_size;
 	u64 map_length = length;
+	u64 max_bio_len = length;
 	struct btrfs_io_context *bioc = NULL;
 	struct btrfs_io_stripe smap;
 	blk_status_t status;
@@ -770,6 +772,31 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 		smap.rst_search_commit_root = false;
 
 	btrfs_bio_counter_inc_blocked(fs_info);
+
+	/*
+	 * The blk-crypto-fallback limits bio sizes to 256 segments, because it
+	 * has no way of controlling the pages it gets for the bounce bio it
+	 * submits.
+	 *
+	 * If we don't pre-split our bio blk-crypto-fallback will do it for us,
+	 * and then call into our checksum callback with a random cloned bio
+	 * that isn't a btrfs_bio.
+	 *
+	 * To account for this we must truncate the bio ourselves, so we need to
+	 * get our length at 256 segments and return that.  We must do this
+	 * before btrfs_map_block because the RAID5/6 code relies on having
+	 * properly stripe aligned things, so we return the truncated length
+	 * here so that btrfs_map_block() does the correct thing.  Further down
+	 * we actually truncate map_length to map_bio_len because map_length
+	 * will be set to whatever the mapping length is for the underlying
+	 * geometry.  This will work properly with RAID5/6 as it will have
+	 * already setup everything for the expected length, and everything else
+	 * can handle with a truncated map_length.
+	 */
+	if (bio_has_crypt_ctx(bio))
+		max_bio_len = btrfs_fscrypt_bio_length(bio, map_length);
+
+	map_length = max_bio_len;
 	ret = btrfs_map_block(fs_info, btrfs_op(bio), logical, &map_length,
 			      &bioc, &smap, &mirror_num);
 	if (ret) {
@@ -788,7 +815,7 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 
 	bbio->can_use_append = btrfs_use_zone_append(bbio);
 
-	map_length = min(map_length, length);
+	map_length = min(map_length, max_bio_len);
 	if (bbio->can_use_append)
 		map_length = btrfs_append_map_length(bbio, map_length);
 
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 5d4802fce7eb..5d34a8b94da5 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -295,6 +295,30 @@ ssize_t btrfs_fscrypt_context_for_new_extent(struct btrfs_inode *inode,
 	return ret;
 }
 
+/*
+ * The block crypto stuff allocates bounce buffers for encryption, so splits at
+ * BIO_MAX_VECS worth of segments.  If we are larger than that number of
+ * segments then we need to limit the size to the size that BIO_MAX_VECS covers.
+ */
+int btrfs_fscrypt_bio_length(struct bio *bio, u64 map_length)
+{
+	unsigned int i = 0;
+	struct bio_vec bv;
+	struct bvec_iter iter;
+	u64 segments_length = 0;
+
+	if (bio_op(bio) != REQ_OP_WRITE)
+		return map_length;
+
+	bio_for_each_segment(bv, bio, iter) {
+		segments_length += bv.bv_len;
+		if (++i == BIO_MAX_VECS)
+			return segments_length;
+	}
+
+	return map_length;
+}
+
 const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.inode_info_offs = (int)offsetof(struct btrfs_inode, i_crypt_info) -
 			   (int)offsetof(struct btrfs_inode, vfs_inode),
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 68eab4606935..f7ce2b2e6639 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -24,6 +24,7 @@ void btrfs_fscrypt_save_extent_info(struct btrfs_path *path, u8 *ctx, unsigned l
 ssize_t btrfs_fscrypt_context_for_new_extent(struct btrfs_inode *inode,
 					     struct fscrypt_extent_info *info,
 					     u8 *ctx);
+int btrfs_fscrypt_bio_length(struct bio *bio, u64 map_length);
 
 #else
 static inline void btrfs_fscrypt_save_extent_info(struct btrfs_path *path,
@@ -63,6 +64,11 @@ static inline ssize_t btrfs_fscrypt_context_for_new_extent(struct btrfs_inode *i
 	return -EINVAL;
 }
 
+static inline u64 btrfs_fscrypt_bio_length(struct bio *bio, u64 map_length)
+{
+	return map_length;
+}
+
 #endif /* CONFIG_FS_ENCRYPTION */
 
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
-- 
2.53.0


