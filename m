Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA29F755A49
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 05:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjGQDxX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 23:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjGQDxJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 23:53:09 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFB0E4B;
        Sun, 16 Jul 2023 20:53:08 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id B8DFA83411;
        Sun, 16 Jul 2023 23:53:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689565988; bh=/JttTObEoVb/r0XeFvvEoTH8kiluhYs5lQFLwWiJO/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBV8bU8vmrZb4Hh+HZvXFziRnNd7Qv/KRDO0CkblsWcZle/YzowXh9SIbit90Kjoh
         xyBDnJOw1+7q1+TaFNPQBpn6dCM0HhaYfSZsQeUjYRdecZVsCi7uMzBZ6aOsjXUBRL
         VhGHdEURUlI4GNoT/isng26gnWkFATlev/r100IOOck2oUKuH0Q6WmrWJOMfth38qA
         zhNzRvt0tewOr/euY3FgmZyTCx4Vx3/3+i8OecAF/7spCfqyLptRQbOALRs2Mwr75d
         Wrizr8Nmx1fMnFm9R9TGVk1aUkLvY53XzbCUoN+mYXgV/X4+wypVMJg8x4YP7fKb5s
         WG2enlZ5MEnRA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 10/17] btrfs: add encryption to CONFIG_BTRFS_DEBUG
Date:   Sun, 16 Jul 2023 23:52:41 -0400
Message-Id: <1da5c29d08cdf8c581014205b54c91097debfff7.1689564024.git.sweettea-kernel@dorminy.me>
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

Since encryption is currently under BTRFS_DEBUG, this adds its
dependencies: inline encryption from fscrypt, and the inline encryption
fallback path from the block layer.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/Kconfig | 2 +-
 fs/btrfs/ioctl.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 3282adc84d52..b6fd4ed78905 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -82,7 +82,7 @@ config BTRFS_FS_RUN_SANITY_TESTS
 
 config BTRFS_DEBUG
 	bool "Btrfs debugging support"
-	depends on BTRFS_FS
+	depends on BTRFS_FS && FS_ENCRYPTION_INLINE_CRYPT && BLK_INLINE_ENCRYPTION_FALLBACK
 	help
 	  Enable run-time debugging support for the btrfs filesystem. This may
 	  enable additional and expensive checks with negative impact on
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 03ea92218749..91ad59519900 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4562,6 +4562,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_fslabel(fs_info, argp);
 	case FS_IOC_SETFSLABEL:
 		return btrfs_ioctl_set_fslabel(file, argp);
+#ifdef CONFIG_BTRFS_DEBUG
 	case FS_IOC_SET_ENCRYPTION_POLICY: {
 		if (!IS_ENABLED(CONFIG_FS_ENCRYPTION))
 			return -EOPNOTSUPP;
@@ -4590,6 +4591,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
 	case FS_IOC_GET_ENCRYPTION_NONCE:
 		return fscrypt_ioctl_get_nonce(file, (void __user *)arg);
+#endif /* CONFIG_BTRFS_DEBUG */
 	case FITRIM:
 		return btrfs_ioctl_fitrim(fs_info, argp);
 	case BTRFS_IOC_SNAP_CREATE:
-- 
2.40.1

