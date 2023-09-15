Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E226B7A128B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Sep 2023 02:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjIOAs7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 14 Sep 2023 20:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjIOAs6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 14 Sep 2023 20:48:58 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41EC26B8
        for <linux-fscrypt@vger.kernel.org>; Thu, 14 Sep 2023 17:48:53 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id 71dfb90a1353d-495bcd861ccso718568e0c.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 14 Sep 2023 17:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1694738933; x=1695343733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=StOECBI34a0aDh7MzYHd+8wqnubOPd2ufHhgjAX7mvc=;
        b=VkkDk8dw7kv+ijdfpKcZn1SgCW4v9LVoDqw3vqIgUzH7pQPRR/cng/+ljqSMZorDYU
         mBayE2bnhzVqvRwgpnDZn8gABGHmGRPQHJ3SXiDWFeZo25dkz7zFEiXyi111cl/hpXPA
         sFH2P9D2o7LaDxeiPD646ijE/kCI9qxXtMiMXpp6rbYtefFpvpi996IvhgouJ46q/vU2
         WpKIltjKYlcxB/NSwBV6c4+P+o7EyQLizewmR/yoPw1VXHKwNPsCkpxKy+TavgVwByVn
         uSnnCjpik24dxvgPRvDA7mr7mr9N/BMiR7f4adtii9XGxj8h8+Q0ymIwQdkRPFJpNmj2
         eBig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694738933; x=1695343733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=StOECBI34a0aDh7MzYHd+8wqnubOPd2ufHhgjAX7mvc=;
        b=CuDkD5bA5HtKh/gB0uZWDST2e5vGvo39UxEny5U0izJfecIVhYNHi2R5Nb3DIjgCop
         Wmnm93jj5FuuY8T024DaQj9sibdnsltxQYeMYWvhP3bmcbDH5rzeregdS1VCdVnuq3u6
         G6Uh1lLPyJDcHUogtPEXwbySHuSyRbzDei2kn9W9hgyzOZF2q422JTCxu1BCXuUEgAt2
         Meq/sge1bgqEVwrk5aWqEvVFuiT45o9OImW8WMQ4iEqtWiNVJWPPKqWOzGZoKjYM4ON7
         UakZDaWAAn067pVqaEUt25x3zWKDMKuEkkHu1TOniTHwdzupSJs7FsOMSfiI+UwhFJiO
         PlbA==
X-Gm-Message-State: AOJu0YykLawxcWWHhRRMTi2eUP/kW8x1BegmBBXpYyPrIhdWCBNJf1dD
        xFUDQyOf7BGmNerVO4wWKd9Tgg==
X-Google-Smtp-Source: AGHT+IEVUOF5iYiUkxX4ebjr4Q3U2ARhDxRiu0T2T0SGvV/UhrpCYWDH/ZxMwjzaI7XhTDDuvADAEA==
X-Received: by 2002:a1f:4cc2:0:b0:495:dcd0:471 with SMTP id z185-20020a1f4cc2000000b00495dcd00471mr385838vka.5.1694738932809;
        Thu, 14 Sep 2023 17:48:52 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id o20-20020a0cf4d4000000b0064f4ec872dfsm894263qvm.0.2023.09.14.17.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 17:48:52 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        clm@fb.com, ebiggers@kernel.org, ngompa13@gmail.com,
        sweettea-kernel@dorminy.me, kernel-team@meta.com
Subject: [PATCH 4/4] blk-crypto: add a process bio callback
Date:   Thu, 14 Sep 2023 20:47:45 -0400
Message-ID: <94e42d738d62ba5cb1eaa9a3c4ba74fe0c62df36.1694738282.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694738282.git.josef@toxicpanda.com>
References: <cover.1694738282.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

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
---
 block/blk-crypto-fallback.c | 18 ++++++++++++++++++
 block/blk-crypto-profile.c  |  2 ++
 block/blk-crypto.c          |  6 +++++-
 fs/crypto/inline_crypt.c    |  3 ++-
 include/linux/blk-crypto.h  |  9 +++++++--
 include/linux/fscrypt.h     | 14 ++++++++++++++
 6 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index e6468eab2681..91e5f70ef6b1 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -346,6 +346,15 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
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
@@ -391,6 +400,15 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
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
diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 7fabc883e39f..1d55b952e52e 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -352,6 +352,8 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
 		return false;
 	if (profile->max_dun_bytes_supported < cfg->dun_bytes)
 		return false;
+	if (cfg->process_bio)
+		return false;
 	return true;
 }
 
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 4d760b092deb..50556952df19 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -321,6 +321,8 @@ int __blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
  * @dun_bytes: number of bytes that will be used to specify the DUN when this
  *	       key is used
  * @data_unit_size: the data unit size to use for en/decryption
+ * @process_bio: the call back if the upper layer needs to process the encrypted
+ *		 bio
  *
  * Return: 0 on success, -errno on failure.  The caller is responsible for
  *	   zeroizing both blk_key and raw_key when done with them.
@@ -328,7 +330,8 @@ int __blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
 int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 			enum blk_crypto_mode_num crypto_mode,
 			unsigned int dun_bytes,
-			unsigned int data_unit_size)
+			unsigned int data_unit_size,
+			blk_crypto_process_bio_t process_bio)
 {
 	const struct blk_crypto_mode *mode;
 
@@ -350,6 +353,7 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 	blk_key->crypto_cfg.crypto_mode = crypto_mode;
 	blk_key->crypto_cfg.dun_bytes = dun_bytes;
 	blk_key->crypto_cfg.data_unit_size = data_unit_size;
+	blk_key->crypto_cfg.process_bio = process_bio;
 	blk_key->data_unit_size_bits = ilog2(data_unit_size);
 	blk_key->size = mode->keysize;
 	memcpy(blk_key->raw, raw_key, mode->keysize);
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 69bb6ac9a7f7..0558fe73e82f 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -168,7 +168,8 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 		return -ENOMEM;
 
 	err = blk_crypto_init_key(blk_key, raw_key, crypto_mode,
-				  fscrypt_get_dun_bytes(ci), sb->s_blocksize);
+				  fscrypt_get_dun_bytes(ci), sb->s_blocksize,
+				  sb->s_cop->process_bio);
 	if (err) {
 		fscrypt_err(inode, "error %d initializing blk-crypto key", err);
 		goto fail;
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 5e5822c18ee4..194c1d727013 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -6,7 +6,7 @@
 #ifndef __LINUX_BLK_CRYPTO_H
 #define __LINUX_BLK_CRYPTO_H
 
-#include <linux/types.h>
+#include <linux/blk_types.h>
 
 enum blk_crypto_mode_num {
 	BLK_ENCRYPTION_MODE_INVALID,
@@ -17,6 +17,9 @@ enum blk_crypto_mode_num {
 	BLK_ENCRYPTION_MODE_MAX,
 };
 
+typedef blk_status_t (blk_crypto_process_bio_t)(struct bio *orig_bio,
+						struct bio *enc_bio);
+
 #define BLK_CRYPTO_MAX_KEY_SIZE		64
 /**
  * struct blk_crypto_config - an inline encryption key's crypto configuration
@@ -31,6 +34,7 @@ struct blk_crypto_config {
 	enum blk_crypto_mode_num crypto_mode;
 	unsigned int data_unit_size;
 	unsigned int dun_bytes;
+	blk_crypto_process_bio_t *process_bio;
 };
 
 /**
@@ -90,7 +94,8 @@ bool bio_crypt_dun_is_contiguous(const struct bio_crypt_ctx *bc,
 int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 			enum blk_crypto_mode_num crypto_mode,
 			unsigned int dun_bytes,
-			unsigned int data_unit_size);
+			unsigned int data_unit_size,
+			blk_crypto_process_bio_t process_bio);
 
 int blk_crypto_start_using_key(struct block_device *bdev,
 			       const struct blk_crypto_key *key);
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index b01327191b4a..daa2ac798bbb 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/blk-crypto.h>
 #include <uapi/linux/fscrypt.h>
 
 /*
@@ -180,6 +181,19 @@ struct fscrypt_operations {
 	 */
 	struct block_device **(*get_devices)(struct super_block *sb,
 					     unsigned int *num_devs);
+
+	/*
+	 * A callback if the file system requires the ability to process the
+	 * encrypted bio.
+	 *
+	 * @orig_bio: the original bio submitted.
+	 * @enc_bio: the encrypted bio.
+	 *
+	 * For writes the enc_bio will be different from the orig_bio, for reads
+	 * they will be the same.  For reads we get the bio before it is
+	 * decrypted, for writes we get the bio before it is submitted.
+	 */
+	blk_crypto_process_bio_t *process_bio;
 };
 
 static inline struct fscrypt_inode_info *fscrypt_get_info(const struct inode *inode)
-- 
2.41.0

