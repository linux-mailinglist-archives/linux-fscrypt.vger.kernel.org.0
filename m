Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF575741D3A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbjF2AgT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjF2AgO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:36:14 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759AE1FC2;
        Wed, 28 Jun 2023 17:36:13 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 032F48030E;
        Wed, 28 Jun 2023 20:36:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998973; bh=Wg/P/roxPK97mxjDl6BDrb/CzpaKq2ejoIy8fDAWKrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFNnLZsgdtS4J1+4ZztIHSoEs1vDvBhk1KavUkGlN+5BxKr/RLHq6I3BvQvZSgck1
         jO8MWCi0C80MJ6BfNtt4Tpl2axPMl3946Ox1+7mJK+J43TioiChVuFGNEiJz0XxSze
         sCts+t74YcCg3Tn5oFXGkJHEd08URmMFYL68fSCJesQQPHaBMUM61+oq7V7AnMmK+x
         Xz0yjGlbMa4ThBLbVYMmDJcJ2GJxZdp9xEspL336sK2byt7EimSIdmMLmgUtLV+qk8
         dzjc0xiSTg8srpGZtA+EpQHZ6lQNtTnf/iu7rFprF9fet06eqG1M4hLUZ4B5m5cpsv
         1C0Xi2eobG3pw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 17/17] btrfs: save and load fscrypt extent contexts
Date:   Wed, 28 Jun 2023 20:35:40 -0400
Message-Id: <7fc592b75dc227b29b37c2b5e1ac9a1729c38b01.1687988380.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988380.git.sweettea-kernel@dorminy.me>
References: <cover.1687988380.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
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
 fs/btrfs/file-item.c            | 21 ++++++++++++++++
 fs/btrfs/fscrypt.c              | 36 +++++++++++++++++++++++++++
 fs/btrfs/fscrypt.h              |  6 +++++
 fs/btrfs/inode.c                | 44 ++++++++++++++++++++++++++++++---
 fs/btrfs/tree-log.c             | 24 ++++++++++++++++--
 include/uapi/linux/btrfs_tree.h |  5 ++++
 6 files changed, 130 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 8095fc2e7ca1..ccc2d12faba3 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -1302,6 +1302,27 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 
 		ctxsize = btrfs_file_extent_ctxsize_from_item(leaf, path);
 		ASSERT(ctxsize == btrfs_file_extent_encryption_ctxsize(leaf, fi));
+
+#ifdef CONFIG_FS_ENCRYPTION
+		if (ctxsize) {
+			u8 context[FSCRYPT_SET_CONTEXT_MAX_SIZE];
+			int res;
+			unsigned int nofs_flag;
+
+			read_extent_buffer(leaf, context,
+					   (unsigned long)fi->fscrypt_context,
+					   ctxsize);
+			nofs_flag = memalloc_nofs_save();
+			res = fscrypt_load_extent_info(&inode->vfs_inode,
+						       context, ctxsize,
+						       &em->fscrypt_info);
+			memalloc_nofs_restore(nofs_flag);
+			if (res)
+				btrfs_err(fs_info,
+					  "Unable to load fscrypt info: %d",
+					   res);
+		}
+#endif /* CONFIG_FS_ENCRYPTION */
 	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
 		em->block_start = EXTENT_MAP_INLINE;
 		em->start = extent_start;
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 658a67856de6..e98b0c31f841 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -164,6 +164,41 @@ static bool btrfs_fscrypt_empty_dir(struct inode *inode)
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
+	if (!em)
+		return -EINVAL;
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
+			 = (offset - em->start) >> inode->i_blkbits;
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
@@ -195,6 +230,7 @@ const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.get_context = btrfs_fscrypt_get_context,
 	.set_context = btrfs_fscrypt_set_context,
 	.empty_dir = btrfs_fscrypt_empty_dir,
+	.get_extent_info = btrfs_fscrypt_get_extent_info,
 	.get_devices = btrfs_fscrypt_get_devices,
 	.key_prefix = "btrfs:"
 };
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 2d405d54cbc7..1cab721a64e5 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -50,6 +50,12 @@ static inline bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 }
 #endif /* CONFIG_FS_ENCRYPTION */
 
+int btrfs_fscrypt_get_extent_info(const struct inode *inode,
+				  u64 lblk_num,
+				  struct fscrypt_info **info_ptr,
+				  u64 *extent_offset,
+				  u64 *extent_length);
+
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
 
 #endif /* BTRFS_FSCRYPT_H */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2f709874124d..b12b60120b13 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3036,17 +3036,46 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	u64 num_bytes = btrfs_stack_file_extent_num_bytes(stack_fi);
 	u64 ram_bytes = btrfs_stack_file_extent_ram_bytes(stack_fi);
 	struct btrfs_drop_extents_args drop_args = { 0 };
-	size_t fscrypt_context_size =
-		btrfs_stack_file_extent_encryption(stack_fi) ?
-			FSCRYPT_SET_CONTEXT_MAX_SIZE : 0;
+	size_t fscrypt_context_size = 0;
+#ifdef CONFIG_FS_ENCRYPTION
+	u8 context[FSCRYPT_SET_CONTEXT_MAX_SIZE];
+#endif /* CONFIG_FS_ENCRYPTION */
+
 	int ret;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
+#ifdef CONFIG_FS_ENCRYPTION
+	if (IS_ENCRYPTED(&inode->vfs_inode)) {
+		u8 encryption;
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
+		fscrypt_context_size =
+			fscrypt_set_extent_context(fscrypt_info, context,
+						   FSCRYPT_SET_CONTEXT_MAX_SIZE);
+		if (fscrypt_context_size < 0) {
+			ret = fscrypt_context_size;
+			goto out;
+		}
+		encryption = btrfs_pack_encryption(BTRFS_ENCRYPTION_FSCRYPT,
+						   fscrypt_context_size);
+		btrfs_set_stack_file_extent_encryption(stack_fi, encryption);
+	}
+#endif /* CONFIG_FS_ENCRYPTION */
+
 	/*
-	 * we may be replacing one extent in the tree with another.
+	 * We may be replacing one extent in the tree with another.
 	 * The new extent is pinned in the extent map, and we don't want
 	 * to drop it from the cache until it is completely in the btree.
 	 *
@@ -3079,6 +3108,13 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 			btrfs_item_ptr_offset(leaf, path->slots[0]),
 			sizeof(struct btrfs_file_extent_item));
 
+#ifdef CONFIG_FS_ENCRYPTION
+	write_extent_buffer(leaf, context,
+			    btrfs_item_ptr_offset(leaf, path->slots[0]) +
+			    sizeof(struct btrfs_file_extent_item),
+			    fscrypt_context_size);
+#endif /* CONFIG_FS_ENCRYPTION */
+
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index eaf014ab7cac..25966ae95eea 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4634,8 +4634,22 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	u64 extent_offset = em->start - em->orig_start;
 	u64 block_len;
 	int ret;
-	u8 encryption = btrfs_pack_encryption(IS_ENCRYPTED(&inode->vfs_inode) ?
-					      BTRFS_ENCRYPTION_FSCRYPT : 0, 0);
+	u8 encryption = 0;
+	size_t fscrypt_context_size = 0;
+#ifdef CONFIG_FS_ENCRYPTION
+	u8 context[FSCRYPT_SET_CONTEXT_MAX_SIZE];
+
+	if (em->fscrypt_info) {
+		fscrypt_context_size =
+			fscrypt_set_extent_context(em->fscrypt_info, context,
+						   FSCRYPT_SET_CONTEXT_MAX_SIZE);
+		if (fscrypt_context_size < 0)
+			return fscrypt_context_size;
+
+		encryption = btrfs_pack_encryption(BTRFS_ENCRYPTION_FSCRYPT,
+						   fscrypt_context_size);
+	}
+#endif /* CONFIG_FS_ENCRYPTION */
 
 	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
@@ -4697,6 +4711,12 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	write_extent_buffer(leaf, &fi,
 			    btrfs_item_ptr_offset(leaf, path->slots[0]),
 			    sizeof(fi));
+#ifdef CONFIG_FS_ENCRYPTION
+	write_extent_buffer(leaf, context,
+			    btrfs_item_ptr_offset(leaf, path->slots[0]) +
+			    sizeof(fi), fscrypt_context_size);
+#endif /* CONFIG_FS_ENCRYPTION */
+
 	btrfs_mark_buffer_dirty(leaf);
 
 	btrfs_release_path(path);
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index e780eee85e6e..787c9e67b491 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -1080,6 +1080,11 @@ struct btrfs_file_extent_item {
 	 * always reflects the size uncompressed and without encoding.
 	 */
 	__le64 num_bytes;
+	/*
+	 * fscrypt extent encryption context. Only present if extent is
+	 * encrypted (as per the encryption field).
+	 */
+	__u8 fscrypt_context[0];
 
 } __attribute__ ((__packed__));
 
-- 
2.40.1

