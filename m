Return-Path: <linux-fscrypt+bounces-1095-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EId3KGUzhmneKQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1095-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:31:01 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F2450101E5F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:31:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 39B243058BA6
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B795643E49D;
	Fri,  6 Feb 2026 18:24:36 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695C443E49E
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402276; cv=none; b=riep3lGN3CYUW/apokAsRtDFgpF6xAb0BK5dvpXSeGOlPX+oPSF7dlx7lW67K1NX0zTsA0BTz/f132pH+YURClni1zSvBkVtpzS/niZ5k6Epzi4nLarFVIj1l3kOk7cBqOovEroSN1gFCBW1DOEhPGmr0BuQBpZl322CulT9krs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402276; c=relaxed/simple;
	bh=gvoi/0nQGPPiJP3k8zgHGQ32lRhLX5hgreRW21At+Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKI+SSF8wdYuDJCDT9U14U2ylw+kWOqNZRQ2A+y7fpEFnn2k0wQ60FGsxFz5FhJBtYOgsRDg+bB9uVpkJe3zaPE3o3r5sZKRpAxmCrsEcUszYs1NycA5tW3T24UN11jWWgDFuQ2fJgNkj/ctWTKeyqrrd+vCaBEq5xzD5fY8TZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 98D793E742;
	Fri,  6 Feb 2026 18:24:06 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 69C773EA63;
	Fri,  6 Feb 2026 18:24:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KPpVGcYxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:06 +0000
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
	linux-kernel@vger.kernel.org,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v6 19/43] btrfs: add fscrypt_info and encryption_type to extent_map
Date: Fri,  6 Feb 2026 19:22:51 +0100
Message-ID: <20260206182336.1397715-20-neelx@suse.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1095-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.993];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,dorminy.me:email,toxicpanda.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F2450101E5F
X-Rspamd-Action: no action

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Each extent_map will end up with a pointer to its associated
fscrypt_info if any, which should have the same lifetime as the
extent_map.  We are also going to need to track the encryption_type
for the file extent items.  Add the fscrypt_info to the extent_map and
the subsequent code for transferring it in the split and merge cases
as well as the code necessary to free them.  A future patch will add
the code to load them as appropriate.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/9818cd4134d048d2d641b9b8ae10be6c6af51956.1706116485.git.josef@toxicpanda.com/
 * No significant changes since. Just add some btrfs_ prefixes even
   to static functions in extent map header file to match the style.
---
 fs/btrfs/extent_map.c | 32 +++++++++++++++++++++++++++++---
 fs/btrfs/extent_map.h | 16 ++++++++++++++++
 fs/btrfs/file-item.c  |  1 +
 fs/btrfs/inode.c      |  1 +
 4 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 58589fc11802..f6b58a5c1151 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -59,6 +59,7 @@ struct extent_map *btrfs_alloc_extent_map(void)
 
 static void free_extent_map(struct extent_map *em)
 {
+	fscrypt_put_extent_info(em->fscrypt_info);
 	kmem_cache_free(extent_map_cache, em);
 }
 
@@ -99,12 +100,24 @@ void btrfs_free_extent_map_safe(struct extent_map_tree *tree,
 	if (!em)
 		return;
 
-	if (refcount_dec_and_test(&em->refs)) {
-		WARN_ON(btrfs_extent_map_in_tree(em));
-		WARN_ON(!list_empty(&em->list));
+	if (!refcount_dec_and_test(&em->refs))
+		return;
+
+	WARN_ON(btrfs_extent_map_in_tree(em));
+	WARN_ON(!list_empty(&em->list));
+
+	/*
+	 * We could take a lock freeing the fscrypt_info, so add this to the
+	 * list of freed_extents to be freed later.
+	 */
+	if (em->fscrypt_info) {
 		list_add_tail(&em->free_list, &tree->freed_extents);
 		set_bit(EXTENT_MAP_TREE_PENDING_FREES, &tree->flags);
+		return;
 	}
+
+	/* Nothing scary here, just free the object. */
+	free_extent_map(em);
 }
 
 /*
@@ -291,6 +304,10 @@ static bool can_merge_extent_map(const struct extent_map *em)
 	if (!list_empty(&em->list))
 		return false;
 
+	/* We can't merge encrypted extents. */
+	if (em->fscrypt_info)
+		return false;
+
 	return true;
 }
 
@@ -311,6 +328,10 @@ static bool mergeable_maps(const struct extent_map *prev, const struct extent_ma
 	if (next->disk_bytenr < EXTENT_MAP_LAST_BYTE - 1)
 		return btrfs_extent_map_block_start(next) == extent_map_block_end(prev);
 
+	/* Don't merge adjacent encrypted maps. */
+	if (prev->fscrypt_info || next->fscrypt_info)
+		return false;
+
 	/* HOLES and INLINE extents. */
 	return next->disk_bytenr == prev->disk_bytenr;
 }
@@ -977,6 +998,7 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 
 			split->generation = gen;
 			split->flags = flags;
+			split->fscrypt_info = fscrypt_get_extent_info(em->fscrypt_info);
 			replace_extent_mapping(inode, em, split, modified);
 			btrfs_free_extent_map(split);
 			split = split2;
@@ -1005,6 +1027,7 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 				split->ram_bytes = split->len;
 			}
 
+			split->fscrypt_info = fscrypt_get_extent_info(em->fscrypt_info);
 			if (btrfs_extent_map_in_tree(em)) {
 				replace_extent_mapping(inode, em, split, modified);
 			} else {
@@ -1163,6 +1186,7 @@ int btrfs_split_extent_map(struct btrfs_inode *inode, u64 start, u64 len, u64 pr
 	split_pre->ram_bytes = split_pre->len;
 	split_pre->flags = flags;
 	split_pre->generation = em->generation;
+	split_pre->fscrypt_info = fscrypt_get_extent_info(em->fscrypt_info);
 
 	replace_extent_mapping(inode, em, split_pre, true);
 
@@ -1180,6 +1204,8 @@ int btrfs_split_extent_map(struct btrfs_inode *inode, u64 start, u64 len, u64 pr
 	split_mid->ram_bytes = split_mid->len;
 	split_mid->flags = flags;
 	split_mid->generation = em->generation;
+	split_mid->fscrypt_info = fscrypt_get_extent_info(em->fscrypt_info);
+
 	add_extent_mapping(inode, split_mid, true);
 
 	/* Once for us */
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index a962012be1c3..a0d5be758e7e 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -24,6 +24,7 @@ enum {
 	ENUM_BIT(EXTENT_FLAG_COMPRESS_ZLIB),
 	ENUM_BIT(EXTENT_FLAG_COMPRESS_LZO),
 	ENUM_BIT(EXTENT_FLAG_COMPRESS_ZSTD),
+	ENUM_BIT(EXTENT_FLAG_ENCRYPT_FSCRYPT),
 	/* pre-allocated extent */
 	ENUM_BIT(EXTENT_FLAG_PREALLOC),
 	/* Logging this extent */
@@ -96,6 +97,7 @@ struct extent_map {
 	u64 generation;
 	u32 flags;
 	refcount_t refs;
+	struct fscrypt_extent_info *fscrypt_info;
 	struct list_head list;
 	struct list_head free_list;
 };
@@ -114,6 +116,20 @@ struct extent_map_tree {
 
 struct btrfs_inode;
 
+static inline void btrfs_extent_map_set_encryption(struct extent_map *em,
+					     enum btrfs_encryption_type type)
+{
+	if (type == BTRFS_ENCRYPTION_FSCRYPT)
+		em->flags |= EXTENT_FLAG_ENCRYPT_FSCRYPT;
+}
+
+static inline enum btrfs_encryption_type btrfs_extent_map_encryption(const struct extent_map *em)
+{
+	if (em->flags & EXTENT_FLAG_ENCRYPT_FSCRYPT)
+		return BTRFS_ENCRYPTION_FSCRYPT;
+	return BTRFS_ENCRYPTION_NONE;
+}
+
 static inline void btrfs_extent_map_set_compression(struct extent_map *em,
 						    enum btrfs_compression_type type)
 {
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 7bd715442f3e..08dc78295707 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -1357,6 +1357,7 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 			if (type == BTRFS_FILE_EXTENT_PREALLOC)
 				em->flags |= EXTENT_FLAG_PREALLOC;
 		}
+		btrfs_extent_map_set_encryption(em, btrfs_file_extent_encryption(leaf, fi));
 	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
 		/* Tree-checker has ensured this. */
 		ASSERT(extent_start == 0);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 758dde148be6..b425047f77c7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7580,6 +7580,7 @@ struct extent_map *btrfs_create_io_em(struct btrfs_inode *inode, u64 start,
 	em->flags |= EXTENT_FLAG_PINNED;
 	if (type == BTRFS_ORDERED_COMPRESSED)
 		btrfs_extent_map_set_compression(em, file_extent->compression);
+	btrfs_extent_map_set_encryption(em, BTRFS_ENCRYPTION_NONE);
 
 	ret = btrfs_replace_extent_map_range(inode, em, true);
 	if (ret) {
-- 
2.51.0


