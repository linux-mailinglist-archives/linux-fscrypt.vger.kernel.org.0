Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CAD741D1E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjF2Afx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbjF2Aft (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:35:49 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64262728;
        Wed, 28 Jun 2023 17:35:47 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 3F3AC8030E;
        Wed, 28 Jun 2023 20:35:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998947; bh=mS8xcbyfJ2L+bJJYin0TxhoCv7CCnF7NZeAWVfGmOqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWltYi1FfNjf/ZCGmuELIxDthB2YhneXl44dzR4QmVcCWB/CXRq8vPf/bcuhDFdP8
         pwFi3qhJ0OOOgRDMxGT7aiQhWnjnii6wefF+wqgXYqS1rwpkQ0R+bwnwB0ajcCffL8
         mQXj2m2j58Rq67BBkLlvoPKZJFnARBHYrVyOiYwzNXzZasPARzGM0zUTF4agINmktw
         wzPbfclehwHmQWqpFyTzaNmM8FCKIiqKU2S1Bq1GC+YHHD3CY/4aGQM0VaRlejcaBs
         KBrTYmR6AQzH8lNLUUoDmdkV+6MjAmXDHnc2yRAyQJ1ydOb+zBkAdEHut6+ouJ7Cq3
         S9tKfDBea1B3g==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 01/17] btrfs: disable various operations on encrypted inodes
Date:   Wed, 28 Jun 2023 20:35:24 -0400
Message-Id: <e7785ffe237e581a7ba7e45d2724fca4d8fa1470.1687988380.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988380.git.sweettea-kernel@dorminy.me>
References: <cover.1687988380.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

Initially, only normal data extents, using the normal (non-direct) IO
path, will be encrypted. This change forbids various other bits:
- allows reflinking only if both inodes have the same encryption status
- disables direct IO on encrypted inodes
- disable inline data on encrypted inodes

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/file.c    | 4 ++--
 fs/btrfs/inode.c   | 3 ++-
 fs/btrfs/reflink.c | 7 +++++++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 392bc7d512a0..354962a7dd72 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1502,7 +1502,7 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 		goto relock;
 	}
 
-	if (check_direct_IO(fs_info, from, pos)) {
+	if (IS_ENCRYPTED(inode) || check_direct_IO(fs_info, from, pos)) {
 		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
 		goto buffered;
 	}
@@ -3741,7 +3741,7 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 	ssize_t read = 0;
 	ssize_t ret;
 
-	if (fsverity_active(inode))
+	if (IS_ENCRYPTED(inode) || fsverity_active(inode))
 		return 0;
 
 	if (check_direct_read(btrfs_sb(inode->i_sb), to, iocb->ki_pos))
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dbbb67293e34..48eadc4f187f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -630,7 +630,8 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
 	 * compressed) data fits in a leaf and the configured maximum inline
 	 * size.
 	 */
-	if (size < i_size_read(&inode->vfs_inode) ||
+	if (IS_ENCRYPTED(&inode->vfs_inode) ||
+	    size < i_size_read(&inode->vfs_inode) ||
 	    size > fs_info->sectorsize ||
 	    data_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info) ||
 	    data_len > fs_info->max_inline)
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 0474bbe39da7..ad722f495c9b 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/blkdev.h>
+#include <linux/fscrypt.h>
 #include <linux/iversion.h>
 #include "ctree.h"
 #include "fs.h"
@@ -811,6 +812,12 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 		ASSERT(inode_in->i_sb == inode_out->i_sb);
 	}
 
+	/*
+	 * Can only reflink encrypted files if both files are encrypted.
+	 */
+	if (IS_ENCRYPTED(inode_in) != IS_ENCRYPTED(inode_out))
+		return -EINVAL;
+
 	/* Don't make the dst file partly checksummed */
 	if ((BTRFS_I(inode_in)->flags & BTRFS_INODE_NODATASUM) !=
 	    (BTRFS_I(inode_out)->flags & BTRFS_INODE_NODATASUM)) {
-- 
2.40.1

