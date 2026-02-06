Return-Path: <linux-fscrypt+bounces-1089-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OCKDDmkyhmneKQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1089-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:26:49 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA25101CF6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:26:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 91C4F301CB62
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C26142EEC8;
	Fri,  6 Feb 2026 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ManIxIWB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ManIxIWB"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7EA42EEB5
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402263; cv=none; b=V3ZxqN2Qs3RCyU9a/XLL0Q9ZexGw3RZsl6WojyPMwIAr6BgV183hrriIr8RNGqaxrgwH+lhUaslb6XBF0DTzsMjklxYuuNFS+aUsoKJQbUMiN5r63UTp9pjhZVp1tBIi+8+xpQOKBqXmxwHLLzUd18To/OWCgyY8FLPYiJswB6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402263; c=relaxed/simple;
	bh=pyvoI9kpidD1sgfEAw3bRdS1eNDuzNnC2qgbERKp0R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Io0plO5rWBTqlucsre8ecyLOtzUa4skQVGbueaetrO9dl7rnth92fU/GLfdN1WRaPbaew7kwTwCwpPOohjaK/u2+AL5+6lUveIiV/YEv6yAWvJJmFH2a7nxt0xgjbFlE5BIgff1+iBHG7/2YskOag6JCIpv9nK3RzfFQ8pG6kAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ManIxIWB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ManIxIWB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E019B3E700;
	Fri,  6 Feb 2026 18:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+65SWdv1RzImpYlFpkGn+W3DnH2iFIUZVW/vILN7NRw=;
	b=ManIxIWB7B8atNm4iqFEkZEV7szuEcVwmon6vHM4HeBOKWw8uQqqqKDcq2j9t0LSo9HfAS
	CC+vfpoS0BG4/yXEGPlVq0EF0ACMtMWWrvyJkrjqEPs4/9l8TPcQtp1/13lms1jejJ2yaM
	VEaDJ2IzOb4HUq+X0SaaCAqpOwR1yA4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+65SWdv1RzImpYlFpkGn+W3DnH2iFIUZVW/vILN7NRw=;
	b=ManIxIWB7B8atNm4iqFEkZEV7szuEcVwmon6vHM4HeBOKWw8uQqqqKDcq2j9t0LSo9HfAS
	CC+vfpoS0BG4/yXEGPlVq0EF0ACMtMWWrvyJkrjqEPs4/9l8TPcQtp1/13lms1jejJ2yaM
	VEaDJ2IzOb4HUq+X0SaaCAqpOwR1yA4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B283E3EA63;
	Fri,  6 Feb 2026 18:24:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iCX1KsAxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:00 +0000
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
	Omar Sandoval <osandov@osandov.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v6 11/43] btrfs: add inode encryption contexts
Date: Fri,  6 Feb 2026 19:22:43 +0100
Message-ID: <20260206182336.1397715-12-neelx@suse.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1089-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[osandov.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,toxicpanda.com:email,suse.com:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: 4EA25101CF6
X-Rspamd-Action: no action

From: Omar Sandoval <osandov@osandov.com>

fscrypt stores a context item with encrypted inodes that contains the
related encryption information.  fscrypt provides an arbitrary blob for
the filesystem to store, and it does not clearly fit into an existing
structure, so this goes in a new item type.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/5a88efb484b0874a7430b83bc6e5f6b9aa5858d5.1706116485.git.josef@toxicpanda.com/
 * Shorten the inode context key macro name to BTRFS_FSCRYPT_INODE_CTX_KEY.
---
 fs/btrfs/fscrypt.c              | 116 ++++++++++++++++++++++++++++++++
 fs/btrfs/fscrypt.h              |   2 +
 fs/btrfs/inode.c                |  19 ++++++
 fs/btrfs/ioctl.c                |   8 ++-
 include/uapi/linux/btrfs_tree.h |  10 +++
 5 files changed, 153 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 6cfba7d94e72..e9b024d671a2 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -1,10 +1,126 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/iversion.h>
 #include "ctree.h"
+#include "accessors.h"
 #include "btrfs_inode.h"
+#include "disk-io.h"
+#include "fs.h"
 #include "fscrypt.h"
+#include "ioctl.h"
+#include "messages.h"
+#include "transaction.h"
+#include "xattr.h"
+
+static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
+{
+	struct btrfs_key key = {
+		.objectid = btrfs_ino(BTRFS_I(inode)),
+		.type = BTRFS_FSCRYPT_INODE_CTX_KEY,
+		.offset = 0,
+	};
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	unsigned long ptr;
+	int ret;
+
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(NULL, BTRFS_I(inode)->root, &key, path, 0, 0);
+	if (ret) {
+		len = -ENOENT;
+		goto out;
+	}
+
+	leaf = path->nodes[0];
+	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
+	/* fscrypt provides max context length, but it could be less */
+	len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
+	read_extent_buffer(leaf, ctx, ptr, len);
+
+out:
+	btrfs_free_path(path);
+	return len;
+}
+
+static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
+				     size_t len, void *fs_data)
+{
+	struct btrfs_trans_handle *trans = fs_data;
+	struct btrfs_key key = {
+		.objectid = btrfs_ino(BTRFS_I(inode)),
+		.type = BTRFS_FSCRYPT_INODE_CTX_KEY,
+		.offset = 0,
+	};
+	struct btrfs_path *path = NULL;
+	struct extent_buffer *leaf;
+	unsigned long ptr;
+	int ret;
+
+	if (!trans)
+		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
+	ret = btrfs_search_slot(trans, BTRFS_I(inode)->root, &key, path, 0, 1);
+	if (ret < 0)
+		goto out_err;
+
+	if (ret > 0) {
+		btrfs_release_path(path);
+		ret = btrfs_insert_empty_item(trans, BTRFS_I(inode)->root, path, &key, len);
+		if (ret)
+			goto out_err;
+	}
+
+	leaf = path->nodes[0];
+	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
+
+	len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
+	write_extent_buffer(leaf, ctx, ptr, len);
+	btrfs_mark_buffer_dirty(trans, leaf);
+	btrfs_release_path(path);
+
+	if (fs_data)
+		return ret;
+
+	BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
+	btrfs_sync_inode_flags_to_i_flags(BTRFS_I(inode));
+	inode_inc_iversion(inode);
+	inode_set_ctime_current(inode);
+	ret = btrfs_update_inode(trans, BTRFS_I(inode));
+	if (ret)
+		goto out_abort;
+	btrfs_free_path(path);
+	btrfs_end_transaction(trans);
+	return 0;
+out_abort:
+	btrfs_abort_transaction(trans, ret);
+out_err:
+	if (!fs_data)
+		btrfs_end_transaction(trans);
+	btrfs_free_path(path);
+	return ret;
+}
+
+static bool btrfs_fscrypt_empty_dir(struct inode *inode)
+{
+	return inode->i_size == BTRFS_EMPTY_DIR_SIZE;
+}
 
 const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.inode_info_offs = (int)offsetof(struct btrfs_inode, i_crypt_info) -
 			   (int)offsetof(struct btrfs_inode, vfs_inode),
+	.get_context = btrfs_fscrypt_get_context,
+	.set_context = btrfs_fscrypt_set_context,
+	.empty_dir = btrfs_fscrypt_empty_dir,
 };
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 7f4e6888bd43..80adb7e56826 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -5,6 +5,8 @@
 
 #include <linux/fscrypt.h>
 
+#include "fs.h"
+
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
 
 #endif /* BTRFS_FSCRYPT_H */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fdc07612af6e..c06d7cd45be5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -60,6 +60,7 @@
 #include "defrag.h"
 #include "dir-item.h"
 #include "file-item.h"
+#include "fscrypt.h"
 #include "uuid-tree.h"
 #include "ioctl.h"
 #include "file.h"
@@ -6473,6 +6474,9 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 	struct inode *inode = args->inode;
 	int ret;
 
+	if (fscrypt_is_nokey_name(args->dentry))
+		return -ENOKEY;
+
 	if (!args->orphan) {
 		ret = fscrypt_setup_filename(dir, &args->dentry->d_name, 0,
 					     &args->fname);
@@ -6508,6 +6512,9 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 	if (dir->i_security)
 		(*trans_num_items)++;
 #endif
+	/* 1 to add fscrypt item */
+	if (args->encrypt)
+		(*trans_num_items)++;
 	if (args->orphan) {
 		/* 1 to add orphan item */
 		(*trans_num_items)++;
@@ -6701,6 +6708,11 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 	BTRFS_I(inode)->i_otime_sec = ts.tv_sec;
 	BTRFS_I(inode)->i_otime_nsec = ts.tv_nsec;
 
+	if (args->encrypt) {
+		BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
+		btrfs_sync_inode_flags_to_i_flags(BTRFS_I(inode));
+	}
+
 	/*
 	 * We're going to fill the inode item now, so at this point the inode
 	 * must be fully initialized.
@@ -6774,6 +6786,13 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 			goto discard;
 		}
 	}
+	if (args->encrypt) {
+		ret = fscrypt_set_context(inode, trans);
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			goto discard;
+		}
+	}
 
 	ret = btrfs_add_inode_to_root(BTRFS_I(inode), false);
 	if (WARN_ON(ret)) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f1b56be6f8f4..9d0716498286 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -153,6 +153,8 @@ static unsigned int btrfs_inode_flags_to_fsflags(const struct btrfs_inode *inode
 		iflags |= FS_DIRSYNC_FL;
 	if (flags & BTRFS_INODE_NODATACOW)
 		iflags |= FS_NOCOW_FL;
+	if (flags & BTRFS_INODE_ENCRYPT)
+		iflags |= FS_ENCRYPT_FL;
 	if (ro_flags & BTRFS_INODE_RO_VERITY)
 		iflags |= FS_VERITY_FL;
 
@@ -181,12 +183,14 @@ void btrfs_sync_inode_flags_to_i_flags(struct btrfs_inode *inode)
 		new_fl |= S_NOATIME;
 	if (inode->flags & BTRFS_INODE_DIRSYNC)
 		new_fl |= S_DIRSYNC;
+	if (inode->flags & BTRFS_INODE_ENCRYPT)
+		new_fl |= S_ENCRYPTED;
 	if (inode->ro_flags & BTRFS_INODE_RO_VERITY)
 		new_fl |= S_VERITY;
 
 	set_mask_bits(&inode->vfs_inode.i_flags,
 		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC |
-		      S_VERITY, new_fl);
+		      S_VERITY | S_ENCRYPTED, new_fl);
 }
 
 /*
@@ -199,7 +203,7 @@ static int check_fsflags(unsigned int old_flags, unsigned int flags)
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
 		      FS_SYNC_FL | FS_DIRSYNC_FL | \
 		      FS_NOCOMP_FL | FS_COMPR_FL |
-		      FS_NOCOW_FL))
+		      FS_NOCOW_FL | FS_ENCRYPT_FL))
 		return -EOPNOTSUPP;
 
 	/* COMPR and NOCOMP on new/old are valid */
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index f7843e6bb978..02b1ab1f7858 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -167,6 +167,8 @@
 #define BTRFS_VERITY_DESC_ITEM_KEY	36
 #define BTRFS_VERITY_MERKLE_ITEM_KEY	37
 
+#define BTRFS_FSCRYPT_INODE_CTX_KEY	41
+
 #define BTRFS_ORPHAN_ITEM_KEY		48
 /* reserve 2-15 close to the inode for later flexibility */
 
@@ -431,6 +433,7 @@ static inline __u8 btrfs_dir_flags_to_ftype(__u8 flags)
 #define BTRFS_INODE_NOATIME		(1U << 9)
 #define BTRFS_INODE_DIRSYNC		(1U << 10)
 #define BTRFS_INODE_COMPRESS		(1U << 11)
+#define BTRFS_INODE_ENCRYPT		(1U << 12)
 
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1U << 31)
 
@@ -447,6 +450,7 @@ static inline __u8 btrfs_dir_flags_to_ftype(__u8 flags)
 	 BTRFS_INODE_NOATIME |						\
 	 BTRFS_INODE_DIRSYNC |						\
 	 BTRFS_INODE_COMPRESS |						\
+	 BTRFS_INODE_ENCRYPT |						\
 	 BTRFS_INODE_ROOT_ITEM_INIT)
 
 #define BTRFS_INODE_RO_VERITY		(1U << 0)
@@ -1075,6 +1079,12 @@ enum {
 	BTRFS_NR_FILE_EXTENT_TYPES = 3,
 };
 
+enum btrfs_encryption_type {
+	BTRFS_ENCRYPTION_NONE,
+	BTRFS_ENCRYPTION_FSCRYPT,
+	BTRFS_NR_ENCRYPTION_TYPES,
+};
+
 struct btrfs_file_extent_item {
 	/*
 	 * transaction id that created this extent
-- 
2.51.0


