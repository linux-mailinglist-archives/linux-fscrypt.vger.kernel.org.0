Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298E27C4171
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbjJJUlR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbjJJUlO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:14 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41631D8
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:11 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-59b5484fbe6so75352327b3.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970470; x=1697575270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3m4RAmLF+khaONHXt5qu//wFJJoUrRtGots1ic/eLAI=;
        b=WjfFi+gH5h5K1Rxx88fOl7il7cMo1NwVuHfhNO9uPV/j+y2+ahEQd4RjsgDL5154by
         RWeE+SibHed/VdWh/hho6I2YbWoyMVip28dIWPKHu174IYo2U/+z21MrZwuqWYp4EiVg
         05Rr5czj4m+0KvVdJNfMUxT/xH0VzgKoO4r5Zr0oFpRAh1yTgNU/Sx6wZMAlDhODlFpc
         n8/5xsl5LbO18JHqI41LT3qyyoAXaOafyCKF0uktkzV3+rjU1VHgVQlcFXqflpZQgTve
         ICJTARlqXYiGTJ8mgVrXIKI3jGRY/Ez4M1a0ITVB/tuX9nyC2U/aL3mv6UCdLu2Wy32C
         bxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970470; x=1697575270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3m4RAmLF+khaONHXt5qu//wFJJoUrRtGots1ic/eLAI=;
        b=j+pWnO7NIRFE6DAMI1o63ymQe6ut8cUdOFj/ARLfb9RPabdcd4LDG1PWoRyGnSarWp
         0vcZ/6WBL2PjTPcWZx00TjHrQ2ECzWJOE6tfl+0SjJn9IR2GnQyNyqDuSeEsgZt6BLNC
         4Fq3go8VZH/pzri+JnMzM5op6gDi7V05OlcbLh2ASOeZC2I62EfnnZV1NwMg41B1vS2H
         XOxHXGGZkZZxo0ReLT4mAKxqZNfbiRz3L9awhw7Qj+cZBeGMwBolAv3ZF2eQH5RHIwc0
         UQQkv0gaYIChIFLzl8uC52+nr7PZ2z4hrgE9DYQtDh1tWMTlCvo4BqywYxjBkFtb8SG3
         errQ==
X-Gm-Message-State: AOJu0YwaL5T/owsL8d166ltJIRht6QQaaj+UCvdYqlB0cx2TUgyXpJdH
        n5LW0v9pLIQ1BQgOTs5hXSVGuCT3zkzy7DivZVG0cA==
X-Google-Smtp-Source: AGHT+IEouGSIjN904f72tEDHIxSSZumqXFfqa+Z9ibdW067FA51KO6BL+bO0SLL2rzK/kWN9sdei7g==
X-Received: by 2002:a81:4e4a:0:b0:5a7:ca59:82b9 with SMTP id c71-20020a814e4a000000b005a7ca5982b9mr2301640ywb.16.1696970470319;
        Tue, 10 Oct 2023 13:41:10 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id n184-20020a0de4c1000000b005a4d922cf77sm4656731ywe.119.2023.10.10.13.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:09 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 05/36] blk-crypto: add a process bio callback
Date:   Tue, 10 Oct 2023 16:40:20 -0400
Message-ID: <ab3493e225d34845fa953c429b3cd07c112ec7e7.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 block/blk-crypto-fallback.c        | 28 ++++++++++++++++++++++++++++
 block/blk-crypto-profile.c         |  2 ++
 block/blk-crypto.c                 |  6 +++++-
 fs/crypto/inline_crypt.c           |  3 ++-
 include/linux/blk-crypto-profile.h |  7 +++++++
 include/linux/blk-crypto.h         |  9 +++++++--
 include/linux/fscrypt.h            | 14 ++++++++++++++
 7 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index e6468eab2681..8b4a83534127 100644
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
@@ -391,6 +400,24 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 	unsigned int i;
 	blk_status_t blk_st;
 
+	/*
+	 * Process the bio first before trying to decrypt.
+	 *
+	 * NOTE: btrfs expects that this bio is the same that was submitted.  If
+	 * at any point this changes we will need to update process_bio to take
+	 * f_ctx->crypt_iter in order to make sure we can iterate the pages for
+	 * checksumming.  We're currently saving this in our btrfs_bio, so this
+	 * works, but if at any point in the future we start allocating a bounce
+	 * bio or something we need to update this callback.
+	 */
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
@@ -560,6 +587,7 @@ static int blk_crypto_fallback_init(void)
 
 	blk_crypto_fallback_profile->ll_ops = blk_crypto_fallback_ll_ops;
 	blk_crypto_fallback_profile->max_dun_bytes_supported = BLK_CRYPTO_MAX_IV_SIZE;
+	blk_crypto_fallback_profile->process_bio_supported = true;
 
 	/* All blk-crypto modes have a crypto API fallback. */
 	for (i = 0; i < BLK_ENCRYPTION_MODE_MAX; i++)
diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 7fabc883e39f..640cf2ea3fcc 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -352,6 +352,8 @@ bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
 		return false;
 	if (profile->max_dun_bytes_supported < cfg->dun_bytes)
 		return false;
+	if (cfg->process_bio && !profile->process_bio_supported)
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
index 4eeb75410ba8..57776c548a06 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -168,7 +168,8 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 
 	err = blk_crypto_init_key(blk_key, raw_key, crypto_mode,
 				  fscrypt_get_dun_bytes(ci),
-				  1U << ci->ci_data_unit_bits);
+				  1U << ci->ci_data_unit_bits,
+				  sb->s_cop->process_bio);
 	if (err) {
 		fscrypt_err(inode, "error %d initializing blk-crypto key", err);
 		goto fail;
diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
index 90ab33cb5d0e..3c002e85631a 100644
--- a/include/linux/blk-crypto-profile.h
+++ b/include/linux/blk-crypto-profile.h
@@ -100,6 +100,13 @@ struct blk_crypto_profile {
 	 */
 	struct device *dev;
 
+	/**
+	 * @process_bio_supported: Some things, like btrfs, require the
+	 * encrypted data for checksumming. Drivers set this to true if they can
+	 * handle the process_bio() callback.
+	 */
+	bool process_bio_supported;
+
 	/* private: The following fields shouldn't be accessed by drivers. */
 
 	/* Number of keyslots, or 0 if not applicable */
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
index ea8fdc6f3b83..a3576da6a9fa 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/blk-crypto.h>
 #include <uapi/linux/fscrypt.h>
 
 /*
@@ -199,6 +200,19 @@ struct fscrypt_operations {
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
 
 static inline struct fscrypt_inode_info *
-- 
2.41.0

