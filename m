Return-Path: <linux-fscrypt+bounces-1568-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +A/5Ndg9BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1568-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:01:12 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 98E2D53020A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E592A313C335
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:55:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FFB03E9C2A;
	Wed, 13 May 2026 08:54:56 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C183E5A09
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662495; cv=none; b=iqIdo6klHdtlOe5BbqSLBx/+YwsDZ4DPJArrtBY8D1uhSMKk4rlajJ67+Tfnl0iS8u+qMQ9aX8UEj2pGs6YzykOwimhBKHSnsn8revZirkbZsQDh0bSjT04LgKzSDEXJDkBTwNvr4qF+lhI6mmRFUTFtZ8BnXzW7MUHPyAUkmSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662495; c=relaxed/simple;
	bh=T2TgOvqj51y3uz+YMNI2zM3lARpVWxneM4gNHPaxAq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gczLSx5lolM5egVB/vEpHLQ0VAabXP/arqxSkr8UTmkIwR9Fq7N372L3v1gnOinO9n4SX1pb2Wa65JuoZwR67qh0wXg+W00Vo8W4wTyoIjbHj42AM1noRaoIchW+pY3PsTbB9RVg9Fn6shH8Ge/WDd34cKu4+C3QgnZDVyDNNSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 464DA67900;
	Wed, 13 May 2026 08:54:27 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1CBC5593A9;
	Wed, 13 May 2026 08:54:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0L2OBkM8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:27 +0000
From: Daniel Vacek <neelx@suse.com>
To: Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>
Cc: linux-block@vger.kernel.org,
	Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Omar Sandoval <osandov@osandov.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v7 13/43] btrfs: adapt readdir for encrypted and nokey names
Date: Wed, 13 May 2026 10:52:47 +0200
Message-ID: <20260513085340.3673127-14-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260513085340.3673127-1-neelx@suse.com>
References: <20260513085340.3673127-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 98E2D53020A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[suse.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1568-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[osandov.com:email,toxicpanda.com:email,suse.com:email,suse.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,dorminy.me:email]
X-Rspamd-Action: no action

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
contain a nokey name, the first time the name is successfully matched
to a stored name populates the disk name field of the fscrypt_name,
allowing the caller to use the normal disk name codepaths afterward.
Otherwise, the matching functionality is in close analogue to the
function fscrypt_match_name().

Functions where most callers are providing a fscrypt_str are duplicated
and adapted for a fscrypt_name, and functions where most callers are
providing a fscrypt_name are changed to so require at all callsites.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v7 changes:
 * Return true instead of error as suggested by Chris' AI review.
v6 changes:
 * Adapt to changed prototypes.
 * Return error directly instead of goto out and remove the label in
   btrfs_inode_by_name().
v5: https://lore.kernel.org/linux-btrfs/52b31cd6e5c86f8fe3d08ce65bca5f40c3ce5c5a.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/btrfs_inode.h   |   2 +-
 fs/btrfs/delayed-inode.c |  25 ++++++-
 fs/btrfs/delayed-inode.h |   5 +-
 fs/btrfs/dir-item.c      |  73 +++++++++++++++---
 fs/btrfs/dir-item.h      |  10 ++-
 fs/btrfs/extent_io.c     |  41 +++++++++++
 fs/btrfs/extent_io.h     |   3 +
 fs/btrfs/fscrypt.c       |  33 +++++++++
 fs/btrfs/fscrypt.h       |  18 +++++
 fs/btrfs/inode.c         | 155 ++++++++++++++++++++++++---------------
 fs/btrfs/root-tree.c     |   9 ++-
 fs/btrfs/root-tree.h     |   2 +-
 fs/btrfs/tree-log.c      |   3 +-
 13 files changed, 301 insertions(+), 78 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 81940b27b037..9499e15609b3 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -560,7 +560,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
 int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
-		       const struct fscrypt_str *name);
+		       struct fscrypt_name *name);
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
 		   const struct fscrypt_str *name, bool add_backref, u64 index);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 09795439b9fb..097fe6ec60ba 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1784,7 +1784,9 @@ bool btrfs_should_delete_dir_index(const struct list_head *del_list, u64 index)
 /*
  * Read dir info stored in the delayed tree.
  */
-bool btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
+bool btrfs_readdir_delayed_dir_index(const struct inode *inode,
+				     struct fscrypt_str *fstr,
+				     struct dir_context *ctx,
 				     const struct list_head *ins_list)
 {
 	struct btrfs_dir_item *di;
@@ -1793,6 +1795,7 @@ bool btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 	char *name;
 	int name_len;
 	unsigned char d_type;
+	size_t fstr_len = fstr->len;
 
 	/*
 	 * Changing the data of the delayed item is impossible. So
@@ -1819,7 +1822,25 @@ bool btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 		d_type = fs_ftype_to_dtype(btrfs_dir_flags_to_ftype(di->type));
 		btrfs_disk_key_to_cpu(&location, &di->location);
 
-		over = !dir_emit(ctx, name, name_len, location.objectid, d_type);
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
+			ret = fscrypt_fname_disk_to_usr(inode, 0, 0, &iname, fstr);
+			if (ret)
+				return true;
+			over = !dir_emit(ctx, fstr->name, fstr->len, location.objectid, d_type);
+		} else {
+			over = !dir_emit(ctx, name, name_len, location.objectid, d_type);
+		}
 
 		if (refcount_dec_and_test(&curr->refs))
 			kfree(curr);
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index fc752863f89b..9bff11478632 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -19,6 +19,7 @@
 #include <linux/ref_tracker.h>
 #include "ctree.h"
 
+struct fscrypt_str;
 struct btrfs_disk_key;
 struct btrfs_fs_info;
 struct btrfs_inode;
@@ -159,7 +160,9 @@ void btrfs_readdir_put_delayed_items(struct btrfs_inode *inode,
 				     struct list_head *ins_list,
 				     struct list_head *del_list);
 bool btrfs_should_delete_dir_index(const struct list_head *del_list, u64 index);
-bool btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
+bool btrfs_readdir_delayed_dir_index(const struct inode *inode,
+				     struct fscrypt_str *fstr,
+				     struct dir_context *ctx,
 				     const struct list_head *ins_list);
 
 /* Used during directory logging. */
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 84f1c64423d3..1525b945646b 100644
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
@@ -227,6 +228,47 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
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
+		di = btrfs_match_dir_item_fname(path, name);
+
+	if (ret == -ENOENT || (di && IS_ERR(di) && PTR_ERR(di) == -ENOENT))
+		return NULL;
+	if (ret < 0)
+		di = ERR_PTR(ret);
+
+	return di;
+}
+
 int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir_ino,
 				   const struct fscrypt_str *name)
 {
@@ -276,9 +318,9 @@ int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir_ino,
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
@@ -316,7 +358,7 @@ btrfs_lookup_dir_index_item(struct btrfs_trans_handle *trans,
 
 struct btrfs_dir_item *
 btrfs_search_dir_index_item(struct btrfs_root *root, struct btrfs_path *path,
-			    u64 dirid, const struct fscrypt_str *name)
+			    u64 dirid, struct fscrypt_name *name)
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
@@ -329,8 +371,7 @@ btrfs_search_dir_index_item(struct btrfs_root *root, struct btrfs_path *path,
 	btrfs_for_each_slot(root, &key, &key, path, ret) {
 		if (key.objectid != dirid || key.type != BTRFS_DIR_INDEX_KEY)
 			break;
-
-		di = btrfs_match_dir_item_name(path, name->name, name->len);
+		di = btrfs_match_dir_item_fname(path, name);
 		if (di)
 			return di;
 	}
@@ -366,8 +407,8 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
  * this walks through all the entries in a dir item and finds one
  * for a specific name.
  */
-struct btrfs_dir_item *btrfs_match_dir_item_name(const struct btrfs_path *path,
-						 const char *name, int name_len)
+struct btrfs_dir_item *btrfs_match_dir_item_fname(const struct btrfs_path *path,
+						  struct fscrypt_name *name)
 {
 	struct btrfs_dir_item *dir_item;
 	unsigned long name_ptr;
@@ -386,8 +427,8 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(const struct btrfs_path *path,
 			btrfs_dir_data_len(leaf, dir_item);
 		name_ptr = (unsigned long)(dir_item + 1);
 
-		if (btrfs_dir_name_len(leaf, dir_item) == name_len &&
-		    memcmp_extent_buffer(leaf, name, name_ptr, name_len) == 0)
+		if (btrfs_fscrypt_match_name(name, leaf, name_ptr,
+					     btrfs_dir_name_len(leaf, dir_item)))
 			return dir_item;
 
 		cur += this_len;
@@ -397,6 +438,20 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(const struct btrfs_path *path,
 	return NULL;
 }
 
+/*
+ * helper function to look at the directory item pointed to by 'path'
+ * this walks through all the entries in a dir item and finds one
+ * for a specific name.
+ */
+struct btrfs_dir_item *btrfs_match_dir_item_name(const struct btrfs_path *path,
+						 const char *name, int name_len)
+{
+	struct fscrypt_name fname = {
+		.disk_name = FSTR_INIT((char *) name, name_len)
+	};
+	return btrfs_match_dir_item_fname(path, &fname);
+}
+
 /*
  * given a pointer into a directory item, delete it.  This
  * handles items that have more than one entry in them.
diff --git a/fs/btrfs/dir-item.h b/fs/btrfs/dir-item.h
index e52174a8baf9..f89d12ee28a7 100644
--- a/fs/btrfs/dir-item.h
+++ b/fs/btrfs/dir-item.h
@@ -7,6 +7,7 @@
 #include <linux/crc32c.h>
 
 struct fscrypt_str;
+struct fscrypt_name;
 struct btrfs_fs_info;
 struct btrfs_key;
 struct btrfs_path;
@@ -23,6 +24,11 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
 					     struct btrfs_path *path, u64 dir,
 					     const struct fscrypt_str *name, int mod);
+struct btrfs_dir_item *btrfs_lookup_dir_item_fname(
+			struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct btrfs_path *path, u64 dir,
+			struct fscrypt_name *name, int mod);
 struct btrfs_dir_item *btrfs_lookup_dir_index_item(
 			struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
@@ -30,7 +36,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_index_item(
 			u64 index, const struct fscrypt_str *name, int mod);
 struct btrfs_dir_item *btrfs_search_dir_index_item(struct btrfs_root *root,
 			    struct btrfs_path *path, u64 dirid,
-			    const struct fscrypt_str *name);
+			    struct fscrypt_name *name);
 int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct btrfs_path *path,
@@ -48,6 +54,8 @@ struct btrfs_dir_item *btrfs_lookup_xattr(struct btrfs_trans_handle *trans,
 struct btrfs_dir_item *btrfs_match_dir_item_name(const struct btrfs_path *path,
 						 const char *name,
 						 int name_len);
+struct btrfs_dir_item *btrfs_match_dir_item_fname(const struct btrfs_path *path,
+						  struct fscrypt_name *name);
 
 static inline u64 btrfs_name_hash(const char *name, int len)
 {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2275189b7860..2819989f895f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4160,6 +4160,47 @@ static void assert_eb_folio_uptodate(const struct extent_buffer *eb, int i)
 	}
 }
 
+/* Take a sha256 of a portion of an extent buffer. */
+void extent_buffer_sha256(const struct extent_buffer *eb,
+			  unsigned long start,
+			  unsigned long len, u8 *out)
+{
+	size_t cur;
+	size_t offset;
+	char *kaddr;
+	unsigned long i = get_eb_folio_index(eb, start);
+	struct sha256_ctx sctx;
+
+	if (check_eb_range(eb, start, len))
+		return;
+
+	if (eb->addr) {
+		sha256(eb->addr + start, len, out);
+		return;
+	}
+
+	offset = get_eb_offset_in_folio(eb, start);
+
+	/*
+	 * TODO: This should maybe be using the crypto API, not the fallback,
+	 * but fscrypt uses the fallback and this is only used in emulation of
+	 * fscrypt's buffer sha256 method.
+	 */
+	sha256_init(&sctx);
+	while (len > 0) {
+		assert_eb_folio_uptodate(eb, i);
+
+		cur = min(len, PAGE_SIZE - offset);
+		kaddr = folio_address(eb->folios[i]);
+		sha256_update(&sctx, (u8 *)(kaddr + offset), cur);
+
+		len -= cur;
+		offset = 0;
+		i++;
+	}
+	sha256_final(&sctx, out);
+}
+
 static void __write_extent_buffer(const struct extent_buffer *eb,
 				  const void *srcv, unsigned long start,
 				  unsigned long len, bool use_memmove)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b310a5145cf6..8c7da2962cd4 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -329,6 +329,9 @@ static inline bool extent_buffer_uptodate(const struct extent_buffer *eb)
 
 int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
 			 unsigned long start, unsigned long len);
+void extent_buffer_sha256(const struct extent_buffer *eb,
+			  unsigned long start,
+			  unsigned long len, u8 *out);
 void read_extent_buffer(const struct extent_buffer *eb, void *dst,
 			unsigned long start,
 			unsigned long len);
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index c503f817cbe7..ae4f15762842 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -1,17 +1,50 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/iversion.h>
+#include <crypto/sha2.h>
 #include "ctree.h"
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
+		return !memcmp_extent_buffer(leaf, fname->disk_name.name, de_name, de_name_len);
+	}
+
+	if (de_name_len <= sizeof(nokey_name->bytes))
+		return false;
+
+	if (memcmp_extent_buffer(leaf, nokey_name->bytes, de_name, sizeof(nokey_name->bytes)))
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
index 80adb7e56826..4e9c87290158 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -4,9 +4,27 @@
 #define BTRFS_FSCRYPT_H
 
 #include <linux/fscrypt.h>
+#include "extent_map.h"
 
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
+	return !memcmp_extent_buffer(leaf, fname->disk_name.name, de_name, de_name_len);
+}
+#endif /* CONFIG_FS_ENCRYPTION */
+
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
 
 #endif /* BTRFS_FSCRYPT_H */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 14bad4cdb900..0bae9179eb12 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4404,7 +4404,7 @@ static void update_time_after_link_or_unlink(struct btrfs_inode *dir)
 static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 				struct btrfs_inode *dir,
 				struct btrfs_inode *inode,
-				const struct fscrypt_str *name,
+				struct fscrypt_name *name,
 				struct btrfs_rename_ctx *rename_ctx)
 {
 	struct btrfs_root *root = dir->root;
@@ -4420,7 +4420,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino, name, -1);
+	di = btrfs_lookup_dir_item_fname(trans, root, path, dir_ino, name, -1);
 	if (IS_ERR_OR_NULL(di)) {
 		btrfs_free_path(path);
 		return di ? PTR_ERR(di) : -ENOENT;
@@ -4452,11 +4452,13 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	ret = btrfs_del_inode_ref(trans, root, name, ino, dir_ino, &index);
+	ret = btrfs_del_inode_ref(trans, root, &name->disk_name, ino, dir_ino, &index);
 	if (unlikely(ret)) {
+		/* This should print a base-64 encoded name if relevant? */
 		btrfs_crit(fs_info,
 	   "failed to delete reference to %.*s, root %llu inode %llu parent %llu",
-			   name->len, name->name, btrfs_root_id(root), ino, dir_ino);
+			   name->disk_name.len, name->disk_name.name,
+			   btrfs_root_id(root), ino, dir_ino);
 		btrfs_abort_transaction(trans, ret);
 		return ret;
 	}
@@ -4477,8 +4479,8 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	 * operations on the log tree, increasing latency for applications.
 	 */
 	if (!rename_ctx) {
-		btrfs_del_inode_ref_in_log(trans, name, inode, dir);
-		btrfs_del_dir_entries_in_log(trans, name, dir, index);
+		btrfs_del_inode_ref_in_log(trans, &name->disk_name, inode, dir);
+		btrfs_del_dir_entries_in_log(trans, &name->disk_name, dir, index);
 	}
 
 	/*
@@ -4492,7 +4494,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	 */
 	btrfs_run_delayed_iput(fs_info, inode);
 
-	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name->len * 2);
+	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name->disk_name.len * 2);
 	inode_inc_iversion(&inode->vfs_inode);
 	inode_set_ctime_current(&inode->vfs_inode);
 	inode_inc_iversion(&dir->vfs_inode);
@@ -4503,7 +4505,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
-		       const struct fscrypt_str *name)
+		       struct fscrypt_name *name)
 {
 	int ret;
 
@@ -4550,11 +4552,9 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 		goto fscrypt_free;
 	}
 
-	btrfs_record_unlink_dir(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
-				false);
+	btrfs_record_unlink_dir(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)), false);
 
-	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
-				 &fname.disk_name);
+	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)), &fname);
 	if (ret)
 		goto end_trans;
 
@@ -4591,8 +4591,6 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	/* This needs to handle no-key deletions later on */
-
 	if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID) {
 		objectid = btrfs_root_id(inode->root);
 	} else if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
@@ -4609,8 +4607,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
-				   &fname.disk_name, -1);
+	di = btrfs_lookup_dir_item_fname(trans, root, path, dir_ino, &fname, -1);
 	if (IS_ERR_OR_NULL(di)) {
 		ret = di ? PTR_ERR(di) : -ENOENT;
 		goto out;
@@ -4636,7 +4633,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	 * call btrfs_del_root_ref, and it _shouldn't_ fail.
 	 */
 	if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID) {
-		di = btrfs_search_dir_index_item(root, path, dir_ino, &fname.disk_name);
+		di = btrfs_search_dir_index_item(root, path, dir_ino, &fname);
 		if (IS_ERR(di)) {
 			ret = PTR_ERR(di);
 			btrfs_abort_transaction(trans, ret);
@@ -4650,7 +4647,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	} else {
 		ret = btrfs_del_root_ref(trans, objectid,
 					 btrfs_root_id(root), dir_ino,
-					 &index, &fname.disk_name);
+					 &index, &fname);
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
@@ -4963,7 +4960,7 @@ static int btrfs_rmdir(struct inode *vfs_dir, struct dentry *dentry)
 	btrfs_record_unlink_dir(trans, dir, inode, false);
 
 	/* now the directory is empty */
-	ret = btrfs_unlink_inode(trans, dir, inode, &fname.disk_name);
+	ret = btrfs_unlink_inode(trans, dir, inode, &fname);
 	if (!ret)
 		btrfs_i_size_write(inode, 0);
 out:
@@ -5762,36 +5759,23 @@ void btrfs_evict_inode(struct inode *inode)
  * If no dir entries were found, returns -ENOENT.
  * If found a corrupted location in dir entry, returns -EUCLEAN.
  */
-static int btrfs_inode_by_name(struct btrfs_inode *dir, struct dentry *dentry,
+static int btrfs_inode_by_name(struct btrfs_inode *dir, struct fscrypt_name *fname,
 			       struct btrfs_key *location, u8 *type)
 {
 	struct btrfs_dir_item *di;
 	BTRFS_PATH_AUTO_FREE(path);
 	struct btrfs_root *root = dir->root;
 	int ret = 0;
-	struct fscrypt_name fname;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	ret = fscrypt_setup_filename(&dir->vfs_inode, &dentry->d_name, 1, &fname);
-	if (ret < 0)
-		return ret;
-	/*
-	 * fscrypt_setup_filename() should never return a positive value, but
-	 * gcc on sparc/parisc thinks it can, so assert that doesn't happen.
-	 */
-	ASSERT(ret == 0);
-
 	/* This needs to handle no-key deletions later on */
 
-	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(dir),
-				   &fname.disk_name, 0);
-	if (IS_ERR_OR_NULL(di)) {
-		ret = di ? PTR_ERR(di) : -ENOENT;
-		goto out;
-	}
+	di = btrfs_lookup_dir_item_fname(NULL, root, path, btrfs_ino(dir), fname, 0);
+	if (IS_ERR_OR_NULL(di))
+		return di ? PTR_ERR(di) : -ENOENT;
 
 	btrfs_dir_item_key_to_cpu(path->nodes[0], di, location);
 	if (unlikely(location->type != BTRFS_INODE_ITEM_KEY &&
@@ -5799,13 +5783,11 @@ static int btrfs_inode_by_name(struct btrfs_inode *dir, struct dentry *dentry,
 		ret = -EUCLEAN;
 		btrfs_warn(root->fs_info,
 "%s gets something invalid in DIR_ITEM (name %s, directory ino %llu, location " BTRFS_KEY_FMT ")",
-			   __func__, fname.disk_name.name, btrfs_ino(dir),
+			   __func__, fname->usr_fname->name, btrfs_ino(dir),
 			   BTRFS_KEY_FMT_VALUE(location));
 	}
 	if (!ret)
 		*type = btrfs_dir_ftype(path->nodes[0], di);
-out:
-	fscrypt_free_filename(&fname);
 	return ret;
 }
 
@@ -6072,20 +6054,27 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location = { 0 };
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
 		inode = btrfs_iget(location.objectid, root);
 		if (IS_ERR(inode))
-			return ERR_CAST(inode);
+			goto cleanup;
 
 		/* Do extra check against inode mode with di_type */
 		if (unlikely(btrfs_inode_type(inode) != di_type)) {
@@ -6094,9 +6083,10 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 				  inode->vfs_inode.i_mode, btrfs_inode_type(inode),
 				  di_type);
 			iput(&inode->vfs_inode);
-			return ERR_PTR(-EUCLEAN);
+			inode = ERR_PTR(-EUCLEAN);
+			goto cleanup;
 		}
-		return &inode->vfs_inode;
+		goto cleanup;
 	}
 
 	ret = fixup_tree_root_location(fs_info, BTRFS_I(dir), dentry,
@@ -6111,7 +6101,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 		btrfs_put_root(sub_root);
 
 		if (IS_ERR(inode))
-			return ERR_CAST(inode);
+			goto cleanup;
 
 		down_read(&fs_info->cleanup_work_sem);
 		if (!sb_rdonly(inode->vfs_inode.i_sb))
@@ -6123,6 +6113,9 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 		}
 	}
 
+cleanup:
+	fscrypt_free_filename(&fname);
+
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
@@ -6321,18 +6314,32 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
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
@@ -6349,6 +6356,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		struct dir_entry *entry;
 		struct extent_buffer *leaf = path->nodes[0];
 		u8 ftype;
+		u32 nokey_len;
 
 		if (found_key.objectid != key.objectid)
 			break;
@@ -6362,8 +6370,12 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
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
+		if ((total_len + sizeof(struct dir_entry) + nokey_len) >= PAGE_SIZE) {
 			btrfs_release_path(path);
 			ret = btrfs_filldir(private->filldir_buf, entries, ctx);
 			if (ret)
@@ -6377,8 +6389,31 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		ftype = btrfs_dir_flags_to_ftype(btrfs_dir_flags(leaf, di));
 		entry = addr;
 		name_ptr = (char *)(entry + 1);
-		read_extent_buffer(leaf, name_ptr,
-				   (unsigned long)(di + 1), name_len);
+		if (btrfs_dir_flags(leaf, di) & BTRFS_FT_ENCRYPTED) {
+			struct fscrypt_str oname = FSTR_INIT(name_ptr, nokey_len);
+			u32 hash = 0, minor_hash = 0;
+
+			read_extent_buffer(leaf, fstr.name, (unsigned long)(di + 1), name_len);
+			fstr.len = name_len;
+			/*
+			 * We're iterating through DIR_INDEX items, so we don't
+			 * have the DIR_ITEM hash handy. Only compute it if
+			 * we'll need it -- the nokey name stores it, so that
+			 * we can look up the appropriate item by nokey name
+			 * later on.
+			 */
+			if (!fscrypt_has_encryption_key(inode)) {
+				u64 name_hash = btrfs_name_hash(fstr.name, fstr.len);
+				hash = name_hash;
+				minor_hash = name_hash >> 32;
+			}
+			ret = fscrypt_fname_disk_to_usr(inode, hash, minor_hash, &fstr, &oname);
+			if (ret)
+				goto err;
+			name_len = oname.len;
+		} else {
+			read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1), name_len);
+		}
 		put_unaligned(name_len, &entry->name_len);
 		put_unaligned(fs_ftype_to_dtype(ftype), &entry->type);
 		btrfs_dir_item_key_to_cpu(leaf, di, &location);
@@ -6398,7 +6433,8 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	if (ret)
 		goto nopos;
 
-	if (btrfs_readdir_delayed_dir_index(ctx, &ins_list))
+	fstr.len = fstr_len;
+	if (btrfs_readdir_delayed_dir_index(inode, &fstr, ctx, &ins_list))
 		goto nopos;
 
 	/*
@@ -6427,6 +6463,8 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 err:
 	if (put)
 		btrfs_readdir_put_delayed_items(BTRFS_I(inode), &ins_list, &del_list);
+err_fstr:
+	fscrypt_fname_free_buffer(&fstr);
 	return ret;
 }
 
@@ -6928,6 +6966,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = parent_inode->root;
 	u64 ino = btrfs_ino(inode);
 	u64 parent_ino = btrfs_ino(parent_inode);
+	struct fscrypt_name fname = { .disk_name = *name };
 
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		memcpy(&key, &inode->root->root_key, sizeof(key));
@@ -6975,7 +7014,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 		int ret2;
 
 		ret2 = btrfs_del_root_ref(trans, key.objectid, btrfs_root_id(root),
-					  parent_ino, &local_index, name);
+					  parent_ino, &local_index, &fname);
 		if (ret2)
 			btrfs_abort_transaction(trans, ret2);
 	} else if (add_backref) {
@@ -8497,7 +8536,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	} else { /* src is an inode */
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					   BTRFS_I(old_dentry->d_inode),
-					   old_name, &old_rename_ctx);
+					   &old_fname, &old_rename_ctx);
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			goto out_fail;
@@ -8519,7 +8558,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	} else { /* dest is an inode */
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(new_dir),
 					   BTRFS_I(new_dentry->d_inode),
-					   new_name, &new_rename_ctx);
+					   &new_fname, &new_rename_ctx);
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			goto out_fail;
@@ -8788,7 +8827,7 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 	} else {
 		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					   BTRFS_I(d_inode(old_dentry)),
-					   &old_fname.disk_name, &rename_ctx);
+					   &old_fname, &rename_ctx);
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			goto out_fail;
@@ -8813,7 +8852,7 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 		} else {
 			ret = btrfs_unlink_inode(trans, BTRFS_I(new_dir),
 						 BTRFS_I(d_inode(new_dentry)),
-						 &new_fname.disk_name);
+						 &new_fname);
 			if (unlikely(ret)) {
 				btrfs_abort_transaction(trans, ret);
 				goto out_fail;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index d85a09ae1733..9f0f73200889 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -10,6 +10,7 @@
 #include "messages.h"
 #include "transaction.h"
 #include "disk-io.h"
+#include "fscrypt.h"
 #include "qgroup.h"
 #include "space-info.h"
 #include "accessors.h"
@@ -328,7 +329,7 @@ int btrfs_del_root(struct btrfs_trans_handle *trans,
 
 int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       u64 ref_id, u64 dirid, u64 *sequence,
-		       const struct fscrypt_str *name)
+		       struct fscrypt_name *name)
 {
 	struct btrfs_root *tree_root = trans->fs_info->tree_root;
 	BTRFS_PATH_AUTO_FREE(path);
@@ -350,15 +351,15 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 	if (ret < 0) {
 		return ret;
 	} else if (ret == 0) {
+		u32 name_len;
 		leaf = path->nodes[0];
 		ref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_root_ref);
 		ptr = (unsigned long)(ref + 1);
+		name_len = btrfs_root_ref_name_len(leaf, ref);
 		if ((btrfs_root_ref_dirid(leaf, ref) != dirid) ||
-		    (btrfs_root_ref_name_len(leaf, ref) != name->len) ||
-		    memcmp_extent_buffer(leaf, name->name, ptr, name->len))
+		    !btrfs_fscrypt_match_name(name, leaf, ptr, name_len))
 			return -ENOENT;
-
 		*sequence = btrfs_root_ref_sequence(leaf, ref);
 
 		ret = btrfs_del_item(trans, tree_root, path);
diff --git a/fs/btrfs/root-tree.h b/fs/btrfs/root-tree.h
index 8f5739e732b9..e85623dba952 100644
--- a/fs/btrfs/root-tree.h
+++ b/fs/btrfs/root-tree.h
@@ -23,7 +23,7 @@ int btrfs_add_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       const struct fscrypt_str *name);
 int btrfs_del_root_ref(struct btrfs_trans_handle *trans, u64 root_id,
 		       u64 ref_id, u64 dirid, u64 *sequence,
-		       const struct fscrypt_str *name);
+		       struct fscrypt_name *name);
 int btrfs_del_root(struct btrfs_trans_handle *trans, const struct btrfs_key *key);
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      const struct btrfs_key *key,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e6cd475057db..81f0990d638b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1045,9 +1045,10 @@ static int unlink_inode_for_log_replay(struct walk_control *wc,
 				       const struct fscrypt_str *name)
 {
 	struct btrfs_trans_handle *trans = wc->trans;
+	struct fscrypt_name fname = { .disk_name = *name, };
 	int ret;
 
-	ret = btrfs_unlink_inode(trans, dir, inode, name);
+	ret = btrfs_unlink_inode(trans, dir, inode, &fname);
 	if (ret) {
 		btrfs_abort_log_replay(wc, ret,
 	       "failed to unlink inode %llu parent dir %llu name %.*s root %llu",
-- 
2.53.0


