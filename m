Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1355ADC82
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Sep 2022 02:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiIFAgD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Sep 2022 20:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235444AbiIFAgB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Sep 2022 20:36:01 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49746AA0E;
        Mon,  5 Sep 2022 17:36:00 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id C04988110B;
        Mon,  5 Sep 2022 20:35:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662424560; bh=TSnH1AvkQlEh4dSfg/qC9KaSCmkgkY7apfI9jUsA8Qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbmvOBw2sXhl+Osf3toazBbdB4SoT1SEkf/N+J3tvUcEoEmy1UcGkowwBCbIZtqNd
         m5OJONjhe5sXKFdWiJ+Z/6vM7hndqJrGiJ/56L1u6Nk1eznwACHkF7qGWYPapwDxdF
         RR8QeTDQvY/hgWP7REjRDPkc4ynd00Ah2HR8NYRnklYyBFsNYikMDIA59ftNhoucJP
         5AXXMFgkwuwmj+IqlbjZsQ2tehD38uaTAvA1SY0eJ+v8XaeDVFMBnsVoQOgABPthDG
         4+SU+L/h1nhrbdxZaAYXctTYBIFLk5DBNwZEpVcvVGnl33+fYb0B1XfA9aRz0dXoXt
         fXpYNs80atKTA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 11/20] btrfs: disable various operations on encrypted inodes
Date:   Mon,  5 Sep 2022 20:35:26 -0400
Message-Id: <927dbeab576537ac0e4c954a8c3d13b148cd6a26.1662420176.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1662420176.git.sweettea-kernel@dorminy.me>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
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
index 0a76ae8b8e96..7216ac1f860c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1895,7 +1895,7 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 		goto relock;
 	}
 
-	if (check_direct_IO(fs_info, from, pos)) {
+	if (IS_ENCRYPTED(inode) || check_direct_IO(fs_info, from, pos)) {
 		btrfs_inode_unlock(inode, ilock_flags);
 		goto buffered;
 	}
@@ -3729,7 +3729,7 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 	ssize_t read = 0;
 	ssize_t ret;
 
-	if (fsverity_active(inode))
+	if (IS_ENCRYPTED(inode) || fsverity_active(inode))
 		return 0;
 
 	if (check_direct_read(btrfs_sb(inode->i_sb), to, iocb->ki_pos))
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 482c5b3d9e70..fea48c12a33a 100644
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

