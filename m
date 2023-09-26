Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC697AF256
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbjIZSD5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbjIZSDz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:55 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63667BF
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:47 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-773b18cf900so506733685a.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751426; x=1696356226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bqALhv+rQtbM8yoJCJKQcN6vl5pfWsVzXsIxDvCiSdk=;
        b=r3St7zAp9xIDt76AiFO+l0hms3YtLM2lQLCfm1tiF32zqx9+YmsT8+jhgusDMS/7Lj
         YaHoHxWWeH+xiYIG6Mg3EJJ9q/iaq3p/xy1NJ4C00TYfsgeaFJiFGKgpyNCTxxp0nHbU
         Xot2yBY7yN1Ws3wHZ2UgD2Sr/tvUSrAvmWONNh059GVhHNGbfCQNnGHpQ4xWFXwCX5bd
         ZpC9jATbn1PrckloBp+RvLSDzh2WGhnv6g5s3wttza+W1+XwtWDyEbrv5JUjBoPAhPfM
         8lGfKXhEamhbhjaOj7pmGSJmPv3JiNyoL8JMFgwwYiqtVLwL5rn+7FVU1WQFKWL/ZC1w
         IRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751426; x=1696356226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bqALhv+rQtbM8yoJCJKQcN6vl5pfWsVzXsIxDvCiSdk=;
        b=uMHKf/fR+upV35duWFeoN+Y3xoUCTw+0xwtzQmsyHvZ15hEiRL33XH1OHjwN2MwdYw
         CsYjTfM0SX1y80BDlpT7S/6yWQd6dhW3PUQXYB7Boz9dna8o/xGZv+sCQuK8j1XVlCgr
         GKdgskYnPM9t5H0Wq+Zq0Sg3j/rOVg5LuYmOx8jxiftkk0l2Nm8venSxBFsgFAis+Jjp
         jZv0Y/wKfViUv8WrZIiQzJlnyutmuEq8RRlDb6WERKDR3c+U9YI3vn8HToW+qnKMh1eS
         ndB5jND90SiCRXl2gDybumkyglLYmrsaKI8zobGghitwiOnvc0DEG+QBCFpmf9wAbNli
         Eraw==
X-Gm-Message-State: AOJu0YzAX92A8RDgTzl8AyUh2WNszxCTKEJWww/vl903jZBbgu7Zdp3e
        hUsEZZeDaG/sjHeIBC594ramLA==
X-Google-Smtp-Source: AGHT+IHOsnCmLSXsQAIrasctTyBr1q92rLgOAiziVKfb+pAXMfiKg3tNYc/+H+O9voytfYCNQyv0Hg==
X-Received: by 2002:a05:620a:269b:b0:773:cd76:fa37 with SMTP id c27-20020a05620a269b00b00773cd76fa37mr3533760qkp.23.1695751426344;
        Tue, 26 Sep 2023 11:03:46 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id u25-20020ae9c019000000b0076f18be9a64sm2291063qkk.81.2023.09.26.11.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:45 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 29/35] btrfs: implement the fscrypt extent encryption hooks
Date:   Tue, 26 Sep 2023 14:01:55 -0400
Message-ID: <de7dec18d4dd440ebf3c538af5c765d747e1d3ef.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

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
from fscrypt and save it into the file extent item when we create a new
file extent item.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/defrag.c    | 10 ++++++++-
 fs/btrfs/file-item.c | 11 +++++++++-
 fs/btrfs/file-item.h |  5 ++++-
 fs/btrfs/file.c      |  9 +++++++++
 fs/btrfs/fscrypt.c   | 48 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/fscrypt.h   | 31 ++++++++++++++++++++++++++++
 fs/btrfs/inode.c     | 22 +++++++++++++++++++-
 fs/btrfs/tree-log.c  | 10 +++++++++
 8 files changed, 142 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index dde70f358d6f..ec438961eedb 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -16,6 +16,7 @@
 #include "defrag.h"
 #include "file-item.h"
 #include "super.h"
+#include "fscrypt.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
 
@@ -526,9 +527,12 @@ static struct extent_map *defrag_get_extent(struct btrfs_inode *inode,
 	struct btrfs_path path = { 0 };
 	struct extent_map *em;
 	struct btrfs_key key;
+	struct btrfs_fscrypt_ctx ctx;
 	u64 ino = btrfs_ino(inode);
 	int ret;
 
+	ctx.size = 0;
+
 	em = alloc_extent_map();
 	if (!em) {
 		ret = -ENOMEM;
@@ -623,7 +627,7 @@ static struct extent_map *defrag_get_extent(struct btrfs_inode *inode,
 			goto next;
 
 		/* Now this extent covers @start, convert it to em */
-		btrfs_extent_item_to_extent_map(inode, &path, fi, em);
+		btrfs_extent_item_to_extent_map(inode, &path, fi, em, &ctx);
 		break;
 next:
 		ret = btrfs_next_item(root, &path);
@@ -633,6 +637,10 @@ static struct extent_map *defrag_get_extent(struct btrfs_inode *inode,
 			goto not_found;
 	}
 	btrfs_release_path(&path);
+
+	ret = btrfs_fscrypt_load_extent_info(inode, em, &ctx);
+	if (ret)
+		goto err;
 	return em;
 
 not_found:
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 26f35c1baedc..35036fab58c4 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -21,6 +21,7 @@
 #include "accessors.h"
 #include "file-item.h"
 #include "super.h"
+#include "fscrypt.h"
 
 #define __MAX_CSUM_ITEMS(r, size) ((unsigned long)(((BTRFS_LEAF_DATA_SIZE(r) - \
 				   sizeof(struct btrfs_item) * 2) / \
@@ -1264,7 +1265,8 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 				     const struct btrfs_path *path,
 				     struct btrfs_file_extent_item *fi,
-				     struct extent_map *em)
+				     struct extent_map *em,
+				     struct btrfs_fscrypt_ctx *ctx)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_root *root = inode->root;
@@ -1306,6 +1308,13 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 				set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
 		}
 		em->encryption_type = btrfs_file_extent_encryption(leaf, fi);
+		if (em->encryption_type != BTRFS_ENCRYPTION_NONE) {
+			ctx->size =
+				btrfs_file_extent_encryption_ctx_size(leaf, fi);
+			read_extent_buffer(leaf, ctx->ctx,
+				btrfs_file_extent_encryption_ctx_offset(fi),
+				ctx->size);
+		}
 	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
 		em->block_start = EXTENT_MAP_INLINE;
 		em->start = extent_start;
diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
index 04bd2d34efb1..bb79014024bd 100644
--- a/fs/btrfs/file-item.h
+++ b/fs/btrfs/file-item.h
@@ -5,6 +5,8 @@
 
 #include "accessors.h"
 
+struct btrfs_fscrypt_ctx;
+
 #define BTRFS_FILE_EXTENT_INLINE_DATA_START		\
 		(offsetof(struct btrfs_file_extent_item, disk_bytenr))
 
@@ -63,7 +65,8 @@ int btrfs_lookup_csums_bitmap(struct btrfs_root *root, struct btrfs_path *path,
 void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 				     const struct btrfs_path *path,
 				     struct btrfs_file_extent_item *fi,
-				     struct extent_map *em);
+				     struct extent_map *em,
+				     struct btrfs_fscrypt_ctx *ctx);
 int btrfs_inode_clear_file_extent_range(struct btrfs_inode *inode, u64 start,
 					u64 len);
 int btrfs_inode_set_file_extent_range(struct btrfs_inode *inode, u64 start, u64 len);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 70a801b90d13..edd37aa91a02 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -38,6 +38,7 @@
 #include "ioctl.h"
 #include "file.h"
 #include "super.h"
+#include "fscrypt.h"
 
 /* simple helper to fault in pages and copy.  This should go away
  * and be replaced with calls into generic code.
@@ -2276,6 +2277,14 @@ static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_file_extent_num_bytes(leaf, extent, replace_len);
 	if (extent_info->is_new_extent)
 		btrfs_set_file_extent_generation(leaf, extent, trans->transid);
+	if (extent_info->fscrypt_info) {
+		ret = btrfs_fscrypt_save_extent_info(inode, path,
+						     extent_info->fscrypt_info);
+		if (ret) {
+			btrfs_release_path(path);
+			return ret;
+		}
+	}
 	btrfs_mark_buffer_dirty(trans, leaf);
 	btrfs_release_path(path);
 
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 4fe0a8804ac5..7f53bfa621e1 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -214,6 +214,54 @@ static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
 	return devs;
 }
 
+int btrfs_fscrypt_load_extent_info(struct btrfs_inode *inode,
+				   struct extent_map *em,
+				   struct btrfs_fscrypt_ctx *ctx)
+{
+	struct fscrypt_extent_info *info;
+	unsigned long nofs_flag;
+
+	if (ctx->size == 0)
+		return 0;
+
+	nofs_flag = memalloc_nofs_save();
+	info = fscrypt_load_extent_info(&inode->vfs_inode, ctx->ctx, ctx->size);
+	memalloc_nofs_restore(nofs_flag);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+	em->fscrypt_info = info;
+	return 0;
+}
+
+int btrfs_fscrypt_save_extent_info(struct btrfs_inode *inode,
+				   struct btrfs_path *path,
+				   struct fscrypt_extent_info *info)
+{
+	struct btrfs_file_extent_item *ei;
+	u8 ctx[BTRFS_MAX_EXTENT_CTX_SIZE];
+	ssize_t ctx_size;
+
+	ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_file_extent_item);
+
+	ctx_size = fscrypt_set_extent_context(&inode->vfs_inode, info, ctx);
+	if (ctx_size < 0) {
+		btrfs_err_rl(inode->root->fs_info, "invalid encrypt context\n");
+		return (int)ctx_size;
+	}
+	write_extent_buffer(path->nodes[0], ctx,
+			    btrfs_file_extent_encryption_ctx_offset(ei),
+			    ctx_size);
+	btrfs_set_file_extent_encryption_ctx_size(path->nodes[0], ei, ctx_size);
+	return 0;
+}
+
+size_t btrfs_fscrypt_extent_context_size(struct btrfs_inode *inode)
+{
+	return sizeof(struct btrfs_encryption_info) +
+		fscrypt_extent_context_size(&inode->vfs_inode);
+}
+
 const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.get_context = btrfs_fscrypt_get_context,
 	.set_context = btrfs_fscrypt_set_context,
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index c08fd52c99b4..2882a4a9d978 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -8,6 +8,11 @@
 
 #include "fs.h"
 
+struct btrfs_fscrypt_ctx {
+	u8 ctx[BTRFS_MAX_EXTENT_CTX_SIZE];
+	size_t size;
+};
+
 #ifdef CONFIG_FS_ENCRYPTION
 int btrfs_fscrypt_get_disk_name(struct extent_buffer *leaf,
 				struct btrfs_dir_item *di,
@@ -16,8 +21,29 @@ int btrfs_fscrypt_get_disk_name(struct extent_buffer *leaf,
 bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 			      struct extent_buffer *leaf,
 			      unsigned long de_name, u32 de_name_len);
+int btrfs_fscrypt_load_extent_info(struct btrfs_inode *inode,
+				   struct extent_map *em,
+				   struct btrfs_fscrypt_ctx *ctx);
+int btrfs_fscrypt_save_extent_info(struct btrfs_inode *inode,
+				   struct btrfs_path *path,
+				   struct fscrypt_extent_info *fi);
+size_t btrfs_fscrypt_extent_context_size(struct btrfs_inode *inode);
 
 #else
+static inline int btrfs_fscrypt_save_extent_info(struct btrfs_inode *inode,
+						 struct btrfs_path *path,
+						 struct fscrypt_extent_info *fi)
+{
+	return 0;
+}
+
+static inline int btrfs_fscrypt_load_extent_info(struct btrfs_inode *inode,
+						 struct extent_map *em,
+						 struct btrfs_fscrypt_ctx *ctx)
+{
+	return 0;
+}
+
 static inline int btrfs_fscrypt_get_disk_name(struct extent_buffer *leaf,
 					      struct btrfs_dir_item *di,
 					      struct fscrypt_str *qstr)
@@ -35,6 +61,11 @@ static inline bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 	return !memcmp_extent_buffer(leaf, fname->disk_name.name, de_name,
 				     de_name_len);
 }
+
+static inline size_t btrfs_fscrypt_extent_context_size(struct btrfs_inode *inode)
+{
+	return 0;
+}
 #endif /* CONFIG_FS_ENCRYPTION */
 
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ee1ac2718ce3..9414991d6b6b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2904,6 +2904,9 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	size_t fscrypt_context_size = 0;
 	int ret;
 
+	if (btrfs_stack_file_extent_encryption(stack_fi))
+		fscrypt_context_size = btrfs_fscrypt_extent_context_size(inode);
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -2942,6 +2945,12 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 			btrfs_item_ptr_offset(leaf, path->slots[0]),
 			sizeof(struct btrfs_file_extent_item));
 
+	if (fscrypt_context_size) {
+		ret = btrfs_fscrypt_save_extent_info(inode, path, fscrypt_info);
+		if (ret)
+			goto out;
+	}
+
 	btrfs_mark_buffer_dirty(trans, leaf);
 	btrfs_release_path(path);
 
@@ -6866,6 +6875,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	struct btrfs_key found_key;
 	struct extent_map *em = NULL;
 	struct extent_map_tree *em_tree = &inode->extent_tree;
+	struct btrfs_fscrypt_ctx ctx;
 
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, start, len);
@@ -6879,6 +6889,9 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		else
 			goto out;
 	}
+
+	ctx.size = 0;
+
 	em = alloc_extent_map();
 	if (!em) {
 		ret = -ENOMEM;
@@ -6983,7 +6996,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		goto insert;
 	}
 
-	btrfs_extent_item_to_extent_map(inode, path, item, em);
+	btrfs_extent_item_to_extent_map(inode, path, item, em, &ctx);
 
 	if (extent_type == BTRFS_FILE_EXTENT_REG ||
 	    extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
@@ -7028,6 +7041,10 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		goto out;
 	}
 
+	ret = btrfs_fscrypt_load_extent_info(inode, em, &ctx);
+	if (ret)
+		goto out;
+
 	write_lock(&em_tree->lock);
 	ret = btrfs_add_extent_mapping(fs_info, em_tree, &em, start, len);
 	write_unlock(&em_tree->lock);
@@ -9703,6 +9720,9 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 		return trans;
 	}
 
+	if (fscrypt_info)
+		fscrypt_context_size = btrfs_fscrypt_extent_context_size(inode);
+
 	extent_info.disk_offset = start;
 	extent_info.disk_len = len;
 	extent_info.data_offset = 0;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 40dd5c652f0e..5200da6f5be3 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -30,6 +30,7 @@
 #include "file.h"
 #include "orphan.h"
 #include "tree-checker.h"
+#include "fscrypt.h"
 
 #define MAX_CONFLICT_INODES 10
 
@@ -4633,6 +4634,9 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	size_t fscrypt_context_size = 0;
 	u8 encryption = em->encryption_type;
 
+	if (encryption)
+		fscrypt_context_size = btrfs_fscrypt_extent_context_size(inode);
+
 	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
 		btrfs_set_stack_file_extent_type(&fi, BTRFS_FILE_EXTENT_PREALLOC);
@@ -4693,6 +4697,12 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	write_extent_buffer(leaf, &fi,
 			    btrfs_item_ptr_offset(leaf, path->slots[0]),
 			    sizeof(fi));
+	if (fscrypt_context_size) {
+		ret = btrfs_fscrypt_save_extent_info(inode, path,
+						     em->fscrypt_info);
+		if (ret)
+			return ret;
+	}
 	btrfs_mark_buffer_dirty(trans, leaf);
 
 	btrfs_release_path(path);
-- 
2.41.0

