Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D62F755A4A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 05:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjGQDxY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 23:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjGQDxK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 23:53:10 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863841B7;
        Sun, 16 Jul 2023 20:53:09 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 1470183433;
        Sun, 16 Jul 2023 23:53:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689565989; bh=Ix6KGuk1iMQP/w95hZZjqSi+NZP+gEMNU+gj2LuE0ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkrPjkILU6yzYlqHADKX4HznPS9iFtDfCsG6yUjd/40ayG17UYGMunm9CzncbsyNi
         687VpjjFFYMvgnILc31pHzloanFeB9JlHl5dQK+Xv2bNxNvPkRFVkbsMmfl591/yVI
         7X/35jkx3ukCJ3A4kzMNJH2RGXGZr13pCmoKc7hiVgvcrImKxA1UI6l+qbK0wvTvou
         OAXpZzoVVNdIwr9arot0y6YIMoRvLwr78HlfthSu7VbtP6qyI+SDzCuslL6+jZFlzw
         /yaXErcu6HJrMjJBvs+nkhkRtx4owvWDhhQTcrfFNAPGrzGyT5TrjoU7uNAzrfz1jd
         QMy2QoT76c84g==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 11/17] btrfs: add get_devices hook for fscrypt
Date:   Sun, 16 Jul 2023 23:52:42 -0400
Message-Id: <4fb0338787fec0233075a2bff7014f5f34342445.1689564024.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1689564024.git.sweettea-kernel@dorminy.me>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Since extent encryption requires inline encryption, even though we
expect to use the inlinecrypt software fallback most of the time, we
need to enumerate all the devices in use by btrfs.

I'm not sure this is the correct list of active devices and it isn't
tested with any multi-device test yet.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/fscrypt.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index e03157c367a2..6875108f4363 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -11,7 +11,9 @@
 #include "ioctl.h"
 #include "messages.h"
 #include "root-tree.h"
+#include "super.h"
 #include "transaction.h"
+#include "volumes.h"
 #include "xattr.h"
 
 /*
@@ -164,9 +166,46 @@ static bool btrfs_fscrypt_empty_dir(struct inode *inode)
 	return inode->i_size == BTRFS_EMPTY_DIR_SIZE;
 }
 
+static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
+						       unsigned int *num_devs)
+{
+	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	int nr_devices = fs_devices->open_devices;
+
+	struct block_device **devs;
+	struct btrfs_device *device;
+	int i = 0;
+
+	devs = kmalloc_array(nr_devices, sizeof(*devs), GFP_KERNEL);
+	if (!devs)
+		return ERR_PTR(-ENOMEM);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(device, &fs_devices->devices, dev_list) {
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+						&device->dev_state) ||
+		    !device->bdev ||
+		    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state))
+			continue;
+
+		devs[i++] = device->bdev;
+
+		if (i >= nr_devices)
+			break;
+
+	}
+	rcu_read_unlock();
+
+
+	*num_devs = i;
+	return devs;
+}
+
 const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.get_context = btrfs_fscrypt_get_context,
 	.set_context = btrfs_fscrypt_set_context,
 	.empty_dir = btrfs_fscrypt_empty_dir,
+	.get_devices = btrfs_fscrypt_get_devices,
 	.key_prefix = "btrfs:"
 };
-- 
2.40.1

