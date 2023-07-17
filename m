Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E8A755A42
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 05:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjGQDxU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 23:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjGQDxD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 23:53:03 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2D9E43;
        Sun, 16 Jul 2023 20:53:02 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 8E78283411;
        Sun, 16 Jul 2023 23:53:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689565981; bh=5LzFxlUqAcXQm80LvT6GmQ369JzwDtBMRXtlbnLMJh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IY/ZELiWhGgbB2+XpB9TFl+AcwrHagSUktt4PAj8y41v7IzXe6PnR+VC2l3pLDCms
         X1MZNbzfjCD20qvzZaiu/dpbXeonb+dpjqfaVScdohKfeItAUSMUbjloLknYK9U7U2
         pvcpjabpEDBXNI+fZytZKQ/X2FfpRbaiGCOqytTO6sbQMbIg6tzFxy9s/eIYvP1DCt
         PRAWW6N7vU1fFZWpgLaCgUkPorUUWDINqCJRc7SVpFkE8Z8JUPabX+MilR10DmtJo9
         GeRNO/6BNJpNL9H9fbjT2sBKiUBF+De0gfXzO9DANAposthQute0/8HjQ/mh1dfYH/
         44hhukrD/ol3w==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 06/17] btrfs: add new FEATURE_INCOMPAT_ENCRYPT flag
Date:   Sun, 16 Jul 2023 23:52:37 -0400
Message-Id: <ef50913d0c3f9050dc368f99077724243735117a.1689564024.git.sweettea-kernel@dorminy.me>
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

