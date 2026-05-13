Return-Path: <linux-fscrypt+bounces-1595-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WGi4Nrw/BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1595-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:09:16 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60850530481
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:09:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7C26F31B8663
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 09:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CAC83E5A34;
	Wed, 13 May 2026 08:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="q7mH8ww7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="q7mH8ww7"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C96425CF6
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662592; cv=none; b=EP8OBgwsXZ+xrwqC11QAHHDHD7n6h/RRcPFpDCB7Ii/idM8NYVmTj8nepDCsK9dwayT2bTYa37+Fy/IMi5z6iMkrutBrf89vGmHVZwAGF5JvQA1IWrrYPUi57KRMV3rKz5a2dXn4qRwZy/7+XToxfZqwvHDiehqOjC2xDkbo7KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662592; c=relaxed/simple;
	bh=OfxRv/x1GKZM+dnlSRHrJgn0vdJsuIgV/p5vmY/NovA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpoR1gtx0qoOdu2ihbgHNMiYm112v+G15WRHnmTzWWGZY8mrkC/82SD2FYp2L2ZxjhTsMgWwYS5DFcAYMefNf4wA+rSQb2u5iKAPcO1jcJe06zgt69aLKpflRnTVju7o3qpNQhrBMhQt+C5dN6SxuaDQlzzLEJB5VghPuMuVIEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=q7mH8ww7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=q7mH8ww7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AFA607665A;
	Wed, 13 May 2026 08:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GRn0Z5Sr7KC0seCzmb9DiVdSPN+hyVolaVJwO3nevzg=;
	b=q7mH8ww7rJ7hhUJ4YEao0qBgL9hY9fCI9+HqPZ4ZgQ9g4rExpuknBYikXUQQYIytsh8e2q
	aKSklTGXDFdf1xxCnH/5Qrd3yD08twcCTyGNLUv6YgmSqmPfrfy8Rr/NBeZQJj97vwvmGy
	hq7rBmb1OtsTgWcvsQHfeztWHi3lCgw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GRn0Z5Sr7KC0seCzmb9DiVdSPN+hyVolaVJwO3nevzg=;
	b=q7mH8ww7rJ7hhUJ4YEao0qBgL9hY9fCI9+HqPZ4ZgQ9g4rExpuknBYikXUQQYIytsh8e2q
	aKSklTGXDFdf1xxCnH/5Qrd3yD08twcCTyGNLUv6YgmSqmPfrfy8Rr/NBeZQJj97vwvmGy
	hq7rBmb1OtsTgWcvsQHfeztWHi3lCgw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4ED9A593A9;
	Wed, 13 May 2026 08:54:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +By6ElQ8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:44 +0000
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
Subject: [PATCH v7 36/43] btrfs: deal with encrypted symlinks in send
Date: Wed, 13 May 2026 10:53:10 +0200
Message-ID: <20260513085340.3673127-37-neelx@suse.com>
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
X-Rspamd-Queue-Id: 60850530481
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
	TAGGED_FROM(0.00)[bounces-1595-lists,linux-fscrypt=lfdr.de];
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

Send needs to send the decrypted value of the symlinks, handle the case
where the inode is encrypted and decrypt the symlink name into a buffer
and copy this buffer into our fs_path struct.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

No changes in v7.
v6 changes:
 * read_symlink_encrypted() reworked from using pages to using folios.
v5: https://lore.kernel.org/linux-btrfs/4d97f35d6f85ff041b09bed33b63446a92b7a20c.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/send.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 89d72d8cb85f..d5256c22fe7a 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1701,9 +1701,7 @@ static int find_extent_clone(struct send_ctx *sctx,
 	return ret;
 }
 
-static int read_symlink(struct btrfs_root *root,
-			u64 ino,
-			struct fs_path *dest)
+static int read_symlink_unencrypted(struct btrfs_root *root, u64 ino, struct fs_path *dest)
 {
 	int ret;
 	BTRFS_PATH_AUTO_FREE(path);
@@ -1764,6 +1762,47 @@ static int read_symlink(struct btrfs_root *root,
 	return fs_path_add_from_extent_buffer(dest, path->nodes[0], off, len);
 }
 
+static int read_symlink_encrypted(struct btrfs_root *root, u64 ino, struct fs_path *dest)
+{
+	DEFINE_DELAYED_CALL(done);
+	const char *buf;
+	struct folio *folio;
+	struct btrfs_inode *inode;
+	int ret = 0;
+
+	inode = btrfs_iget(ino, root);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	folio = read_mapping_folio(inode->vfs_inode.i_mapping, 0, NULL);
+	if (IS_ERR(folio)) {
+		iput(&inode->vfs_inode);
+		return PTR_ERR(folio);
+	}
+
+	buf = fscrypt_get_symlink(&inode->vfs_inode, folio_address(folio),
+				  BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info),
+				  &done);
+	folio_put(folio);
+	iput(&inode->vfs_inode);
+
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	ret = fs_path_add(dest, buf, strlen(buf));
+	do_delayed_call(&done);
+	return ret;
+}
+
+
+static int read_symlink(struct btrfs_root *root, u64 ino,
+			struct fs_path *dest)
+{
+	if (btrfs_fs_incompat(root->fs_info, ENCRYPT))
+		return read_symlink_encrypted(root, ino, dest);
+	return read_symlink_unencrypted(root, ino, dest);
+}
+
 /*
  * Helper function to generate a file name that is unique in the root of
  * send_root and parent_root. This is used to generate names for orphan inodes.
-- 
2.53.0


