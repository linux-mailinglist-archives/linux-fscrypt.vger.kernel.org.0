Return-Path: <linux-fscrypt+bounces-1597-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KBMgCYhBBGokGQIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1597-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:16:56 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D4BF530791
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:16:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6018B3004C60
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 09:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 397FD426691;
	Wed, 13 May 2026 08:56:45 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959D9426ED6
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662605; cv=none; b=TRAJuOSUuQGIXGpcsUq/xPSI3TSI9SH5bRT1YIGGFRUCJ9HMFsInTcW0bbQoAn6maR3fUPDzUImcjTCW1zHtdMpjC58S52wT92sim7aeg4y2tBMV7/aB3Ng5+7tDQKGkZWp76A+nPIeaC2jKSBUroT+WWIJKM3BOqxeViyBacLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662605; c=relaxed/simple;
	bh=8ggjot87M2+CtdUpdh1bHiO1BC92581RBH5qg0ReqI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqT5YJBPRBwxXGZBNQQOYc771FhXI8xDPEhgPdJ7Eq+xjCCz6ys8OEKDlAUeuFgbe/o9MNYSUdRV8IO1LarhD79UV6DNY1PYvFThzgVFFxjXfjoRXo9Bfn8xS6Ae46n+xErdrtX/jMMkMf2xD+9yNrLFYAYqE+emgLjHDrW8p/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A36D47665F;
	Wed, 13 May 2026 08:54:45 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 835CB593A9;
	Wed, 13 May 2026 08:54:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UDCXH1U8BGpERwAAD6G6ig
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
Subject: [PATCH v7 38/43] btrfs: load the inode context before sending writes
Date: Wed, 13 May 2026 10:53:12 +0200
Message-ID: <20260513085340.3673127-39-neelx@suse.com>
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
X-Rspamd-Queue-Id: 6D4BF530791
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
	TAGGED_FROM(0.00)[bounces-1597-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,toxicpanda.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

For send we will read the pages and copy them into our buffer.  Use the
fscrypt_inode_open helper to make sure the key is loaded properly before
trying to read from the inode so the contents are properly decrypted.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

No changes in v7.
v6 changes:
 * btrfs_iget() returns binode now.
v5: https://lore.kernel.org/linux-btrfs/a307def01bf28c3ed99398868a142180c6088527.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/send.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 3d9764aa4a25..1e80a3db1df2 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5331,6 +5331,38 @@ static int put_file_data(struct send_ctx *sctx, u64 offset, u32 len)
 	return ret;
 }
 
+static int load_fscrypt_context(struct send_ctx *sctx)
+{
+	struct btrfs_root *root = sctx->send_root;
+	struct name_cache_entry *nce;
+	struct btrfs_inode *dir;
+	int ret;
+
+	if (!btrfs_fs_incompat(root->fs_info, ENCRYPT))
+		return 0;
+
+	/*
+	 * If we're encrypted we need to load the parent inode in order to make
+	 * sure the encryption context is loaded.  We have to do this even if
+	 * we're not encrypted, as we need to make sure that we don't violate
+	 * the rule about encrypted children with non-encrypted parents, which
+	 * is enforced by __fscrypt_file_open.
+	 */
+	nce = name_cache_search(sctx, sctx->cur_ino, sctx->cur_inode_gen);
+	if (!nce) {
+		ASSERT(nce);
+		return -EINVAL;
+	}
+
+	dir = btrfs_iget(nce->parent_ino, root);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+
+	ret = __fscrypt_file_open(&dir->vfs_inode, sctx->cur_inode);
+	iput(&dir->vfs_inode);
+	return ret;
+}
+
 /*
  * Read some bytes from the current inode/file and send a write command to
  * user space.
@@ -5348,6 +5380,10 @@ static int send_write(struct send_ctx *sctx, u64 offset, u32 len)
 	if (ret < 0)
 		return ret;
 
+	ret = load_fscrypt_context(sctx);
+	if (ret < 0)
+		return ret;
+
 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
 	TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
 	ret = put_file_data(sctx, offset, len);
-- 
2.53.0


