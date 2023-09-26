Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4067AF225
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbjIZSD3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbjIZSD2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:28 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1668611F
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:19 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-656351b6d74so50302896d6.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751398; x=1696356198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DhsoYdqKEB57sdkiaORFFDDcmRQ6FJWpxL8kkDS6WVQ=;
        b=Im6S7c71oJsLzI4NS1mhHn9J1chKXXCjAIQudkQtxw1C28no8eLnFqMlfLJUWAgOSK
         qSo1G0PUb33zbiQPiIkYL1xUI2DaAoh9i1Epbg9x4XBwK/H8EIM4qEMImvoUwLHAFl2a
         dW9yBXQVU+hIaR2ZKA3XxdQvqK5ojkiMgRynNtCfgtfpMqCmZ5oT/4A19KpUdQuaVvAr
         c0cFVHFC5zYBTW/0SvRbbIKI+uPVz+Raub3vfel92GlQxBvugKm/8mzbHYoPFVd0sGZt
         lVXFIWg7gf6dDFjHQQyZUhTh5y7hg+BB7052BbYvKaT6AcjMFJBkon9tRj+gIcSjyfzV
         ssrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751398; x=1696356198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DhsoYdqKEB57sdkiaORFFDDcmRQ6FJWpxL8kkDS6WVQ=;
        b=RVrqc6OrcMYN8/YeoHX/stGG/CmD113vGRftEuY+k165aY1rHPYlHzKmNIoe2QaCI2
         by8r4pPUOlMnPgGTpoJmhRe12MTC/vj9heYeHhmk6LInWWH4X2lfOJjF2yBdtY5cij1M
         KBEQG0iWb/OvpzxACCs9PnfIN/gCV3B9Igh19Vo4WpHDlGoydIktk1ctg6d/ehcd6EDq
         0X40R+Ozbsz1x7fwYZM6XwT2YP9NpnqMw01B42env8k8p8VbZPdU7m+HSfjfHlh8HzQJ
         4yCxo/uXC3q/dskgbSTTs12Bbn1Blq0jIQ7RozkN6Z2Kgvboj2nvkrPZ8FX5q74ZfGML
         YaFA==
X-Gm-Message-State: AOJu0Yz7nmc84RdbsXhyTXT4dlvmSaH7SfDMWVWQ3UywPAlOSP4h2EEb
        vZ7ptQPKkzzvQw+7XaXaTT0eMQ==
X-Google-Smtp-Source: AGHT+IHy5RadIV1+96HKk2bhm02XovrnSBxIzx4KZIeJBwaSN4keOhNX+CxgEyeCcXakspT4kZaAQQ==
X-Received: by 2002:a05:6214:2267:b0:656:1cee:d1d with SMTP id gs7-20020a056214226700b006561cee0d1dmr15793152qvb.11.1695751398132;
        Tue, 26 Sep 2023 11:03:18 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id e14-20020a0ce3ce000000b0065b0771f2edsm2454602qvl.136.2023.09.26.11.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:17 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 04/35] blk-crypto: add a process bio callback
Date:   Tue, 26 Sep 2023 14:01:30 -0400
Message-ID: <78be341377e7f0fb0ead3d5167be44ca0c87a944.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 21e1851d4ba7..a66a555d84ee 100644
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
index 266416742c72..07493ad2588b 100644
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

