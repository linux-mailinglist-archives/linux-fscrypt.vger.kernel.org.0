Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89EA64D280
	for <lists+linux-fscrypt@lfdr.de>; Wed, 14 Dec 2022 23:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiLNWpr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Dec 2022 17:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiLNWpo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Dec 2022 17:45:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E60101E0;
        Wed, 14 Dec 2022 14:45:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0402B61C3A;
        Wed, 14 Dec 2022 22:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39162C433F2;
        Wed, 14 Dec 2022 22:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671057942;
        bh=wLd4hn46pl37ZdIHOsePkBTX5A4fW4nKrCWTow70H1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLzKHO/8H4DFa5Jdzylc7uSkoLeqo1P+7IkcEYelSvjKXJBSZCSw/dsiP2P4J6bru
         HJP+7eqBV3gjGjbKzQLbmH62xf3fKBic7MZ7SVt6gTwguX8OJLR42U13/8iZGiGmLT
         ftD8P/TNUJiYbOtFwwDmCGyELujl1rqHsakigMHzwm150wwK3p1atVuK7md8QKM+mU
         twO1HnAEk16YmYYAEn2Z0RR68mla+mCi7grgmc+UkLJZt7SoEaUJoJwd+LNQQj6bQQ
         00pECfnYN4UIHopU8jR4EAuCO0Y0SCBYU6lyJL7+ulx7qrpW/Syjh0uueGRx85E3PJ
         HrPI2wTur2dcw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] fsverity: pass pos and size to ->write_merkle_tree_block
Date:   Wed, 14 Dec 2022 14:43:04 -0800
Message-Id: <20221214224304.145712-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221214224304.145712-1-ebiggers@kernel.org>
References: <20221214224304.145712-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,SUSPICIOUS_RECIPS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fsverity_operations::write_merkle_tree_block is passed the index of the
block to write and the log base 2 of the block size.  However, all
implementations of it use these parameters only to calculate the
position and the size of the block, in bytes.

Therefore, make ->write_merkle_tree_block take 'pos' and 'size'
parameters instead of 'index' and 'log_blocksize'.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/btrfs/verity.c        | 19 +++++++------------
 fs/ext4/verity.c         |  6 +++---
 fs/f2fs/verity.c         |  6 +++---
 fs/verity/enable.c       |  4 ++--
 include/linux/fsverity.h |  8 ++++----
 5 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index bf9eb693a6a7..c5ff16f9e9fa 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -783,30 +783,25 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 /*
  * fsverity op that writes a Merkle tree block into the btree.
  *
- * @inode:          inode to write a Merkle tree block for
- * @buf:            Merkle tree data block to write
- * @index:          index of the block in the Merkle tree
- * @log_blocksize:  log base 2 of the Merkle tree block size
- *
- * Note that the block size could be different from the page size, so it is not
- * safe to assume that index is a page index.
+ * @inode:	inode to write a Merkle tree block for
+ * @buf:	Merkle tree block to write
+ * @pos:	the position of the block in the Merkle tree (in bytes)
+ * @size:	the Merkle tree block size (in bytes)
  *
  * Returns 0 on success or negative error code on failure
  */
 static int btrfs_write_merkle_tree_block(struct inode *inode, const void *buf,
-					u64 index, int log_blocksize)
+					 u64 pos, unsigned int size)
 {
-	u64 off = index << log_blocksize;
-	u64 len = 1ULL << log_blocksize;
 	loff_t merkle_pos = merkle_file_pos(inode);
 
 	if (merkle_pos < 0)
 		return merkle_pos;
-	if (merkle_pos > inode->i_sb->s_maxbytes - off - len)
+	if (merkle_pos > inode->i_sb->s_maxbytes - pos - size)
 		return -EFBIG;
 
 	return write_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY,
-			       off, buf, len);
+			       pos, buf, size);
 }
 
 const struct fsverity_operations btrfs_verityops = {
diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 30e3b65798b5..e4da1704438e 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -381,11 +381,11 @@ static struct page *ext4_read_merkle_tree_page(struct inode *inode,
 }
 
 static int ext4_write_merkle_tree_block(struct inode *inode, const void *buf,
-					u64 index, int log_blocksize)
+					u64 pos, unsigned int size)
 {
-	loff_t pos = ext4_verity_metadata_pos(inode) + (index << log_blocksize);
+	pos += ext4_verity_metadata_pos(inode);
 
-	return pagecache_write(inode, buf, 1 << log_blocksize, pos);
+	return pagecache_write(inode, buf, size, pos);
 }
 
 const struct fsverity_operations ext4_verityops = {
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index c352fff88a5e..f320ed8172ec 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -276,11 +276,11 @@ static struct page *f2fs_read_merkle_tree_page(struct inode *inode,
 }
 
 static int f2fs_write_merkle_tree_block(struct inode *inode, const void *buf,
-					u64 index, int log_blocksize)
+					u64 pos, unsigned int size)
 {
-	loff_t pos = f2fs_verity_metadata_pos(inode) + (index << log_blocksize);
+	pos += f2fs_verity_metadata_pos(inode);
 
-	return pagecache_write(inode, buf, 1 << log_blocksize, pos);
+	return pagecache_write(inode, buf, size, pos);
 }
 
 const struct fsverity_operations f2fs_verityops = {
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index df6b499bf6a1..a949ce817202 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -120,8 +120,8 @@ static int build_merkle_tree_level(struct file *filp, unsigned int level,
 			       params->block_size - pending_size);
 			err = vops->write_merkle_tree_block(inode,
 					pending_hashes,
-					dst_block_num,
-					params->log_blocksize);
+					dst_block_num << params->log_blocksize,
+					params->block_size);
 			if (err) {
 				fsverity_err(inode,
 					     "Error %d writing Merkle tree block %llu",
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 203f4962c54a..f5ed7ecfd9ab 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -109,9 +109,9 @@ struct fsverity_operations {
 	 * Write a Merkle tree block to the given inode.
 	 *
 	 * @inode: the inode for which the Merkle tree is being built
-	 * @buf: block to write
-	 * @index: 0-based index of the block within the Merkle tree
-	 * @log_blocksize: log base 2 of the Merkle tree block size
+	 * @buf: the Merkle tree block to write
+	 * @pos: the position of the block in the Merkle tree (in bytes)
+	 * @size: the Merkle tree block size (in bytes)
 	 *
 	 * This is only called between ->begin_enable_verity() and
 	 * ->end_enable_verity().
@@ -119,7 +119,7 @@ struct fsverity_operations {
 	 * Return: 0 on success, -errno on failure
 	 */
 	int (*write_merkle_tree_block)(struct inode *inode, const void *buf,
-				       u64 index, int log_blocksize);
+				       u64 pos, unsigned int size);
 };
 
 #ifdef CONFIG_FS_VERITY
-- 
2.38.1

