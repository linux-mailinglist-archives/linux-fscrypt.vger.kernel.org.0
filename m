Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8E860BFE8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 25 Oct 2022 02:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiJYAnJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Oct 2022 20:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiJYAm1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Oct 2022 20:42:27 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D35A183AC;
        Mon, 24 Oct 2022 16:14:36 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 7C9DB811C2;
        Mon, 24 Oct 2022 19:14:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666653245; bh=wn4nscwr0stEGgJC/0rhkuNvqjwyTBTHJAwOi0YHllI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dl6lQPpIvCYBsKrTsenLOdeSbUtp9XrecffCOeoVrLfhTLOfGmUHC/BqHPU1huSG6
         /Om4ppjovGR/4uE7H3akHSK9PPpFGYDWDIqKG/HrUi1q6SMMsFMJyLEyY5D7QMwFtG
         5jxu6BwhY32GeuPUUIs5AqOnj3amyXPnb3tX5bEG1fNR471SgmY8kREZD1eO7djWr9
         z5ZLVbil9ffAbzdigXVkF8e+zl/6S97BcTrBd7xCV/tyBqGceraRXuA1ammfbl+LgK
         KNylvK2A64Joqd+oCOM21NTAXIWcH3OP0jE1QzLov7LbvyNkelOxUsEP+mjSfM5psN
         J3rDT7qSZHJsw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v4 14/21] btrfs: translate btrfs encryption flags and encrypted inode flag
Date:   Mon, 24 Oct 2022 19:13:24 -0400
Message-Id: <a7a27198299a215fe31b259bd90d1579ed175a1c.1666651724.git.sweettea-kernel@dorminy.me>
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

In btrfs, a file can be encrypted either if its directory is encrypted
or its root subvolume is encrypted, so translate both to the standard
flags.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ioctl.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b28b7588f651..9cd59ab5a8a9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -7,6 +7,7 @@
 #include <linux/bio.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/fscrypt.h>
 #include <linux/fsnotify.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
@@ -149,6 +150,10 @@ static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
 		iflags |= FS_NOCOW_FL;
 	if (ro_flags & BTRFS_INODE_RO_VERITY)
 		iflags |= FS_VERITY_FL;
+	if ((binode->flags & BTRFS_INODE_FSCRYPT_CONTEXT) ||
+	    (btrfs_root_flags(&binode->root->root_item) &
+	     BTRFS_ROOT_SUBVOL_FSCRYPT))
+		iflags |= FS_ENCRYPT_FL;
 
 	if (flags & BTRFS_INODE_NOCOMPRESS)
 		iflags |= FS_NOCOMP_FL;
@@ -178,10 +183,14 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
 		new_fl |= S_DIRSYNC;
 	if (binode->ro_flags & BTRFS_INODE_RO_VERITY)
 		new_fl |= S_VERITY;
+	if ((binode->flags & BTRFS_INODE_FSCRYPT_CONTEXT) ||
+	    (btrfs_root_flags(&binode->root->root_item) &
+	     BTRFS_ROOT_SUBVOL_FSCRYPT))
+		new_fl |= S_ENCRYPTED;
 
 	set_mask_bits(&inode->i_flags,
 		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC |
-		      S_VERITY, new_fl);
+		      S_VERITY | S_ENCRYPTED, new_fl);
 }
 
 /*
@@ -194,7 +203,7 @@ static int check_fsflags(unsigned int old_flags, unsigned int flags)
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
 		      FS_SYNC_FL | FS_DIRSYNC_FL | \
 		      FS_NOCOMP_FL | FS_COMPR_FL |
-		      FS_NOCOW_FL))
+		      FS_NOCOW_FL | FS_ENCRYPT_FL))
 		return -EOPNOTSUPP;
 
 	/* COMPR and NOCOMP on new/old are valid */
-- 
2.35.1

