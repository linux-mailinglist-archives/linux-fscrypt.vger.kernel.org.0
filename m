Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F8D61622F
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 12:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiKBLyD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 07:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiKBLxe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 07:53:34 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95003BD1;
        Wed,  2 Nov 2022 04:53:33 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id CC73980237;
        Wed,  2 Nov 2022 07:53:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1667390013; bh=fBW5/zONytD5ZLev5PXGwSdh7O/fMCNQZDREBak2ZmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tc6u3qgcd9i6yL56kpv2l4haLg1mrYpWkBI7G9Q4V1qNo83Mk0TSUtgRO/kSuIseF
         U0DorQP6m4kobPQqqZkvEJQYn0Xxxc2VFmwzdCuAWaLWSt5dhvVBK+noHtf008zvIm
         ZHHbBjEDFwwPPiTB2WbniOWEWbDnSuQp6dF1sVFLulsHaR7a+4wYD+/dN3RH8myp7I
         g8uVuwDdXKXVd1lCW4YWtbnh0p5rabdaFX5cv+5hvxRRE/6MTUp+mggbT50uP57vfd
         f4wKmIJU2De5xyOu7XpUbhPHExxHebIw2/kbxHU2bqovXX+k6TltKtIKZyDzREoDbI
         qJ6fX5z2B7Tbw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v5 13/18] btrfs: Add new FEATURE_INCOMPAT_ENCRYPT feature flag.
Date:   Wed,  2 Nov 2022 07:53:02 -0400
Message-Id: <db3bdeaedf9084f2634a14eff234522bb023d5fa.1667389115.git.sweettea-kernel@dorminy.me>
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

As encrypted files will be incompatible with older filesystem versions,
new filesystems should be created with an incompat flag for fscrypt,
which will gate access to the encryption ioctls.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/fs.h              | 5 +++--
 fs/btrfs/super.c           | 5 +++++
 include/uapi/linux/btrfs.h | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index c7f2a512fba2..b12146d34dc5 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -185,7 +185,7 @@ enum {
 
 #ifdef CONFIG_BTRFS_DEBUG
 /*
- * Extent tree v2 supported only with CONFIG_BTRFS_DEBUG
+ * Extent tree v2 and encryption supported only with CONFIG_BTRFS_DEBUG
  */
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
@@ -201,7 +201,8 @@ enum {
 	 BTRFS_FEATURE_INCOMPAT_METADATA_UUID	|	\
 	 BTRFS_FEATURE_INCOMPAT_RAID1C34	|	\
 	 BTRFS_FEATURE_INCOMPAT_ZONED		|	\
-	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2)
+	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2	|	\
+	 BTRFS_FEATURE_INCOMPAT_ENCRYPT)
 #else
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1b32103b14d5..a1e6b2446749 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2411,6 +2411,11 @@ static int __init btrfs_print_mod_info(void)
 			", fsverity=yes"
 #else
 			", fsverity=no"
+#endif
+#ifdef CONFIG_FS_ENCRYPTION
+			", fscrypt=yes"
+#else
+			", fscrypt=no"
 #endif
 			;
 	pr_info("Btrfs loaded, crc32c=%s%s\n", crc32c_impl(), options);
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 5655e89b962b..1d29f0df995b 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -316,6 +316,7 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_RAID1C34		(1ULL << 11)
 #define BTRFS_FEATURE_INCOMPAT_ZONED		(1ULL << 12)
 #define BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2	(1ULL << 13)
+#define BTRFS_FEATURE_INCOMPAT_ENCRYPT		(1ULL << 14)
 
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
-- 
2.37.3

