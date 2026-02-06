Return-Path: <linux-fscrypt+bounces-1117-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ALCZLlQ2hmlrLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1117-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:43:32 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A0E1022C8
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:43:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 078C930B1FC6
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C04F544BC8C;
	Fri,  6 Feb 2026 18:25:25 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737D443DA25
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402325; cv=none; b=Eog23RpRkI16kvFfEeSNTpdsNRpqjLi2oRq+fvIGqWLdHK1F75jh9IuR7bD8JSyz2Z8yhiWPwbUiQxVpr5Ezr3IYz0McbW8mLMnGnUvNB9DnrBF0ZwvtDXCWVGyqBua3OC+AckVrKyOUlmZNGSGRncBKlG+06nDcCXnVn7B5360=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402325; c=relaxed/simple;
	bh=9LsGDAhN6yaS4eVreOGRrVmOuVBkuDvHtHFMAJyoGyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nr2PsdFQ2evnLZXOraBX7/uyTuoReMNlsbSWLUkATaiRbMu/23wDj52mmU9BqaWnsb5Q7yMdd2UOEL+Fl0gXbdk1eH6QqB8oU4Sz41jiu/5xTqB7QfUNZwOe5J9Ctd6SyeN9zICNdh2oz/jORZoliYBoelvKiTqwJwOSoh7Iass=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 102F53E737;
	Fri,  6 Feb 2026 18:24:17 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D5F513EA63;
	Fri,  6 Feb 2026 18:24:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uOKzM9AxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:16 +0000
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 35/43] btrfs: make btrfs_ref_to_path handle encrypted filenames
Date: Fri,  6 Feb 2026 19:23:07 +0100
Message-ID: <20260206182336.1397715-36-neelx@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260206182336.1397715-1-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com>
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
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[suse.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1117-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.994];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:mid,suse.com:email]
X-Rspamd-Queue-Id: 29A0E1022C8
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

We use this helper for inode-resolve and path resolution in send, so
update this helper to properly decrypt any encrypted names it finds.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/365d4f820f70b7cf69b1b9cae9b949a15c3350b0.1706116485.git.josef@toxicpanda.com/
 * Adapted to btrfs_iget() now returning binode instead of vfs inode
   as before.
 * Adapted to crypt info being moved from vfs inode to FS specific inode.
---
 fs/btrfs/backref.c | 42 +++++++++++++++++++++++++++++++++++++----
 fs/btrfs/fscrypt.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/fscrypt.h | 10 ++++++++++
 3 files changed, 95 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 9bb406f7dd30..577c3ef87791 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -20,6 +20,7 @@
 #include "extent-tree.h"
 #include "relocation.h"
 #include "tree-checker.h"
+#include "fscrypt.h"
 
 /* Just arbitrary numbers so we can be sure one of these happened. */
 #define BACKREF_FOUND_SHARED     6
@@ -2107,6 +2108,39 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
 	return ret;
 }
 
+static int copy_resolved_iref_to_buf(struct btrfs_root *fs_root,
+				     struct extent_buffer *eb, char *dest,
+				     u64 parent, unsigned long name_off,
+				     u32 name_len, s64 *bytes_left)
+{
+	struct btrfs_fs_info *fs_info = fs_root->fs_info;
+	struct fscrypt_str fname = FSTR_INIT(NULL, 0);
+	int ret;
+
+	/* No encryption, just copy the name in. */
+	if (!btrfs_fs_incompat(fs_info, ENCRYPT)) {
+		*bytes_left -= name_len;
+		if (*bytes_left >= 0)
+			read_extent_buffer(eb, dest + *bytes_left, name_off, name_len);
+		return 0;
+	}
+
+	ret = fscrypt_fname_alloc_buffer(BTRFS_NAME_LEN, &fname);
+	if (ret)
+		return ret;
+
+	ret = btrfs_decrypt_name(fs_root, eb, name_off, name_len, parent, &fname);
+	if (ret)
+		goto out;
+
+	*bytes_left -= fname.len;
+	if (*bytes_left >= 0)
+		memcpy(dest + *bytes_left, fname.name, fname.len);
+out:
+	fscrypt_fname_free_buffer(&fname);
+	return ret;
+}
+
 /*
  * this iterates to turn a name (from iref/extref) into a full filesystem path.
  * Elements of the path are separated by '/' and the path is guaranteed to be
@@ -2138,10 +2172,10 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 		dest[bytes_left] = '\0';
 
 	while (1) {
-		bytes_left -= name_len;
-		if (bytes_left >= 0)
-			read_extent_buffer(eb, dest + bytes_left,
-					   name_off, name_len);
+		ret = copy_resolved_iref_to_buf(fs_root, eb, dest, parent,
+						name_off, name_len, &bytes_left);
+		if (ret)
+			break;
 		if (eb != eb_in) {
 			if (!path->skip_locking)
 				btrfs_tree_read_unlock(eb);
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index d1a4cbb990d4..bcb86cbaa171 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -385,6 +385,53 @@ int btrfs_fscrypt_bio_length(struct bio *bio, u64 map_length)
 	return map_length;
 }
 
+int btrfs_decrypt_name(struct btrfs_root *root, struct extent_buffer *eb,
+		       unsigned long name_off, u32 name_len,
+		       u64 parent_ino, struct fscrypt_str *name)
+{
+	struct btrfs_inode *inode;
+	struct inode *dir;
+	struct fscrypt_str iname = FSTR_INIT(NULL, 0);
+	int ret;
+
+	ASSERT(name_len <= BTRFS_NAME_LEN);
+
+	ret = fscrypt_fname_alloc_buffer(name_len, &iname);
+	if (ret)
+		return ret;
+
+	inode = btrfs_iget(parent_ino, root);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		goto out;
+	}
+	dir = &inode->vfs_inode;
+
+	/*
+	 * Directory isn't encrypted, the name isn't encrypted, we can just copy
+	 * it into the buffer.
+	 */
+	if (!IS_ENCRYPTED(dir)) {
+		read_extent_buffer(eb, name->name, name_off, name_len);
+		name->len = name_len;
+		goto out_inode;
+	}
+
+	read_extent_buffer(eb, iname.name, name_off, name_len);
+
+	ret = fscrypt_prepare_readdir(dir);
+	if (ret)
+		goto out_inode;
+
+	ASSERT(inode->i_crypt_info);
+	ret = fscrypt_fname_disk_to_usr(dir, 0, 0, &iname, name);
+out_inode:
+	iput(dir);
+out:
+	fscrypt_fname_free_buffer(&iname);
+	return ret;
+}
+
 const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.inode_info_offs = (int)offsetof(struct btrfs_inode, i_crypt_info) -
 			   (int)offsetof(struct btrfs_inode, vfs_inode),
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 347b34f45715..4f49ed6176d4 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -32,6 +32,9 @@ bool btrfs_mergeable_encrypted_bio(struct bio *bio, struct inode *inode,
 				   struct fscrypt_extent_info *fi,
 				   u64 logical_offset);
 int btrfs_fscrypt_bio_length(struct bio *bio, u64 map_length);
+int btrfs_decrypt_name(struct btrfs_root *root, struct extent_buffer *eb,
+		       unsigned long name_off, u32 name_len,
+		       u64 parent_ino, struct fscrypt_str *name);
 
 #else
 static inline void btrfs_fscrypt_save_extent_info(struct btrfs_path *path,
@@ -91,6 +94,13 @@ static inline u64 btrfs_fscrypt_bio_length(struct bio *bio, u64 map_length)
 	return map_length;
 }
 
+static inline int btrfs_decrypt_name(struct btrfs_root *root, struct extent_buffer *eb,
+				     unsigned long name_off, u32 name_len,
+				     u64 parent_ino, struct fscrypt_str *name)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_FS_ENCRYPTION */
 
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
-- 
2.51.0


