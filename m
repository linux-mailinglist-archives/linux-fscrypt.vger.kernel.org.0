Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6C47AF22F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbjIZSDk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbjIZSDi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:38 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9FF126
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:31 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-773ac11de71so587830485a.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751410; x=1696356210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NtWGC2dr4Dt18NXh3XbNn734FYbuI4TsF3KP5ThfnrU=;
        b=FuTaIINx90YcGXaXRierRNtlcwjW13mASR3wXUdskSmcRdPy0sVdyjjeFKQ9CUW0Mp
         dz+qPj5+Z4aW/A32YYGD/X9nBjM2TPHo4rMmZLu4ubEXCh+5tyydxDfhQe6D36lPLAIU
         /1QTuLIG3dC02pnbHsVSzQiIxGDJlx9ixGS8e2vGUDO+L62AuFQ6rJJJ/CBjG62BEGO7
         XI1Tf+g/4q9WVdJMyWIIZEKO8nuNM5leAnLOkMWsVAwJQao+p3hSqtbQPPYrUmIbNmLy
         gj33eUf/xWdoNDXQVQUO2f3IFHvjEkL39UjfW4c+KsndbGS+Ge7h6bJJ96Ca45vk7cYa
         lrwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751410; x=1696356210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NtWGC2dr4Dt18NXh3XbNn734FYbuI4TsF3KP5ThfnrU=;
        b=PnBgodDuosPNRu8eISNh1qiI2ZBpVomsSUp7wShfeFPFZDsg+drh04C7EJrLlhUXom
         LFQFOeYl5evgrM6dJTCZAGzGLlbYonQnTegl44DXzOeDkpnznWvjyfMLKF5frtQrEEmE
         7pvAT899bl67LUhh5yIbEqwgOg9Uni2qwwwdXgHbGU5/hiB+5FQsSHh9KvS6wXYPUt9c
         ORM9cgKC6dmlc1vvG42UVnBK4Vow/ojykRCBKeP0F78Q5UAy8EkCs/uZJiyxJHw18sg+
         6tSFKkZ649WIMEhM30rvjjMegCIL/T0jaakFwbJhybVZ5aWDQ2fFBgFIdSXs6XlFBeOG
         T9EQ==
X-Gm-Message-State: AOJu0Yzip51EwevL/qQAefd2qeMJ7VQ6OfZFMh0+E3FlzgjvUlSquvsI
        kiFqP5n1JOB5AML9v7mjohOC2+2jxc/ENf8gBVQ/CQ==
X-Google-Smtp-Source: AGHT+IHMhr0lo610U2KNalLhILcJvuImx6f7yCcB+LJfP81hTll4FSKpP9VQXOcxOrV2NSVp2yLC5g==
X-Received: by 2002:a05:620a:751:b0:76c:b8b0:769d with SMTP id i17-20020a05620a075100b0076cb8b0769dmr10085224qki.39.1695751410676;
        Tue, 26 Sep 2023 11:03:30 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id i17-20020ae9ee11000000b00767d8e12ce3sm4917933qkg.49.2023.09.26.11.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:30 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 15/35] btrfs: implement fscrypt ioctls
Date:   Tue, 26 Sep 2023 14:01:41 -0400
Message-ID: <9faf5ac92793fa1459aded3c23076c667f404f29.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
index ae674c823d14..ddc2d2c7fc7f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4587,6 +4587,34 @@ long btrfs_ioctl(struct file *file, unsigned int
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

