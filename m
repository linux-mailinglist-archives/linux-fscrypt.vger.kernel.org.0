Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8086932F3D3
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Mar 2021 20:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhCET0r (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 Mar 2021 14:26:47 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:46403 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229837AbhCET0k (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 Mar 2021 14:26:40 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id B887F10FD;
        Fri,  5 Mar 2021 14:26:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 05 Mar 2021 14:26:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=v9oMXaF9U9jWMnvNzGDVMAVYWJ
        ZAuP5qF6ScM6hX7Ek=; b=eGiFMJxfQK41wqHtKh0LpWtqPa2r6s9zxJ0DmN26Od
        T+YVyIHrX6BdVkHkb8VV47DD8Dv1VQ7qwCgrx4XzIciFFwb3LMhJRQh8piuAaOgr
        C5lLC5Woc7xPm18pRKWthrBfi6qR/8zC3VC6wKwwwhzSsVh1ZfFNGYDiyvSI3Ftw
        ovTKVNDRrAWpXHrCIYDNC39JAsbDZwxyqn94Yjv2a8SaxU3BwfgoF1HYhWSWF9lg
        qX4STSMr2tqgIXuaYR+j2PK2ANkoJeFZCQlOK398SaBh4f7NYQakrdMg7F9AJRTW
        7+E12xTWjjAdmhE2T0Gjml7F/czv20eXQy8MsN0iRYfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=v9oMXaF9U9jWMnvNzGDVMAVYWJZAuP5qF6ScM6hX7Ek=; b=CFE1vXnJ
        m29hRQ/uF9Btjq7EnQb29cVcIX3pNe7et7JjtNdOqjI2dl2mLg9j36qTJnVoLqUA
        9orPH8/BYIHFia9OHsA5YA5kZj6VTTQ7wfmcsJ1ZY56cRd2n64WqS5gOItzctLqZ
        Z5IK71V3RI5pFDV6YY6jY6KxshTpTAQ7btopT3RcPdvs3hSUeJOGh5Xo8SjYT/ZB
        0LYBaneVc/8/LaBmYq7e4XnIf3O9vV4Ur80RPARHNo47DWjkaufVOkW/otmzfjGv
        UEJmsndq95ku41E0PIENJN1nVwdYfQ5+5B0nISM+M8zayLTpDg60iv0H9Wkh9/Er
        +r/sO+6jot3DlQ==
X-ME-Sender: <xms:74VCYErSB1Xxi-1xQ-kagKlojgaCm9dLMnoLnGM0V654mWdYaFdgCA>
    <xme:74VCYKohcYsBwA6sN6g0skichSfBkfGaykLIH-FpwBOCtLlsUUCMGhHomtCnHRuHO
    8PLC5kKbaYcsdJhOqU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtiedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    eiueffuedvieeujefhheeigfekvedujeejjeffvedvhedtudefiefhkeegueehleenucfk
    phepudeifedruddugedrudefvddrheenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:74VCYJNpgm9tM3u3VFgMoUWtHWy3zCE4lbVJN3KU75VMDTKeBK8ipg>
    <xmx:74VCYL5xyLdrc3AjvYnGcvAnEM5IrgbJmehIRR3SmZBsfGNn-u39Tg>
    <xmx:74VCYD7m9DErQGLWp2UUjN9G0pb4xt2u6RXljJnRKbxSPAr7NgKkPQ>
    <xmx:74VCYNS2SL3YAfbB-eJ7_6_mVsZDrz76dzk9amgtCKu1dgFjCBwhHw>
Received: from localhost (unknown [163.114.132.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id B30801080063;
        Fri,  5 Mar 2021 14:26:38 -0500 (EST)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org,
        'Eric Biggers ' <ebiggers@kernel.org>
Subject: [PATCH v2 1/5] btrfs: add compat_flags to btrfs_inode_item
Date:   Fri,  5 Mar 2021 11:26:29 -0800
Message-Id: <f47aa729e2c15b9e3f913c4347bf24562a631772.1614971203.git.boris@bur.io>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1614971203.git.boris@bur.io>
References: <cover.1614971203.git.boris@bur.io>
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
index 28e202e89660..8b95932f25a8 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -191,6 +191,7 @@ struct btrfs_inode {
 
 	/* flags field from the on disk inode */
 	u32 flags;
+	u64 compat_flags;
 
 	/*
 	 * Counters to keep track of the number of extent item's we may use due
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 40ec3393d2a1..e65df997a2c6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1761,6 +1761,7 @@ BTRFS_SETGET_FUNCS(inode_gid, struct btrfs_inode_item, gid, 32);
 BTRFS_SETGET_FUNCS(inode_mode, struct btrfs_inode_item, mode, 32);
 BTRFS_SETGET_FUNCS(inode_rdev, struct btrfs_inode_item, rdev, 64);
 BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
+BTRFS_SETGET_FUNCS(inode_compat_flags, struct btrfs_inode_item, compat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_generation, struct btrfs_inode_item,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_sequence, struct btrfs_inode_item,
@@ -1778,6 +1779,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_inode_gid, struct btrfs_inode_item, gid, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_mode, struct btrfs_inode_item, mode, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_rdev, struct btrfs_inode_item, rdev, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_flags, struct btrfs_inode_item, flags, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_compat_flags, struct btrfs_inode_item, compat_flags, 64);
 BTRFS_SETGET_FUNCS(timespec_sec, struct btrfs_timespec, sec, 64);
 BTRFS_SETGET_FUNCS(timespec_nsec, struct btrfs_timespec, nsec, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_timespec_sec, struct btrfs_timespec, sec, 64);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index ec0b50b8c5d6..6ea9d27b9c9d 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1733,6 +1733,7 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_inode_transid(inode_item, trans->transid);
 	btrfs_set_stack_inode_rdev(inode_item, inode->i_rdev);
 	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
+	btrfs_set_stack_inode_compat_flags(inode_item, BTRFS_I(inode)->compat_flags);
 	btrfs_set_stack_inode_block_group(inode_item, 0);
 
 	btrfs_set_stack_timespec_sec(&inode_item->atime,
@@ -1791,6 +1792,7 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 	inode->i_rdev = 0;
 	*rdev = btrfs_stack_inode_rdev(inode_item);
 	BTRFS_I(inode)->flags = btrfs_stack_inode_flags(inode_item);
+	BTRFS_I(inode)->compat_flags = btrfs_stack_inode_compat_flags(inode_item);
 
 	inode->i_atime.tv_sec = btrfs_stack_timespec_sec(&inode_item->atime);
 	inode->i_atime.tv_nsec = btrfs_stack_timespec_nsec(&inode_item->atime);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4f2f1e932751..4529e974c582 100644
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
 
@@ -8844,6 +8846,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->defrag_bytes = 0;
 	ei->disk_i_size = 0;
 	ei->flags = 0;
+	ei->compat_flags = 0;
 	ei->csum_bytes = 0;
 	ei->index_cnt = (u64)-1;
 	ei->dir_index = 0;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a8c60d46d19c..d3fb065312f5 100644
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
 
 	inode_lock(inode);
 	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
-	old_fsflags = btrfs_inode_flags_to_fsflags(binode->flags);
+	old_fsflags = btrfs_inode_flags_to_fsflags(binode);
 
 	ret = vfs_ioc_setflags_prepare(inode, old_fsflags, fsflags);
 	if (ret)
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 2f1acc9aea9e..c436b4517452 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3942,6 +3942,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
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
2.24.1

