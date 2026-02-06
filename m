Return-Path: <linux-fscrypt+bounces-1121-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YBRGHUM2hmlrLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1121-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:43:15 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C82C51022BA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:43:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 03EA9303C679
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B17A43E48F;
	Fri,  6 Feb 2026 18:25:39 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2264143DA53
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402339; cv=none; b=K7FpPgVzIcmMUaGxEXFxbYo/wYJvAujoxWKcGIj13zK3SQi5h2/vZNgrq5jZwi7fTdqH2R4gj7HcaLThl+TAX7Z5GSQGyMVuZhQ3DhNrdDuXUF+F1aj0q5aGooGw/u6y0/SpDN5J7d7KXyhk8esZdAIoARAXO1ZDBi4aDXqy+Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402339; c=relaxed/simple;
	bh=fZxW8wexZZ7fyQehWlyzdfCe9GH5o7H4GiTaE8gAS1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJcYo64QRwBce1++CC8AGYhbbPWB4bZpmkByAsU+ZeMscQYGzKUdrxtb7KXp8wuvavj5zWY9KyWegJwWdc4Lt9jceD/7bIVUCHTI1/lsUnje4a78meWNFYRWq72NTtg7ZF/9NPXMlqErQXoSOiMDmbGmzwyL4CbW6pChnXa7pEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 69D0A3E745;
	Fri,  6 Feb 2026 18:24:19 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F3A63EA63;
	Fri,  6 Feb 2026 18:24:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SJfzDtMxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:19 +0000
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
Subject: [PATCH v6 40/43] btrfs: support encryption with log replay
Date: Fri,  6 Feb 2026 19:23:12 +0100
Message-ID: <20260206182336.1397715-41-neelx@suse.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1121-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.994];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,suse.com:mid,suse.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C82C51022BA
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

Log replay needs a few tweaks in order to make sure everything works
with encryption.

1. Copy in the fscrypt context if we find one in the log.
2. Set NEEDS_FULL_SYNC when we update the inode context so all of the
   items are copied into the log at fsync time.

This makes replay of encrypted files work properly.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/d1ada7ac632c2ab554a840c7ba29b53a93b9855f.1706116485.git.josef@toxicpanda.com/
 * Adapted to the redesigned encryption context storing.
   - No need to specially handle the extent item now.
     It is not any different to before and the
     new context items are simply copied.
---
 fs/btrfs/fscrypt.c  | 1 +
 fs/btrfs/tree-log.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index bcb86cbaa171..cbdeaa75a868 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -145,6 +145,7 @@ static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
 			goto out_err;
 	}
 
+	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
 	leaf = path->nodes[0];
 	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 0d01e31a4592..fa75531f9633 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2922,7 +2922,9 @@ static int replay_one_buffer(struct extent_buffer *eb,
 			continue;
 
 		/* these keys are simply copied */
-		if (wc->log_key.type == BTRFS_XATTR_ITEM_KEY) {
+		if (wc->log_key.type == BTRFS_XATTR_ITEM_KEY ||
+		    wc->log_key.type == BTRFS_FSCRYPT_INODE_CTX_KEY ||
+		    wc->log_key.type == BTRFS_FSCRYPT_CTX_KEY) {
 			ret = overwrite_item(wc);
 			if (ret)
 				break;
-- 
2.51.0


