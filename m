Return-Path: <linux-fscrypt+bounces-1582-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAulCAE/BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1582-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:06:09 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CA53F530377
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:06:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9AA2F31192BA
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CFF03E9C0F;
	Wed, 13 May 2026 08:55:49 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A55401A13
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662549; cv=none; b=p8lfkwM1TtcOhJVY2rI139VoauSUc1wNHZaeFv/ND1g4WUjh7D4xoQXt12aUVZkSavQm67/1rgIoOOufDoexoRZyc9IWuBGup9VnHAzLnc1cf3z5CtpNUHHN/zamkaYqVXfgn22y8nvPX56sw4r/3z1m4+bBM8lBSJJin+bBbCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662549; c=relaxed/simple;
	bh=bstH3yoiWLkH01mk72Z2o8aRD0giEyllOvQ5UINcbL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaJQR1kzWvuTx7yhH/ssHJtMKuUTjfZ5ZLdI3AKzQRBMRJHjjBPyyOWeSLqlfzLKGCOWqF2DlM5vhKFNsrhtt9LwqxAUs5xcGt2zcRTB1DY/N1rZzhYBOygXZ4dz0VSZzj5Vw+PwjdjuL7YCw2jo4LqOy0k2ujg2IG4ABMrEH3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 388F276691;
	Wed, 13 May 2026 08:54:35 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 17975593A9;
	Wed, 13 May 2026 08:54:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mAw9BUs8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:35 +0000
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
Subject: [PATCH v7 25/43] btrfs: pass through fscrypt_extent_info to the file extent helpers
Date: Wed, 13 May 2026 10:52:59 +0200
Message-ID: <20260513085340.3673127-26-neelx@suse.com>
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
X-Rspamd-Queue-Id: CA53F530377
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
	TAGGED_FROM(0.00)[bounces-1582-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.com:email,suse.com:mid,toxicpanda.com:email]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

Now that we have the fscrypt_extnet_info in all of the supporting
structures, pass this through and set the file extent encryption bit
accordingly from the supporting structures.  In subsequent patches code
will be added to populate these appropriately.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/a8b9dd312a4504f209e861cca5289a528b30ff95.1706116485.git.josef@toxicpanda.com/
 * No changes since.
---
 fs/btrfs/inode.c    | 16 ++++++++++------
 fs/btrfs/tree-log.c |  2 +-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index eab7950372ae..cdd2d7bc50cc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3056,7 +3056,9 @@ int btrfs_writepage_cow_fixup(struct folio *folio)
 }
 
 static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
-				       struct btrfs_inode *inode, u64 file_pos,
+				       struct btrfs_inode *inode,
+				       struct fscrypt_extent_info *fscrypt_info,
+				       u64 file_pos,
 				       struct btrfs_file_extent_item *stack_fi,
 				       const bool update_inode_bytes,
 				       u64 qgroup_reserved)
@@ -3180,7 +3182,7 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_file_extent_num_bytes(&stack_fi, num_bytes);
 	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, ram_bytes);
 	btrfs_set_stack_file_extent_compression(&stack_fi, oe->compress_type);
-	btrfs_set_stack_file_extent_encryption(&stack_fi, BTRFS_ENCRYPTION_NONE);
+	btrfs_set_stack_file_extent_encryption(&stack_fi, oe->encryption_type);
 	/* Other encoding is reserved and always 0 */
 
 	/*
@@ -3193,7 +3195,7 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
 			     test_bit(BTRFS_ORDERED_ENCODED, &oe->flags) ||
 			     test_bit(BTRFS_ORDERED_TRUNCATED, &oe->flags);
 
-	return insert_reserved_file_extent(trans, oe->inode,
+	return insert_reserved_file_extent(trans, oe->inode, oe->fscrypt_info,
 					   oe->file_offset, &stack_fi,
 					   update_inode_bytes, oe->qgroup_rsv);
 }
@@ -9288,6 +9290,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 				       struct btrfs_trans_handle *trans_in,
 				       struct btrfs_inode *inode,
 				       struct btrfs_key *ins,
+				       struct fscrypt_extent_info *fscrypt_info,
 				       u64 file_offset)
 {
 	struct btrfs_file_extent_item stack_fi;
@@ -9307,7 +9310,8 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	btrfs_set_stack_file_extent_num_bytes(&stack_fi, len);
 	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, len);
 	btrfs_set_stack_file_extent_compression(&stack_fi, BTRFS_COMPRESS_NONE);
-	btrfs_set_stack_file_extent_encryption(&stack_fi, BTRFS_ENCRYPTION_NONE);
+	btrfs_set_stack_file_extent_encryption(&stack_fi, fscrypt_info? BTRFS_ENCRYPTION_FSCRYPT:
+									BTRFS_ENCRYPTION_NONE);
 	/* Other encoding is reserved and always 0 */
 
 	ret = btrfs_qgroup_release_data(inode, file_offset, len, &qgroup_released);
@@ -9315,7 +9319,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 		return ERR_PTR(ret);
 
 	if (trans) {
-		ret = insert_reserved_file_extent(trans, inode,
+		ret = insert_reserved_file_extent(trans, inode, fscrypt_info,
 						  file_offset, &stack_fi,
 						  true, qgroup_released);
 		if (ret)
@@ -9408,7 +9412,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 
 		last_alloc = ins.offset;
 		trans = insert_prealloc_file_extent(trans, BTRFS_I(inode),
-						    &ins, cur_offset);
+						    &ins, NULL, cur_offset);
 		/*
 		 * Now that we inserted the prealloc extent we can finally
 		 * decrement the number of reservations in the block group.
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 3229a60bffb7..60aa763d2fa4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5150,7 +5150,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	u64 block_start = btrfs_extent_map_block_start(em);
 	u64 block_len;
 	int ret;
-	u8 encryption = BTRFS_ENCRYPTION_NONE;
+	u8 encryption = btrfs_extent_map_encryption(em);
 
 	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
 	if (em->flags & EXTENT_FLAG_PREALLOC)
-- 
2.53.0


