Return-Path: <linux-fscrypt+bounces-1596-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kCB4IgFABGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1596-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:10:25 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D305304DD
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1ED253149092
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 09:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6286E3EF67E;
	Wed, 13 May 2026 08:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OzdAKvyA";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OzdAKvyA"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914A53E5A03
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662599; cv=none; b=E8Omz/48HU8G57Az+TmAeUQ2+ca4bn0nkpiN12Qeyn+uoF4Ywcgf8iEGOehpM54nurh0GvZru6D6FibRPsMiJeCKPpn+SqmxZxZ7LTebOixsK6uHlhmOU4THIWBKBtxLliHPC6IwuGraMYVZFnaK1i9uoNaA9ECHtWuP3KjIkXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662599; c=relaxed/simple;
	bh=0PaKGKV9pn/F24X2tNYGC/fbQASdvA4fSV2UQLwI3GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwkHZ2BkgzWup4PfWiVYPUtAjo2GrTf+avCVaje6mgJ+ZsxxvVuucQS9HguFEkcojS+82dCVDm+B8WCGbGNKc7cyxhJvNVtGOHgj701iz7P3Q+wdZ6SDgOBmyhL8g2a9c/0dZRqTr2kC2VLIdEZM0MXxAX4bGE58NNu0bjvbHdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OzdAKvyA; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OzdAKvyA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 333FD7665C;
	Wed, 13 May 2026 08:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662485; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xcZdEbP79cX5oRQiJ3XPDjWtgMOPTRVTGtZ1DO2nEr8=;
	b=OzdAKvyA1/ehCjM5oXQMwYTeEe19bHCoZRtFkRCDX1Z6G+/h9Oz+pmOfAOdEw3xt7OXfuZ
	ttCiBKZv8FeJvj7sxKpAothcDQ90INimlcfMazbXYXpDpP78W2dF5yxdgUgLNYtiNPHlOr
	cFbmniWtq7+2GgovqlyW5VBHAwJhCpg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662485; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xcZdEbP79cX5oRQiJ3XPDjWtgMOPTRVTGtZ1DO2nEr8=;
	b=OzdAKvyA1/ehCjM5oXQMwYTeEe19bHCoZRtFkRCDX1Z6G+/h9Oz+pmOfAOdEw3xt7OXfuZ
	ttCiBKZv8FeJvj7sxKpAothcDQ90INimlcfMazbXYXpDpP78W2dF5yxdgUgLNYtiNPHlOr
	cFbmniWtq7+2GgovqlyW5VBHAwJhCpg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1159B593A9;
	Wed, 13 May 2026 08:54:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8F29A1U8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:45 +0000
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
Subject: [PATCH v7 37/43] btrfs: decrypt file names for send
Date: Wed, 13 May 2026 10:53:11 +0200
Message-ID: <20260513085340.3673127-38-neelx@suse.com>
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
X-Rspamd-Queue-Id: 01D305304DD
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
	TAGGED_FROM(0.00)[bounces-1596-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.com:email,suse.com:mid,suse.com:dkim]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

In send we're going to be looking up file names from back references and
putting them into the send stream.  If we are encrypted use the helper
for decrypting names and copy the decrypted name into the buffer.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

No changes in v7.
v6 changes:
 * Simplified the error return logic in fs_path_add_from_encrypted().
v5: https://lore.kernel.org/linux-btrfs/fd8b1d5f395a890dbdf8281a52fbaaa920c7b726.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/send.c | 47 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d5256c22fe7a..3d9764aa4a25 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -32,6 +32,7 @@
 #include "ioctl.h"
 #include "verity.h"
 #include "lru_cache.h"
+#include "fscrypt.h"
 
 /*
  * Maximum number of references an extent can have in order for us to attempt to
@@ -579,13 +580,39 @@ static inline int fs_path_add_path(struct fs_path *p, const struct fs_path *p2)
 	return fs_path_add(p, p2->start, fs_path_len(p2));
 }
 
-static int fs_path_add_from_extent_buffer(struct fs_path *p,
+static int fs_path_add_from_encrypted(struct btrfs_root *root,
+				      struct fs_path *p,
+				      struct extent_buffer *eb,
+				      unsigned long off, int len,
+				      u64 parent_ino)
+{
+	struct fscrypt_str fname = FSTR_INIT(NULL, 0);
+	int ret;
+
+	ret = fscrypt_fname_alloc_buffer(BTRFS_NAME_LEN, &fname);
+	if (ret)
+		return ret;
+
+	ret = btrfs_decrypt_name(root, eb, off, len, parent_ino, &fname);
+	if (!ret)
+		ret = fs_path_add(p, fname.name, fname.len);
+
+	fscrypt_fname_free_buffer(&fname);
+	return ret;
+}
+
+static int fs_path_add_from_extent_buffer(struct btrfs_root *root,
+					  struct fs_path *p,
 					  struct extent_buffer *eb,
-					  unsigned long off, int len)
+					  unsigned long off, int len,
+					  u64 parent_ino)
 {
 	int ret;
 	char *prepared;
 
+	if (root && btrfs_fs_incompat(root->fs_info, ENCRYPT))
+		return fs_path_add_from_encrypted(root, p, eb, off, len, parent_ino);
+
 	ret = fs_path_prepare_for_add(p, len, &prepared);
 	if (ret < 0)
 		return ret;
@@ -1062,8 +1089,7 @@ static int iterate_inode_ref(struct btrfs_root *root, struct btrfs_path *path,
 			}
 			p->start = start;
 		} else {
-			ret = fs_path_add_from_extent_buffer(p, eb, name_off,
-							     name_len);
+			ret = fs_path_add_from_extent_buffer(root, p, eb, name_off, name_len, dir);
 			if (ret < 0)
 				goto out;
 		}
@@ -1759,7 +1785,7 @@ static int read_symlink_unencrypted(struct btrfs_root *root, u64 ino, struct fs_
 	off = btrfs_file_extent_inline_start(ei);
 	len = btrfs_file_extent_ram_bytes(path->nodes[0], ei);
 
-	return fs_path_add_from_extent_buffer(dest, path->nodes[0], off, len);
+	return fs_path_add_from_extent_buffer(NULL, dest, path->nodes[0], off, len, 0);
 }
 
 static int read_symlink_encrypted(struct btrfs_root *root, u64 ino, struct fs_path *dest)
@@ -2034,18 +2060,19 @@ static int get_first_ref(struct btrfs_root *root, u64 ino,
 		iref = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				      struct btrfs_inode_ref);
 		len = btrfs_inode_ref_name_len(path->nodes[0], iref);
-		ret = fs_path_add_from_extent_buffer(name, path->nodes[0],
-						     (unsigned long)(iref + 1),
-						     len);
 		parent_dir = found_key.offset;
+		ret = fs_path_add_from_extent_buffer(root, name, path->nodes[0],
+						     (unsigned long)(iref + 1),
+						     len, parent_dir);
 	} else {
 		struct btrfs_inode_extref *extref;
 		extref = btrfs_item_ptr(path->nodes[0], path->slots[0],
 					struct btrfs_inode_extref);
 		len = btrfs_inode_extref_name_len(path->nodes[0], extref);
-		ret = fs_path_add_from_extent_buffer(name, path->nodes[0],
-					(unsigned long)&extref->name, len);
 		parent_dir = btrfs_inode_extref_parent(path->nodes[0], extref);
+		ret = fs_path_add_from_extent_buffer(root, name, path->nodes[0],
+					(unsigned long)&extref->name, len,
+					parent_dir);
 	}
 	if (ret < 0)
 		return ret;
-- 
2.53.0


