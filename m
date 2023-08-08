Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE32E774642
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbjHHSyc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbjHHSyP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:54:15 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24008A7B7;
        Tue,  8 Aug 2023 10:09:01 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id AC02083541;
        Tue,  8 Aug 2023 13:09:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514540; bh=ntPuzPG8lqrcqAowHX8Wfy9zZUFP0oUAHsbjRXF+ud4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqXdbIqjgbRsYCFAK8prqhrXbyjfvbWLspofmr3d5eKgwYiDgPUNi8NilgwWYEzjz
         lpwir42PGIs6uhiekcOGkNbJwukhqLECO0Ml+FDs6L+Fp/CPdXNeqcbP9mwTr+gdn7
         vToiPLiIOxlK4MLuvCL+jxAObOBznggtOfKwrIvsGGAJymCMcPfxd0e0ONf/Gg2swj
         nPrh7Yr782zMKcnBaib3NbpgZghc0Rm+dwKKFe7AK/IuxNL5rYC5Ny20bBQLoAOr2Z
         QxenOogQ0TvZI/A4HldknHMg7i0pNcCaMrDRoMFcObwdjSldEpLiqOHSfTJl/i2Vwp
         V547dYwjlRkVA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 14/16] fscrypt: cache list of inlinecrypt devices
Date:   Tue,  8 Aug 2023 13:08:31 -0400
Message-ID: <62170e01a2c0b107619018c859250c03b6023a57.1691505882.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

btrfs sometimes frees extents while holding a mutex, which makes it
impossible to free an inlinecrypt prepared key since that requires
taking a semaphore. Therefore, we will need to offload prepared key
freeing into an asynchronous process (rcu is insufficient since that can
run in softirq context which is also incompatible with taking a
semaphore). In order to avoid use-after-free on the filesystem
superblock for keys being freed during shutdown, we need to cache the
list of devices that the key has been loaded into, so that we can later
remove it without reference to the superblock.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 13 +++++++++++--
 fs/crypto/inline_crypt.c    | 20 +++++++++-----------
 fs/crypto/keysetup.c        |  2 +-
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 03be2c136c0e..aba83509c735 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -205,6 +205,16 @@ struct fscrypt_prepared_key {
 	struct crypto_skcipher *tfm;
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 	struct blk_crypto_key *blk_key;
+
+	/*
+	 * The list of devices that have this block key.
+	 */
+	struct block_device **devices;
+
+	/*
+	 * The number of devices in @ci_devices.
+	 */
+	size_t device_count;
 #endif
 	enum fscrypt_prepared_key_type type;
 };
@@ -470,8 +480,7 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 				     const u8 *raw_key,
 				     const struct fscrypt_info *ci);
 
-void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
-				      struct fscrypt_prepared_key *prep_key);
+void fscrypt_destroy_inline_crypt_key(struct fscrypt_prepared_key *prep_key);
 
 /*
  * Check whether the crypto transform or blk-crypto key has been allocated in
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 76274b736e1a..91f8365b4194 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -185,12 +185,15 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 		if (err)
 			break;
 	}
-	kfree(devs);
+
 	if (err) {
 		fscrypt_err(inode, "error %d starting to use blk-crypto", err);
 		goto fail;
 	}
 
+	prep_key->devices = devs;
+	prep_key->device_count = num_devs;
+
 	/*
 	 * Pairs with the smp_load_acquire() in fscrypt_is_key_prepared().
 	 * I.e., here we publish ->blk_key with a RELEASE barrier so that
@@ -205,24 +208,19 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 	return err;
 }
 
-void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
-				      struct fscrypt_prepared_key *prep_key)
+void fscrypt_destroy_inline_crypt_key(struct fscrypt_prepared_key *prep_key)
 {
 	struct blk_crypto_key *blk_key = prep_key->blk_key;
-	struct block_device **devs;
-	unsigned int num_devs;
 	unsigned int i;
 
 	if (!blk_key)
 		return;
 
 	/* Evict the key from all the filesystem's block devices. */
-	devs = fscrypt_get_devices(sb, &num_devs);
-	if (!IS_ERR(devs)) {
-		for (i = 0; i < num_devs; i++)
-			blk_crypto_evict_key(devs[i], blk_key);
-		kfree(devs);
-	}
+	for (i = 0; i < prep_key->device_count; i++)
+		blk_crypto_evict_key(prep_key->devices[i], blk_key);
+
+	kfree(prep_key->devices);
 	kfree_sensitive(blk_key);
 }
 
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 12c3851b7cd6..fe246229c869 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -195,7 +195,7 @@ void fscrypt_destroy_prepared_key(struct super_block *sb,
 				  struct fscrypt_prepared_key *prep_key)
 {
 	crypto_free_skcipher(prep_key->tfm);
-	fscrypt_destroy_inline_crypt_key(sb, prep_key);
+	fscrypt_destroy_inline_crypt_key(prep_key);
 	memzero_explicit(prep_key, sizeof(*prep_key));
 }
 
-- 
2.41.0

