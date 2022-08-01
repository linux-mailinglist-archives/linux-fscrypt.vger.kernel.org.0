Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF57658709B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Aug 2022 20:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbiHASys (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 1 Aug 2022 14:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiHASyq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 1 Aug 2022 14:54:46 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1121AF34;
        Mon,  1 Aug 2022 11:54:44 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 34704320082A;
        Mon,  1 Aug 2022 14:54:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 01 Aug 2022 14:54:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1659380082; x=1659466482; bh=aZGVF0zWawVqHyEWRXvBp6DjR
        Zzyz40DcaMDr4bRPek=; b=ZnLKvoWTZT+nBmEpFlnip0Z0bBAIOe2Mklxfs2Ng9
        TST86owPSv+aqBJfNCXceIAEXlvfvZEPcGso7Sm/4TEu3nTcEUi95D9rGFdEUxyw
        B9P3CYAFRTX4mQjizKL6NFBWeLvLllBd0Mrh6ox1JGPkup8YG2LdGXNd5K3rfnuN
        z2zcdb/DFmksyqDo5lsEPP3zC2N9Ww0exWIZny9uMbf+jYLqREieWHgYC7d3YfQD
        tv7ZweM9PSbBxXjvKLCuVUK2bSlZvpXf2pnxmjUzqnMdDWlHPOa53CrAQj7YpjUy
        QpN9HequJ1JYhUK5nHi/9gsAsLUYtI/BnvA74i2ZyK/Wg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1659380082; x=1659466482; bh=aZGVF0zWawVqHyEWRXvBp6DjRZzyz40DcaM
        Dr4bRPek=; b=p63GcSsOHm2o8cnULo5m0uuA+5Lck33HrB+p6EJAy/c63bzlvvM
        v+G4Ob/tT4Ph7bvrcFIXrQruLuKoQSlcA7OF/z6XaVS4g2KCuoniecFxUNI5Khsj
        WcfzEyy4DeMGigoOxJ+w980hkgyJRC4/23BfjbF98CvPCNbpjwy0F5gxe4Y9gFBk
        vOq004rr8XNyWZ2lztyzHfle4I2eM7qo5icofc6qC6W9Qhcus9Pi/GDX2Nnzeef9
        EAghJidaPaIryqgKl83jlncG5M7LpFfXJW1hzZwH3EHCyFb1r5cvOB5bMFeaVHb7
        ZjId1Q5Agg5vO3CucesvLrBSNeN3vHKOVbg==
X-ME-Sender: <xms:ciHoYpQG9uD5-0rP45R_S_tt5ErCAxbTfEjW4SKyXKqGPfI_8kGWTA>
    <xme:ciHoYizhD4NTwqkkp8ZK1E8calA-xeUspSXm_jyCqfWIxNszsSC27KpNlqP576qM5
    p_qIVbYLZq3n7SGJQY>
X-ME-Received: <xmr:ciHoYu2_AMafbWihJb5KZZJ_Ftx20tB7I0LfqiWRCon5oKUMsPw9-IdNbAtz1aHEP6grUnAnveUZ-r72iBOtdbcsCj3Ggw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddvfedgudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekud
    duteefkefffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:ciHoYhASILTmD5bPySqyz-zqfY_ggstfr-0HhwVvFVp9SUUhJsZGUw>
    <xmx:ciHoYijV5UQrqT_UnfRdAjRup3KFlyhXp3acO0cazo0rdOmVa9wDIw>
    <xmx:ciHoYlpOJIUScGHu-8TolhUuDuoSX_U3oakW9CkhPztdTewNeLfFeQ>
    <xmx:ciHoYmZPAcujko1PjJvIkjyxAgFvAmXQ3fT12GhjzSTotHd6mOBDGQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Aug 2022 14:54:42 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v3] btrfs: send: add support for fs-verity
Date:   Mon,  1 Aug 2022 11:54:40 -0700
Message-Id: <7ac3a01572a872f8779f357598215e0e07d191bd.1659379913.git.boris@bur.io>
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

--
Changes in v3:
- Fixed build failure when CONFIG_FS_VERITY was not set. This required a
  kludge to avoid a build warning as well.
Changes in v2:
- Allocate 16K with kvmalloc and keep it around till the end of send
  instead of re-allocating on each file with fs-verity.
- Use unsigned literal for bitshift.
---
 fs/btrfs/send.c              | 114 +++++++++++++++++++++++++++++++++++
 fs/btrfs/send.h              |  15 ++++-
 fs/verity/fsverity_private.h |   2 -
 include/linux/fsverity.h     |   3 +
 4 files changed, 129 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e7671afcee4f..084f19d39218 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -15,6 +15,7 @@
 #include <linux/string.h>
 #include <linux/compat.h>
 #include <linux/crc32c.h>
+#include <linux/fsverity.h>
 
 #include "send.h"
 #include "ctree.h"
@@ -127,6 +128,8 @@ struct send_ctx {
 	bool cur_inode_new_gen;
 	bool cur_inode_deleted;
 	bool ignore_cur_inode;
+	bool cur_inode_needs_verity;
+	void *verity_descriptor;
 
 	u64 send_progress;
 
@@ -624,6 +627,7 @@ static int tlv_put(struct send_ctx *sctx, u16 attr, const void *data, int len)
 		return tlv_put(sctx, attr, &__tmp, sizeof(__tmp));	\
 	}
 
+TLV_PUT_DEFINE_INT(8)
 TLV_PUT_DEFINE_INT(32)
 TLV_PUT_DEFINE_INT(64)
 
@@ -4886,6 +4890,94 @@ static int process_all_new_xattrs(struct send_ctx *sctx)
 	return ret;
 }
 
+#ifdef CONFIG_FS_VERITY
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
+	TLV_PUT_U32(sctx, BTRFS_SEND_A_VERITY_BLOCK_SIZE, 1U << desc->log_blocksize);
+	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SALT_DATA, desc->salt, desc->salt_size);
+	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SIG_DATA, desc->signature, (int)desc->sig_size);
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
+	if (!sctx->verity_descriptor) {
+		sctx->verity_descriptor = kvmalloc(FS_VERITY_MAX_DESCRIPTOR_SIZE, GFP_KERNEL);
+		if (!sctx->verity_descriptor) {
+			ret = -ENOMEM;
+			goto iput;
+		}
+	}
+
+	ret = fs_info->sb->s_vop->get_verity_descriptor(inode, sctx->verity_descriptor, ret);
+	if (ret < 0)
+		goto iput;
+
+	p = fs_path_alloc();
+	if (!p) {
+		ret = -ENOMEM;
+		goto iput;
+	}
+	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
+	if (ret < 0)
+		goto free_path;
+
+	ret = send_verity(sctx, p, sctx->verity_descriptor);
+	if (ret < 0)
+		goto free_path;
+
+free_path:
+	fs_path_free(p);
+iput:
+	iput(inode);
+	return ret;
+}
+#else
+static int process_new_verity(struct send_ctx *sctx)
+{
+	int ret = 0;
+	struct send_ctx tmp;
+
+	return -EPERM;
+	/* avoid unused TLV_PUT_U8 build warning without CONFIG_FS_VERITY */
+	TLV_PUT_U8(&tmp, 0, 0);
+tlv_put_failure:
+	return -EPERM;
+}
+#endif
+
+
 static inline u64 max_send_read_size(const struct send_ctx *sctx)
 {
 	return sctx->send_max_size - SZ_16K;
@@ -6377,6 +6469,11 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
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
@@ -6785,6 +6882,18 @@ static int changed_extent(struct send_ctx *sctx,
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
@@ -6939,6 +7048,9 @@ static int changed_cb(struct btrfs_path *left_path,
 			ret = changed_xattr(sctx, result);
 		else if (key->type == BTRFS_EXTENT_DATA_KEY)
 			ret = changed_extent(sctx, result);
+		else if (key->type == BTRFS_VERITY_DESC_ITEM_KEY &&
+			 key->offset == 0)
+			ret = changed_verity(sctx, result);
 	}
 
 out:
@@ -8036,6 +8148,8 @@ long btrfs_ioctl_send(struct inode *inode, struct btrfs_ioctl_send_args *arg)
 		kvfree(sctx->clone_roots);
 		kfree(sctx->send_buf_pages);
 		kvfree(sctx->send_buf);
+		if (sctx->verity_descriptor)
+			kvfree(sctx->verity_descriptor);
 
 		name_cache_free(sctx);
 
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

