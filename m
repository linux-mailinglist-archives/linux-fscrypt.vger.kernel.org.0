Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24FE657CB09
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Jul 2022 14:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiGUM7i (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Jul 2022 08:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiGUM7h (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Jul 2022 08:59:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6310A4D827;
        Thu, 21 Jul 2022 05:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=KhNLdsZZHBfZfKt851/B+Z7PKCSdlhzM2OXC0nVKAPw=; b=i7LkAzOBZ98DVApWah+jecB7/9
        rn3SrkpE+t/GcVibKfUab4TGI6fLrfd7ASXSKZmP6vduX79myMfMmP4JDwZydD3L+PAsLb9Nbc/y6
        azENOWZaU3ar4m3ONPOELX5Vmx7epSV6M7jk1uxv4+6VFWzVmINkdCWu9bvhi8SJUeaE/S3Fzq0cU
        41DuWClUwjOkx3caEtki655et+WY1ep9Ck5vI0DIGjAtUhDX+1r5RFoqfVIZVsEvvexssDZrILzUZ
        ByHrsPZWTrhgGTDsIKiDVg4d9o0MX0zTC9nypJORcyJ1sR+vqSVHYuRcZr3+8qdHCrlWkw8J2mm3V
        9279M2Jg==;
Received: from [2001:4bb8:18a:6f7a:1b03:4d0e:b929:ebb2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oEVm7-006VgJ-R7; Thu, 21 Jul 2022 12:59:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     ebiggers@kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org
Subject: RFC: what to do about fscrypt vs block device interaction
Date:   Thu, 21 Jul 2022 14:59:29 +0200
Message-Id: <20220721125929.1866403-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

fscrypt is the last major user of request_queues in file system code.
A lot of this would be easy to fix, and I have some pending patches,
but the major roadblocker is that the fscrypt_blk_crypto_key tries
to hold it's own refefrences to the request_queue.  The reason for
that is documented in the code, as in that the master key can outlive
the super_block.  But can you explain why we need to do that?  I
think evicting the key on unmount would be very much the expected
behavior.  With that we could rework how fscrypt interacts with the
file systems for inline encryption and avoid the nasty returning
of the devics in the get_devices method.  See my draft patch below,
for which I'm stuck at how to find a super_block for the evict side,
which seems to require larger logic changes.

---
 Documentation/block/inline-encryption.rst |   8 +-
 block/blk-crypto.c                        |  12 --
 fs/crypto/fscrypt_private.h               |   7 +-
 fs/crypto/inline_crypt.c                  | 158 ++++++++--------------
 fs/crypto/keysetup.c                      |   4 +-
 fs/f2fs/super.c                           |  57 ++++++--
 include/linux/blk-crypto.h                |   3 -
 include/linux/fscrypt.h                   |  39 ++++--
 8 files changed, 141 insertions(+), 147 deletions(-)

diff --git a/Documentation/block/inline-encryption.rst b/Documentation/block/inline-encryption.rst
index 4d151fbe20583..8150e10169c97 100644
--- a/Documentation/block/inline-encryption.rst
+++ b/Documentation/block/inline-encryption.rst
@@ -185,9 +185,9 @@ blk-crypto-fallback is optional and is controlled by the
 API presented to users of the block layer
 =========================================
 
-``blk_crypto_config_supported()`` allows users to check ahead of time whether
+``__blk_crypto_config_supported()`` allows users to check ahead of time whether
 inline encryption with particular crypto settings will work on a particular
-request_queue -- either via hardware or via blk-crypto-fallback.  This function
+request_queue via hardware.  This function
 takes in a ``struct blk_crypto_config`` which is like blk_crypto_key, but omits
 the actual bytes of the key and instead just contains the algorithm, data unit
 size, etc.  This function can be useful if blk-crypto-fallback is disabled.
@@ -195,7 +195,7 @@ size, etc.  This function can be useful if blk-crypto-fallback is disabled.
 ``blk_crypto_init_key()`` allows users to initialize a blk_crypto_key.
 
 Users must call ``blk_crypto_start_using_key()`` before actually starting to use
-a blk_crypto_key on a request_queue (even if ``blk_crypto_config_supported()``
+a blk_crypto_key on a request_queue (even if ``__blk_crypto_config_supported()``
 was called earlier).  This is needed to initialize blk-crypto-fallback if it
 will be needed.  This must not be called from the data path, as this may have to
 allocate resources, which may deadlock in that case.
@@ -214,7 +214,7 @@ any kernel data structures it may be linked into.
 In summary, for users of the block layer, the lifecycle of a blk_crypto_key is
 as follows:
 
-1. ``blk_crypto_config_supported()`` (optional)
+1. ``__blk_crypto_config_supported()`` (optional)
 2. ``blk_crypto_init_key()``
 3. ``blk_crypto_start_using_key()``
 4. ``bio_crypt_set_ctx()`` (potentially many times)
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index a496aaef85ba4..887f08cb746d2 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -352,18 +352,6 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 	return 0;
 }
 
-/*
- * Check if bios with @cfg can be en/decrypted by blk-crypto (i.e. either the
- * request queue it's submitted to supports inline crypto, or the
- * blk-crypto-fallback is enabled and supports the cfg).
- */
-bool blk_crypto_config_supported(struct request_queue *q,
-				 const struct blk_crypto_config *cfg)
-{
-	return IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-	       __blk_crypto_cfg_supported(q->crypto_profile, cfg);
-}
-
 /**
  * blk_crypto_start_using_key() - Start using a blk_crypto_key on a device
  * @key: A key to use on the device
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 6b4c8094cc7b0..b062892cfbb6e 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -184,7 +184,7 @@ struct fscrypt_symlink_data {
 struct fscrypt_prepared_key {
 	struct crypto_skcipher *tfm;
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
-	struct fscrypt_blk_crypto_key *blk_key;
+	struct blk_crypto_key *blk_key;
 #endif
 };
 
@@ -335,7 +335,7 @@ void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf);
 
 /* inline_crypt.c */
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
-int fscrypt_select_encryption_impl(struct fscrypt_info *ci);
+void fscrypt_select_encryption_impl(struct fscrypt_info *ci);
 
 static inline bool
 fscrypt_using_inline_encryption(const struct fscrypt_info *ci)
@@ -372,9 +372,8 @@ fscrypt_is_key_prepared(struct fscrypt_prepared_key *prep_key,
 
 #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
-static inline int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
+static inline void fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 {
-	return 0;
 }
 
 static inline bool
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 90f3e68f166e3..b4e5d9e6f7223 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -21,28 +21,6 @@
 
 #include "fscrypt_private.h"
 
-struct fscrypt_blk_crypto_key {
-	struct blk_crypto_key base;
-	int num_devs;
-	struct request_queue *devs[];
-};
-
-static int fscrypt_get_num_devices(struct super_block *sb)
-{
-	if (sb->s_cop->get_num_devices)
-		return sb->s_cop->get_num_devices(sb);
-	return 1;
-}
-
-static void fscrypt_get_devices(struct super_block *sb, int num_devs,
-				struct request_queue **devs)
-{
-	if (num_devs == 1)
-		devs[0] = bdev_get_queue(sb->s_bdev);
-	else
-		sb->s_cop->get_devices(sb, devs);
-}
-
 static unsigned int fscrypt_get_dun_bytes(const struct fscrypt_info *ci)
 {
 	struct super_block *sb = ci->ci_inode->i_sb;
@@ -73,47 +51,48 @@ static unsigned int fscrypt_get_dun_bytes(const struct fscrypt_info *ci)
  * systems use just one implementation per mode, which makes these messages
  * helpful for debugging problems where the "wrong" implementation is used.
  */
-static void fscrypt_log_blk_crypto_impl(struct fscrypt_mode *mode,
-					struct request_queue **devs,
-					int num_devs,
-					const struct blk_crypto_config *cfg)
+bool fscrypt_blk_crypto_supported(struct block_device *bdev,
+				  struct fscrypt_mode *mode,
+				  const struct blk_crypto_config *cfg)
 {
-	int i;
+	if (__blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
+			cfg)) {
+		if (!xchg(&mode->logged_blk_crypto_native, 1)) {
+			pr_info("fscrypt: %s using blk-crypto (native)\n",
+				mode->friendly_name);
+		}
+		return true;
+	}
 
-	for (i = 0; i < num_devs; i++) {
-		if (!IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
-		    __blk_crypto_cfg_supported(devs[i]->crypto_profile, cfg)) {
-			if (!xchg(&mode->logged_blk_crypto_native, 1))
-				pr_info("fscrypt: %s using blk-crypto (native)\n",
-					mode->friendly_name);
-		} else if (!xchg(&mode->logged_blk_crypto_fallback, 1)) {
+	if (IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)) {
+		if (!xchg(&mode->logged_blk_crypto_fallback, 1)) {
 			pr_info("fscrypt: %s using blk-crypto-fallback\n",
 				mode->friendly_name);
 		}
+		return true;
 	}
+
+	return false;
 }
 
 /* Enable inline encryption for this file if supported. */
-int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
+void fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 {
 	const struct inode *inode = ci->ci_inode;
 	struct super_block *sb = inode->i_sb;
 	struct blk_crypto_config crypto_cfg;
-	int num_devs;
-	struct request_queue **devs;
-	int i;
 
 	/* The file must need contents encryption, not filenames encryption */
 	if (!S_ISREG(inode->i_mode))
-		return 0;
+		return;
 
 	/* The crypto mode must have a blk-crypto counterpart */
 	if (ci->ci_mode->blk_crypto_mode == BLK_ENCRYPTION_MODE_INVALID)
-		return 0;
+		return;
 
 	/* The filesystem must be mounted with -o inlinecrypt */
 	if (!(sb->s_flags & SB_INLINECRYPT))
-		return 0;
+		return;
 
 	/*
 	 * When a page contains multiple logically contiguous filesystem blocks,
@@ -126,7 +105,7 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 	if ((fscrypt_policy_flags(&ci->ci_policy) &
 	     FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) &&
 	    sb->s_blocksize != PAGE_SIZE)
-		return 0;
+		return;
 
 	/*
 	 * On all the filesystem's devices, blk-crypto must support the crypto
@@ -135,24 +114,17 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 	crypto_cfg.crypto_mode = ci->ci_mode->blk_crypto_mode;
 	crypto_cfg.data_unit_size = sb->s_blocksize;
 	crypto_cfg.dun_bytes = fscrypt_get_dun_bytes(ci);
-	num_devs = fscrypt_get_num_devices(sb);
-	devs = kmalloc_array(num_devs, sizeof(*devs), GFP_KERNEL);
-	if (!devs)
-		return -ENOMEM;
-	fscrypt_get_devices(sb, num_devs, devs);
 
-	for (i = 0; i < num_devs; i++) {
-		if (!blk_crypto_config_supported(devs[i], &crypto_cfg))
-			goto out_free_devs;
+	if (sb->s_cop->blk_crypto_supported) {
+		if (sb->s_cop->blk_crypto_supported(sb, ci->ci_mode,
+				&crypto_cfg))
+			ci->ci_inlinecrypt = true;
+	} else {
+		if (fscrypt_blk_crypto_supported(sb->s_bdev, ci->ci_mode,
+				&crypto_cfg))
+			ci->ci_inlinecrypt = true;
 	}
 
-	fscrypt_log_blk_crypto_impl(ci->ci_mode, devs, num_devs, &crypto_cfg);
-
-	ci->ci_inlinecrypt = true;
-out_free_devs:
-	kfree(devs);
-
-	return 0;
 }
 
 int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
@@ -162,20 +134,14 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 	const struct inode *inode = ci->ci_inode;
 	struct super_block *sb = inode->i_sb;
 	enum blk_crypto_mode_num crypto_mode = ci->ci_mode->blk_crypto_mode;
-	int num_devs = fscrypt_get_num_devices(sb);
-	int queue_refs = 0;
-	struct fscrypt_blk_crypto_key *blk_key;
+	struct blk_crypto_key *blk_key;
 	int err;
-	int i;
 
-	blk_key = kzalloc(struct_size(blk_key, devs, num_devs), GFP_KERNEL);
+	blk_key = kzalloc(sizeof(*blk_key), GFP_KERNEL);
 	if (!blk_key)
 		return -ENOMEM;
 
-	blk_key->num_devs = num_devs;
-	fscrypt_get_devices(sb, num_devs, blk_key->devs);
-
-	err = blk_crypto_init_key(&blk_key->base, raw_key, crypto_mode,
+	err = blk_crypto_init_key(blk_key, raw_key, crypto_mode,
 				  fscrypt_get_dun_bytes(ci), sb->s_blocksize);
 	if (err) {
 		fscrypt_err(inode, "error %d initializing blk-crypto key", err);
@@ -184,26 +150,17 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 
 	/*
 	 * We have to start using blk-crypto on all the filesystem's devices.
-	 * We also have to save all the request_queue's for later so that the
-	 * key can be evicted from them.  This is needed because some keys
-	 * aren't destroyed until after the filesystem was already unmounted
-	 * (namely, the per-mode keys in struct fscrypt_master_key).
 	 */
-	for (i = 0; i < num_devs; i++) {
-		if (!blk_get_queue(blk_key->devs[i])) {
-			fscrypt_err(inode, "couldn't get request_queue");
-			err = -EAGAIN;
-			goto fail;
-		}
-		queue_refs++;
-
-		err = blk_crypto_start_using_key(&blk_key->base,
-						 blk_key->devs[i]);
-		if (err) {
-			fscrypt_err(inode,
-				    "error %d starting to use blk-crypto", err);
-			goto fail;
-		}
+	if (sb->s_cop->blk_crypto_start_using_key)
+		err = sb->s_cop->blk_crypto_start_using_key(sb, blk_key);
+	else
+		err = blk_crypto_start_using_key(blk_key,
+				bdev_get_queue(sb->s_bdev));
+
+	if (err) {
+		fscrypt_err(inode,
+			    "error %d starting to use blk-crypto", err);
+		goto fail;
 	}
 	/*
 	 * Pairs with the smp_load_acquire() in fscrypt_is_key_prepared().
@@ -215,24 +172,29 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 	return 0;
 
 fail:
-	for (i = 0; i < queue_refs; i++)
-		blk_put_queue(blk_key->devs[i]);
 	kfree_sensitive(blk_key);
 	return err;
 }
 
 void fscrypt_destroy_inline_crypt_key(struct fscrypt_prepared_key *prep_key)
 {
-	struct fscrypt_blk_crypto_key *blk_key = prep_key->blk_key;
-	int i;
+	struct blk_crypto_key *blk_key = prep_key->blk_key;
+	/*
+	 * Some keys aren't destroyed until after the filesystem was already unmounted
+	 * (namely, the per-mode keys in struct fscrypt_master_key).
+	 *
+	 * XXX: how can we fix this?
+	 */
+	struct super_block *sb = NULL;
 
-	if (blk_key) {
-		for (i = 0; i < blk_key->num_devs; i++) {
-			blk_crypto_evict_key(blk_key->devs[i], &blk_key->base);
-			blk_put_queue(blk_key->devs[i]);
-		}
-		kfree_sensitive(blk_key);
-	}
+	if (!blk_key)
+		return;
+
+	if (sb->s_cop->blk_crypto_evict_key)
+		sb->s_cop->blk_crypto_evict_key(sb, blk_key);
+	else
+		blk_crypto_evict_key(bdev_get_queue(sb->s_bdev), blk_key);
+	kfree_sensitive(blk_key);
 }
 
 bool __fscrypt_inode_uses_inline_crypto(const struct inode *inode)
@@ -282,7 +244,7 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 	ci = inode->i_crypt_info;
 
 	fscrypt_generate_dun(ci, first_lblk, dun);
-	bio_crypt_set_ctx(bio, &ci->ci_enc_key.blk_key->base, dun, gfp_mask);
+	bio_crypt_set_ctx(bio, ci->ci_enc_key.blk_key, dun, gfp_mask);
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx);
 
@@ -369,7 +331,7 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 	 * uses the same pointer.  I.e., there's currently no need to support
 	 * merging requests where the keys are the same but the pointers differ.
 	 */
-	if (bc->bc_key != &inode->i_crypt_info->ci_enc_key.blk_key->base)
+	if (bc->bc_key != inode->i_crypt_info->ci_enc_key.blk_key)
 		return false;
 
 	fscrypt_generate_dun(inode->i_crypt_info, next_lblk, next_dun);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index c35711896bd4f..06ac0b9d170be 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -421,9 +421,7 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 	struct fscrypt_key_specifier mk_spec;
 	int err;
 
-	err = fscrypt_select_encryption_impl(ci);
-	if (err)
-		return err;
+	fscrypt_select_encryption_impl(ci);
 
 	err = fscrypt_policy_to_key_spec(&ci->ci_policy, &mk_spec);
 	if (err)
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 37221e94e5eff..599550e3e5f05 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2012 Samsung Electronics Co., Ltd.
  *             http://www.samsung.com/
  */
+#include <linux/blk-crypto.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
@@ -3004,23 +3005,59 @@ static void f2fs_get_ino_and_lblk_bits(struct super_block *sb,
 	*lblk_bits_ret = 8 * sizeof(block_t);
 }
 
-static int f2fs_get_num_devices(struct super_block *sb)
+static bool f2fs_blk_crypto_supported(struct super_block *sb,
+		struct fscrypt_mode *mode, struct blk_crypto_config *cfg)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	int i;
+
+	if (!f2fs_is_multi_device(sbi))
+		return fscrypt_blk_crypto_supported(sb->s_bdev, mode, cfg);
 
-	if (f2fs_is_multi_device(sbi))
-		return sbi->s_ndevs;
-	return 1;
+	for (i = 0; i < sbi->s_ndevs; i++)
+		if (!fscrypt_blk_crypto_supported(FDEV(i).bdev, mode, cfg))
+			return false;
+	return true;
 }
 
-static void f2fs_get_devices(struct super_block *sb,
-			     struct request_queue **devs)
+static int f2fs_blk_crypto_start_using_key(struct super_block *sb,
+		struct blk_crypto_key *key)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	int ret, i;
+
+	if (!f2fs_is_multi_device(sbi)) {
+		return blk_crypto_start_using_key(key,
+			bdev_get_queue(sb->s_bdev));
+	}
+
+	for (i = 0; i < sbi->s_ndevs; i++) {
+		ret = blk_crypto_start_using_key(key, 
+			bdev_get_queue(FDEV(i).bdev));
+		if (ret)
+			goto fail;
+	}
+
+	return 0;
+fail:
+	while (--i >= 0)
+		blk_crypto_evict_key(bdev_get_queue(FDEV(i).bdev), key);
+	return ret;
+}
+	
+static void f2fs_blk_crypto_evict_key(struct super_block *sb,
+		struct blk_crypto_key *key)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 	int i;
 
+	if (!f2fs_is_multi_device(sbi)) {
+		blk_crypto_evict_key(bdev_get_queue(sb->s_bdev), key);
+		return;
+	}
+
 	for (i = 0; i < sbi->s_ndevs; i++)
-		devs[i] = bdev_get_queue(FDEV(i).bdev);
+		blk_crypto_evict_key(bdev_get_queue(FDEV(i).bdev), key);
 }
 
 static const struct fscrypt_operations f2fs_cryptops = {
@@ -3031,8 +3068,10 @@ static const struct fscrypt_operations f2fs_cryptops = {
 	.empty_dir		= f2fs_empty_dir,
 	.has_stable_inodes	= f2fs_has_stable_inodes,
 	.get_ino_and_lblk_bits	= f2fs_get_ino_and_lblk_bits,
-	.get_num_devices	= f2fs_get_num_devices,
-	.get_devices		= f2fs_get_devices,
+	.blk_crypto_supported	= f2fs_blk_crypto_supported,
+	.blk_crypto_start_using_key = f2fs_blk_crypto_start_using_key,
+	.blk_crypto_evict_key	= f2fs_blk_crypto_evict_key,
+
 };
 #endif
 
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 69b24fe92cbf1..541fc781c60a5 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -100,9 +100,6 @@ int blk_crypto_start_using_key(const struct blk_crypto_key *key,
 int blk_crypto_evict_key(struct request_queue *q,
 			 const struct blk_crypto_key *key);
 
-bool blk_crypto_config_supported(struct request_queue *q,
-				 const struct blk_crypto_config *cfg);
-
 #else /* CONFIG_BLK_INLINE_ENCRYPTION */
 
 static inline bool bio_has_crypt_ctx(struct bio *bio)
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index e60d57c99cb6f..5db1defa2ce00 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -30,8 +30,11 @@
  */
 #define FSCRYPT_CONTENTS_ALIGNMENT 16
 
+struct blk_crypto_config;
+struct blk_crypto_key;
 union fscrypt_policy;
 struct fscrypt_info;
+struct fscrypt_mode;
 struct fs_parameter;
 struct seq_file;
 
@@ -161,24 +164,27 @@ struct fscrypt_operations {
 				      int *ino_bits_ret, int *lblk_bits_ret);
 
 	/*
-	 * Return the number of block devices to which the filesystem may write
-	 * encrypted file contents.
-	 *
-	 * If the filesystem can use multiple block devices (other than block
-	 * devices that aren't used for encrypted file contents, such as
-	 * external journal devices), and wants to support inline encryption,
-	 * then it must implement this function.  Otherwise it's not needed.
+	 * Must call fscrypt_blk_crypto_supported() on all block devices used
+	 * by the file system.
+	 * Required if the file system uses multiple block devices.
 	 */
-	int (*get_num_devices)(struct super_block *sb);
+	bool (*blk_crypto_supported)(struct super_block *sb,
+				     struct fscrypt_mode *mode,
+				     struct blk_crypto_config *cfg);
 
 	/*
-	 * If ->get_num_devices() returns a value greater than 1, then this
-	 * function is called to get the array of request_queues that the
-	 * filesystem is using -- one per block device.  (There may be duplicate
-	 * entries in this array, as block devices can share a request_queue.)
+	 * Start using @key on all block device uses by the file system.
+	 * Required if the file system uses multiple block devices.
+	 */
+	int (*blk_crypto_start_using_key)(struct super_block *sb,
+					  struct blk_crypto_key *key);
+	
+	/*
+	 * Evict @key from all block device uses by the file system.
+	 * Required if the file system uses multiple block devices.
 	 */
-	void (*get_devices)(struct super_block *sb,
-			    struct request_queue **devs);
+	void (*blk_crypto_evict_key)(struct super_block *sb,
+					  struct blk_crypto_key *key);
 };
 
 static inline struct fscrypt_info *fscrypt_get_info(const struct inode *inode)
@@ -379,6 +385,11 @@ static inline void fscrypt_set_ops(struct super_block *sb,
 {
 	sb->s_cop = s_cop;
 }
+
+/* inline_crypt.c */
+bool fscrypt_blk_crypto_supported(struct block_device *bdev,
+				  struct fscrypt_mode *mode,
+				  const struct blk_crypto_config *cfg);
 #else  /* !CONFIG_FS_ENCRYPTION */
 
 static inline struct fscrypt_info *fscrypt_get_info(const struct inode *inode)
-- 
2.30.2

