Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FBF774653
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjHHSyx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjHHSyi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:54:38 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A68696B2;
        Tue,  8 Aug 2023 10:12:34 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 83F498343D;
        Tue,  8 Aug 2023 13:12:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514754; bh=h1UoSMBy1DTYNUEDp5Q4krNvl6d2m/f9p6YPgBTIwOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvTQEYJBqzmJtzFFWoGJZDUSc+lh/mD4XAyKYSUybS5NxmgYhARJNp05tKrggUHCo
         SBx34oFQ3ePYWLcF+YuGyFbsy5cuW3lQJDOVPLmAcWQbKAAZh53WTdEn4NV27hbwDk
         uBd2I6kbj8AHhwFj1BBrkI1jhUlU51zU/HMssxBl1niE5wtYrg3CgfOyrqksBHki59
         QnJ7g3gUunGzcYbJ6cmBfjoZNDmb3TXVQvoUkrqfzkcGH7QFmaiVB8iROv3QyxfKxE
         5TELYR0A0KWdVe1QQo1CJi+Ey7v0JAGgj52j4pHpaQn3sRqxEUj9VI0XGfbUCi7dS7
         wIJE68C2BOODA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 06/17] btrfs: add new FEATURE_INCOMPAT_ENCRYPT flag
Date:   Tue,  8 Aug 2023 13:12:08 -0400
Message-ID: <5f28a69c531271ee1dc49b5a76918e30b976879a.1691510179.git.sweettea-kernel@dorminy.me>
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

From: Omar Sandoval <osandov@osandov.com>

As encrypted files will be incompatible with older filesystem versions,
new filesystems should be created with an incompat flag for fscrypt,
which will gate access to the encryption ioctls.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/fs.h              | 7 ++++---
 fs/btrfs/super.c           | 5 +++++
 fs/btrfs/sysfs.c           | 6 ++++++
 include/uapi/linux/btrfs.h | 1 +
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index ef07c6c252d8..15d0dc425e32 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -223,9 +223,10 @@ enum {
 	 * Features under developmen like Extent tree v2 support is enabled
 	 * only under CONFIG_BTRFS_DEBUG.
 	 */
-#define BTRFS_FEATURE_INCOMPAT_SUPP		\
-	(BTRFS_FEATURE_INCOMPAT_SUPP_STABLE |	\
-	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2)
+#define BTRFS_FEATURE_INCOMPAT_SUPP		 \
+	(BTRFS_FEATURE_INCOMPAT_SUPP_STABLE |	 \
+	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2 | \
+	 BTRFS_FEATURE_INCOMPAT_ENCRYPT)
 
 #else
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 08b1e2ded5be..0cc9c2909f64 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2421,6 +2421,11 @@ static int __init btrfs_print_mod_info(void)
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
 	pr_info("Btrfs loaded%s\n", options);
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index b1d1ac25237b..ac955f920edf 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -301,6 +301,9 @@ BTRFS_FEAT_ATTR_INCOMPAT(extent_tree_v2, EXTENT_TREE_V2);
 #ifdef CONFIG_FS_VERITY
 BTRFS_FEAT_ATTR_COMPAT_RO(verity, VERITY);
 #endif
+#ifdef CONFIG_FS_ENCRYPTION
+BTRFS_FEAT_ATTR_INCOMPAT(encryption, ENCRYPT);
+#endif /* CONFIG_FS_ENCRYPTION */
 
 /*
  * Features which depend on feature bits and may differ between each fs.
@@ -331,6 +334,9 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 #ifdef CONFIG_FS_VERITY
 	BTRFS_FEAT_ATTR_PTR(verity),
 #endif
+#ifdef CONFIG_FS_ENCRYPTION
+	BTRFS_FEAT_ATTR_PTR(encryption),
+#endif /* CONFIG_FS_ENCRYPTION */
 	NULL
 };
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index dbb8b96da50d..98d1fa51a351 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -333,6 +333,7 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_RAID1C34		(1ULL << 11)
 #define BTRFS_FEATURE_INCOMPAT_ZONED		(1ULL << 12)
 #define BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2	(1ULL << 13)
+#define BTRFS_FEATURE_INCOMPAT_ENCRYPT		(1ULL << 14)
 
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
-- 
2.41.0

