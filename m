Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D8A3B896B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Jun 2021 22:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbhF3UE0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Jun 2021 16:04:26 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:37715 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233693AbhF3UEZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Jun 2021 16:04:25 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 272D932002B6;
        Wed, 30 Jun 2021 16:01:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 30 Jun 2021 16:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm1; bh=CvVvgl3Py1DO/gduKygw3lhkAS
        qzaymkTpkBSrUuV6E=; b=hXK5xCRIPSxxTlkPBDeejmrkGtPARKS9SS+CxE0zxx
        9pZZDhpn9feWVMXpWc10AJ1Q6ZriWCPjt4nE74bptOcOtVOjvQUnyTVsT32v6vpQ
        /wxTfevOiCKuz+96KwtN108UYf1EgwGSnYXT2jMqm6nGabteZoa+D754t7zDS2m4
        wOxGewS2OZwYB+JIBnSRowXv/J9P6dZjKDEZdkP5tx/GWwdXwqOtk20dDtsp7G3D
        sxKmCbZrFnan1Hk2lFQBLl85N3MBVSJsOve0Wj7/12X94bsn2EfWKYcO/TnFjni2
        PSlsK98TNARLe9+xath8HGgR2cjSrmZZUI7XoqcTgMIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=CvVvgl3Py1DO/gduKygw3lhkASqzaymkTpkBSrUuV6E=; b=Bzolxd2/
        fO8oZlpLYtobUSz6wY3p7GsomVQWOgbiTrd5nCCD4o7yHyrrGYxvyjIUDbCdrdau
        HoNXV8yAfaPivPOLlkFHlmSaONNRWtZvF+F/mnMKlJOVLSAulHyT0rmXhNe37kj9
        j9IrRamJ4qx+aq3GZ3TpEarSn4rFwFZ145I9jQQKsuhVBLOjjr8QGAuNx0Zh7A9v
        eQpSZXFfzr2qawJs4R0D4cEpvhjDCIz17ho+6eousKmIamoVYV7PRy4wQ5K0iE2L
        8t1wv9C5QLrhjshM3uCnNEX2+DLCwm57/4uVf1ckjx9eqr25a26YK47u0xMrup78
        3UxEbjtmoTWNIw==
X-ME-Sender: <xms:s83cYMERxore5zTTuRzVn4_R6MYF0QxfeWMTNU2KHvnA0Humnj08wg>
    <xme:s83cYFURKw7DK9Xjs5_qH4EJ_6Ka3ajJ89x4IU88KKyf4j299IaK00_xbbq9WdNV9
    KMZRyyLvA18lCflBoc>
X-ME-Received: <xmr:s83cYGIXpWEIzpVK2BlgEzVfos2HaL-hT_lfmeDkHaWd02Ti8Nnp_7FpLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeigedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffve
    dvhedtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:s83cYOFsiLUxDTDb_n_MlGWcqcZIkxO5b_JLvhhN4BBDsHZ5UtewUQ>
    <xmx:s83cYCVGmJZms7U1QXe9rntsSX7xdb0VOiLmE5V5T0jpFUi49dlEVQ>
    <xmx:s83cYBO43S6HBX_eaLEZpy6DdSL7bfjXuc4-VC8CAOVl_rcSJYpL3w>
    <xmx:s83cYFfTEbnw17Peffy0eE-XlLV-RrDjPxwSYTOJ1b0oHpXYsHHIXQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Jun 2021 16:01:55 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v6 1/3] btrfs: add ro compat flags to inodes
Date:   Wed, 30 Jun 2021 13:01:48 -0700
Message-Id: <423b23a37cdbc71f0860dc00f9518aa354939ae8.1625083099.git.boris@bur.io>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1625083099.git.boris@bur.io>
References: <cover.1625083099.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Currently, inode flags are fully backwards incompatible in btrfs. If we
introduce a new inode flag, then tree-checker will detect it and fail.
This can even cause us to fail to mount entirely. To make it possible to
introduce new flags which can be read-only compatible, like VERITY, we
add new ro flags to btrfs without treating them quite so harshly in
tree-checker. A read-only file system can survive an unexpected flag,
and can be mounted.

As for the implementation, it unfortunately gets a little complicated.

The on-disk representation of the inode, btrfs_inode_item, has an __le64
for flags but the in-memory representation, btrfs_inode, uses a u32.
Dave Sterba had the nice idea that we could reclaim those wasted 32 bits
on disk and use them for the new ro-compat flags.

It turns out that the tree-checker code which checks for unknown flags
is broken, and ignores the upper 32 bits we are hoping to use. The issue
is that the flags use the literal 1 rather than 1ULL, so the flags are
signed ints, and one of them is specifically (1 << 31). As a result, the
mask which ORs the flags is a negative integer on machines where int is
32 bit twos complement. When tree-checker evaluates the expression:

btrfs_inode_flags(leaf, iitem) & ~BTRFS_INODE_FLAG_MASK)

The mask is something like 0x80000abc, which gets promoted to u64 with
sign extension to 0xffffffff80000abc. Negating that 64 bit mask leaves
all the upper bits zeroed, and we can't detect unexpected flags.

This suggests that we can't use those bits after all. Luckily, we have
good reason to believe that they are zero anyway. Inode flags are
metadata, which is always checksummed, so any bit flips that would
introduce 1s would cause a checksum failure anyway (excluding the
improbable case of the checksum getting corruped exactly badly).
Further, unless the 1 << 31 flag is used, the cast to u64 of the 32 bit
inode flag should preserve its value and not add leading zeroes
(at least for twos complement..) The only place that flag
(BTRFS_INODE_ROOT_ITEM_INIT) is used is in a special inode embedded in
the root item, and indeed for that inode we see 0xffffffff80000000 as
the flags on disk. However, that inode is never seen by tree checker,
nor is it used in a context where verity might be meaningful.
Theoretically, a future ro flag might cause trouble on that inode, so we
should proactively clean up that mess before it does.

With the introduction of the new ro flags, keep two separate unsigned
masks and check them against the appropriate u32. Since we no longer run
afoul of sign extension, this also stops writing out 0xffffffff80000000
in root_item inodes going forward.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/btrfs_inode.h   | 20 +++++++++++++++++++-
 fs/btrfs/ctree.h         | 30 ++++++++++++++++--------------
 fs/btrfs/delayed-inode.c |  9 +++++++--
 fs/btrfs/inode.c         |  9 +++++++--
 fs/btrfs/ioctl.c         |  7 ++++---
 fs/btrfs/tree-checker.c  | 18 ++++++++++++++----
 fs/btrfs/tree-log.c      |  5 ++++-
 7 files changed, 71 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index c652e19ad74e..1093b00130be 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -189,8 +189,10 @@ struct btrfs_inode {
 	 */
 	u64 csum_bytes;
 
-	/* flags field from the on disk inode */
+	/* Backwards incompatible flags, lower half of inode_item::flags  */
 	u32 flags;
+	/* Read-only compatibility flags, upper half of inode_item::flags */
+	u32 ro_flags;
 
 	/*
 	 * Counters to keep track of the number of extent item's we may use due
@@ -348,6 +350,22 @@ struct btrfs_dio_private {
 	u8 csums[];
 };
 
+/*
+ * btrfs_inode_item stores flags in a u64, btrfs_inode stores them in two
+ * separate u32s. These two functions convert between the two representations.
+ */
+static inline u64 btrfs_inode_combine_flags(u32 flags, u32 ro_flags)
+{
+	return (flags | ((u64)ro_flags << 32));
+}
+
+static inline void btrfs_inode_split_flags(u64 inode_item_flags,
+					   u32 *flags, u32 *ro_flags)
+{
+	*flags = (u32)inode_item_flags;
+	*ro_flags = (u32)(inode_item_flags >> 32);
+}
+
 /* Array of bytes with variable length, hexadecimal format 0x1234 */
 #define CSUM_FMT				"0x%*phN"
 #define CSUM_FMT_VALUE(size, bytes)		size, bytes
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d7ef4d7d2c1a..422bcc93977e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1486,20 +1486,20 @@ do {                                                                   \
 /*
  * Inode flags
  */
-#define BTRFS_INODE_NODATASUM		(1 << 0)
-#define BTRFS_INODE_NODATACOW		(1 << 1)
-#define BTRFS_INODE_READONLY		(1 << 2)
-#define BTRFS_INODE_NOCOMPRESS		(1 << 3)
-#define BTRFS_INODE_PREALLOC		(1 << 4)
-#define BTRFS_INODE_SYNC		(1 << 5)
-#define BTRFS_INODE_IMMUTABLE		(1 << 6)
-#define BTRFS_INODE_APPEND		(1 << 7)
-#define BTRFS_INODE_NODUMP		(1 << 8)
-#define BTRFS_INODE_NOATIME		(1 << 9)
-#define BTRFS_INODE_DIRSYNC		(1 << 10)
-#define BTRFS_INODE_COMPRESS		(1 << 11)
-
-#define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
+#define BTRFS_INODE_NODATASUM		(1U << 0)
+#define BTRFS_INODE_NODATACOW		(1U << 1)
+#define BTRFS_INODE_READONLY		(1U << 2)
+#define BTRFS_INODE_NOCOMPRESS		(1U << 3)
+#define BTRFS_INODE_PREALLOC		(1U << 4)
+#define BTRFS_INODE_SYNC		(1U << 5)
+#define BTRFS_INODE_IMMUTABLE		(1U << 6)
+#define BTRFS_INODE_APPEND		(1U << 7)
+#define BTRFS_INODE_NODUMP		(1U << 8)
+#define BTRFS_INODE_NOATIME		(1U << 9)
+#define BTRFS_INODE_DIRSYNC		(1U << 10)
+#define BTRFS_INODE_COMPRESS		(1U << 11)
+
+#define BTRFS_INODE_ROOT_ITEM_INIT	(1U << 31)
 
 #define BTRFS_INODE_FLAG_MASK						\
 	(BTRFS_INODE_NODATASUM |					\
@@ -1516,6 +1516,8 @@ do {                                                                   \
 	 BTRFS_INODE_COMPRESS |						\
 	 BTRFS_INODE_ROOT_ITEM_INIT)
 
+#define BTRFS_INODE_RO_FLAG_MASK					(0)
+
 struct btrfs_map_token {
 	struct extent_buffer *eb;
 	char *kaddr;
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 257c1e18abd4..27be3150e537 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1711,6 +1711,8 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 				  struct btrfs_inode_item *inode_item,
 				  struct inode *inode)
 {
+	u64 flags;
+
 	btrfs_set_stack_inode_uid(inode_item, i_uid_read(inode));
 	btrfs_set_stack_inode_gid(inode_item, i_gid_read(inode));
 	btrfs_set_stack_inode_size(inode_item, BTRFS_I(inode)->disk_i_size);
@@ -1723,7 +1725,9 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 				       inode_peek_iversion(inode));
 	btrfs_set_stack_inode_transid(inode_item, trans->transid);
 	btrfs_set_stack_inode_rdev(inode_item, inode->i_rdev);
-	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
+	flags = btrfs_inode_combine_flags(BTRFS_I(inode)->flags,
+					  BTRFS_I(inode)->ro_flags);
+	btrfs_set_stack_inode_flags(inode_item, flags);
 	btrfs_set_stack_inode_block_group(inode_item, 0);
 
 	btrfs_set_stack_timespec_sec(&inode_item->atime,
@@ -1781,7 +1785,8 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 				   btrfs_stack_inode_sequence(inode_item));
 	inode->i_rdev = 0;
 	*rdev = btrfs_stack_inode_rdev(inode_item);
-	BTRFS_I(inode)->flags = btrfs_stack_inode_flags(inode_item);
+	btrfs_inode_split_flags(btrfs_stack_inode_flags(inode_item),
+				&BTRFS_I(inode)->flags, &BTRFS_I(inode)->ro_flags);
 
 	inode->i_atime.tv_sec = btrfs_stack_timespec_sec(&inode_item->atime);
 	inode->i_atime.tv_nsec = btrfs_stack_timespec_nsec(&inode_item->atime);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e6eb20987351..be27cccea1a9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3639,7 +3639,8 @@ static int btrfs_read_locked_inode(struct inode *inode,
 	rdev = btrfs_inode_rdev(leaf, inode_item);
 
 	BTRFS_I(inode)->index_cnt = (u64)-1;
-	BTRFS_I(inode)->flags = btrfs_inode_flags(leaf, inode_item);
+	btrfs_inode_split_flags(btrfs_inode_flags(leaf, inode_item),
+				&BTRFS_I(inode)->flags, &BTRFS_I(inode)->ro_flags);
 
 cache_index:
 	/*
@@ -3770,6 +3771,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    struct inode *inode)
 {
 	struct btrfs_map_token token;
+	u64 flags;
 
 	btrfs_init_map_token(&token, leaf);
 
@@ -3805,7 +3807,9 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_token_inode_sequence(&token, item, inode_peek_iversion(inode));
 	btrfs_set_token_inode_transid(&token, item, trans->transid);
 	btrfs_set_token_inode_rdev(&token, item, inode->i_rdev);
-	btrfs_set_token_inode_flags(&token, item, BTRFS_I(inode)->flags);
+	flags = btrfs_inode_combine_flags(BTRFS_I(inode)->flags,
+					  BTRFS_I(inode)->ro_flags);
+	btrfs_set_token_inode_flags(&token, item, flags);
 	btrfs_set_token_inode_block_group(&token, item, 0);
 }
 
@@ -8904,6 +8908,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->defrag_bytes = 0;
 	ei->disk_i_size = 0;
 	ei->flags = 0;
+	ei->ro_flags = 0;
 	ei->csum_bytes = 0;
 	ei->index_cnt = (u64)-1;
 	ei->dir_index = 0;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0ba98e08a029..8007364f064d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -103,9 +103,10 @@ static unsigned int btrfs_mask_fsflags_for_type(struct inode *inode,
  * Export internal inode flags to the format expected by the FS_IOC_GETFLAGS
  * ioctl.
  */
-static unsigned int btrfs_inode_flags_to_fsflags(unsigned int flags)
+static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
 {
 	unsigned int iflags = 0;
+	u32 flags = binode->flags;
 
 	if (flags & BTRFS_INODE_SYNC)
 		iflags |= FS_SYNC_FL;
@@ -200,7 +201,7 @@ int btrfs_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 {
 	struct btrfs_inode *binode = BTRFS_I(d_inode(dentry));
 
-	fileattr_fill_flags(fa, btrfs_inode_flags_to_fsflags(binode->flags));
+	fileattr_fill_flags(fa, btrfs_inode_flags_to_fsflags(binode));
 	return 0;
 }
 
@@ -224,7 +225,7 @@ int btrfs_fileattr_set(struct user_namespace *mnt_userns,
 		return -EOPNOTSUPP;
 
 	fsflags = btrfs_mask_fsflags_for_type(inode, fa->flags);
-	old_fsflags = btrfs_inode_flags_to_fsflags(binode->flags);
+	old_fsflags = btrfs_inode_flags_to_fsflags(binode);
 	ret = check_fsflags(old_fsflags, fsflags);
 	if (ret)
 		return ret;
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index a8b2e0d2c025..a4a9620957a6 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -24,6 +24,7 @@
 #include "compression.h"
 #include "volumes.h"
 #include "misc.h"
+#include "btrfs_inode.h"
 
 /*
  * Error message should follow the following format:
@@ -999,6 +1000,8 @@ static int check_inode_item(struct extent_buffer *leaf,
 	u32 valid_mask = (S_IFMT | S_ISUID | S_ISGID | S_ISVTX | 0777);
 	u32 mode;
 	int ret;
+	u32 flags;
+	u32 ro_flags;
 
 	ret = check_inode_key(leaf, key, slot);
 	if (unlikely(ret < 0))
@@ -1054,11 +1057,18 @@ static int check_inode_item(struct extent_buffer *leaf,
 			btrfs_inode_nlink(leaf, iitem));
 		return -EUCLEAN;
 	}
-	if (unlikely(btrfs_inode_flags(leaf, iitem) & ~BTRFS_INODE_FLAG_MASK)) {
+	btrfs_inode_split_flags(btrfs_inode_flags(leaf, iitem),
+				&flags, &ro_flags);
+	if (unlikely(flags & ~BTRFS_INODE_FLAG_MASK)) {
 		inode_item_err(leaf, slot,
-			       "unknown flags detected: 0x%llx",
-			       btrfs_inode_flags(leaf, iitem) &
-			       ~BTRFS_INODE_FLAG_MASK);
+			       "unknown incompat flags detected: 0x%x", flags);
+		return -EUCLEAN;
+	}
+	if (unlikely(!sb_rdonly(fs_info->sb) &&
+		     (ro_flags & ~BTRFS_INODE_RO_FLAG_MASK))) {
+		inode_item_err(leaf, slot,
+			       "unknown ro-compat flags detected on writeable mount: 0x%x",
+			       ro_flags);
 		return -EUCLEAN;
 	}
 	return 0;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index cab451d19547..25d8616692e4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3913,6 +3913,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    u64 logged_isize)
 {
 	struct btrfs_map_token token;
+	u64 flags;
 
 	btrfs_init_map_token(&token, leaf);
 
@@ -3962,7 +3963,9 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_token_inode_sequence(&token, item, inode_peek_iversion(inode));
 	btrfs_set_token_inode_transid(&token, item, trans->transid);
 	btrfs_set_token_inode_rdev(&token, item, inode->i_rdev);
-	btrfs_set_token_inode_flags(&token, item, BTRFS_I(inode)->flags);
+	flags = btrfs_inode_combine_flags(BTRFS_I(inode)->flags,
+					  BTRFS_I(inode)->ro_flags);
+	btrfs_set_token_inode_flags(&token, item, flags);
 	btrfs_set_token_inode_block_group(&token, item, 0);
 }
 
-- 
2.31.1

