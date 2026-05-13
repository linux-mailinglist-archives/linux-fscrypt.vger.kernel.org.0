Return-Path: <linux-fscrypt+bounces-1587-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sG+fGPxABGokGQIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1587-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:14:36 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA00C530663
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:14:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5A09230659D8
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 589C33EDABD;
	Wed, 13 May 2026 08:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pF2+6jP1";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FF1GjlC/"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B453E5EEF
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662564; cv=none; b=mQMyTv3jLhsoxEc0Tr4oW79bxyJpqEQhKIMZ9aKA0OWuzNI9T0E0aWwRWGVAlDbldLU26vNSOt79ucV7qq7Af1MkpHN8S/VzLNmG0Q+lJn0GiHUsbK+jgWOHRsu8aRa07Lmc6PdJ8LMKKlsITrfLD5g6AwfzkA72JlBgACHvko4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662564; c=relaxed/simple;
	bh=w/+BPTiqCtzjyMfttpKKHyLsc8u/NIqBqTBcooC6/0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKrHHzv6LBrHb1UllElgRD2MOXKWQQXLeIQ5PJv3u6SvsV5etpOQ5ko7RmFMliy4I+RurIV0nwLaxB1bVOGhXQ3pc5Rg5/X0hqqmZUt4Zs5zq/3BoJ9VlLOjdwCNZH6eJuhbU67euYD21ejqVpRZ5LT0L1dvHyQAeF64kPI0W/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pF2+6jP1; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FF1GjlC/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 79CBE5CE73;
	Wed, 13 May 2026 08:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J5M4XUrog3E7rsHm0HEqT5k/fF48anhlA9JIL4z3TPQ=;
	b=pF2+6jP11xsKw4hD/W/GAOpgLiG89zdGamDmQMgZ0i5ORFV4nYqxD+VeoPgpZt/34ath2y
	tQGb3knUla1DJeCYxQoCgxIYypXkZK+rgySlSxP634RArjdMjPfPI7YJhgimF8xMv3Asok
	tKXWKqiltuzylAlMKttScDGZYLgpFu0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662476; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J5M4XUrog3E7rsHm0HEqT5k/fF48anhlA9JIL4z3TPQ=;
	b=FF1GjlC/XVnmBheoR0xZZ1C/99iuxsgAFgRv/iZWY0z2XP4wSNgQYV7hzNoV7BtRgDfPa2
	f6GRQB+nct7bpORSwKGq7Hvt5A9MLBdmVXUeI9ZGS29WwhVYgPnWEQjkw0jiFijAAIULbe
	T0bZThzBRkn9R50D9WniziH2hk4Vl0c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52AE1593AB;
	Wed, 13 May 2026 08:54:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cG64E0w8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:36 +0000
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
Subject: [PATCH v7 26/43] btrfs: implement the fscrypt extent encryption hooks
Date: Wed, 13 May 2026 10:53:00 +0200
Message-ID: <20260513085340.3673127-27-neelx@suse.com>
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
X-Rspamd-Queue-Id: AA00C530663
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1587-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,suse.com:email,suse.com:mid,suse.com:dkim]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

This patch implements the necessary hooks from fscrypt to support
per-extent encryption.  There's two main entry points

btrfs_fscrypt_load_extent_info
btrfs_fscrypt_save_extent_info

btrfs_fscrypt_load_extent_info gets called when we create the extent
maps from the file extent item at btrfs_get_extent() time.  We read the
extent context, and pass it into fscrypt to create the appropriate
fscrypt_extent_info structure.  This is then used on the bio's to make
sure the encryption is done properly.

btrfs_fscrypt_save_extent_info is used to generate the fscrypt context
from fscrypt and save it into the tree item when we create a new
file extent item.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

No changes in v7.
v6 changes:
 * Significantly reworked due to the changes in previous commit [24/43].
v5: https://lore.kernel.org/linux-btrfs/30eaad31964c88c3497a0c5bc8f2c727c1dc763a.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/ctree.h    |  3 ++
 fs/btrfs/defrag.c   |  6 ++++
 fs/btrfs/file.c     | 11 ++++++
 fs/btrfs/fscrypt.c  | 84 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/fscrypt.h  | 29 ++++++++++++++++
 fs/btrfs/inode.c    | 36 +++++++++++++++++++
 fs/btrfs/reflink.c  | 43 ++++++++++++++++++++++-
 fs/btrfs/tree-log.c | 19 ++++++++++
 8 files changed, 230 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6de7ad191e04..89d3c3137786 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -400,6 +400,9 @@ struct btrfs_replace_extent_info {
 	u64 file_offset;
 	/* Pointer to a file extent item of type regular or prealloc. */
 	char *extent_buf;
+	/* The fscrypt_extent_info for a new extent. */
+	u8 *fscrypt_ctx;
+	u32 fscrypt_context_size;
 	/*
 	 * Set to true when attempting to replace a file range with a new extent
 	 * described by this structure, set to false when attempting to clone an
diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 7e2db5d3a4d4..a828ec45bb5f 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -16,6 +16,7 @@
 #include "file-item.h"
 #include "super.h"
 #include "compression.h"
+#include "fscrypt.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
 
@@ -720,6 +721,11 @@ static struct extent_map *defrag_get_extent(struct btrfs_inode *inode,
 		if (ret > 0)
 			goto not_found;
 	}
+	btrfs_release_path(&path);
+
+	ret = btrfs_fscrypt_load_extent_info(inode, &path, &key, em);
+	if (ret)
+		goto err;
 	return em;
 
 not_found:
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fe7baecbf83b..b845556d2100 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -38,6 +38,7 @@
 #include "file.h"
 #include "super.h"
 #include "print-tree.h"
+#include "fscrypt.h"
 
 /*
  * Unlock folio after btrfs_file_write() is done with it.
@@ -2406,6 +2407,16 @@ static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
 	if (extent_info->is_new_extent)
 		btrfs_set_file_extent_generation(leaf, extent, trans->transid);
 	btrfs_release_path(path);
+	if (extent_info->fscrypt_context_size) {
+		key.type = BTRFS_FSCRYPT_CTX_KEY;
+		ret = btrfs_insert_empty_item(trans, root, path, &key,
+					      extent_info->fscrypt_context_size);
+		if (ret)
+			return ret;
+		btrfs_fscrypt_save_extent_info(path,
+					       extent_info->fscrypt_ctx,
+					       extent_info->fscrypt_context_size);
+	}
 
 	ret = btrfs_inode_set_file_extent_range(inode, extent_info->file_offset,
 						replace_len);
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 1d29cfa7037c..5d4802fce7eb 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -212,9 +212,93 @@ static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
 	return devs;
 }
 
+int btrfs_fscrypt_load_extent_info(struct btrfs_inode *inode,
+				   struct btrfs_path *path,
+				   struct btrfs_key *key,
+				   struct extent_map *em)
+{
+	struct extent_buffer *leaf;
+	int slot;
+	unsigned long offset;
+	u8 ctx[BTRFS_MAX_EXTENT_CTX_SIZE];
+	unsigned long size;
+	struct fscrypt_extent_info *info;
+	unsigned long nofs_flag;
+	int ret;
+
+	if (em->disk_bytenr == EXTENT_MAP_HOLE)
+		return 0;
+	if (btrfs_extent_map_encryption(em) != BTRFS_ENCRYPTION_FSCRYPT)
+		return 0;
+
+	key->type = BTRFS_FSCRYPT_CTX_KEY;
+	ret = btrfs_search_slot(NULL, inode->root, key, path, 0, 0);
+	leaf = path->nodes[0];
+	slot = path->slots[0];
+	if (ret) {
+		btrfs_err(leaf->fs_info,
+	"missing or error searching encryption context item in leaf: root=%llu block=%llu slot=%d ino=%llu file_offset=%llu, err %i",
+			  btrfs_header_owner(leaf), btrfs_header_bytenr(leaf), slot,
+			  key->objectid, key->offset, ret);
+		btrfs_release_path(path);
+		return ret;
+	}
+
+	size = btrfs_item_size(leaf, slot);
+	if (size > FSCRYPT_SET_CONTEXT_MAX_SIZE) {
+		btrfs_err(leaf->fs_info,
+	"unexpected or corrupted encryption context size in leaf: root=%llu block=%llu slot=%d ino=%llu file_offset=%llu, size %lu (too big)",
+			  btrfs_header_owner(leaf), btrfs_header_bytenr(leaf), slot,
+			  key->objectid, key->offset, size);
+		btrfs_release_path(path);
+		return -EIO;
+	}
+
+	offset = btrfs_item_ptr_offset(leaf, slot),
+	read_extent_buffer(leaf, ctx, offset, size);
+	btrfs_release_path(path);
+
+	nofs_flag = memalloc_nofs_save();
+	info = fscrypt_load_extent_info(&inode->vfs_inode, ctx, size);
+	memalloc_nofs_restore(nofs_flag);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+	em->fscrypt_info = info;
+	return 0;
+}
+
+void btrfs_fscrypt_save_extent_info(struct btrfs_path *path, u8 *ctx, unsigned long size)
+{
+	struct extent_buffer *leaf = path->nodes[0];
+	unsigned long offset = btrfs_item_ptr_offset(leaf, path->slots[0]);
+
+	ASSERT(size <= FSCRYPT_SET_CONTEXT_MAX_SIZE);
+
+	write_extent_buffer(leaf, ctx, offset, size);
+	btrfs_release_path(path);
+}
+
+ssize_t btrfs_fscrypt_context_for_new_extent(struct btrfs_inode *inode,
+					     struct fscrypt_extent_info *info,
+					     u8 *ctx)
+{
+	ssize_t ret;
+
+	if (!info)
+		return 0;
+
+	ret = fscrypt_context_for_new_extent(&inode->vfs_inode, info, ctx);
+	if (ret < 0) {
+		btrfs_err_rl(inode->root->fs_info, "invalid encrypt context");
+		return ret;
+	}
+	return ret;
+}
+
 const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.inode_info_offs = (int)offsetof(struct btrfs_inode, i_crypt_info) -
 			   (int)offsetof(struct btrfs_inode, vfs_inode),
+	.has_per_extent_encryption = 1,
 	.get_context = btrfs_fscrypt_get_context,
 	.set_context = btrfs_fscrypt_set_context,
 	.empty_dir = btrfs_fscrypt_empty_dir,
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index c5cdc27f943c..68eab4606935 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -16,8 +16,27 @@ int btrfs_fscrypt_get_disk_name(struct extent_buffer *leaf,
 bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 			      struct extent_buffer *leaf,
 			      unsigned long de_name, u32 de_name_len);
+int btrfs_fscrypt_load_extent_info(struct btrfs_inode *inode,
+				   struct btrfs_path *path,
+				   struct btrfs_key *key,
+				   struct extent_map *em);
+void btrfs_fscrypt_save_extent_info(struct btrfs_path *path, u8 *ctx, unsigned long size);
+ssize_t btrfs_fscrypt_context_for_new_extent(struct btrfs_inode *inode,
+					     struct fscrypt_extent_info *info,
+					     u8 *ctx);
 
 #else
+static inline void btrfs_fscrypt_save_extent_info(struct btrfs_path *path,
+						  u8 *ctx, unsigned long size) { }
+
+static inline int btrfs_fscrypt_load_extent_info(struct btrfs_inode *inode,
+						 struct btrfs_path *path,
+						 struct btrfs_key *key,
+						 struct extent_map *em)
+{
+	return 0;
+}
+
 static inline int btrfs_fscrypt_get_disk_name(struct extent_buffer *leaf,
 					      struct btrfs_dir_item *di,
 					      struct fscrypt_str *qstr)
@@ -34,6 +53,16 @@ static inline bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 		return false;
 	return !memcmp_extent_buffer(leaf, fname->disk_name.name, de_name, de_name_len);
 }
+
+static inline ssize_t btrfs_fscrypt_context_for_new_extent(struct btrfs_inode *inode,
+							   struct fscrypt_extent_info *info,
+							   u8 *ctx)
+{
+	if (!info)
+		return 0;
+	return -EINVAL;
+}
+
 #endif /* CONFIG_FS_ENCRYPTION */
 
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cdd2d7bc50cc..a78a7206a291 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3074,8 +3074,16 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	u64 num_bytes = btrfs_stack_file_extent_num_bytes(stack_fi);
 	u64 ram_bytes = btrfs_stack_file_extent_ram_bytes(stack_fi);
 	struct btrfs_drop_extents_args drop_args = { 0 };
+	u8 fscrypt_ctx[FSCRYPT_SET_CONTEXT_MAX_SIZE];
+	ssize_t fscrypt_context_size;
 	int ret;
 
+	fscrypt_context_size = btrfs_fscrypt_context_for_new_extent(inode,
+								    fscrypt_info,
+								    fscrypt_ctx);
+	if (fscrypt_context_size < 0)
+		return (int)fscrypt_context_size;
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -3116,6 +3124,16 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 
+	if (fscrypt_context_size) {
+		ins.objectid = btrfs_ino(inode);
+		ins.type = BTRFS_FSCRYPT_CTX_KEY;
+		ins.offset = file_pos;
+		ret = btrfs_insert_empty_item(trans, root, path, &ins, fscrypt_context_size);
+		if (ret)
+			return ret;
+		btrfs_fscrypt_save_extent_info(path, fscrypt_ctx, fscrypt_context_size);
+	}
+
 	/*
 	 * If we dropped an inline extent here, we know the range where it is
 	 * was not marked with the EXTENT_DELALLOC_NEW bit, so we update the
@@ -7481,6 +7499,12 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		goto out;
 	}
 
+	ret = btrfs_fscrypt_load_extent_info(inode, path, &found_key, em);
+	if (ret > 0)
+		ret = -EIO;
+	if (ret < 0)
+		goto out;
+
 	write_lock(&em_tree->lock);
 	ret = btrfs_add_extent_mapping(inode, &em, start, len);
 	write_unlock(&em_tree->lock);
@@ -9294,6 +9318,8 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 				       u64 file_offset)
 {
 	struct btrfs_file_extent_item stack_fi;
+	u8 fscrypt_ctx[FSCRYPT_SET_CONTEXT_MAX_SIZE];
+	ssize_t fscrypt_context_size;
 	struct btrfs_replace_extent_info extent_info;
 	struct btrfs_trans_handle *trans = trans_in;
 	struct btrfs_path *path;
@@ -9327,6 +9353,14 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 		return trans;
 	}
 
+	fscrypt_context_size = btrfs_fscrypt_context_for_new_extent(inode,
+								    fscrypt_info,
+								    fscrypt_ctx);
+	if (fscrypt_context_size < 0) {
+		ret = (int)fscrypt_context_size;
+		goto free_qgroup;
+	}
+
 	extent_info.disk_offset = start;
 	extent_info.disk_len = len;
 	extent_info.data_offset = 0;
@@ -9337,6 +9371,8 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	extent_info.update_times = true;
 	extent_info.qgroup_reserved = qgroup_released;
 	extent_info.insertions = 0;
+	extent_info.fscrypt_ctx = fscrypt_ctx;
+	extent_info.fscrypt_context_size = fscrypt_context_size;
 
 	path = btrfs_alloc_path();
 	if (!path) {
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 49865a463780..ff431c05cb38 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -421,7 +421,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		struct btrfs_key new_key;
 		u64 disko = 0, diskl = 0;
 		u64 datao = 0, datal = 0;
-		u8 comp;
+		u8 comp, encryption;
 		u64 drop_start;
 
 		/* Note the key will change type as we walk through the tree */
@@ -464,6 +464,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		extent = btrfs_item_ptr(leaf, slot,
 					struct btrfs_file_extent_item);
 		extent_gen = btrfs_file_extent_generation(leaf, extent);
+		encryption = btrfs_file_extent_encryption(leaf, extent);
 		comp = btrfs_file_extent_compression(leaf, extent);
 		type = btrfs_file_extent_type(leaf, extent);
 		if (type == BTRFS_FILE_EXTENT_REG ||
@@ -523,6 +524,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		if (type == BTRFS_FILE_EXTENT_REG ||
 		    type == BTRFS_FILE_EXTENT_PREALLOC) {
 			struct btrfs_replace_extent_info clone_info;
+			u8 fscrypt_ctx[FSCRYPT_SET_CONTEXT_MAX_SIZE];
 
 			/*
 			 *    a  | --- range to clone ---|  b
@@ -539,6 +541,43 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 				datal -= off - key.offset;
 			}
 
+			if (encryption == BTRFS_ENCRYPTION_FSCRYPT) {
+				unsigned long offset;
+
+				key.type = BTRFS_FSCRYPT_CTX_KEY;
+				ret = btrfs_search_slot(NULL, BTRFS_I(src)->root, &key, path, 0, 0);
+				if (ret < 0)
+					goto out;
+				leaf = path->nodes[0];
+				slot = path->slots[0];
+				if (ret) {
+					btrfs_err(leaf->fs_info,
+	"missing or error searching encryption context item in leaf: root=%llu block=%llu slot=%d ino=%llu file_offset=%llu, err %i",
+						btrfs_header_owner(leaf),
+						btrfs_header_bytenr(leaf), slot,
+						key.objectid, key.offset, ret);
+					goto out;
+				}
+
+				size = btrfs_item_size(leaf, slot);
+				if (size > FSCRYPT_SET_CONTEXT_MAX_SIZE) {
+					btrfs_err(leaf->fs_info,
+	"unexpected or corrupted encryption context size in leaf: root=%llu block=%llu slot=%d ino=%llu file_offset=%llu, size %u (too big)",
+						btrfs_header_owner(leaf),
+						btrfs_header_bytenr(leaf), slot,
+						key.objectid, key.offset, size);
+					ret = -EIO;
+					goto out;
+				}
+
+				offset = btrfs_item_ptr_offset(leaf, slot),
+				read_extent_buffer(leaf, fscrypt_ctx, offset, size);
+				btrfs_release_path(path);
+				key.type = BTRFS_EXTENT_DATA_KEY;
+			} else {
+				size = 0;
+			}
+
 			clone_info.disk_offset = disko;
 			clone_info.disk_len = diskl;
 			clone_info.data_offset = datao;
@@ -547,6 +586,8 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			clone_info.extent_buf = buf;
 			clone_info.is_new_extent = false;
 			clone_info.update_times = !no_time_update;
+			clone_info.fscrypt_ctx = fscrypt_ctx;
+			clone_info.fscrypt_context_size = size;
 			ret = btrfs_replace_file_extents(BTRFS_I(inode), path,
 					drop_start, new_key.offset + datal - 1,
 					&clone_info, &trans);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 60aa763d2fa4..f3b839950855 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -30,6 +30,7 @@
 #include "print-tree.h"
 #include "tree-checker.h"
 #include "delayed-inode.h"
+#include "fscrypt.h"
 
 #define MAX_CONFLICT_INODES 10
 
@@ -5145,6 +5146,8 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_file_extent_item fi = { 0 };
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
+	u8 fscrypt_ctx[FSCRYPT_SET_CONTEXT_MAX_SIZE];
+	ssize_t fscrypt_context_size;
 	enum btrfs_compression_type compress_type;
 	u64 extent_offset = em->offset;
 	u64 block_start = btrfs_extent_map_block_start(em);
@@ -5152,6 +5155,12 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	int ret;
 	u8 encryption = btrfs_extent_map_encryption(em);
 
+	fscrypt_context_size = btrfs_fscrypt_context_for_new_extent(inode,
+								    em->fscrypt_info,
+								    fscrypt_ctx);
+	if (fscrypt_context_size < 0)
+		return (int)fscrypt_context_size;
+
 	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
 	if (em->flags & EXTENT_FLAG_PREALLOC)
 		btrfs_set_stack_file_extent_type(&fi, BTRFS_FILE_EXTENT_PREALLOC);
@@ -5215,6 +5224,16 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 
+	if (fscrypt_context_size) {
+		key.objectid = btrfs_ino(inode);
+		key.type = BTRFS_FSCRYPT_CTX_KEY;
+		key.offset = em->start;
+		ret = btrfs_insert_empty_item(trans, log, path, &key, fscrypt_context_size);
+		if (ret)
+			return ret;
+		btrfs_fscrypt_save_extent_info(path, fscrypt_ctx, fscrypt_context_size);
+	}
+
 	return ret;
 }
 
-- 
2.53.0


