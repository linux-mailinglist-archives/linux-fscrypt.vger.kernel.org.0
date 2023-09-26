Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABE17AF232
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbjIZSDj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbjIZSDi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:38 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754F7FC
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:29 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id af79cd13be357-7740c520847so604212285a.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751408; x=1696356208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wbh7VV9KbEE9zbDAudiIoyZIp5Pe92r58y3UHja/Zl8=;
        b=Hqq842PvBUKHBPGAk/SVcK9POvz5jNBhZ7OF4ogb5RKKQ/TaRwWy3cn5GbTqpsdABK
         dzk3hsCJ3Lg7VNjmqFiYG6FZc8q7yPRVKG6TiLJTYHL+kiJJMB39FXM9/Nv8x25Pwmnx
         nos+HbJl4dr20yJ8Dn0TiK18U5rE5Vcs85j8oOnH4HOzTfNO7WB51lmXeqCdEDBu7rxX
         ubbWYEMvIlY9reu3pJS86Wyc7IyTyJPB6p6840mQ1oqmMsAt0amnX4s9lT2BL2kVNuZM
         tk7SmoMDnIYvAlyDTBbnnXOG+5P5tTUIaRXgWoXH3ryeywXG9OKdFIwqtybVoy6AUNNc
         /vlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751408; x=1696356208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wbh7VV9KbEE9zbDAudiIoyZIp5Pe92r58y3UHja/Zl8=;
        b=WqwRi+V1z2h2sJMCRSgxl4xc1wJ28l3MsCowMqmcaFH6k32azhCoIqbRcl7+2ZwcUe
         Atyvq5OlFYd5wOutcR/loa3haNLIecQadUyTX9hwyeBUATaLCnC2Sq30Xb66ck73RanU
         5TDcM6GnfmL+E3ue5dbvvzSjYzXggoJwPyy+7Jri5muEg9ofK2auDybfotYQr64v3v9S
         7kEm0y1phfM38d11xqBorncpophOYxkVEGYHm0i/WL5fj1yKnc45sNqH7fUMtkVDfTyr
         Ft2w2oNniQq0LxAAh5QdVhLjweFQuvIVIB1vKvNHnJjhhu9fZSliTnaEzfm2MzHfDyQg
         X4Cw==
X-Gm-Message-State: AOJu0YxPF78EZx+Qm2NjyRA6ZBuwlO5y1uHV/xERh5nmluIfgMZlkdmc
        0k7PisfJRay9DmgAr4r73qZVCg==
X-Google-Smtp-Source: AGHT+IH1YfpzNgpQqpAdLjIKF3TAodD88ca4tiqM1nQ2LHrja+NT/kdHlMGVAu/7J8b11tUVJuJWjw==
X-Received: by 2002:a05:620a:2ac8:b0:76f:1d96:4eb5 with SMTP id bn8-20020a05620a2ac800b0076f1d964eb5mr11308516qkb.36.1695751408247;
        Tue, 26 Sep 2023 11:03:28 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id e12-20020a05620a12cc00b00767d6ec578csm2031929qkl.20.2023.09.26.11.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:27 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 13/35] btrfs: adapt readdir for encrypted and nokey names
Date:   Tue, 26 Sep 2023 14:01:39 -0400
Message-ID: <e405fffae735ea6a250c58bd7ad199281f111f9a.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
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
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/btrfs_inode.h   |   2 +-
 fs/btrfs/delayed-inode.c |  29 ++++++-
 fs/btrfs/delayed-inode.h |   6 +-
 fs/btrfs/dir-item.c      |  77 ++++++++++++++++---
 fs/btrfs/dir-item.h      |  11 ++-
 fs/btrfs/extent_io.c     |  18 +++++
 fs/btrfs/extent_io.h     |   3 +
 fs/btrfs/fscrypt.c       |  34 +++++++++
 fs/btrfs/fscrypt.h       |  19 +++++
 fs/btrfs/inode.c         | 158 ++++++++++++++++++++++++++-------------
 fs/btrfs/root-tree.c     |   8 +-
 fs/btrfs/root-tree.h     |   2 +-
 fs/btrfs/tree-log.c      |   3 +-
 13 files changed, 297 insertions(+), 73 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 68ebb6096822..93390f12a4ef 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -422,7 +422,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
 int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
-		       const struct fscrypt_str *name);
+		       struct fscrypt_name *name);
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
 		   const struct fscrypt_str *name, int add_backref, u64 index);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 35d7616615c1..43b5fb3fce27 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1762,7 +1762,9 @@ int btrfs_should_delete_dir_index(struct list_head *del_list,
 /*
  * Read dir info stored in the delayed tree.
  */
-int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
+int btrfs_readdir_delayed_dir_index(struct inode *inode,
+				    struct fscrypt_str *fstr,
+				    struct dir_context *ctx,
 				    struct list_head *ins_list)
 {
 	struct btrfs_dir_item *di;
@@ -1772,6 +1774,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 	int name_len;
 	int over = 0;
 	unsigned char d_type;
+	size_t fstr_len = fstr->len;
 
 	/*
 	 * Changing the data of the delayed item is impossible. So
@@ -1796,8 +1799,28 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
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
index d050e572c7f9..6fe2c7607c8b 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -16,6 +16,8 @@
 #include <linux/refcount.h>
 #include "ctree.h"
 
+struct fscrypt_str;
+
 enum btrfs_delayed_item_type {
 	BTRFS_DELAYED_INSERTION_ITEM,
 	BTRFS_DELAYED_DELETION_ITEM
@@ -155,7 +157,9 @@ void btrfs_readdir_put_delayed_items(struct inode *inode,
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
index 9c07d5c3e5ad..a64cfddff7f0 100644
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
index e40a226373d7..1d6ab8c3b879 100644
--- a/fs/btrfs/dir-item.h
+++ b/fs/btrfs/dir-item.h
@@ -6,6 +6,7 @@
 #include <linux/crc32c.h>
 
 struct fscrypt_str;
+struct fscrypt_name;
 
 int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir,
 			  const struct fscrypt_str *name);
@@ -16,6 +17,11 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
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
@@ -23,7 +29,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_index_item(
 			u64 index, const struct fscrypt_str *name, int mod);
 struct btrfs_dir_item *btrfs_search_dir_index_item(struct btrfs_root *root,
 			    struct btrfs_path *path, u64 dirid,
-			    const struct fscrypt_str *name);
+			    struct fscrypt_name *name);
 int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct btrfs_path *path,
@@ -42,6 +48,9 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 						 struct btrfs_path *path,
 						 const char *name,
 						 int name_len);
+struct btrfs_dir_item *btrfs_match_dir_item_fname(struct btrfs_fs_info *fs_info,
+						  struct btrfs_path *path,
+						  struct fscrypt_name *name);
 
 static inline u64 btrfs_name_hash(const char *name, int len)
 {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 90369d132d4f..121746b7ce95 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4135,6 +4135,24 @@ static void assert_eb_page_uptodate(const struct extent_buffer *eb,
 	}
 }
 
+/* Take a sha256 of a portion of an extent buffer. */
+void extent_buffer_sha256(const struct extent_buffer *eb,
+			  unsigned long start,
+			  unsigned long len, u8 *out)
+{
+	void *eb_addr = btrfs_get_eb_addr(eb);
+
+	if (check_eb_range(eb, start, len))
+		return;
+
+	/*
+	 * TODO: This should maybe be using the crypto API, not the fallback,
+	 * but fscrypt uses the fallback and this is only used in emulation of
+	 * fscrypt's buffer sha256 method.
+	 */
+	sha256(eb_addr + start, len, out);
+}
+
 void write_extent_buffer(const struct extent_buffer *eb, const void *srcv,
 			 unsigned long start, unsigned long len)
 {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 368ffe00c326..b30b3448b1fb 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -254,6 +254,9 @@ static inline int extent_buffer_uptodate(const struct extent_buffer *eb)
 
 int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
 			 unsigned long start, unsigned long len);
+void extent_buffer_sha256(const struct extent_buffer *eb,
+			  unsigned long start,
+			  unsigned long len, u8 *out);
 void read_extent_buffer(const struct extent_buffer *eb, void *dst,
 			unsigned long start,
 			unsigned long len);
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index bb3a83d01032..588966f0414f 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -5,13 +5,47 @@
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
+ * extent_buffer.
+ */
+bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
+			      struct extent_buffer *leaf, unsigned long de_name,
+			      u32 de_name_len)
+{
+	const struct fscrypt_nokey_name *nokey_name =
+		(const struct fscrypt_nokey_name *)fname->crypto_buf.name;
+	u8 digest[SHA256_DIGEST_SIZE];
+
+	if (likely(fname->disk_name.name)) {
+		if (de_name_len != fname->disk_name.len)
+			return false;
+		return !memcmp_extent_buffer(leaf, fname->disk_name.name,
+					     de_name, de_name_len);
+	}
+
+	if (de_name_len <= sizeof(nokey_name->bytes))
+		return false;
+
+	if (memcmp_extent_buffer(leaf, nokey_name->bytes, de_name,
+				 sizeof(nokey_name->bytes)))
+		return false;
+
+	extent_buffer_sha256(leaf, de_name + sizeof(nokey_name->bytes),
+			     de_name_len - sizeof(nokey_name->bytes), digest);
+
+	return !memcmp(digest, nokey_name->sha256, sizeof(digest));
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
index f261113e7242..ccbaeea68e2e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4049,7 +4049,7 @@ int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
 static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 				struct btrfs_inode *dir,
 				struct btrfs_inode *inode,
-				const struct fscrypt_str *name,
+				struct fscrypt_name *name,
 				struct btrfs_rename_ctx *rename_ctx)
 {
 	struct btrfs_root *root = dir->root;
@@ -4067,7 +4067,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino, name, -1);
+	di = btrfs_lookup_dir_item_fname(trans, root, path, dir_ino, name, -1);
 	if (IS_ERR_OR_NULL(di)) {
 		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto err;
@@ -4095,11 +4095,14 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
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
@@ -4120,8 +4123,10 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
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
@@ -4139,7 +4144,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name->len * 2);
+	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name->disk_name.len * 2);
 	inode_inc_iversion(&inode->vfs_inode);
 	inode_inc_iversion(&dir->vfs_inode);
 	inode_set_ctime_current(&inode->vfs_inode);
@@ -4151,7 +4156,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
-		       const struct fscrypt_str *name)
+		       struct fscrypt_name *name)
 {
 	int ret;
 
@@ -4202,7 +4207,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 				false);
 
 	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
-				 &fname.disk_name);
+				 &fname);
 	if (ret)
 		goto end_trans;
 
@@ -4239,8 +4244,6 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	/* This needs to handle no-key deletions later on */
-
 	if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID) {
 		objectid = inode->root->root_key.objectid;
 	} else if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
@@ -4257,8 +4260,8 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
-				   &fname.disk_name, -1);
+	di = btrfs_lookup_dir_item_fname(trans, root, path, dir_ino,
+					 &fname, -1);
 	if (IS_ERR_OR_NULL(di)) {
 		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto out;
@@ -4284,7 +4287,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	 * call btrfs_del_root_ref, and it _shouldn't_ fail.
 	 */
 	if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
-		di = btrfs_search_dir_index_item(root, path, dir_ino, &fname.disk_name);
+		di = btrfs_search_dir_index_item(root, path, dir_ino, &fname);
 		if (IS_ERR_OR_NULL(di)) {
 			if (!di)
 				ret = -ENOENT;
@@ -4301,7 +4304,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	} else {
 		ret = btrfs_del_root_ref(trans, objectid,
 					 root->root_key.objectid, dir_ino,
-					 &index, &fname.disk_name);
+					 &index, &fname);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
@@ -4624,7 +4627,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	/* now the directory is empty */
 	err = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
-				 &fname.disk_name);
+				 &fname);
 	if (!err) {
 		btrfs_i_size_write(BTRFS_I(inode), 0);
 		/*
@@ -5328,32 +5331,23 @@ void btrfs_evict_inode(struct inode *inode)
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
@@ -5365,13 +5359,13 @@ static int btrfs_inode_by_name(struct btrfs_inode *dir, struct dentry *dentry,
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
@@ -5644,20 +5638,27 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
+	struct fscrypt_name fname;
 	u8 di_type = 0;
 	int ret = 0;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	ret = btrfs_inode_by_name(BTRFS_I(dir), dentry, &location, &di_type);
-	if (ret < 0)
+	ret = fscrypt_prepare_lookup(dir, dentry, &fname);
+	if (ret)
 		return ERR_PTR(ret);
 
+	ret = btrfs_inode_by_name(BTRFS_I(dir), &fname, &location, &di_type);
+	if (ret < 0) {
+		inode = ERR_PTR(ret);
+		goto cleanup;
+	}
+
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, location.objectid, root);
 		if (IS_ERR(inode))
-			return inode;
+			goto cleanup;
 
 		/* Do extra check against inode mode with di_type */
 		if (btrfs_inode_type(inode) != di_type) {
@@ -5666,9 +5667,10 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 				  inode->i_mode, btrfs_inode_type(inode),
 				  di_type);
 			iput(inode);
-			return ERR_PTR(-EUCLEAN);
+			inode = ERR_PTR(-EUCLEAN);
+			goto cleanup;
 		}
-		return inode;
+		goto cleanup;
 	}
 
 	ret = fixup_tree_root_location(fs_info, BTRFS_I(dir), dentry,
@@ -5683,7 +5685,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 		btrfs_put_root(sub_root);
 
 		if (IS_ERR(inode))
-			return inode;
+			goto cleanup;
 
 		down_read(&fs_info->cleanup_work_sem);
 		if (!sb_rdonly(inode->i_sb))
@@ -5695,6 +5697,8 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 		}
 	}
 
+cleanup:
+	fscrypt_free_filename(&fname);
 	return inode;
 }
 
@@ -5883,18 +5887,32 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	LIST_HEAD(del_list);
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
@@ -5911,6 +5929,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		struct dir_entry *entry;
 		struct extent_buffer *leaf = path->nodes[0];
 		u8 ftype;
+		u32 nokey_len;
 
 		if (found_key.objectid != key.objectid)
 			break;
@@ -5924,8 +5943,13 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
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
@@ -5939,8 +5963,36 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
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
@@ -5960,7 +6012,8 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	if (ret)
 		goto nopos;
 
-	ret = btrfs_readdir_delayed_dir_index(ctx, &ins_list);
+	fstr.len = fstr_len;
+	ret = btrfs_readdir_delayed_dir_index(inode, &fstr, ctx, &ins_list);
 	if (ret)
 		goto nopos;
 
@@ -5991,6 +6044,8 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	if (put)
 		btrfs_readdir_put_delayed_items(inode, &ins_list, &del_list);
 	btrfs_free_path(path);
+err_fstr:
+	fscrypt_fname_free_buffer(&fstr);
 	return ret;
 }
 
@@ -6441,6 +6496,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = parent_inode->root;
 	u64 ino = btrfs_ino(inode);
 	u64 parent_ino = btrfs_ino(parent_inode);
+	struct fscrypt_name fname = { .disk_name = *name };
 
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		memcpy(&key, &inode->root->root_key, sizeof(key));
@@ -6496,7 +6552,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 		int err;
 		err = btrfs_del_root_ref(trans, key.objectid,
 					 root->root_key.objectid, parent_ino,
-					 &local_index, name);
+					 &local_index, &fname);
 		if (err)
 			btrfs_abort_transaction(trans, err);
 	} else if (add_backref) {
@@ -8863,7 +8919,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	} else { /* src is an inode */
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					   BTRFS_I(old_dentry->d_inode),
-					   old_name, &old_rename_ctx);
+					   &old_fname, &old_rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, BTRFS_I(old_inode));
 	}
@@ -8878,7 +8934,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	} else { /* dest is an inode */
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(new_dir),
 					   BTRFS_I(new_dentry->d_inode),
-					   new_name, &new_rename_ctx);
+					   &new_fname, &new_rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, BTRFS_I(new_inode));
 	}
@@ -9123,7 +9179,7 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 	} else {
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					   BTRFS_I(d_inode(old_dentry)),
-					   &old_fname.disk_name, &rename_ctx);
+					   &old_fname, &rename_ctx);
 		if (!ret)
 			ret = btrfs_update_inode(trans, BTRFS_I(old_inode));
 	}
@@ -9141,7 +9197,7 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 		} else {
 			ret = btrfs_unlink_inode(trans, BTRFS_I(new_dir),
 						 BTRFS_I(d_inode(new_dentry)),
-						 &new_fname.disk_name);
+						 &new_fname);
 		}
 		if (!ret && new_inode->i_nlink == 0)
 			ret = btrfs_orphan_add(trans,
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 603ad1459368..d131934123f5 100644
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
@@ -334,7 +335,7 @@ int btrfs_del_root(struct btrfs_trans_handle *trans,
 
 int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       u64 ref_id, u64 dirid, u64 *sequence,
-		       const struct fscrypt_str *name)
+		       struct fscrypt_name *name)
 {
 	struct btrfs_root *tree_root = trans->fs_info->tree_root;
 	struct btrfs_path *path;
@@ -356,13 +357,14 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
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
index 8b2c3859e464..5ba7b36cf826 100644
--- a/fs/btrfs/root-tree.h
+++ b/fs/btrfs/root-tree.h
@@ -15,7 +15,7 @@ int btrfs_add_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       const struct fscrypt_str *name);
 int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       u64 ref_id, u64 dirid, u64 *sequence,
-		       const struct fscrypt_str *name);
+		       struct fscrypt_name *name);
 int btrfs_del_root(struct btrfs_trans_handle *trans, const struct btrfs_key *key);
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      const struct btrfs_key *key,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c4d8900f91bb..cc262305f4c5 100644
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
2.41.0

