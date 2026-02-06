Return-Path: <linux-fscrypt+bounces-1112-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cKMoLfQ0hmlrLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1112-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:37:40 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C45210209D
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6669231800DE
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE23E43CEE9;
	Fri,  6 Feb 2026 18:25:13 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FC343CEC2
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402313; cv=none; b=jgTwNUgHzBOMrDcOiaB2GY7GURBBb0cALPpoXKOsZrJO36ckafnhH5ob/y4IRWGByT1tr51NFLmRZoTgAKH35u1Vv/lYjYjaHydrOFXib9q1Ea3ICSkChAOl2LQ8R0oeCpqA8PEOpSVvOOqv+8J/NV0f2p3rvuBeYQrhFsIFJmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402313; c=relaxed/simple;
	bh=jxsfwWOkFu6y3aSWsnhI7vrlS53sGNFWe3N9q0oyctE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/XWblEVDvgAAc604HZfO2FQ8aTobN3u2YfqCOXRUo1xwNcaoSMDLWYFRwyal9DGtDuS+qb5RRFRfAwC5810Fu5Gc1HGm9gQYEvYgr13Nwjp8KpFqD56EtZnR/ezWbY+P4yAfIGKufhIeqQZUVZZ9uFjemZjgFl5RL4F5uNIGJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E5CDF5BD03;
	Fri,  6 Feb 2026 18:24:17 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B97A53EA63;
	Fri,  6 Feb 2026 18:24:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gEDCLNExhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:17 +0000
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
Subject: [PATCH v6 37/43] btrfs: decrypt file names for send
Date: Fri,  6 Feb 2026 19:23:09 +0100
Message-ID: <20260206182336.1397715-38-neelx@suse.com>
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
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
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
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1112-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.994];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.com:mid,suse.com:email,toxicpanda.com:email]
X-Rspamd-Queue-Id: 3C45210209D
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

In send we're going to be looking up file names from back references and
putting them into the send stream.  If we are encrypted use the helper
for decrypting names and copy the decrypted name into the buffer.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/fd8b1d5f395a890dbdf8281a52fbaaa920c7b726.1706116485.git.josef@toxicpanda.com/
 * Simplified the error return logic in fs_path_add_from_encrypted().
---
 fs/btrfs/send.c | 47 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index b77f96ae2fea..faaade4c35dc 100644
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
2.51.0


