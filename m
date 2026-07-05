Return-Path: <linux-fscrypt+bounces-1721-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id NPRcCvq0SmoDGgEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1721-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:48:10 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2823770B1E7
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:48:09 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G1fM456P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1721-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1721-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A721B300CF07
	for <lists+linux-fscrypt@lfdr.de>; Sun,  5 Jul 2026 19:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078A33A0B13;
	Sun,  5 Jul 2026 19:47:43 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5623246ED;
	Sun,  5 Jul 2026 19:47:41 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783280862; cv=none; b=ApKia6bLNrkv0A1oqvMr9OgZhs4QHananjdvBsiEf+4DPNkVjmVCRaSJBLRtVdxzS3EGRtguC+lh0iM4QHbMPof0XLOZZ0LBdYdwoAjhJhRtb3H2APMKulVRVvA9mZuuhMyF5LhGETUW3JCOtlX8G3hxU79iv4VZiF9XPu1MBig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783280862; c=relaxed/simple;
	bh=rDzvJQPkI/+5mWk9DdM9XqErfJxO55IBGu5D8AbfyXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQ7f12BBbDDZS7S8CctnltGrTtNzUlRwK81rBTtR8W1Jc0lFTKHgBueAnJQ6R+UJ4dwqXBEVPSdCfKPPNlkNoliy7CdOc3AcGw7Qr6XQyI4sj7fIEKIzlxnMNhzbhEchI8ZaYLMyRvRho0zNbo+dnGnEQqpDuFYwRJ2TCHQdPts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G1fM456P; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365F81F000E9;
	Sun,  5 Jul 2026 19:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783280861;
	bh=R2PI6iuoyUw2XJ5MVbeY7n1gSyK6HwEu3MUtpH0Fv5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G1fM456PqLiMXUhUS0jszQtRL0EAo1fThg4nECloQNYmYdgXcOLq+FRNUOEP7MqIi
	 Draay2w67+T+XCNGOV22VFsWL4Smb60j4KM1pJbeW2jr1ctjWWegd7m6xvkRDA965A
	 HZ31j4CTp13zfljics7eKPlkxInCveiZDeJN/NAvHABr0q8n7XTaczo+KVk0pZZXBl
	 AeZK3wGmQo60gf1dP+0asQyjjWLSTeD+mlFCW7/G++VqqW8a3SwvX8DZZyryI49cUa
	 cptpj1l86gCyPKSDQfNuwoWd4davZLVMnwgZ+I9A4y3EWxRpfnBXZ9Tz0b3bMhnRHN
	 ocIoYGarejd5Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 03/17] blk-crypto: Allow control over whether hardware is used
Date: Sun,  5 Jul 2026 12:45:40 -0700
Message-ID: <20260705194555.75030-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260705194555.75030-1-ebiggers@kernel.org>
References: <20260705194555.75030-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1721-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-block@vger.kernel.org,m:hch@lst.de,m:tytso@mit.edu,m:adilger.kernel@dilger.ca,m:libaokun@linux.alibaba.com,m:jack@suse.cz,m:ojaswin@linux.ibm.com,m:ritesh.list@gmail.com,m:yi.zhang@huawei.com,m:jaegeuk@kernel.org,m:chao@kernel.org,m:ebiggers@kernel.org,m:riteshlist@gmail.com,s:lists@lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.sourceforge.net,lst.de,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2823770B1E7

fscrypt uses inline encryption hardware only when the "inlinecrypt"
mount option is given.  I'd like to keep that behavior even after
standardizing on the blk-crypto API for file contents encryption.  That
is, the default should continue to be the well-tested CPU-based
encryption code, and the use of inline encryption hardware should
continue to be an opt-in feature for systems where it's beneficial and
has been fully validated (including verifying ciphertext correctness).

To support this use case, extend blk_crypto_config with a new flag
BLK_CRYPTO_CFG_ALLOW_HW.

For now it's always set.  Later commits will change that.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 block/blk-crypto.c          | 11 ++++++++++-
 drivers/md/dm-inlinecrypt.c |  3 ++-
 fs/crypto/inline_crypt.c    |  4 +++-
 include/linux/blk-crypto.h  | 14 ++++++++++++--
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index de60f03b4d4b..0fe6ef0eea1d 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -300,6 +300,7 @@ int __blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
  * @dun_bytes: number of bytes that will be used to specify the DUN when this
  *	       key is used
  * @data_unit_size: the data unit size to use for en/decryption
+ * @flags: BLK_CRYPTO_CFG_* flags
  *
  * Return: 0 on success, -errno on failure.  The caller is responsible for
  *	   zeroizing both blk_key and key_bytes when done with them.
@@ -309,7 +310,7 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 			enum blk_crypto_key_type key_type,
 			enum blk_crypto_mode_num crypto_mode,
 			unsigned int dun_bytes,
-			unsigned int data_unit_size)
+			unsigned int data_unit_size, int flags)
 {
 	const struct blk_crypto_mode *mode;
 
@@ -318,6 +319,9 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 	if (crypto_mode >= ARRAY_SIZE(blk_crypto_modes))
 		return -EINVAL;
 
+	if (flags & ~BLK_CRYPTO_CFG_ALLOW_HW)
+		return -EINVAL;
+
 	mode = &blk_crypto_modes[crypto_mode];
 	switch (key_type) {
 	case BLK_CRYPTO_KEY_TYPE_RAW:
@@ -328,6 +332,8 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 		if (key_size < mode->security_strength ||
 		    key_size > BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE)
 			return -EINVAL;
+		if (!(flags & BLK_CRYPTO_CFG_ALLOW_HW))
+			return -EINVAL;
 		break;
 	default:
 		return -EINVAL;
@@ -343,6 +349,7 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 	blk_key->crypto_cfg.dun_bytes = dun_bytes;
 	blk_key->crypto_cfg.data_unit_size = data_unit_size;
 	blk_key->crypto_cfg.key_type = key_type;
+	blk_key->crypto_cfg.flags = flags;
 	blk_key->data_unit_size_bits = ilog2(data_unit_size);
 	blk_key->size = key_size;
 	memcpy(blk_key->bytes, key_bytes, key_size);
@@ -368,6 +375,8 @@ bool blk_crypto_config_supported_natively(struct block_device *bdev,
 
 	if (!profile)
 		return false;
+	if (!(cfg->flags & BLK_CRYPTO_CFG_ALLOW_HW))
+		return false;
 	if (!(profile->modes_supported[cfg->crypto_mode] & cfg->data_unit_size))
 		return false;
 	if (profile->max_dun_bytes_supported < cfg->dun_bytes)
diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
index be1b4aa8f28b..35379f5c84df 100644
--- a/drivers/md/dm-inlinecrypt.c
+++ b/drivers/md/dm-inlinecrypt.c
@@ -406,7 +406,8 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	err = blk_crypto_init_key(&ctx->key, key_bytes, ctx->key_size,
 				  ctx->key_type, cipher->mode_num,
-				  dun_bytes, ctx->sector_size);
+				  dun_bytes, ctx->sector_size,
+				  BLK_CRYPTO_CFG_ALLOW_HW);
 	if (err) {
 		ti->error = "Error initializing blk-crypto key";
 		goto bad;
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 47324062fee5..aaf71f6068b0 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -134,6 +134,7 @@ int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci,
 	crypto_cfg.dun_bytes = fscrypt_get_dun_bytes(ci);
 	crypto_cfg.key_type = is_hw_wrapped_key ?
 		BLK_CRYPTO_KEY_TYPE_HW_WRAPPED : BLK_CRYPTO_KEY_TYPE_RAW;
+	crypto_cfg.flags = BLK_CRYPTO_CFG_ALLOW_HW;
 
 	devs = fscrypt_get_devices(sb, &num_devs);
 	if (IS_ERR(devs))
@@ -175,7 +176,8 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 
 	err = blk_crypto_init_key(blk_key, key_bytes, key_size, key_type,
 				  crypto_mode, fscrypt_get_dun_bytes(ci),
-				  1U << ci->ci_data_unit_bits);
+				  1U << ci->ci_data_unit_bits,
+				  BLK_CRYPTO_CFG_ALLOW_HW);
 	if (err) {
 		fscrypt_err(inode, "error %d initializing blk-crypto key", err);
 		goto fail;
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index f7c3cb4a342f..b4a7be8e95c0 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -68,6 +68,15 @@ enum blk_crypto_key_type {
  */
 #define BLK_CRYPTO_SW_SECRET_SIZE	32
 
+/* Flags for blk_crypto_config::flags: */
+
+/*
+ * If set, inline encryption hardware will be used if available.
+ * If unset, CPU-based encryption will always be used (requires
+ * CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)
+ */
+#define BLK_CRYPTO_CFG_ALLOW_HW		(1 << 0)
+
 /**
  * struct blk_crypto_config - an inline encryption key's crypto configuration
  * @crypto_mode: encryption algorithm this key is for
@@ -76,13 +85,14 @@ enum blk_crypto_key_type {
  *	ciphertext.  This is always a power of 2.  It might be e.g. the
  *	filesystem block size or the disk sector size.
  * @dun_bytes: the maximum number of bytes of DUN used when using this key
- * @key_type: the type of this key -- either raw or hardware-wrapped
+ * @flags: BLK_CRYPTO_CFG_* flags
  */
 struct blk_crypto_config {
 	enum blk_crypto_mode_num crypto_mode;
 	unsigned int data_unit_size;
 	unsigned int dun_bytes;
 	enum blk_crypto_key_type key_type;
+	int flags;
 };
 
 /**
@@ -150,7 +160,7 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 			enum blk_crypto_key_type key_type,
 			enum blk_crypto_mode_num crypto_mode,
 			unsigned int dun_bytes,
-			unsigned int data_unit_size);
+			unsigned int data_unit_size, int flags);
 
 int blk_crypto_start_using_key(struct block_device *bdev,
 			       const struct blk_crypto_key *key);
-- 
2.54.0


