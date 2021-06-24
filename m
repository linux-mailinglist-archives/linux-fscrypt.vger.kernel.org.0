Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D91A3B3954
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Jun 2021 00:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhFXWnj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 24 Jun 2021 18:43:39 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:56627 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229643AbhFXWni (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 24 Jun 2021 18:43:38 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id B788A32007E8;
        Thu, 24 Jun 2021 18:41:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 24 Jun 2021 18:41:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm1; bh=oRTBr/GDaZZuUv+nTfzlWoQaB+
        idTALKh5Gdz/PMhXQ=; b=nXSFeLSlaA+Tmp3sTF8rnoXublUxfn9sMzclYZEyNx
        AQT2cNrbZw9EMyv6rKSeDWBgfJmWkP/JKfwX0/exHKD5N8UAGFZj7TZOMicI6TEa
        uMom1b6VRQumXc7PgbX9bgWdH6UnIqUkJFKLtOASvIf1POJ10CS7ZpgT5Zpp43ws
        SuQyZ7w+pKIYttyKooHWPUBIBEnbdcPRvPdR4MQFLyPACUaaCKWpwqIWABAR4KVa
        935ADXwREBcZsTfIKEO5/3w0gUJnFyF7mSIordN+1YWYhAxpBU4BZTSecxesod4S
        /TB05pMe0LF8C12rSs1QQWRlh0t7k6qqAIAopjMIByZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=oRTBr/GDaZZuUv+nTfzlWoQaB+idTALKh5Gdz/PMhXQ=; b=DpsQ4f1N
        0EC4ONw+JCxE5+aHxe2y7hd+MZNnc8m7Qq/Wm760jSfVi0+cb/2GRvwFbS9VRwID
        7sYE3c4u5oDNbyNclQLJ40eYOjJnqES98vG9bWRKsMBrQvbhs259Uq4WSo7Q96qx
        Q9pIpLIh2rPYjZstE03c3pnCb7h2D/tR0962fpw2eTnbrIS3910AA6ekEUuzYzDU
        qglLE2qEfzSqeGbs7SdxiKRjFxH6jZlSDH64PaZGERUyoR1IdNSEpTyCjoLtEzjw
        qV+S0POcaJEaZfOXXSL3SAyzTXKHL3ZPuPa7Qb3CMTMrTjUEbMUYG58ee1mw148Q
        y+50V2v4KIaitw==
X-ME-Sender: <xms:DgrVYJTROIscywHDMtYG6nK3wwoMmCH93xjhKEPUkXtiaob0YstJmA>
    <xme:DgrVYCxQ4idaopD9rMavEOTaVmJqFtpFkBAQJ36y_7vsDrNUTtOX8XP8zoqZgnNQj
    xraAEJNIAtwPQ3OTuE>
X-ME-Received: <xmr:DgrVYO0CVFdZcvtPUlDnFBOShmhew_jidnCeCgeMNp98nPJgTagG5fiYVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegiedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffve
    dvhedtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:DgrVYBCZxSYI7-3hrAFNIC47BfY3NTiHadn9esKntXzPGK1isu4jrw>
    <xmx:DgrVYChQqkAD4-_9CDlzRpothMaEUo6KdB3PS8MJJFjmEBh1mm-8MQ>
    <xmx:DgrVYFqtTqKxb7xG3oE-eiAE7cHBOGAlH1qMEidcsapvoeyZFAdRPQ>
    <xmx:DgrVYGa2MOQTfBBLV0r6bGhC8xsbaUwe_9gsCehAjSVZ8IfR-C_ryQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Jun 2021 18:41:17 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v5 2/3] btrfs: initial fsverity support
Date:   Thu, 24 Jun 2021 15:41:10 -0700
Message-Id: <459e0acf996441628bc465bbe64218d7fea132c4.1624573983.git.boris@bur.io>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624573983.git.boris@bur.io>
References: <cover.1624573983.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add support for fsverity in btrfs. To support the generic interface in
fs/verity, we add two new item types in the fs tree for inodes with
verity enabled. One stores the per-file verity descriptor and btrfs
verity item and the other stores the Merkle tree data itself.

Verity checking is done in end_page_read just before a page is marked
uptodate. This naturally handles a variety of edge cases like holes,
preallocated extents, and inline extents. Some care needs to be taken to
not try to verity pages past the end of the file, which are accessed by
the generic buffered file reading code under some circumstances like
reading to the end of the last page and trying to read again. Direct IO
on a verity file falls back to buffered reads.

Verity relies on PageChecked for the Merkle tree data itself to avoid
re-walking up shared paths in the tree. For this reason, we need to
cache the Merkle tree data. Since the file is immutable after verity is
turned on, we can cache it at an index past EOF.

Use the new inode ro_flags to store verity on the inode item, so that we
can enable verity on a file, then rollback to an older kernel and still
mount the file system and read the file. Since we can't safely write the
file anymore without ruining the invariants of the Merkle tree, we mark
a ro_compat flag on the file system when a file has verity enabled.

Co-developed-by: Chris Mason <clm@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/Makefile               |   1 +
 fs/btrfs/btrfs_inode.h          |   7 +
 fs/btrfs/ctree.h                |  25 +-
 fs/btrfs/extent_io.c            |  25 +-
 fs/btrfs/file.c                 |  10 +
 fs/btrfs/inode.c                |   6 +
 fs/btrfs/ioctl.c                |  14 +-
 fs/btrfs/super.c                |   3 +
 fs/btrfs/sysfs.c                |   6 +
 fs/btrfs/verity.c               | 763 ++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h      |   1 +
 include/uapi/linux/btrfs_tree.h |  35 ++
 12 files changed, 877 insertions(+), 19 deletions(-)
 create mode 100644 fs/btrfs/verity.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index cec88a66bd6c..3dcf9bcc2326 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -36,6 +36,7 @@ btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
 btrfs-$(CONFIG_BTRFS_FS_REF_VERIFY) += ref-verify.o
 btrfs-$(CONFIG_BLK_DEV_ZONED) += zoned.o
+btrfs-$(CONFIG_FS_VERITY) += verity.o
 
 btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o \
 	tests/extent-buffer-tests.o tests/btrfs-tests.o \
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 1093b00130be..76ee1452c57b 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -51,6 +51,13 @@ enum {
 	 * the file range, inode's io_tree).
 	 */
 	BTRFS_INODE_NO_DELALLOC_FLUSH,
+	/*
+	 * Set when we are working on enabling verity for a file. Computing and
+	 * writing the whole Merkle tree can take a while so we want to prevent
+	 * races where two separate tasks attempt to simultaneously start verity
+	 * on the same file.
+	 */
+	BTRFS_INODE_VERITY_IN_PROGRESS,
 };
 
 /* in memory btrfs inode */
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 422bcc93977e..63a99319f6f4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -281,7 +281,8 @@ struct btrfs_super_block {
 
 #define BTRFS_FEATURE_COMPAT_RO_SUPP			\
 	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
-	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID)
+	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID | \
+	 BTRFS_FEATURE_COMPAT_RO_VERITY)
 
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_SET	0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR	0ULL
@@ -1516,7 +1517,9 @@ do {                                                                   \
 	 BTRFS_INODE_COMPRESS |						\
 	 BTRFS_INODE_ROOT_ITEM_INIT)
 
-#define BTRFS_INODE_RO_FLAG_MASK					(0)
+#define BTRFS_INODE_RO_VERITY		(1U << 0)
+
+#define BTRFS_INODE_RO_FLAG_MASK	(BTRFS_INODE_RO_VERITY)
 
 struct btrfs_map_token {
 	struct extent_buffer *eb;
@@ -3783,6 +3786,24 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
 	return signal_pending(current);
 }
 
+/* verity.c */
+#ifdef CONFIG_FS_VERITY
+extern const struct fsverity_operations btrfs_verityops;
+int btrfs_drop_verity_items(struct btrfs_inode *inode);
+BTRFS_SETGET_FUNCS(verity_descriptor_encryption, struct btrfs_verity_descriptor_item,
+		   encryption, 8);
+BTRFS_SETGET_FUNCS(verity_descriptor_size, struct btrfs_verity_descriptor_item, size, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_verity_descriptor_encryption, struct btrfs_verity_descriptor_item,
+			 encryption, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_verity_descriptor_size, struct btrfs_verity_descriptor_item,
+			 size, 64);
+#else
+static inline int btrfs_drop_verity_items(struct btrfs_inode *inode)
+{
+	return 0;
+}
+#endif
+
 /* Sanity test specific functions */
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_destroy_inode(struct inode *inode);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9e81d25dea70..aeaf8fe342dc 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -13,6 +13,7 @@
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
 #include <linux/cleancache.h>
+#include <linux/fsverity.h>
 #include "misc.h"
 #include "extent_io.h"
 #include "extent-io-tree.h"
@@ -2245,18 +2246,6 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	return bitset;
 }
 
-/*
- * helper function to set a given page up to date if all the
- * extents in the tree for that page are up to date
- */
-static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
-{
-	u64 start = page_offset(page);
-	u64 end = start + PAGE_SIZE - 1;
-	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
-		SetPageUptodate(page);
-}
-
 int free_io_failure(struct extent_io_tree *failure_tree,
 		    struct extent_io_tree *io_tree,
 		    struct io_failure_record *rec)
@@ -2688,7 +2677,14 @@ static void end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
 	       start + len <= page_offset(page) + PAGE_SIZE);
 
 	if (uptodate) {
-		btrfs_page_set_uptodate(fs_info, page, start, len);
+		if (!PageError(page) && !PageUptodate(page) &&
+		    start < i_size_read(page->mapping->host) &&
+		    fsverity_active(page->mapping->host) &&
+		    !fsverity_verify_page(page)) {
+			btrfs_page_set_error(fs_info, page, start, len);
+		} else {
+			btrfs_page_set_uptodate(fs_info, page, start, len);
+		}
 	} else {
 		btrfs_page_clear_uptodate(fs_info, page, start, len);
 		btrfs_page_set_error(fs_info, page, start, len);
@@ -3097,7 +3093,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 		/* Update page status and unlock */
 		end_page_read(page, uptodate, start, len);
 		endio_readpage_release_extent(&processed, BTRFS_I(inode),
-					      start, end, uptodate);
+					      start, end, PageUptodate(page));
 	}
 	/* Release the last extent */
 	endio_readpage_release_extent(&processed, NULL, 0, 0, false);
@@ -3627,7 +3623,6 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 		/* the get_extent function already copied into the page */
 		if (test_range_bit(tree, cur, cur_end,
 				   EXTENT_UPTODATE, 1, NULL)) {
-			check_page_uptodate(tree, page);
 			unlock_extent(tree, cur, cur + iosize - 1);
 			end_page_read(page, true, cur, iosize);
 			cur = cur + iosize;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 28a05ba47060..78503b125261 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -16,6 +16,7 @@
 #include <linux/btrfs.h>
 #include <linux/uio.h>
 #include <linux/iversion.h>
+#include <linux/fsverity.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -3605,7 +3606,13 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int whence)
 
 static int btrfs_file_open(struct inode *inode, struct file *filp)
 {
+	int ret;
+
 	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
+
+	ret = fsverity_file_open(inode, filp);
+	if (ret)
+		return ret;
 	return generic_file_open(inode, filp);
 }
 
@@ -3634,6 +3641,9 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	ssize_t ret;
 
+	if (fsverity_active(inode))
+		return 0;
+
 	if (check_direct_read(btrfs_sb(inode->i_sb), to, iocb->ki_pos))
 		return 0;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index be27cccea1a9..9f176a840446 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -32,6 +32,7 @@
 #include <linux/sched/mm.h>
 #include <linux/iomap.h>
 #include <asm/unaligned.h>
+#include <linux/fsverity.h>
 #include "misc.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -5437,6 +5438,7 @@ void btrfs_evict_inode(struct inode *inode)
 	trace_btrfs_inode_evict(inode);
 
 	if (!root) {
+		fsverity_cleanup_inode(inode);
 		clear_inode(inode);
 		return;
 	}
@@ -5519,6 +5521,7 @@ void btrfs_evict_inode(struct inode *inode)
 	 * to retry these periodically in the future.
 	 */
 	btrfs_remove_delayed_node(BTRFS_I(inode));
+	fsverity_cleanup_inode(inode);
 	clear_inode(inode);
 }
 
@@ -9090,6 +9093,7 @@ static int btrfs_getattr(struct user_namespace *mnt_userns,
 	struct inode *inode = d_inode(path->dentry);
 	u32 blocksize = inode->i_sb->s_blocksize;
 	u32 bi_flags = BTRFS_I(inode)->flags;
+	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
 
 	stat->result_mask |= STATX_BTIME;
 	stat->btime.tv_sec = BTRFS_I(inode)->i_otime.tv_sec;
@@ -9102,6 +9106,8 @@ static int btrfs_getattr(struct user_namespace *mnt_userns,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (bi_flags & BTRFS_INODE_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
+	if (bi_ro_flags & BTRFS_INODE_RO_VERITY)
+		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8007364f064d..c4e8f7df384b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/iversion.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "export.h"
@@ -107,6 +108,7 @@ static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
 {
 	unsigned int iflags = 0;
 	u32 flags = binode->flags;
+	u32 ro_flags = binode->ro_flags;
 
 	if (flags & BTRFS_INODE_SYNC)
 		iflags |= FS_SYNC_FL;
@@ -122,6 +124,8 @@ static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
 		iflags |= FS_DIRSYNC_FL;
 	if (flags & BTRFS_INODE_NODATACOW)
 		iflags |= FS_NOCOW_FL;
+	if (ro_flags & BTRFS_INODE_RO_VERITY)
+		iflags |= FS_VERITY_FL;
 
 	if (flags & BTRFS_INODE_NOCOMPRESS)
 		iflags |= FS_NOCOMP_FL;
@@ -149,10 +153,12 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (binode->flags & BTRFS_INODE_DIRSYNC)
 		new_fl |= S_DIRSYNC;
+	if (binode->ro_flags & BTRFS_INODE_RO_VERITY)
+		new_fl |= S_VERITY;
 
 	set_mask_bits(&inode->i_flags,
-		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC,
-		      new_fl);
+		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC |
+		      S_VERITY, new_fl);
 }
 
 /*
@@ -5014,6 +5020,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_subvol_rootref(file, argp);
 	case BTRFS_IOC_INO_LOOKUP_USER:
 		return btrfs_ioctl_ino_lookup_user(file, argp);
+	case FS_IOC_ENABLE_VERITY:
+		return fsverity_ioctl_enable(file, (const void __user *)argp);
+	case FS_IOC_MEASURE_VERITY:
+		return fsverity_ioctl_measure(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d07b18b2b250..e6c5968bd028 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1353,6 +1353,9 @@ static int btrfs_fill_super(struct super_block *sb,
 	sb->s_op = &btrfs_super_ops;
 	sb->s_d_op = &btrfs_dentry_operations;
 	sb->s_export_op = &btrfs_export_ops;
+#ifdef CONFIG_FS_VERITY
+	sb->s_vop = &btrfs_verityops;
+#endif
 	sb->s_xattr = btrfs_xattr_handlers;
 	sb->s_time_gran = 1;
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 9d1d140118ff..e101a0bf392f 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -267,6 +267,9 @@ BTRFS_FEAT_ATTR_INCOMPAT(raid1c34, RAID1C34);
 #ifdef CONFIG_BTRFS_DEBUG
 BTRFS_FEAT_ATTR_INCOMPAT(zoned, ZONED);
 #endif
+#ifdef CONFIG_FS_VERITY
+BTRFS_FEAT_ATTR_COMPAT_RO(verity, VERITY);
+#endif
 
 static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(mixed_backref),
@@ -284,6 +287,9 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(raid1c34),
 #ifdef CONFIG_BTRFS_DEBUG
 	BTRFS_FEAT_ATTR_PTR(zoned),
+#endif
+#ifdef CONFIG_FS_VERITY
+	BTRFS_FEAT_ATTR_PTR(verity),
 #endif
 	NULL
 };
diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
new file mode 100644
index 000000000000..15da6c9e1532
--- /dev/null
+++ b/fs/btrfs/verity.c
@@ -0,0 +1,763 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/rwsem.h>
+#include <linux/xattr.h>
+#include <linux/security.h>
+#include <linux/posix_acl_xattr.h>
+#include <linux/iversion.h>
+#include <linux/fsverity.h>
+#include <linux/sched/mm.h>
+#include "ctree.h"
+#include "btrfs_inode.h"
+#include "transaction.h"
+#include "disk-io.h"
+#include "locking.h"
+
+/*
+ * Implementation of the interface defined in struct fsverity_operations.
+ *
+ * The main question is how and where to store the verity descriptor and the
+ * Merkle tree. We store both in dedicated btree items in the filesystem tree,
+ * together with the rest of the inode metadata. This means we'll need to do
+ * extra work to encrypt them once encryption is supported in btrfs, but btrfs
+ * has a lot of careful code around i_size and it seems better to make a new key
+ * type than try and adjust all of our expectations for i_size.
+ *
+ * Note that this differs from the implementation in ext4 and f2fs, where
+ * this data is stored as if it were in the file, but past EOF. However, btrfs
+ * does not have a widespread mechanism for caching opaque metadata pages, so we
+ * do pretend that the Merkle tree pages themselves are past EOF for the
+ * purposes of caching them (as opposed to creating a virtual inode).
+ *
+ * fs verity items are stored under two different key types on disk.
+ * The descriptor items:
+ * [ inode objectid, BTRFS_VERITY_DESC_ITEM_KEY, offset ]
+ *
+ * At offset 0, we store a btrfs_verity_descriptor_item which tracks the
+ * size of the descriptor item and some extra data for encryption.
+ * Starting at offset 1, these hold the generic fs verity descriptor.
+ * The latter are opaque to btrfs, we just read and write them as a blob for
+ * the higher level verity code.  The most common descriptor size is 256 bytes.
+ *
+ * The merkle tree items:
+ * [ inode objectid, BTRFS_VERITY_MERKLE_ITEM_KEY, offset ]
+ *
+ * These also start at offset 0, and correspond to the merkle tree bytes.
+ * So when fsverity asks for page 0 of the merkle tree, we pull up one page
+ * starting at offset 0 for this key type.  These are also opaque to btrfs,
+ * we're blindly storing whatever fsverity sends down.
+ */
+
+
+#define MERKLE_START_ALIGN 65536
+/*
+ * Compute the logical file offset where we cache the Merkle tree.
+ *
+ * @inode: the inode of the verity file
+ *
+ * For the purposes of caching the Merkle tree pages, as required by
+ * fs-verity, it is convenient to do size computations in terms of a file
+ * offset, rather than in terms of page indices.
+ *
+ * Use 64K to be sure it's past the last page in the file, even with 64k pages.
+ * That rounding operation itself can overflow loff_t, so we do it in u64 and
+ * check.
+ *
+ * Returns the file offset on success, negative error code on failure.
+ */
+static loff_t merkle_file_pos(const struct inode *inode)
+{
+	loff_t ret;
+	u64 sz = inode->i_size;
+	u64 rounded = round_up(sz, MERKLE_START_ALIGN);
+
+	if (rounded > inode->i_sb->s_maxbytes)
+		return -EFBIG;
+	ret = rounded;
+	return ret;
+}
+
+/*
+ * Drop all the items for this inode with this key_type.
+ *
+ * @inode: The inode to drop items for
+ * @key_type: The type of items to drop (VERITY_DESC_ITEM or
+ *            VERITY_MERKLE_ITEM)
+ *
+ * Before doing a verity enable we cleanup any existing verity items.
+ * This is also used to clean up if a verity enable failed half way
+ * through.
+ *
+ * Returns number of dropped items on success, negative error code on failure.
+ */
+static int drop_verity_items(struct btrfs_inode *inode, u8 key_type)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = inode->root;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int count = 0;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	while (1) {
+		/*
+		 * 1 for the item being dropped
+		 */
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto out;
+		}
+
+		/*
+		 * Walk backwards through all the items until we find one
+		 * that isn't from our key type or objectid
+		 */
+		key.objectid = btrfs_ino(inode);
+		key.type = key_type;
+		key.offset = (u64)-1;
+
+		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+		if (ret > 0) {
+			ret = 0;
+			/* No more keys of this type, we're done */
+			if (path->slots[0] == 0)
+				break;
+			path->slots[0]--;
+		} else if (ret < 0) {
+			btrfs_end_transaction(trans);
+			goto out;
+		}
+
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+
+		/* No more keys of this type, we're done */
+		if (key.objectid != btrfs_ino(inode) || key.type != key_type)
+			break;
+
+		/*
+		 * This shouldn't be a performance sensitive function because
+		 * it's not used as part of truncate.  If it ever becomes
+		 * perf sensitive, change this to walk forward and bulk delete
+		 * items
+		 */
+		ret = btrfs_del_items(trans, root, path, path->slots[0], 1);
+		if (ret) {
+			btrfs_end_transaction(trans);
+			goto out;
+		}
+		count++;
+		btrfs_release_path(path);
+		btrfs_end_transaction(trans);
+	}
+	ret = count;
+	btrfs_end_transaction(trans);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+/*
+ * Drop all verity items
+ *
+ * @inode: the inode to drop verity items for.
+ *
+ * In most contexts where we are dropping verity items, we want to do it for all
+ * the types of verity items, not a particular one.
+ *
+ * Returns: 0 on success, negative error code on failure.
+ */
+int btrfs_drop_verity_items(struct btrfs_inode *inode)
+{
+	int ret;
+
+	ret = drop_verity_items(inode, BTRFS_VERITY_DESC_ITEM_KEY);
+	if (ret < 0)
+		goto out;
+	ret = drop_verity_items(inode, BTRFS_VERITY_MERKLE_ITEM_KEY);
+	if (ret < 0)
+		goto out;
+	ret = 0;
+out:
+	return ret;
+}
+
+
+/*
+ * Insert and write inode items with a given key type and offset.
+ *
+ * @inode: The inode to insert for.
+ * @key_type: The key type to insert.
+ * @offset: The item offset to insert at.
+ * @src: Source data to write.
+ * @len: Length of source data to write.
+ *
+ * Write len bytes from src into items of up to 1k length.
+ * The inserted items will have key <ino, key_type, offset + off> where
+ * off is consecutively increasing from 0 up to the last item ending at
+ * offset + len.
+ *
+ * Returns 0 on success and a negative error code on failure.
+ */
+static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
+			   const char *src, u64 len)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path;
+	struct btrfs_root *root = inode->root;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	u64 copied = 0;
+	unsigned long copy_bytes;
+	unsigned long src_offset = 0;
+	void *data;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	while (len > 0) {
+		/*
+		 * 1 for the new item being inserted
+		 */
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
+
+		key.objectid = btrfs_ino(inode);
+		key.type = key_type;
+		key.offset = offset;
+
+		/*
+		 * Insert 2K at a time mostly to be friendly for smaller
+		 * leaf size filesystems
+		 */
+		copy_bytes = min_t(u64, len, 2048);
+
+		ret = btrfs_insert_empty_item(trans, root, path, &key, copy_bytes);
+		if (ret) {
+			btrfs_end_transaction(trans);
+			break;
+		}
+
+		leaf = path->nodes[0];
+
+		data = btrfs_item_ptr(leaf, path->slots[0], void);
+		write_extent_buffer(leaf, src + src_offset,
+				    (unsigned long)data, copy_bytes);
+		offset += copy_bytes;
+		src_offset += copy_bytes;
+		len -= copy_bytes;
+		copied += copy_bytes;
+
+		btrfs_release_path(path);
+		btrfs_end_transaction(trans);
+	}
+
+	btrfs_free_path(path);
+	return ret;
+}
+
+/*
+ * Read inode items of the given key type and offset from the btree.
+ *
+ * @inode: The inode to read items of.
+ * @key_type: The key type to read.
+ * @offset: The item offset to read from.
+ * @dest: The buffer to read into. This parameter has slightly tricky
+ *        semantics.  If it is NULL, the function will not do any copying
+ *        and will just return the size of all the items up to len bytes.
+ *        If dest_page is passed, then the function will kmap_local the
+ *        page and ignore dest, but it must still be non-NULL to avoid the
+ *        counting-only behavior.
+ * @len: Length in bytes to read.
+ * @dest_page: Copy into this page instead of the dest buffer.
+ *
+ * Helper function to read items from the btree.  This returns the number
+ * of bytes read or < 0 for errors.  We can return short reads if the
+ * items don't exist on disk or aren't big enough to fill the desired length.
+ * Supports reading into a provided buffer (dest) or into the page cache
+ *
+ * Returns number of bytes read or a negative error code on failure.
+ */
+static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
+			  char *dest, u64 len, struct page *dest_page)
+{
+	struct btrfs_path *path;
+	struct btrfs_root *root = inode->root;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	u64 item_end;
+	u64 copy_end;
+	int copied = 0;
+	u32 copy_offset;
+	unsigned long copy_bytes;
+	unsigned long dest_offset = 0;
+	void *data;
+	char *kaddr = dest;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	if (dest_page)
+		path->reada = READA_FORWARD;
+
+	key.objectid = btrfs_ino(inode);
+	key.type = key_type;
+	key.offset = offset;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		goto out;
+	} else if (ret > 0) {
+		ret = 0;
+		if (path->slots[0] == 0)
+			goto out;
+		path->slots[0]--;
+	}
+
+	while (len > 0) {
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+		if (key.objectid != btrfs_ino(inode) ||
+		    key.type != key_type)
+			break;
+
+		item_end = btrfs_item_size_nr(leaf, path->slots[0]) + key.offset;
+
+		if (copied > 0) {
+			/*
+			 * Once we've copied something, we want all of the items
+			 * to be sequential
+			 */
+			if (key.offset != offset)
+				break;
+		} else {
+			/*
+			 * Our initial offset might be in the middle of an
+			 * item.  Make sure it all makes sense
+			 */
+			if (key.offset > offset)
+				break;
+			if (item_end <= offset)
+				break;
+		}
+
+		/* desc = NULL to just sum all the item lengths */
+		if (!dest)
+			copy_end = item_end;
+		else
+			copy_end = min(offset + len, item_end);
+
+		/* Number of bytes in this item we want to copy */
+		copy_bytes = copy_end - offset;
+
+		/* Offset from the start of item for copying */
+		copy_offset = offset - key.offset;
+
+		if (dest) {
+			if (dest_page)
+				kaddr = kmap_local_page(dest_page);
+
+			data = btrfs_item_ptr(leaf, path->slots[0], void);
+			read_extent_buffer(leaf, kaddr + dest_offset,
+					   (unsigned long)data + copy_offset,
+					   copy_bytes);
+
+			if (dest_page)
+				kunmap_local(kaddr);
+		}
+
+		offset += copy_bytes;
+		dest_offset += copy_bytes;
+		len -= copy_bytes;
+		copied += copy_bytes;
+
+		path->slots[0]++;
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			/*
+			 * We've reached the last slot in this leaf and we need
+			 * to go to the next leaf.
+			 */
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0) {
+				break;
+			} else if (ret > 0) {
+				ret = 0;
+				break;
+			}
+		}
+	}
+out:
+	btrfs_free_path(path);
+	if (!ret)
+		ret = copied;
+	return ret;
+}
+
+/*
+ * Rollback in-progress verity if we encounter an error.
+ *
+ * @inode: the inode verity had an error for
+ *
+ * We try to handle recoverable errors while enabling verity by rolling it
+ * back and just failing the operation, rather than having an fs level error no
+ * matter what. However, any error in rollback is unrecoverable.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int rollback_verity(struct btrfs_inode *inode)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = inode->root;
+	int ret;
+
+	ASSERT(inode_is_locked(&inode->vfs_inode));
+	truncate_inode_pages(inode->vfs_inode.i_mapping,
+			     inode->vfs_inode.i_size);
+	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
+	ret = btrfs_drop_verity_items(inode);
+	if (ret) {
+		btrfs_handle_fs_error(root->fs_info, ret,
+				      "failed to drop verity items in rollback %lu\n",
+				      inode->vfs_inode.i_ino);
+		goto out;
+	}
+	/*
+	 * 1 for updating the inode flag
+	 */
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		btrfs_handle_fs_error(root->fs_info, ret,
+				      "failed to start transaction in verity rollback %lu\n",
+				      inode->vfs_inode.i_ino);
+		goto out;
+	}
+	inode->ro_flags &= ~BTRFS_INODE_RO_VERITY;
+	btrfs_sync_inode_flags_to_i_flags(&inode->vfs_inode);
+	ret = btrfs_update_inode(trans, root, inode);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto out;
+	}
+	btrfs_end_transaction(trans);
+out:
+	return ret;
+}
+
+/*
+ * Finalize making the file a valid verity file
+ *
+ * @inode: the inode to be marked as verity
+ * @desc: the contents of the verity descriptor to write (not NULL)
+ * @desc_size: the size of the verity descriptor
+ *
+ * Do the actual work of finalizing verity after successfully writing the Merkle
+ * tree:
+ * - write out the descriptor items
+ * - mark the inode with the verity flag
+ * - mark the ro compat bit
+ * - clear the in progress bit
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int finish_verity(struct btrfs_inode *inode,
+			 const void *desc, size_t desc_size)
+{
+	struct btrfs_trans_handle *trans = NULL;
+	struct btrfs_root *root = inode->root;
+	struct btrfs_verity_descriptor_item item;
+	int ret;
+
+	/* Write out the descriptor item */
+	memset(&item, 0, sizeof(item));
+	btrfs_set_stack_verity_descriptor_size(&item, desc_size);
+	ret = write_key_bytes(inode,
+			      BTRFS_VERITY_DESC_ITEM_KEY, 0,
+			      (const char *)&item, sizeof(item));
+	if (ret)
+		goto out;
+	/* Write out the descriptor itself */
+	ret = write_key_bytes(inode,
+			      BTRFS_VERITY_DESC_ITEM_KEY, 1,
+			      desc, desc_size);
+	if (ret)
+		goto out;
+
+	/*
+	 * 1 for updating the inode flag
+	 */
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+	inode->ro_flags |= BTRFS_INODE_RO_VERITY;
+	btrfs_sync_inode_flags_to_i_flags(&inode->vfs_inode);
+	ret = btrfs_update_inode(trans, root, inode);
+	if (ret)
+		goto end_trans;
+	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
+	btrfs_set_fs_compat_ro(root->fs_info, VERITY);
+end_trans:
+	btrfs_end_transaction(trans);
+out:
+	return ret;
+
+}
+
+/*
+ * fsverity op that begins enabling verity.
+ *
+ * @filp: the file to enable verity on
+ *
+ * Begin enabling fsverity for the file. We drop any existing verity items
+ * and set the in progress bit.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int btrfs_begin_enable_verity(struct file *filp)
+{
+	struct btrfs_inode *inode = BTRFS_I(file_inode(filp));
+	struct btrfs_root *root = inode->root;
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	ASSERT(inode_is_locked(file_inode(filp)));
+
+	if (test_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = btrfs_drop_verity_items(inode);
+	if (ret)
+		goto out;
+
+	set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
+	btrfs_end_transaction(trans);
+out:
+	return ret;
+}
+
+/*
+ * fsverity op that ends enabling verity.
+ *
+ * @filp: the file we are finishing enabling verity on
+ * @desc: the verity descriptor to write out (NULL in error conditions)
+ * @desc_size: the size of the verity descriptor (variable with signatures)
+ * @merkle_tree_size: the size of the merkle tree in bytes
+ *
+ * If desc is null, then VFS is signaling an error occurred during verity
+ * enable, and we should try to rollback. Otherwise, attempt to finish verity.
+ *
+ * Returns 0 on success, negative error code on error.
+ */
+static int btrfs_end_enable_verity(struct file *filp, const void *desc,
+				   size_t desc_size, u64 merkle_tree_size)
+{
+	struct btrfs_inode *inode = BTRFS_I(file_inode(filp));
+	int ret = 0;
+	int rollback_ret;
+
+	ASSERT(inode_is_locked(file_inode(filp)));
+
+	if (desc == NULL)
+		goto rollback;
+
+	ret = finish_verity(inode, desc, desc_size);
+	if (ret)
+		goto rollback;
+	return ret;
+
+
+rollback:
+	rollback_ret = rollback_verity(inode);
+	if (rollback_ret)
+		btrfs_err(inode->root->fs_info,
+			  "failed to rollback verity items: %d", rollback_ret);
+	return ret;
+}
+
+/*
+ * fsverity op that gets the struct fsverity_descriptor.
+ *
+ * @inode: the inode to get the descriptor of
+ * @buf: output buffer for the descriptor contents
+ * @buf_size: size of the output buffer. 0 to query the size.
+ *
+ * fsverity does a two pass setup for reading the descriptor, in the first pass
+ * it calls with buf_size = 0 to query the size of the descriptor,
+ * and then in the second pass it actually reads the descriptor off
+ * disk.
+ *
+ * Returns the size on success or a negative error code on failure.
+ */
+static int btrfs_get_verity_descriptor(struct inode *inode, void *buf,
+				       size_t buf_size)
+{
+	u64 true_size;
+	int ret = 0;
+	struct btrfs_verity_descriptor_item item;
+
+	memset(&item, 0, sizeof(item));
+	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY,
+			     0, (char *)&item, sizeof(item), NULL);
+	if (ret < 0)
+		return ret;
+
+	if (item.reserved[0] != 0 || item.reserved[1] != 0)
+		return -EUCLEAN;
+
+	true_size = btrfs_stack_verity_descriptor_size(&item);
+	if (true_size > INT_MAX)
+		return -EUCLEAN;
+
+	if (!buf_size)
+		return true_size;
+	if (buf_size < true_size)
+		return -ERANGE;
+
+	ret = read_key_bytes(BTRFS_I(inode),
+			     BTRFS_VERITY_DESC_ITEM_KEY, 1,
+			     buf, buf_size, NULL);
+	if (ret < 0)
+		return ret;
+	if (ret != true_size)
+		return -EIO;
+
+	return true_size;
+}
+
+/*
+ * fsverity op that reads and caches a merkle tree page.
+ *
+ * @inode: the inode to read a merkle tree page for
+ * @index: the page index relative to the start of the merkle tree
+ * @num_ra_pages: number of pages to readahead. Optional, we ignore it.
+ *
+ * The Merkle tree is stored in the filesystem btree, but its pages are cached
+ * with a logical position past EOF in the inode's mapping.
+ *
+ * Returns the page we read, or an ERR_PTR on error.
+ */
+static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
+					       pgoff_t index,
+					       unsigned long num_ra_pages)
+{
+	struct page *page;
+	u64 off = (u64)index << PAGE_SHIFT;
+	loff_t merkle_pos = merkle_file_pos(inode);
+	int ret;
+
+	if (merkle_pos < 0)
+		return ERR_PTR(merkle_pos);
+	if (merkle_pos > inode->i_sb->s_maxbytes - off - PAGE_SIZE)
+		return ERR_PTR(-EFBIG);
+	index += merkle_pos >> PAGE_SHIFT;
+again:
+	page = find_get_page_flags(inode->i_mapping, index, FGP_ACCESSED);
+	if (page) {
+		if (PageUptodate(page))
+			return page;
+
+		lock_page(page);
+		/*
+		 * We only insert uptodate pages, so !Uptodate has to be
+		 * an error
+		 */
+		if (!PageUptodate(page)) {
+			unlock_page(page);
+			put_page(page);
+			return ERR_PTR(-EIO);
+		}
+		unlock_page(page);
+		return page;
+	}
+
+	page = __page_cache_alloc(mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS));
+	if (!page)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * Merkle item keys are indexed from byte 0 in the merkle tree.
+	 * they have the form:
+	 *
+	 * [ inode objectid, BTRFS_MERKLE_ITEM_KEY, offset in bytes ]
+	 */
+	ret = read_key_bytes(BTRFS_I(inode),
+			     BTRFS_VERITY_MERKLE_ITEM_KEY, off,
+			     page_address(page), PAGE_SIZE, page);
+	if (ret < 0) {
+		put_page(page);
+		return ERR_PTR(ret);
+	}
+	if (ret < PAGE_SIZE)
+		memzero_page(page, ret, PAGE_SIZE - ret);
+
+	SetPageUptodate(page);
+	ret = add_to_page_cache_lru(page, inode->i_mapping, index, GFP_NOFS);
+
+	if (!ret) {
+		/* Inserted and ready for fsverity */
+		unlock_page(page);
+	} else {
+		put_page(page);
+		/* Did someone race us into inserting this page? */
+		if (ret == -EEXIST)
+			goto again;
+		page = ERR_PTR(ret);
+	}
+	return page;
+}
+
+/*
+ * fsverity op that writes a Merkle tree block into the btree.
+ *
+ * @inode: inode to write a Merkle tree block for
+ * @buf: Merkle tree data block to write
+ * @index: the index of the block in the Merkle tree
+ * @log_blocksize: log base 2 of the Merkle tree block size
+ *
+ * Note that the block size could be different from the page size, so it is not
+ * safe to assume that index is a page index.
+ *
+ * Returns 0 on success or negative error code on failure
+ */
+static int btrfs_write_merkle_tree_block(struct inode *inode, const void *buf,
+					u64 index, int log_blocksize)
+{
+	u64 off = index << log_blocksize;
+	u64 len = 1 << log_blocksize;
+	loff_t merkle_pos = merkle_file_pos(inode);
+
+	if (merkle_pos < 0)
+		return merkle_pos;
+	if (merkle_pos > inode->i_sb->s_maxbytes - off - len)
+		return -EFBIG;
+
+	return write_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY,
+			       off, buf, len);
+}
+
+const struct fsverity_operations btrfs_verityops = {
+	.begin_enable_verity	= btrfs_begin_enable_verity,
+	.end_enable_verity	= btrfs_end_enable_verity,
+	.get_verity_descriptor	= btrfs_get_verity_descriptor,
+	.read_merkle_tree_page	= btrfs_read_merkle_tree_page,
+	.write_merkle_tree_block = btrfs_write_merkle_tree_block,
+};
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 22cd037123fa..d7d3cfead056 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -288,6 +288,7 @@ struct btrfs_ioctl_fs_info_args {
  * first mount when booting older kernel versions.
  */
 #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID	(1ULL << 1)
+#define BTRFS_FEATURE_COMPAT_RO_VERITY			(1ULL << 2)
 
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index ccdb40fe40dc..871d64fdc887 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -118,6 +118,29 @@
 #define BTRFS_INODE_REF_KEY		12
 #define BTRFS_INODE_EXTREF_KEY		13
 #define BTRFS_XATTR_ITEM_KEY		24
+
+/*
+ * fs verity items are stored under two different key types on disk.
+ * The descriptor items:
+ * [ inode objectid, BTRFS_VERITY_DESC_ITEM_KEY, offset ]
+ *
+ * At offset 0, we store a btrfs_verity_descriptor_item which tracks the
+ * size of the descriptor item and some extra data for encryption.
+ * Starting at offset 1, these hold the generic fs verity descriptor.
+ * The latter are opaque to btrfs, we just read and write them as a blob for the
+ * higher level verity code.  The most common descriptor size is 256 bytes.
+ *
+ * The merkle tree items:
+ * [ inode objectid, BTRFS_VERITY_MERKLE_ITEM_KEY, offset ]
+ *
+ * These also start at offset 0, and correspond to the merkle tree bytes.
+ * When fsverity asks for page 0 of the merkle tree, we pull up one page
+ * starting at offset 0 for this key type.  These are also opaque to btrfs,
+ * we're blindly storing whatever fsverity sends down.
+ */
+#define BTRFS_VERITY_DESC_ITEM_KEY	36
+#define BTRFS_VERITY_MERKLE_ITEM_KEY	37
+
 #define BTRFS_ORPHAN_ITEM_KEY		48
 /* reserve 2-15 close to the inode for later flexibility */
 
@@ -991,4 +1014,16 @@ struct btrfs_qgroup_limit_item {
 	__le64 rsv_excl;
 } __attribute__ ((__packed__));
 
+struct btrfs_verity_descriptor_item {
+	/* size of the verity descriptor in bytes */
+	__le64 size;
+	/*
+	 * When we implement support for fscrypt, we will need to encrypt the
+	 * Merkle tree for encrypted verity files. These 128 bits are for the
+	 * eventual storage of an fscrypt initialization vector.
+	 */
+	__le64 reserved[2];
+	__u8 encryption;
+} __attribute__ ((__packed__));
+
 #endif /* _BTRFS_CTREE_H_ */
-- 
2.31.1

