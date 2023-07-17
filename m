Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798DF755A3F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 05:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjGQDxV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 23:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjGQDxG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 23:53:06 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E4DE6B;
        Sun, 16 Jul 2023 20:53:03 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id E31EF8341B;
        Sun, 16 Jul 2023 23:53:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689565983; bh=ctyuc+b/zxpML8wXTBRZxX30mNT64zxxhbE0RPGPJuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/kRs66geUBATSkbghIfvGXPHHA5BXieV6kBttmXDZsLyAHzMDn39vteSKQY/chlV
         UN80ytJRgYisYJ2ZZmeTr/gY2uU9EtOqb7vKfpV44sGJaodZnnXUj9+La1uUrhZl/F
         6MSS/nHPMLkUKkhECC9oyisFWw1zM+z0UCNdVs6wpZAqKNJt/ejROBQwWvNJBZQv+r
         JcS1ODTxJ4zoINm7VgMHt+gee3WnB3LoTGT6fKQTf1WkJF9wr+FYgW8tu4OYuUg/mL
         1mvvpoPxuMJyDFUKFUZuKEW+xSt6X8juoEQYenCuLSdSAjv+aChLZ9Y1+hCVRiu7zk
         ZNb3gMv8hRf/Q==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 07/17] btrfs: adapt readdir for encrypted and nokey names
Date:   Sun, 16 Jul 2023 23:52:38 -0400
Message-Id: <ba4d9065b8109ea74fc1c5bed788e45c95a07e75.1689564024.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1689564024.git.sweettea-kernel@dorminy.me>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

Deleting an encrypted file must always be permitted, even if the user
does not have the appropriate key. Therefore, for listing an encrypted
directory, so-called 'nokey' names are provided, and these nokey names
must be sufficient to look up and delete the appropriate encrypted
files. See 'struct fscrypt_nokey_name' for more information on the
format of these names.

The first part of supporting nokey names is allowing lookups by nokey
name. Only a few entry points need to support these: deleting a
directory, file, or subvolume -- each of these call
fscrypt_setup_filename() with a '1' argument, indicating that the key is
not required and therefore a nokey name may be provided. If a nokey name
is provided, the fscrypt_name returned by fscrypt_setup_filename() will
not have its disk_name field populated, but will have various other
fields set.

This change alters the relevant codepaths to pass a complete
fscrypt_name anywhere that it might contain a nokey name. When it does
contain a nokey name, the first time the name is successfully matched to
a stored name populates the disk name field of the fscrypt_name,
allowing the caller to use the normal disk name codepaths afterward.
Otherwise, the matching functionality is in close analogue to the
function fscrypt_match_name().

Functions where most callers are providing a fscrypt_str are duplicated
and adapted for a fscrypt_name, and functions where most callers are
providing a fscrypt_name are changed to so require at all callsites.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/btrfs_inode.h   |   2 +-
 fs/btrfs/delayed-inode.c |  30 +++++++-
 fs/btrfs/delayed-inode.h |   4 +-
 fs/btrfs/dir-item.c      |  77 ++++++++++++++++++---
 fs/btrfs/dir-item.h      |  13 +++-
 fs/btrfs/extent_io.c     |  38 +++++++++++
 fs/btrfs/extent_io.h     |   3 +
 fs/btrfs/fscrypt.c       |  46 +++++++++++++
 fs/btrfs/fscrypt.h       |  19 ++++++
 fs/btrfs/inode.c         | 143 ++++++++++++++++++++++++++-------------
 fs/btrfs/root-tree.c     |   8 ++-
 fs/btrfs/root-tree.h     |   2 +-
 fs/btrfs/tree-log.c      |   3 +-
 13 files changed, 320 insertions(+), 68 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ec4a06a78aff..464059674ae5 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -421,7 +421,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
 int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
-		       const struct fscrypt_str *name);
+		       struct fscrypt_name *name);
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
 		   const struct fscrypt_str *name, int add_backref, u64 index);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 6b457b010cbc..919303d29b76 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1497,6 +1497,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 
 	ret = __btrfs_add_delayed_item(delayed_node, delayed_item);
 	if (unlikely(ret)) {
+		// TODO: It would be nice to print the base64encoded name here maybe?
 		btrfs_err(trans->fs_info,
 			  "err add delayed dir index item(name: %.*s) into the insertion tree of the delayed node(root id: %llu, inode id: %llu, errno: %d)",
 			  name_len, name, delayed_node->root->root_key.objectid,
@@ -1724,7 +1725,9 @@ int btrfs_should_delete_dir_index(struct list_head *del_list,
  * btrfs_readdir_delayed_dir_index - read dir info stored in the delayed tree
  *
  */
-int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
+int btrfs_readdir_delayed_dir_index(struct inode *inode,
+				    struct fscrypt_str *fstr,
+				    struct dir_context *ctx,
 				    struct list_head *ins_list)
 {
 	struct btrfs_dir_item *di;
@@ -1734,6 +1737,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 	int name_len;
 	int over = 0;
 	unsigned char d_type;
+	size_t fstr_len = fstr->len;
 
 	if (list_empty(ins_list))
 		return 0;
@@ -1761,8 +1765,28 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 		d_type = fs_ftype_to_dtype(btrfs_dir_flags_to_ftype(di->type));
 		btrfs_disk_key_to_cpu(&location, &di->location);
 
-		over = !dir_emit(ctx, name, name_len,
-			       location.objectid, d_type);
+		if (di->type & BTRFS_FT_ENCRYPTED) {
+			int ret;
+			struct fscrypt_str iname = FSTR_INIT(name, name_len);
+
+			fstr->len = fstr_len;
+			/*
+			 * The hash is only used when the encryption key is not
+			 * available. But if we have delayed insertions, then we
+			 * must have the encryption key available or we wouldn't
+			 * have been able to create entries in the directory.
+			 * So, we don't calculate the hash.
+			 */
+			ret = fscrypt_fname_disk_to_usr(inode, 0, 0, &iname,
+							fstr);
+			if (ret)
+				return ret;
+			over = !dir_emit(ctx, fstr->name, fstr->len,
+					 location.objectid, d_type);
+		} else {
+			over = !dir_emit(ctx, name, name_len, location.objectid,
+					 d_type);
+		}
 
 		if (refcount_dec_and_test(&curr->refs))
 			kfree(curr);
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 4f21daa3dbc7..a4f9fa27b126 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -155,7 +155,9 @@ void btrfs_readdir_put_delayed_items(struct inode *inode,
 				     struct list_head *del_list);
 int btrfs_should_delete_dir_index(struct list_head *del_list,
 				  u64 index);
-int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
+int btrfs_readdir_delayed_dir_index(struct inode *inode,
+				    struct fscrypt_str *fstr,
+				    struct dir_context *ctx,
 				    struct list_head *ins_list);
 
 /* Used during directory logging. */
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 082eb0e19598..da95ae411d72 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -6,6 +6,7 @@
 #include "messages.h"
 #include "ctree.h"
 #include "disk-io.h"
+#include "fscrypt.h"
 #include "transaction.h"
 #include "accessors.h"
 #include "dir-item.h"
@@ -230,6 +231,47 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 	return di;
 }
 
+/*
+ * Lookup for a directory item by fscrypt_name.
+ *
+ * @trans:	The transaction handle to use.
+ * @root:	The root of the target tree.
+ * @path:	Path to use for the search.
+ * @dir:	The inode number (objectid) of the directory.
+ * @name:	The fscrypt_name associated to the directory entry
+ * @mod:	Used to indicate if the tree search is meant for a read only
+ *		lookup or for a deletion lookup, so its value should be 0 or
+ *		-1, respectively.
+ *
+ * Returns: NULL if the dir item does not exists, an error pointer if an error
+ * happened, or a pointer to a dir item if a dir item exists for the given name.
+ */
+struct btrfs_dir_item *btrfs_lookup_dir_item_fname(struct btrfs_trans_handle *trans,
+						   struct btrfs_root *root,
+						   struct btrfs_path *path, u64 dir,
+						   struct fscrypt_name *name, int mod)
+{
+	struct btrfs_key key;
+	struct btrfs_dir_item *di = NULL;
+	int ret = 0;
+
+	key.objectid = dir;
+	key.type = BTRFS_DIR_ITEM_KEY;
+	key.offset = btrfs_name_hash(name->disk_name.name, name->disk_name.len);
+	/* XXX get the right hash for no-key names */
+
+	ret = btrfs_search_slot(trans, root, &key, path, mod, -mod);
+	if (ret == 0)
+		di = btrfs_match_dir_item_fname(root->fs_info, path, name);
+
+	if (ret == -ENOENT || (di && IS_ERR(di) && PTR_ERR(di) == -ENOENT))
+		return NULL;
+	if (ret < 0)
+		di = ERR_PTR(ret);
+
+	return di;
+}
+
 int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 				   const struct fscrypt_str *name)
 {
@@ -287,9 +329,9 @@ int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 }
 
 /*
- * Lookup for a directory index item by name and index number.
+ * Lookup for a directory index item by fscrypt_name and index number.
  *
- * @trans:	The transaction handle to use. Can be NULL if @mod is 0.
+ * @trans:	The transaction handle to use.
  * @root:	The root of the target tree.
  * @path:	Path to use for the search.
  * @dir:	The inode number (objectid) of the directory.
@@ -327,7 +369,7 @@ btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
 
 struct btrfs_dir_item *
 btrfs_search_dir_index_item(struct btrfs_root *root, struct btrfs_path *path,
-			    u64 dirid, const struct fscrypt_str *name)
+			    u64 dirid, struct fscrypt_name *name)
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
@@ -340,9 +382,7 @@ btrfs_search_dir_index_item(struct btrfs_root *root, struct btrfs_path *path,
 	btrfs_for_each_slot(root, &key, &key, path, ret) {
 		if (key.objectid != dirid || key.type != BTRFS_DIR_INDEX_KEY)
 			break;
-
-		di = btrfs_match_dir_item_name(root->fs_info, path,
-					       name->name, name->len);
+		di = btrfs_match_dir_item_fname(root->fs_info, path, name);
 		if (di)
 			return di;
 	}
@@ -378,9 +418,9 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
  * this walks through all the entries in a dir item and finds one
  * for a specific name.
  */
-struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
-						 struct btrfs_path *path,
-						 const char *name, int name_len)
+struct btrfs_dir_item *btrfs_match_dir_item_fname(struct btrfs_fs_info *fs_info,
+						  struct btrfs_path *path,
+						  struct fscrypt_name *name)
 {
 	struct btrfs_dir_item *dir_item;
 	unsigned long name_ptr;
@@ -399,8 +439,8 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 			btrfs_dir_data_len(leaf, dir_item);
 		name_ptr = (unsigned long)(dir_item + 1);
 
-		if (btrfs_dir_name_len(leaf, dir_item) == name_len &&
-		    memcmp_extent_buffer(leaf, name, name_ptr, name_len) == 0)
+		if (btrfs_fscrypt_match_name(name, leaf, name_ptr,
+					     btrfs_dir_name_len(leaf, dir_item)))
 			return dir_item;
 
 		cur += this_len;
@@ -410,6 +450,21 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 	return NULL;
 }
 
+/*
+ * helper function to look at the directory item pointed to by 'path'
+ * this walks through all the entries in a dir item and finds one
+ * for a specific name.
+ */
+struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
+						 struct btrfs_path *path,
+						 const char *name, int name_len)
+{
+	struct fscrypt_name fname = {
+		.disk_name = FSTR_INIT((char *) name, name_len)
+	};
+	return btrfs_match_dir_item_fname(fs_info, path, &fname);
+}
+
 /*
  * given a pointer into a directory item, delete it.  This
  * handles items that have more than one entry in them.
diff --git a/fs/btrfs/dir-item.h b/fs/btrfs/dir-item.h
index aab4b7cc7fa0..4f42a4f6a4ec 100644
--- a/fs/btrfs/dir-item.h
+++ b/fs/btrfs/dir-item.h
@@ -3,6 +3,8 @@
 #ifndef BTRFS_DIR_ITEM_H
 #define BTRFS_DIR_ITEM_H
 
+#include <linux/fscrypt.h>
+
 int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 			  const struct fscrypt_str *name);
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
@@ -12,6 +14,11 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
 					     struct btrfs_path *path, u64 dir,
 					     const struct fscrypt_str *name, int mod);
+struct btrfs_dir_item *btrfs_lookup_dir_item_fname(
+	struct btrfs_trans_handle *trans,
+	struct btrfs_root *root,
+	struct btrfs_path *path, u64 dir,
+	struct fscrypt_name *name, int mod);
 struct btrfs_dir_item *btrfs_lookup_dir_index_item(
 			struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
@@ -19,7 +26,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_index_item(
 			u64 index, const struct fscrypt_str *name, int mod);
 struct btrfs_dir_item *btrfs_search_dir_index_item(struct btrfs_root *root,
 			    struct btrfs_path *path, u64 dirid,
-			    const struct fscrypt_str *name);
+			    struct fscrypt_name *name);
 int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct btrfs_path *path,
@@ -39,4 +46,8 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 						 const char *name,
 						 int name_len);
 
+struct btrfs_dir_item *btrfs_match_dir_item_fname(struct btrfs_fs_info *fs_info,
+						  struct btrfs_path *path,
+						  struct fscrypt_name *name);
+
 #endif
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a845a90d46f7..35bd673bde3e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4175,6 +4175,44 @@ static void assert_eb_page_uptodate(const struct extent_buffer *eb,
 	}
 }
 
+/* Take a sha256 of a portion of an extent buffer. */
+void extent_buffer_sha256(const struct extent_buffer *eb,
+			  unsigned long start,
+			  unsigned long len, u8 *out)
+{
+	size_t cur;
+	size_t offset;
+	struct page *page;
+	char *kaddr;
+	unsigned long i = get_eb_page_index(start);
+	struct sha256_state sctx;
+
+	if (check_eb_range(eb, start, len))
+		return;
+
+	offset = get_eb_offset_in_page(eb, start);
+
+	/*
+	 * TODO: This should maybe be using the crypto API, not the fallback,
+	 * but fscrypt uses the fallback and this is only used in emulation of
+	 * fscrypt's buffer sha256 method.
+	 */
+	sha256_init(&sctx);
+	while (len > 0) {
+		page = eb->pages[i];
+		assert_eb_page_uptodate(eb, page);
+
+		cur = min(len, PAGE_SIZE - offset);
+		kaddr = page_address(page);
+		sha256_update(&sctx, (u8 *)(kaddr + offset), cur);
+
+		len -= cur;
+		offset = 0;
+		i++;
+	}
+	sha256_final(&sctx, out);
+}
+
 void write_extent_buffer_chunk_tree_uuid(const struct extent_buffer *eb,
 		const void *srcv)
 {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c5fae3a7d911..9dc8c6f3af0f 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -230,6 +230,9 @@ static inline int extent_buffer_uptodate(const struct extent_buffer *eb)
 
 int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
 			 unsigned long start, unsigned long len);
+void extent_buffer_sha256(const struct extent_buffer *eb,
+			  unsigned long start,
+			  unsigned long len, u8 *out);
 void read_extent_buffer(const struct extent_buffer *eb, void *dst,
 			unsigned long start,
 			unsigned long len);
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 1dfddf827cf8..e03157c367a2 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -5,13 +5,59 @@
 #include "accessors.h"
 #include "btrfs_inode.h"
 #include "disk-io.h"
+#include "ioctl.h"
 #include "fs.h"
 #include "fscrypt.h"
 #include "ioctl.h"
 #include "messages.h"
+#include "root-tree.h"
 #include "transaction.h"
 #include "xattr.h"
 
+/*
+ * This function is extremely similar to fscrypt_match_name() but uses an
+ * extent_buffer. Also, it edits the provided argument to populate the disk_name
+ * if we successfully match and previously were using a nokey name.
+ */
+bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
+			      struct extent_buffer *leaf, unsigned long de_name,
+			      u32 de_name_len)
+{
+	const struct fscrypt_nokey_name *nokey_name =
+		(const void *)fname->crypto_buf.name;
+	u8 digest[SHA256_DIGEST_SIZE];
+
+	if (likely(fname->disk_name.name)) {
+		if (de_name_len != fname->disk_name.len)
+			return false;
+		return !memcmp_extent_buffer(leaf, fname->disk_name.name,
+					     de_name, de_name_len);
+	}
+	if (de_name_len <= sizeof(nokey_name->bytes))
+		return false;
+	if (memcmp_extent_buffer(leaf, nokey_name->bytes, de_name,
+				 sizeof(nokey_name->bytes)))
+		return false;
+	extent_buffer_sha256(leaf, de_name + sizeof(nokey_name->bytes),
+			     de_name_len - sizeof(nokey_name->bytes), digest);
+	if (!memcmp(digest, nokey_name->sha256, sizeof(digest))) {
+		/*
+		 * For no-key names, we use this opportunity to find the disk
+		 * name, so future searches don't need to deal with nokey names
+		 * and we know what the encrypted size is.
+		 */
+		fname->disk_name.name = kmalloc(de_name_len, GFP_KERNEL | GFP_NOFS);
+		if (!fname->disk_name.name)
+			fname->disk_name.name = ERR_PTR(-ENOMEM);
+		else
+			read_extent_buffer(leaf, fname->disk_name.name,
+					   de_name, de_name_len);
+		fname->disk_name.len = de_name_len;
+		return true;
+	}
+	return false;
+}
+
 static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
 {
 	struct btrfs_key key = {
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 80adb7e56826..1647bbbcd609 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -4,9 +4,28 @@
 #define BTRFS_FSCRYPT_H
 
 #include <linux/fscrypt.h>
+#include "extent_io.h"
 
 #include "fs.h"
 
+#ifdef CONFIG_FS_ENCRYPTION
+bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
+			      struct extent_buffer *leaf,
+			      unsigned long de_name, u32 de_name_len);
+
+#else
+static inline bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
+					    struct extent_buffer *leaf,
+					    unsigned long de_name,
+					    u32 de_name_len)
+{
+	if (de_name_len != fname_len(fname))
+		return false;
+	return !memcmp_extent_buffer(leaf, fname->disk_name.name, de_name,
+				     de_name_len);
+}
+#endif /* CONFIG_FS_ENCRYPTION */
+
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
 
 #endif /* BTRFS_FSCRYPT_H */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c9898ac2192c..40c2ec328730 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4198,7 +4198,7 @@ int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
 static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 				struct btrfs_inode *dir,
 				struct btrfs_inode *inode,
-				const struct fscrypt_str *name,
+				struct fscrypt_name *name,
 				struct btrfs_rename_ctx *rename_ctx)
 {
 	struct btrfs_root *root = dir->root;
@@ -4216,7 +4216,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino, name, -1);
+	di = btrfs_lookup_dir_item_fname(trans, root, path, dir_ino, name, -1);
 	if (IS_ERR_OR_NULL(di)) {
 		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto err;
@@ -4244,11 +4244,14 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	ret = btrfs_del_inode_ref(trans, root, name, ino, dir_ino, &index);
+	ret = btrfs_del_inode_ref(trans, root, &name->disk_name, ino, dir_ino,
+				  &index);
 	if (ret) {
+		/* This should print a base-64 encoded name if relevant? */
 		btrfs_info(fs_info,
 			"failed to delete reference to %.*s, inode %llu parent %llu",
-			name->len, name->name, ino, dir_ino);
+			name->disk_name.len, name->disk_name.name, ino,
+			dir_ino);
 		btrfs_abort_transaction(trans, ret);
 		goto err;
 	}
@@ -4269,8 +4272,10 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	 * operations on the log tree, increasing latency for applications.
 	 */
 	if (!rename_ctx) {
-		btrfs_del_inode_ref_in_log(trans, root, name, inode, dir_ino);
-		btrfs_del_dir_entries_in_log(trans, root, name, dir, index);
+		btrfs_del_inode_ref_in_log(trans, root, &name->disk_name,
+					   inode, dir_ino);
+		btrfs_del_dir_entries_in_log(trans, root, &name->disk_name,
+					     dir, index);
 	}
 
 	/*
@@ -4288,7 +4293,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name->len * 2);
+	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name->disk_name.len * 2);
 	inode_inc_iversion(&inode->vfs_inode);
 	inode_inc_iversion(&dir->vfs_inode);
 	inode->vfs_inode.i_ctime = current_time(&inode->vfs_inode);
@@ -4301,7 +4306,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
-		       const struct fscrypt_str *name)
+		       struct fscrypt_name *name)
 {
 	int ret;
 
@@ -4352,7 +4357,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 				false);
 
 	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
-				 &fname.disk_name);
+				 &fname);
 	if (ret)
 		goto end_trans;
 
@@ -4389,8 +4394,6 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	/* This needs to handle no-key deletions later on */
-
 	if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID) {
 		objectid = inode->root->root_key.objectid;
 	} else if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
@@ -4407,8 +4410,8 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
-				   &fname.disk_name, -1);
+	di = btrfs_lookup_dir_item_fname(trans, root, path, dir_ino,
+					 &fname, -1);
 	if (IS_ERR_OR_NULL(di)) {
 		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto out;
@@ -4434,7 +4437,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	 * call btrfs_del_root_ref, and it _shouldn't_ fail.
 	 */
 	if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
-		di = btrfs_search_dir_index_item(root, path, dir_ino, &fname.disk_name);
+		di = btrfs_search_dir_index_item(root, path, dir_ino, &fname);
 		if (IS_ERR_OR_NULL(di)) {
 			if (!di)
 				ret = -ENOENT;
@@ -4451,7 +4454,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	} else {
 		ret = btrfs_del_root_ref(trans, objectid,
 					 root->root_key.objectid, dir_ino,
-					 &index, &fname.disk_name);
+					 &index, &fname);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
@@ -4775,7 +4778,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	/* now the directory is empty */
 	err = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
-				 &fname.disk_name);
+				 &fname);
 	if (!err) {
 		btrfs_i_size_write(BTRFS_I(inode), 0);
 		/*
@@ -5478,32 +5481,23 @@ void btrfs_evict_inode(struct inode *inode)
  * If no dir entries were found, returns -ENOENT.
  * If found a corrupted location in dir entry, returns -EUCLEAN.
  */
-static int btrfs_inode_by_name(struct btrfs_inode *dir, struct dentry *dentry,
+static int btrfs_inode_by_name(struct btrfs_inode *dir,
+			       struct fscrypt_name *fname,
 			       struct btrfs_key *location, u8 *type)
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_path *path;
 	struct btrfs_root *root = dir->root;
 	int ret = 0;
-	struct fscrypt_name fname;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	ret = fscrypt_setup_filename(&dir->vfs_inode, &dentry->d_name, 1, &fname);
-	if (ret < 0)
-		goto out;
-	/*
-	 * fscrypt_setup_filename() should never return a positive value, but
-	 * gcc on sparc/parisc thinks it can, so assert that doesn't happen.
-	 */
-	ASSERT(ret == 0);
-
 	/* This needs to handle no-key deletions later on */
 
-	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(dir),
-				   &fname.disk_name, 0);
+	di = btrfs_lookup_dir_item_fname(NULL, root, path, btrfs_ino(dir),
+				   fname, 0);
 	if (IS_ERR_OR_NULL(di)) {
 		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto out;
@@ -5515,13 +5509,13 @@ static int btrfs_inode_by_name(struct btrfs_inode *dir, struct dentry *dentry,
 		ret = -EUCLEAN;
 		btrfs_warn(root->fs_info,
 "%s gets something invalid in DIR_ITEM (name %s, directory ino %llu, location(%llu %u %llu))",
-			   __func__, fname.disk_name.name, btrfs_ino(dir),
-			   location->objectid, location->type, location->offset);
+			   __func__, fname->usr_fname->name,
+			   btrfs_ino(dir), location->objectid,
+			   location->type, location->offset);
 	}
 	if (!ret)
 		*type = btrfs_dir_ftype(path->nodes[0], di);
 out:
-	fscrypt_free_filename(&fname);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -5793,13 +5787,18 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
+	struct fscrypt_name fname;
 	u8 di_type = 0;
 	int ret = 0;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	ret = btrfs_inode_by_name(BTRFS_I(dir), dentry, &location, &di_type);
+	ret = fscrypt_prepare_lookup(dir, dentry, &fname);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = btrfs_inode_by_name(BTRFS_I(dir), &fname, &location, &di_type);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
@@ -5940,18 +5939,32 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	struct list_head del_list;
 	int ret;
 	char *name_ptr;
-	int name_len;
+	u32 name_len;
 	int entries = 0;
 	int total_len = 0;
 	bool put = false;
 	struct btrfs_key location;
+	struct fscrypt_str fstr = FSTR_INIT(NULL, 0);
+	u32 fstr_len = 0;
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_ENCRYPT) {
+		ret = fscrypt_prepare_readdir(inode);
+		if (ret)
+			return ret;
+		ret = fscrypt_fname_alloc_buffer(BTRFS_NAME_LEN, &fstr);
+		if (ret)
+			return ret;
+		fstr_len = fstr.len;
+	}
+
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto err_fstr;
+	}
 
 	addr = private->filldir_buf;
 	path->reada = READA_FORWARD;
@@ -5969,6 +5982,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		struct dir_entry *entry;
 		struct extent_buffer *leaf = path->nodes[0];
 		u8 ftype;
+		u32 nokey_len;
 
 		if (found_key.objectid != key.objectid)
 			break;
@@ -5980,8 +5994,13 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 			continue;
 		di = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
 		name_len = btrfs_dir_name_len(leaf, di);
-		if ((total_len + sizeof(struct dir_entry) + name_len) >=
-		    PAGE_SIZE) {
+		nokey_len = DIV_ROUND_UP(name_len * 4, 3);
+		/*
+		 * If name is encrypted, and we don't have the key, we could
+		 * need up to 4/3rds the bytes to print it.
+		 */
+		if ((total_len + sizeof(struct dir_entry) + nokey_len)
+		    >= PAGE_SIZE) {
 			btrfs_release_path(path);
 			ret = btrfs_filldir(private->filldir_buf, entries, ctx);
 			if (ret)
@@ -5995,8 +6014,36 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		ftype = btrfs_dir_flags_to_ftype(btrfs_dir_flags(leaf, di));
 		entry = addr;
 		name_ptr = (char *)(entry + 1);
-		read_extent_buffer(leaf, name_ptr,
-				   (unsigned long)(di + 1), name_len);
+		if (btrfs_dir_flags(leaf, di) & BTRFS_FT_ENCRYPTED) {
+			struct fscrypt_str oname = FSTR_INIT(name_ptr,
+							     nokey_len);
+			u32 hash = 0, minor_hash = 0;
+
+			read_extent_buffer(leaf, fstr.name,
+					   (unsigned long)(di + 1), name_len);
+			fstr.len = name_len;
+			/*
+			 * We're iterating through DIR_INDEX items, so we don't
+			 * have the DIR_ITEM hash handy. Only compute it if
+			 * we'll need it -- the nokey name stores it, so that
+			 * we can look up the appropriate item by nokey name
+			 * later on.
+			 */
+			if (!fscrypt_has_encryption_key(inode)) {
+				u64 name_hash = btrfs_name_hash(fstr.name,
+								fstr.len);
+				hash = name_hash;
+				minor_hash = name_hash >> 32;
+			}
+			ret = fscrypt_fname_disk_to_usr(inode, hash, minor_hash,
+							&fstr, &oname);
+			if (ret)
+				goto err;
+			name_len = oname.len;
+		} else {
+			read_extent_buffer(leaf, name_ptr,
+					   (unsigned long)(di + 1), name_len);
+		}
 		put_unaligned(name_len, &entry->name_len);
 		put_unaligned(fs_ftype_to_dtype(ftype), &entry->type);
 		btrfs_dir_item_key_to_cpu(leaf, di, &location);
@@ -6016,7 +6063,8 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	if (ret)
 		goto nopos;
 
-	ret = btrfs_readdir_delayed_dir_index(ctx, &ins_list);
+	fstr.len = fstr_len;
+	ret = btrfs_readdir_delayed_dir_index(inode, &fstr, ctx, &ins_list);
 	if (ret)
 		goto nopos;
 
@@ -6047,6 +6095,8 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	if (put)
 		btrfs_readdir_put_delayed_items(inode, &ins_list, &del_list);
 	btrfs_free_path(path);
+err_fstr:
+	fscrypt_fname_free_buffer(&fstr);
 	return ret;
 }
 
@@ -6555,6 +6605,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = parent_inode->root;
 	u64 ino = btrfs_ino(inode);
 	u64 parent_ino = btrfs_ino(parent_inode);
+	struct fscrypt_name fname = { .disk_name = *name };
 
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		memcpy(&key, &inode->root->root_key, sizeof(key));
@@ -6612,7 +6663,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 		int err;
 		err = btrfs_del_root_ref(trans, key.objectid,
 					 root->root_key.objectid, parent_ino,
-					 &local_index, name);
+					 &local_index, &fname);
 		if (err)
 			btrfs_abort_transaction(trans, err);
 	} else if (add_backref) {
@@ -8982,7 +9033,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	} else { /* src is an inode */
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					   BTRFS_I(old_dentry->d_inode),
-					   old_name, &old_rename_ctx);
+					   &old_fname, &old_rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, root, BTRFS_I(old_inode));
 	}
@@ -8997,7 +9048,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	} else { /* dest is an inode */
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(new_dir),
 					   BTRFS_I(new_dentry->d_inode),
-					   new_name, &new_rename_ctx);
+					   &new_fname, &new_rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, dest, BTRFS_I(new_inode));
 	}
@@ -9246,7 +9297,7 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 	} else {
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					   BTRFS_I(d_inode(old_dentry)),
-					   &old_fname.disk_name, &rename_ctx);
+					   &old_fname, &rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, root, BTRFS_I(old_inode));
 	}
@@ -9265,7 +9316,7 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 		} else {
 			ret = btrfs_unlink_inode(trans, BTRFS_I(new_dir),
 						 BTRFS_I(d_inode(new_dentry)),
-						 &new_fname.disk_name);
+						 &new_fname);
 		}
 		if (!ret && new_inode->i_nlink == 0)
 			ret = btrfs_orphan_add(trans,
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 859874579456..5fa416ef54ad 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -10,6 +10,7 @@
 #include "messages.h"
 #include "transaction.h"
 #include "disk-io.h"
+#include "fscrypt.h"
 #include "print-tree.h"
 #include "qgroup.h"
 #include "space-info.h"
@@ -333,7 +334,7 @@ int btrfs_del_root(struct btrfs_trans_handle *trans,
 
 int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       u64 ref_id, u64 dirid, u64 *sequence,
-		       const struct fscrypt_str *name)
+		       struct fscrypt_name *name)
 {
 	struct btrfs_root *tree_root = trans->fs_info->tree_root;
 	struct btrfs_path *path;
@@ -355,13 +356,14 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 	if (ret < 0) {
 		goto out;
 	} else if (ret == 0) {
+		u32 name_len;
 		leaf = path->nodes[0];
 		ref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_root_ref);
 		ptr = (unsigned long)(ref + 1);
+		name_len = btrfs_root_ref_name_len(leaf, ref);
 		if ((btrfs_root_ref_dirid(leaf, ref) != dirid) ||
-		    (btrfs_root_ref_name_len(leaf, ref) != name->len) ||
-		    memcmp_extent_buffer(leaf, name->name, ptr, name->len)) {
+		    !btrfs_fscrypt_match_name(name, leaf, ptr, name_len)) {
 			ret = -ENOENT;
 			goto out;
 		}
diff --git a/fs/btrfs/root-tree.h b/fs/btrfs/root-tree.h
index cbbaca32126e..a57bbf7b0180 100644
--- a/fs/btrfs/root-tree.h
+++ b/fs/btrfs/root-tree.h
@@ -13,7 +13,7 @@ int btrfs_add_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       const struct fscrypt_str *name);
 int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       u64 ref_id, u64 dirid, u64 *sequence,
-		       const struct fscrypt_str *name);
+		       struct fscrypt_name *name);
 int btrfs_del_root(struct btrfs_trans_handle *trans, const struct btrfs_key *key);
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      const struct btrfs_key *key,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 8ad7e7e38d18..3bf746668e07 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -901,9 +901,10 @@ static int unlink_inode_for_log_replay(struct btrfs_trans_handle *trans,
 				       struct btrfs_inode *inode,
 				       const struct fscrypt_str *name)
 {
+	struct fscrypt_name fname = { .disk_name = *name, };
 	int ret;
 
-	ret = btrfs_unlink_inode(trans, dir, inode, name);
+	ret = btrfs_unlink_inode(trans, dir, inode, &fname);
 	if (ret)
 		return ret;
 	/*
-- 
2.40.1

