Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA3D5971E8
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 16:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239492AbiHQOuu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Aug 2022 10:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240437AbiHQOur (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Aug 2022 10:50:47 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A0C8FD6B;
        Wed, 17 Aug 2022 07:50:46 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id C0BCB80A9D;
        Wed, 17 Aug 2022 10:50:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1660747846; bh=Rb3/Yvh2vqCnu8VOdaEHR/xCVuwgqNq/Bjv8ql59VhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEbWz+CumEEpC38qniNKL53IrP37m4hFwSjRlhL0F4sZ9Ft2brSMTokjYn2JVBQ2t
         8h0Jt3re+EOa+d6d47NBip8VfT8OipHSp+MrA8osLwmVPtIK/ehXVuUa5hL3H+xssr
         tqF5CIi/mkhY2sCxOVEyyQ88rbuDP9YDZ+IcgEmZQ8xcfKniorh7Zm0O5nA2+46qMm
         xEf0cbZamK/loixJdy+NEjD9swRb6cNdeIJ0OCJTLZ3UBgOj2ByjSwWw1mD3hFgBXp
         vsB+Toev8fcGUS7sVUjlsGD5gv5CjTB+1DkeaoeT2nlllMpZdEJVutQSN7jmt/YzxL
         e3mlrOGI6CPHA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 13/21] btrfs: add fscrypt_context items.
Date:   Wed, 17 Aug 2022 10:49:57 -0400
Message-Id: <f84a024da71383fafd65c53e927a0cad060b59e3.1660744500.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1660744500.git.sweettea-kernel@dorminy.me>
References: <cover.1660744500.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

In order to store per-inode information such as the inode nonce and the
key identifier, fscrypt stores a context item with each encrypted inode.
This can be implemented as a new item type, as fscrypt provides an
arbitrary blob for the filesystem to store.

This also provides a good place to implement full-subvolume encryption:
a subvolume flag permits setting one context for the whole subvolume.
However, since an unencrypted subvolume would be unable to read
encrypted data, encrypted subvolumes should only be snapshottable to
other encrypted subvolumes.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

fix set context item
---
 fs/btrfs/ctree.h                |   3 +
 fs/btrfs/fscrypt.c              | 160 ++++++++++++++++++++++++++++++++
 fs/btrfs/inode.c                |  38 ++++++++
 fs/btrfs/ioctl.c                |  10 +-
 fs/btrfs/tree-checker.c         |   1 +
 include/uapi/linux/btrfs_tree.h |  10 ++
 6 files changed, 221 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a7e09b90d326..ce2fccc67db5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -33,6 +33,7 @@
 #include "extent-io-tree.h"
 #include "extent_io.h"
 #include "extent_map.h"
+#include "fscrypt.h"
 #include "async-thread.h"
 #include "block-rsv.h"
 #include "locking.h"
@@ -1674,6 +1675,7 @@ do {                                                                   \
 #define BTRFS_INODE_NOATIME		(1U << 9)
 #define BTRFS_INODE_DIRSYNC		(1U << 10)
 #define BTRFS_INODE_COMPRESS		(1U << 11)
+#define BTRFS_INODE_FSCRYPT_CONTEXT	(1U << 12)
 
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1U << 31)
 
@@ -1690,6 +1692,7 @@ do {                                                                   \
 	 BTRFS_INODE_NOATIME |						\
 	 BTRFS_INODE_DIRSYNC |						\
 	 BTRFS_INODE_COMPRESS |						\
+	 BTRFS_INODE_FSCRYPT_CONTEXT |					\
 	 BTRFS_INODE_ROOT_ITEM_INIT)
 
 #define BTRFS_INODE_RO_VERITY		(1U << 0)
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 9829d280a6bc..959efc4c179b 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -3,8 +3,13 @@
  * Copyright (C) 2020 Facebook
  */
 
+#include <linux/iversion.h>
 #include "ctree.h"
+#include "btrfs_inode.h"
+#include "disk-io.h"
 #include "fscrypt.h"
+#include "transaction.h"
+#include "xattr.h"
 
 /* fscrypt_match_name() but for an extent_buffer. */
 bool btrfs_fscrypt_match_name(const struct fscrypt_name *fname,
@@ -31,5 +36,160 @@ bool btrfs_fscrypt_match_name(const struct fscrypt_name *fname,
 	return !memcmp(digest, nokey_name->sha256, sizeof(digest));
 }
 
+static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct inode *put_inode = NULL;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	unsigned long ptr;
+	int ret;
+
+	if (S_ISREG(inode->i_mode) &&
+	    (btrfs_root_flags(&root->root_item) & BTRFS_ROOT_SUBVOL_FSCRYPT)) {
+		/* TODO: maybe cache the item */
+		inode = btrfs_iget(inode->i_sb, BTRFS_FIRST_FREE_OBJECTID,
+				   root);
+		if (IS_ERR(inode))
+			return PTR_ERR(inode);
+		put_inode = inode;
+	}
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key = (struct btrfs_key) {
+		.objectid = btrfs_ino(BTRFS_I(inode)),
+		.type = BTRFS_FSCRYPT_CTXT_ITEM_KEY,
+		.offset = 0,
+	};
+
+	ret = btrfs_search_slot(NULL, BTRFS_I(inode)->root, &key, path, 0, 0);
+	if (ret) {
+		len = -EINVAL;
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
+	iput(put_inode);
+	return len;
+}
+
+static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
+				     size_t len, void *fs_data)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
+	int is_subvolume = inode->i_ino == BTRFS_FIRST_FREE_OBJECTID;
+	int ret;
+	struct btrfs_path *path;
+	struct btrfs_key key = {
+		.objectid = btrfs_ino(BTRFS_I(inode)),
+		.type = BTRFS_FSCRYPT_CTXT_ITEM_KEY,
+		.offset = 0,
+	};
+
+	/*
+	 * If the whole subvolume is encrypted, we can get the policy for
+	 * regular files from the root inode.
+	 */
+	if (S_ISREG(inode->i_mode) &&
+	    (btrfs_root_flags(&root->root_item) & BTRFS_ROOT_SUBVOL_FSCRYPT))
+		return 0;
+
+	if (fs_data) {
+		/*
+		 * We are setting the context as part of an existing
+		 * transaction. This happens when we are inheriting the context
+		 * for a new inode.
+		 */
+		trans = fs_data;
+	} else {
+		/*
+		 * 1 for the inode item
+		 * 1 for the fscrypt item
+		 * 1 for the root item if the inode is a subvolume
+		 */
+		trans = btrfs_start_transaction(root, 2 + is_subvolume);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
+	}
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	ret = btrfs_search_slot(trans, BTRFS_I(inode)->root, &key, path, 0, 1);
+	if (ret == 0) {
+		struct extent_buffer *leaf = path->nodes[0];
+		unsigned long ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
+		len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
+		write_extent_buffer(leaf, ctx, ptr, len);
+		btrfs_mark_buffer_dirty(leaf);
+		btrfs_free_path(path);
+		goto out;
+	} else if (ret < 0) {
+		goto out;
+	}
+	btrfs_free_path(path);
+
+	ret = btrfs_insert_item(trans, BTRFS_I(inode)->root, &key, (void *) ctx, len);
+	if (ret)
+		goto out;
+
+	BTRFS_I(inode)->flags |= BTRFS_INODE_FSCRYPT_CONTEXT;
+	btrfs_sync_inode_flags_to_i_flags(inode);
+	inode_inc_iversion(inode);
+	inode->i_ctime = current_time(inode);
+	ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
+	if (ret)
+		goto out;
+
+	/*
+	 * For new subvolumes, the root item is already initialized with
+	 * the BTRFS_ROOT_SUBVOL_FSCRYPT flag.
+	 */
+	if (!fs_data && is_subvolume) {
+		u64 root_flags = btrfs_root_flags(&root->root_item);
+
+		btrfs_set_root_flags(&root->root_item,
+				     root_flags |
+				     BTRFS_ROOT_SUBVOL_FSCRYPT);
+		ret = btrfs_update_root(trans, root->fs_info->tree_root,
+					&root->root_key,
+					&root->root_item);
+	}
+out:
+	if (fs_data)
+		return ret;
+
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
+	else
+		btrfs_end_transaction(trans);
+	return ret;
+}
+
+static bool btrfs_fscrypt_empty_dir(struct inode *inode)
+{
+	/*
+	 * We don't care about turning on encryption on a non-empty directory
+	 * so we always return true.
+	 */
+	return true;
+}
+
 const struct fscrypt_operations btrfs_fscrypt_ops = {
+	.key_prefix = "btrfs:",
+	.get_context = btrfs_fscrypt_get_context,
+	.set_context = btrfs_fscrypt_set_context,
+	.empty_dir = btrfs_fscrypt_empty_dir,
 };
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0fdd162d30bc..5762e7795838 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6282,6 +6282,34 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 	struct inode *inode = args->inode;
 	int ret;
 
+	if (fscrypt_is_nokey_name(args->dentry))
+		return -ENOKEY;
+
+	if (IS_ENCRYPTED(dir) &&
+	    !(BTRFS_I(dir)->flags & BTRFS_INODE_FSCRYPT_CONTEXT)) {
+		struct inode *root_inode;
+		bool encrypt;
+
+		root_inode = btrfs_iget(inode->i_sb, BTRFS_FIRST_FREE_OBJECTID,
+					BTRFS_I(dir)->root);
+		if (IS_ERR(root_inode))
+			return PTR_ERR(root_inode);
+		/*
+		 * TODO: perhaps instead of faking making a new dir to get a
+		 * new context, it would be better to expose
+		 * fscrypt_setup_encryption_info() for our use.
+		 */
+		ret = fscrypt_prepare_new_inode(root_inode, dir, &encrypt);
+		if (!ret) {
+			ret = fscrypt_set_context(dir, NULL);
+			if (ret)
+				fscrypt_put_encryption_info(dir);
+		}
+		iput(root_inode);
+		if (ret)
+			return ret;
+	}
+
 	if (!args->orphan) {
 		ret = fscrypt_setup_filename(dir, &args->dentry->d_name, 0,
 					     &args->fname);
@@ -6315,6 +6343,8 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 	if (dir->i_security)
 		(*trans_num_items)++;
 #endif
+	if (args->encrypt)
+		(*trans_num_items)++; /* 1 to add fscrypt item */
 	if (args->orphan) {
 		/* 1 to add orphan item */
 		(*trans_num_items)++;
@@ -6568,6 +6598,14 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 		}
 	}
 
+	if (args->encrypt) {
+		ret = fscrypt_set_context(inode, trans);
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			goto discard;
+		}
+	}
+
 	inode_tree_add(inode);
 
 	trace_btrfs_inode_new(inode);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 10b8db56edda..8f5b65c43c8d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -658,7 +658,8 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 				     fs_info->nodesize);
 	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
 
-	btrfs_set_root_flags(root_item, 0);
+	btrfs_set_root_flags(root_item, new_inode_args.encrypt ?
+			     BTRFS_ROOT_SUBVOL_FSCRYPT : 0);
 	btrfs_set_root_limit(root_item, 0);
 	btrfs_set_stack_inode_flags(inode_item, BTRFS_INODE_ROOT_ITEM_INIT);
 
@@ -787,6 +788,13 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 		return -ETXTBSY;
 	}
 
+	if ((btrfs_root_flags(&root->root_item) & BTRFS_ROOT_SUBVOL_FSCRYPT) &&
+	    !IS_ENCRYPTED(dir)) {
+		btrfs_warn(fs_info,
+			   "cannot snapshot encrypted volume to unencrypted destination");
+		return -EXDEV;
+	}
+
 	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_KERNEL);
 	if (!pending_snapshot)
 		return -ENOMEM;
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 2c6d48af1d2a..05f404c7498e 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1124,6 +1124,7 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_root_item ri = { 0 };
 	const u64 valid_root_flags = BTRFS_ROOT_SUBVOL_RDONLY |
+				     BTRFS_ROOT_SUBVOL_FSCRYPT |
 				     BTRFS_ROOT_SUBVOL_DEAD;
 	int ret;
 
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 428ae75b9f73..da44d3355385 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -144,6 +144,8 @@
 #define BTRFS_VERITY_DESC_ITEM_KEY	36
 #define BTRFS_VERITY_MERKLE_ITEM_KEY	37
 
+#define BTRFS_FSCRYPT_CTXT_ITEM_KEY	41
+
 #define BTRFS_ORPHAN_ITEM_KEY		48
 /* reserve 2-15 close to the inode for later flexibility */
 
@@ -633,6 +635,8 @@ struct btrfs_dir_item {
 } __attribute__ ((__packed__));
 
 #define BTRFS_ROOT_SUBVOL_RDONLY	(1ULL << 0)
+/* Top-level subvolume directory is encrypted with fscrypt. */
+#define BTRFS_ROOT_SUBVOL_FSCRYPT	(1ULL << 1)
 
 /*
  * Internal in-memory flag that a subvolume has been marked for deletion but
@@ -788,6 +792,12 @@ enum {
 	BTRFS_NR_FILE_EXTENT_TYPES = 3,
 };
 
+enum {
+	BTRFS_ENCRYPTION_NONE,
+	BTRFS_ENCRYPTION_FSCRYPT,
+	BTRFS_NR_ENCRYPTION_TYPES,
+};
+
 struct btrfs_file_extent_item {
 	/*
 	 * transaction id that created this extent
-- 
2.35.1

