Return-Path: <linux-fscrypt+bounces-1085-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oEiNG+EyhmleLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1085-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:28:49 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C663B101D74
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:28:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6DB78309E432
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E9F428466;
	Fri,  6 Feb 2026 18:24:13 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA2E42846F
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402253; cv=none; b=afNqUgAhLOuuNiEzemyvhKiTyOeDTZD6NBPa17yQBV1v3jyOLlQ7T6A3gYKzUga/OH8BV/U2Pi+NQGH5ZD9AP4tO9X79Ba24w2LQYW//oJFXoGGl6dqstSirgQqKcgXxVeRUPiGcJIzUS/DumiJs9SWT2M1LGHFzYfBSQnTsLEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402253; c=relaxed/simple;
	bh=WWPyU3Cw5JFKguMvOW44poEbw0QYpQG6cCJf4kJzrok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4MaVf02sUVzpviI0kXuVhJXetznx8Bm6Znlseu+WCHCmNm2cordLOpnXzyQ4d1Px4zLHNC1jkojJUQsQPleFcLQ9LHmvpVQAV9nBspMgFVjc8vFktGSiIfw70rmy6ci7NrcFwAIvOQjAD9pHR+lBnszkAygakuAZ339eGYr480=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 599833E745;
	Fri,  6 Feb 2026 18:23:57 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B1503EA63;
	Fri,  6 Feb 2026 18:23:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wK0KCr0xhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:23:57 +0000
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
Subject: [PATCH v6 06/43] fscrypt: add a process_bio hook to fscrypt_operations
Date: Fri,  6 Feb 2026 19:22:38 +0100
Message-ID: <20260206182336.1397715-7-neelx@suse.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1085-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: C663B101D74
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

This will allow file systems to set a process_bio hook for inline
encryption.  This will be utilized by btrfs in order to make sure the
checksumming work is done on the encrypted bio's.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/2c638e5fa1b7868dbf79d932b15364c3c30ca9de.1706116485.git.josef@toxicpanda.com/
 * No changes since.
---
 fs/crypto/inline_crypt.c |  2 +-
 include/linux/fscrypt.h  | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index d737fb6ff011..fc1aa5b00af1 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -179,7 +179,7 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 	err = blk_crypto_init_key(blk_key, key_bytes, key_size, key_type,
 				  crypto_mode, fscrypt_get_dun_bytes(ci),
 				  1U << ci->ci_data_unit_bits,
-				  NULL);
+				  sb->s_cop->process_bio);
 	if (err) {
 		fscrypt_err(inode, "error %d initializing blk-crypto key", err);
 		goto fail;
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index dba5ca122775..e3bb9e3756e1 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/blk-crypto.h>
 #include <uapi/linux/fscrypt.h>
 
 /*
@@ -205,6 +206,19 @@ struct fscrypt_operations {
 	 */
 	struct block_device **(*get_devices)(struct super_block *sb,
 					     unsigned int *num_devs);
+
+	/*
+	 * A callback if the file system requires the ability to process the
+	 * encrypted bio, used only with inline encryption.
+	 *
+	 * @orig_bio: the original bio submitted.
+	 * @enc_bio: the encrypted bio.
+	 *
+	 * For writes the enc_bio will be different from the orig_bio, for reads
+	 * they will be the same.  For reads we get the bio before it is
+	 * decrypted, for writes we get the bio before it is submitted.
+	 */
+	blk_crypto_process_bio_t process_bio;
 };
 
 int fscrypt_d_revalidate(struct inode *dir, const struct qstr *name,
-- 
2.51.0


