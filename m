Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24B9606690
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 19:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJTQ7u (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 12:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiJTQ7s (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 12:59:48 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC01264A8;
        Thu, 20 Oct 2022 09:59:42 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id DA771811CE;
        Thu, 20 Oct 2022 12:59:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666285181; bh=XjHIit3RHS2zmoqs0CeqPbUbgyQZhK+rhKn07fPTG28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lD+SxB8/JmvZTqtCtJqBeL3iffoSQNmY7/4+GQssc8UVstwrOnWgctR+x0Q1WUwQP
         6+MjbaT8oPjQcFLtQIokvxqh+uKnaq76a4cL8O70dx3hNYqIntlzjH7FHMDxNPnFD8
         eeYtfP1KCIVRCICyI0NP0baD57HNnoURTtmmItRyl1oHpSTdnxPFnZGhtQoGHEULvi
         dHou4eCs45BYu4acASKXt9c6eVfzMJNyM1At/K7o5MEwJtuzAkCemaCrdw0skR6RPv
         IwSJ4GQZVYITsGdTxriw6e/X4cWBtLAk9bUEaXcPmBDAzO/xBk3CVYZPOtRrszNLSM
         I7RBI6xb0r+Qw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 22/22] btrfs: encrypt verity items
Date:   Thu, 20 Oct 2022 12:58:41 -0400
Message-Id: <cbf8af76b1d15f6ee42241025526b7ce4c8e9366.1666281277.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1666281276.git.sweettea-kernel@dorminy.me>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Verity items are deemed to have sensitive information about the file
contents, so verity items for a encrypted file should be encrypted. This
change uses the fscrypt inplace encryption helper to do so, which should
be similar to what is used for inline extents.

This change has two related holes. Currently, this reuses the fscrypt
extent context from the data in the file for encryption: if there are
not yet any extents for the file when verity is enabled thereon, there
is no fscrypt extent context yet and encryption fails. Additionally,
IVs shouldn't be reused. I think the best solution here is to somehow
pack the 33-byte fscrypt extent contexts into the 16 bytes reserved for
encryption in verity items, and use that in some in-memory-only extent
maps set up to cover the file indexes after the actual data.

But maybe a better solution is to move fscrypt extent contexts into
their own items with offsets past the end of the file, and then there's
no risk of in-memory-only extent maps accidentally making it to disk or
confusing some other part of the system.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/verity.c | 112 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 97 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index ee00e33c309e..0903aab276c6 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -8,6 +8,7 @@
 #include <linux/security.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/iversion.h>
+#include <linux/fscrypt.h>
 #include <linux/fsverity.h>
 #include <linux/sched/mm.h>
 #include "ctree.h"
@@ -218,14 +219,52 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
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
@@ -237,12 +276,6 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
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
@@ -251,18 +284,23 @@ static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 
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
+	if (ciphertext_page) {
+		kunmap_local(ciphertext_buf);
+		__free_page(ciphertext_page);
+	}
+
 	return ret;
 }
 
@@ -304,6 +342,17 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
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
@@ -365,14 +414,41 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
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
@@ -399,6 +475,12 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
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
-- 
2.35.1

