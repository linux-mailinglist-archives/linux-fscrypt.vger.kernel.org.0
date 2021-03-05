Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9431632F3D6
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Mar 2021 20:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhCET0r (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 Mar 2021 14:26:47 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36803 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229971AbhCET0o (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 Mar 2021 14:26:44 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 5FE752B1B;
        Fri,  5 Mar 2021 14:26:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 05 Mar 2021 14:26:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=+u2fnWDajw5bCtq6rKPhavsXXT
        lxB7QGPRXM3bCwvtI=; b=Xx0jlcxGZ7LzqbqybtSc8WHYVEghlnlT5i8UEV3T6q
        o0nSrtS/1pGC+w8zYTf6m5BX06ptPmZ/xoDbuVStpug7wihBbn+YZ0ZFTeqKlMsC
        CgHUbuQyFNVaCbVamfs5Jwdt6NFEmh7ZUZpFk42kav3WxLJUocrOEd+YUWrpLc9q
        xzSyboLuUhFga9BjJKZVbVvZ3s0PO5WvTZJRarqAdpc3/ADV9U/gung/A1F24CJJ
        8XEZxKn7Wfx1nXM4pbiDhtBH81RdUPMdKurPmPvDnz/IkX0BRN33f7CUjPb13Wm/
        pTRjFYPIcgIVomIs42FG1HQfmd1Pb6yTTUI7yMd7l0Ew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=+u2fnWDajw5bCtq6rKPhavsXXTlxB7QGPRXM3bCwvtI=; b=EDaD17dJ
        j4FJYCN+8+Y87CxkQZHeN+N0L4v4kkSDP/tXP9bJLMmAfuAXG/XE4Q6MfnMGo1KW
        axpI+h/tuKrRB9ZL0bH8CQl1V0XVjgrqe0cqJaUAs/b2/gmLYo8Fq1UluEvW++OB
        Bc/sqcm8eItyDAL0Yb1quBSKKGn/hjvnUoUWks4ZJYL+Fhivb25wfj2nHrqXuMDV
        fprdrrsAsb4cdvz+o7NiJ3sr09pMC8sW3vWksLm04VxJcQZRLzZsxyG8fRZH0IAw
        4GhjjlhohZeYJAJEffFqZpqY4+Vic/lyA+RGLSmQne9uHFT3l81O/KPV/w20zYfM
        VUdCZJUQUGjKqQ==
X-ME-Sender: <xms:8oVCYG7gd5IORz2ed9FF-lAtidy1EMguquLTa25mcQSoJM4nyomAkA>
    <xme:8oVCYP5-C6J4QH9TU3o_Xv0ddjYYq6xzNqgunaVWmP8WDOsRhm0FI1HkC9pBwWnwN
    lyCjWw9Mmtf4F4VfrY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtiedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    eiueffuedvieeujefhheeigfekvedujeejjeffvedvhedtudefiefhkeegueehleenucfk
    phepudeifedruddugedrudefvddrheenucevlhhushhtvghrufhiiigvpedunecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:8oVCYFeehaCmB70lmopZYCoJYwCl847i5pKfYZNHTQmYDvY_THF7WA>
    <xmx:8oVCYDIBPhQFOWfW6Ca_3aZCc4By66ZTI_NspOmMG8_2_LRbn9Uz2A>
    <xmx:8oVCYKIy1QU857gJZFonxCqezPpJ3lFM_4kEvGnFHYCpKK95yZA5NQ>
    <xmx:8oVCYMhATXS8J5IF0Td464z-a-y89fR01F_QIZIDIbs06mPChcyRCg>
Received: from localhost (unknown [163.114.132.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0CF92240057;
        Fri,  5 Mar 2021 14:26:42 -0500 (EST)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org,
        'Eric Biggers ' <ebiggers@kernel.org>
Subject: [PATCH v2 2/5] btrfs: initial fsverity support
Date:   Fri,  5 Mar 2021 11:26:30 -0800
Message-Id: <71249018efc661fdd3c43bda5d7cea271904ae1a.1614971203.git.boris@bur.io>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1614971203.git.boris@bur.io>
References: <cover.1614971203.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Chris Mason <clm@fb.com>

Add support for fsverity in btrfs. To support the generic interface in
fs/verity, we add two new item types in the fs tree for inodes with
verity enabled. One stores the per-file verity descriptor and the other
stores the Merkle tree data itself.

Verity checking is done at the end of IOs to ensure each page is checked
before it is marked uptodate.

Verity relies on PageChecked for the Merkle tree data itself to avoid
re-walking up shared paths in the tree. For this reason, we need to
cache the Merkle tree data. Since the file is immutable after verity is
turned on, we can cache it at an index past EOF.

Use the new inode compat_flags to store verity on the inode item, so
that we can enable verity on a file, then rollback to an older kernel
and still mount the file system and read the file. Since we can't safely
write the file anymore without ruining the invariants of the Merkle
tree, we mark a ro_compat flag on the file system when a file has verity
enabled.

Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/Makefile               |   1 +
 fs/btrfs/btrfs_inode.h          |   1 +
 fs/btrfs/ctree.h                |  23 +-
 fs/btrfs/extent_io.c            |  27 +-
 fs/btrfs/file.c                 |   6 +
 fs/btrfs/inode.c                |   7 +
 fs/btrfs/ioctl.c                |  14 +-
 fs/btrfs/super.c                |   1 +
 fs/btrfs/sysfs.c                |   6 +
 fs/btrfs/verity.c               | 598 ++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h      |   2 +-
 include/uapi/linux/btrfs_tree.h |  15 +
 12 files changed, 690 insertions(+), 11 deletions(-)
 create mode 100644 fs/btrfs/verity.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index b634c42115ea..ff719d2bba1a 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -34,6 +34,7 @@ btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
 btrfs-$(CONFIG_BTRFS_FS_REF_VERIFY) += ref-verify.o
 btrfs-$(CONFIG_BLK_DEV_ZONED) += zoned.o
+btrfs-$(CONFIG_FS_VERITY) += verity.o
 
 btrfs-$(CONFIG_BTRFS_FS_RUN_SANITY_TESTS) += tests/free-space-tests.o \
 	tests/extent-buffer-tests.o tests/btrfs-tests.o \
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 8b95932f25a8..c0b0537bd50e 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -51,6 +51,7 @@ enum {
 	 * the file range, inode's io_tree).
 	 */
 	BTRFS_INODE_NO_DELALLOC_FLUSH,
+	BTRFS_INODE_VERITY_IN_PROGRESS,
 };
 
 /* in memory btrfs inode */
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e65df997a2c6..f73ba7794dda 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -279,9 +279,10 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
 
-#define BTRFS_FEATURE_COMPAT_RO_SUPP			\
-	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
-	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID)
+#define BTRFS_FEATURE_COMPAT_RO_SUPP				\
+	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |		\
+	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID |	\
+	 BTRFS_FEATURE_COMPAT_RO_VERITY)
 
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_SET	0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR	0ULL
@@ -1480,6 +1481,11 @@ do {                                                                   \
 	 BTRFS_INODE_COMPRESS |						\
 	 BTRFS_INODE_ROOT_ITEM_INIT)
 
+/*
+ * Inode compat flags
+ */
+#define BTRFS_INODE_VERITY		(1 << 0)
+
 struct btrfs_map_token {
 	struct extent_buffer *eb;
 	char *kaddr;
@@ -3735,6 +3741,17 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
 
 #define in_range(b, first, len) ((b) >= (first) && (b) < (first) + (len))
 
+/* verity.c */
+extern const struct fsverity_operations btrfs_verityops;
+int btrfs_drop_verity_items(struct btrfs_inode *inode);
+BTRFS_SETGET_FUNCS(verity_descriptor_encryption, struct btrfs_verity_descriptor_item,
+		   encryption, 8);
+BTRFS_SETGET_FUNCS(verity_descriptor_size, struct btrfs_verity_descriptor_item, size, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_verity_descriptor_encryption, struct btrfs_verity_descriptor_item,
+			 encryption, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_verity_descriptor_size, struct btrfs_verity_descriptor_item,
+			 size, 64);
+
 /* Sanity test specific functions */
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_destroy_inode(struct inode *inode);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4dfb3ead1175..0d6f8b33830f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -13,6 +13,7 @@
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
 #include <linux/cleancache.h>
+#include <linux/fsverity.h>
 #include "extent_io.h"
 #include "extent-io-tree.h"
 #include "extent_map.h"
@@ -2861,15 +2862,28 @@ static void begin_page_read(struct btrfs_fs_info *fs_info, struct page *page)
 	btrfs_subpage_start_reader(fs_info, page, page_offset(page), PAGE_SIZE);
 }
 
-static void end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
+static int end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(page->mapping->host->i_sb);
+	int ret = 0;
+	struct inode *inode = page->mapping->host;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 
 	ASSERT(page_offset(page) <= start &&
 		start + len <= page_offset(page) + PAGE_SIZE);
 
 	if (uptodate) {
-		btrfs_page_set_uptodate(fs_info, page, start, len);
+		/*
+		 * buffered reads of a file with page alignment will issue a
+		 * 0 length read for one page past the end of file, so we must
+		 * explicitly skip checking verity on that page of zeros.
+		 */
+		if (!PageError(page) && !PageUptodate(page) &&
+		    start < i_size_read(inode) &&
+		    fsverity_active(inode) &&
+		    fsverity_verify_page(page) != true)
+			ret = -EIO;
+		else
+			btrfs_page_set_uptodate(fs_info, page, start, len);
 	} else {
 		btrfs_page_clear_uptodate(fs_info, page, start, len);
 		btrfs_page_set_error(fs_info, page, start, len);
@@ -2877,12 +2891,13 @@ static void end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
 
 	if (fs_info->sectorsize == PAGE_SIZE)
 		unlock_page(page);
-	else if (is_data_inode(page->mapping->host))
+	else if (is_data_inode(inode))
 		/*
 		 * For subpage data, unlock the page if we're the last reader.
 		 * For subpage metadata, page lock is not utilized for read.
 		 */
 		btrfs_subpage_end_reader(fs_info, page, start, len);
+	return ret;
 }
 
 /*
@@ -3019,7 +3034,9 @@ static void end_bio_extent_readpage(struct bio *bio)
 		bio_offset += len;
 
 		/* Update page status and unlock */
-		end_page_read(page, uptodate, start, len);
+		ret = end_page_read(page, uptodate, start, len);
+		if (ret)
+			uptodate = 0;
 		endio_readpage_release_extent(&processed, BTRFS_I(inode),
 					      start, end, uptodate);
 	}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2c282664c4b8..75f1406021e5 100644
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
@@ -3588,7 +3589,12 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int whence)
 
 static int btrfs_file_open(struct inode *inode, struct file *filp)
 {
+	int ret;
 	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
+
+	ret = fsverity_file_open(inode, filp);
+	if (ret)
+		return ret;
 	return generic_file_open(inode, filp);
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4529e974c582..9291f6633bc6 100644
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
@@ -5399,7 +5400,9 @@ void btrfs_evict_inode(struct inode *inode)
 
 	trace_btrfs_inode_evict(inode);
 
+
 	if (!root) {
+		fsverity_cleanup_inode(inode);
 		clear_inode(inode);
 		return;
 	}
@@ -5482,6 +5485,7 @@ void btrfs_evict_inode(struct inode *inode)
 	 * to retry these periodically in the future.
 	 */
 	btrfs_remove_delayed_node(BTRFS_I(inode));
+	fsverity_cleanup_inode(inode);
 	clear_inode(inode);
 }
 
@@ -9026,6 +9030,7 @@ static int btrfs_getattr(const struct path *path, struct kstat *stat,
 	struct inode *inode = d_inode(path->dentry);
 	u32 blocksize = inode->i_sb->s_blocksize;
 	u32 bi_flags = BTRFS_I(inode)->flags;
+	u32 bi_compat_flags = BTRFS_I(inode)->compat_flags;
 
 	stat->result_mask |= STATX_BTIME;
 	stat->btime.tv_sec = BTRFS_I(inode)->i_otime.tv_sec;
@@ -9038,6 +9043,8 @@ static int btrfs_getattr(const struct path *path, struct kstat *stat,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (bi_flags & BTRFS_INODE_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
+	if (bi_compat_flags & BTRFS_INODE_VERITY)
+		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d3fb065312f5..cf91d8f0d479 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -26,6 +26,7 @@
 #include <linux/btrfs.h>
 #include <linux/uaccess.h>
 #include <linux/iversion.h>
+#include <linux/fsverity.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "export.h"
@@ -105,6 +106,7 @@ static unsigned int btrfs_mask_fsflags_for_type(struct inode *inode,
 static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
 {
 	unsigned int flags = binode->flags;
+	unsigned int compat_flags = binode->compat_flags;
 	unsigned int iflags = 0;
 
 	if (flags & BTRFS_INODE_SYNC)
@@ -121,6 +123,8 @@ static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
 		iflags |= FS_DIRSYNC_FL;
 	if (flags & BTRFS_INODE_NODATACOW)
 		iflags |= FS_NOCOW_FL;
+	if (compat_flags & BTRFS_INODE_VERITY)
+		iflags |= FS_VERITY_FL;
 
 	if (flags & BTRFS_INODE_NOCOMPRESS)
 		iflags |= FS_NOCOMP_FL;
@@ -148,10 +152,12 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (binode->flags & BTRFS_INODE_DIRSYNC)
 		new_fl |= S_DIRSYNC;
+	if (binode->compat_flags & BTRFS_INODE_VERITY)
+		new_fl |= S_VERITY;
 
 	set_mask_bits(&inode->i_flags,
-		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC,
-		      new_fl);
+		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC |
+		      S_VERITY, new_fl);
 }
 
 static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
@@ -5035,6 +5041,10 @@ long btrfs_ioctl(struct file *file, unsigned int
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
index f8435641b912..be7dfde7e4cf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1339,6 +1339,7 @@ static int btrfs_fill_super(struct super_block *sb,
 	sb->s_op = &btrfs_super_ops;
 	sb->s_d_op = &btrfs_dentry_operations;
 	sb->s_export_op = &btrfs_export_ops;
+	sb->s_vop = &btrfs_verityops;
 	sb->s_xattr = btrfs_xattr_handlers;
 	sb->s_time_gran = 1;
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 6eb1c50fa98c..e8de0055c61e 100644
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
index 000000000000..648bda5a3716
--- /dev/null
+++ b/fs/btrfs/verity.c
@@ -0,0 +1,598 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 Facebook.  All rights reserved.
+ */
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
+ * Just like ext4, we cache the merkle tree in pages after EOF in the page
+ * cache.  Unlike ext4, we're storing these in dedicated btree items and
+ * not just shoving them after EOF in the file.  This means we'll need to
+ * do extra work to encrypt them once encryption is supported in btrfs,
+ * but btrfs has a lot of careful code around i_size and it seems better
+ * to make a new key type than try and adjust all of our expectations
+ * for i_size.
+ *
+ * fs verity items are stored under two different key types on disk.
+ *
+ * The descriptor items:
+ * [ inode objectid, BTRFS_VERITY_DESC_ITEM_KEY, offset ]
+ *
+ * At offset 0, we store a btrfs_verity_descriptor_item which tracks the
+ * size of the descriptor item and some extra data for encryption.
+ * Starting at offset 1, these hold the generic fs verity descriptor.
+ * These are opaque to btrfs, we just read and write them as a blob for
+ * the higher level verity code.  The most common size for this is 256 bytes.
+ *
+ * The merkle tree items:
+ * [ inode objectid, BTRFS_VERITY_MERKLE_ITEM_KEY, offset ]
+ *
+ * These also start at offset 0, and correspond to the merkle tree bytes.
+ * So when fsverity asks for page 0 of the merkle tree, we pull up one page
+ * starting at offset 0 for this key type.  These are also opaque to btrfs,
+ * we're blindly storing whatever fsverity sends down.
+ *
+ * This file is just reading and writing the various items whenever
+ * fsverity needs us to.
+ */
+
+/*
+ * Drop all the items for this inode with this key_type.
+ * @inode: The inode to drop items for
+ * @key_type: The type of items to drop (VERITY_DESC_ITEM or
+ *            VERITY_MERKLE_ITEM)
+ *
+ * Before doing a verity enable we cleanup any existing verity items.
+ *
+ * This is also used to clean up if a verity enable failed half way
+ * through.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int drop_verity_items(struct btrfs_inode *inode, u8 key_type)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = inode->root;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	while (1) {
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto out;
+		}
+
+		/*
+		 * walk backwards through all the items until we find one
+		 * that isn't from our key type or objectid
+		 */
+		key.objectid = btrfs_ino(inode);
+		key.offset = (u64)-1;
+		key.type = key_type;
+
+		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+		if (ret > 0) {
+			ret = 0;
+			/* no more keys of this type, we're done */
+			if (path->slots[0] == 0)
+				break;
+			path->slots[0]--;
+		} else if (ret < 0) {
+			break;
+		}
+
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+
+		/* no more keys of this type, we're done */
+		if (key.objectid != btrfs_ino(inode) || key.type != key_type)
+			break;
+
+		/*
+		 * this shouldn't be a performance sensitive function because
+		 * it's not used as part of truncate.  If it ever becomes
+		 * perf sensitive, change this to walk forward and bulk delete
+		 * items
+		 */
+		ret = btrfs_del_items(trans, root, path,
+				      path->slots[0], 1);
+		btrfs_release_path(path);
+		btrfs_end_transaction(trans);
+
+		if (ret)
+			goto out;
+	}
+
+	btrfs_end_transaction(trans);
+out:
+	btrfs_free_path(path);
+	return ret;
+
+}
+
+/*
+ * Insert and write inode items with a given key type and offset.
+ * @inode: The inode to insert for.
+ * @key_type: The key type to insert.
+ * @offset: The item offset to insert at.
+ * @src: Source data to write.
+ * @len: Length of source data to write.
+ * @max_item_size: Break up the write into items of this size at most.
+ *                 Useful for small leaf size file systems.
+ *
+ * Write len bytes from src into items of up to max_item_size length.
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
+	u64 orig_len = len;
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
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
+
+		key.objectid = btrfs_ino(inode);
+		key.offset = offset;
+		key.type = key_type;
+
+		/*
+		 * insert 1K at a time mostly to be friendly for smaller
+		 * leaf size filesystems
+		 */
+		copy_bytes = min_t(u64, len, 1024);
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
+
+	if (!ret && copied != orig_len)
+		ret = -EIO;
+	return ret;
+}
+
+/*
+ * Read inode items of the given key type and offset from the btree.
+ * @inode: The inode to read items of.
+ * @key_type: The key type to read.
+ * @offset: The item offset to read from.
+ * @dest: The buffer to read into. This parameter has slightly tricky
+ *        semantics.  If it is NULL, the function will not do any copying
+ *        and will just return the size of all the items up to len bytes.
+ *        If dest_page is passed, then the function will kmap_atomic the
+ *        page and ignore dest, but it must still be non-NULL to avoid the
+ *        counting-only behavior.
+ * @len: Length in bytes to read.
+ * @dest_page: Copy into this page instead of the dest buffer.
+ *
+ * Helper function to read items from the btree.  This returns the number
+ * of bytes read or < 0 for errors.  We can return short reads if the
+ * items don't exist on disk or aren't big enough to fill the desired length.
+ *
+ * Supports reading into a provided buffer (dest) or into the page cache
+ *
+ * Returns number of bytes read or a negative error code on failure.
+ */
+static ssize_t read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
+			  char *dest, u64 len, struct page *dest_page)
+{
+	struct btrfs_path *path;
+	struct btrfs_root *root = inode->root;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	u64 item_end;
+	u64 copy_end;
+	u64 copied = 0;
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
+	key.offset = offset;
+	key.type = key_type;
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
+			 * once we've copied something, we want all of the items
+			 * to be sequential
+			 */
+			if (key.offset != offset)
+				break;
+		} else {
+			/*
+			 * our initial offset might be in the middle of an
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
+		/* number of bytes in this item we want to copy */
+		copy_bytes = copy_end - offset;
+
+		/* offset from the start of item for copying */
+		copy_offset = offset - key.offset;
+
+		if (dest) {
+			if (dest_page)
+				kaddr = kmap_atomic(dest_page);
+
+			data = btrfs_item_ptr(leaf, path->slots[0], void);
+			read_extent_buffer(leaf, kaddr + dest_offset,
+					   (unsigned long)data + copy_offset,
+					   copy_bytes);
+
+			if (dest_page)
+				kunmap_atomic(kaddr);
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
+			 * we've reached the last slot in this leaf and we need
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
+ * fsverity op that begins enabling verity.
+ * fsverity calls this to ask us to setup the inode for enabling.  We
+ * drop any existing verity items and set the in progress bit.
+ */
+static int btrfs_begin_enable_verity(struct file *filp)
+{
+	struct inode *inode = file_inode(filp);
+	int ret;
+
+	if (test_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &BTRFS_I(inode)->runtime_flags))
+		return -EBUSY;
+
+	/*
+	 * ext4 adds the inode to the orphan list here, presumably because the
+	 * truncate done at orphan processing time will delete partial
+	 * measurements.  TODO: setup orphans
+	 */
+	set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &BTRFS_I(inode)->runtime_flags);
+	ret = drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY);
+	if (ret)
+		goto err;
+
+	ret = drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &BTRFS_I(inode)->runtime_flags);
+	return ret;
+
+}
+
+/*
+ * fsverity op that ends enabling verity.
+ * fsverity calls this when it's done with all of the pages in the file
+ * and all of the merkle items have been inserted.  We write the
+ * descriptor and update the inode in the btree to reflect its new life
+ * as a verity file.
+ */
+static int btrfs_end_enable_verity(struct file *filp, const void *desc,
+				  size_t desc_size, u64 merkle_tree_size)
+{
+	struct btrfs_trans_handle *trans;
+	struct inode *inode = file_inode(filp);
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_verity_descriptor_item item;
+	int ret;
+
+	if (desc != NULL) {
+		/* write out the descriptor item */
+		memset(&item, 0, sizeof(item));
+		btrfs_set_stack_verity_descriptor_size(&item, desc_size);
+		ret = write_key_bytes(BTRFS_I(inode),
+				      BTRFS_VERITY_DESC_ITEM_KEY, 0,
+				      (const char *)&item, sizeof(item));
+		if (ret)
+			goto out;
+		/* write out the descriptor itself */
+		ret = write_key_bytes(BTRFS_I(inode),
+				      BTRFS_VERITY_DESC_ITEM_KEY, 1,
+				      desc, desc_size);
+		if (ret)
+			goto out;
+
+		/* update our inode flags to include fs verity */
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto out;
+		}
+		BTRFS_I(inode)->compat_flags |= BTRFS_INODE_VERITY;
+		btrfs_sync_inode_flags_to_i_flags(inode);
+		ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
+		btrfs_end_transaction(trans);
+	}
+
+out:
+	if (desc == NULL || ret) {
+		/* If we failed, drop all the verity items */
+		drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY);
+		drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY);
+	} else
+		btrfs_set_fs_compat_ro(root->fs_info, VERITY);
+	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &BTRFS_I(inode)->runtime_flags);
+	return ret;
+}
+
+/*
+ * fsverity op that gets the struct fsverity_descriptor.
+ * fsverity does a two pass setup for reading the descriptor, in the first pass
+ * it calls with buf_size = 0 to query the size of the descriptor,
+ * and then in the second pass it actually reads the descriptor off
+ * disk.
+ */
+static int btrfs_get_verity_descriptor(struct inode *inode, void *buf,
+				       size_t buf_size)
+{
+	size_t true_size;
+	ssize_t ret = 0;
+	struct btrfs_verity_descriptor_item item;
+
+	memset(&item, 0, sizeof(item));
+	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY,
+			     0, (char *)&item, sizeof(item), NULL);
+	if (ret < 0)
+		return ret;
+
+	true_size = btrfs_stack_verity_descriptor_size(&item);
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
+	if (ret != buf_size)
+		return -EIO;
+
+	return buf_size;
+}
+
+/*
+ * Helper function for computing cache index for Merkle tree pages
+ * @inode: verity file whose Merkle items we want.
+ * @merkle_index: index of the page in the Merkle tree (as in
+ *                read_merkle_tree_page).
+ *
+ * Returns: page index of the Merkle page.
+ */
+static unsigned long get_verity_mapping_index(struct inode *inode,
+					      pgoff_t merkle_index)
+{
+	/*
+	 * the file is readonly, so i_size can't change here.  We jump
+	 * some pages past the last page to cache our merkles.  The goal
+	 * is just to jump past any hugepages that might be mapped in.
+	 */
+	return (i_size_read(inode) >> PAGE_SHIFT) + 2048 + merkle_index;
+}
+
+/*
+ * fsverity op that reads and caches a merkle tree page.  These are stored
+ * in the btree, but we cache them in the inode's address space after EOF.
+ */
+static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
+					       pgoff_t index,
+					       unsigned long num_ra_pages)
+{
+	struct page *p;
+	u64 start = index << PAGE_SHIFT;
+	unsigned long mapping_index = get_verity_mapping_index(inode, index);
+	ssize_t ret;
+	int err;
+
+again:
+	p = find_get_page_flags(inode->i_mapping, mapping_index, FGP_ACCESSED);
+	if (p) {
+		if (PageUptodate(p))
+			return p;
+
+		lock_page(p);
+		/*
+		 * we only insert uptodate pages, so !Uptodate has to be
+		 * an error
+		 */
+		if (!PageUptodate(p)) {
+			unlock_page(p);
+			put_page(p);
+			return ERR_PTR(-EIO);
+		}
+		unlock_page(p);
+		return p;
+	}
+
+	p = page_cache_alloc(inode->i_mapping);
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * merkle item keys are indexed from byte 0 in the merkle tree.
+	 * they have the form:
+	 *
+	 * [ inode objectid, BTRFS_MERKLE_ITEM_KEY, offset in bytes ]
+	 */
+	ret = read_key_bytes(BTRFS_I(inode),
+			     BTRFS_VERITY_MERKLE_ITEM_KEY, start,
+			     page_address(p), PAGE_SIZE, p);
+	if (ret < 0) {
+		put_page(p);
+		return ERR_PTR(ret);
+	}
+
+	/* zero fill any bytes we didn't write into the page */
+	if (ret < PAGE_SIZE) {
+		char *kaddr = kmap_atomic(p);
+
+		memset(kaddr + ret, 0, PAGE_SIZE - ret);
+		kunmap_atomic(kaddr);
+	}
+	SetPageUptodate(p);
+	err = add_to_page_cache_lru(p, inode->i_mapping, mapping_index,
+				    mapping_gfp_mask(inode->i_mapping));
+
+	if (!err) {
+		/* inserted and ready for fsverity */
+		unlock_page(p);
+	} else {
+		put_page(p);
+		/* did someone race us into inserting this page? */
+		if (err == -EEXIST)
+			goto again;
+		p = ERR_PTR(err);
+	}
+	return p;
+}
+
+/*
+ * fsverity op that writes a merkle tree block into the btree in 1k chunks.
+ */
+static int btrfs_write_merkle_tree_block(struct inode *inode, const void *buf,
+					u64 index, int log_blocksize)
+{
+	u64 start = index << log_blocksize;
+	u64 len = 1 << log_blocksize;
+	unsigned long mapping_index = get_verity_mapping_index(inode, index);
+
+	if (mapping_index > inode->i_sb->s_maxbytes >> PAGE_SHIFT)
+		return -EFBIG;
+
+	return write_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY,
+			       start, buf, len);
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
index 5df73001aad4..fa21c8aac78d 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -288,6 +288,7 @@ struct btrfs_ioctl_fs_info_args {
  * first mount when booting older kernel versions.
  */
 #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID	(1ULL << 1)
+#define BTRFS_FEATURE_COMPAT_RO_VERITY		(1ULL << 2)
 
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
@@ -308,7 +309,6 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_METADATA_UUID	(1ULL << 10)
 #define BTRFS_FEATURE_INCOMPAT_RAID1C34		(1ULL << 11)
 #define BTRFS_FEATURE_INCOMPAT_ZONED		(1ULL << 12)
-
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
 	__u64 compat_ro_flags;
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index ae25280316bd..2be57416f886 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -118,6 +118,14 @@
 #define BTRFS_INODE_REF_KEY		12
 #define BTRFS_INODE_EXTREF_KEY		13
 #define BTRFS_XATTR_ITEM_KEY		24
+
+/*
+ * fsverity has a descriptor per file, and then
+ * a number of sha or csum items indexed by offset in to the file.
+ */
+#define BTRFS_VERITY_DESC_ITEM_KEY	36
+#define BTRFS_VERITY_MERKLE_ITEM_KEY	37
+
 #define BTRFS_ORPHAN_ITEM_KEY		48
 /* reserve 2-15 close to the inode for later flexibility */
 
@@ -996,4 +1004,11 @@ struct btrfs_qgroup_limit_item {
 	__le64 rsv_excl;
 } __attribute__ ((__packed__));
 
+struct btrfs_verity_descriptor_item {
+	/* size of the verity descriptor in bytes */
+	__le64 size;
+	__le64 reserved[2];
+	__u8 encryption;
+} __attribute__ ((__packed__));
+
 #endif /* _BTRFS_CTREE_H_ */
-- 
2.24.1

