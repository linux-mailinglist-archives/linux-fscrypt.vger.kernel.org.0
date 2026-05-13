Return-Path: <linux-fscrypt+bounces-1570-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UFulGAU+BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1570-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:01:57 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CFD7530234
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:01:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9064830F1669
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2998D3EE1FB;
	Wed, 13 May 2026 08:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="l/fYUPou";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VGzMuO6a"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2C23EAC9E
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662507; cv=none; b=gUwibJKx0iR19MCZwmxAX8Lv81pyV5IK9ExvzU4CzyXaR76QpYCLJgf79JyQJWDIfgKYkUmwR/CNI8Q3UxVKShNIBfJdYb2saK4PLjwKZmiVyW/FZJ6eZhUNwC2EtsbMIZm9n6TeFpVjLtx/M1m19lxQ3X541l3eUi0vwPgiJzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662507; c=relaxed/simple;
	bh=94P+SRsXxZhohd1vsPmoPPpQ5SEJhyeoZt4KF1gpwaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SD/aVP9xUn8XPREITFxKx1Om60tMfLAUCr7RCY0JcZKx/qMO6U2l1qlqONpZE/x0voDFJ0kMmIuxaSkmwkLbeTm3TVhpt3IwwrHbkoeX32+LlawnZHGOkJJSc+RMAJhmJlRdp3WRGLOvjV/gM+mhvzZ52oOz2cVpxIMRbuF9qUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=l/fYUPou; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VGzMuO6a; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EFAE476652;
	Wed, 13 May 2026 08:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sWReB9WTng1IwqRCJwegtHT96f7uSBkqcgWgR62g8Tk=;
	b=l/fYUPouAmADVq4AzaOCYFXE2qqS0DntYS3lwQJ3UUN+mrwP1bAuxFGiMPl28szM+9H5aX
	OdRrtUNEg1qDrl4dE/aXew7N5i8OavFf8/X+yzy31AAirVQCIPMiLfqe3Onw4ZVI7p1N9P
	Yxy8CU4RW6VszNRge7RQnbVba2D2OgY=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662467; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sWReB9WTng1IwqRCJwegtHT96f7uSBkqcgWgR62g8Tk=;
	b=VGzMuO6aG4DJdh/rpAFGRJ+cC0RHxcjmO6mEQOwaiJJ0HPaEPBsmfCg+ur/pcImN1cFd3g
	AraHIRQdp4o+QYOOVyP6urFgjZyzzNfD09Nc0qZ4wkxvXVRlulWz/sKp/p21KfiOU7+od+
	khZRGKITjVToOJPc1XaEGCE6YtzESMQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CBA11593A9;
	Wed, 13 May 2026 08:54:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eF4+MUM8BGpERwAAD6G6ig
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
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v7 14/43] btrfs: handle nokey names
Date: Wed, 13 May 2026 10:52:48 +0200
Message-ID: <20260513085340.3673127-15-neelx@suse.com>
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
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Rspamd-Queue-Id: 6CFD7530234
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1570-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,suse.com:email,suse.com:mid,suse.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,dorminy.me:email]
X-Rspamd-Action: no action

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

For encrypted or unencrypted names, we calculate the offset for the dir
item by hashing the name for the dir item. However, this doesn't work
for a long nokey name, where we do not have the complete ciphertext.
Instead, fscrypt stores the filesystem-provided hash in the nokey name,
and we can extract it from the fscrypt_name structure in such a case.

Additionally, for nokey names, if we find the nokey name on disk we can
update the fscrypt_name with the disk name, so add that to searching for
diritems.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v7 changes:
 * Fix a memory leak as found by Chris' AI review.
No changes in v6.
v5: https://lore.kernel.org/linux-btrfs/a7e3aec8ec03814b4baa1d929ae8fb77f13c17d2.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/dir-item.c | 43 +++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/fscrypt.c  | 27 +++++++++++++++++++++++++++
 fs/btrfs/fscrypt.h  | 11 +++++++++++
 3 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 1525b945646b..09ce1b85af74 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -228,6 +228,35 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 	return di;
 }
 
+/*
+ * If appropriate, populate the disk name for a fscrypt_name looked up without
+ * a key.
+ *
+ * @path:	The path to the extent buffer in which the name was found.
+ * @di:		The dir item corresponding.
+ * @fname:	The fscrypt_name to perhaps populate.
+ *
+ * Returns: 0 if the name is already populated or the dir item doesn't exist
+ * or the name was successfully populated, else an error code.
+ */
+static int ensure_disk_name_from_dir_item(struct btrfs_path *path,
+					  struct btrfs_dir_item *di,
+					  struct fscrypt_name *name)
+{
+	int ret;
+
+	if (name->disk_name.name || !di)
+		return 0;
+
+	ret = btrfs_fscrypt_get_disk_name(path->nodes[0], di, &name->disk_name);
+	if (ret)
+		return ret;
+
+	name->crypto_buf.name = name->disk_name.name;
+	name->crypto_buf.len  = name->disk_name.len;
+	return 0;
+}
+
 /*
  * Lookup for a directory item by fscrypt_name.
  *
@@ -254,8 +283,11 @@ struct btrfs_dir_item *btrfs_lookup_dir_item_fname(struct btrfs_trans_handle *tr
 
 	key.objectid = dir;
 	key.type = BTRFS_DIR_ITEM_KEY;
-	key.offset = btrfs_name_hash(name->disk_name.name, name->disk_name.len);
-	/* XXX get the right hash for no-key names */
+
+	if (!name->disk_name.name)
+		key.offset = name->hash | ((u64)name->minor_hash << 32);
+	else
+		key.offset = btrfs_name_hash(name->disk_name.name, name->disk_name.len);
 
 	ret = btrfs_search_slot(trans, root, &key, path, mod, -mod);
 	if (ret == 0)
@@ -263,6 +295,8 @@ struct btrfs_dir_item *btrfs_lookup_dir_item_fname(struct btrfs_trans_handle *tr
 
 	if (ret == -ENOENT || (di && IS_ERR(di) && PTR_ERR(di) == -ENOENT))
 		return NULL;
+	if (ret == 0)
+		ret = ensure_disk_name_from_dir_item(path, di, name);
 	if (ret < 0)
 		di = ERR_PTR(ret);
 
@@ -371,7 +405,12 @@ btrfs_search_dir_index_item(struct btrfs_root *root, struct btrfs_path *path,
 	btrfs_for_each_slot(root, &key, &key, path, ret) {
 		if (key.objectid != dirid || key.type != BTRFS_DIR_INDEX_KEY)
 			break;
+
 		di = btrfs_match_dir_item_fname(path, name);
+		if (di)
+			ret = ensure_disk_name_from_dir_item(path, di, name);
+		if (ret)
+			break;
 		if (di)
 			return di;
 	}
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index ae4f15762842..2fa33e69083d 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -15,6 +15,33 @@
 #include "transaction.h"
 #include "xattr.h"
 
+/*
+ * From a given location in a leaf, read a name into a qstr (usually a
+ * fscrypt_name's disk_name), allocating the required buffer. Used for
+ * nokey names.
+ */
+int btrfs_fscrypt_get_disk_name(struct extent_buffer *leaf,
+				struct btrfs_dir_item *dir_item,
+				struct fscrypt_str *name)
+{
+	unsigned long de_name_len = btrfs_dir_name_len(leaf, dir_item);
+	unsigned long de_name = (unsigned long)(dir_item + 1);
+	/*
+	 * For no-key names, we use this opportunity to find the disk
+	 * name, so future searches don't need to deal with nokey names
+	 * and we know what the encrypted size is.
+	 */
+	name->name = kmalloc(de_name_len, GFP_NOFS);
+
+	if (!name->name)
+		return -ENOMEM;
+
+	read_extent_buffer(leaf, name->name, de_name, de_name_len);
+
+	name->len = de_name_len;
+	return 0;
+}
+
 /*
  * This function is extremely similar to fscrypt_match_name() but uses an
  * extent_buffer.
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 4e9c87290158..c5cdc27f943c 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -9,11 +9,22 @@
 #include "fs.h"
 
 #ifdef CONFIG_FS_ENCRYPTION
+int btrfs_fscrypt_get_disk_name(struct extent_buffer *leaf,
+				struct btrfs_dir_item *di,
+				struct fscrypt_str *qstr);
+
 bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 			      struct extent_buffer *leaf,
 			      unsigned long de_name, u32 de_name_len);
 
 #else
+static inline int btrfs_fscrypt_get_disk_name(struct extent_buffer *leaf,
+					      struct btrfs_dir_item *di,
+					      struct fscrypt_str *qstr)
+{
+	return 0;
+}
+
 static inline bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 					    struct extent_buffer *leaf,
 					    unsigned long de_name,
-- 
2.53.0


