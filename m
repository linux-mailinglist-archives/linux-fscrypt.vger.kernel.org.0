Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E9A2DD3B6
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 16:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgLQPF2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 10:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727660AbgLQPF1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 10:05:27 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54285C0617B0
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 07:04:47 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id c3so7789716pgq.16
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 07:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=vImsZiFdTHwkHvYcMVg9vkl4TS9ilxgm2hcpSKGUI6o=;
        b=EuvNwY3rCeWO5HYtJrYL4Y77B+kKQrU+xPDGZUssXoasZNrW4MFoUbntCZXDQHydgM
         cAiW1QFNaeJi3gXhq9+8GpgHcsRzE6LiPz1/6ua6/n3YP4/NoV8LoBTTIXmr6OGC2VPe
         Xb/Izr25I2HjkhB5ZywHvlH9Q/gSEBEFPxh8KEB0vohoNzlSZ7NLxJ9FFS/EG/FEYfHv
         4iQA9kux469iusWYTfyLvD/FmO3sIjYB3FfSTz64g50SdFYZYWdFnfpBm6xTWwm88Iq0
         /173QfX2QijUxkY0KohQrUxpynvoB7BHr0sBnLqIU1uxj24afDQAE0Cj6YNLY0BFFn0M
         DpiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vImsZiFdTHwkHvYcMVg9vkl4TS9ilxgm2hcpSKGUI6o=;
        b=NejqHBtYvGieJZ8aTzN+ms/4RKxXomee0slQ+vic+6S2+VQlBe17UVukieqkrWaGl+
         70zxFT/xvgfJ6KbkGijn2ELXKnXF38/2vxrNN89OUsTHhwxGFJa58awV+UDlkrJfbgPq
         AZ+r7ID9VIUrXP2tFqNCamnLsJnZcn5fDnHumIJooadKPdeuYrwRjzZ+HgsVazJbzgjA
         XoTrn8nmo9DMtLXKFB8vovhHyVT4LkfbF4ku+fuBdwIXfNdjxe7rrWTBb+NyAzTHnxoI
         xL+XSW5G8E9dgtw43CWqyqFQMLc2v9ly4n5N9L5SkrWADjn/Rl2m6jll3ZCxqj98Wg8c
         K8ww==
X-Gm-Message-State: AOAM532A1BJIsBZwIxgV3g28CAXkivSmGFm0zfTZ8evzlrcPAwpEO/eZ
        0SpdnF3763PU4WJ5HhW2uO19FhtA5x4=
X-Google-Smtp-Source: ABdhPJzqNWRRkleWOjCheiehg+lSY+hNLM17V3/Joig5Hn4L2LfKC8xk88VBvI1LMpMdXp4yHJclGkJNokU=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a62:c312:0:b029:1a9:19c7:a8e with SMTP id
 v18-20020a62c3120000b02901a919c70a8emr6575809pfg.74.1608217486744; Thu, 17
 Dec 2020 07:04:46 -0800 (PST)
Date:   Thu, 17 Dec 2020 15:04:33 +0000
In-Reply-To: <20201217150435.1505269-1-satyat@google.com>
Message-Id: <20201217150435.1505269-2-satyat@google.com>
Mime-Version: 1.0
References: <20201217150435.1505269-1-satyat@google.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH v2 1/3] fscrypt, f2fs: replace fscrypt_get_devices with fscrypt_get_device
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
index c57bebfa48fe..8234217b42f4 100644
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
-	devs = kmalloc_array(num_devs, sizeof(*devs), GFP_KERNEL);
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
 
@@ -140,9 +136,6 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 	if (!blk_key)
 		return -ENOMEM;
 
-	blk_key->num_devs = num_devs;
-	fscrypt_get_devices(sb, num_devs, blk_key->devs);
-
 	err = blk_crypto_init_key(&blk_key->base, raw_key, crypto_mode,
 				  fscrypt_get_dun_bytes(ci), sb->s_blocksize);
 	if (err) {
@@ -157,8 +150,10 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
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
index 00eff2f51807..4872973d7a22 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2538,14 +2538,18 @@ static int f2fs_get_num_devices(struct super_block *sb)
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
@@ -2558,7 +2562,7 @@ static const struct fscrypt_operations f2fs_cryptops = {
 	.has_stable_inodes	= f2fs_has_stable_inodes,
 	.get_ino_and_lblk_bits	= f2fs_get_ino_and_lblk_bits,
 	.get_num_devices	= f2fs_get_num_devices,
-	.get_devices		= f2fs_get_devices,
+	.get_device		= f2fs_get_device,
 };
 #endif
 
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index a8f7a43f031b..a7d1af4932aa 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -68,8 +68,8 @@ struct fscrypt_operations {
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
2.29.2.729.g45daf8777d-goog

