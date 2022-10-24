Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB8060BFD3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 25 Oct 2022 02:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiJYAmm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Oct 2022 20:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiJYAmW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Oct 2022 20:42:22 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8A21C931;
        Mon, 24 Oct 2022 16:14:11 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 00357812CC;
        Mon, 24 Oct 2022 19:14:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666653251; bh=m4XS7ptSlATCJ6WssAKT/6DqqFRIRstG9avwQzZsF68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7A8MO1wS62anydC4ErwyHoDGTqCR4GaUQREJIamyUX3OqNuZhfeOGW2zRZ5D4WTR
         4BixP7OmJL0EpIShVSHkayO6a0yjY+uTTIowNczQSDwQio9QM1zEzpqXk9Zf9c/uz3
         iZjaboEd04BkpwVCDWU5lMXPEUtRB/kkHRJRRQPKirQQuvExzzlTcurOHesMhrump6
         2Jo8FGu/9oIRApR7OCPUb2AC6i7Tc9fEyymOx+xckRzRWbevmD14yH2uI9LVXMhh4c
         EcfJtXAK0dpF+YiEtdjnSytX9po6iCEr6lVAu2Jt6iL0WnS4+zT1iDtqxECoiHUE+S
         KKIXWEPME670Q==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v4 17/21] btrfs: Add new FEATURE_INCOMPAT_ENCRYPT feature flag.
Date:   Mon, 24 Oct 2022 19:13:27 -0400
Message-Id: <fa558869c5dd4edd2625e3012daecfeb3d06df56.1666651724.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1666651724.git.sweettea-kernel@dorminy.me>
References: <cover.1666651724.git.sweettea-kernel@dorminy.me>
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
index 2bd1b9e03d30..8eeb1918aa1c 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -159,7 +159,7 @@ enum {
 
 #ifdef CONFIG_BTRFS_DEBUG
 /*
- * Extent tree v2 supported only with CONFIG_BTRFS_DEBUG
+ * Extent tree v2 and encryption supported only with CONFIG_BTRFS_DEBUG
  */
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
@@ -175,7 +175,8 @@ enum {
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
index 8ab5171d07e8..c1075db7bfc7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2751,6 +2751,11 @@ static int __init btrfs_print_mod_info(void)
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

