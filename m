Return-Path: <linux-fscrypt+bounces-1083-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sJl6HZMyhmneKQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1083-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:27:31 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CAE4B101D16
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:27:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 01D9B3081819
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19BF936073C;
	Fri,  6 Feb 2026 18:24:06 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B3E3D902A
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402246; cv=none; b=bA6CM96wHR9DgljNuPloYwW7URhbQcommZ1LKK9FqvcQSRBhUbKHFYo4lJPwPamuStcoYuzrf22+owJXF7Sm9/u88Y0Xha6C1KSb99jiIUwHBC/JDRws8GK3WoDvuK/j8wps9l4w9JYhKemiePdX8jFi1Hs0YJ+x6kV049Rdlgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402246; c=relaxed/simple;
	bh=V3qkz5KR+/fbjcLmGLO6jWlKLTc0sUhs1UdnMQPC+Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyGnqFTuSJ8x41IGGaEA+aU/tg6R62VFe4yVndlFIpgYHSlOs6Dk6Fg57zg6IndZppnmzFya5y7kkZ8yA+g+hMIP4CsUkhb7ZsoaOJXgqaRes/ollNR6miD6hamxJz7mxKkliZkD3TmTukk3+KoQtMmMkkcmzZI1B4CnJq8cwmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8E7693E743;
	Fri,  6 Feb 2026 18:23:55 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 638BB3EA63;
	Fri,  6 Feb 2026 18:23:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wM/aF7sxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:23:55 +0000
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
Subject: [PATCH v6 03/43] fscrypt: add a __fscrypt_file_open helper
Date: Fri,  6 Feb 2026 19:22:35 +0100
Message-ID: <20260206182336.1397715-4-neelx@suse.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1083-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:mid,suse.com:email,toxicpanda.com:email]
X-Rspamd-Queue-Id: CAE4B101D16
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

We have fscrypt_file_open() which is meant to be called on files being
opened so that their key is loaded when we start reading data from them.

However for btrfs send we are opening the inode directly without a filp,
so we need a different helper to make sure we can load the fscrypt
context for the inode before reading its contents.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/4a372419c3fe6ad425e1b124c342a054e9d6db23.1706116485.git.josef@toxicpanda.com/
 * Adapted to fscrypt changes.
---
 fs/crypto/hooks.c       | 38 ++++++++++++++++++++++++++++++++------
 include/linux/fscrypt.h |  8 ++++++++
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index b97de0d1430f..17eb2e844f30 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -9,6 +9,37 @@
 
 #include "fscrypt_private.h"
 
+/**
+ * __fscrypt_file_open() - prepare for filesystem-internal access to a
+ *			   possibly-encrypted regular file
+ * @dir: the inode for the directory via which the file is being accessed
+ * @inode: the inode being "opened"
+ *
+ * This is like fscrypt_file_open(), but instead of taking the 'struct file'
+ * being opened it takes the parent directory explicitly.  This is intended for
+ * use cases such as "send/receive" which involve the filesystem accessing file
+ * contents without setting up a 'struct file'.
+ *
+ * Return: 0 on success, -ENOKEY if the key is missing, or another -errno code
+ */
+int __fscrypt_file_open(struct inode *dir, struct inode *inode)
+{
+	int err;
+
+	err = fscrypt_require_key(inode);
+	if (err)
+		return err;
+
+	if (!fscrypt_has_permitted_context(dir, inode)) {
+		fscrypt_warn(inode,
+			     "Inconsistent encryption context (parent directory: %lu)",
+			     dir->i_ino);
+		return -EPERM;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__fscrypt_file_open);
+
 /**
  * fscrypt_file_open() - prepare to open a possibly-encrypted regular file
  * @inode: the inode being opened
@@ -60,12 +91,7 @@ int fscrypt_file_open(struct inode *inode, struct file *filp)
 	rcu_read_unlock();
 
 	dentry_parent = dget_parent(dentry);
-	if (!fscrypt_has_permitted_context(d_inode(dentry_parent), inode)) {
-		fscrypt_warn(inode,
-			     "Inconsistent encryption context (parent directory: %lu)",
-			     d_inode(dentry_parent)->i_ino);
-		err = -EPERM;
-	}
+	err = __fscrypt_file_open(d_inode(dentry_parent), inode);
 	dput(dentry_parent);
 	return err;
 }
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 5a17e4975b06..dba5ca122775 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -471,6 +471,7 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
 
 /* hooks.c */
 int fscrypt_file_open(struct inode *inode, struct file *filp);
+int __fscrypt_file_open(struct inode *dir, struct inode *inode);
 int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
 			   struct dentry *dentry);
 int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -818,6 +819,13 @@ static inline int fscrypt_file_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static inline int __fscrypt_file_open(struct inode *dir, struct inode *inode)
+{
+	if (IS_ENCRYPTED(inode))
+		return -EOPNOTSUPP;
+	return 0;
+}
+
 static inline int __fscrypt_prepare_link(struct inode *inode, struct inode *dir,
 					 struct dentry *dentry)
 {
-- 
2.51.0


