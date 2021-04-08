Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D77358CB2
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhDHSeM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:34:12 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:52117 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232608AbhDHSeL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:34:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id B10C0118E;
        Thu,  8 Apr 2021 14:33:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 08 Apr 2021 14:34:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=DrSJNJxLDNhr7swCDPU7NuzVsQ
        PAvhzAaJjRD39VfhE=; b=h4FI8B8HfHS3fnlPVTQ87w5T9ruBv6v+yIam47+AEE
        p0H2hUOtQhD2d0MpcphVPBmQwkkCO0lWaI6ng7Fb1NZD07buyg1VvSbNkMIBoGEt
        vTXA1v3I0T7jEBGI3FjcJB7WUTQm73LrOJ5fVp5gzMUSAVXw1diMVmcBV7HfAnv6
        PvHeeWUft/UJlVK92VU04aC+R+E3jtJHvWU9u+VIYnoZO1KfEergEbqTFvJIFWs5
        1WFJI82nB/AfzET73hgOgdhFop6ClWnhW2wT/rVqOsAR3f1wq0KWTebSUWuwMgVQ
        nTq6pz2ee18tAfUfeshxpaf6LtQORppbG7R2DiRYAcLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=DrSJNJxLDNhr7swCDPU7NuzVsQPAvhzAaJjRD39VfhE=; b=thYQblyR
        8zyqRzqbY90z10wHmsSxn6UJNDxaZTQOGVaeVvDZBwgV3TFYH1y+RzTvEUjPxr4g
        K2Ax513su5peLz/0I7cN9sI+Z8sj5OKO6fwkXx0a9cXWQR8kmM8lBhSLjzxXGK0w
        fMoQjKgyYM+uEIF36RlKQGW2gyE3C8iigpHX5nEY2q0SyBwSw6oTLx3SeEAObnzT
        RehE/czzhQ/Hx44Io+GOXCRkIzMZeyGdNwurQ8A/iraQQ2Tcrg845gCQ07+KN1uB
        jjE+xEIaSY+9Bgx54kTKVd/xxb4ersZpRfN3nY482rLsT0UzWVwevlL2TNOmkJPm
        guHO9RGEcsDylg==
X-ME-Sender: <xms:l0xvYHp36FW9Kxnjj6ac76-VL4oZXpfX2SQKuzjYejwvWdExJxt_qA>
    <xme:l0xvYBz8W2pmzk_NnL_SkKrcZU2V0NBz7ofEU9J4vLJtEN5Jd7pcF3ZuXjsVwTQTg
    KCOZ4dEST2BQFUILIE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:l0xvYMKJTg3GNLp6DU4_tUsU1eIm0ugywdcVbKmzJk7EY2aqOCJ2Xw>
    <xmx:l0xvYDK0O9gxR8Dtypvl2BHzJr0Xq36Smf7xv9JwDjR8eP6Lk6BAVA>
    <xmx:l0xvYBuzUp19XNdACSA5a8_mr1p831k7DTpEvekiquFazNquCmSUMg>
    <xmx:l0xvYDqWw0FKIPLIuZ-6tv_OlC5iAHIN7RS08GfhXf6XT-qLsOaeLQ>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0AF3C1080057;
        Thu,  8 Apr 2021 14:33:58 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 1/5] btrfs: add compat_flags to btrfs_inode_item
Date:   Thu,  8 Apr 2021 11:33:52 -0700
Message-Id: <7fd3068c977de9dd25eb98fa2b9d3cd928613138.1617900170.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617900170.git.boris@bur.io>
References: <cover.1617900170.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The tree checker currently rejects unrecognized flags when it reads
btrfs_inode_item. Practically, this means that adding a new flag makes
the change backwards incompatible if the flag is ever set on a file.

Take up one of the 4 reserved u64 fields in the btrfs_inode_item as a
new "compat_flags". These flags are zero on inode creation in btrfs and
mkfs and are ignored by an older kernel, so it should be safe to use
them in this way.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/btrfs_inode.h          | 1 +
 fs/btrfs/ctree.h                | 2 ++
 fs/btrfs/delayed-inode.c        | 2 ++
 fs/btrfs/inode.c                | 3 +++
 fs/btrfs/ioctl.c                | 7 ++++---
 fs/btrfs/tree-log.c             | 1 +
 include/uapi/linux/btrfs_tree.h | 7 ++++++-
 7 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index c652e19ad74e..e8dbc8e848ce 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -191,6 +191,7 @@ struct btrfs_inode {
 
 	/* flags field from the on disk inode */
 	u32 flags;
+	u64 compat_flags;
 
 	/*
 	 * Counters to keep track of the number of extent item's we may use due
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f2fd73e58ee6..d633c563164b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1754,6 +1754,7 @@ BTRFS_SETGET_FUNCS(inode_gid, struct btrfs_inode_item, gid, 32);
 BTRFS_SETGET_FUNCS(inode_mode, struct btrfs_inode_item, mode, 32);
 BTRFS_SETGET_FUNCS(inode_rdev, struct btrfs_inode_item, rdev, 64);
 BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
+BTRFS_SETGET_FUNCS(inode_compat_flags, struct btrfs_inode_item, compat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_generation, struct btrfs_inode_item,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_sequence, struct btrfs_inode_item,
@@ -1771,6 +1772,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_inode_gid, struct btrfs_inode_item, gid, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_mode, struct btrfs_inode_item, mode, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_rdev, struct btrfs_inode_item, rdev, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_flags, struct btrfs_inode_item, flags, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_compat_flags, struct btrfs_inode_item, compat_flags, 64);
 BTRFS_SETGET_FUNCS(timespec_sec, struct btrfs_timespec, sec, 64);
 BTRFS_SETGET_FUNCS(timespec_nsec, struct btrfs_timespec, nsec, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_timespec_sec, struct btrfs_timespec, sec, 64);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 1a88f6214ebc..ef4e0265dbe3 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1718,6 +1718,7 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_inode_transid(inode_item, trans->transid);
 	btrfs_set_stack_inode_rdev(inode_item, inode->i_rdev);
 	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
+	btrfs_set_stack_inode_compat_flags(inode_item, BTRFS_I(inode)->compat_flags);
 	btrfs_set_stack_inode_block_group(inode_item, 0);
 
 	btrfs_set_stack_timespec_sec(&inode_item->atime,
@@ -1776,6 +1777,7 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 	inode->i_rdev = 0;
 	*rdev = btrfs_stack_inode_rdev(inode_item);
 	BTRFS_I(inode)->flags = btrfs_stack_inode_flags(inode_item);
+	BTRFS_I(inode)->compat_flags = btrfs_stack_inode_compat_flags(inode_item);
 
 	inode->i_atime.tv_sec = btrfs_stack_timespec_sec(&inode_item->atime);
 	inode->i_atime.tv_nsec = btrfs_stack_timespec_nsec(&inode_item->atime);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e0e20ad25e4..3aa96ec27045 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3627,6 +3627,7 @@ static int btrfs_read_locked_inode(struct inode *inode,
 
 	BTRFS_I(inode)->index_cnt = (u64)-1;
 	BTRFS_I(inode)->flags = btrfs_inode_flags(leaf, inode_item);
+	BTRFS_I(inode)->compat_flags = btrfs_inode_compat_flags(leaf, inode_item);
 
 cache_index:
 	/*
@@ -3793,6 +3794,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_token_inode_transid(&token, item, trans->transid);
 	btrfs_set_token_inode_rdev(&token, item, inode->i_rdev);
 	btrfs_set_token_inode_flags(&token, item, BTRFS_I(inode)->flags);
+	btrfs_set_token_inode_compat_flags(&token, item, BTRFS_I(inode)->compat_flags);
 	btrfs_set_token_inode_block_group(&token, item, 0);
 }
 
@@ -8859,6 +8861,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->defrag_bytes = 0;
 	ei->disk_i_size = 0;
 	ei->flags = 0;
+	ei->compat_flags = 0;
 	ei->csum_bytes = 0;
 	ei->index_cnt = (u64)-1;
 	ei->dir_index = 0;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3415a9f06c81..2c9cbd2642b1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -102,8 +102,9 @@ static unsigned int btrfs_mask_fsflags_for_type(struct inode *inode,
  * Export internal inode flags to the format expected by the FS_IOC_GETFLAGS
  * ioctl.
  */
-static unsigned int btrfs_inode_flags_to_fsflags(unsigned int flags)
+static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
 {
+	unsigned int flags = binode->flags;
 	unsigned int iflags = 0;
 
 	if (flags & BTRFS_INODE_SYNC)
@@ -156,7 +157,7 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
 static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
 {
 	struct btrfs_inode *binode = BTRFS_I(file_inode(file));
-	unsigned int flags = btrfs_inode_flags_to_fsflags(binode->flags);
+	unsigned int flags = btrfs_inode_flags_to_fsflags(binode);
 
 	if (copy_to_user(arg, &flags, sizeof(flags)))
 		return -EFAULT;
@@ -228,7 +229,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 
 	btrfs_inode_lock(inode, 0);
 	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
-	old_fsflags = btrfs_inode_flags_to_fsflags(binode->flags);
+	old_fsflags = btrfs_inode_flags_to_fsflags(binode);
 
 	ret = vfs_ioc_setflags_prepare(inode, old_fsflags, fsflags);
 	if (ret)
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 72c4b66ed516..fed638f995ba 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3944,6 +3944,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_token_inode_transid(&token, item, trans->transid);
 	btrfs_set_token_inode_rdev(&token, item, inode->i_rdev);
 	btrfs_set_token_inode_flags(&token, item, BTRFS_I(inode)->flags);
+	btrfs_set_token_inode_compat_flags(&token, item, BTRFS_I(inode)->compat_flags);
 	btrfs_set_token_inode_block_group(&token, item, 0);
 }
 
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 58d7cff9afb1..ae25280316bd 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -574,11 +574,16 @@ struct btrfs_inode_item {
 	/* modification sequence number for NFS */
 	__le64 sequence;
 
+	/*
+	 * flags which aren't checked for corruption at mount
+	 * and can be added in a backwards compatible way
+	 */
+	__le64 compat_flags;
 	/*
 	 * a little future expansion, for more than this we can
 	 * just grow the inode item and version it
 	 */
-	__le64 reserved[4];
+	__le64 reserved[3];
 	struct btrfs_timespec atime;
 	struct btrfs_timespec ctime;
 	struct btrfs_timespec mtime;
-- 
2.30.2

