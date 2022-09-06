Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F07C5ADC8C
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Sep 2022 02:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbiIFAgJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Sep 2022 20:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbiIFAgH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Sep 2022 20:36:07 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7336A4A3;
        Mon,  5 Sep 2022 17:36:02 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 8E86381041;
        Mon,  5 Sep 2022 20:36:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662424561; bh=Eys7VWo8MU14uwl1XQhv0/N2YTlFuNEsTzLwSdchzQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=po4cwcRX6mEEeDrioh0Z0VRIPJRVKExRoxdxyC4zfx5DqwIAKxxuBrhXIYCKwUMPm
         78gAVPne3FFlw/gZu8mTbfXBKEv7kee9YPfAvnuDD/NxAzpO3/fIs41SypuW2aeTR7
         L0CvknigAsgHH48/ysUJe9eoSC8UO6a2syA7fm1aA9JwtrQ4FNXwimMxlSQQYyWvC8
         eNyGBDehuJGfvCMM78BJIjdJW3CZdxpJAESzVyx/ev3z3I1BvBhyLISaPqJxaS0dbO
         0Mhymrxc+kz0Ms0I+tSXATo/HBRGueNB2f5cxVLcmnNn2sne2SNodTJlJNjsn5F3ZX
         1EZnu8nccvNZg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 12/20] btrfs: start using fscrypt hooks.
Date:   Mon,  5 Sep 2022 20:35:27 -0400
Message-Id: <4b27b127a4048a58af965634436b562ec1217c82.1662420176.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1662420176.git.sweettea-kernel@dorminy.me>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

In order to appropriately encrypt, create, open, rename, and various symlink
operations must call fscrypt hooks. These determine whether the inode
should be encrypted and do other preparatory actions. The superblock
must have fscrypt operations registered, so implement the minimal set
also.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/ctree.h   |  1 +
 fs/btrfs/file.c    |  3 ++
 fs/btrfs/fscrypt.c |  3 ++
 fs/btrfs/fscrypt.h |  1 +
 fs/btrfs/inode.c   | 91 ++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/super.c   |  3 ++
 6 files changed, 90 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 230537a007b6..2b9ba8d77861 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3416,6 +3416,7 @@ struct btrfs_new_inode_args {
 	 */
 	struct posix_acl *default_acl;
 	struct posix_acl *acl;
+	bool encrypt;
 };
 int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 			    unsigned int *trans_num_items);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7216ac1f860c..929a0308676c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3695,6 +3695,9 @@ static int btrfs_file_open(struct inode *inode, struct file *filp)
 	int ret;
 
 	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
+	ret = fscrypt_file_open(inode, filp);
+	if (ret)
+		return ret;
 
 	ret = fsverity_file_open(inode, filp);
 	if (ret)
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 2ed844dd61d0..9829d280a6bc 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -30,3 +30,6 @@ bool btrfs_fscrypt_match_name(const struct fscrypt_name *fname,
 			     de_name_len - sizeof(nokey_name->bytes), digest);
 	return !memcmp(digest, nokey_name->sha256, sizeof(digest));
 }
+
+const struct fscrypt_operations btrfs_fscrypt_ops = {
+};
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 7f24d12e6ee0..07884206c8a1 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -22,4 +22,5 @@ static bool btrfs_fscrypt_match_name(const struct fscrypt_name *fname,
 }
 #endif
 
+extern const struct fscrypt_operations btrfs_fscrypt_ops;
 #endif /* BTRFS_FSCRYPT_H */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fea48c12a33a..eb42e4bf55b9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5450,6 +5450,7 @@ void btrfs_evict_inode(struct inode *inode)
 	trace_btrfs_inode_evict(inode);
 
 	if (!root) {
+		fscrypt_put_encryption_info(inode);
 		fsverity_cleanup_inode(inode);
 		clear_inode(inode);
 		return;
@@ -5551,6 +5552,7 @@ void btrfs_evict_inode(struct inode *inode)
 	 * to retry these periodically in the future.
 	 */
 	btrfs_remove_delayed_node(BTRFS_I(inode));
+	fscrypt_put_encryption_info(inode);
 	fsverity_cleanup_inode(inode);
 	clear_inode(inode);
 }
@@ -6289,6 +6291,10 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 		return ret;
 	}
 
+	ret = fscrypt_prepare_new_inode(dir, inode, &args->encrypt);
+	if (ret)
+		return ret;
+
 	/* 1 to add inode item */
 	*trans_num_items = 1;
 	/* 1 to add compression property */
@@ -6767,9 +6773,13 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
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
@@ -7050,6 +7060,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		unsigned long ptr;
 		char *map;
 		size_t size;
+		size_t inline_size;
 		size_t extent_offset;
 		size_t copy_size;
 
@@ -7057,9 +7068,13 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
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
@@ -9003,6 +9018,7 @@ void btrfs_test_destroy_inode(struct inode *inode)
 
 void btrfs_free_inode(struct inode *inode)
 {
+	fscrypt_free_inode(inode);
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 }
 
@@ -9073,8 +9089,7 @@ int btrfs_drop_inode(struct inode *inode)
 	/* the snap/subvol tree is on deleting */
 	if (btrfs_root_refs(&root->root_item) == 0)
 		return 1;
-	else
-		return generic_drop_inode(inode);
+	return generic_drop_inode(inode) || fscrypt_drop_inode(inode);
 }
 
 static void init_once(void *foo)
@@ -9688,6 +9703,11 @@ static int btrfs_rename2(struct user_namespace *mnt_userns, struct inode *old_di
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
@@ -9907,15 +9927,22 @@ static int btrfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
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
+	 * fscrypt sets disk_link.len to be len + 1, including a NULL terminator, but we
+	 * don't store that NULL.
+	 */
+	err = fscrypt_prepare_symlink(dir, symname, name_len,
+				      BTRFS_MAX_INLINE_DATA_SIZE(fs_info) + 1,
+				      &disk_link);
+	if (err)
+		return err;
 
 	inode = new_inode(dir->i_sb);
 	if (!inode)
@@ -9924,7 +9951,7 @@ static int btrfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	inode->i_op = &btrfs_symlink_inode_operations;
 	inode_nohighmem(inode);
 	inode->i_mapping->a_ops = &btrfs_aops;
-	btrfs_i_size_write(BTRFS_I(inode), name_len);
+	btrfs_i_size_write(BTRFS_I(inode), disk_link.len - 1);
 	inode_set_bytes(inode, name_len);
 
 	new_inode_args.inode = inode;
@@ -9952,10 +9979,23 @@ static int btrfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
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
@@ -9974,10 +10014,11 @@ static int btrfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
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
 
@@ -9994,6 +10035,29 @@ static int btrfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
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
@@ -11576,7 +11640,7 @@ static const struct inode_operations btrfs_special_inode_operations = {
 	.update_time	= btrfs_update_time,
 };
 static const struct inode_operations btrfs_symlink_inode_operations = {
-	.get_link	= page_get_link,
+	.get_link	= btrfs_get_link,
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.permission	= btrfs_permission,
@@ -11586,4 +11650,7 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 
 const struct dentry_operations btrfs_dentry_operations = {
 	.d_delete	= btrfs_dentry_delete,
+#ifdef CONFIG_FS_ENCRYPTION
+	.d_revalidate	= fscrypt_d_revalidate,
+#endif
 };
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b7118345c6f7..ba7008108bbb 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -47,6 +47,8 @@
 #include "tests/btrfs-tests.h"
 #include "block-group.h"
 #include "discard.h"
+#include "fscrypt.h"
+
 #include "qgroup.h"
 #include "raid56.h"
 #define CREATE_TRACE_POINTS
@@ -1448,6 +1450,7 @@ static int btrfs_fill_super(struct super_block *sb,
 	sb->s_vop = &btrfs_verityops;
 #endif
 	sb->s_xattr = btrfs_xattr_handlers;
+	fscrypt_set_ops(sb, &btrfs_fscrypt_ops);
 	sb->s_time_gran = 1;
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
 	sb->s_flags |= SB_POSIXACL;
-- 
2.35.1

