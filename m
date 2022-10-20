Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33941606686
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 19:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiJTQ7w (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 12:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiJTQ7v (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 12:59:51 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3602F264A8;
        Thu, 20 Oct 2022 09:59:47 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id EEE6180040;
        Thu, 20 Oct 2022 12:59:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666285157; bh=AYTDDi6t+y5XEct+X1w2qAKrG6BY3R/4Gsf8I40d8jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1+WG1JdNQVW0Z7NUT4OkX9mEOIGpi4jsJ6N+fLua7Ao3J0MaC0yIjOPwNS9mmZ8b
         Nj51UJ65noarofpTWCXhp32i1JSOtfeghgeIUyGWNZ6gRbk91VAYRz6Qqylhq/mZ9j
         4dKi2XrKOGLuHOauAcNJxApC3/j2U6k3qUpzsr3iRii/EXpfQyS8lZHyuuHWIXepAv
         2ZmzGpdG5cF4vjS0oDXpYnXjXz5juqiWB3jHxvz3xUWrLzzkbGPMfNj3Y+SzI3Vch+
         q5ER+6ncolM5MbUtcUIOnL3+tgD1rhX/sndI9bqZhah/wuxR08KDn9Kiaevyuc4KuE
         u8h5xNZu06rTQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 09/22] btrfs: store directory encryption state
Date:   Thu, 20 Oct 2022 12:58:28 -0400
Message-Id: <166f66417363fa627bfa2df4220069d4d062bfee.1666281277.git.sweettea-kernel@dorminy.me>
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

From: Omar Sandoval <osandov@osandov.com>

For directories with encrypted files/filenames, we need to store a flag
indicating this fact. There's no room in other fields, so we'll need to
borrow a bit from dir_type. Since it's now a combination of type and
flags, we rename it to dir_flags to reflect its new usage.

The new flag, FT_ENCRYPTED, indicates a directory containing encrypted
data, which is orthogonal to file type; therefore, add the new
flag, and make conversion from directory type to file type strip the
flag.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/ctree.h                | 15 +++++++++++++--
 fs/btrfs/delayed-inode.c        |  6 +++---
 fs/btrfs/delayed-inode.h        |  2 +-
 fs/btrfs/dir-item.c             |  7 +++++--
 fs/btrfs/inode.c                | 13 +++++++------
 fs/btrfs/print-tree.c           |  4 ++--
 fs/btrfs/send.c                 |  2 +-
 fs/btrfs/tree-checker.c         |  2 +-
 fs/btrfs/tree-log.c             | 20 ++++++++++----------
 include/uapi/linux/btrfs_tree.h |  7 +++++++
 10 files changed, 50 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9d1186a16912..38aef923c33b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1935,10 +1935,10 @@ BTRFS_SETGET_FUNCS(root_ref_name_len, struct btrfs_root_ref, name_len, 16);
 
 /* struct btrfs_dir_item */
 BTRFS_SETGET_FUNCS(dir_data_len, struct btrfs_dir_item, data_len, 16);
-BTRFS_SETGET_FUNCS(dir_type, struct btrfs_dir_item, type, 8);
+BTRFS_SETGET_FUNCS(dir_flags, struct btrfs_dir_item, type, 8);
 BTRFS_SETGET_FUNCS(dir_name_len, struct btrfs_dir_item, name_len, 16);
 BTRFS_SETGET_FUNCS(dir_transid, struct btrfs_dir_item, transid, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_dir_type, struct btrfs_dir_item, type, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_dir_flags, struct btrfs_dir_item, type, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_dir_data_len, struct btrfs_dir_item,
 			 data_len, 16);
 BTRFS_SETGET_STACK_FUNCS(stack_dir_name_len, struct btrfs_dir_item,
@@ -1946,6 +1946,17 @@ BTRFS_SETGET_STACK_FUNCS(stack_dir_name_len, struct btrfs_dir_item,
 BTRFS_SETGET_STACK_FUNCS(stack_dir_transid, struct btrfs_dir_item,
 			 transid, 64);
 
+static inline u8 btrfs_dir_ftype(const struct extent_buffer *eb,
+				 const struct btrfs_dir_item *item)
+{
+	return btrfs_dir_flags_to_ftype(btrfs_dir_flags(eb, item));
+}
+
+static inline u8 btrfs_stack_dir_ftype(const struct btrfs_dir_item *item)
+{
+	return btrfs_dir_flags_to_ftype(btrfs_stack_dir_flags(item));
+}
+
 static inline void btrfs_dir_item_key(const struct extent_buffer *eb,
 				      const struct btrfs_dir_item *item,
 				      struct btrfs_disk_key *key)
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index a411f04a7b97..3a492c8aa1ee 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1413,7 +1413,7 @@ void btrfs_balance_delayed_items(struct btrfs_fs_info *fs_info)
 int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 				   const char *name, int name_len,
 				   struct btrfs_inode *dir,
-				   struct btrfs_disk_key *disk_key, u8 type,
+				   struct btrfs_disk_key *disk_key, u8 flags,
 				   u64 index)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
@@ -1444,7 +1444,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_dir_transid(dir_item, trans->transid);
 	btrfs_set_stack_dir_data_len(dir_item, 0);
 	btrfs_set_stack_dir_name_len(dir_item, name_len);
-	btrfs_set_stack_dir_type(dir_item, type);
+	btrfs_set_stack_dir_flags(dir_item, flags);
 	memcpy((char *)(dir_item + 1), name, name_len);
 
 	data_len = delayed_item->data_len + sizeof(struct btrfs_item);
@@ -1754,7 +1754,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 		name = (char *)(di + 1);
 		name_len = btrfs_stack_dir_name_len(di);
 
-		d_type = fs_ftype_to_dtype(di->type);
+		d_type = fs_ftype_to_dtype(btrfs_dir_flags_to_ftype(di->type));
 		btrfs_disk_key_to_cpu(&location, &di->location);
 
 		over = !dir_emit(ctx, name, name_len,
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 0163ca637a96..4f21daa3dbc7 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -113,7 +113,7 @@ static inline void btrfs_init_delayed_root(
 int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 				   const char *name, int name_len,
 				   struct btrfs_inode *dir,
-				   struct btrfs_disk_key *disk_key, u8 type,
+				   struct btrfs_disk_key *disk_key, u8 flags,
 				   u64 index);
 
 int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index fdab48c1abb8..f6987823903b 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -81,7 +81,7 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 	leaf = path->nodes[0];
 	btrfs_cpu_key_to_disk(&disk_key, &location);
 	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
-	btrfs_set_dir_type(leaf, dir_item, BTRFS_FT_XATTR);
+	btrfs_set_dir_flags(leaf, dir_item, BTRFS_FT_XATTR);
 	btrfs_set_dir_name_len(leaf, dir_item, name_len);
 	btrfs_set_dir_transid(leaf, dir_item, trans->transid);
 	btrfs_set_dir_data_len(leaf, dir_item, data_len);
@@ -138,9 +138,12 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 		goto out_free;
 	}
 
+	if (IS_ENCRYPTED(&dir->vfs_inode))
+		type |= BTRFS_FT_ENCRYPTED;
+
 	leaf = path->nodes[0];
 	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
-	btrfs_set_dir_type(leaf, dir_item, type);
+	btrfs_set_dir_flags(leaf, dir_item, type);
 	btrfs_set_dir_data_len(leaf, dir_item, 0);
 	btrfs_set_dir_name_len(leaf, dir_item, name->len);
 	btrfs_set_dir_transid(leaf, dir_item, trans->transid);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b36e1bfdadd5..b2728e95a7b9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5594,7 +5594,7 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 			   location->objectid, location->type, location->offset);
 	}
 	if (!ret)
-		*type = btrfs_dir_type(path->nodes[0], di);
+		*type = btrfs_dir_ftype(path->nodes[0], di);
 out:
 	fscrypt_free_filename(&fname);
 	btrfs_free_path(path);
@@ -6044,6 +6044,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	btrfs_for_each_slot(root, &key, &found_key, path, ret) {
 		struct dir_entry *entry;
 		struct extent_buffer *leaf = path->nodes[0];
+		u8 ftype;
 
 		if (found_key.objectid != key.objectid)
 			break;
@@ -6067,13 +6068,13 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 			goto again;
 		}
 
+		ftype = btrfs_dir_flags_to_ftype(btrfs_dir_flags(leaf, di));
 		entry = addr;
-		put_unaligned(name_len, &entry->name_len);
 		name_ptr = (char *)(entry + 1);
-		read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
-				   name_len);
-		put_unaligned(fs_ftype_to_dtype(btrfs_dir_type(leaf, di)),
-				&entry->type);
+		read_extent_buffer(leaf, name_ptr,
+				   (unsigned long)(di + 1), name_len);
+		put_unaligned(name_len, &entry->name_len);
+		put_unaligned(fs_ftype_to_dtype(ftype), &entry->type);
 		btrfs_dir_item_key_to_cpu(leaf, di, &location);
 		put_unaligned(location.objectid, &entry->ino);
 		put_unaligned(found_key.offset, &entry->offset);
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index dd8777872143..6d9d99bf3536 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -240,9 +240,9 @@ void btrfs_print_leaf(struct extent_buffer *l)
 		case BTRFS_DIR_ITEM_KEY:
 			di = btrfs_item_ptr(l, i, struct btrfs_dir_item);
 			btrfs_dir_item_key_to_cpu(l, di, &found_key);
-			pr_info("\t\tdir oid %llu type %u\n",
+			pr_info("\t\tdir oid %llu flags %u\n",
 				found_key.objectid,
-				btrfs_dir_type(l, di));
+				btrfs_dir_flags(l, di));
 			break;
 		case BTRFS_ROOT_ITEM_KEY:
 			ri = btrfs_item_ptr(l, i, struct btrfs_root_item);
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index dcca2f733af1..526b323955fb 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1093,7 +1093,7 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 		data_len = btrfs_dir_data_len(eb, di);
 		btrfs_dir_item_key_to_cpu(eb, di, &di_key);
 
-		if (btrfs_dir_type(eb, di) == BTRFS_FT_XATTR) {
+		if (btrfs_dir_ftype(eb, di) == BTRFS_FT_XATTR) {
 			if (name_len > XATTR_NAME_MAX) {
 				ret = -ENAMETOOLONG;
 				goto out;
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 43f905ab0a18..77c53a7491cf 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -528,7 +528,7 @@ static int check_dir_item(struct extent_buffer *leaf,
 		}
 
 		/* dir type check */
-		dir_type = btrfs_dir_type(leaf, di);
+		dir_type = btrfs_dir_ftype(leaf, di);
 		if (unlikely(dir_type >= BTRFS_FT_MAX)) {
 			dir_item_err(leaf, slot,
 			"invalid dir item type, have %u expect [0, %u)",
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 078869dbb68f..7db1fa23e001 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1798,7 +1798,7 @@ static int delete_conflicting_dir_entry(struct btrfs_trans_handle *trans,
 					struct btrfs_path *path,
 					struct btrfs_dir_item *dst_di,
 					const struct btrfs_key *log_key,
-					u8 log_type,
+					u8 log_flags,
 					bool exists)
 {
 	struct btrfs_key found_key;
@@ -1808,7 +1808,7 @@ static int delete_conflicting_dir_entry(struct btrfs_trans_handle *trans,
 	if (found_key.objectid == log_key->objectid &&
 	    found_key.type == log_key->type &&
 	    found_key.offset == log_key->offset &&
-	    btrfs_dir_type(path->nodes[0], dst_di) == log_type)
+	    btrfs_dir_flags(path->nodes[0], dst_di) == log_flags)
 		return 1;
 
 	/*
@@ -1852,7 +1852,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	struct btrfs_key log_key;
 	struct btrfs_key search_key;
 	struct inode *dir;
-	u8 log_type;
+	u8 log_flags;
 	bool exists;
 	int ret;
 	bool update_size = true;
@@ -1866,7 +1866,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	log_type = btrfs_dir_type(eb, di);
+	log_flags = btrfs_dir_flags(eb, di);
 	btrfs_dir_item_key_to_cpu(eb, di, &log_key);
 	ret = btrfs_lookup_inode(trans, root, path, &log_key, 0);
 	btrfs_release_path(path);
@@ -1882,8 +1882,8 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 		goto out;
 	} else if (dir_dst_di) {
 		ret = delete_conflicting_dir_entry(trans, BTRFS_I(dir), path,
-						   dir_dst_di, &log_key, log_type,
-						   exists);
+						   dir_dst_di, &log_key,
+						   log_flags, exists);
 		if (ret < 0)
 			goto out;
 		dir_dst_matches = (ret == 1);
@@ -1900,7 +1900,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	} else if (index_dst_di) {
 		ret = delete_conflicting_dir_entry(trans, BTRFS_I(dir), path,
 						   index_dst_di, &log_key,
-						   log_type, exists);
+						   log_flags, exists);
 		if (ret < 0)
 			goto out;
 		index_dst_matches = (ret == 1);
@@ -2009,7 +2009,7 @@ static noinline int replay_one_dir_item(struct btrfs_trans_handle *trans,
 	 * to ever delete the parent directory has it would result in stale
 	 * dentries that can never be deleted.
 	 */
-	if (ret == 1 && btrfs_dir_type(eb, di) != BTRFS_FT_DIR) {
+	if (ret == 1 && btrfs_dir_ftype(eb, di) != BTRFS_FT_DIR) {
 		struct btrfs_path *fixup_path;
 		struct btrfs_key di_key;
 
@@ -5400,7 +5400,7 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 			}
 
 			di = btrfs_item_ptr(leaf, i, struct btrfs_dir_item);
-			type = btrfs_dir_type(leaf, di);
+			type = btrfs_dir_ftype(leaf, di);
 			if (btrfs_dir_transid(leaf, di) < trans->transid)
 				continue;
 			btrfs_dir_item_key_to_cpu(leaf, di, &di_key);
@@ -6240,7 +6240,7 @@ static int log_new_delayed_dentries(struct btrfs_trans_handle *trans,
 			continue;
 		}
 
-		if (btrfs_stack_dir_type(dir_item) == BTRFS_FT_DIR)
+		if (btrfs_stack_dir_ftype(dir_item) == BTRFS_FT_DIR)
 			log_mode = LOG_INODE_ALL;
 
 		ctx->log_new_dentries = false;
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index f6eb8a0aee6e..10c3c41329bc 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -375,6 +375,13 @@ enum btrfs_csum_type {
 #define BTRFS_FT_SYMLINK	7
 #define BTRFS_FT_XATTR		8
 #define BTRFS_FT_MAX		9
+/* Directory contains encrypted data */
+#define BTRFS_FT_ENCRYPTED	0x80
+
+static inline __u8 btrfs_dir_flags_to_ftype(__u8 flags)
+{
+	return flags & ~BTRFS_FT_ENCRYPTED;
+}
 
 /*
  * Inode flags
-- 
2.35.1

