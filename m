Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB62606698
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 19:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiJTRAM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 13:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiJTRAL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 13:00:11 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C23769F43;
        Thu, 20 Oct 2022 10:00:02 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 8403C811B9;
        Thu, 20 Oct 2022 12:59:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666285170; bh=icRy27yHTRS25YcpeSS+1VWQaeA94bKsBJ+hG1qd76E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbzDhir7h+tSEavkw4M5a6qZZdOTvw0SshHDuiaSZnSNRSeyDDxRlCu4E/XjWGJ1/
         EV38MN09/1C4rPkdY/oQ2oZwnXD2+BO+af9689StggT+xcxtaomvsx7I6QDERHj3lO
         v/9oy3Yj3myhAU5fM35fJ2m8o0FBAu4e4zm7A8rljtfPV9WGPU9ZswZyulV1pldVay
         Gpss+eI115D/vjhSi6Y1h3dFzFa+mPo3UeEOKbkE7RWowusKF9BPmF6cczy4PVn91Z
         LD+PlEFpjxRDKGDe+H0EEygoc/lfzz2tH/BZ1ltYBNAxr+AAUA0Qw9SvZVJy2G37OP
         pcI2r0uShQVZg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 16/22] btrfs: Add new FEATURE_INCOMPAT_ENCRYPT feature flag.
Date:   Thu, 20 Oct 2022 12:58:35 -0400
Message-Id: <68dba5d948573f1fee9255c64642daa2d1f8dec1.1666281277.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1666281276.git.sweettea-kernel@dorminy.me>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 fs/btrfs/ctree.h           | 5 +++--
 fs/btrfs/super.c           | 5 +++++
 include/uapi/linux/btrfs.h | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f09a7872b296..32296dedeb95 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -130,7 +130,7 @@ static_assert(sizeof(struct btrfs_super_block) == BTRFS_SUPER_INFO_SIZE);
 
 #ifdef CONFIG_BTRFS_DEBUG
 /*
- * Extent tree v2 supported only with CONFIG_BTRFS_DEBUG
+ * Extent tree v2 and encryption supported only with CONFIG_BTRFS_DEBUG
  */
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
@@ -146,7 +146,8 @@ static_assert(sizeof(struct btrfs_super_block) == BTRFS_SUPER_INFO_SIZE);
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
index 20123d3634a6..2eaaaf01b842 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2705,6 +2705,11 @@ static void __init btrfs_print_mod_info(void)
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
2.35.1

