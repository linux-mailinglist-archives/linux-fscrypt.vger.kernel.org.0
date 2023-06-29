Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8A1741D2B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjF2AgH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjF2Af7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:35:59 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E48A2102;
        Wed, 28 Jun 2023 17:35:58 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 13C9E80727;
        Wed, 28 Jun 2023 20:35:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998958; bh=RLuxTQSqMbxMmWOXZwiByw9cEBeb2fq1lbwKHYgbcl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=if3mNvbYnhTu1PD8bWSegrc8h3g18vy34zJW1ubTFQcngBbhl+/fHVBdW+M4X/Ony
         xNfBOx+vcf38OGS+ee5NBr2bEFW2vICW3F8d1Q4aYJ9BvLmfwVzs6hKpHrVjQY2BYt
         JhIyySys25tXErv2fOOSZJKZyGD4G3KAVTzpYBdicXY/p9UGE/jWreX350MjTJMjsx
         lTe2tTw2MAnfBjCzndlMFKsPPGwvtdutg7s31YuOT/yZ0YSpYiaev1ynj09LjwAnZ/
         E57FOywxJgEGW8IowrjHR2/fbHvJ8kU2sU9ZCSc2MBPGFH9cfNxjV+OwcFWjOo1L8Y
         hwgsAHd42LaYQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 06/17] btrfs: add new FEATURE_INCOMPAT_ENCRYPT flag
Date:   Wed, 28 Jun 2023 20:35:29 -0400
Message-Id: <77cb8934d438551b23f09dd9931a9dcb31d01a16.1687988380.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988380.git.sweettea-kernel@dorminy.me>
References: <cover.1687988380.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
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
 include/uapi/linux/btrfs.h | 1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 203d2a267828..578874fbc98f 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -225,9 +225,10 @@ enum {
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
index d0df46370c5d..ad18127cee10 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2422,6 +2422,11 @@ static int __init btrfs_print_mod_info(void)
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
2.40.1

