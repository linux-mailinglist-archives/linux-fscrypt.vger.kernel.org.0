Return-Path: <linux-fscrypt+bounces-1583-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MCZWISA/BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1583-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:06:40 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A3295303A4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:06:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8B796311C0AE
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DBED402BA3;
	Wed, 13 May 2026 08:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jDmNLSJ4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jDmNLSJ4"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18E03E9C17
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662551; cv=none; b=oIXYN0owhbXdnNeo0ZersA+MopCVNptugsiTk+0TIZ/OokNuR5WpF8P499LCHprcPOBegBS0GEDgfJyT0Ls4GBVCJk6mof01IAp3axU0BQ4K+ZPbQ3Vjx1tpn1NNPTP/UZYhjKwa1nci1sg66TnkS0pfPYNhn7hCvXCG+9R9ppU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662551; c=relaxed/simple;
	bh=S2SZKkQkHhh9CtMTcidQNseMd3gn84Dpu5qB3PZhl6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEHDEwY+E0iSao2b1jzGtFB67AhOhLcsnj0EkadcFFJAKnpFnoK6yzr0O3esx82r3fHkNbuPvezgQakFLAmP6acwHfI19nvc0dhUFYWIz7CMDGhueml1f7wwhwgsYPLO7AbdWvsTjR9dEpE8eE+eMt8PL50T51ZD7ykv80vkLoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jDmNLSJ4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jDmNLSJ4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9D6B4625D1;
	Wed, 13 May 2026 08:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662474; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=06OoF/z0hCEj+Lw4v/RHUl4Ln+xArgKVEQHWuCuuSk4=;
	b=jDmNLSJ4rrMUDYKEXoeoFMn4IA2lmWT3ikmRopcgszQVSguEU+CKlboLTyxfv5ClrZHDFq
	hX+cXZQxGA4yebbiTkG0P/4VWo75jrFO9GQj/XQgz6ZwOF3Rh/iwh8WqrejN6L34obRYWw
	sKITvclt16SvSzjKqhpDf+Q4nBmy1HY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662474; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=06OoF/z0hCEj+Lw4v/RHUl4Ln+xArgKVEQHWuCuuSk4=;
	b=jDmNLSJ4rrMUDYKEXoeoFMn4IA2lmWT3ikmRopcgszQVSguEU+CKlboLTyxfv5ClrZHDFq
	hX+cXZQxGA4yebbiTkG0P/4VWo75jrFO9GQj/XQgz6ZwOF3Rh/iwh8WqrejN6L34obRYWw
	sKITvclt16SvSzjKqhpDf+Q4nBmy1HY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C905593A9;
	Wed, 13 May 2026 08:54:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AJPvHUo8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:34 +0000
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
Subject: [PATCH v7 24/43] btrfs: add extent encryption context tree item type
Date: Wed, 13 May 2026 10:52:58 +0200
Message-ID: <20260513085340.3673127-25-neelx@suse.com>
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
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Rspamd-Queue-Id: 3A3295303A4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1583-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.com:email,suse.com:mid,suse.com:dkim,toxicpanda.com:email]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

The fscrypt encryption context will be stored as a new tree item type.
This gives us flexibility to include different things in the future.

Also update the tree-checker to validate the new item type.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v7 changes:
 * Keep the original error if any as suggested by Chris' AI review.
 * Fix a comment in check_fscrypt_context() to match the new design
   as suggested by Chris' AI review.
v6 changes:
 * Not much left from the original commit.
   - This was reworked so that the encryption context is now a separate
     tree item with it's unique key.
   - It is tightly related to the file extent item but still optional and
     only used for encrypted extents.
   - The content (and hence the size as well) comes from the fscrrypt
     subsystem and it is not touched by btrfs at all.
   - It's handled as a raw binary data (u8 *).
   - This patch makes sure it is correctly removed when the related extent
     is dropped.
 * As a result, the following patch https://lore.kernel.org/linux-btrfs/f0d9b2d3a40b7a963a977d3dfb62793ff7b065d1.1706116485.git.josef@toxicpanda.com/
   ("btrfs: explicitly track file extent length for replace and drop")
   was dropped as not applicable.  There's no need to track the size
   anymore as it just matches the size of the stored item.

   [RFC]: Should I have kept the structure with __u8 type? Like:

   |  struct btrfs_encryption_info {
   |        __u8 context[0];
   |  };

   I did remove it as it was only used to extend the file extent item
   structure and hence no longer needed.
v5: https://lore.kernel.org/linux-btrfs/7ee9171262857336011bf0e121846617c5181fa4.1706116485.git.josef@toxicpanda.com/
    ("btrfs: add an optional encryption context to the end of file extents")
---
 fs/btrfs/file.c                 | 65 +++++++++++++++++++++++++++++++++
 fs/btrfs/tree-checker.c         | 56 ++++++++++++++++++++++++++--
 include/uapi/linux/btrfs_tree.h |  8 ++++
 3 files changed, 125 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8b0ebdeca9dd..fe7baecbf83b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -151,6 +151,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	u64 extent_offset = 0;
 	u64 extent_end = 0;
 	u64 last_end = args->start;
+	u64 first_ctx = 1, last_ctx = 0;
 	int del_nr = 0;
 	int del_slot = 0;
 	int extent_type;
@@ -408,6 +409,12 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 				del_nr++;
 			}
 
+			if (btrfs_file_extent_encryption(leaf, fi) == BTRFS_ENCRYPTION_FSCRYPT) {
+				if (first_ctx > last_ctx)
+					first_ctx = key.offset;
+				last_ctx = key.offset;
+			}
+
 			if (update_refs &&
 			    extent_type == BTRFS_FILE_EXTENT_INLINE) {
 				args->bytes_found += extent_end - key.offset;
@@ -497,6 +504,64 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 		args->extent_inserted = true;
 	}
 
+	if (first_ctx <= last_ctx) {
+		int slot, nritems;
+
+		btrfs_release_path(path);
+
+		key.objectid = ino;
+		key.type = BTRFS_FSCRYPT_CTX_KEY;
+		key.offset = first_ctx;
+
+		ret = btrfs_search_slot(trans, root, &key, path, modify_tree, !!modify_tree);
+		if (ret < 0)
+			goto out_ctx;
+next_leaf:
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+
+		del_slot = slot;
+		del_nr = 0;
+		nritems = btrfs_header_nritems(leaf);
+		while (slot < nritems) {
+			btrfs_item_key_to_cpu(leaf, &key, slot);
+			if (key.objectid > ino ||
+			    key.type > BTRFS_FSCRYPT_CTX_KEY ||
+			    key.offset > last_ctx)
+				break;
+			del_nr++;
+			slot++;
+		}
+		if (del_nr) {
+			ret = btrfs_del_items(trans, root, path, del_slot, del_nr);
+			if (unlikely(ret)) {
+				btrfs_abort_transaction(trans, ret);
+				goto out_ctx;
+			}
+
+			if (slot == nritems) {
+				ret = btrfs_next_leaf(root, path);
+				if (!ret)
+					goto next_leaf;
+				if (ret > 0)
+					ret = 0;
+			}
+		}
+out_ctx:
+		if (args->path && args->extent_inserted) {
+			int err;
+
+			btrfs_release_path(path);
+
+			key.objectid = ino;
+			key.type = BTRFS_EXTENT_DATA_KEY;
+			key.offset = args->start;
+			err = btrfs_search_slot(trans, root, &key, path, 0, 0);
+			if (err && ret >= 0)
+				ret = err;
+		}
+	}
+
 	if (!args->path)
 		btrfs_free_path(path);
 	else if (!args->extent_inserted)
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 61987353b138..fa20bdf9f1d1 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -186,6 +186,7 @@ static bool check_prev_ino(struct extent_buffer *leaf,
 	       key->type == BTRFS_INODE_EXTREF_KEY ||
 	       key->type == BTRFS_DIR_INDEX_KEY ||
 	       key->type == BTRFS_DIR_ITEM_KEY ||
+	       key->type == BTRFS_FSCRYPT_CTX_KEY ||
 	       key->type == BTRFS_EXTENT_DATA_KEY, "key->type=%u", key->type);
 
 	/*
@@ -204,6 +205,39 @@ static bool check_prev_ino(struct extent_buffer *leaf,
 		prev_key->objectid, key->objectid);
 	return false;
 }
+
+static int check_fscrypt_context(struct extent_buffer *leaf,
+				 struct btrfs_key *key, int slot,
+				 struct btrfs_key *prev_key)
+{
+	u32 sectorsize = leaf->fs_info->sectorsize;
+	u32 item_size = btrfs_item_size(leaf, slot);
+
+	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
+		file_extent_err(leaf, slot,
+"unaligned file_offset for encryption context, have %llu should be aligned to %u",
+			key->offset, sectorsize);
+		return -EUCLEAN;
+	}
+
+	/*
+	 * Previous key must have the same key->objectid (ino).  It can be
+	 * XATTR_ITEM, INODE_ITEM, FSCRYPT_INODE_CTX_KEY, or another FSCRYPT_CTX_KEY.
+	 * But if objectids mismatch, it means we have a missing INODE_ITEM.
+	 */
+	if (unlikely(!check_prev_ino(leaf, key, slot, prev_key)))
+		return -EUCLEAN;
+
+	if (unlikely(item_size > BTRFS_MAX_EXTENT_CTX_SIZE)) {
+		file_extent_err(leaf, slot,
+	"invalid encryption context size, have %u expect a maximum of %u",
+				item_size, BTRFS_MAX_EXTENT_CTX_SIZE);
+		return -EUCLEAN;
+	}
+
+	return 0;
+}
+
 static int check_extent_data_item(struct extent_buffer *leaf,
 				  struct btrfs_key *key, int slot,
 				  struct btrfs_key *prev_key)
@@ -214,6 +248,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 	u32 item_size = btrfs_item_size(leaf, slot);
 	u64 extent_end;
 	u8 policy;
+	u8 fe_type;
 
 	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
 		file_extent_err(leaf, slot,
@@ -244,12 +279,12 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 				SZ_4K);
 		return -EUCLEAN;
 	}
-	if (unlikely(btrfs_file_extent_type(leaf, fi) >=
-		     BTRFS_NR_FILE_EXTENT_TYPES)) {
+
+	fe_type = btrfs_file_extent_type(leaf, fi);
+	if (unlikely(fe_type >= BTRFS_NR_FILE_EXTENT_TYPES)) {
 		file_extent_err(leaf, slot,
 		"invalid type for file extent, have %u expect range [0, %u]",
-			btrfs_file_extent_type(leaf, fi),
-			BTRFS_NR_FILE_EXTENT_TYPES - 1);
+			fe_type, BTRFS_NR_FILE_EXTENT_TYPES - 1);
 		return -EUCLEAN;
 	}
 
@@ -298,6 +333,16 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 		return 0;
 	}
 
+	if (policy == BTRFS_ENCRYPTION_FSCRYPT) {
+		/* Only regular and prealloc extents should have an encryption context */
+		if (unlikely(fe_type != BTRFS_FILE_EXTENT_REG &&
+			     fe_type != BTRFS_FILE_EXTENT_PREALLOC)) {
+			file_extent_err(leaf, slot,
+		"invalid type for encrypted file extent, have %u", fe_type);
+			return -EUCLEAN;
+		}
+	}
+
 	/* Regular or preallocated extent has fixed item size */
 	if (unlikely(item_size != sizeof(*fi))) {
 		file_extent_err(leaf, slot,
@@ -2198,6 +2243,9 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_EXTENT_CSUM_KEY:
 		ret = check_csum_item(leaf, key, slot, prev_key);
 		break;
+	case BTRFS_FSCRYPT_CTX_KEY:
+		ret = check_fscrypt_context(leaf, key, slot, prev_key);
+		break;
 	case BTRFS_DIR_ITEM_KEY:
 	case BTRFS_DIR_INDEX_KEY:
 	case BTRFS_XATTR_ITEM_KEY:
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 7b1922c3265a..26b793396132 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -168,6 +168,7 @@
 #define BTRFS_VERITY_MERKLE_ITEM_KEY	37
 
 #define BTRFS_FSCRYPT_INODE_CTX_KEY	41
+#define BTRFS_FSCRYPT_CTX_KEY		42
 
 #define BTRFS_ORPHAN_ITEM_KEY		48
 /* reserve 2-15 close to the inode for later flexibility */
@@ -1079,6 +1080,13 @@ enum {
 	BTRFS_NR_FILE_EXTENT_TYPES = 3,
 };
 
+/*
+ * Currently just the FSCRYPT_SET_CONTEXT_MAX_SIZE, which is larger than the
+ * current extent context size from fscrypt, so this should give us plenty of
+ * breathing room for expansion later.
+ */
+#define BTRFS_MAX_EXTENT_CTX_SIZE 40
+
 enum btrfs_encryption_type {
 	BTRFS_ENCRYPTION_NONE,
 	BTRFS_ENCRYPTION_FSCRYPT,
-- 
2.53.0


