Return-Path: <linux-fscrypt+bounces-1591-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OBxVAYQ/BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1591-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:08:20 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A57530423
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:08:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E55A431A87A0
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 09:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFDBA4218BB;
	Wed, 13 May 2026 08:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JDYDoMve";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JDYDoMve"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749A03EF0CE
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662577; cv=none; b=po1Z/oa1/4wSDA93w4GSqwZOSIyOI4imp0uqT41ViqGBkbLn3Dqe36CpeT0CaE2pFaVKr4yfzNIvXRpAZb9NDvzHpGEugDmOYPmORdnJ9c66Tj450LBCr99rgLXIWG0IzLqNQ11bi7Z6xtiWhzzfJVfGRRftJLjm8fY4Pkx9IjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662577; c=relaxed/simple;
	bh=dPqekc2lLzoH3mrPbz6MiuSaMhRSu0eghQsQEEq1YjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpF5sbAx7a4EdkrRLgPdZMcMWTBB2lbdtijNpAYw8qWAy1sG7+Qu1J12X8uTov8eceSCmR1Q4uMprevhI1VBO1kdAC0BtBlzvqAwwiess7gC27R/oil6jacivIdJMJBiTJ99c3vobxVblLHOlMSbqWHzlotF5vaPeGlt2fRwDbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JDYDoMve; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JDYDoMve; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D83266AE54;
	Wed, 13 May 2026 08:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Fbg/oBv8BWBHtiBP9xV6wDlqW7uPmbyoDUFcYAdt5U=;
	b=JDYDoMve6CCcRJVM5PxMQNXcSrefN4hoXPAtwE8kx7fZOHgSbKOdChM8T7jv99BXjJie7t
	p9N2mDHFSg9jQZF+ik7CZ1ABHrQ33Z+p2jC2Afybh/7da8MZNUbvhcfy3hHW3PDhmhE3rd
	TcEXHq+Do66/Pa4D8MiyDN1XD+bZAvc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Fbg/oBv8BWBHtiBP9xV6wDlqW7uPmbyoDUFcYAdt5U=;
	b=JDYDoMve6CCcRJVM5PxMQNXcSrefN4hoXPAtwE8kx7fZOHgSbKOdChM8T7jv99BXjJie7t
	p9N2mDHFSg9jQZF+ik7CZ1ABHrQ33Z+p2jC2Afybh/7da8MZNUbvhcfy3hHW3PDhmhE3rd
	TcEXHq+Do66/Pa4D8MiyDN1XD+bZAvc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 864EE593A9;
	Wed, 13 May 2026 08:54:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WPZUIFM8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:43 +0000
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
Subject: [PATCH v7 35/43] btrfs: make btrfs_ref_to_path handle encrypted filenames
Date: Wed, 13 May 2026 10:53:09 +0200
Message-ID: <20260513085340.3673127-36-neelx@suse.com>
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
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Rspamd-Queue-Id: 99A57530423
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1591-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,toxicpanda.com:email,suse.com:email,suse.com:mid,suse.com:dkim]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

We use this helper for inode-resolve and path resolution in send, so
update this helper to properly decrypt any encrypted names it finds.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v7 changes:
 * Fix eb leak in failure case as suggested by Chris' AI review.
v6 changes:
 * Adapted to btrfs_iget() now returning binode instead of vfs inode
   as before.
 * Adapted to crypt info being moved from vfs inode to FS specific inode.
v5: https://lore.kernel.org/linux-btrfs/365d4f820f70b7cf69b1b9cae9b949a15c3350b0.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/backref.c | 43 ++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/fscrypt.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/fscrypt.h | 10 ++++++++++
 3 files changed, 96 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 273924ca912c..33d5df99be8e 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -20,6 +20,7 @@
 #include "extent-tree.h"
 #include "relocation.h"
 #include "tree-checker.h"
+#include "fscrypt.h"
 
 /* Just arbitrary numbers so we can be sure one of these happened. */
 #define BACKREF_FOUND_SHARED     6
@@ -2104,6 +2105,39 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
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
@@ -2135,15 +2169,16 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 		dest[bytes_left] = '\0';
 
 	while (1) {
-		bytes_left -= name_len;
-		if (bytes_left >= 0)
-			read_extent_buffer(eb, dest + bytes_left,
-					   name_off, name_len);
+		ret = copy_resolved_iref_to_buf(fs_root, eb, dest, parent,
+						name_off, name_len, &bytes_left);
 		if (eb != eb_in) {
 			if (!path->skip_locking)
 				btrfs_tree_read_unlock(eb);
 			free_extent_buffer(eb);
 		}
+		if (ret)
+			break;
+
 		ret = btrfs_find_item(fs_root, path, parent, 0,
 				BTRFS_INODE_REF_KEY, &found_key);
 		if (ret > 0)
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 111ca92a3450..a972c8eadfef 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -352,6 +352,53 @@ int btrfs_fscrypt_bio_length(struct bio *bio, u64 map_length)
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
index f7ce2b2e6639..4a1daed90d06 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -25,6 +25,9 @@ ssize_t btrfs_fscrypt_context_for_new_extent(struct btrfs_inode *inode,
 					     struct fscrypt_extent_info *info,
 					     u8 *ctx);
 int btrfs_fscrypt_bio_length(struct bio *bio, u64 map_length);
+int btrfs_decrypt_name(struct btrfs_root *root, struct extent_buffer *eb,
+		       unsigned long name_off, u32 name_len,
+		       u64 parent_ino, struct fscrypt_str *name);
 
 #else
 static inline void btrfs_fscrypt_save_extent_info(struct btrfs_path *path,
@@ -69,6 +72,13 @@ static inline u64 btrfs_fscrypt_bio_length(struct bio *bio, u64 map_length)
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
2.53.0


