Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4676E2830F0
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 Oct 2020 09:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgJEHgV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Oct 2020 03:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJEHgS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Oct 2020 03:36:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69DBC0613CE
        for <linux-fscrypt@vger.kernel.org>; Mon,  5 Oct 2020 00:36:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d15so9049287ybk.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 05 Oct 2020 00:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=+f82j/3GlQU62Y+UZX8Y8sm58itldJWXgxM/FZt85xk=;
        b=a+/jJaTTU96Kl2L3e8OrrWdHr+OeqqOVvfjVHr7exfq0mYagEabyuFkeH1edmSYUio
         iO1flJe0v7aQmci2hmcQcxy0csarT7zJCvNK0vBXsSjH+mBq8iRt9uwBNQIGSsggGBtu
         kiD8XIRgunHpbeTHY2IrThmrDGDGheQj/xhPHg1hVuJOZOtn/LSpSGsV0QFEtA1FBpK0
         hI26d2U0BrBEr6f6ocgT5kBwIahP2deWttKPvE7akKTBL6hwmoP/xm/DUQKQ0h47UVRd
         9ntNvM0LQd58/HDvR0Yuhw8s1bhbYFOEbQPQPm7kag+HoRS9gP6a6ECLBiO/4/PbHzRq
         u9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+f82j/3GlQU62Y+UZX8Y8sm58itldJWXgxM/FZt85xk=;
        b=ra8zLm3qa7y9aQTW+Hreyg71E/MfPJWU0hM3eue/YndIkEefTzdZrMx6FQD4TS7nT6
         4GFIwlJNj2WsTdldxAmPoc4n/Jnusbgl/sZCzb+bRuYB9ArK14ziyZ/rP0vLdBF5zCfA
         7/g4HCcVG5REK1eP7gV0Ddh/PtdDRngunyubFtuSjIbu/DxvEOeb5itTDYyU+xn8KtpT
         XSLoIq65NPUQ+VPdMj1YEbLRRk8JKHMpASjmjqCB48Nax5L0STTEqJGLdzerzTn/HNE/
         viW/LNVDXtKNaJDC5/OvvQfke6BuYsvJ+Mi4Vt1huApMn5Zj3qFCocFt+gKhvxZZQrMQ
         cBug==
X-Gm-Message-State: AOAM531Xr7u5OQ/Z7HVnbWiNxGLVUmTm9gCloY5AbtgA2SUjSjUNpmc2
        iEXe0aMvh++ihTrSc6NjvSIk9KEFa9E=
X-Google-Smtp-Source: ABdhPJwkz/io1x0y+WIuy1g8ndag+QHgzZX9J3u1S7xLPdsLKURB4BMyOE+QUxPwR3tjcapzSV74oh2t+3E=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a25:454:: with SMTP id 81mr16674210ybe.297.1601883375806;
 Mon, 05 Oct 2020 00:36:15 -0700 (PDT)
Date:   Mon,  5 Oct 2020 07:36:04 +0000
In-Reply-To: <20201005073606.1949772-1-satyat@google.com>
Message-Id: <20201005073606.1949772-2-satyat@google.com>
Mime-Version: 1.0
References: <20201005073606.1949772-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH 1/3] fscrypt, f2fs: replace fscrypt_get_devices with fscrypt_get_device
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The new function takes the super_block and the index of a device, and
returns the request_queue of the device at that index (whereas the old
function would take a pointer to an array of request_queues and fill them
all up). This allows callers to avoid allocating an array of request_queues
in some cases (when they don't need the array for anything else).

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/crypto/inline_crypt.c | 33 ++++++++++++++-------------------
 fs/f2fs/super.c          | 16 ++++++++++------
 include/linux/fscrypt.h  |  4 ++--
 3 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index faa25541ccb6..5bbce79df638 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -33,13 +33,15 @@ static int fscrypt_get_num_devices(struct super_block *sb)
 	return 1;
 }
 
-static void fscrypt_get_devices(struct super_block *sb, int num_devs,
-				struct request_queue **devs)
+static struct request_queue *fscrypt_get_device(struct super_block *sb,
+						unsigned int device_index)
 {
-	if (num_devs == 1)
-		devs[0] = bdev_get_queue(sb->s_bdev);
+	if (sb->s_cop->get_device)
+		return sb->s_cop->get_device(sb, device_index);
+	else if (WARN_ON_ONCE(device_index != 0))
+		return NULL;
 	else
-		sb->s_cop->get_devices(sb, devs);
+		return bdev_get_queue(sb->s_bdev);
 }
 
 static unsigned int fscrypt_get_dun_bytes(const struct fscrypt_info *ci)
@@ -70,7 +72,7 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 	struct super_block *sb = inode->i_sb;
 	struct blk_crypto_config crypto_cfg;
 	int num_devs;
-	struct request_queue **devs;
+	struct request_queue *dev;
 	int i;
 
 	/* The file must need contents encryption, not filenames encryption */
@@ -106,20 +108,14 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 	crypto_cfg.data_unit_size = sb->s_blocksize;
 	crypto_cfg.dun_bytes = fscrypt_get_dun_bytes(ci);
 	num_devs = fscrypt_get_num_devices(sb);
-	devs = kmalloc_array(num_devs, sizeof(*devs), GFP_NOFS);
-	if (!devs)
-		return -ENOMEM;
-	fscrypt_get_devices(sb, num_devs, devs);
 
 	for (i = 0; i < num_devs; i++) {
-		if (!blk_crypto_config_supported(devs[i], &crypto_cfg))
-			goto out_free_devs;
+		dev = fscrypt_get_device(sb, i);
+		if (!dev || !blk_crypto_config_supported(dev, &crypto_cfg))
+			return 0;
 	}
 
 	ci->ci_inlinecrypt = true;
-out_free_devs:
-	kfree(devs);
-
 	return 0;
 }
 
@@ -141,9 +137,6 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 	if (!blk_key)
 		return -ENOMEM;
 
-	blk_key->num_devs = num_devs;
-	fscrypt_get_devices(sb, num_devs, blk_key->devs);
-
 	err = blk_crypto_init_key(&blk_key->base, raw_key, crypto_mode,
 				  fscrypt_get_dun_bytes(ci), sb->s_blocksize);
 	if (err) {
@@ -158,8 +151,10 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 	 * aren't destroyed until after the filesystem was already unmounted
 	 * (namely, the per-mode keys in struct fscrypt_master_key).
 	 */
+	blk_key->num_devs = num_devs;
 	for (i = 0; i < num_devs; i++) {
-		if (!blk_get_queue(blk_key->devs[i])) {
+		blk_key->devs[i] = fscrypt_get_device(sb, i);
+		if (!blk_key->devs[i] || !blk_get_queue(blk_key->devs[i])) {
 			fscrypt_err(inode, "couldn't get request_queue");
 			err = -EAGAIN;
 			goto fail;
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index dfa072fa8081..9a6d375cbe4b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2509,14 +2509,18 @@ static int f2fs_get_num_devices(struct super_block *sb)
 	return 1;
 }
 
-static void f2fs_get_devices(struct super_block *sb,
-			     struct request_queue **devs)
+static struct request_queue *f2fs_get_device(struct super_block *sb,
+					     unsigned int device_index)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
-	int i;
 
-	for (i = 0; i < sbi->s_ndevs; i++)
-		devs[i] = bdev_get_queue(FDEV(i).bdev);
+	if (WARN_ON_ONCE(device_index >= f2fs_get_num_devices(sb)))
+		return NULL;
+
+	if (!f2fs_is_multi_device(sbi))
+		return bdev_get_queue(sb->s_bdev);
+
+	return bdev_get_queue(FDEV(device_index).bdev);
 }
 
 static const struct fscrypt_operations f2fs_cryptops = {
@@ -2529,7 +2533,7 @@ static const struct fscrypt_operations f2fs_cryptops = {
 	.has_stable_inodes	= f2fs_has_stable_inodes,
 	.get_ino_and_lblk_bits	= f2fs_get_ino_and_lblk_bits,
 	.get_num_devices	= f2fs_get_num_devices,
-	.get_devices		= f2fs_get_devices,
+	.get_device		= f2fs_get_device,
 };
 #endif
 
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 991ff8575d0e..d835fd19a20a 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -70,8 +70,8 @@ struct fscrypt_operations {
 	void (*get_ino_and_lblk_bits)(struct super_block *sb,
 				      int *ino_bits_ret, int *lblk_bits_ret);
 	int (*get_num_devices)(struct super_block *sb);
-	void (*get_devices)(struct super_block *sb,
-			    struct request_queue **devs);
+	struct request_queue *(*get_device)(struct super_block *sb,
+					    unsigned int dev_index);
 };
 
 static inline struct fscrypt_info *fscrypt_get_info(const struct inode *inode)
-- 
2.28.0.806.g8561365e88-goog

