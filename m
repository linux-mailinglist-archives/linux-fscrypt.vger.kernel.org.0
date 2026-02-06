Return-Path: <linux-fscrypt+bounces-1084-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0A4eIZgyhmneKQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1084-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:27:36 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2030F101D2B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:27:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6BF653082F75
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90DA4426D11;
	Fri,  6 Feb 2026 18:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FVJ4K0C7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FVJ4K0C7"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C977240FDB8
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402246; cv=none; b=VFTJ3o91lFI/q/BzAMdHXUidu18ZrA4BB+/T1wQ6+bK/kYhl5lLPG4QKjSdyG4yi7zNL0Nkvnc/I2kyZvVpg1HHw/JwXejlDBa1otAVe5ucK7LPAo+SBbOdL/1aUMPsQz18t0cGE2uFDY304Zv/WntphbCxm6lWQOvfm7oocCWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402246; c=relaxed/simple;
	bh=u61vO7jsE5NYmS5zINbNxCfbfvNmM2phS/DGmwZ1RnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAVierJYPdvsbNFY6lP7Vl2mrwZY/pPJNvRqeE/VZmZv7j1uoChY7zhBdajdDMcRBkEFWA8b8VBwsy+6oo8ONXqN+g1p7ppFpiWTwj1yu4LCBEmN0jEj5ewwjjR9qcsrYNtwtNIXUGBvgDfcQOiyGUGjrOHAqwVvVxuEesslqrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FVJ4K0C7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FVJ4K0C7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF8A25BD1F;
	Fri,  6 Feb 2026 18:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bdp12iChfRBUwX0bGREqDSlf5SU0oy2SyWcALVhmFUc=;
	b=FVJ4K0C7Hn5PFYIj71DoDUf6eM6ppScwb/kegHXu/0NHlGLfbpiWGix2j7/LVto27lJyBN
	gE4ROuBJxiSzoMKzk0c6XCVJZ7Kbhv96le2U3SdkPG7U3NTq6ahsphvP0hCxzFPmbRzGxA
	6r2BAVd1Ff9JB03Jf5feyJZPbNEDsgQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bdp12iChfRBUwX0bGREqDSlf5SU0oy2SyWcALVhmFUc=;
	b=FVJ4K0C7Hn5PFYIj71DoDUf6eM6ppScwb/kegHXu/0NHlGLfbpiWGix2j7/LVto27lJyBN
	gE4ROuBJxiSzoMKzk0c6XCVJZ7Kbhv96le2U3SdkPG7U3NTq6ahsphvP0hCxzFPmbRzGxA
	6r2BAVd1Ff9JB03Jf5feyJZPbNEDsgQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A2EDD3EA63;
	Fri,  6 Feb 2026 18:23:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YOdPJ7wxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:23:56 +0000
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
Subject: [PATCH v6 05/43] blk-crypto: add a process_bio callback
Date: Fri,  6 Feb 2026 19:22:37 +0100
Message-ID: <20260206182336.1397715-6-neelx@suse.com>
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
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
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
	TAGGED_FROM(0.00)[bounces-1084-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid,toxicpanda.com:email]
X-Rspamd-Queue-Id: 2030F101D2B
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

v5: https://lore.kernel.org/linux-btrfs/66c781f3b2afdf2c558efdf33a7bba8bcfe47ce7.1706116485.git.josef@toxicpanda.com/
 * No changes since.
---
 block/blk-crypto-fallback.c | 43 +++++++++++++++++++++++++++++++++++++
 block/blk-crypto-internal.h |  8 +++++++
 block/blk-crypto-profile.c  |  2 ++
 block/blk-crypto.c          |  6 +++++-
 fs/crypto/inline_crypt.c    |  3 ++-
 include/linux/blk-crypto.h  | 15 +++++++++++--
 6 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 86b27f96051a..7af6424a19ec 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -210,12 +210,15 @@ blk_crypto_fallback_alloc_cipher_req(struct blk_crypto_keyslot *slot,
 
 static bool blk_crypto_fallback_split_bio_if_needed(struct bio **bio_ptr)
 {
+	struct bio_crypt_ctx *bc;
 	struct bio *bio = *bio_ptr;
 	unsigned int i = 0;
 	unsigned int num_sectors = 0;
 	struct bio_vec bv;
 	struct bvec_iter iter;
 
+	bc = bio->bi_crypt_context;
+
 	bio_for_each_segment(bv, bio, iter) {
 		num_sectors += bv.bv_len >> SECTOR_SHIFT;
 		if (++i == BIO_MAX_VECS)
@@ -223,6 +226,16 @@ static bool blk_crypto_fallback_split_bio_if_needed(struct bio **bio_ptr)
 	}
 
 	if (num_sectors < bio_sectors(bio)) {
+		/*
+		 * We cannot split bio's that have process_bio, as they require
+		 * the original bio.  The upper layer must make sure to limit
+		 * the submitted bio's appropriately.
+		 */
+		if (bc->bc_key->crypto_cfg.process_bio) {
+			bio->bi_status = BLK_STS_RESOURCE;
+			return false;
+		}
+
 		bio = bio_submit_split_bioset(bio, num_sectors,
 					      &crypto_bio_split);
 		if (!bio)
@@ -343,6 +356,15 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 		}
 	}
 
+	/* Process the encrypted bio before we submit it. */
+	if (bc->bc_key->crypto_cfg.process_bio) {
+		blk_st = bc->bc_key->crypto_cfg.process_bio(src_bio, enc_bio);
+		if (blk_st != BLK_STS_OK) {
+			src_bio->bi_status = blk_st;
+			goto out_free_bounce_pages;
+		}
+	}
+
 	enc_bio->bi_private = src_bio;
 	enc_bio->bi_end_io = blk_crypto_fallback_encrypt_endio;
 	*bio_ptr = enc_bio;
@@ -388,6 +410,15 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 	unsigned int i;
 	blk_status_t blk_st;
 
+	/* Process the bio first before trying to decrypt. */
+	if (bc->bc_key->crypto_cfg.process_bio) {
+		blk_st = bc->bc_key->crypto_cfg.process_bio(bio, bio);
+		if (blk_st != BLK_STS_OK) {
+			bio->bi_status = blk_st;
+			goto out_no_keyslot;
+		}
+	}
+
 	/*
 	 * Get a blk-crypto-fallback keyslot that contains a crypto_skcipher for
 	 * this bio's algorithm and key.
@@ -437,6 +468,18 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
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
index ccf6dff6ff6b..82b512ca35f0 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -223,6 +223,8 @@ bool blk_crypto_fallback_bio_prep(struct bio **bio_ptr);
 
 int blk_crypto_fallback_evict_key(const struct blk_crypto_key *key);
 
+bool blk_crypto_profile_is_fallback(struct blk_crypto_profile *profile);
+
 #else /* CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK */
 
 static inline int
@@ -245,6 +247,12 @@ blk_crypto_fallback_evict_key(const struct blk_crypto_key *key)
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
index 81918f6e0cae..e57af3bb17dc 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -354,6 +354,8 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
 		return false;
 	if (!(profile->key_types_supported & cfg->key_type))
 		return false;
+	if (cfg->process_bio && !blk_crypto_profile_is_fallback(profile))
+		return false;
 	return true;
 }
 
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 3e7bf1974cbd..b0576e502d4d 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -332,6 +332,8 @@ int __blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
  * @dun_bytes: number of bytes that will be used to specify the DUN when this
  *	       key is used
  * @data_unit_size: the data unit size to use for en/decryption
+ * @process_bio: the call back if the upper layer needs to process the encrypted
+ *		 bio
  *
  * Return: 0 on success, -errno on failure.  The caller is responsible for
  *	   zeroizing both blk_key and key_bytes when done with them.
@@ -341,7 +343,8 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 			enum blk_crypto_key_type key_type,
 			enum blk_crypto_mode_num crypto_mode,
 			unsigned int dun_bytes,
-			unsigned int data_unit_size)
+			unsigned int data_unit_size,
+			blk_crypto_process_bio_t process_bio)
 {
 	const struct blk_crypto_mode *mode;
 
@@ -375,6 +378,7 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 	blk_key->crypto_cfg.dun_bytes = dun_bytes;
 	blk_key->crypto_cfg.data_unit_size = data_unit_size;
 	blk_key->crypto_cfg.key_type = key_type;
+	blk_key->crypto_cfg.process_bio = process_bio;
 	blk_key->data_unit_size_bits = ilog2(data_unit_size);
 	blk_key->size = key_size;
 	memcpy(blk_key->bytes, key_bytes, key_size);
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 38a729700552..d737fb6ff011 100644
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
index 58b0c5254a67..022b00004517 100644
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
@@ -145,7 +155,8 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 			enum blk_crypto_key_type key_type,
 			enum blk_crypto_mode_num crypto_mode,
 			unsigned int dun_bytes,
-			unsigned int data_unit_size);
+			unsigned int data_unit_size,
+			blk_crypto_process_bio_t process_bio);
 
 int blk_crypto_start_using_key(struct block_device *bdev,
 			       const struct blk_crypto_key *key);
-- 
2.51.0


