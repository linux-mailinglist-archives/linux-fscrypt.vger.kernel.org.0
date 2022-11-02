Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB75B616241
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 12:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiKBLyG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 07:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiKBLxn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 07:53:43 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA4DBD1;
        Wed,  2 Nov 2022 04:53:41 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 32FB681472;
        Wed,  2 Nov 2022 07:53:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1667390021; bh=IQRToKMmjUM+53ysQVVAJFNybuNa5MMWtNOLXU7bfFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHwVL8SIwsVVjN8x3mnvY6H51b4h6dotCyOE5K7IKz0OBFgYXHbl+YIX2O0nMwV2L
         IXlpipTK4j0WvXot3ovsGHOomkuv1z4xsRciyKs56VWK6pIyiYZ/QBWGmEFWQMVavD
         orVMd2CRnRjh/vvhRAncroNNcz4pYod9XC7WQg40np3GXzfqxWvAN3cXfaHx724wb3
         A8dmY7Jsvr68m7Ki7Jv3gqkIT2xZtmtDt3gpudbvZKOHXQjye5ZQMvLozTqrDrzVOE
         kgIXjGzOiFtTOToCFUH4X3bxPntWqJGIBkmjvNMyYuG6BGUGuDTu6eZDgczUr9Z3+B
         jI8PYS3y0+Urw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v5 17/18] btrfs: encrypt verity items
Date:   Wed,  2 Nov 2022 07:53:06 -0400
Message-Id: <746be0f68a5a9e34ae82d6484daac02826104b74.1667389116.git.sweettea-kernel@dorminy.me>
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

Verity items are deemed to have sensitive information about the file
contents, so verity items for a encrypted file should be encrypted. In
order to make sure there are extent contexts with which to encrypt,
encrypted verity items wait for the file data to be written before
writing the verity items; it may be better to store a new fscrypt extent
context with verity items.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/verity.c | 124 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 109 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index bf9eb693a6a7..c5784994c03e 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -8,6 +8,7 @@
 #include <linux/security.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/iversion.h>
+#include <linux/fscrypt.h>
 #include <linux/fsverity.h>
 #include <linux/sched/mm.h>
 #include "messages.h"
@@ -224,14 +225,52 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 	struct btrfs_key key;
 	unsigned long copy_bytes;
 	unsigned long src_offset = 0;
-	void *data;
+	void *data_pos;
 	int ret = 0;
+#ifdef CONFIG_FS_ENCRYPTION
+	struct page *ciphertext_page = NULL;
+	char *ciphertext_buf;
+
+	if (IS_ENCRYPTED(&inode->vfs_inode)) {
+		ciphertext_page = alloc_page(GFP_NOFS);
+		if (!ciphertext_page)
+			return -ENOMEM;
+		ciphertext_buf = kmap_local_page(ciphertext_page);
+	}
+#endif /* CONFIG_FS_ENCRYPTION */
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
 	while (len > 0) {
+		const char *data = src + src_offset;
+		/*
+		 * Insert 2K at a time mostly to be friendly for smaller leaf
+		 * size filesystems
+		 */
+		copy_bytes = min_t(u64, len, 2048);
+
+#ifdef CONFIG_FS_ENCRYPTION
+		if (ciphertext_page) {
+			struct btrfs_fs_info *fs_info = inode->root->fs_info;
+			u64 lblk_num = offset >> fs_info->sectorsize_bits;
+
+			memset(ciphertext_buf, 0, PAGE_SIZE);
+			memcpy(ciphertext_buf, data, copy_bytes);
+			copy_bytes = ALIGN(copy_bytes,
+					   FSCRYPT_CONTENTS_ALIGNMENT);
+			ret = fscrypt_encrypt_block_inplace(&inode->vfs_inode,
+							    ciphertext_page,
+							    copy_bytes, 0,
+							    lblk_num,
+							    GFP_NOFS);
+			if (ret)
+				break;
+			data = ciphertext_buf;
+		}
+#endif /* CONFIG_FS_ENCRYPTION */
+
 		/* 1 for the new item being inserted */
 		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans)) {
@@ -243,12 +282,6 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 		key.type = key_type;
 		key.offset = offset;
 
-		/*
-		 * Insert 2K at a time mostly to be friendly for smaller leaf
-		 * size filesystems
-		 */
-		copy_bytes = min_t(u64, len, 2048);
-
 		ret = btrfs_insert_empty_item(trans, root, path, &key, copy_bytes);
 		if (ret) {
 			btrfs_end_transaction(trans);
@@ -257,18 +290,25 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 
 		leaf = path->nodes[0];
 
-		data = btrfs_item_ptr(leaf, path->slots[0], void);
-		write_extent_buffer(leaf, src + src_offset,
-				    (unsigned long)data, copy_bytes);
+		data_pos = btrfs_item_ptr(leaf, path->slots[0], void);
+		write_extent_buffer(leaf, data,
+				    (unsigned long)data_pos, copy_bytes);
 		offset += copy_bytes;
 		src_offset += copy_bytes;
-		len -= copy_bytes;
+		len -= min_t(u64, copy_bytes, len);
 
 		btrfs_release_path(path);
 		btrfs_end_transaction(trans);
 	}
 
 	btrfs_free_path(path);
+#ifdef CONFIG_FS_ENCRYPTION
+	if (ciphertext_page) {
+		kunmap_local(ciphertext_buf);
+		__free_page(ciphertext_page);
+	}
+#endif /* CONFIG_FS_ENCRYPTION */
+
 	return ret;
 }
 
@@ -310,6 +350,17 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 	void *data;
 	char *kaddr = dest;
 	int ret;
+#ifdef CONFIG_FS_ENCRYPTION
+	char *ciphertext_buf;
+	struct page *ciphertext_page = NULL;
+
+	if (dest && IS_ENCRYPTED(&inode->vfs_inode)) {
+		ciphertext_page = alloc_page(GFP_NOFS);
+		if (!ciphertext_page)
+			return -ENOMEM;
+		ciphertext_buf = kmap_local_page(ciphertext_page);
+	}
+#endif /* CONFIG_FS_ENCRYPTION */
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -371,14 +422,41 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 		/* Offset from the start of item for copying */
 		copy_offset = offset - key.offset;
 
+		data = btrfs_item_ptr(leaf, path->slots[0], void);
 		if (dest) {
+#ifdef CONFIG_FS_ENCRYPTION
+			if (ciphertext_page) {
+				struct btrfs_fs_info *fs_info =
+					inode->root->fs_info;
+				u64 lblk_num = offset >> fs_info->sectorsize_bits;
+
+				read_extent_buffer(leaf, ciphertext_buf,
+						   (unsigned long)data + copy_offset,
+						   item_end - offset);
+				ret = fscrypt_decrypt_block_inplace(&inode->vfs_inode,
+								    ciphertext_page,
+								    item_end - offset, 0,
+								    lblk_num);
+				if (ret)
+					break;
+			}
+#endif /* CONFIG_FS_ENCRYPTION */
+
 			if (dest_page)
 				kaddr = kmap_local_page(dest_page);
 
-			data = btrfs_item_ptr(leaf, path->slots[0], void);
-			read_extent_buffer(leaf, kaddr + dest_offset,
-					   (unsigned long)data + copy_offset,
-					   copy_bytes);
+			if (IS_ENABLED(CONFIG_FS_ENCRYPTION) &&
+			    IS_ENCRYPTED(&inode->vfs_inode)) {
+#ifdef CONFIG_FS_ENCRYPTION
+				memcpy(kaddr + dest_offset,
+				       ciphertext_buf + copy_offset,
+				       copy_bytes);
+#endif /* CONFIG_FS_ENCRYPTION */
+			} else {
+				read_extent_buffer(leaf, kaddr + dest_offset,
+						   (unsigned long)data + copy_offset,
+						   copy_bytes);
+			}
 
 			if (dest_page)
 				kunmap_local(kaddr);
@@ -405,6 +483,12 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 		}
 	}
 out:
+#ifdef CONFIG_FS_ENCRYPTION
+	if (ciphertext_page) {
+		kunmap_local(ciphertext_buf);
+		__free_page(ciphertext_page);
+	}
+#endif /* CONFIG_FS_ENCRYPTION */
 	btrfs_free_path(path);
 	if (!ret)
 		ret = copied;
@@ -601,6 +685,16 @@ static int btrfs_begin_enable_verity(struct file *filp)
 	if (ret)
 		return ret;
 
+	if (IS_ENCRYPTED(file_inode(filp))) {
+		/*
+		 * Make sure the data has been written (so that we can reuse
+		 * its encryption info to encrypt verity items).
+		 */
+		ret = btrfs_wait_ordered_range(file_inode(filp), 0, (u64)-1);
+		if (ret)
+			return ret;
+	}
+
 	/* 1 for the orphan item */
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans))
-- 
2.37.3

