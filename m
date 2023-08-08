Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159A17743D9
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbjHHSK5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbjHHSK2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:10:28 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FF51B065;
        Tue,  8 Aug 2023 10:12:41 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 7528583442;
        Tue,  8 Aug 2023 13:12:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514761; bh=rWirf37iqZkz5t+gTTLXe5NpdCjOHBl1ebtWn28/poY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/G/J2WlsNju2isdv2I72IEHomsxz1ozmFiP2I066GUdAyVzePy/5FlGtqeO3D8lq
         ViiT3t2ZyNtwP6gJHQClzHTzGsS1/A0jEtF25lQ3sUqImCJrkGCo93ePnKwDD83iwk
         gL86tFRyq0Fle9hbnR+DY3rODDd1K7fOCTyJSg2xE6NeLxbEWwraG6j/weuhOz+/n1
         L7rrriPccLRyZHhH/GwurNBjrs7pd/4CAHDyWjEvb14b+fn6ZbxLPKBazOoTDmhM8F
         zDxhONZTCPVo3vwQCVbdPRVJDaDa6BiCMzlGkE7pAohygMUJwuvMiQYHsK+n+jBCyb
         XEEqBlJ0czp1g==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 11/17] btrfs: add get_devices hook for fscrypt
Date:   Tue,  8 Aug 2023 13:12:13 -0400
Message-ID: <c985780df51bcc4394a695c087f0b18861f28ae9.1691510179.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691510179.git.sweettea-kernel@dorminy.me>
References: <cover.1691510179.git.sweettea-kernel@dorminy.me>
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

Since extent encryption requires inline encryption, even though we
expect to use the inlinecrypt software fallback most of the time, we
need to enumerate all the devices in use by btrfs.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/fscrypt.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index bdd58415f93c..499073376110 100644
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
@@ -179,9 +181,44 @@ static bool btrfs_fscrypt_empty_dir(struct inode *inode)
 	return inode->i_size == BTRFS_EMPTY_DIR_SIZE;
 }
 
+static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
+						       unsigned int *num_devs)
+{
+	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	int nr_devices = fs_devices->open_devices;
+	struct block_device **devs;
+	struct btrfs_device *device;
+	int i = 0;
+
+	devs = kmalloc_array(nr_devices, sizeof(*devs), GFP_NOFS | GFP_NOWAIT);
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
2.41.0

