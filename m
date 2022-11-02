Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCC3616233
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 12:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiKBLye (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 07:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiKBLyC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 07:54:02 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E1F201A3;
        Wed,  2 Nov 2022 04:53:59 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 2A52881480;
        Wed,  2 Nov 2022 07:53:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1667390009; bh=7fOhas0Zw+Lw5PCP09Cn8+AreZCFZtN1wZw2X9qs2hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DwGeozDbxMfy+rZkP5tuGBD3dGg0N9GThxipF4tVrkbJfQQm4ocjpK1pl4ucuc9K6
         8G2fl/YeOg7UM5O33f8G2QEK57uVU6VbTUPLb4eYh0kyBSKYK8ZzzEZ9j/FqptqpX3
         GtZ5tHujGffUHexMRvypkhZib1SL0KbT7uIFY+rF5rKIjLIDqeRTH0Ba35OtZNnE1p
         VUr/HsX+ern4QjwL3n13qn5xn51VcKwxlHstWWcAzr+HPSbZBU80yXx44EjMF2qVnS
         C4V/oqFw7OxmpMzW50KTzzFAQdkcMQGIkyEi96o53G7eWBTE9pevSrc0zAeq2FmT0k
         P/7G8jXO5YJdw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v5 11/18] btrfs: store a fscrypt extent context per normal file extent
Date:   Wed,  2 Nov 2022 07:53:00 -0400
Message-Id: <bccadb3a4fa622d532be2476e25002caf91cfcb7.1667389115.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1667389115.git.sweettea-kernel@dorminy.me>
References: <cover.1667389115.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

In order to encrypt data, each file extent must have its own persistent
fscrypt_extent_context, which is then provided to fscrypt upon request.
This is only needed for encrypted extents and is of variable size on
disk, so file extents must additionally keep track of their actual
length.

This puts the long-preserved 1-byte encryption field to work. Right now we
don't anticipate very many encryption policies, so 2 bits should be
ample; similarly right now we can't imagine a extent context larger than
fscrypt's current inode contexts, which are 40 bytes, so 6 bits is ample
to store the extent context's size; and therefore we can pack these
together into the one-byte encryption field without touching other space
reserved for future use.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/accessors.h            | 29 +++++++++++
 fs/btrfs/ctree.h                |  3 ++
 fs/btrfs/extent_map.c           |  7 +++
 fs/btrfs/extent_map.h           |  4 ++
 fs/btrfs/file-item.c            | 16 ++++++
 fs/btrfs/file.c                 |  4 +-
 fs/btrfs/fscrypt.c              | 22 ++++++++
 fs/btrfs/fscrypt.h              | 35 +++++++++++++
 fs/btrfs/inode.c                | 90 ++++++++++++++++++++++++++-------
 fs/btrfs/ordered-data.c         | 11 +++-
 fs/btrfs/ordered-data.h         |  4 +-
 fs/btrfs/reflink.c              |  1 +
 fs/btrfs/tree-checker.c         | 37 +++++++++++---
 fs/btrfs/tree-log.c             | 13 ++++-
 include/uapi/linux/btrfs_tree.h |  9 ++++
 15 files changed, 252 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
index cb59b69d2af1..8cc06c2abb6a 100644
--- a/fs/btrfs/accessors.h
+++ b/fs/btrfs/accessors.h
@@ -944,6 +944,16 @@ BTRFS_SETGET_STACK_FUNCS(stack_file_extent_disk_num_bytes,
 			 struct btrfs_file_extent_item, disk_num_bytes, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_compression,
 			 struct btrfs_file_extent_item, compression, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_file_extent_encryption,
+			 struct btrfs_file_extent_item, encryption, 8);
+static inline u8 btrfs_stack_file_extent_encryption_ctxsize(
+	struct btrfs_file_extent_item *e)
+{
+	u8 ctxsize;
+
+	btrfs_unpack_encryption(e->encryption, NULL, &ctxsize);
+	return ctxsize;
+}
 
 static inline unsigned long btrfs_file_extent_inline_start(
 				const struct btrfs_file_extent_item *e)
@@ -976,6 +986,25 @@ BTRFS_SETGET_FUNCS(file_extent_encryption, struct btrfs_file_extent_item,
 BTRFS_SETGET_FUNCS(file_extent_other_encoding, struct btrfs_file_extent_item,
 		   other_encoding, 16);
 
+static inline u8
+btrfs_file_extent_encryption_ctxsize(const struct extent_buffer *eb,
+				     struct btrfs_file_extent_item *e)
+{
+	u8 ctxsize;
+
+	btrfs_unpack_encryption(btrfs_file_extent_encryption(eb, e),
+				NULL, &ctxsize);
+	return ctxsize;
+}
+
+static inline u8
+btrfs_file_extent_ctxsize_from_item(const struct extent_buffer *leaf,
+				    const struct btrfs_path *path)
+{
+	return (btrfs_item_size(leaf, path->slots[0]) -
+		sizeof(struct btrfs_file_extent_item));
+}
+
 /*
  * Returns the number of bytes used by the item on disk, minus the size of any
  * extent headers.  If a file is compressed on disk, this is the compressed
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index be628dd3ecd4..79d1e5d41209 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -38,6 +38,7 @@
 #include "locking.h"
 #include "misc.h"
 #include "fs.h"
+#include "fscrypt.h"
 
 struct btrfs_trans_handle;
 struct btrfs_transaction;
@@ -348,6 +349,8 @@ struct btrfs_replace_extent_info {
 	u64 file_offset;
 	/* Pointer to a file extent item of type regular or prealloc. */
 	char *extent_buf;
+	/* The length of @extent_buf */
+	u32 extent_buf_size;
 	/*
 	 * Set to true when attempting to replace a file range with a new extent
 	 * described by this structure, set to false when attempting to clone an
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 4a4362f5cc52..849c253650cb 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -207,6 +207,13 @@ static int mergable_maps(struct extent_map *prev, struct extent_map *next)
 	if (!list_empty(&prev->list) || !list_empty(&next->list))
 		return 0;
 
+	/*
+	 * Don't merge adjacent maps with different fscrypt_contexts.
+	 */
+	if (!memcmp(&prev->fscrypt_context, &next->fscrypt_context,
+		    sizeof(next->fscrypt_context)))
+		return 0;
+
 	ASSERT(next->block_start != EXTENT_MAP_DELALLOC &&
 	       prev->block_start != EXTENT_MAP_DELALLOC);
 
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 68d3f2c9ea1d..3fa70d6b4750 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -5,6 +5,7 @@
 
 #include <linux/rbtree.h>
 #include <linux/refcount.h>
+#include "fscrypt.h"
 
 #define EXTENT_MAP_LAST_BYTE ((u64)-4)
 #define EXTENT_MAP_HOLE ((u64)-3)
@@ -27,6 +28,8 @@ enum {
 	EXTENT_FLAG_FS_MAPPING,
 	/* This em is merged from two or more physically adjacent ems */
 	EXTENT_FLAG_MERGED,
+	/* This em has a fscrypt extent context */
+	EXTENT_FLAG_ENCRYPTED,
 };
 
 struct extent_map {
@@ -50,6 +53,7 @@ struct extent_map {
 	 */
 	u64 generation;
 	unsigned long flags;
+	struct btrfs_fscrypt_extent_context fscrypt_context;
 	/* Used for chunk mappings, flag EXTENT_FLAG_FS_MAPPING must be set */
 	struct map_lookup *map_lookup;
 	refcount_t refs;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 456f71b42a9c..36b7e2a8d698 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -1233,6 +1233,7 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 	em->generation = btrfs_file_extent_generation(leaf, fi);
 	if (type == BTRFS_FILE_EXTENT_REG ||
 	    type == BTRFS_FILE_EXTENT_PREALLOC) {
+		u8 ctxsize;
 		em->start = extent_start;
 		em->len = extent_end - extent_start;
 		em->orig_start = extent_start -
@@ -1248,6 +1249,10 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 			em->compress_type = compress_type;
 			em->block_start = bytenr;
 			em->block_len = em->orig_block_len;
+		} else if (btrfs_file_extent_encryption(leaf, fi)) {
+			set_bit(EXTENT_FLAG_ENCRYPTED, &em->flags);
+			em->block_start = bytenr;
+			em->block_len = em->orig_block_len;
 		} else {
 			bytenr += btrfs_file_extent_offset(leaf, fi);
 			em->block_start = bytenr;
@@ -1255,6 +1260,17 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 			if (type == BTRFS_FILE_EXTENT_PREALLOC)
 				set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
 		}
+
+		ctxsize = btrfs_file_extent_ctxsize_from_item(leaf, path);
+		ASSERT(ctxsize == btrfs_file_extent_encryption_ctxsize(leaf, fi));
+
+#ifdef CONFIG_FS_ENCRYPTION
+		em->fscrypt_context.len = ctxsize;
+
+		read_extent_buffer(leaf, em->fscrypt_context.buffer,
+				   (unsigned long)fi->fscrypt_context,
+				   ctxsize);
+#endif /* CONFIG_FS_ENCRYPTION */
 	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
 		em->block_start = EXTENT_MAP_INLINE;
 		em->start = extent_start;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2a9808f0c012..2d9c001c63aa 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2246,14 +2246,14 @@ static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = extent_info->file_offset;
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
-				      sizeof(struct btrfs_file_extent_item));
+				      extent_info->extent_buf_size);
 	if (ret)
 		return ret;
 	leaf = path->nodes[0];
 	slot = path->slots[0];
 	write_extent_buffer(leaf, extent_info->extent_buf,
 			    btrfs_item_ptr_offset(leaf, slot),
-			    sizeof(struct btrfs_file_extent_item));
+			    extent_info->extent_buf_size);
 	extent = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
 	ASSERT(btrfs_file_extent_type(leaf, extent) != BTRFS_FILE_EXTENT_INLINE);
 	btrfs_set_file_extent_offset(leaf, extent, extent_info->data_offset);
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index babaa0fffed4..2c9f2d84b539 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -10,6 +10,7 @@
 #include "messages.h"
 #include "transaction.h"
 #include "xattr.h"
+#include "fscrypt.h"
 
 static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
 {
@@ -183,9 +184,30 @@ static bool btrfs_fscrypt_empty_dir(struct inode *inode)
 	return inode->i_size == BTRFS_EMPTY_DIR_SIZE;
 }
 
+static int btrfs_fscrypt_get_extent_context(const struct inode *inode,
+					    u64 lblk_num, void *ctx,
+					    size_t len,
+					    size_t *extent_offset,
+					    size_t *extent_length)
+{
+	return len;
+}
+
+static int btrfs_fscrypt_set_extent_context(void *extent, void *ctx,
+					    size_t len)
+{
+	struct btrfs_fscrypt_extent_context *extent_context = extent;
+
+	memcpy(extent_context->buffer, ctx, len);
+	extent_context->len = len;
+	return 0;
+}
+
 const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.key_prefix = "btrfs:",
 	.get_context = btrfs_fscrypt_get_context,
 	.set_context = btrfs_fscrypt_set_context,
 	.empty_dir = btrfs_fscrypt_empty_dir,
+	.get_extent_context = btrfs_fscrypt_get_extent_context,
+	.set_extent_context = btrfs_fscrypt_set_extent_context,
 };
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 7f4e6888bd43..86dc0e0b91b9 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -5,6 +5,41 @@
 
 #include <linux/fscrypt.h>
 
+#define BTRFS_ENCRYPTION_POLICY_BITS 2
+#define BTRFS_ENCRYPTION_CTXSIZE_BITS 6
+
+#define BTRFS_ENCRYPTION_POLICY_MASK ((1 << BTRFS_ENCRYPTION_POLICY_BITS) - 1)
+#define BTRFS_ENCRYPTION_CTXSIZE_MASK \
+	(((1 << BTRFS_ENCRYPTION_CTXSIZE_BITS) - 1) << \
+		BTRFS_ENCRYPTION_POLICY_BITS)
+
+#ifdef CONFIG_FS_ENCRYPTION
+struct btrfs_fscrypt_extent_context {
+	u8 buffer[FSCRYPT_EXTENT_CONTEXT_MAX_SIZE];
+	u8 len;
+};
+#else
+struct btrfs_fscrypt_extent_context {
+	u8 len;
+};
+#endif
+
+static inline void btrfs_unpack_encryption(u8 encryption,
+					   u8 *policy,
+					   u8 *ctxsize)
+{
+	if (policy)
+		*policy = encryption & BTRFS_ENCRYPTION_POLICY_MASK;
+	if (ctxsize)
+		*ctxsize = ((encryption & BTRFS_ENCRYPTION_CTXSIZE_MASK) >>
+			    BTRFS_ENCRYPTION_POLICY_BITS);
+}
+
+static inline u8 btrfs_pack_encryption(u8 policy, u8 ctxsize)
+{
+	return policy | (ctxsize << BTRFS_ENCRYPTION_POLICY_BITS);
+}
+
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
 
 #endif /* BTRFS_FSCRYPT_H */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1be0b53abc83..332900b41488 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1051,7 +1051,6 @@ static int submit_one_async_extent(struct btrfs_inode *inode,
 		ret = PTR_ERR(em);
 		goto out_free_reserve;
 	}
-	free_extent_map(em);
 
 	ret = btrfs_add_ordered_extent(inode, start,		/* file_offset */
 				       async_extent->ram_size,	/* num_bytes */
@@ -1060,7 +1059,9 @@ static int submit_one_async_extent(struct btrfs_inode *inode,
 				       ins.offset,		/* disk_num_bytes */
 				       0,			/* offset */
 				       1 << BTRFS_ORDERED_COMPRESSED,
-				       async_extent->compress_type);
+				       async_extent->compress_type,
+				       &em->fscrypt_context);
+	free_extent_map(em);
 	if (ret) {
 		btrfs_drop_extent_map_range(inode, start, end, false);
 		goto out_free_reserve;
@@ -1332,12 +1333,13 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 			ret = PTR_ERR(em);
 			goto out_reserve;
 		}
-		free_extent_map(em);
 
 		ret = btrfs_add_ordered_extent(inode, start, ram_size, ram_size,
 					       ins.objectid, cur_alloc_size, 0,
 					       1 << BTRFS_ORDERED_REGULAR,
-					       BTRFS_COMPRESS_NONE);
+					       BTRFS_COMPRESS_NONE,
+					       &em->fscrypt_context);
+		free_extent_map(em);
 		if (ret)
 			goto out_drop_extent_cache;
 
@@ -2131,14 +2133,15 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 				ret = PTR_ERR(em);
 				goto error;
 			}
-			free_extent_map(em);
 			ret = btrfs_add_ordered_extent(inode,
 					cur_offset, nocow_args.num_bytes,
 					nocow_args.num_bytes,
 					nocow_args.disk_bytenr,
 					nocow_args.num_bytes, 0,
 					1 << BTRFS_ORDERED_PREALLOC,
-					BTRFS_COMPRESS_NONE);
+					BTRFS_COMPRESS_NONE,
+					&em->fscrypt_context);
+			free_extent_map(em);
 			if (ret) {
 				btrfs_drop_extent_map_range(inode, cur_offset,
 							    nocow_end, false);
@@ -2152,7 +2155,8 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 						       nocow_args.num_bytes,
 						       0,
 						       1 << BTRFS_ORDERED_NOCOW,
-						       BTRFS_COMPRESS_NONE);
+						       BTRFS_COMPRESS_NONE,
+						       NULL);
 			if (ret)
 				goto error;
 		}
@@ -3084,6 +3088,7 @@ int btrfs_writepage_cow_fixup(struct page *page)
 static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				       struct btrfs_inode *inode, u64 file_pos,
 				       struct btrfs_file_extent_item *stack_fi,
+				       struct btrfs_fscrypt_extent_context *fscrypt_context,
 				       const bool update_inode_bytes,
 				       u64 qgroup_reserved)
 {
@@ -3098,6 +3103,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	u64 num_bytes = btrfs_stack_file_extent_num_bytes(stack_fi);
 	u64 ram_bytes = btrfs_stack_file_extent_ram_bytes(stack_fi);
 	struct btrfs_drop_extents_args drop_args = { 0 };
+	size_t context_len = fscrypt_context ? fscrypt_context->len : 0;
 	int ret;
 
 	path = btrfs_alloc_path();
@@ -3117,7 +3123,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	drop_args.start = file_pos;
 	drop_args.end = file_pos + num_bytes;
 	drop_args.replace_extent = true;
-	drop_args.extent_item_size = sizeof(*stack_fi);
+	drop_args.extent_item_size = sizeof(*stack_fi) + context_len;
 	ret = btrfs_drop_extents(trans, root, inode, &drop_args);
 	if (ret)
 		goto out;
@@ -3128,7 +3134,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 		ins.type = BTRFS_EXTENT_DATA_KEY;
 
 		ret = btrfs_insert_empty_item(trans, root, path, &ins,
-					      sizeof(*stack_fi));
+					      sizeof(*stack_fi) + context_len);
 		if (ret)
 			goto out;
 	}
@@ -3137,6 +3143,13 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	write_extent_buffer(leaf, stack_fi,
 			btrfs_item_ptr_offset(leaf, path->slots[0]),
 			sizeof(struct btrfs_file_extent_item));
+#ifdef CONFIG_FS_ENCRYPTION
+	if (context_len)
+		write_extent_buffer(leaf, fscrypt_context->buffer,
+				btrfs_item_ptr_offset(leaf, path->slots[0]) +
+				sizeof(struct btrfs_file_extent_item),
+				context_len);
+#endif /* CONFIG_FS_ENCRYPTION */
 
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
@@ -3213,7 +3226,12 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_file_extent_num_bytes(&stack_fi, num_bytes);
 	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, ram_bytes);
 	btrfs_set_stack_file_extent_compression(&stack_fi, oe->compress_type);
-	/* Encryption and other encoding is reserved and all 0 */
+	if (IS_ENCRYPTED(oe->inode)) {
+		u8 encryption = btrfs_pack_encryption(BTRFS_ENCRYPTION_FSCRYPT,
+					oe->fscrypt_context.len);
+		btrfs_set_stack_file_extent_encryption(&stack_fi, encryption);
+	}
+	/* Other encoding is reserved and always 0 */
 
 	/*
 	 * For delalloc, when completing an ordered extent we update the inode's
@@ -3227,6 +3245,7 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
 
 	return insert_reserved_file_extent(trans, BTRFS_I(oe->inode),
 					   oe->file_offset, &stack_fi,
+					   &oe->fscrypt_context,
 					   update_inode_bytes, oe->qgroup_rsv);
 }
 
@@ -7133,8 +7152,24 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 
 	btrfs_extent_item_to_extent_map(inode, path, item, em);
 
-	if (extent_type == BTRFS_FILE_EXTENT_REG ||
-	    extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
+	if (extent_type == BTRFS_FILE_EXTENT_REG) {
+		u8 item_ctxsize = btrfs_file_extent_ctxsize_from_item(leaf, path);
+		u8 encryption = btrfs_file_extent_encryption(leaf, item);
+		u8 policy, ctxsize;
+
+		btrfs_unpack_encryption(encryption, &policy, &ctxsize);
+
+		if (policy == BTRFS_ENCRYPTION_FSCRYPT) {
+			if (ctxsize != item_ctxsize) {
+				btrfs_crit(fs_info,
+					"invalid encryption context size for inode %llu: itemsize %d item %d",
+					btrfs_ino(inode), ctxsize, item_ctxsize);
+				ret = -EUCLEAN;
+				goto out;
+			}
+		}
+		goto insert;
+	} else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		goto insert;
 	} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 		/*
@@ -7216,7 +7251,8 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
 				       block_len, 0,
 				       (1 << type) |
 				       (1 << BTRFS_ORDERED_DIRECT),
-				       BTRFS_COMPRESS_NONE);
+				       BTRFS_COMPRESS_NONE,
+				       em ? &em->fscrypt_context : NULL);
 	if (ret) {
 		if (em) {
 			free_extent_map(em);
@@ -7491,6 +7527,7 @@ static struct extent_map *create_io_em(struct btrfs_inode *inode, u64 start,
 				       int type)
 {
 	struct extent_map *em;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	int ret;
 
 	ASSERT(type == BTRFS_ORDERED_PREALLOC ||
@@ -7518,6 +7555,16 @@ static struct extent_map *create_io_em(struct btrfs_inode *inode, u64 start,
 		em->compress_type = compress_type;
 	}
 
+	if (IS_ENCRYPTED(&inode->vfs_inode)) {
+		u64 lblk = em->start >> fs_info->sectorsize_bits;
+		ret = fscrypt_set_extent_context(&inode->vfs_inode, lblk,
+						 &em->fscrypt_context);
+		if (ret < 0) {
+			free_extent_map(em);
+			return ERR_PTR(ret);
+		}
+	}
+
 	ret = btrfs_replace_extent_map_range(inode, em, true);
 	if (ret) {
 		free_extent_map(em);
@@ -9847,6 +9894,7 @@ static int btrfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	struct extent_buffer *leaf;
 	struct fscrypt_str disk_link;
 	u32 name_len = strlen(symname);
+	u8 encryption;
 
 	/*
 	 * fscrypt sets disk_link.len to be len + 1, including a NUL terminator, but we
@@ -9994,16 +10042,18 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	btrfs_set_stack_file_extent_num_bytes(&stack_fi, len);
 	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, len);
 	btrfs_set_stack_file_extent_compression(&stack_fi, BTRFS_COMPRESS_NONE);
-	/* Encryption and other encoding is reserved and all 0 */
+	btrfs_set_stack_file_extent_encryption(&stack_fi,
+					       BTRFS_ENCRYPTION_NONE);
+	/* Other encoding is reserved and always 0 */
 
 	qgroup_released = btrfs_qgroup_release_data(inode, file_offset, len);
 	if (qgroup_released < 0)
 		return ERR_PTR(qgroup_released);
 
 	if (trans) {
-		ret = insert_reserved_file_extent(trans, inode,
-						  file_offset, &stack_fi,
-						  true, qgroup_released);
+		ret = insert_reserved_file_extent(trans, inode, file_offset,
+						  &stack_fi, NULL, true,
+						  qgroup_released);
 		if (ret)
 			goto free_qgroup;
 		return trans;
@@ -10015,6 +10065,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	extent_info.data_len = len;
 	extent_info.file_offset = file_offset;
 	extent_info.extent_buf = (char *)&stack_fi;
+	extent_info.extent_buf_size = sizeof(stack_fi);
 	extent_info.is_new_extent = true;
 	extent_info.update_times = true;
 	extent_info.qgroup_reserved = qgroup_released;
@@ -10945,14 +10996,15 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 		ret = PTR_ERR(em);
 		goto out_free_reserved;
 	}
-	free_extent_map(em);
 
 	ret = btrfs_add_ordered_extent(inode, start, num_bytes, ram_bytes,
 				       ins.objectid, ins.offset,
 				       encoded->unencoded_offset,
 				       (1 << BTRFS_ORDERED_ENCODED) |
 				       (1 << BTRFS_ORDERED_COMPRESSED),
-				       compression);
+				       compression,
+				       &em->fscrypt_context);
+	free_extent_map(em);
 	if (ret) {
 		btrfs_drop_extent_map_range(inode, start, end, false);
 		goto out_free_reserved;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 8fda1949b71b..c5df41843cce 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -167,7 +167,8 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
 int btrfs_add_ordered_extent(struct btrfs_inode *inode, u64 file_offset,
 			     u64 num_bytes, u64 ram_bytes, u64 disk_bytenr,
 			     u64 disk_num_bytes, u64 offset, unsigned flags,
-			     int compress_type)
+			     int compress_type,
+			     struct btrfs_fscrypt_extent_context *fscrypt_context)
 {
 	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -202,6 +203,11 @@ int btrfs_add_ordered_extent(struct btrfs_inode *inode, u64 file_offset,
 	entry->disk_bytenr = disk_bytenr;
 	entry->disk_num_bytes = disk_num_bytes;
 	entry->offset = offset;
+#ifdef CONFIG_FS_ENCRYPTION
+	if (fscrypt_context && fscrypt_context->len)
+		memcpy(&entry->fscrypt_context, fscrypt_context,
+		       sizeof(*fscrypt_context));
+#endif /* CONFIG_FS_ENCRYPTION */
 	entry->bytes_left = num_bytes;
 	entry->inode = igrab(&inode->vfs_inode);
 	entry->compress_type = compress_type;
@@ -1110,7 +1116,8 @@ static int clone_ordered_extent(struct btrfs_ordered_extent *ordered, u64 pos,
 	WARN_ON_ONCE(flags & (1 << BTRFS_ORDERED_COMPRESSED));
 	return btrfs_add_ordered_extent(BTRFS_I(inode), file_offset, len, len,
 					disk_bytenr, len, 0, flags,
-					ordered->compress_type);
+					ordered->compress_type,
+					&ordered->fscrypt_context);
 }
 
 int btrfs_split_ordered_extent(struct btrfs_ordered_extent *ordered, u64 pre,
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 89f82b78f590..a25c63dea8e0 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -99,6 +99,7 @@ struct btrfs_ordered_extent {
 	u64 disk_bytenr;
 	u64 disk_num_bytes;
 	u64 offset;
+	struct btrfs_fscrypt_extent_context fscrypt_context;
 
 	/* number of bytes that still need writing */
 	u64 bytes_left;
@@ -182,7 +183,8 @@ bool btrfs_dec_test_ordered_pending(struct btrfs_inode *inode,
 int btrfs_add_ordered_extent(struct btrfs_inode *inode, u64 file_offset,
 			     u64 num_bytes, u64 ram_bytes, u64 disk_bytenr,
 			     u64 disk_num_bytes, u64 offset, unsigned flags,
-			     int compress_type);
+			     int compress_type,
+			     struct btrfs_fscrypt_extent_context *fscrypt_context);
 void btrfs_add_ordered_sum(struct btrfs_ordered_extent *entry,
 			   struct btrfs_ordered_sum *sum);
 struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct btrfs_inode *inode,
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 579dbf057ffa..4b09d559cc8f 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -501,6 +501,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			clone_info.data_len = datal;
 			clone_info.file_offset = new_key.offset;
 			clone_info.extent_buf = buf;
+			clone_info.extent_buf_size = size;
 			clone_info.is_new_extent = false;
 			clone_info.update_times = !no_time_update;
 			ret = btrfs_replace_file_extents(BTRFS_I(inode), path,
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 77e678efef65..e72c8176f7bc 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -207,6 +207,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 	u32 sectorsize = fs_info->sectorsize;
 	u32 item_size = btrfs_item_size(leaf, slot);
 	u64 extent_end;
+	u8 policy;
 
 	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
 		file_extent_err(leaf, slot,
@@ -258,10 +259,12 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 			BTRFS_NR_COMPRESS_TYPES - 1);
 		return -EUCLEAN;
 	}
-	if (unlikely(btrfs_file_extent_encryption(leaf, fi))) {
+	btrfs_unpack_encryption(btrfs_file_extent_encryption(leaf, fi),
+				&policy, NULL);
+	if (unlikely(policy >= BTRFS_NR_ENCRYPTION_TYPES)) {
 		file_extent_err(leaf, slot,
-			"invalid encryption for file extent, have %u expect 0",
-			btrfs_file_extent_encryption(leaf, fi));
+			"invalid encryption for file extent, have %u expect range [0, %u]",
+			policy, BTRFS_NR_ENCRYPTION_TYPES - 1);
 		return -EUCLEAN;
 	}
 	if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
@@ -290,12 +293,30 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 		return 0;
 	}
 
-	/* Regular or preallocated extent has fixed item size */
-	if (unlikely(item_size != sizeof(*fi))) {
-		file_extent_err(leaf, slot,
+	if (policy == BTRFS_ENCRYPTION_FSCRYPT) {
+		u8 ctxsize = btrfs_file_extent_encryption_ctxsize(leaf, fi);
+
+		if (unlikely(item_size != sizeof(*fi) + ctxsize)) {
+			file_extent_err(leaf, slot,
+	"invalid item size for encrypted file extent, have %u expect = %zu + context of size %u",
+					item_size, sizeof(*fi), ctxsize);
+			return -EUCLEAN;
+		}
+		/* Only regular extents should be encrypted. */
+		if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG) {
+			file_extent_err(leaf, slot,
+		"invalid type for encrypted file extent, have %u expect %u",
+					btrfs_file_extent_type(leaf, fi),
+					BTRFS_FILE_EXTENT_REG);
+			return -EUCLEAN;
+		}
+	} else {
+		if (unlikely(item_size != sizeof(*fi))) {
+			file_extent_err(leaf, slot,
 	"invalid item size for reg/prealloc file extent, have %u expect %zu",
-			item_size, sizeof(*fi));
-		return -EUCLEAN;
+					item_size, sizeof(*fi));
+			return -EUCLEAN;
+		}
 	}
 	if (unlikely(CHECK_FE_ALIGNED(leaf, slot, fi, ram_bytes, sectorsize) ||
 		     CHECK_FE_ALIGNED(leaf, slot, fi, disk_bytenr, sectorsize) ||
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 8d559b076405..9c211802efb1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4610,6 +4610,9 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	u64 extent_offset = em->start - em->orig_start;
 	u64 block_len;
 	int ret;
+	u8 encryption = btrfs_pack_encryption(IS_ENCRYPTED(&inode->vfs_inode) ?
+					      BTRFS_ENCRYPTION_FSCRYPT : 0,
+					      em->fscrypt_context.len);
 
 	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
@@ -4631,6 +4634,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_file_extent_num_bytes(&fi, em->len);
 	btrfs_set_stack_file_extent_ram_bytes(&fi, em->ram_bytes);
 	btrfs_set_stack_file_extent_compression(&fi, em->compress_type);
+	btrfs_set_stack_file_extent_encryption(&fi, encryption);
 
 	ret = log_extent_csums(trans, inode, log, em, ctx);
 	if (ret)
@@ -4662,7 +4666,8 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 		key.offset = em->start;
 
 		ret = btrfs_insert_empty_item(trans, log, path, &key,
-					      sizeof(fi));
+					      sizeof(fi) +
+					      em->fscrypt_context.len);
 		if (ret)
 			return ret;
 	}
@@ -4670,6 +4675,12 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	write_extent_buffer(leaf, &fi,
 			    btrfs_item_ptr_offset(leaf, path->slots[0]),
 			    sizeof(fi));
+#ifdef CONFIG_FS_ENCRYPTION
+	write_extent_buffer(leaf, &em->fscrypt_context.buffer,
+			    btrfs_item_ptr_offset(leaf, path->slots[0]) +
+			    sizeof(fi), em->fscrypt_context.len);
+#endif /* CONFIG_FS_ENCRYPTION */
+
 	btrfs_mark_buffer_dirty(leaf);
 
 	btrfs_release_path(path);
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 52641fdc65bc..4c0f77f3cfa9 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -1049,6 +1049,10 @@ struct btrfs_file_extent_item {
 	 * but not for stat.
 	 */
 	__u8 compression;
+	/*
+	 * This field contains 2 bits of encryption type in the lower bits,
+	 * 6 bits of context size in the upper bits. The unencrypted value is 0.
+	 */
 	__u8 encryption;
 	__le16 other_encoding; /* spare for later use */
 
@@ -1077,6 +1081,11 @@ struct btrfs_file_extent_item {
 	 */
 	__le64 num_bytes;
 
+	/*
+	 * Fscrypt extent encryption context. Only present if extent is
+	 * encrypted (stored in the encryption field).
+	 */
+	__u8 fscrypt_context[0];
 } __attribute__ ((__packed__));
 
 struct btrfs_csum_item {
-- 
2.37.3

