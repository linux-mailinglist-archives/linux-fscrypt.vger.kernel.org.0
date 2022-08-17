Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD4D5971D8
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 16:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240075AbiHQOu4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Aug 2022 10:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240437AbiHQOuy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Aug 2022 10:50:54 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415C83E749;
        Wed, 17 Aug 2022 07:50:53 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 9F12281140;
        Wed, 17 Aug 2022 10:50:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1660747852; bh=ORZrkqsA05BXOYu2otqHJ6RtbItHF/27zv6HhRn6/JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIzq7OZ/vIJ6siSv4LsIptpRxUMfIdCJucppaSOK1tCGakV1Uw9eIqWnUdJ4njCjy
         +OANC7d61TU1v3VXkjlx3c97TGfEhEnf6c4Qjn2bZzklTryvFUBcGcYeFdZVIVboIz
         HJaAZKdnJa75yhyXD2iXxsn4y06vIicnmFGBQ92DAHredlRV8rubaSxGMBbDFt6Zzw
         NRmU3lj6MwMyJHnHEDIKcNZTEpU+qtP2QYGm8wbPBz+OUc2F0+zAM68oirmCZ0X2Ve
         xGLGi2Syq+Uix3bpxEzTIo/5iazp3AwfYP6tV8kXYHrB2tqRpJqDgPEIOlZpkPyvV+
         J+8HPIuJ8XBtA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 17/21] btrfs: Add new FEATURE_INCOMPAT_FSCRYPT feature flag.
Date:   Wed, 17 Aug 2022 10:50:01 -0400
Message-Id: <2f7e98905d9275ad6f5515678c081a085380999b.1660744500.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1660744500.git.sweettea-kernel@dorminy.me>
References: <cover.1660744500.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

As fscrypt files will be incompatible with older filesystem versions,
new filesystems should be created with an incompat flag for fscrypt.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/ctree.h           | 6 ++++--
 include/uapi/linux/btrfs.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 40ceaef462ac..be4a3458b4d6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -334,7 +334,8 @@ static_assert(sizeof(struct btrfs_super_block) == BTRFS_SUPER_INFO_SIZE);
 	 BTRFS_FEATURE_INCOMPAT_METADATA_UUID	|	\
 	 BTRFS_FEATURE_INCOMPAT_RAID1C34	|	\
 	 BTRFS_FEATURE_INCOMPAT_ZONED		|	\
-	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2)
+	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2	|	\
+	 BTRFS_FEATURE_INCOMPAT_FSCRYPT)
 #else
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
@@ -349,7 +350,8 @@ static_assert(sizeof(struct btrfs_super_block) == BTRFS_SUPER_INFO_SIZE);
 	 BTRFS_FEATURE_INCOMPAT_NO_HOLES	|	\
 	 BTRFS_FEATURE_INCOMPAT_METADATA_UUID	|	\
 	 BTRFS_FEATURE_INCOMPAT_RAID1C34	|	\
-	 BTRFS_FEATURE_INCOMPAT_ZONED)
+	 BTRFS_FEATURE_INCOMPAT_ZONED		|	\
+	 BTRFS_FEATURE_INCOMPAT_FSCRYPT)
 #endif
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index f54dc91e4025..b19fc3725769 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -310,6 +310,7 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_RAID1C34		(1ULL << 11)
 #define BTRFS_FEATURE_INCOMPAT_ZONED		(1ULL << 12)
 #define BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2	(1ULL << 13)
+#define BTRFS_FEATURE_INCOMPAT_FSCRYPT		(1ULL << 14)
 
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
-- 
2.35.1

