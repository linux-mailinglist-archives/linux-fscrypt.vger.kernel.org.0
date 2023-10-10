Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D767C417F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbjJJUlc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343846AbjJJUl1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:27 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526EA9E
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:24 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-d865854ef96so6544883276.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970483; x=1697575283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=87dZSqgSaXj4ytyfF35JvwlP3e7S7MAiVwyt9dp8ebs=;
        b=anLPh7C0zTh6PUt7uDdSzRPQQ1dfTi3gtjx1BQHP0erMnM4O3DSuKHRzOPyFsdYFdT
         s24WgR72H7ZOyN3L3uEQbCB+qWkXD1OaGWwzs+e6MmA9ioio8xaDCkmf90H5H9nqEnvT
         UbJwcxmiFgc1SBr3XBSw6PqFjRKpapiI99f6HaxMEev54BrIdrKoz35CLlli8anD+b3T
         q7+vyjc6yFwSaAxO/6j63TrySOKb4s8vBfjxSW/EwKGuMyxE7DdjzSLQXJOE2dyJbvPL
         RoGdi4SiNLU0xJjsDUSvj5NgUsiIN4vW6b67BHGQFWusg/oRGDbSJubTTx8yjtZSBKYS
         1I+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970483; x=1697575283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=87dZSqgSaXj4ytyfF35JvwlP3e7S7MAiVwyt9dp8ebs=;
        b=Z+ueANSD0E+fJTA7vjFAv7BW8tbZrZa2o5fQEdCEmbvOc7+nLf2UszPQg9nWMLKA0o
         279hSsqpwcJ/BzOcCgWsWOq2es0CUi35vKW9WZFQ3XLxOvFYkCAvK0pbz1S3hYlIgYbx
         kn/MXDxLrwkHdQ8ByhV5AP057LKUgl2X7T/HPdBuLT/iT8NSff7rWBSTPuvzxt8wNSqn
         iBz7/DHdZXFWBs7mqiM13zPHtO2KQf04VlTn5PY58QDCLlF4KN+3UuXPM3zDWXAjBJQ3
         /lyJXdNuLuG0eaI1wmXfdGGfw19weJ6R3p4+TqSIrXQS6FRrVYecddtMMVPUqcJn/OZL
         ic+w==
X-Gm-Message-State: AOJu0YwpjhEC7KI9h6nChfhDku22t4Vyj4ijTigjNXyIWK2BJ26YhOeg
        SnigQVs5GYiK7tBfKiojQ/KwVQeN6t/W7SHCTeYDmg==
X-Google-Smtp-Source: AGHT+IEdXg62sV/IhuhsQeH2LWLtqloAx6ZlMUY4+WBDUwliy0+jchyIbbiCbelWWs7f96gcvCkxgA==
X-Received: by 2002:a25:70c3:0:b0:d84:b0f8:916 with SMTP id l186-20020a2570c3000000b00d84b0f80916mr18298740ybc.64.1696970483230;
        Tue, 10 Oct 2023 13:41:23 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id j200-20020a2523d1000000b00d9a58aa5806sm709462ybj.25.2023.10.10.13.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:22 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 17/36] btrfs: add encryption to CONFIG_BTRFS_DEBUG
Date:   Tue, 10 Oct 2023 16:40:32 -0400
Message-ID: <cd63ddceb812fc0d0fca3ab3e44c96e93fe06920.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
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

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Since encryption is currently under BTRFS_DEBUG, this adds its
dependencies: inline encryption from fscrypt, and the inline encryption
fallback path from the block layer.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5938adb64409..c56986031870 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4575,6 +4575,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_fslabel(fs_info, argp);
 	case FS_IOC_SETFSLABEL:
 		return btrfs_ioctl_set_fslabel(file, argp);
+#ifdef CONFIG_BTRFS_DEBUG
 	case FS_IOC_SET_ENCRYPTION_POLICY: {
 		if (!IS_ENABLED(CONFIG_FS_ENCRYPTION))
 			return -EOPNOTSUPP;
@@ -4603,6 +4604,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
 	case FS_IOC_GET_ENCRYPTION_NONCE:
 		return fscrypt_ioctl_get_nonce(file, (void __user *)arg);
+#endif /* CONFIG_BTRFS_DEBUG */
 	case FITRIM:
 		return btrfs_ioctl_fitrim(fs_info, argp);
 	case BTRFS_IOC_SNAP_CREATE:
-- 
2.41.0

