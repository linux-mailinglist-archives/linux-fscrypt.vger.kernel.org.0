Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984055ADC84
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Sep 2022 02:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiIFAgW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Sep 2022 20:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiIFAgU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Sep 2022 20:36:20 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171D06A4A8;
        Mon,  5 Sep 2022 17:36:17 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 6CB93803C8;
        Mon,  5 Sep 2022 20:36:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662424577; bh=1njMgtLMCKXOazQmPtODjiDRbsI7pkHmvUqzqv2QlzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLl6XHHXZEOC7+yXnJk9vm158tW3yVanxuBp90+1t715oUoj3it0Y667AVpqdmZtN
         KT0OZuqGyKi8qAEI0ZD7+KE6WKqlDaSAGENzlYFZ0p/gxl5AoOAljomNds7Xk452a5
         331hJyaq5+lawr/3mA3Iecef46Dq5Q5XOvyRd/se6k8U3Vs69p43ACeOPPOx46D9vO
         ZmQPOz7n651yHf4U+uuFfrctCjrz7GRPbc6LEAcElpzX/0BFmH3KsbvNkvTRG+Rg7m
         T8MF3ZypyzNYMgftT+km4+t/zLZpo56sWK6H7VEPkI16xGXI4RYddsWybzKDH4WrTZ
         OSEqn6uXW7X0Q==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 20/20] btrfs: implement fscrypt ioctls
Date:   Mon,  5 Sep 2022 20:35:35 -0400
Message-Id: <e7dd2cb0f4eef391566e1e60f05136244a288693.1662420177.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1662420176.git.sweettea-kernel@dorminy.me>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
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

From: Omar Sandoval <osandov@osandov.com>

These ioctls allow encryption to be set up.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/ioctl.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 708e514aca25..ea1c14b26206 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5457,6 +5457,34 @@ long btrfs_ioctl(struct file *file, unsigned int
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
+		btrfs_set_fs_incompat(fs_info, FSCRYPT);
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
2.35.1

