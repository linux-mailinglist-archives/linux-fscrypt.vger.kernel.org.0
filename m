Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50185790577
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Sep 2023 07:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351632AbjIBF4P (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 2 Sep 2023 01:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjIBF4O (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 2 Sep 2023 01:56:14 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0E510F4;
        Fri,  1 Sep 2023 22:56:11 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 071B7803B8;
        Sat,  2 Sep 2023 01:56:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1693634171; bh=9CCHaKZC9yydBhLDgrT5+iVaEc3tpYmiIVZSh+piTxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCV0T54qQx7jVei/inQrTPBC0JEmuTOYXk6t0BBtP3xXzwirjcijNszvQb0fV9fjr
         goxXOmO4OwThCW+Xy3oFdEaRokE5Dat++6N+DiIgn4vMg4zyz2UBwNcRdt6H8FESTS
         xSR0MRxWHMsBEGDJLGI9PUzfCqGmAV2ZqH/gQ75mcWP0AEI6WSN8/8kJYLu0GfR/8G
         BtBjh340dPJGv0m/4q4TdDhrzywLZV9iu5p19f6K0lfYKIZp8dXTJ1le19InVVKkaf
         WbcgLu1cIrptKsNqQqcCgHBD6YLf5WnGQcUkQcyyf2Q1Sxd32cshhVGjRDAxevTWLY
         GL9RPm8fYwPOA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ebiggers@kernel.org, ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 11/13] fscrypt: cache list of inlinecrypt devices
Date:   Sat,  2 Sep 2023 01:54:29 -0400
Message-ID: <26e6ff03299df2a5c8f3d8727f36bfe8f15b686d.1693630890.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1693630890.git.sweettea-kernel@dorminy.me>
References: <cover.1693630890.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index cf1eb7fe546f..30459e219fc3 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -206,6 +206,16 @@ struct fscrypt_prepared_key {
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
@@ -472,8 +482,7 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 				     const u8 *raw_key,
 				     const struct fscrypt_common_info *ci);
 
-void fscrypt_destroy_inline_crypt_key(struct super_block *sb,
-				      struct fscrypt_prepared_key *prep_key);
+void fscrypt_destroy_inline_crypt_key(struct fscrypt_prepared_key *prep_key);
 
 /*
  * Check whether the crypto transform or blk-crypto key has been allocated in
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index f0229234249c..19ebdef8508b 100644
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
index f0f70b888bd8..4ea9b68363d5 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -184,7 +184,7 @@ void fscrypt_destroy_prepared_key(struct super_block *sb,
 				  struct fscrypt_prepared_key *prep_key)
 {
 	crypto_free_skcipher(prep_key->tfm);
-	fscrypt_destroy_inline_crypt_key(sb, prep_key);
+	fscrypt_destroy_inline_crypt_key(prep_key);
 	memzero_explicit(prep_key, sizeof(*prep_key));
 }
 
-- 
2.41.0

