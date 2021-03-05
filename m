Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E3832F3DA
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Mar 2021 20:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhCET1U (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 Mar 2021 14:27:20 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:39867 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230051AbhCET0x (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 Mar 2021 14:26:53 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 35D712A95;
        Fri,  5 Mar 2021 14:26:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 05 Mar 2021 14:26:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=6TlOBcObA+yxIcrdhnc569zFPd
        xyS16skYzNGj1Wb3Q=; b=fzdJHWAKCnWf+yBoMIQbwlZEPbQhmoAIEcpAcCLil7
        TPrjMVQUy36Q6JI7+GhffZ+Gabi/aEYlWLcWHKngQrZmkKmndqiknjwuhHF+TTkA
        ny7KufikV6BCXYJ5/h3otscFM6G9EXuPPgh03xMAaIk34EBLe+72TfYb9VN/CdWt
        XJxo+G1DZevsraitKjkEcHplLtkkUucxPua5mFR5NuSisV+wklI54rEELVu7o6Rj
        QUjIM3js3CykX0xc6Y3EUiQpyDijaLsg041W5r9mAoIr7XF72ax42mNBGegZjME9
        +QpSREzEyny7JHFdNTC/7sclK+2jWz94+mmYUjrUN1BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=6TlOBcObA+yxIcrdhnc569zFPdxyS16skYzNGj1Wb3Q=; b=dzhVPauR
        XYl4r1k+x63scRAtcp+p0PziThg8v1IWZ0l3OSP3wZtuFZ+v1+X+k4IGPzTbOMJ+
        JWhaIeZCYU+EIBAqYq/TUwjn7kpQ9EBZS4Ff3pZPnN3CrQqpLUSsC40zoLIA3eTH
        Ux9+QpxJvrRAbsrrsGEqI8yqFuaks8j8LeK4aYlhihU/r1ZCM70DbG2bwWfTk9p8
        HOA2cGA2rj+x3eyfS8ABCC/Ja+yJDths4HOToB9vISawzhuDFuTiRktINdplJUyv
        KitjwWs+ajqPJmMvC/fVJjz4G7HJIazap3Ph99Z625gKtVKdZKKRwvw4JokHyOuf
        xa6CqF13CjmUPQ==
X-ME-Sender: <xms:_IVCYIWSk_giwHYiCzdo3C36DN9sz5XlP7EXS1FSIWg-AqFOIZRiwA>
    <xme:_IVCYMn8Ch3G7hafswTze1TvRjqiEO5mM9hwnYk7RpTbqqfzxI-qcjdm2uc0JlAx-
    3ysDuzuaZZLGgQJ5tU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtiedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    eiueffuedvieeujefhheeigfekvedujeejjeffvedvhedtudefiefhkeegueehleenucfk
    phepudeifedruddugedrudefvddrheenucevlhhushhtvghrufhiiigvpeegnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:_IVCYMaPdoskbd36r3ytSGvghtxY2m7LdTfh2GhT0nnkjDOY7HSBNQ>
    <xmx:_IVCYHWHEmrxKcbufV-CWzb8Sk85nFwNp6tPW8B76SB3JH8DRHQppQ>
    <xmx:_IVCYCmPtmGG9wrIwJ2nO_9hxOqQ7oJfq1Xkyqx2pX03fbLa8bHBew>
    <xmx:_IVCYGssxYgzNYuyk-qvIEpHD12-5Bt1CisqMpwVYDRlDvzVGdUHMg>
Received: from localhost (unknown [163.114.132.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8676E240054;
        Fri,  5 Mar 2021 14:26:51 -0500 (EST)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org,
        'Eric Biggers ' <ebiggers@kernel.org>
Subject: [PATCH v2 5/5] btrfs: verity metadata orphan items
Date:   Fri,  5 Mar 2021 11:26:33 -0800
Message-Id: <8c3aaea8cde506ff5d75a7dcc77263213a3659e6.1614971203.git.boris@bur.io>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1614971203.git.boris@bur.io>
References: <cover.1614971203.git.boris@bur.io>
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

One thing to note is that this is a resurrection of using orphans to
signal orphaned metadata that isn't the inode itself. This makes the
comment discussing deprecating that concept a bit messy in full context.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/inode.c  | 15 +++++++--
 fs/btrfs/verity.c | 80 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 83 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9291f6633bc6..7c00863ba8a3 100644
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
index 648bda5a3716..b677288db411 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -350,6 +350,60 @@ static ssize_t read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset
 	return ret;
 }
 
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
+static int del_orphan(struct btrfs_inode *inode)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = inode->root;
+	int ret;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
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
+int btrfs_drop_verity_items(struct btrfs_inode *inode)
+{
+	int ret;
+
+	ret = drop_verity_items(inode, BTRFS_VERITY_DESC_ITEM_KEY);
+	if (ret)
+		return ret;
+
+	return drop_verity_items(inode, BTRFS_VERITY_MERKLE_ITEM_KEY);
+}
+
 /*
  * fsverity op that begins enabling verity.
  * fsverity calls this to ask us to setup the inode for enabling.  We
@@ -363,17 +417,13 @@ static int btrfs_begin_enable_verity(struct file *filp)
 	if (test_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &BTRFS_I(inode)->runtime_flags))
 		return -EBUSY;
 
-	/*
-	 * ext4 adds the inode to the orphan list here, presumably because the
-	 * truncate done at orphan processing time will delete partial
-	 * measurements.  TODO: setup orphans
-	 */
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
 
@@ -400,6 +450,7 @@ static int btrfs_end_enable_verity(struct file *filp, const void *desc,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_verity_descriptor_item item;
 	int ret;
+	int keep_orphan = 0;
 
 	if (desc != NULL) {
 		/* write out the descriptor item */
@@ -431,11 +482,20 @@ static int btrfs_end_enable_verity(struct file *filp, const void *desc,
 
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
2.24.1

