Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C35755A44
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 05:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjGQDxU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 23:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjGQDxD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 23:53:03 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552621AC;
        Sun, 16 Jul 2023 20:53:01 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id CABFF83433;
        Sun, 16 Jul 2023 23:52:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689565980; bh=l67ZnecrBwvru7sroQbzt4TXMdkDx/SLf5ByFyPwj5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FR1cAdmb5lWFb6foG8S5C8Pn+lA3Zv1/53PTdXPl8WTbllTyFltPkjVlyNlZ8+UVi
         m4vt2Erl4GZqTMwIX11/AMeq5qslmvmiVzCLFI0Gny09YITu1BwYU2WcmkxQ367HJp
         j2SXZ2NHaIf76MH9sxCTdhxFbhx63tnOEhx/egbsykgnZE11tBOkDIT6IfUUxLL+KR
         wB4P5pGDfpEtmf6xOuSb3+qVz7K6CZl/Z6Dxe/BOO4V2eIkP/UfLjeh++mb6lFBnR0
         blhC4EEhaGk0ZYnrL6s42Cxw+kBXOB429jvnPk8J8QI9sOytNMmqfob4rFfAwjVdyP
         GsJxHO6V7FE9w==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 05/17] btrfs: add inode encryption contexts
Date:   Sun, 16 Jul 2023 23:52:36 -0400
Message-Id: <0e56221de4fcded2c5150b77657e225a1a733047.1689564024.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1689564024.git.sweettea-kernel@dorminy.me>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

In order to store encryption information for directories, symlinks,
etc., fscrypt stores a context item with each encrypted non-regular
inode. fscrypt provides an arbitrary blob for the filesystem to store,
and it does not clearly fit into an existing structure, so this goes in
a new item type.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/fscrypt.c              | 118 ++++++++++++++++++++++++++++++++
 fs/btrfs/fscrypt.h              |   2 +
 fs/btrfs/inode.c                |  19 +++++
 fs/btrfs/ioctl.c                |   8 ++-
 include/uapi/linux/btrfs_tree.h |  10 +++
 5 files changed, 155 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 3a53dc59c1e4..1dfddf827cf8 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -1,8 +1,126 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/iversion.h>
 #include "ctree.h"
+#include "accessors.h"
+#include "btrfs_inode.h"
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
+		.type = BTRFS_FSCRYPT_CTX_ITEM_KEY,
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
+static void btrfs_fscrypt_update_context(struct btrfs_path *path,
+					 const void *ctx, size_t len)
+{
+	struct extent_buffer *leaf = path->nodes[0];
+	unsigned long ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
+
+	len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
+	write_extent_buffer(leaf, ctx, ptr, len);
+	btrfs_mark_buffer_dirty(leaf);
+}
+
+static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
+				     size_t len, void *fs_data)
+{
+	struct btrfs_path *path;
+	int ret;
+	struct btrfs_trans_handle *trans = fs_data;
+	struct btrfs_key key = {
+		.objectid = btrfs_ino(BTRFS_I(inode)),
+		.type = BTRFS_FSCRYPT_CTX_ITEM_KEY,
+		.offset = 0,
+	};
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	if (!trans)
+		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	ret = btrfs_search_slot(trans, BTRFS_I(inode)->root, &key, path, 0, 1);
+	if (ret == 0) {
+		btrfs_fscrypt_update_context(path, ctx, len);
+		btrfs_free_path(path);
+		return ret;
+	}
+
+	btrfs_free_path(path);
+	if (ret < 0) {
+		btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
+
+	ret = btrfs_insert_item(trans, BTRFS_I(inode)->root, &key, (void *) ctx, len);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
+
+	if (fs_data)
+		return ret;
+
+	BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
+	btrfs_sync_inode_flags_to_i_flags(inode);
+	inode_inc_iversion(inode);
+	inode->i_ctime = current_time(inode);
+	ret = btrfs_update_inode(trans, BTRFS_I(inode)->root, BTRFS_I(inode));
+	if (!ret) {
+		btrfs_end_transaction(trans);
+		return ret;
+	}
+
+	btrfs_abort_transaction(trans, ret);
+	return ret;
+}
+
+static bool btrfs_fscrypt_empty_dir(struct inode *inode)
+{
+	return inode->i_size == BTRFS_EMPTY_DIR_SIZE;
+}
 
 const struct fscrypt_operations btrfs_fscrypt_ops = {
+	.get_context = btrfs_fscrypt_get_context,
+	.set_context = btrfs_fscrypt_set_context,
+	.empty_dir = btrfs_fscrypt_empty_dir,
 	.key_prefix = "btrfs:"
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
index d8484752b905..c9898ac2192c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -62,6 +62,7 @@
 #include "defrag.h"
 #include "dir-item.h"
 #include "file-item.h"
+#include "fscrypt.h"
 #include "uuid-tree.h"
 #include "ioctl.h"
 #include "file.h"
@@ -6203,6 +6204,9 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 	struct inode *inode = args->inode;
 	int ret;
 
+	if (fscrypt_is_nokey_name(args->dentry))
+		return -ENOKEY;
+
 	if (!args->orphan) {
 		ret = fscrypt_setup_filename(dir, &args->dentry->d_name, 0,
 					     &args->fname);
@@ -6236,6 +6240,9 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 	if (dir->i_security)
 		(*trans_num_items)++;
 #endif
+	/* 1 to add fscrypt item, but only for encrypted non-regular files */
+	if (args->encrypt && !S_ISREG(inode->i_mode))
+		(*trans_num_items)++;
 	if (args->orphan) {
 		/* 1 to add orphan item */
 		(*trans_num_items)++;
@@ -6414,6 +6421,11 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 	inode->i_ctime = inode->i_mtime;
 	BTRFS_I(inode)->i_otime = inode->i_mtime;
 
+	if (args->encrypt) {
+		BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
+		btrfs_sync_inode_flags_to_i_flags(inode);
+	}
+
 	/*
 	 * We're going to fill the inode item now, so at this point the inode
 	 * must be fully initialized.
@@ -6488,6 +6500,13 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 			goto discard;
 		}
 	}
+	if (args->encrypt && !S_ISREG(inode->i_mode)) {
+		ret = fscrypt_set_context(inode, trans);
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			goto discard;
+		}
+	}
 
 	inode_tree_add(BTRFS_I(inode));
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a895d105464b..05984e5448b4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -156,6 +156,8 @@ static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
 		iflags |= FS_DIRSYNC_FL;
 	if (flags & BTRFS_INODE_NODATACOW)
 		iflags |= FS_NOCOW_FL;
+	if (flags & BTRFS_INODE_ENCRYPT)
+		iflags |= FS_ENCRYPT_FL;
 	if (ro_flags & BTRFS_INODE_RO_VERITY)
 		iflags |= FS_VERITY_FL;
 
@@ -185,12 +187,14 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (binode->flags & BTRFS_INODE_DIRSYNC)
 		new_fl |= S_DIRSYNC;
+	if (binode->flags & BTRFS_INODE_ENCRYPT)
+		new_fl |= S_ENCRYPTED;
 	if (binode->ro_flags & BTRFS_INODE_RO_VERITY)
 		new_fl |= S_VERITY;
 
 	set_mask_bits(&inode->i_flags,
 		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC |
-		      S_VERITY, new_fl);
+		      S_VERITY | S_ENCRYPTED, new_fl);
 }
 
 /*
@@ -203,7 +207,7 @@ static int check_fsflags(unsigned int old_flags, unsigned int flags)
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
 		      FS_SYNC_FL | FS_DIRSYNC_FL | \
 		      FS_NOCOMP_FL | FS_COMPR_FL |
-		      FS_NOCOW_FL))
+		      FS_NOCOW_FL | FS_ENCRYPT_FL))
 		return -EOPNOTSUPP;
 
 	/* COMPR and NOCOMP on new/old are valid */
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index ab38d0f411fa..029af0aeb65d 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -161,6 +161,8 @@
 #define BTRFS_VERITY_DESC_ITEM_KEY	36
 #define BTRFS_VERITY_MERKLE_ITEM_KEY	37
 
+#define BTRFS_FSCRYPT_CTX_ITEM_KEY	41
+
 #define BTRFS_ORPHAN_ITEM_KEY		48
 /* reserve 2-15 close to the inode for later flexibility */
 
@@ -399,6 +401,7 @@ static inline __u8 btrfs_dir_flags_to_ftype(__u8 flags)
 #define BTRFS_INODE_NOATIME		(1U << 9)
 #define BTRFS_INODE_DIRSYNC		(1U << 10)
 #define BTRFS_INODE_COMPRESS		(1U << 11)
+#define BTRFS_INODE_ENCRYPT	(1U << 12)
 
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1U << 31)
 
@@ -415,6 +418,7 @@ static inline __u8 btrfs_dir_flags_to_ftype(__u8 flags)
 	 BTRFS_INODE_NOATIME |						\
 	 BTRFS_INODE_DIRSYNC |						\
 	 BTRFS_INODE_COMPRESS |						\
+	 BTRFS_INODE_ENCRYPT |						\
 	 BTRFS_INODE_ROOT_ITEM_INIT)
 
 #define BTRFS_INODE_RO_VERITY		(1U << 0)
@@ -1016,6 +1020,12 @@ enum {
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
2.40.1

