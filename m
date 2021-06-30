Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB9D3B896F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Jun 2021 22:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhF3UEb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Jun 2021 16:04:31 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:34093 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234057AbhF3UEa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Jun 2021 16:04:30 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id D9AF1320051E;
        Wed, 30 Jun 2021 16:02:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 30 Jun 2021 16:02:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm1; bh=/sp37CDmhj37bzSoBE68W/NPLc
        zukT+dJFSBJayMYV8=; b=T1b/O5kUV/bjry/N2RESHox1GXmGLYBkz5+WVZIm9t
        mOv0WS5eXwWlisjUq6LxzRGkC/MPA/WwgeD7BSf4Hg1RcwzaHW6iFxrZqkUkKd1M
        wjji35VoUvUpA4tRGGj+DrZrfKmaHFajJHW1i16mBaOcBJYwDQNGmaOfMy9imo0b
        q6+lPOQznUkO4h7uXNU/Bh5x/SYIDGo/7kmOW29SrsQfRcb0djuGQkUx1nlQ8QT5
        Wtve9RZuOnryI7lFIiPAh3rGpx2eMyK3ZMtCwVNAh/9sj91M2Vitd0Kljv4UwhlB
        Zdfw3PXmOpNaCiCUVBZsvvxa3cpkBB6NLYaA7deNLe/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=/sp37CDmhj37bzSoBE68W/NPLczukT+dJFSBJayMYV8=; b=OTuIZ28/
        KZL4OOUS4TXxR0gSlz9kjJKMTbu8JuzicXFT14Hofb8S2YXI/cjPLq+C2brUJvDO
        B0sv/JyYpTFPrMoVSBObxYWGtQIVs4mvuPAKbMcUp1oFRwtNi/zLMYO93e5oyK2H
        R8NP6SnbOkQykPVuhnx6jP9rWv/+BgWdljoxXJzmLRr1YiP9oQ/+cF8+6anag/6h
        BHicn00XJ5yDAUh0lomBgAhtz8Y8g4UnDTbmsPKknfFby3KCTzNinpfSGCx5Xx0c
        Xqexbe6z7qw5LTnVbhGg4c5XUtmfyaRcla9l4HUrVfIK4j1fmN7ITqxGt2njl/UR
        FANwHYwxbVL9tg==
X-ME-Sender: <xms:uM3cYL2qyiCVlXIqrraWS5LMhrrdesRSxFSxublJ0uLyE8NbXSAGZA>
    <xme:uM3cYKGc4p-qgRoxqVf68kEbpT1W5cMMGw3FFpjoclAtlBaYf9TaAQy4Gce1zWvNo
    2qiyiDJL0dKjhKFv0I>
X-ME-Received: <xmr:uM3cYL6uAaYc7wu1VXapNkRArKBMJrP3kz0g3p3TqSig-oqTiLS5ymU7hg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeigedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffve
    dvhedtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:uM3cYA2HwVFrZ7RmyAyUkLFar_do_2zQMB5sfNeBXt19y4wO1Tc0cg>
    <xmx:uM3cYOHy-7B2rDTbgz8WjT2WwR33uRF5_aQfyFLaOXGL_MloCNq2ug>
    <xmx:uM3cYB8szz3QwlslAZNo4ATVJN_xGhDKZTzaGde0v_qPprdck2030A>
    <xmx:uM3cYAOHC3BKR5PARSTHA8MACSiCv93hBmn76ndas5GJHC2CE90L2Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Jun 2021 16:02:00 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v6 3/3] btrfs: verity metadata orphan items
Date:   Wed, 30 Jun 2021 13:01:50 -0700
Message-Id: <ca8fd4e1b603594972803618d24aee95b27aeeae.1625083099.git.boris@bur.io>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1625083099.git.boris@bur.io>
References: <cover.1625083099.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Writing out the verity data is too large of an operation to do in a
single transaction. If we are interrupted before we finish creating
fsverity metadata for a file, or fail to clean up already created
metadata after a failure, we could leak the verity items that we already
committed.

To address this issue, we use the orphan mechanism. When we start
enabling verity on a file, we also add an orphan item for that inode.
When we are finished, we delete the orphan. However, if we are
interrupted midway, the orphan will be present at mount and we can
cleanup the half-formed verity state.

There is a possible race with a normal unlink operation: if unlink and
verity run on the same file in parallel, it is possible for verity to
succeed and delete the still legitimate orphan added by unlink. Then, if
we are interrupted and mount in that state, we will never clean up the
inode properly. This is also possible for a file created with O_TMPFILE.
Check nlink==0 before deleting to avoid this race.

A final thing to note is that this is a resurrection of using orphans to
signal an operation besides "delete this inode". The old case was to
signal the need to do a truncate. That case still technically applies
for mounting very old file systems, so we need to take some care to not
clobber it. To that end, we just have to be careful that verity orphan
cleanup is a no-op for non-verity files.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/inode.c  | 16 +++++++--
 fs/btrfs/verity.c | 83 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 92 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9f176a840446..29d36e361a50 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3432,7 +3432,14 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 
 		/*
 		 * If we have an inode with links, there are a couple of
-		 * possibilities. Old kernels (before v3.12) used to create an
+		 * possibilities:
+		 *
+		 * 1. We were halfway through creating fsverity metadata for the
+		 * file. In that case, the orphan item represents incomplete
+		 * fsverity metadata which must be cleaned up with
+		 * btrfs_drop_verity_items and deleting the orphan item.
+
+		 * 2. Old kernels (before v3.12) used to create an
 		 * orphan item for truncate indicating that there were possibly
 		 * extent items past i_size that needed to be deleted. In v3.12,
 		 * truncate was changed to update i_size in sync with the extent
@@ -3449,9 +3456,14 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 * deleted but wasn't. The inode number may have been reused,
 		 * but either way, we can delete the orphan item.
 		 */
+
 		if (ret == -ENOENT || inode->i_nlink) {
-			if (!ret)
+			if (!ret) {
+				ret = btrfs_drop_verity_items(BTRFS_I(inode));
 				iput(inode);
+				if (ret)
+					goto out;
+			}
 			trans = btrfs_start_transaction(root, 1);
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index f24c1d88f66d..b1739186156b 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -49,6 +49,15 @@
  * So when fsverity asks for page 0 of the merkle tree, we pull up one page
  * starting at offset 0 for this key type.  These are also opaque to btrfs,
  * we're blindly storing whatever fsverity sends down.
+ *
+ * Another important consideration is the fact that the Merkle tree data scales
+ * linearly with the size of the file (with 4k pages/blocks and SHA-256, it's
+ * ~1/127th the size) so for large files, writing the tree can be a lengthy
+ * operation. For that reason, we guard the whole enable verity operation
+ * (between begin_enable_verity and end_enable_verity) with an orphan item.
+ * Again, because the data can be pretty large, it's quite possible that we
+ * could run out of space writing it, so we try our best to handle errors by
+ * stopping and rolling back rather than aborting the victim transaction.
  */
 
 
@@ -406,6 +415,40 @@ static int read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
 	return ret;
 }
 
+/*
+ * Delete an fsverity orphan
+ *
+ * @trans: transaction to do the delete in
+ * @inode: the inode to orphan
+ *
+ * This helper serves to capture verity orphan specific logic that is repeated
+ * in the couple places we delete verity orphans. Specifically, handling ENOENT
+ * and ignoring inodes with 0 links.
+ *
+ * Returns zero on success or a negative error code on failure.
+ */
+
+static int del_orphan(struct btrfs_trans_handle *trans,
+		      struct btrfs_inode *inode)
+{
+	struct btrfs_root *root = inode->root;
+	int ret;
+
+	/*
+	 * If the inode has no links, it is either already unlinked, or was
+	 * created with O_TMPFILE. In either case, it should have an orphan from
+	 * that other operation. Rather than reference count the orphans, we
+	 * simply ignore them here, because we only invoke the verity path in
+	 * the orphan logic when i_nlink is 1.
+	 */
+	if (!inode->vfs_inode.i_nlink)
+		return 0;
+
+	ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
+	if (ret == -ENOENT)
+		ret = 0;
+	return ret;
+}
 /*
  * Rollback in-progress verity if we encounter an error.
  *
@@ -436,8 +479,9 @@ static int rollback_verity(struct btrfs_inode *inode)
 	}
 	/*
 	 * 1 for updating the inode flag
+	 * 1 for deleting the orphan
 	 */
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		btrfs_handle_fs_error(root->fs_info, ret,
@@ -452,6 +496,11 @@ static int rollback_verity(struct btrfs_inode *inode)
 		btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
+	ret = del_orphan(trans, inode);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto out;
+	}
 	btrfs_end_transaction(trans);
 out:
 	return ret;
@@ -468,6 +517,7 @@ static int rollback_verity(struct btrfs_inode *inode)
  * tree:
  * - write out the descriptor items
  * - mark the inode with the verity flag
+ * - delete the orphan item
  * - mark the ro compat bit
  * - clear the in progress bit
  *
@@ -498,8 +548,9 @@ static int finish_verity(struct btrfs_inode *inode,
 
 	/*
 	 * 1 for updating the inode flag
+	 * 1 for deleting the orphan
 	 */
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out;
@@ -507,6 +558,9 @@ static int finish_verity(struct btrfs_inode *inode,
 	inode->ro_flags |= BTRFS_INODE_RO_VERITY;
 	btrfs_sync_inode_flags_to_i_flags(&inode->vfs_inode);
 	ret = btrfs_update_inode(trans, root, inode);
+	if (ret)
+		goto end_trans;
+	ret = del_orphan(trans, inode);
 	if (ret)
 		goto end_trans;
 	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
@@ -523,14 +577,16 @@ static int finish_verity(struct btrfs_inode *inode,
  *
  * @filp: the file to enable verity on
  *
- * Begin enabling fsverity for the file. We drop any existing verity items
- * and set the in progress bit.
+ * Begin enabling fsverity for the file. We drop any existing verity items, add
+ * an orphan and set the in progress bit.
  *
  * Returns 0 on success, negative error code on failure.
  */
 static int btrfs_begin_enable_verity(struct file *filp)
 {
 	struct btrfs_inode *inode = BTRFS_I(file_inode(filp));
+	struct btrfs_root *root = inode->root;
+	struct btrfs_trans_handle *trans;
 	int ret;
 
 	ASSERT(inode_is_locked(file_inode(filp)));
@@ -540,11 +596,28 @@ static int btrfs_begin_enable_verity(struct file *filp)
 		goto out;
 	}
 
+	/*
+	 * This should almost never do anything, but theoretically, it's
+	 * possible that we failed to enable verity on a file, then were
+	 * interrupted or failed while rolling back, failed to cleanup the
+	 * orphan, and finally attempt to enable verity again.
+	 */
 	ret = btrfs_drop_verity_items(inode);
 	if (ret)
 		goto out;
 
-	set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
+	/*
+	 * 1 for the orphan item
+	 */
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+	ret = btrfs_orphan_add(trans, inode);
+	if (!ret)
+		set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
+	btrfs_end_transaction(trans);
 out:
 	return ret;
 }
-- 
2.31.1

