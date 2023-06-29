Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4831741D30
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjF2AgN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjF2AgH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:36:07 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAA22979;
        Wed, 28 Jun 2023 17:36:05 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id CF53080794;
        Wed, 28 Jun 2023 20:36:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998965; bh=Gsyo6UI5OxD1zrZt4kHcLSsHKxT2/RB4lv7sLpxhsWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7m63AHfRANuFOPqcyRSwRKoGKzDfQ3yfQiCPJ1KdhyrW28W4wUAcvF5AdnQaFcba
         2OgYnPAYmcqWd7dFeIoTXq39zuDTvUxlsoHE6PbH2/ziUH2Jl8zJYZ7JCshiNWJ0m2
         HsrQVemHlEGXnAPjz+2OWT65mTlPL2hOysMQvP+d4x9JqzRKuTE9TN5P9GXyHqxhOU
         lO4pvWDP+vQlb5JsALHfcBE10dPFeGKN3lrqHl10cWXJqKnCedK4nN5mRbWFCnHo5C
         zEnaJZufzc6Vo7xJIMzn8381kbFiXjr212sjwouD1ThD0Tro58AZxaVCdb52WFI6is
         PWdgcliKO1SuA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 11/17] btrfs: add get_devices hook for fscrypt
Date:   Wed, 28 Jun 2023 20:35:34 -0400
Message-Id: <2a8b091cdb0993ad1cc618643e6df49d1aac9045.1687988380.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988380.git.sweettea-kernel@dorminy.me>
References: <cover.1687988380.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 fs/btrfs/fscrypt.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 20727d920841..658a67856de6 100644
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
@@ -162,9 +164,37 @@ static bool btrfs_fscrypt_empty_dir(struct inode *inode)
 	return inode->i_size == BTRFS_EMPTY_DIR_SIZE;
 }
 
+static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
+						       unsigned int *num_devs)
+{
+	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct block_device **devs;
+	struct btrfs_device *device;
+	int i;
+
+	devs = kmalloc_array(fs_devices->num_devices, sizeof(*devs),
+		GFP_KERNEL);
+	if (!devs)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	i = 0;
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
+			continue;
+
+		devs[i++] = device->bdev;
+	}
+	mutex_unlock(&fs_devices->device_list_mutex);
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

