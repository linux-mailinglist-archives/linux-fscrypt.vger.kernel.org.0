Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B702B616239
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 12:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiKBLyE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 07:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbiKBLxg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 07:53:36 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998DDBD1;
        Wed,  2 Nov 2022 04:53:35 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 0B2C781462;
        Wed,  2 Nov 2022 07:53:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1667390015; bh=Jzf2meALQNwbu6QzJ4+dSLFPhD/DJS2tyJYuVKeMWWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTM7ZFyGslVlRBtooHK3AFRm6XB8Omg9S1Q8dpW7hO90eSEGx6tp7k3CpIxNw7msJ
         R+H4mbyw9eFAr8jrPvyjIUZg8vMLszODtwcuTFk+E0tz0U7EZXInxhu+fKYPxlalZW
         1u+P+ip4A7tPvPRD8CzD9F9nCNlDFHzydGyQ3dtRgX0yHPAo7EXcIoHlH2EpADtEaL
         ei0n8ccDxH/XHkZt5wRzj5+EMjmoyIKfzoCuH/+7c7kPH9ox/lx5GCKVrzt4tQWesu
         GdoDrrfYG9T7BpGN1IzG4UYCkNQsMeBLFB/o55lzqwuLqwWt3mAaBLwp9j+Nj1uh0g
         gKJPF4ShZikVw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v5 14/18] btrfs: implement fscrypt ioctls
Date:   Wed,  2 Nov 2022 07:53:03 -0400
Message-Id: <83b95b5a864fa17384b21b26d080813151f9cb6c.1667389115.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1667389115.git.sweettea-kernel@dorminy.me>
References: <cover.1667389115.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

These ioctls allow encryption to actually be used.

The set_encryption_policy ioctl is the thing which actually turns on
encryption, and therefore sets the ENCRYPT flag in the superblock. This
prevents the filesystem from being loaded on older kernels.

fscrypt provides CONFIG_FS_ENCRYPTION-disabled versions of all these
functions which just return -EOPNOTSUPP, so the ioctls don't need to be
compiled out if CONFIG_FS_ENCRYPTION isn't enabled.

We could instead gate this ioctl on the superblock having the flag set,
if we wanted to require mkfs with the encrypt flag in order to have a
filesystem with any encryption.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/ioctl.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a40025e18216..9869a26e36ad 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4557,6 +4557,34 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_fslabel(fs_info, argp);
 	case FS_IOC_SETFSLABEL:
 		return btrfs_ioctl_set_fslabel(file, argp);
+	case FS_IOC_SET_ENCRYPTION_POLICY: {
+		if (!IS_ENABLED(CONFIG_FS_ENCRYPTION))
+			return -EOPNOTSUPP;
+		if (sb_rdonly(fs_info->sb))
+			return -EROFS;
+		/*
+		 *  If we crash before we commit, nothing encrypted could have
+		 * been written so it doesn't matter whether the encrypted
+		 * state persists.
+		 */
+		btrfs_set_fs_incompat(fs_info, ENCRYPT);
+		return fscrypt_ioctl_set_policy(file, (const void __user *)arg);
+	}
+	case FS_IOC_GET_ENCRYPTION_POLICY:
+		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+		return fscrypt_ioctl_get_policy_ex(file, (void __user *)arg);
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+		return fscrypt_ioctl_add_key(file, (void __user *)arg);
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+		return fscrypt_ioctl_remove_key(file, (void __user *)arg);
+	case FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS:
+		return fscrypt_ioctl_remove_key_all_users(file,
+							  (void __user *)arg);
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
+		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
+	case FS_IOC_GET_ENCRYPTION_NONCE:
+		return fscrypt_ioctl_get_nonce(file, (void __user *)arg);
 	case FITRIM:
 		return btrfs_ioctl_fitrim(fs_info, argp);
 	case BTRFS_IOC_SNAP_CREATE:
-- 
2.37.3

