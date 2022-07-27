Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD185835C2
	for <lists+linux-fscrypt@lfdr.de>; Thu, 28 Jul 2022 01:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiG0XqR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 27 Jul 2022 19:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiG0XqQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 27 Jul 2022 19:46:16 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD6C48E94;
        Wed, 27 Jul 2022 16:46:15 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 6B5025C0098;
        Wed, 27 Jul 2022 19:46:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 27 Jul 2022 19:46:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1658965572; x=1659051972; bh=E2KmLPh5VsaNmVK38POPruH4a
        tZe920lxQgOxA8Z/Rk=; b=aGsj6O37nTtG9QwCx6Dt2FkK6pNve131KfU1QSuwM
        vUCNZSG/sQFkbgoVh/0ZHCxNx8kAjY/tMixj1VQjn1N/CDwmNu39XJVtjNoAmpLN
        yFQG808RGhngxRGBExAFvusA5flEOylGMcmuoEvp/dcEKvQhf5aQT58bK7OJ9bJ6
        Y3Q/hUOhC1AFWo/IigrKgzqVq3m//pbx8jXCau5EOCAYuxMW/julOg0EJlBxdvDh
        LiyNVfZEduPRshhrIXgLGqEa8JZMGEW/4tBBauNYvlQUBIMohJJFq9PrhfFLVFw/
        EDjoORDWheDk62N8aoAN58l3ISfTdWqZaOEbi8c3uko2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1658965572; x=1659051972; bh=E2KmLPh5VsaNmVK38POPruH4atZe920lxQg
        OxA8Z/Rk=; b=prylvspjSAfmKHqB1jEh+iB7FWWGSV2CT0w9cMexWn6SXUarYkd
        iynWFQj6Hy1jMLOeQ698mDrB/Z4JrQGIkTHSRshldgqqvAtRIj5qiRhfImy4fSOb
        hkUWtiBn4z8KFoCRiBk9MObksMzDUrxGeFXqRuTAad00X1UuVsQQXdPGtlrMbMZG
        Kh6hO4jehC8k1uPaDQZpab7wP3jN4VsuY1bMyliz3hhIsqjhdZlwc9G/L87FVyVC
        D6VYeNrEfa4ugyulFvLuf178t2w3NZTu+13TKszfSaZH0dBUsvomcMN3PymzDLzb
        GPVVV7ohbvlOXRxxmHNA/xJo/HFg+KVSNwQ==
X-ME-Sender: <xms:RM7hYiRZ3vpp8MLDaGQSJfF8Tuc5tFN9qeOo_9Vsxb-ZkOKd6gQPjA>
    <xme:RM7hYnxo6EF0FEn5uAWz-hCaukhYYWbHLudA0eC6mEXSgcpJdQNUR7_5Tr2a4nsfB
    74IM42qiniRrIIl6GI>
X-ME-Received: <xmr:RM7hYv08hK_un4xteE1H52lEErhS_XSO5v-Ral76LQ-IkGGnxNWrhW8h5Fs-jKrQp9OMSvszFlWtcXnl2aRl1_xP-mdqHQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddufedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeduiedtleeuieejfeelffevleeifefgjeejieegkeduud
    etfeekffeftefhvdejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:RM7hYuCxOG52AlTUp_L1KzOAIzACoWiKvdkRZle-oC8q9Civ-di2GA>
    <xmx:RM7hYrjAtlQRJ1C1DUm-hScqn2-vQd--moocGHKjpHvwnxXTj49Nnw>
    <xmx:RM7hYqr6e_31VcqxA5Ryv6XCVpgioZQIlARUwCtOyGqlf_vbeuBHJw>
    <xmx:RM7hYjYZgFzBeyQ1AQO9Kck0-o6aTzRL2rwwNip9bqPtskcnrCzbRg>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Jul 2022 19:46:11 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH] btrfs: send: add support for fs-verity
Date:   Wed, 27 Jul 2022 16:46:22 -0700
Message-Id: <c2bcafee08a157d5638ad84fb9cfc692dce9bb86.1658965398.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Preserve the fs-verity status of a btrfs file across send/recv.

There is no facility for installing the Merkle tree contents directly on
the receiving filesystem, so we package up the parameters used to enable
verity found in the verity descriptor. This gives the receive side
enough information to properly enable verity again. Note that this means
that receive will have to re-compute the whole Merkle tree, similar to
how compression worked before encoded_write.

Since the file becomes read-only after verity is enabled, it is
important that verity is added to the send stream after any file writes.
Therefore, when we process a verity item, merely note that it happened,
then actually create the command in the send stream during
'finish_inode_if_needed'.

This also creates V3 of the send stream format, without any format
changes besides adding the new commands and attributes.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/send.c              | 97 ++++++++++++++++++++++++++++++++++++
 fs/btrfs/send.h              | 15 ++++--
 fs/verity/fsverity_private.h |  2 -
 include/linux/fsverity.h     |  3 ++
 4 files changed, 112 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e7671afcee4f..0ce243ea9c6d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -15,6 +15,7 @@
 #include <linux/string.h>
 #include <linux/compat.h>
 #include <linux/crc32c.h>
+#include <linux/fsverity.h>
 
 #include "send.h"
 #include "ctree.h"
@@ -127,6 +128,7 @@ struct send_ctx {
 	bool cur_inode_new_gen;
 	bool cur_inode_deleted;
 	bool ignore_cur_inode;
+	bool cur_inode_needs_verity;
 
 	u64 send_progress;
 
@@ -624,6 +626,7 @@ static int tlv_put(struct send_ctx *sctx, u16 attr, const void *data, int len)
 		return tlv_put(sctx, attr, &__tmp, sizeof(__tmp));	\
 	}
 
+TLV_PUT_DEFINE_INT(8)
 TLV_PUT_DEFINE_INT(32)
 TLV_PUT_DEFINE_INT(64)
 
@@ -4886,6 +4889,80 @@ static int process_all_new_xattrs(struct send_ctx *sctx)
 	return ret;
 }
 
+static int send_verity(struct send_ctx *sctx, struct fs_path *path,
+		       struct fsverity_descriptor *desc)
+{
+	int ret;
+
+	ret = begin_cmd(sctx, BTRFS_SEND_C_ENABLE_VERITY);
+	if (ret < 0)
+		goto out;
+
+	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, path);
+	TLV_PUT_U8(sctx, BTRFS_SEND_A_VERITY_ALGORITHM, desc->hash_algorithm);
+	TLV_PUT_U32(sctx, BTRFS_SEND_A_VERITY_BLOCK_SIZE, 1 << desc->log_blocksize);
+	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SALT_DATA, desc->salt, desc->salt_size);
+	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SIG_DATA, desc->signature, desc->sig_size);
+
+	ret = send_cmd(sctx);
+
+tlv_put_failure:
+out:
+	return ret;
+}
+
+static int process_new_verity(struct send_ctx *sctx)
+{
+	int ret = 0;
+	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
+	struct inode *inode;
+	struct fsverity_descriptor *desc;
+	struct fs_path *p;
+
+	inode = btrfs_iget(fs_info->sb, sctx->cur_ino, sctx->send_root);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	ret = fs_info->sb->s_vop->get_verity_descriptor(inode, NULL, 0);
+	if (ret < 0)
+		goto iput;
+
+	if (ret > FS_VERITY_MAX_DESCRIPTOR_SIZE) {
+		ret = -EMSGSIZE;
+		goto iput;
+	}
+	desc = kmalloc(ret, GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto iput;
+	}
+
+	ret = fs_info->sb->s_vop->get_verity_descriptor(inode, desc, ret);
+	if (ret < 0)
+		goto free_desc;
+
+	p = fs_path_alloc();
+	if (!p) {
+		ret = -ENOMEM;
+		goto free_desc;
+	}
+	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
+	if (ret < 0)
+		goto free_path;
+
+	ret = send_verity(sctx, p, desc);
+	if (ret < 0)
+		goto free_path;
+
+free_path:
+	fs_path_free(p);
+free_desc:
+	kfree(desc);
+iput:
+	iput(inode);
+	return ret;
+}
+
 static inline u64 max_send_read_size(const struct send_ctx *sctx)
 {
 	return sctx->send_max_size - SZ_16K;
@@ -6377,6 +6454,11 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
 		if (ret < 0)
 			goto out;
 	}
+	if (sctx->cur_inode_needs_verity) {
+		ret = process_new_verity(sctx);
+		if (ret < 0)
+			goto out;
+	}
 
 	ret = send_capabilities(sctx);
 	if (ret < 0)
@@ -6785,6 +6867,18 @@ static int changed_extent(struct send_ctx *sctx,
 	return ret;
 }
 
+static int changed_verity(struct send_ctx *sctx,
+			  enum btrfs_compare_tree_result result)
+{
+	int ret = 0;
+
+	if (!sctx->cur_inode_new_gen && !sctx->cur_inode_deleted) {
+		if (result == BTRFS_COMPARE_TREE_NEW)
+			sctx->cur_inode_needs_verity = true;
+	}
+	return ret;
+}
+
 static int dir_changed(struct send_ctx *sctx, u64 dir)
 {
 	u64 orig_gen, new_gen;
@@ -6939,6 +7033,9 @@ static int changed_cb(struct btrfs_path *left_path,
 			ret = changed_xattr(sctx, result);
 		else if (key->type == BTRFS_EXTENT_DATA_KEY)
 			ret = changed_extent(sctx, result);
+		else if (key->type == BTRFS_VERITY_DESC_ITEM_KEY &&
+			 key->offset == 0)
+			ret = changed_verity(sctx, result);
 	}
 
 out:
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 4bb4e6a638cb..0a4537775e0c 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -92,8 +92,11 @@ enum btrfs_send_cmd {
 	BTRFS_SEND_C_ENCODED_WRITE	= 25,
 	BTRFS_SEND_C_MAX_V2		= 25,
 
+	/* Version 3 */
+	BTRFS_SEND_C_ENABLE_VERITY	= 26,
+	BTRFS_SEND_C_MAX_V3		= 26,
 	/* End */
-	BTRFS_SEND_C_MAX		= 25,
+	BTRFS_SEND_C_MAX		= 26,
 };
 
 /* attributes in send stream */
@@ -160,8 +163,14 @@ enum {
 	BTRFS_SEND_A_ENCRYPTION		= 31,
 	BTRFS_SEND_A_MAX_V2		= 31,
 
-	/* End */
-	BTRFS_SEND_A_MAX		= 31,
+	/* Version 3 */
+	BTRFS_SEND_A_VERITY_ALGORITHM	= 32,
+	BTRFS_SEND_A_VERITY_BLOCK_SIZE	= 33,
+	BTRFS_SEND_A_VERITY_SALT_DATA	= 34,
+	BTRFS_SEND_A_VERITY_SIG_DATA	= 35,
+	BTRFS_SEND_A_MAX_V3		= 35,
+
+	__BTRFS_SEND_A_MAX		= 35,
 };
 
 long btrfs_ioctl_send(struct inode *inode, struct btrfs_ioctl_send_args *arg);
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index 629785c95007..dbe1ce5b450a 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -70,8 +70,6 @@ struct fsverity_info {
 	const struct inode *inode;
 };
 
-/* Arbitrary limit to bound the kmalloc() size.  Can be changed. */
-#define FS_VERITY_MAX_DESCRIPTOR_SIZE	16384
 
 #define FS_VERITY_MAX_SIGNATURE_SIZE	(FS_VERITY_MAX_DESCRIPTOR_SIZE - \
 					 sizeof(struct fsverity_descriptor))
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 7af030fa3c36..40f14e5fed9d 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -22,6 +22,9 @@
  */
 #define FS_VERITY_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
 
+/* Arbitrary limit to bound the kmalloc() size.  Can be changed. */
+#define FS_VERITY_MAX_DESCRIPTOR_SIZE	16384
+
 /* Verity operations for filesystems */
 struct fsverity_operations {
 
-- 
2.37.0

