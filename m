Return-Path: <linux-fscrypt+bounces-1087-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WNojIhwzhmneKQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1087-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:29:48 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F4AD101DF6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:29:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CCDA730252AB
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A071429824;
	Fri,  6 Feb 2026 18:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="vNsUsCXK";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="vNsUsCXK"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4F1429819
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402258; cv=none; b=hRTOxIf8pD3w7Ih+jqFdYZmg6zAlCq8UZgxJRmAG76AWF1fdtkH2PN+/tt3IHjR+JUjw+UVEwJLGb/41lvoPfiQ4MEEqyaxDwyG0zv3tpKi7gVhZwDJZRlRme5BNMZnaB9wdSQed5AX467Ea7IA/mcw670PFFqLi9VNkzHlzoWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402258; c=relaxed/simple;
	bh=6eQ1M9/H/XuGaMD1MvhzaaFNWtUzgqxTRCVgXUGEjCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blipqYqaKYEMtnvdQWWekMCY0YG24lVFVEya9bub/TT7Is6HWYLy/2WN+mQ7FCjRb3DiRFp0ELtqqHRd069+bldMk1wNpXKte56Yqc9suYSs4a2LPjHQMNMAhgt/bK2DbRlvfkhhIBiWIhsQAe25F6ufo7t36VhjAORJf4Uogos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=vNsUsCXK; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=vNsUsCXK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1406F3E74D;
	Fri,  6 Feb 2026 18:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISdzY2BJK4ZBkWpAA57Mi26qixkjBLJ0zEsaqG3HRQ8=;
	b=vNsUsCXKlsFRP2PH6WLy/FOdwZxNqp0otxd20QdJSM7c90togl8xxmzrklH00p6xTujlGR
	F54hdiDomNQJFGGsnwxBI5OFyfPmYfoTR3vQAOZGaRsnpIwQ+gKNbUBBA2MWsKMw7CfJF+
	CzIPyZM972sA48tmE8rsmiNE2/WLe90=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISdzY2BJK4ZBkWpAA57Mi26qixkjBLJ0zEsaqG3HRQ8=;
	b=vNsUsCXKlsFRP2PH6WLy/FOdwZxNqp0otxd20QdJSM7c90togl8xxmzrklH00p6xTujlGR
	F54hdiDomNQJFGGsnwxBI5OFyfPmYfoTR3vQAOZGaRsnpIwQ+gKNbUBBA2MWsKMw7CfJF+
	CzIPyZM972sA48tmE8rsmiNE2/WLe90=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D51E03EA63;
	Fri,  6 Feb 2026 18:23:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QJOFM78xhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:23:59 +0000
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
Subject: [PATCH v6 10/43] btrfs: start using fscrypt hooks
Date: Fri,  6 Feb 2026 19:22:42 +0100
Message-ID: <20260206182336.1397715-11-neelx@suse.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1087-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dorminy.me:email,toxicpanda.com:email,suse.com:email,suse.com:dkim,suse.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,osandov.com:email]
X-Rspamd-Queue-Id: 0F4AD101DF6
X-Rspamd-Action: no action

From: Omar Sandoval <osandov@osandov.com>

In order to appropriately encrypt, create, open, rename, and various
symlink operations must call fscrypt hooks. These determine whether the
inode should be encrypted and do other preparatory actions. The
superblock must have fscrypt operations registered, so implement the
minimal set also, and introduce the new fscrypt.[ch] files to hold the
fscrypt-specific functionality.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/333de15efb2d7ec220293c4b5e3782fe85634c06.1706116485.git.josef@toxicpanda.com/
 * FSCrypt info moved from VFS inode to FS specific inode structure.
 * Trivial renames.
---
 fs/btrfs/Makefile      |   1 +
 fs/btrfs/btrfs_inode.h |   4 ++
 fs/btrfs/file.c        |   3 ++
 fs/btrfs/fscrypt.c     |  10 ++++
 fs/btrfs/fscrypt.h     |  10 ++++
 fs/btrfs/inode.c       | 109 +++++++++++++++++++++++++++++++++--------
 fs/btrfs/super.c       |   2 +
 7 files changed, 118 insertions(+), 21 deletions(-)
 create mode 100644 fs/btrfs/fscrypt.c
 create mode 100644 fs/btrfs/fscrypt.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 743d7677b175..715ba42f48dc 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -39,6 +39,7 @@ btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_DEBUG) += ref-verify.o
 btrfs-$(CONFIG_BLK_DEV_ZONED) += zoned.o
 btrfs-$(CONFIG_FS_VERITY) += verity.o
+btrfs-$(CONFIG_FS_ENCRYPTION) += fscrypt.o
 
 btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o \
 	tests/extent-buffer-tests.o tests/btrfs-tests.o \
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 73602ee8de3f..bf638a6a0973 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -342,6 +342,9 @@ struct btrfs_inode {
 #ifdef CONFIG_FS_VERITY
 	struct fsverity_info *i_verity_info;
 #endif
+#ifdef CONFIG_FS_ENCRYPTION
+	struct fscrypt_inode_info *i_crypt_info;
+#endif
 
 	struct inode vfs_inode;
 };
@@ -586,6 +589,7 @@ struct btrfs_new_inode_args {
 	struct posix_acl *default_acl;
 	struct posix_acl *acl;
 	struct fscrypt_name fname;
+	bool encrypt;
 };
 
 int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 56ece1109832..3c0db279f592 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3812,6 +3812,9 @@ static int btrfs_file_open(struct inode *inode, struct file *filp)
 		return -EIO;
 
 	filp->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
+	ret = fscrypt_file_open(inode, filp);
+	if (ret)
+		return ret;
 
 	ret = fsverity_file_open(inode, filp);
 	if (ret)
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
new file mode 100644
index 000000000000..6cfba7d94e72
--- /dev/null
+++ b/fs/btrfs/fscrypt.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "ctree.h"
+#include "btrfs_inode.h"
+#include "fscrypt.h"
+
+const struct fscrypt_operations btrfs_fscrypt_ops = {
+	.inode_info_offs = (int)offsetof(struct btrfs_inode, i_crypt_info) -
+			   (int)offsetof(struct btrfs_inode, vfs_inode),
+};
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
new file mode 100644
index 000000000000..7f4e6888bd43
--- /dev/null
+++ b/fs/btrfs/fscrypt.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef BTRFS_FSCRYPT_H
+#define BTRFS_FSCRYPT_H
+
+#include <linux/fscrypt.h>
+
+extern const struct fscrypt_operations btrfs_fscrypt_ops;
+
+#endif /* BTRFS_FSCRYPT_H */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 10609b8199a0..fdc07612af6e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5446,6 +5446,10 @@ static int btrfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (ret)
 		return ret;
 
+	ret = fscrypt_prepare_setattr(dentry, attr);
+	if (ret)
+		return ret;
+
 	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
 		ret = btrfs_setsize(inode, attr);
 		if (ret)
@@ -5600,11 +5604,8 @@ void btrfs_evict_inode(struct inode *inode)
 
 	trace_btrfs_inode_evict(inode);
 
-	if (!root) {
-		fsverity_cleanup_inode(inode);
-		clear_inode(inode);
-		return;
-	}
+	if (!root)
+		goto cleanup;
 
 	fs_info = inode_to_fs_info(inode);
 	evict_inode_truncate_pages(inode);
@@ -5704,6 +5705,9 @@ void btrfs_evict_inode(struct inode *inode)
 	 * to retry these periodically in the future.
 	 */
 	btrfs_remove_delayed_node(BTRFS_I(inode));
+
+cleanup:
+	fscrypt_put_encryption_info(inode);
 	fsverity_cleanup_inode(inode);
 	clear_inode(inode);
 }
@@ -6482,6 +6486,12 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 		return ret;
 	}
 
+	ret = fscrypt_prepare_new_inode(dir, inode, &args->encrypt);
+	if (ret) {
+		fscrypt_free_filename(&args->fname);
+		return ret;
+	}
+
 	/* 1 to add inode item */
 	*trans_num_items = 1;
 	/* 1 to add compression property */
@@ -6974,9 +6984,13 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (inode->i_nlink >= BTRFS_LINK_MAX)
 		return -EMLINK;
 
+	ret = fscrypt_prepare_link(old_dentry, dir, dentry);
+	if (ret)
+		return ret;
+
 	ret = fscrypt_setup_filename(dir, &dentry->d_name, 0, &fname);
 	if (ret)
-		goto fail;
+		return ret;
 
 	ret = btrfs_set_inode_index(BTRFS_I(dir), &index);
 	if (ret)
@@ -8035,6 +8049,9 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	INIT_LIST_HEAD(&ei->delayed_iput);
 	init_rwsem(&ei->i_mmap_lock);
 
+#ifdef CONFIG_FS_ENCRYPTION
+	ei->i_crypt_info = NULL;
+#endif
 	return inode;
 }
 
@@ -8050,6 +8067,7 @@ void btrfs_test_destroy_inode(struct inode *inode)
 void btrfs_free_inode(struct inode *inode)
 {
 	kfree(BTRFS_I(inode)->file_extent_tree);
+	fscrypt_free_inode(inode);
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 }
 
@@ -8121,8 +8139,7 @@ int btrfs_drop_inode(struct inode *inode)
 	/* the snap/subvol tree is on deleting */
 	if (btrfs_root_refs(&root->root_item) == 0)
 		return 1;
-	else
-		return inode_generic_drop(inode);
+	return inode_generic_drop(inode) || fscrypt_drop_inode(inode);
 }
 
 static void init_once(void *foo)
@@ -8776,6 +8793,10 @@ static int btrfs_rename2(struct mnt_idmap *idmap, struct inode *old_dir,
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
 		return -EINVAL;
 
+	ret = fscrypt_prepare_rename(old_dir, old_dentry, new_dir, new_dentry, flags);
+	if (ret)
+		return ret;
+
 	if (flags & RENAME_EXCHANGE)
 		ret = btrfs_rename_exchange(old_dir, old_dentry, new_dir,
 					    new_dentry);
@@ -8970,20 +8991,28 @@ static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	};
 	unsigned int trans_num_items;
 	int ret;
-	int name_len;
 	int datasize;
 	unsigned long ptr;
 	struct btrfs_file_extent_item *ei;
 	struct extent_buffer *leaf;
+	struct fscrypt_str disk_link;
+	size_t max_len;
+	u32 name_len = strlen(symname);
+
+	/*
+	 * BTRFS_MAX_INLINE_DATA_SIZE() isn't actually telling the truth, we actually
+	 * limit inline data extents to min(BTRFS_MAX_INLINE_DATA_SIZE(), sectorsize),
+	 * so adjust max_len given this wonderful bit of inconsistency.
+	 */
+	max_len = min_t(size_t, BTRFS_MAX_INLINE_DATA_SIZE(fs_info), fs_info->sectorsize);
 
-	name_len = strlen(symname);
 	/*
-	 * Symlinks utilize uncompressed inline extent data, which should not
-	 * reach block size.
+	 * fscrypt sets disk_link.len to be len + 1, including a NUL terminator,
+	 * but we don't store that '\0' character.
 	 */
-	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info) ||
-	    name_len >= fs_info->sectorsize)
-		return -ENAMETOOLONG;
+	ret = fscrypt_prepare_symlink(dir, symname, name_len, max_len + 1, &disk_link);
+	if (ret)
+		return ret;
 
 	inode = new_inode(dir->i_sb);
 	if (!inode)
@@ -8992,8 +9021,8 @@ static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	inode->i_op = &btrfs_symlink_inode_operations;
 	inode_nohighmem(inode);
 	inode->i_mapping->a_ops = &btrfs_aops;
-	btrfs_i_size_write(BTRFS_I(inode), name_len);
-	inode_set_bytes(inode, name_len);
+	btrfs_i_size_write(BTRFS_I(inode), disk_link.len - 1);
+	inode_set_bytes(inode, disk_link.len - 1);
 
 	new_inode_args.inode = inode;
 	ret = btrfs_new_inode_prepare(&new_inode_args, &trans_num_items);
@@ -9020,10 +9049,22 @@ static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		inode = NULL;
 		goto out;
 	}
+
+	if (IS_ENCRYPTED(inode)) {
+		ret = fscrypt_encrypt_symlink(inode, symname, name_len, &disk_link);
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			btrfs_free_path(path);
+			discard_new_inode(inode);
+			inode = NULL;
+			goto out;
+		}
+	}
+
 	key.objectid = btrfs_ino(BTRFS_I(inode));
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = 0;
-	datasize = btrfs_file_extent_calc_inline_size(name_len);
+	datasize = btrfs_file_extent_calc_inline_size(disk_link.len - 1);
 	ret = btrfs_insert_empty_item(trans, root, path, &key, datasize);
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
@@ -9041,10 +9082,10 @@ static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	btrfs_set_file_extent_encryption(leaf, ei, 0);
 	btrfs_set_file_extent_compression(leaf, ei, 0);
 	btrfs_set_file_extent_other_encoding(leaf, ei, 0);
-	btrfs_set_file_extent_ram_bytes(leaf, ei, name_len);
+	btrfs_set_file_extent_ram_bytes(leaf, ei, disk_link.len - 1);
 
 	ptr = btrfs_file_extent_inline_start(ei);
-	write_extent_buffer(leaf, symname, ptr, name_len);
+	write_extent_buffer(leaf, disk_link.name, ptr, disk_link.len - 1);
 	btrfs_free_path(path);
 
 	d_instantiate_new(dentry, inode);
@@ -9060,6 +9101,29 @@ static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	return ret;
 }
 
+static const char *btrfs_get_link(struct dentry *dentry, struct inode *inode,
+				  struct delayed_call *done)
+{
+	struct page *cpage;
+	const char *paddr;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+
+	if (!IS_ENCRYPTED(inode))
+		return page_get_link(dentry, inode, done);
+
+	if (!dentry)
+		return ERR_PTR(-ECHILD);
+
+	cpage = read_mapping_page(inode->i_mapping, 0, NULL);
+	if (IS_ERR(cpage))
+		return ERR_CAST(cpage);
+
+	paddr = fscrypt_get_symlink(inode, page_address(cpage),
+				    BTRFS_MAX_INLINE_DATA_SIZE(fs_info), done);
+	put_page(cpage);
+	return paddr;
+}
+
 static struct btrfs_trans_handle *insert_prealloc_file_extent(
 				       struct btrfs_trans_handle *trans_in,
 				       struct btrfs_inode *inode,
@@ -10684,7 +10748,7 @@ static const struct inode_operations btrfs_special_inode_operations = {
 	.update_time	= btrfs_update_time,
 };
 static const struct inode_operations btrfs_symlink_inode_operations = {
-	.get_link	= page_get_link,
+	.get_link	= btrfs_get_link,
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.permission	= btrfs_permission,
@@ -10694,4 +10758,7 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 
 const struct dentry_operations btrfs_dentry_operations = {
 	.d_delete	= btrfs_dentry_delete,
+#ifdef CONFIG_FS_ENCRYPTION
+	.d_revalidate	= fscrypt_d_revalidate,
+#endif
 };
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d64d303b6edc..7eb367b1f6f6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -49,6 +49,7 @@
 #include "tests/btrfs-tests.h"
 #include "block-group.h"
 #include "discard.h"
+#include "fscrypt.h"
 #include "qgroup.h"
 #include "raid56.h"
 #include "fs.h"
@@ -969,6 +970,7 @@ static int btrfs_fill_super(struct super_block *sb,
 	sb->s_vop = &btrfs_verityops;
 #endif
 	sb->s_xattr = btrfs_xattr_handlers;
+	fscrypt_set_ops(sb, &btrfs_fscrypt_ops);
 	sb->s_time_gran = 1;
 	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM;
 
-- 
2.51.0


