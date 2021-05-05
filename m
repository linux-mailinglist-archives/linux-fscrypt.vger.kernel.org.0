Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D655537489D
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 May 2021 21:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhEETVo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 5 May 2021 15:21:44 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43739 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234664AbhEETVn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 5 May 2021 15:21:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id ACE1B5C019C;
        Wed,  5 May 2021 15:20:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 05 May 2021 15:20:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=jYFAQOEyxqJ794q2Ch6wlVGm7q
        rChZ39ti+IGTaPbKc=; b=fs79QkAw0rs2Ocq7dM7BIT+Fz+nT5ezRqqJqXs5tnK
        ZqJFBJCREtTRB4FDmQCTpMEELtTkc1b+hk9ZtJh5Y5Q0bERmy1EladRNvIt1p7HB
        Qc+LX1g8hWDJJLxvU6HNFHZNbsyKE97LmBiIRfnGMpUviwwQ8jq0UrH030BYVCAH
        XLkSP7QQnSHvW1FNuxHmd1etRCZhSJsV2oBqgKRygm4ZbIQUBCyS/Tw1oUMN/Wd4
        928Llq9s1OzOGooyczuwoMl+nJKfkLLg81YztAQyK8lDsMHrAxVSAmQY3nuZubn8
        yEN3dwT48Rn9ROjfCxATYjgNb1+1JjGzfY21HYmDeRlQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=jYFAQOEyxqJ794q2Ch6wlVGm7qrChZ39ti+IGTaPbKc=; b=TKYKKHkA
        8p2RmFp6CN5Glj6Hn1QY+ObHQ/HTu6yM5KNeigCxRV8B8z3iCHscjkQxY1FsH6gF
        apBFEaSuprDLiP3GAyQFtF49IQnSiQp9pqGFXym5XDSQUV1cR9842GnrVDU/neaI
        +un9JQ+N3PNBSG8YGz3bCCKE/6JWc1K54Yrf0VvpsUud6vbEqEZOYreWLA+JyW68
        8mQM3Yceq7AboKM2UfyzrjO2WbXZgQa3k6s9CQ1ZHpOxFZujEuEdY//YIfM2XWJ6
        RwkA8fY+UWAow3q2Hi+5PHf+p7R3GEKH9zokdqdWJHWsed+pOgbWB6Vy17kVOFSa
        kgWn1o3BFjaXFw==
X-ME-Sender: <xms:DvCSYLws_bD45m-FmJARQwsmLRPYsqYKVgHHyEPYAlueTGadbpQq7A>
    <xme:DvCSYDQQQ1-NfeqJ6m1cDUDKvfjslP0tZVK6wVuOcdMMVSET2D3P84So-cSI4Bcj7
    OQOKYtevNECwuJfQbY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefkedgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:DvCSYFX2bM8Kmeag8uTKeKw_Zs1JpPZ5QJ18rtpCtuQ6OkOiCGH7VA>
    <xmx:DvCSYFis9EeAUj-Kcbv6zrr81b7qZcgs283xL3oIjsd8zzfXOJoOnQ>
    <xmx:DvCSYNA1aOMrxbHOlhWOZG24thKFP1caG9Tu5Taj4AX7kzRypeetPQ>
    <xmx:DvCSYAqpoPccapzORpruV83qBZyUNNoywmCdplpGEN-Ox5ZhIKbwBQ>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 15:20:46 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v4 1/5] btrfs: add compat_flags to btrfs_inode_item
Date:   Wed,  5 May 2021 12:20:39 -0700
Message-Id: <6ed83a27f88e18f295f7d661e9c87e7ec7d33428.1620241221.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620241221.git.boris@bur.io>
References: <cover.1620241221.git.boris@bur.io>
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
index 0f5b0b12762b..0546273a520b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1786,6 +1786,7 @@ BTRFS_SETGET_FUNCS(inode_gid, struct btrfs_inode_item, gid, 32);
 BTRFS_SETGET_FUNCS(inode_mode, struct btrfs_inode_item, mode, 32);
 BTRFS_SETGET_FUNCS(inode_rdev, struct btrfs_inode_item, rdev, 64);
 BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
+BTRFS_SETGET_FUNCS(inode_compat_flags, struct btrfs_inode_item, compat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_generation, struct btrfs_inode_item,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_sequence, struct btrfs_inode_item,
@@ -1803,6 +1804,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_inode_gid, struct btrfs_inode_item, gid, 32);
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
index 69fcdf8f0b1c..d89000577f7f 100644
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
 
@@ -8857,6 +8859,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->defrag_bytes = 0;
 	ei->disk_i_size = 0;
 	ei->flags = 0;
+	ei->compat_flags = 0;
 	ei->csum_bytes = 0;
 	ei->index_cnt = (u64)-1;
 	ei->dir_index = 0;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0ba0e4ddaf6b..ff335c192170 100644
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
index a0fc3a1390ab..3ef166a3485a 100644
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

