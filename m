Return-Path: <linux-fscrypt+bounces-1563-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yE1KJ049BGqsGAIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1563-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 10:58:54 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC3D530188
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 10:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6E547311C0AF
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E78D3E5A37;
	Wed, 13 May 2026 08:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oaLNJfNk";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oaLNJfNk"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD883E3C7C
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662474; cv=none; b=KInNtOYd4YOlnOB86JdXsNMGGUaJ7TkKxZ1hCaTwd/kbIHJbrltUf2kouOJH+x+UgbYP+sBQyv41Y7K41KDJgynNCeIXEdYnjLLDGZc64+xJQWdQuQ0q0DMc+VW8sKCLDsL7I00A375+dCinV2NUyEw/hzaETM1BOO7N16t+whM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662474; c=relaxed/simple;
	bh=Er4Vep6aXuPdCCYTI2CEAqXgslB0oTPxTRv+lwRGook=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkBOXMGM89fIIYacy7y1LEm0Xq4gTdDbodMbLIKMPGC8dGyqJEbGDtuZMzZBB09pcxGHVsYkmVWDAqS5bMx2+pZHAaoXLw1mtIgmOIv0GmZUU4vslFcPX4eyj+GNDIZShAZcI6HKc1Ex+b9mBPRlTfCGrkJm6I+7O0NeTgv+gJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oaLNJfNk; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oaLNJfNk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 927055C958;
	Wed, 13 May 2026 08:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SnaoJQYK3I0R0uSqFf6vvTIEOtyX5s7gAaW13wyQdQA=;
	b=oaLNJfNkaQ68ClTINmB+Wv6wOtokX9Gs6R+V7unfwniVSWAyEBj4zAChKy2nJT9QGLGU8v
	3JxxbAoTx7r+sL6YJ3hyaSno1+u1lJ2rdJzdN2IDz/CIxIPqV/hVxvYGLUADntlJOdSk58
	W28kVx8/Dm27ZpwyS2smk1PIAmzOJ18=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SnaoJQYK3I0R0uSqFf6vvTIEOtyX5s7gAaW13wyQdQA=;
	b=oaLNJfNkaQ68ClTINmB+Wv6wOtokX9Gs6R+V7unfwniVSWAyEBj4zAChKy2nJT9QGLGU8v
	3JxxbAoTx7r+sL6YJ3hyaSno1+u1lJ2rdJzdN2IDz/CIxIPqV/hVxvYGLUADntlJOdSk58
	W28kVx8/Dm27ZpwyS2smk1PIAmzOJ18=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6DF96593A9;
	Wed, 13 May 2026 08:54:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aEJeGjs8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:19 +0000
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
Subject: [PATCH v7 05/43] blk-crypto: add a process bio callback
Date: Wed, 13 May 2026 10:52:39 +0200
Message-ID: <20260513085340.3673127-6-neelx@suse.com>
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
X-Rspamd-Queue-Id: 4CC3D530188
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
	TAGGED_FROM(0.00)[bounces-1563-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,suse.com:email,suse.com:mid,suse.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

Btrfs does checksumming, and the checksums need to match the bytes on
disk.  In order to facilitate this add a process bio callback for the
blk-crypto layer.  This allows the file system to specify a callback and
then can process the encrypted bio as necessary.

For btrfs, writes will have the checksums calculated and saved into our
relevant data structures for storage once the write completes.  For
reads we will validate the checksums match what is on disk and error out
if there is a mismatch.

This is incompatible with native encryption obviously, so make sure we
don't use native encryption if this callback is set.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v7 changes:
 * Adapt to fscrypt changes
   - b37fbce460ad ("blk-crypto: optimize bio splitting in blk_crypto_fallback_encrypt_bio")
No changes in v6.
v5: https://lore.kernel.org/linux-btrfs/66c781f3b2afdf2c558efdf33a7bba8bcfe47ce7.1706116485.git.josef@toxicpanda.com/
---
 block/blk-crypto-fallback.c | 41 +++++++++++++++++++++++++++++++++++++
 block/blk-crypto-internal.h |  8 ++++++++
 block/blk-crypto-profile.c  |  2 ++
 block/blk-crypto.c          |  6 +++++-
 fs/crypto/inline_crypt.c    |  3 ++-
 include/linux/blk-crypto.h  | 15 ++++++++++++--
 6 files changed, 71 insertions(+), 4 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 61f595410832..5d35f0687bf8 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -330,6 +330,17 @@ static void __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
 		}
 	}
 
+	/* Process the encrypted bio before we submit it. */
+	if (bc->bc_key->crypto_cfg.process_bio) {
+		blk_status_t status;
+
+		status = bc->bc_key->crypto_cfg.process_bio(src_bio, enc_bio);
+		if (status != BLK_STS_OK) {
+			enc_bio->bi_status = status;
+			goto out_free_enc_bio;
+		}
+	}
+
 	submit_bio(enc_bio);
 	return;
 
@@ -358,6 +369,16 @@ static void blk_crypto_fallback_encrypt_bio(struct bio *src_bio)
 	struct blk_crypto_keyslot *slot;
 	blk_status_t status;
 
+	/*
+	 * We cannot split bio's that have process_bio, as they require the original bio.
+	 * The upper layer must make sure to limit the submitted bio's appropriately.
+	 */
+	if (bio_segments(src_bio) > BIO_MAX_VECS && bc->bc_key->crypto_cfg.process_bio) {
+		src_bio->bi_status = BLK_STS_RESOURCE;
+		bio_endio(src_bio);
+		return;
+	}
+
 	status = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
 					bc->bc_key, &slot);
 	if (status != BLK_STS_OK) {
@@ -427,6 +448,13 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 	struct blk_crypto_keyslot *slot;
 	blk_status_t status;
 
+	/* Process the bio first before trying to decrypt. */
+	if (bc->bc_key->crypto_cfg.process_bio) {
+		status = bc->bc_key->crypto_cfg.process_bio(bio, bio);
+		if (status != BLK_STS_OK)
+			goto out;
+	}
+
 	status = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
 					bc->bc_key, &slot);
 	if (status == BLK_STS_OK) {
@@ -435,12 +463,25 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 				blk_crypto_fallback_tfm(slot));
 		blk_crypto_put_keyslot(slot);
 	}
+out:
 	mempool_free(f_ctx, bio_fallback_crypt_ctx_pool);
 
 	bio->bi_status = status;
 	bio_endio(bio);
 }
 
+/**
+ * blk_crypto_profile_is_fallback - check if this profile is the fallback
+ *				    profile
+ * @profile: the profile we're checking
+ *
+ * This is just a quick check to make sure @profile is the fallback profile.
+ */
+bool blk_crypto_profile_is_fallback(struct blk_crypto_profile *profile)
+{
+	return profile == blk_crypto_fallback_profile;
+}
+
 /**
  * blk_crypto_fallback_decrypt_endio - queue bio for fallback decryption
  *
diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index 742694213529..c857ebeb9637 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -226,6 +226,8 @@ int blk_crypto_fallback_start_using_mode(enum blk_crypto_mode_num mode_num);
 
 int blk_crypto_fallback_evict_key(const struct blk_crypto_key *key);
 
+bool blk_crypto_profile_is_fallback(struct blk_crypto_profile *profile);
+
 #else /* CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK */
 
 static inline int
@@ -241,6 +243,12 @@ blk_crypto_fallback_evict_key(const struct blk_crypto_key *key)
 	return 0;
 }
 
+static inline bool
+blk_crypto_profile_is_fallback(struct blk_crypto_profile *profile)
+{
+	return false;
+}
+
 #endif /* CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK */
 
 #endif /* __LINUX_BLK_CRYPTO_INTERNAL_H */
diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 4ac74443687a..ced35ee186f0 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -352,6 +352,8 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
 		return false;
 	if (!(profile->key_types_supported & cfg->key_type))
 		return false;
+	if (cfg->process_bio && !blk_crypto_profile_is_fallback(profile))
+		return false;
 	return true;
 }
 
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 856d3c5b1fa0..d93c593ae1eb 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -300,6 +300,8 @@ int __blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
  * @dun_bytes: number of bytes that will be used to specify the DUN when this
  *	       key is used
  * @data_unit_size: the data unit size to use for en/decryption
+ * @process_bio: the call back if the upper layer needs to process the encrypted
+ *		 bio
  *
  * Return: 0 on success, -errno on failure.  The caller is responsible for
  *	   zeroizing both blk_key and key_bytes when done with them.
@@ -309,7 +311,8 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 			enum blk_crypto_key_type key_type,
 			enum blk_crypto_mode_num crypto_mode,
 			unsigned int dun_bytes,
-			unsigned int data_unit_size)
+			unsigned int data_unit_size,
+			blk_crypto_process_bio_t process_bio)
 {
 	const struct blk_crypto_mode *mode;
 
@@ -343,6 +346,7 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 	blk_key->crypto_cfg.dun_bytes = dun_bytes;
 	blk_key->crypto_cfg.data_unit_size = data_unit_size;
 	blk_key->crypto_cfg.key_type = key_type;
+	blk_key->crypto_cfg.process_bio = process_bio;
 	blk_key->data_unit_size_bits = ilog2(data_unit_size);
 	blk_key->size = key_size;
 	memcpy(blk_key->bytes, key_bytes, key_size);
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 31791fb98a9e..c51c6eb2259f 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -178,7 +178,8 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 
 	err = blk_crypto_init_key(blk_key, key_bytes, key_size, key_type,
 				  crypto_mode, fscrypt_get_dun_bytes(ci),
-				  1U << ci->ci_data_unit_bits);
+				  1U << ci->ci_data_unit_bits,
+				  NULL);
 	if (err) {
 		fscrypt_err(inode, "error %d initializing blk-crypto key", err);
 		goto fail;
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index f7c3cb4a342f..34512f6f5086 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -7,7 +7,7 @@
 #define __LINUX_BLK_CRYPTO_H
 
 #include <linux/minmax.h>
-#include <linux/types.h>
+#include <linux/blk_types.h>
 #include <uapi/linux/blk-crypto.h>
 
 enum blk_crypto_mode_num {
@@ -19,6 +19,14 @@ enum blk_crypto_mode_num {
 	BLK_ENCRYPTION_MODE_MAX,
 };
 
+/*
+ * orig_bio must be the bio that was submitted from the upper layer as the upper
+ * layer could have used a specific bioset and expect the orig_bio to be from
+ * its bioset.
+ */
+typedef blk_status_t (*blk_crypto_process_bio_t)(struct bio *orig_bio,
+						 struct bio *enc_bio);
+
 /*
  * Supported types of keys.  Must be bitflags due to their use in
  * blk_crypto_profile::key_types_supported.
@@ -77,12 +85,14 @@ enum blk_crypto_key_type {
  *	filesystem block size or the disk sector size.
  * @dun_bytes: the maximum number of bytes of DUN used when using this key
  * @key_type: the type of this key -- either raw or hardware-wrapped
+ * @proces_bio: optional callback to process encrypted bios.
  */
 struct blk_crypto_config {
 	enum blk_crypto_mode_num crypto_mode;
 	unsigned int data_unit_size;
 	unsigned int dun_bytes;
 	enum blk_crypto_key_type key_type;
+	blk_crypto_process_bio_t process_bio;
 };
 
 /**
@@ -150,7 +160,8 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 			enum blk_crypto_key_type key_type,
 			enum blk_crypto_mode_num crypto_mode,
 			unsigned int dun_bytes,
-			unsigned int data_unit_size);
+			unsigned int data_unit_size,
+			blk_crypto_process_bio_t process_bio);
 
 int blk_crypto_start_using_key(struct block_device *bdev,
 			       const struct blk_crypto_key *key);
-- 
2.53.0


