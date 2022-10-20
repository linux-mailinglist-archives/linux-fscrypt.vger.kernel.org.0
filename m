Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A949606693
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 19:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJTQ7y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 12:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiJTQ7x (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 12:59:53 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04D146DA2;
        Thu, 20 Oct 2022 09:59:45 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 65861811B7;
        Thu, 20 Oct 2022 12:59:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666285155; bh=89t8GAc0JcglswZGDhkOod9JiB0n1D9uKEc90u4uESs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5lJ1RAzEdpAjTRtHJEhyAX6pksJmH37vawBrcSVofSVVjoXvxovW2RmNuokdJf3m
         4tQVW09YUPhWqBG92nQDr5ZQSJ9H0BgN/P9OziVFk/lcnn5oJ+SHPg8VIPg+Ti0YE1
         kncNkDUzFHImud4UPXH66xlImse61HVfw1VVCxpR2BuQmbay2d2ypE4D/fJsdfYO5S
         TdZ6oSigziWcs2Pk72ponKFY9sG+zbRYF4z7dhcF4IxZC7u2zopisnB+wA+U21kDSh
         /uw+fsS2GGCkJ5Rb5aSjXbTEVCRi4hCn4CCH492LNA4pxXG1VDNuz/0wrDLOwk0FUA
         b5zIeXYZ29hWg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 08/22] btrfs: use struct fscrypt_str instead of struct qstr
Date:   Thu, 20 Oct 2022 12:58:27 -0400
Message-Id: <8c708f4e52ddcf6a361706265f5fcfa64cce912a.1666281277.git.sweettea-kernel@dorminy.me>
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

While struct qstr is more natural without fscrypt, since it's provided
by dentries, struct fscrypt_str is provided by the fscrypt handlers
processing dentries, and is thus more natural in the fscrypt world.
Replace all of the struct qstr uses with struct fscrypt_str.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/ctree.h       | 19 +++++----
 fs/btrfs/dir-item.c    | 10 ++---
 fs/btrfs/inode-item.c  | 14 +++----
 fs/btrfs/inode-item.h  | 10 ++---
 fs/btrfs/inode.c       | 90 +++++++++++++++++-------------------------
 fs/btrfs/ioctl.c       |  4 +-
 fs/btrfs/root-tree.c   |  4 +-
 fs/btrfs/send.c        |  4 +-
 fs/btrfs/super.c       |  2 +-
 fs/btrfs/transaction.c | 13 +++---
 fs/btrfs/tree-log.c    | 42 ++++++++++----------
 fs/btrfs/tree-log.h    |  4 +-
 12 files changed, 98 insertions(+), 118 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 695fd6cf8918..9d1186a16912 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2898,10 +2898,10 @@ static inline void btrfs_clear_sb_rdonly(struct super_block *sb)
 /* root-item.c */
 int btrfs_add_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       u64 ref_id, u64 dirid, u64 sequence,
-		       const struct qstr *name);
+		       const struct fscrypt_str *name);
 int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       u64 ref_id, u64 dirid, u64 *sequence,
-		       const struct qstr *name);
+		       const struct fscrypt_str *name);
 int btrfs_del_root(struct btrfs_trans_handle *trans,
 		   const struct btrfs_key *key);
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
@@ -2930,23 +2930,23 @@ int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info);
 
 /* dir-item.c */
 int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
-			  const struct qstr *name);
+			  const struct fscrypt_str *name);
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
-			  const struct qstr *name, struct btrfs_inode *dir,
+			  const struct fscrypt_str *name, struct btrfs_inode *dir,
 			  struct btrfs_key *location, u8 type, u64 index);
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
 					     struct btrfs_path *path, u64 dir,
-					     const struct qstr *name, int mod);
+					     const struct fscrypt_str *name, int mod);
 struct btrfs_dir_item *
 btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
 			    struct btrfs_path *path, u64 dir,
-			    u64 index, const struct qstr *name, int mod);
+			    u64 index, const struct fscrypt_str *name, int mod);
 struct btrfs_dir_item *
 btrfs_search_dir_index_item(struct btrfs_root *root,
 			    struct btrfs_path *path, u64 dirid,
-			    const struct qstr *name);
+			    const struct fscrypt_str *name);
 int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct btrfs_path *path,
@@ -3027,10 +3027,10 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
 int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
-		       const struct qstr *name);
+		       const struct fscrypt_str *name);
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
-		   const struct qstr *name, int add_backref, u64 index);
+		   const struct fscrypt_str *name, int add_backref, u64 index);
 int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry);
 int btrfs_truncate_block(struct btrfs_inode *inode, loff_t from, loff_t len,
 			 int front);
@@ -3056,7 +3056,6 @@ struct btrfs_new_inode_args {
 	struct posix_acl *default_acl;
 	struct posix_acl *acl;
 	struct fscrypt_name fname;
-	struct qstr name;
 };
 int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 			    unsigned int *trans_num_items);
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 8c60f37eb13f..fdab48c1abb8 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -104,7 +104,7 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
  * Will return 0 or -ENOMEM
  */
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
-			  const struct qstr *name, struct btrfs_inode *dir,
+			  const struct fscrypt_str *name, struct btrfs_inode *dir,
 			  struct btrfs_key *location, u8 type, u64 index)
 {
 	int ret = 0;
@@ -206,7 +206,7 @@ static struct btrfs_dir_item *btrfs_lookup_match_dir(
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
 					     struct btrfs_path *path, u64 dir,
-					     const struct qstr *name,
+					     const struct fscrypt_str *name,
 					     int mod)
 {
 	struct btrfs_key key;
@@ -225,7 +225,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
-				   const struct qstr *name)
+				   const struct fscrypt_str *name)
 {
 	int ret;
 	struct btrfs_key key;
@@ -302,7 +302,7 @@ struct btrfs_dir_item *
 btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
 			    struct btrfs_path *path, u64 dir,
-			    u64 index, const struct qstr *name, int mod)
+			    u64 index, const struct fscrypt_str *name, int mod)
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
@@ -321,7 +321,7 @@ btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
 
 struct btrfs_dir_item *
 btrfs_search_dir_index_item(struct btrfs_root *root, struct btrfs_path *path,
-			    u64 dirid, const struct qstr *name)
+			    u64 dirid, const struct fscrypt_str *name)
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index 643b0c555064..ce5c51ffdc0d 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -12,7 +12,7 @@
 
 struct btrfs_inode_ref *btrfs_find_name_in_backref(struct extent_buffer *leaf,
 						   int slot,
-						   const struct qstr *name)
+						   const struct fscrypt_str *name)
 {
 	struct btrfs_inode_ref *ref;
 	unsigned long ptr;
@@ -39,7 +39,7 @@ struct btrfs_inode_ref *btrfs_find_name_in_backref(struct extent_buffer *leaf,
 
 struct btrfs_inode_extref *btrfs_find_name_in_ext_backref(
 		struct extent_buffer *leaf, int slot, u64 ref_objectid,
-		const struct qstr *name)
+		const struct fscrypt_str *name)
 {
 	struct btrfs_inode_extref *extref;
 	unsigned long ptr;
@@ -78,7 +78,7 @@ struct btrfs_inode_extref *
 btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
 			  struct btrfs_path *path,
-			  const struct qstr *name,
+			  const struct fscrypt_str *name,
 			  u64 inode_objectid, u64 ref_objectid, int ins_len,
 			  int cow)
 {
@@ -101,7 +101,7 @@ btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
 
 static int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
-				  const struct qstr *name,
+				  const struct fscrypt_str *name,
 				  u64 inode_objectid, u64 ref_objectid,
 				  u64 *index)
 {
@@ -171,7 +171,7 @@ static int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, const struct qstr *name,
+			struct btrfs_root *root, const struct fscrypt_str *name,
 			u64 inode_objectid, u64 ref_objectid, u64 *index)
 {
 	struct btrfs_path *path;
@@ -248,7 +248,7 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
  */
 static int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
-				     const struct qstr *name,
+				     const struct fscrypt_str *name,
 				     u64 inode_objectid, u64 ref_objectid,
 				     u64 index)
 {
@@ -303,7 +303,7 @@ static int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
 
 /* Will return 0, -ENOMEM, -EMLINK, or -EEXIST or anything from the CoW path */
 int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, const struct qstr *name,
+			   struct btrfs_root *root, const struct fscrypt_str *name,
 			   u64 inode_objectid, u64 ref_objectid, u64 index)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
diff --git a/fs/btrfs/inode-item.h b/fs/btrfs/inode-item.h
index 3c657c670cfd..b80aeb715701 100644
--- a/fs/btrfs/inode-item.h
+++ b/fs/btrfs/inode-item.h
@@ -64,10 +64,10 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct btrfs_truncate_control *control);
 int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, const struct qstr *name,
+			   struct btrfs_root *root, const struct fscrypt_str *name,
 			   u64 inode_objectid, u64 ref_objectid, u64 index);
 int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, const struct qstr *name,
+			struct btrfs_root *root, const struct fscrypt_str *name,
 			u64 inode_objectid, u64 ref_objectid, u64 *index);
 int btrfs_insert_empty_inode(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
@@ -80,15 +80,15 @@ struct btrfs_inode_extref *btrfs_lookup_inode_extref(
 			  struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
 			  struct btrfs_path *path,
-			  const struct qstr *name,
+			  const struct fscrypt_str *name,
 			  u64 inode_objectid, u64 ref_objectid, int ins_len,
 			  int cow);
 
 struct btrfs_inode_ref *btrfs_find_name_in_backref(struct extent_buffer *leaf,
 						   int slot,
-						   const struct qstr *name);
+						   const struct fscrypt_str *name);
 struct btrfs_inode_extref *btrfs_find_name_in_ext_backref(
 		struct extent_buffer *leaf, int slot, u64 ref_objectid,
-		const struct qstr *name);
+		const struct fscrypt_str *name);
 
 #endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4c5b2e2d8b5e..b36e1bfdadd5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4284,7 +4284,7 @@ int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
 static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 				struct btrfs_inode *dir,
 				struct btrfs_inode *inode,
-				const struct qstr *name,
+				const struct fscrypt_str *name,
 				struct btrfs_rename_ctx *rename_ctx)
 {
 	struct btrfs_root *root = dir->root;
@@ -4387,7 +4387,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
-		       const struct qstr *name)
+		       const struct fscrypt_str *name)
 {
 	int ret;
 	ret = __btrfs_unlink_inode(trans, dir, inode, name, NULL);
@@ -4427,13 +4427,11 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = d_inode(dentry);
 	int ret;
 	struct fscrypt_name fname;
-	struct qstr name;
 
 	ret = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
 	if (ret)
 		return ret;
-	name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
-
+	
 	/* This needs to handle no-key deletions later on */
 
 	trans = __unlink_start_trans(dir);
@@ -4446,7 +4444,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 			0);
 
 	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
-				 &name);
+				 &fname.disk_name);
 	if (ret)
 		goto out;
 
@@ -4472,7 +4470,6 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
-	struct qstr name;
 	u64 index;
 	int ret;
 	u64 objectid;
@@ -4482,7 +4479,6 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	ret = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
 	if (ret)
 		return ret;
-	name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
 
 	/* This needs to handle no-key deletions later on */
 
@@ -4503,7 +4499,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	}
 
 	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
-				   &name, -1);
+				   &fname.disk_name, -1);
 	if (IS_ERR_OR_NULL(di)) {
 		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto out;
@@ -4529,7 +4525,8 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	 * call btrfs_del_root_ref, and it _shouldn't_ fail.
 	 */
 	if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
-		di = btrfs_search_dir_index_item(root, path, dir_ino, &name);
+		di = btrfs_search_dir_index_item(root, path, dir_ino,
+						 &fname.disk_name);
 		if (IS_ERR_OR_NULL(di)) {
 			if (!di)
 				ret = -ENOENT;
@@ -4546,7 +4543,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	} else {
 		ret = btrfs_del_root_ref(trans, objectid,
 					 root->root_key.objectid, dir_ino,
-					 &index, &name);
+					 &index, &fname.disk_name);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
@@ -4559,7 +4556,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	btrfs_i_size_write(BTRFS_I(dir), dir->i_size - name.len * 2);
+	btrfs_i_size_write(BTRFS_I(dir), dir->i_size - fname.disk_name.len * 2);
 	inode_inc_iversion(dir);
 	dir->i_mtime = current_time(dir);
 	dir->i_ctime = dir->i_mtime;
@@ -4582,7 +4579,7 @@ static noinline int may_destroy_subvol(struct btrfs_root *root)
 	struct btrfs_path *path;
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
-	struct qstr name = QSTR_INIT("default", 7);
+	struct fscrypt_str name = FSTR_INIT("default", 7);
 	u64 dir_id;
 	int ret;
 
@@ -4833,7 +4830,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	struct btrfs_trans_handle *trans;
 	u64 last_unlink_trans;
 	struct fscrypt_name fname;
-	struct qstr name;
 
 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
@@ -4849,7 +4845,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	err = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
 	if (err)
 		return err;
-	name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
 
 	/* This needs to handle no-key deletions later on */
 
@@ -4872,7 +4867,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	/* now the directory is empty */
 	err = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
-				 &name);
+				 &fname.disk_name);
 	if (!err) {
 		btrfs_i_size_write(BTRFS_I(inode), 0);
 		/*
@@ -5566,7 +5561,6 @@ void btrfs_evict_inode(struct inode *inode)
 static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 			       struct btrfs_key *location, u8 *type)
 {
-	struct qstr name;
 	struct btrfs_dir_item *di;
 	struct btrfs_path *path;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
@@ -5581,12 +5575,10 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	if (ret)
 		goto out;
 
-	name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
-
 	/* This needs to handle no-key deletions later on */
 
 	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(BTRFS_I(dir)),
-				   &name, 0);
+				   &fname.disk_name, 0);
 	if (IS_ERR_OR_NULL(di)) {
 		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto out;
@@ -5598,7 +5590,7 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 		ret = -EUCLEAN;
 		btrfs_warn(root->fs_info,
 "%s gets something invalid in DIR_ITEM (name %s, directory ino %llu, location(%llu %u %llu))",
-			   __func__, name.name, btrfs_ino(BTRFS_I(dir)),
+			   __func__, fname.disk_name.name, btrfs_ino(BTRFS_I(dir)),
 			   location->objectid, location->type, location->offset);
 	}
 	if (!ret)
@@ -5628,14 +5620,11 @@ static int fixup_tree_root_location(struct btrfs_fs_info *fs_info,
 	int ret;
 	int err = 0;
 	struct fscrypt_name fname;
-	struct qstr name;
 
 	ret = fscrypt_setup_filename(dir, &dentry->d_name, 0, &fname);
 	if (ret)
 		return ret;
 
-	name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
-
 	path = btrfs_alloc_path();
 	if (!path) {
 		err = -ENOMEM;
@@ -5657,11 +5646,12 @@ static int fixup_tree_root_location(struct btrfs_fs_info *fs_info,
 	leaf = path->nodes[0];
 	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_root_ref);
 	if (btrfs_root_ref_dirid(leaf, ref) != btrfs_ino(BTRFS_I(dir)) ||
-	    btrfs_root_ref_name_len(leaf, ref) != name.len)
+	    btrfs_root_ref_name_len(leaf, ref) != fname.disk_name.len)
 		goto out;
 
-	ret = memcmp_extent_buffer(leaf, name.name, (unsigned long)(ref + 1),
-				   name.len);
+	ret = memcmp_extent_buffer(leaf, fname.disk_name.name,
+				   (unsigned long)(ref + 1),
+				   fname.disk_name.len);
 	if (ret)
 		goto out;
 
@@ -6294,7 +6284,6 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 					     &args->fname);
 		if (ret)
 			return ret;
-		args->name = (struct qstr)FSTR_TO_QSTR(&args->fname.disk_name);
 	}
 
 	ret = posix_acl_create(dir, &inode->i_mode, &args->default_acl, &args->acl);
@@ -6377,7 +6366,7 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 {
 	struct inode *dir = args->dir;
 	struct inode *inode = args->inode;
-	const struct qstr *name = args->orphan ? NULL : &args->dentry->d_name;
+	const struct fscrypt_str *name = args->orphan ? NULL : &args->fname.disk_name;
 	struct btrfs_fs_info *fs_info = btrfs_sb(dir->i_sb);
 	struct btrfs_root *root;
 	struct btrfs_inode_item *inode_item;
@@ -6612,7 +6601,7 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
  */
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
-		   const struct qstr *name, int add_backref, u64 index)
+		   const struct fscrypt_str *name, int add_backref, u64 index)
 {
 	int ret = 0;
 	struct btrfs_key key;
@@ -6768,7 +6757,6 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	struct inode *inode = d_inode(old_dentry);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct fscrypt_name fname;
-	struct qstr name;
 	u64 index;
 	int err;
 	int drop_inode = 0;
@@ -6784,8 +6772,6 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (err)
 		goto fail;
 
-	name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
-
 	err = btrfs_set_inode_index(BTRFS_I(dir), &index);
 	if (err)
 		goto fail;
@@ -6812,7 +6798,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
 
 	err = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode),
-			     &name, 1, index);
+			     &fname.disk_name, 1, index);
 
 	if (err) {
 		drop_inode = 1;
@@ -9069,7 +9055,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	int ret2;
 	bool need_abort = false;
 	struct fscrypt_name old_fname, new_fname;
-	struct qstr old_name, new_name;
+	struct fscrypt_str *old_name, *new_name;
 
 	/*
 	 * For non-subvolumes allow exchange only within one subvolume, in the
@@ -9091,8 +9077,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		return ret;
 	}
 
-	old_name = (struct qstr)FSTR_TO_QSTR(&old_fname.disk_name);
-	new_name = (struct qstr)FSTR_TO_QSTR(&new_fname.disk_name);
+	old_name = &old_fname.disk_name;
+	new_name = &new_fname.disk_name;
 
 	/* close the race window with snapshot create/destroy ioctl */
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID ||
@@ -9161,7 +9147,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		/* force full log commit if subvolume involved. */
 		btrfs_set_log_full_commit(trans);
 	} else {
-		ret = btrfs_insert_inode_ref(trans, dest, &new_name, old_ino,
+		ret = btrfs_insert_inode_ref(trans, dest, new_name, old_ino,
 					     btrfs_ino(BTRFS_I(new_dir)),
 					     old_idx);
 		if (ret)
@@ -9174,7 +9160,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		/* force full log commit if subvolume involved. */
 		btrfs_set_log_full_commit(trans);
 	} else {
-		ret = btrfs_insert_inode_ref(trans, root, &old_name, new_ino,
+		ret = btrfs_insert_inode_ref(trans, root, old_name, new_ino,
 					     btrfs_ino(BTRFS_I(old_dir)),
 					     new_idx);
 		if (ret) {
@@ -9209,7 +9195,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	} else { /* src is an inode */
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					   BTRFS_I(old_dentry->d_inode),
-					   &old_name, &old_rename_ctx);
+					   old_name, &old_rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, root, BTRFS_I(old_inode));
 	}
@@ -9224,7 +9210,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	} else { /* dest is an inode */
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(new_dir),
 					   BTRFS_I(new_dentry->d_inode),
-					   &new_name, &new_rename_ctx);
+					   new_name, &new_rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, dest, BTRFS_I(new_inode));
 	}
@@ -9234,14 +9220,14 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	}
 
 	ret = btrfs_add_link(trans, BTRFS_I(new_dir), BTRFS_I(old_inode),
-			     &new_name, 0, old_idx);
+			     new_name, 0, old_idx);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_fail;
 	}
 
 	ret = btrfs_add_link(trans, BTRFS_I(old_dir), BTRFS_I(new_inode),
-			     &old_name, 0, new_idx);
+			     old_name, 0, new_idx);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_fail;
@@ -9326,7 +9312,6 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 	int ret2;
 	u64 old_ino = btrfs_ino(BTRFS_I(old_inode));
 	struct fscrypt_name old_fname, new_fname;
-	struct qstr old_name, new_name;
 
 	if (btrfs_ino(BTRFS_I(new_dir)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
 		return -EPERM;
@@ -9353,11 +9338,9 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 		return ret;
 	}
 
-	old_name = (struct qstr)FSTR_TO_QSTR(&old_fname.disk_name);
-	new_name = (struct qstr)FSTR_TO_QSTR(&new_fname.disk_name);
-
 	/* check for collisions, even if the  name isn't there */
-	ret = btrfs_check_dir_item_collision(dest, new_dir->i_ino, &new_name);
+	ret = btrfs_check_dir_item_collision(dest, new_dir->i_ino,
+					     &new_fname.disk_name);
 
 	if (ret) {
 		if (ret == -EEXIST) {
@@ -9451,8 +9434,9 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 		/* force full log commit if subvolume involved. */
 		btrfs_set_log_full_commit(trans);
 	} else {
-		ret = btrfs_insert_inode_ref(trans, dest, &new_name, old_ino,
-					     btrfs_ino(BTRFS_I(new_dir)), index);
+		ret = btrfs_insert_inode_ref(trans, dest, &new_fname.disk_name,
+					     old_ino, btrfs_ino(BTRFS_I(new_dir)),
+					     index);
 		if (ret)
 			goto out_fail;
 	}
@@ -9475,7 +9459,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 	} else {
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					   BTRFS_I(d_inode(old_dentry)),
-					   &old_name, &rename_ctx);
+					   &old_fname.disk_name, &rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, root, BTRFS_I(old_inode));
 	}
@@ -9494,7 +9478,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 		} else {
 			ret = btrfs_unlink_inode(trans, BTRFS_I(new_dir),
 						 BTRFS_I(d_inode(new_dentry)),
-						 &new_name);
+						 &new_fname.disk_name);
 		}
 		if (!ret && new_inode->i_nlink == 0)
 			ret = btrfs_orphan_add(trans,
@@ -9506,7 +9490,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 	}
 
 	ret = btrfs_add_link(trans, BTRFS_I(new_dir), BTRFS_I(old_inode),
-			     &new_name, 0, index);
+			     &new_fname.disk_name, 0, index);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_fail;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8a381182ec42..18ddb5c83102 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -949,7 +949,7 @@ static noinline int btrfs_mksubvol(const struct path *parent,
 	struct inode *dir = d_inode(parent->dentry);
 	struct btrfs_fs_info *fs_info = btrfs_sb(dir->i_sb);
 	struct dentry *dentry;
-	struct qstr name_str = QSTR_INIT(name, namelen);
+	struct fscrypt_str name_str = FSTR_INIT((char *)name, namelen);
 	int error;
 
 	error = down_write_killable_nested(&dir->i_rwsem, I_MUTEX_PARENT);
@@ -3774,7 +3774,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_path *path = NULL;
 	struct btrfs_disk_key disk_key;
-	struct qstr name = QSTR_INIT("default", 7);
+	struct fscrypt_str name = FSTR_INIT("default", 7);
 	u64 objectid = 0;
 	u64 dir_id;
 	int ret;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index cf29241b9b31..7d783f094306 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -328,7 +328,7 @@ int btrfs_del_root(struct btrfs_trans_handle *trans,
 
 int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       u64 ref_id, u64 dirid, u64 *sequence,
-		       const struct qstr *name)
+		       const struct fscrypt_str *name)
 {
 	struct btrfs_root *tree_root = trans->fs_info->tree_root;
 	struct btrfs_path *path;
@@ -400,7 +400,7 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
  */
 int btrfs_add_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       u64 ref_id, u64 dirid, u64 sequence,
-		       const struct qstr *name)
+		       const struct fscrypt_str *name)
 {
 	struct btrfs_root *tree_root = trans->fs_info->tree_root;
 	struct btrfs_key key;
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index b7566023954a..dcca2f733af1 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1596,7 +1596,7 @@ static int gen_unique_name(struct send_ctx *sctx,
 		return -ENOMEM;
 
 	while (1) {
-		struct qstr tmp_name;
+		struct fscrypt_str tmp_name;
 		len = snprintf(tmp, sizeof(tmp), "o%llu-%llu-%llu",
 				ino, gen, idx);
 		ASSERT(len < sizeof(tmp));
@@ -1755,7 +1755,7 @@ static int lookup_dir_item_inode(struct btrfs_root *root,
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
 	struct btrfs_path *path;
-	struct qstr name_str = QSTR_INIT(name, name_len);
+	struct fscrypt_str name_str = FSTR_INIT((char *)name, name_len);
 
 	path = alloc_path_for_send();
 	if (!path)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 571224170d99..266712d22bc8 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1394,7 +1394,7 @@ static int get_default_subvol_objectid(struct btrfs_fs_info *fs_info, u64 *objec
 	struct btrfs_dir_item *di;
 	struct btrfs_path *path;
 	struct btrfs_key location;
-	struct qstr name = QSTR_INIT("default", 7);
+	struct fscrypt_str name = FSTR_INIT("default", 7);
 	u64 dir_id;
 
 	path = btrfs_alloc_path();
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c6c57a6bb985..3a3538dba2fc 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1623,7 +1623,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	u64 root_flags;
 	unsigned int mem_flags;
 	struct fscrypt_name fname;
-	struct qstr name;
 
 	ASSERT(pending->path);
 	path = pending->path;
@@ -1643,7 +1642,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	memalloc_nofs_restore(mem_flags);
 	if (pending->error)
 		goto free_pending;
-	name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
 
 	pending->error = btrfs_get_free_objectid(tree_root, &objectid);
 	if (pending->error)
@@ -1691,7 +1689,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	/* check if there is a file/dir which has the same name. */
 	dir_item = btrfs_lookup_dir_item(NULL, parent_root, path,
 					 btrfs_ino(BTRFS_I(parent_inode)),
-					 &name, 0);
+					 &fname.disk_name, 0);
 	if (dir_item != NULL && !IS_ERR(dir_item)) {
 		pending->error = -EEXIST;
 		goto dir_item_existed;
@@ -1786,7 +1784,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_add_root_ref(trans, objectid,
 				 parent_root->root_key.objectid,
 				 btrfs_ino(BTRFS_I(parent_inode)), index,
-				 &name);
+				 &fname.disk_name);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
@@ -1818,8 +1816,9 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		goto fail;
 
-	ret = btrfs_insert_dir_item(trans, &name, BTRFS_I(parent_inode), &key,
-				    BTRFS_FT_DIR, index);
+	ret = btrfs_insert_dir_item(trans, &fname.disk_name,
+				    BTRFS_I(parent_inode), &key, BTRFS_FT_DIR,
+				    index);
 	/* We have check then name at the beginning, so it is impossible. */
 	BUG_ON(ret == -EEXIST || ret == -EOVERFLOW);
 	if (ret) {
@@ -1828,7 +1827,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_i_size_write(BTRFS_I(parent_inode), parent_inode->i_size +
-						  name.len * 2);
+						  fname.disk_name.len * 2);
 	parent_inode->i_mtime = current_time(parent_inode);
 	parent_inode->i_ctime = parent_inode->i_mtime;
 	ret = btrfs_update_inode_fallback(trans, parent_root, BTRFS_I(parent_inode));
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index bfd5bb63f079..078869dbb68f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -596,7 +596,7 @@ static int overwrite_item(struct btrfs_trans_handle *trans,
 }
 
 static int read_one_name(struct extent_buffer *eb, void *start, int len,
-			 struct qstr *name)
+			 struct fscrypt_str *name)
 {
 	char *buf = kmalloc(len, GFP_NOFS);
 
@@ -915,7 +915,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 static int unlink_inode_for_log_replay(struct btrfs_trans_handle *trans,
 				       struct btrfs_inode *dir,
 				       struct btrfs_inode *inode,
-				       const struct qstr *name)
+				       const struct fscrypt_str *name)
 {
 	int ret;
 
@@ -946,7 +946,7 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *root = dir->root;
 	struct inode *inode;
-	struct qstr name;
+	struct fscrypt_str name;
 	struct extent_buffer *leaf;
 	struct btrfs_key location;
 	int ret;
@@ -987,7 +987,7 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 static noinline int inode_in_dir(struct btrfs_root *root,
 				 struct btrfs_path *path,
 				 u64 dirid, u64 objectid, u64 index,
-				 struct qstr *name)
+				 struct fscrypt_str *name)
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_key location;
@@ -1034,7 +1034,7 @@ static noinline int inode_in_dir(struct btrfs_root *root,
 static noinline int backref_in_log(struct btrfs_root *log,
 				   struct btrfs_key *key,
 				   u64 ref_objectid,
-				   const struct qstr *name)
+				   const struct fscrypt_str *name)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -1070,7 +1070,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 				  struct btrfs_inode *dir,
 				  struct btrfs_inode *inode,
 				  u64 inode_objectid, u64 parent_objectid,
-				  u64 ref_index, struct qstr *name)
+				  u64 ref_index, struct fscrypt_str *name)
 {
 	int ret;
 	struct extent_buffer *leaf;
@@ -1104,7 +1104,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 		ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
 		ptr_end = ptr + btrfs_item_size(leaf, path->slots[0]);
 		while (ptr < ptr_end) {
-			struct qstr victim_name;
+			struct fscrypt_str victim_name;
 			victim_ref = (struct btrfs_inode_ref *)ptr;
 			ret = read_one_name(leaf, (victim_ref + 1),
 				 btrfs_inode_ref_name_len(leaf, victim_ref),
@@ -1153,7 +1153,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 		base = btrfs_item_ptr_offset(leaf, path->slots[0]);
 
 		while (cur_offset < item_size) {
-			struct qstr victim_name;
+			struct fscrypt_str victim_name;
 			extref = (struct btrfs_inode_extref *)(base + cur_offset);
 
 			if (btrfs_inode_extref_parent(leaf, extref) != parent_objectid)
@@ -1227,7 +1227,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 }
 
 static int extref_get_fields(struct extent_buffer *eb, unsigned long ref_ptr,
-			     struct qstr *name, u64 *index,
+			     struct fscrypt_str *name, u64 *index,
 			     u64 *parent_objectid)
 {
 	struct btrfs_inode_extref *extref;
@@ -1249,7 +1249,7 @@ static int extref_get_fields(struct extent_buffer *eb, unsigned long ref_ptr,
 }
 
 static int ref_get_fields(struct extent_buffer *eb, unsigned long ref_ptr,
-			  struct qstr *name, u64 *index)
+			  struct fscrypt_str *name, u64 *index)
 {
 	struct btrfs_inode_ref *ref;
 	int ret;
@@ -1301,7 +1301,7 @@ static int unlink_old_inode_refs(struct btrfs_trans_handle *trans,
 	ref_ptr = btrfs_item_ptr_offset(eb, path->slots[0]);
 	ref_end = ref_ptr + btrfs_item_size(eb, path->slots[0]);
 	while (ref_ptr < ref_end) {
-		struct qstr name;
+		struct fscrypt_str name;
 		u64 parent_id;
 
 		if (key->type == BTRFS_INODE_EXTREF_KEY) {
@@ -1371,7 +1371,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 	struct inode *inode = NULL;
 	unsigned long ref_ptr;
 	unsigned long ref_end;
-	struct qstr name;
+	struct fscrypt_str name;
 	int ret;
 	int log_ref_ver = 0;
 	u64 parent_objectid;
@@ -1766,7 +1766,7 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 static noinline int insert_one_name(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root,
 				    u64 dirid, u64 index,
-				    const struct qstr *name,
+				    const struct fscrypt_str *name,
 				    struct btrfs_key *location)
 {
 	struct inode *inode;
@@ -1844,7 +1844,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 				    struct btrfs_dir_item *di,
 				    struct btrfs_key *key)
 {
-	struct qstr name;
+	struct fscrypt_str name;
 	struct btrfs_dir_item *dir_dst_di;
 	struct btrfs_dir_item *index_dst_di;
 	bool dir_dst_matches = false;
@@ -2124,7 +2124,7 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 	struct extent_buffer *eb;
 	int slot;
 	struct btrfs_dir_item *di;
-	struct qstr name;
+	struct fscrypt_str name;
 	struct inode *inode = NULL;
 	struct btrfs_key location;
 
@@ -3422,7 +3422,7 @@ static int del_logged_dentry(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *log,
 			     struct btrfs_path *path,
 			     u64 dir_ino,
-			     const struct qstr *name,
+			     const struct fscrypt_str *name,
 			     u64 index)
 {
 	struct btrfs_dir_item *di;
@@ -3469,7 +3469,7 @@ static int del_logged_dentry(struct btrfs_trans_handle *trans,
  */
 void btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
-				  const struct qstr *name,
+				  const struct fscrypt_str *name,
 				  struct btrfs_inode *dir, u64 index)
 {
 	struct btrfs_path *path;
@@ -3508,7 +3508,7 @@ void btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 /* see comments for btrfs_del_dir_entries_in_log */
 void btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
-				const struct qstr *name,
+				const struct fscrypt_str *name,
 				struct btrfs_inode *inode, u64 dirid)
 {
 	struct btrfs_root *log;
@@ -5192,7 +5192,7 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 		u32 this_len;
 		unsigned long name_ptr;
 		struct btrfs_dir_item *di;
-		struct qstr name_str;
+		struct fscrypt_str name_str;
 
 		if (key->type == BTRFS_INODE_REF_KEY) {
 			struct btrfs_inode_ref *iref;
@@ -7395,7 +7395,6 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 		struct btrfs_root *log = old_dir->root->log_root;
 		struct btrfs_path *path;
 		struct fscrypt_name fname;
-		struct qstr name;
 
 		ASSERT(old_dir_index >= BTRFS_DIR_START_INDEX);
 
@@ -7403,7 +7402,6 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 					     &old_dentry->d_name, 0, &fname);
 		if (ret)
 			goto out;
-		name = (struct qstr)FSTR_TO_QSTR(&fname.disk_name);
 		/*
 		 * We have two inodes to update in the log, the old directory and
 		 * the inode that got renamed, so we must pin the log to prevent
@@ -7439,7 +7437,7 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 		 */
 		mutex_lock(&old_dir->log_mutex);
 		ret = del_logged_dentry(trans, log, path, btrfs_ino(old_dir),
-					&name, old_dir_index);
+					&fname.disk_name, old_dir_index);
 		if (ret > 0) {
 			/*
 			 * The dentry does not exist in the log, so record its
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 59dc4359c8c4..48838626291f 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -86,11 +86,11 @@ int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
 			  struct btrfs_log_ctx *ctx);
 void btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
-				  const struct qstr *name,
+				  const struct fscrypt_str *name,
 				  struct btrfs_inode *dir, u64 index);
 void btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
-				const struct qstr *name,
+				const struct fscrypt_str *name,
 				struct btrfs_inode *inode, u64 dirid);
 void btrfs_end_log_trans(struct btrfs_root *root);
 void btrfs_pin_log_trans(struct btrfs_root *root);
-- 
2.35.1

