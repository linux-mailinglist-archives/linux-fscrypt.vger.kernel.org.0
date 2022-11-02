Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC2961623B
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 12:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiKBLyf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 07:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiKBLyK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 07:54:10 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF32629367;
        Wed,  2 Nov 2022 04:54:07 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id EDD0780237;
        Wed,  2 Nov 2022 07:53:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1667390017; bh=1CKVFk63rf0E58jyUQYltmVJY3bR1jFgfinnjnNYCUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7yA6+RZWSh7cNviDRQseglnHNTA2fzepoFOSsL1dTTePOkeTkX843ZLAcojiIdZa
         2DnoUU+8DBHordVB6i4NZuat0Px/bGx1g4QAkMuH84tLrfOd6SUwP0CNjouEGdX/vy
         mqwBHtJnWibXYp6OGYD+Yky7C6G0gGJ8TsknWT2W0hY+Rp4fsCN2Op9wZXtr5g4z6R
         EZULs3qCBy2ubdQGAeOQKHK/OoaXbfOCHFXwFkNJ1NBooQpLuRcXYhQ4rgithWBDNX
         u/HO9hx+/DaZWbeZ+UxHWlE3HqofXC8dDm4nm6+zQRvJgCMACOXo4ri0KnQCK8I86U
         Nc7Q4AT+dP4Ow==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v5 15/18] btrfs: permit searching for nokey names for removal
Date:   Wed,  2 Nov 2022 07:53:04 -0400
Message-Id: <8f877d65a661708ec56727dabb940644b21809e8.1667389115.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1667389115.git.sweettea-kernel@dorminy.me>
References: <cover.1667389115.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no version=3.4.6
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
 fs/btrfs/delayed-inode.c |  30 ++++++++-
 fs/btrfs/delayed-inode.h |   4 +-
 fs/btrfs/dir-item.c      |  77 ++++++++++++++++++---
 fs/btrfs/dir-item.h      |  13 +++-
 fs/btrfs/extent_io.c     |  38 +++++++++++
 fs/btrfs/extent_io.h     |   3 +
 fs/btrfs/fscrypt.c       |  47 ++++++++++++-
 fs/btrfs/fscrypt.h       |  19 ++++++
 fs/btrfs/inode.c         | 141 ++++++++++++++++++++++++++-------------
 fs/btrfs/root-tree.c     |   8 ++-
 fs/btrfs/root-tree.h     |   2 +-
 fs/btrfs/tree-log.c      |   3 +-
 13 files changed, 319 insertions(+), 68 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 32fa68946f07..f0935a95ec70 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -435,7 +435,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
 int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
-		       const struct fscrypt_str *name);
+		       struct fscrypt_name *name);
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
 		   const struct fscrypt_str *name, int add_backref, u64 index);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index c024f97de9e0..f775e1111d3e 100644
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
index 082eb0e19598..ce046cdabbe9 100644
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
+	struct btrfs_dir_item *di;
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
+	if (ret == -ENOENT || (IS_ERR(di) && PTR_ERR(di) == -ENOENT))
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
index 97aaa74c4822..a0450e4401e9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5329,6 +5329,44 @@ static void assert_eb_page_uptodate(const struct extent_buffer *eb,
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
index a5ec1475988f..0a82604b0feb 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -203,6 +203,9 @@ static inline int extent_buffer_uptodate(const struct extent_buffer *eb)
 
 int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
 			 unsigned long start, unsigned long len);
+void extent_buffer_sha256(const struct extent_buffer *eb,
+			  unsigned long start,
+			  unsigned long len, u8 *out);
 void read_extent_buffer(const struct extent_buffer *eb, void *dst,
 			unsigned long start,
 			unsigned long len);
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 661fe7cc119c..6f4c843720c1 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -5,12 +5,57 @@
 #include "accessors.h"
 #include "btrfs_inode.h"
 #include "disk-io.h"
+#include "ioctl.h"
 #include "fs.h"
 #include "fscrypt.h"
 #include "messages.h"
 #include "transaction.h"
 #include "xattr.h"
-#include "fscrypt.h"
+#include "root-tree.h"
+
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
 
 static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
 {
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 86dc0e0b91b9..65c082e91f65 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -4,6 +4,7 @@
 #define BTRFS_FSCRYPT_H
 
 #include <linux/fscrypt.h>
+#include "extent_io.h"
 
 #define BTRFS_ENCRYPTION_POLICY_BITS 2
 #define BTRFS_ENCRYPTION_CTXSIZE_BITS 6
@@ -24,6 +25,24 @@ struct btrfs_fscrypt_extent_context {
 };
 #endif
 
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
 static inline void btrfs_unpack_encryption(u8 encryption,
 					   u8 *policy,
 					   u8 *ctxsize)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 332900b41488..236f6e91b440 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4319,7 +4319,7 @@ int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
 static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 				struct btrfs_inode *dir,
 				struct btrfs_inode *inode,
-				const struct fscrypt_str *name,
+				struct fscrypt_name *name,
 				struct btrfs_rename_ctx *rename_ctx)
 {
 	struct btrfs_root *root = dir->root;
@@ -4337,7 +4337,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino, name, -1);
+	di = btrfs_lookup_dir_item_fname(trans, root, path, dir_ino, name, -1);
 	if (IS_ERR_OR_NULL(di)) {
 		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto err;
@@ -4365,11 +4365,14 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
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
@@ -4390,8 +4393,10 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
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
@@ -4409,7 +4414,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name->len * 2);
+	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name->disk_name.len * 2);
 	inode_inc_iversion(&inode->vfs_inode);
 	inode_inc_iversion(&dir->vfs_inode);
 	inode->vfs_inode.i_ctime = current_time(&inode->vfs_inode);
@@ -4422,7 +4427,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
-		       const struct fscrypt_str *name)
+		       struct fscrypt_name *name)
 {
 	int ret;
 
@@ -4480,7 +4485,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 			0);
 
 	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
-				 &fname.disk_name);
+				 &fname);
 	if (ret)
 		goto out;
 
@@ -4516,8 +4521,6 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	/* This needs to handle no-key deletions later on */
-
 	if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID) {
 		objectid = inode->root->root_key.objectid;
 	} else if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
@@ -4534,8 +4537,8 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
-				   &fname.disk_name, -1);
+	di = btrfs_lookup_dir_item_fname(trans, root, path, dir_ino,
+					 &fname, -1);
 	if (IS_ERR_OR_NULL(di)) {
 		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto out;
@@ -4561,7 +4564,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	 * call btrfs_del_root_ref, and it _shouldn't_ fail.
 	 */
 	if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
-		di = btrfs_search_dir_index_item(root, path, dir_ino, &fname.disk_name);
+		di = btrfs_search_dir_index_item(root, path, dir_ino, &fname);
 		if (IS_ERR_OR_NULL(di)) {
 			if (!di)
 				ret = -ENOENT;
@@ -4578,7 +4581,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	} else {
 		ret = btrfs_del_root_ref(trans, objectid,
 					 root->root_key.objectid, dir_ino,
-					 &index, &fname.disk_name);
+					 &index, &fname);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
@@ -4881,8 +4884,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (err)
 		return err;
 
-	/* This needs to handle no-key deletions later on */
-
 	trans = __unlink_start_trans(dir);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
@@ -4902,7 +4903,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	/* now the directory is empty */
 	err = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
-				 &fname.disk_name);
+				 &fname);
 	if (!err) {
 		btrfs_i_size_write(BTRFS_I(inode), 0);
 		/*
@@ -5595,27 +5596,20 @@ void btrfs_evict_inode(struct inode *inode)
  * If no dir entries were found, returns -ENOENT.
  * If found a corrupted location in dir entry, returns -EUCLEAN.
  */
-static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
+static int btrfs_inode_by_name(struct inode *dir, struct fscrypt_name *fname,
 			       struct btrfs_key *location, u8 *type)
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_path *path;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	int ret = 0;
-	struct fscrypt_name fname;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	ret = fscrypt_setup_filename(dir, &dentry->d_name, 1, &fname);
-	if (ret)
-		goto out;
-
-	/* This needs to handle no-key deletions later on */
-
-	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(BTRFS_I(dir)),
-				   &fname.disk_name, 0);
+	di = btrfs_lookup_dir_item_fname(NULL, root, path,
+					 btrfs_ino(BTRFS_I(dir)), fname, 0);
 	if (IS_ERR_OR_NULL(di)) {
 		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto out;
@@ -5627,13 +5621,13 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 		ret = -EUCLEAN;
 		btrfs_warn(root->fs_info,
 "%s gets something invalid in DIR_ITEM (name %s, directory ino %llu, location(%llu %u %llu))",
-			   __func__, fname.disk_name.name, btrfs_ino(BTRFS_I(dir)),
-			   location->objectid, location->type, location->offset);
+			   __func__, fname->usr_fname->name,
+			   btrfs_ino(BTRFS_I(dir)), location->objectid,
+			   location->type, location->offset);
 	}
 	if (!ret)
 		*type = btrfs_dir_ftype(path->nodes[0], di);
 out:
-	fscrypt_free_filename(&fname);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -5905,13 +5899,18 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
+	struct fscrypt_name fname;
 	u8 di_type = 0;
 	int ret = 0;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	ret = btrfs_inode_by_name(dir, dentry, &location, &di_type);
+	ret = fscrypt_prepare_lookup(dir, dentry, &fname);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = btrfs_inode_by_name(dir, &fname, &location, &di_type);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
@@ -6052,18 +6051,32 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
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
 
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_FSCRYPT_CONTEXT) {
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
@@ -6081,6 +6094,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		struct dir_entry *entry;
 		struct extent_buffer *leaf = path->nodes[0];
 		u8 ftype;
+		u32 nokey_len;
 
 		if (found_key.objectid != key.objectid)
 			break;
@@ -6092,8 +6106,13 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
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
@@ -6107,8 +6126,36 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
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
@@ -6128,7 +6175,8 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	if (ret)
 		goto nopos;
 
-	ret = btrfs_readdir_delayed_dir_index(ctx, &ins_list);
+	fstr.len = fstr_len;
+	ret = btrfs_readdir_delayed_dir_index(inode, &fstr, ctx, &ins_list);
 	if (ret)
 		goto nopos;
 
@@ -6159,6 +6207,8 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	if (put)
 		btrfs_readdir_put_delayed_items(inode, &ins_list, &del_list);
 	btrfs_free_path(path);
+err_fstr:
+	fscrypt_fname_free_buffer(&fstr);
 	return ret;
 }
 
@@ -6688,6 +6738,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = parent_inode->root;
 	u64 ino = btrfs_ino(inode);
 	u64 parent_ino = btrfs_ino(parent_inode);
+	struct fscrypt_name fname = { .disk_name = *name };
 
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		memcpy(&key, &inode->root->root_key, sizeof(key));
@@ -6745,7 +6796,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 		int err;
 		err = btrfs_del_root_ref(trans, key.objectid,
 					 root->root_key.objectid, parent_ino,
-					 &local_index, name);
+					 &local_index, &fname);
 		if (err)
 			btrfs_abort_transaction(trans, err);
 	} else if (add_backref) {
@@ -9321,7 +9372,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	} else { /* src is an inode */
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					   BTRFS_I(old_dentry->d_inode),
-					   old_name, &old_rename_ctx);
+					   &old_fname, &old_rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, root, BTRFS_I(old_inode));
 	}
@@ -9336,7 +9387,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	} else { /* dest is an inode */
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(new_dir),
 					   BTRFS_I(new_dentry->d_inode),
-					   new_name, &new_rename_ctx);
+					   &new_fname, &new_rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, dest, BTRFS_I(new_inode));
 	}
@@ -9583,7 +9634,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 	} else {
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					   BTRFS_I(d_inode(old_dentry)),
-					   &old_fname.disk_name, &rename_ctx);
+					   &old_fname, &rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, root, BTRFS_I(old_inode));
 	}
@@ -9602,7 +9653,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
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
index 9c211802efb1..331f35972d77 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -925,9 +925,10 @@ static int unlink_inode_for_log_replay(struct btrfs_trans_handle *trans,
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
2.37.3

