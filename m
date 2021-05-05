Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E6D3748A4
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 May 2021 21:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhEETVw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 5 May 2021 15:21:52 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57183 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234247AbhEETVt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 5 May 2021 15:21:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D37285C0129;
        Wed,  5 May 2021 15:20:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 05 May 2021 15:20:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=82mRpWlF6ngrJB4Vkx//tRpSfl
        ycsilwNAuK/EhW7Z4=; b=rgCUWQrJkvEuoexHBOcvij5EYujbfz5oMvOIkZMGXU
        fdLpZU1DuWuBmX0CbDGSSJ7bMPe54sL9X4M2p1BJwhHDvCcotaFzR0kZl2t3PMoE
        ptJj6uBCUA8An6It3yqPRMynNBrNKwQDUb+RQD1h6cg0TlaDl2N+DcKX6msX6WhM
        vSKrkxVVAUCwxrxjsSRBkJl5DIgRVwHB3mvnUJV8kBhZC/f5AG3l81l8tgRIgiqU
        vXTU/7ZEEFFRv2IC6etaGcJ5ZBuAYPlpuqGtz+U+bGz81/qubvQQjWKhavT/WVYI
        93dCmevUP+Ryo21aUvRXCe2+QawGkRLezGFWx21i9Jng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=82mRpWlF6ngrJB4Vkx//tRpSflycsilwNAuK/EhW7Z4=; b=QfKpAINT
        dy3VMlGL4h3saEvsL+VifML4FcakFRzuzxEymDAD3YXj7xkRQcpmH4o6ClpJXGRY
        he0tlmMoWYbx0i4gWIVeVfiPnx+hDoZAd5iv1+sbTq4eRS7pK0OC00iAYNOYkbVs
        JlmTLJr71k6mHoLDA1xxOo8jfYoamhr7ehXRdl28ZJuBqrC3X0cZcfNNbkGO0gao
        /wDKqKekDhcBQtCf65dTUDRl0iJ0Cn7Oze12+vdozq0wwGy8an9JyD3GxqRyAGZ3
        zDtXB/cxj+7on70XCOvtqlc3EM+OCuNLyEo3SH/++37h8jyBbOOK0LFuH0WIl54u
        AjldzelseFkEEQ==
X-ME-Sender: <xms:FPCSYHExHyzoF41P6SswShq7biYExxOLzbdNd5occskx2FQrmaw0SA>
    <xme:FPCSYEWv1anhbBnOqk3-0bVGHKCHtdFjmivK163Zo7XS3mv0VtgK2xl679c2SGazf
    rPZ62wHLR4pIPwHddo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefkedgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:FPCSYJL2b6y95J_xSouBwNT5N7iL4KB6Wq6OZboFeQEvjxpUo8m_fA>
    <xmx:FPCSYFGUrjJtODMI4Xj1LKzQMO9CgClm8txFvCG8MvC9vTBbn4YWcg>
    <xmx:FPCSYNWwhaJgPoG7okxPtRnmxtWq7QDs7nl1YMeekSHQDn7t4U32Hg>
    <xmx:FPCSYOeT-j0dAdT3QpjgphHBc94Rzu_6aLlXg08HDEj7KPKTlLAb3g>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 15:20:52 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v4 5/5] btrfs: verity metadata orphan items
Date:   Wed,  5 May 2021 12:20:43 -0700
Message-Id: <8e7e0d3dd84f729d86e7f1a466fe8828f0e7ba58.1620241221.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620241221.git.boris@bur.io>
References: <cover.1620241221.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

If we don't finish creating fsverity metadata for a file, or fail to
clean up already created metadata after a failure, we could leak the
verity items.

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
signal orphaned metadata that isn't the inode itself. This makes the
comment discussing deprecating that concept a bit messy in full context.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/inode.c  | 15 +++++++--
 fs/btrfs/verity.c | 79 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 87 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1b1101369777..67eba8db4b65 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3419,7 +3419,9 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 
 		/*
 		 * If we have an inode with links, there are a couple of
-		 * possibilities. Old kernels (before v3.12) used to create an
+		 * possibilities:
+		 *
+		 * 1. Old kernels (before v3.12) used to create an
 		 * orphan item for truncate indicating that there were possibly
 		 * extent items past i_size that needed to be deleted. In v3.12,
 		 * truncate was changed to update i_size in sync with the extent
@@ -3432,13 +3434,22 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 * slim, and it's a pain to do the truncate now, so just delete
 		 * the orphan item.
 		 *
+		 * 2. We were halfway through creating fsverity metadata for the
+		 * file. In that case, the orphan item represents incomplete
+		 * fsverity metadata which must be cleaned up with
+		 * btrfs_drop_verity_items.
+		 *
 		 * It's also possible that this orphan item was supposed to be
 		 * deleted but wasn't. The inode number may have been reused,
 		 * but either way, we can delete the orphan item.
 		 */
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
index feaf5908b3d3..3a115cdca018 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -362,6 +362,64 @@ static ssize_t read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset
 	return ret;
 }
 
+/*
+ * Helper to manage the transaction for adding an orphan item.
+ */
+static int add_orphan(struct btrfs_inode *inode)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = inode->root;
+	int ret = 0;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+	ret = btrfs_orphan_add(trans, inode);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		goto out;
+	}
+	btrfs_end_transaction(trans);
+
+out:
+	return ret;
+}
+
+/*
+ * Helper to manage the transaction for deleting an orphan item.
+ */
+static int del_orphan(struct btrfs_inode *inode)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = inode->root;
+	int ret;
+
+	/*
+	 * If the inode has no links, it is either already unlinked, or was
+	 * created with O_TMPFILE. In either case, it should have an orphan from
+	 * that other operation. Rather than reference count the orphans, we
+	 * simply ignore them here, because we only invoke the verity path in
+	 * the orphan logic when i_nlink is 0.
+	 */
+	if (!inode->vfs_inode.i_nlink)
+		return 0;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
+
+	btrfs_end_transaction(trans);
+	return ret;
+}
+
 /*
  * Drop verity items from the btree and from the page cache
  *
@@ -399,11 +457,12 @@ static int btrfs_begin_enable_verity(struct file *filp)
 		return -EBUSY;
 
 	set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &BTRFS_I(inode)->runtime_flags);
-	ret = drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY);
+
+	ret = btrfs_drop_verity_items(BTRFS_I(inode));
 	if (ret)
 		goto err;
 
-	ret = drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY);
+	ret = add_orphan(BTRFS_I(inode));
 	if (ret)
 		goto err;
 
@@ -430,6 +489,7 @@ static int btrfs_end_enable_verity(struct file *filp, const void *desc,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_verity_descriptor_item item;
 	int ret;
+	int keep_orphan = 0;
 
 	if (desc != NULL) {
 		/* write out the descriptor item */
@@ -461,11 +521,20 @@ static int btrfs_end_enable_verity(struct file *filp, const void *desc,
 
 out:
 	if (desc == NULL || ret) {
-		/* If we failed, drop all the verity items */
-		drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY);
-		drop_verity_items(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY);
+		/*
+		 * If verity failed (here or in the generic code), drop all the
+		 * verity items.
+		 */
+		keep_orphan = btrfs_drop_verity_items(BTRFS_I(inode));
 	} else
 		btrfs_set_fs_compat_ro(root->fs_info, VERITY);
+	/*
+	 * If we are handling an error, but failed to drop the verity items,
+	 * we still need the orphan.
+	 */
+	if (!keep_orphan)
+		del_orphan(BTRFS_I(inode));
+
 	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &BTRFS_I(inode)->runtime_flags);
 	return ret;
 }
-- 
2.30.2

