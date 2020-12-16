Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5F62DC551
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Dec 2020 18:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgLPR2O (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Dec 2020 12:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgLPR2N (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Dec 2020 12:28:13 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4312EC061794
        for <linux-fscrypt@vger.kernel.org>; Wed, 16 Dec 2020 09:27:33 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id m5so23940682wrx.9
        for <linux-fscrypt@vger.kernel.org>; Wed, 16 Dec 2020 09:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8pSQ7FQQTufiJ0E8hJeqjgTXcBBLVDZeJhRtHa5U8Hg=;
        b=PWzITIsdxaplfBfAhSfeQElFfUeGvrLf84bG+CbovrlCbWjoJQEk6lJv536UX5Htea
         qn5ynnPXsv37jIE3d4xI9UWgtZAF6qrwxeX5kJMiCrTZdKW2yT+f8Isb2O8I0RqRmE92
         aRhklJQfByoDMCcVg9GFoAH5a1mAkJ1yHm2FWFEnKMs2pTHu6fXPRpTONwgz7b4c00rr
         O0gKcFB3hmj4Mpi2lr5HPRyTio19izwq0CNHzJRk/tiV4lLe/+xXUssA6vfv2tYFl612
         26RY32z9Gf6Mkpwk8ykcv3lSTtNKlsj781ipFE/lOiB1NmmK2Mf1gUhOm3OzbLxo8gZq
         H9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8pSQ7FQQTufiJ0E8hJeqjgTXcBBLVDZeJhRtHa5U8Hg=;
        b=o/XleEDbmYPmrtc7NpK/0g9Hb4a3whBAFUJb9DbQwuVDgmLL+JefmP3m6ZL9vXqbda
         dhdALt6RxNItsupeTQjfQpBWu7sDIO83U2MRS4YS3QcX5Ryh8dXmBg1zXo7xzxVASJT3
         bUBRlOAwuPaPO8+7as1UvjPKaYvZwwwJod+LLG8RpKVQ0SYx/MNdYCKnXVderk0kiBuu
         L7wx79l/5fHCmroWp3xpzLlaiTocW1xDwZsEkKXItXnfJ2ZTyYkiU21VUx6lxkOdVsJ2
         gIVs63yr3FzajHc+Pw/kXuYNEiN3Wxx99uNSUt92I2mFapMdsGEaGW1kRZbiR/MIDbZX
         LsYw==
X-Gm-Message-State: AOAM530JeILInqcfJWZJKF/NzVAnpPg7R98EkdoB4qD9NO+SCI+sU3XH
        Oy2yMPB0soabTmK5X2DKZiSfC/Uz1mCX4w==
X-Google-Smtp-Source: ABdhPJz2czkspfbLfpxg84gIpdhUU0cu8V+AWh0AiWW1xjZBqjfMDTzrPDr4FcghCc6k2moC3kf3yA==
X-Received: by 2002:adf:e348:: with SMTP id n8mr2685430wrj.148.1608139651724;
        Wed, 16 Dec 2020 09:27:31 -0800 (PST)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id j10sm4108883wmj.7.2020.12.16.09.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 09:27:30 -0800 (PST)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com
Subject: [fsverity-utils PATCH 1/2] Remove unneeded includes
Date:   Wed, 16 Dec 2020 17:27:18 +0000
Message-Id: <20201216172719.540610-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Luca Boccassi <luca.boccassi@microsoft.com>

Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
---
 common/fsverity_uapi.h | 1 -
 programs/cmd_enable.c  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/common/fsverity_uapi.h b/common/fsverity_uapi.h
index 33f4415..0006c35 100644
--- a/common/fsverity_uapi.h
+++ b/common/fsverity_uapi.h
@@ -10,7 +10,6 @@
 #ifndef _UAPI_LINUX_FSVERITY_H
 #define _UAPI_LINUX_FSVERITY_H
 
-#include <linux/ioctl.h>
 #include <linux/types.h>
 
 #define FS_VERITY_HASH_ALG_SHA256	1
diff --git a/programs/cmd_enable.c b/programs/cmd_enable.c
index fdf26c7..14c3c17 100644
--- a/programs/cmd_enable.c
+++ b/programs/cmd_enable.c
@@ -14,7 +14,6 @@
 #include <fcntl.h>
 #include <getopt.h>
 #include <limits.h>
-#include <sys/ioctl.h>
 
 static bool read_signature(const char *filename, u8 **sig_ret,
 			   u32 *sig_size_ret)
-- 
2.29.2

