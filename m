Return-Path: <linux-fscrypt+bounces-1562-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MAsLD8I9BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1562-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:00:50 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 88CAA5301F2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:00:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 00E3D3134D5A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A0E3E5A21;
	Wed, 13 May 2026 08:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fFSaQ8PH";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fFSaQ8PH"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9DB3E5A3A
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662474; cv=none; b=D5sIJis+nU+RnW88vHKLImbpOGIZeEl37uBETgoRPBl5VAZF+IKV0mcRQ72vTGemwime/PiYEmT8xljSYuw4x5WZZo9Bgb7dd+4yK36LKtG0+QVlVxy9P9bmpWbjFQ7CZBd/h7IDnA/ykfjj48KLGVBJzlvW5/ciW11G9+CXdV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662474; c=relaxed/simple;
	bh=ovGWnurep0e8r/mdPDW8WKaLIlnDVSy6qoYfSxhpm5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciVEV3DlceHSuF0RC5bByMNZF9xJp9HUs/icNBPW6x6fdlDzEQNWJHn6d71dHz0H8d5WZxd6W3JtfghT9PaMar9WwVdUUWmYPIjX+lwClkWP/R+dqcRYWDz/Jg5u0yjKvueymQqcXs1+bAYzeIHHeoMP5lWZAwCMkUAgBzr5q3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fFSaQ8PH; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fFSaQ8PH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7A01876647;
	Wed, 13 May 2026 08:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5olisZHQxa9bclmF9Smpgx9wTNFsfeUM/MMLtIzfwKA=;
	b=fFSaQ8PHc+Su/fwQyhtcnsk1yyN/MQ7WqrW2artURpQPEnc+idyLjCpxXS40Fzsk/MQaLY
	rHYuxmuK9KVgC90JG/F9DniZ+gp6QxN2rFUPxeKEWt1Csro+pwYVAWdsDH0zsbOWB9JWl5
	HhASLtCH26xNCRTpKpPswVxlSOoNO9o=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5olisZHQxa9bclmF9Smpgx9wTNFsfeUM/MMLtIzfwKA=;
	b=fFSaQ8PHc+Su/fwQyhtcnsk1yyN/MQ7WqrW2artURpQPEnc+idyLjCpxXS40Fzsk/MQaLY
	rHYuxmuK9KVgC90JG/F9DniZ+gp6QxN2rFUPxeKEWt1Csro+pwYVAWdsDH0zsbOWB9JWl5
	HhASLtCH26xNCRTpKpPswVxlSOoNO9o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C9F9593AA;
	Wed, 13 May 2026 08:54:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CM2DBjo8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:18 +0000
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
Subject: [PATCH v7 04/43] fscrypt: conditionally don't wipe mk secret until the last active user is done
Date: Wed, 13 May 2026 10:52:38 +0200
Message-ID: <20260513085340.3673127-5-neelx@suse.com>
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
X-Rspamd-Queue-Id: 88CAA5301F2
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
	TAGGED_FROM(0.00)[bounces-1562-lists,linux-fscrypt=lfdr.de];
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

Previously we were wiping the master key secret when we do
FS_IOC_REMOVE_ENCRYPTION_KEY, and then using the fact that it was
cleared as the mechanism from keeping new users from being setup.  This
works with inode based encryption, as the per-inode key is derived at
setup time, so the secret disappearing doesn't affect any currently open
files from being able to continue working.

However for extent based encryption we do our key derivation at page
writeout and readpage time, which means we need the master key secret to
be available while we still have our file open.

Since the master key lifetime is controlled by a flag, move the clearing
of the secret to the mk_active_users cleanup stage if we have extent
based encryption enabled on this super block.  This counter represents
the actively open files that still exist on the file system, and thus
should still be able to operate normally.  Once the last user is closed
we can clear the secret.  Until then no new users are allowed, and this
allows currently open files to continue to operate until they're closed.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v7 changes:
 * Updated the comment about key status in fscrypt_master_key_secret structure
   as suggested by Eric.
No changes in v6.
v5: https://lore.kernel.org/linux-btrfs/5f28e46ce99d918a16f5bf4d8190870d0fffefc4.1706116485.git.josef@toxicpanda.com/
---
 fs/crypto/fscrypt_private.h |  9 ++++++---
 fs/crypto/keyring.c         | 18 +++++++++++++++++-
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index e5ab9893dfed..2f5f4e7f8f65 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -592,9 +592,12 @@ struct fscrypt_master_key_secret {
  *
  * FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED
  *	Removal of this key has been initiated, but some inodes that were
- *	unlocked with it are still in-use.  Like ABSENT, ->mk_secret is wiped,
- *	and the key can no longer be used to unlock inodes.  Unlike ABSENT, the
- *	key is still in the keyring; ->mk_decrypted_inodes is nonempty; and
+ *	unlocked with it are still in-use.
+ *	For filesystems using per-extent encryption ->mk_secret is still
+ *	being kept as the per-extent keys are derived at writeout time.
+ *	Otherwise, like ABSENT, ->mk_secret is wiped, and the key can
+ *	no longer be used to unlock inodes.  Unlike ABSENT, the key is
+ *	still in the keyring; ->mk_decrypted_inodes is nonempty; and
  *	->mk_active_refs > 0, being equal to the size of ->mk_decrypted_inodes.
  *
  *	This state transitions to ABSENT if ->mk_decrypted_inodes becomes empty,
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index be8e6e8011f2..796e02a0db25 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -110,6 +110,14 @@ void fscrypt_put_master_key_activeref(struct super_block *sb,
 	WARN_ON_ONCE(mk->mk_present);
 	WARN_ON_ONCE(!list_empty(&mk->mk_decrypted_inodes));
 
+	/* We can't wipe the master key secret until the last activeref is
+	 * dropped on the master key with per-extent encryption since the key
+	 * derivation continues to happen as long as there are active refs.
+	 * Wipe it here now that we're done using it.
+	 */
+	if (sb->s_cop->has_per_extent_encryption)
+		wipe_master_key_secret(&mk->mk_secret);
+
 	for (i = 0; i <= FSCRYPT_MODE_MAX; i++) {
 		fscrypt_destroy_prepared_key(
 				sb, &mk->mk_direct_keys[i]);
@@ -134,7 +142,15 @@ static void fscrypt_initiate_key_removal(struct super_block *sb,
 					 struct fscrypt_master_key *mk)
 {
 	WRITE_ONCE(mk->mk_present, false);
-	wipe_master_key_secret(&mk->mk_secret);
+
+	/*
+	 * Per-extent encryption requires the master key to stick around until
+	 * writeout has completed as we derive the per-extent keys at writeout
+	 * time.  Once the activeref drops to 0 we'll wipe the master secret
+	 * key.
+	 */
+	if (!sb->s_cop->has_per_extent_encryption)
+		wipe_master_key_secret(&mk->mk_secret);
 	fscrypt_put_master_key_activeref(sb, mk);
 }
 
-- 
2.53.0


