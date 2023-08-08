Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64DC7743D8
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbjHHSK4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbjHHSK1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:10:27 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AB51B061;
        Tue,  8 Aug 2023 10:12:40 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 1F8F98343D;
        Tue,  8 Aug 2023 13:12:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514760; bh=J7il86OlPWYZdN63X7nQwYpmYM3qYx1E/+yZHC0ZBCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FVB0e4vR3eXQ7/I+IZcwwzZNVnO5JwNLNW+yJ/fUbffbBurBMiIhR5UY1Lhfo4AJy
         Cxl+EyDys9fUn37t53EkY+TGACO9hvVCpMr9t0H4pCnbl9OVF0W4kDWXrv2fCwilGe
         sINUAGXVIsBPSw1O4/5WS6GP9kYiFRl4S3eFOZ+ipWjAdvGysFvg4fgMC9djiWZ1FL
         RigQZAm4zygjBvDPDqgwvt4SysyVz8oUn3cpKN/Gh41swx0kNLDsTtwr+u9N4Ksyxt
         4Im16gHtxll8r6B2rZ4muqipsoVniRBNIJSLqjoguqph2GgI7PX2hgD01d18CLPibX
         FXziFW5aDV+kw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 10/17] btrfs: add encryption to CONFIG_BTRFS_DEBUG
Date:   Tue,  8 Aug 2023 13:12:12 -0400
Message-ID: <65ff94801ba183ac72f42454e901a1cc1a6b53dc.1691510179.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691510179.git.sweettea-kernel@dorminy.me>
References: <cover.1691510179.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
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
2.41.0

