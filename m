Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4052D7743D0
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbjHHSKn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbjHHSKJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:10:09 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D94F160AC7;
        Tue,  8 Aug 2023 10:12:50 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 1A8508343D;
        Tue,  8 Aug 2023 13:12:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514770; bh=fisPgf4IomYDyc/gnfxhQqEMa1WSDEUx0M4E649/8mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVVQGy6Qd/JPl0w0skt1YqXWbVgQg+chHtXCujvFad3kF0rXeyZDlN+zQDBMORG4i
         vv282XboraJUz0p5NKbNCfmwl3CfbVjP83N1QDFLdeP/5iN+gbN8p44U3ZWlcJ7Scf
         CE6B7/zl/iItDqeuKdzM9wpdRMTIrl4yUWmnk3ORTd5/x29FoVTEcLALU6mrBIIGdZ
         qZrJoyVaA4Ic8RH6BGGYXyeozQvbYpW5u+ozV3Y/LCBmG5j2jt6M+gWAklSnadG6fu
         pXNtXQTKFfJBA3mOyZXNzqhyXY0tJUJTRMuhsaR57inP3EbZgaU3VOGDxCgGHFiHVb
         dQflINT/3tHhg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 17/17] btrfs: save and load fscrypt extent contexts
Date:   Tue,  8 Aug 2023 13:12:19 -0400
Message-ID: <3fee78c12452ab3176900d082cb5401dd0ca5b53.1691510179.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691510179.git.sweettea-kernel@dorminy.me>
References: <cover.1691510179.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This change actually saves and loads the extent contexts created and
freed by the last change.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/file-item.c |   7 +++
 fs/btrfs/fscrypt.c   | 108 ++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/fscrypt.h   |  35 ++++++++++++++
 fs/btrfs/inode.c     |  37 +++++++++++++--
 fs/btrfs/tree-log.c  |  14 +++++-
 5 files changed, 194 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index f83f7020ed89..880fb7810152 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -1299,6 +1299,13 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 
 		ctxsize = btrfs_file_extent_ctxsize_from_item(leaf, path);
 		ASSERT(ctxsize == btrfs_file_extent_encryption_ctxsize(leaf, fi));
+
+		if (ctxsize) {
+			unsigned long ptr = (unsigned long)fi->encryption_context;
+			int res = btrfs_fscrypt_load_extent_info(inode, leaf, ptr,
+								 ctxsize, &em->fscrypt_info);
+			ASSERT(res == 0);
+		}
 	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
 		em->block_start = EXTENT_MAP_INLINE;
 		em->start = extent_start;
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 5508cbc6bccb..7324375af0ac 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -75,6 +75,65 @@ bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 	return !memcmp(digest, nokey_name->sha256, sizeof(digest));
 }
 
+int btrfs_fscrypt_fill_extent_context(struct btrfs_inode *inode,
+				      struct fscrypt_info *info,
+				      u8 *context_buffer, size_t *context_len)
+{
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	int ret;
+
+	if (!IS_ENCRYPTED(&inode->vfs_inode))
+		return 0;
+
+
+	ret = fscrypt_set_extent_context(info, context_buffer + sizeof(u32),
+					 FSCRYPT_SET_CONTEXT_MAX_SIZE);
+	if (ret < 0) {
+		btrfs_err(fs_info, "fscrypt context could not be saved");
+		return ret;
+	}
+
+	/* the return value, if nonnegative, is the fscrypt context size */
+	ret += sizeof(u32);
+
+	put_unaligned_le32(ret, context_buffer);
+
+	*context_len = ret;
+	return 0;
+}
+
+int btrfs_fscrypt_load_extent_info(struct btrfs_inode *inode,
+				  struct extent_buffer *leaf,
+				  unsigned long ptr,
+				  u8 ctxsize,
+				  struct fscrypt_info **info_ptr)
+{
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	u8 context[BTRFS_FSCRYPT_EXTENT_CONTEXT_MAX_SIZE];
+	int res;
+	unsigned int nofs_flags;
+	u32 len;
+
+	read_extent_buffer(leaf, context, ptr, ctxsize);
+
+	nofs_flags = memalloc_nofs_save();
+	res = fscrypt_load_extent_info(&inode->vfs_inode,
+				       context + sizeof(u32),
+				       ctxsize - sizeof(u32), info_ptr);
+	memalloc_nofs_restore(nofs_flags);
+
+	if (res)
+		btrfs_err(fs_info, "Unable to load fscrypt info: %d", res);
+
+	len = get_unaligned_le32(context);
+	if (len != ctxsize) {
+		res = -EINVAL;
+		btrfs_err(fs_info, "fscrypt info size mismatches");
+	}
+
+	return res;
+}
+
 static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
 {
 	struct btrfs_key key = {
@@ -138,11 +197,14 @@ static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
 
 	if (!trans)
 		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 1);
-	if (IS_ERR(trans))
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
 		return PTR_ERR(trans);
+	}
 
 	ret = btrfs_search_slot(trans, BTRFS_I(inode)->root, &key, path, 0, 1);
 	if (ret < 0) {
+		btrfs_free_path(path);
 		btrfs_abort_transaction(trans, ret);
 		return ret;
 	}
@@ -151,12 +213,13 @@ static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
 		btrfs_release_path(path);
 		ret = btrfs_insert_empty_item(trans, BTRFS_I(inode)->root, path, &key, len);
 		if (ret) {
+			btrfs_free_path(path);
 			btrfs_abort_transaction(trans, ret);
 			return ret;
 		}
 	}
-
 	btrfs_fscrypt_update_context(path, ctx, len);
+	btrfs_free_path(path);
 
 	if (fs_data)
 		return ret;
@@ -166,6 +229,7 @@ static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
 	inode_inc_iversion(inode);
 	inode->i_ctime = current_time(inode);
 	ret = btrfs_update_inode(trans, BTRFS_I(inode)->root, BTRFS_I(inode));
+
 	if (!ret) {
 		btrfs_end_transaction(trans);
 		return ret;
@@ -181,6 +245,45 @@ static bool btrfs_fscrypt_empty_dir(struct inode *inode)
 	return inode->i_size == BTRFS_EMPTY_DIR_SIZE;
 }
 
+int btrfs_fscrypt_get_extent_info(const struct inode *inode,
+				  u64 lblk_num,
+				  struct fscrypt_info **info_ptr,
+				  u64 *extent_offset,
+				  u64 *extent_length)
+{
+	u64 offset = lblk_num << inode->i_blkbits;
+	struct extent_map *em;
+
+	/* Since IO must be in progress on this extent, this must succeed */
+	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, offset, PAGE_SIZE);
+	if (!em) {
+		btrfs_err(BTRFS_I(inode)->root->fs_info,
+			  "extent context requested for block %llu of inode %lu without an extent",
+			  lblk_num, inode->i_ino);
+		return -EINVAL;
+	}
+
+	if (em->block_start == EXTENT_MAP_HOLE) {
+		btrfs_info(BTRFS_I(inode)->root->fs_info,
+			   "extent context requested for block %llu of inode %lu without an extent",
+			   lblk_num, inode->i_ino);
+		free_extent_map(em);
+		return -ENOENT;
+	}
+
+	*info_ptr = em->fscrypt_info;
+
+	if (extent_offset)
+		*extent_offset
+			 = (offset - em->orig_start) >> inode->i_blkbits;
+
+	if (extent_length)
+		*extent_length = em->len >> inode->i_blkbits;
+
+	free_extent_map(em);
+	return 0;
+}
+
 static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
 						       unsigned int *num_devs)
 {
@@ -232,6 +335,7 @@ const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.get_context = btrfs_fscrypt_get_context,
 	.set_context = btrfs_fscrypt_set_context,
 	.empty_dir = btrfs_fscrypt_empty_dir,
+	.get_extent_info = btrfs_fscrypt_get_extent_info,
 	.get_devices = btrfs_fscrypt_get_devices,
 	.key_prefix = "btrfs:"
 };
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 26627df9d5f9..46d003b0e4c3 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -9,6 +9,9 @@
 
 #include "fs.h"
 
+#define BTRFS_FSCRYPT_EXTENT_CONTEXT_MAX_SIZE \
+	(sizeof(u32) + FSCRYPT_SET_CONTEXT_MAX_SIZE)
+
 static inline u32
 btrfs_file_extent_encryption_ctxsize(const struct extent_buffer *eb,
 				     struct btrfs_file_extent_item *e)
@@ -38,6 +41,15 @@ bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 			      struct extent_buffer *leaf,
 			      unsigned long de_name, u32 de_name_len);
 
+int btrfs_fscrypt_fill_extent_context(struct btrfs_inode *inode,
+				      struct fscrypt_info *info,
+				      u8 *context_buffer, size_t *context_len);
+
+int btrfs_fscrypt_load_extent_info(struct btrfs_inode *inode,
+				   struct extent_buffer *leaf,
+				   unsigned long ptr, u8 ctxsize,
+				   struct fscrypt_info **info_ptr);
+
 #else
 static inline int btrfs_fscrypt_get_disk_name(struct extent_buffer *leaf,
 					      struct btrfs_dir_item *di,
@@ -56,8 +68,31 @@ static inline bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 	return !memcmp_extent_buffer(leaf, fname->disk_name.name, de_name,
 				     de_name_len);
 }
+
+static inline int btrfs_fscrypt_fill_extent_context(struct btrfs_inode *inode,
+						    struct fscrypt_info *info,
+						    u8 *context_buffer,
+						    size_t *context_len)
+{
+	return -EINVAL;
+}
+
+static inline int btrfs_fscrypt_load_extent_info(struct btrfs_inode *inode,
+						 struct extent_buffer *leaf,
+						 unsigned long ptr,
+						 u8 ctxsize,
+						 struct fscrypt_info **info_ptr)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_FS_ENCRYPTION */
 
+int btrfs_fscrypt_get_extent_info(const struct inode *inode,
+				  u64 lblk_num,
+				  struct fscrypt_info **info_ptr,
+				  u64 *extent_offset,
+				  u64 *extent_length);
 void btrfs_fscrypt_copy_fscrypt_info(struct btrfs_inode *inode,
 				     struct fscrypt_info *from,
 				     struct fscrypt_info **to_ptr);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index de6778fe65c8..de9e7073017f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2885,17 +2885,41 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	u64 num_bytes = btrfs_stack_file_extent_num_bytes(stack_fi);
 	u64 ram_bytes = btrfs_stack_file_extent_ram_bytes(stack_fi);
 	struct btrfs_drop_extents_args drop_args = { 0 };
-	size_t fscrypt_context_size =
-		btrfs_stack_file_extent_encryption(stack_fi) ?
-			FSCRYPT_SET_CONTEXT_MAX_SIZE : 0;
+	size_t fscrypt_context_size = 0;
+	u8 context[BTRFS_FSCRYPT_EXTENT_CONTEXT_MAX_SIZE];
+	u8 encryption = 0;
+
 	int ret;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
+	if (IS_ENCRYPTED(&inode->vfs_inode)) {
+		struct fscrypt_info *fscrypt_info;
+		u64 lblk_num = file_pos >> root->fs_info->sectorsize_bits;
+
+		ret = btrfs_fscrypt_get_extent_info(&inode->vfs_inode,
+						    lblk_num, &fscrypt_info,
+						    NULL, NULL);
+		if (ret) {
+			btrfs_err(root->fs_info, "No fscrypt context found");
+			goto out;
+		}
+
+		ret = btrfs_fscrypt_fill_extent_context(inode, fscrypt_info,
+							context,
+							&fscrypt_context_size);
+		if (ret)
+			goto out;
+		encryption = BTRFS_ENCRYPTION_FSCRYPT;
+
+	}
+
+	btrfs_set_stack_file_extent_encryption(stack_fi, encryption);
+
 	/*
-	 * we may be replacing one extent in the tree with another.
+	 * We may be replacing one extent in the tree with another.
 	 * The new extent is pinned in the extent map, and we don't want
 	 * to drop it from the cache until it is completely in the btree.
 	 *
@@ -2928,6 +2952,11 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 			btrfs_item_ptr_offset(leaf, path->slots[0]),
 			sizeof(struct btrfs_file_extent_item));
 
+	write_extent_buffer(leaf, context,
+			    btrfs_item_ptr_offset(leaf, path->slots[0]) +
+			    sizeof(struct btrfs_file_extent_item),
+			    fscrypt_context_size);
+
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 49001bf8a0b2..28b86e338434 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -22,6 +22,7 @@
 #include "zoned.h"
 #include "inode-item.h"
 #include "fs.h"
+#include "fscrypt.h"
 #include "accessors.h"
 #include "extent-tree.h"
 #include "root-tree.h"
@@ -4637,6 +4638,14 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	size_t fscrypt_context_size = 0;
 	u8 encryption = IS_ENCRYPTED(&inode->vfs_inode) ?
 				BTRFS_ENCRYPTION_FSCRYPT : 0;
+	u8 context[BTRFS_FSCRYPT_EXTENT_CONTEXT_MAX_SIZE];
+
+	ret = btrfs_fscrypt_fill_extent_context(inode, em->fscrypt_info,
+						context, &fscrypt_context_size);
+	if (ret)
+		return ret;
+
+	btrfs_set_stack_file_extent_encryption(&fi, encryption);
 
 	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
@@ -4658,7 +4667,6 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_file_extent_num_bytes(&fi, em->len);
 	btrfs_set_stack_file_extent_ram_bytes(&fi, em->ram_bytes);
 	btrfs_set_stack_file_extent_compression(&fi, em->compress_type);
-	btrfs_set_stack_file_extent_encryption(&fi, encryption);
 
 	ret = log_extent_csums(trans, inode, log, em, ctx);
 	if (ret)
@@ -4698,6 +4706,10 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	write_extent_buffer(leaf, &fi,
 			    btrfs_item_ptr_offset(leaf, path->slots[0]),
 			    sizeof(fi));
+	write_extent_buffer(leaf, context,
+			    btrfs_item_ptr_offset(leaf, path->slots[0]) +
+			    sizeof(fi), fscrypt_context_size);
+
 	btrfs_mark_buffer_dirty(leaf);
 
 	btrfs_release_path(path);
-- 
2.41.0

