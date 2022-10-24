Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCBFF60BFD5
	for <lists+linux-fscrypt@lfdr.de>; Tue, 25 Oct 2022 02:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiJYAmk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Oct 2022 20:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiJYAmU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Oct 2022 20:42:20 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5301B222B8;
        Mon, 24 Oct 2022 16:14:02 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id C2EC8812BF;
        Mon, 24 Oct 2022 19:14:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666653242; bh=Iq/kIBVoybpGgJp3bpr8YbNI6TuFHYVZJjpCyjZpsfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tG1HiFl38ehHnFtkTOjttIK7RBZM4yF2KkP+IFL+0DkK354fhvUYhxZz5JOR+iI64
         PWPXHO0RCsmAGQnxPAEUREBQvs0odioIv1PRhHsNVj8EXv+lJtJQHarnnwDialXfGM
         aW1vtHEr8e9yIdU0uBlc8pr2djteLciEwY9JX1qQmsUIA3inSpWj29A67RveHyMiCb
         mfDSPmXOVbt14VxDnRff9kI4d/Pq/ge76j+d38jT9L/BHyCcz25K0rMOqIAExJA3+x
         Til/4mRseMk0FsIQFj9C82561NwDvQKOsSB8f7z+CX32q2IA7eDTxWFlkeHusCWzaR
         pTnQXv+H4C/SQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v4 12/21] btrfs: start using fscrypt hooks
Date:   Mon, 24 Oct 2022 19:13:22 -0400
Message-Id: <4804f92109c3e7adea4d0a67681b450b86889b93.1666651724.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1666651724.git.sweettea-kernel@dorminy.me>
References: <cover.1666651724.git.sweettea-kernel@dorminy.me>
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

From: Omar Sandoval <osandov@osandov.com>

In order to appropriately encrypt, create, open, rename, and various
symlink operations must call fscrypt hooks. These determine whether the
inode should be encrypted and do other preparatory actions. The
superblock must have fscrypt operations registered, so implement the
minimal set also, and introduce the new fscrypt.[ch] files to hold the
fscrypt-specific functionality.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/Makefile  |  1 +
 fs/btrfs/ctree.h   |  1 +
 fs/btrfs/file.c    |  3 ++
 fs/btrfs/fscrypt.c |  7 ++++
 fs/btrfs/fscrypt.h | 10 +++++
 fs/btrfs/inode.c   | 91 ++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/super.c   |  2 +
 7 files changed, 103 insertions(+), 12 deletions(-)
 create mode 100644 fs/btrfs/fscrypt.c
 create mode 100644 fs/btrfs/fscrypt.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 76f90dcfb14d..916d7ab95632 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -38,6 +38,7 @@ btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
 btrfs-$(CONFIG_BTRFS_FS_REF_VERIFY) += ref-verify.o
 btrfs-$(CONFIG_BLK_DEV_ZONED) += zoned.o
 btrfs-$(CONFIG_FS_VERITY) += verity.o
+btrfs-$(CONFIG_FS_ENCRYPTION) += fscrypt.o
 
 btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o \
 	tests/extent-buffer-tests.o tests/btrfs-tests.o \
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fda22e5c7a6b..58774c378452 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1676,6 +1676,7 @@ struct btrfs_new_inode_args {
 	struct posix_acl *default_acl;
 	struct posix_acl *acl;
 	struct fscrypt_name fname;
+	bool encrypt;
 };
 int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 			    unsigned int *trans_num_items);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 97d098b3c2e6..769a2a27941c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -4011,6 +4011,9 @@ static int btrfs_file_open(struct inode *inode, struct file *filp)
 	int ret;
 
 	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC;
+	ret = fscrypt_file_open(inode, filp);
+	if (ret)
+		return ret;
 
 	ret = fsverity_file_open(inode, filp);
 	if (ret)
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
new file mode 100644
index 000000000000..48ab99dfe48d
--- /dev/null
+++ b/fs/btrfs/fscrypt.c
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "ctree.h"
+#include "fscrypt.h"
+
+const struct fscrypt_operations btrfs_fscrypt_ops = {
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
index 55a8fe278435..960e3ff092e6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5448,6 +5448,7 @@ void btrfs_evict_inode(struct inode *inode)
 	trace_btrfs_inode_evict(inode);
 
 	if (!root) {
+		fscrypt_put_encryption_info(inode);
 		fsverity_cleanup_inode(inode);
 		clear_inode(inode);
 		return;
@@ -5549,6 +5550,7 @@ void btrfs_evict_inode(struct inode *inode)
 	 * to retry these periodically in the future.
 	 */
 	btrfs_remove_delayed_node(BTRFS_I(inode));
+	fscrypt_put_encryption_info(inode);
 	fsverity_cleanup_inode(inode);
 	clear_inode(inode);
 }
@@ -6295,6 +6297,10 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 		return ret;
 	}
 
+	ret = fscrypt_prepare_new_inode(dir, inode, &args->encrypt);
+	if (ret)
+		return ret;
+
 	/* 1 to add inode item */
 	*trans_num_items = 1;
 	/* 1 to add compression property */
@@ -6771,9 +6777,13 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (inode->i_nlink >= BTRFS_LINK_MAX)
 		return -EMLINK;
 
+	err = fscrypt_prepare_link(old_dentry, dir, dentry);
+	if (err)
+		return err;
+
 	err = fscrypt_setup_filename(dir, &dentry->d_name, 0, &fname);
 	if (err)
-		goto fail;
+		return err;
 
 	err = btrfs_set_inode_index(BTRFS_I(dir), &index);
 	if (err)
@@ -7054,6 +7064,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		unsigned long ptr;
 		char *map;
 		size_t size;
+		size_t inline_size;
 		size_t extent_offset;
 		size_t copy_size;
 
@@ -7061,9 +7072,13 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 			goto out;
 
 		size = btrfs_file_extent_ram_bytes(leaf, item);
+		inline_size = btrfs_file_extent_inline_item_len(leaf, path->slots[0]);
+		ASSERT(btrfs_file_extent_encryption(leaf, item) ||
+		       btrfs_file_extent_compression(leaf, item) ||
+		       (size == inline_size));
 		extent_offset = page_offset(page) + pg_offset - extent_start;
 		copy_size = min_t(u64, PAGE_SIZE - pg_offset,
-				  size - extent_offset);
+				  inline_size - extent_offset);
 		em->start = extent_start + extent_offset;
 		em->len = ALIGN(copy_size, fs_info->sectorsize);
 		em->orig_block_len = em->len;
@@ -8881,6 +8896,7 @@ void btrfs_test_destroy_inode(struct inode *inode)
 
 void btrfs_free_inode(struct inode *inode)
 {
+	fscrypt_free_inode(inode);
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 }
 
@@ -8951,8 +8967,7 @@ int btrfs_drop_inode(struct inode *inode)
 	/* the snap/subvol tree is on deleting */
 	if (btrfs_root_refs(&root->root_item) == 0)
 		return 1;
-	else
-		return generic_drop_inode(inode);
+	return generic_drop_inode(inode) || fscrypt_drop_inode(inode);
 }
 
 static void init_once(void *foo)
@@ -9543,6 +9558,11 @@ static int btrfs_rename2(struct user_namespace *mnt_userns, struct inode *old_di
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
 		return -EINVAL;
 
+	ret = fscrypt_prepare_rename(old_dir, old_dentry, new_dir, new_dentry,
+				     flags);
+	if (ret)
+		return ret;
+
 	if (flags & RENAME_EXCHANGE)
 		ret = btrfs_rename_exchange(old_dir, old_dentry, new_dir,
 					    new_dentry);
@@ -9762,15 +9782,22 @@ static int btrfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	};
 	unsigned int trans_num_items;
 	int err;
-	int name_len;
 	int datasize;
 	unsigned long ptr;
 	struct btrfs_file_extent_item *ei;
 	struct extent_buffer *leaf;
+	struct fscrypt_str disk_link;
+	u32 name_len = strlen(symname);
 
-	name_len = strlen(symname);
-	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info))
-		return -ENAMETOOLONG;
+	/*
+	 * fscrypt sets disk_link.len to be len + 1, including a NUL terminator, but we
+	 * don't store that '\0' character.
+	 */
+	err = fscrypt_prepare_symlink(dir, symname, name_len,
+				      BTRFS_MAX_INLINE_DATA_SIZE(fs_info) + 1,
+				      &disk_link);
+	if (err)
+		return err;
 
 	inode = new_inode(dir->i_sb);
 	if (!inode)
@@ -9779,7 +9806,7 @@ static int btrfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	inode->i_op = &btrfs_symlink_inode_operations;
 	inode_nohighmem(inode);
 	inode->i_mapping->a_ops = &btrfs_aops;
-	btrfs_i_size_write(BTRFS_I(inode), name_len);
+	btrfs_i_size_write(BTRFS_I(inode), disk_link.len - 1);
 	inode_set_bytes(inode, name_len);
 
 	new_inode_args.inode = inode;
@@ -9807,10 +9834,23 @@ static int btrfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 		inode = NULL;
 		goto out;
 	}
+
+	if (IS_ENCRYPTED(inode)) {
+		err = fscrypt_encrypt_symlink(inode, symname, name_len,
+					      &disk_link);
+		if (err) {
+			btrfs_abort_transaction(trans, err);
+			btrfs_free_path(path);
+			discard_new_inode(inode);
+			inode = NULL;
+			goto out;
+		}
+	}
+
 	key.objectid = btrfs_ino(BTRFS_I(inode));
 	key.offset = 0;
 	key.type = BTRFS_EXTENT_DATA_KEY;
-	datasize = btrfs_file_extent_calc_inline_size(name_len);
+	datasize = btrfs_file_extent_calc_inline_size(disk_link.len - 1);
 	err = btrfs_insert_empty_item(trans, root, path, &key,
 				      datasize);
 	if (err) {
@@ -9829,10 +9869,11 @@ static int btrfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	btrfs_set_file_extent_encryption(leaf, ei, 0);
 	btrfs_set_file_extent_compression(leaf, ei, 0);
 	btrfs_set_file_extent_other_encoding(leaf, ei, 0);
+	/* ram size is the unencoded size */
 	btrfs_set_file_extent_ram_bytes(leaf, ei, name_len);
 
 	ptr = btrfs_file_extent_inline_start(ei);
-	write_extent_buffer(leaf, symname, ptr, name_len);
+	write_extent_buffer(leaf, disk_link.name, ptr, disk_link.len - 1);
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
@@ -9849,6 +9890,29 @@ static int btrfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	return err;
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
@@ -11420,7 +11484,7 @@ static const struct inode_operations btrfs_special_inode_operations = {
 	.update_time	= btrfs_update_time,
 };
 static const struct inode_operations btrfs_symlink_inode_operations = {
-	.get_link	= page_get_link,
+	.get_link	= btrfs_get_link,
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.permission	= btrfs_permission,
@@ -11430,4 +11494,7 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 
 const struct dentry_operations btrfs_dentry_operations = {
 	.d_delete	= btrfs_dentry_delete,
+#ifdef CONFIG_FS_ENCRYPTION
+	.d_revalidate	= fscrypt_d_revalidate,
+#endif
 };
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 863804751b06..8ab5171d07e8 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -48,6 +48,7 @@
 #include "tests/btrfs-tests.h"
 #include "block-group.h"
 #include "discard.h"
+#include "fscrypt.h"
 #include "qgroup.h"
 #include "raid56.h"
 #include "fs.h"
@@ -1475,6 +1476,7 @@ static int btrfs_fill_super(struct super_block *sb,
 	sb->s_vop = &btrfs_verityops;
 #endif
 	sb->s_xattr = btrfs_xattr_handlers;
+	fscrypt_set_ops(sb, &btrfs_fscrypt_ops);
 	sb->s_time_gran = 1;
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
 	sb->s_flags |= SB_POSIXACL;
-- 
2.35.1

