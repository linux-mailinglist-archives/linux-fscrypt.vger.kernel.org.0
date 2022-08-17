Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85D85971E2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 16:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240436AbiHQOuq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Aug 2022 10:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240369AbiHQOum (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Aug 2022 10:50:42 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086503AE62;
        Wed, 17 Aug 2022 07:50:40 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 4B2F68042B;
        Wed, 17 Aug 2022 10:50:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1660747840; bh=45mPsaVSUVEKFgCwQQlfVFXsKBuzOzIhLQqKX5S1IBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhfBTNmRyVkiPxGRmTHIxFx8+17R9Ol3cPdRUSN9TW5mZvEAEhmQfabrF7tUfyfT5
         w8hcGqQOETyMfU8CTePjfRORiqg6SZ/Wsp/eTwqJg0JRGaSV1bCr9L/dGZdSAY+w8r
         5ae6KtqlP/GJxqwsmfpXMZ0xQ6712ZH3++GDwU2Vo08UZrSo8nQkQuEEA4fHyJG+JT
         l5+pq1RNHei868M2XC3pEKMLsmbn50z6UbGgkCUWi9ly9MoLtoz5REmoCpudlCC5zT
         GjsBWE5Zz53IYvmvhQw7f+aQuCPhsbB6e8v5a6ULEwEYIruYSMMlrBPWkfdrU4Ho5F
         AA/pGu7h/r5og==
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
Subject: [PATCH 10/21] btrfs: disable various operations on encrypted inodes
Date:   Wed, 17 Aug 2022 10:49:54 -0400
Message-Id: <f440e0b47b551913f56e87626c7872f801a4ffba.1660744500.git.sweettea-kernel@dorminy.me>
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

Initially, only normal data extents, using the normal (non-direct) IO
path, will be encrypted. This change forbids various other bits:
- allows reflinking only if both inodes have the same encryption status
- disables compressing encrypted inodes
- disables direct IO on encrypted inodes
- disable inline data on encrypted inodes

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/btrfs_inode.h | 3 +++
 fs/btrfs/file.c        | 4 ++--
 fs/btrfs/inode.c       | 3 ++-
 fs/btrfs/reflink.c     | 7 +++++++
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index b160b8e124e0..ff668686717b 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -400,6 +400,9 @@ static inline bool btrfs_inode_in_log(struct btrfs_inode *inode, u64 generation)
  */
 static inline bool btrfs_inode_can_compress(const struct btrfs_inode *inode)
 {
+	if (IS_ENCRYPTED(&inode->vfs_inode))
+		return false;
+
 	if (inode->flags & BTRFS_INODE_NODATACOW ||
 	    inode->flags & BTRFS_INODE_NODATASUM)
 		return false;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c9649b7b2f18..b2ffacef9abb 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1896,7 +1896,7 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 		goto relock;
 	}
 
-	if (check_direct_IO(fs_info, from, pos)) {
+	if (IS_ENCRYPTED(inode) || check_direct_IO(fs_info, from, pos)) {
 		btrfs_inode_unlock(inode, ilock_flags);
 		goto buffered;
 	}
@@ -3743,7 +3743,7 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 	ssize_t read = 0;
 	ssize_t ret;
 
-	if (fsverity_active(inode))
+	if (IS_ENCRYPTED(inode) || fsverity_active(inode))
 		return 0;
 
 	if (check_direct_read(btrfs_sb(inode->i_sb), to, iocb->ki_pos))
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 016b3fb856ce..15104263059a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -409,7 +409,8 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
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
index 9acf47b11fe6..d22086e1cbc8 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -805,6 +805,13 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 		ASSERT(inode_in->i_sb == inode_out->i_sb);
 	}
 
+	/*
+	 * Can only reflink encrypted files if both files are encrypted.
+	 */
+	if (!fscrypt_have_same_policy(inode_in, inode_out)) {
+		return -EINVAL;
+	}
+
 	/* Don't make the dst file partly checksummed */
 	if ((BTRFS_I(inode_in)->flags & BTRFS_INODE_NODATASUM) !=
 	    (BTRFS_I(inode_out)->flags & BTRFS_INODE_NODATASUM)) {
-- 
2.35.1

