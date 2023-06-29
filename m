Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285D3741D31
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbjF2AgO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjF2AgG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:36:06 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F8B297B;
        Wed, 28 Jun 2023 17:36:03 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 693968030E;
        Wed, 28 Jun 2023 20:36:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998963; bh=QVlHFQb+aOmVOh6Tft4Rn0vXRANjaMBj0UL6vP1nbUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1uw/fJ9nBQbwDJxtlJThBlLNILMlvMb4HNlr31dDvPI2O1ctTvQf+FyIc7/zJaEi
         xNMNG1IbgEBqX+tFRhbrjM7hd+za/edP9/GSZtEOYR8qSkNAYhjFBO7vnNtoW7Sq3g
         gpdRAMtKhGckT8fmfbJS6ojWEE3FJ2hkXz0KS3A3j5G8KfIoA3+PtcubkoqJha1Vlc
         I6vq4osfniu2CTiTeUxAeb1RdyFsQok3YMqMcuJTuGphAgnj2hA8Cvykifpn4Tr2A9
         XjwPAzbfJ1qP9Lmtex+VW7cKrCTFdt/L12BYax/QZbPfh1Gen0PFI8g/aAkvXLchDa
         LqzOHW9zkrI/A==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 10/17] btrfs: add encryption to CONFIG_BTRFS_DEBUG
Date:   Wed, 28 Jun 2023 20:35:33 -0400
Message-Id: <8c1baf02f2c6ca424917c1b0ef65d92012f43e93.1687988380.git.sweettea-kernel@dorminy.me>
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

Since encryption is currently under BTRFS_DEBUG, this adds its
dependencies: inline encryption from fscrypt, and the inline encryption
fallback path from the block layer.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/Kconfig | 2 +-
 fs/btrfs/ioctl.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 66fa9ab2c046..c7861e579d72 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -80,7 +80,7 @@ config BTRFS_FS_RUN_SANITY_TESTS
 
 config BTRFS_DEBUG
 	bool "Btrfs debugging support"
-	depends on BTRFS_FS
+	depends on BTRFS_FS && FS_ENCRYPTION_INLINE_CRYPT && BLK_INLINE_ENCRYPTION_FALLBACK
 	help
 	  Enable run-time debugging support for the btrfs filesystem. This may
 	  enable additional and expensive checks with negative impact on
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 71d1610444b4..7c4360b59aae 100644
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

