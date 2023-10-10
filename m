Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A1E7C4181
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbjJJUlb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343780AbjJJUl1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:27 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41716B9
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:23 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-5a7be61fe74so15049427b3.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970482; x=1697575282; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SgLb5y9ux6Y3nH3Dpo6jruzdTCArFvbtPwPabW0o0qU=;
        b=2Iu0cM8G9QNZ8DoQmhBTP0J+823ugjyqTenoB9xu5A/DYaPOont2cSXwjVcIlOtKzC
         O5wuwepD8ibSHGzAzB/1v9dNymNJwfxJcDx0MkXuxqIJBCD9l2Wd99oxY5q5AP4D9h6v
         Qm+IuOYiKy22JckzYPiKTiJ9k8rY+gLkeLkbR3qrY6ZOi3AWfBiTD+lL8Tjba5KCpEdr
         P1m814xJk0OQIW0ub6HU5GzZsuLHQFY6aFbISTKJ/WM3kwR73YYPAtiVgq5YOGrvgUVC
         GaEz895+B9Iqwbnp8PXgzx1gdCDTBkP2fdFaB9MEHZdya95NN1SgZ6p0d0spXLzWSbK+
         KOZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970482; x=1697575282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SgLb5y9ux6Y3nH3Dpo6jruzdTCArFvbtPwPabW0o0qU=;
        b=kvHf0pZ6vOTG8P5v56nKWgz0oRXfadgRGw8fHGEInxkbUtaVO97he5HfVPF1cc2fAv
         +bd1CMcWYaRqojSkXOzQSHTOeRtmfwMMiRC0bpnUGHzRh3j5KHweJhAdUT3pyoWKAJ/x
         RU2/mkBEytUC4k46tLYtPQC0wtxHh0ZWRHrDoJNgdSSVX4m5DGyUMi9x25yutgRPnmbx
         6IG31cMrRTyiu66OFijOSO0BoHWW2lyu9jOWoprrQN1a+u8QQLk7PVs8Nc/PcLZAeWCy
         8StmwKQkZYE7I1QnzaMQp0DNVHwoEdKaEuIh9n8OkeOUT4DA9/ezFPt2QHMjf/lwZFvn
         FxRQ==
X-Gm-Message-State: AOJu0Yw670e9AE+TPvWKoEc+I6KcDHU0FPMzsKs8+KbEKM/2ldHR7OfF
        y1kDR8zZznW+dHrPqWgwZ2Flox5h58zxpi/jNbvEvg==
X-Google-Smtp-Source: AGHT+IHYW6Z9cFRYt8h0d7OoJLV4IK4K2kTHi6uHVrPXFZJKKfKaqyzfW7wtSaTlT2rqqqoFYHU/tQ==
X-Received: by 2002:a81:c246:0:b0:57a:8ecb:11ad with SMTP id t6-20020a81c246000000b0057a8ecb11admr22346857ywg.43.1696970482248;
        Tue, 10 Oct 2023 13:41:22 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id q6-20020a815c06000000b00592548b2c47sm4655990ywb.80.2023.10.10.13.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:21 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 16/36] btrfs: implement fscrypt ioctls
Date:   Tue, 10 Oct 2023 16:40:31 -0400
Message-ID: <b8a1f317f709155961e154b3dc1438a96b01a528.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ioctl.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1f1506280619..5938adb64409 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4575,6 +4575,34 @@ long btrfs_ioctl(struct file *file, unsigned int
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
2.41.0

