Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A01358CBB
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhDHSeR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:34:17 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:39331 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232840AbhDHSeR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:34:17 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 2EBFE10BE;
        Thu,  8 Apr 2021 14:34:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 08 Apr 2021 14:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=PGrpzEHlWjPm+65NrdMCAJ+Dtg
        WEAB65TQyzfNCKOtI=; b=N0ZMeZHKVgUjcho3744mVgFjPCp9rHm5AfOsQsMmdX
        +aSraPJpxReiMErT1wJ6tAny5+28zs8muVYSV0StAi5xpOkTTjIQSGj3VQtJfs9d
        Jw709cbncS0AcB1wj5sJvAuOKfl3eJkoYrVTc+zZvzDrMAQrV/p3ovm8613UFwQh
        fM21mgdxVWRa9ZLwBLYc/R+Ne0Nyi4HE5Ryc7D00AEbEGAou7YPv351aD27t9Ezw
        j6Mckl0RcU/keQrFBI6K6kD1vn6EM+feDNqPE29uC8CcxKrRztilY0ZCvBPRjCDZ
        n8ftcyLdOHmIirtYClScytVWGM/2yWIn3eErcnkdVnNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=PGrpzEHlWjPm+65NrdMCAJ+DtgWEAB65TQyzfNCKOtI=; b=C7sShPG4
        WJr/KyqCQ24jCiQVV0bgzsMY8tleL8bhbbAWMrGA+YCaO0RNxJLObrGPoBw60aoC
        piAfWFh6k/f4kho8fSRFUeqfyFKuC5v7jxLOk6Ga/4HFYfVBU6i43YNmBAD7isGB
        Ll9un8eU4c9gL6sA4cJ7/1WtQvW8OSqsyQREHJ4y5b7z2U9bOdxPNV8mHp6kEH2m
        +v4+ja/JbsiI0oa2Lv3ZvJ5lzFm2Ha+YAEOQlC9HnRd7IB+ARalImW/goXaVthUv
        SK5GtMRKGWEiAmu1SM+CSOWi0XyBdgJR4csI/Tp0NkP76OiRt0Iq8Xs3gyd/UyiP
        ojFdxBVEbbGoDQ==
X-ME-Sender: <xms:nExvYOqXG_YAwRuHz1HZRvelkmHIZvfnngxOW0O55tH5IDrLwzwkfg>
    <xme:nExvYKf4E2W7twDpl0CNR4GmCM8dIESOctd2xihgjLFiqBV8Wr9OmltwbXTjL-zcD
    sJsRSycQEx7iPNKlno>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:nExvYNoeHLSNKjeBbpV4b29CDCzVyXG8ip2Tbzfk1Iu6pmkz8iCv2w>
    <xmx:nExvYLFMP7_lStXSTpmtu_4d2CuJ5Uv9pdcc3ZJP6hJ9JzDjQuNgEA>
    <xmx:nExvYNvA8QWB0pBtMGdQNCgcpDOQNm_eF02e0oonouGZ4rbbUZvU-A>
    <xmx:nExvYF3P_ug_9o3D6_LEh3NiVUw5lQKqcBopzFjWytlnabOxZ0-16A>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id 70E961080064;
        Thu,  8 Apr 2021 14:34:04 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 5/5] btrfs: verity metadata orphan items
Date:   Thu,  8 Apr 2021 11:33:56 -0700
Message-Id: <73930fec9b9485787196cf06b370a3921c190f9d.1617900170.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617900170.git.boris@bur.io>
References: <cover.1617900170.git.boris@bur.io>
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
 fs/btrfs/inode.c  | 15 ++++++--
 fs/btrfs/verity.c | 89 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 92 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 887e1ca2ed66..939893cb039d 100644
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
index 0cc9bdd876e2..b96f7d9698a8 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -378,6 +378,69 @@ static ssize_t read_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset
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
+int btrfs_drop_verity_items(struct btrfs_inode *inode)
+{
+	int ret;
+	struct inode *ino = &inode->vfs_inode;
+	pgoff_t index;
+
+	ret = get_verity_mapping_index(ino, 0, &index);
+	if (ret)
+		return ret;
+	truncate_inode_pages(inode->vfs_inode.i_mapping, index << PAGE_SHIFT);
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
@@ -391,17 +454,13 @@ static int btrfs_begin_enable_verity(struct file *filp)
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
 
@@ -428,6 +487,7 @@ static int btrfs_end_enable_verity(struct file *filp, const void *desc,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_verity_descriptor_item item;
 	int ret;
+	int keep_orphan = 0;
 
 	if (desc != NULL) {
 		/* write out the descriptor item */
@@ -459,11 +519,20 @@ static int btrfs_end_enable_verity(struct file *filp, const void *desc,
 
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

