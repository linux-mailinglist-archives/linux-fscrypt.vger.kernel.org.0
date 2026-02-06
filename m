Return-Path: <linux-fscrypt+bounces-1111-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EEZXApQ1hmlrLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1111-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:40:20 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5457C1021AE
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7883D3031D52
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7046E44A70E;
	Fri,  6 Feb 2026 18:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dOl9FZg0";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dOl9FZg0"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F65744A70A
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402311; cv=none; b=DkBMOwPeSSwobHtXNnPIDkFPfiHsT/3J7wvQJ0OCzFDsoWjUmVDy2NGh0FqDA9C8W47XflfYrYUvk2kJ3IYLePJXxWBvmZC6jTHMheyMs0ZDLwg44qN+rgao2pVQsdzBHMZJ3GnR2zVTUJ/aRs3XFUWQTWIWLttiahl2USSXgCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402311; c=relaxed/simple;
	bh=01Qr6eo0ySyzsJAE+aRqlzlEGMAUXrRO3vLfBmO34jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eryBg8zeN/lU00+/fZ7X+vc1f9dnKQJq4ycMxLW23tu/rZhkCcis3uD4uWGPZMh4IHe1muJAXV/LrEk2ik3YdacKHc/V7W9ak1JhQnM0CdKfciJdrzqBWFbm8tye5Tw4sH8mpMpz7VHTJVIfxugBGkCOcjXdvjdmnKkPM9e5Pew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dOl9FZg0; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dOl9FZg0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3434A3E757;
	Fri,  6 Feb 2026 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402254; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TlRycN/r/hzMtCufsix9uWAe9WmB5Kqoq1qghJz4TLY=;
	b=dOl9FZg0+Rg6TRLur29O2zhigULec92c2Ovjjr/QRjk/Zpjctzpt2pAqv52mMGFA1PRE3H
	2+EQrhMVOazJYnfkZTmglTQPYYDbEzj2a0RVAT5FtlCy+hOyFRMDhRKwXpFF2y2L2oS5On
	I+DtK93/qbZs19kDxFr1TGlgQFiEWW4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402254; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TlRycN/r/hzMtCufsix9uWAe9WmB5Kqoq1qghJz4TLY=;
	b=dOl9FZg0+Rg6TRLur29O2zhigULec92c2Ovjjr/QRjk/Zpjctzpt2pAqv52mMGFA1PRE3H
	2+EQrhMVOazJYnfkZTmglTQPYYDbEzj2a0RVAT5FtlCy+hOyFRMDhRKwXpFF2y2L2oS5On
	I+DtK93/qbZs19kDxFr1TGlgQFiEWW4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0771C3EA63;
	Fri,  6 Feb 2026 18:24:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WOFWAc4xhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:14 +0000
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
Subject: [PATCH v6 31/43] btrfs: limit encrypted writes to 256 segments
Date: Fri,  6 Feb 2026 19:23:03 +0100
Message-ID: <20260206182336.1397715-32-neelx@suse.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1111-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid,toxicpanda.com:email]
X-Rspamd-Queue-Id: 5457C1021AE
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
index 487dd9267fd7..1ae81997fb2d 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -14,6 +14,7 @@
 #include "zoned.h"
 #include "file-item.h"
 #include "raid-stripe-tree.h"
+#include "fscrypt.h"
 
 static struct bio_set btrfs_bioset;
 static struct bio_set btrfs_clone_bioset;
@@ -751,6 +752,7 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 	u64 logical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
 	u64 length = bio->bi_iter.bi_size;
 	u64 map_length = length;
+	u64 max_bio_len = length;
 	struct btrfs_io_context *bioc = NULL;
 	struct btrfs_io_stripe smap;
 	blk_status_t status;
@@ -762,6 +764,31 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
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
@@ -780,7 +807,7 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 
 	bbio->can_use_append = btrfs_use_zone_append(bbio);
 
-	map_length = min(map_length, length);
+	map_length = min(map_length, max_bio_len);
 	if (bbio->can_use_append)
 		map_length = btrfs_append_map_length(bbio, map_length);
 
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index f4d6979a581b..b6350b043994 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -328,6 +328,30 @@ bool btrfs_mergeable_encrypted_bio(struct bio *bio, struct inode *inode,
 	return fscrypt_mergeable_extent_bio(bio, fi, logical_offset);
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
index 1a2a4ffee383..347b34f45715 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -31,6 +31,7 @@ void btrfs_set_bio_crypt_ctx_from_extent(struct bio *bio,
 bool btrfs_mergeable_encrypted_bio(struct bio *bio, struct inode *inode,
 				   struct fscrypt_extent_info *fi,
 				   u64 logical_offset);
+int btrfs_fscrypt_bio_length(struct bio *bio, u64 map_length);
 
 #else
 static inline void btrfs_fscrypt_save_extent_info(struct btrfs_path *path,
@@ -85,6 +86,11 @@ static inline bool btrfs_mergeable_encrypted_bio(struct bio *bio,
 	return true;
 }
 
+static inline u64 btrfs_fscrypt_bio_length(struct bio *bio, u64 map_length)
+{
+	return map_length;
+}
+
 #endif /* CONFIG_FS_ENCRYPTION */
 
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
-- 
2.51.0


