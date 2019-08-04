Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 616B680A39
	for <lists+linux-fscrypt@lfdr.de>; Sun,  4 Aug 2019 11:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfHDJ5J (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 4 Aug 2019 05:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfHDJ5J (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 4 Aug 2019 05:57:09 -0400
Received: from localhost.localdomain (unknown [180.111.32.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 454E720665;
        Sun,  4 Aug 2019 09:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564912629;
        bh=s1HN0HFWrzjCco1eavATf8vuBvGG9VhqmF59WM2sedc=;
        h=From:To:Cc:Subject:Date:From;
        b=qlHSPxQcEtXpsmJZiBR6c8s+/BOMOi2NbzqL7k7TVxG+4oV5iNnvXovD8aHza7/Is
         LV7LAqabdnpCLPQhb/PIanHegEoqShLKcHsjAgMB6mmeU+v/OzBRSt3ktEGXMytt4e
         iL/5bsVPQ8kfe4ojeZ56MH63Yz1vS6tCXA+Q/MHE=
From:   Chao Yu <chao@kernel.org>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        chao@kernel.org, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH] ext4 crypto: fix to check feature status before get policy
Date:   Sun,  4 Aug 2019 17:56:43 +0800
Message-Id: <20190804095643.7393-1-chao@kernel.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

When getting fscrypto policy via EXT4_IOC_GET_ENCRYPTION_POLICY, if
encryption feature is off, it's better to return EOPNOTSUPP instead
of ENODATA, so let's add ext4_has_feature_encrypt() to do the check
for that.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
---
 fs/ext4/ioctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 442f7ef873fc..bf87835c1237 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1112,9 +1112,11 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return -EOPNOTSUPP;
 #endif
 	}
-	case EXT4_IOC_GET_ENCRYPTION_POLICY:
+	case EXT4_IOC_GET_ENCRYPTION_POLICY: {
+		if (!ext4_has_feature_encrypt(sb))
+			return -EOPNOTSUPP;
 		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
-
+	}
 	case EXT4_IOC_FSGETXATTR:
 	{
 		struct fsxattr fa;
-- 
2.22.0

