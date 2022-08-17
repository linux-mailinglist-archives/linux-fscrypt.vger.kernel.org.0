Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8A05971C9
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 16:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240427AbiHQOup (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Aug 2022 10:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240417AbiHQOui (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Aug 2022 10:50:38 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322BF33A26;
        Wed, 17 Aug 2022 07:50:37 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id B2D3C8042B;
        Wed, 17 Aug 2022 10:50:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1660747837; bh=gO03JrjFMU9KjtZh35gPfuD4CW7aFI/0juADJjCzBTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LlfMmj8HX3WQ64OCiuFvL2PL+Qhz8n9TU+qdYl5nek+LLvl+tZA1Z8SgFC32cog9y
         n9fjpgY5+EX6vA5i/3QYiQke/8dUxnijmUffT+R0Wdx76baMVrJpKRI1z/o+haoyMl
         NRa0o27SLK78GKl7tXEygx2VoIh0Bdd10Yb71AyWdPxbZHKhB01CRavKgG5MkDhWJT
         BF9VGmmLp86wKjwaxR4U6kVvJdqzuyqP838juhfWL01UCCRhRRaVnFxNT1vPyxPwrK
         9XoBUGCQKOX9bhIHkOrtHtUqlA/VWkv6U3ep1SyuQJIMWBqSokfd2QFJlkAf8rKEJ2
         v9wAeTF7mHrKg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 08/21] btrfs: setup fscrypt_names from dentrys using helper
Date:   Wed, 17 Aug 2022 10:49:52 -0400
Message-Id: <33ab6691c8038f52a448844f0ebc363477db30da.1660744500.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1660744500.git.sweettea-kernel@dorminy.me>
References: <cover.1660744500.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Most places that we create fscrypt_names, we are doing so from a dentry.
Fscrypt provides a helper for this common pattern:
fscrypt_setup_filename() initializes a filename to search for from a
dentry, performing encryption of the plaintext if it can and should be
done. This converts each setup of a fscrypt_name from a dentry to use
this helper; at present, since there are no encrypted directories,
nothing goes down the filename encryption paths.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/inode.c       | 153 ++++++++++++++++++++++++++---------------
 fs/btrfs/transaction.c |  26 +++++--
 fs/btrfs/tree-log.c    |  12 ++--
 3 files changed, 123 insertions(+), 68 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dbb2ef802b9a..f3861c58309a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4408,14 +4408,17 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	struct btrfs_trans_handle *trans;
 	struct inode *inode = d_inode(dentry);
 	int ret;
-	struct fscrypt_name fname = {
-		.disk_name = FSTR_INIT((unsigned char *)dentry->d_name.name, dentry->d_name.len)
-	};
+	struct fscrypt_name fname;
 
+	ret = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
+	if (ret)
+		return ret;
 
 	trans = __unlink_start_trans(dir);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
 
 	btrfs_record_unlink_dir(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
 			0);
@@ -4432,6 +4435,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	}
 
 out:
+	fscrypt_free_filename(&fname);
 	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(BTRFS_I(dir)->root->fs_info);
 	return ret;
@@ -4450,10 +4454,11 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	int ret;
 	u64 objectid;
 	u64 dir_ino = btrfs_ino(BTRFS_I(dir));
-	struct fscrypt_name fname = {
-		.disk_name = FSTR_INIT((char *) dentry->d_name.name,
-				       dentry->d_name.len)
-	};
+	struct fscrypt_name fname;
+
+	ret = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
+	if (ret)
+		return ret;
 
 	if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID) {
 		objectid = inode->root->root_key.objectid;
@@ -4461,12 +4466,15 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 		objectid = inode->location.objectid;
 	} else {
 		WARN_ON(1);
+		fscrypt_free_filename(&fname);
 		return -EINVAL;
 	}
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	di = btrfs_lookup_dir_item(trans, root, path, dir_ino, &fname, -1);
 	if (IS_ERR_OR_NULL(di)) {
@@ -4533,6 +4541,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 		btrfs_abort_transaction(trans, ret);
 out:
 	btrfs_free_path(path);
+	fscrypt_free_filename(&fname);
 	return ret;
 }
 
@@ -4799,9 +4808,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	int err = 0;
 	struct btrfs_trans_handle *trans;
 	u64 last_unlink_trans;
-	struct fscrypt_name fname = {
-		.disk_name = FSTR_INIT((unsigned char *)dentry->d_name.name, dentry->d_name.len)
-	};
+	struct fscrypt_name fname;
 
 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
@@ -4814,9 +4821,15 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 		return btrfs_delete_subvolume(dir, dentry);
 	}
 
+	err = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
+	if (err)
+		return err;
+
 	trans = __unlink_start_trans(dir);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto out_notrans;
+	}
 
 	if (unlikely(btrfs_ino(BTRFS_I(inode)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
 		err = btrfs_unlink_subvol(trans, dir, dentry);
@@ -4850,7 +4863,9 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	}
 out:
 	btrfs_end_transaction(trans);
+out_notrans:
 	btrfs_btree_balance_dirty(fs_info);
+	fscrypt_free_filename(&fname);
 
 	return err;
 }
@@ -5544,7 +5559,7 @@ void btrfs_evict_inode(struct inode *inode)
 
 /*
  * Return the key found in the dir entry in the location pointer, fill @type
- * with BTRFS_FT_*, and return 0.
+ * with BTRFS_FT_*, and return 0. Used only for lookups, not removals.
  *
  * If no dir entries were found, returns -ENOENT.
  * If found a corrupted location in dir entry, returns -EUCLEAN.
@@ -5556,15 +5571,16 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	struct btrfs_path *path;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	int ret = 0;
-	struct fscrypt_name fname = {
-		.disk_name = FSTR_INIT((char *) dentry->d_name.name,
-				       dentry->d_name.len)
-	};
+	struct fscrypt_name fname;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
+	ret = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
+	if (ret)
+		goto out;
+
 	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(BTRFS_I(dir)),
 				   &fname, 0);
 	if (IS_ERR_OR_NULL(di)) {
@@ -5584,6 +5600,7 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	if (!ret)
 		*type = btrfs_dir_ftype(path->nodes[0], di);
 out:
+	fscrypt_free_filename(&fname);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -5604,9 +5621,15 @@ static int fixup_tree_root_location(struct btrfs_fs_info *fs_info,
 	struct btrfs_root_ref *ref;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
+	struct fscrypt_name fname;
 	int ret;
 	int err = 0;
 
+	ret = fscrypt_setup_filename(dir, &dentry->d_name, 0,
+				     &fname);
+	if (ret)
+		return ret;
+
 	path = btrfs_alloc_path();
 	if (!path) {
 		err = -ENOMEM;
@@ -5652,6 +5675,7 @@ static int fixup_tree_root_location(struct btrfs_fs_info *fs_info,
 	err = 0;
 out:
 	btrfs_free_path(path);
+	fscrypt_free_filename(&fname);
 	return err;
 }
 
@@ -6258,16 +6282,17 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 	struct inode *inode = args->inode;
 	int ret;
 
+	if (!args->orphan) {
+		ret = fscrypt_setup_filename(dir, &args->dentry->d_name, 0,
+					     &args->fname);
+		if (ret)
+			return ret;
+	}
+
 	ret = posix_acl_create(dir, &inode->i_mode, &args->default_acl, &args->acl);
-	if (ret)
+	if (ret) {
+		fscrypt_free_filename(&args->fname);
 		return ret;
-
-	if (!args->orphan) {
-		char *name = (char *) args->dentry->d_name.name;
-		int name_len = args->dentry->d_name.len;
-		args->fname = (struct fscrypt_name) {
-			.disk_name = FSTR_INIT(name, name_len),
-		};
 	}
 
 	/* 1 to add inode item */
@@ -6308,6 +6333,7 @@ void btrfs_new_inode_args_destroy(struct btrfs_new_inode_args *args)
 {
 	posix_acl_release(args->acl);
 	posix_acl_release(args->default_acl);
+	fscrypt_free_filename(&args->fname);
 }
 
 /*
@@ -6735,10 +6761,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct inode *inode = d_inode(old_dentry);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct fscrypt_name fname = {
-		.disk_name = FSTR_INIT((char *) dentry->d_name.name,
-				       dentry->d_name.len)
-	};
+	struct fscrypt_name fname;
 	u64 index;
 	int err;
 	int drop_inode = 0;
@@ -6750,6 +6773,10 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (inode->i_nlink >= BTRFS_LINK_MAX)
 		return -EMLINK;
 
+	err = fscrypt_setup_filename(dir, &dentry->d_name, 0, &fname);
+	if (err)
+		goto fail;
+
 	err = btrfs_set_inode_index(BTRFS_I(dir), &index);
 	if (err)
 		goto fail;
@@ -6800,6 +6827,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	}
 
 fail:
+	fscrypt_free_filename(&fname);
 	if (trans)
 		btrfs_end_transaction(trans);
 	if (drop_inode) {
@@ -9181,14 +9209,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	int ret;
 	int ret2;
 	bool need_abort = false;
-	struct fscrypt_name old_name = {
-		.disk_name = FSTR_INIT((char *) old_dentry->d_name.name,
-				       old_dentry->d_name.len)
-	};
-	struct fscrypt_name new_name = {
-		.disk_name = FSTR_INIT((char *) new_dentry->d_name.name,
-				       new_dentry->d_name.len)
-	};
+	struct fscrypt_name old_fname, new_fname;
 
 	/*
 	 * For non-subvolumes allow exchange only within one subvolume, in the
@@ -9200,6 +9221,16 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	     new_ino != BTRFS_FIRST_FREE_OBJECTID))
 		return -EXDEV;
 
+	ret = fscrypt_setup_filename(old_dir, &old_dentry->d_name, 0, &old_fname);
+	if (ret)
+		return ret;
+
+	ret = fscrypt_setup_filename(new_dir, &new_dentry->d_name, 0, &new_fname);
+	if (ret) {
+		fscrypt_free_filename(&old_fname);
+		return ret;
+	}
+
 	/* close the race window with snapshot create/destroy ioctl */
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID ||
 	    new_ino == BTRFS_FIRST_FREE_OBJECTID)
@@ -9267,7 +9298,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		/* force full log commit if subvolume involved. */
 		btrfs_set_log_full_commit(trans);
 	} else {
-		ret = btrfs_insert_inode_ref(trans, dest, &new_name, old_ino,
+		ret = btrfs_insert_inode_ref(trans, dest, &new_fname, old_ino,
 					     btrfs_ino(BTRFS_I(new_dir)),
 					     old_idx);
 		if (ret)
@@ -9280,7 +9311,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		/* force full log commit if subvolume involved. */
 		btrfs_set_log_full_commit(trans);
 	} else {
-		ret = btrfs_insert_inode_ref(trans, root, &old_name, new_ino,
+		ret = btrfs_insert_inode_ref(trans, root, &old_fname, new_ino,
 					     btrfs_ino(BTRFS_I(old_dir)),
 					     new_idx);
 		if (ret) {
@@ -9314,7 +9345,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		ret = btrfs_unlink_subvol(trans, old_dir, old_dentry);
 	} else { /* src is an inode */
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
-					   BTRFS_I(old_dentry->d_inode), &old_name,
+					   BTRFS_I(old_dentry->d_inode), &old_fname,
 					   &old_rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, root, BTRFS_I(old_inode));
@@ -9329,7 +9360,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 		ret = btrfs_unlink_subvol(trans, new_dir, new_dentry);
 	} else { /* dest is an inode */
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(new_dir),
-					   BTRFS_I(new_dentry->d_inode), &new_name,
+					   BTRFS_I(new_dentry->d_inode), &new_fname,
 					   &new_rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, dest, BTRFS_I(new_inode));
@@ -9340,14 +9371,14 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	}
 
 	ret = btrfs_add_link(trans, BTRFS_I(new_dir), BTRFS_I(old_inode),
-			     &new_name, 0, old_idx);
+			     &new_fname, 0, old_idx);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_fail;
 	}
 
 	ret = btrfs_add_link(trans, BTRFS_I(old_dir), BTRFS_I(new_inode),
-			     &old_name, 0, new_idx);
+			     &old_fname, 0, new_idx);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_fail;
@@ -9390,6 +9421,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	    old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&fs_info->subvol_sem);
 
+	fscrypt_free_filename(&new_fname);
+	fscrypt_free_filename(&old_fname);
 	return ret;
 }
 
@@ -9429,14 +9462,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 	int ret;
 	int ret2;
 	u64 old_ino = btrfs_ino(BTRFS_I(old_inode));
-	struct fscrypt_name old_fname = {
-		.disk_name = FSTR_INIT((char *)old_dentry->d_name.name,
-				       old_dentry->d_name.len)
-	};
-	struct fscrypt_name new_fname = {
-		.disk_name = FSTR_INIT((char *)new_dentry->d_name.name,
-				       new_dentry->d_name.len)
-	};
+	struct fscrypt_name old_fname, new_fname;
 
 	if (btrfs_ino(BTRFS_I(new_dir)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
 		return -EPERM;
@@ -9453,6 +9479,16 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 	    new_inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
 
+	ret = fscrypt_setup_filename(old_dir, &old_dentry->d_name, 0, &old_fname);
+	if (ret)
+		return ret;
+
+	ret = fscrypt_setup_filename(new_dir, &new_dentry->d_name, 0, &new_fname);
+	if (ret) {
+		fscrypt_free_filename(&old_fname);
+		return ret;
+	}
+
 	/* check for collisions, even if the  name isn't there */
 	ret = btrfs_check_dir_item_collision(dest, new_dir->i_ino, &new_fname);
 
@@ -9461,11 +9497,11 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 			/* we shouldn't get
 			 * eexist without a new_inode */
 			if (WARN_ON(!new_inode)) {
-				return ret;
+				goto out_fscrypt_names;
 			}
 		} else {
 			/* maybe -EOVERFLOW */
-			return ret;
+			goto out_fscrypt_names;
 		}
 	}
 	ret = 0;
@@ -9639,6 +9675,9 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 out_whiteout_inode:
 	if (flags & RENAME_WHITEOUT)
 		iput(whiteout_args.inode);
+out_fscrypt_names:
+	fscrypt_free_filename(&old_fname);
+	fscrypt_free_filename(&new_fname);
 	return ret;
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3d1459dccc8d..c95cd917b54f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -6,6 +6,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/writeback.h>
 #include <linux/pagemap.h>
 #include <linux/blkdev.h>
@@ -1660,10 +1661,8 @@ create_pending_snapshot(struct btrfs_trans_handle *trans,
 	u64 index = 0;
 	u64 objectid;
 	u64 root_flags;
-	struct fscrypt_name fname = {
-		.disk_name = FSTR_INIT((char *) pending->dentry->d_name.name,
-				       pending->dentry->d_name.len)
-	};
+	unsigned int mem_flags;
+	struct fscrypt_name fname;
 
 	ASSERT(pending->path);
 	path = pending->path;
@@ -1671,9 +1670,22 @@ create_pending_snapshot(struct btrfs_trans_handle *trans,
 	ASSERT(pending->root_item);
 	new_root_item = pending->root_item;
 
+	/*
+	 * Since this is during btrfs_commit_transaction() and more items
+	 * joining the transaction at this point would be bad, use NOFS
+	 * allocations so that no new writes are kicked off.
+	 */
+	mem_flags = memalloc_nofs_save();
+	pending->error = fscrypt_setup_filename(parent_inode,
+						&pending->dentry->d_name, 0,
+						&fname);
+	memalloc_nofs_restore(mem_flags);
+	if (pending->error)
+		goto free_pending;
+
 	pending->error = btrfs_get_free_objectid(tree_root, &objectid);
 	if (pending->error)
-		goto no_free_objectid;
+		goto free_fname;
 
 	/*
 	 * Make qgroup to skip current new snapshot's qgroupid, as it is
@@ -1887,7 +1899,9 @@ create_pending_snapshot(struct btrfs_trans_handle *trans,
 	trans->bytes_reserved = 0;
 clear_skip_qgroup:
 	btrfs_clear_skip_qgroup(trans);
-no_free_objectid:
+free_fname:
+	fscrypt_free_filename(&fname);
+free_pending:
 	kfree(new_root_item);
 	pending->root_item = NULL;
 	btrfs_free_path(path);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 0cd515e02fe4..ee7b80d953e9 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6906,13 +6906,13 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 	if (old_dir && old_dir->logged_trans == trans->transid) {
 		struct btrfs_root *log = old_dir->root->log_root;
 		struct btrfs_path *path;
-		struct fscrypt_name fname = {
-			.disk_name = FSTR_INIT((char *) old_dentry->d_name.name,
-					       old_dentry->d_name.len)
-		};
-
+		struct fscrypt_name fname;
 		ASSERT(old_dir_index >= BTRFS_DIR_START_INDEX);
 
+		ret = fscrypt_setup_filename(&old_dir->vfs_inode,
+					     &old_dentry->d_name, 0, &fname);
+		if (ret)
+			goto out;
 		/*
 		 * We have two inodes to update in the log, the old directory and
 		 * the inode that got renamed, so we must pin the log to prevent
@@ -6932,6 +6932,7 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 		path = btrfs_alloc_path();
 		if (!path) {
 			ret = -ENOMEM;
+			fscrypt_free_filename(&fname);
 			goto out;
 		}
 
@@ -6961,6 +6962,7 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 		mutex_unlock(&old_dir->log_mutex);
 
 		btrfs_free_path(path);
+		fscrypt_free_filename(&fname);
 		if (ret < 0)
 			goto out;
 	}
-- 
2.35.1

