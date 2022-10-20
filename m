Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571E760668F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 19:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiJTRAJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 13:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiJTQ77 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 12:59:59 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3847F65260;
        Thu, 20 Oct 2022 09:59:55 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 84D13811C0;
        Thu, 20 Oct 2022 12:59:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666285165; bh=FpdGpIli/OtIwgXzxZ93LvzW1lv31p9Kbn29YTWrDR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6g+aNom9J2n9b3Pa/KXxvcgPJ9gtkic9QCAYyXfovE2d2yPGs69c8h3jTPE4G0mt
         9XMN8UnDK9MoNoPNKZM1vSwEc2MjTU94f/1dzc8q1krWW/o4qNZ/llYcZu/4mnmpxx
         NMBBc6/mavbk6m8ga0QJVOox9cb862Hv+qyBgduBdTaVuVvp5WsdEmhYe9bhf2Uuam
         HSty6QVQ6o2zeoTUWWU6WaO7cE6RH9pKl2ozs8l43DcJDFeNDvLJCFA8puHpaSbt0q
         VS5ZePVwsAPuyZptvmFuZcjuP2exGi7woEYaNqP9T/O2sU2qOAFcppvGx84EZuhmmr
         DbO9IKf0iZUrw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 13/22] btrfs: translate btrfs encryption flags and encrypted inode flag
Date:   Thu, 20 Oct 2022 12:58:32 -0400
Message-Id: <7c9fd4e5dcd1e95869da3cdf42c27c17855c0277.1666281277.git.sweettea-kernel@dorminy.me>
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
index 7839986ca0c1..e9267709ae7b 100644
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
@@ -147,6 +148,10 @@ static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
 		iflags |= FS_NOCOW_FL;
 	if (ro_flags & BTRFS_INODE_RO_VERITY)
 		iflags |= FS_VERITY_FL;
+	if ((binode->flags & BTRFS_INODE_FSCRYPT_CONTEXT) ||
+	    (btrfs_root_flags(&binode->root->root_item) &
+	     BTRFS_ROOT_SUBVOL_FSCRYPT))
+		iflags |= FS_ENCRYPT_FL;
 
 	if (flags & BTRFS_INODE_NOCOMPRESS)
 		iflags |= FS_NOCOMP_FL;
@@ -176,10 +181,14 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
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
@@ -192,7 +201,7 @@ static int check_fsflags(unsigned int old_flags, unsigned int flags)
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
 		      FS_SYNC_FL | FS_DIRSYNC_FL | \
 		      FS_NOCOMP_FL | FS_COMPR_FL |
-		      FS_NOCOW_FL))
+		      FS_NOCOW_FL | FS_ENCRYPT_FL))
 		return -EOPNOTSUPP;
 
 	/* COMPR and NOCOMP on new/old are valid */
-- 
2.35.1

